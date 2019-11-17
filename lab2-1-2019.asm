.data 
a: .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
.text
li $t1, 0x10010000
lw $t0, 0($t1)
lw $t2, 4($t1)
add $t3, $t1, $t0
clo $t1, $t2
srav $t7, $t3, $t2
sub $t3, $t1, $t0
and $t3, $t1, $t1
or $t3, $t0, $t1
nor $t3, $t1, $zero
xor $t3, $t1, $t0
li $t1, 0x10010000
sw $t3, 12($t1)
beq $t1,$t1, Label
Volta: slt $t5, $t1, $zero
j Pula
Label: j Volta
Pula:  addu $t3, $t3, $t3
subu $t5, $t5, $t5
srl $t8, $t1, 4
sll $t5, $t8, 30
addi $t5, $t2, 400
andi $t5, $t5, -22
ori $t5, $t3, 20
xori $t5, $t5, 100
mult $t5, $t3
mflo $t1
mfhi $t5
div $t5, $t3
li $t4, 0x00400000
mflo $t1
mfhi $t5
bgez $t1, Label
jr $t4

