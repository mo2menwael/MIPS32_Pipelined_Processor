// verilog_lint: waive-start unpacked-dimensions-range-ordering
// verilog_lint: waive-start always-comb
// verilog_lint: waive-start parameter-name-style
// verilog_lint: waive-start explicit-parameter-storage-type
// verilog_lint: waive-start line-length

module Branch_Predictor (
    input wire clk, rst_n,
    input wire hazard_stall,
    // For Fetch Stage
    input wire [31:0] read_address,
    output wire branch_pred_sel,
    output wire [31:0] branch_pred_target,
    // For Decode Stage
    input wire [31:0] write_address,
    input wire branch_write_enable,
    input wire jump_write_enable,
    input wire [31:0] jump_write_target,
    input wire [31:0] branch_write_target,
    input wire branch_taken,
    output wire mispred_sel,
    output wire [31:0] mispred_correct_target
);

localparam [1:0] Strongly_not_taken = 2'b00,
                 Weakly_not_taken = 2'b01,
                 Weakly_taken = 2'b10,
                 Strongly_taken = 2'b11;

wire valid;
wire [1:0] branch_next_state;
wire wr_en;
wire [5:0] read_index, write_index;
wire [23:0] read_tag, write_tag;
wire [58:0] buffer_in, buffer_out;
wire is_taken;
wire tag_match;
wire [23:0] BTB_out_tag;
wire [31:0] BTB_out_branch_target;
wire [1:0] BTB_out_branch_state;
wire BTB_out_valid;
wire [1:0] branch_state_d;
wire [31:0] write_target;


Branch_State_Reg branch_state_reg_inst (
    .clk(clk),
    .rst_n(rst_n),
    .clear(hazard_stall | ~tag_match),
    .branch_state_f(BTB_out_branch_state),
    .branch_state_d(branch_state_d)
);

Branch_Target_Buffer branch_target_buffer_inst (
    .clk(clk),
    .rst_n(rst_n),
    .buffer_in(buffer_in),
    .wr_en(wr_en),
    .write_index(write_index),
    .read_index(read_index),
    .buffer_out(buffer_out)
);

Branch_FSM branch_fsm_inst (
    .hazard_stall(hazard_stall),
    .branch_taken(branch_taken),
    .branch_state_d(branch_state_d),
    .write_target(write_target),
    .write_address(write_address),
    .branch_write_enable(branch_write_enable),
    .jump_write_enable(jump_write_enable),
    .branch_next_state(branch_next_state),
    .valid(valid),
    .mispred_correct_target(mispred_correct_target),
    .mispred_sel(mispred_sel)
);



assign wr_en = hazard_stall ? 1'd0 : (branch_write_enable | jump_write_enable);

assign read_index = hazard_stall ? 6'd0 : read_address[5:0];
assign write_index = hazard_stall ? 6'd0 : write_address[5:0];

assign read_tag = hazard_stall ? 24'd0 : read_address[29:6];
assign write_tag = hazard_stall ? 24'd0 : write_address[29:6];

assign write_target = hazard_stall ? 32'd0 : (jump_write_enable ? jump_write_target : branch_write_target);

assign buffer_in = hazard_stall ? 59'd0 : {branch_next_state, valid, write_target, write_tag};

assign is_taken = hazard_stall ? 1'd0 : ((BTB_out_branch_state == Strongly_taken) || (BTB_out_branch_state == Weakly_taken));

assign BTB_out_tag = hazard_stall ? 24'd0 : buffer_out[23:0];
assign BTB_out_branch_target = hazard_stall ? 32'd0 : buffer_out[55:24];
assign BTB_out_valid = hazard_stall ? 1'd0 : buffer_out[56];
assign BTB_out_branch_state = hazard_stall ? 2'd0 : buffer_out[58:57];

assign tag_match = hazard_stall ? 1'd0 : (read_tag == BTB_out_tag);

assign branch_pred_target = hazard_stall ? 32'd0 : BTB_out_branch_target;

assign branch_pred_sel = hazard_stall ? 1'd0 : (tag_match & BTB_out_valid & is_taken);

endmodule
