section .text
global main
main:
    ;write your code here
    xor rax, rax
    xor rbx, rbx
.loop:
    mov rax, [rsi + rbx]
    sub rax, '0'
    cmp [r8 + rbx], 0
    je concat
.concat:
.suma: 
    ret