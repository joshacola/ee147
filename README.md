GPU filters are done! These are the filters we have so far:  
blur  
sharpen  
emboss  
edges  
sobel  
b_and_w  
  
Each can be called with:  
  
cpu_blur("filename.bmp");  
OR  
gpu_blur("filename.bmp");  
  
with the exception of b_and_w, (only cpu_b_and_w is done at this time)  
NOTE: Include filters.h to make it work!  
  
example.cu gives an example program, you can compile it with ./compile  
because I don't know how to use makefiles and I'm too lazy to learn  
  
or alternatively you can just type  
nvcc -I/usr/local/cuda/include -std=c++11 filename.cu  
