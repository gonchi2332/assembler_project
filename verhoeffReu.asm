; verhoeff.asm - función reutilizable

section .data
    d db 0,1,2,3,4,5,6,7,8,9
      db 1,2,3,4,0,6,7,8,9,5
      db 2,3,4,0,1,7,8,9,5,6
      db 3,4,0,1,2,8,9,5,6,7
      db 4,0,1,2,3,9,5,6,7,8
      db 5,9,8,7,6,0,4,3,2,1
      db 6,5,9,8,7,1,0,4,3,2
      db 7,6,5,9,8,2,1,0,4,3
      db 8,7,6,5,9,3,2,1,0,4
      db 9,8,7,6,5,4,3,2,1,0

    p db 0,1,2,3,4,5,6,7,8,9
      db 1,5,7,6,2,8,3,0,9,4
      db 5,8,0,3,7,9,6,1,4,2
      db 8,9,1,6,0,4,3,5,2,7
      db 9,4,5,3,1,2,6,8,7,0
      db 4,2,8,6,5,7,3,9,0,1
      db 2,7,9,3,8,0,6,4,1,5
      db 7,0,4,6,9,1,3,2,5,8

    inv db 0,4,3,2,1,5,6,7,8,9

section .text
global verhoeff

; Entradas:
;   RSI -> puntero a cadena ASCII de números (ej. "1503")
; Salida:
;   AL  <- dígito Verhoeff (0–9)

verhoeff:
    push rbx
    push rcx
    push rdx
    push r8
    push r9

    xor rbx, rbx                ; c = 0
    xor r8, r8                  ; i = 0
    
    inc r8                      ; i = 1
    lea r10, [rel p]            ; tabla p
    lea r11, [rel d]            ; tabla d
    lea r12, [rel inv]          ; tabla inv
    xor rcx, rcx
    xor rax, rax

.fin_cad:
    mov al, [rsi + rcx]
    cmp al, 0
    je .inicio
    inc rcx
    jmp .fin_cad

.inicio:
    dec rcx
    xor r9, r9
    dec r9
.loop:
    cmp r9, rcx
    jge .termino

    movzx rax, byte [rsi + rcx]
    sub rax, '0'

    mov rdx, r8
    and rdx, 7
    imul rdx, 10
    add rdx, rax
    movzx rdx, byte [r10 + rdx]

    mov rax, rbx
    imul rax, 10
    add rax, rdx
    movzx rbx, byte [r11 + rax]

    inc r8
    dec rcx
    jmp .loop

.termino:
    movzx rax, byte [r12 + rbx]
    ; Resultado final en AL

    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    ret
