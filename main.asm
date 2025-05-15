%include "D:\Universidad\Taller bajo nivel de programacion\PrimerParcial2025\assembler_project\verhoeffReu.asm"
%include "D:\Universidad\Taller bajo nivel de programacion\PrimerParcial2025\assembler_project\tamcad.asm"
%include "D:\Universidad\Taller bajo nivel de programacion\PrimerParcial2025\assembler_project\sum_cad.asm"
%include "D:\Universidad\Taller bajo nivel de programacion\PrimerParcial2025\assembler_project\int_a_cad.asm"
%include "D:\Universidad\Taller bajo nivel de programacion\PrimerParcial2025\assembler_project\llaveDos.asm"

extern GetStdHandle
extern WriteFile
extern ExitProcess

section .data
    numero_autorizacion db "29040011007", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    numero_factura      db "1503", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    nit_cliente         db "4189179011", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    fecha_transaccion   db "20070702", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    monto_transaccion   db "2500", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    llave_dosificacion  db "9rCB7Sv4X29d)5k7N%3ab89p-3(5[A", 0 
    sum_dig times 18 db 0
    resultado db 0         ; aquí guardaremos AL como ASCII
    escrito dq 0

section .bss
    cinco_verhoeff resb 5
    fecha_completa    resb 12
    monto_completo    resb 12
    fragmento resb 32
    indice_llave resb 1

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


    ; Inicializar índice de corte de la llave
    mov byte [indice_llave], 0
    mov ecx, 0
    
    .particionar_loop:
        movzx r8, byte [cinco_verhoeff + rcx]
        sub r8, '0'
        inc r8  ;
    
        cmp ecx, 0
        je .autorizacion
        cmp ecx, 1
        je .factura
        cmp ecx, 2
        je .nit
        cmp ecx, 3
        je .fecha
        jmp .monto
    
    .autorizacion:
        lea rsi, [numero_autorizacion]
        jmp .continuar
    .factura:
        lea rsi, [numero_factura]
        jmp .continuar
    .nit:
        lea rsi, [nit_cliente]
        jmp .continuar
    .fecha:
        lea rsi, [fecha_transaccion]
        jmp .continuar
    .monto:
        lea rsi, [monto_transaccion]
    
    .continuar:
        call cortar_y_concatenar
        inc ecx
        cmp ecx, 5
        jl .particionar_loop

    xor ecx, ecx
    call ExitProcess    