section .text
global sum_cad
sum_cad:
    mov rbp, rsp; for correct debugging
    xor rbx, rbx
    xor r11, r11
    mov r11, 1
    call tamcad
    dec rcx
    xor r9, r9
    dec r9
.loop:
    cmp r9, rcx
    jge .termino
    xor rax, rax
    mov al, [rsi + rcx]
    sub rax, '0'
    mul r11
    add rbx, rax
    mov rax, r11
    mov r11, 10
    mul r11
    mov r11, rax
    dec rcx
    jmp .loop
.termino:
    add r13, rbx
    ret