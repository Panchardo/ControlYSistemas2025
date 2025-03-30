// Version: 002
// Date:    2022/04/05
// Author:  Rodrigo Gonzalez <rodralez@frm.utn.edu.ar>

#include <stdio.h>
#include <float.h>
#include <math.h>
#include <signal.h>
#include <stdlib.h>

// Compile usando el siguiente comando
// compile: gcc -Wall -O3 -std=c99 ex_04.c -o ex_04 -lm -march=corei7 -frounding-math -fsignaling-nans

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
    printf("\n");
}
     
int main(void)
{	
  int ROUND_MODE;
	
  ROUND_MODE = fegetround();		
  printf("Current Round Mode = %d \n", ROUND_MODE );
		
  show_fe_exceptions();
      
  /* Temporarily raise other exceptions */
  feclearexcept(FE_ALL_EXCEPT); //  Limpia todas las excepciones de punto flotante previamente activadas.
  feraiseexcept(FE_INEXACT); // Lanza la excepcion correspondiente. FE_INEXACT es resultado inexacto
  show_fe_exceptions();
    
  feclearexcept(FE_ALL_EXCEPT);
  feraiseexcept(FE_INVALID); // FE_INVALID se activa cuando una operación matemática no tiene un resultado válido. Ejemplo 0/0 o sqrt(-1)
  show_fe_exceptions();

  feclearexcept(FE_ALL_EXCEPT);    
  feraiseexcept(FE_DIVBYZERO); // Division por cero
  show_fe_exceptions();

  feclearexcept(FE_ALL_EXCEPT);
  feraiseexcept(FE_OVERFLOW);
  show_fe_exceptions();

  feclearexcept(FE_ALL_EXCEPT);
  feraiseexcept(FE_UNDERFLOW);
  show_fe_exceptions();
  
  feclearexcept(FE_ALL_EXCEPT);
  feraiseexcept(FE_OVERFLOW | FE_INEXACT); // aqui combinó dos excepciones con una operacion OR bitwise
  show_fe_exceptions();

	return 0;	
}

/*
FE_DIVBYZERO → Se produjo un error de polo en una operación de punto flotante anterior.

FE_INEXACT → Resultado inexacto: fue necesario redondear para almacenar el resultado de una operación de punto flotante anterior.

FE_INVALID → Se produjo un error de dominio en una operación de punto flotante anterior.

FE_OVERFLOW → El resultado de una operación de punto flotante anterior era demasiado grande para ser representado.

FE_UNDERFLOW → El resultado de una operación de punto flotante anterior fue subnormal con una pérdida de precisión.

FE_ALL_EXCEPT → OR bit a bit de todas las excepciones de punto flotante admitidas.
*/