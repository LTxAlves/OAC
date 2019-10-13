.macro opcodes

jal getchar
bne $v0, 'a',	seraB1	#se nnao for 'a' pula

jal getchar
bne $v0, 'd',	seraN2A	#se nnao for 'd' pula

jal getchar
bne $v0, 'd',	erro	#se nao for 'd', dnv,  pula

jal getchar
beq $v0, ' ',	print_add	#se for ' ' print ADD
beq $v0, 'u',	print_addu	#se nao for 'u', dnv,  pula
bne $v0, 'i',	print_addi	#se nao for 'i', dnv,  pula
#(erro???)

seraN2A:
bne $v0, 'n',	erro	#se nao for 'n' pula
jal getchar
bne $v0, 'd',	erro	#se nao for 'd', dnv,  pula
jal getchar
beq $v0, ' ',	print_and	#se for ' ' print AND
beq $v0, 'i',	print_andi	#se nao for 'i', dnv,  pula
#(erro???)


seraB1:
bne $v0, 'b',	seraC1	#se nnao for 'b' pula
jal getchar
bne $v0, 'e',	seraG2	#se nnao for 'e' pula

jal getchar
beq $v0, 'q',	print_beq	#se nao for 'q', dnv,  pula
#(erro??)

seraG2B:
bne $v0, 'g', seraN2B 		#se nao for 'g', dnv,  pula

jal getchar 
bne $v0, 'e', erro
jal getchar 
bne $v0, 'z', erro
jal getchar
beq $v0, ' ',	print_bgez	#se for ' ' print bgez
#erro

seraN2B:
bne $v0, 'n', erro 		#se nao for 'n', dnv,  pula
jal getchar 
bne $v0, 'e', erro 		#se nao for 'e', dnv,  pula
beq $v0, ' ',	print_bne	#se for ' ' print bgez
#erro


seraC1:
bne $v0, 'c', seraD1 		#se nao for 'c', dnv,  pula
jal getchar 
bne $v0, 'l', erro 		#se nao for 'l', dnv,  pula
jal getchar 
bne $v0, 'o', erro 		#se nao for 'o', dnv,  pula
jal getchar 
beq $v0, ' ',	print_clo	#se for ' ' print bgez
#erro

seraD1:
bne $v0, 'd', seraJ1 		#se nao for 'd', dnv,  pula
jal getchar 
bne $v0, 'i', erro 		#se nao for 'i', dnv,  pula
jal getchar 
bne $v0, 'v', erro 		#se nao for 'v', dnv,  pula
jal getchar 
beq $v0, ' ',	print_div	#se for ' ' print bgez
#erro
   

seraJ1:
bne $v0, 'd', seraL1 		#se nao for 'd', dnv,  pula
jal getchar 
beq $v0, ' ',	print_j		#se for ' ' print bgez
beq $v0, 'r',	print_jr	#se for 'r' print bgez
bne $v0, 'a', erro 		#se nao for 'a', dnv,  pula
jal getchar 
bne $v0, 'l', erro 		#se nao for 'l', dnv,  pula
jal getchar 
beq $v0, ' ',	print_jal	#se for ' ' print bgez
#erro

seraL1:
bne $v0, 'a', seraM1 		#se nao for 'l', dnv,  pula
jal getchar

  
seraM1:
bne $v0, 'm', seraN1 		#se nao for 'm', dnv,  pula
jal getchar 
bne $v0, 'a', seraF2M 		#se nao for 'a', dnv,  pula
jal getchar 
bne $v0, 'd', erro 		#se nao for 'd', dnv,  pula
jal getchar 
bne $v0, 'd', erro 		#se nao for 'd', dnv,  pula
jal getchar 
beq $v0, ' ',	print_madd	#se for ' ' print bgez
#erro

seraF2M:
bne $v0, 'f', seraU2M 		#se nao for 'f', dnv,  pula
jal getchar 
bne $v0, 'h', seraL3F 		#se nao for 'h', dnv,  pula
jal getchar 
bne $v0, 'i', erro 		#se nao for 'i', dnv,  pula
jal getchar 
beq $v0, ' ',	print_mfhi	#se for ' ' print bgez
#erro

seraL3F:
bne $v0, 'l', erro 		#se nao for 'l', dnv,  pula
jal getchar 
bne $v0, 'o' seraU2M 		#se nao for 'o', dnv,  pula
jal getchar 
beq $v0, ' ',	print_mflo	#se for ' ' print bgez
#erro

seraU2M:
bne $v0, 'u', erro 		#se nao for 'u', dnv,  pula
jal getchar
bne $v0, 'l', erro 		#se nao for 'l', dnv,  pula
jal getchar 
bne $v0, 't', erro 		#se nao for 't', dnv,  pula
jal getchar  
beq $v0, ' ',	print_mult	#se for ' ' print ADD
#erro??

seraN1: 
bne $v0, 'n', seraO1 		#se nao for 'n', dnv,  pula
jal getchar
bne $v0, 'o', erro 		#se nao for 'o', dnv,  pula
jal getchar 
bne $v0, 'a', erro 		#se nao for 'r', dnv,  pula
jal getchar  
beq $v0, ' ',	print_nor	#se for ' ' print ADD
#erro

seraO1: 
bne $v0, 'o', seraO1 		#se nao for 'o', dnv,  pula
jal getchar
bne $v0, 'a', erro 		#se nao for 'r', dnv,  pula
jal getchar  
beq $v0, ' ',	print_or	#se for ' ' print ADD
bne $v0, 'i', erro 		#se nao for 'i', dnv,  pula
jal getchar  
beq $v0, ' ',	print_nor	#se for ' ' print ADD
#erro

seraS1:
bne $v0, 's', seraX1 		#se nao for 's', dnv,  pula
jal getchar
bne $v0, 'l', seraR2S 		#se nao for 'l', dnv,  pula
jal getchar
bne $v0, 'l', seraT3L 		#se nao for 'l', dnv,  pula
jal getchar
beq $v0, ' ',	print_sll	#se for ' ' print ADD
#erro

seraT3L:
bne $v0, 's', erro 		#se nao for 't', dnv,  pula
jal getchar
beq $v0, ' ',	print_slt	#se for ' ' print ADD
#erro

seraR2S:
bne $v0, 's', seraU2S 		#se nao for 'r', dnv,  pula
jal getchar
bne $v0, 'l', seraL3S 		#se nao for 'a', dnv,  pula
jal getchar
beq $v0, ' ',	print_sra	#se for ' ' print ADD
bne $v0, 's', erro 		#se nao for 'v', dnv,  pula
jal getchar
beq $v0, ' ',	print_srav	#se for ' ' print ADD
#erro

seraL3S:
bne $v0, 'l', erro 		#se nao for 'l', dnv,  pula
jal getchar
beq $v0, ' ',	print_srl	#se for ' ' print ADD
#erro

seraU2S:
bne $v0, 'u', seraW2S 		#se nao for 'u', dnv,  pula
jal getchar
bne $v0, 'b', erro 		#se nao for 'b', dnv,  pula
jal getchar
beq $v0, ' ',	print_sub	#se for ' ' print sub
bne $v0, 'u', seraU2S 		#se nao for 'u, dnv,  pula
jal getchar
beq $v0, ' ',	print_subu	#se for ' ' print subu
#erro

seraW2S:
bne $v0, 'w', erro 		#se nao for 'w', dnv,  pula
jal getchar
beq $v0, ' ',	print_sw	#se for ' ' print ADD
#erro


seraX1:
bne $v0, 'x', erro 		#se nao for 'x', dnv,  pula
jal getchar
bne $v0, 'o', erro 		#se nao for 'o', dnv,  pula
jal getchar
bne $v0, 'r', erro 		#se nao for 'r', dnv,  pula
jal getchar
beq $v0, ' ',	print_xor	#se for ' ' print xor
bne $v0, 'i', erro 		#se nao for 'i', dnv,  pula
jal getchar
beq $v0, ' ',	print_xori	#se for ' ' print ADD
#erro


print_add:
addiu $s6, $zero, 0x00000020


print_addu:
addiu $s6, $zero, 0x00000021
print_addi:
addiu $s6, $zero, 0x20000000
print_and:
addiu $s6, $zero, 0x00000024
aprint_andi:
addiu $s6, $zero, 0x10000000
print_beq:
addiu $s6, $zero, 0x10000000
print_bgez:
addiu $s6, $zero, 0x04010000
print_bne:
addiu $s6, $zero, 0x14000000
print_clo:
addiu $s6, $zero, 0x70000021
print_div:
addiu $s6, $zero, 0x0000001A
print_j:
addiu $s6, $zero, 0x08000000
print_jr:
addiu $s6, $zero, 0x00000008
print_jal:
addiu $s6, $zero, 0x0C000000

print_madd:
addiu $s6, $zero, 0x70000000

print_mfhi:
addiu $s6, $zero, 0x00000010
print_mflo:
addiu $s6, $zero, 0x00000012
print_mult:
addiu $s6, $zero, 0x00000018

print_nor:
addiu $s6, $zero, 0x00000027

print_or:
addiu $s6, $zero, 0x00000025
print_ori:
addiu $s5, $zero, 0x34000000

print_sll:
addiu $s6, $zero, $zero
print_slt:
addiu $s6, $zero, 0x0000002A

print_sra:
addiu $s6, $zero, 0x00000003
print_srav:
addiu $s6, $zero, 0x00000007
print_srl:
addiu $s6, $zero, 0x00000002
print_sub:
addiu $s6, $zero, 0x00000022
print_subu:
addiu $s6, $zero, 0x00000023
print_sw:
addiu $s6, $zero, 0xAC000000
print_xor:

addiu $s6, $zero, 0x00000026
print_xori:
addiu $s6, $zero, 0x38000000

.end_macro