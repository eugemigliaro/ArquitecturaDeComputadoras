;Agregar a la biblioteca una función que recibe un número y una zona de memoria, y
;transforme el número en un string, terminado con cero, en la zona de memoria pasada
;como parámetro.
;Nota: Puede utilizar la instrucción div o idiv
; me pasan el número en en eax y la dirección de memoria en ebx

section .text
    GLOBAL _start

_start:

    mov eax, 123
    mov ebx, cadena
    call num2str

    mov eax, 4
    mov ebx, 1
    mov ecx, cadena
    mov edx, 10
    int 80h

    mov eax, 1
    mov ebx, 0
    int 80h

num2str:
    pushad
    pushf

    push 0

    .loop1:
        cmp eax, 0
        je .end1
        mov edx, 0
        mov ecx, 10
        div ecx
        add edx, '0'
        push edx
        ;inc ecx
        jmp .loop1
    .end1:
        mov ecx, 0
        pop eax
    .loop2:
        cmp al, 0
        je .end2
        mov [ebx], al
        pop eax
        inc ebx
        ;dec ecx
        jmp .loop2
    .end2:
        popf
        popad
        ret

section .data
    numero equ 123
    msg db "holaaaaaaaaaa", 10

section .bss
    cadena: resb 10