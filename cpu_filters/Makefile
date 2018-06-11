CC=nvcc
CXXFLAGS= -std=c++11
ARCH=-arch=sm_52
SOURCES=EXAMPLE.cpp
OBJECTS=$(SOURCES:.cpp=.o)
EXECUTABLE=filter
all: $(SOURCES) $(EXECUTABLE)
    
$(EXECUTABLE): $(OBJECTS) 
	$(CC) $(ARCH) $(OBJECTS) -o $@
.PHONY : clean
clean :
	-rm $(EXECUTABLE)

