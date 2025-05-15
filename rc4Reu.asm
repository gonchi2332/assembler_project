; rc4.asm - función RC4 reutilizable
section .data
    tabla_per times 256 db 0    ; Tabla de permutación S

section .text
global encripcion_rc4

; Entradas:
;   RSI = puntero a texto plano (se modificará in-place)
;   RDI = puntero a texto cifrado
;   RCX = longitud del texto
; Salida:
;   El texto cifrado [RDI]

encripcion_rc4:
    mov rbp, rsp; for correct debugging
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
    xor rcx, rcx
    xor r8, r8
.popular_lista:
    mov byte [tabla_per + r13], r13b
    inc r13
    cmp r13, 256
    jne .popular_lista

    ; ======================
    ; KSA: Key Scheduling Algorithm
    ; ======================
    xor rbx, rbx       ; j = 0
    xor r13, r13       ; i = 0
.ksa_loop:
    ;j := (j + S[i] + key[i mod tam_llave]) mod 256
    movzx r8, byte [tabla_per + r13]

    ; key[i mod tam_llave]
    push rbx
    mov rax, r13
    xor rdx, rdx
    mov rbx, tam_llave
    div rbx
    movzx r9, byte [llave_dosificacion + rdx]
    pop rbx

    add rbx, r8
    add rbx, r9
    and rbx, 0xFF
    
    ; Swap tabla_per[i], tabla_per[j]
    mov al, [tabla_per + r13]
    mov cl, [tabla_per + rbx]
    mov [tabla_per + r13], cl
    mov [tabla_per + rbx], al

    inc r13
    cmp r13, 256
    jne .ksa_loop

    ; ======================
    ; PRGA: Pseudo-random generation
    ; ======================
    xor r13, r13      ; i = 0
    xor rbx, rbx      ; j = 0
    xor r8, r8        ; índice de texto
    call tamcad       ; rcx = tamano texto

.prga_loop:
    inc r13
    and r13, 0xFF

    movzx r9, byte [tabla_per + r13]
    add rbx, r9
    and rbx, 0xFF

    ; Swap tabla_per[i], tabla_per[j]
    mov al, [tabla_per + r13]
    mov dl, [tabla_per + rbx]
    mov [tabla_per + r13], dl
    mov [tabla_per + rbx], al

    ; K = tabla_per[(tabla_per[i] + tabla_per[j]) mod 256]
    movzx r10, byte [tabla_per + r13]
    movzx r11, byte [tabla_per + rbx]
    add r10, r11
    and r10, 0xFF

    ; Texto cifrado: texto XOR K
    mov al, [tabla_per + r10]
    xor al, [rsi + r8]
    mov [rdi + r8], al

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