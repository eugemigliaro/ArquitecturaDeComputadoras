;============================================================
; 32-bit Linux assembly example using Intel syntax.
; Prints all command-line arguments (except argv[0]) by calling
; a dedicated print_args function from our main entry point.
; Also includes an exit_process function for sys_exit.
;
; Usage:
;   nasm -f elf32 print_args.asm -o print_args.o
;   ld -m elf_i386 print_args.o -o print_args
;   ./print_args arg1 arg2 ...
;============================================================

section .data
newline db 10, 0    ; newline + terminator
cadena_prueba db "hola", 0

section .text

;------------------------------------------------------------
; Entry point: _start
;   Extract argc and argv, then calls print_args(argc, argv).
;   Finally calls exit_process(0).
;------------------------------------------------------------

global _start

_start:
    ; On the stack for 32-bit Linux at process start:
    ;   [esp + 0]   = (unused, return address placeholder)
    ;   [esp + 4]   = argc
    ;   [esp + 8]   = argv (pointer to array of pointers)

    mov ebx, [esp]   ; argc
    mov ecx, esp
    add ecx, 4       ; argv

    ; Push argv and argc onto the stack for print_args(argc, argv)
    push ecx             ; push argv
    push ebx             ; push argc
    call print_args

    ; Exit with code 0
    push 0
    call exit_process

;------------------------------------------------------------
; print_args(argc, argv)
;   Prints all arguments except argv[0]. Then returns.
;   cdecl-like convention: arguments are on the stack.
;   [ebp+8] = argc, [ebp+12] = argv.
;   If there's no argument or a null pointer, we call exit_process(0).
;------------------------------------------------------------
print_args:
    push ebp
    mov  ebp, esp
    mov  ebx, [ebp + 8]  ; argc
    mov  ecx, [ebp + 12] ; argv

    ; If argc <= 1, no real arguments beyond the program name
    cmp ebx, 1
    jle .no_args

    ; Skip argv[0] (program name) by adding 4 bytes
    add ecx, 4    ; now ECX points to argv[1]

    ; ESI will track how many arguments remain
    mov esi, ebx
    dec esi       ; we want to print argc - 1 arguments

.print_loop:
    ; Load pointer to current argument string
    mov edx, [ecx]

    ; If this pointer is null, we have no string to print
    test edx, edx
    jz .no_args

    ; Print the string
    push ecx       ; save registers across call
    push ebx
    push esi

    push edx       ; push pointer to string
    call print_string
    pop edx

    ; Print a newline
    push newline
    call print_string
    pop eax        ; discard pointer

    pop esi        ; restore registers
    pop ebx
    pop ecx

    ; Move to next pointer (4 bytes per pointer in 32-bit)
    add ecx, 4
    dec esi
    jnz .print_loop

    ; Return normally if we've printed everything
    mov esp, ebp
    pop ebp
    ret

.no_args:
    ; If we have no arguments (or pointer is null), exit the program
    push 0
    call exit_process

;------------------------------------------------------------
; exit_process(exit_code)
;   Wraps sys_exit(exit_code).
;   cdecl-like convention: argument is on the stack.
;   [ebp+8] = exit_code.
;------------------------------------------------------------
exit_process:
    push ebp
    mov  ebp, esp

    mov  eax, 1          ; syscall number for sys_exit
    mov  ebx, [ebp + 8]  ; exit code
    int  0x80

    mov  esp, ebp
    pop  ebp
    ret

;------------------------------------------------------------
; print_string:
;   Prints a null-terminated string to stdout.
;   Argument (on stack): pointer to string.
;   Relies on an external strlen_ function to get length.
;   [ebp+8] = pointer to string.
;------------------------------------------------------------
print_string:
    push ebp
    mov  ebp, esp
    mov  esi, [ebp + 8]   ; pointer to string

    ; Get string length using strlen_
    push esi              ; push pointer to string
    call strlen_
    pop esi               ; pop argument from stack

    ; EAX now has the length
    mov  edx, eax         ; EDX = length

    ; sys_write(1, string, length)
    mov  eax, 4           ; syscall number for sys_write
    mov  ebx, 1           ; file descriptor: stdout
    mov  ecx, esi         ; pointer to string
    int  80h

    mov  esp, ebp
    pop  ebp
    ret

;------------------------------------------------------------
; strlen_:
;   Returns the length of a null-terminated string.
;   Argument (on stack): pointer to string.
;   Result in EAX.
;   [ebp+8] = pointer to string.
;------------------------------------------------------------
strlen_:
    push ebp
    mov  ebp, esp

    mov  edi, [ebp + 8]   ; pointer to string
    xor  ecx, ecx         ; ECX = 0

.strlen_loop:
    mov  al, [edi]
    test al, al
    je   .strlen_done
    inc  edi
    inc  ecx
    jmp  .strlen_loop

.strlen_done:
    mov  eax, ecx         ; length in EAX

    mov  esp, ebp
    pop  ebp
    ret