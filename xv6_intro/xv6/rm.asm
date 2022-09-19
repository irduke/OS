
_rm:     file format elf32-i386


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
  15:	83 ec 18             	sub    $0x18,%esp
  18:	8b 39                	mov    (%ecx),%edi
  1a:	8b 41 04             	mov    0x4(%ecx),%eax
  1d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int i;

  if(argc < 2){
  20:	83 ff 01             	cmp    $0x1,%edi
  23:	7e 25                	jle    4a <main+0x4a>
    printf(2, "Usage: rm files...\n");
    exit();
  }

  for(i = 1; i < argc; i++){
  25:	bb 01 00 00 00       	mov    $0x1,%ebx
  2a:	39 fb                	cmp    %edi,%ebx
  2c:	7d 44                	jge    72 <main+0x72>
    if(unlink(argv[i]) < 0){
  2e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  31:	8d 34 98             	lea    (%eax,%ebx,4),%esi
  34:	83 ec 0c             	sub    $0xc,%esp
  37:	ff 36                	pushl  (%esi)
  39:	e8 91 00 00 00       	call   cf <unlink>
  3e:	83 c4 10             	add    $0x10,%esp
  41:	85 c0                	test   %eax,%eax
  43:	78 19                	js     5e <main+0x5e>
  for(i = 1; i < argc; i++){
  45:	83 c3 01             	add    $0x1,%ebx
  48:	eb e0                	jmp    2a <main+0x2a>
    printf(2, "Usage: rm files...\n");
  4a:	83 ec 08             	sub    $0x8,%esp
  4d:	68 40 03 00 00       	push   $0x340
  52:	6a 02                	push   $0x2
  54:	e8 77 01 00 00       	call   1d0 <printf>
    exit();
  59:	e8 21 00 00 00       	call   7f <exit>
      printf(2, "rm: %s failed to delete\n", argv[i]);
  5e:	83 ec 04             	sub    $0x4,%esp
  61:	ff 36                	pushl  (%esi)
  63:	68 54 03 00 00       	push   $0x354
  68:	6a 02                	push   $0x2
  6a:	e8 61 01 00 00       	call   1d0 <printf>
      break;
  6f:	83 c4 10             	add    $0x10,%esp
    }
  }

  exit();
  72:	e8 08 00 00 00       	call   7f <exit>

00000077 <fork>:
  77:	b8 01 00 00 00       	mov    $0x1,%eax
  7c:	cd 40                	int    $0x40
  7e:	c3                   	ret    

0000007f <exit>:
  7f:	b8 02 00 00 00       	mov    $0x2,%eax
  84:	cd 40                	int    $0x40
  86:	c3                   	ret    

00000087 <wait>:
  87:	b8 03 00 00 00       	mov    $0x3,%eax
  8c:	cd 40                	int    $0x40
  8e:	c3                   	ret    

0000008f <pipe>:
  8f:	b8 04 00 00 00       	mov    $0x4,%eax
  94:	cd 40                	int    $0x40
  96:	c3                   	ret    

00000097 <read>:
  97:	b8 05 00 00 00       	mov    $0x5,%eax
  9c:	cd 40                	int    $0x40
  9e:	c3                   	ret    

0000009f <write>:
  9f:	b8 10 00 00 00       	mov    $0x10,%eax
  a4:	cd 40                	int    $0x40
  a6:	c3                   	ret    

000000a7 <close>:
  a7:	b8 15 00 00 00       	mov    $0x15,%eax
  ac:	cd 40                	int    $0x40
  ae:	c3                   	ret    

000000af <kill>:
  af:	b8 06 00 00 00       	mov    $0x6,%eax
  b4:	cd 40                	int    $0x40
  b6:	c3                   	ret    

000000b7 <exec>:
  b7:	b8 07 00 00 00       	mov    $0x7,%eax
  bc:	cd 40                	int    $0x40
  be:	c3                   	ret    

000000bf <open>:
  bf:	b8 0f 00 00 00       	mov    $0xf,%eax
  c4:	cd 40                	int    $0x40
  c6:	c3                   	ret    

000000c7 <mknod>:
  c7:	b8 11 00 00 00       	mov    $0x11,%eax
  cc:	cd 40                	int    $0x40
  ce:	c3                   	ret    

000000cf <unlink>:
  cf:	b8 12 00 00 00       	mov    $0x12,%eax
  d4:	cd 40                	int    $0x40
  d6:	c3                   	ret    

000000d7 <fstat>:
  d7:	b8 08 00 00 00       	mov    $0x8,%eax
  dc:	cd 40                	int    $0x40
  de:	c3                   	ret    

000000df <link>:
  df:	b8 13 00 00 00       	mov    $0x13,%eax
  e4:	cd 40                	int    $0x40
  e6:	c3                   	ret    

000000e7 <mkdir>:
  e7:	b8 14 00 00 00       	mov    $0x14,%eax
  ec:	cd 40                	int    $0x40
  ee:	c3                   	ret    

000000ef <chdir>:
  ef:	b8 09 00 00 00       	mov    $0x9,%eax
  f4:	cd 40                	int    $0x40
  f6:	c3                   	ret    

000000f7 <dup>:
  f7:	b8 0a 00 00 00       	mov    $0xa,%eax
  fc:	cd 40                	int    $0x40
  fe:	c3                   	ret    

000000ff <getpid>:
  ff:	b8 0b 00 00 00       	mov    $0xb,%eax
 104:	cd 40                	int    $0x40
 106:	c3                   	ret    

00000107 <sbrk>:
 107:	b8 0c 00 00 00       	mov    $0xc,%eax
 10c:	cd 40                	int    $0x40
 10e:	c3                   	ret    

0000010f <sleep>:
 10f:	b8 0d 00 00 00       	mov    $0xd,%eax
 114:	cd 40                	int    $0x40
 116:	c3                   	ret    

00000117 <uptime>:
 117:	b8 0e 00 00 00       	mov    $0xe,%eax
 11c:	cd 40                	int    $0x40
 11e:	c3                   	ret    

0000011f <yield>:
 11f:	b8 16 00 00 00       	mov    $0x16,%eax
 124:	cd 40                	int    $0x40
 126:	c3                   	ret    

00000127 <shutdown>:
 127:	b8 17 00 00 00       	mov    $0x17,%eax
 12c:	cd 40                	int    $0x40
 12e:	c3                   	ret    

0000012f <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 12f:	55                   	push   %ebp
 130:	89 e5                	mov    %esp,%ebp
 132:	83 ec 1c             	sub    $0x1c,%esp
 135:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 138:	6a 01                	push   $0x1
 13a:	8d 55 f4             	lea    -0xc(%ebp),%edx
 13d:	52                   	push   %edx
 13e:	50                   	push   %eax
 13f:	e8 5b ff ff ff       	call   9f <write>
}
 144:	83 c4 10             	add    $0x10,%esp
 147:	c9                   	leave  
 148:	c3                   	ret    

00000149 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 149:	55                   	push   %ebp
 14a:	89 e5                	mov    %esp,%ebp
 14c:	57                   	push   %edi
 14d:	56                   	push   %esi
 14e:	53                   	push   %ebx
 14f:	83 ec 2c             	sub    $0x2c,%esp
 152:	89 45 d0             	mov    %eax,-0x30(%ebp)
 155:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 157:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 15b:	0f 95 c2             	setne  %dl
 15e:	89 f0                	mov    %esi,%eax
 160:	c1 e8 1f             	shr    $0x1f,%eax
 163:	84 c2                	test   %al,%dl
 165:	74 42                	je     1a9 <printint+0x60>
    neg = 1;
    x = -xx;
 167:	f7 de                	neg    %esi
    neg = 1;
 169:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 170:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 175:	89 f0                	mov    %esi,%eax
 177:	ba 00 00 00 00       	mov    $0x0,%edx
 17c:	f7 f1                	div    %ecx
 17e:	89 df                	mov    %ebx,%edi
 180:	83 c3 01             	add    $0x1,%ebx
 183:	0f b6 92 74 03 00 00 	movzbl 0x374(%edx),%edx
 18a:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 18e:	89 f2                	mov    %esi,%edx
 190:	89 c6                	mov    %eax,%esi
 192:	39 d1                	cmp    %edx,%ecx
 194:	76 df                	jbe    175 <printint+0x2c>
  if(neg)
 196:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 19a:	74 2f                	je     1cb <printint+0x82>
    buf[i++] = '-';
 19c:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 1a1:	8d 5f 02             	lea    0x2(%edi),%ebx
 1a4:	8b 75 d0             	mov    -0x30(%ebp),%esi
 1a7:	eb 15                	jmp    1be <printint+0x75>
  neg = 0;
 1a9:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 1b0:	eb be                	jmp    170 <printint+0x27>

  while(--i >= 0)
    putc(fd, buf[i]);
 1b2:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 1b7:	89 f0                	mov    %esi,%eax
 1b9:	e8 71 ff ff ff       	call   12f <putc>
  while(--i >= 0)
 1be:	83 eb 01             	sub    $0x1,%ebx
 1c1:	79 ef                	jns    1b2 <printint+0x69>
}
 1c3:	83 c4 2c             	add    $0x2c,%esp
 1c6:	5b                   	pop    %ebx
 1c7:	5e                   	pop    %esi
 1c8:	5f                   	pop    %edi
 1c9:	5d                   	pop    %ebp
 1ca:	c3                   	ret    
 1cb:	8b 75 d0             	mov    -0x30(%ebp),%esi
 1ce:	eb ee                	jmp    1be <printint+0x75>

000001d0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 1d0:	f3 0f 1e fb          	endbr32 
 1d4:	55                   	push   %ebp
 1d5:	89 e5                	mov    %esp,%ebp
 1d7:	57                   	push   %edi
 1d8:	56                   	push   %esi
 1d9:	53                   	push   %ebx
 1da:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 1dd:	8d 45 10             	lea    0x10(%ebp),%eax
 1e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 1e3:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 1e8:	bb 00 00 00 00       	mov    $0x0,%ebx
 1ed:	eb 14                	jmp    203 <printf+0x33>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 1ef:	89 fa                	mov    %edi,%edx
 1f1:	8b 45 08             	mov    0x8(%ebp),%eax
 1f4:	e8 36 ff ff ff       	call   12f <putc>
 1f9:	eb 05                	jmp    200 <printf+0x30>
      }
    } else if(state == '%'){
 1fb:	83 fe 25             	cmp    $0x25,%esi
 1fe:	74 25                	je     225 <printf+0x55>
  for(i = 0; fmt[i]; i++){
 200:	83 c3 01             	add    $0x1,%ebx
 203:	8b 45 0c             	mov    0xc(%ebp),%eax
 206:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 20a:	84 c0                	test   %al,%al
 20c:	0f 84 23 01 00 00    	je     335 <printf+0x165>
    c = fmt[i] & 0xff;
 212:	0f be f8             	movsbl %al,%edi
 215:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 218:	85 f6                	test   %esi,%esi
 21a:	75 df                	jne    1fb <printf+0x2b>
      if(c == '%'){
 21c:	83 f8 25             	cmp    $0x25,%eax
 21f:	75 ce                	jne    1ef <printf+0x1f>
        state = '%';
 221:	89 c6                	mov    %eax,%esi
 223:	eb db                	jmp    200 <printf+0x30>
      if(c == 'd'){
 225:	83 f8 64             	cmp    $0x64,%eax
 228:	74 49                	je     273 <printf+0xa3>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 22a:	83 f8 78             	cmp    $0x78,%eax
 22d:	0f 94 c1             	sete   %cl
 230:	83 f8 70             	cmp    $0x70,%eax
 233:	0f 94 c2             	sete   %dl
 236:	08 d1                	or     %dl,%cl
 238:	75 63                	jne    29d <printf+0xcd>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 23a:	83 f8 73             	cmp    $0x73,%eax
 23d:	0f 84 84 00 00 00    	je     2c7 <printf+0xf7>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 243:	83 f8 63             	cmp    $0x63,%eax
 246:	0f 84 b7 00 00 00    	je     303 <printf+0x133>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 24c:	83 f8 25             	cmp    $0x25,%eax
 24f:	0f 84 cc 00 00 00    	je     321 <printf+0x151>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 255:	ba 25 00 00 00       	mov    $0x25,%edx
 25a:	8b 45 08             	mov    0x8(%ebp),%eax
 25d:	e8 cd fe ff ff       	call   12f <putc>
        putc(fd, c);
 262:	89 fa                	mov    %edi,%edx
 264:	8b 45 08             	mov    0x8(%ebp),%eax
 267:	e8 c3 fe ff ff       	call   12f <putc>
      }
      state = 0;
 26c:	be 00 00 00 00       	mov    $0x0,%esi
 271:	eb 8d                	jmp    200 <printf+0x30>
        printint(fd, *ap, 10, 1);
 273:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 276:	8b 17                	mov    (%edi),%edx
 278:	83 ec 0c             	sub    $0xc,%esp
 27b:	6a 01                	push   $0x1
 27d:	b9 0a 00 00 00       	mov    $0xa,%ecx
 282:	8b 45 08             	mov    0x8(%ebp),%eax
 285:	e8 bf fe ff ff       	call   149 <printint>
        ap++;
 28a:	83 c7 04             	add    $0x4,%edi
 28d:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 290:	83 c4 10             	add    $0x10,%esp
      state = 0;
 293:	be 00 00 00 00       	mov    $0x0,%esi
 298:	e9 63 ff ff ff       	jmp    200 <printf+0x30>
        printint(fd, *ap, 16, 0);
 29d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 2a0:	8b 17                	mov    (%edi),%edx
 2a2:	83 ec 0c             	sub    $0xc,%esp
 2a5:	6a 00                	push   $0x0
 2a7:	b9 10 00 00 00       	mov    $0x10,%ecx
 2ac:	8b 45 08             	mov    0x8(%ebp),%eax
 2af:	e8 95 fe ff ff       	call   149 <printint>
        ap++;
 2b4:	83 c7 04             	add    $0x4,%edi
 2b7:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 2ba:	83 c4 10             	add    $0x10,%esp
      state = 0;
 2bd:	be 00 00 00 00       	mov    $0x0,%esi
 2c2:	e9 39 ff ff ff       	jmp    200 <printf+0x30>
        s = (char*)*ap;
 2c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 2ca:	8b 30                	mov    (%eax),%esi
        ap++;
 2cc:	83 c0 04             	add    $0x4,%eax
 2cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 2d2:	85 f6                	test   %esi,%esi
 2d4:	75 28                	jne    2fe <printf+0x12e>
          s = "(null)";
 2d6:	be 6d 03 00 00       	mov    $0x36d,%esi
 2db:	8b 7d 08             	mov    0x8(%ebp),%edi
 2de:	eb 0d                	jmp    2ed <printf+0x11d>
          putc(fd, *s);
 2e0:	0f be d2             	movsbl %dl,%edx
 2e3:	89 f8                	mov    %edi,%eax
 2e5:	e8 45 fe ff ff       	call   12f <putc>
          s++;
 2ea:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 2ed:	0f b6 16             	movzbl (%esi),%edx
 2f0:	84 d2                	test   %dl,%dl
 2f2:	75 ec                	jne    2e0 <printf+0x110>
      state = 0;
 2f4:	be 00 00 00 00       	mov    $0x0,%esi
 2f9:	e9 02 ff ff ff       	jmp    200 <printf+0x30>
 2fe:	8b 7d 08             	mov    0x8(%ebp),%edi
 301:	eb ea                	jmp    2ed <printf+0x11d>
        putc(fd, *ap);
 303:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 306:	0f be 17             	movsbl (%edi),%edx
 309:	8b 45 08             	mov    0x8(%ebp),%eax
 30c:	e8 1e fe ff ff       	call   12f <putc>
        ap++;
 311:	83 c7 04             	add    $0x4,%edi
 314:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 317:	be 00 00 00 00       	mov    $0x0,%esi
 31c:	e9 df fe ff ff       	jmp    200 <printf+0x30>
        putc(fd, c);
 321:	89 fa                	mov    %edi,%edx
 323:	8b 45 08             	mov    0x8(%ebp),%eax
 326:	e8 04 fe ff ff       	call   12f <putc>
      state = 0;
 32b:	be 00 00 00 00       	mov    $0x0,%esi
 330:	e9 cb fe ff ff       	jmp    200 <printf+0x30>
    }
  }
}
 335:	8d 65 f4             	lea    -0xc(%ebp),%esp
 338:	5b                   	pop    %ebx
 339:	5e                   	pop    %esi
 33a:	5f                   	pop    %edi
 33b:	5d                   	pop    %ebp
 33c:	c3                   	ret    
