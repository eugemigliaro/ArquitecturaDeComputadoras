section .text
    global main
    extern hola_mundo

main:
    call hola_mundo
    ret