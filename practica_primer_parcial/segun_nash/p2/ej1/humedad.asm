section .data
    arreglo dd 10, 20, 30, 40, 50
    cant_arreglo dd ($ - arreglo) / 4
    esta_msg db "La humedad se encuentra en el arreglo", 10, 0
    filename db "/sys/bus/iio/in_voltage0_raw", 0
    resolucion dd 16
    timespec_1sec dd 1, 0

section .text
    global main
    global is_in_array
    extern printf
    extern get_humedad

main:
    push ebp
    mov ebp, esp
    sub esp, 8

    mov dword[ebp - 4], 0; flag
    mov dword[ebp - 8], 10; cantidad de segundos a correr

.loop:
    push filename
    push dword[resolucion]
    call get_humedad
    add esp, 8
    xor edx, edx
    mov bx, 7
    div bx
    movzx eax, ax
    pushad
    push eax
    call is_in_array
    add esp, 4
    mov dword[ebp - 4], eax
    popad
    cmp dword[ebp - 4], 0
    je .no_esta_arr
    pushad
    push esta_msg
    call printf
    add esp, 4
    popad

.no_esta_arr:
    mov eax, 162
    mov ebx, timespec_1sec
    mov ecx, 0
    int 80h
    mov ecx, dword[ebp - 8]
    dec ecx
    jz .end
    mov dword[ebp - 8], ecx
    jmp .loop

.end:
    mov eax, 0
    mov esp, ebp
    pop ebp
    ret

is_in_array:
    push ebp
    mov ebp, esp
    mov edx, dword[ebp + 8]
    mov eax, arreglo
    mov ecx, dword[cant_arreglo]

.loop:
    cmp edx, dword[eax]
    je .esta
    add eax, 4
    dec ecx
    jz .no_esta
    jmp .loop

.esta:
    mov eax, 1
    jmp .end

.no_esta:
    mov eax, 0
    jmp .end

.end:
    mov esp, ebp
    pop ebp
    ret