module Branch_State_Reg (
    input wire clk, rst_n,
    input wire clear,
    input wire [1:0] branch_state_f,
    output reg [1:0] branch_state_d
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        branch_state_d <= 2'b00;
    end else if (clear) begin
        branch_state_d <= 2'b00;
    end else begin
        branch_state_d <= branch_state_f;
    end
end

endmodule
