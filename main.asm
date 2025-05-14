%include "D:\Universidad\Taller bajo nivel de programacion\PrimerParcial2025\assembler_project\verhoeffReu.asm"
%include "D:\Universidad\Taller bajo nivel de programacion\PrimerParcial2025\assembler_project\tamcad.asm"
%include "D:\Universidad\Taller bajo nivel de programacion\PrimerParcial2025\assembler_project\sum_cad.asm"
%include "D:\Universidad\Taller bajo nivel de programacion\PrimerParcial2025\assembler_project\int_a_cad.asm"
%include "D:\Universidad\Taller bajo nivel de programacion\PrimerParcial2025\assembler_project\cortarConcatenarLlave.asm"

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
    handle_stdout dq 0
    mensaje db "Resultado final", 10, 0

section .bss
    cinco_verhoeff resb 5
    fecha_completa    resb 12
    monto_completo    resb 12

section .text
global main
main:
    mov rbp, rsp; for correct debugging
    mov rcx, -11
    call GetStdHandle
    mov [handle_stdout], rax
    
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
    
    ; Paso 2: Particionar la Llave de Dosificación
    
    lea rsi, [cinco_verhoeff]        
    movzx r8, byte [rsi]             
    inc r8                           
    mov [cinco_verhoeff], r8         
    
    movzx r8, byte [rsi + 1]         
    inc r8                           
    mov [cinco_verhoeff + 1], r8     
    
    movzx r8, byte [rsi + 2]        
    inc r8                           
    mov [cinco_verhoeff + 2], r8     
    
    movzx r8, byte [rsi + 3]         
    inc r8                           
    mov [cinco_verhoeff + 3], r8     
    
    movzx r8, byte [rsi + 4]         
    inc r8                           
    mov [cinco_verhoeff + 4], r8  

   
    movzx r8, byte [cinco_verhoeff]  
    mov r9, r8                      
    lea rsi, [numero_autorizacion]   
    call cortar_y_concatenar        
    
    
    movzx r8, byte [cinco_verhoeff + 1] 
    mov r9, r8                          
    lea rsi, [numero_factura]           
    call cortar_y_concatenar           
    
  
    movzx r8, byte [cinco_verhoeff + 2] 
    mov r9, r8                          
    lea rsi, [nit_cliente]              
    call cortar_y_concatenar          
    
   
    movzx r8, byte [cinco_verhoeff + 3] 
    mov r9, r8                          
    lea rsi, [fecha_transaccion]        
    call cortar_y_concatenar          
    
    
    movzx r8, byte [cinco_verhoeff + 4] 
    mov r9, r8                          
    lea rsi, [monto_transaccion]        
    call cortar_y_concatenar  

    xor ecx, ecx
    call ExitProcess  

      
            
;imprimir resultados
imprimir_string:
    ; rsi debe apuntar a la cadena que quieres imprimir
    ; rdx debe contener la longitud de la cadena
    push rcx
    push rdx
    push r8
    push r9

    mov rcx, [handle_stdout]
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