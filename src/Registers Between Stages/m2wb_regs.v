module m2wb_regs (
    input wire clk,
    input wire rst_n,
    input wire [31:0] alu_out_m,
    input wire [31:0] read_data_m,
    input wire [4:0] write_reg_m,
    input wire reg_write_m,
    input wire [1:0] mem_to_reg_m,
    input wire link_m,
    input wire [31:0] pc_plus_4_m,
    input wire [31:0] hi_out_m,
    input wire [31:0] lo_out_m,
    output reg [31:0] alu_out_wb,
    output reg [31:0] read_data_wb,
    output reg [4:0] write_reg_wb,
    output reg reg_write_wb,
    output reg [1:0] mem_to_reg_wb,
    output reg link_wb,
    output reg [31:0] pc_plus_4_wb,
    output reg [31:0] hi_out_wb,
    output reg [31:0] lo_out_wb
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        alu_out_wb <= 32'd0;
        read_data_wb <= 32'd0;
        write_reg_wb <= 5'd0;
        reg_write_wb <= 1'd0;
        mem_to_reg_wb <= 1'd0;
        link_wb <= 1'd0;
        pc_plus_4_wb <= 32'd0;
        hi_out_wb <= 32'd0;
        lo_out_wb <= 32'd0;
    end else begin
        alu_out_wb <= alu_out_m;
        read_data_wb <= read_data_m;
        write_reg_wb <= write_reg_m;
        reg_write_wb <= reg_write_m;
        mem_to_reg_wb <= mem_to_reg_m;
        link_wb <= link_m;
        pc_plus_4_wb <= pc_plus_4_m;
        hi_out_wb <= hi_out_m;
        lo_out_wb <= lo_out_m;
    end
end

endmodule
