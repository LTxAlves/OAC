	.data
path_arq: .asciiz "mips1.asm" #trocar nome/colocar caminho relativo ao executavel do MARS
arq_saida_text: .asciiz "saida_text.mif"
arq_saida_data: .asciiz "saida_data.mif"
espaco: .space 1024
erro_ao_abrir: .asciiz "Erro ao abrir arquivo!\n"
aberto_sucesso: .asciiz "Arquivo aberto com sucesso!\n"
erro_ao_ler: .asciiz "Erro ao ler do arquivo!\n"
fim_do_arquivo: .asciiz "Fim do arquivo encontrado!\n"
erro_de_instrucao: .asciiz "Erro de instrucao no arquivo"
arq_data_comeco: .ascii "DEPTH\t\t= 16384;\nWIDTH\t\t= 32;\nADDRESS_RADIX\t= HEX;\nDATA_RADIX\t= HEX;\nCONTENT\nBEGIN\n\n"
arq_text_comeco: .ascii "DEPTH\t\t= 16384;\nWIDTH\t\t= 32;\nADDRESS_RADIX\t= HEX;\nDATA_RADIX\t= HEX;\nCONTENT\nBEGIN\n\n"
arqs_end: .ascii "\n\nEND;\n"

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

jal le_arq
move $s1, $v0		#quantidade de caracteres no espaco de memoria
move $a0, $s0		#carrega descritor do arquivo
jal fecha_arquivo
move $s0, $zero
la $t7, espaco		#salvar ponteiro para o primeiro byte/char
add $s1, $s1, $t7	#salvar endereco do final do arquivo

procura_ponto:
lbu $t0, ($t7)			#carrega o caractere em $t7
beq $t0, '.', data_ou_text	#se t0 == '.', deve ser data ou text 
addi $t7, $t7, 1		#próximo byte/char
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

acabou_arquivo:
li $v0, 15		#escrever em arq
move $a0, $s2		#descritor do arq
la $a1, arqs_end	#o que escrever
li $a2, 7		#quant de caracteres
syscall
jal fecha_arquivo
move $s2, $zero
j fim_prog

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
beq $v0, 'd', area_data	#se depois de '.' temos 'd', é data
beq $v0, 't', area_text	#se depois de '.' temos 't', é text
j erro_instrucao	#se depois de '.' nao temos 'd' nem 't', é erro

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
jal getchar			#prox char
beq $v0, '.', fim_data		#se '.', deve ser ".text"
bne $v0, '\n', data		#depois de pular separadores e '.', se nao eh '\n', eh mais um numero
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

uma_word:
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
j erro_instrucao		#se nada disso, erro

sem_erro:
move $v0, $a0			#retorna ponteiro do ultimo char lido
beqz $t3, nao_negativo		#checa sinal
sub $t1, $zero, $t1		#t1 = -t1 se negativo
nao_negativo:
move $v1, $t1			#retorna valor da word
jr $ra

testa_hex:
addi $a0, $a0, 2		#pula "0x" ou "0X" do hexa
loop_hex:
lbu $t0, ($a0)
blt $t0, '0', fim_numero	#menor valor possivel eh '0', se menor, acabou num
ble $t0, '9', chars_0_ate_9	#caso '0' <= char <= '9'
blt $t0, 'A', erro_instrucao	#senao é '0' a '9', 'A' eh o menor
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
addi $t0, $t0, -55	#t0 = t0 - ('A' - 10), 'A' vale 10
j fim_hexa

chars_a_ate_f:
sll $t1, $t1, 4
addi $t0, $t0, -87	#t0 = t0 - ('a' - 10), 'a' vale 10
j fim_hexa

fim_hexa:
add $t1, $t1, $t0	#soma o novo num (com overflow, caso passe de 32 bits)
addi $a0, $a0, 1	#prox char
j loop_hex

move $a0, $s2		#carrega descritor do arquivo
jal fecha_arquivo
move $s2, $zero

j fim_prog

area_text:
jal getchar
bne $v0, 'e', erro_instrucao	#proximo char deve ser 'e'
jal getchar
bne $v0, 'x', erro_instrucao	#proximo char deve ser 'x'
jal getchar
bne $v0, 't', erro_instrucao	#proximo char deve ser 't'
jal getchar
bne $v0, '\n', erro_instrucao	#proximo char deve ser '\n'

j fim_prog

fecha_arquivo:
li $v0, 16		#fechar arquivo
syscall
jr $ra

le_arq:
li $v0, 14		#ler de arquivo
move $a0, $s0		#descritor do arquivo
la $a1, espaco		#endereco para guardar bytes lidos
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

set_ra:
move $v0, $ra
jr $ra
