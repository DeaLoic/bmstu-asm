.model tiny

.DOSSEG
.data
.code
.startup
oldHandler dd 0
jmp main

beep proc near
    pushf
    push bx
    push es
    push dx
    push ax
    mov ah, 02h
    int 1Ah ; cf = 1 if doesnt work
    jc exit

    mov bx, 0B800h
    mov es, bx
    mov bx, 72 * 2

    xor ax, ax
    mov al, ch
    call unpack
    mov es:[bx], ah
    ;mov byte ptr es:[bx + 1], 3h
    mov es:[bx + 2], al
    add bx, 4
    mov byte ptr es:[bx], ':'
    add bx, 2

    xor ax, ax
    mov al, cl
    call unpack
    mov es:[bx], ah
    mov es:[bx + 2], al
    add bx, 4

    mov byte ptr es:[bx], ':'
    add bx, 2

    xor ax, ax
    mov al, dh
    call unpack
    mov es:[bx], ah
    mov es:[bx + 2], al

exit:
    pop ax
    pop dx
    pop es
    pop bx
    popf
    jmp cs:oldHandler
    iret
beep endp

unpack proc near
    mov ah, al
    and al, 00001111b
    push cx
    mov cl, 4
    shr ah, cl
    pop cx
    or ax, 3030h
    ret
unpack endp

main:
        mov ax, 351Ch
        int 21h

        mov word ptr oldHandler, bx
        mov word ptr oldHandler + 2, es

        mov ax, 251Ch
        mov dx, OFFSET beep
        mov bx, cs
        mov ds, bx
        int 21h

        mov dx, offset main
        int 27h
        ret
end