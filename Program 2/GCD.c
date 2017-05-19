#include <stdio.h>

int main()
{

    int x=24;
    int y=12;
    int i;
    int gcd;

    for(i=y;; i--)
    {
        if(x%i==0 && y%i==0)
        {
            gcd=i; //WE CAN JUST RETURN I
            break;
        }
    }

    printf("X is: %d\nY is: %d\ni is: %d\nGCD is: %d", x,y,i, gcd);


}
