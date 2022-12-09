CXX=gcc
CFLAGS=-std=c99

all: disk_image

disk_image: fs.o
	$(CXX) $(CFLAGS) -o $@ $^ 

.PHONY: cleans
clean:
	-rm -f *.o *~ disk_image

SUBMIT_FILENAME=fs-ird2dpj-sg4sgz.tar.gz

archive:
	tar "--exclude=*.tgz" --exclude=msh --exclude=.git "--exclude=*.o" -zcvf $(SUBMIT_FILENAME) *