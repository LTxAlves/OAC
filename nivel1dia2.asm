.data
a: .word 1000, 2000, 3000
b: .word 1000000, 2000000, 3000000
c: .word 1000000000, 2000000000, 3000000000

.text
li $t0, 0x10010000
lw $t1, 0($t0)
lw $t2, 12($t0)
lw $t3, 24($t0)
add $t1, $t2, $t3
srav $t2, $t1, $t3
madd $t1, $t3
mult $t1, $t2
mflo $t1
mfhi $t2 
mult $t2, $t3
mflo $t2
mfhi $t3 
mult $t1, $t2
mflo $t1
mfhi $t2
mult $t2, $t3
mflo $t2
mfhi $t3  
clo $t1, $t2
clo $t4, $t3
add $t2, $t0, $t1
add $t3, $t1, $t2
add $t3, $t3, $t3
add $t3, $t3, $t3
