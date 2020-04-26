DataSeg SEGMENT BYTE 'Data'
    oldHandler dd 1
DataSeg EndS

StackSeg SEGMENT STACK 'Stack'
    db 2
StackSeg EndS

ASSUME DS:DataSeg, CS:CodeSeg, SS:StackSeg

CodeSeg SEGMENT  BYTE 'Code'

beep proc far
    push bx
    push es
    mov bx, 0B800h
    mov es, bx
    mov bx, 0
    mov word ptr es:[bx], 3132h
    pop es
    pop bx
    iret
beep endp


main:
        mov ax, DataSeg
        mov ds, ax

        mov ax, 351Ch
        int 21h

        mov word ptr oldHandler, bx
        mov word ptr oldHandler + 2, es

        mov ax, 251Ch
        mov dx, OFFSET beep
        push ds
        mov bx, cs
        mov ds, bx
        int 21h
        pop ds


        mov ah, 1
        int 21h
        int 21h
        mov ax, 251Ch
        mov dx, word ptr oldHandler + 2
        mov bx, word ptr oldHandler
        mov ds, dx
        mov dx, bx
        int 21h


        mov ah, 4ch
        int 21h

CodeSeg EndS
End main