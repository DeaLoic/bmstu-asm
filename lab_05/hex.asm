PUBLIC OutHex

ASSUME CS:CodeSeg

CodeSeg SEGMENT WORD 'Processing'


; input - in stack segment, offset
OutHex proc far
    add ah, 2
    ret
OutHex ENDP
CodeSeg ENDS
END