module Sign_OR_Zero_Extend (
    input wire [15:0] imm,
    input wire [1:0] sign_extend,
    output wire [31:0] extended
);

assign extended = (sign_extend == 2'b00) ? {{16{imm[15]}}, imm} :
                  (sign_extend == 2'b01) ? {16'b0, imm} :
                  (sign_extend == 2'b10) ? {imm, 16'b0} :
                  32'b0;

endmodule
