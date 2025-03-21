#include <math.h>
#include <stdio.h>
#include <stdint.h>

const int8_t m = 21;  // Parte entera: 21 bits
const int8_t n = 10;  // Parte fraccionaria: 10 bits

// Función de truncamiento
int32_t truncation(int64_t X) {
    int32_t a = (int32_t)(X >> n);  // Desplazamiento a la derecha para truncar
    return a;
}

// Función de redondeo
int32_t rounding(int64_t X) {
    int32_t a = X + (1 << (n - 1)); 
    return truncation(a);
}

void main(void) {
    float X1 = 2.56;
    printf("X = %.2f \n", X1 ); // 2.56 en binario con 10 decimales es 10.1000111101

    // Convertir el valor de X a un valor entero representado en punto fijo
    int64_t X_fixed = (int64_t)(X1 * (1 << n));  //Se multiplica el numero por 2^n, lo que equivale a correr la coma n lugares a la derecha. 
                                                //En el caso de 10.1000111101, queda 1010001111.01. Pero lo estamos guardando en un entero, entonces se guarda 101000111101, 
                                                //con muchos ceros a la izquierda de ese numero, porque tiene 64 bits. Ese numero en decimal es 2621
    printf("X_fixed = %d \n", X_fixed );

    // Aplicar truncamiento y redondeo
    int32_t x_trunc = truncation(X_fixed); // Al truncar, 1010 0011 1101 se desplaza n lugares a la derecha (10 en este caso, quedando 000000000010  (con muchos ceros a la derecha porque tiene 32 bits ahora), lo cual es 2. 
                                           // Fijarse que los bits menos significativos corresponden a la parte entera                                                                                                               
    int32_t x_redond = rounding(X_fixed); // Al redondear, a X = 1010 0011 1101 se le suma un 1 corrido n-1 lugares, osea 9 en este caso. 
                                            //El resultado es 1100 0011 1101 (Hay que contar 9 lugares y ponerlo al decimo). Luego al truncarse 
                                            //queda 0000 0000 0011 que es 3.

    // Imprimir resultados
    printf("Truncado = %d \n", x_trunc);
    printf("Redondeado = %d \n", x_redond);

    float X2 = 3.5;

    float mult = X1 * X2; // 8.96

    int64_t res_fixed = (int64_t)(mult * (1 << n));
    int32_t res_trunc = truncation(res_fixed);
    int32_t res_redond = rounding(res_fixed); 

    
    printf("Truncado producto = %d \n", res_trunc);
    printf("Redondeado producto = %d \n", res_redond);


}
 



