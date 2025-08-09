vlib work
vlog *.*v
vsim -voptargs=+acc work.MIPS_Pipelined_TB
do wave.do
run -all