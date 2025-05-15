section .text
global tamcad

; Entradas:
;   RSI -> puntero a cadena ASCII
; Salida:
;   rcx  <- tamano de la cadena

tamcad:
    mov rbp, rsp; for correct debugging
    xor rcx, rcx
.contar:
    cmp byte [rsi + rcx], 0
    je .terminar
    inc rcx
    jmp .contar
.terminar:
    ; rcx = longitud
    ret