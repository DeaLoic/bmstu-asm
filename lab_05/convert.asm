PUBLIC ConvertBinToDecimalSign
PUBLIC ConvertBinToHex

ASSUME CS:CodeSeg

CodeSeg SEGMENT WORD 'Converting'


; input - ex:bx - target. dx - binary
ConvertBinToDecimalSign proc far
        push ax
        push bx
        push cx
        push dx

        push bp
        mov bp, sp
        sub sp, 12
        xor ax, ax
        mov cx, 12
    SetNull:
            dec bp
            mov byte ptr [bp], 0
            loop SetNull
        add bp, 12
        mov byte ptr [bp - 2], 1

    SignHandle:
            push dx
            rcl dx, 1
            rcl al, 1
            pop dx
            cmp al, 0
            je IsPositive

            mov byte ptr es:[bx], '-'
            neg dx
            inc bx
            dec cx
            xor ax, ax
            jmp MainCycle
            
            IsPositive:
                mov byte ptr es:[bx], 0
                inc bx
                xor ax, ax
    MainCycle:
            cmp cx, 15
            je MainCycleEnd

            rcr dx, 1
            rcl al, 1

            cmp al, 0
            je NextIterationPreparing
            call AddingStack

        NextIterationPreparing:
            dec bp
            call TwiceOnStack
            inc bp

            inc cx
            xor al, al
            jmp MainCycle

    MainCycleEnd:
        mov bp, sp
        add bp, 3
        xor cx, cx
    ReverseWriteCycle:
            cmp cx, 5
            jae Exit

            mov al, byte ptr [bp]
            add al, 30h
            mov byte ptr es:[bx], al

            inc bx
            add bp, 2
            inc cx
            jmp ReverseWriteCycle
        sub bx, 6
    Exit:
        add sp, 12
        pop bp
        pop dx
        pop cx
        pop bx
        pop ax
    ret

ConvertBinToDecimalSign ENDP

TwiceOnStack proc near
        push ax
        push cx
        push bp
        dec bp
        mov cx, 0
    TwiceCycle:
        cmp cx, 6
        jae TwiceCycleEnd

        xor ax, ax
        mov al, byte ptr [bp]
        add al, al
        mov byte ptr [bp], al

        sub bp, 2
        inc cx
        jmp TwiceCycle
    TwiceCycleEnd:

        pop bp
        pop cx
        pop ax
        call Normalization
    ret
TwiceOnStack ENDP

AddingStack proc near
        call AddingUnnormalStack
        call Normalization
    ret
AddingStack ENDP

AddingUnnormalStack proc near
        push ax
        push cx
        push bp
        dec bp

        xor cx, cx
    AddingCycle:
        cmp cx, 5
        jae AddingCycleEnd

        mov al, byte ptr [bp]
        add al, byte ptr [bp - 1]
        mov byte ptr [bp], al
        
        inc cx
        sub bp, 2
        jmp AddingCycle
    AddingCycleEnd:
        pop bp
        pop cx
        pop ax
    ret
AddingUnnormalStack ENDP

Normalization proc near
        push cx
        push bp
        dec bp
        xor cx, cx
    MainNormalizationCycle:
        cmp cx, 5
        je Exit
        
        DigitCycle:
            cmp byte ptr [bp], 10
            jb IncCounter

            sub byte ptr [bp], 10
            inc byte ptr [bp - 2]
            jmp DigitCycle
        
        IncCounter:
            inc cx
            sub bp, 2
            jmp MainNormalizationCycle
    
    Exit:
        pop bp
        pop cx
    ret
Normalization ENDP

; input - ex:bx - target. dx - binary
ConvertBinToHex proc far
        push ax
        push cx

        mov cl, 4
        xor ax, ax
        mov al, dh
        and al, 11110000b
        ror ax, cl
        call HexToChar
        mov byte ptr es:[bx], al

        mov al, dh
        and al, 00001111b
        call HexToChar
        mov byte ptr es:[bx + 1], al

        xor ax, ax
        mov al, dl
        and al, 11110000b
        ror ax, cl
        call HexToChar
        mov byte ptr es:[bx + 2], al

        mov al, dl
        and al, 00001111b
        call HexToChar
        mov byte ptr es:[bx + 3], al

        pop cx
        pop ax
    ret
ConvertBinToHex ENDP

HexToChar proc near
        cmp al, 10
        jae IsLetter

        add al, 30h
        jmp Exit

    IsLetter:
        add al, 55 ; to letters

    Exit:
    ret
HexToChar ENDP

CodeSeg ENDS
END