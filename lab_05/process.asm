PUBLIC ProcessBinary

EXTERN InputBinary: far
EXTERN PrintNextLine: far
EXTERN PrintStringDs: far
EXTERN ConvertBinToHex: far
EXTERN ConvertBinToDecimalSign: far
EXTERN InputBinary: far

MessageS SEGMENT PARA 'Message'
    welcomeInputBinaryMsg   db 'Pls, input non-sign 16 bit binary in direct format$'
    emptyInputMsg           db 'Empty input. Abort$'
    notBinaryMsg            db 'Input should contain only 1 and 0. Abort$'
MessageS ENDS

NumberSeg SEGMENT PARA 'NumberOffset'
    source  LABEL BYTE
    ORG 2
    hex     LABEL BYTE
    ORG 6
    decimal LABEL BYTE
NumberSeg ENDS

ASSUME CS:CodeSeg, ES:NumberSeg, DS:MessageS

CodeSeg SEGMENT WORD 'Processing'

ErrorHandler proc near
        cmp ax, 0
        je ExitEH

        push dx

        mov dx, OFFSET emptyInputMsg
        cmp ax, 1
        je OutError

        mov dx, OFFSET notBinaryMsg
        cmp ax, 2
        je OutError
    
    OutError:
        call PrintStringDs
        pop dx

    ExitEH:
    ret

ErrorHandler endp

; input - in es:dx - memory link. out - al - error
ProcessBinary proc far
    push dx
    push ds
    push bx

    mov bx, dx
    mov dx, MessageS
    mov ds, dx
    mov dx, OFFSET welcomeInputBinaryMsg
    call PrintStringDs
    call PrintNextLine
    

    call InputBinary
    call PrintNextLine

    call ErrorHandler

    cmp al, 0
    ja Exit

    mov es:[bx], dx

    lea bx, [bx + OFFSET hex - OFFSET source]
    call ConvertBinToHex
    lea bx, [bx + OFFSET decimal - OFFSET hex]
    call ConvertBinToDecimalSign

    Exit:
        pop bx
        pop ds
        pop dx
    ret
ProcessBinary ENDP
CodeSeg ENDS
END