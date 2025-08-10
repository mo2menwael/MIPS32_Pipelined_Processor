module e2m_regs (
    input wire clk,
    input wire rst_n,
    input wire [31:0] alu_out_e,
    input wire [31:0] write_data_e,
    input wire [4:0] write_reg_e,
    input wire reg_write_e,
    input wire [2:0] mem_to_reg_e,
    input wire mem_write_e,
    input wire [1:0] mem_data_size_e,
    input wire link_e,
    input wire [31:0] pc_plus_4_e,
    input wire [63:0] mult_result_e,
    input wire [63:0] div_result_e,
    input wire hi_write_e,
    input wire lo_write_e,
    input wire [1:0] hi_src_e,
    input wire [1:0] lo_src_e,
    input wire [4:0] rd_e,
    input wire [31:0] C0_Reg_Data_e,
    output reg [31:0] alu_out_m,
    output reg [31:0] write_data_m,
    output reg [4:0] write_reg_m,
    output reg reg_write_m,
    output reg [2:0] mem_to_reg_m,
    output reg mem_write_m,
    output reg [1:0] mem_data_size_m,
    output reg link_m,
    output reg [31:0] pc_plus_4_m,
    output reg [63:0] mult_result_m,
    output reg [63:0] div_result_m,
    output reg hi_write_m,
    output reg lo_write_m,
    output reg [1:0] hi_src_m,
    output reg [1:0] lo_src_m,
    output reg [4:0] rd_m,
    output reg [31:0] C0_Reg_Data_m
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        alu_out_m <= 32'd0;
        write_data_m <= 32'd0;
        write_reg_m <= 5'd0;
        reg_write_m <= 1'd0;
        mem_to_reg_m <= 2'd0;
        mem_write_m <= 1'd0;
        mem_data_size_m <= 2'd0;
        link_m <= 1'd0;
        pc_plus_4_m <= 32'd0;
        mult_result_m <= 64'd0;
        div_result_m <= 64'd0;
        hi_write_m <= 1'd0;
        lo_write_m <= 1'd0;
        hi_src_m <= 2'd0;
        lo_src_m <= 2'd0;
        rd_m <= 5'd0;
        C0_Reg_Data_m <= 32'd0;
    end else begin
        alu_out_m <= alu_out_e;
        write_data_m <= write_data_e;
        write_reg_m <= write_reg_e;
        reg_write_m <= reg_write_e;
        mem_to_reg_m <= mem_to_reg_e;
        mem_write_m <= mem_write_e;
        mem_data_size_m <= mem_data_size_e;
        link_m <= link_e;
        pc_plus_4_m <= pc_plus_4_e;
        mult_result_m <= mult_result_e;
        div_result_m <= div_result_e;
        hi_write_m <= hi_write_e;
        lo_write_m <= lo_write_e;
        hi_src_m <= hi_src_e;
        lo_src_m <= lo_src_e;
        rd_m <= rd_e;
        C0_Reg_Data_m <= C0_Reg_Data_e;
    end
end

endmodule
