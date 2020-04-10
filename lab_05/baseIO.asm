public PrintSymbol, PrintSpace, InputSymbol, PrintNextLine, PrintStringOnEs, ClearScreen

ASSUME CS:CodeS

CodeS SEGMENT PARA 'baseIO'

; result in al
InputSymbol proc far
    push bx
    push ax
    mov ah, 1
    int 21h
    mov bl, al
    pop ax
    mov al, bl
    pop bx
    ret
InputSymbol endp

; input - dl
PrintSymbol proc far
    push ax
    mov ah, 2
    int 21h
    pop ax
    ret
PrintSymbol endp

; void
PrintSpace proc far
    push dx
    mov dl, 20h
    call PrintSymbol
    pop dx
    ret
PrintSpace endp

; void. Print '10' '13'
PrintNextLine proc far
    push dx
    mov dl, 10
    call PrintSymbol
    mov dl, 13
    call PrintSymbol
    pop dx
    ret
PrintNextLine endp

; input - es,dx
PrintStringOnEs proc far
    push ax
    push ds
    push es
    pop ds   ; ds = ex
    mov ah, 09h
    int 21h
    pop ds
    pop ax
    ret
PrintStringOnEs endp

ClearScreen proc far
    push ax
    mov ax, 3
    int 10h
    pop ax
    ret
ClearScreen endp

CodeS ENDS
END