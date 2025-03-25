;Dado un número n, imprimir la suma de los primeros n números naturales (No utilizar una fórmula).

section .text
    global _start

_start:
    mov eax, 5
    call _suma

    mov ebx, cadena
    mov 

    mov eax, 4
    mov ebx, 1
    mov ecx, cadena
    mov edx, 10
    int 80h

    mov eax, 1
    mov ebx, 0
    int 80h

_suma:
    pushad
    pushf
    ;tomo el número n en eax, devuelvo la suma en eax

    mov ecx, eax
    mov eax, 0
    .loop1:
        cmp ecx, 0
        je .end1
        add eax, ecx
        dec ecx
        jmp .loop1
    .end1:

    popf
    popad
    ret

section .data
    cadena: db 10