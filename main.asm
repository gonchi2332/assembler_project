%include "C:\Users\israe\Documents\UMSS\Assembly\assembler_project\verhoeffReu.asm"
%include "C:\Users\israe\Documents\UMSS\Assembly\assembler_project\tamcad.asm"
%include "C:\Users\israe\Documents\UMSS\Assembly\assembler_project\sum_cad.asm"
%include "C:\Users\israe\Documents\UMSS\Assembly\assembler_project\int_a_cad.asm"

extern GetStdHandle
extern WriteFile
extern ExitProcess

section .data
    numero_autorizacion db "29040011007", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    numero_factura      db "1503", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    nit_cliente         db "4189179011", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    fecha_transaccion   db "20070702", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    monto_transaccion   db "2500", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    sum_dig times 18 db 0
    resultado db 0         ; aquí guardaremos AL como ASCII
    escrito dq 0

section .bss
    cinco_verhoeff resb 5
    fecha_completa    resb 12
    monto_completo    resb 12

section .text
global main
main:
    mov rbp, rsp ; debug
    sub rsp, 40    
    xor r13, r13
    lea r14, [sum_dig]
    lea rsi, [numero_factura]
    call verhoeff
    call tamcad
    add al, '0'
    mov [rsi + rcx], al
    call verhoeff
    call tamcad
    add al, '0'
    mov [rsi + rcx], al
    call sum_cad
    
    lea rsi, [nit_cliente]
    call verhoeff
    call tamcad
    add al, '0'
    mov [rsi + rcx], al
    call verhoeff
    call tamcad
    add al, '0'
    mov [rsi + rcx], al
    call sum_cad
    
    lea rsi, [fecha_transaccion]
    call verhoeff
    call tamcad
    add al, '0'
    mov [rsi + rcx], al
    call verhoeff
    call tamcad
    add al, '0'
    mov [rsi + rcx], al
    call sum_cad
    
    lea rsi, [monto_transaccion]
    call verhoeff
    call tamcad
    add al, '0'
    mov [rsi + rcx], al
    call verhoeff
    call tamcad
    add al, '0'
    mov [rsi + rcx], al
    
    call sum_cad
    call int_a_cad
    lea rsi, [sum_dig]
    call verhoeff
    call tamcad
    mov [cinco_verhoeff], al
    add al, '0'
    mov [rsi + rcx], al
    call verhoeff
    call tamcad
    mov [cinco_verhoeff + 1], al
    add al, '0'
    mov [rsi + rcx], al
    call verhoeff
    call tamcad
    mov [cinco_verhoeff + 2], al
    add al, '0'
    mov [rsi + rcx], al
    call verhoeff
    call tamcad
    mov [cinco_verhoeff + 3], al
    add al, '0'
    mov [rsi + rcx], al
    call verhoeff
    call tamcad
    mov [cinco_verhoeff +4], al
    add al, '0'
    mov [rsi + rcx], al

    xor ecx, ecx
    call ExitProcess    