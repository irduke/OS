CXX=gcc
CFLAGS=-std=c99

all: list_harness

list_harness: main.o list_t.o
	$(CXX) $(CFALGS) -o $@ $^ 

.PHONY: clean
clean:
	-rm -f *.o *~ list_harness