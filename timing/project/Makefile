CC=nvcc
NVCC_FLAGS= -I/usr/local/cuda/include -std=c++11
SOURCES = main.cu support.cu support.h
LD_FLAGS    = -lcudart -L/usr/local/cuda/lib64
EXE	        = a.out
OBJ	        = main.o support.o

default: $(EXE)

main.o: main.cu support.h
	$(CC) -c -o $@ main.cu $(NVCC_FLAGS)

support.o: support.cu support.h
	$(CC) -c -o $@ support.cu $(NVCC_FLAGS)

$(EXE): $(OBJ)
	$(CC) $(OBJ) -o $(EXE) $(LD_FLAGS)

clean:
	rm -rf *.o $(EXE)
