# Laboratório 1 - Organização e Arquitetura de Computadores

## Começando

Estas instruções ensinarão como utilizar o código para desenvolvimento e testes em sua máquina.

### Pré-requisitos

Para uitlização do projeto, você vai precisar dos seguintes:

```none
Java
MARS 4.5
```

### Instalando

#### Instalando pré-requisitos em sistema operacional Windows

* Primeiramente, instalar uma versão de Java, preferencialmente a mais recente disponível no _website_ <https://www.java.com/en/download/>
  * Usando o instalador, siga as instruções para completar a instalação.

* Baixar o executável do _software_ MARS, disponível no _website_ <http://courses.missouristate.edu/kenvollmar/mars/download.htm>

### Instalando pré-requisitos em sistema operacional Linux

* Consulte sua distribuição! Distribuições debian e arch, por exemplo, possuem modos de instalação/atualização de Java diferentes!

* Baixar o executável do _software_ MARS, disponível no _website_ <http://courses.missouristate.edu/kenvollmar/mars/download.htm>

### Instalando pré-requisitos em sistema operacional Mac OS X

* Instruções disponíveis no _website_ <https://java.com/en/download/help/mac_install.xml>

* Baixar o executável do _software_ MARS, disponível no _website_ <http://courses.missouristate.edu/kenvollmar/mars/download.htm>

## Executando o programa

1. Inincie a plataforma MARS
2. Abra (<kbd>Ctrl</kbd> + <kbd>O</kbd> ou <kbd>&#8984;</kbd> + <kbd>O</kbd>) o arquivo `asm_to_mif.asm`
3. Na linha 4, altere o valor da _string_ "example_saida.asm" para o caminho para o arquivo com o código assembly a ser utilizado
    * Em sistema operacional Linux (testado em Ubuntu 18.04.3 LTS), o caminho é sempre absoluto, isto é, o progrma MARS sempre é executado no diretório "/home/"
4. Garanta que o caminho digitado seja um caminho absoluto (p. ex.: "C:/Users/jose/Documents/arquivo.asm") ou relativo ao diretório que contém o executável MARS4_5.jar (p. ex.: "../aqruivo.asm" se o arquivo está um diretório acima de diretório de MARS4_5.jar)
5. Utilize a IDE do MARS mara montar e executar o programa
6. Os arquivos resultantes estarão no diretório do MARS ou no diretório "/home/" dependendo de seu sistema operacional

### Limitações

1. O arquivo de entrada deve estar limitado a 2048 bytes para o funcionamento correto do programa
2. O arquivo de entrada deve estar corretamente formatado para garantir o funcionamento correto do programa
    * Isso significa que caracteres como espaço e tabulação logo antes de quebra de linha devem ser evitados
    * Instruções devem seguir o formato: "inst reg1, reg2, reg3", "inst reg1, reg2, imediato" etc, separados corretamente por vírgula e um único espaço
3. O arquivo de entrada é limitado às instruções da especificação do projeto. Instruções não requisitadas na especificação resulatarão em terminação imediata do programa.
    * Instruções tipo R suportadas: add, addu, and, clo, div, jr, madd, mfhi, mflo, mult, nor, or, sll, slt, sra, srav, srl, sub, subu, xor
    * Instruções tipo I suportadas: addi, andi, beq, bgez, bne, lui, lw, ori, sw, xori
        * Imediatos com mais de 16 bits não suportados
    * Instruções tipo J suportadas: j, jal
    * Pseudo-instruções suportadas: li (com imediato de até 16 bits), li (com imediato de 17 a 32 bits)

## Feito com

* [MIPS32](https://www.mips.com/products/architectures/mips32-2/)
* [MARS](http://courses.missouristate.edu/kenvollmar/mars/)

## Autores

* **Fábio Rodrigues de Andrade Santos** - *16/0151783* - [Santos-Fabio](https://github.com/Santos-Fabio "GitHub de Fábio")
* **Felipe Calassa de Albuquerque** - *16/0151805* - [calasssa](https://github.com/calasssa "GitHub de Felipe")
* **Leonardo Alves** - *16/0012007* - [LTxAlves](https://github.com/LTxAlves "GitHub de Leonardo")

## Reconhecimentos

* Billie Thompson's README template - disponível [aqui](https://gist.github.com/PurpleBooth/109311bb0361f32d87a2#file-readme-template-md)
