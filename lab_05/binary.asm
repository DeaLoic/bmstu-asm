public InputBinary
PUBLIC OutBinary

extern InputSymbol: far
extern PrintStringOnEs: far
extern PrintNextLine: far

NumberSeg SEGMENT BYTE 'DATA'
    ORG 0
    source  LABEL BYTE
    ORG 2
    hex     LABEL BYTE
    ORG 6
    decimal LABEL BYTE
NumberSeg ENDS

ASSUME CS:CodeSeg

CodeSeg SEGMENT WORD 'Processing'

SetFalseDxByCl proc near
    clc
    call SetToDxByCl
    ret
SetFalseDxByCl endp

SetTrueDxByCl proc near
    stc
    call SetToDxByCl
    ret
SetTrueDxByCl endp

SetToDxByCl proc near
    push ax
    mov ax, 0
    rcl ax, cl
    or dx, ax
    pop ax
    ret
SetToDxByCl endp

; Output - dx. ax - error
InputBinary proc far
        push cx
        push dx

        mov dx, 0
        mov cl, 16
    ReadCycle:
            cmp cl, 0
            je ReadCycleEnd

            call InputSymbol

            cmp al, 0Dh ; EOL check
            je ReadCycleEnd

            sub al, 30h
            cmp al, 1
            ja NotBinaryExit
            je SetTrue

            SetFalse:
                call SetFalseDxByCl
                jmp DecCl
            SetTrue:
                call SetTrueDxByCl
            DecCl:
                dec cl
                jmp ReadCycle

    ReadCycleEnd:

        cmp cl, 16
        je EmptyInput

        ror dx, cl
        jmp CorrectExit

    EmptyInput:
        mov al, 2
        jmp ErrorExit
    NotBinaryExit:
        mov al, 3
        jmp ErrorExit
    ErrorExit:
        pop dx
        jmp Exit
    CorrectExit:
        add sp, 2 ; pass dx
        mov al, 0
    Exit:
        pop cx
    ret
InputBinary ENDP

; input - es:dx
OutBinary proc far
        push dx
        push cx
        push bx
        push ax

        mov bx, dx
        add bx, OFFSET source
        mov bx, es:[bx]
        mov dl, 00011000b
        mov cx, 16
        mov ah, 02h

    SkipLeadZero:
            rcl bx, 1
            rcl dl, 1
            cmp dl, '0'
            jne PrintBit
            cmp cx, 1
            je PrintBit
            rcr dl, 1

            loop SkipLeadZero

    PrintCycleStart:
            rcl bx, 1
            rcl dl, 1
        PrintBit:
            int 21h
            rcr dl, 1

            loop PrintCycleStart
    PrintCycleEnd:

            call PrintNextLine

    Exit:
            pop ax
            pop bx
            pop cx
            pop dx
    ret
OutBinary ENDP

CodeSeg ENDS
END