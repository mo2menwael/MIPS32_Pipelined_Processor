// verilog_lint: waive-start unpacked-dimensions-range-ordering
// verilog_lint: waive-start always-comb

module Branch_Target_Buffer (
    input clk, rst_n,
    input [58:0] buffer_in,
    input wr_en,
    input [5:0] write_index,
    input [5:0] read_index,
    output wire [58:0] buffer_out
);

// Branch Target Buffer (BTB) structure (64 entries, 59 bits each)
reg [58:0] BTB [0:63];

integer i;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (i = 0; i < 64; i = i + 1) begin
            BTB[i] <= 59'd0;
        end
    end else if (wr_en) begin
        BTB[write_index] <= buffer_in;
    end
end

assign buffer_out = BTB[read_index];

endmodule
