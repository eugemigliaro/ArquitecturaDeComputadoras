;escribir un programa asm que utilice la función de stdio printf para imprimir
;la cantidad de argumentos que se le pasen al programa y los mismos argumentos.

section .rodata
    ; Cadenas de formato para printf
    fmtNum db "Se pasaron %d argumentos: ", 10, 0
    fmtArg db "Argumento %d: %s", 10, 0

section .text
global main           ; Símbolo de entrada para enlazar con gcc
extern printf         ; Declaramos que usaremos printf de la libc

; Función main en convención cdecl
main:
    ; Prologo típico (salvar ebp y crear nuevo marco)
    push ebp
    mov  ebp, esp

    ; Extraer argc y argv de la pila
    mov  eax, [ebp + 8]   ; argc
    dec  eax              ; quito el program name
    mov  ebx, [ebp + 12]  ; argv

    ; Imprimir la cantidad de argumentos
    ; printf(fmtNum, argc); 

    pushad

    push eax              ; 2º argumento: argc (int)
    push dword fmtNum     ; 1º argumento: cadena de formato
    call printf
    add  esp, 8           ; limpiar la pila (2 argumentos x 4 bytes)

    popad

    ; Preparar un bucle para imprimir cada argumento
    xor  edx, edx         ; edx = 0  (i = 0, índice del argumento)
imprime_loop:
    cmp  edx, eax         ; ¿i < argc?
    jge  fin_bucle

    ; Calcular argv[i]
    ; argv es un array de punteros de 4 bytes cada uno.
    add ebx, 4            ; ebx = &argv[i]
    mov  ecx, [ebx]       ; ecx = argv[i] (puntero a la cadena)

    ; Imprimir: printf(fmtArg, i, argv[i]);
    pushad

    push ecx              ; 3er argumento: la cadena
    push edx              ; 2º argumento: índice i
    push dword fmtArg     ; 1er argumento: cadena de formato
    call printf
    add  esp, 12          ; limpiar la pila (3 argumentos)

    popad

    inc  edx              ; i++
    jmp  imprime_loop

fin_bucle:
    ; Retornar 0 (éxito) desde main
    mov  eax, 0
    leave
    ret
