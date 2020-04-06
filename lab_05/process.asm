PUBLIC ProcessBinary
EXTERN InputBinary: far

ASSUME CS:CodeSeg

CodeSeg SEGMENT WORD 'Processing'


; input - in stack segment, offset
ProcessBinary proc far
    push bx
    sub sp, 4
    mov bp, sp
    mov bx, [bp + 6] ; far => 2 position for cs:ip
    mov [bp - 4], bx ; 1 position for bx

    mov bx, [bp + 4]
    mov [bp - 6], bx

    call InputBinary
    ret
ProcessBinary ENDP
CodeSeg ENDS
END