; Funcoes para colocar o programa em algum dos blocos de memoria e depois printar seu local

section .data

; dados de ascii usados no print_int
endline: db 10          ; ascii de \n
zero_ascii: dd 48       ; ascii de '0'

; strings utilizadas pelo print_ans
fail_string: db "Nao eh possivel carregar o programa na memoria", 10, 0

section .bss

section .text

global fit

; void fit(int sz, int e1, int s1, int e2, int s2, int e3, int s3, int e4, int s4)
; funcao que realiza os calculos para colocar o programa de tamanho sz na memoria, estando disponiveis os enderecos eX, com espaco sX (1 <= X <= 4)
; entrada:
;       sz = tamanho do programa a ser carregado
;       eX = endereco do bloco X de memoria, 1 <= X <= 4 (eX = -1 se nao foi fornecido no programa)
;       sX = tamanho do bloco X de memoria, 1 <= X <= 4 (sX = -1 se nao foi fornecido no programa)
; saida:
;       nenhum valor, chama a funcao que printa onde o programa vai ficar guardado

fit:
        enter 0, 0

        ; primeiro loop pra ver se cabe completo em algum bloco
        mov eax, ebp
        mov ebx, [ebp+8]
        mov ecx, 4      ; tamanho do loop
for1:   cmp dword [eax + 12], -1
        je break1   ; se nao tem mais valores sai
        cmp [eax + 16], ebx
        jge full_fit
        add eax, 8      ; pula o eX e sX analisados atualmente
        loop for1

break1: 
        ; nao cabe inteiro em um endereco, entao a gente itera pela lista de enderecos pra ver quantos sao necessarios pra colocar esse programa
        mov eax, ebp
        mov ebx, [ebp+8]
        mov ecx, 1
for2:   cmp ebx, [eax+16]
        jle partial_fit
        ; se nao cabe, coloca tudo que pode nessa secao de memoria
        sub ebx, [eax+16]
        push dword [eax+16]
        push dword [eax+12]
        add eax, 8      ; proximo argumento
        inc ecx
        cmp ecx, 5
        je no_fit       ; nao tem mais argumentos da funcao, entao nao cabe
        cmp dword [eax+12], -1 
        je no_fit       ; se o proximo argumento eh -1, entao eh valor invalido, logo eh no_fit
        jmp for2    


partial_fit:
        push ebx
        push [eax+12]
        push ecx
        call print_ans
        jmp fim_fit

no_fit:
        push dword -1
        call print_ans
        add esp, 4      ; desempilhando o -1
        jmp fim_fit

full_fit:
        ; empilhar que temos um par de argumentos so, que eh o endereco que a gente achou e o tamanho do codigo
        push ebx
        push [eax + 12]
        push dword 1
        call print_ans
        add esp, 12
        jmp fim_fit

; loop para desempilhar tudo que eu empilhei durante a funcao
fim_fit:
        cmp esp, ebp
        je fit_ret
        add esp, 4
        jmp fim_fit

fit_ret:
        leave
        ret


; void print_ans
; funcao que, dado o numero de blocos e o numero de bytes, imprime em quais blocos e o quanto o programa ocupa, ou se nao eh possivel
; entrada:
;       - [ebx+8] = -1 se nao for possivel colocar o programa na memoria, caso contrario eh o numero de blocos que o programa ocupa
;       - [ebx + 8*x + 12] = endereco do bloco x-1
;       - [ebx + 8*x + 16] = tamanho ocupado no bloco x-1
; saida:
;       - prints no terminal
print_ans:
        enter 0, 0

        cmp dword [ebp+8], -1
        je print_fail

print_fail:
        mov eax, 3
        mov ebx, 1
        mov ecx, fail_string
        mov edx, 47     ; tamanho da string
        int 80h
        jmp fim_print_ans

fim_print_ans:
        leave
        ret

; print_num(int x)
; funcao que recebe um numero e printa esse numero no terminal
; argumentos:
;       um inteiro
; retorno:
;       nada
print_num:
    enter 0,0 
    mov eax, [ebp+8]
    cmp eax, 0
    je print_zero
    
for_print_num:
    cmp eax, 0
    je show_num
    mov edx, 0
    mov ecx, 10
    div ecx
    push edx
    jmp for_print_num

print_zero:
    push eax

show_num:
    cmp esp, ebp
    je exit_print
    mov eax, [zero_ascii]
    add DWORD [esp], eax
    mov eax, 4
    mov ebx, 1
    mov ecx, esp
    mov edx, 1
    int 80h
    add esp, 4
    jmp show_num

exit_print:
    mov eax, 4
    mov ebx, 1
    mov ecx, endline
    mov edx, 1
    int 80h

    leave
    ret