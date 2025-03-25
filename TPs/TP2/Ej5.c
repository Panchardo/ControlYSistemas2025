#include <stdio.h>
#include <stdint.h>

#define n 10  // 10 bits para la parte fraccionaria
#define SHIFT (1 << n)  // 2^10 = 1024

// Función para convertir de float a formato Q21.10
int32_t float_to_q21_10(float x) {
    return (int32_t)(x * SHIFT);
}

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

// Función para realizar la operación MAC en punto fijo
int32_t mac32BIT(int32_t X[], int32_t Y[], int8_t size) {
    int32_t result = 0;
    for (int8_t i = 0; i < size; i++) {
        result += (int32_t)truncation((int64_t)X[i] * (int64_t)Y[i]);  // Multiplicamos los valores y acumulamos
    }
    return result;
}

// Función para realizar la operación MAC en punto fijo
int32_t mac64BIT(int64_t X[], int64_t Y[], int8_t size) {
    int64_t result = 0;
    for (int8_t i = 0; i < size; i++) {
        result += (( X[i] * Y[i]));  // Multiplicamos los valores y acumulamos
    //    printf("i = %d; result = %ld", i,result);
    }
    int32_t result_redondeado = truncation(result);
    return result_redondeado;
}

void main(void) {
    // Vectores flotantes
    float X_float[5] = {1.1, 2.2, 3.3, 4.4, 5.5};
    float Y_float[5] = {6.6, 7.7, 8.8, 9.9, 10.10};
    
    // Convertir los vectores a formato Q21.10
    int32_t X[5], Y[5];
    int64_t X64[5], Y64[5];
    for (int i = 0; i < 5; i++) {
        X[i] = float_to_q21_10(X_float[i]);
        Y[i] = float_to_q21_10(Y_float[i]);
        X64[i] = (int64_t)X[i];
        Y64[i] = (int64_t)Y[i];
    }

    // Realizar la operación MAC
    int32_t result_trunc = mac32BIT(X, Y, 5);
    int32_t result_redond = mac64BIT(X64,Y64, 5);

    double A[5] = {1.1, 2.2, 3.3, 4.4, 5.5 };
    double B[5] = {6.6, 7.7, 8.8, 9.9, 10.10};
    double acum_db = 0;
    for(int8_t i=0; i < 5; i++)
    {
        acum_db += A[i] * B[i];
    }

    printf("Multiplicacion 32 bits truncada: %d\n", result_trunc); //155980 ---> En Q21.10 es: 10011000.0101001100 = 152.32421875 (no deberia ser un entero truncado?)
    printf("En Q21.10: %.5f\n", (float)result_trunc/(1<<n)); //155982 ---> En Q21.10 es :10011000.0101001110 = 152.326171875 (no deberia ser un entero redondeado?)
    printf("Multiplicacion 64 bits redondeada: %d\n", result_redond);
    printf("En Q21.10: %.5f\n", (float)result_redond/(1<<n));
    printf("Multiplicacion con double: %.2f", acum_db); //152.35


}
/*
    // Convertir el resultado a formato decimal
    float result_decimal = (float)result / (SHIFT * SHIFT);

    // Mostrar resultados
    printf("Operacion MAC en punto fijo Q21.10\n");
    printf("Resultado en punto fijo (en Q21.10): %ld\n", result);
    printf("Resultado en formato decimal: %.6f\n", result_decimal);
*/

/* 
EJ 6:Suponga que debe implementar un filtro digital con un procesador DSP de 16 bits. El mismo cuenta
con un acumulador de 40 bits en su ALU. Calcule cuántas sumas consecutivas puede realizar
garantizando que no se producirá un overflow.

SUMANDOS DE 16 BITS. La cuenta es 40 = 16 + log2(s) ---> despejando s ---> 16.777.216 sumandos se pueden sumar sin producir overflow

*/