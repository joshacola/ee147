#include <stdio.h>

__global__ void gpu_filter(ebmpBYTE* pixels, ebmpBYTE* pixels_out, int* weights, int width, int height){
    int i = blockIdx.x*blockDim.x+threadIdx.x;
    while (i<(width*height)){
        int column = i % width;
        int row = i / width;
        if (row > 0 && column > 0 && row < height - 1 && column < width - 1){
            int Red = 0;
            int Green = 0;
            int Blue = 0;
            for (int j = column-1; j < column + 2; j++){
                Blue += pixels[((row-1)*width+j)*3+0]*weights[j+1-column]/weights[j+10-column];
                Green += pixels[((row-1)*width+j)*3+1]*weights[j+1-column]/weights[j+10-column];
                Red += pixels[((row-1)*width+j)*3+2]*weights[j+1-column]/weights[j+10-column];

                Blue += pixels[(row*width+j)*3+0]*weights[j+4-column]/weights[j+13-column];
                Green += pixels[(row*width+j)*3+1]*weights[j+4-column]/weights[j+13-column];
                Red += pixels[(row*width+j)*3+2]*weights[j+4-column]/weights[j+13-column];

                Blue += pixels[((row+1)*width+j)*3+0]*weights[j+7-column]/weights[j+16-column];
                Green += pixels[((row+1)*width+j)*3+1]*weights[j+7-column]/weights[j+16-column];
                Red += pixels[((row+1)*width+j)*3+2]*weights[j+7-column]/weights[j+16-column];
            }
	    if (Blue > 255) Blue = 255;
            if (Green > 255) Green = 255;
            if (Red > 255) Red = 255;
            if (Blue < 0) Blue = 0;
            if (Green < 0) Green = 0;;
            if (Red < 0) Red = 0;
	    pixels_out[(row*width+column)*3] = Blue;
	    pixels_out[(row*width+column)*3+1] = Green;
	    pixels_out[(row*width+column)*3+2] = Red;
        }
        i+=1024;
    }
    return;
}
