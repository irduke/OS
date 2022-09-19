
_cat:     file format elf32-i386


Disassembly of section .text:

00000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	55                   	push   %ebp
   5:	89 e5                	mov    %esp,%ebp
   7:	56                   	push   %esi
   8:	53                   	push   %ebx
   9:	8b 75 08             	mov    0x8(%ebp),%esi
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
   c:	83 ec 04             	sub    $0x4,%esp
   f:	68 00 02 00 00       	push   $0x200
  14:	68 20 04 00 00       	push   $0x420
  19:	56                   	push   %esi
  1a:	e8 01 01 00 00       	call   120 <read>
  1f:	89 c3                	mov    %eax,%ebx
  21:	83 c4 10             	add    $0x10,%esp
  24:	85 c0                	test   %eax,%eax
  26:	7e 2b                	jle    53 <cat+0x53>
    if (write(1, buf, n) != n) {
  28:	83 ec 04             	sub    $0x4,%esp
  2b:	53                   	push   %ebx
  2c:	68 20 04 00 00       	push   $0x420
  31:	6a 01                	push   $0x1
  33:	e8 f0 00 00 00       	call   128 <write>
  38:	83 c4 10             	add    $0x10,%esp
  3b:	39 d8                	cmp    %ebx,%eax
  3d:	74 cd                	je     c <cat+0xc>
      printf(1, "cat: write error\n");
  3f:	83 ec 08             	sub    $0x8,%esp
  42:	68 c8 03 00 00       	push   $0x3c8
  47:	6a 01                	push   $0x1
  49:	e8 0b 02 00 00       	call   259 <printf>
      exit();
  4e:	e8 b5 00 00 00       	call   108 <exit>
    }
  }
  if(n < 0){
  53:	78 07                	js     5c <cat+0x5c>
    printf(1, "cat: read error\n");
    exit();
  }
}
  55:	8d 65 f8             	lea    -0x8(%ebp),%esp
  58:	5b                   	pop    %ebx
  59:	5e                   	pop    %esi
  5a:	5d                   	pop    %ebp
  5b:	c3                   	ret    
    printf(1, "cat: read error\n");
  5c:	83 ec 08             	sub    $0x8,%esp
  5f:	68 da 03 00 00       	push   $0x3da
  64:	6a 01                	push   $0x1
  66:	e8 ee 01 00 00       	call   259 <printf>
    exit();
  6b:	e8 98 00 00 00       	call   108 <exit>

00000070 <main>:

int
main(int argc, char *argv[])
{
  70:	f3 0f 1e fb          	endbr32 
  74:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  78:	83 e4 f0             	and    $0xfffffff0,%esp
  7b:	ff 71 fc             	pushl  -0x4(%ecx)
  7e:	55                   	push   %ebp
  7f:	89 e5                	mov    %esp,%ebp
  81:	57                   	push   %edi
  82:	56                   	push   %esi
  83:	53                   	push   %ebx
  84:	51                   	push   %ecx
  85:	83 ec 18             	sub    $0x18,%esp
  88:	8b 01                	mov    (%ecx),%eax
  8a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8d:	8b 51 04             	mov    0x4(%ecx),%edx
  90:	89 55 e0             	mov    %edx,-0x20(%ebp)
  int fd, i;

  if(argc <= 1){
  93:	83 f8 01             	cmp    $0x1,%eax
  96:	7e 3e                	jle    d6 <main+0x66>
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
  98:	be 01 00 00 00       	mov    $0x1,%esi
  9d:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  a0:	7d 59                	jge    fb <main+0x8b>
    if((fd = open(argv[i], 0)) < 0){
  a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  a5:	8d 3c b0             	lea    (%eax,%esi,4),%edi
  a8:	83 ec 08             	sub    $0x8,%esp
  ab:	6a 00                	push   $0x0
  ad:	ff 37                	pushl  (%edi)
  af:	e8 94 00 00 00       	call   148 <open>
  b4:	89 c3                	mov    %eax,%ebx
  b6:	83 c4 10             	add    $0x10,%esp
  b9:	85 c0                	test   %eax,%eax
  bb:	78 28                	js     e5 <main+0x75>
      printf(1, "cat: cannot open %s\n", argv[i]);
      exit();
    }
    cat(fd);
  bd:	83 ec 0c             	sub    $0xc,%esp
  c0:	50                   	push   %eax
  c1:	e8 3a ff ff ff       	call   0 <cat>
    close(fd);
  c6:	89 1c 24             	mov    %ebx,(%esp)
  c9:	e8 62 00 00 00       	call   130 <close>
  for(i = 1; i < argc; i++){
  ce:	83 c6 01             	add    $0x1,%esi
  d1:	83 c4 10             	add    $0x10,%esp
  d4:	eb c7                	jmp    9d <main+0x2d>
    cat(0);
  d6:	83 ec 0c             	sub    $0xc,%esp
  d9:	6a 00                	push   $0x0
  db:	e8 20 ff ff ff       	call   0 <cat>
    exit();
  e0:	e8 23 00 00 00       	call   108 <exit>
      printf(1, "cat: cannot open %s\n", argv[i]);
  e5:	83 ec 04             	sub    $0x4,%esp
  e8:	ff 37                	pushl  (%edi)
  ea:	68 eb 03 00 00       	push   $0x3eb
  ef:	6a 01                	push   $0x1
  f1:	e8 63 01 00 00       	call   259 <printf>
      exit();
  f6:	e8 0d 00 00 00       	call   108 <exit>
  }
  exit();
  fb:	e8 08 00 00 00       	call   108 <exit>

00000100 <fork>:
 100:	b8 01 00 00 00       	mov    $0x1,%eax
 105:	cd 40                	int    $0x40
 107:	c3                   	ret    

00000108 <exit>:
 108:	b8 02 00 00 00       	mov    $0x2,%eax
 10d:	cd 40                	int    $0x40
 10f:	c3                   	ret    

00000110 <wait>:
 110:	b8 03 00 00 00       	mov    $0x3,%eax
 115:	cd 40                	int    $0x40
 117:	c3                   	ret    

00000118 <pipe>:
 118:	b8 04 00 00 00       	mov    $0x4,%eax
 11d:	cd 40                	int    $0x40
 11f:	c3                   	ret    

00000120 <read>:
 120:	b8 05 00 00 00       	mov    $0x5,%eax
 125:	cd 40                	int    $0x40
 127:	c3                   	ret    

00000128 <write>:
 128:	b8 10 00 00 00       	mov    $0x10,%eax
 12d:	cd 40                	int    $0x40
 12f:	c3                   	ret    

00000130 <close>:
 130:	b8 15 00 00 00       	mov    $0x15,%eax
 135:	cd 40                	int    $0x40
 137:	c3                   	ret    

00000138 <kill>:
 138:	b8 06 00 00 00       	mov    $0x6,%eax
 13d:	cd 40                	int    $0x40
 13f:	c3                   	ret    

00000140 <exec>:
 140:	b8 07 00 00 00       	mov    $0x7,%eax
 145:	cd 40                	int    $0x40
 147:	c3                   	ret    

00000148 <open>:
 148:	b8 0f 00 00 00       	mov    $0xf,%eax
 14d:	cd 40                	int    $0x40
 14f:	c3                   	ret    

00000150 <mknod>:
 150:	b8 11 00 00 00       	mov    $0x11,%eax
 155:	cd 40                	int    $0x40
 157:	c3                   	ret    

00000158 <unlink>:
 158:	b8 12 00 00 00       	mov    $0x12,%eax
 15d:	cd 40                	int    $0x40
 15f:	c3                   	ret    

00000160 <fstat>:
 160:	b8 08 00 00 00       	mov    $0x8,%eax
 165:	cd 40                	int    $0x40
 167:	c3                   	ret    

00000168 <link>:
 168:	b8 13 00 00 00       	mov    $0x13,%eax
 16d:	cd 40                	int    $0x40
 16f:	c3                   	ret    

00000170 <mkdir>:
 170:	b8 14 00 00 00       	mov    $0x14,%eax
 175:	cd 40                	int    $0x40
 177:	c3                   	ret    

00000178 <chdir>:
 178:	b8 09 00 00 00       	mov    $0x9,%eax
 17d:	cd 40                	int    $0x40
 17f:	c3                   	ret    

00000180 <dup>:
 180:	b8 0a 00 00 00       	mov    $0xa,%eax
 185:	cd 40                	int    $0x40
 187:	c3                   	ret    

00000188 <getpid>:
 188:	b8 0b 00 00 00       	mov    $0xb,%eax
 18d:	cd 40                	int    $0x40
 18f:	c3                   	ret    

00000190 <sbrk>:
 190:	b8 0c 00 00 00       	mov    $0xc,%eax
 195:	cd 40                	int    $0x40
 197:	c3                   	ret    

00000198 <sleep>:
 198:	b8 0d 00 00 00       	mov    $0xd,%eax
 19d:	cd 40                	int    $0x40
 19f:	c3                   	ret    

000001a0 <uptime>:
 1a0:	b8 0e 00 00 00       	mov    $0xe,%eax
 1a5:	cd 40                	int    $0x40
 1a7:	c3                   	ret    

000001a8 <yield>:
 1a8:	b8 16 00 00 00       	mov    $0x16,%eax
 1ad:	cd 40                	int    $0x40
 1af:	c3                   	ret    

000001b0 <shutdown>:
 1b0:	b8 17 00 00 00       	mov    $0x17,%eax
 1b5:	cd 40                	int    $0x40
 1b7:	c3                   	ret    

000001b8 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 1b8:	55                   	push   %ebp
 1b9:	89 e5                	mov    %esp,%ebp
 1bb:	83 ec 1c             	sub    $0x1c,%esp
 1be:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 1c1:	6a 01                	push   $0x1
 1c3:	8d 55 f4             	lea    -0xc(%ebp),%edx
 1c6:	52                   	push   %edx
 1c7:	50                   	push   %eax
 1c8:	e8 5b ff ff ff       	call   128 <write>
}
 1cd:	83 c4 10             	add    $0x10,%esp
 1d0:	c9                   	leave  
 1d1:	c3                   	ret    

000001d2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 1d2:	55                   	push   %ebp
 1d3:	89 e5                	mov    %esp,%ebp
 1d5:	57                   	push   %edi
 1d6:	56                   	push   %esi
 1d7:	53                   	push   %ebx
 1d8:	83 ec 2c             	sub    $0x2c,%esp
 1db:	89 45 d0             	mov    %eax,-0x30(%ebp)
 1de:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 1e0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 1e4:	0f 95 c2             	setne  %dl
 1e7:	89 f0                	mov    %esi,%eax
 1e9:	c1 e8 1f             	shr    $0x1f,%eax
 1ec:	84 c2                	test   %al,%dl
 1ee:	74 42                	je     232 <printint+0x60>
    neg = 1;
    x = -xx;
 1f0:	f7 de                	neg    %esi
    neg = 1;
 1f2:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 1f9:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 1fe:	89 f0                	mov    %esi,%eax
 200:	ba 00 00 00 00       	mov    $0x0,%edx
 205:	f7 f1                	div    %ecx
 207:	89 df                	mov    %ebx,%edi
 209:	83 c3 01             	add    $0x1,%ebx
 20c:	0f b6 92 08 04 00 00 	movzbl 0x408(%edx),%edx
 213:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 217:	89 f2                	mov    %esi,%edx
 219:	89 c6                	mov    %eax,%esi
 21b:	39 d1                	cmp    %edx,%ecx
 21d:	76 df                	jbe    1fe <printint+0x2c>
  if(neg)
 21f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 223:	74 2f                	je     254 <printint+0x82>
    buf[i++] = '-';
 225:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 22a:	8d 5f 02             	lea    0x2(%edi),%ebx
 22d:	8b 75 d0             	mov    -0x30(%ebp),%esi
 230:	eb 15                	jmp    247 <printint+0x75>
  neg = 0;
 232:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 239:	eb be                	jmp    1f9 <printint+0x27>

  while(--i >= 0)
    putc(fd, buf[i]);
 23b:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 240:	89 f0                	mov    %esi,%eax
 242:	e8 71 ff ff ff       	call   1b8 <putc>
  while(--i >= 0)
 247:	83 eb 01             	sub    $0x1,%ebx
 24a:	79 ef                	jns    23b <printint+0x69>
}
 24c:	83 c4 2c             	add    $0x2c,%esp
 24f:	5b                   	pop    %ebx
 250:	5e                   	pop    %esi
 251:	5f                   	pop    %edi
 252:	5d                   	pop    %ebp
 253:	c3                   	ret    
 254:	8b 75 d0             	mov    -0x30(%ebp),%esi
 257:	eb ee                	jmp    247 <printint+0x75>

00000259 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 259:	f3 0f 1e fb          	endbr32 
 25d:	55                   	push   %ebp
 25e:	89 e5                	mov    %esp,%ebp
 260:	57                   	push   %edi
 261:	56                   	push   %esi
 262:	53                   	push   %ebx
 263:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 266:	8d 45 10             	lea    0x10(%ebp),%eax
 269:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 26c:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 271:	bb 00 00 00 00       	mov    $0x0,%ebx
 276:	eb 14                	jmp    28c <printf+0x33>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 278:	89 fa                	mov    %edi,%edx
 27a:	8b 45 08             	mov    0x8(%ebp),%eax
 27d:	e8 36 ff ff ff       	call   1b8 <putc>
 282:	eb 05                	jmp    289 <printf+0x30>
      }
    } else if(state == '%'){
 284:	83 fe 25             	cmp    $0x25,%esi
 287:	74 25                	je     2ae <printf+0x55>
  for(i = 0; fmt[i]; i++){
 289:	83 c3 01             	add    $0x1,%ebx
 28c:	8b 45 0c             	mov    0xc(%ebp),%eax
 28f:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 293:	84 c0                	test   %al,%al
 295:	0f 84 23 01 00 00    	je     3be <printf+0x165>
    c = fmt[i] & 0xff;
 29b:	0f be f8             	movsbl %al,%edi
 29e:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 2a1:	85 f6                	test   %esi,%esi
 2a3:	75 df                	jne    284 <printf+0x2b>
      if(c == '%'){
 2a5:	83 f8 25             	cmp    $0x25,%eax
 2a8:	75 ce                	jne    278 <printf+0x1f>
        state = '%';
 2aa:	89 c6                	mov    %eax,%esi
 2ac:	eb db                	jmp    289 <printf+0x30>
      if(c == 'd'){
 2ae:	83 f8 64             	cmp    $0x64,%eax
 2b1:	74 49                	je     2fc <printf+0xa3>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 2b3:	83 f8 78             	cmp    $0x78,%eax
 2b6:	0f 94 c1             	sete   %cl
 2b9:	83 f8 70             	cmp    $0x70,%eax
 2bc:	0f 94 c2             	sete   %dl
 2bf:	08 d1                	or     %dl,%cl
 2c1:	75 63                	jne    326 <printf+0xcd>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 2c3:	83 f8 73             	cmp    $0x73,%eax
 2c6:	0f 84 84 00 00 00    	je     350 <printf+0xf7>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 2cc:	83 f8 63             	cmp    $0x63,%eax
 2cf:	0f 84 b7 00 00 00    	je     38c <printf+0x133>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 2d5:	83 f8 25             	cmp    $0x25,%eax
 2d8:	0f 84 cc 00 00 00    	je     3aa <printf+0x151>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 2de:	ba 25 00 00 00       	mov    $0x25,%edx
 2e3:	8b 45 08             	mov    0x8(%ebp),%eax
 2e6:	e8 cd fe ff ff       	call   1b8 <putc>
        putc(fd, c);
 2eb:	89 fa                	mov    %edi,%edx
 2ed:	8b 45 08             	mov    0x8(%ebp),%eax
 2f0:	e8 c3 fe ff ff       	call   1b8 <putc>
      }
      state = 0;
 2f5:	be 00 00 00 00       	mov    $0x0,%esi
 2fa:	eb 8d                	jmp    289 <printf+0x30>
        printint(fd, *ap, 10, 1);
 2fc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 2ff:	8b 17                	mov    (%edi),%edx
 301:	83 ec 0c             	sub    $0xc,%esp
 304:	6a 01                	push   $0x1
 306:	b9 0a 00 00 00       	mov    $0xa,%ecx
 30b:	8b 45 08             	mov    0x8(%ebp),%eax
 30e:	e8 bf fe ff ff       	call   1d2 <printint>
        ap++;
 313:	83 c7 04             	add    $0x4,%edi
 316:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 319:	83 c4 10             	add    $0x10,%esp
      state = 0;
 31c:	be 00 00 00 00       	mov    $0x0,%esi
 321:	e9 63 ff ff ff       	jmp    289 <printf+0x30>
        printint(fd, *ap, 16, 0);
 326:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 329:	8b 17                	mov    (%edi),%edx
 32b:	83 ec 0c             	sub    $0xc,%esp
 32e:	6a 00                	push   $0x0
 330:	b9 10 00 00 00       	mov    $0x10,%ecx
 335:	8b 45 08             	mov    0x8(%ebp),%eax
 338:	e8 95 fe ff ff       	call   1d2 <printint>
        ap++;
 33d:	83 c7 04             	add    $0x4,%edi
 340:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 343:	83 c4 10             	add    $0x10,%esp
      state = 0;
 346:	be 00 00 00 00       	mov    $0x0,%esi
 34b:	e9 39 ff ff ff       	jmp    289 <printf+0x30>
        s = (char*)*ap;
 350:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 353:	8b 30                	mov    (%eax),%esi
        ap++;
 355:	83 c0 04             	add    $0x4,%eax
 358:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 35b:	85 f6                	test   %esi,%esi
 35d:	75 28                	jne    387 <printf+0x12e>
          s = "(null)";
 35f:	be 00 04 00 00       	mov    $0x400,%esi
 364:	8b 7d 08             	mov    0x8(%ebp),%edi
 367:	eb 0d                	jmp    376 <printf+0x11d>
          putc(fd, *s);
 369:	0f be d2             	movsbl %dl,%edx
 36c:	89 f8                	mov    %edi,%eax
 36e:	e8 45 fe ff ff       	call   1b8 <putc>
          s++;
 373:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 376:	0f b6 16             	movzbl (%esi),%edx
 379:	84 d2                	test   %dl,%dl
 37b:	75 ec                	jne    369 <printf+0x110>
      state = 0;
 37d:	be 00 00 00 00       	mov    $0x0,%esi
 382:	e9 02 ff ff ff       	jmp    289 <printf+0x30>
 387:	8b 7d 08             	mov    0x8(%ebp),%edi
 38a:	eb ea                	jmp    376 <printf+0x11d>
        putc(fd, *ap);
 38c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 38f:	0f be 17             	movsbl (%edi),%edx
 392:	8b 45 08             	mov    0x8(%ebp),%eax
 395:	e8 1e fe ff ff       	call   1b8 <putc>
        ap++;
 39a:	83 c7 04             	add    $0x4,%edi
 39d:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 3a0:	be 00 00 00 00       	mov    $0x0,%esi
 3a5:	e9 df fe ff ff       	jmp    289 <printf+0x30>
        putc(fd, c);
 3aa:	89 fa                	mov    %edi,%edx
 3ac:	8b 45 08             	mov    0x8(%ebp),%eax
 3af:	e8 04 fe ff ff       	call   1b8 <putc>
      state = 0;
 3b4:	be 00 00 00 00       	mov    $0x0,%esi
 3b9:	e9 cb fe ff ff       	jmp    289 <printf+0x30>
    }
  }
}
 3be:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3c1:	5b                   	pop    %ebx
 3c2:	5e                   	pop    %esi
 3c3:	5f                   	pop    %edi
 3c4:	5d                   	pop    %ebp
 3c5:	c3                   	ret    
