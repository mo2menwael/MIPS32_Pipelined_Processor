#################################
# This Test is created to verify the Branch Prediction Unit:
#################################
# Kernel will initalize $gp and $sp first to specify our used Memory.
addi $sp, $0, 0x7FFC				# $sp is located in the Reg file at address 29
addi $gp, $0, 0x1080  				# $gp is located in the Reg file at address 28
jal main							# main is located at 0x0400
#################################
main:
	addi t0, $0, 0x03E8  			# i_max = 1,000
	addi t1, $0, 0x0004  			# j_max = 4
	addi s0, $0, 0x0000  			# i == 0
	Outer_Loop:
		beq s0, t0, exit  			# i ?= i_max
		addi s1, $0, 0x0000  		# j == 0
		Inner_Loop:
			beq s1, t1, exit_in  	# j ?= j_max
			addi s2, s2, 0x0001  	# Count = Count+1;
			addi s1, s1, 0x0001  	# j++
			j Inner_Loop		 	# 
		exit_in:
		addi s0, s0, 0x0001  		# i++
		j Outer_Loop		 		#
	exit:
	#################################
	addi t2, $0, 0x0FA0  			# Count_max = 4,000
	beq s2, t2, DONE  			
	addiu $s0, $0, 0XDEAD
	j SKIP
	DONE:  addiu $s0, $0, 0XD08E
	SKIP:  jr $ra 					# return to operating system
#################################
