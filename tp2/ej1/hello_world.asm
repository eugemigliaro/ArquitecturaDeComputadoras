section .data
    ; msg is a byte array containing the string 'Hello World!' terminated by a 0
    msg db 'Hello World!', 10
    length equ $-msg

section .text
    ; _start is the entry point of the program
    GLOBAL _start

_start:
    ; write(1, msg, 13) - Write the first 13 bytes of the string in msg to the file descriptor 1 (stdout)
    mov eax, 4                ; 1 is the file descriptor of stdout
    mov ebx, 1
    mov ecx, msg              ; msg is the address of the string to write
    mov edx, length               ; 13 is the length of the string to write
    int 0x80                  ; invoke the write system call

    ; exit(0) - Exit the program with return code 0
    mov eax, 1
    mov ebx, 0                ; 0 is the return code
    int 0x80                  ; invoke the exit system call
