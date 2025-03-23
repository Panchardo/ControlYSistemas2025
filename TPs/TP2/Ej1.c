#include <math.h>
#include <stdio.h>
#include <stdint.h>
void main(void)
{
signed char a, b, c, d, s1, s2;
a = 127; // 0 1111111
b = 127; // 0 1111111
c = a + b; // 1 1111110 = -2 = -128 + 64 + 32 + 16 + 8 + 4 + 2
d = a * b; // 11111000000001 pero se almacenan los 8 bits menos significativos, es decir 00000001, por eso el resultado sera 1
s1 = (-8) >> 2; // 1111 1000 (complemento a 2) >> 2 ---> 11111110 = -2
s2 = (-1) >> 5; // 1111 1111 (complemento a 2) >> 5 ---> 11111111 = -1 Ambos casos suceden porque se utiliza desplazamiento aritmético (se conserva el bit de signo). En este caso no importa cuanto se desplace, siempre sera -1 el resultado
printf("c = %d \n", c );
printf("d = %d \n", d );
printf("s1 = %d \n", s1 );
printf("s2 = %d \n", s2 );
}

// resultados con signed char

/*
c = -2 
d = 1 
s1 = -2 
s2 = -1 

Ej 1.1) No son los valores correctos. Deberian dar c = 254 y d = 16129
EJ 1.2) Para arreglarlo, podriamos cambiar el tipo de variable a uno que admita mas bits. Ejemplo uint32_t
EJ 1.3) Los resultados son correctos porque correr dos bits a la derecha significa dividir por 2^2, y -8/4 = -2. Lo mismo con -1/2^5 = -1



*/

