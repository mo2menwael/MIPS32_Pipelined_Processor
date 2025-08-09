addi $s0, $0, 0x0AF0 
addi $s1, $0, 0x04B0 
add $s2, $s0, $s1
addi $t0, $0, 0x0FA0 
beq $s2, $t0, NEXT1
j ERROR
NEXT1: sub $s3, $s0, $s1
addi $t1, $0, 0x0640 
beq $s3, $t1, NEXT2
j ERROR
NEXT2: and $s4, $s0, $s1
addi $t2, $0, 0x00B0 
beq $s4, $t2, NEXT3
j ERROR
NEXT3: or $s5, $s0, $s1
addi $t3, $0, 0x0EF0
beq $s5, $t3, NEXT4
j ERROR
NEXT4: addi $t4, $0, 0x0064  
sw $s0, 50($t4)
lw $t5, 50($t4)
beq $s0, $t5, DONE
ERROR: addi $s0, $0, 0XDEAD
j SKIP
DONE:  addi $s0, $0, 0XD08E
SKIP: nop