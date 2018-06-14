CC=nvcc
NVCC_FLAGS= -I/usr/local/cuda/include -std=c++11
SOURCES = main.cu support.cu kernel.cu gpu_blur.cu EasyBMP.cpp cpu_sobel.cpp cpu_edges.cpp cpu_blur.cpp cpu_emboss.cpp cpu_sharpen.cpp cpu_black_and_white.cpp
LD_FLAGS    = -lcudart -L/usr/local/cuda/lib64
EXE	        = a
OBJ	        = main.o support.o

default: $(EXE)

main.o: main.cu support.h
	$(CC) -c -o $@ main.cu $(NVCC_FLAGS)

support.o: support.cu support.h
	$(CC) -c -o $@ support.cu $(NVCC_FLAGS)

$(EXE): $(OBJ)
	$(NVCC) $(OBJ) -o $(EXE) $(LD_FLAGS)

clean:
	rm -rf *.o $(EXE)