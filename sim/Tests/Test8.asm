#################################
# This Test is created to verify the Exception Unit:
#################################
# Kernel will initalize $gp and $sp first to specify our used Memory.
addi $sp, $0, 0x7FFC				# $sp is located in the Reg file at address 29
addi $gp, $0, 0x1080  				# $gp is located in the Reg file at address 28
jal main							# main is located at 0x0400
#################################
main:
	addi $t0, $0, 0x03E8  			# $t0 = 1,000
	addi $t1, $0, 0x0000  			# $t1 = 0
	div $t0, $t1					# Exception[1]: divide by zero
	mfhi $s1
	mflo $s2
	lui $t3, 0xFFFF
	ori $t3, $t3, 0xFFFF
	bne $s1, $t3, ERROR
	bne $s2, $t3, ERROR
	#################################
	lui $t0, 0x7FFF
	ori $t0, $t0, 0xFFFF
	addu $s1, $t0, $t0				# No-Exception:
	lui $t1, 0xFFFF
	ori $t1, $t1, 0xFFFE
	bne $s1, $t1, ERROR
	add $s2, $t0, $t0				# Exception[2]: arithmetic overflow
	bne $s2, $0, ERROR
    #################################
    0000003F	                    # Exception[3]: undefined instruction
    addiu $s7, $0, 0x0001 
    beq $s7, $s6, DONE
	#################################
	ERROR:addiu $s0, $0, 0XDEAD
	j SKIP
	DONE:  addiu $s0, $0, 0XD08E
	SKIP:  jr $ra 					# return to operating system
#################################
exception_handler:
	mfc0 $t0, Cause
	lui $t1, 0x0000
	ori $t1, $t1, 0x0024
	lui $t2, 0x0000
	ori $t2, $t2, 0x0028
	lui $t3, 0x0000
	ori $t3, $t3, 0x0030
	bne $t0, $t1, next_check			#Exception_Handler[1]: divide by zero
	lui $t4, 0xFFFF
	ori $t4, $t4, 0FFFF
	mthi $t4
	mtlo $t4
	mfc0 $k0, EPC
	jr $k0
	next_check:
		bne $t0, $t2, next_check2		#Exception_Handler[2]: undefined instruction
        addiu $s6, $0, 0x0001
		mfc0 $k0, EPC
		jr $k0
	next_check2:
		bne $t0, $t3, skip_handler		#Exception_Handler[3]: arithmetic overflow
		add $s2, $0, $0
	skip_handler:
		mfc0 $k0, EPC
		jr $k0
 	