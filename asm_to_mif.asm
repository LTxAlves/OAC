.include "opcode-funcao.asm"

	.data
path_arq: .asciiz "example_saida.asm" #trocar nome/colocar caminho relativo ao executavel do MARS
arq_saida_text: .asciiz "saida_text.mif"
arq_saida_data: .asciiz "saida_data.mif"
arq_in: .space 1024
erro_ao_abrir: .asciiz "Erro ao abrir arquivo!\n"
aberto_sucesso: .asciiz "Arquivo aberto com sucesso!\n"
erro_ao_ler: .asciiz "Erro ao ler do arquivo!\n"
fim_do_arquivo: .asciiz "Fim do arquivo encontrado!\n"
erro_de_instrucao: .asciiz "Erro de instrucao no arquivo"
arq_data_comeco: .ascii "DEPTH\t\t= 16384;\nWIDTH\t\t= 32;\nADDRESS_RADIX\t= HEX;\nDATA_RADIX\t= HEX;\nCONTENT\nBEGIN\n\n"
arq_text_comeco: .ascii "DEPTH\t\t= 4096;\nWIDTH\t\t= 32;\nADDRESS_RADIX\t= HEX;\nDATA_RADIX\t= HEX;\nCONTENT\nBEGIN\n\n"
arqs_end: .ascii "\n\nEND;\n"
instrucao_ascii: .space 8

	.text
main:
	li $v0, 13		#abrir arquivo
	la $a0, path_arq	#endereco da string com nome do arquivo
	li $a1, 0		#abrir para leitura
	li $a2, 0		#modo (ignorado no MARS)
	syscall
	move $s0, $v0		#salva descritor do arquivo
	blez $s0, erro_abertura	#se s0 <= 0, erro de abertura

	li $v0, 4		#imprimir string
	la $a0, aberto_sucesso	#endereco da string
	syscall

	move $a0, $s0		#descritor do arquivo como argumento
	jal le_arq
	move $s1, $v0		#quantidade de caracteres no espaco de memoria
	move $a0, $s0		#carrega descritor do arquivo
	jal fecha_arquivo
	move $s0, $zero
	la $t7, arq_in		#salvar ponteiro para o primeiro byte/char
	add $s1, $s1, $t7	#salvar endereco do final do arquivo

procura_ponto:
	lbu $t0, ($t7)			#carrega o caractere em t7
	beq $t0, '.', data_ou_text	#se t0 == '.', deve ser data ou text 
	addi $t7, $t7, 1		#proximo byte/char
	bge $t7, $s1, fim_prog		#se t7 >= s1, acabaram os caracteres (e o programa)
	j procura_ponto			#continua procurando o caractere '.'

procura_dois_pontos:
	move $t1, $ra		#t1 recebe ra
	jal getchar		#prox char
	move $ra, $t1		#ra recebe seu valor anterior
	bne $v0, ':', procura_dois_pontos	#se v0 != ':', continua procura
	jr $ra			#se encontrou ':', retorna a caller

pula_nova_linha:
	move $t1, $ra		#t1 recebe ra
	jal getchar		#prox char
	move $ra, $t1		#ra recebe seu valor anterior
	beq $v0, '\n', pula_nova_linha	#se v0 == '\n', continua pulando chars
	addi $t7, $t7, -1	#retorna ponteiro ao ultimo '\n' encontrado
	jr $ra			#retorna a caller

procura_word:
	move $t1, $ra			#t1 recebe ra
	jal getchar			#prox char
	bne $v0, ' ', erro_instrucao	#depois de ':' devemos ter ' '
	jal getchar
	bne $v0, '.', erro_instrucao	#prox char deve ser '.'
	jal getchar
	bne $v0, 'w', erro_instrucao	#prox char deve ser 'w'
	jal getchar
	bne $v0, 'o', erro_instrucao	#prox char deve ser 'o'
	jal getchar
	bne $v0, 'r', erro_instrucao	#prox char deve ser 'r'
	jal getchar
	bne $v0, 'd', erro_instrucao	#prox char deve ser 'd'
	jr $t1

getchar:
	addi $t7, $t7, 1	#proximo byte/char
	bge $t7, $s1, fim_prog	#se t7 == s1, acabaram os caracteres (e o programa)
	lbu $v0, ($t7)		#v0 recebe char para retorno
	jr $ra			#retorna a caller

data_ou_text:
	jal getchar
	beq $v0, 'd', area_data	#se depois de '.' temos 'd', eh data
	beq $v0, 't', area_text	#se depois de '.' temos 't', eh text
	j erro_instrucao	#se depois de '.' nao temos 'd' nem 't', eh erro

area_data:
	jal getchar
	bne $v0, 'a', erro_instrucao	#proximo char deve ser 'a'
	jal getchar
	bne $v0, 't', erro_instrucao	#proximo char deve ser 't'
	jal getchar
	bne $v0, 'a', erro_instrucao	#proximo char deve ser 'a'
	jal getchar
	bne $v0, '\n', erro_instrucao	#proximo char deve ser '\n'

	li $v0, 13		#abrir arquivo
	la $a0, arq_saida_data	#endereco da string com nome do arquivo
	li $a1, 1		#abrir para escrita
	li $a2, 0		#modo (ignorado no MARS)
	syscall
	blez $v0, erro_abertura	#se v0 <= 0, erro de abertura
	move $s2, $v0		#salvar descritor

	move $a0, $s2		#a0 com descritor
	li $v0, 15		#escrever em arquivo
	la $a1, arq_data_comeco	#o que escrever
	li $a2, 83		#num de caracteres a escrever
	syscall

	data:
		addi $t7, $t7, -1	#retorna o ponteiro pro char anterior (ultimo '\n')
		jal pula_nova_linha	#pula todos '\n' encontrados (precisa de ao menos 1)
		jal procura_dois_pontos	#pula tudo ate encontrar ':'
		jal procura_word	#procura por " .word" depois de ':'

		jal getchar
		bne $v0, ' ', erro_instrucao	#depois de ".word" deve haver espaco
		jal getchar

		get_word:
			move $a0, $t7		#ponteiro para char atual como argumento
			jal uma_word
			move $t7, $v0
			bge $t7, $s1, fim_data
			move $a0, $v1

			lbu $t0, ($t7)
			bne $t0, '\n', pula_separadores
			addi $t7, $t7, -1

			pula_separadores:
				jal getchar			#prox char
				beq $v0, ' ', pula_separadores	#se char eh ' ', pula mais
				beq $v0, ',', pula_separadores	#se char eh ',', pula mais
				beq $v0, '\t', pula_separadores	#se char eh '\t', pula mais
				bne $v0, '\n', get_word		#se char nao eh '\n' nem separador, deve ser num

			fim_word:			#se nao eh nenhum, continua
				jal getchar		#prox char
				beq $v0, '.', fim_data	#se '.', deve ser ".text"
				bne $v0, '\n', data	#depois de pular separadores e '.', se nao eh '\n', eh mais um numero
				j fim_word

			fim_data:
				li $v0, 15		#escrever em arq
				move $a0, $s2		#descritor do arq
				la $a1, arqs_end	#o que escrever
				li $a2, 7		#quant de caracteres
				syscall
				jal fecha_arquivo
				move $s2, $zero
				j procura_ponto

uma_word:	#a0 com endereco do char atual
		#retorna v0 com end do ultimo char lido e v1 com valor da word (-1 se erro)
	move $t1, $zero			#zera para calcular num atual
	lbu $t0, ($a0)			#carregar o caractere apontado
	seq $t3, $t0, '-'		#flag de nums negativos
	beqz $t3, num_positivo		#se eh '-', pula um char
	addi $a0, $a0, 1
	lbu $t0, ($a0)			#garante que '-' nao vai ser passado como num
	num_positivo:
		bne $t0, '0', testa_decimal	#se o char for != '0', nao eh hexadecimal
		lbu $t0, 1($a0)			#2o char apontado
		beq $t0, 'x', testa_hex		#se 2o char eh 'x'
		beq $t0, 'X', testa_hex		#ou 'X', pula para hexadecimal

	testa_decimal:
		lbu $t0, ($a0)
		bgt $t0, '9', erro_instrucao	#se $t0 > '9', erro
		blt $t0, '0', fim_numero	#se $t0 < '0', testa fim
		addi $t0, $t0, -48		#t0 = atoi(t0)
		sll $t2, $t1, 3			#t2 = 8*t1
		add $t2, $t2, $t1		#t2 = t2 + t1
		add $t2, $t2, $t1		#t2 = t2 + t1
		move $t1, $t2			#t1 = t2 (== 8*t1 + t1 + t1 == 10*t1)
		add $t1, $t1, $t0		#t1 = t1 + t0
		addi $a0, $a0, 1		#prox char
		j testa_decimal

		fim_numero:
			beq $t0, ' ', sem_erro		#se ' ' depois do num, ok
			beq $t0, ',', sem_erro		#se ',' depois do num, ok
			beq $t0, '\n', sem_erro		#se '\n' depois do num, ok
			beq $t0, '\0', sem_erro		#se '\0' depois do num, ok
			beq $t0, '\t', sem_erro		#se '\t' depois do num, ok
			beq $t0, '(', sem_erro		#se '(' depois do num, okay
			j erro_instrucao		#se nada disso, erro

			sem_erro:
				move $v0, $a0			#retorna ponteiro do ultimo char lido
				beq $t3, $zero, nao_negativo	#checa sinal
				sub $t1, $zero, $t1		#t1 = -t1 se negativo
			nao_negativo:
				move $v1, $t1			#retorna valor da word
				jr $ra
	erro_word:
		li $v0, -1
		jr $ra

	testa_hex:
		addi $a0, $a0, 2		#pula "0x" ou "0X" do hexa
	loop_hex:
		lbu $t0, ($a0)
		blt $t0, '0', fim_numero	#menor valor possivel eh '0', se menor, acabou num
		ble $t0, '9', chars_0_ate_9	#caso '0' <= char <= '9'
		blt $t0, 'A', erro_instrucao	#senao eh '0' a '9', 'A' eh o menor
		ble $t0, 'F', chars_A_ate_F	#caso 'A' <= char <= 'F'
		blt $t0, 'a', erro_instrucao	#senao 'A' a 'F', 'a' eh o menor
		ble $t0, 'f', chars_a_ate_f	#caso 'a' <= char <= 'f'
		j erro_instrucao		#se char > 'f', erro

		chars_0_ate_9:
			sll $t1, $t1, 4		#se mais um char, mais um hexa (que representa 4 bits)
			addi $t0, $t0, -48	#t0 = atoi(t0)
			j fim_hexa

		chars_A_ate_F:
			sll $t1, $t1, 4
			addi $t0, $t0, -55	#t0 = t0 - ('A' - 10), 'A' passa a valer 10
			j fim_hexa

		chars_a_ate_f:
			sll $t1, $t1, 4
			addi $t0, $t0, -87	#t0 = t0 - ('a' - 10), 'a' passa a valer 10
			j fim_hexa

		fim_hexa:
			addu $t1, $t1, $t0	#soma o novo num (sem overflow, caso represente um num negativo)
			addi $a0, $a0, 1	#prox char
			j loop_hex

area_text:
	jal getchar
	bne $v0, 'e', erro_instrucao	#proximo char deve ser 'e'
	jal getchar
	bne $v0, 'x', erro_instrucao	#proximo char deve ser 'x'
	jal getchar
	bne $v0, 't', erro_instrucao	#proximo char deve ser 't'
	jal getchar
	bne $v0, '\n', erro_instrucao	#proximo char deve ser '\n'

	li $v0, 13		#abrir arquivo
	la $a0, arq_saida_text	#endereco da string com nome do arquivo
	li $a1, 1		#abrir para escrita
	li $a2, 0		#modo (ignorado no MARS)
	syscall
	blez $v0, erro_abertura	#se v0 <= 0, erro de abertura
	move $s2, $v0		#salvar descritor

	move $a0, $s2		#a0 com descritor
	li $v0, 15		#escrever em arquivo
	la $a1, arq_text_comeco	#o que escrever
	li $a2, 82		#num de caracteres a escrever
	syscall

	move $a0, $s2
	jal fecha_arquivo

	j fim_prog

fecha_arquivo:
	li $v0, 16		#fechar arquivo
	syscall
	jr $ra

le_arq:
	li $v0, 14		#ler de arquivo
	la $a1, arq_in		#endereco para guardar bytes lidos
	li $a2, 1024		#numero de bytes a ler
	syscall
	bltz $v0, erro_leitura	#se v0 < 0, erro
	jr $ra

erro_abertura:
	li $v0, 31		#som de erro
	li $a0, 56
	li $a1, 1000
	li $a2, 80
	li $a3, 127
	syscall

	li $v0, 4		#mensagem de erro
	la $a0, erro_ao_abrir
	syscall

	j fim_prog

erro_leitura:
	li $v0, 31		#som de erro
	li $a0, 56
	li $a1, 1000
	li $a2, 80
	li $a3, 127
	syscall

	li $v0, 4		#mensagem de erro
	la $a0, erro_ao_ler
	syscall
	j fim_prog

fim_arq:
	li $v0, 4		#mensagem de fim
	la $a0, erro_ao_ler
	syscall
	j fim_prog

fim_prog:
	li $v0, 10
	syscall

erro_instrucao:
	li $v0, 4		#mensagem de erro
	la $a0, erro_de_instrucao
	syscall
	bnez $s2, nao_fecha_data
	move $a0, $s2
	jal fecha_arquivo
	move $s2, $zero
	nao_fecha_data:
		j fim_prog

get_reg:	#a0 aponta p/ char atual (deve ser '$')
		#retorna v0 = num do registrador (-1 se erro) e v1 = ponteiro para char atualizado
	lbu $t0, ($a0)		#carrega char
	bne $t0, '$', not_reg	#se t0 != '$', erro
	lbu $t0, 1($a0)		#carrega proximo char
	blt $t0, '0', not_reg	#se t0 < '0', erro
	bgt $t0, '9', reg_letra	#se t0 > '9', $letra
	lbu $t1, 2($a0)		#carrega terceiro char
	beq $t1, ' ', reg_num	#se terceiro char eh espaco, eh $0 a $9
	beq $t1, ',', reg_num	#se terceiro char eh virgula, eh $0 a $9
	beq $t1, '\n', reg_num	#se terceiro char eh '\n', eh $0 a $9
	beq $t1, '\0', reg_num	#se terceiro char eh '\0', eh $0 a $9
	blt $t1, '0', not_reg	#se terceiro char nao eh num, erro
	bgt $t1, '9', not_reg	#se terceiro char nao eh num, erro

	reg_num_num:			#registradores $10 a $31
		addi $t0, $t0, -48	#t0 = atoi(t0)
		addi $t1, $t1, -48	#t1 = atoi(t1)
		sll $v0, $t0, 3		#v0 = 8*t0
		add $v0, $v0, $t0	#v0 = 9*t0
		add $v0, $v0, $t0	#v0 = 10*t0
		add $v0, $v0, $t1	#v0 = 10*t0 + t1
		bgt $v0, 31, not_reg	#se $32 ou maior, erro
		add $v1, $a0, 3		#v1 = a0 + 3, ap
		jr $ra

	reg_num:		#registradores $0 a $9
		addi $v0, $t0, -48	#v0 = atoi(t0)
		addi $v1, $a0, 2	#v1 = a0 + 2
		jr $ra

	reg_letra:
		addi $a0, $a0, 2	#pula "$c" onde c eh char qualquer
		lbu $t1, ($a0)		#carrega char depois de "$c"
		beq $t0, 't', reg_t	#se t0 = 't', familia $t
		beq $t0, 's', reg_s	#se t0 = 's', familia $s ou $sp
		beq $t0, 'z', reg_z	#se t0 = 'z', $zero
		beq $t0, 'a', reg_a	#se t0 = 'a', familia $a ou $at
		beq $t0, 'v', reg_v	#se t0 = 'v', familia $v
		beq $t0, 'g', reg_g	#se t0 = 'g', $gp
		beq $t0, 'k', reg_k	#se t0 = 'k', familia $k
		beq $t0, 'r', reg_r	#se t0 = 'r', $ra
		beq $t0, 'f', reg_f	#se t0 = 'f', $fp
		j not_reg		#se nada disso, erro

		reg_t:
			blt $t1, '0', not_reg
			bgt $t1, '9', not_reg
			addi $t1, $t1, -40	#t1 = atoi(t1)+8 pois $t0 = $8
			blt $t1, 15, reg_t0_t7	#$t8 e $t9 sao diferentes
			addi $v0, $t1, 8	#8 de diferenca entre $t7 e $t8
			addi $v1, $a0, 1	#prox char
			jr $ra

			reg_t0_t7:
				move $v0, $t1		#num do registrador
				addi $v1, $a0, 1	#prox char
				jr $ra

		reg_s:
			beq $t1, 'p', reg_sp
			blt $t1, '0', not_reg
			bgt $t1, '7', not_reg
			addi $v0, $t1, -32	#v0 = atoi(t1) + 16, pois $s0 = $16
			addi $v1, $a0, 1
			jr $ra

			reg_sp:
				li $v0, 29
				addi $v1, $a0, 1
				jr $ra

		reg_z:
			bne $t1, 'e', not_reg
			addi $a0, $a0, 1	#proximo byte/char
			lbu $t1, ($a0)		#v0 recebe prox char
			bne $t1, 'r', not_reg
			addi $a0, $a0, 1	#proximo byte/char
			lbu $t1, ($a0)		#t1 recebe prox char
			bne $t1, 'o', not_reg
			move $v0, $zero
			addi $v1, $a0, 1	#proximo byte/char
			jr $ra

		reg_a:
			beq $t1, 't', reg_at
			blt $t1, '0', not_reg
			bgt $t1, '3', not_reg
			addi $v0, $t1, -44	#v0 = atoi(t1) + 4, pois $a0 = $4
			addi $v1, $a0, 1
			jr $ra

			reg_at:
				li $v0, 1
				addi $v1, $a0, 1
				jr $ra

		reg_v:
			blt $t1, '0', not_reg
			bgt $t1, '1', not_reg
			addi $v0, $t1, -46	#v0 = atoi(t1) + 2, pois $v0 = $2
			addi $v1, $a0, 1
			jr $ra

		reg_g:
			bne $t1, 'p', not_reg
			li $v0, 28
			addi $v1, $a0, 1
			jr $ra

		reg_k:
			blt $t1, '0', not_reg
			bgt $t1, '1', not_reg
			addi $v0, $t1, -22	#v0 = atoi(t1) + 26, pois $k0 = $26
			addi $v1, $a0, 1
			jr $ra

		reg_r:
			bne $t1, 'a', not_reg
			li $v0, 31
			addi $v1, $a0, 1
			jr $ra

		reg_f:
			bne $t1, 'p', not_reg
			li $v0, 30
			addi $v1, $a0, 1
			jr $ra

		not_reg:
			li $v0, -1
			jr $ra

bin_para_ascii:	#recebe em a0 num para converter para ascii
		#guarda em instrucao_ascii a string resultante sem \0
	move $t0, $a0		#t0 guarda a0
	move $t1, $ra		#t1 guarda ra

	andi $a0, $t0, 0x0000000F	#pega ultimo half-byte como argumento
	jal hex_para_ascii		#converte para ascii
	sb $v0, instrucao_ascii + 7	#guarda no ultimo byte da variavel

	andi $a0, $t0, 0x000000F0	#pega penultimo half-byte como argumento
	srl $a0, $a0, 4			#leva o lsb para a posicao 0
	jal hex_para_ascii
	sb $v0, instrucao_ascii + 6	#guarda no penultimo byte da variavel

	andi $a0, $t0, 0x00000F00	#pega antepenultimo half-byte como argumento
	srl $a0, $a0, 8			#leva o lsb para a posicao 0
	jal hex_para_ascii
	sb $v0, instrucao_ascii + 5	#guarda no antepenultimo byte da variavel

	andi $a0, $t0, 0x0000F000	#pega quinto half-byte como argumento
	srl $a0, $a0, 12		#leva o lsb para a posicao 0
	jal hex_para_ascii
	sb $v0, instrucao_ascii + 4	#guarda no quinto byte da variavel

	andi $a0, $t0, 0x000F0000	#pega quarto half-byte como argumento
	srl $a0, $a0, 16		#leva o lsb para a posicao 0
	jal hex_para_ascii
	sb $v0, instrucao_ascii + 3	#guarda no quarto byte da variavel

	andi $a0, $t0, 0x00F00000	#pega terceiro half-byte como argumento
	srl $a0, $a0, 20		#leva o lsb para a posicao 0
	jal hex_para_ascii
	sb $v0, instrucao_ascii + 2	#guarda no terceiro byte da variavel

	andi $a0, $t0, 0x0F000000	#pega segundo half-byte como argumento
	srl $a0, $a0, 24		#leva o lsb para a posicao 0
	jal hex_para_ascii
	sb $v0, instrucao_ascii + 1	#guarda no segundo byte da variavel

	andi $a0, $t0, 0xF0000000	#pega primeiro half-byte como argumento
	srl $a0, $a0, 28		#leva o lsb para a posicao 0
	jal hex_para_ascii
	sb $v0, instrucao_ascii		#guarda no primeiro byte da variavel

	jr $t1				#retorna a caller

	hex_para_ascii:			#recebe um unico byte em a0
		bgt $a0, 9, letra_hex	#se a0 > 9, eh A ate F
		addi $v0, $a0, 48	#senao, eh 0 ate 9 (v0 = itoa(a0)), '0' == 48
		j salto_letra		#pula o passo de conversao 'A' ate 'F'
		letra_hex:
		addi $v0, $a0, 55	#['A', 'F'] == [65, 70], mas a0 >= 10, dai 10 de diferenca
		salto_letra:
		jr $ra			#retorna a caller

set_ra:
	move $v0, $ra
	jr $ra
