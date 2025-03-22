#include <stdio.h>
#include <stdint.h>

#define n 10  // 10 bits para la parte fraccionaria
#define SHIFT (1 << n)  // 2^10 = 1024

// Función para convertir de float a formato Q21.10
int32_t float_to_q21_10(float x) {
    return (int32_t)(x * SHIFT);
}

// Función para realizar la operación MAC en punto fijo
int64_t mac(int32_t X[], int32_t Y[], int size) {
    int64_t result = 0;
    for (int i = 0; i < size; i++) {
        result += (int64_t)X[i] * (int64_t)Y[i];  // Multiplicamos los valores y acumulamos
    }
    return result;
}

int main(void) {
    // Vectores flotantes
    float X_float[5] = {1.1, 2.2, 3.3, 4.4, 5.5};
    float Y_float[5] = {6.6, 7.7, 8.8, 9.9, 10.10};
    
    // Convertir los vectores a formato Q21.10
    int32_t X[5], Y[5];
    for (int i = 0; i < 5; i++) {
        X[i] = float_to_q21_10(X_float[i]);
        Y[i] = float_to_q21_10(Y_float[i]);
    }

    // Realizar la operación MAC
    int64_t result = mac(X, Y, 5);

    // Convertir el resultado a formato decimal
    float result_decimal = (float)result / (SHIFT * SHIFT);

    // Mostrar resultados
    printf("Operacion MAC en punto fijo Q21.10\n");
    printf("Resultado en punto fijo (en Q21.10): %ld\n", result);
    printf("Resultado en formato decimal: %.6f\n", result_decimal);

    return 0;
}
