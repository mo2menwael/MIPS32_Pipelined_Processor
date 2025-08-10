// verilog_lint: waive-start line-length
// verilog_lint: waive-start always-comb
// verilog_lint: waive-start explicit-parameter-storage-type
// verilog_lint: waive-start parameter-name-style

module Ctrl_Unit (
    input wire [5:0] op_code,
    input wire [5:0] funct,
    input wire rt_first_bit,
    input wire rs_third_bit,
    output reg reg_dst_d,
    output reg reg_write_d,
    output reg [2:0] mem_to_reg_d,
    output reg alu_src_d,
    output reg [3:0] alu_control_d,
    output reg mem_write_d,
    output reg [2:0] branch_d,
    output reg [1:0] jump_d,
    output reg unsigned_instr_d,
    output reg [1:0] sign_extend_d,
    output reg [1:0] mem_data_size_d,
    output reg link_d,
    output reg mult_en_d,
    output reg div_en_d,
    output reg hi_write_d,
    output reg lo_write_d,
    output reg [1:0] hi_src_d,
    output reg [1:0] lo_src_d,
    output reg undefined_instr_d
);

localparam [2:0] NO_BRANCH = 3'b000, BRANCH_EQUAL = 3'b001, BRANCH_NOT_EQUAL = 3'b010,
                 BRANCH_LT_ZERO = 3'b011, BRANCH_LTE_ZERO = 3'b100, BRANCH_GT_ZERO = 3'b101,
                 BRANCH_GTE_ZERO = 3'b110;

localparam [1:0] NO_JUMP = 2'b00, JTA = 2'b01, JR = 2'b10;

localparam [2:0] ALU_OUT = 3'b000, MEM_OUT = 3'b001, HI = 3'b010, LO = 3'b011, C0 = 3'b100;

localparam [1:0] NO_MULT_DIV = 2'b00, MULT = 2'b01, DIV = 2'b10;

always@(*) begin
    // R-type instructions
    if (~|op_code) begin
        reg_dst_d = 1; reg_write_d = 1; alu_src_d = 0; mem_to_reg_d = ALU_OUT; mem_write_d = 0; mem_data_size_d = 2'b10; link_d = 1'b0;
        alu_control_d = 4'b1111; branch_d = NO_BRANCH; jump_d = NO_JUMP; unsigned_instr_d = 1'b0; sign_extend_d = 2'b00; undefined_instr_d = 1'b0;
        mult_en_d = 1'b0; div_en_d = 1'b0; hi_write_d = 1'b0; lo_write_d = 1'b0; hi_src_d = NO_MULT_DIV; lo_src_d = NO_MULT_DIV;

        case (funct)
            6'b000000: alu_control_d = 4'b0000;  // SLL (Shift Left Logical)
            6'b000010: alu_control_d = 4'b0001;  // SRL (Shift Right Logical)
            6'b000011: alu_control_d = 4'b0010;  // SRA (Shift Right Arithmetic)
            6'b000100: alu_control_d = 4'b0011;  // SLLV (Shift Left Logical Variable)
            6'b000110: alu_control_d = 4'b0100;  // SRLV (Shift Right Logical Variable)
            6'b000111: alu_control_d = 4'b0101;  // SRAV (Shift Right Arithmetic Variable)

            // JR (Jump Register)
            6'b001000: begin
                jump_d = JR; reg_write_d = 1'b0;
            end

            // JALR (Jump and Link Register)
            6'b001001: begin
                jump_d = JR; link_d = 1'b1; reg_write_d = 1'b0;
            end

            // MFHI (Move From HI)
            6'b010000: begin
                reg_write_d = 1'b1; mem_to_reg_d = HI;
            end

            // MTHI (Move To HI)
            6'b010001: begin
                hi_src_d = NO_MULT_DIV; hi_write_d = 1'b1; reg_write_d = 1'b0; alu_control_d = 4'b1110;
            end

            // MFLO (Move From LO)
            6'b010010: begin
                reg_write_d = 1'b1; mem_to_reg_d = LO;
            end

            // MTLO (Move To LO)
            6'b010011: begin
                lo_src_d = NO_MULT_DIV; lo_write_d = 1'b1; reg_write_d = 1'b0; alu_control_d = 4'b1110;
            end

            // MULT (Multiply)
            6'b011000: begin
                mult_en_d = 1'b1; hi_src_d = MULT; lo_src_d = MULT; hi_write_d = 1'b1; lo_write_d = 1'b1; reg_write_d = 1'b0;
            end

            // MULTU (Multiply Unsigned)
            6'b011001: begin
                mult_en_d = 1'b1; hi_src_d = MULT; lo_src_d = MULT; hi_write_d = 1'b1; lo_write_d = 1'b1; reg_write_d = 1'b0; unsigned_instr_d = 1'b1;
            end

            // DIV (Divide)
            6'b011010: begin
                div_en_d = 1'b1; hi_src_d = DIV; lo_src_d = DIV; hi_write_d = 1'b1; lo_write_d = 1'b1; reg_write_d = 1'b0;
            end

            // DIVU (Divide Unsigned)
            6'b011011: begin
                div_en_d = 1'b1; hi_src_d = DIV; lo_src_d = DIV; hi_write_d = 1'b1; lo_write_d = 1'b1; reg_write_d = 1'b0; unsigned_instr_d = 1'b1;
            end

            6'b100000: alu_control_d = 4'b0110;  // ADD (Add)
            // ADDU (Add Unsigned)
            6'b100001: begin
                alu_control_d = 4'b0110; unsigned_instr_d = 1'b1;
            end
            6'b100010: alu_control_d = 4'b0111;  // SUB (Subtract)
            // SUBU (Subtract Unsigned)
            6'b100011: begin
                alu_control_d = 4'b0111; unsigned_instr_d = 1'b1;
            end
            6'b100100: alu_control_d = 4'b1000;  // AND (Bitwise AND)
            6'b100101: alu_control_d = 4'b1001;  // OR (Bitwise OR)
            6'b100110: alu_control_d = 4'b1010;  // XOR (Bitwise XOR)
            6'b100111: alu_control_d = 4'b1011;  // NOR (Bitwise NOR)
            6'b101010: alu_control_d = 4'b1100;  // SLT (Set on Less Than)
            // SLTU (Set on Less Than Unsigned)
            6'b101011: begin
                alu_control_d = 4'b1100; unsigned_instr_d = 1'b1;
            end
            default : begin
                reg_dst_d = 1; reg_write_d = 0; alu_src_d = 0; mem_to_reg_d = ALU_OUT; mem_write_d = 0; mem_data_size_d = 2'b10; link_d = 1'b0;
                alu_control_d = 4'b1111; branch_d = NO_BRANCH; jump_d = NO_JUMP; unsigned_instr_d = 1'b0; sign_extend_d = 2'b00; undefined_instr_d = 1'b1;
                mult_en_d = 1'b0; div_en_d = 1'b0; hi_write_d = 1'b0; lo_write_d = 1'b0; hi_src_d = NO_MULT_DIV; lo_src_d = NO_MULT_DIV;
            end
        endcase
    end
    else begin
        reg_dst_d = 1'b0; unsigned_instr_d = 1'b0; reg_write_d = 1'b0; mem_to_reg_d = ALU_OUT; mem_data_size_d = 2'b10; link_d = 1'b0;
        mem_write_d = 1'b0; branch_d = NO_BRANCH; jump_d = NO_JUMP; alu_control_d = 4'b1111; alu_src_d = 1'b0; sign_extend_d = 2'b00;
        mult_en_d = 1'b0; div_en_d = 1'b0; hi_write_d = 1'b0; lo_write_d = 1'b0; hi_src_d = NO_MULT_DIV; lo_src_d = NO_MULT_DIV; undefined_instr_d = 1'b0;

        case (op_code)
            // branch less than zero/branch greater than or equal to zero
            6'b000001: begin
                if (~rt_first_bit) begin  // branch less than zero
                    branch_d = BRANCH_LT_ZERO;
                end
                else begin // branch greater than or equal to zero
                    branch_d = BRANCH_GTE_ZERO;
                end
            end

            // Jump
            6'b000010: begin
                jump_d = JTA;
            end
            // Jump and Link
            6'b000011: begin
                jump_d = JTA; link_d = 1'b1;
            end
            // Branch if Equal
            6'b000100: begin
                branch_d = BRANCH_EQUAL;
            end
            // Branch if not equal
            6'b000101: begin
                branch_d = BRANCH_NOT_EQUAL;
            end
            // branch if less than or equal to zero
            6'b000110: begin
                branch_d = BRANCH_LTE_ZERO;
            end
            // branch if greater than zero
            6'b000111: begin
                branch_d = BRANCH_GT_ZERO;
            end

            // Add immediate
            6'b001000: begin
                reg_write_d = 1'b1; alu_src_d = 1'b1; alu_control_d = 4'b0110;
            end
            // Add Immediate Unsigned
            6'b001001: begin
                reg_write_d = 1'b1; alu_src_d = 1'b1; alu_control_d = 4'b0110; unsigned_instr_d = 1'b1;
            end
            // Set less than immediate
            6'b001010: begin
                reg_write_d = 1'b1; alu_src_d = 1'b1; alu_control_d = 4'b1100;
            end
            // Set less than immediate unsigned
            6'b001011: begin
                reg_write_d = 1'b1; alu_src_d = 1'b1; alu_control_d = 4'b1100; unsigned_instr_d = 1'b1;
            end
            // AND Immediate
            6'b001100: begin
                reg_write_d = 1'b1; alu_src_d = 1'b1; alu_control_d = 4'b1000; sign_extend_d = 2'b01;
            end
            // OR Immediate
            6'b001101: begin
                reg_write_d = 1'b1; alu_src_d = 1'b1; alu_control_d = 4'b1001; sign_extend_d = 2'b01;
            end
            // XOR Immediate
            6'b001110: begin
                reg_write_d = 1'b1; alu_src_d = 1'b1; alu_control_d = 4'b1010; sign_extend_d = 2'b01;
            end

            // Load Upper Immediate
            6'b001111: begin
                reg_write_d = 1'b1; alu_src_d = 1'b1; sign_extend_d = 2'b10; alu_control_d = 4'b1111; // to pass SrcB from ALU
            end

            // Move from coprocessor0
            6'b010000: begin
                if (~rs_third_bit) begin
                    reg_write_d = 1'b1; mem_to_reg_d = C0;
                end
            end

            // MUL (Multiply output in 32-bit)
            6'b011100: begin
                alu_control_d = 4'b1101; reg_dst_d = 1; reg_write_d = 1'b1;
            end

            // Load byte
            6'b100000: begin
                reg_write_d = 1'b1; alu_src_d = 1'b1; alu_control_d = 4'b0110; mem_to_reg_d = MEM_OUT; mem_data_size_d = 2'b00;
            end
            // Load halfword
            6'b100001: begin
                reg_write_d = 1'b1; alu_src_d = 1'b1; alu_control_d = 4'b0110; mem_to_reg_d = MEM_OUT; mem_data_size_d = 2'b01;
            end
            // Load Word
            6'b100011: begin
                reg_write_d = 1'b1; alu_src_d = 1'b1; alu_control_d = 4'b0110; mem_to_reg_d = MEM_OUT; mem_data_size_d = 2'b10;
            end
            // Load byte unsigned
            6'b100100: begin
                reg_write_d = 1'b1; alu_src_d = 1'b1; alu_control_d = 4'b0110; mem_to_reg_d = MEM_OUT; mem_data_size_d = 2'b00; sign_extend_d = 2'b01;
            end
            // Load halfword unsigned
            6'b100101: begin
                reg_write_d = 1'b1; alu_src_d = 1'b1; alu_control_d = 4'b0110; mem_to_reg_d = MEM_OUT; mem_data_size_d = 2'b01; sign_extend_d = 2'b01;
            end
            // Store byte
            6'b101000: begin
                alu_src_d = 1'b1; alu_control_d = 4'b0110; mem_write_d = 1'b1; mem_data_size_d = 2'b00;
            end
            // Store halfword
            6'b101001: begin
                alu_src_d = 1'b1; alu_control_d = 4'b0110; mem_write_d = 1'b1; mem_data_size_d = 2'b01;
            end
            // Store Word
            6'b101011: begin
                alu_src_d = 1'b1; alu_control_d = 4'b0110; mem_write_d = 1'b1; mem_data_size_d = 2'b10;
            end

            // Default
            default: begin
                reg_dst_d = 1'b0; unsigned_instr_d = 1'b0; reg_write_d = 1'b0; mem_to_reg_d = ALU_OUT; mem_data_size_d = 2'b10; link_d = 1'b0;
                mem_write_d = 1'b0; branch_d = NO_BRANCH; jump_d = NO_JUMP; alu_control_d = 4'b1111; alu_src_d = 1'b0; sign_extend_d = 2'b00;
                mult_en_d = 1'b0; div_en_d = 1'b0; hi_write_d = 1'b0; lo_write_d = 1'b0; hi_src_d = NO_MULT_DIV; lo_src_d = NO_MULT_DIV; undefined_instr_d = 1'b1;
            end
        endcase
    end
end

endmodule
