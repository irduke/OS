
_rm:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	57                   	push   %edi
   4:	56                   	push   %esi
   5:	53                   	push   %ebx
   6:	83 e4 f0             	and    $0xfffffff0,%esp
   9:	83 ec 10             	sub    $0x10,%esp
   c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  if(argc < 2){
   f:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  13:	7f 4b                	jg     60 <main+0x60>
    printf(2, "Usage: rm files...\n");
  15:	c7 44 24 04 35 03 00 	movl   $0x335,0x4(%esp)
  1c:	00 
  1d:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  24:	e8 b3 01 00 00       	call   1dc <printf>
    exit();
  29:	e8 49 00 00 00       	call   77 <exit>
  }

  for(i = 1; i < argc; i++){
    if(unlink(argv[i]) < 0){
  2e:	8d 34 9f             	lea    (%edi,%ebx,4),%esi
  31:	8b 06                	mov    (%esi),%eax
  33:	89 04 24             	mov    %eax,(%esp)
  36:	e8 8c 00 00 00       	call   c7 <unlink>
  3b:	85 c0                	test   %eax,%eax
  3d:	79 1c                	jns    5b <main+0x5b>
      printf(2, "rm: %s failed to delete\n", argv[i]);
  3f:	8b 06                	mov    (%esi),%eax
  41:	89 44 24 08          	mov    %eax,0x8(%esp)
  45:	c7 44 24 04 49 03 00 	movl   $0x349,0x4(%esp)
  4c:	00 
  4d:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  54:	e8 83 01 00 00       	call   1dc <printf>
      break;
  59:	eb 0f                	jmp    6a <main+0x6a>
  for(i = 1; i < argc; i++){
  5b:	83 c3 01             	add    $0x1,%ebx
  5e:	eb 05                	jmp    65 <main+0x65>
  60:	bb 01 00 00 00       	mov    $0x1,%ebx
  65:	3b 5d 08             	cmp    0x8(%ebp),%ebx
  68:	7c c4                	jl     2e <main+0x2e>
    }
  }

  exit();
  6a:	e8 08 00 00 00       	call   77 <exit>

0000006f <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
  6f:	b8 01 00 00 00       	mov    $0x1,%eax
  74:	cd 40                	int    $0x40
  76:	c3                   	ret    

00000077 <exit>:
SYSCALL(exit)
  77:	b8 02 00 00 00       	mov    $0x2,%eax
  7c:	cd 40                	int    $0x40
  7e:	c3                   	ret    

0000007f <wait>:
SYSCALL(wait)
  7f:	b8 03 00 00 00       	mov    $0x3,%eax
  84:	cd 40                	int    $0x40
  86:	c3                   	ret    

00000087 <pipe>:
SYSCALL(pipe)
  87:	b8 04 00 00 00       	mov    $0x4,%eax
  8c:	cd 40                	int    $0x40
  8e:	c3                   	ret    

0000008f <read>:
SYSCALL(read)
  8f:	b8 05 00 00 00       	mov    $0x5,%eax
  94:	cd 40                	int    $0x40
  96:	c3                   	ret    

00000097 <write>:
SYSCALL(write)
  97:	b8 10 00 00 00       	mov    $0x10,%eax
  9c:	cd 40                	int    $0x40
  9e:	c3                   	ret    

0000009f <close>:
SYSCALL(close)
  9f:	b8 15 00 00 00       	mov    $0x15,%eax
  a4:	cd 40                	int    $0x40
  a6:	c3                   	ret    

000000a7 <kill>:
SYSCALL(kill)
  a7:	b8 06 00 00 00       	mov    $0x6,%eax
  ac:	cd 40                	int    $0x40
  ae:	c3                   	ret    

000000af <exec>:
SYSCALL(exec)
  af:	b8 07 00 00 00       	mov    $0x7,%eax
  b4:	cd 40                	int    $0x40
  b6:	c3                   	ret    

000000b7 <open>:
SYSCALL(open)
  b7:	b8 0f 00 00 00       	mov    $0xf,%eax
  bc:	cd 40                	int    $0x40
  be:	c3                   	ret    

000000bf <mknod>:
SYSCALL(mknod)
  bf:	b8 11 00 00 00       	mov    $0x11,%eax
  c4:	cd 40                	int    $0x40
  c6:	c3                   	ret    

000000c7 <unlink>:
SYSCALL(unlink)
  c7:	b8 12 00 00 00       	mov    $0x12,%eax
  cc:	cd 40                	int    $0x40
  ce:	c3                   	ret    

000000cf <fstat>:
SYSCALL(fstat)
  cf:	b8 08 00 00 00       	mov    $0x8,%eax
  d4:	cd 40                	int    $0x40
  d6:	c3                   	ret    

000000d7 <link>:
SYSCALL(link)
  d7:	b8 13 00 00 00       	mov    $0x13,%eax
  dc:	cd 40                	int    $0x40
  de:	c3                   	ret    

000000df <mkdir>:
SYSCALL(mkdir)
  df:	b8 14 00 00 00       	mov    $0x14,%eax
  e4:	cd 40                	int    $0x40
  e6:	c3                   	ret    

000000e7 <chdir>:
SYSCALL(chdir)
  e7:	b8 09 00 00 00       	mov    $0x9,%eax
  ec:	cd 40                	int    $0x40
  ee:	c3                   	ret    

000000ef <dup>:
SYSCALL(dup)
  ef:	b8 0a 00 00 00       	mov    $0xa,%eax
  f4:	cd 40                	int    $0x40
  f6:	c3                   	ret    

000000f7 <getpid>:
SYSCALL(getpid)
  f7:	b8 0b 00 00 00       	mov    $0xb,%eax
  fc:	cd 40                	int    $0x40
  fe:	c3                   	ret    

000000ff <sbrk>:
SYSCALL(sbrk)
  ff:	b8 0c 00 00 00       	mov    $0xc,%eax
 104:	cd 40                	int    $0x40
 106:	c3                   	ret    

00000107 <sleep>:
SYSCALL(sleep)
 107:	b8 0d 00 00 00       	mov    $0xd,%eax
 10c:	cd 40                	int    $0x40
 10e:	c3                   	ret    

0000010f <uptime>:
SYSCALL(uptime)
 10f:	b8 0e 00 00 00       	mov    $0xe,%eax
 114:	cd 40                	int    $0x40
 116:	c3                   	ret    

00000117 <yield>:
SYSCALL(yield)
 117:	b8 16 00 00 00       	mov    $0x16,%eax
 11c:	cd 40                	int    $0x40
 11e:	c3                   	ret    

0000011f <shutdown>:
SYSCALL(shutdown)
 11f:	b8 17 00 00 00       	mov    $0x17,%eax
 124:	cd 40                	int    $0x40
 126:	c3                   	ret    

00000127 <writecount>:
SYSCALL(writecount)
 127:	b8 18 00 00 00       	mov    $0x18,%eax
 12c:	cd 40                	int    $0x40
 12e:	c3                   	ret    

0000012f <setwritecount>:
SYSCALL(setwritecount)
 12f:	b8 19 00 00 00       	mov    $0x19,%eax
 134:	cd 40                	int    $0x40
 136:	c3                   	ret    
 137:	66 90                	xchg   %ax,%ax
 139:	66 90                	xchg   %ax,%ax
 13b:	66 90                	xchg   %ax,%ax
 13d:	66 90                	xchg   %ax,%ax
 13f:	90                   	nop

00000140 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
 143:	83 ec 18             	sub    $0x18,%esp
 146:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 149:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 150:	00 
 151:	8d 55 f4             	lea    -0xc(%ebp),%edx
 154:	89 54 24 04          	mov    %edx,0x4(%esp)
 158:	89 04 24             	mov    %eax,(%esp)
 15b:	e8 37 ff ff ff       	call   97 <write>
}
 160:	c9                   	leave  
 161:	c3                   	ret    

00000162 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 162:	55                   	push   %ebp
 163:	89 e5                	mov    %esp,%ebp
 165:	57                   	push   %edi
 166:	56                   	push   %esi
 167:	53                   	push   %ebx
 168:	83 ec 2c             	sub    $0x2c,%esp
 16b:	89 c7                	mov    %eax,%edi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 16d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 171:	0f 95 c3             	setne  %bl
 174:	89 d0                	mov    %edx,%eax
 176:	c1 e8 1f             	shr    $0x1f,%eax
 179:	84 c3                	test   %al,%bl
 17b:	74 0b                	je     188 <printint+0x26>
    neg = 1;
    x = -xx;
 17d:	f7 da                	neg    %edx
    neg = 1;
 17f:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
 186:	eb 07                	jmp    18f <printint+0x2d>
  neg = 0;
 188:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 18f:	be 00 00 00 00       	mov    $0x0,%esi
  do{
    buf[i++] = digits[x % base];
 194:	8d 5e 01             	lea    0x1(%esi),%ebx
 197:	89 d0                	mov    %edx,%eax
 199:	ba 00 00 00 00       	mov    $0x0,%edx
 19e:	f7 f1                	div    %ecx
 1a0:	0f b6 92 69 03 00 00 	movzbl 0x369(%edx),%edx
 1a7:	88 54 35 d8          	mov    %dl,-0x28(%ebp,%esi,1)
  }while((x /= base) != 0);
 1ab:	89 c2                	mov    %eax,%edx
    buf[i++] = digits[x % base];
 1ad:	89 de                	mov    %ebx,%esi
  }while((x /= base) != 0);
 1af:	85 c0                	test   %eax,%eax
 1b1:	75 e1                	jne    194 <printint+0x32>
  if(neg)
 1b3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 1b7:	74 16                	je     1cf <printint+0x6d>
    buf[i++] = '-';
 1b9:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 1be:	8d 5b 01             	lea    0x1(%ebx),%ebx
 1c1:	eb 0c                	jmp    1cf <printint+0x6d>

  while(--i >= 0)
    putc(fd, buf[i]);
 1c3:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 1c8:	89 f8                	mov    %edi,%eax
 1ca:	e8 71 ff ff ff       	call   140 <putc>
  while(--i >= 0)
 1cf:	83 eb 01             	sub    $0x1,%ebx
 1d2:	79 ef                	jns    1c3 <printint+0x61>
}
 1d4:	83 c4 2c             	add    $0x2c,%esp
 1d7:	5b                   	pop    %ebx
 1d8:	5e                   	pop    %esi
 1d9:	5f                   	pop    %edi
 1da:	5d                   	pop    %ebp
 1db:	c3                   	ret    

000001dc <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 1dc:	55                   	push   %ebp
 1dd:	89 e5                	mov    %esp,%ebp
 1df:	57                   	push   %edi
 1e0:	56                   	push   %esi
 1e1:	53                   	push   %ebx
 1e2:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 1e5:	8d 45 10             	lea    0x10(%ebp),%eax
 1e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 1eb:	bf 00 00 00 00       	mov    $0x0,%edi
  for(i = 0; fmt[i]; i++){
 1f0:	be 00 00 00 00       	mov    $0x0,%esi
 1f5:	e9 23 01 00 00       	jmp    31d <printf+0x141>
    c = fmt[i] & 0xff;
 1fa:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 1fd:	85 ff                	test   %edi,%edi
 1ff:	75 19                	jne    21a <printf+0x3e>
      if(c == '%'){
 201:	83 f8 25             	cmp    $0x25,%eax
 204:	0f 84 0b 01 00 00    	je     315 <printf+0x139>
        state = '%';
      } else {
        putc(fd, c);
 20a:	0f be d3             	movsbl %bl,%edx
 20d:	8b 45 08             	mov    0x8(%ebp),%eax
 210:	e8 2b ff ff ff       	call   140 <putc>
 215:	e9 00 01 00 00       	jmp    31a <printf+0x13e>
      }
    } else if(state == '%'){
 21a:	83 ff 25             	cmp    $0x25,%edi
 21d:	0f 85 f7 00 00 00    	jne    31a <printf+0x13e>
      if(c == 'd'){
 223:	83 f8 64             	cmp    $0x64,%eax
 226:	75 26                	jne    24e <printf+0x72>
        printint(fd, *ap, 10, 1);
 228:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 22b:	8b 10                	mov    (%eax),%edx
 22d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 234:	b9 0a 00 00 00       	mov    $0xa,%ecx
 239:	8b 45 08             	mov    0x8(%ebp),%eax
 23c:	e8 21 ff ff ff       	call   162 <printint>
        ap++;
 241:	83 45 e4 04          	addl   $0x4,-0x1c(%ebp)
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 245:	66 bf 00 00          	mov    $0x0,%di
 249:	e9 cc 00 00 00       	jmp    31a <printf+0x13e>
      } else if(c == 'x' || c == 'p'){
 24e:	83 f8 78             	cmp    $0x78,%eax
 251:	0f 94 c1             	sete   %cl
 254:	83 f8 70             	cmp    $0x70,%eax
 257:	0f 94 c2             	sete   %dl
 25a:	08 d1                	or     %dl,%cl
 25c:	74 27                	je     285 <printf+0xa9>
        printint(fd, *ap, 16, 0);
 25e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 261:	8b 10                	mov    (%eax),%edx
 263:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 26a:	b9 10 00 00 00       	mov    $0x10,%ecx
 26f:	8b 45 08             	mov    0x8(%ebp),%eax
 272:	e8 eb fe ff ff       	call   162 <printint>
        ap++;
 277:	83 45 e4 04          	addl   $0x4,-0x1c(%ebp)
      state = 0;
 27b:	bf 00 00 00 00       	mov    $0x0,%edi
 280:	e9 95 00 00 00       	jmp    31a <printf+0x13e>
      } else if(c == 's'){
 285:	83 f8 73             	cmp    $0x73,%eax
 288:	75 37                	jne    2c1 <printf+0xe5>
        s = (char*)*ap;
 28a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 28d:	8b 18                	mov    (%eax),%ebx
        ap++;
 28f:	83 45 e4 04          	addl   $0x4,-0x1c(%ebp)
        if(s == 0)
 293:	85 db                	test   %ebx,%ebx
 295:	75 19                	jne    2b0 <printf+0xd4>
          s = "(null)";
 297:	bb 62 03 00 00       	mov    $0x362,%ebx
 29c:	8b 7d 08             	mov    0x8(%ebp),%edi
 29f:	eb 12                	jmp    2b3 <printf+0xd7>
          putc(fd, *s);
 2a1:	0f be d2             	movsbl %dl,%edx
 2a4:	89 f8                	mov    %edi,%eax
 2a6:	e8 95 fe ff ff       	call   140 <putc>
          s++;
 2ab:	83 c3 01             	add    $0x1,%ebx
 2ae:	eb 03                	jmp    2b3 <printf+0xd7>
 2b0:	8b 7d 08             	mov    0x8(%ebp),%edi
        while(*s != 0){
 2b3:	0f b6 13             	movzbl (%ebx),%edx
 2b6:	84 d2                	test   %dl,%dl
 2b8:	75 e7                	jne    2a1 <printf+0xc5>
      state = 0;
 2ba:	bf 00 00 00 00       	mov    $0x0,%edi
 2bf:	eb 59                	jmp    31a <printf+0x13e>
      } else if(c == 'c'){
 2c1:	83 f8 63             	cmp    $0x63,%eax
 2c4:	75 19                	jne    2df <printf+0x103>
        putc(fd, *ap);
 2c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 2c9:	0f be 10             	movsbl (%eax),%edx
 2cc:	8b 45 08             	mov    0x8(%ebp),%eax
 2cf:	e8 6c fe ff ff       	call   140 <putc>
        ap++;
 2d4:	83 45 e4 04          	addl   $0x4,-0x1c(%ebp)
      state = 0;
 2d8:	bf 00 00 00 00       	mov    $0x0,%edi
 2dd:	eb 3b                	jmp    31a <printf+0x13e>
      } else if(c == '%'){
 2df:	83 f8 25             	cmp    $0x25,%eax
 2e2:	75 12                	jne    2f6 <printf+0x11a>
        putc(fd, c);
 2e4:	0f be d3             	movsbl %bl,%edx
 2e7:	8b 45 08             	mov    0x8(%ebp),%eax
 2ea:	e8 51 fe ff ff       	call   140 <putc>
      state = 0;
 2ef:	bf 00 00 00 00       	mov    $0x0,%edi
 2f4:	eb 24                	jmp    31a <printf+0x13e>
        putc(fd, '%');
 2f6:	ba 25 00 00 00       	mov    $0x25,%edx
 2fb:	8b 45 08             	mov    0x8(%ebp),%eax
 2fe:	e8 3d fe ff ff       	call   140 <putc>
        putc(fd, c);
 303:	0f be d3             	movsbl %bl,%edx
 306:	8b 45 08             	mov    0x8(%ebp),%eax
 309:	e8 32 fe ff ff       	call   140 <putc>
      state = 0;
 30e:	bf 00 00 00 00       	mov    $0x0,%edi
 313:	eb 05                	jmp    31a <printf+0x13e>
        state = '%';
 315:	bf 25 00 00 00       	mov    $0x25,%edi
  for(i = 0; fmt[i]; i++){
 31a:	83 c6 01             	add    $0x1,%esi
 31d:	89 f0                	mov    %esi,%eax
 31f:	03 45 0c             	add    0xc(%ebp),%eax
 322:	0f b6 18             	movzbl (%eax),%ebx
 325:	84 db                	test   %bl,%bl
 327:	0f 85 cd fe ff ff    	jne    1fa <printf+0x1e>
    }
  }
}
 32d:	83 c4 1c             	add    $0x1c,%esp
 330:	5b                   	pop    %ebx
 331:	5e                   	pop    %esi
 332:	5f                   	pop    %edi
 333:	5d                   	pop    %ebp
 334:	c3                   	ret    
