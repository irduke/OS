
_echo:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	57                   	push   %edi
  12:	56                   	push   %esi
  13:	53                   	push   %ebx
  14:	51                   	push   %ecx
  15:	83 ec 08             	sub    $0x8,%esp
  18:	8b 31                	mov    (%ecx),%esi
  1a:	8b 79 04             	mov    0x4(%ecx),%edi
  int i;

  for(i = 1; i < argc; i++)
  1d:	b8 01 00 00 00       	mov    $0x1,%eax
  22:	eb 1a                	jmp    3e <main+0x3e>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  24:	ba 1c 03 00 00       	mov    $0x31c,%edx
  29:	52                   	push   %edx
  2a:	ff 34 87             	pushl  (%edi,%eax,4)
  2d:	68 20 03 00 00       	push   $0x320
  32:	6a 01                	push   $0x1
  34:	e8 75 01 00 00       	call   1ae <printf>
  39:	83 c4 10             	add    $0x10,%esp
  for(i = 1; i < argc; i++)
  3c:	89 d8                	mov    %ebx,%eax
  3e:	39 f0                	cmp    %esi,%eax
  40:	7d 0e                	jge    50 <main+0x50>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  42:	8d 58 01             	lea    0x1(%eax),%ebx
  45:	39 f3                	cmp    %esi,%ebx
  47:	7d db                	jge    24 <main+0x24>
  49:	ba 1e 03 00 00       	mov    $0x31e,%edx
  4e:	eb d9                	jmp    29 <main+0x29>
  exit();
  50:	e8 08 00 00 00       	call   5d <exit>

00000055 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
  55:	b8 01 00 00 00       	mov    $0x1,%eax
  5a:	cd 40                	int    $0x40
  5c:	c3                   	ret    

0000005d <exit>:
SYSCALL(exit)
  5d:	b8 02 00 00 00       	mov    $0x2,%eax
  62:	cd 40                	int    $0x40
  64:	c3                   	ret    

00000065 <wait>:
SYSCALL(wait)
  65:	b8 03 00 00 00       	mov    $0x3,%eax
  6a:	cd 40                	int    $0x40
  6c:	c3                   	ret    

0000006d <pipe>:
SYSCALL(pipe)
  6d:	b8 04 00 00 00       	mov    $0x4,%eax
  72:	cd 40                	int    $0x40
  74:	c3                   	ret    

00000075 <read>:
SYSCALL(read)
  75:	b8 05 00 00 00       	mov    $0x5,%eax
  7a:	cd 40                	int    $0x40
  7c:	c3                   	ret    

0000007d <write>:
SYSCALL(write)
  7d:	b8 10 00 00 00       	mov    $0x10,%eax
  82:	cd 40                	int    $0x40
  84:	c3                   	ret    

00000085 <close>:
SYSCALL(close)
  85:	b8 15 00 00 00       	mov    $0x15,%eax
  8a:	cd 40                	int    $0x40
  8c:	c3                   	ret    

0000008d <kill>:
SYSCALL(kill)
  8d:	b8 06 00 00 00       	mov    $0x6,%eax
  92:	cd 40                	int    $0x40
  94:	c3                   	ret    

00000095 <exec>:
SYSCALL(exec)
  95:	b8 07 00 00 00       	mov    $0x7,%eax
  9a:	cd 40                	int    $0x40
  9c:	c3                   	ret    

0000009d <open>:
SYSCALL(open)
  9d:	b8 0f 00 00 00       	mov    $0xf,%eax
  a2:	cd 40                	int    $0x40
  a4:	c3                   	ret    

000000a5 <mknod>:
SYSCALL(mknod)
  a5:	b8 11 00 00 00       	mov    $0x11,%eax
  aa:	cd 40                	int    $0x40
  ac:	c3                   	ret    

000000ad <unlink>:
SYSCALL(unlink)
  ad:	b8 12 00 00 00       	mov    $0x12,%eax
  b2:	cd 40                	int    $0x40
  b4:	c3                   	ret    

000000b5 <fstat>:
SYSCALL(fstat)
  b5:	b8 08 00 00 00       	mov    $0x8,%eax
  ba:	cd 40                	int    $0x40
  bc:	c3                   	ret    

000000bd <link>:
SYSCALL(link)
  bd:	b8 13 00 00 00       	mov    $0x13,%eax
  c2:	cd 40                	int    $0x40
  c4:	c3                   	ret    

000000c5 <mkdir>:
SYSCALL(mkdir)
  c5:	b8 14 00 00 00       	mov    $0x14,%eax
  ca:	cd 40                	int    $0x40
  cc:	c3                   	ret    

000000cd <chdir>:
SYSCALL(chdir)
  cd:	b8 09 00 00 00       	mov    $0x9,%eax
  d2:	cd 40                	int    $0x40
  d4:	c3                   	ret    

000000d5 <dup>:
SYSCALL(dup)
  d5:	b8 0a 00 00 00       	mov    $0xa,%eax
  da:	cd 40                	int    $0x40
  dc:	c3                   	ret    

000000dd <getpid>:
SYSCALL(getpid)
  dd:	b8 0b 00 00 00       	mov    $0xb,%eax
  e2:	cd 40                	int    $0x40
  e4:	c3                   	ret    

000000e5 <sbrk>:
SYSCALL(sbrk)
  e5:	b8 0c 00 00 00       	mov    $0xc,%eax
  ea:	cd 40                	int    $0x40
  ec:	c3                   	ret    

000000ed <sleep>:
SYSCALL(sleep)
  ed:	b8 0d 00 00 00       	mov    $0xd,%eax
  f2:	cd 40                	int    $0x40
  f4:	c3                   	ret    

000000f5 <uptime>:
SYSCALL(uptime)
  f5:	b8 0e 00 00 00       	mov    $0xe,%eax
  fa:	cd 40                	int    $0x40
  fc:	c3                   	ret    

000000fd <yield>:
SYSCALL(yield)
  fd:	b8 16 00 00 00       	mov    $0x16,%eax
 102:	cd 40                	int    $0x40
 104:	c3                   	ret    

00000105 <shutdown>:
SYSCALL(shutdown)
 105:	b8 17 00 00 00       	mov    $0x17,%eax
 10a:	cd 40                	int    $0x40
 10c:	c3                   	ret    

0000010d <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 10d:	55                   	push   %ebp
 10e:	89 e5                	mov    %esp,%ebp
 110:	83 ec 1c             	sub    $0x1c,%esp
 113:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 116:	6a 01                	push   $0x1
 118:	8d 55 f4             	lea    -0xc(%ebp),%edx
 11b:	52                   	push   %edx
 11c:	50                   	push   %eax
 11d:	e8 5b ff ff ff       	call   7d <write>
}
 122:	83 c4 10             	add    $0x10,%esp
 125:	c9                   	leave  
 126:	c3                   	ret    

00000127 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 127:	55                   	push   %ebp
 128:	89 e5                	mov    %esp,%ebp
 12a:	57                   	push   %edi
 12b:	56                   	push   %esi
 12c:	53                   	push   %ebx
 12d:	83 ec 2c             	sub    $0x2c,%esp
 130:	89 45 d0             	mov    %eax,-0x30(%ebp)
 133:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 135:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 139:	0f 95 c2             	setne  %dl
 13c:	89 f0                	mov    %esi,%eax
 13e:	c1 e8 1f             	shr    $0x1f,%eax
 141:	84 c2                	test   %al,%dl
 143:	74 42                	je     187 <printint+0x60>
    neg = 1;
    x = -xx;
 145:	f7 de                	neg    %esi
    neg = 1;
 147:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 14e:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 153:	89 f0                	mov    %esi,%eax
 155:	ba 00 00 00 00       	mov    $0x0,%edx
 15a:	f7 f1                	div    %ecx
 15c:	89 df                	mov    %ebx,%edi
 15e:	83 c3 01             	add    $0x1,%ebx
 161:	0f b6 92 2c 03 00 00 	movzbl 0x32c(%edx),%edx
 168:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 16c:	89 f2                	mov    %esi,%edx
 16e:	89 c6                	mov    %eax,%esi
 170:	39 d1                	cmp    %edx,%ecx
 172:	76 df                	jbe    153 <printint+0x2c>
  if(neg)
 174:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 178:	74 2f                	je     1a9 <printint+0x82>
    buf[i++] = '-';
 17a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 17f:	8d 5f 02             	lea    0x2(%edi),%ebx
 182:	8b 75 d0             	mov    -0x30(%ebp),%esi
 185:	eb 15                	jmp    19c <printint+0x75>
  neg = 0;
 187:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 18e:	eb be                	jmp    14e <printint+0x27>

  while(--i >= 0)
    putc(fd, buf[i]);
 190:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 195:	89 f0                	mov    %esi,%eax
 197:	e8 71 ff ff ff       	call   10d <putc>
  while(--i >= 0)
 19c:	83 eb 01             	sub    $0x1,%ebx
 19f:	79 ef                	jns    190 <printint+0x69>
}
 1a1:	83 c4 2c             	add    $0x2c,%esp
 1a4:	5b                   	pop    %ebx
 1a5:	5e                   	pop    %esi
 1a6:	5f                   	pop    %edi
 1a7:	5d                   	pop    %ebp
 1a8:	c3                   	ret    
 1a9:	8b 75 d0             	mov    -0x30(%ebp),%esi
 1ac:	eb ee                	jmp    19c <printint+0x75>

000001ae <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 1ae:	f3 0f 1e fb          	endbr32 
 1b2:	55                   	push   %ebp
 1b3:	89 e5                	mov    %esp,%ebp
 1b5:	57                   	push   %edi
 1b6:	56                   	push   %esi
 1b7:	53                   	push   %ebx
 1b8:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 1bb:	8d 45 10             	lea    0x10(%ebp),%eax
 1be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 1c1:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 1c6:	bb 00 00 00 00       	mov    $0x0,%ebx
 1cb:	eb 14                	jmp    1e1 <printf+0x33>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 1cd:	89 fa                	mov    %edi,%edx
 1cf:	8b 45 08             	mov    0x8(%ebp),%eax
 1d2:	e8 36 ff ff ff       	call   10d <putc>
 1d7:	eb 05                	jmp    1de <printf+0x30>
      }
    } else if(state == '%'){
 1d9:	83 fe 25             	cmp    $0x25,%esi
 1dc:	74 25                	je     203 <printf+0x55>
  for(i = 0; fmt[i]; i++){
 1de:	83 c3 01             	add    $0x1,%ebx
 1e1:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e4:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 1e8:	84 c0                	test   %al,%al
 1ea:	0f 84 23 01 00 00    	je     313 <printf+0x165>
    c = fmt[i] & 0xff;
 1f0:	0f be f8             	movsbl %al,%edi
 1f3:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 1f6:	85 f6                	test   %esi,%esi
 1f8:	75 df                	jne    1d9 <printf+0x2b>
      if(c == '%'){
 1fa:	83 f8 25             	cmp    $0x25,%eax
 1fd:	75 ce                	jne    1cd <printf+0x1f>
        state = '%';
 1ff:	89 c6                	mov    %eax,%esi
 201:	eb db                	jmp    1de <printf+0x30>
      if(c == 'd'){
 203:	83 f8 64             	cmp    $0x64,%eax
 206:	74 49                	je     251 <printf+0xa3>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 208:	83 f8 78             	cmp    $0x78,%eax
 20b:	0f 94 c1             	sete   %cl
 20e:	83 f8 70             	cmp    $0x70,%eax
 211:	0f 94 c2             	sete   %dl
 214:	08 d1                	or     %dl,%cl
 216:	75 63                	jne    27b <printf+0xcd>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 218:	83 f8 73             	cmp    $0x73,%eax
 21b:	0f 84 84 00 00 00    	je     2a5 <printf+0xf7>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 221:	83 f8 63             	cmp    $0x63,%eax
 224:	0f 84 b7 00 00 00    	je     2e1 <printf+0x133>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 22a:	83 f8 25             	cmp    $0x25,%eax
 22d:	0f 84 cc 00 00 00    	je     2ff <printf+0x151>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 233:	ba 25 00 00 00       	mov    $0x25,%edx
 238:	8b 45 08             	mov    0x8(%ebp),%eax
 23b:	e8 cd fe ff ff       	call   10d <putc>
        putc(fd, c);
 240:	89 fa                	mov    %edi,%edx
 242:	8b 45 08             	mov    0x8(%ebp),%eax
 245:	e8 c3 fe ff ff       	call   10d <putc>
      }
      state = 0;
 24a:	be 00 00 00 00       	mov    $0x0,%esi
 24f:	eb 8d                	jmp    1de <printf+0x30>
        printint(fd, *ap, 10, 1);
 251:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 254:	8b 17                	mov    (%edi),%edx
 256:	83 ec 0c             	sub    $0xc,%esp
 259:	6a 01                	push   $0x1
 25b:	b9 0a 00 00 00       	mov    $0xa,%ecx
 260:	8b 45 08             	mov    0x8(%ebp),%eax
 263:	e8 bf fe ff ff       	call   127 <printint>
        ap++;
 268:	83 c7 04             	add    $0x4,%edi
 26b:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 26e:	83 c4 10             	add    $0x10,%esp
      state = 0;
 271:	be 00 00 00 00       	mov    $0x0,%esi
 276:	e9 63 ff ff ff       	jmp    1de <printf+0x30>
        printint(fd, *ap, 16, 0);
 27b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 27e:	8b 17                	mov    (%edi),%edx
 280:	83 ec 0c             	sub    $0xc,%esp
 283:	6a 00                	push   $0x0
 285:	b9 10 00 00 00       	mov    $0x10,%ecx
 28a:	8b 45 08             	mov    0x8(%ebp),%eax
 28d:	e8 95 fe ff ff       	call   127 <printint>
        ap++;
 292:	83 c7 04             	add    $0x4,%edi
 295:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 298:	83 c4 10             	add    $0x10,%esp
      state = 0;
 29b:	be 00 00 00 00       	mov    $0x0,%esi
 2a0:	e9 39 ff ff ff       	jmp    1de <printf+0x30>
        s = (char*)*ap;
 2a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 2a8:	8b 30                	mov    (%eax),%esi
        ap++;
 2aa:	83 c0 04             	add    $0x4,%eax
 2ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 2b0:	85 f6                	test   %esi,%esi
 2b2:	75 28                	jne    2dc <printf+0x12e>
          s = "(null)";
 2b4:	be 25 03 00 00       	mov    $0x325,%esi
 2b9:	8b 7d 08             	mov    0x8(%ebp),%edi
 2bc:	eb 0d                	jmp    2cb <printf+0x11d>
          putc(fd, *s);
 2be:	0f be d2             	movsbl %dl,%edx
 2c1:	89 f8                	mov    %edi,%eax
 2c3:	e8 45 fe ff ff       	call   10d <putc>
          s++;
 2c8:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 2cb:	0f b6 16             	movzbl (%esi),%edx
 2ce:	84 d2                	test   %dl,%dl
 2d0:	75 ec                	jne    2be <printf+0x110>
      state = 0;
 2d2:	be 00 00 00 00       	mov    $0x0,%esi
 2d7:	e9 02 ff ff ff       	jmp    1de <printf+0x30>
 2dc:	8b 7d 08             	mov    0x8(%ebp),%edi
 2df:	eb ea                	jmp    2cb <printf+0x11d>
        putc(fd, *ap);
 2e1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 2e4:	0f be 17             	movsbl (%edi),%edx
 2e7:	8b 45 08             	mov    0x8(%ebp),%eax
 2ea:	e8 1e fe ff ff       	call   10d <putc>
        ap++;
 2ef:	83 c7 04             	add    $0x4,%edi
 2f2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 2f5:	be 00 00 00 00       	mov    $0x0,%esi
 2fa:	e9 df fe ff ff       	jmp    1de <printf+0x30>
        putc(fd, c);
 2ff:	89 fa                	mov    %edi,%edx
 301:	8b 45 08             	mov    0x8(%ebp),%eax
 304:	e8 04 fe ff ff       	call   10d <putc>
      state = 0;
 309:	be 00 00 00 00       	mov    $0x0,%esi
 30e:	e9 cb fe ff ff       	jmp    1de <printf+0x30>
    }
  }
}
 313:	8d 65 f4             	lea    -0xc(%ebp),%esp
 316:	5b                   	pop    %ebx
 317:	5e                   	pop    %esi
 318:	5f                   	pop    %edi
 319:	5d                   	pop    %ebp
 31a:	c3                   	ret    
