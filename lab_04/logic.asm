public loweringMatrix

extern getSize: far
extern getElem: far
extern setElem: far

ASSUME CS:CodeS

CodeS SEGMENT PARA 'logic'

; input al
loweringSymbol proc near
    cmp al, 41h
    jb exit

    cmp al, 5Ah
    ja exit
    
    add al, 20h

    exit:
        ret
loweringSymbol endp

; input - ds:bx - matrix first (x)
loweringMatrix proc far
    push ax
    push cx
    push dx

    call getSize

    mov dl, cl
    handleCycle:
        cmp ch, 0
        jna handleCycleEnd

        mov cl, dl
        handleLineCycle:
            cmp cl, 0
            jna handleLineCycleEnd

            call getElem

            cmp ah, 0
            jg exit ; wrong size

            call loweringSymbol
            call setElem
        handleLineCycleContinue:
            dec cl
            jmp handleLineCycle
        handleLineCycleEnd:
        dec ch
        jmp handleCycle

    handleCycleEnd:

    exit:
        pop dx
        pop cx
        pop ax
        ret

loweringMatrix endp

CodeS ENDS
END