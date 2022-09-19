
_stressfs:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "fs.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	56                   	push   %esi
  12:	53                   	push   %ebx
  13:	51                   	push   %ecx
  14:	81 ec 24 02 00 00    	sub    $0x224,%esp
  int fd, i;
  char path[] = "stressfs0";
  1a:	c7 45 de 73 74 72 65 	movl   $0x65727473,-0x22(%ebp)
  21:	c7 45 e2 73 73 66 73 	movl   $0x73667373,-0x1e(%ebp)
  28:	66 c7 45 e6 30 00    	movw   $0x30,-0x1a(%ebp)
  char data[512];

  printf(1, "stressfs starting\n");
  2e:	68 9c 05 00 00       	push   $0x59c
  33:	6a 01                	push   $0x1
  35:	e8 f4 03 00 00       	call   42e <printf>
  memset(data, 'a', sizeof(data));
  3a:	83 c4 0c             	add    $0xc,%esp
  3d:	68 00 02 00 00       	push   $0x200
  42:	6a 61                	push   $0x61
  44:	8d 85 de fd ff ff    	lea    -0x222(%ebp),%eax
  4a:	50                   	push   %eax
  4b:	e8 40 01 00 00       	call   190 <memset>

  for(i = 0; i < 4; i++)
  50:	83 c4 10             	add    $0x10,%esp
  53:	bb 00 00 00 00       	mov    $0x0,%ebx
  58:	83 fb 03             	cmp    $0x3,%ebx
  5b:	7f 0e                	jg     6b <main+0x6b>
    if(fork() > 0)
  5d:	e8 73 02 00 00       	call   2d5 <fork>
  62:	85 c0                	test   %eax,%eax
  64:	7f 05                	jg     6b <main+0x6b>
  for(i = 0; i < 4; i++)
  66:	83 c3 01             	add    $0x1,%ebx
  69:	eb ed                	jmp    58 <main+0x58>
      break;

  printf(1, "write %d\n", i);
  6b:	83 ec 04             	sub    $0x4,%esp
  6e:	53                   	push   %ebx
  6f:	68 af 05 00 00       	push   $0x5af
  74:	6a 01                	push   $0x1
  76:	e8 b3 03 00 00       	call   42e <printf>

  path[8] += i;
  7b:	00 5d e6             	add    %bl,-0x1a(%ebp)
  fd = open(path, O_CREATE | O_RDWR);
  7e:	83 c4 08             	add    $0x8,%esp
  81:	68 02 02 00 00       	push   $0x202
  86:	8d 45 de             	lea    -0x22(%ebp),%eax
  89:	50                   	push   %eax
  8a:	e8 8e 02 00 00       	call   31d <open>
  8f:	89 c6                	mov    %eax,%esi
  for(i = 0; i < 20; i++)
  91:	83 c4 10             	add    $0x10,%esp
  94:	bb 00 00 00 00       	mov    $0x0,%ebx
  99:	eb 1b                	jmp    b6 <main+0xb6>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  9b:	83 ec 04             	sub    $0x4,%esp
  9e:	68 00 02 00 00       	push   $0x200
  a3:	8d 85 de fd ff ff    	lea    -0x222(%ebp),%eax
  a9:	50                   	push   %eax
  aa:	56                   	push   %esi
  ab:	e8 4d 02 00 00       	call   2fd <write>
  for(i = 0; i < 20; i++)
  b0:	83 c3 01             	add    $0x1,%ebx
  b3:	83 c4 10             	add    $0x10,%esp
  b6:	83 fb 13             	cmp    $0x13,%ebx
  b9:	7e e0                	jle    9b <main+0x9b>
  close(fd);
  bb:	83 ec 0c             	sub    $0xc,%esp
  be:	56                   	push   %esi
  bf:	e8 41 02 00 00       	call   305 <close>

  printf(1, "read\n");
  c4:	83 c4 08             	add    $0x8,%esp
  c7:	68 b9 05 00 00       	push   $0x5b9
  cc:	6a 01                	push   $0x1
  ce:	e8 5b 03 00 00       	call   42e <printf>

  fd = open(path, O_RDONLY);
  d3:	83 c4 08             	add    $0x8,%esp
  d6:	6a 00                	push   $0x0
  d8:	8d 45 de             	lea    -0x22(%ebp),%eax
  db:	50                   	push   %eax
  dc:	e8 3c 02 00 00       	call   31d <open>
  e1:	89 c6                	mov    %eax,%esi
  for (i = 0; i < 20; i++)
  e3:	83 c4 10             	add    $0x10,%esp
  e6:	bb 00 00 00 00       	mov    $0x0,%ebx
  eb:	eb 1b                	jmp    108 <main+0x108>
    read(fd, data, sizeof(data));
  ed:	83 ec 04             	sub    $0x4,%esp
  f0:	68 00 02 00 00       	push   $0x200
  f5:	8d 85 de fd ff ff    	lea    -0x222(%ebp),%eax
  fb:	50                   	push   %eax
  fc:	56                   	push   %esi
  fd:	e8 f3 01 00 00       	call   2f5 <read>
  for (i = 0; i < 20; i++)
 102:	83 c3 01             	add    $0x1,%ebx
 105:	83 c4 10             	add    $0x10,%esp
 108:	83 fb 13             	cmp    $0x13,%ebx
 10b:	7e e0                	jle    ed <main+0xed>
  close(fd);
 10d:	83 ec 0c             	sub    $0xc,%esp
 110:	56                   	push   %esi
 111:	e8 ef 01 00 00       	call   305 <close>

  wait();
 116:	e8 ca 01 00 00       	call   2e5 <wait>

  exit();
 11b:	e8 bd 01 00 00       	call   2dd <exit>

00000120 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 120:	f3 0f 1e fb          	endbr32 
 124:	55                   	push   %ebp
 125:	89 e5                	mov    %esp,%ebp
 127:	56                   	push   %esi
 128:	53                   	push   %ebx
 129:	8b 75 08             	mov    0x8(%ebp),%esi
 12c:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 12f:	89 f0                	mov    %esi,%eax
 131:	89 d1                	mov    %edx,%ecx
 133:	83 c2 01             	add    $0x1,%edx
 136:	89 c3                	mov    %eax,%ebx
 138:	83 c0 01             	add    $0x1,%eax
 13b:	0f b6 09             	movzbl (%ecx),%ecx
 13e:	88 0b                	mov    %cl,(%ebx)
 140:	84 c9                	test   %cl,%cl
 142:	75 ed                	jne    131 <strcpy+0x11>
    ;
  return os;
}
 144:	89 f0                	mov    %esi,%eax
 146:	5b                   	pop    %ebx
 147:	5e                   	pop    %esi
 148:	5d                   	pop    %ebp
 149:	c3                   	ret    

0000014a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 14a:	f3 0f 1e fb          	endbr32 
 14e:	55                   	push   %ebp
 14f:	89 e5                	mov    %esp,%ebp
 151:	8b 4d 08             	mov    0x8(%ebp),%ecx
 154:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 157:	0f b6 01             	movzbl (%ecx),%eax
 15a:	84 c0                	test   %al,%al
 15c:	74 0c                	je     16a <strcmp+0x20>
 15e:	3a 02                	cmp    (%edx),%al
 160:	75 08                	jne    16a <strcmp+0x20>
    p++, q++;
 162:	83 c1 01             	add    $0x1,%ecx
 165:	83 c2 01             	add    $0x1,%edx
 168:	eb ed                	jmp    157 <strcmp+0xd>
  return (uchar)*p - (uchar)*q;
 16a:	0f b6 c0             	movzbl %al,%eax
 16d:	0f b6 12             	movzbl (%edx),%edx
 170:	29 d0                	sub    %edx,%eax
}
 172:	5d                   	pop    %ebp
 173:	c3                   	ret    

00000174 <strlen>:

uint
strlen(const char *s)
{
 174:	f3 0f 1e fb          	endbr32 
 178:	55                   	push   %ebp
 179:	89 e5                	mov    %esp,%ebp
 17b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 17e:	b8 00 00 00 00       	mov    $0x0,%eax
 183:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
 187:	74 05                	je     18e <strlen+0x1a>
 189:	83 c0 01             	add    $0x1,%eax
 18c:	eb f5                	jmp    183 <strlen+0xf>
    ;
  return n;
}
 18e:	5d                   	pop    %ebp
 18f:	c3                   	ret    

00000190 <memset>:

void*
memset(void *dst, int c, uint n)
{
 190:	f3 0f 1e fb          	endbr32 
 194:	55                   	push   %ebp
 195:	89 e5                	mov    %esp,%ebp
 197:	57                   	push   %edi
 198:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 19b:	89 d7                	mov    %edx,%edi
 19d:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1a0:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a3:	fc                   	cld    
 1a4:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1a6:	89 d0                	mov    %edx,%eax
 1a8:	5f                   	pop    %edi
 1a9:	5d                   	pop    %ebp
 1aa:	c3                   	ret    

000001ab <strchr>:

char*
strchr(const char *s, char c)
{
 1ab:	f3 0f 1e fb          	endbr32 
 1af:	55                   	push   %ebp
 1b0:	89 e5                	mov    %esp,%ebp
 1b2:	8b 45 08             	mov    0x8(%ebp),%eax
 1b5:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 1b9:	0f b6 10             	movzbl (%eax),%edx
 1bc:	84 d2                	test   %dl,%dl
 1be:	74 09                	je     1c9 <strchr+0x1e>
    if(*s == c)
 1c0:	38 ca                	cmp    %cl,%dl
 1c2:	74 0a                	je     1ce <strchr+0x23>
  for(; *s; s++)
 1c4:	83 c0 01             	add    $0x1,%eax
 1c7:	eb f0                	jmp    1b9 <strchr+0xe>
      return (char*)s;
  return 0;
 1c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1ce:	5d                   	pop    %ebp
 1cf:	c3                   	ret    

000001d0 <gets>:

char*
gets(char *buf, int max)
{
 1d0:	f3 0f 1e fb          	endbr32 
 1d4:	55                   	push   %ebp
 1d5:	89 e5                	mov    %esp,%ebp
 1d7:	57                   	push   %edi
 1d8:	56                   	push   %esi
 1d9:	53                   	push   %ebx
 1da:	83 ec 1c             	sub    $0x1c,%esp
 1dd:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e0:	bb 00 00 00 00       	mov    $0x0,%ebx
 1e5:	89 de                	mov    %ebx,%esi
 1e7:	83 c3 01             	add    $0x1,%ebx
 1ea:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1ed:	7d 2e                	jge    21d <gets+0x4d>
    cc = read(0, &c, 1);
 1ef:	83 ec 04             	sub    $0x4,%esp
 1f2:	6a 01                	push   $0x1
 1f4:	8d 45 e7             	lea    -0x19(%ebp),%eax
 1f7:	50                   	push   %eax
 1f8:	6a 00                	push   $0x0
 1fa:	e8 f6 00 00 00       	call   2f5 <read>
    if(cc < 1)
 1ff:	83 c4 10             	add    $0x10,%esp
 202:	85 c0                	test   %eax,%eax
 204:	7e 17                	jle    21d <gets+0x4d>
      break;
    buf[i++] = c;
 206:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 20a:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 20d:	3c 0a                	cmp    $0xa,%al
 20f:	0f 94 c2             	sete   %dl
 212:	3c 0d                	cmp    $0xd,%al
 214:	0f 94 c0             	sete   %al
 217:	08 c2                	or     %al,%dl
 219:	74 ca                	je     1e5 <gets+0x15>
    buf[i++] = c;
 21b:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 21d:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 221:	89 f8                	mov    %edi,%eax
 223:	8d 65 f4             	lea    -0xc(%ebp),%esp
 226:	5b                   	pop    %ebx
 227:	5e                   	pop    %esi
 228:	5f                   	pop    %edi
 229:	5d                   	pop    %ebp
 22a:	c3                   	ret    

0000022b <stat>:

int
stat(const char *n, struct stat *st)
{
 22b:	f3 0f 1e fb          	endbr32 
 22f:	55                   	push   %ebp
 230:	89 e5                	mov    %esp,%ebp
 232:	56                   	push   %esi
 233:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 234:	83 ec 08             	sub    $0x8,%esp
 237:	6a 00                	push   $0x0
 239:	ff 75 08             	pushl  0x8(%ebp)
 23c:	e8 dc 00 00 00       	call   31d <open>
  if(fd < 0)
 241:	83 c4 10             	add    $0x10,%esp
 244:	85 c0                	test   %eax,%eax
 246:	78 24                	js     26c <stat+0x41>
 248:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 24a:	83 ec 08             	sub    $0x8,%esp
 24d:	ff 75 0c             	pushl  0xc(%ebp)
 250:	50                   	push   %eax
 251:	e8 df 00 00 00       	call   335 <fstat>
 256:	89 c6                	mov    %eax,%esi
  close(fd);
 258:	89 1c 24             	mov    %ebx,(%esp)
 25b:	e8 a5 00 00 00       	call   305 <close>
  return r;
 260:	83 c4 10             	add    $0x10,%esp
}
 263:	89 f0                	mov    %esi,%eax
 265:	8d 65 f8             	lea    -0x8(%ebp),%esp
 268:	5b                   	pop    %ebx
 269:	5e                   	pop    %esi
 26a:	5d                   	pop    %ebp
 26b:	c3                   	ret    
    return -1;
 26c:	be ff ff ff ff       	mov    $0xffffffff,%esi
 271:	eb f0                	jmp    263 <stat+0x38>

00000273 <atoi>:

int
atoi(const char *s)
{
 273:	f3 0f 1e fb          	endbr32 
 277:	55                   	push   %ebp
 278:	89 e5                	mov    %esp,%ebp
 27a:	53                   	push   %ebx
 27b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 27e:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 283:	0f b6 01             	movzbl (%ecx),%eax
 286:	8d 58 d0             	lea    -0x30(%eax),%ebx
 289:	80 fb 09             	cmp    $0x9,%bl
 28c:	77 12                	ja     2a0 <atoi+0x2d>
    n = n*10 + *s++ - '0';
 28e:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 291:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 294:	83 c1 01             	add    $0x1,%ecx
 297:	0f be c0             	movsbl %al,%eax
 29a:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
 29e:	eb e3                	jmp    283 <atoi+0x10>
  return n;
}
 2a0:	89 d0                	mov    %edx,%eax
 2a2:	5b                   	pop    %ebx
 2a3:	5d                   	pop    %ebp
 2a4:	c3                   	ret    

000002a5 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2a5:	f3 0f 1e fb          	endbr32 
 2a9:	55                   	push   %ebp
 2aa:	89 e5                	mov    %esp,%ebp
 2ac:	56                   	push   %esi
 2ad:	53                   	push   %ebx
 2ae:	8b 75 08             	mov    0x8(%ebp),%esi
 2b1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 2b4:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 2b7:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 2b9:	8d 58 ff             	lea    -0x1(%eax),%ebx
 2bc:	85 c0                	test   %eax,%eax
 2be:	7e 0f                	jle    2cf <memmove+0x2a>
    *dst++ = *src++;
 2c0:	0f b6 01             	movzbl (%ecx),%eax
 2c3:	88 02                	mov    %al,(%edx)
 2c5:	8d 49 01             	lea    0x1(%ecx),%ecx
 2c8:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 2cb:	89 d8                	mov    %ebx,%eax
 2cd:	eb ea                	jmp    2b9 <memmove+0x14>
  return vdst;
}
 2cf:	89 f0                	mov    %esi,%eax
 2d1:	5b                   	pop    %ebx
 2d2:	5e                   	pop    %esi
 2d3:	5d                   	pop    %ebp
 2d4:	c3                   	ret    

000002d5 <fork>:
 2d5:	b8 01 00 00 00       	mov    $0x1,%eax
 2da:	cd 40                	int    $0x40
 2dc:	c3                   	ret    

000002dd <exit>:
 2dd:	b8 02 00 00 00       	mov    $0x2,%eax
 2e2:	cd 40                	int    $0x40
 2e4:	c3                   	ret    

000002e5 <wait>:
 2e5:	b8 03 00 00 00       	mov    $0x3,%eax
 2ea:	cd 40                	int    $0x40
 2ec:	c3                   	ret    

000002ed <pipe>:
 2ed:	b8 04 00 00 00       	mov    $0x4,%eax
 2f2:	cd 40                	int    $0x40
 2f4:	c3                   	ret    

000002f5 <read>:
 2f5:	b8 05 00 00 00       	mov    $0x5,%eax
 2fa:	cd 40                	int    $0x40
 2fc:	c3                   	ret    

000002fd <write>:
 2fd:	b8 10 00 00 00       	mov    $0x10,%eax
 302:	cd 40                	int    $0x40
 304:	c3                   	ret    

00000305 <close>:
 305:	b8 15 00 00 00       	mov    $0x15,%eax
 30a:	cd 40                	int    $0x40
 30c:	c3                   	ret    

0000030d <kill>:
 30d:	b8 06 00 00 00       	mov    $0x6,%eax
 312:	cd 40                	int    $0x40
 314:	c3                   	ret    

00000315 <exec>:
 315:	b8 07 00 00 00       	mov    $0x7,%eax
 31a:	cd 40                	int    $0x40
 31c:	c3                   	ret    

0000031d <open>:
 31d:	b8 0f 00 00 00       	mov    $0xf,%eax
 322:	cd 40                	int    $0x40
 324:	c3                   	ret    

00000325 <mknod>:
 325:	b8 11 00 00 00       	mov    $0x11,%eax
 32a:	cd 40                	int    $0x40
 32c:	c3                   	ret    

0000032d <unlink>:
 32d:	b8 12 00 00 00       	mov    $0x12,%eax
 332:	cd 40                	int    $0x40
 334:	c3                   	ret    

00000335 <fstat>:
 335:	b8 08 00 00 00       	mov    $0x8,%eax
 33a:	cd 40                	int    $0x40
 33c:	c3                   	ret    

0000033d <link>:
 33d:	b8 13 00 00 00       	mov    $0x13,%eax
 342:	cd 40                	int    $0x40
 344:	c3                   	ret    

00000345 <mkdir>:
 345:	b8 14 00 00 00       	mov    $0x14,%eax
 34a:	cd 40                	int    $0x40
 34c:	c3                   	ret    

0000034d <chdir>:
 34d:	b8 09 00 00 00       	mov    $0x9,%eax
 352:	cd 40                	int    $0x40
 354:	c3                   	ret    

00000355 <dup>:
 355:	b8 0a 00 00 00       	mov    $0xa,%eax
 35a:	cd 40                	int    $0x40
 35c:	c3                   	ret    

0000035d <getpid>:
 35d:	b8 0b 00 00 00       	mov    $0xb,%eax
 362:	cd 40                	int    $0x40
 364:	c3                   	ret    

00000365 <sbrk>:
 365:	b8 0c 00 00 00       	mov    $0xc,%eax
 36a:	cd 40                	int    $0x40
 36c:	c3                   	ret    

0000036d <sleep>:
 36d:	b8 0d 00 00 00       	mov    $0xd,%eax
 372:	cd 40                	int    $0x40
 374:	c3                   	ret    

00000375 <uptime>:
 375:	b8 0e 00 00 00       	mov    $0xe,%eax
 37a:	cd 40                	int    $0x40
 37c:	c3                   	ret    

0000037d <yield>:
 37d:	b8 16 00 00 00       	mov    $0x16,%eax
 382:	cd 40                	int    $0x40
 384:	c3                   	ret    

00000385 <shutdown>:
 385:	b8 17 00 00 00       	mov    $0x17,%eax
 38a:	cd 40                	int    $0x40
 38c:	c3                   	ret    

0000038d <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 38d:	55                   	push   %ebp
 38e:	89 e5                	mov    %esp,%ebp
 390:	83 ec 1c             	sub    $0x1c,%esp
 393:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 396:	6a 01                	push   $0x1
 398:	8d 55 f4             	lea    -0xc(%ebp),%edx
 39b:	52                   	push   %edx
 39c:	50                   	push   %eax
 39d:	e8 5b ff ff ff       	call   2fd <write>
}
 3a2:	83 c4 10             	add    $0x10,%esp
 3a5:	c9                   	leave  
 3a6:	c3                   	ret    

000003a7 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3a7:	55                   	push   %ebp
 3a8:	89 e5                	mov    %esp,%ebp
 3aa:	57                   	push   %edi
 3ab:	56                   	push   %esi
 3ac:	53                   	push   %ebx
 3ad:	83 ec 2c             	sub    $0x2c,%esp
 3b0:	89 45 d0             	mov    %eax,-0x30(%ebp)
 3b3:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3b5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 3b9:	0f 95 c2             	setne  %dl
 3bc:	89 f0                	mov    %esi,%eax
 3be:	c1 e8 1f             	shr    $0x1f,%eax
 3c1:	84 c2                	test   %al,%dl
 3c3:	74 42                	je     407 <printint+0x60>
    neg = 1;
    x = -xx;
 3c5:	f7 de                	neg    %esi
    neg = 1;
 3c7:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 3ce:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 3d3:	89 f0                	mov    %esi,%eax
 3d5:	ba 00 00 00 00       	mov    $0x0,%edx
 3da:	f7 f1                	div    %ecx
 3dc:	89 df                	mov    %ebx,%edi
 3de:	83 c3 01             	add    $0x1,%ebx
 3e1:	0f b6 92 c8 05 00 00 	movzbl 0x5c8(%edx),%edx
 3e8:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 3ec:	89 f2                	mov    %esi,%edx
 3ee:	89 c6                	mov    %eax,%esi
 3f0:	39 d1                	cmp    %edx,%ecx
 3f2:	76 df                	jbe    3d3 <printint+0x2c>
  if(neg)
 3f4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 3f8:	74 2f                	je     429 <printint+0x82>
    buf[i++] = '-';
 3fa:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 3ff:	8d 5f 02             	lea    0x2(%edi),%ebx
 402:	8b 75 d0             	mov    -0x30(%ebp),%esi
 405:	eb 15                	jmp    41c <printint+0x75>
  neg = 0;
 407:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 40e:	eb be                	jmp    3ce <printint+0x27>

  while(--i >= 0)
    putc(fd, buf[i]);
 410:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 415:	89 f0                	mov    %esi,%eax
 417:	e8 71 ff ff ff       	call   38d <putc>
  while(--i >= 0)
 41c:	83 eb 01             	sub    $0x1,%ebx
 41f:	79 ef                	jns    410 <printint+0x69>
}
 421:	83 c4 2c             	add    $0x2c,%esp
 424:	5b                   	pop    %ebx
 425:	5e                   	pop    %esi
 426:	5f                   	pop    %edi
 427:	5d                   	pop    %ebp
 428:	c3                   	ret    
 429:	8b 75 d0             	mov    -0x30(%ebp),%esi
 42c:	eb ee                	jmp    41c <printint+0x75>

0000042e <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 42e:	f3 0f 1e fb          	endbr32 
 432:	55                   	push   %ebp
 433:	89 e5                	mov    %esp,%ebp
 435:	57                   	push   %edi
 436:	56                   	push   %esi
 437:	53                   	push   %ebx
 438:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 43b:	8d 45 10             	lea    0x10(%ebp),%eax
 43e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 441:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 446:	bb 00 00 00 00       	mov    $0x0,%ebx
 44b:	eb 14                	jmp    461 <printf+0x33>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 44d:	89 fa                	mov    %edi,%edx
 44f:	8b 45 08             	mov    0x8(%ebp),%eax
 452:	e8 36 ff ff ff       	call   38d <putc>
 457:	eb 05                	jmp    45e <printf+0x30>
      }
    } else if(state == '%'){
 459:	83 fe 25             	cmp    $0x25,%esi
 45c:	74 25                	je     483 <printf+0x55>
  for(i = 0; fmt[i]; i++){
 45e:	83 c3 01             	add    $0x1,%ebx
 461:	8b 45 0c             	mov    0xc(%ebp),%eax
 464:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 468:	84 c0                	test   %al,%al
 46a:	0f 84 23 01 00 00    	je     593 <printf+0x165>
    c = fmt[i] & 0xff;
 470:	0f be f8             	movsbl %al,%edi
 473:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 476:	85 f6                	test   %esi,%esi
 478:	75 df                	jne    459 <printf+0x2b>
      if(c == '%'){
 47a:	83 f8 25             	cmp    $0x25,%eax
 47d:	75 ce                	jne    44d <printf+0x1f>
        state = '%';
 47f:	89 c6                	mov    %eax,%esi
 481:	eb db                	jmp    45e <printf+0x30>
      if(c == 'd'){
 483:	83 f8 64             	cmp    $0x64,%eax
 486:	74 49                	je     4d1 <printf+0xa3>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 488:	83 f8 78             	cmp    $0x78,%eax
 48b:	0f 94 c1             	sete   %cl
 48e:	83 f8 70             	cmp    $0x70,%eax
 491:	0f 94 c2             	sete   %dl
 494:	08 d1                	or     %dl,%cl
 496:	75 63                	jne    4fb <printf+0xcd>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 498:	83 f8 73             	cmp    $0x73,%eax
 49b:	0f 84 84 00 00 00    	je     525 <printf+0xf7>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4a1:	83 f8 63             	cmp    $0x63,%eax
 4a4:	0f 84 b7 00 00 00    	je     561 <printf+0x133>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 4aa:	83 f8 25             	cmp    $0x25,%eax
 4ad:	0f 84 cc 00 00 00    	je     57f <printf+0x151>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 4b3:	ba 25 00 00 00       	mov    $0x25,%edx
 4b8:	8b 45 08             	mov    0x8(%ebp),%eax
 4bb:	e8 cd fe ff ff       	call   38d <putc>
        putc(fd, c);
 4c0:	89 fa                	mov    %edi,%edx
 4c2:	8b 45 08             	mov    0x8(%ebp),%eax
 4c5:	e8 c3 fe ff ff       	call   38d <putc>
      }
      state = 0;
 4ca:	be 00 00 00 00       	mov    $0x0,%esi
 4cf:	eb 8d                	jmp    45e <printf+0x30>
        printint(fd, *ap, 10, 1);
 4d1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4d4:	8b 17                	mov    (%edi),%edx
 4d6:	83 ec 0c             	sub    $0xc,%esp
 4d9:	6a 01                	push   $0x1
 4db:	b9 0a 00 00 00       	mov    $0xa,%ecx
 4e0:	8b 45 08             	mov    0x8(%ebp),%eax
 4e3:	e8 bf fe ff ff       	call   3a7 <printint>
        ap++;
 4e8:	83 c7 04             	add    $0x4,%edi
 4eb:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 4ee:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4f1:	be 00 00 00 00       	mov    $0x0,%esi
 4f6:	e9 63 ff ff ff       	jmp    45e <printf+0x30>
        printint(fd, *ap, 16, 0);
 4fb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4fe:	8b 17                	mov    (%edi),%edx
 500:	83 ec 0c             	sub    $0xc,%esp
 503:	6a 00                	push   $0x0
 505:	b9 10 00 00 00       	mov    $0x10,%ecx
 50a:	8b 45 08             	mov    0x8(%ebp),%eax
 50d:	e8 95 fe ff ff       	call   3a7 <printint>
        ap++;
 512:	83 c7 04             	add    $0x4,%edi
 515:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 518:	83 c4 10             	add    $0x10,%esp
      state = 0;
 51b:	be 00 00 00 00       	mov    $0x0,%esi
 520:	e9 39 ff ff ff       	jmp    45e <printf+0x30>
        s = (char*)*ap;
 525:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 528:	8b 30                	mov    (%eax),%esi
        ap++;
 52a:	83 c0 04             	add    $0x4,%eax
 52d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 530:	85 f6                	test   %esi,%esi
 532:	75 28                	jne    55c <printf+0x12e>
          s = "(null)";
 534:	be bf 05 00 00       	mov    $0x5bf,%esi
 539:	8b 7d 08             	mov    0x8(%ebp),%edi
 53c:	eb 0d                	jmp    54b <printf+0x11d>
          putc(fd, *s);
 53e:	0f be d2             	movsbl %dl,%edx
 541:	89 f8                	mov    %edi,%eax
 543:	e8 45 fe ff ff       	call   38d <putc>
          s++;
 548:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 54b:	0f b6 16             	movzbl (%esi),%edx
 54e:	84 d2                	test   %dl,%dl
 550:	75 ec                	jne    53e <printf+0x110>
      state = 0;
 552:	be 00 00 00 00       	mov    $0x0,%esi
 557:	e9 02 ff ff ff       	jmp    45e <printf+0x30>
 55c:	8b 7d 08             	mov    0x8(%ebp),%edi
 55f:	eb ea                	jmp    54b <printf+0x11d>
        putc(fd, *ap);
 561:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 564:	0f be 17             	movsbl (%edi),%edx
 567:	8b 45 08             	mov    0x8(%ebp),%eax
 56a:	e8 1e fe ff ff       	call   38d <putc>
        ap++;
 56f:	83 c7 04             	add    $0x4,%edi
 572:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 575:	be 00 00 00 00       	mov    $0x0,%esi
 57a:	e9 df fe ff ff       	jmp    45e <printf+0x30>
        putc(fd, c);
 57f:	89 fa                	mov    %edi,%edx
 581:	8b 45 08             	mov    0x8(%ebp),%eax
 584:	e8 04 fe ff ff       	call   38d <putc>
      state = 0;
 589:	be 00 00 00 00       	mov    $0x0,%esi
 58e:	e9 cb fe ff ff       	jmp    45e <printf+0x30>
    }
  }
}
 593:	8d 65 f4             	lea    -0xc(%ebp),%esp
 596:	5b                   	pop    %ebx
 597:	5e                   	pop    %esi
 598:	5f                   	pop    %edi
 599:	5d                   	pop    %ebp
 59a:	c3                   	ret    
