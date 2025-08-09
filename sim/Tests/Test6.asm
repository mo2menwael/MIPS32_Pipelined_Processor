#################################
# This Test is created to verify the Multiplication-Division Unit:
#################################
# Kernel will initalize $gp and $sp first to specify our used Memory.
addi $sp, $0, 0x7FFC				# $sp is located in the Reg file at address 29
addi $gp, $0, 0x1080  				# $gp is located in the Reg file at address 28
jal main							# main is located at 0x0400
#################################
main:  
	lui $t0, 0xAAAA  			    # 
	ori $t0, $t0, 0x5555  			# $t0 = 0xAAAA_5555 = 2,863,289,685 (unsigned) or -1,431,677,611 (signed)
	lui $t1, 0x3C3C  			    # 
	ori $t1, $t1, 0xC3C3  			# $t1 = 0x3C3C_C3C3 = 1,010,615,235
	lui $t2, 0xAAAA  			    # 
	ori $t2, $t2, 0xBEBF  			# $t2 = 0xAAAA_BEBF 		#Low_Value
	lui $t3, 0xEBEB  			    # 
	ori $t3, $t3, 0xAAAA  			# $t3 = 0xEBEB_AAAA  		#Signed_High_Value
	lui $t4, 0x2828  			    # 
	ori $t4, $t4, 0x6E6D  			# $t4 = 0x2828_6E6D  		#Unsigned_High_Value
	#################################
	mul $s0, $t0, $t1				# $t0, $t1 = 0xEBEB_AAAA_AAAA_BEBF  => $s0 = 0xAAAA_BEBF
	beq $s0, $t2, NEXT1
	j ERROR
    NEXT1: mult $t0, $t1 			# {[hi], [lo]} = $s0 * $s1 = 0xEBEB_AAAA_AAAA_BEBF
	mfhi $s1                        # $s1 = [hi] = 0xEBEB_AAAA
    mflo $s2                        # $s2 = [lo] = 0xAAAA_BEBF
    beq $s1, $t3, NEXT2
	j ERROR
    NEXT2: beq $s2, $t2, NEXT3
	j ERROR
    NEXT3: multu $t0, $t1 			# {[hi], [lo]} = $s0 * $s1 = 0x2828_6E6D_AAAA_BEBF 
	mfhi $s3                        # $s3 = [hi] = 0x2828_6E6D
    mflo $s4                        # $s4 = [lo] = 0xAAAA_BEBF
    beq $s3, $t4, NEXT4
	j ERROR
    NEXT4: beq $s4, $t2, NEXT5
	j ERROR
	#################################
    NEXT5:  andi $t1, $t1, 0x00FF  	# $t1 = 0x0000_00C3 
	lui $t2, 0xFFFF  			    # 
	ori $t2, $t2, 0xFFA5  			# $t2 = 0xFFFF_FFA5 		#Signed_High_Value
	lui $t3, 0xFF8F  			    # 
	ori $t3, $t3, 0xF890  			# $t3 = 0xFF8F_F890 		#Signed_Low_Value
	lui $t4, 0x0000  			    # 
	ori $t4, $t4, 0x00A5  			# $t4 = 0x0000_00A5  		#Unsigned_High_Value
	lui $t5, 0x00E0  			    # 
	ori $t5, $t5, 0x0D90  			# $t5 = 0x00E0_0D90  		#Unsigned_Low_Value
	#################################
	div $t0, $t1					# [lo] = $t0/$t1 = 0xFF8F_F890, [hi] = $t0%$t1 = 0xFFFF_FFA5
	mfhi $s2                        # $s2 = [hi] = 0xFFFF_FFA5
    mflo $s3                        # $s3 = [lo] = 0xFF8F_F890
    beq $s2, $t2, NEXT6
	j ERROR
    NEXT6: beq $s3, $t3, NEXT7
	j ERROR
    NEXT7: divu $t0, $t1			# [lo] = $t0/$t1 = 0x00E0_0D90, [hi] = $t0%$t1 = 0x0000_00A5
	mfhi $s4                        # $s4 = [hi] = 0x0000_00A5
    mflo $s5                        # $s5 = [lo] = 0x00E0_0D90
    beq $s4, $t4, NEXT8
	j ERROR
    NEXT8: beq $s5, $t5, NEXT9
	j ERROR
	#################################			
    NEXT9: mthi $s5                 #[hi] = $s5 = 0x00E0_0D90
    mtlo $s4                        #[lo] = $s4 = 0x0000_00A5
	mfhi $s6                        # $s6 = [hi] = 0x00E0_0D90
    mflo $s7                        # $s7 = [lo] = 0x0000_00A5
	beq $s5, $s6, NEXT10
	j ERROR
    NEXT10: beq $s4, $s7, DONE
	#################################			
	ERROR: addiu $s0, $0, 0XDEAD
	j SKIP
	DONE:  addiu $s0, $0, 0XD08E
	SKIP:  jr $ra 					# return to operating system
#################################
