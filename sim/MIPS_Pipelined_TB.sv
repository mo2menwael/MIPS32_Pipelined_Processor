// verilog_lint: waive-start explicit-parameter-storage-type
// verilog_lint: waive-start parameter-name-style

`timescale 1ps/1ps

module MIPS_Pipelined_TB ();

logic clk, rst_n;
logic [3:0] led;

MIPS_Pipelined_Top dut (
    .clk(clk),
    .rst_n(rst_n),
    .led(led)
);

parameter clock_period = 20;
always #(clock_period/2) clk = ~clk;

initial begin
    $dumpfile("MIPS_Pipelined_TB.vcd");
    $dumpvars(0, MIPS_Pipelined_TB);

    clk = 0;
    rst_n = 0;
    #clock_period;
    rst_n = 1;

    // Initialize memory with some test instructions or load from file
    $readmemh("Tests/Test6.hex", dut.instr_mem_inst.mem);

    // Run for a sufficient time to execute all instructions
    #2000;
    //#(28050 * clock_period);   // For test 7 only

    $stop;
end

endmodule
