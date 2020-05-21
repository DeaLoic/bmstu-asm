#include <stdio.h>
#include <stdlib.h>

int GetLenght(char *string);

extern char* CopyAsm(char *dest, char *source, int size); 


int main()
{
    char *string = "This is my LOoOoOoOoONG string (41 char)\n";

    char *dest = (char *) malloc(32);
    for (int i = 0; i < 32; i++)
    {
        dest[i] = '1';
    }
    dest[31] = '\0';

    printf("Source string: %s\n", string);
    int lenght = GetLenght(string);
    printf("Lenght by asm insert: %d\n", lenght);
    printf("\nDest string: %s\n", dest);

    printf("Source ptr: %p    Dest ptr: %p\n", string, dest);
    printf("\nError code after copying: %d\n", CopyAsm(dest, string, 10));
    printf("Source after: %s\n", string);
    printf("Dest after: %s\n", dest);

    return 0;
}

int GetLenght(char *string)
{
    int lenght = 0;

    __asm__ (
        ".intel_syntax noprefix\n\t"
        "    push eax \n\t"
        "    push ebx \n\t"
        "    push edx \n\t"
        ".att_syntax prefix\n\t"
        "    movl %1, %%ebx \n\t"
        ".intel_syntax noprefix\n\t"
        "    xor eax, eax \n\t"
        "startCount: \n\t"
        "    mov dl, byte ptr [ebx] \n\t"
        "    cmp dl, 0 \n\t"
        "    je endCount \n\t"
        "    inc eax \n\t"
        "    inc ebx \n\t"
        "    jmp startCount \n\t"
        "endCount: \n\t"
        ".att_syntax prefix\n\t"
        "    movl %%eax, %0 \n\t"
        ".intel_syntax noprefix\n\t"
        "    pop edx \n\t"
        "    pop ebx \n\t"
        "    pop eax \n\t"
        ".att_syntax prefix\n\t"
        : "=m" (lenght)
        : "m"  (string)
        : "cc"
    );
    return lenght;
}