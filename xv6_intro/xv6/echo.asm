
_echo:     file format elf32-i386


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
   c:	8b 75 08             	mov    0x8(%ebp),%esi
   f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  for(i = 1; i < argc; i++)
  12:	b8 01 00 00 00       	mov    $0x1,%eax
  17:	eb 34                	jmp    4d <main+0x4d>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  19:	8d 58 01             	lea    0x1(%eax),%ebx
  1c:	39 f3                	cmp    %esi,%ebx
  1e:	7d 07                	jge    27 <main+0x27>
  20:	ba 15 03 00 00       	mov    $0x315,%edx
  25:	eb 05                	jmp    2c <main+0x2c>
  27:	ba 17 03 00 00       	mov    $0x317,%edx
  2c:	89 54 24 0c          	mov    %edx,0xc(%esp)
  30:	8b 04 87             	mov    (%edi,%eax,4),%eax
  33:	89 44 24 08          	mov    %eax,0x8(%esp)
  37:	c7 44 24 04 19 03 00 	movl   $0x319,0x4(%esp)
  3e:	00 
  3f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  46:	e8 71 01 00 00       	call   1bc <printf>
  for(i = 1; i < argc; i++)
  4b:	89 d8                	mov    %ebx,%eax
  4d:	39 f0                	cmp    %esi,%eax
  4f:	7c c8                	jl     19 <main+0x19>
  exit();
  51:	e8 08 00 00 00       	call   5e <exit>

00000056 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
  56:	b8 01 00 00 00       	mov    $0x1,%eax
  5b:	cd 40                	int    $0x40
  5d:	c3                   	ret    

0000005e <exit>:
SYSCALL(exit)
  5e:	b8 02 00 00 00       	mov    $0x2,%eax
  63:	cd 40                	int    $0x40
  65:	c3                   	ret    

00000066 <wait>:
SYSCALL(wait)
  66:	b8 03 00 00 00       	mov    $0x3,%eax
  6b:	cd 40                	int    $0x40
  6d:	c3                   	ret    

0000006e <pipe>:
SYSCALL(pipe)
  6e:	b8 04 00 00 00       	mov    $0x4,%eax
  73:	cd 40                	int    $0x40
  75:	c3                   	ret    

00000076 <read>:
SYSCALL(read)
  76:	b8 05 00 00 00       	mov    $0x5,%eax
  7b:	cd 40                	int    $0x40
  7d:	c3                   	ret    

0000007e <write>:
SYSCALL(write)
  7e:	b8 10 00 00 00       	mov    $0x10,%eax
  83:	cd 40                	int    $0x40
  85:	c3                   	ret    

00000086 <close>:
SYSCALL(close)
  86:	b8 15 00 00 00       	mov    $0x15,%eax
  8b:	cd 40                	int    $0x40
  8d:	c3                   	ret    

0000008e <kill>:
SYSCALL(kill)
  8e:	b8 06 00 00 00       	mov    $0x6,%eax
  93:	cd 40                	int    $0x40
  95:	c3                   	ret    

00000096 <exec>:
SYSCALL(exec)
  96:	b8 07 00 00 00       	mov    $0x7,%eax
  9b:	cd 40                	int    $0x40
  9d:	c3                   	ret    

0000009e <open>:
SYSCALL(open)
  9e:	b8 0f 00 00 00       	mov    $0xf,%eax
  a3:	cd 40                	int    $0x40
  a5:	c3                   	ret    

000000a6 <mknod>:
SYSCALL(mknod)
  a6:	b8 11 00 00 00       	mov    $0x11,%eax
  ab:	cd 40                	int    $0x40
  ad:	c3                   	ret    

000000ae <unlink>:
SYSCALL(unlink)
  ae:	b8 12 00 00 00       	mov    $0x12,%eax
  b3:	cd 40                	int    $0x40
  b5:	c3                   	ret    

000000b6 <fstat>:
SYSCALL(fstat)
  b6:	b8 08 00 00 00       	mov    $0x8,%eax
  bb:	cd 40                	int    $0x40
  bd:	c3                   	ret    

000000be <link>:
SYSCALL(link)
  be:	b8 13 00 00 00       	mov    $0x13,%eax
  c3:	cd 40                	int    $0x40
  c5:	c3                   	ret    

000000c6 <mkdir>:
SYSCALL(mkdir)
  c6:	b8 14 00 00 00       	mov    $0x14,%eax
  cb:	cd 40                	int    $0x40
  cd:	c3                   	ret    

000000ce <chdir>:
SYSCALL(chdir)
  ce:	b8 09 00 00 00       	mov    $0x9,%eax
  d3:	cd 40                	int    $0x40
  d5:	c3                   	ret    

000000d6 <dup>:
SYSCALL(dup)
  d6:	b8 0a 00 00 00       	mov    $0xa,%eax
  db:	cd 40                	int    $0x40
  dd:	c3                   	ret    

000000de <getpid>:
SYSCALL(getpid)
  de:	b8 0b 00 00 00       	mov    $0xb,%eax
  e3:	cd 40                	int    $0x40
  e5:	c3                   	ret    

000000e6 <sbrk>:
SYSCALL(sbrk)
  e6:	b8 0c 00 00 00       	mov    $0xc,%eax
  eb:	cd 40                	int    $0x40
  ed:	c3                   	ret    

000000ee <sleep>:
SYSCALL(sleep)
  ee:	b8 0d 00 00 00       	mov    $0xd,%eax
  f3:	cd 40                	int    $0x40
  f5:	c3                   	ret    

000000f6 <uptime>:
SYSCALL(uptime)
  f6:	b8 0e 00 00 00       	mov    $0xe,%eax
  fb:	cd 40                	int    $0x40
  fd:	c3                   	ret    

000000fe <yield>:
SYSCALL(yield)
  fe:	b8 16 00 00 00       	mov    $0x16,%eax
 103:	cd 40                	int    $0x40
 105:	c3                   	ret    

00000106 <shutdown>:
SYSCALL(shutdown)
 106:	b8 17 00 00 00       	mov    $0x17,%eax
 10b:	cd 40                	int    $0x40
 10d:	c3                   	ret    

0000010e <writecount>:
SYSCALL(writecount)
 10e:	b8 18 00 00 00       	mov    $0x18,%eax
 113:	cd 40                	int    $0x40
 115:	c3                   	ret    

00000116 <setwritecount>:
SYSCALL(setwritecount)
 116:	b8 19 00 00 00       	mov    $0x19,%eax
 11b:	cd 40                	int    $0x40
 11d:	c3                   	ret    
 11e:	66 90                	xchg   %ax,%ax

00000120 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 120:	55                   	push   %ebp
 121:	89 e5                	mov    %esp,%ebp
 123:	83 ec 18             	sub    $0x18,%esp
 126:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 129:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 130:	00 
 131:	8d 55 f4             	lea    -0xc(%ebp),%edx
 134:	89 54 24 04          	mov    %edx,0x4(%esp)
 138:	89 04 24             	mov    %eax,(%esp)
 13b:	e8 3e ff ff ff       	call   7e <write>
}
 140:	c9                   	leave  
 141:	c3                   	ret    

00000142 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 142:	55                   	push   %ebp
 143:	89 e5                	mov    %esp,%ebp
 145:	57                   	push   %edi
 146:	56                   	push   %esi
 147:	53                   	push   %ebx
 148:	83 ec 2c             	sub    $0x2c,%esp
 14b:	89 c7                	mov    %eax,%edi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 14d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 151:	0f 95 c3             	setne  %bl
 154:	89 d0                	mov    %edx,%eax
 156:	c1 e8 1f             	shr    $0x1f,%eax
 159:	84 c3                	test   %al,%bl
 15b:	74 0b                	je     168 <printint+0x26>
    neg = 1;
    x = -xx;
 15d:	f7 da                	neg    %edx
    neg = 1;
 15f:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
 166:	eb 07                	jmp    16f <printint+0x2d>
  neg = 0;
 168:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 16f:	be 00 00 00 00       	mov    $0x0,%esi
  do{
    buf[i++] = digits[x % base];
 174:	8d 5e 01             	lea    0x1(%esi),%ebx
 177:	89 d0                	mov    %edx,%eax
 179:	ba 00 00 00 00       	mov    $0x0,%edx
 17e:	f7 f1                	div    %ecx
 180:	0f b6 92 25 03 00 00 	movzbl 0x325(%edx),%edx
 187:	88 54 35 d8          	mov    %dl,-0x28(%ebp,%esi,1)
  }while((x /= base) != 0);
 18b:	89 c2                	mov    %eax,%edx
    buf[i++] = digits[x % base];
 18d:	89 de                	mov    %ebx,%esi
  }while((x /= base) != 0);
 18f:	85 c0                	test   %eax,%eax
 191:	75 e1                	jne    174 <printint+0x32>
  if(neg)
 193:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 197:	74 16                	je     1af <printint+0x6d>
    buf[i++] = '-';
 199:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 19e:	8d 5b 01             	lea    0x1(%ebx),%ebx
 1a1:	eb 0c                	jmp    1af <printint+0x6d>

  while(--i >= 0)
    putc(fd, buf[i]);
 1a3:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 1a8:	89 f8                	mov    %edi,%eax
 1aa:	e8 71 ff ff ff       	call   120 <putc>
  while(--i >= 0)
 1af:	83 eb 01             	sub    $0x1,%ebx
 1b2:	79 ef                	jns    1a3 <printint+0x61>
}
 1b4:	83 c4 2c             	add    $0x2c,%esp
 1b7:	5b                   	pop    %ebx
 1b8:	5e                   	pop    %esi
 1b9:	5f                   	pop    %edi
 1ba:	5d                   	pop    %ebp
 1bb:	c3                   	ret    

000001bc <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 1bc:	55                   	push   %ebp
 1bd:	89 e5                	mov    %esp,%ebp
 1bf:	57                   	push   %edi
 1c0:	56                   	push   %esi
 1c1:	53                   	push   %ebx
 1c2:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 1c5:	8d 45 10             	lea    0x10(%ebp),%eax
 1c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 1cb:	bf 00 00 00 00       	mov    $0x0,%edi
  for(i = 0; fmt[i]; i++){
 1d0:	be 00 00 00 00       	mov    $0x0,%esi
 1d5:	e9 23 01 00 00       	jmp    2fd <printf+0x141>
    c = fmt[i] & 0xff;
 1da:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 1dd:	85 ff                	test   %edi,%edi
 1df:	75 19                	jne    1fa <printf+0x3e>
      if(c == '%'){
 1e1:	83 f8 25             	cmp    $0x25,%eax
 1e4:	0f 84 0b 01 00 00    	je     2f5 <printf+0x139>
        state = '%';
      } else {
        putc(fd, c);
 1ea:	0f be d3             	movsbl %bl,%edx
 1ed:	8b 45 08             	mov    0x8(%ebp),%eax
 1f0:	e8 2b ff ff ff       	call   120 <putc>
 1f5:	e9 00 01 00 00       	jmp    2fa <printf+0x13e>
      }
    } else if(state == '%'){
 1fa:	83 ff 25             	cmp    $0x25,%edi
 1fd:	0f 85 f7 00 00 00    	jne    2fa <printf+0x13e>
      if(c == 'd'){
 203:	83 f8 64             	cmp    $0x64,%eax
 206:	75 26                	jne    22e <printf+0x72>
        printint(fd, *ap, 10, 1);
 208:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 20b:	8b 10                	mov    (%eax),%edx
 20d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 214:	b9 0a 00 00 00       	mov    $0xa,%ecx
 219:	8b 45 08             	mov    0x8(%ebp),%eax
 21c:	e8 21 ff ff ff       	call   142 <printint>
        ap++;
 221:	83 45 e4 04          	addl   $0x4,-0x1c(%ebp)
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 225:	66 bf 00 00          	mov    $0x0,%di
 229:	e9 cc 00 00 00       	jmp    2fa <printf+0x13e>
      } else if(c == 'x' || c == 'p'){
 22e:	83 f8 78             	cmp    $0x78,%eax
 231:	0f 94 c1             	sete   %cl
 234:	83 f8 70             	cmp    $0x70,%eax
 237:	0f 94 c2             	sete   %dl
 23a:	08 d1                	or     %dl,%cl
 23c:	74 27                	je     265 <printf+0xa9>
        printint(fd, *ap, 16, 0);
 23e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 241:	8b 10                	mov    (%eax),%edx
 243:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 24a:	b9 10 00 00 00       	mov    $0x10,%ecx
 24f:	8b 45 08             	mov    0x8(%ebp),%eax
 252:	e8 eb fe ff ff       	call   142 <printint>
        ap++;
 257:	83 45 e4 04          	addl   $0x4,-0x1c(%ebp)
      state = 0;
 25b:	bf 00 00 00 00       	mov    $0x0,%edi
 260:	e9 95 00 00 00       	jmp    2fa <printf+0x13e>
      } else if(c == 's'){
 265:	83 f8 73             	cmp    $0x73,%eax
 268:	75 37                	jne    2a1 <printf+0xe5>
        s = (char*)*ap;
 26a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 26d:	8b 18                	mov    (%eax),%ebx
        ap++;
 26f:	83 45 e4 04          	addl   $0x4,-0x1c(%ebp)
        if(s == 0)
 273:	85 db                	test   %ebx,%ebx
 275:	75 19                	jne    290 <printf+0xd4>
          s = "(null)";
 277:	bb 1e 03 00 00       	mov    $0x31e,%ebx
 27c:	8b 7d 08             	mov    0x8(%ebp),%edi
 27f:	eb 12                	jmp    293 <printf+0xd7>
          putc(fd, *s);
 281:	0f be d2             	movsbl %dl,%edx
 284:	89 f8                	mov    %edi,%eax
 286:	e8 95 fe ff ff       	call   120 <putc>
          s++;
 28b:	83 c3 01             	add    $0x1,%ebx
 28e:	eb 03                	jmp    293 <printf+0xd7>
 290:	8b 7d 08             	mov    0x8(%ebp),%edi
        while(*s != 0){
 293:	0f b6 13             	movzbl (%ebx),%edx
 296:	84 d2                	test   %dl,%dl
 298:	75 e7                	jne    281 <printf+0xc5>
      state = 0;
 29a:	bf 00 00 00 00       	mov    $0x0,%edi
 29f:	eb 59                	jmp    2fa <printf+0x13e>
      } else if(c == 'c'){
 2a1:	83 f8 63             	cmp    $0x63,%eax
 2a4:	75 19                	jne    2bf <printf+0x103>
        putc(fd, *ap);
 2a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 2a9:	0f be 10             	movsbl (%eax),%edx
 2ac:	8b 45 08             	mov    0x8(%ebp),%eax
 2af:	e8 6c fe ff ff       	call   120 <putc>
        ap++;
 2b4:	83 45 e4 04          	addl   $0x4,-0x1c(%ebp)
      state = 0;
 2b8:	bf 00 00 00 00       	mov    $0x0,%edi
 2bd:	eb 3b                	jmp    2fa <printf+0x13e>
      } else if(c == '%'){
 2bf:	83 f8 25             	cmp    $0x25,%eax
 2c2:	75 12                	jne    2d6 <printf+0x11a>
        putc(fd, c);
 2c4:	0f be d3             	movsbl %bl,%edx
 2c7:	8b 45 08             	mov    0x8(%ebp),%eax
 2ca:	e8 51 fe ff ff       	call   120 <putc>
      state = 0;
 2cf:	bf 00 00 00 00       	mov    $0x0,%edi
 2d4:	eb 24                	jmp    2fa <printf+0x13e>
        putc(fd, '%');
 2d6:	ba 25 00 00 00       	mov    $0x25,%edx
 2db:	8b 45 08             	mov    0x8(%ebp),%eax
 2de:	e8 3d fe ff ff       	call   120 <putc>
        putc(fd, c);
 2e3:	0f be d3             	movsbl %bl,%edx
 2e6:	8b 45 08             	mov    0x8(%ebp),%eax
 2e9:	e8 32 fe ff ff       	call   120 <putc>
      state = 0;
 2ee:	bf 00 00 00 00       	mov    $0x0,%edi
 2f3:	eb 05                	jmp    2fa <printf+0x13e>
        state = '%';
 2f5:	bf 25 00 00 00       	mov    $0x25,%edi
  for(i = 0; fmt[i]; i++){
 2fa:	83 c6 01             	add    $0x1,%esi
 2fd:	89 f0                	mov    %esi,%eax
 2ff:	03 45 0c             	add    0xc(%ebp),%eax
 302:	0f b6 18             	movzbl (%eax),%ebx
 305:	84 db                	test   %bl,%bl
 307:	0f 85 cd fe ff ff    	jne    1da <printf+0x1e>
    }
  }
}
 30d:	83 c4 1c             	add    $0x1c,%esp
 310:	5b                   	pop    %ebx
 311:	5e                   	pop    %esi
 312:	5f                   	pop    %edi
 313:	5d                   	pop    %ebp
 314:	c3                   	ret    
