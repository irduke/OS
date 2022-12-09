#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <strings.h>
#include <errno.h>
#include <assert.h>
#include "inode.h"

static unsigned char *rawdata;
static char *bitmap;
static enum {create, insert, extract} func;
static unsigned int nblocks;
static char* input_file;
static char* path;

int min(int a, int b) {
  return (a > b) ? b : a;
}

void init_bitmap(int iblocks)
{
  // assert(nblocks < TOTAL_BLOCKS);
  // assert(iblocks < TOTAL_BLOCKS);
  int i;
  switch(func) {
    case create: 
      for (i = 0; i < nblocks; i++) {
        if(i < iblocks) {
          bitmap[i] = 1;
        } 
        else {
          bitmap[i] = 0;
        }
      }
      return;
    case insert:
      //TODO: implement insert bitmap
      return;
    case extract:
      //TODO: implement extract bitmap for unused blocks
      return;
  }
}

int get_free_block()
{
  int blockno;
  int i;
  for (i = 0; i < nblocks; i++) {
    if (bitmap[i] == 0) {
      blockno = i;
      bitmap[i] = 0b1;
      return blockno;
    }
  }
  perror("No Available Block");
  exit(-1);
}

int init_dblocks(struct inode *ip, FILE *fpr, unsigned char *buf)
{
  int i, j, num_bytes = 0;
  char c;

  for (i = 0; i < N_DBLOCKS; i++) {
    int blockno = get_free_block();
    ip->dblocks[i] = blockno;
    j = 0;
    memset(buf, 0, BLOCK_SZ);
    while ((j < BLOCK_SZ) && !(feof(fpr))) {
      c = fgetc(fpr);
      num_bytes += 1;
      buf[j] = c;
      j++;
    }
    memcpy(&rawdata[blockno * BLOCK_SZ], buf, BLOCK_SZ);
    if (feof(fpr)) {
      return num_bytes;
    }
  }
  return num_bytes;
}

int init_iblocks(struct inode *ip, FILE *fpr, unsigned char *buf)
{
  int i, j, k, num_bytes = 0;
  char c;
  unsigned char inode_buffer[BLOCK_SZ];

  for (i = 0; i < N_IBLOCKS; i++) {
    int iblockno = get_free_block();
    // printf("%d", iblockno);
    ip->iblocks[i] = iblockno;
    memset(inode_buffer, 0, BLOCK_SZ);
    for (j = 0; j < N_DBLOCKS_IBLOCK; j++) {
      int blockno = get_free_block();
      memcpy(&inode_buffer[4*j], &blockno, 4);
      k = 0;
      memset(buf, 0, BLOCK_SZ);
      while ((k < BLOCK_SZ) && !(feof(fpr))) {
        c = fgetc(fpr);
        num_bytes += 1;
        buf[k] = c;
        k++;
      }
      memcpy(&rawdata[blockno * BLOCK_SZ], buf, BLOCK_SZ);

      if (feof(fpr)) {
        memcpy(&rawdata[iblockno * BLOCK_SZ], &inode_buffer[0], BLOCK_SZ);
        return num_bytes;
      }
    }
    memcpy(&rawdata[iblockno * BLOCK_SZ], &inode_buffer[0], BLOCK_SZ);
  }
  // exit(-1);
  return num_bytes;
}

void place_file(struct inode *ip, FILE *fpr, int uid, int gid, int D, int I)
{
  int total_bytes = 0;
  int i2block_index, i3block_index;
  unsigned char buf[BLOCK_SZ];

  ip->mode = 0;
  ip->nlink = 1;
  ip->uid = uid;
  ip->gid = gid;
  ip->ctime = rand();
  ip->mtime = rand();
  ip->atime = rand();

  total_bytes += init_dblocks(ip, fpr, &buf[0]);

  // Allocate IBLOCKS if needed
  if (!feof(fpr)) {
    // printf("IBLOCKS needed\n");
    total_bytes += init_iblocks(ip, fpr, &buf[0]);
  }

  // // Allocate I2Block if needed
  // if (!feof(fpr)) {
    // Didn't get to it :(
      // 1 * (1024/4) * (1024/4) * 1024
  // }

  // // Allocate I3Block if needed
  // if (!feof(fpr)) {
    // Didn't get to it :(
  // }

  ip->size = total_bytes;
  printf("Wrote %d bytes to file %s\n", total_bytes, input_file);

  memcpy((&rawdata[D * BLOCK_SZ] + (I * INODE_SIZE)), ip, INODE_SIZE);
}

void extract_file(FILE *fpr, struct inode *ip) {
  int remainder = (ip->size) % BLOCK_SZ;
  unsigned char buf[(ip->size) + BLOCK_SZ - remainder];
  int i, j;

  // DBLOCKS
  int ub = min(N_DBLOCKS, ((ip->size / BLOCK_SZ)+1));
  for(i = 0; i < ub; i++) {
    fseek(fpr, (ip->dblocks[i]*BLOCK_SZ), SEEK_SET);
    fread(&buf[BLOCK_SZ*i], BLOCK_SZ, 1, fpr);
  }

  // IBLOCKS
  ub = min(N_IBLOCKS, ((ip->size - DBLOCKS_SIZE) / IBLOCKS_SIZE));
  int d_num;
  for (i = 0; i < ub; i++) {
    for (j = 0; j < N_DBLOCKS_IBLOCK; j++) {
      fseek(fpr, ((ip->iblocks[i]*BLOCK_SZ) + 4*j), SEEK_SET);
      fread(&d_num, 4, 1, fpr);
      fseek(fpr, (d_num * BLOCK_SZ), SEEK_SET);
      fread(&buf[DBLOCKS_SIZE+(BLOCK_SZ*j)], BLOCK_SZ, 1, fpr);
    }
  }

  char name[100];
  sprintf(name, "%s/%d_%d", path, ip->size, rand());
  fpr = fopen(name, "wb");
  if (!fpr) {
    perror("datafile open");
    exit(-1);
  }

  i = fwrite(&buf[0], ip->size, 1, fpr);
  if (i != 1) {
    perror("fwrite");
    exit(-1);
  }

  i = fclose(fpr);
  if (i) {
    perror("datafile close");
    exit(-1);
  }
  
}

void extract_inodes(FILE *fpr, int uid, int gid)
{
  unsigned char inode_buffer[100];
  struct inode *ip;
  
  int unused_blocks[10*1024];
  int read_val, cumulative_sum = 0;

  int i = 0;
  while(1) {
    read_val = fread(&inode_buffer[0], 1, 100, fpr);
    if (read_val < 100) break;
    cumulative_sum += 1;

    ip = (struct inode*) &inode_buffer[0];
    if (ip->uid == uid && ip->gid == gid) {
      printf("File found at inode in block %d, file size %d\n", (cumulative_sum/BLOCK_SZ), ip->size);
      extract_file(fpr, ip);
      if(cumulative_sum % BLOCK_SZ == 0) {  // new block .. used
        unused_blocks[cumulative_sum/BLOCK_SZ] = 0;
      }
    }
    else if((ip->uid != uid && ip->gid != gid) && (cumulative_sum % BLOCK_SZ == 0)) {
      // FOUND A NEW BLOCK ... UNUSED
      unused_blocks[cumulative_sum/BLOCK_SZ] = 1;
    }
    i++;
    fseek(fpr, i, SEEK_SET);
  }

  // create UNUSED_BLOCKS file
  int ub;
  FILE *ub_fp;
  char unused_block[10*1024];
  ub_fp = fopen("UNUSED_BLOCKS.txt", "w");
  for(ub = 0; ub < 10*1024; ub++) {
    if(unused_blocks[ub] == 1) {
      sprintf(unused_block, "%d", ub);
      fputs(unused_block, ub_fp);
      fputs("\n", ub_fp);
    }
  }
  fclose(ub_fp);
}

void main(int argc, char **argv)
{
  int i;
  FILE *fpr;
  struct inode *ip;

  char *image_file;
  int iblocks;
  int uid;
  int gid;
  int block;
  int inodepos;

  if (argc < 10) {
    perror("Too few args");
    exit(1);
  }
  if (strcmp(argv[1], "-create") == 0 || strcmp(argv[1], "-insert") == 0) {
    func = create;
    if (argc != 18 || inodepos > 10) {
      perror("Invalid args");
      exit(1);
    }
    image_file = argv[3];
    nblocks = atoi(argv[5]);
    iblocks = atoi(argv[7]);
    input_file = argv[9];
    uid = atoi(argv[11]);
    gid = atoi(argv[13]);
    block = atoi(argv[15]);
    inodepos = atoi(argv[17]);

    if(strcmp(argv[1], "-insert") == 0) {
      // insert functionaltiy 
      
      fpr = fopen(image_file, "rb");
      if (!fpr) {
        perror("datafile open");
        exit(-1);
      }

      rawdata = malloc(nblocks * BLOCK_SZ);
      memset(rawdata, 0, (nblocks * BLOCK_SZ));
      fread(rawdata, nblocks * BLOCK_SZ, 1, fpr);
      bitmap = malloc(nblocks);
      init_bitmap(iblocks);
      ip = malloc(sizeof(struct inode));

      fpr = fopen(input_file, "rb");
      if (!fpr) {
        perror(input_file);
        exit(-1);
      }
      place_file(ip, fpr, uid, gid, block, inodepos);
    }
    else if(strcmp(argv[1], "-create") == 0) {
      // create functionality

      rawdata = malloc(nblocks * BLOCK_SZ);
      memset(rawdata, 0, (nblocks * BLOCK_SZ));
      bitmap = malloc(nblocks);
      init_bitmap(iblocks);
      ip = malloc(sizeof(struct inode));
        
      fpr = fopen(input_file, "rb");
      if (!fpr) {
        perror(input_file);
        exit(-1);
      }
      place_file(ip, fpr, uid, gid, block, inodepos);
    }

    fpr = fopen(image_file, "wb");
    if (!fpr) {
      perror("datafile open");
      exit(-1);
    }
    i = fwrite(rawdata, 1, nblocks*BLOCK_SZ, fpr);
    if (i != nblocks*BLOCK_SZ) {
      perror("fwrite");
      exit(-1);
    }
    i = fclose(fpr);
    if (i) {
      perror("datafile close");
      exit(-1);
    }
  } 
  else if (strcmp(argv[1], "-extract") == 0) {
    if (argc != 10) {
      perror("Incorrect number of args");
      exit(1);
    }
    func = extract;
    image_file = argv[3];
    uid = atoi(argv[5]);
    gid = atoi(argv[7]);
    path = argv[9];

    fpr = fopen(image_file, "rb");
    if (!fpr) {
      perror(image_file);
      exit(-1);
    }
    extract_inodes(fpr, uid, gid);
    fseek(fpr, 0, SEEK_SET);
  } 
  else {
    perror("Unrecognized Function");
    exit(-1);
  }

  printf("Done.\n");
  return;
}
