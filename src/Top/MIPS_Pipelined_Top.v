// verilog_lint: waive-start explicit-parameter-storage-type
// verilog_lint: waive-start parameter-name-style
// verilog_lint: waive-start line-length

module MIPS_Pipelined_Top (
    input wire clk,
    input wire rst_n,
    output wire [3:0] led
);

localparam [2:0] NO_BRANCH = 3'b000, BRANCH_EQUAL = 3'b001, BRANCH_NOT_EQUAL = 3'b010,
                 BRANCH_LT_ZERO = 3'b011, BRANCH_LTE_ZERO = 3'b100, BRANCH_GT_ZERO = 3'b101,
                 BRANCH_GTE_ZERO = 3'b110;

localparam [1:0] NO_JUMP = 2'b00, JTA = 2'b01, JR = 2'b10;

localparam [2:0] ALU_OUT = 3'b000, MEM_OUT = 3'b001, HI = 3'b010, LO = 3'b011, C0 = 3'b100;

localparam [1:0] NO_MULT_DIV = 2'b00, MULT = 2'b01, DIV = 2'b10;

wire [31:0] PC_f, PC_d;
wire [31:0] PC_next;
wire [31:0] PC_Jump;
wire [31:0] PC_Plus_4_f, PC_Plus_4_d, PC_Plus_4_e, PC_Plus_4_m, PC_Plus_4_wb;
wire [31:0] PC_Branch_d;
wire [31:0] Jr_Target_Addr, Jalr_Target_Addr;
wire [31:0] Instr_f, Instr_d;
wire [31:0] SignImm_d, SignImm_e;
wire [4:0] rs_d, rt_d, rd_d;
wire [4:0] rs_e, rt_e, rd_e;
wire [4:0] rd_m, rd_wb;
wire [31:0] SrcA_e, SrcB_e;
wire [31:0] ALU_out_e, ALU_out_m, ALU_out_wb;
wire [31:0] Write_Data_e, Write_Data_m;
wire [4:0] Write_Reg_e, Write_Reg_m, Write_Reg_wb;
wire [31:0] Read_Data_m, Read_Data_wb;
wire [31:0] SrcA_00_d, SrcB_00_d, SrcA_00_e, SrcB_00_e;
wire [31:0] read_data1_d, read_data2_d;
wire [31:0] result_wb;
wire [31:0] Reg_File_Write_Data;
wire [4:0] Reg_File_Write_Addr;

wire Reg_Write_d, Reg_Write_e, Reg_Write_m, Reg_Write_wb;
wire [2:0] Mem_to_Reg_d, Mem_to_Reg_e, Mem_to_Reg_m, Mem_to_Reg_wb;
wire Mem_Write_d, Mem_Write_e, Mem_Write_m;
wire [3:0] ALU_Control_d, ALU_Control_e;
wire ALU_Src_d, ALU_Src_e;
wire Reg_Dst_d, Reg_Dst_e;
wire Unsigned_Instr_d, Unsigned_Instr_e;
wire [4:0] Shamt_d, Shamt_e;
wire [1:0] Mem_Data_Size_d, Mem_Data_Size_e, Mem_Data_Size_m;
wire [2:0] Branch_d;
wire PCSrc_d;
wire [1:0] Jump_d;
wire Link_d, Link_e, Link_m, Link_wb;
wire Overflow;
wire [1:0] Sign_Extend;

wire stall_f, stall_d, flush_e;
wire [1:0] forwardA_d, forwardB_d;
wire [1:0] forward_jr_f;
wire forward_jalr_f;
wire [1:0] forwardA_e, forwardB_e;


wire Div_En_d, Div_En_e;
wire Mult_En_d, Mult_En_e;
wire [63:0] Div_Result_e, Div_Result_m;
wire [63:0] Mult_Result_e, Mult_Result_m;
wire Hi_Write_d, Hi_Write_e, Hi_Write_m;
wire Lo_Write_d, Lo_Write_e, Lo_Write_m;
wire [31:0] Hi_In_m;
wire [31:0] Hi_Out_m, Hi_Out_wb;
wire [31:0] Lo_In_m;
wire [31:0] Lo_Out_m, Lo_Out_wb;
wire [1:0] Hi_Src_d, Hi_Src_e, Hi_Src_m;
wire [1:0] Lo_Src_d, Lo_Src_e, Lo_Src_m;

wire branch_pred_sel;
wire [31:0] branch_pred_target;
wire mispred_sel;
wire [31:0] mispred_correct_target;
wire [31:0] jump_write_target;

wire EPC_Write, Cause_Write;
wire [1:0] Int_Cause;
wire [31:0] C0_Reg_Data_d, C0_Reg_Data_e, C0_Reg_Data_m, C0_Reg_Data_wb;
wire Undefined_Instr_d;
wire Div_by_Zero;

PC_reg pc_reg_inst (
.clk    (clk),
.rst_n  (rst_n),
.enable (!stall_f | EPC_Write),
.pc_next(PC_next),
.pc     (PC_f)
);

Instr_Mem instr_mem_inst (
.pc   (PC_f),
.instr(Instr_f)
);

Data_Mem data_mem_inst (
.clk          (clk),
.rst_n        (rst_n),
.wr_en        (Mem_Write_m),
.addr         (ALU_out_m),
.wr_data      (Write_Data_m),
.mem_data_size(Mem_Data_Size_m),
.rd_data      (Read_Data_m)
);

Reg_file reg_file_inst (
.clk     (clk),
.rst_n   (rst_n),
.wr_en   (Reg_Write_wb | Link_wb),
.rd_addr1(rs_d),
.rd_addr2(rt_d),
.wr_addr (Reg_File_Write_Addr),
.wr_data (Reg_File_Write_Data),
.rd_data1(read_data1_d),
.rd_data2(read_data2_d)
);

Sign_OR_Zero_Extend sign_or_zero_extend_inst (
.imm        (Instr_d[15:0]),
.sign_extend(Sign_Extend),
.extended   (SignImm_d)
);

ALU ALU_inst (
.SrcA          (SrcA_e),
.SrcB          (SrcB_e),
.alu_op        (ALU_Control_e),
.alu_result    (ALU_out_e),
.unsigned_instr(Unsigned_Instr_e),
.shamt         (Shamt_e),
.overflow      (Overflow)
);

Ctrl_Unit ctrl_unit_inst (
.op_code          (Instr_d[31:26]),
.funct            (Instr_d[5:0]),
.rt_first_bit     (Instr_d[16]),
.rs_third_bit     (Instr_d[23]),
.reg_dst_d        (Reg_Dst_d),
.reg_write_d      (Reg_Write_d),
.mem_to_reg_d     (Mem_to_Reg_d),
.alu_src_d        (ALU_Src_d),
.alu_control_d    (ALU_Control_d),
.mem_write_d      (Mem_Write_d),
.branch_d         (Branch_d),
.jump_d           (Jump_d),
.unsigned_instr_d (Unsigned_Instr_d),
.sign_extend_d    (Sign_Extend),
.mem_data_size_d  (Mem_Data_Size_d),
.link_d           (Link_d),
.hi_write_d       (Hi_Write_d),
.lo_write_d       (Lo_Write_d),
.mult_en_d        (Mult_En_d),
.div_en_d         (Div_En_d),
.hi_src_d         (Hi_Src_d),
.lo_src_d         (Lo_Src_d),
.undefined_instr_d(Undefined_Instr_d)
);

Hazard_Unit hazard_unit_inst (
.rs_d           (rs_d),
.rt_d           (rt_d),
.rs_e           (rs_e),
.rt_e           (rt_e),
.write_reg_e    (Write_Reg_e),
.write_reg_m    (Write_Reg_m),
.write_reg_wb   (Write_Reg_wb),
.branch_d       (Branch_d),
.jump_d         (Jump_d),
.mem_to_reg_e   (Mem_to_Reg_e),
.mem_to_reg_m   (Mem_to_Reg_m),
.mem_to_reg_wb  (Mem_to_Reg_wb),
.reg_write_e    (Reg_Write_e),
.reg_write_m    (Reg_Write_m),
.reg_write_wb   (Reg_Write_wb),
.link_d         (Link_d),
.Overflow       (Overflow),
.stall_f        (stall_f),
.stall_d        (stall_d),
.forwardA_d     (forwardA_d),
.forwardB_d     (forwardB_d),
.forwardA_e     (forwardA_e),
.forwardB_e     (forwardB_e),
.forward_jr_f   (forward_jr_f),
.forward_jalr_f (forward_jalr_f),
.flush_e        (flush_e)
);

BranchComparison_Unit branch_comparison_unit_inst (
.SrcA       (SrcA_00_d),
.SrcB       (SrcB_00_d),
.branch_d   (Branch_d),
.pc_srd_d   (PCSrc_d)
);

f2d_regs f2d_regs_inst (
.clk        (clk),
.rst_n      (rst_n),
.enable     (!stall_d),
.clear      ((mispred_sel & !stall_d) || (EPC_Write)),           // flush_f
.instr_f    (Instr_f),
.pc_plus_4_f(PC_Plus_4_f),
.pc_f       (PC_f),
.instr_d    (Instr_d),
.pc_plus_4_d(PC_Plus_4_d),
.pc_d       (PC_d)
);

d2e_regs d2e_regs_inst (
.clk             (clk),
.rst_n           (rst_n),
.clear           (flush_e),
.rt_d            (rt_d),
.rs_d            (rs_d),
.rd_d            (rd_d),
.alu_src_d       (ALU_Src_d),
.reg_dst_d       (Reg_Dst_d),
.mem_write_d     (Mem_Write_d),
.reg_write_d     (Reg_Write_d),
.mem_to_reg_d    (Mem_to_Reg_d),
.alu_control_d   (ALU_Control_d),
.srcA_00_d       (SrcA_00_d),
.srcB_00_d       (SrcB_00_d),
.sign_imm_d      (SignImm_d),
.unsigned_instr_d(Unsigned_Instr_d),
.shamt_d         (Shamt_d),
.mem_data_size_d (Mem_Data_Size_d),
.link_d          (Link_d),
.pc_plus_4_d     (PC_Plus_4_d),
.div_en_d        (Div_En_d),
.mult_en_d       (Mult_En_d),
.hi_src_d        (Hi_Src_d),
.lo_src_d        (Lo_Src_d),
.hi_write_d      (Hi_Write_d),
.lo_write_d      (Lo_Write_d),
.C0_Reg_Data_d   (C0_Reg_Data_d),
.hi_write_e      (Hi_Write_e),
.lo_write_e      (Lo_Write_e),
.hi_src_e        (Hi_Src_e),
.lo_src_e        (Lo_Src_e),
.div_en_e        (Div_En_e),
.mult_en_e       (Mult_En_e),
.rt_e            (rt_e),
.rs_e            (rs_e),
.rd_e            (rd_e),
.alu_src_e       (ALU_Src_e),
.reg_dst_e       (Reg_Dst_e),
.mem_write_e     (Mem_Write_e),
.reg_write_e     (Reg_Write_e),
.mem_to_reg_e    (Mem_to_Reg_e),
.alu_control_e   (ALU_Control_e),
.srcA_00_e       (SrcA_00_e),
.srcB_00_e       (SrcB_00_e),
.sign_imm_e      (SignImm_e),
.unsigned_instr_e(Unsigned_Instr_e),
.shamt_e         (Shamt_e),
.mem_data_size_e (Mem_Data_Size_e),
.link_e          (Link_e),
.pc_plus_4_e     (PC_Plus_4_e),
.C0_Reg_Data_e   (C0_Reg_Data_e)
);

e2m_regs e2m_regs_inst (
.clk            (clk),
.rst_n          (rst_n),
.reg_write_e    (Reg_Write_e),
.mem_to_reg_e   (Mem_to_Reg_e),
.mem_write_e    (Mem_Write_e),
.write_reg_e    (Write_Reg_e),
.alu_out_e      (ALU_out_e),
.write_data_e   (Write_Data_e),
.mem_data_size_e(Mem_Data_Size_e),
.link_e         (Link_e),
.pc_plus_4_e    (PC_Plus_4_e),
.hi_src_e       (Hi_Src_e),
.lo_src_e       (Lo_Src_e),
.hi_write_e     (Hi_Write_e),
.lo_write_e     (Lo_Write_e),
.mult_result_e  (Mult_Result_e),
.div_result_e   (Div_Result_e),
.rd_e           (rd_e),
.C0_Reg_Data_e  (C0_Reg_Data_e),
.hi_src_m       (Hi_Src_m),
.lo_src_m       (Lo_Src_m),
.hi_write_m     (Hi_Write_m),
.lo_write_m     (Lo_Write_m),
.mult_result_m  (Mult_Result_m),
.div_result_m   (Div_Result_m),
.reg_write_m    (Reg_Write_m),
.mem_to_reg_m   (Mem_to_Reg_m),
.mem_write_m    (Mem_Write_m),
.write_reg_m    (Write_Reg_m),
.alu_out_m      (ALU_out_m),
.write_data_m   (Write_Data_m),
.mem_data_size_m(Mem_Data_Size_m),
.link_m         (Link_m),
.pc_plus_4_m    (PC_Plus_4_m),
.rd_m           (rd_m),
.C0_Reg_Data_m  (C0_Reg_Data_m)
);

m2wb_regs m2wb_regs_inst (
.clk           (clk),
.rst_n         (rst_n),
.reg_write_m   (Reg_Write_m),
.mem_to_reg_m  (Mem_to_Reg_m),
.write_reg_m   (Write_Reg_m),
.alu_out_m     (ALU_out_m),
.read_data_m   (Read_Data_m),
.link_m        (Link_m),
.pc_plus_4_m   (PC_Plus_4_m),
.hi_out_m      (Hi_Out_m),
.lo_out_m      (Lo_Out_m),
.rd_m          (rd_m),
.C0_Reg_Data_m (C0_Reg_Data_m),
.hi_out_wb     (Hi_Out_wb),
.lo_out_wb     (Lo_Out_wb),
.reg_write_wb  (Reg_Write_wb),
.mem_to_reg_wb (Mem_to_Reg_wb),
.write_reg_wb  (Write_Reg_wb),
.alu_out_wb    (ALU_out_wb),
.read_data_wb  (Read_Data_wb),
.pc_plus_4_wb  (PC_Plus_4_wb),
.link_wb       (Link_wb),
.rd_wb         (rd_wb),
.C0_Reg_Data_wb(C0_Reg_Data_wb)
);

DIV_Unit div_unit_inst (
.op1           (SrcA_e),
.op2           (Write_Data_e),
.unsigned_instr(Unsigned_Instr_e),
.div_en        (Div_En_e),
.div_result    (Div_Result_e)
);

MULT_Unit mult_unit_inst (
.op1           (SrcA_e),
.op2           (Write_Data_e),
.unsigned_instr(Unsigned_Instr_e),
.mult_en       (Mult_En_e),
.mult_result   (Mult_Result_e)
);

hi_reg hi_reg_inst (
.clk     (clk),
.rst_n   (rst_n),
.hi_write(Hi_Write_m),
.hi_in   (Hi_In_m),
.hi_out  (Hi_Out_m)
);

lo_reg lo_reg_inst (
.clk     (clk),
.rst_n   (rst_n),
.lo_write(Lo_Write_m),
.lo_in   (Lo_In_m),
.lo_out  (Lo_Out_m)
);

Branch_Predictor branch_predictor_inst (
    .clk(clk),
    .rst_n(rst_n),
    .read_address(PC_f),
    .hazard_stall(stall_f),
    .write_address(PC_d),
    .branch_write_enable(Branch_d != NO_BRANCH),
    .jump_write_enable(Jump_d != NO_JUMP),
    .branch_write_target(PC_Branch_d),
    .jump_write_target(jump_write_target),
    .branch_taken(PCSrc_d),
    .branch_pred_sel(branch_pred_sel),
    .branch_pred_target(branch_pred_target),
    .mispred_sel(mispred_sel),
    .mispred_correct_target(mispred_correct_target)
);

Exception_Unit exception_unit_inst (
    .clk(clk),
    .rst_n(rst_n),
    .pc_f(PC_f),
    .pc_d(PC_d),
    .EPC_Write(EPC_Write),
    .Int_Cause(Int_Cause),
    .Cause_Write(Cause_Write),
    .C0_Reg_Address(rd_d),
    .C0_Reg_Data(C0_Reg_Data_d)
);

assign PC_Plus_4_f = PC_f + 4;
assign PC_Branch_d = PC_Plus_4_d + {SignImm_d[29:0], 2'b00};
assign PC_Jump = {PC_Plus_4_d[31:28], Instr_d[25:0], 2'b00};
assign Jalr_Target_Addr = (forward_jalr_f) ? ALU_out_e : read_data1_d;
assign Jr_Target_Addr = (forward_jr_f == 2'b01) ? Read_Data_m :
                        (forward_jr_f == 2'b10) ? C0_Reg_Data_e : read_data1_d;

assign PC_next = (EPC_Write) ? 32'd1120 :                             // Change 32'd1120 for your exception handler address Or implement a virtual memory
                 (mispred_sel) ? mispred_correct_target :             // that has a TLB (Translation Lookaside Buffer) that will translate the addresses for you
                 (branch_pred_sel) ? branch_pred_target : PC_Plus_4_f;

assign jump_write_target = (Jump_d == JTA) ? PC_Jump :
                           (Jump_d == JR && ~Link_d) ? Jr_Target_Addr :
                           (Jump_d == JR && Link_d) ? Jalr_Target_Addr : 32'd0;

// The Hi_Out and Lo_Out bypass is only done after the branch prediction was set up as to
// prevent incorrect data from being used in the positive edge clock in branch comparison unit
assign SrcA_00_d = (forwardA_d == 2'b00) ? ALU_out_m :
                   (forwardA_d == 2'b01) ? Hi_Out_wb :
                   (forwardA_d == 2'b10) ? Lo_Out_wb : read_data1_d;

assign SrcB_00_d = (forwardB_d == 2'b00) ? ALU_out_m :
                   (forwardB_d == 2'b01) ? Hi_Out_wb :
                   (forwardB_d == 2'b10) ? Lo_Out_wb : read_data2_d;

assign rs_d = Instr_d[25:21];
assign rt_d = Instr_d[20:16];
assign rd_d = Instr_d[15:11];
assign Shamt_d = Instr_d[10:6];

assign Write_Reg_e = (Reg_Dst_e) ? rd_e[4:0] : rt_e[4:0];
assign SrcA_e = (forwardA_e == 2'b00) ? SrcA_00_e :
                (forwardA_e == 2'b01) ? result_wb : ALU_out_m;
assign Write_Data_e = (forwardB_e == 2'b00) ? SrcB_00_e :
                      (forwardB_e == 2'b01) ? result_wb : ALU_out_m;
assign SrcB_e = (ALU_Src_e) ? SignImm_e : Write_Data_e;

assign result_wb = (Mem_to_Reg_wb == ALU_OUT) ? ALU_out_wb :
                   (Mem_to_Reg_wb == MEM_OUT) ? Read_Data_wb :
                   (Mem_to_Reg_wb == HI) ? Hi_Out_wb :
                   (Mem_to_Reg_wb == LO) ? Lo_Out_wb : C0_Reg_Data_wb;

assign Reg_File_Write_Data = (Link_wb) ? PC_Plus_4_wb : result_wb;
assign Reg_File_Write_Addr = (Link_wb) ? 5'd31 : Write_Reg_wb;

assign Hi_In_m = (Hi_Src_m == NO_MULT_DIV) ? ALU_out_m :
                 (Hi_Src_m == MULT) ? Mult_Result_m[63:32] : Div_Result_m[63:32];

assign Lo_In_m = (Lo_Src_m == NO_MULT_DIV) ? ALU_out_m :
                 (Lo_Src_m == MULT) ? Mult_Result_m[31:0] : Div_Result_m[31:0];

// Nor to check if the value is equal to zero or not
assign Div_by_Zero = (Instr_d[5:0] == 6'b011010 || Instr_d[5:0] == 6'b011011) && (~|Instr_d[31:26]) && (~|SrcB_00_d);

assign EPC_Write = (Overflow | Undefined_Instr_d | Div_by_Zero);
assign Int_Cause = Overflow ? 2'b00 : (Undefined_Instr_d ? 2'b01 : (Div_by_Zero ? 2'b10 : 2'b11));
assign Cause_Write = EPC_Write;

assign led = reg_file_inst.reg_file_mem[16][3:0];


endmodule
