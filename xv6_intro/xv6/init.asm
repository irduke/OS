
_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	83 ec 10             	sub    $0x10,%esp
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   a:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  11:	00 
  12:	c7 04 24 c5 03 00 00 	movl   $0x3c5,(%esp)
  19:	e8 27 01 00 00       	call   145 <open>
  1e:	85 c0                	test   %eax,%eax
  20:	79 30                	jns    52 <main+0x52>
    mknod("console", 1, 1);
  22:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  29:	00 
  2a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  31:	00 
  32:	c7 04 24 c5 03 00 00 	movl   $0x3c5,(%esp)
  39:	e8 0f 01 00 00       	call   14d <mknod>
    open("console", O_RDWR);
  3e:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  45:	00 
  46:	c7 04 24 c5 03 00 00 	movl   $0x3c5,(%esp)
  4d:	e8 f3 00 00 00       	call   145 <open>
  }
  dup(0);  // stdout
  52:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  59:	e8 1f 01 00 00       	call   17d <dup>
  dup(0);  // stderr
  5e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  65:	e8 13 01 00 00       	call   17d <dup>

  for(;;){
    printf(1, "init: starting sh\n");
  6a:	c7 44 24 04 cd 03 00 	movl   $0x3cd,0x4(%esp)
  71:	00 
  72:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  79:	e8 ee 01 00 00       	call   26c <printf>
    pid = fork();
  7e:	e8 7a 00 00 00       	call   fd <fork>
  83:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
  85:	85 c0                	test   %eax,%eax
  87:	79 19                	jns    a2 <main+0xa2>
      printf(1, "init: fork failed\n");
  89:	c7 44 24 04 e0 03 00 	movl   $0x3e0,0x4(%esp)
  90:	00 
  91:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  98:	e8 cf 01 00 00       	call   26c <printf>
      exit();
  9d:	e8 63 00 00 00       	call   105 <exit>
    }
    if(pid == 0){
  a2:	85 c0                	test   %eax,%eax
  a4:	75 41                	jne    e7 <main+0xe7>
      exec("sh", argv);
  a6:	c7 44 24 04 30 04 00 	movl   $0x430,0x4(%esp)
  ad:	00 
  ae:	c7 04 24 f3 03 00 00 	movl   $0x3f3,(%esp)
  b5:	e8 83 00 00 00       	call   13d <exec>
      printf(1, "init: exec sh failed\n");
  ba:	c7 44 24 04 f6 03 00 	movl   $0x3f6,0x4(%esp)
  c1:	00 
  c2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  c9:	e8 9e 01 00 00       	call   26c <printf>
      exit();
  ce:	e8 32 00 00 00       	call   105 <exit>
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
  d3:	c7 44 24 04 0c 04 00 	movl   $0x40c,0x4(%esp)
  da:	00 
  db:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  e2:	e8 85 01 00 00       	call   26c <printf>
    while((wpid=wait()) >= 0 && wpid != pid)
  e7:	e8 21 00 00 00       	call   10d <wait>
  ec:	85 c0                	test   %eax,%eax
  ee:	0f 88 76 ff ff ff    	js     6a <main+0x6a>
  f4:	39 d8                	cmp    %ebx,%eax
  f6:	75 db                	jne    d3 <main+0xd3>
  f8:	e9 6d ff ff ff       	jmp    6a <main+0x6a>

000000fd <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
  fd:	b8 01 00 00 00       	mov    $0x1,%eax
 102:	cd 40                	int    $0x40
 104:	c3                   	ret    

00000105 <exit>:
SYSCALL(exit)
 105:	b8 02 00 00 00       	mov    $0x2,%eax
 10a:	cd 40                	int    $0x40
 10c:	c3                   	ret    

0000010d <wait>:
SYSCALL(wait)
 10d:	b8 03 00 00 00       	mov    $0x3,%eax
 112:	cd 40                	int    $0x40
 114:	c3                   	ret    

00000115 <pipe>:
SYSCALL(pipe)
 115:	b8 04 00 00 00       	mov    $0x4,%eax
 11a:	cd 40                	int    $0x40
 11c:	c3                   	ret    

0000011d <read>:
SYSCALL(read)
 11d:	b8 05 00 00 00       	mov    $0x5,%eax
 122:	cd 40                	int    $0x40
 124:	c3                   	ret    

00000125 <write>:
SYSCALL(write)
 125:	b8 10 00 00 00       	mov    $0x10,%eax
 12a:	cd 40                	int    $0x40
 12c:	c3                   	ret    

0000012d <close>:
SYSCALL(close)
 12d:	b8 15 00 00 00       	mov    $0x15,%eax
 132:	cd 40                	int    $0x40
 134:	c3                   	ret    

00000135 <kill>:
SYSCALL(kill)
 135:	b8 06 00 00 00       	mov    $0x6,%eax
 13a:	cd 40                	int    $0x40
 13c:	c3                   	ret    

0000013d <exec>:
SYSCALL(exec)
 13d:	b8 07 00 00 00       	mov    $0x7,%eax
 142:	cd 40                	int    $0x40
 144:	c3                   	ret    

00000145 <open>:
SYSCALL(open)
 145:	b8 0f 00 00 00       	mov    $0xf,%eax
 14a:	cd 40                	int    $0x40
 14c:	c3                   	ret    

0000014d <mknod>:
SYSCALL(mknod)
 14d:	b8 11 00 00 00       	mov    $0x11,%eax
 152:	cd 40                	int    $0x40
 154:	c3                   	ret    

00000155 <unlink>:
SYSCALL(unlink)
 155:	b8 12 00 00 00       	mov    $0x12,%eax
 15a:	cd 40                	int    $0x40
 15c:	c3                   	ret    

0000015d <fstat>:
SYSCALL(fstat)
 15d:	b8 08 00 00 00       	mov    $0x8,%eax
 162:	cd 40                	int    $0x40
 164:	c3                   	ret    

00000165 <link>:
SYSCALL(link)
 165:	b8 13 00 00 00       	mov    $0x13,%eax
 16a:	cd 40                	int    $0x40
 16c:	c3                   	ret    

0000016d <mkdir>:
SYSCALL(mkdir)
 16d:	b8 14 00 00 00       	mov    $0x14,%eax
 172:	cd 40                	int    $0x40
 174:	c3                   	ret    

00000175 <chdir>:
SYSCALL(chdir)
 175:	b8 09 00 00 00       	mov    $0x9,%eax
 17a:	cd 40                	int    $0x40
 17c:	c3                   	ret    

0000017d <dup>:
SYSCALL(dup)
 17d:	b8 0a 00 00 00       	mov    $0xa,%eax
 182:	cd 40                	int    $0x40
 184:	c3                   	ret    

00000185 <getpid>:
SYSCALL(getpid)
 185:	b8 0b 00 00 00       	mov    $0xb,%eax
 18a:	cd 40                	int    $0x40
 18c:	c3                   	ret    

0000018d <sbrk>:
SYSCALL(sbrk)
 18d:	b8 0c 00 00 00       	mov    $0xc,%eax
 192:	cd 40                	int    $0x40
 194:	c3                   	ret    

00000195 <sleep>:
SYSCALL(sleep)
 195:	b8 0d 00 00 00       	mov    $0xd,%eax
 19a:	cd 40                	int    $0x40
 19c:	c3                   	ret    

0000019d <uptime>:
SYSCALL(uptime)
 19d:	b8 0e 00 00 00       	mov    $0xe,%eax
 1a2:	cd 40                	int    $0x40
 1a4:	c3                   	ret    

000001a5 <yield>:
SYSCALL(yield)
 1a5:	b8 16 00 00 00       	mov    $0x16,%eax
 1aa:	cd 40                	int    $0x40
 1ac:	c3                   	ret    

000001ad <shutdown>:
SYSCALL(shutdown)
 1ad:	b8 17 00 00 00       	mov    $0x17,%eax
 1b2:	cd 40                	int    $0x40
 1b4:	c3                   	ret    

000001b5 <writecount>:
SYSCALL(writecount)
 1b5:	b8 18 00 00 00       	mov    $0x18,%eax
 1ba:	cd 40                	int    $0x40
 1bc:	c3                   	ret    

000001bd <setwritecount>:
SYSCALL(setwritecount)
 1bd:	b8 19 00 00 00       	mov    $0x19,%eax
 1c2:	cd 40                	int    $0x40
 1c4:	c3                   	ret    
 1c5:	66 90                	xchg   %ax,%ax
 1c7:	66 90                	xchg   %ax,%ax
 1c9:	66 90                	xchg   %ax,%ax
 1cb:	66 90                	xchg   %ax,%ax
 1cd:	66 90                	xchg   %ax,%ax
 1cf:	90                   	nop

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
 1eb:	e8 35 ff ff ff       	call   125 <write>
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
 230:	0f b6 92 1c 04 00 00 	movzbl 0x41c(%edx),%edx
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
 327:	bb 15 04 00 00       	mov    $0x415,%ebx
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
