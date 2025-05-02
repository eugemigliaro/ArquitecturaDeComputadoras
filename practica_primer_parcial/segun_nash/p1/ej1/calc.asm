section .data
    fmtResultado db "Resultado = %d", 10, 0
    fmtErrorCantArgs db "Cantidad de argumentos incorrecta", 10, 0
    fmtErrorOperador db "Error: Operador <%s> no reconocido", 10, 0

section .text
    global main
    global validar_operador
    extern printf
    extern operar

main:
    push ebp
    mov ebp, esp
    sub esp, 8

    mov dword[ebp - 4], 0; el resultado
    mov dword[ebp - 8], 0; flag

    ;en [ebp + 8] tengo el argc
    ;en [ebp + 12] tengo el argv
    
    ;ahora necesito validar que el segundo argumento sea un operador

    mov ecx, [ebp + 8] ;argc
    cmp ecx, 4
    jl .error_cant_args

    mov eax, [ebp + 12] ; argv
    mov eax, [eax + 8] ;argv[1]

    pushad
    push eax
    call validar_operador
    mov [ebp - 8], eax
    add esp, 4
    popad

    cmp dword[ebp - 8], 0
    je .error_operador

    pushad
    mov eax, [ebp + 12]
    mov ecx, [eax + 8] ; argv[1], el operador
    push ecx
    mov ecx, [eax + 12] ; argv[2], el operando 2
    push ecx
    mov ecx, [eax + 4] ; argv[0], el operando 1
    push ecx
    call operar
    add esp, 12
    mov [ebp - 4], eax ; el resultado lo guardo
    popad

    jmp .mostrar_resultado

.error_cant_args:
    push fmtErrorCantArgs
    call printf
    add esp, 4
    jmp .end

.error_operador:
    mov eax, [ebp + 12]
    mov eax, [eax + 8]
    push eax
    push fmtErrorOperador
    call printf
    add esp, 8
    jmp .end

.mostrar_resultado:
    mov eax, [ebp - 4]
    push eax
    push fmtResultado
    call printf
    add esp, 8

.end:
    mov eax, 0
    mov esp, ebp
    pop ebp
    ret

validar_operador:
    push ebp
    mov ebp, esp
    mov eax, [ebp + 8]
    cmp byte[eax], '+'
    je .return
    cmp byte[eax], '-'
    je .return
    cmp byte[eax], '*'
    je .return
    cmp byte[eax], '/'
    je .return
    cmp byte[eax], '^'
    je .return
    mov eax, 0
    jmp .end
.return:
    mov eax, 1
.end:
    mov esp, ebp
    pop ebp
    ret