/******************************************************************************
 *cr
 *cr            (C) Copyright 2010 The Board of Trustees of the
 *cr                        University of Illinois
 *cr                         All Rights Reserved
 *cr
 ******************************************************************************/

#include <stdio.h>

#define TILE_SIZE 16

__global__ void mysgemm(int m, int n, int k, const float *A, const float *B, float* C) {

    /********************************************************************
     *
     * Compute C = A x B
     *   where A is a (m x k) matrix
     *   where B is a (k x n) matrix
     *   where C is a (m x n) matrix
     *
     * Use shared memory for tiling
     *
     ********************************************************************/

    // INSERT KERNEL CODE HERE
    __shared__ float ds_M[TILE_SIZE][TILE_SIZE];
    __shared__ float ds_N[TILE_SIZE][TILE_SIZE];
    int a1 = blockIdx.x;
    int a2 = blockIdx.y;
    int b1 = threadIdx.x;
    int b2 = threadIdx.y;
    int column = blockDim.x * a1 + b1;
    int row = blockDim.y * a2 + b2;
    float temp = 0;
    int width = m;
    if (n > width) width = n;
    if (k > width) width = k;
    for (int i = 0; i < (width - 1)/TILE_SIZE + 1; i++){ //maybe
	if (row < m && i * TILE_SIZE + b1 < k){
	    ds_M[b2][b1] = A[row * k + i*TILE_SIZE + b1]; //maybe
	}
	else {
	    ds_M[b2][b1] = 0.0;
	}
	if ((i * TILE_SIZE + b2) < k && column < n){	
		ds_N[b2][b1] = B[(i * TILE_SIZE + b2) * n + column]; //maybe
	}
	else {
	    ds_N[b2][b1] = 0.0;
	}
	__syncthreads();
	if (row < m && column < n){ //maybe
	    for (int j = 0; j < TILE_SIZE; j++){
	        temp += ds_M[b2][j] * ds_N[j][b1];
	    }
	}
	__syncthreads();
    }
    if (row < m && column < n){
	C[row * n + column] = temp;
    }
}

void basicSgemm(char transa, char transb, int m, int n, int k, float alpha, const float *A, int lda, const float *B, int ldb, float beta, float *C, int ldc)
{
    if ((transa != 'N') && (transa != 'n')) {
	printf("unsupported value of 'transa'\n");
    	return;
    }

    if ((transb != 'N') && (transb != 'n')) {
	printf("unsupported value of 'transb'\n");
	return;
    }

    if ((alpha - 1.0f > 1e-10) || (alpha - 1.0f < -1e-10)) {
	printf("unsupported value of alpha\n");
	return;
    }

    if ((beta - 0.0f > 1e-10) || (beta - 0.0f < -1e-10)) {
	printf("unsupported value of beta\n");
	return;
    }

    // Initialize thread block and kernel grid dimensions ---------------------

    const unsigned int BLOCK_SIZE = TILE_SIZE;

    //INSERT CODE HERE
    int temp = m;
    if (n > temp) temp = n;
    if (k > temp) temp = k;
    dim3 DimGrid((temp-1)/BLOCK_SIZE+1, (temp-1)/BLOCK_SIZE+1, 1);
    dim3 DimBlock(BLOCK_SIZE, BLOCK_SIZE, 1);

    // Invoke CUDA kernel -----------------------------------------------------

    //INSERT CODE HERE
    mysgemm<<<DimGrid, DimBlock>>>(m, n, k, A, B, C);



}


