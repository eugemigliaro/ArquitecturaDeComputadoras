section .text
    GLOBAL _start

_start:
    mov eax, cadena
    mov ebx, eax
    call toUpper
    mov ecx, eax
    call strlen
    mov edx, eax
    mov eax, 4
    mov ebx, 1
    mov ecx, cadena
    int 0x80
    mov ebx, 0
    call end

toUpper:
    pushad
    pushf

    .loop:
        mov al, [ebx]
        cmp al, 0
        jz .end
        cmp al, 'a'
        jl .next
        cmp al, 'z'
        jg .next
        sub al, 'a'-'A'
        mov [ebx], al
    .next:
        inc ebx
        jmp .loop
    .end:
        popf
        popad
        ret

strlen:
    push ecx
    push ebx
    pushf

    mov ecx, 0
    
    .loop:
        mov al, [ebx]
        cmp al, 0
        jz .end
        inc ecx
        inc ebx
        jmp .loop
    .end:
        mov eax, ecx
    
    popf
    pop ebx
    pop ecx
    ret

end:
    mov eax, 1
    int 80h

section .data
    cadena db "h4ppy c0d1ng", 10

section .bss