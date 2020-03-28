extern matrixInput: far
extern logicTarget: far
extern matrixOut: far

MessageS SEGMENT WORD 'Messages'
    errorString db 13
                db 10
                db 'Error$'
    nextString  db 13
                db 10
                db '$'
    outputMessageString db 'Changed matrix:'
                        db 13
                        db 10
                        db '$'
MessageS ENDS

MatrixS SEGMENT WORD 'Data'
    x db 0
    y db 0
    body db 81 DUP(0)
MatrixS ENDS

StackS SEGMENT WORD STACK 'Stack'
    db 100 DUP(?)
StackS ENDS

ASSUME CS:CodeS, DS:MatrixS, ES:MessageS, SS:StackS

CodeS SEGMENT PARA 'Code'

outputMessageOnEs proc near
    push ax
    push ds
    push es
    pop ds   ; ds = ex
    mov ah, 09h
    int 21h
    pop ds
    pop ax
    ret
outputMessageOnEs endp

main:
    mov ax, MatrixS
    mov ds, ax

    mov ax, MessageS
    mov es, ax


    mov bx, OFFSET x
    call matrixInput

    cmp ax, 0
    jg errorExit

    call logicTarget
    cmp ax, 0
    jg errorExit
    
    mov dx, offset nextString
    call outputMessageOnEs

    mov dx, offset outputMessageString
    call outputMessageOnEs

    call matrixOut

    mov ah, 1
    int 21h

    jmp exit

errorExit:
    mov dx, OFFSET errorString
    call outputMessageOnEs

exit:
    mov ah, 4ch
    int 21h

CodeS ENDS 
end main