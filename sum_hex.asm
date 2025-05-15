section .data
    paso db 5

; Entradas:
;   RSI -> puntero de la cadena hexadecimal
;   RCS -> tamano de la cadena
;   RAX -> pos inicial
; Salida:
;   R10 -> sumatoria de la cadena

section .text
global sum_hex
sum_hex:
    push rax
    mov rbp, rsp; for correct debugging
    xor r10, r10
    .loop:
        cmp rax, rcx
        jge .terminado
        movzx rbx, byte [rsi + rax]
        add r10, rbx
        movzx rbx, byte [paso]
        add rax, rbx
        jmp .loop
    .terminado:
    pop rax
    ret