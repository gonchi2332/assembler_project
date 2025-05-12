extern ExitProcess

section .data
    key db '9rCB7Sv4X29d)5k7N%3ab89p-3(5[A71621'        ; Clave de 9 bytes
    keylen equ $ - key

    plaintext db '18isw'   ; Texto a cifrar
    textlen equ $ - plaintext

    S times 256 db 0          ; Tabla S

section .bss
    ciphertext resb textlen

section .text
    global main

main:
    mov rbp, rsp; for correct debugging
    ; Inicializar S[i] = i
    xor rcx, rcx
    xor rsi, rsi
.popular_lista:
    mov byte [S + rcx], cl
    inc rcx
    cmp rcx, 256
    jne .popular_lista

    ; KSA: Key Scheduling Algorithm
    xor rcx, rcx       ; i = 0
    xor rbx, rbx       ; j = 0
.ksa_loop:
    ;j := (j + S[i] + key[i mod keylength]) mod 256
    movzx rax, byte [S + rcx]

    push rax
    push rbx
    mov rax, rcx        ; copiar índice
    xor rdx, rdx        ; limpiar rdx antes de div
    mov rbx, keylen     ; divisor
    div rbx  
    movzx rsi, byte [key + rdx]
    mov rdx, rsi
    pop rax
    pop rbx
    
    ; Nuevo j
    add rbx, rax
    add rbx, rdx
    and rbx, 0xFF

    ; Swap S[i] y S[j]
    mov al, [S + rcx]
    mov ah, [S + rbx]
    mov [S + rcx], ah
    mov [S + rbx], al

    inc rcx
    cmp rcx, 256
    jne .ksa_loop

    ; PRGA: Generar keystream y cifrar
    xor rcx, rcx       ; i = 0
    xor rbx, rbx       ; j = 0
    xor rsi, rsi       ; índice de texto

.prga_loop:
    ; i := (i + 1) mod 256
    inc rcx
    and rcx, 0xFF
    
    ; j := (j + S[i]) mod 256
    movzx rax, byte [S + rcx]
    add rbx, rax
    and rbx, 0xFF

    ; Swap S[i], S[j]
    mov al, [S + rcx]
    mov ah, [S + rbx]
    mov [S + rcx], ah
    mov [S + rbx], al

    ; t := (S[i] + S[j]) mod 256
    movzx r8, byte [S + rcx]
    movzx r9, byte [S + rbx]
    add r8, r9
    and r8, 0xFF

    ;generar texto cifrado K := S[t]
    mov al, [S + r8]
    xor al, [plaintext + rsi]
    mov [ciphertext + rsi], al

    inc rsi
    cmp rsi, textlen
    jne .prga_loop

    ; Finalizar programa (sys_exit)
    mov rax, 60
    xor rdi, rdi
    xor ecx, ecx
    call ExitProcess
