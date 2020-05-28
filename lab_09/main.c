#include <stdio.h>
#include <string.h>

#define NAME_SIZE 7
#define COOL_NAMES_COUNT 6
char coolNames[COOL_NAMES_COUNT][NAME_SIZE + 1] = {"dmitriy", "smith", "cherry", "admin", "pavel", "titor"};
int main()
{
    char name[100];
    printf("Enter your name: ");
    scanf("%s", name);

    int isCool = 0;
    for (int i = 0; i < COOL_NAMES_COUNT && !isCool; i++)
    {
        if (strcmp(name, coolNames[i]) == 0)
        {
            isCool = 1;
        }
    }

    if (isCool)
    {
        printf("You are cool!\n");
    }
    else
    {
        printf("You are not cool, sorry/|\\\n");
    }
}