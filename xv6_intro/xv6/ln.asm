
_ln:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	83 ec 10             	sub    $0x10,%esp
   a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(argc != 3){
   d:	83 7d 08 03          	cmpl   $0x3,0x8(%ebp)
  11:	74 19                	je     2c <main+0x2c>
    printf(2, "Usage: ln old new\n");
  13:	c7 44 24 04 35 03 00 	movl   $0x335,0x4(%esp)
  1a:	00 
  1b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  22:	e8 b5 01 00 00       	call   1dc <printf>
    exit();
  27:	e8 45 00 00 00       	call   71 <exit>
  }
  if(link(argv[1], argv[2]) < 0)
  2c:	8b 43 08             	mov    0x8(%ebx),%eax
  2f:	89 44 24 04          	mov    %eax,0x4(%esp)
  33:	8b 43 04             	mov    0x4(%ebx),%eax
  36:	89 04 24             	mov    %eax,(%esp)
  39:	e8 93 00 00 00       	call   d1 <link>
  3e:	85 c0                	test   %eax,%eax
  40:	79 22                	jns    64 <main+0x64>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  42:	8b 43 08             	mov    0x8(%ebx),%eax
  45:	89 44 24 0c          	mov    %eax,0xc(%esp)
  49:	8b 43 04             	mov    0x4(%ebx),%eax
  4c:	89 44 24 08          	mov    %eax,0x8(%esp)
  50:	c7 44 24 04 48 03 00 	movl   $0x348,0x4(%esp)
  57:	00 
  58:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  5f:	e8 78 01 00 00       	call   1dc <printf>
  exit();
  64:	e8 08 00 00 00       	call   71 <exit>

00000069 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
  69:	b8 01 00 00 00       	mov    $0x1,%eax
  6e:	cd 40                	int    $0x40
  70:	c3                   	ret    

00000071 <exit>:
SYSCALL(exit)
  71:	b8 02 00 00 00       	mov    $0x2,%eax
  76:	cd 40                	int    $0x40
  78:	c3                   	ret    

00000079 <wait>:
SYSCALL(wait)
  79:	b8 03 00 00 00       	mov    $0x3,%eax
  7e:	cd 40                	int    $0x40
  80:	c3                   	ret    

00000081 <pipe>:
SYSCALL(pipe)
  81:	b8 04 00 00 00       	mov    $0x4,%eax
  86:	cd 40                	int    $0x40
  88:	c3                   	ret    

00000089 <read>:
SYSCALL(read)
  89:	b8 05 00 00 00       	mov    $0x5,%eax
  8e:	cd 40                	int    $0x40
  90:	c3                   	ret    

00000091 <write>:
SYSCALL(write)
  91:	b8 10 00 00 00       	mov    $0x10,%eax
  96:	cd 40                	int    $0x40
  98:	c3                   	ret    

00000099 <close>:
SYSCALL(close)
  99:	b8 15 00 00 00       	mov    $0x15,%eax
  9e:	cd 40                	int    $0x40
  a0:	c3                   	ret    

000000a1 <kill>:
SYSCALL(kill)
  a1:	b8 06 00 00 00       	mov    $0x6,%eax
  a6:	cd 40                	int    $0x40
  a8:	c3                   	ret    

000000a9 <exec>:
SYSCALL(exec)
  a9:	b8 07 00 00 00       	mov    $0x7,%eax
  ae:	cd 40                	int    $0x40
  b0:	c3                   	ret    

000000b1 <open>:
SYSCALL(open)
  b1:	b8 0f 00 00 00       	mov    $0xf,%eax
  b6:	cd 40                	int    $0x40
  b8:	c3                   	ret    

000000b9 <mknod>:
SYSCALL(mknod)
  b9:	b8 11 00 00 00       	mov    $0x11,%eax
  be:	cd 40                	int    $0x40
  c0:	c3                   	ret    

000000c1 <unlink>:
SYSCALL(unlink)
  c1:	b8 12 00 00 00       	mov    $0x12,%eax
  c6:	cd 40                	int    $0x40
  c8:	c3                   	ret    

000000c9 <fstat>:
SYSCALL(fstat)
  c9:	b8 08 00 00 00       	mov    $0x8,%eax
  ce:	cd 40                	int    $0x40
  d0:	c3                   	ret    

000000d1 <link>:
SYSCALL(link)
  d1:	b8 13 00 00 00       	mov    $0x13,%eax
  d6:	cd 40                	int    $0x40
  d8:	c3                   	ret    

000000d9 <mkdir>:
SYSCALL(mkdir)
  d9:	b8 14 00 00 00       	mov    $0x14,%eax
  de:	cd 40                	int    $0x40
  e0:	c3                   	ret    

000000e1 <chdir>:
SYSCALL(chdir)
  e1:	b8 09 00 00 00       	mov    $0x9,%eax
  e6:	cd 40                	int    $0x40
  e8:	c3                   	ret    

000000e9 <dup>:
SYSCALL(dup)
  e9:	b8 0a 00 00 00       	mov    $0xa,%eax
  ee:	cd 40                	int    $0x40
  f0:	c3                   	ret    

000000f1 <getpid>:
SYSCALL(getpid)
  f1:	b8 0b 00 00 00       	mov    $0xb,%eax
  f6:	cd 40                	int    $0x40
  f8:	c3                   	ret    

000000f9 <sbrk>:
SYSCALL(sbrk)
  f9:	b8 0c 00 00 00       	mov    $0xc,%eax
  fe:	cd 40                	int    $0x40
 100:	c3                   	ret    

00000101 <sleep>:
SYSCALL(sleep)
 101:	b8 0d 00 00 00       	mov    $0xd,%eax
 106:	cd 40                	int    $0x40
 108:	c3                   	ret    

00000109 <uptime>:
SYSCALL(uptime)
 109:	b8 0e 00 00 00       	mov    $0xe,%eax
 10e:	cd 40                	int    $0x40
 110:	c3                   	ret    

00000111 <yield>:
SYSCALL(yield)
 111:	b8 16 00 00 00       	mov    $0x16,%eax
 116:	cd 40                	int    $0x40
 118:	c3                   	ret    

00000119 <shutdown>:
SYSCALL(shutdown)
 119:	b8 17 00 00 00       	mov    $0x17,%eax
 11e:	cd 40                	int    $0x40
 120:	c3                   	ret    

00000121 <writecount>:
SYSCALL(writecount)
 121:	b8 18 00 00 00       	mov    $0x18,%eax
 126:	cd 40                	int    $0x40
 128:	c3                   	ret    

00000129 <setwritecount>:
SYSCALL(setwritecount)
 129:	b8 19 00 00 00       	mov    $0x19,%eax
 12e:	cd 40                	int    $0x40
 130:	c3                   	ret    
 131:	66 90                	xchg   %ax,%ax
 133:	66 90                	xchg   %ax,%ax
 135:	66 90                	xchg   %ax,%ax
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
 15b:	e8 31 ff ff ff       	call   91 <write>
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
 1a0:	0f b6 92 63 03 00 00 	movzbl 0x363(%edx),%edx
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
 297:	bb 5c 03 00 00       	mov    $0x35c,%ebx
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
