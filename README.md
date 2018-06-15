For bitmap images, with blur, sharpen, emboss, sobel, and edge detection filters:  
First open the directory /c++_files. The image file to run kernels on must be in this directory and needs to be called “example.bmp” (we have included an image, so it is not necessary to find your own if you don’t want to). The example program can being run using make and then ./a.out (from /c++ files).  
Or, alternatively, you write your own program using the filter functions found in main.cu, then compile with      nvcc -I/usr/local/cuda/include -std=c++11 filename.cu  
If you choose to write your own program, make sure to include filters.h, this will include all the other required files for you (open main.cu to see an example).  
  
For jpeg images with black and white filter:  
The black and white filter is written with python. Can be run using the python main.py command.   
