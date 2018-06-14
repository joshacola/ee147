#include "filters.h"
#include <stdio.h>
#include <stdlib.h>
#include "support.h"
#include <string>
#include <time.h>

using namespace std;

int main(){
    //Timing Start
    struct timespec begin, end;
    clock_gettime(CLOCK_MONOTONIC, &begin);

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

    //Timing End
    clock_gettime(CLOCK_MONOTONIC, &end);
    uint64_t time_taken;
    time_taken = (end.tv_sec - begin.tv_sec)*1000000000;
    time_taken+=(end.tv_nsec - begin.tv_nsec);
    time_taken = time_taken / 1000000;
    cout << "Total time: " <<  time_taken << " ms" << endl;
}
