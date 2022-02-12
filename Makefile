CXX = g++
CXXFLAGS = -g -Wall -O0
CXXSRCS = towers.cpp 
BIN = mm

all:
	$(CXX) $(CXXFLAGS) -c $(CXXSRCS)
	$(CXX) $(CXXFLAGS) -o $(BIN) *.o
	gcc -o towers -g towers.s
	./towers
clean:
	rm -f *.o
