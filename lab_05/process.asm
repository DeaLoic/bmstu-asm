PUBLIC ProcessBinary

EXTERN InputBinary: far
EXTERN PrintNextLine: far
EXTERN ConvertBinToHex: far
EXTERN ConvertBinToDecimalSign: far
EXTERN InputBinary: far



NumberSeg SEGMENT PARA 'NumberOffset'
    source  LABEL BYTE
    ORG 2
    hex     LABEL BYTE
    ORG 6
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

    mov es:[bx], dx

    lea bx, [bx + OFFSET hex - OFFSET source]
    call ConvertBinToHex
    lea bx, [bx + OFFSET decimal - OFFSET hex]
    call ConvertBinToDecimalSign

    Exit:
        pop bx
        pop dx
    ret
ProcessBinary ENDP
CodeSeg ENDS
END