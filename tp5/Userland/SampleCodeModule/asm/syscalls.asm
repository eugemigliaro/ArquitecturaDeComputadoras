GLOBAL sys_write

sys_write:
    mov rax, 0x03
    int 0x80
    ret