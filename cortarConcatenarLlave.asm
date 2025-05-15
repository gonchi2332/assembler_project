section .text
global cortar_y_concatenar

cortar_y_concatenar:
    lea rdx, [cinco_verhoeff]      
    add rdx, r9 
    mov rcx, r9                   
    rep movsb                   
    ret