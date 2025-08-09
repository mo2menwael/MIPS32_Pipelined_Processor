module PC_reg (
    input wire clk, rst_n, enable,
    input wire [31:0] pc_next,
    output reg [31:0] pc
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pc <= 32'b0;
    end else if (enable) begin
        pc <= pc_next;
    end
end

endmodule
