public matrixInput
public logicTarget
public matrixOut

MatrixS SEGMENT PARA 'MatrixOffsets'
    X label BYTE
    ORG 1
    Y label BYTE
    ORG 2
    body label BYTE
MatrixS ENDS

ASSUME DS:MatrixS, CS:CodeS

CodeS SEGMENT PARA 'Code'

; input symb in dl
printSymbol proc near
    push ax
    mov ah, 2
    int 21h
    pop ax
    ret
printSymbol endp

printSpace proc near
    push dx
    mov dl, 20h
    call printSymbol
    pop dx
    ret
printSpace endp

nextLinePrint proc near
    push dx
    mov dl, 10
    call printSymbol
    mov dl, 13
    call printSymbol
    pop dx
    ret
nextLinePrint endp

; result in al
inputSymbol proc near
    push bx
    push ax
    mov ah, 1
    int 21h
    mov bl, al
    pop ax
    mov al, bl
    pop bx
    ret
inputSymbol endp

; ds - source matrix segment. bx - offset
matrixInput proc far
    
    call inputSymbol  ; read x symbol
    sub al, 30h       ; transform to digit
    
    cmp al, 10     
    jae errorExit  ; если не цифра - выход с ошибкой
    mov ah, 0      ; иначе - сохранить
    push ax

    call printSpace

    call inputSymbol      ; read y symbol
    sub al, 30h           ; transform to digit
    
    cmp al, 10     
    jae errorExit  ; если не цифра - выход с ошибкой

    call nextLinePrint
    mov byte ptr [bx + offset Y], al ; иначе - записать
    pop ax
    mov byte ptr [bx + offset X], al

    mul byte ptr [bx + offset Y]

    cmp ax, 0
    jna errorExit

    push cx
    push dx
    mov dx, bx
    mov ch, byte ptr [bx + offset X]
    add bx, offset body

    mov ah, 1 ; set to optimixation input

    readCycle:
        cmp ch, 0
        jna readCycleEnd
        xchg bx, dx
        mov cl, byte ptr [bx + offset Y]
        xchg bx, dx

        readLineCycle:
            cmp cl, 0
            jna reaLineCycleEnd

            int 21h                  ; input
            mov byte ptr ds:[bx], al ; save
            call printSpace
            inc bx
            dec cl
            jmp readLineCycle

        reaLineCycleEnd:
        dec ch
        call nextLinePrint
        jmp readCycle
    readCycleEnd:

    mov bx, dx
    pop dx
    pop cx
    jmp correctExit

    errorExit:
        mov ax, 1
        ret
    correctExit:
        mov ax, 0
        ret

matrixInput endp


matrixOut proc far
    push ax ; pusha from i286
    push bx
    push cx
    push dx

    mov ax, 0
    mov al, byte ptr [bx + offset X]
    mul byte ptr [bx + offset Y]

    cmp ax, 0
    jna errorExit

    mov ch, byte ptr [bx + offset X]
    mov ax, bx
    add bx, offset body
    
    printMatrixCycle:
        cmp ch, 0
        jna printMatrixCycleEnd

        xchg ax, bx
        mov cl, byte ptr [bx + offset Y]
        xchg ax, bx
        printLineCycle:
            cmp cl, 0
            jna printLineCycleEnd

            mov dl, byte ptr ds:[bx]
            call printSymbol
            call printSpace
            inc bx
            dec cl
            jmp printLineCycle
        printLineCycleEnd:

        dec ch
        call nextLinePrint
        jmp printMatrixCycle
    
    printMatrixCycleEnd:

    mov bx, ax
    pop dx
    pop cx
    pop bx
    pop ax
    mov ax, 0
    ret

    errorExit:
        pop cx
        pop bx
        pop ax
        mov ax, 1
        ret
        
matrixOut endp

logicTarget proc far
    ret
logicTarget endp
CodeS ENDS
END