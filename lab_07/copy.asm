section .text
global _CopyAsm

_CopyAsm:
    push ebp
    mov ebp, esp

    push ebx
    push ecx
    push edx

    mov ecx, [ebp + 16]
    cmp ecx, 0
    jl end_copying

    mov ebx, [ebp + 8]
    mov eax, [ebp + 12]

    cmp eax, ebx
    jl reverse_copying

forward_copying:
    cmp ecx, 0
    je end_forward_copying

    mov dl, byte [eax]
    mov byte [ebx], dl

    add eax, 1
    add ebx, 1
    dec ecx

    jmp forward_copying
end_forward_copying:
    mov byte [ebx], 0
    jmp end_copying

reverse_copying:
    add eax, ecx
    add ebx, ecx
    mov byte [ebx], 0
    dec eax
    dec ebx
reverse_copying_start:
    cmp ecx, 0
    je end_reverse_copying

    mov dl, byte [eax]
    mov byte [ebx], dl

    sub eax, 1
    sub ebx, 1
    dec ecx

    jmp reverse_copying_start

end_reverse_copying:
end_copying:
    mov eax, 0
    jmp exit
error_exit:
    mov eax, 1
exit:
    pop edx
    pop ecx
    pop ebx
    pop ebp
    ret
