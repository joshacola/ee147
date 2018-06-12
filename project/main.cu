#include <stdio.h>
#include <stdlib.h>
#include "kernel.cu"
#include "support.h"
void gpu_blur (string filename)
{
    BMP Background;
    Background.ReadFromFile(filename.c_str());
    int height = Background.TellHeight();
    int width = Background.TellWidth();
    int depth = Background.TellBitDepth();
    BMP Output;
    Output.SetSize( width , height );
    Output.SetBitDepth( 24 );

    cudaError_t cuda_ret;

    int *weigths, *weights_d;

    weights = (int*) malloc( sizeof(int)*18 );


//SET WEIGHTS:
    for(int i = 0; i < 9; i++){
        weights[i] = 1;
    }
    weights[10] = 16;
    weights[11] = 8;
    weights[12] = 16;
    weights[13] = 8;
    weights[14] = 4;
    weights[15] = 8;
    weights[16] = 16;
    weights[17] = 8;
    weights[18] = 16;

//WEIGHTS SET

    ebmpBYTE *A_h, *B_h;
    ebmpBYTE *A_d, *B_d;
    A_h = *Background.Pixels;
    B_h = *Output.Pixels;
    dim3 dim_grid, dim_block;

    cudaMalloc((void**)&weights_d, sizeof(int)*18 );
    cudaMalloc((void**)&A_d, sizeof(ebmpBYTE)*width*height*4);
    cudaMalloc((void**)&B_d, sizeof(ebmpBYTE)*width*height*4);

    cudaDeviceSynchronize();

    cudaMemcpy(weights_d, weights, sizeof(int)*18, cudaMemcpyHostToDevice);
    cudaMemcpy(A_d, A_h, sizeof(ebmpBYTE)*width*height*4, cudaMemcpyHostToDevice);

    cudaDeviceSynchronize();

    dim3 DimGrid(1, 1, 1);
    dim3 DimBlock(1024, 1, 1);

    gpu_filter<<<DimGrid, DimBlock>>>(A_d, B_d, weights_d, width, height);

    cuda_ret = cudaDeviceSynchronize();
    if(cuda_ret != cudaSuccess) FATAL("Unable to launch kernel");

    cudaMemcpy(B_h, B_d, sizeof(ebmpBYTE)*width*height*4, cudaMemcpyDeviceToHost);

    cudaDeviceSynchronize();

    string fileout = filename;
    fileout.pop_back();
    fileout.pop_back();
    fileout.pop_back();
    fileout.pop_back();
    string extra = "_cpu_blur.bmp";
    fileout = fileout + extra;
    Output.WriteToFile(fileout.c_str());
    free(weights);
    free(A_h);
    free(B_h);

    cudaFree(weights_d);
    cudaFree(B_d);
    cudaFree(A_d);
    return(0);
}


