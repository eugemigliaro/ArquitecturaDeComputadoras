;quiero hacer un programa que imprima el primer argumento que se le pasa al ejecutar el programa
section .data
    fmt db "El primer argumento es: %s, y la cantidad de argumentos (contando el nombre del programa) es : %d", 10, 0
    top_fmt db "El valor que está al tope del stack es: %d", 10, 0

section .text
    global main
    extern printf

main:
    push ebp
    mov ebp, esp

    push 0
    ; en [ebp + 8] tengo el argc
    ; en [ebp + 12] tengo el argv

    mov eax, [ebp + 12] ;argv
    mov eax, [eax + 4] ;argv[1] porque argv[0] es el nombre del programa

    mov ecx, [ebp + 8] ;argc

    push cx
    push eax
    push fmt
    call printf
    add esp, 10

    pop eax
    push eax
    push top_fmt
    call printf
    add esp, 8

    mov eax, 0
    mov esp, ebp
    pop ebp
    ret