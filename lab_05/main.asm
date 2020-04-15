EXTERN ProcessBinary: far
EXTERN OutBinary: far
EXTERN OutHex: far
EXTERN OutDecimalSign: far
EXTERN ClearScreen: far

extern PrintStringOnEs: far
extern PrintNextLine: far
extern InputSymbol: far
extern PrintSymbol: far

Stack SEGMENT BYTE STACK 'Stack'
    db 100 DUP(?)
Stack ENDS    

NumberSeg SEGMENT BYTE 'DATA'
    source     dw  3030h
    hex        db  4 DUP(30h)
    decimal    db  6 DUP(30h)
NumberSeg ENDS

MessageSeg SEGMENT BYTE 'MENU'
    menuMsg                 db '     MENU$'
    inputMsg                db '1) Input non-sign 16 bites binary$'
    outBinaryMsg            db '2) Print inputed number in non-sign binary$'
    outHexMsg               db '3) Print inputed number in non-sign hex$'
    outDecimalSignMsg       db '4) Print inputed number in decimal (sign)$'
    exitMsg                 db '0) Exit$'
    incorrectInputMsg       db 'Pls, input number, according to menu$'
MessageSeg ENDS

FuncSeg SEGMENT DWORD 'FUNCS'
    Funcs dd Exit, ProcessBinary, OutBinary, OutHex, OutDecimalSign
FuncSeg ENDS

ASSUME CS:CodeSeg, SS:Stack, DS:FuncSeg, ES:MessageSeg, ES:NumberSeg

CodeSeg SEGMENT PARA 'Code'

PrintMenu proc near
    push dx

    call PrintNextLine

    mov dx, OFFSET menuMsg
    call PrintStringOnEs
    call PrintNextLine

    mov dx, OFFSET inputMsg
    call PrintStringOnEs
    call PrintNextLine

    mov dx, OFFSET outBinaryMsg
    call PrintStringOnEs
    call PrintNextLine

    mov dx, OFFSET outHexMsg
    call PrintStringOnEs
    call PrintNextLine

    mov dx, OFFSET outDecimalSignMsg
    call PrintStringOnEs
    call PrintNextLine

    mov dx, OFFSET exitMsg
    call PrintStringOnEs
    call PrintNextLine

    pop dx
    ret
PrintMenu EndP

Exit proc near
    mov ah, 4ch
    int 21h
Exit EndP
Main:
    mov ax, FuncSeg
    mov ds, ax
    mov ax, MessageSeg
    mov es, ax
    
    call PrintMenu
    jmp EndCyclePart
InputCycle:
    call PrintMenu

    sub al, 30h
    cmp al, 4
    jbe CorrectInput
    
    mov dx, OFFSET incorrectInputMsg
    call PrintStringOnEs
    call PrintNextLine

    jmp EndCyclePart

    CorrectInput:
        push es
        push dx
        push bx
        push ax

        mov dx, NumberSeg
        mov es, dx
        mov dx, OFFSET source

        mov ah, 0
        mov bh, 4
        mul bh
        mov bx, ax
        call Funcs[bx]
        
        pop ax
        pop bx
        pop dx
        pop es
    
    EndCyclePart:
        call InputSymbol
        call ClearScreen

        push dx
        mov dl, al
        call PrintSymbol
        pop dx

        jmp InputCycle
EndCycle: ; unreached
    call Exit

CodeSeg ENDS

END Main