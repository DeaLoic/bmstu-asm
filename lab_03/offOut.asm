public offsetOut

extern x: byte
extern indent: byte

CodeS SEGMENT PARA 'CODE'
	assume CS:CodeS

offsetOut proc far
	mov ax, seg x
	mov es, ax
	mov dl, es:x
	add dl, es:indent
	mov ah, 02h
    int 21h
	ret
offsetOut endp

CodeS ENDS
END