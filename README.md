Okay  
So far if you go to cpu_filters there are a bunch of files  
You can look at EXAMPLE.cpp to see how to call a filter function  
Right now there are:  
blur  
sharpen  
emboss  
edges  
sobel  
b_and_w (black and white)  
Each can be called with:  
cpu_blur("filename.bmp");  
as seen in EXAMPLE.cpp  
(include filters.h to make it work) 
  
PS: compile with g++ (gcc doesnt work for some reason)  

