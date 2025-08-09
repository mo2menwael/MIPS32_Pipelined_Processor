module hi_reg (
    input wire clk,
    input wire rst_n,
    input wire hi_write,
    input wire [31:0] hi_in,
    output reg [31:0] hi_out
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        hi_out <= 32'b0;
    end else if (hi_write) begin
        hi_out <= hi_in;
    end
end

endmodule
