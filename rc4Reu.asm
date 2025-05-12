; rc4.asm - función RC4 reutilizable

section .data
    S times 256 db 0    ; Tabla de permutación S

section .text
global rc4_encrypt

; Entradas:
;   RSI = puntero a texto plano (se modificará in-place)
;   RDI = puntero a clave
;   RCX = longitud del texto
;   RDX = longitud de la clave
; Salida:
;   El texto cifrado sobrescribe el original en [RSI]

rc4_encrypt:
    push rbx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13

    ; ======================
    ; Inicializar S[i] = i
    ; ======================
    xor r13, r13
.init_s:
    mov byte [S + r13], r13b
    inc r13
    cmp r13, 256
    jne .init_s

    ; ======================
    ; KSA: Key Scheduling Algorithm
    ; ======================
    xor rbx, rbx       ; j = 0
    xor r13, r13       ; i = 0
.ksa_loop:
    movzx r8, byte [S + r13]

    ; key[i mod keylen]
    mov rax, r13
    xor rdx, rdx
    div rdx, rdx
    mov rax, r13
    xor rdx, rdx
    mov r11, rdx
    movzx r9, byte [rdi + r11]

    add rbx, r8
    add rbx, r9
    and rbx, 0xFF

    ; Swap S[i], S[j]
    mov al, [S + r13]
    mov bl, [S + rbx]
    mov [S + r13], bl
    mov [S + rbx], al

    inc r13
    cmp r13, 256
    jne .ksa_loop

    ; ======================
    ; PRGA: Pseudo-random generation
    ; ======================
    xor r13, r13      ; i = 0
    xor rbx, rbx      ; j = 0
    xor r8, r8        ; índice de texto

.prga_loop:
    inc r13
    and r13, 0xFF

    movzx r9, byte [S + r13]
    add rbx, r9
    and rbx, 0xFF

    ; Swap S[i], S[j]
    mov al, [S + r13]
    mov bl, [S + rbx]
    mov [S + r13], bl
    mov [S + rbx], al

    ; K = S[(S[i] + S[j]) mod 256]
    movzx r10, byte [S + r13]
    movzx r11, byte [S + rbx]
    add r10, r11
    and r10, 0xFF

    ; Texto cifrado: texto XOR K
    mov al, [S + r10]
    xor al, [rsi + r8]
    mov [rsi + r8], al

    inc r8
    cmp r8, rcx
    jne .prga_loop

    ; ======================
    ; Restaurar y salir
    ; ======================
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rbx
    ret