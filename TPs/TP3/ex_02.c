// Version: 001
// Date:    2020/03/19
// Author:  Rodrigo Gonzalez <rodralez@frm.utn.edu.ar>

// Compile usando el siguiente comando
// compile: gcc -Wall -std=c99 ex_02.c -o ex_02 -lm -frounding-math -fsignaling-nans 

//-lm Enlaza la biblioteca matemática (libm), necesaria para funciones como sin(), cos(), sqrt(), etc. Esto es porque math.h no es parte de la libreria estandar de C.
// frounding-math desactiva el redondeo por defecto y le dice al compilador que el programa cambia el modo de redondeo dinamicamente
// -fsignaling-nans 

#include <stdio.h>
#include <float.h>
#include <math.h>
#include <fenv.h>

void test_rounding (void)
{
  float fp1, fp2;
  double df3;

 fp1 = exp(1.1);
 printf(" exp(1.1) = %+0.8f\n", fp1);
 
 fp2 = -exp(1.1);
 
  printf("-exp(1.1) = %+0.8f\n", fp2);

 df3 = exp(1.1);
 
  printf("double exp(1.1) = %+0.16lf\n", df3);
}

void current_rounding (void)
{
	int ROUND_MODE;
	
	ROUND_MODE = fegetround();	// Metodo get para obtener el modo de redondeo. Por default, es TONEAREST, es decir redondea al entero mas cercano. Se vio en el EJ 1.
	
	printf("Current Round Mode = %d \n", ROUND_MODE );
}

void change_rounding (int rounding_mode)
{
	fesetround (rounding_mode);	// Setea el rounding_mode dandole la macro correspondiente
}

int main(void)
{	
	printf("** Floating-point single-precision constants ** \n");
	printf("FLT_MIN 	= %E \n", 		FLT_MIN ); // Valor minimo representable con float
	printf("FLT_MAX 	= %E \n", 		FLT_MAX ); // Valor maximo representable con float
	printf("FLT_EPSILON	= %E \n", 	FLT_EPSILON ); // En MATLAB: eps(single(1)) FLT_EPSILON: This is the difference between 1 and the smallest floating point number of type float that is greater than 1.
	printf("\n");
	
	printf("** Floating-point double-precision constants ** \n");
	printf("DBL_MIN 	= %E \n", 		DBL_MIN ); // Valor minimo representable con double
	printf("DBL_MAX 	= %E \n", 		DBL_MAX ); // Valor maximo representable con double
	printf("DBL_EPSILON	= %E \n", 	DBL_EPSILON ); // En MATLAB: eps(1). DBL_EPSILON: lo mismo que con float
	printf("\n");

	printf("** Floating point rounding modes ** \n");
	printf("Rounding Mode FE_TONEAREST	= %d \n", 	FE_TONEAREST ); // Redondeo bancario. Por defecto activado
	printf("Rounding Mode FE_DOWNWARD	= %d \n", 		FE_DOWNWARD ); // Redondeo a +inf
	printf("Rounding Mode FE_UPWARD		= %d \n", 		FE_UPWARD ); // Redondeo a -inf
	printf("Rounding Mode FE_TOWARDZERO	= %d \n", 	FE_TOWARDZERO );  // Este es un truncamiento
	printf("\n");
	
	//RESULTADO REAL DE exp(1.1) = 3.0041660239464 = 1.10000000100010001000001(1) * 2^1. Ese 1 entre () es el digito despues del bit menos significante. 

	current_rounding(); // TONEAREST 
	test_rounding(); 
	/*
	Current Round Mode = 0
 	exp(1.1) = +3.00416613 En formato punto flotante es 0 10000000 100 0000 0100 0100 0100 0010 que es 3.004166126251220703125.., que es un numero mas grande que el original. Esto porque, como hay un 1 en el bit despues del menos significante, se redondeo para arriba.
	-exp(1.1) = -3.00416613 Tiene sentido que sea igual con signo contrario, porque redondean hacia el entero mas cercano. Aqui seria como redondear hacia abajo
	double exp(1.1) = +3.00416602 // 3.00416602394640008810 es el numero mas completo, se redondea. El numero con coma en binario es 1.1000000010001000100000110010010001001101010101000111(1)*2^1. Se ha redondeado para arriba tambien por ese 1 que aparece.
	*/
	printf("\n");
	
	change_rounding(FE_DOWNWARD);

	current_rounding();
	test_rounding();
	/*
	Current Round Mode = 1024
	exp(1.1) = +3.00416589 // aca redondeo para -inf. El numero en punto flotante queda 0 10000000 100 0000 0100 0100 0100 0001, que en decimal es 3.004165887...
	-exp(1.1) = -3.00416613 // Redondeo para -inf tambien, queda igual que el caso de redondeo anterior pues redondear para -inf es tambien redondear al entero mas cercano
	double exp(1.1) = +3.00416602
	*/
	printf("\n");
	
	change_rounding(FE_UPWARD);
	current_rounding();

	test_rounding();	
	/*
	Current Round Mode = 2048
	exp(1.1) = +3.00416613 //Ahora se redondea para +inf, se invierten los casos con respecto al de redondeo para abajo.
	-exp(1.1) = -3.00416589
	double exp(1.1) = +3.00416602
	*/
	printf("\n");

	change_rounding(FE_TOWARDZERO);
	current_rounding();
	
	test_rounding();
	/*
	Current Round Mode = 3072
	exp(1.1) = +3.00416589 //Truncamiento. Con o sin signo el numero es el mismo.
	-exp(1.1) = -3.00416589
	double exp(1.1) = +3.00416602
	*/
	printf("\n");
	return 0;
}
