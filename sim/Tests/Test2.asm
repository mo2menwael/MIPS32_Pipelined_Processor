#################################
# Kernel will initalize $gp and $sp first to specify our used Memory.
addi $sp, $0, 0x7FFC	# $sp is located in the Reg file at address 29
addi $gp, $0, 0x1080  	# $gp is located in the Reg file at address 28
jal 0x0400
#################################
.data
	f:
	g:
	y:
.text
	main:
		addi $sp, $sp, −4 				# $sp is located in the Reg file at address 29
		sw $ra, 0($sp) 					# store $ra (return address of OS before starting the main funtion) on stack
		addi $a0, $0, 2 				# $a0 = 2
		sw $a0, f 						# f = 2                	# Assembler shuld locate f at address 0x1000 = 0xFF80($gp)
		addi $a1, $0, 3 				# $a1 = 3
		sw $a1, g 						# g = 3					# Assembler shuld locate g at address 0x1004 = 0xFF84($gp)
		jal sum 						# call sum function
		sw $v0, y 						# y = sum(f, g)			# Assembler shuld locate y at address 0x1008 = 0xFF88($gp)
		addiu $t0, $0, 5
		beq $v0, $t0, DONE
		ERROR: addi $s0, $0, 0XDEAD
		j SKIP
		DONE:  addi $s0, $0, 0XD08E
		SKIP:  Iw $ra, 0($sp) 			# restore $ra from stack
		addi $sp, $sp, 4 				# restore stack pointer
		jr $ra 							# return to operating system
	sum:		
		add $v0, $a0, $a1 				# $v0 = a + b
		jr $ra 							# return to caller
	