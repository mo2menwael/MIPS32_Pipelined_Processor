// verilog_lint: waive-start explicit-parameter-storage-type
// verilog_lint: waive-start unpacked-dimensions-range-ordering
// verilog_lint: waive-start always-comb

module Data_Mem #(parameter DEPTH = 32768, WIDTH = 8) (
    input wire clk, rst_n,
    input wire wr_en,
    input wire [1:0] mem_data_size,
    input wire [(4*WIDTH)-1:0] addr,
    input wire [(4*WIDTH)-1:0] wr_data,
    output reg [(4*WIDTH)-1:0] rd_data
);

reg [WIDTH-1:0] mem [0:DEPTH-1];

integer i;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (i = 0; i < DEPTH; i = i + 1) begin
            mem[i] <= 0;
        end
    end
    else if (wr_en) begin
        if (mem_data_size == 2'b00) begin
            mem[addr] <= wr_data[7:0];
        end
        else if (mem_data_size == 2'b01) begin
            {mem[addr+1], mem[addr]} <= wr_data[15:0];
        end
        else if (mem_data_size == 2'b10) begin
            {mem[addr+3], mem[addr+2], mem[addr+1], mem[addr]} <= wr_data;
        end
    end
end

always@(*) begin
    if (mem_data_size == 2'b00) begin
        rd_data = {{24{mem[addr][7]}}, mem[addr]};
    end
    else if (mem_data_size == 2'b01) begin
        rd_data = {{16{mem[addr+1][7]}}, mem[addr+1], mem[addr]};
    end
    else if (mem_data_size == 2'b10) begin
        rd_data = {mem[addr+3], mem[addr+2], mem[addr+1], mem[addr]};
    end
    else begin
        rd_data = 0;    // Should not happen
    end
end

endmodule
