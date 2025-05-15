%include "C:\Users\israe\Documents\UMSS\Assembly\assembler_project\verhoeffReu.asm"
%include "C:\Users\israe\Documents\UMSS\Assembly\assembler_project\tamcad.asm"
%include "C:\Users\israe\Documents\UMSS\Assembly\assembler_project\sum_cad.asm"
%include "C:\Users\israe\Documents\UMSS\Assembly\assembler_project\int_a_cad.asm"
%include "C:\Users\israe\Documents\UMSS\Assembly\assembler_project\llaveDos.asm"
%include "C:\Users\israe\Documents\UMSS\Assembly\assembler_project\rc4Reu.asm"
%include "C:\Users\israe\Documents\UMSS\Assembly\assembler_project\hex_a_ascii.asm"

extern GetStdHandle
extern WriteFile
extern ExitProcess

section .data
    numero_autorizacion db "29040011007", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    numero_factura      db "1503", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    nit_cliente         db "4189179011", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    fecha_transaccion   db "20070702", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    monto_transaccion   db "2500", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    llave_dosificacion  db "9rCB7Sv4X29d)5k7N%3ab89p-3(5[A", 0, 0, 0, 0, 0, 0
    tam_llave equ $ - llave_dosificacion - 1
    sum_dig times 18 db 0
    resultado db 0         ; aquí guardaremos AL como ASCII
    escrito dq 0
    indice_llave db 0
    mensaje db "Resultado final", 10, 0

section .bss
    cinco_verhoeff resb 5
    inc_cinco_verhoeff resb 5
    cad_concatenada    resb 116
    cypher1 resb 116
    cad_cypher1 resb 233
    sum1 resb 1
    sum2 resb 1
    sum3 resb 1
    sum4 resb 1
    sum5 resb 1
    sum_total resb 1
    base resb 5
    cypher2 resb 10
    monto_completo    resb 12
    fragmento resb 32

section .text
global main
main:
    
    mov rbp, rsp ; debug
    sub rsp, 40    
    xor r13, r13
    lea rsi, [numero_factura]
    call verhoeff
    call verhoeff
    call sum_cad
    
    lea rsi, [nit_cliente]
    call verhoeff
    call verhoeff
    call sum_cad
    
    lea rsi, [fecha_transaccion]
    call verhoeff
    call verhoeff
    call sum_cad
    
    lea rsi, [monto_transaccion]
    call verhoeff
    call verhoeff
    call sum_cad
    
    ; en r13 esta la suma de las cad en modo int, a continuacion lo convertimos
    ; a una cadena para poder sacar su verhoeff 
    lea r14, [sum_dig]
    call int_a_cad
    
    lea rsi, [sum_dig]
    xor rcx, rcx
    .cinco_ver:
        call verhoeff
        mov [cinco_verhoeff + rcx], al
        sub rax, '0'
        inc rax
        mov [inc_cinco_verhoeff + rcx], al
        inc rcx
        cmp rcx, 5
        jne .cinco_ver

    xor rcx, rcx
    lea rdi, [llave_dosificacion]
    .particionar_loop:
        movzx r8, byte [inc_cinco_verhoeff + rcx]
    
        cmp rcx, 0
        je .autorizacion
        cmp rcx, 1
        je .factura
        cmp rcx, 2
        je .nit
        cmp rcx, 3
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
        call concatenar_cad
        inc rcx
        cmp rcx, 5
        jl .particionar_loop
    
    mov byte [indice_llave], 0
    lea rsi, [numero_autorizacion]
    call tamcad
    mov r8, rcx
    lea rsi, [cad_concatenada]
    lea rdi, [numero_autorizacion] 
    call concatenar_cad
    lea rsi, [numero_factura]
    call tamcad
    mov r8, rcx
    lea rsi, [cad_concatenada]
    lea rdi, [numero_factura] 
    call concatenar_cad
    lea rsi, [nit_cliente]
    call tamcad
    mov r8, rcx
    lea rsi, [cad_concatenada]
    lea rdi, [nit_cliente] 
    call concatenar_cad
    lea rsi, [fecha_transaccion]
    call tamcad
    mov r8, rcx
    lea rsi, [cad_concatenada]
    lea rdi, [fecha_transaccion] 
    call concatenar_cad
    lea rsi, [monto_transaccion]
    call tamcad
    mov r8, rcx
    lea rsi, [cad_concatenada]
    lea rdi, [monto_transaccion] 
    call concatenar_cad
    
    xor r8, r8
    mov r8, 5
    mov byte [indice_llave], 0
    lea rsi, [llave_dosificacion]
    lea rdi, [cinco_verhoeff]   
    call concatenar_cad 

    lea rsi, [cad_concatenada]
    lea rdi, [cypher1]  
    call encripcion_rc4

    ; Llamamos a tamcad porque da el tamano de cad_concatenada, que es igual que cypher1
    call tamcad
    lea rsi, [cypher1]
    lea rdi, [cad_cypher1]
    xor r11, r11
    call hex_a_ascii
    
    xor rcx, rcx
    call ExitProcess  

      
            
;imprimir resultados
imprimir_string:
    ; rsi debe apuntar a la cadena que quieres imprimir
    ; rdx debe contener la longitud de la cadena
    push rcx
    push rdx
    push r8
    push r9

    mov rcx, [resultado]
    mov r8, rdx               ; Número de bytes a escribir
    lea r9, [escrito]         ; Dirección para almacenar bytes escritos
    xor rax, rax              ; LPOVERLAPPED = NULL
    push rax                  ; Empujamos NULL al stack
    call WriteFile
    add rsp, 8                ; Limpiamos el parámetro en stack

    pop r9
    pop r8
    pop rdx
    pop rcx
    ret    