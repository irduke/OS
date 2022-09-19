
_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	53                   	push   %ebx
  12:	51                   	push   %ecx
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
  13:	83 ec 08             	sub    $0x8,%esp
  16:	6a 02                	push   $0x2
  18:	68 a8 03 00 00       	push   $0x3a8
  1d:	e8 07 01 00 00       	call   129 <open>
  22:	83 c4 10             	add    $0x10,%esp
  25:	85 c0                	test   %eax,%eax
  27:	78 59                	js     82 <main+0x82>
    mknod("console", 1, 1);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  29:	83 ec 0c             	sub    $0xc,%esp
  2c:	6a 00                	push   $0x0
  2e:	e8 2e 01 00 00       	call   161 <dup>
  dup(0);  // stderr
  33:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  3a:	e8 22 01 00 00       	call   161 <dup>
  3f:	83 c4 10             	add    $0x10,%esp

  for(;;){
    printf(1, "init: starting sh\n");
  42:	83 ec 08             	sub    $0x8,%esp
  45:	68 b0 03 00 00       	push   $0x3b0
  4a:	6a 01                	push   $0x1
  4c:	e8 e9 01 00 00       	call   23a <printf>
    pid = fork();
  51:	e8 8b 00 00 00       	call   e1 <fork>
  56:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
  58:	83 c4 10             	add    $0x10,%esp
  5b:	85 c0                	test   %eax,%eax
  5d:	78 48                	js     a7 <main+0xa7>
      printf(1, "init: fork failed\n");
      exit();
    }
    if(pid == 0){
  5f:	74 5a                	je     bb <main+0xbb>
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
  61:	e8 8b 00 00 00       	call   f1 <wait>
  66:	85 c0                	test   %eax,%eax
  68:	78 d8                	js     42 <main+0x42>
  6a:	39 c3                	cmp    %eax,%ebx
  6c:	74 d4                	je     42 <main+0x42>
      printf(1, "zombie!\n");
  6e:	83 ec 08             	sub    $0x8,%esp
  71:	68 ef 03 00 00       	push   $0x3ef
  76:	6a 01                	push   $0x1
  78:	e8 bd 01 00 00       	call   23a <printf>
  7d:	83 c4 10             	add    $0x10,%esp
  80:	eb df                	jmp    61 <main+0x61>
    mknod("console", 1, 1);
  82:	83 ec 04             	sub    $0x4,%esp
  85:	6a 01                	push   $0x1
  87:	6a 01                	push   $0x1
  89:	68 a8 03 00 00       	push   $0x3a8
  8e:	e8 9e 00 00 00       	call   131 <mknod>
    open("console", O_RDWR);
  93:	83 c4 08             	add    $0x8,%esp
  96:	6a 02                	push   $0x2
  98:	68 a8 03 00 00       	push   $0x3a8
  9d:	e8 87 00 00 00       	call   129 <open>
  a2:	83 c4 10             	add    $0x10,%esp
  a5:	eb 82                	jmp    29 <main+0x29>
      printf(1, "init: fork failed\n");
  a7:	83 ec 08             	sub    $0x8,%esp
  aa:	68 c3 03 00 00       	push   $0x3c3
  af:	6a 01                	push   $0x1
  b1:	e8 84 01 00 00       	call   23a <printf>
      exit();
  b6:	e8 2e 00 00 00       	call   e9 <exit>
      exec("sh", argv);
  bb:	83 ec 08             	sub    $0x8,%esp
  be:	68 14 04 00 00       	push   $0x414
  c3:	68 d6 03 00 00       	push   $0x3d6
  c8:	e8 54 00 00 00       	call   121 <exec>
      printf(1, "init: exec sh failed\n");
  cd:	83 c4 08             	add    $0x8,%esp
  d0:	68 d9 03 00 00       	push   $0x3d9
  d5:	6a 01                	push   $0x1
  d7:	e8 5e 01 00 00       	call   23a <printf>
      exit();
  dc:	e8 08 00 00 00       	call   e9 <exit>

000000e1 <fork>:
  e1:	b8 01 00 00 00       	mov    $0x1,%eax
  e6:	cd 40                	int    $0x40
  e8:	c3                   	ret    

000000e9 <exit>:
  e9:	b8 02 00 00 00       	mov    $0x2,%eax
  ee:	cd 40                	int    $0x40
  f0:	c3                   	ret    

000000f1 <wait>:
  f1:	b8 03 00 00 00       	mov    $0x3,%eax
  f6:	cd 40                	int    $0x40
  f8:	c3                   	ret    

000000f9 <pipe>:
  f9:	b8 04 00 00 00       	mov    $0x4,%eax
  fe:	cd 40                	int    $0x40
 100:	c3                   	ret    

00000101 <read>:
 101:	b8 05 00 00 00       	mov    $0x5,%eax
 106:	cd 40                	int    $0x40
 108:	c3                   	ret    

00000109 <write>:
 109:	b8 10 00 00 00       	mov    $0x10,%eax
 10e:	cd 40                	int    $0x40
 110:	c3                   	ret    

00000111 <close>:
 111:	b8 15 00 00 00       	mov    $0x15,%eax
 116:	cd 40                	int    $0x40
 118:	c3                   	ret    

00000119 <kill>:
 119:	b8 06 00 00 00       	mov    $0x6,%eax
 11e:	cd 40                	int    $0x40
 120:	c3                   	ret    

00000121 <exec>:
 121:	b8 07 00 00 00       	mov    $0x7,%eax
 126:	cd 40                	int    $0x40
 128:	c3                   	ret    

00000129 <open>:
 129:	b8 0f 00 00 00       	mov    $0xf,%eax
 12e:	cd 40                	int    $0x40
 130:	c3                   	ret    

00000131 <mknod>:
 131:	b8 11 00 00 00       	mov    $0x11,%eax
 136:	cd 40                	int    $0x40
 138:	c3                   	ret    

00000139 <unlink>:
 139:	b8 12 00 00 00       	mov    $0x12,%eax
 13e:	cd 40                	int    $0x40
 140:	c3                   	ret    

00000141 <fstat>:
 141:	b8 08 00 00 00       	mov    $0x8,%eax
 146:	cd 40                	int    $0x40
 148:	c3                   	ret    

00000149 <link>:
 149:	b8 13 00 00 00       	mov    $0x13,%eax
 14e:	cd 40                	int    $0x40
 150:	c3                   	ret    

00000151 <mkdir>:
 151:	b8 14 00 00 00       	mov    $0x14,%eax
 156:	cd 40                	int    $0x40
 158:	c3                   	ret    

00000159 <chdir>:
 159:	b8 09 00 00 00       	mov    $0x9,%eax
 15e:	cd 40                	int    $0x40
 160:	c3                   	ret    

00000161 <dup>:
 161:	b8 0a 00 00 00       	mov    $0xa,%eax
 166:	cd 40                	int    $0x40
 168:	c3                   	ret    

00000169 <getpid>:
 169:	b8 0b 00 00 00       	mov    $0xb,%eax
 16e:	cd 40                	int    $0x40
 170:	c3                   	ret    

00000171 <sbrk>:
 171:	b8 0c 00 00 00       	mov    $0xc,%eax
 176:	cd 40                	int    $0x40
 178:	c3                   	ret    

00000179 <sleep>:
 179:	b8 0d 00 00 00       	mov    $0xd,%eax
 17e:	cd 40                	int    $0x40
 180:	c3                   	ret    

00000181 <uptime>:
 181:	b8 0e 00 00 00       	mov    $0xe,%eax
 186:	cd 40                	int    $0x40
 188:	c3                   	ret    

00000189 <yield>:
 189:	b8 16 00 00 00       	mov    $0x16,%eax
 18e:	cd 40                	int    $0x40
 190:	c3                   	ret    

00000191 <shutdown>:
 191:	b8 17 00 00 00       	mov    $0x17,%eax
 196:	cd 40                	int    $0x40
 198:	c3                   	ret    

00000199 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 199:	55                   	push   %ebp
 19a:	89 e5                	mov    %esp,%ebp
 19c:	83 ec 1c             	sub    $0x1c,%esp
 19f:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 1a2:	6a 01                	push   $0x1
 1a4:	8d 55 f4             	lea    -0xc(%ebp),%edx
 1a7:	52                   	push   %edx
 1a8:	50                   	push   %eax
 1a9:	e8 5b ff ff ff       	call   109 <write>
}
 1ae:	83 c4 10             	add    $0x10,%esp
 1b1:	c9                   	leave  
 1b2:	c3                   	ret    

000001b3 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 1b3:	55                   	push   %ebp
 1b4:	89 e5                	mov    %esp,%ebp
 1b6:	57                   	push   %edi
 1b7:	56                   	push   %esi
 1b8:	53                   	push   %ebx
 1b9:	83 ec 2c             	sub    $0x2c,%esp
 1bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
 1bf:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 1c1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 1c5:	0f 95 c2             	setne  %dl
 1c8:	89 f0                	mov    %esi,%eax
 1ca:	c1 e8 1f             	shr    $0x1f,%eax
 1cd:	84 c2                	test   %al,%dl
 1cf:	74 42                	je     213 <printint+0x60>
    neg = 1;
    x = -xx;
 1d1:	f7 de                	neg    %esi
    neg = 1;
 1d3:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 1da:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 1df:	89 f0                	mov    %esi,%eax
 1e1:	ba 00 00 00 00       	mov    $0x0,%edx
 1e6:	f7 f1                	div    %ecx
 1e8:	89 df                	mov    %ebx,%edi
 1ea:	83 c3 01             	add    $0x1,%ebx
 1ed:	0f b6 92 00 04 00 00 	movzbl 0x400(%edx),%edx
 1f4:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 1f8:	89 f2                	mov    %esi,%edx
 1fa:	89 c6                	mov    %eax,%esi
 1fc:	39 d1                	cmp    %edx,%ecx
 1fe:	76 df                	jbe    1df <printint+0x2c>
  if(neg)
 200:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 204:	74 2f                	je     235 <printint+0x82>
    buf[i++] = '-';
 206:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 20b:	8d 5f 02             	lea    0x2(%edi),%ebx
 20e:	8b 75 d0             	mov    -0x30(%ebp),%esi
 211:	eb 15                	jmp    228 <printint+0x75>
  neg = 0;
 213:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 21a:	eb be                	jmp    1da <printint+0x27>

  while(--i >= 0)
    putc(fd, buf[i]);
 21c:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 221:	89 f0                	mov    %esi,%eax
 223:	e8 71 ff ff ff       	call   199 <putc>
  while(--i >= 0)
 228:	83 eb 01             	sub    $0x1,%ebx
 22b:	79 ef                	jns    21c <printint+0x69>
}
 22d:	83 c4 2c             	add    $0x2c,%esp
 230:	5b                   	pop    %ebx
 231:	5e                   	pop    %esi
 232:	5f                   	pop    %edi
 233:	5d                   	pop    %ebp
 234:	c3                   	ret    
 235:	8b 75 d0             	mov    -0x30(%ebp),%esi
 238:	eb ee                	jmp    228 <printint+0x75>

0000023a <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 23a:	f3 0f 1e fb          	endbr32 
 23e:	55                   	push   %ebp
 23f:	89 e5                	mov    %esp,%ebp
 241:	57                   	push   %edi
 242:	56                   	push   %esi
 243:	53                   	push   %ebx
 244:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 247:	8d 45 10             	lea    0x10(%ebp),%eax
 24a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 24d:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 252:	bb 00 00 00 00       	mov    $0x0,%ebx
 257:	eb 14                	jmp    26d <printf+0x33>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 259:	89 fa                	mov    %edi,%edx
 25b:	8b 45 08             	mov    0x8(%ebp),%eax
 25e:	e8 36 ff ff ff       	call   199 <putc>
 263:	eb 05                	jmp    26a <printf+0x30>
      }
    } else if(state == '%'){
 265:	83 fe 25             	cmp    $0x25,%esi
 268:	74 25                	je     28f <printf+0x55>
  for(i = 0; fmt[i]; i++){
 26a:	83 c3 01             	add    $0x1,%ebx
 26d:	8b 45 0c             	mov    0xc(%ebp),%eax
 270:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 274:	84 c0                	test   %al,%al
 276:	0f 84 23 01 00 00    	je     39f <printf+0x165>
    c = fmt[i] & 0xff;
 27c:	0f be f8             	movsbl %al,%edi
 27f:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 282:	85 f6                	test   %esi,%esi
 284:	75 df                	jne    265 <printf+0x2b>
      if(c == '%'){
 286:	83 f8 25             	cmp    $0x25,%eax
 289:	75 ce                	jne    259 <printf+0x1f>
        state = '%';
 28b:	89 c6                	mov    %eax,%esi
 28d:	eb db                	jmp    26a <printf+0x30>
      if(c == 'd'){
 28f:	83 f8 64             	cmp    $0x64,%eax
 292:	74 49                	je     2dd <printf+0xa3>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 294:	83 f8 78             	cmp    $0x78,%eax
 297:	0f 94 c1             	sete   %cl
 29a:	83 f8 70             	cmp    $0x70,%eax
 29d:	0f 94 c2             	sete   %dl
 2a0:	08 d1                	or     %dl,%cl
 2a2:	75 63                	jne    307 <printf+0xcd>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 2a4:	83 f8 73             	cmp    $0x73,%eax
 2a7:	0f 84 84 00 00 00    	je     331 <printf+0xf7>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 2ad:	83 f8 63             	cmp    $0x63,%eax
 2b0:	0f 84 b7 00 00 00    	je     36d <printf+0x133>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 2b6:	83 f8 25             	cmp    $0x25,%eax
 2b9:	0f 84 cc 00 00 00    	je     38b <printf+0x151>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 2bf:	ba 25 00 00 00       	mov    $0x25,%edx
 2c4:	8b 45 08             	mov    0x8(%ebp),%eax
 2c7:	e8 cd fe ff ff       	call   199 <putc>
        putc(fd, c);
 2cc:	89 fa                	mov    %edi,%edx
 2ce:	8b 45 08             	mov    0x8(%ebp),%eax
 2d1:	e8 c3 fe ff ff       	call   199 <putc>
      }
      state = 0;
 2d6:	be 00 00 00 00       	mov    $0x0,%esi
 2db:	eb 8d                	jmp    26a <printf+0x30>
        printint(fd, *ap, 10, 1);
 2dd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 2e0:	8b 17                	mov    (%edi),%edx
 2e2:	83 ec 0c             	sub    $0xc,%esp
 2e5:	6a 01                	push   $0x1
 2e7:	b9 0a 00 00 00       	mov    $0xa,%ecx
 2ec:	8b 45 08             	mov    0x8(%ebp),%eax
 2ef:	e8 bf fe ff ff       	call   1b3 <printint>
        ap++;
 2f4:	83 c7 04             	add    $0x4,%edi
 2f7:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 2fa:	83 c4 10             	add    $0x10,%esp
      state = 0;
 2fd:	be 00 00 00 00       	mov    $0x0,%esi
 302:	e9 63 ff ff ff       	jmp    26a <printf+0x30>
        printint(fd, *ap, 16, 0);
 307:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 30a:	8b 17                	mov    (%edi),%edx
 30c:	83 ec 0c             	sub    $0xc,%esp
 30f:	6a 00                	push   $0x0
 311:	b9 10 00 00 00       	mov    $0x10,%ecx
 316:	8b 45 08             	mov    0x8(%ebp),%eax
 319:	e8 95 fe ff ff       	call   1b3 <printint>
        ap++;
 31e:	83 c7 04             	add    $0x4,%edi
 321:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 324:	83 c4 10             	add    $0x10,%esp
      state = 0;
 327:	be 00 00 00 00       	mov    $0x0,%esi
 32c:	e9 39 ff ff ff       	jmp    26a <printf+0x30>
        s = (char*)*ap;
 331:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 334:	8b 30                	mov    (%eax),%esi
        ap++;
 336:	83 c0 04             	add    $0x4,%eax
 339:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 33c:	85 f6                	test   %esi,%esi
 33e:	75 28                	jne    368 <printf+0x12e>
          s = "(null)";
 340:	be f8 03 00 00       	mov    $0x3f8,%esi
 345:	8b 7d 08             	mov    0x8(%ebp),%edi
 348:	eb 0d                	jmp    357 <printf+0x11d>
          putc(fd, *s);
 34a:	0f be d2             	movsbl %dl,%edx
 34d:	89 f8                	mov    %edi,%eax
 34f:	e8 45 fe ff ff       	call   199 <putc>
          s++;
 354:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 357:	0f b6 16             	movzbl (%esi),%edx
 35a:	84 d2                	test   %dl,%dl
 35c:	75 ec                	jne    34a <printf+0x110>
      state = 0;
 35e:	be 00 00 00 00       	mov    $0x0,%esi
 363:	e9 02 ff ff ff       	jmp    26a <printf+0x30>
 368:	8b 7d 08             	mov    0x8(%ebp),%edi
 36b:	eb ea                	jmp    357 <printf+0x11d>
        putc(fd, *ap);
 36d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 370:	0f be 17             	movsbl (%edi),%edx
 373:	8b 45 08             	mov    0x8(%ebp),%eax
 376:	e8 1e fe ff ff       	call   199 <putc>
        ap++;
 37b:	83 c7 04             	add    $0x4,%edi
 37e:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 381:	be 00 00 00 00       	mov    $0x0,%esi
 386:	e9 df fe ff ff       	jmp    26a <printf+0x30>
        putc(fd, c);
 38b:	89 fa                	mov    %edi,%edx
 38d:	8b 45 08             	mov    0x8(%ebp),%eax
 390:	e8 04 fe ff ff       	call   199 <putc>
      state = 0;
 395:	be 00 00 00 00       	mov    $0x0,%esi
 39a:	e9 cb fe ff ff       	jmp    26a <printf+0x30>
    }
  }
}
 39f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3a2:	5b                   	pop    %ebx
 3a3:	5e                   	pop    %esi
 3a4:	5f                   	pop    %edi
 3a5:	5d                   	pop    %ebp
 3a6:	c3                   	ret    
