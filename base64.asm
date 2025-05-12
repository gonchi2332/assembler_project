extern GetStdHandle
extern WriteFile
extern ExitProcess

section .data
    ; Diccionario exacto del documento (case-sensitive)
    base64_table db "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz+/"
    input dd 19058106        ; Valor del ejemplo del documento
    output db 6 dup(0)       ; Buffer de salida (5 chars + null)
    bytes_written dq 0

section .text
global main
main:
    sub rsp, 40             
    mov eax, [rel input]     
    lea rsi, [rel base64_table]
    lea rdi, [rel output]
    xor rbx, rbx             

.encode_loop:
    xor edx, edx
    mov ecx, 64              ; Base 64
    div ecx                  ; EAX = cociente, EDX = residuo (0-63)

    ; Mapear residuo a carácter
    mov cl, [rsi + rdx]
    mov [rdi + rbx], cl
    inc rbx

    test eax, eax            
    jnz .encode_loop

    ; Invertir el resultado (los dígitos se generan al revés)
    mov rcx, rbx
    shr rcx, 1               ; Mitad de la longitud
    jz .print               ; Saltar si longitud <= 1

    lea rdi, [rel output]
    mov rsi, rdi
    add rsi, rbx
    dec rsi                  ; RSI apunta al último carácter

.reverse:
    mov al, [rdi]
    mov ah, [rsi]
    mov [rsi], al
    mov [rdi], ah
    inc rdi
    dec rsi
    loop .reverse

.print:
    mov byte [rdi + rbx], 10 ; LF
    inc rbx

    ; Obtener handle de salida estándar
    mov ecx, -11             ; STD_OUTPUT_HANDLE
    call GetStdHandle

    ; Escribir resultado
    mov rcx, rax             ; Handle
    lea rdx, [rel output]    ; Buffer
    mov r8d, ebx             ; Longitud
    lea r9, [rel bytes_written]
    sub rsp, 32
    call WriteFile
    add rsp, 32

    ; Salir
    xor ecx, ecx
    call ExitProcess