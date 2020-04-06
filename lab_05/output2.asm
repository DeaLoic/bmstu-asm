PUBLIC OutBinary

ASSUME CS:CodeSeg

CodeSeg SEGMENT WORD 'Processing'


; input - in stack segment, offset
OutBinary proc far
    add ah, 3
    ret
OutBinary ENDP
CodeSeg ENDS
END