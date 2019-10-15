.macro pega_registrador
	jal getchar
	move $a0, $t7			#copia t7 para a0, arg de get_reg
	jal get_reg
	bltz $v0, erro_instrucao	#se v0 < 0, erro, definido em get_reg
	move $t7, $v1
.end_macro

.macro acha_cifrao
	repeticao:
		jal getchar
		bne $v0, '$', repeticao
	addi $t7, $t7, -1
.end_macro

.macro opcodes

	move $t9, $ra

	jal getchar
	bne $v0, 'a', comeca_com_b	#se char nao for 'a', testa 'b'
	jal getchar
	bne $v0, 'd', n_depois_de_a	#se segundo char nao for 'd', testa 'n'
	jal getchar
	bne $v0, 'd', erro_instrucao	#se terceiro char nao for 'd' dnv,  erro
	jal getchar
	beq $v0, ' ', get_code_add	#se quarto char for ' ', eh add
	beq $v0, 'u', get_code_addu	#se quarto char for 'u', eh addu
	beq $v0, 'i', get_code_addi	#se quarto char for 'i', eh addi
	j erro_instrucao		#senao, erro

	n_depois_de_a:
		bne $v0, 'n', erro_instrucao	#se nao for 'n', erro
		jal getchar
		bne $v0, 'd', erro_instrucao	#se nao for 'd', erro
		jal getchar
		beq $v0, ' ', get_code_and	#se for ' ', eh and
		bne $v0, 'i', erro_instrucao	#se nao for 'i', erro
		jal getchar
		beq $v0, ' ', get_code_andi	#se for ' ', eh andi
		j erro_instrucao		#senao, erro

	comeca_com_b:
		bne $v0, 'b', comeca_com_c	#se nao for 'b', testa 'c'
		jal getchar
		bne $v0, 'e', g_depois_de_b	#se nao for 'e', testa 'g'
		jal getchar
		bne $v0, 'q', erro_instrucao	#se nao for 'q', erro
		jal getchar
		beq $v0, ' ', get_code_beq	#se for ' ', eh beq
		j erro_instrucao		#senao, erro

		g_depois_de_b:
			bne $v0, 'g', n_depois_de_b	#se nao for 'g', testa 'n'
			jal getchar 
			bne $v0, 'e', erro_instrucao	#se nao for 'e', erro
			jal getchar 
			bne $v0, 'z', erro_instrucao	#se nao for 'z', erro
			jal getchar
			beq $v0, ' ', get_code_bgez	#se for ' ', eh bgez
			j erro_instrucao		#senao, erro

		n_depois_de_b:
			bne $v0, 'n', erro_instrucao	#se nao for 'n'
			jal getchar 
			bne $v0, 'e', erro_instrucao	#se nao for 'e'
			beq $v0, ' ', get_code_bne	#se for ' ', eh bne
			j erro_instrucao		#senao, erro

	comeca_com_c:
		bne $v0, 'c', comeca_com_d	#se nao for 'c', testa 'd'
		jal getchar 
		bne $v0, 'l', erro_instrucao	#se nao for 'l', erro
		jal getchar 
		bne $v0, 'o', erro_instrucao	#se nao for 'o', erro
		jal getchar 
		beq $v0, ' ', get_code_clo	#se for ' ', eh clo
		j erro_instrucao		#senao, erro

	comeca_com_d:
		bne $v0, 'd', comeca_com_j	#se nao for 'd', testa 'j'
		jal getchar 
		bne $v0, 'i', erro_instrucao	#se nao for 'i', erro
		jal getchar 
		bne $v0, 'v', erro_instrucao	#se nao for 'v', erro
		jal getchar 
		beq $v0, ' ', get_code_div	#se for ' ' eh div
		j erro_instrucao		#senao, erro

	comeca_com_j:
		bne $v0, 'j', comeca_com_l	#se nao for 'j', testa 'l'
		jal getchar 
		beq $v0, ' ', get_code_j	#se for ' ' eh j
		beq $v0, 'r', testa_jr		#se for 'r', deve ser jr
		bne $v0, 'a', erro_instrucao	#se nao for 'a', erro
		jal getchar 
		bne $v0, 'l', erro_instrucao	#se nao for 'l', erro
		jal getchar 
		beq $v0, ' ', get_code_jal	#se for ' ' eh jal
		j erro_instrucao		#senao, erro

		testa_jr:
			jal getchar
			beq $v0, ' ', get_code_jr	#se for ' ', eh jr
			j erro_instrucao		#senao, erro

	comeca_com_l:
		bne $v0, 'l', comeca_com_m	#se nao for 'l', testa 'm'
		jal getchar
		bne $v0, 'i', u_depois_de_l	#se nao for 'i', testa 'u'
		jal getchar
		beq $v0, ' ', get_code_li	#se for ' ', eh li
		j erro_instrucao		#senao, erro

		u_depois_de_l:
			bne $v0, 'u', w_depois_de_l	#se nao for 'u', testa 'w'
			jal getchar
			bne $v0, 'i', erro_instrucao	#se nao for 'i', erro
			jal getchar
			beq $v0, ' ', get_code_lui	#se for ' ', eh lui
			j erro_instrucao		#senao, erro

		w_depois_de_l:
			bne $v0, 'w', erro_instrucao	#se nao for 'w', erro
			jal getchar
			beq $v0, ' ', get_code_lw	#se for ' ', eh lw
			j erro_instrucao		#senao, erro
	
	comeca_com_m:
		bne $v0, 'm', comeca_com_n	#se nao for 'm', testa 'n'
		jal getchar 
		bne $v0, 'a', f_depois_de_m	#se nao for 'a', testa 'f'
		jal getchar 
		bne $v0, 'd', erro_instrucao	#se nao for 'd', erro
		jal getchar 
		bne $v0, 'd', erro_instrucao	#se nao for 'd', erro
		jal getchar 
		beq $v0, ' ', get_code_madd	#se for ' ', eh madd
		j erro_instrucao		#senao, erro

		f_depois_de_m:
			bne $v0, 'f', u_depois_de_m	#se nao for 'f', testa 'u'
			jal getchar 
			bne $v0, 'h', l_depois_de_mf	#se nao for 'h'
			jal getchar 
			bne $v0, 'i', erro_instrucao	#se nao for 'i'
			jal getchar 
			beq $v0, ' ', get_code_mfhi	#se for ' ', eh mfhi
			j erro_instrucao		#senao, erro

		l_depois_de_mf:
			bne $v0, 'l', erro_instrucao	#se nao for 'l'
			jal getchar 
			bne $v0, 'o' u_depois_de_m	#se nao for 'o'
			jal getchar 
			beq $v0, ' ', get_code_mflo	#se for ' ', eh mflo
			j erro_instrucao		#senao, erro

		u_depois_de_m:
			bne $v0, 'u', erro_instrucao	#se nao for 'u'
			jal getchar
			bne $v0, 'l', erro_instrucao	#se nao for 'l'
			jal getchar 
			bne $v0, 't', erro_instrucao	#se nao for 't'
			jal getchar  
			beq $v0, ' ', get_code_mult	#se for ' ', eh mult
			j erro_instrucao		#senao, erro

	comeca_com_n: 
		bne $v0, 'n', comeca_com_o	#se nao for 'n', testa 'o'
		jal getchar
		bne $v0, 'o', erro_instrucao	#se nao for 'o', erro
		jal getchar 
		bne $v0, 'r', erro_instrucao	#se nao for 'r', erro
		jal getchar  
		beq $v0, ' ', get_code_nor	#se for ' ', eh nor
		j erro_instrucao		#senao, erro

	comeca_com_o: 
		bne $v0, 'o', comeca_com_s	#se nao for 'o', testa 's'
		jal getchar
		bne $v0, 'r', erro_instrucao	#se nao for 'r', erro
		jal getchar  
		beq $v0, ' ', get_code_or	#se for ' ', eh or
		bne $v0, 'i', erro_instrucao	#se nao for 'i', erro
		jal getchar  
		beq $v0, ' ', get_code_ori	#se for ' ', eh ori
		j erro_instrucao		#senao, erro

	comeca_com_s:
		bne $v0, 's', comeca_com_x	#se nao for 's', testa 'x'
		jal getchar
		bne $v0, 'l', r_depois_de_s	#se nao for 'l', testa 'r'
		jal getchar
		bne $v0, 'l', t_depois_de_sl	#se nao for 'l', testa 't'
		jal getchar
		beq $v0, ' ', get_code_sll	#se for ' ', eh sll
		j erro_instrucao		#senao, erro

		r_depois_de_s:
			bne $v0, 'r', u_depois_de_s	#se nao for 'r', testa 'u'
			jal getchar
			bne $v0, 'a', l_depois_de_sr	#se nao for 'a', testa 'l'
			jal getchar
			beq $v0, ' ', get_code_sra	#se for ' ' eh ADD
			bne $v0, 'v', erro_instrucao	#se nao for 'v'
			jal getchar
			beq $v0, ' ', get_code_srav	#se for ' ' eh ADD
			j erro_instrucao		#senao, erro

			l_depois_de_sr:
				bne $v0, 'l', erro_instrucao	#se nao for 'l'
				jal getchar
				beq $v0, ' ', get_code_srl	#se for ' ', eh srl
				j erro_instrucao		#senao, erro

		t_depois_de_sl:
			bne $v0, 't', erro_instrucao	#se nao for 't', erro
			jal getchar
			beq $v0, ' ', get_code_slt	#se for ' ', eh slt
			j erro_instrucao		#senao, erro

		u_depois_de_s:
			bne $v0, 'u', w_depois_de_s		#se nao for 'u'
			jal getchar
			bne $v0, 'b', erro_instrucao	#se nao for 'b'
			jal getchar
			beq $v0, ' ', get_code_sub	#se for ' ' eh sub
			bne $v0, 'u', u_depois_de_s	#se nao for 'u'
			jal getchar
			beq $v0, ' ', get_code_subu	#se for ' ' eh subu
			j erro_instrucao		#senao, erro

		w_depois_de_s:
			bne $v0, 'w', erro_instrucao	#se nao for 'w'
			jal getchar
			beq $v0, ' ', get_code_sw	#se for ' ', eh sw
			j erro_instrucao		#senao, erro

	comeca_com_x:
		bne $v0, 'x', erro_instrucao	#se nao for 'x', erro
		jal getchar
		bne $v0, 'o', erro_instrucao	#se nao for 'o', erro
		jal getchar
		bne $v0, 'r', erro_instrucao	#se nao for 'r', erro
		jal getchar
		beq $v0, ' ', get_code_xor	#se for ' ', eh xor
		bne $v0, 'i', erro_instrucao	#se nao for 'i', erro
		jal getchar
		beq $v0, ' ', get_code_xori	#se for ' ', eh xori
		j erro_instrucao		#senao, erro

	get_code_add:
		li $t0, 0x00000020
		pega_registrador
		sll $v0, $v0, 11
		or $t0, $t0, $v0
		acha_cifrao
		pega_registrador
		sll $v0, $v0, 21
		or $t0, $t0, $v0
		acha_cifrao
		pega_registrador
		sll $v0, $v0, 16
		or $v0, $t0, $v0
		jr $t9

	get_code_addu:
		li $t0, 0x00000021
		pega_registrador
		sll $v0, $v0, 11
		or $t0, $t0, $v0
		acha_cifrao
		pega_registrador
		sll $v0, $v0, 21
		or $t0, $t0, $v0
		acha_cifrao
		pega_registrador
		sll $v0, $v0, 16
		or $v0, $t0, $v0
		jr $t9

	get_code_addi:
		li $t0, 0x20000000
		jr $t9

	get_code_and:
		li $t0, 0x00000024
		pega_registrador
		sll $v0, $v0, 11
		or $t0, $t0, $v0
		acha_cifrao
		pega_registrador
		sll $v0, $v0, 21
		or $t0, $t0, $v0
		acha_cifrao
		pega_registrador
		sll $v0, $v0, 16
		or $v0, $t0, $v0
		jr $t9

	get_code_andi:
		li $t0, 0x10000000
		jr $t9

	get_code_beq:
		li $t0, 0x10000000
		jr $t9

	get_code_bgez:
		li $t0, 0x04010000
		jr $t9

	get_code_bne:
		li $t0, 0x14000000
		jr $t9

	get_code_clo:
		li $t0, 0x70000021
		pega_registrador
		sll $v0, $v0, 11
		or $t0, $t0, $v0
		acha_cifrao
		pega_registrador
		sll $v0, $v0, 21
		or $v0, $t0, $v0
		jr $t9

	get_code_div:
		li $t0, 0x0000001A
		pega_registrador
		sll $v0, $v0, 21
		or $t0, $t0, $v0
		acha_cifrao
		pega_registrador
		sll $v0, $v0, 16
		or $v0, $t0, $v0
		jr $t9

	get_code_j:
		li $t0, 0x08000000
		jr $t9

	get_code_jr:
		li $t0, 0x00000008
		pega_registrador
		sll $v0, $v0, 21
		or $v0, $t0, $v0
		jr $t9

	get_code_jal:
		li $t0, 0x0C000000
		jr $t9

	get_code_li:
		li $t0, 0x24000000
		jr $t9

	get_code_lui:
		li $t0, 0x3C000000
		jr $t9

	get_code_lw:
		li $t0, 0x8C000000
		jr $t9

	get_code_madd:
		li $t0, 0x70000000
		pega_registrador
		sll $v0, $v0, 21
		or $t0, $t0, $v0
		acha_cifrao
		pega_registrador
		sll $v0, $v0, 16
		or $v0, $t0, $v0
		jr $t9

	get_code_mfhi:
		li $t0, 0x00000010
		pega_registrador
		sll $v0, $v0, 11
		or $v0, $t0, $v0
		jr $t9

	get_code_mflo:
		li $t0, 0x00000012
		pega_registrador
		sll $v0, $v0, 11
		or $v0, $t0, $v0
		jr $t9

	get_code_mult:
		li $t0, 0x00000018
		pega_registrador
		sll $v0, $v0, 21
		or $t0, $t0, $v0
		acha_cifrao
		pega_registrador
		sll $v0, $v0, 16
		or $v0, $t0, $v0
		jr $t9

	get_code_nor:
		li $t0, 0x00000027
		pega_registrador
		sll $v0, $v0, 11
		or $t0, $t0, $v0
		acha_cifrao
		pega_registrador
		sll $v0, $v0, 21
		or $t0, $t0, $v0
		acha_cifrao
		pega_registrador
		sll $v0, $v0, 16
		or $v0, $t0, $v0
		jr $t9

	get_code_or:
		li $t0, 0x00000025
		pega_registrador
		sll $v0, $v0, 11
		or $t0, $t0, $v0
		acha_cifrao
		pega_registrador
		sll $v0, $v0, 21
		or $t0, $t0, $v0
		acha_cifrao
		pega_registrador
		sll $v0, $v0, 16
		or $v0, $t0, $v0
		jr $t9

	get_code_ori:
		li $t0, 0x34000000
		jr $t9

	get_code_sll:
		li $t0, 0
		jr $t9

	get_code_slt:
		li $t0, 0x0000002A
		pega_registrador
		sll $v0, $v0, 11
		or $t0, $t0, $v0
		acha_cifrao
		pega_registrador
		sll $v0, $v0, 21
		or $t0, $t0, $v0
		acha_cifrao
		pega_registrador
		sll $v0, $v0, 16
		or $v0, $t0, $v0
		jr $t9

	get_code_sra:
		li $t0, 0x00000003
		jr $t9

	get_code_srav:
		li $t0, 0x00000007
		pega_registrador
		sll $v0, $v0, 11
		or $t0, $t0, $v0
		acha_cifrao
		pega_registrador
		sll $v0, $v0, 16
		or $t0, $t0, $v0
		acha_cifrao
		pega_registrador
		sll $v0, $v0, 21
		or $v0, $t0, $v0
		jr $t9

	get_code_srl:
		li $t0, 0x00000002
		jr $t9

	get_code_sub:
		li $t0, 0x00000022
		pega_registrador
		sll $v0, $v0, 11
		or $t0, $t0, $v0
		acha_cifrao
		pega_registrador
		sll $v0, $v0, 21
		or $t0, $t0, $v0
		acha_cifrao
		pega_registrador
		sll $v0, $v0, 16
		or $v0, $t0, $v0
		jr $t9

	get_code_subu:
		li $t0, 0x00000023
		pega_registrador
		sll $v0, $v0, 11
		or $t0, $t0, $v0
		acha_cifrao
		pega_registrador
		sll $v0, $v0, 21
		or $t0, $t0, $v0
		acha_cifrao
		pega_registrador
		sll $v0, $v0, 16
		or $v0, $t0, $v0
		jr $t9

	get_code_sw:
		li $t0, 0xAC000000
		jr $t9

	get_code_xor:
		li $t0, 0x00000026
		pega_registrador
		sll $v0, $v0, 11
		or $t0, $t0, $v0
		acha_cifrao
		pega_registrador
		sll $v0, $v0, 21
		or $t0, $t0, $v0
		acha_cifrao
		pega_registrador
		sll $v0, $v0, 16
		or $v0, $t0, $v0
		jr $t9

	get_code_xori:
		li $t0, 0x38000000
		jr $t9


.end_macro