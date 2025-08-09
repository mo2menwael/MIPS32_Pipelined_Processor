// verilog_lint: waive-start unpacked-dimensions-range-ordering

module Reg_file (
    input wire clk, rst_n,
    input wire wr_en,
    input wire [4:0] rd_addr1,
    input wire [4:0] rd_addr2,
    input wire [4:0] wr_addr,
    input wire [31:0] wr_data,
    output wire [31:0] rd_data1,
    output wire [31:0] rd_data2
);

reg [31:0] reg_file_mem [0:31];

integer i;

always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (i = 0; i < 32; i = i + 1) begin
            reg_file_mem[i] <= 0;
        end
    end
    else if (wr_en) begin
        reg_file_mem[wr_addr] <= wr_data;
    end
end


// Setting the $0 register value to 0 when read
assign rd_data1 = (rd_addr1 != 0) ? reg_file_mem[rd_addr1] : 0;
assign rd_data2 = (rd_addr2 != 0) ? reg_file_mem[rd_addr2] : 0;

endmodule
