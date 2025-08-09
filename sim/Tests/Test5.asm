#################################
# This Test is created to verify the Shift Instructions:
#   sll, srl, sra, sllv, srlv, srav
#################################
# Kernel will initalize $gp and $sp first to specify our used Memory.
addi $sp, $0, 0x7FFC			# $sp is located in the Reg file at address 29
addi $gp, $0, 0x1080  			# $gp is located in the Reg file at address 28
jal main						# main is located at 0x0400
#################################
main:
	addi $sp, $sp, −4 					# Move $sp one location to store thre return address.
	sw $ra, 0($sp) 						# store $ra (return address of OS before starting the main funtion) on stack
	#################################
	lui $a0, 0xA5A5
	ori $a0, $a0, 0x5A5A				# $a0 = 0xA5A55A5A
	addi $a1, $0, 0xACAC				# $a1 = 0x0000ACAC 	=> 	$a1[4:0] = 12 
	jal shift_instr
	bgtz $v0, DONE
	#################################
	addi $s0, $0, 0XDEAD
	j SKIP
	DONE:  addi $s0, $0, 0XD08E
	SKIP:  Iw $ra, 0($sp) 				# restore $ra from stack
	addi $sp, $sp, 4 					# restore stack pointer
	jr $ra 								# return to operating system
#################################
shift_instr:
	sll  $t0, $a0, 12         	# $t0 = 0xA5A5_5A5A <<  12 = 0x55A5_A000
	sllv $t1, $a0, $a1          # $t1 = 0xA5A5_5A5A <<  12 = 0x55A5_A000
	lui  $t2, 0x55A5
	ori  $t2, $t2, 0xA000		# $t2 = 0x55A5_A000
	beq  $t2, $t0, SH_NEXT1
	j END
	SH_NEXT1: beq  $t2, $t1, SH_NEXT2
	j END
	#################################
	SH_NEXT2:
	srl  $t0, $a0, 12         	# $t0 = 0xA5A5_5A5A >>  12 = 0x000A_5A55
	srlv $t1, $a0, $a1          # $t1 = 0xA5A5_5A5A >>  12 = 0x000A_5A55
	lui  $t2, 0x000A
	ori  $t2, $t2, 0x5A55		# $t2 = 0x000A_5A55
	beq  $t2, $t0, SH_NEXT3
	j END
	SH_NEXT3: beq  $t2, $t1, SH_NEXT4
	j END
	#################################
	SH_NEXT4:
	sra  $t0, $a0, 12         	# $t0 = 0xA5A5_5A5A >>> 12 = 0xFFFA_5A55
	srav $t1, $a0, $a1          # $t1 = 0xA5A5_5A5A >>> 12 = 0xFFFA_5A55
	lui  $t2, 0xFFFA
	ori  $t2, $t2, 0x5A55		# $t2 = 0xFFFA_5A55
	beq  $t2, $t0, SH_NEXT5
	j END
	SH_NEXT5: beq  $t2, $t1, SH_DONE
	j END
	#################################
	SH_DONE: addiu $v0, $0, 0x0001
	jr $ra 
	END:addu $v0, $0, $0
	jr $ra 	
	