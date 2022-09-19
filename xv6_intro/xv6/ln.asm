
_ln:     file format elf32-i386


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
  11:	53                   	push   %ebx
  12:	51                   	push   %ecx
  13:	8b 59 04             	mov    0x4(%ecx),%ebx
  if(argc != 3){
  16:	83 39 03             	cmpl   $0x3,(%ecx)
  19:	74 14                	je     2f <main+0x2f>
    printf(2, "Usage: ln old new\n");
  1b:	83 ec 08             	sub    $0x8,%esp
  1e:	68 28 03 00 00       	push   $0x328
  23:	6a 02                	push   $0x2
  25:	e8 8f 01 00 00       	call   1b9 <printf>
    exit();
  2a:	e8 39 00 00 00       	call   68 <exit>
  }
  if(link(argv[1], argv[2]) < 0)
  2f:	83 ec 08             	sub    $0x8,%esp
  32:	ff 73 08             	pushl  0x8(%ebx)
  35:	ff 73 04             	pushl  0x4(%ebx)
  38:	e8 8b 00 00 00       	call   c8 <link>
  3d:	83 c4 10             	add    $0x10,%esp
  40:	85 c0                	test   %eax,%eax
  42:	78 05                	js     49 <main+0x49>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit();
  44:	e8 1f 00 00 00       	call   68 <exit>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  49:	ff 73 08             	pushl  0x8(%ebx)
  4c:	ff 73 04             	pushl  0x4(%ebx)
  4f:	68 3b 03 00 00       	push   $0x33b
  54:	6a 02                	push   $0x2
  56:	e8 5e 01 00 00       	call   1b9 <printf>
  5b:	83 c4 10             	add    $0x10,%esp
  5e:	eb e4                	jmp    44 <main+0x44>

00000060 <fork>:
  60:	b8 01 00 00 00       	mov    $0x1,%eax
  65:	cd 40                	int    $0x40
  67:	c3                   	ret    

00000068 <exit>:
  68:	b8 02 00 00 00       	mov    $0x2,%eax
  6d:	cd 40                	int    $0x40
  6f:	c3                   	ret    

00000070 <wait>:
  70:	b8 03 00 00 00       	mov    $0x3,%eax
  75:	cd 40                	int    $0x40
  77:	c3                   	ret    

00000078 <pipe>:
  78:	b8 04 00 00 00       	mov    $0x4,%eax
  7d:	cd 40                	int    $0x40
  7f:	c3                   	ret    

00000080 <read>:
  80:	b8 05 00 00 00       	mov    $0x5,%eax
  85:	cd 40                	int    $0x40
  87:	c3                   	ret    

00000088 <write>:
  88:	b8 10 00 00 00       	mov    $0x10,%eax
  8d:	cd 40                	int    $0x40
  8f:	c3                   	ret    

00000090 <close>:
  90:	b8 15 00 00 00       	mov    $0x15,%eax
  95:	cd 40                	int    $0x40
  97:	c3                   	ret    

00000098 <kill>:
  98:	b8 06 00 00 00       	mov    $0x6,%eax
  9d:	cd 40                	int    $0x40
  9f:	c3                   	ret    

000000a0 <exec>:
  a0:	b8 07 00 00 00       	mov    $0x7,%eax
  a5:	cd 40                	int    $0x40
  a7:	c3                   	ret    

000000a8 <open>:
  a8:	b8 0f 00 00 00       	mov    $0xf,%eax
  ad:	cd 40                	int    $0x40
  af:	c3                   	ret    

000000b0 <mknod>:
  b0:	b8 11 00 00 00       	mov    $0x11,%eax
  b5:	cd 40                	int    $0x40
  b7:	c3                   	ret    

000000b8 <unlink>:
  b8:	b8 12 00 00 00       	mov    $0x12,%eax
  bd:	cd 40                	int    $0x40
  bf:	c3                   	ret    

000000c0 <fstat>:
  c0:	b8 08 00 00 00       	mov    $0x8,%eax
  c5:	cd 40                	int    $0x40
  c7:	c3                   	ret    

000000c8 <link>:
  c8:	b8 13 00 00 00       	mov    $0x13,%eax
  cd:	cd 40                	int    $0x40
  cf:	c3                   	ret    

000000d0 <mkdir>:
  d0:	b8 14 00 00 00       	mov    $0x14,%eax
  d5:	cd 40                	int    $0x40
  d7:	c3                   	ret    

000000d8 <chdir>:
  d8:	b8 09 00 00 00       	mov    $0x9,%eax
  dd:	cd 40                	int    $0x40
  df:	c3                   	ret    

000000e0 <dup>:
  e0:	b8 0a 00 00 00       	mov    $0xa,%eax
  e5:	cd 40                	int    $0x40
  e7:	c3                   	ret    

000000e8 <getpid>:
  e8:	b8 0b 00 00 00       	mov    $0xb,%eax
  ed:	cd 40                	int    $0x40
  ef:	c3                   	ret    

000000f0 <sbrk>:
  f0:	b8 0c 00 00 00       	mov    $0xc,%eax
  f5:	cd 40                	int    $0x40
  f7:	c3                   	ret    

000000f8 <sleep>:
  f8:	b8 0d 00 00 00       	mov    $0xd,%eax
  fd:	cd 40                	int    $0x40
  ff:	c3                   	ret    

00000100 <uptime>:
 100:	b8 0e 00 00 00       	mov    $0xe,%eax
 105:	cd 40                	int    $0x40
 107:	c3                   	ret    

00000108 <yield>:
 108:	b8 16 00 00 00       	mov    $0x16,%eax
 10d:	cd 40                	int    $0x40
 10f:	c3                   	ret    

00000110 <shutdown>:
 110:	b8 17 00 00 00       	mov    $0x17,%eax
 115:	cd 40                	int    $0x40
 117:	c3                   	ret    

00000118 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 118:	55                   	push   %ebp
 119:	89 e5                	mov    %esp,%ebp
 11b:	83 ec 1c             	sub    $0x1c,%esp
 11e:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 121:	6a 01                	push   $0x1
 123:	8d 55 f4             	lea    -0xc(%ebp),%edx
 126:	52                   	push   %edx
 127:	50                   	push   %eax
 128:	e8 5b ff ff ff       	call   88 <write>
}
 12d:	83 c4 10             	add    $0x10,%esp
 130:	c9                   	leave  
 131:	c3                   	ret    

00000132 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 132:	55                   	push   %ebp
 133:	89 e5                	mov    %esp,%ebp
 135:	57                   	push   %edi
 136:	56                   	push   %esi
 137:	53                   	push   %ebx
 138:	83 ec 2c             	sub    $0x2c,%esp
 13b:	89 45 d0             	mov    %eax,-0x30(%ebp)
 13e:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 140:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 144:	0f 95 c2             	setne  %dl
 147:	89 f0                	mov    %esi,%eax
 149:	c1 e8 1f             	shr    $0x1f,%eax
 14c:	84 c2                	test   %al,%dl
 14e:	74 42                	je     192 <printint+0x60>
    neg = 1;
    x = -xx;
 150:	f7 de                	neg    %esi
    neg = 1;
 152:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 159:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 15e:	89 f0                	mov    %esi,%eax
 160:	ba 00 00 00 00       	mov    $0x0,%edx
 165:	f7 f1                	div    %ecx
 167:	89 df                	mov    %ebx,%edi
 169:	83 c3 01             	add    $0x1,%ebx
 16c:	0f b6 92 58 03 00 00 	movzbl 0x358(%edx),%edx
 173:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 177:	89 f2                	mov    %esi,%edx
 179:	89 c6                	mov    %eax,%esi
 17b:	39 d1                	cmp    %edx,%ecx
 17d:	76 df                	jbe    15e <printint+0x2c>
  if(neg)
 17f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 183:	74 2f                	je     1b4 <printint+0x82>
    buf[i++] = '-';
 185:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 18a:	8d 5f 02             	lea    0x2(%edi),%ebx
 18d:	8b 75 d0             	mov    -0x30(%ebp),%esi
 190:	eb 15                	jmp    1a7 <printint+0x75>
  neg = 0;
 192:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 199:	eb be                	jmp    159 <printint+0x27>

  while(--i >= 0)
    putc(fd, buf[i]);
 19b:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 1a0:	89 f0                	mov    %esi,%eax
 1a2:	e8 71 ff ff ff       	call   118 <putc>
  while(--i >= 0)
 1a7:	83 eb 01             	sub    $0x1,%ebx
 1aa:	79 ef                	jns    19b <printint+0x69>
}
 1ac:	83 c4 2c             	add    $0x2c,%esp
 1af:	5b                   	pop    %ebx
 1b0:	5e                   	pop    %esi
 1b1:	5f                   	pop    %edi
 1b2:	5d                   	pop    %ebp
 1b3:	c3                   	ret    
 1b4:	8b 75 d0             	mov    -0x30(%ebp),%esi
 1b7:	eb ee                	jmp    1a7 <printint+0x75>

000001b9 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 1b9:	f3 0f 1e fb          	endbr32 
 1bd:	55                   	push   %ebp
 1be:	89 e5                	mov    %esp,%ebp
 1c0:	57                   	push   %edi
 1c1:	56                   	push   %esi
 1c2:	53                   	push   %ebx
 1c3:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 1c6:	8d 45 10             	lea    0x10(%ebp),%eax
 1c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 1cc:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 1d1:	bb 00 00 00 00       	mov    $0x0,%ebx
 1d6:	eb 14                	jmp    1ec <printf+0x33>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 1d8:	89 fa                	mov    %edi,%edx
 1da:	8b 45 08             	mov    0x8(%ebp),%eax
 1dd:	e8 36 ff ff ff       	call   118 <putc>
 1e2:	eb 05                	jmp    1e9 <printf+0x30>
      }
    } else if(state == '%'){
 1e4:	83 fe 25             	cmp    $0x25,%esi
 1e7:	74 25                	je     20e <printf+0x55>
  for(i = 0; fmt[i]; i++){
 1e9:	83 c3 01             	add    $0x1,%ebx
 1ec:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ef:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 1f3:	84 c0                	test   %al,%al
 1f5:	0f 84 23 01 00 00    	je     31e <printf+0x165>
    c = fmt[i] & 0xff;
 1fb:	0f be f8             	movsbl %al,%edi
 1fe:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 201:	85 f6                	test   %esi,%esi
 203:	75 df                	jne    1e4 <printf+0x2b>
      if(c == '%'){
 205:	83 f8 25             	cmp    $0x25,%eax
 208:	75 ce                	jne    1d8 <printf+0x1f>
        state = '%';
 20a:	89 c6                	mov    %eax,%esi
 20c:	eb db                	jmp    1e9 <printf+0x30>
      if(c == 'd'){
 20e:	83 f8 64             	cmp    $0x64,%eax
 211:	74 49                	je     25c <printf+0xa3>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 213:	83 f8 78             	cmp    $0x78,%eax
 216:	0f 94 c1             	sete   %cl
 219:	83 f8 70             	cmp    $0x70,%eax
 21c:	0f 94 c2             	sete   %dl
 21f:	08 d1                	or     %dl,%cl
 221:	75 63                	jne    286 <printf+0xcd>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 223:	83 f8 73             	cmp    $0x73,%eax
 226:	0f 84 84 00 00 00    	je     2b0 <printf+0xf7>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 22c:	83 f8 63             	cmp    $0x63,%eax
 22f:	0f 84 b7 00 00 00    	je     2ec <printf+0x133>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 235:	83 f8 25             	cmp    $0x25,%eax
 238:	0f 84 cc 00 00 00    	je     30a <printf+0x151>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 23e:	ba 25 00 00 00       	mov    $0x25,%edx
 243:	8b 45 08             	mov    0x8(%ebp),%eax
 246:	e8 cd fe ff ff       	call   118 <putc>
        putc(fd, c);
 24b:	89 fa                	mov    %edi,%edx
 24d:	8b 45 08             	mov    0x8(%ebp),%eax
 250:	e8 c3 fe ff ff       	call   118 <putc>
      }
      state = 0;
 255:	be 00 00 00 00       	mov    $0x0,%esi
 25a:	eb 8d                	jmp    1e9 <printf+0x30>
        printint(fd, *ap, 10, 1);
 25c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 25f:	8b 17                	mov    (%edi),%edx
 261:	83 ec 0c             	sub    $0xc,%esp
 264:	6a 01                	push   $0x1
 266:	b9 0a 00 00 00       	mov    $0xa,%ecx
 26b:	8b 45 08             	mov    0x8(%ebp),%eax
 26e:	e8 bf fe ff ff       	call   132 <printint>
        ap++;
 273:	83 c7 04             	add    $0x4,%edi
 276:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 279:	83 c4 10             	add    $0x10,%esp
      state = 0;
 27c:	be 00 00 00 00       	mov    $0x0,%esi
 281:	e9 63 ff ff ff       	jmp    1e9 <printf+0x30>
        printint(fd, *ap, 16, 0);
 286:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 289:	8b 17                	mov    (%edi),%edx
 28b:	83 ec 0c             	sub    $0xc,%esp
 28e:	6a 00                	push   $0x0
 290:	b9 10 00 00 00       	mov    $0x10,%ecx
 295:	8b 45 08             	mov    0x8(%ebp),%eax
 298:	e8 95 fe ff ff       	call   132 <printint>
        ap++;
 29d:	83 c7 04             	add    $0x4,%edi
 2a0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 2a3:	83 c4 10             	add    $0x10,%esp
      state = 0;
 2a6:	be 00 00 00 00       	mov    $0x0,%esi
 2ab:	e9 39 ff ff ff       	jmp    1e9 <printf+0x30>
        s = (char*)*ap;
 2b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 2b3:	8b 30                	mov    (%eax),%esi
        ap++;
 2b5:	83 c0 04             	add    $0x4,%eax
 2b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 2bb:	85 f6                	test   %esi,%esi
 2bd:	75 28                	jne    2e7 <printf+0x12e>
          s = "(null)";
 2bf:	be 4f 03 00 00       	mov    $0x34f,%esi
 2c4:	8b 7d 08             	mov    0x8(%ebp),%edi
 2c7:	eb 0d                	jmp    2d6 <printf+0x11d>
          putc(fd, *s);
 2c9:	0f be d2             	movsbl %dl,%edx
 2cc:	89 f8                	mov    %edi,%eax
 2ce:	e8 45 fe ff ff       	call   118 <putc>
          s++;
 2d3:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 2d6:	0f b6 16             	movzbl (%esi),%edx
 2d9:	84 d2                	test   %dl,%dl
 2db:	75 ec                	jne    2c9 <printf+0x110>
      state = 0;
 2dd:	be 00 00 00 00       	mov    $0x0,%esi
 2e2:	e9 02 ff ff ff       	jmp    1e9 <printf+0x30>
 2e7:	8b 7d 08             	mov    0x8(%ebp),%edi
 2ea:	eb ea                	jmp    2d6 <printf+0x11d>
        putc(fd, *ap);
 2ec:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 2ef:	0f be 17             	movsbl (%edi),%edx
 2f2:	8b 45 08             	mov    0x8(%ebp),%eax
 2f5:	e8 1e fe ff ff       	call   118 <putc>
        ap++;
 2fa:	83 c7 04             	add    $0x4,%edi
 2fd:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 300:	be 00 00 00 00       	mov    $0x0,%esi
 305:	e9 df fe ff ff       	jmp    1e9 <printf+0x30>
        putc(fd, c);
 30a:	89 fa                	mov    %edi,%edx
 30c:	8b 45 08             	mov    0x8(%ebp),%eax
 30f:	e8 04 fe ff ff       	call   118 <putc>
      state = 0;
 314:	be 00 00 00 00       	mov    $0x0,%esi
 319:	e9 cb fe ff ff       	jmp    1e9 <printf+0x30>
    }
  }
}
 31e:	8d 65 f4             	lea    -0xc(%ebp),%esp
 321:	5b                   	pop    %ebx
 322:	5e                   	pop    %esi
 323:	5f                   	pop    %edi
 324:	5d                   	pop    %ebp
 325:	c3                   	ret    
