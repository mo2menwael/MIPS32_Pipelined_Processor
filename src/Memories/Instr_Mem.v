// verilog_lint: waive-start explicit-parameter-storage-type
// verilog_lint: waive-start unpacked-dimensions-range-ordering
// verilog_lint: waive-start always-comb

module Instr_Mem #(parameter DEPTH = 1024) (
    input wire [31:0] pc,
    output wire [31:0] instr
);

reg [31:0] mem [0:DEPTH-1];

assign instr = mem[pc[31:2]];  // MIPS uses byte addressing, but instructions are word-aligned
                               // Each instruction is 4 bytes, so we need to divide PC by 4

endmodule
