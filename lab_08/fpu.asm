section .text
global _isCircleBigger

; int isCircleBigger(double radius, double square)

_isCircleBigger:
    push ebp
    mov ebp, esp
    push edx

    fwait
    finit
    fld qword [ebp + 8] ; load radius
    fmul st0, st0

    fldpi
    fmul
    fcom qword [ebp + 16]

    fstsw ax
    mov dx, ax

    and dx, 0100010100000000b  ; take c3 c2 c0
    cmp dx, 0000000000000000b

    jne lesserEqual

    mov eax, 1
    jmp exit

lesserEqual:
    mov eax, 0

exit:
    pop edx
    pop ebp
    ret