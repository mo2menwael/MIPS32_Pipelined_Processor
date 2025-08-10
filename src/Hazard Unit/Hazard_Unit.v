// verilog_lint: waive-start line-length
// verilog_lint: waive-start explicit-parameter-storage-type
// verilog_lint: waive-start parameter-name-style

module Hazard_Unit (
    input wire [4:0] rs_d,
    input wire [4:0] rt_d,
    input wire [4:0] rs_e,
    input wire [4:0] rt_e,
    input wire [4:0] write_reg_e,
    input wire [4:0] write_reg_m,
    input wire [4:0] write_reg_wb,
    input wire [2:0] branch_d,
    input wire [1:0] jump_d,
    input wire [1:0] mem_to_reg_e,
    input wire [1:0] mem_to_reg_m,
    input wire [1:0] mem_to_reg_wb,
    input wire reg_write_e,
    input wire reg_write_m,
    input wire reg_write_wb,
    input wire link_d,
    output wire stall_f,
    output wire stall_d,
    output wire [1:0] forwardA_d,
    output wire [1:0] forwardB_d,
    output wire [1:0] forwardA_e,
    output wire [1:0] forwardB_e,
    output wire flush_e,
    output wire forward_jr_f,
    output wire forward_jalr_f
);

localparam [2:0] NO_BRANCH = 3'b000, BRANCH_EQUAL = 3'b001, BRANCH_NOT_EQUAL = 3'b010,
                 BRANCH_LT_ZERO = 3'b011, BRANCH_LTE_ZERO = 3'b100, BRANCH_GT_ZERO = 3'b101,
                 BRANCH_GTE_ZERO = 3'b110;

localparam [1:0] NO_JUMP = 2'b00, JTA = 2'b01, JR = 2'b10;

localparam [1:0] ALU_OUT = 2'b00, MEM_OUT = 2'b01, HI = 2'b10, LO = 2'b11;

// Data Hazard solved by forward in Execute
wire condition1_RsE, condition2_RsE;
wire condition1_RtE, condition2_RtE;

assign condition1_RsE = (rs_e != 0) && (rs_e == write_reg_m) && reg_write_m;
assign condition2_RsE = (rs_e != 0) && (rs_e == write_reg_wb) && reg_write_wb;
assign forwardA_e = (condition1_RsE) ? 2'b10 :
                    (condition2_RsE) ? 2'b01 : 2'b00;

assign condition1_RtE = (rt_e != 0) && (rt_e == write_reg_m) && reg_write_m;
assign condition2_RtE = (rt_e != 0) && (rt_e == write_reg_wb) && reg_write_wb;
assign forwardB_e = (condition1_RtE) ? 2'b10 :
                    (condition2_RtE) ? 2'b01 : 2'b00;

// Data Hazard solved by forward in Decode
wire condition1_RsD, condition2_RsD, condition3_RsD;
wire condition1_RtD, condition2_RtD, condition3_RtD;

assign condition1_RsD = (rs_d != 0) && (rs_d == write_reg_m) && reg_write_m;
assign condition2_RsD = (rs_d != 0) && (rs_d == write_reg_wb) && (mem_to_reg_wb == HI);
assign condition3_RsD = (rs_d != 0) && (rs_d == write_reg_wb) && (mem_to_reg_wb == LO);
assign forwardA_d = (condition1_RsD) ? 2'b00 :
                    (condition2_RsD) ? 2'b01 :
                    (condition3_RsD) ? 2'b10 : 2'b11;

assign condition1_RtD = (rt_d != 0) && (rt_d == write_reg_m) && reg_write_m;
assign condition2_RtD = (rt_d != 0) && (rt_d == write_reg_wb) && (mem_to_reg_wb == HI);
assign condition3_RtD = (rt_d != 0) && (rt_d == write_reg_wb) && (mem_to_reg_wb == LO);
assign forwardB_d = (condition1_RtD) ? 2'b00 :
                    (condition2_RtD) ? 2'b01 :
                    (condition3_RtD) ? 2'b10 : 2'b11;

// Data & Control Hazard solved by Stall
wire LwStall;  // Stall for lw instruction
wire MfStall;  // Stall for mfhi/mflo instructions
wire branchstall_cond1, branchstall_cond2, branchstall;

assign LwStall = ((rs_d == rt_e) || (rt_d == rt_e)) && (mem_to_reg_e == MEM_OUT);
assign MfStall = ((rs_d == rt_e) || (rt_d == rt_e)) && ((mem_to_reg_e == HI) || (mem_to_reg_e == LO));

assign branchstall_cond1 = (branch_d != NO_BRANCH) && reg_write_e && ((write_reg_e == rs_d) || (write_reg_e == rt_d));
assign branchstall_cond2 = (branch_d != NO_BRANCH) && ((mem_to_reg_m == MEM_OUT) || (mem_to_reg_m == HI) || (mem_to_reg_m == LO)) && ((write_reg_m == rs_d) || (write_reg_m == rt_d));
assign branchstall = branchstall_cond1 || branchstall_cond2;

// Data Hazard solved by forward from memory stage between lw $ra and jr $ra
assign forward_jr_f = (jump_d == JR) && ~link_d && (mem_to_reg_m == MEM_OUT) && (rs_d == write_reg_m);

// Data Hazard solved by forward from execute stage between addi $rs and jalr $rs
assign forward_jalr_f = (jump_d == JR) && link_d && reg_write_e && (rs_d == write_reg_e);

assign stall_f = LwStall || MfStall || branchstall;
assign stall_d = LwStall || MfStall || branchstall;
assign flush_e = LwStall || MfStall || branchstall;

endmodule
