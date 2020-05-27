section .text
global _CopyAsm

_CopyAsm:
    push ebp
    mov ebp, esp

    push esi
    push edi
    push ecx


    mov ecx, [ebp + 16]
    mov esi, [ebp + 12]
    mov edi, [ebp + 8]

    cmp ecx, 0
    jl error_exit
    cmp esi, edi
    jb reverse_copying

forward_copying:
    cld
    rep movsb
    mov byte [edi], 0
    jmp end_copying

reverse_copying:
    std
    add esi, ecx
    add edi, ecx
    dec esi
    dec edi
    rep movsb

    mov ecx, [ebp + 16]
    mov byte [edi + ecx + 1], 0
    jmp end_copying

end_copying:
    mov eax, 0
    jmp exit
error_exit:
    mov eax, 1
exit:
    pop ecx
    pop edi
    pop esi
    pop ebp
    ret
