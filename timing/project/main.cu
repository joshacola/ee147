#include "filters.h"
#include <stdio.h>
#include <stdlib.h>
#include "support.h"
#include <string>
#include <time.h>

using namespace std;

int main(){
	cpu_edges("example.bmp");
    gpu_edges("example.bmp");
    cpu_blur("example.bmp");
    gpu_blur("example.bmp");
    cpu_emboss("example.bmp");
    gpu_emboss("example.bmp");
    cpu_sharpen("example.bmp");
    gpu_sharpen("example.bmp");
    cpu_sobel("example.bmp");
    gpu_sobel("example.bmp");
}
