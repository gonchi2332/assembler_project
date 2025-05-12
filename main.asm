%include "C:\Users\israe\Downloads\verhoeffReu.asm"
%include "C:\Users\israe\Downloads\tamcad.asm"

section .data
    numero_autorizacion db "29040011007", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    numero_factura      db "2500", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    nit_cliente         db "4189179011", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    fecha_transaccion   db "20070702", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    monto_transaccion   db "2500", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    ; Lista resultados
    mensaje db "Digito Verhoeff: ", 0
    resultado db 0         ; aquí guardaremos AL como ASCII
    escrito dq 0

section .bss
    sum_dig resb  15
    cinco_verhoeff resb 5
    fecha_completa    resb 12
    monto_completo    resb 12

extern GetStdHandle
extern WriteFile
extern ExitProcess

section .text
global main
main:
    mov rbp, rsp ; debug
    lea r8, [sum_dig]
    lea rsi, [numero_factura]
    call verhoeff
    call tamcad
    add al, '0'
    mov [rsi + rcx], al
    call verhoeff
    call tamcad
    add al, '0'
    mov [rsi + rcx], al
    
    mov rax, 4
    mov rbx, 1
    mov rdx, rcx
    mov rcx, numero_factura
    int 80h
    
    
    
    mov ecx, -11
    call GetStdHandle
    mov rcx, rax
    lea rdx, [numero_factura]
    mov r8d, 6                
    lea r9, [escrito]
    sub rsp, 32
    call WriteFile
    add rsp, 32

    xor ecx, ecx
    call ExitProcess    
    
    lea rsi, [nit_cliente]
    call verhoeff
    call tamcad
    add al, '0'
    mov [rsi + rcx], al
    call verhoeff
    call tamcad
    add al, '0'
    mov [rsi + rcx], al
    
    lea rsi, [fecha_transaccion]
    call verhoeff
    call tamcad
    add al, '0'
    mov [rsi + rcx], al
    call verhoeff
    call tamcad
    add al, '0'
    mov [rsi + rcx], al
    
    lea rsi, [monto_transaccion]
    call verhoeff
    call tamcad
    add al, '0'
    mov [rsi + rcx], al
    call verhoeff
    call tamcad
    add al, '0'
    mov [rsi + rcx], al