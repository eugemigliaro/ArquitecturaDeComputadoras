;escriba una función que reciba un string y al retornar, deje dicho string con cada una de sus palabras con la primera letra en mayúsculas.
;como valor de retorno, debe retornar la cantidad de palabras.
;Luego de escribir la función, escriba un programa que la pruebe mostrando en pantalla el string al inicio y al final.

section .data
    cadena db "hola vos", 0
    longitud equ $-cadena

section .text
    global main
    global capitalize

main:
    push ebp
    mov ebp, esp

    mov eax, 4
    mov ebx, 1
    mov ecx, cadena
    mov edx, longitud
    int 80h

    pushad
    push cadena
    call capitalize
    add esp, 4
    popad

    add eax, '0'        ;imprimo el contador de palabras
    mov [buffer], eax

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

    mov esp, ebp
    pop ebp
    ret

capitalize:
    push ebp
    mov ebp, esp
    mov eax, [ebp + 8]
    xor ecx, ecx
    .must_to_upper:
    inc ecx     ;estoy en palabra nueva
    
    push eax
    call is_lower
    mov edx, eax
    pop eax
    
    cmp edx, 1
    jne .after
    pushad
    push eax    ;tengo que pasar a upper, es lower
    call to_upper
    add esp, 4
    popad

    .after:
    inc eax

    pushad                  ;DEBUG
    mov ecx, cadena
    mov eax, 4
    mov ebx, 1
    mov edx, longitud
    int 80h
    popad

    cmp byte[eax], 0
    je .end
    
    push eax
    call is_space
    mov edx, eax
    pop eax
    
    cmp edx, 1
    jne .after
    inc eax

    pushad                  ;DEBUG
    mov ecx, cadena
    mov eax, 4
    mov ebx, 1
    mov edx, longitud
    int 80h
    popad

    cmp byte[eax], 0
    je .end
    jmp .must_to_upper

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
    .not:
    mov eax, 0
    mov esp, ebp
    pop ebp
    ret

to_upper:
    push ebp
    mov ebp, esp
    mov eax, [ebp + 8]
    mov ecx, [eax]
    sub byte[eax], 32
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