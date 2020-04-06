PUBLIC ConvertBinToDecimal

ASSUME CS:CodeSeg

CodeSeg SEGMENT WORD 'Converting'


; input - in stack segment, offset
ConvertBinToDecimal proc far
    add ah, 5
    ret
ConvertBinToDecimal ENDP
CodeSeg ENDS
END