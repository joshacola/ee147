NVCC=nvcc
NVCC_FLAGS= -03 -I/usr/local/cuda/include -std=c++11
SOURCES=main.cu support.cu kernel.cu gpu_blur.cu EasyBMP.cpp cpu_sobel.cpp cpu_edges.cpp cpu_blur.cpp cpu_emboss.cpp cpu_sharpen.cpp cpu_black_and_white.cpp
OBJECTS=$(SOURCES:.cpp=.o)
EXECUTABLE=filter
all: $(SOURCES) $(EXECUTABLE)
    
$(EXECUTABLE): $(OBJECTS) 
	$(NVCC) $(OBJECTS) -o $@ $(NVCC_FLAGS)
.PHONY : clean
clean :
	rm -rf *.o $(EXECUTABLE)
