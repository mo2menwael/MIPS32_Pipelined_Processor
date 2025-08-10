// verilog_lint: waive-start line-length

module MULT_Unit (
    input wire [31:0] op1,
    input wire [31:0] op2,
    input wire mult_en,
    input wire unsigned_instr,
    output wire [63:0] mult_result
);

wire [31:0] op1_signed;
wire [31:0] op2_signed;
assign op1_signed = (!unsigned_instr & op1[31]) ? -op1 : op1;
assign op2_signed = (!unsigned_instr & op2[31]) ? -op2 : op2;


wire [63:0] result;
assign result = mult_en ? op1_signed * op2_signed : 64'b0;

// xor for inequality check
assign mult_result = (~unsigned_instr & (op1[31] ^ op2[31])) ? -result : result;

endmodule
