#include <stdio.h>
   
__global__ void gpu_filter(int n, const float *A, const float *B, float* C) {
	unsigned int i = blockIdx.x*256+threadIdx.x;
	if (i < n) C[i] = A[i] + B[i];
	return;
}
