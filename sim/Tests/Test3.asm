#################################
# This Test is created to: 
#1-Verify Conditional & Unconditional Branch Instructions	
#bltz, bgez, blez, bgtz, beq, bne
#j, jal, jr, jalr
#2-Verify the Arithmatic-Logical Instructions	
#add, addu, sub, subu
#and, or, xor, nor
#slt, sltu
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
	addi $a0, $0, 0xFFFC				# $a0=-4
	addi $a1, $0, 0xFFF0				# $a1=-16
	addi $a2, $0, 0xFFF6				# $a2=-10
	addi $a3, $0, 0xFFD8				# $a3=-40
	jal signed_diffofsums				# $v0=[(-4)+(-16)]-[(-10)+(-40)]=30
	addi $s1, $0, 0x001E
	beq $v0, $s1, Next1
	j ERROR
	#################################
	Next1: addi $a0, $0, 0x2710         # $a0=10,000
	addi $a1, $0, 0x07D0                # $a1=2,000
	addi $a2, $0, 0x1B58                # $a2=7,000
	addi $a3, $0, 0x1B58                # $a3=7,000
	addi $s7, $0, unsigned_diffofsums   # $v0=[(10,000)+(2,000)]-[(7,000)+(7,000)]=-2,000
	jalr $s7
	addi $s2, $0, 0xF830
	bne $v0, $s2, ERROR
	#################################
	lui $a0, $0, 0xA5A5
	ori $a0, $a0, 0x5A5A				# $a0 = 0xA5A55A5A
	lui $a1, $0, 0xAAAA
	ori $a1, $a1, 0x5555				# $a1 = 0xAAAA5555
	jal logical_op
	lui $s3, $0, 0x5A5A
	ori $s3, $s3, 0xA5A5				# $s3 = 0x5A5AA5A5
	beq $v1, $s3, DONE
	#################################
	ERROR: addi $s0, $0, 0XDEAD
	j SKIP
	DONE:  addi $s0, $0, 0XD08E
	SKIP:  Iw $ra, 0($sp) 				# restore $ra from stack
	addi $sp, $sp, 4 					# restore stack pointer
	jr $ra 								# return to operating system
#################################
signed_diffofsums:
	addi $sp, $sp, −4 			# make space on stack to store one register
	sw $s0, 0($sp) 				# save $s0 on stack
	add $t0, $a0, $a1 			# $t0 = f + g
	add $t1, $a2, $a3 			# $t1 = h + i
	sub $s0, $t0, $t1 			# result = (f + g) − (h + i)
	add $v0, $s0, $0 			# put return value in $v0
	lw $s0, 0($sp) 				# restore $s0 from stack
	addi $sp, $sp, 4 			# deallocate stack space
	jr $ra 						# return to caller
unsigned_diffofsums:
	addu $t0, $a0, $a1 			# $t0 = f + g
	addu $t1, $a2, $a3 			# $t1 = h + i
	subu $v0, $t0, $t1 			# result = (f + g) − (h + i), put return value in $v0
	jr $ra 						# return to caller
logical_op:
	and $t0, $a0, $a1			# $a0 = 0xA5A55A5A, $a1 = 0xAAAA5555, $t0 = 0xA0A05050
	xor $t1, $a0, $t0 			# $t1 = 0x05050A0A
	or $t2, $t0, $t1			# $t2 = 0xA5A55A5A
	nor $t3, $t1, $t2			# $t3 = 0x5A5AA5A5
	slt $t4, $t0, $t1			# $t4 = 0x1
	bgtz $t4, OK							
	j END									
	OK: blez $t4, END						
	sltu $t5, $t0, $t1			# $t5 = 0x0
	bgez $t5, OK2							
	j END									
	OK2: bltz $t5, END 						
	addiu $v1, $t3, $0						
	jr $ra 									
	END:addiu $v1, $0, $0					
	jr $ra 									
	