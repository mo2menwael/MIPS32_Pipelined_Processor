module f2d_regs (
    input wire clk,
    input wire rst_n,
    input wire clear,
    input wire enable,
    input wire [31:0] instr_f,
    input wire [31:0] pc_plus_4_f,
    input wire [31:0] pc_f,
    output reg [31:0] instr_d,
    output reg [31:0] pc_plus_4_d,
    output reg [31:0] pc_d
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin             // Don't use (!rst_n | clear) to avoid error in synthesis
        instr_d <= 32'd0;
        pc_plus_4_d <= 32'd0;
        pc_d <= 32'd0;
    end else if (clear) begin
        instr_d <= 32'd0;
        pc_plus_4_d <= 32'd0;
        pc_d <= 32'd0;
    end else if (enable & !clear) begin
        instr_d <= instr_f;
        pc_plus_4_d <= pc_plus_4_f;
        pc_d <= pc_f;
    end
end

endmodule
