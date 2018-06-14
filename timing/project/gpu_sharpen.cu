#include <string>

void gpu_sharpen (std::string filename)
{
    BMP Background;
    Background.ReadFromFile(filename.c_str());
    int height = Background.TellHeight();
    int width = Background.TellWidth();
    int depth = Background.TellBitDepth();
    BMP Output(Background);

    cudaError_t cuda_ret;

    int *weights_d;

    int weights[18];


//SET WEIGHTS:
    for(int i = 9; i < 18; i++){
        weights[i] = 1;
    }
    weights[0] = 0;
    weights[1] = -1;
    weights[2] = 0;
    weights[3] = -1;
    weights[4] = 5;
    weights[5] = -1;
    weights[6] = 0;
    weights[7] = -1;
    weights[8] = 0;

//WEIGHTS SET

    ebmpBYTE *A_h, *B_h;
    ebmpBYTE *A_d, *B_d;
    A_h = (ebmpBYTE*) malloc( sizeof(ebmpBYTE)*width*height*3 );
    B_h = (ebmpBYTE*) malloc( sizeof(ebmpBYTE)*width*height*3 );
    for (int i = 0; i < height; i++){
	for (int j = 0; j < width; j++){
	    A_h[(i*width+j)*3] = Background.Pixels[i][j].Blue;
	    A_h[(i*width+j)*3+1] = Background.Pixels[i][j].Green;
	    A_h[(i*width+j)*3+2] = Background.Pixels[i][j].Red;

	}
    }
    dim3 dim_grid, dim_block;

    cudaMalloc((void**)&weights_d, sizeof(int)*18 );
    cudaMalloc((void**)&A_d, sizeof(ebmpBYTE)*width*height*3);
    cudaMalloc((void**)&B_d, sizeof(ebmpBYTE)*width*height*3);

    cudaDeviceSynchronize();

    cudaMemcpy(weights_d, &weights[0], sizeof(int)*18, cudaMemcpyHostToDevice);
    cudaMemcpy(A_d, A_h, sizeof(ebmpBYTE)*width*height*3, cudaMemcpyHostToDevice);

    cudaDeviceSynchronize();

//Timing start
    cudaEvent_t begin, end;
    float time;
    cudaEventCreate(&begin);
    cudaEventCreate(&end);
    cudaEventRecord(begin, 0);

    dim3 DimGrid(1, 1, 1);
    dim3 DimBlock(1024, 1, 1);

    gpu_filter<<<DimGrid, DimBlock>>>(A_d, B_d, weights_d, width, height);

    cuda_ret = cudaDeviceSynchronize();
    if(cuda_ret != cudaSuccess) printf("error");

    cudaMemcpy(B_h, B_d, sizeof(ebmpBYTE)*width*height*3, cudaMemcpyDeviceToHost);

    cudaDeviceSynchronize();

    for (int i = 0; i < height; i++){
	for (int j = 0; j < width; j++){
	    Output.Pixels[i][j].Blue = B_h[(i*width+j)*3];
	    Output.Pixels[i][j].Green = B_h[(i*width+j)*3+1];
	    Output.Pixels[i][j].Red = B_h[(i*width+j)*3+2];
	}
    }

//Timing end
    cudaEventRecord(end, 0);
    cudaEventSynchronize(end);
    cudaEventElapsedTime(&time, begin, end);
    printf("GPU Sharpen time: %f ms \n", time );

    std::string fileout = filename;
    fileout.pop_back();
    fileout.pop_back();
    fileout.pop_back();
    fileout.pop_back();
    string extra = "_gpu_sharpen.bmp";
    fileout = fileout + extra;
    Output.WriteToFile(fileout.c_str());
    free(A_h);
    free(B_h);

    cudaFree(weights_d);
    cudaFree(B_d);
    cudaFree(A_d);
    return;
}


