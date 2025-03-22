#include <math.h>
#include <stdio.h>
#include <stdint.h>
#include <limits.h>

int32_t saturation(int32_t a, int32_t b){
    int32_t sum = a + b;
    if (sum >= INT32_MAX) {
        return INT32_MAX;
    }else if (sum <= INT32_MIN) {
        return INT32_MIN;
    }else{
        return sum;
    }
}


void main(void){
    int32_t a = INT32_MAX, b = 1;
    int32_t suma = saturation(a,b);
    printf("Suma = %d \n", suma);
    printf("int32 max: %d \n", INT32_MAX);
    printf("int32 min: %d",INT32_MIN);
}


