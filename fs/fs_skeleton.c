#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <assert.h>
#include "inode.h"

#define TOTAL_BLOCKS (10)
  // TODO: redefine total blocks so it can be dynamically allocated by nblocks

static unsigned char *rawdata;
static char *bitmap;

int get_free_block()
{
  // fill in here
  int blockno;
  for(blockno = 0; blockno < TOTAL_BLOCKS; blockno++) {
    if(bitmap[blockno]) continue;
    else return blockno;
  }
  // assert(blockno < TOTAL_BLOCKS);
  // assert(bitmap[blockno]);
  return blockno;
}

void write_int(int pos, int val)
{
  int *ptr = (int *)&rawdata[pos];
  *ptr = val;
}

void place_file(char *file, int uid, int gid)
{
  int i, j, n, nbytes = 0;
  int i2block_index, i3block_index;
  struct inode *ip;
  FILE *fpr;
  unsigned char buf[BLOCK_SZ];

  ip->mode = 0;
  ip->nlink = 1;
  ip->uid = uid;
  ip->gid = gid;
  ip->ctime = rand();
  ip->mtime = rand();
  ip->atime = rand();

  fpr = fopen(file, "rb");
  if (!fpr) {
    perror(file);
    exit(1);
  }

  for (i = 0; i < N_DBLOCKS; i++) {
    int blockno = get_free_block();
    ip->dblocks[i] = blockno;
    // fill in here
    n = fread(&rawdata[ip->dblocks[i]*1024], 1024, 1, fpr);
    if(n < 1024) return;
  }

  // fill in here if IBLOCKS needed
  // if so, you will first need to get an empty block to use for your IBLOCK
  for (i = 0; i < N_IBLOCKS; i++){
    for(j = 0; j < N_DBLOCKS; j++) {
      n = fread(&rawdata[rawdata[ip->iblocks[i]*1024]*1024], 1024, 1, fpr);
      if(n < 1024) return;
    }
  }

  ip->size = nbytes;  // total number of data bytes written for file
  printf("successfully wrote %d bytes of file %s\n", nbytes, file);
}

int main(int argc, char *argv[]) 
{
  if (argc < 2) {
    printf("Insufficient arguments\n");
    exit(1);
  }
  int i;
  FILE *outfile;

  // create
  int nblocks, iblocks, uid, gid, block, inodepos; 
  char *input_file;
  char *output_filename;
  
  // Number of args should be 18 for create/insert, 10 for extract
  if (strcmp(argv[1], "-create") == 0 || strcmp(argv[1], "-insert") == 0) {
    if (argc != 18) {
      printf("Incorrect number of arguments, got: %d, expected 18", argc);
    }
    else {
      output_filename = argv[3];
      nblocks = atoi(argv[5]);
      iblocks = atoi(argv[7]);
      input_file = argv[9];
      uid = atoi(argv[11]);
      gid = atoi(argv[13]);
      block = atoi(argv[15]);
      inodepos = atoi(argv[17]);

      // TODO: add handling for create vs insert

    }
  }
  else if (strcmp(argv[1], "-extract") == 0) {
    if (argc != 10) {
      printf("Incorrect number of arguments, got: %d, expected 10", argc);
      exit(1);
    }
  }
  else {
    printf("Invalid arguments\n");
    exit(1);
  }

  // TA added this 
  rawdata = (unsigned char*)malloc(nblocks*BLOCK_SZ);
  bitmap = (char*)malloc(nblocks);

  outfile = fopen(output_filename, "wb");
  if (!outfile) {
    perror("datafile open");
    exit(1);
  }

  // fill in here to place file 
  // place_file(input_file, uid, gid);

  i = fwrite(rawdata, 1, TOTAL_BLOCKS*BLOCK_SZ, outfile);
  if (i != TOTAL_BLOCKS*BLOCK_SZ) {
    perror("fwrite");
    exit(1);
  }

  i = fclose(outfile);
  if (i) {
    perror("datafile close");
    exit(1);
  }

  printf("Done.\n");
  return 0;
}