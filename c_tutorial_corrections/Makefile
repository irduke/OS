CXX=gcc
CFLAGS=-std=c99

all: list_harness

list_harness: main.o list_t.o
	$(CXX) $(CFALGS) -o $@ $^ 

.PHONY: clean
clean:
	-rm -f *.o *~ list_harness

SUBMIT_FILENAME=c_tutorial-ird2dpj-sg4sgz.tar.gz

archive:
	tar "--exclude=*.tgz" --exclude=msh --exclude=.git "--exclude=*.o" -zcvf $(SUBMIT_FILENAME) *