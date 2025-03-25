#include <math.h>
#include <stdio.h>
#include <stdint.h>

int32_t fp2fx(float x, int8_t n) {
    return (int32_t)(x * (1 << n));
}

float fx2fp(int32_t x, int8_t n) {
    return (float)x / (1 << n);
}

void main(void){
    float b = fx2fp(fp2fx(2.4515, 8), 8);
    printf("Q23.8: %f \n", b); // 2.449219 
    float c = fx2fp(fp2fx(2.4515, 10), 10);
    printf("Q21.10: %f", c); // 2.451172
}
