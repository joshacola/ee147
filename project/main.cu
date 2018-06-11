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

ebmpBYTE *A_h, *B_h;
ebmpBYTE *A_d, *B_d;
A_h = *Background.Pixels;
B_h = *Output.Pixels;
dim3 dim_grid, dim_block;

cudaMalloc((void**)&A_d, sizeof(ebmpBYTE)*width*height);
cudaMalloc((void**)&B_d, sizeof(ebmpBYTE)*width*height);

cudaDeviceSynchronize();

cudaMemcpy(A_d, A_h, sizeof(ebmpBYTE)*width*height, cudaMemcpyHostToDevice);

cudaDeviceSynchronize();

//FIXME KERNEL CALL HERE

cuda_ret = cudaDeviceSynchronize();
if(cuda_ret != cudaSuccess) FATAL("Unable to launch kernel");

cudaMemcpy(B_h, B_d, sizeof(ebmpBYTE)*width*height, cudaMemcpyDeviceToHost);

cudaDeviceSynchronize();

string fileout = filename;
fileout.pop_back();
fileout.pop_back();
fileout.pop_back();
fileout.pop_back();
string extra = "_cpu_blur.bmp";
fileout = fileout + extra;
Output.WriteToFile(fileout.c_str());

free(A_h);
free(B_h);
cudaFree(B_d);
cudaFree(A_d);
return(0);
}


