extern offsetOut : far
public x, indent

StackS SEGMENT BYTE STACK 'Stack'
    db 1
StackS ENDS

DataS SEGMENT WORD 'Data'
    x db 1
    indent db 0
    NEW_STRING db 13
            db 10
            db '$'
DataS ENDS

ASSUME CS:CodeS, DS:DataS, SS:StackS

CodeS SEGMENT PARA 'Code'

new_line proc near
    mov dx, OFFSET NEW_STRING
    mov ah, 09h
    int 21h
    ret
new_line endp

main:
    mov ax, DataS
    mov ds, ax

    ; input x
    mov ah, 01h
    int 21h
    mov x, al

    call new_line

    ; input indent
    mov ah, 01h
    int 21h
    sub al, 30h
    mov indent, al
    
    call new_line

    call offsetOut

    mov ah, 4Ch
    int 21h

CodeS ENDS
END main

