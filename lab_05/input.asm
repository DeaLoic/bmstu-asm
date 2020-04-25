public InputBinary

extern InputSymbol: far
extern PrintStringOnEs: far
extern PrintNextLine: far

MessageSeg SEGMENT WORD 'Message'
    overflowMsg    db 'Number too big. Deny$'
    notBinaryMsg   db 'Enter only 1 or 0. Deny$'
    emptyInputMsg     db 'Input at least one digit$. Deny'
MessageSeg ENDS

ASSUME CS:CodeSeg, ES:MessageSeg

CodeSeg SEGMENT WORD 'Input'

SetFalseByCl proc near
    clc
    call SetToDxByCl
    ret
SetFalseByCl endp

SetTrueByCl proc near
    stc
    call SetToDxByCl
    ret
SetTrueByCl endp

SetToDxByCl proc near
    push ax
    mov ax, 0
    rcl ax, cl
    or dx, ax
    pop ax
    ret
SetToDxByCl endp

; Output - dx. al - error
InputBinary proc far
        push ds
        push es
        push dx
        push cx
        push bx
        push ax

        mov ax, MessageSeg
        mov es, ax

        mov dx, 0
        mov cl, 16
    ReadCycle:
            cmp cl, 0
            je OverflowExit
            dec cl

            call InputSymbol

            cmp al, 0Dh ; EOL check
            je ReadCycleEnd

            sub al, 30h
            cmp al, 1
            ja NotBinaryExit
            je SetTrue

            SetFalse:
                call SetFalseByCl
                jmp ReadCycle
            SetTrue:
                call SetTrueByCl
                jmp ReadCycle

    ReadCycleEnd:

        cmp cl, 15
        je EmptyInput

        ror dx, cl
        jmp CorrectExit

    EmptyInput:
        mov dx, offset emptyInputMsg
        jmp ErrorExit
    NotBinaryExit:
        mov dx, offset notBinaryMsg
        jmp ErrorExit
    OverflowExit:
        mov dx, offset overflowMsg
    ErrorExit:
        call PrintStringOnEs
        call PrintNextLine
        pop ax
        mov al, 1
        push ax
        jmp Exit
    CorrectExit:
        pop ax
        mov al, 0
        push ax
    Exit:
        pop ax
        pop bx
        pop cx
        pop dx
        pop es
        pop ds
    ret
InputBinary ENDP
CodeSeg ENDS
END