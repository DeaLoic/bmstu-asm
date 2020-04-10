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
        sub sp, 16
        xor ax, ax
        xor cx, cx
    MainCycle:
            cmp cx, 15
            jae SignHandle

            ; sub bp, cl ; current handled symbol

            rcr dx, 1
            rcl al, 1
            cmp al, 0
            je SetZero

            call AddPower
            jmp IncCounter

        SetZero:
            sub bp, cx
            mov byte ptr [bp + 1], 0
            add bp, cx

        IncCounter:
            inc cx
            xor al, al
            jmp MainCycle
        SignHandle:
            rcr dx, 1
            rcl al, 1
            cmp al, 0
            je IsPositive

            mov byte ptr es:[bx], '-'

            IsPositive:
                mov byte ptr es:[bx], 0
    MainCycleEnd:
        mov bp, sp
        add bp, 15
        mov cx, 1
    ReverseWriteCycle:
            cmp cx, 16
            jae Exit

            mov al, byte ptr [bp]
            add al, 30h
            mov byte ptr es:[bx], al

            inc bx
            dec bp
            inc cx
            jmp ReverseWriteCycle
    
    Exit:
        add bp, 15
        pop bp
        pop dx
        pop cx
        pop bx
        pop ax
    ret

ConvertBinToDecimalSign ENDP

AddPower proc near
        call PoweringByAdd
        call AddingUnnormal
        call Normalization
    ret
AddPower ENDP

PoweringByAdd proc near
        push cx
        mov ax, 1
        cmp cx, 0
        je EndPowerCycle
        mov ax, 2
    MakePowerCycle:
            cmp cx, 0
            je EndPowerCycle

            add ax, ax
            dec cx
            jmp MakePowerCycle
    EndPowerCycle:
        
        pop cx
    ret
PoweringByAdd ENDP

AddingUnnormal proc near
        push bp
        add bp, cx
        inc bp
        push ax
        and al, 00001111b
        and ah, 00001111b
        add [bp], al
        add [bp + 2], ah
        pop ax
        push ax
        and al, 11110000b
        and ah, 11110000b
        add [bp + 1], al
        add [bp + 3], ah
        pop ax
        pop bp
    ret
AddingUnnormal ENDP

Normalization proc near
        push bp
        push cx
        add bp, cx
        inc bp
    MainNormalizationCycle:
        cmp cx, 15
        je Exit
        
        DigitCycle:
            cmp byte ptr [bp], 10
            jbe IncCounter

            sub byte ptr [bp], 10
            inc byte ptr [bp]
            jmp DigitCycle
        
        IncCounter:
            inc cx
            inc bp
            jmp MainNormalizationCycle
    
    Exit:
        pop cx
        pop bp
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