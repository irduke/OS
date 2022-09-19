
_cat:     file format elf32-i386


Disassembly of section .text:

00000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	56                   	push   %esi
   4:	53                   	push   %ebx
   5:	83 ec 10             	sub    $0x10,%esp
   8:	8b 75 08             	mov    0x8(%ebp),%esi
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
   b:	eb 35                	jmp    42 <cat+0x42>
    if (write(1, buf, n) != n) {
   d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  11:	c7 44 24 04 20 04 00 	movl   $0x420,0x4(%esp)
  18:	00 
  19:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  20:	e8 0b 01 00 00       	call   130 <write>
  25:	39 d8                	cmp    %ebx,%eax
  27:	74 19                	je     42 <cat+0x42>
      printf(1, "cat: write error\n");
  29:	c7 44 24 04 c5 03 00 	movl   $0x3c5,0x4(%esp)
  30:	00 
  31:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  38:	e8 2f 02 00 00       	call   26c <printf>
      exit();
  3d:	e8 ce 00 00 00       	call   110 <exit>
  while((n = read(fd, buf, sizeof(buf))) > 0) {
  42:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  49:	00 
  4a:	c7 44 24 04 20 04 00 	movl   $0x420,0x4(%esp)
  51:	00 
  52:	89 34 24             	mov    %esi,(%esp)
  55:	e8 ce 00 00 00       	call   128 <read>
  5a:	89 c3                	mov    %eax,%ebx
  5c:	85 c0                	test   %eax,%eax
  5e:	7f ad                	jg     d <cat+0xd>
    }
  }
  if(n < 0){
  60:	85 c0                	test   %eax,%eax
  62:	79 19                	jns    7d <cat+0x7d>
    printf(1, "cat: read error\n");
  64:	c7 44 24 04 d7 03 00 	movl   $0x3d7,0x4(%esp)
  6b:	00 
  6c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  73:	e8 f4 01 00 00       	call   26c <printf>
    exit();
  78:	e8 93 00 00 00       	call   110 <exit>
  }
}
  7d:	83 c4 10             	add    $0x10,%esp
  80:	5b                   	pop    %ebx
  81:	5e                   	pop    %esi
  82:	5d                   	pop    %ebp
  83:	c3                   	ret    

00000084 <main>:

int
main(int argc, char *argv[])
{
  84:	55                   	push   %ebp
  85:	89 e5                	mov    %esp,%ebp
  87:	57                   	push   %edi
  88:	56                   	push   %esi
  89:	53                   	push   %ebx
  8a:	83 e4 f0             	and    $0xfffffff0,%esp
  8d:	83 ec 10             	sub    $0x10,%esp
  int fd, i;

  if(argc <= 1){
  90:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  94:	7f 63                	jg     f9 <main+0x75>
    cat(0);
  96:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  9d:	e8 5e ff ff ff       	call   0 <cat>
    exit();
  a2:	e8 69 00 00 00       	call   110 <exit>
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
  a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  aa:	8d 3c 98             	lea    (%eax,%ebx,4),%edi
  ad:	8b 07                	mov    (%edi),%eax
  af:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  b6:	00 
  b7:	89 04 24             	mov    %eax,(%esp)
  ba:	e8 91 00 00 00       	call   150 <open>
  bf:	89 c6                	mov    %eax,%esi
  c1:	85 c0                	test   %eax,%eax
  c3:	79 1f                	jns    e4 <main+0x60>
      printf(1, "cat: cannot open %s\n", argv[i]);
  c5:	8b 07                	mov    (%edi),%eax
  c7:	89 44 24 08          	mov    %eax,0x8(%esp)
  cb:	c7 44 24 04 e8 03 00 	movl   $0x3e8,0x4(%esp)
  d2:	00 
  d3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  da:	e8 8d 01 00 00       	call   26c <printf>
      exit();
  df:	e8 2c 00 00 00       	call   110 <exit>
    }
    cat(fd);
  e4:	89 04 24             	mov    %eax,(%esp)
  e7:	e8 14 ff ff ff       	call   0 <cat>
    close(fd);
  ec:	89 34 24             	mov    %esi,(%esp)
  ef:	e8 44 00 00 00       	call   138 <close>
  for(i = 1; i < argc; i++){
  f4:	83 c3 01             	add    $0x1,%ebx
  f7:	eb 05                	jmp    fe <main+0x7a>
  f9:	bb 01 00 00 00       	mov    $0x1,%ebx
  fe:	3b 5d 08             	cmp    0x8(%ebp),%ebx
 101:	7c a4                	jl     a7 <main+0x23>
  }
  exit();
 103:	e8 08 00 00 00       	call   110 <exit>

00000108 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 108:	b8 01 00 00 00       	mov    $0x1,%eax
 10d:	cd 40                	int    $0x40
 10f:	c3                   	ret    

00000110 <exit>:
SYSCALL(exit)
 110:	b8 02 00 00 00       	mov    $0x2,%eax
 115:	cd 40                	int    $0x40
 117:	c3                   	ret    

00000118 <wait>:
SYSCALL(wait)
 118:	b8 03 00 00 00       	mov    $0x3,%eax
 11d:	cd 40                	int    $0x40
 11f:	c3                   	ret    

00000120 <pipe>:
SYSCALL(pipe)
 120:	b8 04 00 00 00       	mov    $0x4,%eax
 125:	cd 40                	int    $0x40
 127:	c3                   	ret    

00000128 <read>:
SYSCALL(read)
 128:	b8 05 00 00 00       	mov    $0x5,%eax
 12d:	cd 40                	int    $0x40
 12f:	c3                   	ret    

00000130 <write>:
SYSCALL(write)
 130:	b8 10 00 00 00       	mov    $0x10,%eax
 135:	cd 40                	int    $0x40
 137:	c3                   	ret    

00000138 <close>:
SYSCALL(close)
 138:	b8 15 00 00 00       	mov    $0x15,%eax
 13d:	cd 40                	int    $0x40
 13f:	c3                   	ret    

00000140 <kill>:
SYSCALL(kill)
 140:	b8 06 00 00 00       	mov    $0x6,%eax
 145:	cd 40                	int    $0x40
 147:	c3                   	ret    

00000148 <exec>:
SYSCALL(exec)
 148:	b8 07 00 00 00       	mov    $0x7,%eax
 14d:	cd 40                	int    $0x40
 14f:	c3                   	ret    

00000150 <open>:
SYSCALL(open)
 150:	b8 0f 00 00 00       	mov    $0xf,%eax
 155:	cd 40                	int    $0x40
 157:	c3                   	ret    

00000158 <mknod>:
SYSCALL(mknod)
 158:	b8 11 00 00 00       	mov    $0x11,%eax
 15d:	cd 40                	int    $0x40
 15f:	c3                   	ret    

00000160 <unlink>:
SYSCALL(unlink)
 160:	b8 12 00 00 00       	mov    $0x12,%eax
 165:	cd 40                	int    $0x40
 167:	c3                   	ret    

00000168 <fstat>:
SYSCALL(fstat)
 168:	b8 08 00 00 00       	mov    $0x8,%eax
 16d:	cd 40                	int    $0x40
 16f:	c3                   	ret    

00000170 <link>:
SYSCALL(link)
 170:	b8 13 00 00 00       	mov    $0x13,%eax
 175:	cd 40                	int    $0x40
 177:	c3                   	ret    

00000178 <mkdir>:
SYSCALL(mkdir)
 178:	b8 14 00 00 00       	mov    $0x14,%eax
 17d:	cd 40                	int    $0x40
 17f:	c3                   	ret    

00000180 <chdir>:
SYSCALL(chdir)
 180:	b8 09 00 00 00       	mov    $0x9,%eax
 185:	cd 40                	int    $0x40
 187:	c3                   	ret    

00000188 <dup>:
SYSCALL(dup)
 188:	b8 0a 00 00 00       	mov    $0xa,%eax
 18d:	cd 40                	int    $0x40
 18f:	c3                   	ret    

00000190 <getpid>:
SYSCALL(getpid)
 190:	b8 0b 00 00 00       	mov    $0xb,%eax
 195:	cd 40                	int    $0x40
 197:	c3                   	ret    

00000198 <sbrk>:
SYSCALL(sbrk)
 198:	b8 0c 00 00 00       	mov    $0xc,%eax
 19d:	cd 40                	int    $0x40
 19f:	c3                   	ret    

000001a0 <sleep>:
SYSCALL(sleep)
 1a0:	b8 0d 00 00 00       	mov    $0xd,%eax
 1a5:	cd 40                	int    $0x40
 1a7:	c3                   	ret    

000001a8 <uptime>:
SYSCALL(uptime)
 1a8:	b8 0e 00 00 00       	mov    $0xe,%eax
 1ad:	cd 40                	int    $0x40
 1af:	c3                   	ret    

000001b0 <yield>:
SYSCALL(yield)
 1b0:	b8 16 00 00 00       	mov    $0x16,%eax
 1b5:	cd 40                	int    $0x40
 1b7:	c3                   	ret    

000001b8 <shutdown>:
SYSCALL(shutdown)
 1b8:	b8 17 00 00 00       	mov    $0x17,%eax
 1bd:	cd 40                	int    $0x40
 1bf:	c3                   	ret    

000001c0 <writecount>:
SYSCALL(writecount)
 1c0:	b8 18 00 00 00       	mov    $0x18,%eax
 1c5:	cd 40                	int    $0x40
 1c7:	c3                   	ret    

000001c8 <setwritecount>:
SYSCALL(setwritecount)
 1c8:	b8 19 00 00 00       	mov    $0x19,%eax
 1cd:	cd 40                	int    $0x40
 1cf:	c3                   	ret    

000001d0 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	83 ec 18             	sub    $0x18,%esp
 1d6:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 1d9:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1e0:	00 
 1e1:	8d 55 f4             	lea    -0xc(%ebp),%edx
 1e4:	89 54 24 04          	mov    %edx,0x4(%esp)
 1e8:	89 04 24             	mov    %eax,(%esp)
 1eb:	e8 40 ff ff ff       	call   130 <write>
}
 1f0:	c9                   	leave  
 1f1:	c3                   	ret    

000001f2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 1f2:	55                   	push   %ebp
 1f3:	89 e5                	mov    %esp,%ebp
 1f5:	57                   	push   %edi
 1f6:	56                   	push   %esi
 1f7:	53                   	push   %ebx
 1f8:	83 ec 2c             	sub    $0x2c,%esp
 1fb:	89 c7                	mov    %eax,%edi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 1fd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 201:	0f 95 c3             	setne  %bl
 204:	89 d0                	mov    %edx,%eax
 206:	c1 e8 1f             	shr    $0x1f,%eax
 209:	84 c3                	test   %al,%bl
 20b:	74 0b                	je     218 <printint+0x26>
    neg = 1;
    x = -xx;
 20d:	f7 da                	neg    %edx
    neg = 1;
 20f:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
 216:	eb 07                	jmp    21f <printint+0x2d>
  neg = 0;
 218:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 21f:	be 00 00 00 00       	mov    $0x0,%esi
  do{
    buf[i++] = digits[x % base];
 224:	8d 5e 01             	lea    0x1(%esi),%ebx
 227:	89 d0                	mov    %edx,%eax
 229:	ba 00 00 00 00       	mov    $0x0,%edx
 22e:	f7 f1                	div    %ecx
 230:	0f b6 92 04 04 00 00 	movzbl 0x404(%edx),%edx
 237:	88 54 35 d8          	mov    %dl,-0x28(%ebp,%esi,1)
  }while((x /= base) != 0);
 23b:	89 c2                	mov    %eax,%edx
    buf[i++] = digits[x % base];
 23d:	89 de                	mov    %ebx,%esi
  }while((x /= base) != 0);
 23f:	85 c0                	test   %eax,%eax
 241:	75 e1                	jne    224 <printint+0x32>
  if(neg)
 243:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 247:	74 16                	je     25f <printint+0x6d>
    buf[i++] = '-';
 249:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 24e:	8d 5b 01             	lea    0x1(%ebx),%ebx
 251:	eb 0c                	jmp    25f <printint+0x6d>

  while(--i >= 0)
    putc(fd, buf[i]);
 253:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 258:	89 f8                	mov    %edi,%eax
 25a:	e8 71 ff ff ff       	call   1d0 <putc>
  while(--i >= 0)
 25f:	83 eb 01             	sub    $0x1,%ebx
 262:	79 ef                	jns    253 <printint+0x61>
}
 264:	83 c4 2c             	add    $0x2c,%esp
 267:	5b                   	pop    %ebx
 268:	5e                   	pop    %esi
 269:	5f                   	pop    %edi
 26a:	5d                   	pop    %ebp
 26b:	c3                   	ret    

0000026c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 26c:	55                   	push   %ebp
 26d:	89 e5                	mov    %esp,%ebp
 26f:	57                   	push   %edi
 270:	56                   	push   %esi
 271:	53                   	push   %ebx
 272:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 275:	8d 45 10             	lea    0x10(%ebp),%eax
 278:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 27b:	bf 00 00 00 00       	mov    $0x0,%edi
  for(i = 0; fmt[i]; i++){
 280:	be 00 00 00 00       	mov    $0x0,%esi
 285:	e9 23 01 00 00       	jmp    3ad <printf+0x141>
    c = fmt[i] & 0xff;
 28a:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 28d:	85 ff                	test   %edi,%edi
 28f:	75 19                	jne    2aa <printf+0x3e>
      if(c == '%'){
 291:	83 f8 25             	cmp    $0x25,%eax
 294:	0f 84 0b 01 00 00    	je     3a5 <printf+0x139>
        state = '%';
      } else {
        putc(fd, c);
 29a:	0f be d3             	movsbl %bl,%edx
 29d:	8b 45 08             	mov    0x8(%ebp),%eax
 2a0:	e8 2b ff ff ff       	call   1d0 <putc>
 2a5:	e9 00 01 00 00       	jmp    3aa <printf+0x13e>
      }
    } else if(state == '%'){
 2aa:	83 ff 25             	cmp    $0x25,%edi
 2ad:	0f 85 f7 00 00 00    	jne    3aa <printf+0x13e>
      if(c == 'd'){
 2b3:	83 f8 64             	cmp    $0x64,%eax
 2b6:	75 26                	jne    2de <printf+0x72>
        printint(fd, *ap, 10, 1);
 2b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 2bb:	8b 10                	mov    (%eax),%edx
 2bd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2c4:	b9 0a 00 00 00       	mov    $0xa,%ecx
 2c9:	8b 45 08             	mov    0x8(%ebp),%eax
 2cc:	e8 21 ff ff ff       	call   1f2 <printint>
        ap++;
 2d1:	83 45 e4 04          	addl   $0x4,-0x1c(%ebp)
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 2d5:	66 bf 00 00          	mov    $0x0,%di
 2d9:	e9 cc 00 00 00       	jmp    3aa <printf+0x13e>
      } else if(c == 'x' || c == 'p'){
 2de:	83 f8 78             	cmp    $0x78,%eax
 2e1:	0f 94 c1             	sete   %cl
 2e4:	83 f8 70             	cmp    $0x70,%eax
 2e7:	0f 94 c2             	sete   %dl
 2ea:	08 d1                	or     %dl,%cl
 2ec:	74 27                	je     315 <printf+0xa9>
        printint(fd, *ap, 16, 0);
 2ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 2f1:	8b 10                	mov    (%eax),%edx
 2f3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 2fa:	b9 10 00 00 00       	mov    $0x10,%ecx
 2ff:	8b 45 08             	mov    0x8(%ebp),%eax
 302:	e8 eb fe ff ff       	call   1f2 <printint>
        ap++;
 307:	83 45 e4 04          	addl   $0x4,-0x1c(%ebp)
      state = 0;
 30b:	bf 00 00 00 00       	mov    $0x0,%edi
 310:	e9 95 00 00 00       	jmp    3aa <printf+0x13e>
      } else if(c == 's'){
 315:	83 f8 73             	cmp    $0x73,%eax
 318:	75 37                	jne    351 <printf+0xe5>
        s = (char*)*ap;
 31a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 31d:	8b 18                	mov    (%eax),%ebx
        ap++;
 31f:	83 45 e4 04          	addl   $0x4,-0x1c(%ebp)
        if(s == 0)
 323:	85 db                	test   %ebx,%ebx
 325:	75 19                	jne    340 <printf+0xd4>
          s = "(null)";
 327:	bb fd 03 00 00       	mov    $0x3fd,%ebx
 32c:	8b 7d 08             	mov    0x8(%ebp),%edi
 32f:	eb 12                	jmp    343 <printf+0xd7>
          putc(fd, *s);
 331:	0f be d2             	movsbl %dl,%edx
 334:	89 f8                	mov    %edi,%eax
 336:	e8 95 fe ff ff       	call   1d0 <putc>
          s++;
 33b:	83 c3 01             	add    $0x1,%ebx
 33e:	eb 03                	jmp    343 <printf+0xd7>
 340:	8b 7d 08             	mov    0x8(%ebp),%edi
        while(*s != 0){
 343:	0f b6 13             	movzbl (%ebx),%edx
 346:	84 d2                	test   %dl,%dl
 348:	75 e7                	jne    331 <printf+0xc5>
      state = 0;
 34a:	bf 00 00 00 00       	mov    $0x0,%edi
 34f:	eb 59                	jmp    3aa <printf+0x13e>
      } else if(c == 'c'){
 351:	83 f8 63             	cmp    $0x63,%eax
 354:	75 19                	jne    36f <printf+0x103>
        putc(fd, *ap);
 356:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 359:	0f be 10             	movsbl (%eax),%edx
 35c:	8b 45 08             	mov    0x8(%ebp),%eax
 35f:	e8 6c fe ff ff       	call   1d0 <putc>
        ap++;
 364:	83 45 e4 04          	addl   $0x4,-0x1c(%ebp)
      state = 0;
 368:	bf 00 00 00 00       	mov    $0x0,%edi
 36d:	eb 3b                	jmp    3aa <printf+0x13e>
      } else if(c == '%'){
 36f:	83 f8 25             	cmp    $0x25,%eax
 372:	75 12                	jne    386 <printf+0x11a>
        putc(fd, c);
 374:	0f be d3             	movsbl %bl,%edx
 377:	8b 45 08             	mov    0x8(%ebp),%eax
 37a:	e8 51 fe ff ff       	call   1d0 <putc>
      state = 0;
 37f:	bf 00 00 00 00       	mov    $0x0,%edi
 384:	eb 24                	jmp    3aa <printf+0x13e>
        putc(fd, '%');
 386:	ba 25 00 00 00       	mov    $0x25,%edx
 38b:	8b 45 08             	mov    0x8(%ebp),%eax
 38e:	e8 3d fe ff ff       	call   1d0 <putc>
        putc(fd, c);
 393:	0f be d3             	movsbl %bl,%edx
 396:	8b 45 08             	mov    0x8(%ebp),%eax
 399:	e8 32 fe ff ff       	call   1d0 <putc>
      state = 0;
 39e:	bf 00 00 00 00       	mov    $0x0,%edi
 3a3:	eb 05                	jmp    3aa <printf+0x13e>
        state = '%';
 3a5:	bf 25 00 00 00       	mov    $0x25,%edi
  for(i = 0; fmt[i]; i++){
 3aa:	83 c6 01             	add    $0x1,%esi
 3ad:	89 f0                	mov    %esi,%eax
 3af:	03 45 0c             	add    0xc(%ebp),%eax
 3b2:	0f b6 18             	movzbl (%eax),%ebx
 3b5:	84 db                	test   %bl,%bl
 3b7:	0f 85 cd fe ff ff    	jne    28a <printf+0x1e>
    }
  }
}
 3bd:	83 c4 1c             	add    $0x1c,%esp
 3c0:	5b                   	pop    %ebx
 3c1:	5e                   	pop    %esi
 3c2:	5f                   	pop    %edi
 3c3:	5d                   	pop    %ebp
 3c4:	c3                   	ret    
