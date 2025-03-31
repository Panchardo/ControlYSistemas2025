// Version: 004
// Date:    2022/04/05
// Author:  Rodrigo Gonzalez <rodralez@frm.utn.edu.ar>

#define _GNU_SOURCE 1
#define _ISOC99_SOURCE
#include <fenv.h>

#include <stdio.h>
#include <float.h>
#include <math.h>
#include <signal.h>
#include <stdlib.h>

// Compile usando el siguiente comando
// compile: gcc -Wall -std=c99 ex_05.c -o ex_05 -lm -frounding-math -fsignaling-nans -DLINUX

// Variables globales
fexcept_t excepts;
     
void show_fe_exceptions(void)
{
    printf("current exceptions raised: ");
    if(fetestexcept(FE_DIVBYZERO))     printf(" FE_DIVBYZERO");
    if(fetestexcept(FE_INEXACT))       printf(" FE_INEXACT");
    if(fetestexcept(FE_INVALID))       printf(" FE_INVALID");
    if(fetestexcept(FE_OVERFLOW))      printf(" FE_OVERFLOW");
    if(fetestexcept(FE_UNDERFLOW))     printf(" FE_UNDERFLOW");
    if(fetestexcept(FE_ALL_EXCEPT)==0) printf(" none");
    printf("\n");
}

void fpe_handler(int sig){

  printf ("UPS! Floating Point Exception \n");
  
  show_fe_exceptions();
  
  exit(EXIT_FAILURE);
}

int main(void)
{ 
   feclearexcept (FE_ALL_EXCEPT);
   feenableexcept(FE_ALL_EXCEPT); //lo que hace esto es habilitar las INTERRUPCIONES por excepciones de punto flotante, lo que hace que se detenga el programa
                                  // cuando detecta una. 
   signal(SIGFPE, fpe_handler); // SIGFPE es una señal que reporta un error fatal aritmetico. Aunque el nombre haga referencia a "Floating Point Exception", tambien
                                // cubre todos los errores aritmeticos, como division por cero u overflow. La funcion signal hace que cuando detecte la señal SIGFPE,
                                // se ejecute la funcion fpe_handler, en lugar de solo detener el programa. Lo que hace es asignar un manejador de señales a la señal SIGFPE
    
  /* Setup a "current" set of exception flags. */
  /**/
  feraiseexcept(FE_INVALID);
  show_fe_exceptions();

  //~ /* Temporarily raise two other exceptions. */
  feclearexcept(FE_ALL_EXCEPT);
  feraiseexcept(FE_OVERFLOW | FE_INEXACT);
  show_fe_exceptions();
   
  //~ double s;
  //  s = 1.0 / 0.0;  // FE_DIVBYZERO
  //  s = 0.0 / 0.0;  // FE_INVALID
  //  show_fe_exceptions();
   
  return 0;
}


/*
SOLO FUNCIONA EN LINUX
Con lineas 44, 45 y 46 comentadas este es el output:
current exceptions raised:  FE_INVALID
current exceptions raised:  FE_INEXACT FE_OVERFLOW

Con las lineas 44, 45 descomentadas:
Floating point exception (core dumped)

Con las lineas 44, 45 y 46 descomentadas:
UPS! Floating Point Exception 
current exceptions raised:  none // probablemente se imprima none porque por algun motivo el sistema limpia automáticamente los flags de excepción antes de ejecutar el manejador.



*/
