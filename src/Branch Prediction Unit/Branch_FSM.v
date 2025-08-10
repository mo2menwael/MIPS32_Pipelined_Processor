// verilog_lint: waive-start always-comb
// verilog_lint: waive-start parameter-name-style
// verilog_lint: waive-start explicit-parameter-storage-type

module Branch_FSM (
    input wire hazard_stall,
    input wire branch_taken,
    input wire [1:0] branch_state_d,
    input wire [31:0] write_target,
    input wire [31:0] write_address,
    input wire branch_write_enable,
    input wire jump_write_enable,
    output reg [1:0] branch_next_state,
    output reg valid,
    output reg [31:0] mispred_correct_target,
    output reg mispred_sel
);

localparam [1:0] Strongly_not_taken = 2'b00,
                 Weakly_not_taken = 2'b01,
                 Weakly_taken = 2'b10,
                 Strongly_taken = 2'b11;

always @(*) begin
    if (hazard_stall) begin
        valid = 1'b0;
        mispred_sel = 1'b0;
        mispred_correct_target = 32'd0;
        branch_next_state = branch_state_d; // Keep current state by default
    end
    else begin
        if (jump_write_enable) begin
            valid = 1'b1;
            if (branch_state_d == Strongly_taken || branch_state_d == Weakly_taken) begin
                mispred_sel = 1'b0;
                mispred_correct_target = 32'd0;
                branch_next_state = Strongly_taken;
            end
            else begin
                mispred_sel = 1'b1;
                mispred_correct_target = write_target; // Use the jump target for misprediction
                branch_next_state = Strongly_taken;
            end
        end
        else if (branch_write_enable) begin
            valid = 1'b1;

            case (branch_state_d)
                Strongly_not_taken: begin
                    if (branch_taken) begin
                        branch_next_state = Weakly_not_taken;
                        mispred_sel = 1'b1;
                        mispred_correct_target = write_target;
                    end
                    else begin
                        branch_next_state = Strongly_not_taken;
                        mispred_sel = 1'b0;
                        mispred_correct_target = 32'd0;
                    end
                end
                Weakly_not_taken: begin
                    if (branch_taken) begin
                        branch_next_state = Weakly_taken;
                        mispred_sel = 1'b1;
                        mispred_correct_target = write_target;
                    end
                    else begin
                        branch_next_state = Strongly_not_taken;
                        mispred_sel = 1'b0;
                        mispred_correct_target = 32'd0;
                    end
                end
                Weakly_taken: begin
                    if (branch_taken) begin
                        branch_next_state = Strongly_taken;
                        mispred_sel = 1'b0;
                        mispred_correct_target = 32'd0;
                    end
                    else begin
                        branch_next_state = Weakly_not_taken;
                        mispred_sel = 1'b1;
                        mispred_correct_target = write_address + 4;
                    end
                end
                Strongly_taken: begin
                    if (branch_taken) begin
                        branch_next_state = Strongly_taken;
                        mispred_sel = 1'b0;
                        mispred_correct_target = 32'd0;
                    end
                    else begin
                        branch_next_state = Weakly_taken;
                        mispred_sel = 1'b1;
                        mispred_correct_target = write_address + 4;
                    end
                end
                default: begin
                    branch_next_state = Strongly_not_taken;
                    mispred_sel = 1'b0;
                    mispred_correct_target = 32'd0;
                end
            endcase
        end
        else begin
            valid = 1'b0;
            mispred_sel = 1'b0;
            mispred_correct_target = 32'b0;
            branch_next_state = branch_state_d; // Keep current state by default
        end
    end
end

endmodule
