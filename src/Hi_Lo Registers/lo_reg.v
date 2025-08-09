module lo_reg (
    input wire clk,
    input wire rst_n,
    input wire lo_write,
    input wire [31:0] lo_in,
    output reg [31:0] lo_out
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        lo_out <= 32'b0;
    end else if (lo_write) begin
        lo_out <= lo_in;
    end
end

endmodule
