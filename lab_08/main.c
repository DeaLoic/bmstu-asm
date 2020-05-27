#include <stdio.h>
#include <stdlib.h>

void test();

extern int isCircleBigger(double radius, double square);


int main()
{
    while(1)
    {
        test();
    }
    return 0;
}

void test()
{
    double radius;
    double square;
    printf("Input radius and square: ");
    scanf("%lf %lf", &radius, &square);
    printf("%lf %lf ", radius, square);
    printf("%d\n\n", isCircleBigger(radius, square));
}

