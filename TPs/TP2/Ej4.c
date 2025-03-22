#include <math.h>
#include <stdio.h>
#include <stdint.h>
#include <limits.h>

int32_t saturation(int64_t x){
    if (x >= INT32_MAX){
        printf("XD1\n");
        return INT32_MAX;
    }else if(x <= INT32_MIN){
        printf("XD2\n");
        return INT32_MIN;
    }else{
        printf("XD3\n");
        return x;
    }
}

void main(void){
    int64_t a = INT32_MIN+5, b = -34;
    int32_t a_sat = saturation(a);
    int32_t b_sat = saturation(b);

    int64_t suma = (int64_t)a_sat +  (int64_t)b_sat;
    int32_t suma_sat = saturation(suma);
    
    printf("Suma = %d \n", suma_sat);
    printf("int32 max: %d \n", INT32_MAX);
    printf("int32 min: %d",INT32_MIN);
}


