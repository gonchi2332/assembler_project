; ensamblar con: nasm -f win64 verhoeff.asm -o verhoeff.obj
; enlazar con:   gcc verhoeff.obj -o verhoeff.exe
; correr:        ./verhoeff.exe

extern GetStdHandle
extern WriteFile
extern ExitProcess

section .data
    d db 0,1,2,3,4,5,6,7,8,9
      db 1,2,3,4,0,6,7,8,9,5
      db 2,3,4,0,1,7,8,9,5,6
      db 3,4,0,1,2,8,9,5,6,7
      db 4,0,1,2,3,9,5,6,7,8
      db 5,9,8,7,6,0,4,3,2,1
      db 6,5,9,8,7,1,0,4,3,2
      db 7,6,5,9,8,2,1,0,4,3
      db 8,7,6,5,9,3,2,1,0,4
      db 9,8,7,6,5,4,3,2,1,0

    p db 0,1,2,3,4,5,6,7,8,9
      db 1,5,7,6,2,8,3,0,9,4
      db 5,8,0,3,7,9,6,1,4,2
      db 8,9,1,6,0,4,3,5,2,7
      db 9,4,5,3,1,2,6,8,7,0
      db 4,2,8,6,5,7,3,9,0,1
      db 2,7,9,3,8,0,6,4,1,5
      db 7,0,4,6,9,1,3,2,5,8

    inv db 0,4,3,2,1,5,6,7,8,9

    ejemplo db "15031", 0
    salida  db 0
    escrito dq 0

section .text
global main

main:
    mov rbp, rsp; for correct debugging
    mov ebp, esp; for correct debugging
    mov rbp, rsp; for correct debugging
    sub rsp, 40           
    lea rsi, [rel ejemplo]
    call verhoeff

    add al, '0'
    mov [rel salida], al

    ; HANDLE hOut = GetStdHandle(-11)
    mov ecx, -11
    call GetStdHandle
    mov rcx, rax                ; primer parámetro: handle
    lea rdx, [rel salida]       ; segundo parámetro: buffer
    mov r8d, 1                  ; tercer parámetro: longitud
    lea r9, [rel escrito]       ; cuarto parámetro: ptr a bytes escritos
    sub rsp, 32                 ; espacio para 4to argumento
    call WriteFile
    add rsp, 32

    ; ExitProcess(0)
    xor ecx, ecx
    call ExitProcess

verhoeff:
    push rbx
    push rcx
    push rdx
    push r8
    push r9

    xor rbx, rbx                ; c = 0
    xor r8, r8                  ; i = 0
    
    inc r8                      ; i = 1
    lea r10, [rel p]            ; tabla p
    lea r11, [rel d]            ; tabla d
    lea r12, [rel inv]          ; tabla inv
    xor rcx, rcx

.find_end:
    mov al, [rsi + rcx]
    cmp al, 0
    je .start
    inc rcx
    jmp .find_end

.start:
    dec rcx
    xor r9, r9
    dec r9
.loop:
    cmp r9, rcx
    jge .done

    movzx rax, byte [rsi + rcx]  ; Obtener el dígito actual
    sub rax, '0'                ; Convertir a número

    ; Calcular p[i % 8][digito]
    mov rdx, r8
    and rdx, 7                  ; i % 8
    imul rdx, 10                ; *10 (filas en tabla p)
    add rdx, rax                ; +digito
    movzx rdx, byte [r10 + rdx] ; p[i%8][digito]

    ; Calcular d[c][p_result]
    mov rax, rbx                ; c
    imul rax, 10                ; *10 (filas en tabla d)
    add rax, rdx                ; +p_result
    movzx rbx, byte [r11 + rax] ; d[c][p_result]

    inc r8                      ; i++
    dec rcx                     ; siguiente dígito
    jmp .loop

.done:
    movzx rax, byte [r12 + rbx]

    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    ret