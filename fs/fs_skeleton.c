#include <stdlib.h>
#include <stdio.h>
#include <strings.h>
#include <errno.h>
#include <assert.h>
#include "inode.h"

#define TOTAL_BLOCKS (10*1024)
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
  ip->ctime = random();
  ip->mtime = random();
  ip->atime = random();

  fpr = fopen(file, "rb");
  if (!fpr) {
    perror(file);
    exit(-1);
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

void main(int argc, char *argv[]) // add argument handling
{
  int i;
  FILE *outfile;
  int nblocks, iblocks, uid, gid, inodepos; // create
  
  // TODO: fix argument handling

  // create
  if(argv[0] == "-create") {
    nblocks = atoi(argv[4]);
    iblocks = atoi(argv[6]);
    uid = atoi(argv[10]);
    gid = atoi(argv[12]);
    inodepos = atoi(argv[14]);
  }

  rawdata = (unsigned char*)malloc(nblocks*BLOCK_SZ);
  bitmap = (char*)malloc(nblocks);

  outfile = fopen(output_filename, "wb");
  if (!outfile) {
    perror("datafile open");
    exit(-1);
  }

  // fill in here to place file 

  i = fwrite(rawdata, 1, TOTAL_BLOCKS*BLOCK_SZ, outfile);
  if (i != TOTAL_BLOCKS*BLOCK_SZ) {
    perror("fwrite");
    exit(-1);
  }

  i = fclose(outfile);
  if (i) {
    perror("datafile close");
    exit(-1);
  }

  printf("Done.\n");
  return;
}