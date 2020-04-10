PUBLIC ProcessBinary

EXTERN InputBinary: far
EXTERN PrintNextLine: far
EXTERN ConvertBinToHex: far
EXTERN ConvertBinToDecimalSign: far
EXTERN InputBinary: far



NumberSeg SEGMENT BYTE 'DATA'
    source  LABEL BYTE
    ORG 2
    hex     LABEL BYTE
    ORG 4
    decimal LABEL BYTE
NumberSeg ENDS

ASSUME CS:CodeSeg, ES:NumberSeg

CodeSeg SEGMENT WORD 'Processing'

; input - in es:dx - memory link. out - al - error
ProcessBinary proc far
    push dx
    push bx
    mov bx, dx
    call InputBinary
    call PrintNextLine

    cmp al, 0
    ja Exit

    mov [bx + OFFSET source], dx

    add bx, OFFSET hex
    call ConvertBinToHex
    add bx, OFFSET decimal
    call ConvertBinToDecimalSign

    Exit:
        pop bx
        pop dx
    ret
ProcessBinary ENDP
CodeSeg ENDS
END