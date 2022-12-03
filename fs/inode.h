#ifndef INODE_H
#define INODE_H

#define BLOCK_SZ 1024
#define N_DBLOCKS 12
#define N_IBLOCKS 3
#define N_DBLOCKS_IBLOCK 256

#define TOTAL_BLOCKS (10*1024)

#define DBLOCKS_SIZE (BLOCK_SZ * N_DBLOCKS)
#define IBLOCKS_SIZE (N_DBLOCKS_IBLOCK * BLOCK_SZ)
#define INODE_SIZE  100


struct inode {
  int mode;	/* Unknown field */
  int nlink;	/* Number of links to this file */
  int uid;	/* Owner's user ID */
  int gid;	/* Owner's group ID */
  int size;	/* Number of bytes in file */
  int ctime;	/* Time field */
  int mtime;	/* Time field */
  int atime;	/* Time field */
  int dblocks[N_DBLOCKS]; /* Pointers to data blocks */
  int iblocks[N_IBLOCKS]; /* Pointers to indirect blocks */
  int i2block;	/* Pointer to doubly indirect block */
  int i3block;	/* Pointer to triply indirect block */
};

#endif
