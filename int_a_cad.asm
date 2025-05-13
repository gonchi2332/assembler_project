section .text
global int_a_cad

; Entrada:
;   r13 → número entero a convertir
;   r14 → dirección donde se guardará la cadena ASCII (ej. una zona de db 0s)
; Salida:
;   [r14] contendrá la cadena ASCII del número

int_a_cad:
    xor rbx, rbx
    xor rcx, rcx
    mov rax, r13            ; copiar el número a rax para convertir
    mov rdi, r14            ; puntero al buffer donde guardar (rdi usado como base)
    
.guardar_digitos:
    xor rdx, rdx
    mov rbx, 10
    div rbx                 ; rax = rax / 10, rdx = rax % 10
    add dl, '0'             ; convierte dígito a ASCII
    mov [rdi + rcx], dl     ; guarda carácter en r14 + rcx
    inc rcx
    test rax, rax
    jnz .guardar_digitos

    ; ahora los caracteres están al revés en [r14]..[r14+rcx-1]
    ; vamos a invertirlos in-place usando rsi y rdi

    mov rsi, 0              ; índice inicio
    mov rdi, rcx
    dec rdi                 ; índice fin

.invertir:
    cmp rsi, rdi
    jge .done
    mov al, [r14 + rsi]
    mov bl, [r14 + rdi]
    mov [r14 + rsi], bl
    mov [r14 + rdi], al
    inc rsi
    dec rdi
    jmp .invertir

.done:
    ; opcional: null terminator al final
    mov byte [r14 + rcx], 0
    ret