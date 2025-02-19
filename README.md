# Carregador simples x86
Trabalho 2 da disciplina Software Básico do semestre 2024.2, que consiste em escrever um programa que recebe o tamanho do programa a ser carregado, e até 4 pares de números, o endereço e o tamanho de um bloco de memória. O programa deve tentar colocar o programa inteiramente em um bloco, e caso não seja possível, coloca um pedaço do programa total no primeiro endereço que tem espaço.

O programa exibe no terminal se não foi possível carregar o programa fornecido, e caso contrário, exibe o endereço e o tamanho do programa alocado em blocos de memória.

O projeto foi desenvolvido e testado com linux, e devido ao uso do Assembly x86 e do montador NASM, não foi feita uma forma de compilar e executar o programa em Windows.

## Como compilar

Primeiramente, é necessário que a biblioteca _gcc-multilib_ esteja instalada. Caso não esteja, rode no terminal
```
sudo apt install gcc-multilib
```

Depois disso, rode no terminal os seguintes comandos, em ordem:
```
nasm -f elf carregador.s -o carregador.o
gcc -o carregador main.c carregador.o
```

## Como executar

Com o arquivo executável, é necessário executar na linha de comando:
```
./montador tamanho_programa blocos_memoria
```

onde:
- tamanho_do_programa: tamanho do programa a ser carregado
- blocos_de_memoria: até 4 pares de inteiros `endereco` e `tamanho_bloco`:
    - `endereco`: endereço daquele bloco de memória
    - `tamanho_bloco`: tamanho de memória disponível naquele bloco