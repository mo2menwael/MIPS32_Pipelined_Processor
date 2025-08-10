// verilog_lint: waive-start line-length

module DIV_Unit (
    input wire [31:0] op1,
    input wire [31:0] op2,
    input wire div_en,
    input wire unsigned_instr,
    output wire [63:0] div_result
);

assign div_result = div_en ? (unsigned_instr ? {op1 % op2, op1 / op2} : {$signed(op1) % $signed(op2), $signed(op1) / $signed(op2)}) : 64'b0;

endmodule
