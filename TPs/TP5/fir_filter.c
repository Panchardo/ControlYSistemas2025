
#include "fir_filter.h"
#include "fdacoefs.h"
#include "mex.h"

//#define DEBUG 1
static int32_t B_fixed[101];
static uint8_t coeffs_converted = 0;  // flag para saber si ya se convirtieron

void fir_online_float(float *input, float *output)
{
    static uint32_t counter = 0;
    static float cir_buff[101] = {0.0};
    static float * start = &cir_buff[0];   // pointer to the start of the circular buffer
    static float * end = &cir_buff[BL-1];  // pointer to the end of the circular buffer
    static float * head;                    // pointer to the new element at the circular buffer
    
    uint32_t j, idx;
    float acc;
    
#ifdef  DEBUG
    mexPrintf("input = %f \n", *(input) );
#endif
    
#ifdef  DEBUG
    mexPrintf("output = %f \n", *(output) );
#endif
    
    idx = counter % BL;             // modulus operator
    counter++;

    cir_buff[idx] = *(input);       // load new element to the circular buffer
    head = &cir_buff[idx];          // pointer new element at the circular buffer
    
    acc = 0.0;
    
    for (j = 0; j < BL; j++)
    {
        acc = acc + ( *(head--) * B[j] );
        
        if(head < start){
            head = end;
        }        
    }
    
#ifdef  DEBUG
    mexPrintf("acc = %f \n", acc);
#endif
    
    *(output) = acc;
}


void fir_offline_float(float *input, uint32_t N, float *output)
{
	uint32_t i, j;

    float acc;

	for (i=0; i < N; i++)
	{
		output[i] = 0.0;
	}

	for (i=0; i < N-BL; i++)
	{
		acc = 0.0;

		for (j=0; j < BL; j++)
		{
			acc = acc + (input[j+i] * B[j]);
		}

		output[i+BL] = acc;
	}
}

void fir_online_fixed(float *input, uint32_t N, float *output)
{
 //   mexPrintf("input = %f \n", *(input) );
        // Convertir coeficientes solo una vez
    if (!coeffs_converted) {
        for (uint32_t k = 0; k < BL; k++) {
            B_fixed[k] = fp2fx(B[k], N);
            
 //           mexPrintf("acc = %d \n", B_fixed[k]);
        }
        coeffs_converted = 1;
    }
    
    int32_t inputFixed = fp2fx(*input, N);
//    mexPrintf("inputFixed = %d \n", inputFixed );
    static uint32_t counter = 0;
    static int32_t cir_buff[101] = {0};
    static int32_t * start = &cir_buff[0];   // pointer to the start of the circular buffer
    static int32_t * end = &cir_buff[BL-1];  // pointer to the end of the circular buffer
    static int32_t * head;                    // pointer to the new element at the circular buffer
    
    uint32_t i, idx;
    int64_t acc;
    
    idx = counter % BL;             // modulus operator
    counter++;

    cir_buff[idx] = inputFixed;       // load new element to the circular buffer
    head = &cir_buff[idx];          // pointer new element at the circular buffer
    
    acc = 0;


	for (i=0; i < BL; i++)
	{
        
        acc = (int64_t)(acc) + ( (int64_t)*(head--) * (int64_t)B_fixed[i] );
        if(head < start){
            head = end;
        } 
	}
    
  //  mexPrintf("acc = %d \n", acc);
    int32_t suma_trunc = truncation(acc,N);
 //   int32_t suma_sat = saturation(acc);
    float outputFloat = fx2fp(suma_trunc, N);
 //   mexPrintf("outputFloat = %f \n", outputFloat );
    *(output) = outputFloat;

}

int32_t fp2fx(float x, int8_t n) {
    return (int32_t)(x * (1 << n));
}

float fx2fp(int32_t x, int8_t n) {
    return (float)x / (1 << n);
}

int32_t truncation(int64_t X, int8_t n) {
    int32_t a = (int32_t)(X >> n);  // Desplazamiento a la derecha para truncar
    return a;
}
int32_t saturation(int64_t x){
    if (x >= INT32_MAX){
        return INT32_MAX;
    }else if(x <= INT32_MIN){
        return INT32_MIN;
    }else{
        return x;
    }
}

