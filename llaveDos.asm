section .text
global cortar_y_concatenar

cortar_y_concatenar:
    push rdi
    push rsi
    push rcx
    push rdx

    lea rdi, [llave_dosificacion]
    movzx rdx, byte [indice_llave]
    add rdi, rdx
    mov rcx, 0
.find_end:
    mov al, [rsi + rcx]
    cmp al, 0
    je .copy_fragment
    inc rcx
    jmp .find_end

.copy_fragment:
    mov rdx, 0
.loop_copy:
    cmp rdx, r8
    je .finish
    mov al, [rdi + rdx]
    mov [rsi + rcx], al
    inc rcx
    inc rdx
    jmp .loop_copy

.finish:
    mov byte [rsi + rcx], 0
    movzx rax, byte [indice_llave]
    add al, r8b               ; ⬅️ usa r8b porque r8 = 64 bits
    mov [indice_llave], al

    pop rdx
    pop rcx
    pop rsi
    pop rdi
    ret