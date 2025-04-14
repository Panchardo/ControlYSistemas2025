/* ========================================================================
 * fir_filters.h
 *
 * 
 * Version: 001
 * Date:    2017/04/03
 * Author:  Rodrigo Gonzalez <rodralez@frm.utn.edu.ar>
 * URL:     https://github.com/rodralez/control
 *
 * ===================================================================== */
 
#ifndef FIR_FILTERS_H
#define FIR_FILTERS_H
#include <math.h>
#include <stdio.h>
#include <stdint.h>
#include <limits.h>


//typedef int int32_t;
//typedef long int int64_t;
//typedef unsigned int uint32_t;

void fir_online_float(float *input, float *output);
void fir_offline_float(float *input, uint32_t N, float *output);
void fir_online_fixed(float *input, uint32_t N, float *output);
int32_t fp2fx(float x, int8_t n);
float fx2fp(int32_t x, int8_t n);
int32_t truncation(int64_t X, int8_t n);
int32_t saturation(int64_t x);

#endif
