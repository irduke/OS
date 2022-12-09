CXX=gcc
CFLAGS=-std=c99

all: disk_image

disk_image: fs.o
	$(CXX) $(CFALGS) -o $@ $^ 

.PHONY: cleans
clean:
	-rm -f *.o *~ disk_image