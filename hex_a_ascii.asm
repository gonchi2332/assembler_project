section .data
    tabla_hex   db "0123456789ABCDEF", 0

section .text
    global hex_a_ascii

; Entradas:
;   RSI -> puntero de la lista hexadecimal
;   RDI -> puntero de la cadena hexadecimal
;   RCX -> tamano de la lista
;   R11 -> Tiene guion
; Salida:
;   Se actualiza en la direccion RSI con los valores hex a ascii


hex_a_ascii:
    mov rbp, rsp; for correct debugging
    mov rdx, rcx
    xor rcx, rcx
    xor rbx, rbx               ; índice de byte actual

.loop_bytes:
    cmp rcx, rdx
    jge .terminado

    ; obtener byte actual
    movzx rax, byte [rsi + rcx]

    ; nibble alto
    mov bl, al
    shr bl, 4
    movzx bx, byte [tabla_hex + rbx]
    mov [rdi], bl
    inc rdi

    ; nibble bajo
    mov bl, al
    and bl, 0Fh
    movzx bx, byte [tabla_hex + rbx]
    mov [rdi], bl
    inc rdi

    ; agregar guion si se desea, pero no después del último
    mov al, r11b
    cmp al, 1
    jne .pasar_guion

    cmp rcx, rcx - 1
    je .pasar_guion

    mov byte [rdi], '-'
    inc rdi

.pasar_guion:
    inc rcx
    jmp .loop_bytes

.terminado:
    mov byte [rdi], 0      ; null terminator
    ret