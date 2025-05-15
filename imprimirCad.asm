; -------------------------------------------------------
; imprimirCad.asm
; Subrutina para imprimir cadenas ASCII terminadas en 0
; Entradas:
;   RSI → dirección de la cadena terminada en 0
; Requiere que:
;   - La cadena esté correctamente terminada con 0
;   - El símbolo 'escrito' esté definido en el archivo principal
; -------------------------------------------------------

extern GetStdHandle
extern WriteFile
extern escrito          ; definido en el archivo main
                        ; ejemplo: escrito dq 0

section .data
nl db 0x0A              ; salto de línea

section .text
global imprimir_cadena

imprimir_cadena:
    push rcx
    push rdx
    push r8
    push r9
    push r10

    ; Calcular longitud (strlen)
    xor rcx, rcx
.strlen_loop:
    mov al, [rsi + rcx]
    cmp al, 0
    je .strlen_done
    inc rcx
    jmp .strlen_loop

.strlen_done:
    mov r10d, ecx  ; guardamos longitud en r10d

    ; Imprimir cadena con WriteFile
    mov edx, -11
    call GetStdHandle
    mov rcx, rax            ; handle
    mov rdx, rsi            ; buffer de texto
    mov r8d, r10d           ; longitud
    lea r9, [escrito]       ; bytes escritos
    sub rsp, 32
    call WriteFile
    add rsp, 32

    ; Imprimir salto de línea
    mov edx, -11
    call GetStdHandle
    mov rcx, rax
    lea rdx, [nl]
    mov r8d, 1
    lea r9, [escrito]
    sub rsp, 32
    call WriteFile
    add rsp, 32

    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    ret
