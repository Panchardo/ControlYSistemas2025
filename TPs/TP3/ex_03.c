#include <stdio.h>
#include <math.h>

int main() {
    double nan_value = NAN;    // Not a Number
    double pos_inf = INFINITY; // Infinito positivo
    double neg_inf = -INFINITY; // Infinito negativo

    printf("NaN: %f\n", nan_value);
    printf("+Inf: %f\n", pos_inf);
    printf("-Inf: %f\n", neg_inf);

    return 0;
}
/*
OUTPUT
WINDOWS
NaN: nan
+Inf: inf
-Inf: -inf

LINUX
NaN: nan
+Inf: inf
-Inf: -inf

*/