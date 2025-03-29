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

	a = 1000000000.0;	// mil millones
	b =   20000000.0;	// 20 millones
	c =   20000000.0;
	
	f1 = (a * b) * c;
	f2 = a * (b * c);

	d1 = (double) (a) * (double) (b) * (double) (c);

	printf("f1 = %lf \n", f1 );
	printf("f2 = %lf \n", f2 );
	printf("d1 = %lf \n", d1 );
	
	printf("Error en f1 = %10e \n", f1 - 400000000000000000000000.0 );
	printf("Error en f2 = %10e \n", f2 - 400000000000000000000000.0 );
	printf("Error en d1 = %20e \n", d1 - 400000000000000000000000.0 );
	
	double acum_1, acum_2;
	
	acum_1 = 0.0;
	for (int64_t i = 0; i < 10000000; i++){ acum_1 += 0.01; } 

	acum_2 = 0.0;
	b = 0.333;
	for (int64_t i = 0; i < 10000000; i++){ acum_2 += b / b; }
	
	printf("acum_1 = %f \n", acum_1 );
	printf("acum_2 = %f \n", acum_2 );
	
	printf("Error en acum_1 = %10e \n", acum_1 - (100000.0));
	printf("Error en acum_2 = %10e \n", acum_2 - (10000000.0));
	
	return 0;
}
