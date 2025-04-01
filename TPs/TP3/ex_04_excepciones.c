#include <stdio.h>
#include <float.h>
#include <math.h>
#include <signal.h>
#include <stdlib.h>

// Compile usando el siguiente comando
// compile: gcc -Wall -O3 -std=c99 ex_04_excepciones.c -o ex_04_excepciones -lm -march=corei7 -frounding-math -fsignaling-nans

#define _GNU_SOURCE 1
#define _ISOC99_SOURCE
#include <fenv.h>


void show_fe_exceptions(void)
{
    printf("current exceptions raised: ");
    if(fetestexcept(FE_DIVBYZERO))     printf(" FE_DIVBYZERO"); // fetestexcept chequea si se lanzo alguna excepción y cuál
    if(fetestexcept(FE_INEXACT))       printf(" FE_INEXACT");
    if(fetestexcept(FE_INVALID))       printf(" FE_INVALID");
    if(fetestexcept(FE_OVERFLOW))      printf(" FE_OVERFLOW");
    if(fetestexcept(FE_UNDERFLOW))     printf(" FE_UNDERFLOW");
    if(fetestexcept(FE_ALL_EXCEPT)==0) printf(" none");
    if(fetestexcept(FE_DENORMAL))      printf(" FE_DENORM");
    printf("\n");
}

int main(void){
    float div_cero = 1.0/0.0;
    printf("1.0/0.0 = %f\n", div_cero);
    show_fe_exceptions();
    feclearexcept(FE_ALL_EXCEPT);

    float inexacto = 1.0/10.0;
    printf("1.0/10.0 = %f\n", inexacto);
    show_fe_exceptions();
    feclearexcept(FE_ALL_EXCEPT);

    float invalid = 0.0/0.0; //es una indeterminación matemática que no tiene sentido numérico, así que lanza FE_INVALID
    printf("0.0/0.0 = %f\n", invalid);
    show_fe_exceptions();
    feclearexcept(FE_ALL_EXCEPT);

    double invalidsqrt = sqrt(-1);
    printf("raiz de -1 = %f\n", invalidsqrt);
    show_fe_exceptions();
    feclearexcept(FE_ALL_EXCEPT);

    float overflow = FLT_MAX *2 ; // sumar FLT_MAX + 1 no genera overflow porque sumar 1 es muy insignificante
    printf("Overflow = %f\n", overflow);
    show_fe_exceptions();
    feclearexcept(FE_ALL_EXCEPT);

    float underflow = FLT_MIN/(1<<31);
    printf("Underflow = %f\n", underflow);
    show_fe_exceptions();
    feclearexcept(FE_ALL_EXCEPT);


}

/*
OUTPUT
EN WINDOWS

1.0/0.0 = inf
current exceptions raised:  FE_DIVBYZERO
1.0/10.0 = 0.100000
current exceptions raised:  FE_INEXACT
0.0/0.0 = nan
current exceptions raised:  FE_INVALID
raiz de -1 = nan
current exceptions raised:  none
Overflow = inf
current exceptions raised:  FE_INEXACT FE_OVERFLOW
Underflow = -0.000000
current exceptions raised:  FE_INEXACT FE_UNDERFLOW

En LINUX
1.0/0.0 = inf
current exceptions raised:  FE_DIVBYZERO
1.0/10.0 = 0.100000
current exceptions raised:  FE_INEXACT
0.0/0.0 = -nan
current exceptions raised:  FE_INVALID
raiz de -1 = -nan
current exceptions raised:  FE_INVALID
Overflow = inf
current exceptions raised:  FE_INEXACT FE_OVERFLOW
Underflow = -0.000000
current exceptions raised:  FE_INEXACT FE_UNDERFLOW

*/