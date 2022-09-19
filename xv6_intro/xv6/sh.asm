
_sh:     file format elf32-i386


Disassembly of section .text:

00000000 <getcmd>:
  exit();
}

int
getcmd(char *buf, int nbuf)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	55                   	push   %ebp
   5:	89 e5                	mov    %esp,%ebp
   7:	56                   	push   %esi
   8:	53                   	push   %ebx
   9:	8b 5d 08             	mov    0x8(%ebp),%ebx
   c:	8b 75 0c             	mov    0xc(%ebp),%esi
  printf(2, "$ ");
   f:	83 ec 08             	sub    $0x8,%esp
  12:	68 cc 0f 00 00       	push   $0xfcc
  17:	6a 02                	push   $0x2
  19:	e8 f1 0c 00 00       	call   d0f <printf>
  memset(buf, 0, nbuf);
  1e:	83 c4 0c             	add    $0xc,%esp
  21:	56                   	push   %esi
  22:	6a 00                	push   $0x0
  24:	53                   	push   %ebx
  25:	e8 47 0a 00 00       	call   a71 <memset>
  gets(buf, nbuf);
  2a:	83 c4 08             	add    $0x8,%esp
  2d:	56                   	push   %esi
  2e:	53                   	push   %ebx
  2f:	e8 7d 0a 00 00       	call   ab1 <gets>
  if(buf[0] == 0) // EOF
  34:	83 c4 10             	add    $0x10,%esp
  37:	80 3b 00             	cmpb   $0x0,(%ebx)
  3a:	74 0c                	je     48 <getcmd+0x48>
    return -1;
  return 0;
  3c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  41:	8d 65 f8             	lea    -0x8(%ebp),%esp
  44:	5b                   	pop    %ebx
  45:	5e                   	pop    %esi
  46:	5d                   	pop    %ebp
  47:	c3                   	ret    
    return -1;
  48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  4d:	eb f2                	jmp    41 <getcmd+0x41>

0000004f <panic>:
  exit();
}

void
panic(char *s)
{
  4f:	f3 0f 1e fb          	endbr32 
  53:	55                   	push   %ebp
  54:	89 e5                	mov    %esp,%ebp
  56:	83 ec 0c             	sub    $0xc,%esp
  printf(2, "%s\n", s);
  59:	ff 75 08             	pushl  0x8(%ebp)
  5c:	68 69 10 00 00       	push   $0x1069
  61:	6a 02                	push   $0x2
  63:	e8 a7 0c 00 00       	call   d0f <printf>
  exit();
  68:	e8 51 0b 00 00       	call   bbe <exit>

0000006d <fork1>:
}

int
fork1(void)
{
  6d:	f3 0f 1e fb          	endbr32 
  71:	55                   	push   %ebp
  72:	89 e5                	mov    %esp,%ebp
  74:	83 ec 08             	sub    $0x8,%esp
  int pid;

  pid = fork();
  77:	e8 3a 0b 00 00       	call   bb6 <fork>
  if(pid == -1)
  7c:	83 f8 ff             	cmp    $0xffffffff,%eax
  7f:	74 02                	je     83 <fork1+0x16>
    panic("fork");
  return pid;
}
  81:	c9                   	leave  
  82:	c3                   	ret    
    panic("fork");
  83:	83 ec 0c             	sub    $0xc,%esp
  86:	68 cf 0f 00 00       	push   $0xfcf
  8b:	e8 bf ff ff ff       	call   4f <panic>

00000090 <runcmd>:
{
  90:	f3 0f 1e fb          	endbr32 
  94:	55                   	push   %ebp
  95:	89 e5                	mov    %esp,%ebp
  97:	53                   	push   %ebx
  98:	83 ec 14             	sub    $0x14,%esp
  9b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(cmd == 0)
  9e:	85 db                	test   %ebx,%ebx
  a0:	74 0f                	je     b1 <runcmd+0x21>
  switch(cmd->type){
  a2:	8b 03                	mov    (%ebx),%eax
  a4:	83 f8 05             	cmp    $0x5,%eax
  a7:	77 0d                	ja     b6 <runcmd+0x26>
  a9:	3e ff 24 85 84 10 00 	notrack jmp *0x1084(,%eax,4)
  b0:	00 
    exit();
  b1:	e8 08 0b 00 00       	call   bbe <exit>
    panic("runcmd");
  b6:	83 ec 0c             	sub    $0xc,%esp
  b9:	68 d4 0f 00 00       	push   $0xfd4
  be:	e8 8c ff ff ff       	call   4f <panic>
    if(ecmd->argv[0] == 0)
  c3:	8b 43 04             	mov    0x4(%ebx),%eax
  c6:	85 c0                	test   %eax,%eax
  c8:	74 27                	je     f1 <runcmd+0x61>
    exec(ecmd->argv[0], ecmd->argv);
  ca:	8d 53 04             	lea    0x4(%ebx),%edx
  cd:	83 ec 08             	sub    $0x8,%esp
  d0:	52                   	push   %edx
  d1:	50                   	push   %eax
  d2:	e8 1f 0b 00 00       	call   bf6 <exec>
    printf(2, "exec %s failed\n", ecmd->argv[0]);
  d7:	83 c4 0c             	add    $0xc,%esp
  da:	ff 73 04             	pushl  0x4(%ebx)
  dd:	68 db 0f 00 00       	push   $0xfdb
  e2:	6a 02                	push   $0x2
  e4:	e8 26 0c 00 00       	call   d0f <printf>
    break;
  e9:	83 c4 10             	add    $0x10,%esp
  exit();
  ec:	e8 cd 0a 00 00       	call   bbe <exit>
      exit();
  f1:	e8 c8 0a 00 00       	call   bbe <exit>
    close(rcmd->fd);
  f6:	83 ec 0c             	sub    $0xc,%esp
  f9:	ff 73 14             	pushl  0x14(%ebx)
  fc:	e8 e5 0a 00 00       	call   be6 <close>
    if(open(rcmd->file, rcmd->mode) < 0){
 101:	83 c4 08             	add    $0x8,%esp
 104:	ff 73 10             	pushl  0x10(%ebx)
 107:	ff 73 08             	pushl  0x8(%ebx)
 10a:	e8 ef 0a 00 00       	call   bfe <open>
 10f:	83 c4 10             	add    $0x10,%esp
 112:	85 c0                	test   %eax,%eax
 114:	78 0b                	js     121 <runcmd+0x91>
    runcmd(rcmd->cmd);
 116:	83 ec 0c             	sub    $0xc,%esp
 119:	ff 73 04             	pushl  0x4(%ebx)
 11c:	e8 6f ff ff ff       	call   90 <runcmd>
      printf(2, "open %s failed\n", rcmd->file);
 121:	83 ec 04             	sub    $0x4,%esp
 124:	ff 73 08             	pushl  0x8(%ebx)
 127:	68 eb 0f 00 00       	push   $0xfeb
 12c:	6a 02                	push   $0x2
 12e:	e8 dc 0b 00 00       	call   d0f <printf>
      exit();
 133:	e8 86 0a 00 00       	call   bbe <exit>
    if(fork1() == 0)
 138:	e8 30 ff ff ff       	call   6d <fork1>
 13d:	85 c0                	test   %eax,%eax
 13f:	74 10                	je     151 <runcmd+0xc1>
    wait();
 141:	e8 80 0a 00 00       	call   bc6 <wait>
    runcmd(lcmd->right);
 146:	83 ec 0c             	sub    $0xc,%esp
 149:	ff 73 08             	pushl  0x8(%ebx)
 14c:	e8 3f ff ff ff       	call   90 <runcmd>
      runcmd(lcmd->left);
 151:	83 ec 0c             	sub    $0xc,%esp
 154:	ff 73 04             	pushl  0x4(%ebx)
 157:	e8 34 ff ff ff       	call   90 <runcmd>
    if(pipe(p) < 0)
 15c:	83 ec 0c             	sub    $0xc,%esp
 15f:	8d 45 f0             	lea    -0x10(%ebp),%eax
 162:	50                   	push   %eax
 163:	e8 66 0a 00 00       	call   bce <pipe>
 168:	83 c4 10             	add    $0x10,%esp
 16b:	85 c0                	test   %eax,%eax
 16d:	78 3a                	js     1a9 <runcmd+0x119>
    if(fork1() == 0){
 16f:	e8 f9 fe ff ff       	call   6d <fork1>
 174:	85 c0                	test   %eax,%eax
 176:	74 3e                	je     1b6 <runcmd+0x126>
    if(fork1() == 0){
 178:	e8 f0 fe ff ff       	call   6d <fork1>
 17d:	85 c0                	test   %eax,%eax
 17f:	74 6b                	je     1ec <runcmd+0x15c>
    close(p[0]);
 181:	83 ec 0c             	sub    $0xc,%esp
 184:	ff 75 f0             	pushl  -0x10(%ebp)
 187:	e8 5a 0a 00 00       	call   be6 <close>
    close(p[1]);
 18c:	83 c4 04             	add    $0x4,%esp
 18f:	ff 75 f4             	pushl  -0xc(%ebp)
 192:	e8 4f 0a 00 00       	call   be6 <close>
    wait();
 197:	e8 2a 0a 00 00       	call   bc6 <wait>
    wait();
 19c:	e8 25 0a 00 00       	call   bc6 <wait>
    break;
 1a1:	83 c4 10             	add    $0x10,%esp
 1a4:	e9 43 ff ff ff       	jmp    ec <runcmd+0x5c>
      panic("pipe");
 1a9:	83 ec 0c             	sub    $0xc,%esp
 1ac:	68 fb 0f 00 00       	push   $0xffb
 1b1:	e8 99 fe ff ff       	call   4f <panic>
      close(1);
 1b6:	83 ec 0c             	sub    $0xc,%esp
 1b9:	6a 01                	push   $0x1
 1bb:	e8 26 0a 00 00       	call   be6 <close>
      dup(p[1]);
 1c0:	83 c4 04             	add    $0x4,%esp
 1c3:	ff 75 f4             	pushl  -0xc(%ebp)
 1c6:	e8 6b 0a 00 00       	call   c36 <dup>
      close(p[0]);
 1cb:	83 c4 04             	add    $0x4,%esp
 1ce:	ff 75 f0             	pushl  -0x10(%ebp)
 1d1:	e8 10 0a 00 00       	call   be6 <close>
      close(p[1]);
 1d6:	83 c4 04             	add    $0x4,%esp
 1d9:	ff 75 f4             	pushl  -0xc(%ebp)
 1dc:	e8 05 0a 00 00       	call   be6 <close>
      runcmd(pcmd->left);
 1e1:	83 c4 04             	add    $0x4,%esp
 1e4:	ff 73 04             	pushl  0x4(%ebx)
 1e7:	e8 a4 fe ff ff       	call   90 <runcmd>
      close(0);
 1ec:	83 ec 0c             	sub    $0xc,%esp
 1ef:	6a 00                	push   $0x0
 1f1:	e8 f0 09 00 00       	call   be6 <close>
      dup(p[0]);
 1f6:	83 c4 04             	add    $0x4,%esp
 1f9:	ff 75 f0             	pushl  -0x10(%ebp)
 1fc:	e8 35 0a 00 00       	call   c36 <dup>
      close(p[0]);
 201:	83 c4 04             	add    $0x4,%esp
 204:	ff 75 f0             	pushl  -0x10(%ebp)
 207:	e8 da 09 00 00       	call   be6 <close>
      close(p[1]);
 20c:	83 c4 04             	add    $0x4,%esp
 20f:	ff 75 f4             	pushl  -0xc(%ebp)
 212:	e8 cf 09 00 00       	call   be6 <close>
      runcmd(pcmd->right);
 217:	83 c4 04             	add    $0x4,%esp
 21a:	ff 73 08             	pushl  0x8(%ebx)
 21d:	e8 6e fe ff ff       	call   90 <runcmd>
    if(fork1() == 0)
 222:	e8 46 fe ff ff       	call   6d <fork1>
 227:	85 c0                	test   %eax,%eax
 229:	0f 85 bd fe ff ff    	jne    ec <runcmd+0x5c>
      runcmd(bcmd->cmd);
 22f:	83 ec 0c             	sub    $0xc,%esp
 232:	ff 73 04             	pushl  0x4(%ebx)
 235:	e8 56 fe ff ff       	call   90 <runcmd>

0000023a <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
 23a:	f3 0f 1e fb          	endbr32 
 23e:	55                   	push   %ebp
 23f:	89 e5                	mov    %esp,%ebp
 241:	53                   	push   %ebx
 242:	83 ec 10             	sub    $0x10,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
 245:	68 a4 00 00 00       	push   $0xa4
 24a:	e8 f1 0c 00 00       	call   f40 <malloc>
 24f:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
 251:	83 c4 0c             	add    $0xc,%esp
 254:	68 a4 00 00 00       	push   $0xa4
 259:	6a 00                	push   $0x0
 25b:	50                   	push   %eax
 25c:	e8 10 08 00 00       	call   a71 <memset>
  cmd->type = EXEC;
 261:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  return (struct cmd*)cmd;
}
 267:	89 d8                	mov    %ebx,%eax
 269:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 26c:	c9                   	leave  
 26d:	c3                   	ret    

0000026e <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
 26e:	f3 0f 1e fb          	endbr32 
 272:	55                   	push   %ebp
 273:	89 e5                	mov    %esp,%ebp
 275:	53                   	push   %ebx
 276:	83 ec 10             	sub    $0x10,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
 279:	6a 18                	push   $0x18
 27b:	e8 c0 0c 00 00       	call   f40 <malloc>
 280:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
 282:	83 c4 0c             	add    $0xc,%esp
 285:	6a 18                	push   $0x18
 287:	6a 00                	push   $0x0
 289:	50                   	push   %eax
 28a:	e8 e2 07 00 00       	call   a71 <memset>
  cmd->type = REDIR;
 28f:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  cmd->cmd = subcmd;
 295:	8b 45 08             	mov    0x8(%ebp),%eax
 298:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->file = file;
 29b:	8b 45 0c             	mov    0xc(%ebp),%eax
 29e:	89 43 08             	mov    %eax,0x8(%ebx)
  cmd->efile = efile;
 2a1:	8b 45 10             	mov    0x10(%ebp),%eax
 2a4:	89 43 0c             	mov    %eax,0xc(%ebx)
  cmd->mode = mode;
 2a7:	8b 45 14             	mov    0x14(%ebp),%eax
 2aa:	89 43 10             	mov    %eax,0x10(%ebx)
  cmd->fd = fd;
 2ad:	8b 45 18             	mov    0x18(%ebp),%eax
 2b0:	89 43 14             	mov    %eax,0x14(%ebx)
  return (struct cmd*)cmd;
}
 2b3:	89 d8                	mov    %ebx,%eax
 2b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2b8:	c9                   	leave  
 2b9:	c3                   	ret    

000002ba <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
 2ba:	f3 0f 1e fb          	endbr32 
 2be:	55                   	push   %ebp
 2bf:	89 e5                	mov    %esp,%ebp
 2c1:	53                   	push   %ebx
 2c2:	83 ec 10             	sub    $0x10,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
 2c5:	6a 0c                	push   $0xc
 2c7:	e8 74 0c 00 00       	call   f40 <malloc>
 2cc:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
 2ce:	83 c4 0c             	add    $0xc,%esp
 2d1:	6a 0c                	push   $0xc
 2d3:	6a 00                	push   $0x0
 2d5:	50                   	push   %eax
 2d6:	e8 96 07 00 00       	call   a71 <memset>
  cmd->type = PIPE;
 2db:	c7 03 03 00 00 00    	movl   $0x3,(%ebx)
  cmd->left = left;
 2e1:	8b 45 08             	mov    0x8(%ebp),%eax
 2e4:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
 2e7:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ea:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
 2ed:	89 d8                	mov    %ebx,%eax
 2ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2f2:	c9                   	leave  
 2f3:	c3                   	ret    

000002f4 <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
 2f4:	f3 0f 1e fb          	endbr32 
 2f8:	55                   	push   %ebp
 2f9:	89 e5                	mov    %esp,%ebp
 2fb:	53                   	push   %ebx
 2fc:	83 ec 10             	sub    $0x10,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
 2ff:	6a 0c                	push   $0xc
 301:	e8 3a 0c 00 00       	call   f40 <malloc>
 306:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
 308:	83 c4 0c             	add    $0xc,%esp
 30b:	6a 0c                	push   $0xc
 30d:	6a 00                	push   $0x0
 30f:	50                   	push   %eax
 310:	e8 5c 07 00 00       	call   a71 <memset>
  cmd->type = LIST;
 315:	c7 03 04 00 00 00    	movl   $0x4,(%ebx)
  cmd->left = left;
 31b:	8b 45 08             	mov    0x8(%ebp),%eax
 31e:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
 321:	8b 45 0c             	mov    0xc(%ebp),%eax
 324:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
 327:	89 d8                	mov    %ebx,%eax
 329:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 32c:	c9                   	leave  
 32d:	c3                   	ret    

0000032e <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
 32e:	f3 0f 1e fb          	endbr32 
 332:	55                   	push   %ebp
 333:	89 e5                	mov    %esp,%ebp
 335:	53                   	push   %ebx
 336:	83 ec 10             	sub    $0x10,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
 339:	6a 08                	push   $0x8
 33b:	e8 00 0c 00 00       	call   f40 <malloc>
 340:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
 342:	83 c4 0c             	add    $0xc,%esp
 345:	6a 08                	push   $0x8
 347:	6a 00                	push   $0x0
 349:	50                   	push   %eax
 34a:	e8 22 07 00 00       	call   a71 <memset>
  cmd->type = BACK;
 34f:	c7 03 05 00 00 00    	movl   $0x5,(%ebx)
  cmd->cmd = subcmd;
 355:	8b 45 08             	mov    0x8(%ebp),%eax
 358:	89 43 04             	mov    %eax,0x4(%ebx)
  return (struct cmd*)cmd;
}
 35b:	89 d8                	mov    %ebx,%eax
 35d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 360:	c9                   	leave  
 361:	c3                   	ret    

00000362 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
 362:	f3 0f 1e fb          	endbr32 
 366:	55                   	push   %ebp
 367:	89 e5                	mov    %esp,%ebp
 369:	57                   	push   %edi
 36a:	56                   	push   %esi
 36b:	53                   	push   %ebx
 36c:	83 ec 0c             	sub    $0xc,%esp
 36f:	8b 75 0c             	mov    0xc(%ebp),%esi
 372:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *s;
  int ret;

  s = *ps;
 375:	8b 45 08             	mov    0x8(%ebp),%eax
 378:	8b 18                	mov    (%eax),%ebx
  while(s < es && strchr(whitespace, *s))
 37a:	39 f3                	cmp    %esi,%ebx
 37c:	73 1d                	jae    39b <gettoken+0x39>
 37e:	83 ec 08             	sub    $0x8,%esp
 381:	0f be 03             	movsbl (%ebx),%eax
 384:	50                   	push   %eax
 385:	68 d8 10 00 00       	push   $0x10d8
 38a:	e8 fd 06 00 00       	call   a8c <strchr>
 38f:	83 c4 10             	add    $0x10,%esp
 392:	85 c0                	test   %eax,%eax
 394:	74 05                	je     39b <gettoken+0x39>
    s++;
 396:	83 c3 01             	add    $0x1,%ebx
 399:	eb df                	jmp    37a <gettoken+0x18>
  if(q)
 39b:	85 ff                	test   %edi,%edi
 39d:	74 02                	je     3a1 <gettoken+0x3f>
    *q = s;
 39f:	89 1f                	mov    %ebx,(%edi)
  ret = *s;
 3a1:	0f b6 03             	movzbl (%ebx),%eax
 3a4:	0f be f8             	movsbl %al,%edi
  switch(*s){
 3a7:	3c 3c                	cmp    $0x3c,%al
 3a9:	7f 27                	jg     3d2 <gettoken+0x70>
 3ab:	3c 3b                	cmp    $0x3b,%al
 3ad:	7d 13                	jge    3c2 <gettoken+0x60>
 3af:	84 c0                	test   %al,%al
 3b1:	74 12                	je     3c5 <gettoken+0x63>
 3b3:	78 41                	js     3f6 <gettoken+0x94>
 3b5:	3c 26                	cmp    $0x26,%al
 3b7:	74 09                	je     3c2 <gettoken+0x60>
 3b9:	7c 3b                	jl     3f6 <gettoken+0x94>
 3bb:	83 e8 28             	sub    $0x28,%eax
 3be:	3c 01                	cmp    $0x1,%al
 3c0:	77 34                	ja     3f6 <gettoken+0x94>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
 3c2:	83 c3 01             	add    $0x1,%ebx
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
 3c5:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3c9:	74 77                	je     442 <gettoken+0xe0>
    *eq = s;
 3cb:	8b 45 14             	mov    0x14(%ebp),%eax
 3ce:	89 18                	mov    %ebx,(%eax)
 3d0:	eb 70                	jmp    442 <gettoken+0xe0>
  switch(*s){
 3d2:	3c 3e                	cmp    $0x3e,%al
 3d4:	75 0d                	jne    3e3 <gettoken+0x81>
    s++;
 3d6:	8d 43 01             	lea    0x1(%ebx),%eax
    if(*s == '>'){
 3d9:	80 7b 01 3e          	cmpb   $0x3e,0x1(%ebx)
 3dd:	74 0a                	je     3e9 <gettoken+0x87>
    s++;
 3df:	89 c3                	mov    %eax,%ebx
 3e1:	eb e2                	jmp    3c5 <gettoken+0x63>
  switch(*s){
 3e3:	3c 7c                	cmp    $0x7c,%al
 3e5:	75 0f                	jne    3f6 <gettoken+0x94>
 3e7:	eb d9                	jmp    3c2 <gettoken+0x60>
      s++;
 3e9:	83 c3 02             	add    $0x2,%ebx
      ret = '+';
 3ec:	bf 2b 00 00 00       	mov    $0x2b,%edi
 3f1:	eb d2                	jmp    3c5 <gettoken+0x63>
      s++;
 3f3:	83 c3 01             	add    $0x1,%ebx
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
 3f6:	39 f3                	cmp    %esi,%ebx
 3f8:	73 37                	jae    431 <gettoken+0xcf>
 3fa:	83 ec 08             	sub    $0x8,%esp
 3fd:	0f be 03             	movsbl (%ebx),%eax
 400:	50                   	push   %eax
 401:	68 d8 10 00 00       	push   $0x10d8
 406:	e8 81 06 00 00       	call   a8c <strchr>
 40b:	83 c4 10             	add    $0x10,%esp
 40e:	85 c0                	test   %eax,%eax
 410:	75 26                	jne    438 <gettoken+0xd6>
 412:	83 ec 08             	sub    $0x8,%esp
 415:	0f be 03             	movsbl (%ebx),%eax
 418:	50                   	push   %eax
 419:	68 d0 10 00 00       	push   $0x10d0
 41e:	e8 69 06 00 00       	call   a8c <strchr>
 423:	83 c4 10             	add    $0x10,%esp
 426:	85 c0                	test   %eax,%eax
 428:	74 c9                	je     3f3 <gettoken+0x91>
    ret = 'a';
 42a:	bf 61 00 00 00       	mov    $0x61,%edi
 42f:	eb 94                	jmp    3c5 <gettoken+0x63>
 431:	bf 61 00 00 00       	mov    $0x61,%edi
 436:	eb 8d                	jmp    3c5 <gettoken+0x63>
 438:	bf 61 00 00 00       	mov    $0x61,%edi
 43d:	eb 86                	jmp    3c5 <gettoken+0x63>

  while(s < es && strchr(whitespace, *s))
    s++;
 43f:	83 c3 01             	add    $0x1,%ebx
  while(s < es && strchr(whitespace, *s))
 442:	39 f3                	cmp    %esi,%ebx
 444:	73 18                	jae    45e <gettoken+0xfc>
 446:	83 ec 08             	sub    $0x8,%esp
 449:	0f be 03             	movsbl (%ebx),%eax
 44c:	50                   	push   %eax
 44d:	68 d8 10 00 00       	push   $0x10d8
 452:	e8 35 06 00 00       	call   a8c <strchr>
 457:	83 c4 10             	add    $0x10,%esp
 45a:	85 c0                	test   %eax,%eax
 45c:	75 e1                	jne    43f <gettoken+0xdd>
  *ps = s;
 45e:	8b 45 08             	mov    0x8(%ebp),%eax
 461:	89 18                	mov    %ebx,(%eax)
  return ret;
}
 463:	89 f8                	mov    %edi,%eax
 465:	8d 65 f4             	lea    -0xc(%ebp),%esp
 468:	5b                   	pop    %ebx
 469:	5e                   	pop    %esi
 46a:	5f                   	pop    %edi
 46b:	5d                   	pop    %ebp
 46c:	c3                   	ret    

0000046d <peek>:

int
peek(char **ps, char *es, char *toks)
{
 46d:	f3 0f 1e fb          	endbr32 
 471:	55                   	push   %ebp
 472:	89 e5                	mov    %esp,%ebp
 474:	57                   	push   %edi
 475:	56                   	push   %esi
 476:	53                   	push   %ebx
 477:	83 ec 0c             	sub    $0xc,%esp
 47a:	8b 7d 08             	mov    0x8(%ebp),%edi
 47d:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *s;

  s = *ps;
 480:	8b 1f                	mov    (%edi),%ebx
  while(s < es && strchr(whitespace, *s))
 482:	39 f3                	cmp    %esi,%ebx
 484:	73 1d                	jae    4a3 <peek+0x36>
 486:	83 ec 08             	sub    $0x8,%esp
 489:	0f be 03             	movsbl (%ebx),%eax
 48c:	50                   	push   %eax
 48d:	68 d8 10 00 00       	push   $0x10d8
 492:	e8 f5 05 00 00       	call   a8c <strchr>
 497:	83 c4 10             	add    $0x10,%esp
 49a:	85 c0                	test   %eax,%eax
 49c:	74 05                	je     4a3 <peek+0x36>
    s++;
 49e:	83 c3 01             	add    $0x1,%ebx
 4a1:	eb df                	jmp    482 <peek+0x15>
  *ps = s;
 4a3:	89 1f                	mov    %ebx,(%edi)
  return *s && strchr(toks, *s);
 4a5:	0f b6 03             	movzbl (%ebx),%eax
 4a8:	84 c0                	test   %al,%al
 4aa:	75 0d                	jne    4b9 <peek+0x4c>
 4ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
 4b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4b4:	5b                   	pop    %ebx
 4b5:	5e                   	pop    %esi
 4b6:	5f                   	pop    %edi
 4b7:	5d                   	pop    %ebp
 4b8:	c3                   	ret    
  return *s && strchr(toks, *s);
 4b9:	83 ec 08             	sub    $0x8,%esp
 4bc:	0f be c0             	movsbl %al,%eax
 4bf:	50                   	push   %eax
 4c0:	ff 75 10             	pushl  0x10(%ebp)
 4c3:	e8 c4 05 00 00       	call   a8c <strchr>
 4c8:	83 c4 10             	add    $0x10,%esp
 4cb:	85 c0                	test   %eax,%eax
 4cd:	74 07                	je     4d6 <peek+0x69>
 4cf:	b8 01 00 00 00       	mov    $0x1,%eax
 4d4:	eb db                	jmp    4b1 <peek+0x44>
 4d6:	b8 00 00 00 00       	mov    $0x0,%eax
 4db:	eb d4                	jmp    4b1 <peek+0x44>

000004dd <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
 4dd:	f3 0f 1e fb          	endbr32 
 4e1:	55                   	push   %ebp
 4e2:	89 e5                	mov    %esp,%ebp
 4e4:	57                   	push   %edi
 4e5:	56                   	push   %esi
 4e6:	53                   	push   %ebx
 4e7:	83 ec 1c             	sub    $0x1c,%esp
 4ea:	8b 7d 0c             	mov    0xc(%ebp),%edi
 4ed:	8b 75 10             	mov    0x10(%ebp),%esi
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
 4f0:	eb 28                	jmp    51a <parseredirs+0x3d>
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
      panic("missing file for redirection");
 4f2:	83 ec 0c             	sub    $0xc,%esp
 4f5:	68 00 10 00 00       	push   $0x1000
 4fa:	e8 50 fb ff ff       	call   4f <panic>
    switch(tok){
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
 4ff:	83 ec 0c             	sub    $0xc,%esp
 502:	6a 00                	push   $0x0
 504:	6a 00                	push   $0x0
 506:	ff 75 e0             	pushl  -0x20(%ebp)
 509:	ff 75 e4             	pushl  -0x1c(%ebp)
 50c:	ff 75 08             	pushl  0x8(%ebp)
 50f:	e8 5a fd ff ff       	call   26e <redircmd>
 514:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
 517:	83 c4 20             	add    $0x20,%esp
  while(peek(ps, es, "<>")){
 51a:	83 ec 04             	sub    $0x4,%esp
 51d:	68 1d 10 00 00       	push   $0x101d
 522:	56                   	push   %esi
 523:	57                   	push   %edi
 524:	e8 44 ff ff ff       	call   46d <peek>
 529:	83 c4 10             	add    $0x10,%esp
 52c:	85 c0                	test   %eax,%eax
 52e:	74 76                	je     5a6 <parseredirs+0xc9>
    tok = gettoken(ps, es, 0, 0);
 530:	6a 00                	push   $0x0
 532:	6a 00                	push   $0x0
 534:	56                   	push   %esi
 535:	57                   	push   %edi
 536:	e8 27 fe ff ff       	call   362 <gettoken>
 53b:	89 c3                	mov    %eax,%ebx
    if(gettoken(ps, es, &q, &eq) != 'a')
 53d:	8d 45 e0             	lea    -0x20(%ebp),%eax
 540:	50                   	push   %eax
 541:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 544:	50                   	push   %eax
 545:	56                   	push   %esi
 546:	57                   	push   %edi
 547:	e8 16 fe ff ff       	call   362 <gettoken>
 54c:	83 c4 20             	add    $0x20,%esp
 54f:	83 f8 61             	cmp    $0x61,%eax
 552:	75 9e                	jne    4f2 <parseredirs+0x15>
    switch(tok){
 554:	83 fb 3c             	cmp    $0x3c,%ebx
 557:	74 a6                	je     4ff <parseredirs+0x22>
 559:	83 fb 3e             	cmp    $0x3e,%ebx
 55c:	74 25                	je     583 <parseredirs+0xa6>
 55e:	83 fb 2b             	cmp    $0x2b,%ebx
 561:	75 b7                	jne    51a <parseredirs+0x3d>
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
 563:	83 ec 0c             	sub    $0xc,%esp
 566:	6a 01                	push   $0x1
 568:	68 01 02 00 00       	push   $0x201
 56d:	ff 75 e0             	pushl  -0x20(%ebp)
 570:	ff 75 e4             	pushl  -0x1c(%ebp)
 573:	ff 75 08             	pushl  0x8(%ebp)
 576:	e8 f3 fc ff ff       	call   26e <redircmd>
 57b:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
 57e:	83 c4 20             	add    $0x20,%esp
 581:	eb 97                	jmp    51a <parseredirs+0x3d>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
 583:	83 ec 0c             	sub    $0xc,%esp
 586:	6a 01                	push   $0x1
 588:	68 01 02 00 00       	push   $0x201
 58d:	ff 75 e0             	pushl  -0x20(%ebp)
 590:	ff 75 e4             	pushl  -0x1c(%ebp)
 593:	ff 75 08             	pushl  0x8(%ebp)
 596:	e8 d3 fc ff ff       	call   26e <redircmd>
 59b:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
 59e:	83 c4 20             	add    $0x20,%esp
 5a1:	e9 74 ff ff ff       	jmp    51a <parseredirs+0x3d>
    }
  }
  return cmd;
}
 5a6:	8b 45 08             	mov    0x8(%ebp),%eax
 5a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5ac:	5b                   	pop    %ebx
 5ad:	5e                   	pop    %esi
 5ae:	5f                   	pop    %edi
 5af:	5d                   	pop    %ebp
 5b0:	c3                   	ret    

000005b1 <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
 5b1:	f3 0f 1e fb          	endbr32 
 5b5:	55                   	push   %ebp
 5b6:	89 e5                	mov    %esp,%ebp
 5b8:	57                   	push   %edi
 5b9:	56                   	push   %esi
 5ba:	53                   	push   %ebx
 5bb:	83 ec 30             	sub    $0x30,%esp
 5be:	8b 75 08             	mov    0x8(%ebp),%esi
 5c1:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
 5c4:	68 20 10 00 00       	push   $0x1020
 5c9:	57                   	push   %edi
 5ca:	56                   	push   %esi
 5cb:	e8 9d fe ff ff       	call   46d <peek>
 5d0:	83 c4 10             	add    $0x10,%esp
 5d3:	85 c0                	test   %eax,%eax
 5d5:	75 7a                	jne    651 <parseexec+0xa0>
 5d7:	89 c3                	mov    %eax,%ebx
    return parseblock(ps, es);

  ret = execcmd();
 5d9:	e8 5c fc ff ff       	call   23a <execcmd>
 5de:	89 45 d0             	mov    %eax,-0x30(%ebp)
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
 5e1:	83 ec 04             	sub    $0x4,%esp
 5e4:	57                   	push   %edi
 5e5:	56                   	push   %esi
 5e6:	50                   	push   %eax
 5e7:	e8 f1 fe ff ff       	call   4dd <parseredirs>
 5ec:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  while(!peek(ps, es, "|)&;")){
 5ef:	83 c4 10             	add    $0x10,%esp
 5f2:	83 ec 04             	sub    $0x4,%esp
 5f5:	68 37 10 00 00       	push   $0x1037
 5fa:	57                   	push   %edi
 5fb:	56                   	push   %esi
 5fc:	e8 6c fe ff ff       	call   46d <peek>
 601:	83 c4 10             	add    $0x10,%esp
 604:	85 c0                	test   %eax,%eax
 606:	75 75                	jne    67d <parseexec+0xcc>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
 608:	8d 45 e0             	lea    -0x20(%ebp),%eax
 60b:	50                   	push   %eax
 60c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 60f:	50                   	push   %eax
 610:	57                   	push   %edi
 611:	56                   	push   %esi
 612:	e8 4b fd ff ff       	call   362 <gettoken>
 617:	83 c4 10             	add    $0x10,%esp
 61a:	85 c0                	test   %eax,%eax
 61c:	74 5f                	je     67d <parseexec+0xcc>
      break;
    if(tok != 'a')
 61e:	83 f8 61             	cmp    $0x61,%eax
 621:	75 40                	jne    663 <parseexec+0xb2>
      panic("syntax");
    cmd->argv[argc] = q;
 623:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 626:	8b 55 d0             	mov    -0x30(%ebp),%edx
 629:	89 44 9a 04          	mov    %eax,0x4(%edx,%ebx,4)
    cmd->eargv[argc] = eq;
 62d:	8b 45 e0             	mov    -0x20(%ebp),%eax
 630:	89 44 9a 54          	mov    %eax,0x54(%edx,%ebx,4)
    argc++;
 634:	83 c3 01             	add    $0x1,%ebx
    if(argc >= MAXARGS)
 637:	83 fb 13             	cmp    $0x13,%ebx
 63a:	7f 34                	jg     670 <parseexec+0xbf>
      panic("too many args");
    ret = parseredirs(ret, ps, es);
 63c:	83 ec 04             	sub    $0x4,%esp
 63f:	57                   	push   %edi
 640:	56                   	push   %esi
 641:	ff 75 d4             	pushl  -0x2c(%ebp)
 644:	e8 94 fe ff ff       	call   4dd <parseredirs>
 649:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 64c:	83 c4 10             	add    $0x10,%esp
 64f:	eb a1                	jmp    5f2 <parseexec+0x41>
    return parseblock(ps, es);
 651:	83 ec 08             	sub    $0x8,%esp
 654:	57                   	push   %edi
 655:	56                   	push   %esi
 656:	e8 37 01 00 00       	call   792 <parseblock>
 65b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 65e:	83 c4 10             	add    $0x10,%esp
 661:	eb 2d                	jmp    690 <parseexec+0xdf>
      panic("syntax");
 663:	83 ec 0c             	sub    $0xc,%esp
 666:	68 22 10 00 00       	push   $0x1022
 66b:	e8 df f9 ff ff       	call   4f <panic>
      panic("too many args");
 670:	83 ec 0c             	sub    $0xc,%esp
 673:	68 29 10 00 00       	push   $0x1029
 678:	e8 d2 f9 ff ff       	call   4f <panic>
  }
  cmd->argv[argc] = 0;
 67d:	8b 45 d0             	mov    -0x30(%ebp),%eax
 680:	c7 44 98 04 00 00 00 	movl   $0x0,0x4(%eax,%ebx,4)
 687:	00 
  cmd->eargv[argc] = 0;
 688:	c7 44 98 54 00 00 00 	movl   $0x0,0x54(%eax,%ebx,4)
 68f:	00 
  return ret;
}
 690:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 693:	8d 65 f4             	lea    -0xc(%ebp),%esp
 696:	5b                   	pop    %ebx
 697:	5e                   	pop    %esi
 698:	5f                   	pop    %edi
 699:	5d                   	pop    %ebp
 69a:	c3                   	ret    

0000069b <parsepipe>:
{
 69b:	f3 0f 1e fb          	endbr32 
 69f:	55                   	push   %ebp
 6a0:	89 e5                	mov    %esp,%ebp
 6a2:	57                   	push   %edi
 6a3:	56                   	push   %esi
 6a4:	53                   	push   %ebx
 6a5:	83 ec 14             	sub    $0x14,%esp
 6a8:	8b 75 08             	mov    0x8(%ebp),%esi
 6ab:	8b 7d 0c             	mov    0xc(%ebp),%edi
  cmd = parseexec(ps, es);
 6ae:	57                   	push   %edi
 6af:	56                   	push   %esi
 6b0:	e8 fc fe ff ff       	call   5b1 <parseexec>
 6b5:	89 c3                	mov    %eax,%ebx
  if(peek(ps, es, "|")){
 6b7:	83 c4 0c             	add    $0xc,%esp
 6ba:	68 3c 10 00 00       	push   $0x103c
 6bf:	57                   	push   %edi
 6c0:	56                   	push   %esi
 6c1:	e8 a7 fd ff ff       	call   46d <peek>
 6c6:	83 c4 10             	add    $0x10,%esp
 6c9:	85 c0                	test   %eax,%eax
 6cb:	75 0a                	jne    6d7 <parsepipe+0x3c>
}
 6cd:	89 d8                	mov    %ebx,%eax
 6cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6d2:	5b                   	pop    %ebx
 6d3:	5e                   	pop    %esi
 6d4:	5f                   	pop    %edi
 6d5:	5d                   	pop    %ebp
 6d6:	c3                   	ret    
    gettoken(ps, es, 0, 0);
 6d7:	6a 00                	push   $0x0
 6d9:	6a 00                	push   $0x0
 6db:	57                   	push   %edi
 6dc:	56                   	push   %esi
 6dd:	e8 80 fc ff ff       	call   362 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
 6e2:	83 c4 08             	add    $0x8,%esp
 6e5:	57                   	push   %edi
 6e6:	56                   	push   %esi
 6e7:	e8 af ff ff ff       	call   69b <parsepipe>
 6ec:	83 c4 08             	add    $0x8,%esp
 6ef:	50                   	push   %eax
 6f0:	53                   	push   %ebx
 6f1:	e8 c4 fb ff ff       	call   2ba <pipecmd>
 6f6:	89 c3                	mov    %eax,%ebx
 6f8:	83 c4 10             	add    $0x10,%esp
  return cmd;
 6fb:	eb d0                	jmp    6cd <parsepipe+0x32>

000006fd <parseline>:
{
 6fd:	f3 0f 1e fb          	endbr32 
 701:	55                   	push   %ebp
 702:	89 e5                	mov    %esp,%ebp
 704:	57                   	push   %edi
 705:	56                   	push   %esi
 706:	53                   	push   %ebx
 707:	83 ec 14             	sub    $0x14,%esp
 70a:	8b 75 08             	mov    0x8(%ebp),%esi
 70d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  cmd = parsepipe(ps, es);
 710:	57                   	push   %edi
 711:	56                   	push   %esi
 712:	e8 84 ff ff ff       	call   69b <parsepipe>
 717:	89 c3                	mov    %eax,%ebx
  while(peek(ps, es, "&")){
 719:	83 c4 10             	add    $0x10,%esp
 71c:	83 ec 04             	sub    $0x4,%esp
 71f:	68 3e 10 00 00       	push   $0x103e
 724:	57                   	push   %edi
 725:	56                   	push   %esi
 726:	e8 42 fd ff ff       	call   46d <peek>
 72b:	83 c4 10             	add    $0x10,%esp
 72e:	85 c0                	test   %eax,%eax
 730:	74 1a                	je     74c <parseline+0x4f>
    gettoken(ps, es, 0, 0);
 732:	6a 00                	push   $0x0
 734:	6a 00                	push   $0x0
 736:	57                   	push   %edi
 737:	56                   	push   %esi
 738:	e8 25 fc ff ff       	call   362 <gettoken>
    cmd = backcmd(cmd);
 73d:	89 1c 24             	mov    %ebx,(%esp)
 740:	e8 e9 fb ff ff       	call   32e <backcmd>
 745:	89 c3                	mov    %eax,%ebx
 747:	83 c4 10             	add    $0x10,%esp
 74a:	eb d0                	jmp    71c <parseline+0x1f>
  if(peek(ps, es, ";")){
 74c:	83 ec 04             	sub    $0x4,%esp
 74f:	68 3a 10 00 00       	push   $0x103a
 754:	57                   	push   %edi
 755:	56                   	push   %esi
 756:	e8 12 fd ff ff       	call   46d <peek>
 75b:	83 c4 10             	add    $0x10,%esp
 75e:	85 c0                	test   %eax,%eax
 760:	75 0a                	jne    76c <parseline+0x6f>
}
 762:	89 d8                	mov    %ebx,%eax
 764:	8d 65 f4             	lea    -0xc(%ebp),%esp
 767:	5b                   	pop    %ebx
 768:	5e                   	pop    %esi
 769:	5f                   	pop    %edi
 76a:	5d                   	pop    %ebp
 76b:	c3                   	ret    
    gettoken(ps, es, 0, 0);
 76c:	6a 00                	push   $0x0
 76e:	6a 00                	push   $0x0
 770:	57                   	push   %edi
 771:	56                   	push   %esi
 772:	e8 eb fb ff ff       	call   362 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
 777:	83 c4 08             	add    $0x8,%esp
 77a:	57                   	push   %edi
 77b:	56                   	push   %esi
 77c:	e8 7c ff ff ff       	call   6fd <parseline>
 781:	83 c4 08             	add    $0x8,%esp
 784:	50                   	push   %eax
 785:	53                   	push   %ebx
 786:	e8 69 fb ff ff       	call   2f4 <listcmd>
 78b:	89 c3                	mov    %eax,%ebx
 78d:	83 c4 10             	add    $0x10,%esp
  return cmd;
 790:	eb d0                	jmp    762 <parseline+0x65>

00000792 <parseblock>:
{
 792:	f3 0f 1e fb          	endbr32 
 796:	55                   	push   %ebp
 797:	89 e5                	mov    %esp,%ebp
 799:	57                   	push   %edi
 79a:	56                   	push   %esi
 79b:	53                   	push   %ebx
 79c:	83 ec 10             	sub    $0x10,%esp
 79f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 7a2:	8b 75 0c             	mov    0xc(%ebp),%esi
  if(!peek(ps, es, "("))
 7a5:	68 20 10 00 00       	push   $0x1020
 7aa:	56                   	push   %esi
 7ab:	53                   	push   %ebx
 7ac:	e8 bc fc ff ff       	call   46d <peek>
 7b1:	83 c4 10             	add    $0x10,%esp
 7b4:	85 c0                	test   %eax,%eax
 7b6:	74 4b                	je     803 <parseblock+0x71>
  gettoken(ps, es, 0, 0);
 7b8:	6a 00                	push   $0x0
 7ba:	6a 00                	push   $0x0
 7bc:	56                   	push   %esi
 7bd:	53                   	push   %ebx
 7be:	e8 9f fb ff ff       	call   362 <gettoken>
  cmd = parseline(ps, es);
 7c3:	83 c4 08             	add    $0x8,%esp
 7c6:	56                   	push   %esi
 7c7:	53                   	push   %ebx
 7c8:	e8 30 ff ff ff       	call   6fd <parseline>
 7cd:	89 c7                	mov    %eax,%edi
  if(!peek(ps, es, ")"))
 7cf:	83 c4 0c             	add    $0xc,%esp
 7d2:	68 5c 10 00 00       	push   $0x105c
 7d7:	56                   	push   %esi
 7d8:	53                   	push   %ebx
 7d9:	e8 8f fc ff ff       	call   46d <peek>
 7de:	83 c4 10             	add    $0x10,%esp
 7e1:	85 c0                	test   %eax,%eax
 7e3:	74 2b                	je     810 <parseblock+0x7e>
  gettoken(ps, es, 0, 0);
 7e5:	6a 00                	push   $0x0
 7e7:	6a 00                	push   $0x0
 7e9:	56                   	push   %esi
 7ea:	53                   	push   %ebx
 7eb:	e8 72 fb ff ff       	call   362 <gettoken>
  cmd = parseredirs(cmd, ps, es);
 7f0:	83 c4 0c             	add    $0xc,%esp
 7f3:	56                   	push   %esi
 7f4:	53                   	push   %ebx
 7f5:	57                   	push   %edi
 7f6:	e8 e2 fc ff ff       	call   4dd <parseredirs>
}
 7fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
 7fe:	5b                   	pop    %ebx
 7ff:	5e                   	pop    %esi
 800:	5f                   	pop    %edi
 801:	5d                   	pop    %ebp
 802:	c3                   	ret    
    panic("parseblock");
 803:	83 ec 0c             	sub    $0xc,%esp
 806:	68 40 10 00 00       	push   $0x1040
 80b:	e8 3f f8 ff ff       	call   4f <panic>
    panic("syntax - missing )");
 810:	83 ec 0c             	sub    $0xc,%esp
 813:	68 4b 10 00 00       	push   $0x104b
 818:	e8 32 f8 ff ff       	call   4f <panic>

0000081d <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
 81d:	f3 0f 1e fb          	endbr32 
 821:	55                   	push   %ebp
 822:	89 e5                	mov    %esp,%ebp
 824:	53                   	push   %ebx
 825:	83 ec 04             	sub    $0x4,%esp
 828:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
 82b:	85 db                	test   %ebx,%ebx
 82d:	74 3b                	je     86a <nulterminate+0x4d>
    return 0;

  switch(cmd->type){
 82f:	8b 03                	mov    (%ebx),%eax
 831:	83 f8 05             	cmp    $0x5,%eax
 834:	77 34                	ja     86a <nulterminate+0x4d>
 836:	3e ff 24 85 9c 10 00 	notrack jmp *0x109c(,%eax,4)
 83d:	00 
 83e:	b8 00 00 00 00       	mov    $0x0,%eax
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
 843:	83 7c 83 04 00       	cmpl   $0x0,0x4(%ebx,%eax,4)
 848:	74 20                	je     86a <nulterminate+0x4d>
      *ecmd->eargv[i] = 0;
 84a:	8b 54 83 54          	mov    0x54(%ebx,%eax,4),%edx
 84e:	c6 02 00             	movb   $0x0,(%edx)
    for(i=0; ecmd->argv[i]; i++)
 851:	83 c0 01             	add    $0x1,%eax
 854:	eb ed                	jmp    843 <nulterminate+0x26>
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
 856:	83 ec 0c             	sub    $0xc,%esp
 859:	ff 73 04             	pushl  0x4(%ebx)
 85c:	e8 bc ff ff ff       	call   81d <nulterminate>
    *rcmd->efile = 0;
 861:	8b 43 0c             	mov    0xc(%ebx),%eax
 864:	c6 00 00             	movb   $0x0,(%eax)
    break;
 867:	83 c4 10             	add    $0x10,%esp
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
 86a:	89 d8                	mov    %ebx,%eax
 86c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 86f:	c9                   	leave  
 870:	c3                   	ret    
    nulterminate(pcmd->left);
 871:	83 ec 0c             	sub    $0xc,%esp
 874:	ff 73 04             	pushl  0x4(%ebx)
 877:	e8 a1 ff ff ff       	call   81d <nulterminate>
    nulterminate(pcmd->right);
 87c:	83 c4 04             	add    $0x4,%esp
 87f:	ff 73 08             	pushl  0x8(%ebx)
 882:	e8 96 ff ff ff       	call   81d <nulterminate>
    break;
 887:	83 c4 10             	add    $0x10,%esp
 88a:	eb de                	jmp    86a <nulterminate+0x4d>
    nulterminate(lcmd->left);
 88c:	83 ec 0c             	sub    $0xc,%esp
 88f:	ff 73 04             	pushl  0x4(%ebx)
 892:	e8 86 ff ff ff       	call   81d <nulterminate>
    nulterminate(lcmd->right);
 897:	83 c4 04             	add    $0x4,%esp
 89a:	ff 73 08             	pushl  0x8(%ebx)
 89d:	e8 7b ff ff ff       	call   81d <nulterminate>
    break;
 8a2:	83 c4 10             	add    $0x10,%esp
 8a5:	eb c3                	jmp    86a <nulterminate+0x4d>
    nulterminate(bcmd->cmd);
 8a7:	83 ec 0c             	sub    $0xc,%esp
 8aa:	ff 73 04             	pushl  0x4(%ebx)
 8ad:	e8 6b ff ff ff       	call   81d <nulterminate>
    break;
 8b2:	83 c4 10             	add    $0x10,%esp
 8b5:	eb b3                	jmp    86a <nulterminate+0x4d>

000008b7 <parsecmd>:
{
 8b7:	f3 0f 1e fb          	endbr32 
 8bb:	55                   	push   %ebp
 8bc:	89 e5                	mov    %esp,%ebp
 8be:	56                   	push   %esi
 8bf:	53                   	push   %ebx
  es = s + strlen(s);
 8c0:	8b 5d 08             	mov    0x8(%ebp),%ebx
 8c3:	83 ec 0c             	sub    $0xc,%esp
 8c6:	53                   	push   %ebx
 8c7:	e8 89 01 00 00       	call   a55 <strlen>
 8cc:	01 c3                	add    %eax,%ebx
  cmd = parseline(&s, es);
 8ce:	83 c4 08             	add    $0x8,%esp
 8d1:	53                   	push   %ebx
 8d2:	8d 45 08             	lea    0x8(%ebp),%eax
 8d5:	50                   	push   %eax
 8d6:	e8 22 fe ff ff       	call   6fd <parseline>
 8db:	89 c6                	mov    %eax,%esi
  peek(&s, es, "");
 8dd:	83 c4 0c             	add    $0xc,%esp
 8e0:	68 ea 0f 00 00       	push   $0xfea
 8e5:	53                   	push   %ebx
 8e6:	8d 45 08             	lea    0x8(%ebp),%eax
 8e9:	50                   	push   %eax
 8ea:	e8 7e fb ff ff       	call   46d <peek>
  if(s != es){
 8ef:	8b 45 08             	mov    0x8(%ebp),%eax
 8f2:	83 c4 10             	add    $0x10,%esp
 8f5:	39 d8                	cmp    %ebx,%eax
 8f7:	75 12                	jne    90b <parsecmd+0x54>
  nulterminate(cmd);
 8f9:	83 ec 0c             	sub    $0xc,%esp
 8fc:	56                   	push   %esi
 8fd:	e8 1b ff ff ff       	call   81d <nulterminate>
}
 902:	89 f0                	mov    %esi,%eax
 904:	8d 65 f8             	lea    -0x8(%ebp),%esp
 907:	5b                   	pop    %ebx
 908:	5e                   	pop    %esi
 909:	5d                   	pop    %ebp
 90a:	c3                   	ret    
    printf(2, "leftovers: %s\n", s);
 90b:	83 ec 04             	sub    $0x4,%esp
 90e:	50                   	push   %eax
 90f:	68 5e 10 00 00       	push   $0x105e
 914:	6a 02                	push   $0x2
 916:	e8 f4 03 00 00       	call   d0f <printf>
    panic("syntax");
 91b:	c7 04 24 22 10 00 00 	movl   $0x1022,(%esp)
 922:	e8 28 f7 ff ff       	call   4f <panic>

00000927 <main>:
{
 927:	f3 0f 1e fb          	endbr32 
 92b:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 92f:	83 e4 f0             	and    $0xfffffff0,%esp
 932:	ff 71 fc             	pushl  -0x4(%ecx)
 935:	55                   	push   %ebp
 936:	89 e5                	mov    %esp,%ebp
 938:	51                   	push   %ecx
 939:	83 ec 04             	sub    $0x4,%esp
  while((fd = open("console", O_RDWR)) >= 0){
 93c:	83 ec 08             	sub    $0x8,%esp
 93f:	6a 02                	push   $0x2
 941:	68 6d 10 00 00       	push   $0x106d
 946:	e8 b3 02 00 00       	call   bfe <open>
 94b:	83 c4 10             	add    $0x10,%esp
 94e:	85 c0                	test   %eax,%eax
 950:	78 21                	js     973 <main+0x4c>
    if(fd >= 3){
 952:	83 f8 02             	cmp    $0x2,%eax
 955:	7e e5                	jle    93c <main+0x15>
      close(fd);
 957:	83 ec 0c             	sub    $0xc,%esp
 95a:	50                   	push   %eax
 95b:	e8 86 02 00 00       	call   be6 <close>
      break;
 960:	83 c4 10             	add    $0x10,%esp
 963:	eb 0e                	jmp    973 <main+0x4c>
    if(fork1() == 0)
 965:	e8 03 f7 ff ff       	call   6d <fork1>
 96a:	85 c0                	test   %eax,%eax
 96c:	74 79                	je     9e7 <main+0xc0>
    wait();
 96e:	e8 53 02 00 00       	call   bc6 <wait>
  while(getcmd(buf, sizeof(buf)) >= 0){
 973:	83 ec 08             	sub    $0x8,%esp
 976:	68 c8 00 00 00       	push   $0xc8
 97b:	68 e0 10 00 00       	push   $0x10e0
 980:	e8 7b f6 ff ff       	call   0 <getcmd>
 985:	83 c4 10             	add    $0x10,%esp
 988:	85 c0                	test   %eax,%eax
 98a:	78 70                	js     9fc <main+0xd5>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
 98c:	80 3d e0 10 00 00 63 	cmpb   $0x63,0x10e0
 993:	75 d0                	jne    965 <main+0x3e>
 995:	80 3d e1 10 00 00 64 	cmpb   $0x64,0x10e1
 99c:	75 c7                	jne    965 <main+0x3e>
 99e:	80 3d e2 10 00 00 20 	cmpb   $0x20,0x10e2
 9a5:	75 be                	jne    965 <main+0x3e>
      buf[strlen(buf)-1] = 0;  // chop \n
 9a7:	83 ec 0c             	sub    $0xc,%esp
 9aa:	68 e0 10 00 00       	push   $0x10e0
 9af:	e8 a1 00 00 00       	call   a55 <strlen>
 9b4:	c6 80 df 10 00 00 00 	movb   $0x0,0x10df(%eax)
      if(chdir(buf+3) < 0)
 9bb:	c7 04 24 e3 10 00 00 	movl   $0x10e3,(%esp)
 9c2:	e8 67 02 00 00       	call   c2e <chdir>
 9c7:	83 c4 10             	add    $0x10,%esp
 9ca:	85 c0                	test   %eax,%eax
 9cc:	79 a5                	jns    973 <main+0x4c>
        printf(2, "cannot cd %s\n", buf+3);
 9ce:	83 ec 04             	sub    $0x4,%esp
 9d1:	68 e3 10 00 00       	push   $0x10e3
 9d6:	68 75 10 00 00       	push   $0x1075
 9db:	6a 02                	push   $0x2
 9dd:	e8 2d 03 00 00       	call   d0f <printf>
 9e2:	83 c4 10             	add    $0x10,%esp
      continue;
 9e5:	eb 8c                	jmp    973 <main+0x4c>
      runcmd(parsecmd(buf));
 9e7:	83 ec 0c             	sub    $0xc,%esp
 9ea:	68 e0 10 00 00       	push   $0x10e0
 9ef:	e8 c3 fe ff ff       	call   8b7 <parsecmd>
 9f4:	89 04 24             	mov    %eax,(%esp)
 9f7:	e8 94 f6 ff ff       	call   90 <runcmd>
  exit();
 9fc:	e8 bd 01 00 00       	call   bbe <exit>

00000a01 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 a01:	f3 0f 1e fb          	endbr32 
 a05:	55                   	push   %ebp
 a06:	89 e5                	mov    %esp,%ebp
 a08:	56                   	push   %esi
 a09:	53                   	push   %ebx
 a0a:	8b 75 08             	mov    0x8(%ebp),%esi
 a0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 a10:	89 f0                	mov    %esi,%eax
 a12:	89 d1                	mov    %edx,%ecx
 a14:	83 c2 01             	add    $0x1,%edx
 a17:	89 c3                	mov    %eax,%ebx
 a19:	83 c0 01             	add    $0x1,%eax
 a1c:	0f b6 09             	movzbl (%ecx),%ecx
 a1f:	88 0b                	mov    %cl,(%ebx)
 a21:	84 c9                	test   %cl,%cl
 a23:	75 ed                	jne    a12 <strcpy+0x11>
    ;
  return os;
}
 a25:	89 f0                	mov    %esi,%eax
 a27:	5b                   	pop    %ebx
 a28:	5e                   	pop    %esi
 a29:	5d                   	pop    %ebp
 a2a:	c3                   	ret    

00000a2b <strcmp>:

int
strcmp(const char *p, const char *q)
{
 a2b:	f3 0f 1e fb          	endbr32 
 a2f:	55                   	push   %ebp
 a30:	89 e5                	mov    %esp,%ebp
 a32:	8b 4d 08             	mov    0x8(%ebp),%ecx
 a35:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 a38:	0f b6 01             	movzbl (%ecx),%eax
 a3b:	84 c0                	test   %al,%al
 a3d:	74 0c                	je     a4b <strcmp+0x20>
 a3f:	3a 02                	cmp    (%edx),%al
 a41:	75 08                	jne    a4b <strcmp+0x20>
    p++, q++;
 a43:	83 c1 01             	add    $0x1,%ecx
 a46:	83 c2 01             	add    $0x1,%edx
 a49:	eb ed                	jmp    a38 <strcmp+0xd>
  return (uchar)*p - (uchar)*q;
 a4b:	0f b6 c0             	movzbl %al,%eax
 a4e:	0f b6 12             	movzbl (%edx),%edx
 a51:	29 d0                	sub    %edx,%eax
}
 a53:	5d                   	pop    %ebp
 a54:	c3                   	ret    

00000a55 <strlen>:

uint
strlen(const char *s)
{
 a55:	f3 0f 1e fb          	endbr32 
 a59:	55                   	push   %ebp
 a5a:	89 e5                	mov    %esp,%ebp
 a5c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 a5f:	b8 00 00 00 00       	mov    $0x0,%eax
 a64:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
 a68:	74 05                	je     a6f <strlen+0x1a>
 a6a:	83 c0 01             	add    $0x1,%eax
 a6d:	eb f5                	jmp    a64 <strlen+0xf>
    ;
  return n;
}
 a6f:	5d                   	pop    %ebp
 a70:	c3                   	ret    

00000a71 <memset>:

void*
memset(void *dst, int c, uint n)
{
 a71:	f3 0f 1e fb          	endbr32 
 a75:	55                   	push   %ebp
 a76:	89 e5                	mov    %esp,%ebp
 a78:	57                   	push   %edi
 a79:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 a7c:	89 d7                	mov    %edx,%edi
 a7e:	8b 4d 10             	mov    0x10(%ebp),%ecx
 a81:	8b 45 0c             	mov    0xc(%ebp),%eax
 a84:	fc                   	cld    
 a85:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 a87:	89 d0                	mov    %edx,%eax
 a89:	5f                   	pop    %edi
 a8a:	5d                   	pop    %ebp
 a8b:	c3                   	ret    

00000a8c <strchr>:

char*
strchr(const char *s, char c)
{
 a8c:	f3 0f 1e fb          	endbr32 
 a90:	55                   	push   %ebp
 a91:	89 e5                	mov    %esp,%ebp
 a93:	8b 45 08             	mov    0x8(%ebp),%eax
 a96:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 a9a:	0f b6 10             	movzbl (%eax),%edx
 a9d:	84 d2                	test   %dl,%dl
 a9f:	74 09                	je     aaa <strchr+0x1e>
    if(*s == c)
 aa1:	38 ca                	cmp    %cl,%dl
 aa3:	74 0a                	je     aaf <strchr+0x23>
  for(; *s; s++)
 aa5:	83 c0 01             	add    $0x1,%eax
 aa8:	eb f0                	jmp    a9a <strchr+0xe>
      return (char*)s;
  return 0;
 aaa:	b8 00 00 00 00       	mov    $0x0,%eax
}
 aaf:	5d                   	pop    %ebp
 ab0:	c3                   	ret    

00000ab1 <gets>:

char*
gets(char *buf, int max)
{
 ab1:	f3 0f 1e fb          	endbr32 
 ab5:	55                   	push   %ebp
 ab6:	89 e5                	mov    %esp,%ebp
 ab8:	57                   	push   %edi
 ab9:	56                   	push   %esi
 aba:	53                   	push   %ebx
 abb:	83 ec 1c             	sub    $0x1c,%esp
 abe:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 ac1:	bb 00 00 00 00       	mov    $0x0,%ebx
 ac6:	89 de                	mov    %ebx,%esi
 ac8:	83 c3 01             	add    $0x1,%ebx
 acb:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 ace:	7d 2e                	jge    afe <gets+0x4d>
    cc = read(0, &c, 1);
 ad0:	83 ec 04             	sub    $0x4,%esp
 ad3:	6a 01                	push   $0x1
 ad5:	8d 45 e7             	lea    -0x19(%ebp),%eax
 ad8:	50                   	push   %eax
 ad9:	6a 00                	push   $0x0
 adb:	e8 f6 00 00 00       	call   bd6 <read>
    if(cc < 1)
 ae0:	83 c4 10             	add    $0x10,%esp
 ae3:	85 c0                	test   %eax,%eax
 ae5:	7e 17                	jle    afe <gets+0x4d>
      break;
    buf[i++] = c;
 ae7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 aeb:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 aee:	3c 0a                	cmp    $0xa,%al
 af0:	0f 94 c2             	sete   %dl
 af3:	3c 0d                	cmp    $0xd,%al
 af5:	0f 94 c0             	sete   %al
 af8:	08 c2                	or     %al,%dl
 afa:	74 ca                	je     ac6 <gets+0x15>
    buf[i++] = c;
 afc:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 afe:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 b02:	89 f8                	mov    %edi,%eax
 b04:	8d 65 f4             	lea    -0xc(%ebp),%esp
 b07:	5b                   	pop    %ebx
 b08:	5e                   	pop    %esi
 b09:	5f                   	pop    %edi
 b0a:	5d                   	pop    %ebp
 b0b:	c3                   	ret    

00000b0c <stat>:

int
stat(const char *n, struct stat *st)
{
 b0c:	f3 0f 1e fb          	endbr32 
 b10:	55                   	push   %ebp
 b11:	89 e5                	mov    %esp,%ebp
 b13:	56                   	push   %esi
 b14:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 b15:	83 ec 08             	sub    $0x8,%esp
 b18:	6a 00                	push   $0x0
 b1a:	ff 75 08             	pushl  0x8(%ebp)
 b1d:	e8 dc 00 00 00       	call   bfe <open>
  if(fd < 0)
 b22:	83 c4 10             	add    $0x10,%esp
 b25:	85 c0                	test   %eax,%eax
 b27:	78 24                	js     b4d <stat+0x41>
 b29:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 b2b:	83 ec 08             	sub    $0x8,%esp
 b2e:	ff 75 0c             	pushl  0xc(%ebp)
 b31:	50                   	push   %eax
 b32:	e8 df 00 00 00       	call   c16 <fstat>
 b37:	89 c6                	mov    %eax,%esi
  close(fd);
 b39:	89 1c 24             	mov    %ebx,(%esp)
 b3c:	e8 a5 00 00 00       	call   be6 <close>
  return r;
 b41:	83 c4 10             	add    $0x10,%esp
}
 b44:	89 f0                	mov    %esi,%eax
 b46:	8d 65 f8             	lea    -0x8(%ebp),%esp
 b49:	5b                   	pop    %ebx
 b4a:	5e                   	pop    %esi
 b4b:	5d                   	pop    %ebp
 b4c:	c3                   	ret    
    return -1;
 b4d:	be ff ff ff ff       	mov    $0xffffffff,%esi
 b52:	eb f0                	jmp    b44 <stat+0x38>

00000b54 <atoi>:

int
atoi(const char *s)
{
 b54:	f3 0f 1e fb          	endbr32 
 b58:	55                   	push   %ebp
 b59:	89 e5                	mov    %esp,%ebp
 b5b:	53                   	push   %ebx
 b5c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 b5f:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 b64:	0f b6 01             	movzbl (%ecx),%eax
 b67:	8d 58 d0             	lea    -0x30(%eax),%ebx
 b6a:	80 fb 09             	cmp    $0x9,%bl
 b6d:	77 12                	ja     b81 <atoi+0x2d>
    n = n*10 + *s++ - '0';
 b6f:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 b72:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 b75:	83 c1 01             	add    $0x1,%ecx
 b78:	0f be c0             	movsbl %al,%eax
 b7b:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
 b7f:	eb e3                	jmp    b64 <atoi+0x10>
  return n;
}
 b81:	89 d0                	mov    %edx,%eax
 b83:	5b                   	pop    %ebx
 b84:	5d                   	pop    %ebp
 b85:	c3                   	ret    

00000b86 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 b86:	f3 0f 1e fb          	endbr32 
 b8a:	55                   	push   %ebp
 b8b:	89 e5                	mov    %esp,%ebp
 b8d:	56                   	push   %esi
 b8e:	53                   	push   %ebx
 b8f:	8b 75 08             	mov    0x8(%ebp),%esi
 b92:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 b95:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 b98:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 b9a:	8d 58 ff             	lea    -0x1(%eax),%ebx
 b9d:	85 c0                	test   %eax,%eax
 b9f:	7e 0f                	jle    bb0 <memmove+0x2a>
    *dst++ = *src++;
 ba1:	0f b6 01             	movzbl (%ecx),%eax
 ba4:	88 02                	mov    %al,(%edx)
 ba6:	8d 49 01             	lea    0x1(%ecx),%ecx
 ba9:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 bac:	89 d8                	mov    %ebx,%eax
 bae:	eb ea                	jmp    b9a <memmove+0x14>
  return vdst;
}
 bb0:	89 f0                	mov    %esi,%eax
 bb2:	5b                   	pop    %ebx
 bb3:	5e                   	pop    %esi
 bb4:	5d                   	pop    %ebp
 bb5:	c3                   	ret    

00000bb6 <fork>:
 bb6:	b8 01 00 00 00       	mov    $0x1,%eax
 bbb:	cd 40                	int    $0x40
 bbd:	c3                   	ret    

00000bbe <exit>:
 bbe:	b8 02 00 00 00       	mov    $0x2,%eax
 bc3:	cd 40                	int    $0x40
 bc5:	c3                   	ret    

00000bc6 <wait>:
 bc6:	b8 03 00 00 00       	mov    $0x3,%eax
 bcb:	cd 40                	int    $0x40
 bcd:	c3                   	ret    

00000bce <pipe>:
 bce:	b8 04 00 00 00       	mov    $0x4,%eax
 bd3:	cd 40                	int    $0x40
 bd5:	c3                   	ret    

00000bd6 <read>:
 bd6:	b8 05 00 00 00       	mov    $0x5,%eax
 bdb:	cd 40                	int    $0x40
 bdd:	c3                   	ret    

00000bde <write>:
 bde:	b8 10 00 00 00       	mov    $0x10,%eax
 be3:	cd 40                	int    $0x40
 be5:	c3                   	ret    

00000be6 <close>:
 be6:	b8 15 00 00 00       	mov    $0x15,%eax
 beb:	cd 40                	int    $0x40
 bed:	c3                   	ret    

00000bee <kill>:
 bee:	b8 06 00 00 00       	mov    $0x6,%eax
 bf3:	cd 40                	int    $0x40
 bf5:	c3                   	ret    

00000bf6 <exec>:
 bf6:	b8 07 00 00 00       	mov    $0x7,%eax
 bfb:	cd 40                	int    $0x40
 bfd:	c3                   	ret    

00000bfe <open>:
 bfe:	b8 0f 00 00 00       	mov    $0xf,%eax
 c03:	cd 40                	int    $0x40
 c05:	c3                   	ret    

00000c06 <mknod>:
 c06:	b8 11 00 00 00       	mov    $0x11,%eax
 c0b:	cd 40                	int    $0x40
 c0d:	c3                   	ret    

00000c0e <unlink>:
 c0e:	b8 12 00 00 00       	mov    $0x12,%eax
 c13:	cd 40                	int    $0x40
 c15:	c3                   	ret    

00000c16 <fstat>:
 c16:	b8 08 00 00 00       	mov    $0x8,%eax
 c1b:	cd 40                	int    $0x40
 c1d:	c3                   	ret    

00000c1e <link>:
 c1e:	b8 13 00 00 00       	mov    $0x13,%eax
 c23:	cd 40                	int    $0x40
 c25:	c3                   	ret    

00000c26 <mkdir>:
 c26:	b8 14 00 00 00       	mov    $0x14,%eax
 c2b:	cd 40                	int    $0x40
 c2d:	c3                   	ret    

00000c2e <chdir>:
 c2e:	b8 09 00 00 00       	mov    $0x9,%eax
 c33:	cd 40                	int    $0x40
 c35:	c3                   	ret    

00000c36 <dup>:
 c36:	b8 0a 00 00 00       	mov    $0xa,%eax
 c3b:	cd 40                	int    $0x40
 c3d:	c3                   	ret    

00000c3e <getpid>:
 c3e:	b8 0b 00 00 00       	mov    $0xb,%eax
 c43:	cd 40                	int    $0x40
 c45:	c3                   	ret    

00000c46 <sbrk>:
 c46:	b8 0c 00 00 00       	mov    $0xc,%eax
 c4b:	cd 40                	int    $0x40
 c4d:	c3                   	ret    

00000c4e <sleep>:
 c4e:	b8 0d 00 00 00       	mov    $0xd,%eax
 c53:	cd 40                	int    $0x40
 c55:	c3                   	ret    

00000c56 <uptime>:
 c56:	b8 0e 00 00 00       	mov    $0xe,%eax
 c5b:	cd 40                	int    $0x40
 c5d:	c3                   	ret    

00000c5e <yield>:
 c5e:	b8 16 00 00 00       	mov    $0x16,%eax
 c63:	cd 40                	int    $0x40
 c65:	c3                   	ret    

00000c66 <shutdown>:
 c66:	b8 17 00 00 00       	mov    $0x17,%eax
 c6b:	cd 40                	int    $0x40
 c6d:	c3                   	ret    

00000c6e <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 c6e:	55                   	push   %ebp
 c6f:	89 e5                	mov    %esp,%ebp
 c71:	83 ec 1c             	sub    $0x1c,%esp
 c74:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 c77:	6a 01                	push   $0x1
 c79:	8d 55 f4             	lea    -0xc(%ebp),%edx
 c7c:	52                   	push   %edx
 c7d:	50                   	push   %eax
 c7e:	e8 5b ff ff ff       	call   bde <write>
}
 c83:	83 c4 10             	add    $0x10,%esp
 c86:	c9                   	leave  
 c87:	c3                   	ret    

00000c88 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 c88:	55                   	push   %ebp
 c89:	89 e5                	mov    %esp,%ebp
 c8b:	57                   	push   %edi
 c8c:	56                   	push   %esi
 c8d:	53                   	push   %ebx
 c8e:	83 ec 2c             	sub    $0x2c,%esp
 c91:	89 45 d0             	mov    %eax,-0x30(%ebp)
 c94:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 c96:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 c9a:	0f 95 c2             	setne  %dl
 c9d:	89 f0                	mov    %esi,%eax
 c9f:	c1 e8 1f             	shr    $0x1f,%eax
 ca2:	84 c2                	test   %al,%dl
 ca4:	74 42                	je     ce8 <printint+0x60>
    neg = 1;
    x = -xx;
 ca6:	f7 de                	neg    %esi
    neg = 1;
 ca8:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 caf:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 cb4:	89 f0                	mov    %esi,%eax
 cb6:	ba 00 00 00 00       	mov    $0x0,%edx
 cbb:	f7 f1                	div    %ecx
 cbd:	89 df                	mov    %ebx,%edi
 cbf:	83 c3 01             	add    $0x1,%ebx
 cc2:	0f b6 92 bc 10 00 00 	movzbl 0x10bc(%edx),%edx
 cc9:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 ccd:	89 f2                	mov    %esi,%edx
 ccf:	89 c6                	mov    %eax,%esi
 cd1:	39 d1                	cmp    %edx,%ecx
 cd3:	76 df                	jbe    cb4 <printint+0x2c>
  if(neg)
 cd5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 cd9:	74 2f                	je     d0a <printint+0x82>
    buf[i++] = '-';
 cdb:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 ce0:	8d 5f 02             	lea    0x2(%edi),%ebx
 ce3:	8b 75 d0             	mov    -0x30(%ebp),%esi
 ce6:	eb 15                	jmp    cfd <printint+0x75>
  neg = 0;
 ce8:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 cef:	eb be                	jmp    caf <printint+0x27>

  while(--i >= 0)
    putc(fd, buf[i]);
 cf1:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 cf6:	89 f0                	mov    %esi,%eax
 cf8:	e8 71 ff ff ff       	call   c6e <putc>
  while(--i >= 0)
 cfd:	83 eb 01             	sub    $0x1,%ebx
 d00:	79 ef                	jns    cf1 <printint+0x69>
}
 d02:	83 c4 2c             	add    $0x2c,%esp
 d05:	5b                   	pop    %ebx
 d06:	5e                   	pop    %esi
 d07:	5f                   	pop    %edi
 d08:	5d                   	pop    %ebp
 d09:	c3                   	ret    
 d0a:	8b 75 d0             	mov    -0x30(%ebp),%esi
 d0d:	eb ee                	jmp    cfd <printint+0x75>

00000d0f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 d0f:	f3 0f 1e fb          	endbr32 
 d13:	55                   	push   %ebp
 d14:	89 e5                	mov    %esp,%ebp
 d16:	57                   	push   %edi
 d17:	56                   	push   %esi
 d18:	53                   	push   %ebx
 d19:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 d1c:	8d 45 10             	lea    0x10(%ebp),%eax
 d1f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 d22:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 d27:	bb 00 00 00 00       	mov    $0x0,%ebx
 d2c:	eb 14                	jmp    d42 <printf+0x33>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 d2e:	89 fa                	mov    %edi,%edx
 d30:	8b 45 08             	mov    0x8(%ebp),%eax
 d33:	e8 36 ff ff ff       	call   c6e <putc>
 d38:	eb 05                	jmp    d3f <printf+0x30>
      }
    } else if(state == '%'){
 d3a:	83 fe 25             	cmp    $0x25,%esi
 d3d:	74 25                	je     d64 <printf+0x55>
  for(i = 0; fmt[i]; i++){
 d3f:	83 c3 01             	add    $0x1,%ebx
 d42:	8b 45 0c             	mov    0xc(%ebp),%eax
 d45:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 d49:	84 c0                	test   %al,%al
 d4b:	0f 84 23 01 00 00    	je     e74 <printf+0x165>
    c = fmt[i] & 0xff;
 d51:	0f be f8             	movsbl %al,%edi
 d54:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 d57:	85 f6                	test   %esi,%esi
 d59:	75 df                	jne    d3a <printf+0x2b>
      if(c == '%'){
 d5b:	83 f8 25             	cmp    $0x25,%eax
 d5e:	75 ce                	jne    d2e <printf+0x1f>
        state = '%';
 d60:	89 c6                	mov    %eax,%esi
 d62:	eb db                	jmp    d3f <printf+0x30>
      if(c == 'd'){
 d64:	83 f8 64             	cmp    $0x64,%eax
 d67:	74 49                	je     db2 <printf+0xa3>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 d69:	83 f8 78             	cmp    $0x78,%eax
 d6c:	0f 94 c1             	sete   %cl
 d6f:	83 f8 70             	cmp    $0x70,%eax
 d72:	0f 94 c2             	sete   %dl
 d75:	08 d1                	or     %dl,%cl
 d77:	75 63                	jne    ddc <printf+0xcd>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 d79:	83 f8 73             	cmp    $0x73,%eax
 d7c:	0f 84 84 00 00 00    	je     e06 <printf+0xf7>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 d82:	83 f8 63             	cmp    $0x63,%eax
 d85:	0f 84 b7 00 00 00    	je     e42 <printf+0x133>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 d8b:	83 f8 25             	cmp    $0x25,%eax
 d8e:	0f 84 cc 00 00 00    	je     e60 <printf+0x151>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 d94:	ba 25 00 00 00       	mov    $0x25,%edx
 d99:	8b 45 08             	mov    0x8(%ebp),%eax
 d9c:	e8 cd fe ff ff       	call   c6e <putc>
        putc(fd, c);
 da1:	89 fa                	mov    %edi,%edx
 da3:	8b 45 08             	mov    0x8(%ebp),%eax
 da6:	e8 c3 fe ff ff       	call   c6e <putc>
      }
      state = 0;
 dab:	be 00 00 00 00       	mov    $0x0,%esi
 db0:	eb 8d                	jmp    d3f <printf+0x30>
        printint(fd, *ap, 10, 1);
 db2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 db5:	8b 17                	mov    (%edi),%edx
 db7:	83 ec 0c             	sub    $0xc,%esp
 dba:	6a 01                	push   $0x1
 dbc:	b9 0a 00 00 00       	mov    $0xa,%ecx
 dc1:	8b 45 08             	mov    0x8(%ebp),%eax
 dc4:	e8 bf fe ff ff       	call   c88 <printint>
        ap++;
 dc9:	83 c7 04             	add    $0x4,%edi
 dcc:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 dcf:	83 c4 10             	add    $0x10,%esp
      state = 0;
 dd2:	be 00 00 00 00       	mov    $0x0,%esi
 dd7:	e9 63 ff ff ff       	jmp    d3f <printf+0x30>
        printint(fd, *ap, 16, 0);
 ddc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 ddf:	8b 17                	mov    (%edi),%edx
 de1:	83 ec 0c             	sub    $0xc,%esp
 de4:	6a 00                	push   $0x0
 de6:	b9 10 00 00 00       	mov    $0x10,%ecx
 deb:	8b 45 08             	mov    0x8(%ebp),%eax
 dee:	e8 95 fe ff ff       	call   c88 <printint>
        ap++;
 df3:	83 c7 04             	add    $0x4,%edi
 df6:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 df9:	83 c4 10             	add    $0x10,%esp
      state = 0;
 dfc:	be 00 00 00 00       	mov    $0x0,%esi
 e01:	e9 39 ff ff ff       	jmp    d3f <printf+0x30>
        s = (char*)*ap;
 e06:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 e09:	8b 30                	mov    (%eax),%esi
        ap++;
 e0b:	83 c0 04             	add    $0x4,%eax
 e0e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 e11:	85 f6                	test   %esi,%esi
 e13:	75 28                	jne    e3d <printf+0x12e>
          s = "(null)";
 e15:	be b4 10 00 00       	mov    $0x10b4,%esi
 e1a:	8b 7d 08             	mov    0x8(%ebp),%edi
 e1d:	eb 0d                	jmp    e2c <printf+0x11d>
          putc(fd, *s);
 e1f:	0f be d2             	movsbl %dl,%edx
 e22:	89 f8                	mov    %edi,%eax
 e24:	e8 45 fe ff ff       	call   c6e <putc>
          s++;
 e29:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 e2c:	0f b6 16             	movzbl (%esi),%edx
 e2f:	84 d2                	test   %dl,%dl
 e31:	75 ec                	jne    e1f <printf+0x110>
      state = 0;
 e33:	be 00 00 00 00       	mov    $0x0,%esi
 e38:	e9 02 ff ff ff       	jmp    d3f <printf+0x30>
 e3d:	8b 7d 08             	mov    0x8(%ebp),%edi
 e40:	eb ea                	jmp    e2c <printf+0x11d>
        putc(fd, *ap);
 e42:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 e45:	0f be 17             	movsbl (%edi),%edx
 e48:	8b 45 08             	mov    0x8(%ebp),%eax
 e4b:	e8 1e fe ff ff       	call   c6e <putc>
        ap++;
 e50:	83 c7 04             	add    $0x4,%edi
 e53:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 e56:	be 00 00 00 00       	mov    $0x0,%esi
 e5b:	e9 df fe ff ff       	jmp    d3f <printf+0x30>
        putc(fd, c);
 e60:	89 fa                	mov    %edi,%edx
 e62:	8b 45 08             	mov    0x8(%ebp),%eax
 e65:	e8 04 fe ff ff       	call   c6e <putc>
      state = 0;
 e6a:	be 00 00 00 00       	mov    $0x0,%esi
 e6f:	e9 cb fe ff ff       	jmp    d3f <printf+0x30>
    }
  }
}
 e74:	8d 65 f4             	lea    -0xc(%ebp),%esp
 e77:	5b                   	pop    %ebx
 e78:	5e                   	pop    %esi
 e79:	5f                   	pop    %edi
 e7a:	5d                   	pop    %ebp
 e7b:	c3                   	ret    

00000e7c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 e7c:	f3 0f 1e fb          	endbr32 
 e80:	55                   	push   %ebp
 e81:	89 e5                	mov    %esp,%ebp
 e83:	57                   	push   %edi
 e84:	56                   	push   %esi
 e85:	53                   	push   %ebx
 e86:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 e89:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 e8c:	a1 a8 11 00 00       	mov    0x11a8,%eax
 e91:	eb 02                	jmp    e95 <free+0x19>
 e93:	89 d0                	mov    %edx,%eax
 e95:	39 c8                	cmp    %ecx,%eax
 e97:	73 04                	jae    e9d <free+0x21>
 e99:	39 08                	cmp    %ecx,(%eax)
 e9b:	77 12                	ja     eaf <free+0x33>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 e9d:	8b 10                	mov    (%eax),%edx
 e9f:	39 c2                	cmp    %eax,%edx
 ea1:	77 f0                	ja     e93 <free+0x17>
 ea3:	39 c8                	cmp    %ecx,%eax
 ea5:	72 08                	jb     eaf <free+0x33>
 ea7:	39 ca                	cmp    %ecx,%edx
 ea9:	77 04                	ja     eaf <free+0x33>
 eab:	89 d0                	mov    %edx,%eax
 ead:	eb e6                	jmp    e95 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 eaf:	8b 73 fc             	mov    -0x4(%ebx),%esi
 eb2:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 eb5:	8b 10                	mov    (%eax),%edx
 eb7:	39 d7                	cmp    %edx,%edi
 eb9:	74 19                	je     ed4 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 ebb:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 ebe:	8b 50 04             	mov    0x4(%eax),%edx
 ec1:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 ec4:	39 ce                	cmp    %ecx,%esi
 ec6:	74 1b                	je     ee3 <free+0x67>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 ec8:	89 08                	mov    %ecx,(%eax)
  freep = p;
 eca:	a3 a8 11 00 00       	mov    %eax,0x11a8
}
 ecf:	5b                   	pop    %ebx
 ed0:	5e                   	pop    %esi
 ed1:	5f                   	pop    %edi
 ed2:	5d                   	pop    %ebp
 ed3:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 ed4:	03 72 04             	add    0x4(%edx),%esi
 ed7:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 eda:	8b 10                	mov    (%eax),%edx
 edc:	8b 12                	mov    (%edx),%edx
 ede:	89 53 f8             	mov    %edx,-0x8(%ebx)
 ee1:	eb db                	jmp    ebe <free+0x42>
    p->s.size += bp->s.size;
 ee3:	03 53 fc             	add    -0x4(%ebx),%edx
 ee6:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 ee9:	8b 53 f8             	mov    -0x8(%ebx),%edx
 eec:	89 10                	mov    %edx,(%eax)
 eee:	eb da                	jmp    eca <free+0x4e>

00000ef0 <morecore>:

static Header*
morecore(uint nu)
{
 ef0:	55                   	push   %ebp
 ef1:	89 e5                	mov    %esp,%ebp
 ef3:	53                   	push   %ebx
 ef4:	83 ec 04             	sub    $0x4,%esp
 ef7:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 ef9:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 efe:	77 05                	ja     f05 <morecore+0x15>
    nu = 4096;
 f00:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 f05:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 f0c:	83 ec 0c             	sub    $0xc,%esp
 f0f:	50                   	push   %eax
 f10:	e8 31 fd ff ff       	call   c46 <sbrk>
  if(p == (char*)-1)
 f15:	83 c4 10             	add    $0x10,%esp
 f18:	83 f8 ff             	cmp    $0xffffffff,%eax
 f1b:	74 1c                	je     f39 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 f1d:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 f20:	83 c0 08             	add    $0x8,%eax
 f23:	83 ec 0c             	sub    $0xc,%esp
 f26:	50                   	push   %eax
 f27:	e8 50 ff ff ff       	call   e7c <free>
  return freep;
 f2c:	a1 a8 11 00 00       	mov    0x11a8,%eax
 f31:	83 c4 10             	add    $0x10,%esp
}
 f34:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 f37:	c9                   	leave  
 f38:	c3                   	ret    
    return 0;
 f39:	b8 00 00 00 00       	mov    $0x0,%eax
 f3e:	eb f4                	jmp    f34 <morecore+0x44>

00000f40 <malloc>:

void*
malloc(uint nbytes)
{
 f40:	f3 0f 1e fb          	endbr32 
 f44:	55                   	push   %ebp
 f45:	89 e5                	mov    %esp,%ebp
 f47:	53                   	push   %ebx
 f48:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 f4b:	8b 45 08             	mov    0x8(%ebp),%eax
 f4e:	8d 58 07             	lea    0x7(%eax),%ebx
 f51:	c1 eb 03             	shr    $0x3,%ebx
 f54:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 f57:	8b 0d a8 11 00 00    	mov    0x11a8,%ecx
 f5d:	85 c9                	test   %ecx,%ecx
 f5f:	74 04                	je     f65 <malloc+0x25>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 f61:	8b 01                	mov    (%ecx),%eax
 f63:	eb 4b                	jmp    fb0 <malloc+0x70>
    base.s.ptr = freep = prevp = &base;
 f65:	c7 05 a8 11 00 00 ac 	movl   $0x11ac,0x11a8
 f6c:	11 00 00 
 f6f:	c7 05 ac 11 00 00 ac 	movl   $0x11ac,0x11ac
 f76:	11 00 00 
    base.s.size = 0;
 f79:	c7 05 b0 11 00 00 00 	movl   $0x0,0x11b0
 f80:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 f83:	b9 ac 11 00 00       	mov    $0x11ac,%ecx
 f88:	eb d7                	jmp    f61 <malloc+0x21>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 f8a:	74 1a                	je     fa6 <malloc+0x66>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 f8c:	29 da                	sub    %ebx,%edx
 f8e:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 f91:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 f94:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 f97:	89 0d a8 11 00 00    	mov    %ecx,0x11a8
      return (void*)(p + 1);
 f9d:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 fa0:	83 c4 04             	add    $0x4,%esp
 fa3:	5b                   	pop    %ebx
 fa4:	5d                   	pop    %ebp
 fa5:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 fa6:	8b 10                	mov    (%eax),%edx
 fa8:	89 11                	mov    %edx,(%ecx)
 faa:	eb eb                	jmp    f97 <malloc+0x57>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 fac:	89 c1                	mov    %eax,%ecx
 fae:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 fb0:	8b 50 04             	mov    0x4(%eax),%edx
 fb3:	39 da                	cmp    %ebx,%edx
 fb5:	73 d3                	jae    f8a <malloc+0x4a>
    if(p == freep)
 fb7:	39 05 a8 11 00 00    	cmp    %eax,0x11a8
 fbd:	75 ed                	jne    fac <malloc+0x6c>
      if((p = morecore(nunits)) == 0)
 fbf:	89 d8                	mov    %ebx,%eax
 fc1:	e8 2a ff ff ff       	call   ef0 <morecore>
 fc6:	85 c0                	test   %eax,%eax
 fc8:	75 e2                	jne    fac <malloc+0x6c>
 fca:	eb d4                	jmp    fa0 <malloc+0x60>
