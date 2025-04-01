// Version: 002
// Date:    2022/04/05
// Author:  Rodrigo Gonzalez <rodralez@frm.utn.edu.ar>

// Compile usando el siguiente comando
// compile: gcc -Wall -std=c99 ex_01.c -o ex_01
// -Wall
// This enables all the warnings about constructions that some users consider questionable, 
// and that are easy to avoid (or modify to prevent the warning), even in conjunction with macros. 
// This also enables some language-specific warnings described

//-std = XXX

//Determine the language standard. See Language Standards Supported by GCC, for details of these standard versions. This option is currently only supported when compiling C or C++.
// The compiler can accept several base standards, such as ‘c90’ or ‘c++98’, and GNU dialects of those standards, such as ‘gnu90’ or ‘gnu++98’.
// When a base standard is specified, the compiler accepts all programs following that standard plus those using GNU extensions that do not contradict it
#include <stdio.h>
#include <float.h> 
#include <math.h>
#include <fenv.h>

typedef long int int64_t; // cuando declare una variable como int64_t, en realidad la estoy declarando long int

int main(void)
{	
	float a, b, c, f1, f2;
	double d1;

	a = 1000000000.0;	// mil millones ----> EN BINARIO (punto flotante): 0 10011100 110 1110 0110 1011 0010 1000
	b =   20000000.0;	// 20 millones -----> EN BINARIO (punto flotante): 0 10010111 001 1000 1001 0110 1000 0000
	c =   20000000.0;

	// Para calcular el exponente de cada numero individualmente primero se los convierte a binario, se pone la coma a la derecha del bit mas significativo (no el del signo)
	// y se cuenta la cantidad de bits despues de la coma y se resta el bias (127). Luego se multiplica a ese numero con coma (mantisa) por 2^(cantidad de bits despues de la coma - bias)
	// para obtener el numero posta. Justo para estos numeros, las representaciones son exactas.
	
	f1 = (a * b) * c; 


	// Ahora el producto. a * b = 2e16. La mantisa queda 10.001110000110111100100110111111000001 y el exponente 180 − 127 = 53.

	// Para obtener ese producto se suman los exponentes y se multiplican las mantisas y luego se multiplica la mantisa resultante por 2^exponente resultante.
	// Volviendo al resultado anterior, tenemos que normalizarlo para que quede solo un numero antes de la coma, osea que tenemos que correr la coma y sumar 1 al exponente, es decir, 
	// 1.0001110000110111100100110111111000001 ∙ 2^(181 − bias). Ahora se produce un redondeo para arriba, 
	// pues al final de multiplicar las mantisas y sumar los exponentes (E = e1+e2-2bias+bias), queda 1.00011100001101111001001 10111111000001 ∙ 2^(181 − bias) como ya vimos y, 
	// como la mantisa para un float de 32 bits tiene 23 bits, entonces 1.00011100001101111001001 ∙ 2^(181 − bias), pero como el bit de despues del menos significativo es un 1,
	// el compilador automaticamente redondea para arriba en vez de truncar, quedando como resultado 1.00011100001101111001010 ∙ 2^(181 − bias). Si fuera 0, hubiera redondeado para 
	// abajo y el resultado habria sido menor al real. El resultado final en decimal es 20000000545128448 (el resultado real es 2e16)
	// Luego, multiplicado por c (0 10010111 001 1000 1001 0110 1000 0000) da 0 11001101 010 1001 0110 1000 0001 0111 que en decimal es 4.0000002715665E+23
	// (especificamente 400000027156649353412608.000000). En este caso tambien se redondeó para arriba

	f2 = a * (b * c); 

	/* aqui calcula primero b*c = 4e14. En binario es 0 10101111 011 0101 1110 0110 0010 0001, que es 400000001507328 pues fue redondeado para arriba. Luego multiplica por 1e9 y da
	0 11001101 010 1001 0110 1000 0001 0110, que es 3.9999999112785E+23, especificamente 399999991127852334448640.000000, ahi hubo un redondeo para abajo. (1.01010010110100000010110 010010011100000000101 ∙ 2^(205 − bias))
	*/
	d1 = (double) (a) * (double) (b) * (double) (c);
	/*
	Ahora los numeros estan casteados con el doble de precision. Ahora se utiliza el estandar de flotante de 64 bits (53 bits en la mantisa + 10 bits en exponente + bit de signo).
	Primero se hace el producto a*b que sabemos que es 2e16. En punto flotante de 64 bits es 0 10000011100 1101 1100 1101 0110 0101 0000 0000 0000 0000 0000 0000 0000 0000 * 0 10000010111 0011 0001 0010 1101 0000 0000 0000 0000 0000 0000 0000 0000 0000
	que es igual a 0 10000110101 0001 1100 0011 0111 1001 0011 0111 1110 0000 1000 0000 0000 0000. En decimal es 20000000000000000 que es exactamente el resultado real. 
	Luego se multiplica por c y da 0 10001001101 0101 0010 1101 0000 0010 1100 0111 1110 0001 0100 1010 1111 0110 o bien en notacion de punto flotante, 1.0101001011010000001011000111111000010100101011110110 ∙ 2^(1101 − bias).
	Esto corresponde a 399999999999999966445568, que es lo que printea. Ha redondeado para abajo.
	*/
	printf("f1 = %lf \n", f1 );
	printf("f2 = %lf \n", f2 );
	printf("d1 = %lf \n", d1 );
	
	printf("Error en f1 = %10e \n", f1 - 400000000000000000000000.0 );
	printf("Error en f2 = %10e \n", f2 - 400000000000000000000000.0 );
	printf("Error en d1 = %20e \n", d1 - 400000000000000000000000.0 );
	
	double acum_1, acum_2;
	
	acum_1 = 0.0;
	for (int64_t i = 0; i < 10000000; i++){ acum_1 += (float)0.01; } 
	/*
	El resultado deberia ser 100000, pero da 99999.999986. Esto es porque basicamente se esta multiplicando 0.01 x 10000000. El 0.01 en binario se escribe de manera periodica, no tiene una representacion finita
	por lo que cada vez que se suma se introduce un error debido a la aproximacion que se le hace. Tambien influye que en las ultimas sumas se suman un numero muy grande con uno muy chico.
	Declarado como float, el numero es 99999.997765.
	*/

	acum_2 = 0.0;
	b = 0.333;
	for (int64_t i = 0; i < 10000000; i++){ acum_2 += b / b; }
	/*
	La variable b = 0.333 sí tiene un pequeño error de representación en binario, pero cuando se divide entre sí misma (b / b), el error se cancela.
	Entonces cada iteración suma exactamente 1.0 a acum_2.
*/
	
	
	printf("acum_1 = %f \n", acum_1 );
	printf("acum_2 = %f \n", acum_2 );
	
	printf("Error en acum_1 = %10e \n", acum_1 - (100000.0));
	printf("Error en acum_2 = %10e \n", acum_2 - (10000000.0));
	
	return 0;
}


/*OUTPUT
WINDOWS:
f1 = 400000027156649353412608.000000 
f2 = 399999991127852334448640.000000
d1 = 399999999999999966445568.000000 
Error en f1 = 2.715665e+16
Error en f2 = -8.872148e+15
Error en d1 =         0.000000e+00 
acum_1 = 99999.999986 
acum_2 = 10000000.000000
Error en acum_1 = -1.369031e-05
Error en acum_2 = 0.000000e+00

LINUX:
f1 = 400000027156649353412608.000000 
f2 = 399999991127852334448640.000000 
d1 = 399999999999999966445568.000000 
Error en f1 = 2.715665e+16 
Error en f2 = -8.872148e+15 
Error en d1 =         0.000000e+00 
acum_1 = 99999.999986 
acum_2 = 10000000.000000 
Error en acum_1 = -1.369031e-05 
Error en acum_2 = 0.000000e+00 
*/