// verilog_lint: waive-start always-comb
// verilog_lint: waive-start line-length

module ALU (
    input wire [31:0] SrcA,
    input wire [31:0] SrcB,
    input wire [3:0] alu_op,
    input wire [4:0] shamt,
    input wire unsigned_instr,
    output reg [31:0] alu_result,
    output wire overflow
);

always@(*) begin
    case (alu_op)
        4'b0000: alu_result = SrcB << shamt;                    // SLL (Shift Left Logical)
        4'b0001: alu_result = SrcB >> shamt;                    // SRL (Shift Right Logical)
        4'b0010: alu_result = $signed(SrcB) >>> shamt;          // SRA (Shift Right Arithmetic)
        4'b0011: alu_result = SrcB << SrcA[4:0];                // SLLV (Shift Left Logical Variable)
        4'b0100: alu_result = SrcB >> SrcA[4:0];                // SRLV (Shift Right Logical Variable)
        4'b0101: alu_result = $signed(SrcB) >>> SrcA[4:0];      // SRAV (Shift Right Arithmetic Variable)
        4'b0110: alu_result = SrcA + SrcB;                      // ADD (Add)
        4'b0111: alu_result = SrcA - SrcB;                      // SUB (Subtract)
        4'b1000: alu_result = SrcA & SrcB;                      // AND (Bitwise AND)
        4'b1001: alu_result = SrcA | SrcB;                      // OR (Bitwise OR)
        4'b1010: alu_result = SrcA ^ SrcB;                      // XOR (Bitwise XOR)
        4'b1011: alu_result = ~(SrcA | SrcB);                   // NOR (Bitwise NOR)
        4'b1100: alu_result = (unsigned_instr) ? SrcA < SrcB : $signed(SrcA) < $signed(SrcB);   // SLT (Set on Less Than)
        4'b1101: alu_result = $signed(SrcA) * $signed(SrcB);    // MUL (Multiply in 32-bit)
        4'b1110: alu_result = SrcA;                             // Pass SrcA
        default: alu_result = SrcB;                             // Default case (4'b1111), pass SrcB
    endcase
end

// Overflow detection for addition and subtraction
// Overflow occurs if the sign of the result is different from the signs of both operands in addition
// or if the signs of the operands are different in subtraction
assign overflow = (alu_op == 4'b0110 && !unsigned_instr) ? ((SrcA[31] == SrcB[31]) && (alu_result[31] != SrcA[31])) :
                  (alu_op == 4'b0111 && !unsigned_instr) ? ((SrcA[31] != SrcB[31]) && (alu_result[31] != SrcA[31])) :
                  1'b0;

endmodule
