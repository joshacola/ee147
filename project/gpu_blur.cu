#include <string>
#include "kernel.cu"

void gpu_blur (std::string filename)
{
    BMP Background;
    Background.ReadFromFile(filename.c_str());
    int height = Background.TellHeight();
    int width = Background.TellWidth();
    int depth = Background.TellBitDepth();
    BMP Output=Background;

    cudaError_t cuda_ret;

    int *weights_d;

    int weights[18];


//SET WEIGHTS:
    for(int i = 0; i < 9; i++){
        weights[i] = 1;
    }
    weights[9] = 16;
    weights[10] = 8;
    weights[11] = 16;
    weights[12] = 8;
    weights[13] = 4;
    weights[14] = 8;
    weights[15] = 16;
    weights[16] = 8;
    weights[17] = 16;

//WEIGHTS SET

    ebmpBYTE *A_h, *B_h;
    ebmpBYTE *A_d, *B_d;
    A_h = &Background.Pixels[0][0].Blue;
    B_h = &Output.Pixels[0][0].Blue;
    dim3 dim_grid, dim_block;

    cudaMalloc((void**)&weights_d, sizeof(int)*18 );
    cudaMalloc((void**)&A_d, sizeof(ebmpBYTE)*width*height*4);
    cudaMalloc((void**)&B_d, sizeof(ebmpBYTE)*width*height*4);

    cudaDeviceSynchronize();

    cudaMemcpy(weights_d, &weights[0], sizeof(int)*18, cudaMemcpyHostToDevice);
    cudaMemcpy(A_d, A_h, sizeof(ebmpBYTE)*width*height*4, cudaMemcpyHostToDevice);

    cudaDeviceSynchronize();

    dim3 DimGrid(1, 1, 1);
    dim3 DimBlock(1024, 1, 1);

    gpu_filter<<<DimGrid, DimBlock>>>(A_d, B_d, weights_d, width, height);

    cuda_ret = cudaDeviceSynchronize();
    if(cuda_ret != cudaSuccess); //FIXME

    cudaMemcpy(B_h, B_d, sizeof(ebmpBYTE)*width*height*4, cudaMemcpyDeviceToHost);

    cudaDeviceSynchronize();

    std::string fileout = filename;
    fileout.pop_back();
    fileout.pop_back();
    fileout.pop_back();
    fileout.pop_back();
    string extra = "_gpu_blur.bmp";
    fileout = fileout + extra;
    Output.WriteToFile(fileout.c_str());
    free(A_h);

    cudaFree(weights_d);
    cudaFree(B_d);
    cudaFree(A_d);
    return;
}


