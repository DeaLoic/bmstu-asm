PUBLIC OutHex

EXTERN PrintNextLine: far

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


; input - dx:es
OutHex proc far
        push ax
        push bx
        push cx
        push dx

        mov bx, dx
        lea bx, [bx + OFFSET hex - OFFSET source]
        mov cx, 4
        mov ah, 2

    SkipLeadZero:
            mov byte ptr dl, byte ptr es:[bx]
            cmp dl, '0'
            jne OutCycle
            
            cmp cx, 1
            je OutCycle
            
            inc bx
            loop SkipLeadZero
    OutCycle:
            mov byte ptr dl, byte ptr es:[bx]
            int 21h
            inc bx
            loop OutCycle
        
        call PrintNextLine

        pop dx
        pop cx
        pop bx
        pop ax
    ret
OutHex ENDP
CodeSeg ENDS
END