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
    ;mov ah, 02h
    ;int 1Ah ; cf = 1 if doesnt work
    ;jc exit

    mov bx, 0B800h
    mov es, bx
    mov bx, 72 * 2
    mov byte ptr es:[bx - 1], 3h
    mov byte ptr es:[bx + 1], 3h
    mov byte ptr es:[bx + 3], 3h
    mov byte ptr es:[bx + 5], 3h
    mov byte ptr es:[bx + 7], 3h
    mov byte ptr es:[bx + 9], 3h
    mov byte ptr es:[bx + 11], 3h
    mov byte ptr es:[bx + 13], 3h
    mov byte ptr es:[bx + 15], 3h

exit:
    pop ax
    pop dx
    pop es
    pop bx
    popf
    jmp cs:oldHandler
    iret
beep endp

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