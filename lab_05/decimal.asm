PUBLIC OutDecimalSign

ASSUME CS:CodeSeg

CodeSeg SEGMENT WORD 'Processing'


; input - in stack segment, offset
OutDecimalSign proc far
    add ah, 1
    ret
OutDecimalSign ENDP
CodeSeg ENDS
END