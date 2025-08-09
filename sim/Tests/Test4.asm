#################################
# This Test is created to verify the Arithmatic-Logical with Immediate Instructions:
#   slti, sltiu, andi, xori, ori
#   addi, addiu
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
	ori $a0, $a0, 0x5A5A				# $a0 = 0xA5A55A5A (unsinged=+2,779,077,210) or (singed=-0x5A5A_A5A6=-1,515,890,086)
	jal arith_add_imm
	bgtz $v0, NEXT
	j ERROR
	NEXT:jal logical_op_imm
	lui $s3, 0xFFFF
	ori $s3, $s3, 0xA5A5				# $s3 = 0xFFFFA5A5
	beq $v1, $s3, DONE
	#################################
	ERROR: addi $s0, $0, 0XDEAD
	j SKIP
	DONE:  addi $s0, $0, 0XD08E
	SKIP:  Iw $ra, 0($sp) 				# restore $ra from stack
	addi $sp, $sp, 4 					# restore stack pointer
	jr $ra 								# return to operating system
#################################
arith_add_imm:
	addi  $t0, $a0, 0xAAAA 			# $t0 = 0xA5A5_5A5A+0xFFFF_AAAA = 0x1_A5A5_0504,	# $t0 = (-1,515,890,086+(-21,846)) = -1,515,911,932 = -0x5A5A_FAFC)		
	addiu $t1, $a0, 0xAAAA 			# $t1 = 0xA5A5_5A5A+0xFFFF_AAAA = 0x1_A5A5_0504,	# $t1 = (+2,779,077,210+4,294,945,450 = 5,810,835,535)
	lui $t2, 0xA5A5
	ori $t2, $t2, 0x0504
	beq $t0, $t2, NEXT_ADD
	j END_ADD
	NEXT_ADD: beq $t1, $t2, NEXT2_ADD
	j END_ADD
	NEXT2_ADD: addiu $v0, $t3, 0x0001
	jr $ra 
	END_ADD:addiu $v0, $0, 0x0000
	jr $ra
logical_op_imm:
	andi $t0, $a0, 0x5555			# $a0 = 0xA5A55A5A, $t0 = 0x00005050
	xori $t1, $t0, 0x5A5A 			# $t1 = 0x00000A0A
	ori $t2, $t1, 0x5050			# $t2 = 0x00005A5A
	nor $t3, $t1, $t2				# $t3 = 0xFFFFA5A5
	slti $t4, $t0, 0x5A5A			# $t4 = 0x1
	bgtz $t4, OK
	j END
	OK: sltiu $t5, $t0, 0xFFFF		# $t5 = 0x0
	bgez $t5, OK2
	j END
	OK2: addu $v1, $t3, $0
	jr $ra 
	END:addu $v1, $0, $0
	jr $ra 	
	