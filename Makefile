CXX = g++
CXXFLAGS = -g -Wall -O0
CXXSRCS = towers.cpp 
BIN = mm

all:
	$(CXX) $(CXXFLAGS) -c $(CXXSRCS)
	$(CXX) $(CXXFLAGS) -o $(BIN) *.o

clean:
	rm -f *.o
