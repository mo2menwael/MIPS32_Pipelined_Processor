module d2e_regs (
    input wire clk,
    input wire rst_n,
    input wire clear,
    input wire [31:0] srcA_00_d,
    input wire [31:0] srcB_00_d,
    input wire [4:0] rs_d,
    input wire [4:0] rt_d,
    input wire [4:0] rd_d,
    input wire [31:0] sign_imm_d,
    input wire [3:0] alu_control_d,
    input wire alu_src_d,
    input wire reg_dst_d,
    input wire reg_write_d,
    input wire [2:0] mem_to_reg_d,
    input wire mem_write_d,
    input wire unsigned_instr_d,
    input wire [4:0] shamt_d,
    input wire [1:0] mem_data_size_d,
    input wire link_d,
    input wire [31:0] pc_plus_4_d,
    input wire mult_en_d,
    input wire div_en_d,
    input wire hi_write_d,
    input wire lo_write_d,
    input wire [1:0] hi_src_d,
    input wire [1:0] lo_src_d,
    input wire [31:0] C0_Reg_Data_d,
    output reg [31:0] srcA_00_e,
    output reg [31:0] srcB_00_e,
    output reg [4:0] rs_e,
    output reg [4:0] rt_e,
    output reg [4:0] rd_e,
    output reg [31:0] sign_imm_e,
    output reg [3:0] alu_control_e,
    output reg alu_src_e,
    output reg reg_dst_e,
    output reg reg_write_e,
    output reg [2:0] mem_to_reg_e,
    output reg mem_write_e,
    output reg unsigned_instr_e,
    output reg [4:0] shamt_e,
    output reg [1:0] mem_data_size_e,
    output reg link_e,
    output reg [31:0] pc_plus_4_e,
    output reg mult_en_e,
    output reg div_en_e,
    output reg hi_write_e,
    output reg lo_write_e,
    output reg [1:0] hi_src_e,
    output reg [1:0] lo_src_e,
    output reg [31:0] C0_Reg_Data_e
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin                     // Don't use (!rst_n | clear) to avoid error in synthesis
        srcA_00_e <= 32'd0;
        srcB_00_e <= 32'd0;
        rs_e <= 5'd0;
        rt_e <= 5'd0;
        rd_e <= 5'd0;
        sign_imm_e <= 32'd0;
        alu_control_e <= 4'd0;
        alu_src_e <= 1'd0;
        reg_dst_e <= 1'd0;
        reg_write_e <= 1'd0;
        mem_to_reg_e <= 2'd0;
        mem_write_e <= 1'd0;
        unsigned_instr_e <= 1'd0;
        shamt_e <= 5'd0;
        mem_data_size_e <= 2'd0;
        link_e <= 1'd0;
        pc_plus_4_e <= 32'd0;
        mult_en_e <= 1'd0;
        div_en_e <= 1'd0;
        hi_write_e <= 1'd0;
        lo_write_e <= 1'd0;
        hi_src_e <= 2'd0;
        lo_src_e <= 2'd0;
        C0_Reg_Data_e <= 32'd0;
    end
    else if (clear) begin
        srcA_00_e <= 32'd0;
        srcB_00_e <= 32'd0;
        rs_e <= 5'd0;
        rt_e <= 5'd0;
        rd_e <= 5'd0;
        sign_imm_e <= 32'd0;
        alu_control_e <= 4'd0;
        alu_src_e <= 1'd0;
        reg_dst_e <= 1'd0;
        reg_write_e <= 1'd0;
        mem_to_reg_e <= 1'd0;
        mem_write_e <= 1'd0;
        unsigned_instr_e <= 1'd0;
        shamt_e <= 5'd0;
        mem_data_size_e <= 2'd0;
        link_e <= 1'd0;
        pc_plus_4_e <= 32'd0;
        mult_en_e <= 1'd0;
        div_en_e <= 1'd0;
        hi_write_e <= 1'd0;
        lo_write_e <= 1'd0;
        hi_src_e <= 2'd0;
        lo_src_e <= 2'd0;
        C0_Reg_Data_e <= 32'd0;
    end
    else begin
        srcA_00_e <= srcA_00_d;
        srcB_00_e <= srcB_00_d;
        rs_e <= rs_d;
        rt_e <= rt_d;
        rd_e <= rd_d;
        sign_imm_e <= sign_imm_d;
        alu_control_e <= alu_control_d;
        alu_src_e <= alu_src_d;
        reg_dst_e <= reg_dst_d;
        reg_write_e <= reg_write_d;
        mem_to_reg_e <= mem_to_reg_d;
        mem_write_e <= mem_write_d;
        unsigned_instr_e <= unsigned_instr_d;
        shamt_e <= shamt_d;
        mem_data_size_e <= mem_data_size_d;
        link_e <= link_d;
        pc_plus_4_e <= pc_plus_4_d;
        mult_en_e <= mult_en_d;
        div_en_e <= div_en_d;
        hi_write_e <= hi_write_d;
        lo_write_e <= lo_write_d;
        hi_src_e <= hi_src_d;
        lo_src_e <= lo_src_d;
        C0_Reg_Data_e <= C0_Reg_Data_d;
    end
end

endmodule
