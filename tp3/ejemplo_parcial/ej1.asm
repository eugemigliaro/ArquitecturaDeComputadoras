;escriba una función que reciba un string y al retornar, deje dicho string con cada una de sus palabras con la primera letra en mayúsculas.
;como valor de retorno, debe retornar la cantidad de palabras.
;Luego de escribir la función, escriba un programa que la pruebe mostrando en pantalla el string al inicio y al final.

section .data
    cadena db "hola como         estás", 0
    longitud equ $-cadena

section .text
    global main
    global capitalize

main:
    push ebp
    mov ebp, esp
    sub esp, 4
    mov dword[ebp - 4], 0 ;contador

    mov eax, 4
    mov ebx, 1
    mov ecx, cadena
    mov edx, longitud
    int 80h

    pushad
    push cadena
    call capitalize
    mov dword[ebp - 4], eax
    add esp, 4
    popad

    mov eax, dword[ebp - 4]

    add eax, '0'        ;imprimo el contador de palabras
    mov [buffer], eax

    pushad
    mov eax, 4
    mov ebx, 1
    mov ecx, buffer
    mov edx, 1
    int 80h

    mov eax, 4          ;imprimo la cadena modificada
    mov ebx, 1
    mov ecx, cadena
    mov edx, longitud
    int 80h
    popad
    
    mov esp, ebp
    pop ebp
    ret

capitalize:
    push ebp
    mov ebp, esp
    mov eax, [ebp + 8]
    xor ecx, ecx

    mov dl, 1       ;marco como que el prev is_space

    .loop:
    cmp byte[eax], 0
    je .end
    ;guardo en dh si el current is_space
    push eax
    call is_space
    mov dh, al
    pop eax
    ;if es el inicio de una palabra, pasar a mayúscula
    cmp dl, 1
    je .prev_is_space
    jmp .not_new_word

    .prev_is_space:
    ;if [eax] is_space, no estoy en el inicio de una palabra, no llamo a new_word
    cmp dh, 1
    je .not_new_word
    jmp .new_word

    .not_new_word:
    jmp .continue
    
    .new_word:
    inc ecx
    pushad
    push eax
    call to_upper
    add esp, 4
    popad
    jmp .continue

    .continue:
    mov dl, dh      ;muevo el current a prev
    inc eax
    jmp .loop

    .end:
    mov eax, ecx
    mov esp, ebp
    pop ebp
    ret

is_space:
    push ebp
    mov ebp, esp
    mov eax, [ebp + 8]
    cmp byte[eax], ' '
    jne .not
    mov eax, 1
    jmp .return
    .not:
    mov eax, 0
    .return:
    mov esp, ebp
    pop ebp
    ret

to_upper:
    push ebp
    mov ebp, esp
    mov eax, [ebp + 8]
    pushad
    push eax
    call is_lower
    add esp, 4
    cmp eax, 1
    popad
    jne .not_lower
    ;llego acá, entonces es lower, la paso a upper
    sub byte[eax], 32

    .not_lower:
    mov esp, ebp
    pop ebp
    ret

is_lower:
    push ebp
    mov ebp, esp
    mov eax, [ebp + 8]
    cmp byte[eax], 'a'
    jl .not
    cmp byte[eax], 'z'
    jg .not
    mov eax, 1
    jmp .return
    .not:
    mov eax, 0
    .return:
    mov esp, ebp
    pop ebp
    ret

section .bss
    buffer resb 1