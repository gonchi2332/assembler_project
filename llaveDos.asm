section .text
global concatenar_cad

; Entradas:
;   RSI = puntero a texto plano
;   RDI = puntero a texto a concatenar
;   RCX = longitud del texto
;   R8  = longitud de texto a concatenar
; Salida:
;   El texto cifrado [RDI]

concatenar_cad:
    mov rbp, rsp; for correct debugging
    push rdi
    push rsi
    push rcx
    push rdx
    movzx rdx, byte [indice_llave]
    add rdi, rdx
    call tamcad

    xor rdx, rdx
.loop_copia:
    cmp rdx, r8
    je .terminado
    movzx rax, byte [rdi + rdx]
    mov [rsi + rcx], al
    inc rcx
    inc rdx
    jmp .loop_copia

.terminado:
    movzx rax, byte [indice_llave]
    add rax, r8
    mov [indice_llave], rax

    pop rdx
    pop rcx
    pop rsi
    pop rdi
    ret