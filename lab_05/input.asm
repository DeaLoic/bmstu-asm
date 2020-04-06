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

; input - in stack segment, offset
InputBinary proc far
        push bp
        mov bp, sp
        add bp, 2

        push ds
        push es
        push bx
        push cx
        push dx
        push ax

        mov ax, MessageSeg
        mov es, ax

        mov bx, [bp + 2]
        mov ds, bx
        mov bx, [bp + 4]
        ; ds:bx - target array. Registers in stack

        mov bp, sp
        sub sp, 16

        mov ch, 17
    ReadCycle:
            cmp ch, 0
            je OverflowExit
            dec ch

            call InputSymbol

            cmp al, 0Dh ; EOL check
            je ReadCycleEnd

            sub al, 30h
            cmp al, 1
            ja NotBinaryExit

            dec bp
            mov [bp], al
            jmp ReadCycle

    ReadCycleEnd:

        cmp ch, 16
        je EmptyInput
        mov cl, 1

    CopyFromBufCycle:
            cmp cl, ch
            jb SetZero
            
            cmp cl, 17
            je CorrectExit


            mov al, byte ptr [bp]
            dec sp
            jmp SetToMemory
        SetZero:
            mov al, 0
        SetToMemory:
            mov [bx], al
            inc cl
            inc bx
            jmp CopyFromBufCycle
    CopyFromBufCycleEnd:

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
        sub sp, 16
        pop ax
        mov ah, 1
        push ax
        jmp Exit
    CorrectExit:
        sub sp, 16
        pop ax
        mov ah, 0
        push ax
    Exit:
        pop ax
        pop dx
        pop cx
        pop bx
        pop es
        pop dx
        pop bp
    ret
InputBinary ENDP
CodeSeg ENDS
END