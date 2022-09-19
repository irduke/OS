
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:
8010000c:	0f 20 e0             	mov    %cr4,%eax
8010000f:	83 c8 10             	or     $0x10,%eax
80100012:	0f 22 e0             	mov    %eax,%cr4
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
8010001a:	0f 22 d8             	mov    %eax,%cr3
8010001d:	0f 20 c0             	mov    %cr0,%eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
80100025:	0f 22 c0             	mov    %eax,%cr0
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp
8010002d:	b8 64 2b 10 80       	mov    $0x80102b64,%eax
80100032:	ff e0                	jmp    *%eax

80100034 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	57                   	push   %edi
80100038:	56                   	push   %esi
80100039:	53                   	push   %ebx
8010003a:	83 ec 18             	sub    $0x18,%esp
8010003d:	89 c6                	mov    %eax,%esi
8010003f:	89 d7                	mov    %edx,%edi
  struct buf *b;

  acquire(&bcache.lock);
80100041:	68 c0 b5 10 80       	push   $0x8010b5c0
80100046:	e8 d9 3c 00 00       	call   80103d24 <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
8010004b:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
80100051:	83 c4 10             	add    $0x10,%esp
80100054:	eb 03                	jmp    80100059 <bget+0x25>
80100056:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100059:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010005f:	74 30                	je     80100091 <bget+0x5d>
    if(b->dev == dev && b->blockno == blockno){
80100061:	39 73 04             	cmp    %esi,0x4(%ebx)
80100064:	75 f0                	jne    80100056 <bget+0x22>
80100066:	39 7b 08             	cmp    %edi,0x8(%ebx)
80100069:	75 eb                	jne    80100056 <bget+0x22>
      b->refcnt++;
8010006b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010006e:	83 c0 01             	add    $0x1,%eax
80100071:	89 43 4c             	mov    %eax,0x4c(%ebx)
      release(&bcache.lock);
80100074:	83 ec 0c             	sub    $0xc,%esp
80100077:	68 c0 b5 10 80       	push   $0x8010b5c0
8010007c:	e8 0c 3d 00 00       	call   80103d8d <release>
      acquiresleep(&b->lock);
80100081:	8d 43 0c             	lea    0xc(%ebx),%eax
80100084:	89 04 24             	mov    %eax,(%esp)
80100087:	e8 64 3a 00 00       	call   80103af0 <acquiresleep>
      return b;
8010008c:	83 c4 10             	add    $0x10,%esp
8010008f:	eb 4c                	jmp    801000dd <bget+0xa9>
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100091:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100097:	eb 03                	jmp    8010009c <bget+0x68>
80100099:	8b 5b 50             	mov    0x50(%ebx),%ebx
8010009c:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000a2:	74 43                	je     801000e7 <bget+0xb3>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
801000a4:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
801000a8:	75 ef                	jne    80100099 <bget+0x65>
801000aa:	f6 03 04             	testb  $0x4,(%ebx)
801000ad:	75 ea                	jne    80100099 <bget+0x65>
      b->dev = dev;
801000af:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
801000b2:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
801000b5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
801000bb:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
801000c2:	83 ec 0c             	sub    $0xc,%esp
801000c5:	68 c0 b5 10 80       	push   $0x8010b5c0
801000ca:	e8 be 3c 00 00       	call   80103d8d <release>
      acquiresleep(&b->lock);
801000cf:	8d 43 0c             	lea    0xc(%ebx),%eax
801000d2:	89 04 24             	mov    %eax,(%esp)
801000d5:	e8 16 3a 00 00       	call   80103af0 <acquiresleep>
      return b;
801000da:	83 c4 10             	add    $0x10,%esp
    }
  }
  panic("bget: no buffers");
}
801000dd:	89 d8                	mov    %ebx,%eax
801000df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801000e2:	5b                   	pop    %ebx
801000e3:	5e                   	pop    %esi
801000e4:	5f                   	pop    %edi
801000e5:	5d                   	pop    %ebp
801000e6:	c3                   	ret    
  panic("bget: no buffers");
801000e7:	83 ec 0c             	sub    $0xc,%esp
801000ea:	68 a0 67 10 80       	push   $0x801067a0
801000ef:	e8 68 02 00 00       	call   8010035c <panic>

801000f4 <binit>:
{
801000f4:	f3 0f 1e fb          	endbr32 
801000f8:	55                   	push   %ebp
801000f9:	89 e5                	mov    %esp,%ebp
801000fb:	53                   	push   %ebx
801000fc:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
801000ff:	68 b1 67 10 80       	push   $0x801067b1
80100104:	68 c0 b5 10 80       	push   $0x8010b5c0
80100109:	e8 c6 3a 00 00       	call   80103bd4 <initlock>
  bcache.head.prev = &bcache.head;
8010010e:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
80100115:	fc 10 80 
  bcache.head.next = &bcache.head;
80100118:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
8010011f:	fc 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100122:	83 c4 10             	add    $0x10,%esp
80100125:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
8010012a:	eb 37                	jmp    80100163 <binit+0x6f>
    b->next = bcache.head.next;
8010012c:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
80100131:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
80100134:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
8010013b:	83 ec 08             	sub    $0x8,%esp
8010013e:	68 b8 67 10 80       	push   $0x801067b8
80100143:	8d 43 0c             	lea    0xc(%ebx),%eax
80100146:	50                   	push   %eax
80100147:	e8 6d 39 00 00       	call   80103ab9 <initsleeplock>
    bcache.head.next->prev = b;
8010014c:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
80100151:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100154:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010015a:	81 c3 5c 02 00 00    	add    $0x25c,%ebx
80100160:	83 c4 10             	add    $0x10,%esp
80100163:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100169:	72 c1                	jb     8010012c <binit+0x38>
}
8010016b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010016e:	c9                   	leave  
8010016f:	c3                   	ret    

80100170 <bread>:

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
80100170:	f3 0f 1e fb          	endbr32 
80100174:	55                   	push   %ebp
80100175:	89 e5                	mov    %esp,%ebp
80100177:	53                   	push   %ebx
80100178:	83 ec 04             	sub    $0x4,%esp
  struct buf *b;

  b = bget(dev, blockno);
8010017b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010017e:	8b 45 08             	mov    0x8(%ebp),%eax
80100181:	e8 ae fe ff ff       	call   80100034 <bget>
80100186:	89 c3                	mov    %eax,%ebx
  if((b->flags & B_VALID) == 0) {
80100188:	f6 00 02             	testb  $0x2,(%eax)
8010018b:	74 07                	je     80100194 <bread+0x24>
    iderw(b);
  }
  return b;
}
8010018d:	89 d8                	mov    %ebx,%eax
8010018f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100192:	c9                   	leave  
80100193:	c3                   	ret    
    iderw(b);
80100194:	83 ec 0c             	sub    $0xc,%esp
80100197:	50                   	push   %eax
80100198:	e8 ec 1c 00 00       	call   80101e89 <iderw>
8010019d:	83 c4 10             	add    $0x10,%esp
  return b;
801001a0:	eb eb                	jmp    8010018d <bread+0x1d>

801001a2 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a2:	f3 0f 1e fb          	endbr32 
801001a6:	55                   	push   %ebp
801001a7:	89 e5                	mov    %esp,%ebp
801001a9:	53                   	push   %ebx
801001aa:	83 ec 10             	sub    $0x10,%esp
801001ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001b0:	8d 43 0c             	lea    0xc(%ebx),%eax
801001b3:	50                   	push   %eax
801001b4:	e8 c9 39 00 00       	call   80103b82 <holdingsleep>
801001b9:	83 c4 10             	add    $0x10,%esp
801001bc:	85 c0                	test   %eax,%eax
801001be:	74 14                	je     801001d4 <bwrite+0x32>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001c0:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001c3:	83 ec 0c             	sub    $0xc,%esp
801001c6:	53                   	push   %ebx
801001c7:	e8 bd 1c 00 00       	call   80101e89 <iderw>
}
801001cc:	83 c4 10             	add    $0x10,%esp
801001cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d2:	c9                   	leave  
801001d3:	c3                   	ret    
    panic("bwrite");
801001d4:	83 ec 0c             	sub    $0xc,%esp
801001d7:	68 bf 67 10 80       	push   $0x801067bf
801001dc:	e8 7b 01 00 00       	call   8010035c <panic>

801001e1 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e1:	f3 0f 1e fb          	endbr32 
801001e5:	55                   	push   %ebp
801001e6:	89 e5                	mov    %esp,%ebp
801001e8:	56                   	push   %esi
801001e9:	53                   	push   %ebx
801001ea:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ed:	8d 73 0c             	lea    0xc(%ebx),%esi
801001f0:	83 ec 0c             	sub    $0xc,%esp
801001f3:	56                   	push   %esi
801001f4:	e8 89 39 00 00       	call   80103b82 <holdingsleep>
801001f9:	83 c4 10             	add    $0x10,%esp
801001fc:	85 c0                	test   %eax,%eax
801001fe:	74 6b                	je     8010026b <brelse+0x8a>
    panic("brelse");

  releasesleep(&b->lock);
80100200:	83 ec 0c             	sub    $0xc,%esp
80100203:	56                   	push   %esi
80100204:	e8 3a 39 00 00       	call   80103b43 <releasesleep>

  acquire(&bcache.lock);
80100209:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100210:	e8 0f 3b 00 00       	call   80103d24 <acquire>
  b->refcnt--;
80100215:	8b 43 4c             	mov    0x4c(%ebx),%eax
80100218:	83 e8 01             	sub    $0x1,%eax
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	83 c4 10             	add    $0x10,%esp
80100221:	85 c0                	test   %eax,%eax
80100223:	75 2f                	jne    80100254 <brelse+0x73>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100225:	8b 43 54             	mov    0x54(%ebx),%eax
80100228:	8b 53 50             	mov    0x50(%ebx),%edx
8010022b:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010022e:	8b 43 50             	mov    0x50(%ebx),%eax
80100231:	8b 53 54             	mov    0x54(%ebx),%edx
80100234:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100237:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
8010023c:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
8010023f:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    bcache.head.next->prev = b;
80100246:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
8010024b:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010024e:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
80100254:	83 ec 0c             	sub    $0xc,%esp
80100257:	68 c0 b5 10 80       	push   $0x8010b5c0
8010025c:	e8 2c 3b 00 00       	call   80103d8d <release>
}
80100261:	83 c4 10             	add    $0x10,%esp
80100264:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100267:	5b                   	pop    %ebx
80100268:	5e                   	pop    %esi
80100269:	5d                   	pop    %ebp
8010026a:	c3                   	ret    
    panic("brelse");
8010026b:	83 ec 0c             	sub    $0xc,%esp
8010026e:	68 c6 67 10 80       	push   $0x801067c6
80100273:	e8 e4 00 00 00       	call   8010035c <panic>

80100278 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100278:	f3 0f 1e fb          	endbr32 
8010027c:	55                   	push   %ebp
8010027d:	89 e5                	mov    %esp,%ebp
8010027f:	57                   	push   %edi
80100280:	56                   	push   %esi
80100281:	53                   	push   %ebx
80100282:	83 ec 28             	sub    $0x28,%esp
80100285:	8b 7d 08             	mov    0x8(%ebp),%edi
80100288:	8b 75 0c             	mov    0xc(%ebp),%esi
8010028b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  uint target;
  int c;

  iunlock(ip);
8010028e:	57                   	push   %edi
8010028f:	e8 fc 13 00 00       	call   80101690 <iunlock>
  target = n;
80100294:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  acquire(&cons.lock);
80100297:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010029e:	e8 81 3a 00 00       	call   80103d24 <acquire>
  while(n > 0){
801002a3:	83 c4 10             	add    $0x10,%esp
801002a6:	85 db                	test   %ebx,%ebx
801002a8:	0f 8e 8f 00 00 00    	jle    8010033d <consoleread+0xc5>
    while(input.r == input.w){
801002ae:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002b3:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002b9:	75 47                	jne    80100302 <consoleread+0x8a>
      if(myproc()->killed){
801002bb:	e8 6e 30 00 00       	call   8010332e <myproc>
801002c0:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
801002c4:	75 17                	jne    801002dd <consoleread+0x65>
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c6:	83 ec 08             	sub    $0x8,%esp
801002c9:	68 20 a5 10 80       	push   $0x8010a520
801002ce:	68 a0 ff 10 80       	push   $0x8010ffa0
801002d3:	e8 19 35 00 00       	call   801037f1 <sleep>
801002d8:	83 c4 10             	add    $0x10,%esp
801002db:	eb d1                	jmp    801002ae <consoleread+0x36>
        release(&cons.lock);
801002dd:	83 ec 0c             	sub    $0xc,%esp
801002e0:	68 20 a5 10 80       	push   $0x8010a520
801002e5:	e8 a3 3a 00 00       	call   80103d8d <release>
        ilock(ip);
801002ea:	89 3c 24             	mov    %edi,(%esp)
801002ed:	e8 d8 12 00 00       	call   801015ca <ilock>
        return -1;
801002f2:	83 c4 10             	add    $0x10,%esp
801002f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801002fd:	5b                   	pop    %ebx
801002fe:	5e                   	pop    %esi
801002ff:	5f                   	pop    %edi
80100300:	5d                   	pop    %ebp
80100301:	c3                   	ret    
    c = input.buf[input.r++ % INPUT_BUF];
80100302:	8d 50 01             	lea    0x1(%eax),%edx
80100305:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
8010030b:	89 c2                	mov    %eax,%edx
8010030d:	83 e2 7f             	and    $0x7f,%edx
80100310:	0f b6 92 20 ff 10 80 	movzbl -0x7fef00e0(%edx),%edx
80100317:	0f be ca             	movsbl %dl,%ecx
    if(c == C('D')){  // EOF
8010031a:	80 fa 04             	cmp    $0x4,%dl
8010031d:	74 14                	je     80100333 <consoleread+0xbb>
    *dst++ = c;
8010031f:	8d 46 01             	lea    0x1(%esi),%eax
80100322:	88 16                	mov    %dl,(%esi)
    --n;
80100324:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
80100327:	83 f9 0a             	cmp    $0xa,%ecx
8010032a:	74 11                	je     8010033d <consoleread+0xc5>
    *dst++ = c;
8010032c:	89 c6                	mov    %eax,%esi
8010032e:	e9 73 ff ff ff       	jmp    801002a6 <consoleread+0x2e>
      if(n < target){
80100333:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
80100336:	73 05                	jae    8010033d <consoleread+0xc5>
        input.r--;
80100338:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
  release(&cons.lock);
8010033d:	83 ec 0c             	sub    $0xc,%esp
80100340:	68 20 a5 10 80       	push   $0x8010a520
80100345:	e8 43 3a 00 00       	call   80103d8d <release>
  ilock(ip);
8010034a:	89 3c 24             	mov    %edi,(%esp)
8010034d:	e8 78 12 00 00       	call   801015ca <ilock>
  return target - n;
80100352:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100355:	29 d8                	sub    %ebx,%eax
80100357:	83 c4 10             	add    $0x10,%esp
8010035a:	eb 9e                	jmp    801002fa <consoleread+0x82>

8010035c <panic>:
{
8010035c:	f3 0f 1e fb          	endbr32 
80100360:	55                   	push   %ebp
80100361:	89 e5                	mov    %esp,%ebp
80100363:	53                   	push   %ebx
80100364:	83 ec 34             	sub    $0x34,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100367:	fa                   	cli    
  cons.locking = 0;
80100368:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
8010036f:	00 00 00 
  cprintf("lapicid %d: panic: ", lapicid());
80100372:	e8 d8 20 00 00       	call   8010244f <lapicid>
80100377:	83 ec 08             	sub    $0x8,%esp
8010037a:	50                   	push   %eax
8010037b:	68 cd 67 10 80       	push   $0x801067cd
80100380:	e8 a4 02 00 00       	call   80100629 <cprintf>
  cprintf(s);
80100385:	83 c4 04             	add    $0x4,%esp
80100388:	ff 75 08             	pushl  0x8(%ebp)
8010038b:	e8 99 02 00 00       	call   80100629 <cprintf>
  cprintf("\n");
80100390:	c7 04 24 c3 71 10 80 	movl   $0x801071c3,(%esp)
80100397:	e8 8d 02 00 00       	call   80100629 <cprintf>
  getcallerpcs(&s, pcs);
8010039c:	83 c4 08             	add    $0x8,%esp
8010039f:	8d 45 d0             	lea    -0x30(%ebp),%eax
801003a2:	50                   	push   %eax
801003a3:	8d 45 08             	lea    0x8(%ebp),%eax
801003a6:	50                   	push   %eax
801003a7:	e8 47 38 00 00       	call   80103bf3 <getcallerpcs>
  for(i=0; i<10; i++)
801003ac:	83 c4 10             	add    $0x10,%esp
801003af:	bb 00 00 00 00       	mov    $0x0,%ebx
801003b4:	eb 17                	jmp    801003cd <panic+0x71>
    cprintf(" %p", pcs[i]);
801003b6:	83 ec 08             	sub    $0x8,%esp
801003b9:	ff 74 9d d0          	pushl  -0x30(%ebp,%ebx,4)
801003bd:	68 e1 67 10 80       	push   $0x801067e1
801003c2:	e8 62 02 00 00       	call   80100629 <cprintf>
  for(i=0; i<10; i++)
801003c7:	83 c3 01             	add    $0x1,%ebx
801003ca:	83 c4 10             	add    $0x10,%esp
801003cd:	83 fb 09             	cmp    $0x9,%ebx
801003d0:	7e e4                	jle    801003b6 <panic+0x5a>
  panicked = 1; // freeze other CPU
801003d2:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
801003d9:	00 00 00 
  for(;;)
801003dc:	eb fe                	jmp    801003dc <panic+0x80>

801003de <cgaputc>:
{
801003de:	55                   	push   %ebp
801003df:	89 e5                	mov    %esp,%ebp
801003e1:	57                   	push   %edi
801003e2:	56                   	push   %esi
801003e3:	53                   	push   %ebx
801003e4:	83 ec 0c             	sub    $0xc,%esp
801003e7:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801003e9:	b9 d4 03 00 00       	mov    $0x3d4,%ecx
801003ee:	b8 0e 00 00 00       	mov    $0xe,%eax
801003f3:	89 ca                	mov    %ecx,%edx
801003f5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801003f6:	bb d5 03 00 00       	mov    $0x3d5,%ebx
801003fb:	89 da                	mov    %ebx,%edx
801003fd:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
801003fe:	0f b6 f8             	movzbl %al,%edi
80100401:	c1 e7 08             	shl    $0x8,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100404:	b8 0f 00 00 00       	mov    $0xf,%eax
80100409:	89 ca                	mov    %ecx,%edx
8010040b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010040c:	89 da                	mov    %ebx,%edx
8010040e:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
8010040f:	0f b6 c8             	movzbl %al,%ecx
80100412:	09 f9                	or     %edi,%ecx
  if(c == '\n')
80100414:	83 fe 0a             	cmp    $0xa,%esi
80100417:	74 66                	je     8010047f <cgaputc+0xa1>
  else if(c == BACKSPACE){
80100419:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010041f:	74 7f                	je     801004a0 <cgaputc+0xc2>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100421:	89 f0                	mov    %esi,%eax
80100423:	0f b6 f0             	movzbl %al,%esi
80100426:	8d 59 01             	lea    0x1(%ecx),%ebx
80100429:	66 81 ce 00 07       	or     $0x700,%si
8010042e:	66 89 b4 09 00 80 0b 	mov    %si,-0x7ff48000(%ecx,%ecx,1)
80100435:	80 
  if(pos < 0 || pos > 25*80)
80100436:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010043c:	77 6f                	ja     801004ad <cgaputc+0xcf>
  if((pos/80) >= 24){  // Scroll up.
8010043e:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
80100444:	7f 74                	jg     801004ba <cgaputc+0xdc>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100446:	be d4 03 00 00       	mov    $0x3d4,%esi
8010044b:	b8 0e 00 00 00       	mov    $0xe,%eax
80100450:	89 f2                	mov    %esi,%edx
80100452:	ee                   	out    %al,(%dx)
  outb(CRTPORT+1, pos>>8);
80100453:	89 d8                	mov    %ebx,%eax
80100455:	c1 f8 08             	sar    $0x8,%eax
80100458:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
8010045d:	89 ca                	mov    %ecx,%edx
8010045f:	ee                   	out    %al,(%dx)
80100460:	b8 0f 00 00 00       	mov    $0xf,%eax
80100465:	89 f2                	mov    %esi,%edx
80100467:	ee                   	out    %al,(%dx)
80100468:	89 d8                	mov    %ebx,%eax
8010046a:	89 ca                	mov    %ecx,%edx
8010046c:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
8010046d:	66 c7 84 1b 00 80 0b 	movw   $0x720,-0x7ff48000(%ebx,%ebx,1)
80100474:	80 20 07 
}
80100477:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010047a:	5b                   	pop    %ebx
8010047b:	5e                   	pop    %esi
8010047c:	5f                   	pop    %edi
8010047d:	5d                   	pop    %ebp
8010047e:	c3                   	ret    
    pos += 80 - pos%80;
8010047f:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100484:	89 c8                	mov    %ecx,%eax
80100486:	f7 ea                	imul   %edx
80100488:	c1 fa 05             	sar    $0x5,%edx
8010048b:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010048e:	c1 e0 04             	shl    $0x4,%eax
80100491:	89 ca                	mov    %ecx,%edx
80100493:	29 c2                	sub    %eax,%edx
80100495:	bb 50 00 00 00       	mov    $0x50,%ebx
8010049a:	29 d3                	sub    %edx,%ebx
8010049c:	01 cb                	add    %ecx,%ebx
8010049e:	eb 96                	jmp    80100436 <cgaputc+0x58>
    if(pos > 0) --pos;
801004a0:	85 c9                	test   %ecx,%ecx
801004a2:	7e 05                	jle    801004a9 <cgaputc+0xcb>
801004a4:	8d 59 ff             	lea    -0x1(%ecx),%ebx
801004a7:	eb 8d                	jmp    80100436 <cgaputc+0x58>
  pos |= inb(CRTPORT+1);
801004a9:	89 cb                	mov    %ecx,%ebx
801004ab:	eb 89                	jmp    80100436 <cgaputc+0x58>
    panic("pos under/overflow");
801004ad:	83 ec 0c             	sub    $0xc,%esp
801004b0:	68 e5 67 10 80       	push   $0x801067e5
801004b5:	e8 a2 fe ff ff       	call   8010035c <panic>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004ba:	83 ec 04             	sub    $0x4,%esp
801004bd:	68 60 0e 00 00       	push   $0xe60
801004c2:	68 a0 80 0b 80       	push   $0x800b80a0
801004c7:	68 00 80 0b 80       	push   $0x800b8000
801004cc:	e8 87 39 00 00       	call   80103e58 <memmove>
    pos -= 80;
801004d1:	83 eb 50             	sub    $0x50,%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004d4:	b8 80 07 00 00       	mov    $0x780,%eax
801004d9:	29 d8                	sub    %ebx,%eax
801004db:	8d 94 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%edx
801004e2:	83 c4 0c             	add    $0xc,%esp
801004e5:	01 c0                	add    %eax,%eax
801004e7:	50                   	push   %eax
801004e8:	6a 00                	push   $0x0
801004ea:	52                   	push   %edx
801004eb:	e8 e8 38 00 00       	call   80103dd8 <memset>
801004f0:	83 c4 10             	add    $0x10,%esp
801004f3:	e9 4e ff ff ff       	jmp    80100446 <cgaputc+0x68>

801004f8 <consputc>:
  if(panicked){
801004f8:	83 3d 58 a5 10 80 00 	cmpl   $0x0,0x8010a558
801004ff:	74 03                	je     80100504 <consputc+0xc>
  asm volatile("cli");
80100501:	fa                   	cli    
    for(;;)
80100502:	eb fe                	jmp    80100502 <consputc+0xa>
{
80100504:	55                   	push   %ebp
80100505:	89 e5                	mov    %esp,%ebp
80100507:	53                   	push   %ebx
80100508:	83 ec 04             	sub    $0x4,%esp
8010050b:	89 c3                	mov    %eax,%ebx
  if(c == BACKSPACE){
8010050d:	3d 00 01 00 00       	cmp    $0x100,%eax
80100512:	74 18                	je     8010052c <consputc+0x34>
    uartputc(c);
80100514:	83 ec 0c             	sub    $0xc,%esp
80100517:	50                   	push   %eax
80100518:	e8 33 4d 00 00       	call   80105250 <uartputc>
8010051d:	83 c4 10             	add    $0x10,%esp
  cgaputc(c);
80100520:	89 d8                	mov    %ebx,%eax
80100522:	e8 b7 fe ff ff       	call   801003de <cgaputc>
}
80100527:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010052a:	c9                   	leave  
8010052b:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
8010052c:	83 ec 0c             	sub    $0xc,%esp
8010052f:	6a 08                	push   $0x8
80100531:	e8 1a 4d 00 00       	call   80105250 <uartputc>
80100536:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
8010053d:	e8 0e 4d 00 00       	call   80105250 <uartputc>
80100542:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100549:	e8 02 4d 00 00       	call   80105250 <uartputc>
8010054e:	83 c4 10             	add    $0x10,%esp
80100551:	eb cd                	jmp    80100520 <consputc+0x28>

80100553 <printint>:
{
80100553:	55                   	push   %ebp
80100554:	89 e5                	mov    %esp,%ebp
80100556:	57                   	push   %edi
80100557:	56                   	push   %esi
80100558:	53                   	push   %ebx
80100559:	83 ec 2c             	sub    $0x2c,%esp
8010055c:	89 d6                	mov    %edx,%esi
8010055e:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
80100561:	85 c9                	test   %ecx,%ecx
80100563:	74 0c                	je     80100571 <printint+0x1e>
80100565:	89 c7                	mov    %eax,%edi
80100567:	c1 ef 1f             	shr    $0x1f,%edi
8010056a:	89 7d d4             	mov    %edi,-0x2c(%ebp)
8010056d:	85 c0                	test   %eax,%eax
8010056f:	78 38                	js     801005a9 <printint+0x56>
    x = xx;
80100571:	89 c1                	mov    %eax,%ecx
  i = 0;
80100573:	bb 00 00 00 00       	mov    $0x0,%ebx
    buf[i++] = digits[x % base];
80100578:	89 c8                	mov    %ecx,%eax
8010057a:	ba 00 00 00 00       	mov    $0x0,%edx
8010057f:	f7 f6                	div    %esi
80100581:	89 df                	mov    %ebx,%edi
80100583:	83 c3 01             	add    $0x1,%ebx
80100586:	0f b6 92 10 68 10 80 	movzbl -0x7fef97f0(%edx),%edx
8010058d:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
80100591:	89 ca                	mov    %ecx,%edx
80100593:	89 c1                	mov    %eax,%ecx
80100595:	39 d6                	cmp    %edx,%esi
80100597:	76 df                	jbe    80100578 <printint+0x25>
  if(sign)
80100599:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
8010059d:	74 1a                	je     801005b9 <printint+0x66>
    buf[i++] = '-';
8010059f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
801005a4:	8d 5f 02             	lea    0x2(%edi),%ebx
801005a7:	eb 10                	jmp    801005b9 <printint+0x66>
    x = -xx;
801005a9:	f7 d8                	neg    %eax
801005ab:	89 c1                	mov    %eax,%ecx
801005ad:	eb c4                	jmp    80100573 <printint+0x20>
    consputc(buf[i]);
801005af:	0f be 44 1d d8       	movsbl -0x28(%ebp,%ebx,1),%eax
801005b4:	e8 3f ff ff ff       	call   801004f8 <consputc>
  while(--i >= 0)
801005b9:	83 eb 01             	sub    $0x1,%ebx
801005bc:	79 f1                	jns    801005af <printint+0x5c>
}
801005be:	83 c4 2c             	add    $0x2c,%esp
801005c1:	5b                   	pop    %ebx
801005c2:	5e                   	pop    %esi
801005c3:	5f                   	pop    %edi
801005c4:	5d                   	pop    %ebp
801005c5:	c3                   	ret    

801005c6 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005c6:	f3 0f 1e fb          	endbr32 
801005ca:	55                   	push   %ebp
801005cb:	89 e5                	mov    %esp,%ebp
801005cd:	57                   	push   %edi
801005ce:	56                   	push   %esi
801005cf:	53                   	push   %ebx
801005d0:	83 ec 18             	sub    $0x18,%esp
801005d3:	8b 7d 0c             	mov    0xc(%ebp),%edi
801005d6:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
801005d9:	ff 75 08             	pushl  0x8(%ebp)
801005dc:	e8 af 10 00 00       	call   80101690 <iunlock>
  acquire(&cons.lock);
801005e1:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801005e8:	e8 37 37 00 00       	call   80103d24 <acquire>
  for(i = 0; i < n; i++)
801005ed:	83 c4 10             	add    $0x10,%esp
801005f0:	bb 00 00 00 00       	mov    $0x0,%ebx
801005f5:	39 f3                	cmp    %esi,%ebx
801005f7:	7d 0e                	jge    80100607 <consolewrite+0x41>
    consputc(buf[i] & 0xff);
801005f9:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801005fd:	e8 f6 fe ff ff       	call   801004f8 <consputc>
  for(i = 0; i < n; i++)
80100602:	83 c3 01             	add    $0x1,%ebx
80100605:	eb ee                	jmp    801005f5 <consolewrite+0x2f>
  release(&cons.lock);
80100607:	83 ec 0c             	sub    $0xc,%esp
8010060a:	68 20 a5 10 80       	push   $0x8010a520
8010060f:	e8 79 37 00 00       	call   80103d8d <release>
  ilock(ip);
80100614:	83 c4 04             	add    $0x4,%esp
80100617:	ff 75 08             	pushl  0x8(%ebp)
8010061a:	e8 ab 0f 00 00       	call   801015ca <ilock>

  return n;
}
8010061f:	89 f0                	mov    %esi,%eax
80100621:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100624:	5b                   	pop    %ebx
80100625:	5e                   	pop    %esi
80100626:	5f                   	pop    %edi
80100627:	5d                   	pop    %ebp
80100628:	c3                   	ret    

80100629 <cprintf>:
{
80100629:	f3 0f 1e fb          	endbr32 
8010062d:	55                   	push   %ebp
8010062e:	89 e5                	mov    %esp,%ebp
80100630:	57                   	push   %edi
80100631:	56                   	push   %esi
80100632:	53                   	push   %ebx
80100633:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100636:	a1 54 a5 10 80       	mov    0x8010a554,%eax
8010063b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
8010063e:	85 c0                	test   %eax,%eax
80100640:	75 10                	jne    80100652 <cprintf+0x29>
  if (fmt == 0)
80100642:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80100646:	74 1c                	je     80100664 <cprintf+0x3b>
  argp = (uint*)(void*)(&fmt + 1);
80100648:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010064b:	be 00 00 00 00       	mov    $0x0,%esi
80100650:	eb 27                	jmp    80100679 <cprintf+0x50>
    acquire(&cons.lock);
80100652:	83 ec 0c             	sub    $0xc,%esp
80100655:	68 20 a5 10 80       	push   $0x8010a520
8010065a:	e8 c5 36 00 00       	call   80103d24 <acquire>
8010065f:	83 c4 10             	add    $0x10,%esp
80100662:	eb de                	jmp    80100642 <cprintf+0x19>
    panic("null fmt");
80100664:	83 ec 0c             	sub    $0xc,%esp
80100667:	68 ff 67 10 80       	push   $0x801067ff
8010066c:	e8 eb fc ff ff       	call   8010035c <panic>
      consputc(c);
80100671:	e8 82 fe ff ff       	call   801004f8 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100676:	83 c6 01             	add    $0x1,%esi
80100679:	8b 55 08             	mov    0x8(%ebp),%edx
8010067c:	0f b6 04 32          	movzbl (%edx,%esi,1),%eax
80100680:	85 c0                	test   %eax,%eax
80100682:	0f 84 b1 00 00 00    	je     80100739 <cprintf+0x110>
    if(c != '%'){
80100688:	83 f8 25             	cmp    $0x25,%eax
8010068b:	75 e4                	jne    80100671 <cprintf+0x48>
    c = fmt[++i] & 0xff;
8010068d:	83 c6 01             	add    $0x1,%esi
80100690:	0f b6 1c 32          	movzbl (%edx,%esi,1),%ebx
    if(c == 0)
80100694:	85 db                	test   %ebx,%ebx
80100696:	0f 84 9d 00 00 00    	je     80100739 <cprintf+0x110>
    switch(c){
8010069c:	83 fb 70             	cmp    $0x70,%ebx
8010069f:	74 2e                	je     801006cf <cprintf+0xa6>
801006a1:	7f 22                	jg     801006c5 <cprintf+0x9c>
801006a3:	83 fb 25             	cmp    $0x25,%ebx
801006a6:	74 6c                	je     80100714 <cprintf+0xeb>
801006a8:	83 fb 64             	cmp    $0x64,%ebx
801006ab:	75 76                	jne    80100723 <cprintf+0xfa>
      printint(*argp++, 10, 1);
801006ad:	8d 5f 04             	lea    0x4(%edi),%ebx
801006b0:	8b 07                	mov    (%edi),%eax
801006b2:	b9 01 00 00 00       	mov    $0x1,%ecx
801006b7:	ba 0a 00 00 00       	mov    $0xa,%edx
801006bc:	e8 92 fe ff ff       	call   80100553 <printint>
801006c1:	89 df                	mov    %ebx,%edi
      break;
801006c3:	eb b1                	jmp    80100676 <cprintf+0x4d>
    switch(c){
801006c5:	83 fb 73             	cmp    $0x73,%ebx
801006c8:	74 1d                	je     801006e7 <cprintf+0xbe>
801006ca:	83 fb 78             	cmp    $0x78,%ebx
801006cd:	75 54                	jne    80100723 <cprintf+0xfa>
      printint(*argp++, 16, 0);
801006cf:	8d 5f 04             	lea    0x4(%edi),%ebx
801006d2:	8b 07                	mov    (%edi),%eax
801006d4:	b9 00 00 00 00       	mov    $0x0,%ecx
801006d9:	ba 10 00 00 00       	mov    $0x10,%edx
801006de:	e8 70 fe ff ff       	call   80100553 <printint>
801006e3:	89 df                	mov    %ebx,%edi
      break;
801006e5:	eb 8f                	jmp    80100676 <cprintf+0x4d>
      if((s = (char*)*argp++) == 0)
801006e7:	8d 47 04             	lea    0x4(%edi),%eax
801006ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006ed:	8b 1f                	mov    (%edi),%ebx
801006ef:	85 db                	test   %ebx,%ebx
801006f1:	75 05                	jne    801006f8 <cprintf+0xcf>
        s = "(null)";
801006f3:	bb f8 67 10 80       	mov    $0x801067f8,%ebx
      for(; *s; s++)
801006f8:	0f b6 03             	movzbl (%ebx),%eax
801006fb:	84 c0                	test   %al,%al
801006fd:	74 0d                	je     8010070c <cprintf+0xe3>
        consputc(*s);
801006ff:	0f be c0             	movsbl %al,%eax
80100702:	e8 f1 fd ff ff       	call   801004f8 <consputc>
      for(; *s; s++)
80100707:	83 c3 01             	add    $0x1,%ebx
8010070a:	eb ec                	jmp    801006f8 <cprintf+0xcf>
      if((s = (char*)*argp++) == 0)
8010070c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010070f:	e9 62 ff ff ff       	jmp    80100676 <cprintf+0x4d>
      consputc('%');
80100714:	b8 25 00 00 00       	mov    $0x25,%eax
80100719:	e8 da fd ff ff       	call   801004f8 <consputc>
      break;
8010071e:	e9 53 ff ff ff       	jmp    80100676 <cprintf+0x4d>
      consputc('%');
80100723:	b8 25 00 00 00       	mov    $0x25,%eax
80100728:	e8 cb fd ff ff       	call   801004f8 <consputc>
      consputc(c);
8010072d:	89 d8                	mov    %ebx,%eax
8010072f:	e8 c4 fd ff ff       	call   801004f8 <consputc>
      break;
80100734:	e9 3d ff ff ff       	jmp    80100676 <cprintf+0x4d>
  if(locking)
80100739:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
8010073d:	75 08                	jne    80100747 <cprintf+0x11e>
}
8010073f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100742:	5b                   	pop    %ebx
80100743:	5e                   	pop    %esi
80100744:	5f                   	pop    %edi
80100745:	5d                   	pop    %ebp
80100746:	c3                   	ret    
    release(&cons.lock);
80100747:	83 ec 0c             	sub    $0xc,%esp
8010074a:	68 20 a5 10 80       	push   $0x8010a520
8010074f:	e8 39 36 00 00       	call   80103d8d <release>
80100754:	83 c4 10             	add    $0x10,%esp
}
80100757:	eb e6                	jmp    8010073f <cprintf+0x116>

80100759 <consoleintr>:
{
80100759:	f3 0f 1e fb          	endbr32 
8010075d:	55                   	push   %ebp
8010075e:	89 e5                	mov    %esp,%ebp
80100760:	57                   	push   %edi
80100761:	56                   	push   %esi
80100762:	53                   	push   %ebx
80100763:	83 ec 18             	sub    $0x18,%esp
80100766:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
80100769:	68 20 a5 10 80       	push   $0x8010a520
8010076e:	e8 b1 35 00 00       	call   80103d24 <acquire>
  while((c = getc()) >= 0){
80100773:	83 c4 10             	add    $0x10,%esp
  int c, doprocdump = 0;
80100776:	be 00 00 00 00       	mov    $0x0,%esi
  while((c = getc()) >= 0){
8010077b:	eb 13                	jmp    80100790 <consoleintr+0x37>
    switch(c){
8010077d:	83 ff 08             	cmp    $0x8,%edi
80100780:	0f 84 d9 00 00 00    	je     8010085f <consoleintr+0x106>
80100786:	83 ff 10             	cmp    $0x10,%edi
80100789:	75 25                	jne    801007b0 <consoleintr+0x57>
8010078b:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
80100790:	ff d3                	call   *%ebx
80100792:	89 c7                	mov    %eax,%edi
80100794:	85 c0                	test   %eax,%eax
80100796:	0f 88 f5 00 00 00    	js     80100891 <consoleintr+0x138>
    switch(c){
8010079c:	83 ff 15             	cmp    $0x15,%edi
8010079f:	0f 84 93 00 00 00    	je     80100838 <consoleintr+0xdf>
801007a5:	7e d6                	jle    8010077d <consoleintr+0x24>
801007a7:	83 ff 7f             	cmp    $0x7f,%edi
801007aa:	0f 84 af 00 00 00    	je     8010085f <consoleintr+0x106>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801007b0:	85 ff                	test   %edi,%edi
801007b2:	74 dc                	je     80100790 <consoleintr+0x37>
801007b4:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801007b9:	89 c2                	mov    %eax,%edx
801007bb:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
801007c1:	83 fa 7f             	cmp    $0x7f,%edx
801007c4:	77 ca                	ja     80100790 <consoleintr+0x37>
        c = (c == '\r') ? '\n' : c;
801007c6:	83 ff 0d             	cmp    $0xd,%edi
801007c9:	0f 84 b8 00 00 00    	je     80100887 <consoleintr+0x12e>
        input.buf[input.e++ % INPUT_BUF] = c;
801007cf:	8d 50 01             	lea    0x1(%eax),%edx
801007d2:	89 15 a8 ff 10 80    	mov    %edx,0x8010ffa8
801007d8:	83 e0 7f             	and    $0x7f,%eax
801007db:	89 f9                	mov    %edi,%ecx
801007dd:	88 88 20 ff 10 80    	mov    %cl,-0x7fef00e0(%eax)
        consputc(c);
801007e3:	89 f8                	mov    %edi,%eax
801007e5:	e8 0e fd ff ff       	call   801004f8 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801007ea:	83 ff 0a             	cmp    $0xa,%edi
801007ed:	0f 94 c2             	sete   %dl
801007f0:	83 ff 04             	cmp    $0x4,%edi
801007f3:	0f 94 c0             	sete   %al
801007f6:	08 c2                	or     %al,%dl
801007f8:	75 10                	jne    8010080a <consoleintr+0xb1>
801007fa:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801007ff:	83 e8 80             	sub    $0xffffff80,%eax
80100802:	39 05 a8 ff 10 80    	cmp    %eax,0x8010ffa8
80100808:	75 86                	jne    80100790 <consoleintr+0x37>
          input.w = input.e;
8010080a:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010080f:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
80100814:	83 ec 0c             	sub    $0xc,%esp
80100817:	68 a0 ff 10 80       	push   $0x8010ffa0
8010081c:	e8 3d 31 00 00       	call   8010395e <wakeup>
80100821:	83 c4 10             	add    $0x10,%esp
80100824:	e9 67 ff ff ff       	jmp    80100790 <consoleintr+0x37>
        input.e--;
80100829:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
8010082e:	b8 00 01 00 00       	mov    $0x100,%eax
80100833:	e8 c0 fc ff ff       	call   801004f8 <consputc>
      while(input.e != input.w &&
80100838:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010083d:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
80100843:	0f 84 47 ff ff ff    	je     80100790 <consoleintr+0x37>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100849:	83 e8 01             	sub    $0x1,%eax
8010084c:	89 c2                	mov    %eax,%edx
8010084e:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100851:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
80100858:	75 cf                	jne    80100829 <consoleintr+0xd0>
8010085a:	e9 31 ff ff ff       	jmp    80100790 <consoleintr+0x37>
      if(input.e != input.w){
8010085f:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100864:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010086a:	0f 84 20 ff ff ff    	je     80100790 <consoleintr+0x37>
        input.e--;
80100870:	83 e8 01             	sub    $0x1,%eax
80100873:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100878:	b8 00 01 00 00       	mov    $0x100,%eax
8010087d:	e8 76 fc ff ff       	call   801004f8 <consputc>
80100882:	e9 09 ff ff ff       	jmp    80100790 <consoleintr+0x37>
        c = (c == '\r') ? '\n' : c;
80100887:	bf 0a 00 00 00       	mov    $0xa,%edi
8010088c:	e9 3e ff ff ff       	jmp    801007cf <consoleintr+0x76>
  release(&cons.lock);
80100891:	83 ec 0c             	sub    $0xc,%esp
80100894:	68 20 a5 10 80       	push   $0x8010a520
80100899:	e8 ef 34 00 00       	call   80103d8d <release>
  if(doprocdump) {
8010089e:	83 c4 10             	add    $0x10,%esp
801008a1:	85 f6                	test   %esi,%esi
801008a3:	75 08                	jne    801008ad <consoleintr+0x154>
}
801008a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801008a8:	5b                   	pop    %ebx
801008a9:	5e                   	pop    %esi
801008aa:	5f                   	pop    %edi
801008ab:	5d                   	pop    %ebp
801008ac:	c3                   	ret    
    procdump();  // now call procdump() wo. cons.lock held
801008ad:	e8 51 31 00 00       	call   80103a03 <procdump>
}
801008b2:	eb f1                	jmp    801008a5 <consoleintr+0x14c>

801008b4 <consoleinit>:

void
consoleinit(void)
{
801008b4:	f3 0f 1e fb          	endbr32 
801008b8:	55                   	push   %ebp
801008b9:	89 e5                	mov    %esp,%ebp
801008bb:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801008be:	68 08 68 10 80       	push   $0x80106808
801008c3:	68 20 a5 10 80       	push   $0x8010a520
801008c8:	e8 07 33 00 00       	call   80103bd4 <initlock>

  devsw[CONSOLE].write = consolewrite;
801008cd:	c7 05 6c 09 11 80 c6 	movl   $0x801005c6,0x8011096c
801008d4:	05 10 80 
  devsw[CONSOLE].read = consoleread;
801008d7:	c7 05 68 09 11 80 78 	movl   $0x80100278,0x80110968
801008de:	02 10 80 
  cons.locking = 1;
801008e1:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
801008e8:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
801008eb:	83 c4 08             	add    $0x8,%esp
801008ee:	6a 00                	push   $0x0
801008f0:	6a 01                	push   $0x1
801008f2:	e8 04 17 00 00       	call   80101ffb <ioapicenable>
}
801008f7:	83 c4 10             	add    $0x10,%esp
801008fa:	c9                   	leave  
801008fb:	c3                   	ret    

801008fc <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801008fc:	f3 0f 1e fb          	endbr32 
80100900:	55                   	push   %ebp
80100901:	89 e5                	mov    %esp,%ebp
80100903:	57                   	push   %edi
80100904:	56                   	push   %esi
80100905:	53                   	push   %ebx
80100906:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
8010090c:	e8 1d 2a 00 00       	call   8010332e <myproc>
80100911:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100917:	e8 69 1f 00 00       	call   80102885 <begin_op>

  if((ip = namei(path)) == 0){
8010091c:	83 ec 0c             	sub    $0xc,%esp
8010091f:	ff 75 08             	pushl  0x8(%ebp)
80100922:	e8 28 13 00 00       	call   80101c4f <namei>
80100927:	83 c4 10             	add    $0x10,%esp
8010092a:	85 c0                	test   %eax,%eax
8010092c:	74 56                	je     80100984 <exec+0x88>
8010092e:	89 c3                	mov    %eax,%ebx
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100930:	83 ec 0c             	sub    $0xc,%esp
80100933:	50                   	push   %eax
80100934:	e8 91 0c 00 00       	call   801015ca <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100939:	6a 34                	push   $0x34
8010093b:	6a 00                	push   $0x0
8010093d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100943:	50                   	push   %eax
80100944:	53                   	push   %ebx
80100945:	e8 86 0e 00 00       	call   801017d0 <readi>
8010094a:	83 c4 20             	add    $0x20,%esp
8010094d:	83 f8 34             	cmp    $0x34,%eax
80100950:	75 0c                	jne    8010095e <exec+0x62>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100952:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100959:	45 4c 46 
8010095c:	74 42                	je     801009a0 <exec+0xa4>
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
8010095e:	85 db                	test   %ebx,%ebx
80100960:	0f 84 c9 02 00 00    	je     80100c2f <exec+0x333>
    iunlockput(ip);
80100966:	83 ec 0c             	sub    $0xc,%esp
80100969:	53                   	push   %ebx
8010096a:	e8 0e 0e 00 00       	call   8010177d <iunlockput>
    end_op();
8010096f:	e8 8f 1f 00 00       	call   80102903 <end_op>
80100974:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100977:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010097c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010097f:	5b                   	pop    %ebx
80100980:	5e                   	pop    %esi
80100981:	5f                   	pop    %edi
80100982:	5d                   	pop    %ebp
80100983:	c3                   	ret    
    end_op();
80100984:	e8 7a 1f 00 00       	call   80102903 <end_op>
    cprintf("exec: fail\n");
80100989:	83 ec 0c             	sub    $0xc,%esp
8010098c:	68 21 68 10 80       	push   $0x80106821
80100991:	e8 93 fc ff ff       	call   80100629 <cprintf>
    return -1;
80100996:	83 c4 10             	add    $0x10,%esp
80100999:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010099e:	eb dc                	jmp    8010097c <exec+0x80>
  if((pgdir = setupkvm()) == 0)
801009a0:	e8 51 5b 00 00       	call   801064f6 <setupkvm>
801009a5:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
801009ab:	85 c0                	test   %eax,%eax
801009ad:	0f 84 09 01 00 00    	je     80100abc <exec+0x1c0>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801009b3:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  sz = 0;
801009b9:	bf 00 00 00 00       	mov    $0x0,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801009be:	be 00 00 00 00       	mov    $0x0,%esi
801009c3:	eb 0c                	jmp    801009d1 <exec+0xd5>
801009c5:	83 c6 01             	add    $0x1,%esi
801009c8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
801009ce:	83 c0 20             	add    $0x20,%eax
801009d1:	0f b7 95 50 ff ff ff 	movzwl -0xb0(%ebp),%edx
801009d8:	39 f2                	cmp    %esi,%edx
801009da:	0f 8e 98 00 00 00    	jle    80100a78 <exec+0x17c>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
801009e0:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
801009e6:	6a 20                	push   $0x20
801009e8:	50                   	push   %eax
801009e9:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
801009ef:	50                   	push   %eax
801009f0:	53                   	push   %ebx
801009f1:	e8 da 0d 00 00       	call   801017d0 <readi>
801009f6:	83 c4 10             	add    $0x10,%esp
801009f9:	83 f8 20             	cmp    $0x20,%eax
801009fc:	0f 85 ba 00 00 00    	jne    80100abc <exec+0x1c0>
    if(ph.type != ELF_PROG_LOAD)
80100a02:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100a09:	75 ba                	jne    801009c5 <exec+0xc9>
    if(ph.memsz < ph.filesz)
80100a0b:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100a11:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100a17:	0f 82 9f 00 00 00    	jb     80100abc <exec+0x1c0>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100a1d:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100a23:	0f 82 93 00 00 00    	jb     80100abc <exec+0x1c0>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100a29:	83 ec 04             	sub    $0x4,%esp
80100a2c:	50                   	push   %eax
80100a2d:	57                   	push   %edi
80100a2e:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100a34:	e8 2d 59 00 00       	call   80106366 <allocuvm>
80100a39:	89 c7                	mov    %eax,%edi
80100a3b:	83 c4 10             	add    $0x10,%esp
80100a3e:	85 c0                	test   %eax,%eax
80100a40:	74 7a                	je     80100abc <exec+0x1c0>
    if(ph.vaddr % PGSIZE != 0)
80100a42:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100a48:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100a4d:	75 6d                	jne    80100abc <exec+0x1c0>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100a4f:	83 ec 0c             	sub    $0xc,%esp
80100a52:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100a58:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100a5e:	53                   	push   %ebx
80100a5f:	50                   	push   %eax
80100a60:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100a66:	e8 9e 57 00 00       	call   80106209 <loaduvm>
80100a6b:	83 c4 20             	add    $0x20,%esp
80100a6e:	85 c0                	test   %eax,%eax
80100a70:	0f 89 4f ff ff ff    	jns    801009c5 <exec+0xc9>
80100a76:	eb 44                	jmp    80100abc <exec+0x1c0>
  iunlockput(ip);
80100a78:	83 ec 0c             	sub    $0xc,%esp
80100a7b:	53                   	push   %ebx
80100a7c:	e8 fc 0c 00 00       	call   8010177d <iunlockput>
  end_op();
80100a81:	e8 7d 1e 00 00       	call   80102903 <end_op>
  sz = PGROUNDUP(sz);
80100a86:	8d 87 ff 0f 00 00    	lea    0xfff(%edi),%eax
80100a8c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100a91:	83 c4 0c             	add    $0xc,%esp
80100a94:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100a9a:	52                   	push   %edx
80100a9b:	50                   	push   %eax
80100a9c:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100aa2:	57                   	push   %edi
80100aa3:	e8 be 58 00 00       	call   80106366 <allocuvm>
80100aa8:	89 c6                	mov    %eax,%esi
80100aaa:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100ab0:	83 c4 10             	add    $0x10,%esp
80100ab3:	85 c0                	test   %eax,%eax
80100ab5:	75 24                	jne    80100adb <exec+0x1df>
  ip = 0;
80100ab7:	bb 00 00 00 00       	mov    $0x0,%ebx
  if(pgdir)
80100abc:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100ac2:	85 c0                	test   %eax,%eax
80100ac4:	0f 84 94 fe ff ff    	je     8010095e <exec+0x62>
    freevm(pgdir);
80100aca:	83 ec 0c             	sub    $0xc,%esp
80100acd:	50                   	push   %eax
80100ace:	e8 9b 59 00 00       	call   8010646e <freevm>
80100ad3:	83 c4 10             	add    $0x10,%esp
80100ad6:	e9 83 fe ff ff       	jmp    8010095e <exec+0x62>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100adb:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100ae1:	83 ec 08             	sub    $0x8,%esp
80100ae4:	50                   	push   %eax
80100ae5:	57                   	push   %edi
80100ae6:	e8 98 5a 00 00       	call   80106583 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100aeb:	83 c4 10             	add    $0x10,%esp
80100aee:	bf 00 00 00 00       	mov    $0x0,%edi
80100af3:	8b 45 0c             	mov    0xc(%ebp),%eax
80100af6:	8d 1c b8             	lea    (%eax,%edi,4),%ebx
80100af9:	8b 03                	mov    (%ebx),%eax
80100afb:	85 c0                	test   %eax,%eax
80100afd:	74 4d                	je     80100b4c <exec+0x250>
    if(argc >= MAXARG)
80100aff:	83 ff 1f             	cmp    $0x1f,%edi
80100b02:	0f 87 13 01 00 00    	ja     80100c1b <exec+0x31f>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100b08:	83 ec 0c             	sub    $0xc,%esp
80100b0b:	50                   	push   %eax
80100b0c:	e8 88 34 00 00       	call   80103f99 <strlen>
80100b11:	29 c6                	sub    %eax,%esi
80100b13:	83 ee 01             	sub    $0x1,%esi
80100b16:	83 e6 fc             	and    $0xfffffffc,%esi
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100b19:	83 c4 04             	add    $0x4,%esp
80100b1c:	ff 33                	pushl  (%ebx)
80100b1e:	e8 76 34 00 00       	call   80103f99 <strlen>
80100b23:	83 c0 01             	add    $0x1,%eax
80100b26:	50                   	push   %eax
80100b27:	ff 33                	pushl  (%ebx)
80100b29:	56                   	push   %esi
80100b2a:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b30:	e8 ea 5b 00 00       	call   8010671f <copyout>
80100b35:	83 c4 20             	add    $0x20,%esp
80100b38:	85 c0                	test   %eax,%eax
80100b3a:	0f 88 e5 00 00 00    	js     80100c25 <exec+0x329>
    ustack[3+argc] = sp;
80100b40:	89 b4 bd 64 ff ff ff 	mov    %esi,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100b47:	83 c7 01             	add    $0x1,%edi
80100b4a:	eb a7                	jmp    80100af3 <exec+0x1f7>
80100b4c:	89 f1                	mov    %esi,%ecx
80100b4e:	89 c3                	mov    %eax,%ebx
  ustack[3+argc] = 0;
80100b50:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100b57:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100b5b:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100b62:	ff ff ff 
  ustack[1] = argc;
80100b65:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100b6b:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100b72:	89 f2                	mov    %esi,%edx
80100b74:	29 c2                	sub    %eax,%edx
80100b76:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)
  sp -= (3+argc+1) * 4;
80100b7c:	8d 04 bd 10 00 00 00 	lea    0x10(,%edi,4),%eax
80100b83:	29 c1                	sub    %eax,%ecx
80100b85:	89 ce                	mov    %ecx,%esi
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100b87:	50                   	push   %eax
80100b88:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
80100b8e:	50                   	push   %eax
80100b8f:	51                   	push   %ecx
80100b90:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b96:	e8 84 5b 00 00       	call   8010671f <copyout>
80100b9b:	83 c4 10             	add    $0x10,%esp
80100b9e:	85 c0                	test   %eax,%eax
80100ba0:	0f 88 16 ff ff ff    	js     80100abc <exec+0x1c0>
  for(last=s=path; *s; s++)
80100ba6:	8b 55 08             	mov    0x8(%ebp),%edx
80100ba9:	89 d0                	mov    %edx,%eax
80100bab:	eb 03                	jmp    80100bb0 <exec+0x2b4>
80100bad:	83 c0 01             	add    $0x1,%eax
80100bb0:	0f b6 08             	movzbl (%eax),%ecx
80100bb3:	84 c9                	test   %cl,%cl
80100bb5:	74 0a                	je     80100bc1 <exec+0x2c5>
    if(*s == '/')
80100bb7:	80 f9 2f             	cmp    $0x2f,%cl
80100bba:	75 f1                	jne    80100bad <exec+0x2b1>
      last = s+1;
80100bbc:	8d 50 01             	lea    0x1(%eax),%edx
80100bbf:	eb ec                	jmp    80100bad <exec+0x2b1>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100bc1:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100bc7:	89 f8                	mov    %edi,%eax
80100bc9:	83 c0 6c             	add    $0x6c,%eax
80100bcc:	83 ec 04             	sub    $0x4,%esp
80100bcf:	6a 10                	push   $0x10
80100bd1:	52                   	push   %edx
80100bd2:	50                   	push   %eax
80100bd3:	e8 80 33 00 00       	call   80103f58 <safestrcpy>
  oldpgdir = curproc->pgdir;
80100bd8:	8b 5f 04             	mov    0x4(%edi),%ebx
  curproc->pgdir = pgdir;
80100bdb:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
80100be1:	89 4f 04             	mov    %ecx,0x4(%edi)
  curproc->sz = sz;
80100be4:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
80100bea:	89 0f                	mov    %ecx,(%edi)
  curproc->tf->eip = elf.entry;  // main
80100bec:	8b 47 18             	mov    0x18(%edi),%eax
80100bef:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100bf5:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100bf8:	8b 47 18             	mov    0x18(%edi),%eax
80100bfb:	89 70 44             	mov    %esi,0x44(%eax)
  switchuvm(curproc);
80100bfe:	89 3c 24             	mov    %edi,(%esp)
80100c01:	e8 4e 54 00 00       	call   80106054 <switchuvm>
  freevm(oldpgdir);
80100c06:	89 1c 24             	mov    %ebx,(%esp)
80100c09:	e8 60 58 00 00       	call   8010646e <freevm>
  return 0;
80100c0e:	83 c4 10             	add    $0x10,%esp
80100c11:	b8 00 00 00 00       	mov    $0x0,%eax
80100c16:	e9 61 fd ff ff       	jmp    8010097c <exec+0x80>
  ip = 0;
80100c1b:	bb 00 00 00 00       	mov    $0x0,%ebx
80100c20:	e9 97 fe ff ff       	jmp    80100abc <exec+0x1c0>
80100c25:	bb 00 00 00 00       	mov    $0x0,%ebx
80100c2a:	e9 8d fe ff ff       	jmp    80100abc <exec+0x1c0>
  return -1;
80100c2f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c34:	e9 43 fd ff ff       	jmp    8010097c <exec+0x80>

80100c39 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100c39:	f3 0f 1e fb          	endbr32 
80100c3d:	55                   	push   %ebp
80100c3e:	89 e5                	mov    %esp,%ebp
80100c40:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100c43:	68 2d 68 10 80       	push   $0x8010682d
80100c48:	68 c0 ff 10 80       	push   $0x8010ffc0
80100c4d:	e8 82 2f 00 00       	call   80103bd4 <initlock>
}
80100c52:	83 c4 10             	add    $0x10,%esp
80100c55:	c9                   	leave  
80100c56:	c3                   	ret    

80100c57 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100c57:	f3 0f 1e fb          	endbr32 
80100c5b:	55                   	push   %ebp
80100c5c:	89 e5                	mov    %esp,%ebp
80100c5e:	53                   	push   %ebx
80100c5f:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
80100c62:	68 c0 ff 10 80       	push   $0x8010ffc0
80100c67:	e8 b8 30 00 00       	call   80103d24 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100c6c:	83 c4 10             	add    $0x10,%esp
80100c6f:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
80100c74:	eb 03                	jmp    80100c79 <filealloc+0x22>
80100c76:	83 c3 18             	add    $0x18,%ebx
80100c79:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100c7f:	73 24                	jae    80100ca5 <filealloc+0x4e>
    if(f->ref == 0){
80100c81:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
80100c85:	75 ef                	jne    80100c76 <filealloc+0x1f>
      f->ref = 1;
80100c87:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100c8e:	83 ec 0c             	sub    $0xc,%esp
80100c91:	68 c0 ff 10 80       	push   $0x8010ffc0
80100c96:	e8 f2 30 00 00       	call   80103d8d <release>
      return f;
80100c9b:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ftable.lock);
  return 0;
}
80100c9e:	89 d8                	mov    %ebx,%eax
80100ca0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ca3:	c9                   	leave  
80100ca4:	c3                   	ret    
  release(&ftable.lock);
80100ca5:	83 ec 0c             	sub    $0xc,%esp
80100ca8:	68 c0 ff 10 80       	push   $0x8010ffc0
80100cad:	e8 db 30 00 00       	call   80103d8d <release>
  return 0;
80100cb2:	83 c4 10             	add    $0x10,%esp
80100cb5:	bb 00 00 00 00       	mov    $0x0,%ebx
80100cba:	eb e2                	jmp    80100c9e <filealloc+0x47>

80100cbc <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100cbc:	f3 0f 1e fb          	endbr32 
80100cc0:	55                   	push   %ebp
80100cc1:	89 e5                	mov    %esp,%ebp
80100cc3:	53                   	push   %ebx
80100cc4:	83 ec 10             	sub    $0x10,%esp
80100cc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100cca:	68 c0 ff 10 80       	push   $0x8010ffc0
80100ccf:	e8 50 30 00 00       	call   80103d24 <acquire>
  if(f->ref < 1)
80100cd4:	8b 43 04             	mov    0x4(%ebx),%eax
80100cd7:	83 c4 10             	add    $0x10,%esp
80100cda:	85 c0                	test   %eax,%eax
80100cdc:	7e 1a                	jle    80100cf8 <filedup+0x3c>
    panic("filedup");
  f->ref++;
80100cde:	83 c0 01             	add    $0x1,%eax
80100ce1:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ce4:	83 ec 0c             	sub    $0xc,%esp
80100ce7:	68 c0 ff 10 80       	push   $0x8010ffc0
80100cec:	e8 9c 30 00 00       	call   80103d8d <release>
  return f;
}
80100cf1:	89 d8                	mov    %ebx,%eax
80100cf3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100cf6:	c9                   	leave  
80100cf7:	c3                   	ret    
    panic("filedup");
80100cf8:	83 ec 0c             	sub    $0xc,%esp
80100cfb:	68 34 68 10 80       	push   $0x80106834
80100d00:	e8 57 f6 ff ff       	call   8010035c <panic>

80100d05 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100d05:	f3 0f 1e fb          	endbr32 
80100d09:	55                   	push   %ebp
80100d0a:	89 e5                	mov    %esp,%ebp
80100d0c:	53                   	push   %ebx
80100d0d:	83 ec 30             	sub    $0x30,%esp
80100d10:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100d13:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d18:	e8 07 30 00 00       	call   80103d24 <acquire>
  if(f->ref < 1)
80100d1d:	8b 43 04             	mov    0x4(%ebx),%eax
80100d20:	83 c4 10             	add    $0x10,%esp
80100d23:	85 c0                	test   %eax,%eax
80100d25:	7e 65                	jle    80100d8c <fileclose+0x87>
    panic("fileclose");
  if(--f->ref > 0){
80100d27:	83 e8 01             	sub    $0x1,%eax
80100d2a:	89 43 04             	mov    %eax,0x4(%ebx)
80100d2d:	85 c0                	test   %eax,%eax
80100d2f:	7f 68                	jg     80100d99 <fileclose+0x94>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100d31:	8b 03                	mov    (%ebx),%eax
80100d33:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d36:	8b 43 08             	mov    0x8(%ebx),%eax
80100d39:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100d3c:	8b 43 0c             	mov    0xc(%ebx),%eax
80100d3f:	89 45 ec             	mov    %eax,-0x14(%ebp)
80100d42:	8b 43 10             	mov    0x10(%ebx),%eax
80100d45:	89 45 f0             	mov    %eax,-0x10(%ebp)
  f->ref = 0;
80100d48:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
  f->type = FD_NONE;
80100d4f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  release(&ftable.lock);
80100d55:	83 ec 0c             	sub    $0xc,%esp
80100d58:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d5d:	e8 2b 30 00 00       	call   80103d8d <release>

  if(ff.type == FD_PIPE)
80100d62:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d65:	83 c4 10             	add    $0x10,%esp
80100d68:	83 f8 01             	cmp    $0x1,%eax
80100d6b:	74 41                	je     80100dae <fileclose+0xa9>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100d6d:	83 f8 02             	cmp    $0x2,%eax
80100d70:	75 37                	jne    80100da9 <fileclose+0xa4>
    begin_op();
80100d72:	e8 0e 1b 00 00       	call   80102885 <begin_op>
    iput(ff.ip);
80100d77:	83 ec 0c             	sub    $0xc,%esp
80100d7a:	ff 75 f0             	pushl  -0x10(%ebp)
80100d7d:	e8 57 09 00 00       	call   801016d9 <iput>
    end_op();
80100d82:	e8 7c 1b 00 00       	call   80102903 <end_op>
80100d87:	83 c4 10             	add    $0x10,%esp
80100d8a:	eb 1d                	jmp    80100da9 <fileclose+0xa4>
    panic("fileclose");
80100d8c:	83 ec 0c             	sub    $0xc,%esp
80100d8f:	68 3c 68 10 80       	push   $0x8010683c
80100d94:	e8 c3 f5 ff ff       	call   8010035c <panic>
    release(&ftable.lock);
80100d99:	83 ec 0c             	sub    $0xc,%esp
80100d9c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100da1:	e8 e7 2f 00 00       	call   80103d8d <release>
    return;
80100da6:	83 c4 10             	add    $0x10,%esp
  }
}
80100da9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dac:	c9                   	leave  
80100dad:	c3                   	ret    
    pipeclose(ff.pipe, ff.writable);
80100dae:	83 ec 08             	sub    $0x8,%esp
80100db1:	0f be 45 e9          	movsbl -0x17(%ebp),%eax
80100db5:	50                   	push   %eax
80100db6:	ff 75 ec             	pushl  -0x14(%ebp)
80100db9:	e8 8d 21 00 00       	call   80102f4b <pipeclose>
80100dbe:	83 c4 10             	add    $0x10,%esp
80100dc1:	eb e6                	jmp    80100da9 <fileclose+0xa4>

80100dc3 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100dc3:	f3 0f 1e fb          	endbr32 
80100dc7:	55                   	push   %ebp
80100dc8:	89 e5                	mov    %esp,%ebp
80100dca:	53                   	push   %ebx
80100dcb:	83 ec 04             	sub    $0x4,%esp
80100dce:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100dd1:	83 3b 02             	cmpl   $0x2,(%ebx)
80100dd4:	75 31                	jne    80100e07 <filestat+0x44>
    ilock(f->ip);
80100dd6:	83 ec 0c             	sub    $0xc,%esp
80100dd9:	ff 73 10             	pushl  0x10(%ebx)
80100ddc:	e8 e9 07 00 00       	call   801015ca <ilock>
    stati(f->ip, st);
80100de1:	83 c4 08             	add    $0x8,%esp
80100de4:	ff 75 0c             	pushl  0xc(%ebp)
80100de7:	ff 73 10             	pushl  0x10(%ebx)
80100dea:	e8 b2 09 00 00       	call   801017a1 <stati>
    iunlock(f->ip);
80100def:	83 c4 04             	add    $0x4,%esp
80100df2:	ff 73 10             	pushl  0x10(%ebx)
80100df5:	e8 96 08 00 00       	call   80101690 <iunlock>
    return 0;
80100dfa:	83 c4 10             	add    $0x10,%esp
80100dfd:	b8 00 00 00 00       	mov    $0x0,%eax
  }
  return -1;
}
80100e02:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e05:	c9                   	leave  
80100e06:	c3                   	ret    
  return -1;
80100e07:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100e0c:	eb f4                	jmp    80100e02 <filestat+0x3f>

80100e0e <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100e0e:	f3 0f 1e fb          	endbr32 
80100e12:	55                   	push   %ebp
80100e13:	89 e5                	mov    %esp,%ebp
80100e15:	56                   	push   %esi
80100e16:	53                   	push   %ebx
80100e17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;

  if(f->readable == 0)
80100e1a:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100e1e:	74 70                	je     80100e90 <fileread+0x82>
    return -1;
  if(f->type == FD_PIPE)
80100e20:	8b 03                	mov    (%ebx),%eax
80100e22:	83 f8 01             	cmp    $0x1,%eax
80100e25:	74 44                	je     80100e6b <fileread+0x5d>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100e27:	83 f8 02             	cmp    $0x2,%eax
80100e2a:	75 57                	jne    80100e83 <fileread+0x75>
    ilock(f->ip);
80100e2c:	83 ec 0c             	sub    $0xc,%esp
80100e2f:	ff 73 10             	pushl  0x10(%ebx)
80100e32:	e8 93 07 00 00       	call   801015ca <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100e37:	ff 75 10             	pushl  0x10(%ebp)
80100e3a:	ff 73 14             	pushl  0x14(%ebx)
80100e3d:	ff 75 0c             	pushl  0xc(%ebp)
80100e40:	ff 73 10             	pushl  0x10(%ebx)
80100e43:	e8 88 09 00 00       	call   801017d0 <readi>
80100e48:	89 c6                	mov    %eax,%esi
80100e4a:	83 c4 20             	add    $0x20,%esp
80100e4d:	85 c0                	test   %eax,%eax
80100e4f:	7e 03                	jle    80100e54 <fileread+0x46>
      f->off += r;
80100e51:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100e54:	83 ec 0c             	sub    $0xc,%esp
80100e57:	ff 73 10             	pushl  0x10(%ebx)
80100e5a:	e8 31 08 00 00       	call   80101690 <iunlock>
    return r;
80100e5f:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100e62:	89 f0                	mov    %esi,%eax
80100e64:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100e67:	5b                   	pop    %ebx
80100e68:	5e                   	pop    %esi
80100e69:	5d                   	pop    %ebp
80100e6a:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80100e6b:	83 ec 04             	sub    $0x4,%esp
80100e6e:	ff 75 10             	pushl  0x10(%ebp)
80100e71:	ff 75 0c             	pushl  0xc(%ebp)
80100e74:	ff 73 0c             	pushl  0xc(%ebx)
80100e77:	e8 29 22 00 00       	call   801030a5 <piperead>
80100e7c:	89 c6                	mov    %eax,%esi
80100e7e:	83 c4 10             	add    $0x10,%esp
80100e81:	eb df                	jmp    80100e62 <fileread+0x54>
  panic("fileread");
80100e83:	83 ec 0c             	sub    $0xc,%esp
80100e86:	68 46 68 10 80       	push   $0x80106846
80100e8b:	e8 cc f4 ff ff       	call   8010035c <panic>
    return -1;
80100e90:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100e95:	eb cb                	jmp    80100e62 <fileread+0x54>

80100e97 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100e97:	f3 0f 1e fb          	endbr32 
80100e9b:	55                   	push   %ebp
80100e9c:	89 e5                	mov    %esp,%ebp
80100e9e:	57                   	push   %edi
80100e9f:	56                   	push   %esi
80100ea0:	53                   	push   %ebx
80100ea1:	83 ec 1c             	sub    $0x1c,%esp
80100ea4:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;

  if(f->writable == 0)
80100ea7:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
80100eab:	0f 84 cc 00 00 00    	je     80100f7d <filewrite+0xe6>
    return -1;
  if(f->type == FD_PIPE)
80100eb1:	8b 06                	mov    (%esi),%eax
80100eb3:	83 f8 01             	cmp    $0x1,%eax
80100eb6:	74 10                	je     80100ec8 <filewrite+0x31>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100eb8:	83 f8 02             	cmp    $0x2,%eax
80100ebb:	0f 85 af 00 00 00    	jne    80100f70 <filewrite+0xd9>
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
80100ec1:	bf 00 00 00 00       	mov    $0x0,%edi
80100ec6:	eb 67                	jmp    80100f2f <filewrite+0x98>
    return pipewrite(f->pipe, addr, n);
80100ec8:	83 ec 04             	sub    $0x4,%esp
80100ecb:	ff 75 10             	pushl  0x10(%ebp)
80100ece:	ff 75 0c             	pushl  0xc(%ebp)
80100ed1:	ff 76 0c             	pushl  0xc(%esi)
80100ed4:	e8 02 21 00 00       	call   80102fdb <pipewrite>
80100ed9:	83 c4 10             	add    $0x10,%esp
80100edc:	e9 82 00 00 00       	jmp    80100f63 <filewrite+0xcc>
    while(i < n){
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
80100ee1:	e8 9f 19 00 00       	call   80102885 <begin_op>
      ilock(f->ip);
80100ee6:	83 ec 0c             	sub    $0xc,%esp
80100ee9:	ff 76 10             	pushl  0x10(%esi)
80100eec:	e8 d9 06 00 00       	call   801015ca <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80100ef1:	ff 75 e4             	pushl  -0x1c(%ebp)
80100ef4:	ff 76 14             	pushl  0x14(%esi)
80100ef7:	89 f8                	mov    %edi,%eax
80100ef9:	03 45 0c             	add    0xc(%ebp),%eax
80100efc:	50                   	push   %eax
80100efd:	ff 76 10             	pushl  0x10(%esi)
80100f00:	e8 cc 09 00 00       	call   801018d1 <writei>
80100f05:	89 c3                	mov    %eax,%ebx
80100f07:	83 c4 20             	add    $0x20,%esp
80100f0a:	85 c0                	test   %eax,%eax
80100f0c:	7e 03                	jle    80100f11 <filewrite+0x7a>
        f->off += r;
80100f0e:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
80100f11:	83 ec 0c             	sub    $0xc,%esp
80100f14:	ff 76 10             	pushl  0x10(%esi)
80100f17:	e8 74 07 00 00       	call   80101690 <iunlock>
      end_op();
80100f1c:	e8 e2 19 00 00       	call   80102903 <end_op>

      if(r < 0)
80100f21:	83 c4 10             	add    $0x10,%esp
80100f24:	85 db                	test   %ebx,%ebx
80100f26:	78 31                	js     80100f59 <filewrite+0xc2>
        break;
      if(r != n1)
80100f28:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
80100f2b:	75 1f                	jne    80100f4c <filewrite+0xb5>
        panic("short filewrite");
      i += r;
80100f2d:	01 df                	add    %ebx,%edi
    while(i < n){
80100f2f:	3b 7d 10             	cmp    0x10(%ebp),%edi
80100f32:	7d 25                	jge    80100f59 <filewrite+0xc2>
      int n1 = n - i;
80100f34:	8b 45 10             	mov    0x10(%ebp),%eax
80100f37:	29 f8                	sub    %edi,%eax
80100f39:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(n1 > max)
80100f3c:	3d 00 06 00 00       	cmp    $0x600,%eax
80100f41:	7e 9e                	jle    80100ee1 <filewrite+0x4a>
        n1 = max;
80100f43:	c7 45 e4 00 06 00 00 	movl   $0x600,-0x1c(%ebp)
80100f4a:	eb 95                	jmp    80100ee1 <filewrite+0x4a>
        panic("short filewrite");
80100f4c:	83 ec 0c             	sub    $0xc,%esp
80100f4f:	68 4f 68 10 80       	push   $0x8010684f
80100f54:	e8 03 f4 ff ff       	call   8010035c <panic>
    }
    return i == n ? n : -1;
80100f59:	3b 7d 10             	cmp    0x10(%ebp),%edi
80100f5c:	74 0d                	je     80100f6b <filewrite+0xd4>
80100f5e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80100f63:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f66:	5b                   	pop    %ebx
80100f67:	5e                   	pop    %esi
80100f68:	5f                   	pop    %edi
80100f69:	5d                   	pop    %ebp
80100f6a:	c3                   	ret    
    return i == n ? n : -1;
80100f6b:	8b 45 10             	mov    0x10(%ebp),%eax
80100f6e:	eb f3                	jmp    80100f63 <filewrite+0xcc>
  panic("filewrite");
80100f70:	83 ec 0c             	sub    $0xc,%esp
80100f73:	68 55 68 10 80       	push   $0x80106855
80100f78:	e8 df f3 ff ff       	call   8010035c <panic>
    return -1;
80100f7d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f82:	eb df                	jmp    80100f63 <filewrite+0xcc>

80100f84 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
80100f84:	55                   	push   %ebp
80100f85:	89 e5                	mov    %esp,%ebp
80100f87:	57                   	push   %edi
80100f88:	56                   	push   %esi
80100f89:	53                   	push   %ebx
80100f8a:	83 ec 0c             	sub    $0xc,%esp
80100f8d:	89 d6                	mov    %edx,%esi
  char *s;
  int len;

  while(*path == '/')
80100f8f:	0f b6 10             	movzbl (%eax),%edx
80100f92:	80 fa 2f             	cmp    $0x2f,%dl
80100f95:	75 05                	jne    80100f9c <skipelem+0x18>
    path++;
80100f97:	83 c0 01             	add    $0x1,%eax
80100f9a:	eb f3                	jmp    80100f8f <skipelem+0xb>
  if(*path == 0)
80100f9c:	84 d2                	test   %dl,%dl
80100f9e:	74 59                	je     80100ff9 <skipelem+0x75>
80100fa0:	89 c3                	mov    %eax,%ebx
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80100fa2:	0f b6 13             	movzbl (%ebx),%edx
80100fa5:	80 fa 2f             	cmp    $0x2f,%dl
80100fa8:	0f 95 c1             	setne  %cl
80100fab:	84 d2                	test   %dl,%dl
80100fad:	0f 95 c2             	setne  %dl
80100fb0:	84 d1                	test   %dl,%cl
80100fb2:	74 05                	je     80100fb9 <skipelem+0x35>
    path++;
80100fb4:	83 c3 01             	add    $0x1,%ebx
80100fb7:	eb e9                	jmp    80100fa2 <skipelem+0x1e>
  len = path - s;
80100fb9:	89 df                	mov    %ebx,%edi
80100fbb:	29 c7                	sub    %eax,%edi
  if(len >= DIRSIZ)
80100fbd:	83 ff 0d             	cmp    $0xd,%edi
80100fc0:	7e 11                	jle    80100fd3 <skipelem+0x4f>
    memmove(name, s, DIRSIZ);
80100fc2:	83 ec 04             	sub    $0x4,%esp
80100fc5:	6a 0e                	push   $0xe
80100fc7:	50                   	push   %eax
80100fc8:	56                   	push   %esi
80100fc9:	e8 8a 2e 00 00       	call   80103e58 <memmove>
80100fce:	83 c4 10             	add    $0x10,%esp
80100fd1:	eb 17                	jmp    80100fea <skipelem+0x66>
  else {
    memmove(name, s, len);
80100fd3:	83 ec 04             	sub    $0x4,%esp
80100fd6:	57                   	push   %edi
80100fd7:	50                   	push   %eax
80100fd8:	56                   	push   %esi
80100fd9:	e8 7a 2e 00 00       	call   80103e58 <memmove>
    name[len] = 0;
80100fde:	c6 04 3e 00          	movb   $0x0,(%esi,%edi,1)
80100fe2:	83 c4 10             	add    $0x10,%esp
80100fe5:	eb 03                	jmp    80100fea <skipelem+0x66>
  }
  while(*path == '/')
    path++;
80100fe7:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80100fea:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80100fed:	74 f8                	je     80100fe7 <skipelem+0x63>
  return path;
}
80100fef:	89 d8                	mov    %ebx,%eax
80100ff1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ff4:	5b                   	pop    %ebx
80100ff5:	5e                   	pop    %esi
80100ff6:	5f                   	pop    %edi
80100ff7:	5d                   	pop    %ebp
80100ff8:	c3                   	ret    
    return 0;
80100ff9:	bb 00 00 00 00       	mov    $0x0,%ebx
80100ffe:	eb ef                	jmp    80100fef <skipelem+0x6b>

80101000 <bzero>:
{
80101000:	55                   	push   %ebp
80101001:	89 e5                	mov    %esp,%ebp
80101003:	53                   	push   %ebx
80101004:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, bno);
80101007:	52                   	push   %edx
80101008:	50                   	push   %eax
80101009:	e8 62 f1 ff ff       	call   80100170 <bread>
8010100e:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101010:	8d 40 5c             	lea    0x5c(%eax),%eax
80101013:	83 c4 0c             	add    $0xc,%esp
80101016:	68 00 02 00 00       	push   $0x200
8010101b:	6a 00                	push   $0x0
8010101d:	50                   	push   %eax
8010101e:	e8 b5 2d 00 00       	call   80103dd8 <memset>
  log_write(bp);
80101023:	89 1c 24             	mov    %ebx,(%esp)
80101026:	e8 8b 19 00 00       	call   801029b6 <log_write>
  brelse(bp);
8010102b:	89 1c 24             	mov    %ebx,(%esp)
8010102e:	e8 ae f1 ff ff       	call   801001e1 <brelse>
}
80101033:	83 c4 10             	add    $0x10,%esp
80101036:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101039:	c9                   	leave  
8010103a:	c3                   	ret    

8010103b <bfree>:
{
8010103b:	55                   	push   %ebp
8010103c:	89 e5                	mov    %esp,%ebp
8010103e:	57                   	push   %edi
8010103f:	56                   	push   %esi
80101040:	53                   	push   %ebx
80101041:	83 ec 14             	sub    $0x14,%esp
80101044:	89 c3                	mov    %eax,%ebx
80101046:	89 d6                	mov    %edx,%esi
  bp = bread(dev, BBLOCK(b, sb));
80101048:	89 d0                	mov    %edx,%eax
8010104a:	c1 e8 0c             	shr    $0xc,%eax
8010104d:	03 05 d8 09 11 80    	add    0x801109d8,%eax
80101053:	50                   	push   %eax
80101054:	53                   	push   %ebx
80101055:	e8 16 f1 ff ff       	call   80100170 <bread>
8010105a:	89 c3                	mov    %eax,%ebx
  bi = b % BPB;
8010105c:	89 f7                	mov    %esi,%edi
8010105e:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
  m = 1 << (bi % 8);
80101064:	89 f1                	mov    %esi,%ecx
80101066:	83 e1 07             	and    $0x7,%ecx
80101069:	b8 01 00 00 00       	mov    $0x1,%eax
8010106e:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101070:	83 c4 10             	add    $0x10,%esp
80101073:	c1 ff 03             	sar    $0x3,%edi
80101076:	0f b6 54 3b 5c       	movzbl 0x5c(%ebx,%edi,1),%edx
8010107b:	0f b6 ca             	movzbl %dl,%ecx
8010107e:	85 c1                	test   %eax,%ecx
80101080:	74 24                	je     801010a6 <bfree+0x6b>
  bp->data[bi/8] &= ~m;
80101082:	f7 d0                	not    %eax
80101084:	21 d0                	and    %edx,%eax
80101086:	88 44 3b 5c          	mov    %al,0x5c(%ebx,%edi,1)
  log_write(bp);
8010108a:	83 ec 0c             	sub    $0xc,%esp
8010108d:	53                   	push   %ebx
8010108e:	e8 23 19 00 00       	call   801029b6 <log_write>
  brelse(bp);
80101093:	89 1c 24             	mov    %ebx,(%esp)
80101096:	e8 46 f1 ff ff       	call   801001e1 <brelse>
}
8010109b:	83 c4 10             	add    $0x10,%esp
8010109e:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010a1:	5b                   	pop    %ebx
801010a2:	5e                   	pop    %esi
801010a3:	5f                   	pop    %edi
801010a4:	5d                   	pop    %ebp
801010a5:	c3                   	ret    
    panic("freeing free block");
801010a6:	83 ec 0c             	sub    $0xc,%esp
801010a9:	68 5f 68 10 80       	push   $0x8010685f
801010ae:	e8 a9 f2 ff ff       	call   8010035c <panic>

801010b3 <balloc>:
{
801010b3:	55                   	push   %ebp
801010b4:	89 e5                	mov    %esp,%ebp
801010b6:	57                   	push   %edi
801010b7:	56                   	push   %esi
801010b8:	53                   	push   %ebx
801010b9:	83 ec 1c             	sub    $0x1c,%esp
801010bc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801010bf:	be 00 00 00 00       	mov    $0x0,%esi
801010c4:	eb 14                	jmp    801010da <balloc+0x27>
    brelse(bp);
801010c6:	83 ec 0c             	sub    $0xc,%esp
801010c9:	ff 75 e4             	pushl  -0x1c(%ebp)
801010cc:	e8 10 f1 ff ff       	call   801001e1 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801010d1:	81 c6 00 10 00 00    	add    $0x1000,%esi
801010d7:	83 c4 10             	add    $0x10,%esp
801010da:	39 35 c0 09 11 80    	cmp    %esi,0x801109c0
801010e0:	76 75                	jbe    80101157 <balloc+0xa4>
    bp = bread(dev, BBLOCK(b, sb));
801010e2:	8d 86 ff 0f 00 00    	lea    0xfff(%esi),%eax
801010e8:	85 f6                	test   %esi,%esi
801010ea:	0f 49 c6             	cmovns %esi,%eax
801010ed:	c1 f8 0c             	sar    $0xc,%eax
801010f0:	83 ec 08             	sub    $0x8,%esp
801010f3:	03 05 d8 09 11 80    	add    0x801109d8,%eax
801010f9:	50                   	push   %eax
801010fa:	ff 75 d8             	pushl  -0x28(%ebp)
801010fd:	e8 6e f0 ff ff       	call   80100170 <bread>
80101102:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101105:	83 c4 10             	add    $0x10,%esp
80101108:	b8 00 00 00 00       	mov    $0x0,%eax
8010110d:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80101112:	7f b2                	jg     801010c6 <balloc+0x13>
80101114:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80101117:	89 5d e0             	mov    %ebx,-0x20(%ebp)
8010111a:	3b 1d c0 09 11 80    	cmp    0x801109c0,%ebx
80101120:	73 a4                	jae    801010c6 <balloc+0x13>
      m = 1 << (bi % 8);
80101122:	99                   	cltd   
80101123:	c1 ea 1d             	shr    $0x1d,%edx
80101126:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
80101129:	83 e1 07             	and    $0x7,%ecx
8010112c:	29 d1                	sub    %edx,%ecx
8010112e:	ba 01 00 00 00       	mov    $0x1,%edx
80101133:	d3 e2                	shl    %cl,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101135:	8d 48 07             	lea    0x7(%eax),%ecx
80101138:	85 c0                	test   %eax,%eax
8010113a:	0f 49 c8             	cmovns %eax,%ecx
8010113d:	c1 f9 03             	sar    $0x3,%ecx
80101140:	89 4d dc             	mov    %ecx,-0x24(%ebp)
80101143:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101146:	0f b6 4c 0f 5c       	movzbl 0x5c(%edi,%ecx,1),%ecx
8010114b:	0f b6 f9             	movzbl %cl,%edi
8010114e:	85 d7                	test   %edx,%edi
80101150:	74 12                	je     80101164 <balloc+0xb1>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101152:	83 c0 01             	add    $0x1,%eax
80101155:	eb b6                	jmp    8010110d <balloc+0x5a>
  panic("balloc: out of blocks");
80101157:	83 ec 0c             	sub    $0xc,%esp
8010115a:	68 72 68 10 80       	push   $0x80106872
8010115f:	e8 f8 f1 ff ff       	call   8010035c <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
80101164:	09 ca                	or     %ecx,%edx
80101166:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101169:	8b 75 dc             	mov    -0x24(%ebp),%esi
8010116c:	88 54 30 5c          	mov    %dl,0x5c(%eax,%esi,1)
        log_write(bp);
80101170:	83 ec 0c             	sub    $0xc,%esp
80101173:	89 c6                	mov    %eax,%esi
80101175:	50                   	push   %eax
80101176:	e8 3b 18 00 00       	call   801029b6 <log_write>
        brelse(bp);
8010117b:	89 34 24             	mov    %esi,(%esp)
8010117e:	e8 5e f0 ff ff       	call   801001e1 <brelse>
        bzero(dev, b + bi);
80101183:	89 da                	mov    %ebx,%edx
80101185:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101188:	e8 73 fe ff ff       	call   80101000 <bzero>
}
8010118d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101190:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101193:	5b                   	pop    %ebx
80101194:	5e                   	pop    %esi
80101195:	5f                   	pop    %edi
80101196:	5d                   	pop    %ebp
80101197:	c3                   	ret    

80101198 <bmap>:
{
80101198:	55                   	push   %ebp
80101199:	89 e5                	mov    %esp,%ebp
8010119b:	57                   	push   %edi
8010119c:	56                   	push   %esi
8010119d:	53                   	push   %ebx
8010119e:	83 ec 1c             	sub    $0x1c,%esp
801011a1:	89 c3                	mov    %eax,%ebx
801011a3:	89 d7                	mov    %edx,%edi
  if(bn < NDIRECT){
801011a5:	83 fa 0b             	cmp    $0xb,%edx
801011a8:	76 45                	jbe    801011ef <bmap+0x57>
  bn -= NDIRECT;
801011aa:	8d 72 f4             	lea    -0xc(%edx),%esi
  if(bn < NINDIRECT){
801011ad:	83 fe 7f             	cmp    $0x7f,%esi
801011b0:	77 7f                	ja     80101231 <bmap+0x99>
    if((addr = ip->addrs[NDIRECT]) == 0)
801011b2:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801011b8:	85 c0                	test   %eax,%eax
801011ba:	74 4a                	je     80101206 <bmap+0x6e>
    bp = bread(ip->dev, addr);
801011bc:	83 ec 08             	sub    $0x8,%esp
801011bf:	50                   	push   %eax
801011c0:	ff 33                	pushl  (%ebx)
801011c2:	e8 a9 ef ff ff       	call   80100170 <bread>
801011c7:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801011c9:	8d 44 b0 5c          	lea    0x5c(%eax,%esi,4),%eax
801011cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801011d0:	8b 30                	mov    (%eax),%esi
801011d2:	83 c4 10             	add    $0x10,%esp
801011d5:	85 f6                	test   %esi,%esi
801011d7:	74 3c                	je     80101215 <bmap+0x7d>
    brelse(bp);
801011d9:	83 ec 0c             	sub    $0xc,%esp
801011dc:	57                   	push   %edi
801011dd:	e8 ff ef ff ff       	call   801001e1 <brelse>
    return addr;
801011e2:	83 c4 10             	add    $0x10,%esp
}
801011e5:	89 f0                	mov    %esi,%eax
801011e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011ea:	5b                   	pop    %ebx
801011eb:	5e                   	pop    %esi
801011ec:	5f                   	pop    %edi
801011ed:	5d                   	pop    %ebp
801011ee:	c3                   	ret    
    if((addr = ip->addrs[bn]) == 0)
801011ef:	8b 74 90 5c          	mov    0x5c(%eax,%edx,4),%esi
801011f3:	85 f6                	test   %esi,%esi
801011f5:	75 ee                	jne    801011e5 <bmap+0x4d>
      ip->addrs[bn] = addr = balloc(ip->dev);
801011f7:	8b 00                	mov    (%eax),%eax
801011f9:	e8 b5 fe ff ff       	call   801010b3 <balloc>
801011fe:	89 c6                	mov    %eax,%esi
80101200:	89 44 bb 5c          	mov    %eax,0x5c(%ebx,%edi,4)
    return addr;
80101204:	eb df                	jmp    801011e5 <bmap+0x4d>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101206:	8b 03                	mov    (%ebx),%eax
80101208:	e8 a6 fe ff ff       	call   801010b3 <balloc>
8010120d:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
80101213:	eb a7                	jmp    801011bc <bmap+0x24>
      a[bn] = addr = balloc(ip->dev);
80101215:	8b 03                	mov    (%ebx),%eax
80101217:	e8 97 fe ff ff       	call   801010b3 <balloc>
8010121c:	89 c6                	mov    %eax,%esi
8010121e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101221:	89 30                	mov    %esi,(%eax)
      log_write(bp);
80101223:	83 ec 0c             	sub    $0xc,%esp
80101226:	57                   	push   %edi
80101227:	e8 8a 17 00 00       	call   801029b6 <log_write>
8010122c:	83 c4 10             	add    $0x10,%esp
8010122f:	eb a8                	jmp    801011d9 <bmap+0x41>
  panic("bmap: out of range");
80101231:	83 ec 0c             	sub    $0xc,%esp
80101234:	68 88 68 10 80       	push   $0x80106888
80101239:	e8 1e f1 ff ff       	call   8010035c <panic>

8010123e <iget>:
{
8010123e:	55                   	push   %ebp
8010123f:	89 e5                	mov    %esp,%ebp
80101241:	57                   	push   %edi
80101242:	56                   	push   %esi
80101243:	53                   	push   %ebx
80101244:	83 ec 28             	sub    $0x28,%esp
80101247:	89 c7                	mov    %eax,%edi
80101249:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
8010124c:	68 e0 09 11 80       	push   $0x801109e0
80101251:	e8 ce 2a 00 00       	call   80103d24 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101256:	83 c4 10             	add    $0x10,%esp
  empty = 0;
80101259:	be 00 00 00 00       	mov    $0x0,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010125e:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
80101263:	eb 0a                	jmp    8010126f <iget+0x31>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101265:	85 f6                	test   %esi,%esi
80101267:	74 3b                	je     801012a4 <iget+0x66>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101269:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010126f:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101275:	73 35                	jae    801012ac <iget+0x6e>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101277:	8b 43 08             	mov    0x8(%ebx),%eax
8010127a:	85 c0                	test   %eax,%eax
8010127c:	7e e7                	jle    80101265 <iget+0x27>
8010127e:	39 3b                	cmp    %edi,(%ebx)
80101280:	75 e3                	jne    80101265 <iget+0x27>
80101282:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101285:	39 4b 04             	cmp    %ecx,0x4(%ebx)
80101288:	75 db                	jne    80101265 <iget+0x27>
      ip->ref++;
8010128a:	83 c0 01             	add    $0x1,%eax
8010128d:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101290:	83 ec 0c             	sub    $0xc,%esp
80101293:	68 e0 09 11 80       	push   $0x801109e0
80101298:	e8 f0 2a 00 00       	call   80103d8d <release>
      return ip;
8010129d:	83 c4 10             	add    $0x10,%esp
801012a0:	89 de                	mov    %ebx,%esi
801012a2:	eb 32                	jmp    801012d6 <iget+0x98>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801012a4:	85 c0                	test   %eax,%eax
801012a6:	75 c1                	jne    80101269 <iget+0x2b>
      empty = ip;
801012a8:	89 de                	mov    %ebx,%esi
801012aa:	eb bd                	jmp    80101269 <iget+0x2b>
  if(empty == 0)
801012ac:	85 f6                	test   %esi,%esi
801012ae:	74 30                	je     801012e0 <iget+0xa2>
  ip->dev = dev;
801012b0:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801012b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801012b5:	89 46 04             	mov    %eax,0x4(%esi)
  ip->ref = 1;
801012b8:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801012bf:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801012c6:	83 ec 0c             	sub    $0xc,%esp
801012c9:	68 e0 09 11 80       	push   $0x801109e0
801012ce:	e8 ba 2a 00 00       	call   80103d8d <release>
  return ip;
801012d3:	83 c4 10             	add    $0x10,%esp
}
801012d6:	89 f0                	mov    %esi,%eax
801012d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012db:	5b                   	pop    %ebx
801012dc:	5e                   	pop    %esi
801012dd:	5f                   	pop    %edi
801012de:	5d                   	pop    %ebp
801012df:	c3                   	ret    
    panic("iget: no inodes");
801012e0:	83 ec 0c             	sub    $0xc,%esp
801012e3:	68 9b 68 10 80       	push   $0x8010689b
801012e8:	e8 6f f0 ff ff       	call   8010035c <panic>

801012ed <readsb>:
{
801012ed:	f3 0f 1e fb          	endbr32 
801012f1:	55                   	push   %ebp
801012f2:	89 e5                	mov    %esp,%ebp
801012f4:	53                   	push   %ebx
801012f5:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, 1);
801012f8:	6a 01                	push   $0x1
801012fa:	ff 75 08             	pushl  0x8(%ebp)
801012fd:	e8 6e ee ff ff       	call   80100170 <bread>
80101302:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101304:	8d 40 5c             	lea    0x5c(%eax),%eax
80101307:	83 c4 0c             	add    $0xc,%esp
8010130a:	6a 1c                	push   $0x1c
8010130c:	50                   	push   %eax
8010130d:	ff 75 0c             	pushl  0xc(%ebp)
80101310:	e8 43 2b 00 00       	call   80103e58 <memmove>
  brelse(bp);
80101315:	89 1c 24             	mov    %ebx,(%esp)
80101318:	e8 c4 ee ff ff       	call   801001e1 <brelse>
}
8010131d:	83 c4 10             	add    $0x10,%esp
80101320:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101323:	c9                   	leave  
80101324:	c3                   	ret    

80101325 <iinit>:
{
80101325:	f3 0f 1e fb          	endbr32 
80101329:	55                   	push   %ebp
8010132a:	89 e5                	mov    %esp,%ebp
8010132c:	53                   	push   %ebx
8010132d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101330:	68 ab 68 10 80       	push   $0x801068ab
80101335:	68 e0 09 11 80       	push   $0x801109e0
8010133a:	e8 95 28 00 00       	call   80103bd4 <initlock>
  for(i = 0; i < NINODE; i++) {
8010133f:	83 c4 10             	add    $0x10,%esp
80101342:	bb 00 00 00 00       	mov    $0x0,%ebx
80101347:	83 fb 31             	cmp    $0x31,%ebx
8010134a:	7f 23                	jg     8010136f <iinit+0x4a>
    initsleeplock(&icache.inode[i].lock, "inode");
8010134c:	83 ec 08             	sub    $0x8,%esp
8010134f:	68 b2 68 10 80       	push   $0x801068b2
80101354:	8d 14 db             	lea    (%ebx,%ebx,8),%edx
80101357:	89 d0                	mov    %edx,%eax
80101359:	c1 e0 04             	shl    $0x4,%eax
8010135c:	05 20 0a 11 80       	add    $0x80110a20,%eax
80101361:	50                   	push   %eax
80101362:	e8 52 27 00 00       	call   80103ab9 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101367:	83 c3 01             	add    $0x1,%ebx
8010136a:	83 c4 10             	add    $0x10,%esp
8010136d:	eb d8                	jmp    80101347 <iinit+0x22>
  readsb(dev, &sb);
8010136f:	83 ec 08             	sub    $0x8,%esp
80101372:	68 c0 09 11 80       	push   $0x801109c0
80101377:	ff 75 08             	pushl  0x8(%ebp)
8010137a:	e8 6e ff ff ff       	call   801012ed <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010137f:	ff 35 d8 09 11 80    	pushl  0x801109d8
80101385:	ff 35 d4 09 11 80    	pushl  0x801109d4
8010138b:	ff 35 d0 09 11 80    	pushl  0x801109d0
80101391:	ff 35 cc 09 11 80    	pushl  0x801109cc
80101397:	ff 35 c8 09 11 80    	pushl  0x801109c8
8010139d:	ff 35 c4 09 11 80    	pushl  0x801109c4
801013a3:	ff 35 c0 09 11 80    	pushl  0x801109c0
801013a9:	68 18 69 10 80       	push   $0x80106918
801013ae:	e8 76 f2 ff ff       	call   80100629 <cprintf>
}
801013b3:	83 c4 30             	add    $0x30,%esp
801013b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801013b9:	c9                   	leave  
801013ba:	c3                   	ret    

801013bb <ialloc>:
{
801013bb:	f3 0f 1e fb          	endbr32 
801013bf:	55                   	push   %ebp
801013c0:	89 e5                	mov    %esp,%ebp
801013c2:	57                   	push   %edi
801013c3:	56                   	push   %esi
801013c4:	53                   	push   %ebx
801013c5:	83 ec 1c             	sub    $0x1c,%esp
801013c8:	8b 45 0c             	mov    0xc(%ebp),%eax
801013cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801013ce:	bb 01 00 00 00       	mov    $0x1,%ebx
801013d3:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801013d6:	39 1d c8 09 11 80    	cmp    %ebx,0x801109c8
801013dc:	76 76                	jbe    80101454 <ialloc+0x99>
    bp = bread(dev, IBLOCK(inum, sb));
801013de:	89 d8                	mov    %ebx,%eax
801013e0:	c1 e8 03             	shr    $0x3,%eax
801013e3:	83 ec 08             	sub    $0x8,%esp
801013e6:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801013ec:	50                   	push   %eax
801013ed:	ff 75 08             	pushl  0x8(%ebp)
801013f0:	e8 7b ed ff ff       	call   80100170 <bread>
801013f5:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + inum%IPB;
801013f7:	89 d8                	mov    %ebx,%eax
801013f9:	83 e0 07             	and    $0x7,%eax
801013fc:	c1 e0 06             	shl    $0x6,%eax
801013ff:	8d 7c 06 5c          	lea    0x5c(%esi,%eax,1),%edi
    if(dip->type == 0){  // a free inode
80101403:	83 c4 10             	add    $0x10,%esp
80101406:	66 83 3f 00          	cmpw   $0x0,(%edi)
8010140a:	74 11                	je     8010141d <ialloc+0x62>
    brelse(bp);
8010140c:	83 ec 0c             	sub    $0xc,%esp
8010140f:	56                   	push   %esi
80101410:	e8 cc ed ff ff       	call   801001e1 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
80101415:	83 c3 01             	add    $0x1,%ebx
80101418:	83 c4 10             	add    $0x10,%esp
8010141b:	eb b6                	jmp    801013d3 <ialloc+0x18>
      memset(dip, 0, sizeof(*dip));
8010141d:	83 ec 04             	sub    $0x4,%esp
80101420:	6a 40                	push   $0x40
80101422:	6a 00                	push   $0x0
80101424:	57                   	push   %edi
80101425:	e8 ae 29 00 00       	call   80103dd8 <memset>
      dip->type = type;
8010142a:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010142e:	66 89 07             	mov    %ax,(%edi)
      log_write(bp);   // mark it allocated on the disk
80101431:	89 34 24             	mov    %esi,(%esp)
80101434:	e8 7d 15 00 00       	call   801029b6 <log_write>
      brelse(bp);
80101439:	89 34 24             	mov    %esi,(%esp)
8010143c:	e8 a0 ed ff ff       	call   801001e1 <brelse>
      return iget(dev, inum);
80101441:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101444:	8b 45 08             	mov    0x8(%ebp),%eax
80101447:	e8 f2 fd ff ff       	call   8010123e <iget>
}
8010144c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010144f:	5b                   	pop    %ebx
80101450:	5e                   	pop    %esi
80101451:	5f                   	pop    %edi
80101452:	5d                   	pop    %ebp
80101453:	c3                   	ret    
  panic("ialloc: no inodes");
80101454:	83 ec 0c             	sub    $0xc,%esp
80101457:	68 b8 68 10 80       	push   $0x801068b8
8010145c:	e8 fb ee ff ff       	call   8010035c <panic>

80101461 <iupdate>:
{
80101461:	f3 0f 1e fb          	endbr32 
80101465:	55                   	push   %ebp
80101466:	89 e5                	mov    %esp,%ebp
80101468:	56                   	push   %esi
80101469:	53                   	push   %ebx
8010146a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010146d:	8b 43 04             	mov    0x4(%ebx),%eax
80101470:	c1 e8 03             	shr    $0x3,%eax
80101473:	83 ec 08             	sub    $0x8,%esp
80101476:	03 05 d4 09 11 80    	add    0x801109d4,%eax
8010147c:	50                   	push   %eax
8010147d:	ff 33                	pushl  (%ebx)
8010147f:	e8 ec ec ff ff       	call   80100170 <bread>
80101484:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101486:	8b 43 04             	mov    0x4(%ebx),%eax
80101489:	83 e0 07             	and    $0x7,%eax
8010148c:	c1 e0 06             	shl    $0x6,%eax
8010148f:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101493:	0f b7 53 50          	movzwl 0x50(%ebx),%edx
80101497:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010149a:	0f b7 53 52          	movzwl 0x52(%ebx),%edx
8010149e:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
801014a2:	0f b7 53 54          	movzwl 0x54(%ebx),%edx
801014a6:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
801014aa:	0f b7 53 56          	movzwl 0x56(%ebx),%edx
801014ae:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
801014b2:	8b 53 58             	mov    0x58(%ebx),%edx
801014b5:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801014b8:	83 c3 5c             	add    $0x5c,%ebx
801014bb:	83 c0 0c             	add    $0xc,%eax
801014be:	83 c4 0c             	add    $0xc,%esp
801014c1:	6a 34                	push   $0x34
801014c3:	53                   	push   %ebx
801014c4:	50                   	push   %eax
801014c5:	e8 8e 29 00 00       	call   80103e58 <memmove>
  log_write(bp);
801014ca:	89 34 24             	mov    %esi,(%esp)
801014cd:	e8 e4 14 00 00       	call   801029b6 <log_write>
  brelse(bp);
801014d2:	89 34 24             	mov    %esi,(%esp)
801014d5:	e8 07 ed ff ff       	call   801001e1 <brelse>
}
801014da:	83 c4 10             	add    $0x10,%esp
801014dd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801014e0:	5b                   	pop    %ebx
801014e1:	5e                   	pop    %esi
801014e2:	5d                   	pop    %ebp
801014e3:	c3                   	ret    

801014e4 <itrunc>:
{
801014e4:	55                   	push   %ebp
801014e5:	89 e5                	mov    %esp,%ebp
801014e7:	57                   	push   %edi
801014e8:	56                   	push   %esi
801014e9:	53                   	push   %ebx
801014ea:	83 ec 1c             	sub    $0x1c,%esp
801014ed:	89 c6                	mov    %eax,%esi
  for(i = 0; i < NDIRECT; i++){
801014ef:	bb 00 00 00 00       	mov    $0x0,%ebx
801014f4:	eb 03                	jmp    801014f9 <itrunc+0x15>
801014f6:	83 c3 01             	add    $0x1,%ebx
801014f9:	83 fb 0b             	cmp    $0xb,%ebx
801014fc:	7f 19                	jg     80101517 <itrunc+0x33>
    if(ip->addrs[i]){
801014fe:	8b 54 9e 5c          	mov    0x5c(%esi,%ebx,4),%edx
80101502:	85 d2                	test   %edx,%edx
80101504:	74 f0                	je     801014f6 <itrunc+0x12>
      bfree(ip->dev, ip->addrs[i]);
80101506:	8b 06                	mov    (%esi),%eax
80101508:	e8 2e fb ff ff       	call   8010103b <bfree>
      ip->addrs[i] = 0;
8010150d:	c7 44 9e 5c 00 00 00 	movl   $0x0,0x5c(%esi,%ebx,4)
80101514:	00 
80101515:	eb df                	jmp    801014f6 <itrunc+0x12>
  if(ip->addrs[NDIRECT]){
80101517:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
8010151d:	85 c0                	test   %eax,%eax
8010151f:	75 1b                	jne    8010153c <itrunc+0x58>
  ip->size = 0;
80101521:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
80101528:	83 ec 0c             	sub    $0xc,%esp
8010152b:	56                   	push   %esi
8010152c:	e8 30 ff ff ff       	call   80101461 <iupdate>
}
80101531:	83 c4 10             	add    $0x10,%esp
80101534:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101537:	5b                   	pop    %ebx
80101538:	5e                   	pop    %esi
80101539:	5f                   	pop    %edi
8010153a:	5d                   	pop    %ebp
8010153b:	c3                   	ret    
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
8010153c:	83 ec 08             	sub    $0x8,%esp
8010153f:	50                   	push   %eax
80101540:	ff 36                	pushl  (%esi)
80101542:	e8 29 ec ff ff       	call   80100170 <bread>
80101547:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
8010154a:	8d 78 5c             	lea    0x5c(%eax),%edi
    for(j = 0; j < NINDIRECT; j++){
8010154d:	83 c4 10             	add    $0x10,%esp
80101550:	bb 00 00 00 00       	mov    $0x0,%ebx
80101555:	eb 0a                	jmp    80101561 <itrunc+0x7d>
        bfree(ip->dev, a[j]);
80101557:	8b 06                	mov    (%esi),%eax
80101559:	e8 dd fa ff ff       	call   8010103b <bfree>
    for(j = 0; j < NINDIRECT; j++){
8010155e:	83 c3 01             	add    $0x1,%ebx
80101561:	83 fb 7f             	cmp    $0x7f,%ebx
80101564:	77 09                	ja     8010156f <itrunc+0x8b>
      if(a[j])
80101566:	8b 14 9f             	mov    (%edi,%ebx,4),%edx
80101569:	85 d2                	test   %edx,%edx
8010156b:	74 f1                	je     8010155e <itrunc+0x7a>
8010156d:	eb e8                	jmp    80101557 <itrunc+0x73>
    brelse(bp);
8010156f:	83 ec 0c             	sub    $0xc,%esp
80101572:	ff 75 e4             	pushl  -0x1c(%ebp)
80101575:	e8 67 ec ff ff       	call   801001e1 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
8010157a:	8b 06                	mov    (%esi),%eax
8010157c:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
80101582:	e8 b4 fa ff ff       	call   8010103b <bfree>
    ip->addrs[NDIRECT] = 0;
80101587:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
8010158e:	00 00 00 
80101591:	83 c4 10             	add    $0x10,%esp
80101594:	eb 8b                	jmp    80101521 <itrunc+0x3d>

80101596 <idup>:
{
80101596:	f3 0f 1e fb          	endbr32 
8010159a:	55                   	push   %ebp
8010159b:	89 e5                	mov    %esp,%ebp
8010159d:	53                   	push   %ebx
8010159e:	83 ec 10             	sub    $0x10,%esp
801015a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801015a4:	68 e0 09 11 80       	push   $0x801109e0
801015a9:	e8 76 27 00 00       	call   80103d24 <acquire>
  ip->ref++;
801015ae:	8b 43 08             	mov    0x8(%ebx),%eax
801015b1:	83 c0 01             	add    $0x1,%eax
801015b4:	89 43 08             	mov    %eax,0x8(%ebx)
  release(&icache.lock);
801015b7:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801015be:	e8 ca 27 00 00       	call   80103d8d <release>
}
801015c3:	89 d8                	mov    %ebx,%eax
801015c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801015c8:	c9                   	leave  
801015c9:	c3                   	ret    

801015ca <ilock>:
{
801015ca:	f3 0f 1e fb          	endbr32 
801015ce:	55                   	push   %ebp
801015cf:	89 e5                	mov    %esp,%ebp
801015d1:	56                   	push   %esi
801015d2:	53                   	push   %ebx
801015d3:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801015d6:	85 db                	test   %ebx,%ebx
801015d8:	74 22                	je     801015fc <ilock+0x32>
801015da:	83 7b 08 00          	cmpl   $0x0,0x8(%ebx)
801015de:	7e 1c                	jle    801015fc <ilock+0x32>
  acquiresleep(&ip->lock);
801015e0:	83 ec 0c             	sub    $0xc,%esp
801015e3:	8d 43 0c             	lea    0xc(%ebx),%eax
801015e6:	50                   	push   %eax
801015e7:	e8 04 25 00 00       	call   80103af0 <acquiresleep>
  if(ip->valid == 0){
801015ec:	83 c4 10             	add    $0x10,%esp
801015ef:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
801015f3:	74 14                	je     80101609 <ilock+0x3f>
}
801015f5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801015f8:	5b                   	pop    %ebx
801015f9:	5e                   	pop    %esi
801015fa:	5d                   	pop    %ebp
801015fb:	c3                   	ret    
    panic("ilock");
801015fc:	83 ec 0c             	sub    $0xc,%esp
801015ff:	68 ca 68 10 80       	push   $0x801068ca
80101604:	e8 53 ed ff ff       	call   8010035c <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101609:	8b 43 04             	mov    0x4(%ebx),%eax
8010160c:	c1 e8 03             	shr    $0x3,%eax
8010160f:	83 ec 08             	sub    $0x8,%esp
80101612:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101618:	50                   	push   %eax
80101619:	ff 33                	pushl  (%ebx)
8010161b:	e8 50 eb ff ff       	call   80100170 <bread>
80101620:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101622:	8b 43 04             	mov    0x4(%ebx),%eax
80101625:	83 e0 07             	and    $0x7,%eax
80101628:	c1 e0 06             	shl    $0x6,%eax
8010162b:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
8010162f:	0f b7 10             	movzwl (%eax),%edx
80101632:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101636:	0f b7 50 02          	movzwl 0x2(%eax),%edx
8010163a:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010163e:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101642:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101646:	0f b7 50 06          	movzwl 0x6(%eax),%edx
8010164a:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010164e:	8b 50 08             	mov    0x8(%eax),%edx
80101651:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101654:	83 c0 0c             	add    $0xc,%eax
80101657:	8d 53 5c             	lea    0x5c(%ebx),%edx
8010165a:	83 c4 0c             	add    $0xc,%esp
8010165d:	6a 34                	push   $0x34
8010165f:	50                   	push   %eax
80101660:	52                   	push   %edx
80101661:	e8 f2 27 00 00       	call   80103e58 <memmove>
    brelse(bp);
80101666:	89 34 24             	mov    %esi,(%esp)
80101669:	e8 73 eb ff ff       	call   801001e1 <brelse>
    ip->valid = 1;
8010166e:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101675:	83 c4 10             	add    $0x10,%esp
80101678:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
8010167d:	0f 85 72 ff ff ff    	jne    801015f5 <ilock+0x2b>
      panic("ilock: no type");
80101683:	83 ec 0c             	sub    $0xc,%esp
80101686:	68 d0 68 10 80       	push   $0x801068d0
8010168b:	e8 cc ec ff ff       	call   8010035c <panic>

80101690 <iunlock>:
{
80101690:	f3 0f 1e fb          	endbr32 
80101694:	55                   	push   %ebp
80101695:	89 e5                	mov    %esp,%ebp
80101697:	56                   	push   %esi
80101698:	53                   	push   %ebx
80101699:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010169c:	85 db                	test   %ebx,%ebx
8010169e:	74 2c                	je     801016cc <iunlock+0x3c>
801016a0:	8d 73 0c             	lea    0xc(%ebx),%esi
801016a3:	83 ec 0c             	sub    $0xc,%esp
801016a6:	56                   	push   %esi
801016a7:	e8 d6 24 00 00       	call   80103b82 <holdingsleep>
801016ac:	83 c4 10             	add    $0x10,%esp
801016af:	85 c0                	test   %eax,%eax
801016b1:	74 19                	je     801016cc <iunlock+0x3c>
801016b3:	83 7b 08 00          	cmpl   $0x0,0x8(%ebx)
801016b7:	7e 13                	jle    801016cc <iunlock+0x3c>
  releasesleep(&ip->lock);
801016b9:	83 ec 0c             	sub    $0xc,%esp
801016bc:	56                   	push   %esi
801016bd:	e8 81 24 00 00       	call   80103b43 <releasesleep>
}
801016c2:	83 c4 10             	add    $0x10,%esp
801016c5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016c8:	5b                   	pop    %ebx
801016c9:	5e                   	pop    %esi
801016ca:	5d                   	pop    %ebp
801016cb:	c3                   	ret    
    panic("iunlock");
801016cc:	83 ec 0c             	sub    $0xc,%esp
801016cf:	68 df 68 10 80       	push   $0x801068df
801016d4:	e8 83 ec ff ff       	call   8010035c <panic>

801016d9 <iput>:
{
801016d9:	f3 0f 1e fb          	endbr32 
801016dd:	55                   	push   %ebp
801016de:	89 e5                	mov    %esp,%ebp
801016e0:	57                   	push   %edi
801016e1:	56                   	push   %esi
801016e2:	53                   	push   %ebx
801016e3:	83 ec 18             	sub    $0x18,%esp
801016e6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801016e9:	8d 73 0c             	lea    0xc(%ebx),%esi
801016ec:	56                   	push   %esi
801016ed:	e8 fe 23 00 00       	call   80103af0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801016f2:	83 c4 10             	add    $0x10,%esp
801016f5:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
801016f9:	74 07                	je     80101702 <iput+0x29>
801016fb:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101700:	74 35                	je     80101737 <iput+0x5e>
  releasesleep(&ip->lock);
80101702:	83 ec 0c             	sub    $0xc,%esp
80101705:	56                   	push   %esi
80101706:	e8 38 24 00 00       	call   80103b43 <releasesleep>
  acquire(&icache.lock);
8010170b:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101712:	e8 0d 26 00 00       	call   80103d24 <acquire>
  ip->ref--;
80101717:	8b 43 08             	mov    0x8(%ebx),%eax
8010171a:	83 e8 01             	sub    $0x1,%eax
8010171d:	89 43 08             	mov    %eax,0x8(%ebx)
  release(&icache.lock);
80101720:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101727:	e8 61 26 00 00       	call   80103d8d <release>
}
8010172c:	83 c4 10             	add    $0x10,%esp
8010172f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101732:	5b                   	pop    %ebx
80101733:	5e                   	pop    %esi
80101734:	5f                   	pop    %edi
80101735:	5d                   	pop    %ebp
80101736:	c3                   	ret    
    acquire(&icache.lock);
80101737:	83 ec 0c             	sub    $0xc,%esp
8010173a:	68 e0 09 11 80       	push   $0x801109e0
8010173f:	e8 e0 25 00 00       	call   80103d24 <acquire>
    int r = ip->ref;
80101744:	8b 7b 08             	mov    0x8(%ebx),%edi
    release(&icache.lock);
80101747:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010174e:	e8 3a 26 00 00       	call   80103d8d <release>
    if(r == 1){
80101753:	83 c4 10             	add    $0x10,%esp
80101756:	83 ff 01             	cmp    $0x1,%edi
80101759:	75 a7                	jne    80101702 <iput+0x29>
      itrunc(ip);
8010175b:	89 d8                	mov    %ebx,%eax
8010175d:	e8 82 fd ff ff       	call   801014e4 <itrunc>
      ip->type = 0;
80101762:	66 c7 43 50 00 00    	movw   $0x0,0x50(%ebx)
      iupdate(ip);
80101768:	83 ec 0c             	sub    $0xc,%esp
8010176b:	53                   	push   %ebx
8010176c:	e8 f0 fc ff ff       	call   80101461 <iupdate>
      ip->valid = 0;
80101771:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101778:	83 c4 10             	add    $0x10,%esp
8010177b:	eb 85                	jmp    80101702 <iput+0x29>

8010177d <iunlockput>:
{
8010177d:	f3 0f 1e fb          	endbr32 
80101781:	55                   	push   %ebp
80101782:	89 e5                	mov    %esp,%ebp
80101784:	53                   	push   %ebx
80101785:	83 ec 10             	sub    $0x10,%esp
80101788:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010178b:	53                   	push   %ebx
8010178c:	e8 ff fe ff ff       	call   80101690 <iunlock>
  iput(ip);
80101791:	89 1c 24             	mov    %ebx,(%esp)
80101794:	e8 40 ff ff ff       	call   801016d9 <iput>
}
80101799:	83 c4 10             	add    $0x10,%esp
8010179c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010179f:	c9                   	leave  
801017a0:	c3                   	ret    

801017a1 <stati>:
{
801017a1:	f3 0f 1e fb          	endbr32 
801017a5:	55                   	push   %ebp
801017a6:	89 e5                	mov    %esp,%ebp
801017a8:	8b 55 08             	mov    0x8(%ebp),%edx
801017ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
801017ae:	8b 0a                	mov    (%edx),%ecx
801017b0:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
801017b3:	8b 4a 04             	mov    0x4(%edx),%ecx
801017b6:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
801017b9:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
801017bd:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
801017c0:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
801017c4:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
801017c8:	8b 52 58             	mov    0x58(%edx),%edx
801017cb:	89 50 10             	mov    %edx,0x10(%eax)
}
801017ce:	5d                   	pop    %ebp
801017cf:	c3                   	ret    

801017d0 <readi>:
{
801017d0:	f3 0f 1e fb          	endbr32 
801017d4:	55                   	push   %ebp
801017d5:	89 e5                	mov    %esp,%ebp
801017d7:	57                   	push   %edi
801017d8:	56                   	push   %esi
801017d9:	53                   	push   %ebx
801017da:	83 ec 1c             	sub    $0x1c,%esp
801017dd:	8b 75 10             	mov    0x10(%ebp),%esi
  if(ip->type == T_DEV){
801017e0:	8b 45 08             	mov    0x8(%ebp),%eax
801017e3:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
801017e8:	74 2c                	je     80101816 <readi+0x46>
  if(off > ip->size || off + n < off)
801017ea:	8b 45 08             	mov    0x8(%ebp),%eax
801017ed:	8b 40 58             	mov    0x58(%eax),%eax
801017f0:	39 f0                	cmp    %esi,%eax
801017f2:	0f 82 cb 00 00 00    	jb     801018c3 <readi+0xf3>
801017f8:	89 f2                	mov    %esi,%edx
801017fa:	03 55 14             	add    0x14(%ebp),%edx
801017fd:	0f 82 c7 00 00 00    	jb     801018ca <readi+0xfa>
  if(off + n > ip->size)
80101803:	39 d0                	cmp    %edx,%eax
80101805:	73 05                	jae    8010180c <readi+0x3c>
    n = ip->size - off;
80101807:	29 f0                	sub    %esi,%eax
80101809:	89 45 14             	mov    %eax,0x14(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010180c:	bf 00 00 00 00       	mov    $0x0,%edi
80101811:	e9 8f 00 00 00       	jmp    801018a5 <readi+0xd5>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101816:	0f b7 40 52          	movzwl 0x52(%eax),%eax
8010181a:	66 83 f8 09          	cmp    $0x9,%ax
8010181e:	0f 87 91 00 00 00    	ja     801018b5 <readi+0xe5>
80101824:	98                   	cwtl   
80101825:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
8010182c:	85 c0                	test   %eax,%eax
8010182e:	0f 84 88 00 00 00    	je     801018bc <readi+0xec>
    return devsw[ip->major].read(ip, dst, n);
80101834:	83 ec 04             	sub    $0x4,%esp
80101837:	ff 75 14             	pushl  0x14(%ebp)
8010183a:	ff 75 0c             	pushl  0xc(%ebp)
8010183d:	ff 75 08             	pushl  0x8(%ebp)
80101840:	ff d0                	call   *%eax
80101842:	83 c4 10             	add    $0x10,%esp
80101845:	eb 66                	jmp    801018ad <readi+0xdd>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101847:	89 f2                	mov    %esi,%edx
80101849:	c1 ea 09             	shr    $0x9,%edx
8010184c:	8b 45 08             	mov    0x8(%ebp),%eax
8010184f:	e8 44 f9 ff ff       	call   80101198 <bmap>
80101854:	83 ec 08             	sub    $0x8,%esp
80101857:	50                   	push   %eax
80101858:	8b 45 08             	mov    0x8(%ebp),%eax
8010185b:	ff 30                	pushl  (%eax)
8010185d:	e8 0e e9 ff ff       	call   80100170 <bread>
80101862:	89 c1                	mov    %eax,%ecx
    m = min(n - tot, BSIZE - off%BSIZE);
80101864:	89 f0                	mov    %esi,%eax
80101866:	25 ff 01 00 00       	and    $0x1ff,%eax
8010186b:	bb 00 02 00 00       	mov    $0x200,%ebx
80101870:	29 c3                	sub    %eax,%ebx
80101872:	8b 55 14             	mov    0x14(%ebp),%edx
80101875:	29 fa                	sub    %edi,%edx
80101877:	83 c4 0c             	add    $0xc,%esp
8010187a:	39 d3                	cmp    %edx,%ebx
8010187c:	0f 47 da             	cmova  %edx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
8010187f:	53                   	push   %ebx
80101880:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101883:	8d 44 01 5c          	lea    0x5c(%ecx,%eax,1),%eax
80101887:	50                   	push   %eax
80101888:	ff 75 0c             	pushl  0xc(%ebp)
8010188b:	e8 c8 25 00 00       	call   80103e58 <memmove>
    brelse(bp);
80101890:	83 c4 04             	add    $0x4,%esp
80101893:	ff 75 e4             	pushl  -0x1c(%ebp)
80101896:	e8 46 e9 ff ff       	call   801001e1 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010189b:	01 df                	add    %ebx,%edi
8010189d:	01 de                	add    %ebx,%esi
8010189f:	01 5d 0c             	add    %ebx,0xc(%ebp)
801018a2:	83 c4 10             	add    $0x10,%esp
801018a5:	39 7d 14             	cmp    %edi,0x14(%ebp)
801018a8:	77 9d                	ja     80101847 <readi+0x77>
  return n;
801018aa:	8b 45 14             	mov    0x14(%ebp),%eax
}
801018ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018b0:	5b                   	pop    %ebx
801018b1:	5e                   	pop    %esi
801018b2:	5f                   	pop    %edi
801018b3:	5d                   	pop    %ebp
801018b4:	c3                   	ret    
      return -1;
801018b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801018ba:	eb f1                	jmp    801018ad <readi+0xdd>
801018bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801018c1:	eb ea                	jmp    801018ad <readi+0xdd>
    return -1;
801018c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801018c8:	eb e3                	jmp    801018ad <readi+0xdd>
801018ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801018cf:	eb dc                	jmp    801018ad <readi+0xdd>

801018d1 <writei>:
{
801018d1:	f3 0f 1e fb          	endbr32 
801018d5:	55                   	push   %ebp
801018d6:	89 e5                	mov    %esp,%ebp
801018d8:	57                   	push   %edi
801018d9:	56                   	push   %esi
801018da:	53                   	push   %ebx
801018db:	83 ec 1c             	sub    $0x1c,%esp
801018de:	8b 75 10             	mov    0x10(%ebp),%esi
  if(ip->type == T_DEV){
801018e1:	8b 45 08             	mov    0x8(%ebp),%eax
801018e4:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
801018e9:	0f 84 9b 00 00 00    	je     8010198a <writei+0xb9>
  if(off > ip->size || off + n < off)
801018ef:	8b 45 08             	mov    0x8(%ebp),%eax
801018f2:	39 70 58             	cmp    %esi,0x58(%eax)
801018f5:	0f 82 f0 00 00 00    	jb     801019eb <writei+0x11a>
801018fb:	89 f0                	mov    %esi,%eax
801018fd:	03 45 14             	add    0x14(%ebp),%eax
80101900:	0f 82 ec 00 00 00    	jb     801019f2 <writei+0x121>
  if(off + n > MAXFILE*BSIZE)
80101906:	3d 00 18 01 00       	cmp    $0x11800,%eax
8010190b:	0f 87 e8 00 00 00    	ja     801019f9 <writei+0x128>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101911:	bf 00 00 00 00       	mov    $0x0,%edi
80101916:	3b 7d 14             	cmp    0x14(%ebp),%edi
80101919:	0f 83 94 00 00 00    	jae    801019b3 <writei+0xe2>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
8010191f:	89 f2                	mov    %esi,%edx
80101921:	c1 ea 09             	shr    $0x9,%edx
80101924:	8b 45 08             	mov    0x8(%ebp),%eax
80101927:	e8 6c f8 ff ff       	call   80101198 <bmap>
8010192c:	83 ec 08             	sub    $0x8,%esp
8010192f:	50                   	push   %eax
80101930:	8b 45 08             	mov    0x8(%ebp),%eax
80101933:	ff 30                	pushl  (%eax)
80101935:	e8 36 e8 ff ff       	call   80100170 <bread>
8010193a:	89 c1                	mov    %eax,%ecx
    m = min(n - tot, BSIZE - off%BSIZE);
8010193c:	89 f0                	mov    %esi,%eax
8010193e:	25 ff 01 00 00       	and    $0x1ff,%eax
80101943:	bb 00 02 00 00       	mov    $0x200,%ebx
80101948:	29 c3                	sub    %eax,%ebx
8010194a:	8b 55 14             	mov    0x14(%ebp),%edx
8010194d:	29 fa                	sub    %edi,%edx
8010194f:	83 c4 0c             	add    $0xc,%esp
80101952:	39 d3                	cmp    %edx,%ebx
80101954:	0f 47 da             	cmova  %edx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101957:	53                   	push   %ebx
80101958:	ff 75 0c             	pushl  0xc(%ebp)
8010195b:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010195e:	8d 44 01 5c          	lea    0x5c(%ecx,%eax,1),%eax
80101962:	50                   	push   %eax
80101963:	e8 f0 24 00 00       	call   80103e58 <memmove>
    log_write(bp);
80101968:	83 c4 04             	add    $0x4,%esp
8010196b:	ff 75 e4             	pushl  -0x1c(%ebp)
8010196e:	e8 43 10 00 00       	call   801029b6 <log_write>
    brelse(bp);
80101973:	83 c4 04             	add    $0x4,%esp
80101976:	ff 75 e4             	pushl  -0x1c(%ebp)
80101979:	e8 63 e8 ff ff       	call   801001e1 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010197e:	01 df                	add    %ebx,%edi
80101980:	01 de                	add    %ebx,%esi
80101982:	01 5d 0c             	add    %ebx,0xc(%ebp)
80101985:	83 c4 10             	add    $0x10,%esp
80101988:	eb 8c                	jmp    80101916 <writei+0x45>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
8010198a:	0f b7 40 52          	movzwl 0x52(%eax),%eax
8010198e:	66 83 f8 09          	cmp    $0x9,%ax
80101992:	77 49                	ja     801019dd <writei+0x10c>
80101994:	98                   	cwtl   
80101995:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
8010199c:	85 c0                	test   %eax,%eax
8010199e:	74 44                	je     801019e4 <writei+0x113>
    return devsw[ip->major].write(ip, src, n);
801019a0:	83 ec 04             	sub    $0x4,%esp
801019a3:	ff 75 14             	pushl  0x14(%ebp)
801019a6:	ff 75 0c             	pushl  0xc(%ebp)
801019a9:	ff 75 08             	pushl  0x8(%ebp)
801019ac:	ff d0                	call   *%eax
801019ae:	83 c4 10             	add    $0x10,%esp
801019b1:	eb 11                	jmp    801019c4 <writei+0xf3>
  if(n > 0 && off > ip->size){
801019b3:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801019b7:	74 08                	je     801019c1 <writei+0xf0>
801019b9:	8b 45 08             	mov    0x8(%ebp),%eax
801019bc:	39 70 58             	cmp    %esi,0x58(%eax)
801019bf:	72 0b                	jb     801019cc <writei+0xfb>
  return n;
801019c1:	8b 45 14             	mov    0x14(%ebp),%eax
}
801019c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019c7:	5b                   	pop    %ebx
801019c8:	5e                   	pop    %esi
801019c9:	5f                   	pop    %edi
801019ca:	5d                   	pop    %ebp
801019cb:	c3                   	ret    
    ip->size = off;
801019cc:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
801019cf:	83 ec 0c             	sub    $0xc,%esp
801019d2:	50                   	push   %eax
801019d3:	e8 89 fa ff ff       	call   80101461 <iupdate>
801019d8:	83 c4 10             	add    $0x10,%esp
801019db:	eb e4                	jmp    801019c1 <writei+0xf0>
      return -1;
801019dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801019e2:	eb e0                	jmp    801019c4 <writei+0xf3>
801019e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801019e9:	eb d9                	jmp    801019c4 <writei+0xf3>
    return -1;
801019eb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801019f0:	eb d2                	jmp    801019c4 <writei+0xf3>
801019f2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801019f7:	eb cb                	jmp    801019c4 <writei+0xf3>
    return -1;
801019f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801019fe:	eb c4                	jmp    801019c4 <writei+0xf3>

80101a00 <namecmp>:
{
80101a00:	f3 0f 1e fb          	endbr32 
80101a04:	55                   	push   %ebp
80101a05:	89 e5                	mov    %esp,%ebp
80101a07:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101a0a:	6a 0e                	push   $0xe
80101a0c:	ff 75 0c             	pushl  0xc(%ebp)
80101a0f:	ff 75 08             	pushl  0x8(%ebp)
80101a12:	e8 b3 24 00 00       	call   80103eca <strncmp>
}
80101a17:	c9                   	leave  
80101a18:	c3                   	ret    

80101a19 <dirlookup>:
{
80101a19:	f3 0f 1e fb          	endbr32 
80101a1d:	55                   	push   %ebp
80101a1e:	89 e5                	mov    %esp,%ebp
80101a20:	57                   	push   %edi
80101a21:	56                   	push   %esi
80101a22:	53                   	push   %ebx
80101a23:	83 ec 1c             	sub    $0x1c,%esp
80101a26:	8b 75 08             	mov    0x8(%ebp),%esi
80101a29:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(dp->type != T_DIR)
80101a2c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101a31:	75 07                	jne    80101a3a <dirlookup+0x21>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101a33:	bb 00 00 00 00       	mov    $0x0,%ebx
80101a38:	eb 1d                	jmp    80101a57 <dirlookup+0x3e>
    panic("dirlookup not DIR");
80101a3a:	83 ec 0c             	sub    $0xc,%esp
80101a3d:	68 e7 68 10 80       	push   $0x801068e7
80101a42:	e8 15 e9 ff ff       	call   8010035c <panic>
      panic("dirlookup read");
80101a47:	83 ec 0c             	sub    $0xc,%esp
80101a4a:	68 f9 68 10 80       	push   $0x801068f9
80101a4f:	e8 08 e9 ff ff       	call   8010035c <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101a54:	83 c3 10             	add    $0x10,%ebx
80101a57:	39 5e 58             	cmp    %ebx,0x58(%esi)
80101a5a:	76 48                	jbe    80101aa4 <dirlookup+0x8b>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101a5c:	6a 10                	push   $0x10
80101a5e:	53                   	push   %ebx
80101a5f:	8d 45 d8             	lea    -0x28(%ebp),%eax
80101a62:	50                   	push   %eax
80101a63:	56                   	push   %esi
80101a64:	e8 67 fd ff ff       	call   801017d0 <readi>
80101a69:	83 c4 10             	add    $0x10,%esp
80101a6c:	83 f8 10             	cmp    $0x10,%eax
80101a6f:	75 d6                	jne    80101a47 <dirlookup+0x2e>
    if(de.inum == 0)
80101a71:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101a76:	74 dc                	je     80101a54 <dirlookup+0x3b>
    if(namecmp(name, de.name) == 0){
80101a78:	83 ec 08             	sub    $0x8,%esp
80101a7b:	8d 45 da             	lea    -0x26(%ebp),%eax
80101a7e:	50                   	push   %eax
80101a7f:	57                   	push   %edi
80101a80:	e8 7b ff ff ff       	call   80101a00 <namecmp>
80101a85:	83 c4 10             	add    $0x10,%esp
80101a88:	85 c0                	test   %eax,%eax
80101a8a:	75 c8                	jne    80101a54 <dirlookup+0x3b>
      if(poff)
80101a8c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80101a90:	74 05                	je     80101a97 <dirlookup+0x7e>
        *poff = off;
80101a92:	8b 45 10             	mov    0x10(%ebp),%eax
80101a95:	89 18                	mov    %ebx,(%eax)
      inum = de.inum;
80101a97:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101a9b:	8b 06                	mov    (%esi),%eax
80101a9d:	e8 9c f7 ff ff       	call   8010123e <iget>
80101aa2:	eb 05                	jmp    80101aa9 <dirlookup+0x90>
  return 0;
80101aa4:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101aa9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101aac:	5b                   	pop    %ebx
80101aad:	5e                   	pop    %esi
80101aae:	5f                   	pop    %edi
80101aaf:	5d                   	pop    %ebp
80101ab0:	c3                   	ret    

80101ab1 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101ab1:	55                   	push   %ebp
80101ab2:	89 e5                	mov    %esp,%ebp
80101ab4:	57                   	push   %edi
80101ab5:	56                   	push   %esi
80101ab6:	53                   	push   %ebx
80101ab7:	83 ec 1c             	sub    $0x1c,%esp
80101aba:	89 c3                	mov    %eax,%ebx
80101abc:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101abf:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101ac2:	80 38 2f             	cmpb   $0x2f,(%eax)
80101ac5:	74 17                	je     80101ade <namex+0x2d>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101ac7:	e8 62 18 00 00       	call   8010332e <myproc>
80101acc:	83 ec 0c             	sub    $0xc,%esp
80101acf:	ff 70 68             	pushl  0x68(%eax)
80101ad2:	e8 bf fa ff ff       	call   80101596 <idup>
80101ad7:	89 c6                	mov    %eax,%esi
80101ad9:	83 c4 10             	add    $0x10,%esp
80101adc:	eb 53                	jmp    80101b31 <namex+0x80>
    ip = iget(ROOTDEV, ROOTINO);
80101ade:	ba 01 00 00 00       	mov    $0x1,%edx
80101ae3:	b8 01 00 00 00       	mov    $0x1,%eax
80101ae8:	e8 51 f7 ff ff       	call   8010123e <iget>
80101aed:	89 c6                	mov    %eax,%esi
80101aef:	eb 40                	jmp    80101b31 <namex+0x80>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
      iunlockput(ip);
80101af1:	83 ec 0c             	sub    $0xc,%esp
80101af4:	56                   	push   %esi
80101af5:	e8 83 fc ff ff       	call   8010177d <iunlockput>
      return 0;
80101afa:	83 c4 10             	add    $0x10,%esp
80101afd:	be 00 00 00 00       	mov    $0x0,%esi
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101b02:	89 f0                	mov    %esi,%eax
80101b04:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b07:	5b                   	pop    %ebx
80101b08:	5e                   	pop    %esi
80101b09:	5f                   	pop    %edi
80101b0a:	5d                   	pop    %ebp
80101b0b:	c3                   	ret    
    if((next = dirlookup(ip, name, 0)) == 0){
80101b0c:	83 ec 04             	sub    $0x4,%esp
80101b0f:	6a 00                	push   $0x0
80101b11:	ff 75 e4             	pushl  -0x1c(%ebp)
80101b14:	56                   	push   %esi
80101b15:	e8 ff fe ff ff       	call   80101a19 <dirlookup>
80101b1a:	89 c7                	mov    %eax,%edi
80101b1c:	83 c4 10             	add    $0x10,%esp
80101b1f:	85 c0                	test   %eax,%eax
80101b21:	74 4a                	je     80101b6d <namex+0xbc>
    iunlockput(ip);
80101b23:	83 ec 0c             	sub    $0xc,%esp
80101b26:	56                   	push   %esi
80101b27:	e8 51 fc ff ff       	call   8010177d <iunlockput>
80101b2c:	83 c4 10             	add    $0x10,%esp
    ip = next;
80101b2f:	89 fe                	mov    %edi,%esi
  while((path = skipelem(path, name)) != 0){
80101b31:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101b34:	89 d8                	mov    %ebx,%eax
80101b36:	e8 49 f4 ff ff       	call   80100f84 <skipelem>
80101b3b:	89 c3                	mov    %eax,%ebx
80101b3d:	85 c0                	test   %eax,%eax
80101b3f:	74 3c                	je     80101b7d <namex+0xcc>
    ilock(ip);
80101b41:	83 ec 0c             	sub    $0xc,%esp
80101b44:	56                   	push   %esi
80101b45:	e8 80 fa ff ff       	call   801015ca <ilock>
    if(ip->type != T_DIR){
80101b4a:	83 c4 10             	add    $0x10,%esp
80101b4d:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101b52:	75 9d                	jne    80101af1 <namex+0x40>
    if(nameiparent && *path == '\0'){
80101b54:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80101b58:	74 b2                	je     80101b0c <namex+0x5b>
80101b5a:	80 3b 00             	cmpb   $0x0,(%ebx)
80101b5d:	75 ad                	jne    80101b0c <namex+0x5b>
      iunlock(ip);
80101b5f:	83 ec 0c             	sub    $0xc,%esp
80101b62:	56                   	push   %esi
80101b63:	e8 28 fb ff ff       	call   80101690 <iunlock>
      return ip;
80101b68:	83 c4 10             	add    $0x10,%esp
80101b6b:	eb 95                	jmp    80101b02 <namex+0x51>
      iunlockput(ip);
80101b6d:	83 ec 0c             	sub    $0xc,%esp
80101b70:	56                   	push   %esi
80101b71:	e8 07 fc ff ff       	call   8010177d <iunlockput>
      return 0;
80101b76:	83 c4 10             	add    $0x10,%esp
80101b79:	89 fe                	mov    %edi,%esi
80101b7b:	eb 85                	jmp    80101b02 <namex+0x51>
  if(nameiparent){
80101b7d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80101b81:	0f 84 7b ff ff ff    	je     80101b02 <namex+0x51>
    iput(ip);
80101b87:	83 ec 0c             	sub    $0xc,%esp
80101b8a:	56                   	push   %esi
80101b8b:	e8 49 fb ff ff       	call   801016d9 <iput>
    return 0;
80101b90:	83 c4 10             	add    $0x10,%esp
80101b93:	89 de                	mov    %ebx,%esi
80101b95:	e9 68 ff ff ff       	jmp    80101b02 <namex+0x51>

80101b9a <dirlink>:
{
80101b9a:	f3 0f 1e fb          	endbr32 
80101b9e:	55                   	push   %ebp
80101b9f:	89 e5                	mov    %esp,%ebp
80101ba1:	57                   	push   %edi
80101ba2:	56                   	push   %esi
80101ba3:	53                   	push   %ebx
80101ba4:	83 ec 20             	sub    $0x20,%esp
80101ba7:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101baa:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if((ip = dirlookup(dp, name, 0)) != 0){
80101bad:	6a 00                	push   $0x0
80101baf:	57                   	push   %edi
80101bb0:	53                   	push   %ebx
80101bb1:	e8 63 fe ff ff       	call   80101a19 <dirlookup>
80101bb6:	83 c4 10             	add    $0x10,%esp
80101bb9:	85 c0                	test   %eax,%eax
80101bbb:	75 07                	jne    80101bc4 <dirlink+0x2a>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101bbd:	b8 00 00 00 00       	mov    $0x0,%eax
80101bc2:	eb 23                	jmp    80101be7 <dirlink+0x4d>
    iput(ip);
80101bc4:	83 ec 0c             	sub    $0xc,%esp
80101bc7:	50                   	push   %eax
80101bc8:	e8 0c fb ff ff       	call   801016d9 <iput>
    return -1;
80101bcd:	83 c4 10             	add    $0x10,%esp
80101bd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101bd5:	eb 63                	jmp    80101c3a <dirlink+0xa0>
      panic("dirlink read");
80101bd7:	83 ec 0c             	sub    $0xc,%esp
80101bda:	68 08 69 10 80       	push   $0x80106908
80101bdf:	e8 78 e7 ff ff       	call   8010035c <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101be4:	8d 46 10             	lea    0x10(%esi),%eax
80101be7:	89 c6                	mov    %eax,%esi
80101be9:	39 43 58             	cmp    %eax,0x58(%ebx)
80101bec:	76 1c                	jbe    80101c0a <dirlink+0x70>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101bee:	6a 10                	push   $0x10
80101bf0:	50                   	push   %eax
80101bf1:	8d 45 d8             	lea    -0x28(%ebp),%eax
80101bf4:	50                   	push   %eax
80101bf5:	53                   	push   %ebx
80101bf6:	e8 d5 fb ff ff       	call   801017d0 <readi>
80101bfb:	83 c4 10             	add    $0x10,%esp
80101bfe:	83 f8 10             	cmp    $0x10,%eax
80101c01:	75 d4                	jne    80101bd7 <dirlink+0x3d>
    if(de.inum == 0)
80101c03:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c08:	75 da                	jne    80101be4 <dirlink+0x4a>
  strncpy(de.name, name, DIRSIZ);
80101c0a:	83 ec 04             	sub    $0x4,%esp
80101c0d:	6a 0e                	push   $0xe
80101c0f:	57                   	push   %edi
80101c10:	8d 7d d8             	lea    -0x28(%ebp),%edi
80101c13:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c16:	50                   	push   %eax
80101c17:	e8 ef 22 00 00       	call   80103f0b <strncpy>
  de.inum = inum;
80101c1c:	8b 45 10             	mov    0x10(%ebp),%eax
80101c1f:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c23:	6a 10                	push   $0x10
80101c25:	56                   	push   %esi
80101c26:	57                   	push   %edi
80101c27:	53                   	push   %ebx
80101c28:	e8 a4 fc ff ff       	call   801018d1 <writei>
80101c2d:	83 c4 20             	add    $0x20,%esp
80101c30:	83 f8 10             	cmp    $0x10,%eax
80101c33:	75 0d                	jne    80101c42 <dirlink+0xa8>
  return 0;
80101c35:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101c3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c3d:	5b                   	pop    %ebx
80101c3e:	5e                   	pop    %esi
80101c3f:	5f                   	pop    %edi
80101c40:	5d                   	pop    %ebp
80101c41:	c3                   	ret    
    panic("dirlink");
80101c42:	83 ec 0c             	sub    $0xc,%esp
80101c45:	68 bc 6f 10 80       	push   $0x80106fbc
80101c4a:	e8 0d e7 ff ff       	call   8010035c <panic>

80101c4f <namei>:

struct inode*
namei(char *path)
{
80101c4f:	f3 0f 1e fb          	endbr32 
80101c53:	55                   	push   %ebp
80101c54:	89 e5                	mov    %esp,%ebp
80101c56:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101c59:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101c5c:	ba 00 00 00 00       	mov    $0x0,%edx
80101c61:	8b 45 08             	mov    0x8(%ebp),%eax
80101c64:	e8 48 fe ff ff       	call   80101ab1 <namex>
}
80101c69:	c9                   	leave  
80101c6a:	c3                   	ret    

80101c6b <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101c6b:	f3 0f 1e fb          	endbr32 
80101c6f:	55                   	push   %ebp
80101c70:	89 e5                	mov    %esp,%ebp
80101c72:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
80101c75:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101c78:	ba 01 00 00 00       	mov    $0x1,%edx
80101c7d:	8b 45 08             	mov    0x8(%ebp),%eax
80101c80:	e8 2c fe ff ff       	call   80101ab1 <namex>
}
80101c85:	c9                   	leave  
80101c86:	c3                   	ret    

80101c87 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
80101c87:	89 c1                	mov    %eax,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101c89:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101c8e:	ec                   	in     (%dx),%al
80101c8f:	89 c2                	mov    %eax,%edx
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101c91:	83 e0 c0             	and    $0xffffffc0,%eax
80101c94:	3c 40                	cmp    $0x40,%al
80101c96:	75 f1                	jne    80101c89 <idewait+0x2>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80101c98:	85 c9                	test   %ecx,%ecx
80101c9a:	74 0a                	je     80101ca6 <idewait+0x1f>
80101c9c:	f6 c2 21             	test   $0x21,%dl
80101c9f:	75 08                	jne    80101ca9 <idewait+0x22>
    return -1;
  return 0;
80101ca1:	b9 00 00 00 00       	mov    $0x0,%ecx
}
80101ca6:	89 c8                	mov    %ecx,%eax
80101ca8:	c3                   	ret    
    return -1;
80101ca9:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
80101cae:	eb f6                	jmp    80101ca6 <idewait+0x1f>

80101cb0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101cb0:	55                   	push   %ebp
80101cb1:	89 e5                	mov    %esp,%ebp
80101cb3:	56                   	push   %esi
80101cb4:	53                   	push   %ebx
  if(b == 0)
80101cb5:	85 c0                	test   %eax,%eax
80101cb7:	0f 84 91 00 00 00    	je     80101d4e <idestart+0x9e>
80101cbd:	89 c6                	mov    %eax,%esi
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101cbf:	8b 58 08             	mov    0x8(%eax),%ebx
80101cc2:	81 fb cf 07 00 00    	cmp    $0x7cf,%ebx
80101cc8:	0f 87 8d 00 00 00    	ja     80101d5b <idestart+0xab>
  int read_cmd = (sector_per_block == 1) ? IDE_CMD_READ :  IDE_CMD_RDMUL;
  int write_cmd = (sector_per_block == 1) ? IDE_CMD_WRITE : IDE_CMD_WRMUL;

  if (sector_per_block > 7) panic("idestart");

  idewait(0);
80101cce:	b8 00 00 00 00       	mov    $0x0,%eax
80101cd3:	e8 af ff ff ff       	call   80101c87 <idewait>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101cd8:	b8 00 00 00 00       	mov    $0x0,%eax
80101cdd:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101ce2:	ee                   	out    %al,(%dx)
80101ce3:	b8 01 00 00 00       	mov    $0x1,%eax
80101ce8:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101ced:	ee                   	out    %al,(%dx)
80101cee:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101cf3:	89 d8                	mov    %ebx,%eax
80101cf5:	ee                   	out    %al,(%dx)
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101cf6:	89 d8                	mov    %ebx,%eax
80101cf8:	c1 f8 08             	sar    $0x8,%eax
80101cfb:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101d00:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
80101d01:	89 d8                	mov    %ebx,%eax
80101d03:	c1 f8 10             	sar    $0x10,%eax
80101d06:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101d0b:	ee                   	out    %al,(%dx)
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101d0c:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101d10:	c1 e0 04             	shl    $0x4,%eax
80101d13:	83 e0 10             	and    $0x10,%eax
80101d16:	c1 fb 18             	sar    $0x18,%ebx
80101d19:	83 e3 0f             	and    $0xf,%ebx
80101d1c:	09 d8                	or     %ebx,%eax
80101d1e:	83 c8 e0             	or     $0xffffffe0,%eax
80101d21:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101d26:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101d27:	f6 06 04             	testb  $0x4,(%esi)
80101d2a:	74 3c                	je     80101d68 <idestart+0xb8>
80101d2c:	b8 30 00 00 00       	mov    $0x30,%eax
80101d31:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101d36:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
80101d37:	83 c6 5c             	add    $0x5c,%esi
  asm volatile("cld; rep outsl" :
80101d3a:	b9 80 00 00 00       	mov    $0x80,%ecx
80101d3f:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101d44:	fc                   	cld    
80101d45:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101d47:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101d4a:	5b                   	pop    %ebx
80101d4b:	5e                   	pop    %esi
80101d4c:	5d                   	pop    %ebp
80101d4d:	c3                   	ret    
    panic("idestart");
80101d4e:	83 ec 0c             	sub    $0xc,%esp
80101d51:	68 6b 69 10 80       	push   $0x8010696b
80101d56:	e8 01 e6 ff ff       	call   8010035c <panic>
    panic("incorrect blockno");
80101d5b:	83 ec 0c             	sub    $0xc,%esp
80101d5e:	68 74 69 10 80       	push   $0x80106974
80101d63:	e8 f4 e5 ff ff       	call   8010035c <panic>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101d68:	b8 20 00 00 00       	mov    $0x20,%eax
80101d6d:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101d72:	ee                   	out    %al,(%dx)
}
80101d73:	eb d2                	jmp    80101d47 <idestart+0x97>

80101d75 <ideinit>:
{
80101d75:	f3 0f 1e fb          	endbr32 
80101d79:	55                   	push   %ebp
80101d7a:	89 e5                	mov    %esp,%ebp
80101d7c:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80101d7f:	68 86 69 10 80       	push   $0x80106986
80101d84:	68 80 a5 10 80       	push   $0x8010a580
80101d89:	e8 46 1e 00 00       	call   80103bd4 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80101d8e:	83 c4 08             	add    $0x8,%esp
80101d91:	a1 00 2d 11 80       	mov    0x80112d00,%eax
80101d96:	83 e8 01             	sub    $0x1,%eax
80101d99:	50                   	push   %eax
80101d9a:	6a 0e                	push   $0xe
80101d9c:	e8 5a 02 00 00       	call   80101ffb <ioapicenable>
  idewait(0);
80101da1:	b8 00 00 00 00       	mov    $0x0,%eax
80101da6:	e8 dc fe ff ff       	call   80101c87 <idewait>
80101dab:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80101db0:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101db5:	ee                   	out    %al,(%dx)
  for(i=0; i<1000; i++){
80101db6:	83 c4 10             	add    $0x10,%esp
80101db9:	b9 00 00 00 00       	mov    $0x0,%ecx
80101dbe:	eb 03                	jmp    80101dc3 <ideinit+0x4e>
80101dc0:	83 c1 01             	add    $0x1,%ecx
80101dc3:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
80101dc9:	7f 14                	jg     80101ddf <ideinit+0x6a>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101dcb:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101dd0:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80101dd1:	84 c0                	test   %al,%al
80101dd3:	74 eb                	je     80101dc0 <ideinit+0x4b>
      havedisk1 = 1;
80101dd5:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80101ddc:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101ddf:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80101de4:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101de9:	ee                   	out    %al,(%dx)
}
80101dea:	c9                   	leave  
80101deb:	c3                   	ret    

80101dec <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80101dec:	f3 0f 1e fb          	endbr32 
80101df0:	55                   	push   %ebp
80101df1:	89 e5                	mov    %esp,%ebp
80101df3:	57                   	push   %edi
80101df4:	53                   	push   %ebx
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80101df5:	83 ec 0c             	sub    $0xc,%esp
80101df8:	68 80 a5 10 80       	push   $0x8010a580
80101dfd:	e8 22 1f 00 00       	call   80103d24 <acquire>

  if((b = idequeue) == 0){
80101e02:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
80101e08:	83 c4 10             	add    $0x10,%esp
80101e0b:	85 db                	test   %ebx,%ebx
80101e0d:	74 48                	je     80101e57 <ideintr+0x6b>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80101e0f:	8b 43 58             	mov    0x58(%ebx),%eax
80101e12:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80101e17:	f6 03 04             	testb  $0x4,(%ebx)
80101e1a:	74 4d                	je     80101e69 <ideintr+0x7d>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80101e1c:	8b 03                	mov    (%ebx),%eax
80101e1e:	83 c8 02             	or     $0x2,%eax
  b->flags &= ~B_DIRTY;
80101e21:	83 e0 fb             	and    $0xfffffffb,%eax
80101e24:	89 03                	mov    %eax,(%ebx)
  wakeup(b);
80101e26:	83 ec 0c             	sub    $0xc,%esp
80101e29:	53                   	push   %ebx
80101e2a:	e8 2f 1b 00 00       	call   8010395e <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80101e2f:	a1 64 a5 10 80       	mov    0x8010a564,%eax
80101e34:	83 c4 10             	add    $0x10,%esp
80101e37:	85 c0                	test   %eax,%eax
80101e39:	74 05                	je     80101e40 <ideintr+0x54>
    idestart(idequeue);
80101e3b:	e8 70 fe ff ff       	call   80101cb0 <idestart>

  release(&idelock);
80101e40:	83 ec 0c             	sub    $0xc,%esp
80101e43:	68 80 a5 10 80       	push   $0x8010a580
80101e48:	e8 40 1f 00 00       	call   80103d8d <release>
80101e4d:	83 c4 10             	add    $0x10,%esp
}
80101e50:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101e53:	5b                   	pop    %ebx
80101e54:	5f                   	pop    %edi
80101e55:	5d                   	pop    %ebp
80101e56:	c3                   	ret    
    release(&idelock);
80101e57:	83 ec 0c             	sub    $0xc,%esp
80101e5a:	68 80 a5 10 80       	push   $0x8010a580
80101e5f:	e8 29 1f 00 00       	call   80103d8d <release>
    return;
80101e64:	83 c4 10             	add    $0x10,%esp
80101e67:	eb e7                	jmp    80101e50 <ideintr+0x64>
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80101e69:	b8 01 00 00 00       	mov    $0x1,%eax
80101e6e:	e8 14 fe ff ff       	call   80101c87 <idewait>
80101e73:	85 c0                	test   %eax,%eax
80101e75:	78 a5                	js     80101e1c <ideintr+0x30>
    insl(0x1f0, b->data, BSIZE/4);
80101e77:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80101e7a:	b9 80 00 00 00       	mov    $0x80,%ecx
80101e7f:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101e84:	fc                   	cld    
80101e85:	f3 6d                	rep insl (%dx),%es:(%edi)
}
80101e87:	eb 93                	jmp    80101e1c <ideintr+0x30>

80101e89 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80101e89:	f3 0f 1e fb          	endbr32 
80101e8d:	55                   	push   %ebp
80101e8e:	89 e5                	mov    %esp,%ebp
80101e90:	53                   	push   %ebx
80101e91:	83 ec 10             	sub    $0x10,%esp
80101e94:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
80101e97:	8d 43 0c             	lea    0xc(%ebx),%eax
80101e9a:	50                   	push   %eax
80101e9b:	e8 e2 1c 00 00       	call   80103b82 <holdingsleep>
80101ea0:	83 c4 10             	add    $0x10,%esp
80101ea3:	85 c0                	test   %eax,%eax
80101ea5:	74 37                	je     80101ede <iderw+0x55>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80101ea7:	8b 03                	mov    (%ebx),%eax
80101ea9:	83 e0 06             	and    $0x6,%eax
80101eac:	83 f8 02             	cmp    $0x2,%eax
80101eaf:	74 3a                	je     80101eeb <iderw+0x62>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
80101eb1:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
80101eb5:	74 09                	je     80101ec0 <iderw+0x37>
80101eb7:	83 3d 60 a5 10 80 00 	cmpl   $0x0,0x8010a560
80101ebe:	74 38                	je     80101ef8 <iderw+0x6f>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80101ec0:	83 ec 0c             	sub    $0xc,%esp
80101ec3:	68 80 a5 10 80       	push   $0x8010a580
80101ec8:	e8 57 1e 00 00       	call   80103d24 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
80101ecd:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80101ed4:	83 c4 10             	add    $0x10,%esp
80101ed7:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
80101edc:	eb 2a                	jmp    80101f08 <iderw+0x7f>
    panic("iderw: buf not locked");
80101ede:	83 ec 0c             	sub    $0xc,%esp
80101ee1:	68 8a 69 10 80       	push   $0x8010698a
80101ee6:	e8 71 e4 ff ff       	call   8010035c <panic>
    panic("iderw: nothing to do");
80101eeb:	83 ec 0c             	sub    $0xc,%esp
80101eee:	68 a0 69 10 80       	push   $0x801069a0
80101ef3:	e8 64 e4 ff ff       	call   8010035c <panic>
    panic("iderw: ide disk 1 not present");
80101ef8:	83 ec 0c             	sub    $0xc,%esp
80101efb:	68 b5 69 10 80       	push   $0x801069b5
80101f00:	e8 57 e4 ff ff       	call   8010035c <panic>
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80101f05:	8d 50 58             	lea    0x58(%eax),%edx
80101f08:	8b 02                	mov    (%edx),%eax
80101f0a:	85 c0                	test   %eax,%eax
80101f0c:	75 f7                	jne    80101f05 <iderw+0x7c>
    ;
  *pp = b;
80101f0e:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80101f10:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
80101f16:	75 1a                	jne    80101f32 <iderw+0xa9>
    idestart(b);
80101f18:	89 d8                	mov    %ebx,%eax
80101f1a:	e8 91 fd ff ff       	call   80101cb0 <idestart>
80101f1f:	eb 11                	jmp    80101f32 <iderw+0xa9>

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
80101f21:	83 ec 08             	sub    $0x8,%esp
80101f24:	68 80 a5 10 80       	push   $0x8010a580
80101f29:	53                   	push   %ebx
80101f2a:	e8 c2 18 00 00       	call   801037f1 <sleep>
80101f2f:	83 c4 10             	add    $0x10,%esp
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80101f32:	8b 03                	mov    (%ebx),%eax
80101f34:	83 e0 06             	and    $0x6,%eax
80101f37:	83 f8 02             	cmp    $0x2,%eax
80101f3a:	75 e5                	jne    80101f21 <iderw+0x98>
  }


  release(&idelock);
80101f3c:	83 ec 0c             	sub    $0xc,%esp
80101f3f:	68 80 a5 10 80       	push   $0x8010a580
80101f44:	e8 44 1e 00 00       	call   80103d8d <release>
}
80101f49:	83 c4 10             	add    $0x10,%esp
80101f4c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101f4f:	c9                   	leave  
80101f50:	c3                   	ret    

80101f51 <ioapicread>:
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80101f51:	8b 15 34 26 11 80    	mov    0x80112634,%edx
80101f57:	89 02                	mov    %eax,(%edx)
  return ioapic->data;
80101f59:	a1 34 26 11 80       	mov    0x80112634,%eax
80101f5e:	8b 40 10             	mov    0x10(%eax),%eax
}
80101f61:	c3                   	ret    

80101f62 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80101f62:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80101f68:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80101f6a:	a1 34 26 11 80       	mov    0x80112634,%eax
80101f6f:	89 50 10             	mov    %edx,0x10(%eax)
}
80101f72:	c3                   	ret    

80101f73 <ioapicinit>:

void
ioapicinit(void)
{
80101f73:	f3 0f 1e fb          	endbr32 
80101f77:	55                   	push   %ebp
80101f78:	89 e5                	mov    %esp,%ebp
80101f7a:	57                   	push   %edi
80101f7b:	56                   	push   %esi
80101f7c:	53                   	push   %ebx
80101f7d:	83 ec 0c             	sub    $0xc,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80101f80:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
80101f87:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80101f8a:	b8 01 00 00 00       	mov    $0x1,%eax
80101f8f:	e8 bd ff ff ff       	call   80101f51 <ioapicread>
80101f94:	c1 e8 10             	shr    $0x10,%eax
80101f97:	0f b6 f8             	movzbl %al,%edi
  id = ioapicread(REG_ID) >> 24;
80101f9a:	b8 00 00 00 00       	mov    $0x0,%eax
80101f9f:	e8 ad ff ff ff       	call   80101f51 <ioapicread>
80101fa4:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80101fa7:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
80101fae:	39 c2                	cmp    %eax,%edx
80101fb0:	75 2f                	jne    80101fe1 <ioapicinit+0x6e>
{
80101fb2:	bb 00 00 00 00       	mov    $0x0,%ebx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80101fb7:	39 fb                	cmp    %edi,%ebx
80101fb9:	7f 38                	jg     80101ff3 <ioapicinit+0x80>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80101fbb:	8d 53 20             	lea    0x20(%ebx),%edx
80101fbe:	81 ca 00 00 01 00    	or     $0x10000,%edx
80101fc4:	8d 74 1b 10          	lea    0x10(%ebx,%ebx,1),%esi
80101fc8:	89 f0                	mov    %esi,%eax
80101fca:	e8 93 ff ff ff       	call   80101f62 <ioapicwrite>
    ioapicwrite(REG_TABLE+2*i+1, 0);
80101fcf:	8d 46 01             	lea    0x1(%esi),%eax
80101fd2:	ba 00 00 00 00       	mov    $0x0,%edx
80101fd7:	e8 86 ff ff ff       	call   80101f62 <ioapicwrite>
  for(i = 0; i <= maxintr; i++){
80101fdc:	83 c3 01             	add    $0x1,%ebx
80101fdf:	eb d6                	jmp    80101fb7 <ioapicinit+0x44>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80101fe1:	83 ec 0c             	sub    $0xc,%esp
80101fe4:	68 d4 69 10 80       	push   $0x801069d4
80101fe9:	e8 3b e6 ff ff       	call   80100629 <cprintf>
80101fee:	83 c4 10             	add    $0x10,%esp
80101ff1:	eb bf                	jmp    80101fb2 <ioapicinit+0x3f>
  }
}
80101ff3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ff6:	5b                   	pop    %ebx
80101ff7:	5e                   	pop    %esi
80101ff8:	5f                   	pop    %edi
80101ff9:	5d                   	pop    %ebp
80101ffa:	c3                   	ret    

80101ffb <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80101ffb:	f3 0f 1e fb          	endbr32 
80101fff:	55                   	push   %ebp
80102000:	89 e5                	mov    %esp,%ebp
80102002:	53                   	push   %ebx
80102003:	83 ec 04             	sub    $0x4,%esp
80102006:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102009:	8d 50 20             	lea    0x20(%eax),%edx
8010200c:	8d 5c 00 10          	lea    0x10(%eax,%eax,1),%ebx
80102010:	89 d8                	mov    %ebx,%eax
80102012:	e8 4b ff ff ff       	call   80101f62 <ioapicwrite>
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102017:	8b 55 0c             	mov    0xc(%ebp),%edx
8010201a:	c1 e2 18             	shl    $0x18,%edx
8010201d:	8d 43 01             	lea    0x1(%ebx),%eax
80102020:	e8 3d ff ff ff       	call   80101f62 <ioapicwrite>
}
80102025:	83 c4 04             	add    $0x4,%esp
80102028:	5b                   	pop    %ebx
80102029:	5d                   	pop    %ebp
8010202a:	c3                   	ret    

8010202b <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
8010202b:	f3 0f 1e fb          	endbr32 
8010202f:	55                   	push   %ebp
80102030:	89 e5                	mov    %esp,%ebp
80102032:	53                   	push   %ebx
80102033:	83 ec 04             	sub    $0x4,%esp
80102036:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102039:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
8010203f:	75 61                	jne    801020a2 <kfree+0x77>
80102041:	81 fb a8 54 11 80    	cmp    $0x801154a8,%ebx
80102047:	72 59                	jb     801020a2 <kfree+0x77>

// Convert kernel virtual address to physical address
static inline uint V2P(void *a) {
    // define panic() here because memlayout.h is included before defs.h
    extern void panic(char*) __attribute__((noreturn));
    if (a < (void*) KERNBASE)
80102049:	81 fb ff ff ff 7f    	cmp    $0x7fffffff,%ebx
8010204f:	76 44                	jbe    80102095 <kfree+0x6a>
        panic("V2P on address < KERNBASE "
              "(not a kernel virtual address; consider walking page "
              "table to determine physical address of a user virtual address)");
    return (uint)a - KERNBASE;
80102051:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102057:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
8010205c:	77 44                	ja     801020a2 <kfree+0x77>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
8010205e:	83 ec 04             	sub    $0x4,%esp
80102061:	68 00 10 00 00       	push   $0x1000
80102066:	6a 01                	push   $0x1
80102068:	53                   	push   %ebx
80102069:	e8 6a 1d 00 00       	call   80103dd8 <memset>

  if(kmem.use_lock)
8010206e:	83 c4 10             	add    $0x10,%esp
80102071:	83 3d 74 26 11 80 00 	cmpl   $0x0,0x80112674
80102078:	75 35                	jne    801020af <kfree+0x84>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
8010207a:	a1 78 26 11 80       	mov    0x80112678,%eax
8010207f:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
80102081:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
80102087:	83 3d 74 26 11 80 00 	cmpl   $0x0,0x80112674
8010208e:	75 31                	jne    801020c1 <kfree+0x96>
    release(&kmem.lock);
}
80102090:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102093:	c9                   	leave  
80102094:	c3                   	ret    
        panic("V2P on address < KERNBASE "
80102095:	83 ec 0c             	sub    $0xc,%esp
80102098:	68 08 6a 10 80       	push   $0x80106a08
8010209d:	e8 ba e2 ff ff       	call   8010035c <panic>
    panic("kfree");
801020a2:	83 ec 0c             	sub    $0xc,%esp
801020a5:	68 96 6a 10 80       	push   $0x80106a96
801020aa:	e8 ad e2 ff ff       	call   8010035c <panic>
    acquire(&kmem.lock);
801020af:	83 ec 0c             	sub    $0xc,%esp
801020b2:	68 40 26 11 80       	push   $0x80112640
801020b7:	e8 68 1c 00 00       	call   80103d24 <acquire>
801020bc:	83 c4 10             	add    $0x10,%esp
801020bf:	eb b9                	jmp    8010207a <kfree+0x4f>
    release(&kmem.lock);
801020c1:	83 ec 0c             	sub    $0xc,%esp
801020c4:	68 40 26 11 80       	push   $0x80112640
801020c9:	e8 bf 1c 00 00       	call   80103d8d <release>
801020ce:	83 c4 10             	add    $0x10,%esp
}
801020d1:	eb bd                	jmp    80102090 <kfree+0x65>

801020d3 <freerange>:
{
801020d3:	f3 0f 1e fb          	endbr32 
801020d7:	55                   	push   %ebp
801020d8:	89 e5                	mov    %esp,%ebp
801020da:	56                   	push   %esi
801020db:	53                   	push   %ebx
801020dc:	8b 45 08             	mov    0x8(%ebp),%eax
801020df:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if (vend < vstart) panic("freerange");
801020e2:	39 c3                	cmp    %eax,%ebx
801020e4:	72 0c                	jb     801020f2 <freerange+0x1f>
  p = (char*)PGROUNDUP((uint)vstart);
801020e6:	05 ff 0f 00 00       	add    $0xfff,%eax
801020eb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801020f0:	eb 1b                	jmp    8010210d <freerange+0x3a>
  if (vend < vstart) panic("freerange");
801020f2:	83 ec 0c             	sub    $0xc,%esp
801020f5:	68 9c 6a 10 80       	push   $0x80106a9c
801020fa:	e8 5d e2 ff ff       	call   8010035c <panic>
    kfree(p);
801020ff:	83 ec 0c             	sub    $0xc,%esp
80102102:	50                   	push   %eax
80102103:	e8 23 ff ff ff       	call   8010202b <kfree>
80102108:	83 c4 10             	add    $0x10,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010210b:	89 f0                	mov    %esi,%eax
8010210d:	8d b0 00 10 00 00    	lea    0x1000(%eax),%esi
80102113:	39 de                	cmp    %ebx,%esi
80102115:	76 e8                	jbe    801020ff <freerange+0x2c>
}
80102117:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010211a:	5b                   	pop    %ebx
8010211b:	5e                   	pop    %esi
8010211c:	5d                   	pop    %ebp
8010211d:	c3                   	ret    

8010211e <kinit1>:
{
8010211e:	f3 0f 1e fb          	endbr32 
80102122:	55                   	push   %ebp
80102123:	89 e5                	mov    %esp,%ebp
80102125:	83 ec 10             	sub    $0x10,%esp
  initlock(&kmem.lock, "kmem");
80102128:	68 a6 6a 10 80       	push   $0x80106aa6
8010212d:	68 40 26 11 80       	push   $0x80112640
80102132:	e8 9d 1a 00 00       	call   80103bd4 <initlock>
  kmem.use_lock = 0;
80102137:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
8010213e:	00 00 00 
  freerange(vstart, vend);
80102141:	83 c4 08             	add    $0x8,%esp
80102144:	ff 75 0c             	pushl  0xc(%ebp)
80102147:	ff 75 08             	pushl  0x8(%ebp)
8010214a:	e8 84 ff ff ff       	call   801020d3 <freerange>
}
8010214f:	83 c4 10             	add    $0x10,%esp
80102152:	c9                   	leave  
80102153:	c3                   	ret    

80102154 <kinit2>:
{
80102154:	f3 0f 1e fb          	endbr32 
80102158:	55                   	push   %ebp
80102159:	89 e5                	mov    %esp,%ebp
8010215b:	83 ec 10             	sub    $0x10,%esp
  freerange(vstart, vend);
8010215e:	ff 75 0c             	pushl  0xc(%ebp)
80102161:	ff 75 08             	pushl  0x8(%ebp)
80102164:	e8 6a ff ff ff       	call   801020d3 <freerange>
  kmem.use_lock = 1;
80102169:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
80102170:	00 00 00 
}
80102173:	83 c4 10             	add    $0x10,%esp
80102176:	c9                   	leave  
80102177:	c3                   	ret    

80102178 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102178:	f3 0f 1e fb          	endbr32 
8010217c:	55                   	push   %ebp
8010217d:	89 e5                	mov    %esp,%ebp
8010217f:	53                   	push   %ebx
80102180:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102183:	83 3d 74 26 11 80 00 	cmpl   $0x0,0x80112674
8010218a:	75 21                	jne    801021ad <kalloc+0x35>
    acquire(&kmem.lock);
  r = kmem.freelist;
8010218c:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
80102192:	85 db                	test   %ebx,%ebx
80102194:	74 07                	je     8010219d <kalloc+0x25>
    kmem.freelist = r->next;
80102196:	8b 03                	mov    (%ebx),%eax
80102198:	a3 78 26 11 80       	mov    %eax,0x80112678
  if(kmem.use_lock)
8010219d:	83 3d 74 26 11 80 00 	cmpl   $0x0,0x80112674
801021a4:	75 19                	jne    801021bf <kalloc+0x47>
    release(&kmem.lock);
  return (char*)r;
}
801021a6:	89 d8                	mov    %ebx,%eax
801021a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801021ab:	c9                   	leave  
801021ac:	c3                   	ret    
    acquire(&kmem.lock);
801021ad:	83 ec 0c             	sub    $0xc,%esp
801021b0:	68 40 26 11 80       	push   $0x80112640
801021b5:	e8 6a 1b 00 00       	call   80103d24 <acquire>
801021ba:	83 c4 10             	add    $0x10,%esp
801021bd:	eb cd                	jmp    8010218c <kalloc+0x14>
    release(&kmem.lock);
801021bf:	83 ec 0c             	sub    $0xc,%esp
801021c2:	68 40 26 11 80       	push   $0x80112640
801021c7:	e8 c1 1b 00 00       	call   80103d8d <release>
801021cc:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
801021cf:	eb d5                	jmp    801021a6 <kalloc+0x2e>

801021d1 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
801021d1:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021d5:	ba 64 00 00 00       	mov    $0x64,%edx
801021da:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801021db:	a8 01                	test   $0x1,%al
801021dd:	0f 84 ad 00 00 00    	je     80102290 <kbdgetc+0xbf>
801021e3:	ba 60 00 00 00       	mov    $0x60,%edx
801021e8:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
801021e9:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
801021ec:	3c e0                	cmp    $0xe0,%al
801021ee:	74 5b                	je     8010224b <kbdgetc+0x7a>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801021f0:	84 c0                	test   %al,%al
801021f2:	78 64                	js     80102258 <kbdgetc+0x87>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801021f4:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx
801021fa:	f6 c1 40             	test   $0x40,%cl
801021fd:	74 0f                	je     8010220e <kbdgetc+0x3d>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801021ff:	83 c8 80             	or     $0xffffff80,%eax
80102202:	0f b6 d0             	movzbl %al,%edx
    shift &= ~E0ESC;
80102205:	83 e1 bf             	and    $0xffffffbf,%ecx
80102208:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  }

  shift |= shiftcode[data];
8010220e:	0f b6 8a e0 6b 10 80 	movzbl -0x7fef9420(%edx),%ecx
80102215:	0b 0d b4 a5 10 80    	or     0x8010a5b4,%ecx
  shift ^= togglecode[data];
8010221b:	0f b6 82 e0 6a 10 80 	movzbl -0x7fef9520(%edx),%eax
80102222:	31 c1                	xor    %eax,%ecx
80102224:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
8010222a:	89 c8                	mov    %ecx,%eax
8010222c:	83 e0 03             	and    $0x3,%eax
8010222f:	8b 04 85 c0 6a 10 80 	mov    -0x7fef9540(,%eax,4),%eax
80102236:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010223a:	f6 c1 08             	test   $0x8,%cl
8010223d:	74 56                	je     80102295 <kbdgetc+0xc4>
    if('a' <= c && c <= 'z')
8010223f:	8d 50 9f             	lea    -0x61(%eax),%edx
80102242:	83 fa 19             	cmp    $0x19,%edx
80102245:	77 3d                	ja     80102284 <kbdgetc+0xb3>
      c += 'A' - 'a';
80102247:	83 e8 20             	sub    $0x20,%eax
8010224a:	c3                   	ret    
    shift |= E0ESC;
8010224b:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
    return 0;
80102252:	b8 00 00 00 00       	mov    $0x0,%eax
80102257:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80102258:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx
8010225e:	f6 c1 40             	test   $0x40,%cl
80102261:	75 05                	jne    80102268 <kbdgetc+0x97>
80102263:	89 c2                	mov    %eax,%edx
80102265:	83 e2 7f             	and    $0x7f,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102268:	0f b6 82 e0 6b 10 80 	movzbl -0x7fef9420(%edx),%eax
8010226f:	83 c8 40             	or     $0x40,%eax
80102272:	0f b6 c0             	movzbl %al,%eax
80102275:	f7 d0                	not    %eax
80102277:	21 c8                	and    %ecx,%eax
80102279:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
    return 0;
8010227e:	b8 00 00 00 00       	mov    $0x0,%eax
80102283:	c3                   	ret    
    else if('A' <= c && c <= 'Z')
80102284:	8d 50 bf             	lea    -0x41(%eax),%edx
80102287:	83 fa 19             	cmp    $0x19,%edx
8010228a:	77 09                	ja     80102295 <kbdgetc+0xc4>
      c += 'a' - 'A';
8010228c:	83 c0 20             	add    $0x20,%eax
  }
  return c;
8010228f:	c3                   	ret    
    return -1;
80102290:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102295:	c3                   	ret    

80102296 <kbdintr>:

void
kbdintr(void)
{
80102296:	f3 0f 1e fb          	endbr32 
8010229a:	55                   	push   %ebp
8010229b:	89 e5                	mov    %esp,%ebp
8010229d:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801022a0:	68 d1 21 10 80       	push   $0x801021d1
801022a5:	e8 af e4 ff ff       	call   80100759 <consoleintr>
}
801022aa:	83 c4 10             	add    $0x10,%esp
801022ad:	c9                   	leave  
801022ae:	c3                   	ret    

801022af <shutdown>:
#include "types.h"
#include "x86.h"

void
shutdown(void)
{
801022af:	f3 0f 1e fb          	endbr32 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022b3:	b8 00 00 00 00       	mov    $0x0,%eax
801022b8:	ba 01 05 00 00       	mov    $0x501,%edx
801022bd:	ee                   	out    %al,(%dx)
  /*
     This only works in QEMU and assumes QEMU was run 
     with -device isa-debug-exit
   */
  outb(0x501, 0x0);
}
801022be:	c3                   	ret    

801022bf <lapicw>:

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801022bf:	8b 0d 7c 26 11 80    	mov    0x8011267c,%ecx
801022c5:	8d 04 81             	lea    (%ecx,%eax,4),%eax
801022c8:	89 10                	mov    %edx,(%eax)
  lapic[ID];  // wait for write to finish, by reading
801022ca:	a1 7c 26 11 80       	mov    0x8011267c,%eax
801022cf:	8b 40 20             	mov    0x20(%eax),%eax
}
801022d2:	c3                   	ret    

801022d3 <cmos_read>:
801022d3:	ba 70 00 00 00       	mov    $0x70,%edx
801022d8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022d9:	ba 71 00 00 00       	mov    $0x71,%edx
801022de:	ec                   	in     (%dx),%al
cmos_read(uint reg)
{
  outb(CMOS_PORT,  reg);
  microdelay(200);

  return inb(CMOS_RETURN);
801022df:	0f b6 c0             	movzbl %al,%eax
}
801022e2:	c3                   	ret    

801022e3 <fill_rtcdate>:

static void
fill_rtcdate(struct rtcdate *r)
{
801022e3:	55                   	push   %ebp
801022e4:	89 e5                	mov    %esp,%ebp
801022e6:	53                   	push   %ebx
801022e7:	83 ec 04             	sub    $0x4,%esp
801022ea:	89 c3                	mov    %eax,%ebx
  r->second = cmos_read(SECS);
801022ec:	b8 00 00 00 00       	mov    $0x0,%eax
801022f1:	e8 dd ff ff ff       	call   801022d3 <cmos_read>
801022f6:	89 03                	mov    %eax,(%ebx)
  r->minute = cmos_read(MINS);
801022f8:	b8 02 00 00 00       	mov    $0x2,%eax
801022fd:	e8 d1 ff ff ff       	call   801022d3 <cmos_read>
80102302:	89 43 04             	mov    %eax,0x4(%ebx)
  r->hour   = cmos_read(HOURS);
80102305:	b8 04 00 00 00       	mov    $0x4,%eax
8010230a:	e8 c4 ff ff ff       	call   801022d3 <cmos_read>
8010230f:	89 43 08             	mov    %eax,0x8(%ebx)
  r->day    = cmos_read(DAY);
80102312:	b8 07 00 00 00       	mov    $0x7,%eax
80102317:	e8 b7 ff ff ff       	call   801022d3 <cmos_read>
8010231c:	89 43 0c             	mov    %eax,0xc(%ebx)
  r->month  = cmos_read(MONTH);
8010231f:	b8 08 00 00 00       	mov    $0x8,%eax
80102324:	e8 aa ff ff ff       	call   801022d3 <cmos_read>
80102329:	89 43 10             	mov    %eax,0x10(%ebx)
  r->year   = cmos_read(YEAR);
8010232c:	b8 09 00 00 00       	mov    $0x9,%eax
80102331:	e8 9d ff ff ff       	call   801022d3 <cmos_read>
80102336:	89 43 14             	mov    %eax,0x14(%ebx)
}
80102339:	83 c4 04             	add    $0x4,%esp
8010233c:	5b                   	pop    %ebx
8010233d:	5d                   	pop    %ebp
8010233e:	c3                   	ret    

8010233f <lapicinit>:
{
8010233f:	f3 0f 1e fb          	endbr32 
  if(!lapic)
80102343:	83 3d 7c 26 11 80 00 	cmpl   $0x0,0x8011267c
8010234a:	0f 84 fe 00 00 00    	je     8010244e <lapicinit+0x10f>
{
80102350:	55                   	push   %ebp
80102351:	89 e5                	mov    %esp,%ebp
80102353:	83 ec 08             	sub    $0x8,%esp
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102356:	ba 3f 01 00 00       	mov    $0x13f,%edx
8010235b:	b8 3c 00 00 00       	mov    $0x3c,%eax
80102360:	e8 5a ff ff ff       	call   801022bf <lapicw>
  lapicw(TDCR, X1);
80102365:	ba 0b 00 00 00       	mov    $0xb,%edx
8010236a:	b8 f8 00 00 00       	mov    $0xf8,%eax
8010236f:	e8 4b ff ff ff       	call   801022bf <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102374:	ba 20 00 02 00       	mov    $0x20020,%edx
80102379:	b8 c8 00 00 00       	mov    $0xc8,%eax
8010237e:	e8 3c ff ff ff       	call   801022bf <lapicw>
  lapicw(TICR, 10000000);
80102383:	ba 80 96 98 00       	mov    $0x989680,%edx
80102388:	b8 e0 00 00 00       	mov    $0xe0,%eax
8010238d:	e8 2d ff ff ff       	call   801022bf <lapicw>
  lapicw(LINT0, MASKED);
80102392:	ba 00 00 01 00       	mov    $0x10000,%edx
80102397:	b8 d4 00 00 00       	mov    $0xd4,%eax
8010239c:	e8 1e ff ff ff       	call   801022bf <lapicw>
  lapicw(LINT1, MASKED);
801023a1:	ba 00 00 01 00       	mov    $0x10000,%edx
801023a6:	b8 d8 00 00 00       	mov    $0xd8,%eax
801023ab:	e8 0f ff ff ff       	call   801022bf <lapicw>
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801023b0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
801023b5:	8b 40 30             	mov    0x30(%eax),%eax
801023b8:	c1 e8 10             	shr    $0x10,%eax
801023bb:	a8 fc                	test   $0xfc,%al
801023bd:	75 7b                	jne    8010243a <lapicinit+0xfb>
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
801023bf:	ba 33 00 00 00       	mov    $0x33,%edx
801023c4:	b8 dc 00 00 00       	mov    $0xdc,%eax
801023c9:	e8 f1 fe ff ff       	call   801022bf <lapicw>
  lapicw(ESR, 0);
801023ce:	ba 00 00 00 00       	mov    $0x0,%edx
801023d3:	b8 a0 00 00 00       	mov    $0xa0,%eax
801023d8:	e8 e2 fe ff ff       	call   801022bf <lapicw>
  lapicw(ESR, 0);
801023dd:	ba 00 00 00 00       	mov    $0x0,%edx
801023e2:	b8 a0 00 00 00       	mov    $0xa0,%eax
801023e7:	e8 d3 fe ff ff       	call   801022bf <lapicw>
  lapicw(EOI, 0);
801023ec:	ba 00 00 00 00       	mov    $0x0,%edx
801023f1:	b8 2c 00 00 00       	mov    $0x2c,%eax
801023f6:	e8 c4 fe ff ff       	call   801022bf <lapicw>
  lapicw(ICRHI, 0);
801023fb:	ba 00 00 00 00       	mov    $0x0,%edx
80102400:	b8 c4 00 00 00       	mov    $0xc4,%eax
80102405:	e8 b5 fe ff ff       	call   801022bf <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
8010240a:	ba 00 85 08 00       	mov    $0x88500,%edx
8010240f:	b8 c0 00 00 00       	mov    $0xc0,%eax
80102414:	e8 a6 fe ff ff       	call   801022bf <lapicw>
  while(lapic[ICRLO] & DELIVS)
80102419:	a1 7c 26 11 80       	mov    0x8011267c,%eax
8010241e:	8b 80 00 03 00 00    	mov    0x300(%eax),%eax
80102424:	f6 c4 10             	test   $0x10,%ah
80102427:	75 f0                	jne    80102419 <lapicinit+0xda>
  lapicw(TPR, 0);
80102429:	ba 00 00 00 00       	mov    $0x0,%edx
8010242e:	b8 20 00 00 00       	mov    $0x20,%eax
80102433:	e8 87 fe ff ff       	call   801022bf <lapicw>
}
80102438:	c9                   	leave  
80102439:	c3                   	ret    
    lapicw(PCINT, MASKED);
8010243a:	ba 00 00 01 00       	mov    $0x10000,%edx
8010243f:	b8 d0 00 00 00       	mov    $0xd0,%eax
80102444:	e8 76 fe ff ff       	call   801022bf <lapicw>
80102449:	e9 71 ff ff ff       	jmp    801023bf <lapicinit+0x80>
8010244e:	c3                   	ret    

8010244f <lapicid>:
{
8010244f:	f3 0f 1e fb          	endbr32 
  if (!lapic)
80102453:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102458:	85 c0                	test   %eax,%eax
8010245a:	74 07                	je     80102463 <lapicid+0x14>
  return lapic[ID] >> 24;
8010245c:	8b 40 20             	mov    0x20(%eax),%eax
8010245f:	c1 e8 18             	shr    $0x18,%eax
80102462:	c3                   	ret    
    return 0;
80102463:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102468:	c3                   	ret    

80102469 <lapiceoi>:
{
80102469:	f3 0f 1e fb          	endbr32 
  if(lapic)
8010246d:	83 3d 7c 26 11 80 00 	cmpl   $0x0,0x8011267c
80102474:	74 17                	je     8010248d <lapiceoi+0x24>
{
80102476:	55                   	push   %ebp
80102477:	89 e5                	mov    %esp,%ebp
80102479:	83 ec 08             	sub    $0x8,%esp
    lapicw(EOI, 0);
8010247c:	ba 00 00 00 00       	mov    $0x0,%edx
80102481:	b8 2c 00 00 00       	mov    $0x2c,%eax
80102486:	e8 34 fe ff ff       	call   801022bf <lapicw>
}
8010248b:	c9                   	leave  
8010248c:	c3                   	ret    
8010248d:	c3                   	ret    

8010248e <microdelay>:
{
8010248e:	f3 0f 1e fb          	endbr32 
}
80102492:	c3                   	ret    

80102493 <lapicstartap>:
{
80102493:	f3 0f 1e fb          	endbr32 
80102497:	55                   	push   %ebp
80102498:	89 e5                	mov    %esp,%ebp
8010249a:	57                   	push   %edi
8010249b:	56                   	push   %esi
8010249c:	53                   	push   %ebx
8010249d:	83 ec 0c             	sub    $0xc,%esp
801024a0:	8b 75 08             	mov    0x8(%ebp),%esi
801024a3:	8b 7d 0c             	mov    0xc(%ebp),%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801024a6:	b8 0f 00 00 00       	mov    $0xf,%eax
801024ab:	ba 70 00 00 00       	mov    $0x70,%edx
801024b0:	ee                   	out    %al,(%dx)
801024b1:	b8 0a 00 00 00       	mov    $0xa,%eax
801024b6:	ba 71 00 00 00       	mov    $0x71,%edx
801024bb:	ee                   	out    %al,(%dx)
  wrv[0] = 0;
801024bc:	66 c7 05 67 04 00 80 	movw   $0x0,0x80000467
801024c3:	00 00 
  wrv[1] = addr >> 4;
801024c5:	89 f8                	mov    %edi,%eax
801024c7:	c1 e8 04             	shr    $0x4,%eax
801024ca:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapicw(ICRHI, apicid<<24);
801024d0:	c1 e6 18             	shl    $0x18,%esi
801024d3:	89 f2                	mov    %esi,%edx
801024d5:	b8 c4 00 00 00       	mov    $0xc4,%eax
801024da:	e8 e0 fd ff ff       	call   801022bf <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
801024df:	ba 00 c5 00 00       	mov    $0xc500,%edx
801024e4:	b8 c0 00 00 00       	mov    $0xc0,%eax
801024e9:	e8 d1 fd ff ff       	call   801022bf <lapicw>
  lapicw(ICRLO, INIT | LEVEL);
801024ee:	ba 00 85 00 00       	mov    $0x8500,%edx
801024f3:	b8 c0 00 00 00       	mov    $0xc0,%eax
801024f8:	e8 c2 fd ff ff       	call   801022bf <lapicw>
  for(i = 0; i < 2; i++){
801024fd:	bb 00 00 00 00       	mov    $0x0,%ebx
80102502:	eb 21                	jmp    80102525 <lapicstartap+0x92>
    lapicw(ICRHI, apicid<<24);
80102504:	89 f2                	mov    %esi,%edx
80102506:	b8 c4 00 00 00       	mov    $0xc4,%eax
8010250b:	e8 af fd ff ff       	call   801022bf <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
80102510:	89 fa                	mov    %edi,%edx
80102512:	c1 ea 0c             	shr    $0xc,%edx
80102515:	80 ce 06             	or     $0x6,%dh
80102518:	b8 c0 00 00 00       	mov    $0xc0,%eax
8010251d:	e8 9d fd ff ff       	call   801022bf <lapicw>
  for(i = 0; i < 2; i++){
80102522:	83 c3 01             	add    $0x1,%ebx
80102525:	83 fb 01             	cmp    $0x1,%ebx
80102528:	7e da                	jle    80102504 <lapicstartap+0x71>
}
8010252a:	83 c4 0c             	add    $0xc,%esp
8010252d:	5b                   	pop    %ebx
8010252e:	5e                   	pop    %esi
8010252f:	5f                   	pop    %edi
80102530:	5d                   	pop    %ebp
80102531:	c3                   	ret    

80102532 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102532:	f3 0f 1e fb          	endbr32 
80102536:	55                   	push   %ebp
80102537:	89 e5                	mov    %esp,%ebp
80102539:	57                   	push   %edi
8010253a:	56                   	push   %esi
8010253b:	53                   	push   %ebx
8010253c:	83 ec 3c             	sub    $0x3c,%esp
8010253f:	8b 75 08             	mov    0x8(%ebp),%esi
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
80102542:	b8 0b 00 00 00       	mov    $0xb,%eax
80102547:	e8 87 fd ff ff       	call   801022d3 <cmos_read>

  bcd = (sb & (1 << 2)) == 0;
8010254c:	83 e0 04             	and    $0x4,%eax
8010254f:	89 c7                	mov    %eax,%edi

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
80102551:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102554:	e8 8a fd ff ff       	call   801022e3 <fill_rtcdate>
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102559:	b8 0a 00 00 00       	mov    $0xa,%eax
8010255e:	e8 70 fd ff ff       	call   801022d3 <cmos_read>
80102563:	a8 80                	test   $0x80,%al
80102565:	75 ea                	jne    80102551 <cmostime+0x1f>
        continue;
    fill_rtcdate(&t2);
80102567:	8d 5d b8             	lea    -0x48(%ebp),%ebx
8010256a:	89 d8                	mov    %ebx,%eax
8010256c:	e8 72 fd ff ff       	call   801022e3 <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102571:	83 ec 04             	sub    $0x4,%esp
80102574:	6a 18                	push   $0x18
80102576:	53                   	push   %ebx
80102577:	8d 45 d0             	lea    -0x30(%ebp),%eax
8010257a:	50                   	push   %eax
8010257b:	e8 9f 18 00 00       	call   80103e1f <memcmp>
80102580:	83 c4 10             	add    $0x10,%esp
80102583:	85 c0                	test   %eax,%eax
80102585:	75 ca                	jne    80102551 <cmostime+0x1f>
      break;
  }

  // convert
  if(bcd) {
80102587:	85 ff                	test   %edi,%edi
80102589:	75 78                	jne    80102603 <cmostime+0xd1>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010258b:	8b 45 d0             	mov    -0x30(%ebp),%eax
8010258e:	89 c2                	mov    %eax,%edx
80102590:	c1 ea 04             	shr    $0x4,%edx
80102593:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102596:	83 e0 0f             	and    $0xf,%eax
80102599:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010259c:	89 45 d0             	mov    %eax,-0x30(%ebp)
    CONV(minute);
8010259f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801025a2:	89 c2                	mov    %eax,%edx
801025a4:	c1 ea 04             	shr    $0x4,%edx
801025a7:	8d 14 92             	lea    (%edx,%edx,4),%edx
801025aa:	83 e0 0f             	and    $0xf,%eax
801025ad:	8d 04 50             	lea    (%eax,%edx,2),%eax
801025b0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    CONV(hour  );
801025b3:	8b 45 d8             	mov    -0x28(%ebp),%eax
801025b6:	89 c2                	mov    %eax,%edx
801025b8:	c1 ea 04             	shr    $0x4,%edx
801025bb:	8d 14 92             	lea    (%edx,%edx,4),%edx
801025be:	83 e0 0f             	and    $0xf,%eax
801025c1:	8d 04 50             	lea    (%eax,%edx,2),%eax
801025c4:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(day   );
801025c7:	8b 45 dc             	mov    -0x24(%ebp),%eax
801025ca:	89 c2                	mov    %eax,%edx
801025cc:	c1 ea 04             	shr    $0x4,%edx
801025cf:	8d 14 92             	lea    (%edx,%edx,4),%edx
801025d2:	83 e0 0f             	and    $0xf,%eax
801025d5:	8d 04 50             	lea    (%eax,%edx,2),%eax
801025d8:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(month );
801025db:	8b 45 e0             	mov    -0x20(%ebp),%eax
801025de:	89 c2                	mov    %eax,%edx
801025e0:	c1 ea 04             	shr    $0x4,%edx
801025e3:	8d 14 92             	lea    (%edx,%edx,4),%edx
801025e6:	83 e0 0f             	and    $0xf,%eax
801025e9:	8d 04 50             	lea    (%eax,%edx,2),%eax
801025ec:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(year  );
801025ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801025f2:	89 c2                	mov    %eax,%edx
801025f4:	c1 ea 04             	shr    $0x4,%edx
801025f7:	8d 14 92             	lea    (%edx,%edx,4),%edx
801025fa:	83 e0 0f             	and    $0xf,%eax
801025fd:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102600:	89 45 e4             	mov    %eax,-0x1c(%ebp)
#undef     CONV
  }

  *r = t1;
80102603:	8b 45 d0             	mov    -0x30(%ebp),%eax
80102606:	89 06                	mov    %eax,(%esi)
80102608:	8b 45 d4             	mov    -0x2c(%ebp),%eax
8010260b:	89 46 04             	mov    %eax,0x4(%esi)
8010260e:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102611:	89 46 08             	mov    %eax,0x8(%esi)
80102614:	8b 45 dc             	mov    -0x24(%ebp),%eax
80102617:	89 46 0c             	mov    %eax,0xc(%esi)
8010261a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010261d:	89 46 10             	mov    %eax,0x10(%esi)
80102620:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102623:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102626:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
8010262d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102630:	5b                   	pop    %ebx
80102631:	5e                   	pop    %esi
80102632:	5f                   	pop    %edi
80102633:	5d                   	pop    %ebp
80102634:	c3                   	ret    

80102635 <read_head>:
}

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
80102635:	55                   	push   %ebp
80102636:	89 e5                	mov    %esp,%ebp
80102638:	53                   	push   %ebx
80102639:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
8010263c:	ff 35 b4 26 11 80    	pushl  0x801126b4
80102642:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102648:	e8 23 db ff ff       	call   80100170 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
8010264d:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102650:	89 1d c8 26 11 80    	mov    %ebx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102656:	83 c4 10             	add    $0x10,%esp
80102659:	ba 00 00 00 00       	mov    $0x0,%edx
8010265e:	39 d3                	cmp    %edx,%ebx
80102660:	7e 10                	jle    80102672 <read_head+0x3d>
    log.lh.block[i] = lh->block[i];
80102662:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102666:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010266d:	83 c2 01             	add    $0x1,%edx
80102670:	eb ec                	jmp    8010265e <read_head+0x29>
  }
  brelse(buf);
80102672:	83 ec 0c             	sub    $0xc,%esp
80102675:	50                   	push   %eax
80102676:	e8 66 db ff ff       	call   801001e1 <brelse>
}
8010267b:	83 c4 10             	add    $0x10,%esp
8010267e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102681:	c9                   	leave  
80102682:	c3                   	ret    

80102683 <install_trans>:
{
80102683:	55                   	push   %ebp
80102684:	89 e5                	mov    %esp,%ebp
80102686:	57                   	push   %edi
80102687:	56                   	push   %esi
80102688:	53                   	push   %ebx
80102689:	83 ec 0c             	sub    $0xc,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
8010268c:	be 00 00 00 00       	mov    $0x0,%esi
80102691:	39 35 c8 26 11 80    	cmp    %esi,0x801126c8
80102697:	7e 68                	jle    80102701 <install_trans+0x7e>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102699:	89 f0                	mov    %esi,%eax
8010269b:	03 05 b4 26 11 80    	add    0x801126b4,%eax
801026a1:	83 c0 01             	add    $0x1,%eax
801026a4:	83 ec 08             	sub    $0x8,%esp
801026a7:	50                   	push   %eax
801026a8:	ff 35 c4 26 11 80    	pushl  0x801126c4
801026ae:	e8 bd da ff ff       	call   80100170 <bread>
801026b3:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801026b5:	83 c4 08             	add    $0x8,%esp
801026b8:	ff 34 b5 cc 26 11 80 	pushl  -0x7feed934(,%esi,4)
801026bf:	ff 35 c4 26 11 80    	pushl  0x801126c4
801026c5:	e8 a6 da ff ff       	call   80100170 <bread>
801026ca:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801026cc:	8d 57 5c             	lea    0x5c(%edi),%edx
801026cf:	8d 40 5c             	lea    0x5c(%eax),%eax
801026d2:	83 c4 0c             	add    $0xc,%esp
801026d5:	68 00 02 00 00       	push   $0x200
801026da:	52                   	push   %edx
801026db:	50                   	push   %eax
801026dc:	e8 77 17 00 00       	call   80103e58 <memmove>
    bwrite(dbuf);  // write dst to disk
801026e1:	89 1c 24             	mov    %ebx,(%esp)
801026e4:	e8 b9 da ff ff       	call   801001a2 <bwrite>
    brelse(lbuf);
801026e9:	89 3c 24             	mov    %edi,(%esp)
801026ec:	e8 f0 da ff ff       	call   801001e1 <brelse>
    brelse(dbuf);
801026f1:	89 1c 24             	mov    %ebx,(%esp)
801026f4:	e8 e8 da ff ff       	call   801001e1 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801026f9:	83 c6 01             	add    $0x1,%esi
801026fc:	83 c4 10             	add    $0x10,%esp
801026ff:	eb 90                	jmp    80102691 <install_trans+0xe>
}
80102701:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102704:	5b                   	pop    %ebx
80102705:	5e                   	pop    %esi
80102706:	5f                   	pop    %edi
80102707:	5d                   	pop    %ebp
80102708:	c3                   	ret    

80102709 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102709:	55                   	push   %ebp
8010270a:	89 e5                	mov    %esp,%ebp
8010270c:	53                   	push   %ebx
8010270d:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102710:	ff 35 b4 26 11 80    	pushl  0x801126b4
80102716:	ff 35 c4 26 11 80    	pushl  0x801126c4
8010271c:	e8 4f da ff ff       	call   80100170 <bread>
80102721:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102723:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102729:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
8010272c:	83 c4 10             	add    $0x10,%esp
8010272f:	b8 00 00 00 00       	mov    $0x0,%eax
80102734:	39 c1                	cmp    %eax,%ecx
80102736:	7e 10                	jle    80102748 <write_head+0x3f>
    hb->block[i] = log.lh.block[i];
80102738:	8b 14 85 cc 26 11 80 	mov    -0x7feed934(,%eax,4),%edx
8010273f:	89 54 83 60          	mov    %edx,0x60(%ebx,%eax,4)
  for (i = 0; i < log.lh.n; i++) {
80102743:	83 c0 01             	add    $0x1,%eax
80102746:	eb ec                	jmp    80102734 <write_head+0x2b>
  }
  bwrite(buf);
80102748:	83 ec 0c             	sub    $0xc,%esp
8010274b:	53                   	push   %ebx
8010274c:	e8 51 da ff ff       	call   801001a2 <bwrite>
  brelse(buf);
80102751:	89 1c 24             	mov    %ebx,(%esp)
80102754:	e8 88 da ff ff       	call   801001e1 <brelse>
}
80102759:	83 c4 10             	add    $0x10,%esp
8010275c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010275f:	c9                   	leave  
80102760:	c3                   	ret    

80102761 <recover_from_log>:

static void
recover_from_log(void)
{
80102761:	55                   	push   %ebp
80102762:	89 e5                	mov    %esp,%ebp
80102764:	83 ec 08             	sub    $0x8,%esp
  read_head();
80102767:	e8 c9 fe ff ff       	call   80102635 <read_head>
  install_trans(); // if committed, copy from log to disk
8010276c:	e8 12 ff ff ff       	call   80102683 <install_trans>
  log.lh.n = 0;
80102771:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102778:	00 00 00 
  write_head(); // clear the log
8010277b:	e8 89 ff ff ff       	call   80102709 <write_head>
}
80102780:	c9                   	leave  
80102781:	c3                   	ret    

80102782 <write_log>:
}

// Copy modified blocks from cache to log.
static void
write_log(void)
{
80102782:	55                   	push   %ebp
80102783:	89 e5                	mov    %esp,%ebp
80102785:	57                   	push   %edi
80102786:	56                   	push   %esi
80102787:	53                   	push   %ebx
80102788:	83 ec 0c             	sub    $0xc,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010278b:	be 00 00 00 00       	mov    $0x0,%esi
80102790:	39 35 c8 26 11 80    	cmp    %esi,0x801126c8
80102796:	7e 68                	jle    80102800 <write_log+0x7e>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102798:	89 f0                	mov    %esi,%eax
8010279a:	03 05 b4 26 11 80    	add    0x801126b4,%eax
801027a0:	83 c0 01             	add    $0x1,%eax
801027a3:	83 ec 08             	sub    $0x8,%esp
801027a6:	50                   	push   %eax
801027a7:	ff 35 c4 26 11 80    	pushl  0x801126c4
801027ad:	e8 be d9 ff ff       	call   80100170 <bread>
801027b2:	89 c3                	mov    %eax,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801027b4:	83 c4 08             	add    $0x8,%esp
801027b7:	ff 34 b5 cc 26 11 80 	pushl  -0x7feed934(,%esi,4)
801027be:	ff 35 c4 26 11 80    	pushl  0x801126c4
801027c4:	e8 a7 d9 ff ff       	call   80100170 <bread>
801027c9:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
801027cb:	8d 50 5c             	lea    0x5c(%eax),%edx
801027ce:	8d 43 5c             	lea    0x5c(%ebx),%eax
801027d1:	83 c4 0c             	add    $0xc,%esp
801027d4:	68 00 02 00 00       	push   $0x200
801027d9:	52                   	push   %edx
801027da:	50                   	push   %eax
801027db:	e8 78 16 00 00       	call   80103e58 <memmove>
    bwrite(to);  // write the log
801027e0:	89 1c 24             	mov    %ebx,(%esp)
801027e3:	e8 ba d9 ff ff       	call   801001a2 <bwrite>
    brelse(from);
801027e8:	89 3c 24             	mov    %edi,(%esp)
801027eb:	e8 f1 d9 ff ff       	call   801001e1 <brelse>
    brelse(to);
801027f0:	89 1c 24             	mov    %ebx,(%esp)
801027f3:	e8 e9 d9 ff ff       	call   801001e1 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801027f8:	83 c6 01             	add    $0x1,%esi
801027fb:	83 c4 10             	add    $0x10,%esp
801027fe:	eb 90                	jmp    80102790 <write_log+0xe>
  }
}
80102800:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102803:	5b                   	pop    %ebx
80102804:	5e                   	pop    %esi
80102805:	5f                   	pop    %edi
80102806:	5d                   	pop    %ebp
80102807:	c3                   	ret    

80102808 <commit>:

static void
commit()
{
  if (log.lh.n > 0) {
80102808:	83 3d c8 26 11 80 00 	cmpl   $0x0,0x801126c8
8010280f:	7f 01                	jg     80102812 <commit+0xa>
80102811:	c3                   	ret    
{
80102812:	55                   	push   %ebp
80102813:	89 e5                	mov    %esp,%ebp
80102815:	83 ec 08             	sub    $0x8,%esp
    write_log();     // Write modified blocks from cache to log
80102818:	e8 65 ff ff ff       	call   80102782 <write_log>
    write_head();    // Write header to disk -- the real commit
8010281d:	e8 e7 fe ff ff       	call   80102709 <write_head>
    install_trans(); // Now install writes to home locations
80102822:	e8 5c fe ff ff       	call   80102683 <install_trans>
    log.lh.n = 0;
80102827:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
8010282e:	00 00 00 
    write_head();    // Erase the transaction from the log
80102831:	e8 d3 fe ff ff       	call   80102709 <write_head>
  }
}
80102836:	c9                   	leave  
80102837:	c3                   	ret    

80102838 <initlog>:
{
80102838:	f3 0f 1e fb          	endbr32 
8010283c:	55                   	push   %ebp
8010283d:	89 e5                	mov    %esp,%ebp
8010283f:	53                   	push   %ebx
80102840:	83 ec 2c             	sub    $0x2c,%esp
80102843:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102846:	68 e0 6c 10 80       	push   $0x80106ce0
8010284b:	68 80 26 11 80       	push   $0x80112680
80102850:	e8 7f 13 00 00       	call   80103bd4 <initlock>
  readsb(dev, &sb);
80102855:	83 c4 08             	add    $0x8,%esp
80102858:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010285b:	50                   	push   %eax
8010285c:	53                   	push   %ebx
8010285d:	e8 8b ea ff ff       	call   801012ed <readsb>
  log.start = sb.logstart;
80102862:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102865:	a3 b4 26 11 80       	mov    %eax,0x801126b4
  log.size = sb.nlog;
8010286a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010286d:	a3 b8 26 11 80       	mov    %eax,0x801126b8
  log.dev = dev;
80102872:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
  recover_from_log();
80102878:	e8 e4 fe ff ff       	call   80102761 <recover_from_log>
}
8010287d:	83 c4 10             	add    $0x10,%esp
80102880:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102883:	c9                   	leave  
80102884:	c3                   	ret    

80102885 <begin_op>:
{
80102885:	f3 0f 1e fb          	endbr32 
80102889:	55                   	push   %ebp
8010288a:	89 e5                	mov    %esp,%ebp
8010288c:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
8010288f:	68 80 26 11 80       	push   $0x80112680
80102894:	e8 8b 14 00 00       	call   80103d24 <acquire>
80102899:	83 c4 10             	add    $0x10,%esp
8010289c:	eb 15                	jmp    801028b3 <begin_op+0x2e>
      sleep(&log, &log.lock);
8010289e:	83 ec 08             	sub    $0x8,%esp
801028a1:	68 80 26 11 80       	push   $0x80112680
801028a6:	68 80 26 11 80       	push   $0x80112680
801028ab:	e8 41 0f 00 00       	call   801037f1 <sleep>
801028b0:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
801028b3:	83 3d c0 26 11 80 00 	cmpl   $0x0,0x801126c0
801028ba:	75 e2                	jne    8010289e <begin_op+0x19>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801028bc:	a1 bc 26 11 80       	mov    0x801126bc,%eax
801028c1:	83 c0 01             	add    $0x1,%eax
801028c4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
801028c7:	8d 14 09             	lea    (%ecx,%ecx,1),%edx
801028ca:	03 15 c8 26 11 80    	add    0x801126c8,%edx
801028d0:	83 fa 1e             	cmp    $0x1e,%edx
801028d3:	7e 17                	jle    801028ec <begin_op+0x67>
      sleep(&log, &log.lock);
801028d5:	83 ec 08             	sub    $0x8,%esp
801028d8:	68 80 26 11 80       	push   $0x80112680
801028dd:	68 80 26 11 80       	push   $0x80112680
801028e2:	e8 0a 0f 00 00       	call   801037f1 <sleep>
801028e7:	83 c4 10             	add    $0x10,%esp
801028ea:	eb c7                	jmp    801028b3 <begin_op+0x2e>
      log.outstanding += 1;
801028ec:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
801028f1:	83 ec 0c             	sub    $0xc,%esp
801028f4:	68 80 26 11 80       	push   $0x80112680
801028f9:	e8 8f 14 00 00       	call   80103d8d <release>
}
801028fe:	83 c4 10             	add    $0x10,%esp
80102901:	c9                   	leave  
80102902:	c3                   	ret    

80102903 <end_op>:
{
80102903:	f3 0f 1e fb          	endbr32 
80102907:	55                   	push   %ebp
80102908:	89 e5                	mov    %esp,%ebp
8010290a:	53                   	push   %ebx
8010290b:	83 ec 10             	sub    $0x10,%esp
  acquire(&log.lock);
8010290e:	68 80 26 11 80       	push   $0x80112680
80102913:	e8 0c 14 00 00       	call   80103d24 <acquire>
  log.outstanding -= 1;
80102918:	a1 bc 26 11 80       	mov    0x801126bc,%eax
8010291d:	83 e8 01             	sub    $0x1,%eax
80102920:	a3 bc 26 11 80       	mov    %eax,0x801126bc
  if(log.committing)
80102925:	8b 1d c0 26 11 80    	mov    0x801126c0,%ebx
8010292b:	83 c4 10             	add    $0x10,%esp
8010292e:	85 db                	test   %ebx,%ebx
80102930:	75 2c                	jne    8010295e <end_op+0x5b>
  if(log.outstanding == 0){
80102932:	85 c0                	test   %eax,%eax
80102934:	75 35                	jne    8010296b <end_op+0x68>
    log.committing = 1;
80102936:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
8010293d:	00 00 00 
    do_commit = 1;
80102940:	bb 01 00 00 00       	mov    $0x1,%ebx
  release(&log.lock);
80102945:	83 ec 0c             	sub    $0xc,%esp
80102948:	68 80 26 11 80       	push   $0x80112680
8010294d:	e8 3b 14 00 00       	call   80103d8d <release>
  if(do_commit){
80102952:	83 c4 10             	add    $0x10,%esp
80102955:	85 db                	test   %ebx,%ebx
80102957:	75 24                	jne    8010297d <end_op+0x7a>
}
80102959:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010295c:	c9                   	leave  
8010295d:	c3                   	ret    
    panic("log.committing");
8010295e:	83 ec 0c             	sub    $0xc,%esp
80102961:	68 e4 6c 10 80       	push   $0x80106ce4
80102966:	e8 f1 d9 ff ff       	call   8010035c <panic>
    wakeup(&log);
8010296b:	83 ec 0c             	sub    $0xc,%esp
8010296e:	68 80 26 11 80       	push   $0x80112680
80102973:	e8 e6 0f 00 00       	call   8010395e <wakeup>
80102978:	83 c4 10             	add    $0x10,%esp
8010297b:	eb c8                	jmp    80102945 <end_op+0x42>
    commit();
8010297d:	e8 86 fe ff ff       	call   80102808 <commit>
    acquire(&log.lock);
80102982:	83 ec 0c             	sub    $0xc,%esp
80102985:	68 80 26 11 80       	push   $0x80112680
8010298a:	e8 95 13 00 00       	call   80103d24 <acquire>
    log.committing = 0;
8010298f:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102996:	00 00 00 
    wakeup(&log);
80102999:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
801029a0:	e8 b9 0f 00 00       	call   8010395e <wakeup>
    release(&log.lock);
801029a5:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
801029ac:	e8 dc 13 00 00       	call   80103d8d <release>
801029b1:	83 c4 10             	add    $0x10,%esp
}
801029b4:	eb a3                	jmp    80102959 <end_op+0x56>

801029b6 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801029b6:	f3 0f 1e fb          	endbr32 
801029ba:	55                   	push   %ebp
801029bb:	89 e5                	mov    %esp,%ebp
801029bd:	53                   	push   %ebx
801029be:	83 ec 04             	sub    $0x4,%esp
801029c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801029c4:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
801029ca:	83 fa 1d             	cmp    $0x1d,%edx
801029cd:	7f 45                	jg     80102a14 <log_write+0x5e>
801029cf:	a1 b8 26 11 80       	mov    0x801126b8,%eax
801029d4:	83 e8 01             	sub    $0x1,%eax
801029d7:	39 c2                	cmp    %eax,%edx
801029d9:	7d 39                	jge    80102a14 <log_write+0x5e>
    panic("too big a transaction");
  if (log.outstanding < 1)
801029db:	83 3d bc 26 11 80 00 	cmpl   $0x0,0x801126bc
801029e2:	7e 3d                	jle    80102a21 <log_write+0x6b>
    panic("log_write outside of trans");

  acquire(&log.lock);
801029e4:	83 ec 0c             	sub    $0xc,%esp
801029e7:	68 80 26 11 80       	push   $0x80112680
801029ec:	e8 33 13 00 00       	call   80103d24 <acquire>
  for (i = 0; i < log.lh.n; i++) {
801029f1:	83 c4 10             	add    $0x10,%esp
801029f4:	b8 00 00 00 00       	mov    $0x0,%eax
801029f9:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
801029ff:	39 c2                	cmp    %eax,%edx
80102a01:	7e 2b                	jle    80102a2e <log_write+0x78>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102a03:	8b 4b 08             	mov    0x8(%ebx),%ecx
80102a06:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
80102a0d:	74 1f                	je     80102a2e <log_write+0x78>
  for (i = 0; i < log.lh.n; i++) {
80102a0f:	83 c0 01             	add    $0x1,%eax
80102a12:	eb e5                	jmp    801029f9 <log_write+0x43>
    panic("too big a transaction");
80102a14:	83 ec 0c             	sub    $0xc,%esp
80102a17:	68 f3 6c 10 80       	push   $0x80106cf3
80102a1c:	e8 3b d9 ff ff       	call   8010035c <panic>
    panic("log_write outside of trans");
80102a21:	83 ec 0c             	sub    $0xc,%esp
80102a24:	68 09 6d 10 80       	push   $0x80106d09
80102a29:	e8 2e d9 ff ff       	call   8010035c <panic>
      break;
  }
  log.lh.block[i] = b->blockno;
80102a2e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80102a31:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
  if (i == log.lh.n)
80102a38:	39 c2                	cmp    %eax,%edx
80102a3a:	74 18                	je     80102a54 <log_write+0x9e>
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102a3c:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102a3f:	83 ec 0c             	sub    $0xc,%esp
80102a42:	68 80 26 11 80       	push   $0x80112680
80102a47:	e8 41 13 00 00       	call   80103d8d <release>
}
80102a4c:	83 c4 10             	add    $0x10,%esp
80102a4f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a52:	c9                   	leave  
80102a53:	c3                   	ret    
    log.lh.n++;
80102a54:	83 c2 01             	add    $0x1,%edx
80102a57:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
80102a5d:	eb dd                	jmp    80102a3c <log_write+0x86>

80102a5f <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80102a5f:	55                   	push   %ebp
80102a60:	89 e5                	mov    %esp,%ebp
80102a62:	53                   	push   %ebx
80102a63:	83 ec 08             	sub    $0x8,%esp

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102a66:	68 8a 00 00 00       	push   $0x8a
80102a6b:	68 8c a4 10 80       	push   $0x8010a48c
80102a70:	68 00 70 00 80       	push   $0x80007000
80102a75:	e8 de 13 00 00       	call   80103e58 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102a7a:	83 c4 10             	add    $0x10,%esp
80102a7d:	bb 80 27 11 80       	mov    $0x80112780,%ebx
80102a82:	eb 13                	jmp    80102a97 <startothers+0x38>
80102a84:	83 ec 0c             	sub    $0xc,%esp
80102a87:	68 08 6a 10 80       	push   $0x80106a08
80102a8c:	e8 cb d8 ff ff       	call   8010035c <panic>
80102a91:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102a97:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102a9e:	00 00 00 
80102aa1:	05 80 27 11 80       	add    $0x80112780,%eax
80102aa6:	39 d8                	cmp    %ebx,%eax
80102aa8:	76 58                	jbe    80102b02 <startothers+0xa3>
    if(c == mycpu())  // We've started already.
80102aaa:	e8 00 08 00 00       	call   801032af <mycpu>
80102aaf:	39 c3                	cmp    %eax,%ebx
80102ab1:	74 de                	je     80102a91 <startothers+0x32>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102ab3:	e8 c0 f6 ff ff       	call   80102178 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102ab8:	05 00 10 00 00       	add    $0x1000,%eax
80102abd:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void(**)(void))(code-8) = mpenter;
80102ac2:	c7 05 f8 6f 00 80 46 	movl   $0x80102b46,0x80006ff8
80102ac9:	2b 10 80 
    if (a < (void*) KERNBASE)
80102acc:	b8 00 90 10 80       	mov    $0x80109000,%eax
80102ad1:	3d ff ff ff 7f       	cmp    $0x7fffffff,%eax
80102ad6:	76 ac                	jbe    80102a84 <startothers+0x25>
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102ad8:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102adf:	90 10 00 

    lapicstartap(c->apicid, V2P(code));
80102ae2:	83 ec 08             	sub    $0x8,%esp
80102ae5:	68 00 70 00 00       	push   $0x7000
80102aea:	0f b6 03             	movzbl (%ebx),%eax
80102aed:	50                   	push   %eax
80102aee:	e8 a0 f9 ff ff       	call   80102493 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102af3:	83 c4 10             	add    $0x10,%esp
80102af6:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102afc:	85 c0                	test   %eax,%eax
80102afe:	74 f6                	je     80102af6 <startothers+0x97>
80102b00:	eb 8f                	jmp    80102a91 <startothers+0x32>
      ;
  }
}
80102b02:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b05:	c9                   	leave  
80102b06:	c3                   	ret    

80102b07 <mpmain>:
{
80102b07:	55                   	push   %ebp
80102b08:	89 e5                	mov    %esp,%ebp
80102b0a:	53                   	push   %ebx
80102b0b:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102b0e:	e8 fc 07 00 00       	call   8010330f <cpuid>
80102b13:	89 c3                	mov    %eax,%ebx
80102b15:	e8 f5 07 00 00       	call   8010330f <cpuid>
80102b1a:	83 ec 04             	sub    $0x4,%esp
80102b1d:	53                   	push   %ebx
80102b1e:	50                   	push   %eax
80102b1f:	68 24 6d 10 80       	push   $0x80106d24
80102b24:	e8 00 db ff ff       	call   80100629 <cprintf>
  idtinit();       // load idt register
80102b29:	e8 b3 24 00 00       	call   80104fe1 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102b2e:	e8 7c 07 00 00       	call   801032af <mycpu>
80102b33:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102b35:	b8 01 00 00 00       	mov    $0x1,%eax
80102b3a:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102b41:	e8 76 0a 00 00       	call   801035bc <scheduler>

80102b46 <mpenter>:
{
80102b46:	f3 0f 1e fb          	endbr32 
80102b4a:	55                   	push   %ebp
80102b4b:	89 e5                	mov    %esp,%ebp
80102b4d:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102b50:	e8 d6 34 00 00       	call   8010602b <switchkvm>
  seginit();
80102b55:	e8 81 33 00 00       	call   80105edb <seginit>
  lapicinit();
80102b5a:	e8 e0 f7 ff ff       	call   8010233f <lapicinit>
  mpmain();
80102b5f:	e8 a3 ff ff ff       	call   80102b07 <mpmain>

80102b64 <main>:
{
80102b64:	f3 0f 1e fb          	endbr32 
80102b68:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102b6c:	83 e4 f0             	and    $0xfffffff0,%esp
80102b6f:	ff 71 fc             	pushl  -0x4(%ecx)
80102b72:	55                   	push   %ebp
80102b73:	89 e5                	mov    %esp,%ebp
80102b75:	51                   	push   %ecx
80102b76:	83 ec 0c             	sub    $0xc,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102b79:	68 00 00 40 80       	push   $0x80400000
80102b7e:	68 a8 54 11 80       	push   $0x801154a8
80102b83:	e8 96 f5 ff ff       	call   8010211e <kinit1>
  kvmalloc();      // kernel page table
80102b88:	e8 db 39 00 00       	call   80106568 <kvmalloc>
  mpinit();        // detect other processors
80102b8d:	e8 db 01 00 00       	call   80102d6d <mpinit>
  lapicinit();     // interrupt controller
80102b92:	e8 a8 f7 ff ff       	call   8010233f <lapicinit>
  seginit();       // segment descriptors
80102b97:	e8 3f 33 00 00       	call   80105edb <seginit>
  picinit();       // disable pic
80102b9c:	e8 a6 02 00 00       	call   80102e47 <picinit>
  ioapicinit();    // another interrupt controller
80102ba1:	e8 cd f3 ff ff       	call   80101f73 <ioapicinit>
  consoleinit();   // console hardware
80102ba6:	e8 09 dd ff ff       	call   801008b4 <consoleinit>
  uartinit();      // serial port
80102bab:	e8 e9 26 00 00       	call   80105299 <uartinit>
  pinit();         // process table
80102bb0:	e8 dc 06 00 00       	call   80103291 <pinit>
  tvinit();        // trap vectors
80102bb5:	e8 72 23 00 00       	call   80104f2c <tvinit>
  binit();         // buffer cache
80102bba:	e8 35 d5 ff ff       	call   801000f4 <binit>
  fileinit();      // file table
80102bbf:	e8 75 e0 ff ff       	call   80100c39 <fileinit>
  ideinit();       // disk 
80102bc4:	e8 ac f1 ff ff       	call   80101d75 <ideinit>
  startothers();   // start other processors
80102bc9:	e8 91 fe ff ff       	call   80102a5f <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102bce:	83 c4 08             	add    $0x8,%esp
80102bd1:	68 00 00 00 8e       	push   $0x8e000000
80102bd6:	68 00 00 40 80       	push   $0x80400000
80102bdb:	e8 74 f5 ff ff       	call   80102154 <kinit2>
  userinit();      // first user process
80102be0:	e8 71 07 00 00       	call   80103356 <userinit>
  mpmain();        // finish this processor's setup
80102be5:	e8 1d ff ff ff       	call   80102b07 <mpmain>

80102bea <sum>:
int ncpu;
uchar ioapicid;

static uchar
sum(uchar *addr, int len)
{
80102bea:	55                   	push   %ebp
80102beb:	89 e5                	mov    %esp,%ebp
80102bed:	56                   	push   %esi
80102bee:	53                   	push   %ebx
80102bef:	89 c6                	mov    %eax,%esi
  int i, sum;

  sum = 0;
80102bf1:	b8 00 00 00 00       	mov    $0x0,%eax
  for(i=0; i<len; i++)
80102bf6:	b9 00 00 00 00       	mov    $0x0,%ecx
80102bfb:	39 d1                	cmp    %edx,%ecx
80102bfd:	7d 0b                	jge    80102c0a <sum+0x20>
    sum += addr[i];
80102bff:	0f b6 1c 0e          	movzbl (%esi,%ecx,1),%ebx
80102c03:	01 d8                	add    %ebx,%eax
  for(i=0; i<len; i++)
80102c05:	83 c1 01             	add    $0x1,%ecx
80102c08:	eb f1                	jmp    80102bfb <sum+0x11>
  return sum;
}
80102c0a:	5b                   	pop    %ebx
80102c0b:	5e                   	pop    %esi
80102c0c:	5d                   	pop    %ebp
80102c0d:	c3                   	ret    

80102c0e <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102c0e:	55                   	push   %ebp
80102c0f:	89 e5                	mov    %esp,%ebp
80102c11:	56                   	push   %esi
80102c12:	53                   	push   %ebx
}

// Convert physical address to kernel virtual address
static inline void *P2V(uint a) {
    extern void panic(char*) __attribute__((noreturn));
    if (a > KERNBASE)
80102c13:	3d 00 00 00 80       	cmp    $0x80000000,%eax
80102c18:	77 0b                	ja     80102c25 <mpsearch1+0x17>
        panic("P2V on address > KERNBASE");
    return (char*)a + KERNBASE;
80102c1a:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
80102c20:	8d 34 13             	lea    (%ebx,%edx,1),%esi
  for(p = addr; p < e; p += sizeof(struct mp))
80102c23:	eb 10                	jmp    80102c35 <mpsearch1+0x27>
        panic("P2V on address > KERNBASE");
80102c25:	83 ec 0c             	sub    $0xc,%esp
80102c28:	68 38 6d 10 80       	push   $0x80106d38
80102c2d:	e8 2a d7 ff ff       	call   8010035c <panic>
80102c32:	83 c3 10             	add    $0x10,%ebx
80102c35:	39 f3                	cmp    %esi,%ebx
80102c37:	73 29                	jae    80102c62 <mpsearch1+0x54>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102c39:	83 ec 04             	sub    $0x4,%esp
80102c3c:	6a 04                	push   $0x4
80102c3e:	68 52 6d 10 80       	push   $0x80106d52
80102c43:	53                   	push   %ebx
80102c44:	e8 d6 11 00 00       	call   80103e1f <memcmp>
80102c49:	83 c4 10             	add    $0x10,%esp
80102c4c:	85 c0                	test   %eax,%eax
80102c4e:	75 e2                	jne    80102c32 <mpsearch1+0x24>
80102c50:	ba 10 00 00 00       	mov    $0x10,%edx
80102c55:	89 d8                	mov    %ebx,%eax
80102c57:	e8 8e ff ff ff       	call   80102bea <sum>
80102c5c:	84 c0                	test   %al,%al
80102c5e:	75 d2                	jne    80102c32 <mpsearch1+0x24>
80102c60:	eb 05                	jmp    80102c67 <mpsearch1+0x59>
      return (struct mp*)p;
  return 0;
80102c62:	bb 00 00 00 00       	mov    $0x0,%ebx
}
80102c67:	89 d8                	mov    %ebx,%eax
80102c69:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102c6c:	5b                   	pop    %ebx
80102c6d:	5e                   	pop    %esi
80102c6e:	5d                   	pop    %ebp
80102c6f:	c3                   	ret    

80102c70 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80102c70:	55                   	push   %ebp
80102c71:	89 e5                	mov    %esp,%ebp
80102c73:	83 ec 08             	sub    $0x8,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102c76:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80102c7d:	c1 e0 08             	shl    $0x8,%eax
80102c80:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80102c87:	09 d0                	or     %edx,%eax
80102c89:	c1 e0 04             	shl    $0x4,%eax
80102c8c:	74 1f                	je     80102cad <mpsearch+0x3d>
    if((mp = mpsearch1(p, 1024)))
80102c8e:	ba 00 04 00 00       	mov    $0x400,%edx
80102c93:	e8 76 ff ff ff       	call   80102c0e <mpsearch1>
80102c98:	85 c0                	test   %eax,%eax
80102c9a:	75 0f                	jne    80102cab <mpsearch+0x3b>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
80102c9c:	ba 00 00 01 00       	mov    $0x10000,%edx
80102ca1:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80102ca6:	e8 63 ff ff ff       	call   80102c0e <mpsearch1>
}
80102cab:	c9                   	leave  
80102cac:	c3                   	ret    
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80102cad:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80102cb4:	c1 e0 08             	shl    $0x8,%eax
80102cb7:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80102cbe:	09 d0                	or     %edx,%eax
80102cc0:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80102cc3:	2d 00 04 00 00       	sub    $0x400,%eax
80102cc8:	ba 00 04 00 00       	mov    $0x400,%edx
80102ccd:	e8 3c ff ff ff       	call   80102c0e <mpsearch1>
80102cd2:	85 c0                	test   %eax,%eax
80102cd4:	75 d5                	jne    80102cab <mpsearch+0x3b>
80102cd6:	eb c4                	jmp    80102c9c <mpsearch+0x2c>

80102cd8 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80102cd8:	55                   	push   %ebp
80102cd9:	89 e5                	mov    %esp,%ebp
80102cdb:	57                   	push   %edi
80102cdc:	56                   	push   %esi
80102cdd:	53                   	push   %ebx
80102cde:	83 ec 0c             	sub    $0xc,%esp
80102ce1:	89 c7                	mov    %eax,%edi
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80102ce3:	e8 88 ff ff ff       	call   80102c70 <mpsearch>
80102ce8:	89 c6                	mov    %eax,%esi
80102cea:	85 c0                	test   %eax,%eax
80102cec:	74 66                	je     80102d54 <mpconfig+0x7c>
80102cee:	8b 58 04             	mov    0x4(%eax),%ebx
80102cf1:	85 db                	test   %ebx,%ebx
80102cf3:	74 48                	je     80102d3d <mpconfig+0x65>
    if (a > KERNBASE)
80102cf5:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80102cfb:	77 4a                	ja     80102d47 <mpconfig+0x6f>
    return (char*)a + KERNBASE;
80102cfd:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
80102d03:	83 ec 04             	sub    $0x4,%esp
80102d06:	6a 04                	push   $0x4
80102d08:	68 57 6d 10 80       	push   $0x80106d57
80102d0d:	53                   	push   %ebx
80102d0e:	e8 0c 11 00 00       	call   80103e1f <memcmp>
80102d13:	83 c4 10             	add    $0x10,%esp
80102d16:	85 c0                	test   %eax,%eax
80102d18:	75 3e                	jne    80102d58 <mpconfig+0x80>
    return 0;
  if(conf->version != 1 && conf->version != 4)
80102d1a:	0f b6 43 06          	movzbl 0x6(%ebx),%eax
80102d1e:	3c 01                	cmp    $0x1,%al
80102d20:	0f 95 c2             	setne  %dl
80102d23:	3c 04                	cmp    $0x4,%al
80102d25:	0f 95 c0             	setne  %al
80102d28:	84 c2                	test   %al,%dl
80102d2a:	75 33                	jne    80102d5f <mpconfig+0x87>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80102d2c:	0f b7 53 04          	movzwl 0x4(%ebx),%edx
80102d30:	89 d8                	mov    %ebx,%eax
80102d32:	e8 b3 fe ff ff       	call   80102bea <sum>
80102d37:	84 c0                	test   %al,%al
80102d39:	75 2b                	jne    80102d66 <mpconfig+0x8e>
    return 0;
  *pmp = mp;
80102d3b:	89 37                	mov    %esi,(%edi)
  return conf;
}
80102d3d:	89 d8                	mov    %ebx,%eax
80102d3f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d42:	5b                   	pop    %ebx
80102d43:	5e                   	pop    %esi
80102d44:	5f                   	pop    %edi
80102d45:	5d                   	pop    %ebp
80102d46:	c3                   	ret    
        panic("P2V on address > KERNBASE");
80102d47:	83 ec 0c             	sub    $0xc,%esp
80102d4a:	68 38 6d 10 80       	push   $0x80106d38
80102d4f:	e8 08 d6 ff ff       	call   8010035c <panic>
    return 0;
80102d54:	89 c3                	mov    %eax,%ebx
80102d56:	eb e5                	jmp    80102d3d <mpconfig+0x65>
    return 0;
80102d58:	bb 00 00 00 00       	mov    $0x0,%ebx
80102d5d:	eb de                	jmp    80102d3d <mpconfig+0x65>
    return 0;
80102d5f:	bb 00 00 00 00       	mov    $0x0,%ebx
80102d64:	eb d7                	jmp    80102d3d <mpconfig+0x65>
    return 0;
80102d66:	bb 00 00 00 00       	mov    $0x0,%ebx
80102d6b:	eb d0                	jmp    80102d3d <mpconfig+0x65>

80102d6d <mpinit>:

void
mpinit(void)
{
80102d6d:	f3 0f 1e fb          	endbr32 
80102d71:	55                   	push   %ebp
80102d72:	89 e5                	mov    %esp,%ebp
80102d74:	57                   	push   %edi
80102d75:	56                   	push   %esi
80102d76:	53                   	push   %ebx
80102d77:	83 ec 1c             	sub    $0x1c,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80102d7a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80102d7d:	e8 56 ff ff ff       	call   80102cd8 <mpconfig>
80102d82:	85 c0                	test   %eax,%eax
80102d84:	74 19                	je     80102d9f <mpinit+0x32>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80102d86:	8b 50 24             	mov    0x24(%eax),%edx
80102d89:	89 15 7c 26 11 80    	mov    %edx,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102d8f:	8d 50 2c             	lea    0x2c(%eax),%edx
80102d92:	0f b7 48 04          	movzwl 0x4(%eax),%ecx
80102d96:	01 c1                	add    %eax,%ecx
  ismp = 1;
80102d98:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102d9d:	eb 20                	jmp    80102dbf <mpinit+0x52>
    panic("Expect to run on an SMP");
80102d9f:	83 ec 0c             	sub    $0xc,%esp
80102da2:	68 5c 6d 10 80       	push   $0x80106d5c
80102da7:	e8 b0 d5 ff ff       	call   8010035c <panic>
    switch(*p){
80102dac:	bb 00 00 00 00       	mov    $0x0,%ebx
80102db1:	eb 0c                	jmp    80102dbf <mpinit+0x52>
80102db3:	83 e8 03             	sub    $0x3,%eax
80102db6:	3c 01                	cmp    $0x1,%al
80102db8:	76 1a                	jbe    80102dd4 <mpinit+0x67>
80102dba:	bb 00 00 00 00       	mov    $0x0,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102dbf:	39 ca                	cmp    %ecx,%edx
80102dc1:	73 4d                	jae    80102e10 <mpinit+0xa3>
    switch(*p){
80102dc3:	0f b6 02             	movzbl (%edx),%eax
80102dc6:	3c 02                	cmp    $0x2,%al
80102dc8:	74 38                	je     80102e02 <mpinit+0x95>
80102dca:	77 e7                	ja     80102db3 <mpinit+0x46>
80102dcc:	84 c0                	test   %al,%al
80102dce:	74 09                	je     80102dd9 <mpinit+0x6c>
80102dd0:	3c 01                	cmp    $0x1,%al
80102dd2:	75 d8                	jne    80102dac <mpinit+0x3f>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80102dd4:	83 c2 08             	add    $0x8,%edx
      continue;
80102dd7:	eb e6                	jmp    80102dbf <mpinit+0x52>
      if(ncpu < NCPU) {
80102dd9:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
80102ddf:	83 fe 07             	cmp    $0x7,%esi
80102de2:	7f 19                	jg     80102dfd <mpinit+0x90>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80102de4:	0f b6 42 01          	movzbl 0x1(%edx),%eax
80102de8:	69 fe b0 00 00 00    	imul   $0xb0,%esi,%edi
80102dee:	88 87 80 27 11 80    	mov    %al,-0x7feed880(%edi)
        ncpu++;
80102df4:	83 c6 01             	add    $0x1,%esi
80102df7:	89 35 00 2d 11 80    	mov    %esi,0x80112d00
      p += sizeof(struct mpproc);
80102dfd:	83 c2 14             	add    $0x14,%edx
      continue;
80102e00:	eb bd                	jmp    80102dbf <mpinit+0x52>
      ioapicid = ioapic->apicno;
80102e02:	0f b6 42 01          	movzbl 0x1(%edx),%eax
80102e06:	a2 60 27 11 80       	mov    %al,0x80112760
      p += sizeof(struct mpioapic);
80102e0b:	83 c2 08             	add    $0x8,%edx
      continue;
80102e0e:	eb af                	jmp    80102dbf <mpinit+0x52>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80102e10:	85 db                	test   %ebx,%ebx
80102e12:	74 26                	je     80102e3a <mpinit+0xcd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80102e14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102e17:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80102e1b:	74 15                	je     80102e32 <mpinit+0xc5>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e1d:	b8 70 00 00 00       	mov    $0x70,%eax
80102e22:	ba 22 00 00 00       	mov    $0x22,%edx
80102e27:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e28:	ba 23 00 00 00       	mov    $0x23,%edx
80102e2d:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80102e2e:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e31:	ee                   	out    %al,(%dx)
  }
}
80102e32:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e35:	5b                   	pop    %ebx
80102e36:	5e                   	pop    %esi
80102e37:	5f                   	pop    %edi
80102e38:	5d                   	pop    %ebp
80102e39:	c3                   	ret    
    panic("Didn't find a suitable machine");
80102e3a:	83 ec 0c             	sub    $0xc,%esp
80102e3d:	68 74 6d 10 80       	push   $0x80106d74
80102e42:	e8 15 d5 ff ff       	call   8010035c <panic>

80102e47 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80102e47:	f3 0f 1e fb          	endbr32 
80102e4b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102e50:	ba 21 00 00 00       	mov    $0x21,%edx
80102e55:	ee                   	out    %al,(%dx)
80102e56:	ba a1 00 00 00       	mov    $0xa1,%edx
80102e5b:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80102e5c:	c3                   	ret    

80102e5d <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80102e5d:	f3 0f 1e fb          	endbr32 
80102e61:	55                   	push   %ebp
80102e62:	89 e5                	mov    %esp,%ebp
80102e64:	57                   	push   %edi
80102e65:	56                   	push   %esi
80102e66:	53                   	push   %ebx
80102e67:	83 ec 0c             	sub    $0xc,%esp
80102e6a:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102e6d:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80102e70:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80102e76:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80102e7c:	e8 d6 dd ff ff       	call   80100c57 <filealloc>
80102e81:	89 03                	mov    %eax,(%ebx)
80102e83:	85 c0                	test   %eax,%eax
80102e85:	0f 84 88 00 00 00    	je     80102f13 <pipealloc+0xb6>
80102e8b:	e8 c7 dd ff ff       	call   80100c57 <filealloc>
80102e90:	89 06                	mov    %eax,(%esi)
80102e92:	85 c0                	test   %eax,%eax
80102e94:	74 7d                	je     80102f13 <pipealloc+0xb6>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80102e96:	e8 dd f2 ff ff       	call   80102178 <kalloc>
80102e9b:	89 c7                	mov    %eax,%edi
80102e9d:	85 c0                	test   %eax,%eax
80102e9f:	74 72                	je     80102f13 <pipealloc+0xb6>
    goto bad;
  p->readopen = 1;
80102ea1:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80102ea8:	00 00 00 
  p->writeopen = 1;
80102eab:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80102eb2:	00 00 00 
  p->nwrite = 0;
80102eb5:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80102ebc:	00 00 00 
  p->nread = 0;
80102ebf:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80102ec6:	00 00 00 
  initlock(&p->lock, "pipe");
80102ec9:	83 ec 08             	sub    $0x8,%esp
80102ecc:	68 93 6d 10 80       	push   $0x80106d93
80102ed1:	50                   	push   %eax
80102ed2:	e8 fd 0c 00 00       	call   80103bd4 <initlock>
  (*f0)->type = FD_PIPE;
80102ed7:	8b 03                	mov    (%ebx),%eax
80102ed9:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80102edf:	8b 03                	mov    (%ebx),%eax
80102ee1:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80102ee5:	8b 03                	mov    (%ebx),%eax
80102ee7:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80102eeb:	8b 03                	mov    (%ebx),%eax
80102eed:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80102ef0:	8b 06                	mov    (%esi),%eax
80102ef2:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80102ef8:	8b 06                	mov    (%esi),%eax
80102efa:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80102efe:	8b 06                	mov    (%esi),%eax
80102f00:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80102f04:	8b 06                	mov    (%esi),%eax
80102f06:	89 78 0c             	mov    %edi,0xc(%eax)
  return 0;
80102f09:	83 c4 10             	add    $0x10,%esp
80102f0c:	b8 00 00 00 00       	mov    $0x0,%eax
80102f11:	eb 29                	jmp    80102f3c <pipealloc+0xdf>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80102f13:	8b 03                	mov    (%ebx),%eax
80102f15:	85 c0                	test   %eax,%eax
80102f17:	74 0c                	je     80102f25 <pipealloc+0xc8>
    fileclose(*f0);
80102f19:	83 ec 0c             	sub    $0xc,%esp
80102f1c:	50                   	push   %eax
80102f1d:	e8 e3 dd ff ff       	call   80100d05 <fileclose>
80102f22:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80102f25:	8b 06                	mov    (%esi),%eax
80102f27:	85 c0                	test   %eax,%eax
80102f29:	74 19                	je     80102f44 <pipealloc+0xe7>
    fileclose(*f1);
80102f2b:	83 ec 0c             	sub    $0xc,%esp
80102f2e:	50                   	push   %eax
80102f2f:	e8 d1 dd ff ff       	call   80100d05 <fileclose>
80102f34:	83 c4 10             	add    $0x10,%esp
  return -1;
80102f37:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102f3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f3f:	5b                   	pop    %ebx
80102f40:	5e                   	pop    %esi
80102f41:	5f                   	pop    %edi
80102f42:	5d                   	pop    %ebp
80102f43:	c3                   	ret    
  return -1;
80102f44:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102f49:	eb f1                	jmp    80102f3c <pipealloc+0xdf>

80102f4b <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80102f4b:	f3 0f 1e fb          	endbr32 
80102f4f:	55                   	push   %ebp
80102f50:	89 e5                	mov    %esp,%ebp
80102f52:	53                   	push   %ebx
80102f53:	83 ec 10             	sub    $0x10,%esp
80102f56:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&p->lock);
80102f59:	53                   	push   %ebx
80102f5a:	e8 c5 0d 00 00       	call   80103d24 <acquire>
  if(writable){
80102f5f:	83 c4 10             	add    $0x10,%esp
80102f62:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102f66:	74 3f                	je     80102fa7 <pipeclose+0x5c>
    p->writeopen = 0;
80102f68:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80102f6f:	00 00 00 
    wakeup(&p->nread);
80102f72:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102f78:	83 ec 0c             	sub    $0xc,%esp
80102f7b:	50                   	push   %eax
80102f7c:	e8 dd 09 00 00       	call   8010395e <wakeup>
80102f81:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80102f84:	83 bb 3c 02 00 00 00 	cmpl   $0x0,0x23c(%ebx)
80102f8b:	75 09                	jne    80102f96 <pipeclose+0x4b>
80102f8d:	83 bb 40 02 00 00 00 	cmpl   $0x0,0x240(%ebx)
80102f94:	74 2f                	je     80102fc5 <pipeclose+0x7a>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80102f96:	83 ec 0c             	sub    $0xc,%esp
80102f99:	53                   	push   %ebx
80102f9a:	e8 ee 0d 00 00       	call   80103d8d <release>
80102f9f:	83 c4 10             	add    $0x10,%esp
}
80102fa2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102fa5:	c9                   	leave  
80102fa6:	c3                   	ret    
    p->readopen = 0;
80102fa7:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80102fae:	00 00 00 
    wakeup(&p->nwrite);
80102fb1:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80102fb7:	83 ec 0c             	sub    $0xc,%esp
80102fba:	50                   	push   %eax
80102fbb:	e8 9e 09 00 00       	call   8010395e <wakeup>
80102fc0:	83 c4 10             	add    $0x10,%esp
80102fc3:	eb bf                	jmp    80102f84 <pipeclose+0x39>
    release(&p->lock);
80102fc5:	83 ec 0c             	sub    $0xc,%esp
80102fc8:	53                   	push   %ebx
80102fc9:	e8 bf 0d 00 00       	call   80103d8d <release>
    kfree((char*)p);
80102fce:	89 1c 24             	mov    %ebx,(%esp)
80102fd1:	e8 55 f0 ff ff       	call   8010202b <kfree>
80102fd6:	83 c4 10             	add    $0x10,%esp
80102fd9:	eb c7                	jmp    80102fa2 <pipeclose+0x57>

80102fdb <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80102fdb:	f3 0f 1e fb          	endbr32 
80102fdf:	55                   	push   %ebp
80102fe0:	89 e5                	mov    %esp,%ebp
80102fe2:	57                   	push   %edi
80102fe3:	56                   	push   %esi
80102fe4:	53                   	push   %ebx
80102fe5:	83 ec 18             	sub    $0x18,%esp
80102fe8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80102feb:	89 de                	mov    %ebx,%esi
80102fed:	53                   	push   %ebx
80102fee:	e8 31 0d 00 00       	call   80103d24 <acquire>
  for(i = 0; i < n; i++){
80102ff3:	83 c4 10             	add    $0x10,%esp
80102ff6:	bf 00 00 00 00       	mov    $0x0,%edi
80102ffb:	3b 7d 10             	cmp    0x10(%ebp),%edi
80102ffe:	7c 41                	jl     80103041 <pipewrite+0x66>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103000:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103006:	83 ec 0c             	sub    $0xc,%esp
80103009:	50                   	push   %eax
8010300a:	e8 4f 09 00 00       	call   8010395e <wakeup>
  release(&p->lock);
8010300f:	89 1c 24             	mov    %ebx,(%esp)
80103012:	e8 76 0d 00 00       	call   80103d8d <release>
  return n;
80103017:	83 c4 10             	add    $0x10,%esp
8010301a:	8b 45 10             	mov    0x10(%ebp),%eax
8010301d:	eb 5c                	jmp    8010307b <pipewrite+0xa0>
      wakeup(&p->nread);
8010301f:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103025:	83 ec 0c             	sub    $0xc,%esp
80103028:	50                   	push   %eax
80103029:	e8 30 09 00 00       	call   8010395e <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010302e:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103034:	83 c4 08             	add    $0x8,%esp
80103037:	56                   	push   %esi
80103038:	50                   	push   %eax
80103039:	e8 b3 07 00 00       	call   801037f1 <sleep>
8010303e:	83 c4 10             	add    $0x10,%esp
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103041:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103047:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010304d:	05 00 02 00 00       	add    $0x200,%eax
80103052:	39 c2                	cmp    %eax,%edx
80103054:	75 2d                	jne    80103083 <pipewrite+0xa8>
      if(p->readopen == 0 || myproc()->killed){
80103056:	83 bb 3c 02 00 00 00 	cmpl   $0x0,0x23c(%ebx)
8010305d:	74 0b                	je     8010306a <pipewrite+0x8f>
8010305f:	e8 ca 02 00 00       	call   8010332e <myproc>
80103064:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80103068:	74 b5                	je     8010301f <pipewrite+0x44>
        release(&p->lock);
8010306a:	83 ec 0c             	sub    $0xc,%esp
8010306d:	53                   	push   %ebx
8010306e:	e8 1a 0d 00 00       	call   80103d8d <release>
        return -1;
80103073:	83 c4 10             	add    $0x10,%esp
80103076:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010307b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010307e:	5b                   	pop    %ebx
8010307f:	5e                   	pop    %esi
80103080:	5f                   	pop    %edi
80103081:	5d                   	pop    %ebp
80103082:	c3                   	ret    
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103083:	8d 42 01             	lea    0x1(%edx),%eax
80103086:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
8010308c:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103092:	8b 45 0c             	mov    0xc(%ebp),%eax
80103095:	0f b6 04 38          	movzbl (%eax,%edi,1),%eax
80103099:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
8010309d:	83 c7 01             	add    $0x1,%edi
801030a0:	e9 56 ff ff ff       	jmp    80102ffb <pipewrite+0x20>

801030a5 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801030a5:	f3 0f 1e fb          	endbr32 
801030a9:	55                   	push   %ebp
801030aa:	89 e5                	mov    %esp,%ebp
801030ac:	57                   	push   %edi
801030ad:	56                   	push   %esi
801030ae:	53                   	push   %ebx
801030af:	83 ec 18             	sub    $0x18,%esp
801030b2:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801030b5:	89 df                	mov    %ebx,%edi
801030b7:	53                   	push   %ebx
801030b8:	e8 67 0c 00 00       	call   80103d24 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801030bd:	83 c4 10             	add    $0x10,%esp
801030c0:	eb 13                	jmp    801030d5 <piperead+0x30>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801030c2:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801030c8:	83 ec 08             	sub    $0x8,%esp
801030cb:	57                   	push   %edi
801030cc:	50                   	push   %eax
801030cd:	e8 1f 07 00 00       	call   801037f1 <sleep>
801030d2:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801030d5:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
801030db:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
801030e1:	75 28                	jne    8010310b <piperead+0x66>
801030e3:	8b b3 40 02 00 00    	mov    0x240(%ebx),%esi
801030e9:	85 f6                	test   %esi,%esi
801030eb:	74 23                	je     80103110 <piperead+0x6b>
    if(myproc()->killed){
801030ed:	e8 3c 02 00 00       	call   8010332e <myproc>
801030f2:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
801030f6:	74 ca                	je     801030c2 <piperead+0x1d>
      release(&p->lock);
801030f8:	83 ec 0c             	sub    $0xc,%esp
801030fb:	53                   	push   %ebx
801030fc:	e8 8c 0c 00 00       	call   80103d8d <release>
      return -1;
80103101:	83 c4 10             	add    $0x10,%esp
80103104:	be ff ff ff ff       	mov    $0xffffffff,%esi
80103109:	eb 50                	jmp    8010315b <piperead+0xb6>
8010310b:	be 00 00 00 00       	mov    $0x0,%esi
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103110:	3b 75 10             	cmp    0x10(%ebp),%esi
80103113:	7d 2c                	jge    80103141 <piperead+0x9c>
    if(p->nread == p->nwrite)
80103115:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010311b:	3b 83 38 02 00 00    	cmp    0x238(%ebx),%eax
80103121:	74 1e                	je     80103141 <piperead+0x9c>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103123:	8d 50 01             	lea    0x1(%eax),%edx
80103126:	89 93 34 02 00 00    	mov    %edx,0x234(%ebx)
8010312c:	25 ff 01 00 00       	and    $0x1ff,%eax
80103131:	0f b6 44 03 34       	movzbl 0x34(%ebx,%eax,1),%eax
80103136:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103139:	88 04 31             	mov    %al,(%ecx,%esi,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010313c:	83 c6 01             	add    $0x1,%esi
8010313f:	eb cf                	jmp    80103110 <piperead+0x6b>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103141:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103147:	83 ec 0c             	sub    $0xc,%esp
8010314a:	50                   	push   %eax
8010314b:	e8 0e 08 00 00       	call   8010395e <wakeup>
  release(&p->lock);
80103150:	89 1c 24             	mov    %ebx,(%esp)
80103153:	e8 35 0c 00 00       	call   80103d8d <release>
  return i;
80103158:	83 c4 10             	add    $0x10,%esp
}
8010315b:	89 f0                	mov    %esi,%eax
8010315d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103160:	5b                   	pop    %ebx
80103161:	5e                   	pop    %esi
80103162:	5f                   	pop    %edi
80103163:	5d                   	pop    %ebp
80103164:	c3                   	ret    

80103165 <wakeup1>:
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103165:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
8010316a:	eb 0a                	jmp    80103176 <wakeup1+0x11>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
8010316c:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103173:	83 c2 7c             	add    $0x7c,%edx
80103176:	81 fa 54 4c 11 80    	cmp    $0x80114c54,%edx
8010317c:	73 0d                	jae    8010318b <wakeup1+0x26>
    if(p->state == SLEEPING && p->chan == chan)
8010317e:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103182:	75 ef                	jne    80103173 <wakeup1+0xe>
80103184:	39 42 20             	cmp    %eax,0x20(%edx)
80103187:	75 ea                	jne    80103173 <wakeup1+0xe>
80103189:	eb e1                	jmp    8010316c <wakeup1+0x7>
}
8010318b:	c3                   	ret    

8010318c <allocproc>:
{
8010318c:	55                   	push   %ebp
8010318d:	89 e5                	mov    %esp,%ebp
8010318f:	53                   	push   %ebx
80103190:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103193:	68 20 2d 11 80       	push   $0x80112d20
80103198:	e8 87 0b 00 00       	call   80103d24 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010319d:	83 c4 10             	add    $0x10,%esp
801031a0:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
801031a5:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
801031ab:	73 7b                	jae    80103228 <allocproc+0x9c>
    if(p->state == UNUSED)
801031ad:	83 7b 0c 00          	cmpl   $0x0,0xc(%ebx)
801031b1:	74 05                	je     801031b8 <allocproc+0x2c>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801031b3:	83 c3 7c             	add    $0x7c,%ebx
801031b6:	eb ed                	jmp    801031a5 <allocproc+0x19>
  p->state = EMBRYO;
801031b8:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801031bf:	a1 04 a0 10 80       	mov    0x8010a004,%eax
801031c4:	8d 50 01             	lea    0x1(%eax),%edx
801031c7:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
801031cd:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
801031d0:	83 ec 0c             	sub    $0xc,%esp
801031d3:	68 20 2d 11 80       	push   $0x80112d20
801031d8:	e8 b0 0b 00 00       	call   80103d8d <release>
  if((p->kstack = kalloc()) == 0){
801031dd:	e8 96 ef ff ff       	call   80102178 <kalloc>
801031e2:	89 43 08             	mov    %eax,0x8(%ebx)
801031e5:	83 c4 10             	add    $0x10,%esp
801031e8:	85 c0                	test   %eax,%eax
801031ea:	74 53                	je     8010323f <allocproc+0xb3>
  sp -= sizeof *p->tf;
801031ec:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  p->tf = (struct trapframe*)sp;
801031f2:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
801031f5:	c7 80 b0 0f 00 00 21 	movl   $0x80104f21,0xfb0(%eax)
801031fc:	4f 10 80 
  sp -= sizeof *p->context;
801031ff:	05 9c 0f 00 00       	add    $0xf9c,%eax
  p->context = (struct context*)sp;
80103204:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103207:	83 ec 04             	sub    $0x4,%esp
8010320a:	6a 14                	push   $0x14
8010320c:	6a 00                	push   $0x0
8010320e:	50                   	push   %eax
8010320f:	e8 c4 0b 00 00       	call   80103dd8 <memset>
  p->context->eip = (uint)forkret;
80103214:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103217:	c7 40 10 4a 32 10 80 	movl   $0x8010324a,0x10(%eax)
  return p;
8010321e:	83 c4 10             	add    $0x10,%esp
}
80103221:	89 d8                	mov    %ebx,%eax
80103223:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103226:	c9                   	leave  
80103227:	c3                   	ret    
  release(&ptable.lock);
80103228:	83 ec 0c             	sub    $0xc,%esp
8010322b:	68 20 2d 11 80       	push   $0x80112d20
80103230:	e8 58 0b 00 00       	call   80103d8d <release>
  return 0;
80103235:	83 c4 10             	add    $0x10,%esp
80103238:	bb 00 00 00 00       	mov    $0x0,%ebx
8010323d:	eb e2                	jmp    80103221 <allocproc+0x95>
    p->state = UNUSED;
8010323f:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103246:	89 c3                	mov    %eax,%ebx
80103248:	eb d7                	jmp    80103221 <allocproc+0x95>

8010324a <forkret>:
{
8010324a:	f3 0f 1e fb          	endbr32 
8010324e:	55                   	push   %ebp
8010324f:	89 e5                	mov    %esp,%ebp
80103251:	83 ec 14             	sub    $0x14,%esp
  release(&ptable.lock);
80103254:	68 20 2d 11 80       	push   $0x80112d20
80103259:	e8 2f 0b 00 00       	call   80103d8d <release>
  if (first) {
8010325e:	83 c4 10             	add    $0x10,%esp
80103261:	83 3d 00 a0 10 80 00 	cmpl   $0x0,0x8010a000
80103268:	75 02                	jne    8010326c <forkret+0x22>
}
8010326a:	c9                   	leave  
8010326b:	c3                   	ret    
    first = 0;
8010326c:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
80103273:	00 00 00 
    iinit(ROOTDEV);
80103276:	83 ec 0c             	sub    $0xc,%esp
80103279:	6a 01                	push   $0x1
8010327b:	e8 a5 e0 ff ff       	call   80101325 <iinit>
    initlog(ROOTDEV);
80103280:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103287:	e8 ac f5 ff ff       	call   80102838 <initlog>
8010328c:	83 c4 10             	add    $0x10,%esp
}
8010328f:	eb d9                	jmp    8010326a <forkret+0x20>

80103291 <pinit>:
{
80103291:	f3 0f 1e fb          	endbr32 
80103295:	55                   	push   %ebp
80103296:	89 e5                	mov    %esp,%ebp
80103298:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
8010329b:	68 98 6d 10 80       	push   $0x80106d98
801032a0:	68 20 2d 11 80       	push   $0x80112d20
801032a5:	e8 2a 09 00 00       	call   80103bd4 <initlock>
}
801032aa:	83 c4 10             	add    $0x10,%esp
801032ad:	c9                   	leave  
801032ae:	c3                   	ret    

801032af <mycpu>:
{
801032af:	f3 0f 1e fb          	endbr32 
801032b3:	55                   	push   %ebp
801032b4:	89 e5                	mov    %esp,%ebp
801032b6:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801032b9:	9c                   	pushf  
801032ba:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801032bb:	f6 c4 02             	test   $0x2,%ah
801032be:	75 28                	jne    801032e8 <mycpu+0x39>
  apicid = lapicid();
801032c0:	e8 8a f1 ff ff       	call   8010244f <lapicid>
  for (i = 0; i < ncpu; ++i) {
801032c5:	ba 00 00 00 00       	mov    $0x0,%edx
801032ca:	39 15 00 2d 11 80    	cmp    %edx,0x80112d00
801032d0:	7e 30                	jle    80103302 <mycpu+0x53>
    if (cpus[i].apicid == apicid)
801032d2:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
801032d8:	0f b6 89 80 27 11 80 	movzbl -0x7feed880(%ecx),%ecx
801032df:	39 c1                	cmp    %eax,%ecx
801032e1:	74 12                	je     801032f5 <mycpu+0x46>
  for (i = 0; i < ncpu; ++i) {
801032e3:	83 c2 01             	add    $0x1,%edx
801032e6:	eb e2                	jmp    801032ca <mycpu+0x1b>
    panic("mycpu called with interrupts enabled\n");
801032e8:	83 ec 0c             	sub    $0xc,%esp
801032eb:	68 7c 6e 10 80       	push   $0x80106e7c
801032f0:	e8 67 d0 ff ff       	call   8010035c <panic>
      return &cpus[i];
801032f5:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
801032fb:	05 80 27 11 80       	add    $0x80112780,%eax
}
80103300:	c9                   	leave  
80103301:	c3                   	ret    
  panic("unknown apicid\n");
80103302:	83 ec 0c             	sub    $0xc,%esp
80103305:	68 9f 6d 10 80       	push   $0x80106d9f
8010330a:	e8 4d d0 ff ff       	call   8010035c <panic>

8010330f <cpuid>:
cpuid() {
8010330f:	f3 0f 1e fb          	endbr32 
80103313:	55                   	push   %ebp
80103314:	89 e5                	mov    %esp,%ebp
80103316:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103319:	e8 91 ff ff ff       	call   801032af <mycpu>
8010331e:	2d 80 27 11 80       	sub    $0x80112780,%eax
80103323:	c1 f8 04             	sar    $0x4,%eax
80103326:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010332c:	c9                   	leave  
8010332d:	c3                   	ret    

8010332e <myproc>:
myproc(void) {
8010332e:	f3 0f 1e fb          	endbr32 
80103332:	55                   	push   %ebp
80103333:	89 e5                	mov    %esp,%ebp
80103335:	53                   	push   %ebx
80103336:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103339:	e8 fd 08 00 00       	call   80103c3b <pushcli>
  c = mycpu();
8010333e:	e8 6c ff ff ff       	call   801032af <mycpu>
  p = c->proc;
80103343:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103349:	e8 2e 09 00 00       	call   80103c7c <popcli>
}
8010334e:	89 d8                	mov    %ebx,%eax
80103350:	83 c4 04             	add    $0x4,%esp
80103353:	5b                   	pop    %ebx
80103354:	5d                   	pop    %ebp
80103355:	c3                   	ret    

80103356 <userinit>:
{
80103356:	f3 0f 1e fb          	endbr32 
8010335a:	55                   	push   %ebp
8010335b:	89 e5                	mov    %esp,%ebp
8010335d:	53                   	push   %ebx
8010335e:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103361:	e8 26 fe ff ff       	call   8010318c <allocproc>
80103366:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103368:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
8010336d:	e8 84 31 00 00       	call   801064f6 <setupkvm>
80103372:	89 43 04             	mov    %eax,0x4(%ebx)
80103375:	85 c0                	test   %eax,%eax
80103377:	0f 84 b8 00 00 00    	je     80103435 <userinit+0xdf>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
8010337d:	83 ec 04             	sub    $0x4,%esp
80103380:	68 2c 00 00 00       	push   $0x2c
80103385:	68 60 a4 10 80       	push   $0x8010a460
8010338a:	50                   	push   %eax
8010338b:	e8 f4 2d 00 00       	call   80106184 <inituvm>
  p->sz = PGSIZE;
80103390:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103396:	8b 43 18             	mov    0x18(%ebx),%eax
80103399:	83 c4 0c             	add    $0xc,%esp
8010339c:	6a 4c                	push   $0x4c
8010339e:	6a 00                	push   $0x0
801033a0:	50                   	push   %eax
801033a1:	e8 32 0a 00 00       	call   80103dd8 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801033a6:	8b 43 18             	mov    0x18(%ebx),%eax
801033a9:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801033af:	8b 43 18             	mov    0x18(%ebx),%eax
801033b2:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
801033b8:	8b 43 18             	mov    0x18(%ebx),%eax
801033bb:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801033bf:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801033c3:	8b 43 18             	mov    0x18(%ebx),%eax
801033c6:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801033ca:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801033ce:	8b 43 18             	mov    0x18(%ebx),%eax
801033d1:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801033d8:	8b 43 18             	mov    0x18(%ebx),%eax
801033db:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801033e2:	8b 43 18             	mov    0x18(%ebx),%eax
801033e5:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
801033ec:	8d 43 6c             	lea    0x6c(%ebx),%eax
801033ef:	83 c4 0c             	add    $0xc,%esp
801033f2:	6a 10                	push   $0x10
801033f4:	68 c8 6d 10 80       	push   $0x80106dc8
801033f9:	50                   	push   %eax
801033fa:	e8 59 0b 00 00       	call   80103f58 <safestrcpy>
  p->cwd = namei("/");
801033ff:	c7 04 24 d1 6d 10 80 	movl   $0x80106dd1,(%esp)
80103406:	e8 44 e8 ff ff       	call   80101c4f <namei>
8010340b:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
8010340e:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103415:	e8 0a 09 00 00       	call   80103d24 <acquire>
  p->state = RUNNABLE;
8010341a:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103421:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103428:	e8 60 09 00 00       	call   80103d8d <release>
}
8010342d:	83 c4 10             	add    $0x10,%esp
80103430:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103433:	c9                   	leave  
80103434:	c3                   	ret    
    panic("userinit: out of memory?");
80103435:	83 ec 0c             	sub    $0xc,%esp
80103438:	68 af 6d 10 80       	push   $0x80106daf
8010343d:	e8 1a cf ff ff       	call   8010035c <panic>

80103442 <growproc>:
{
80103442:	f3 0f 1e fb          	endbr32 
80103446:	55                   	push   %ebp
80103447:	89 e5                	mov    %esp,%ebp
80103449:	56                   	push   %esi
8010344a:	53                   	push   %ebx
8010344b:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc *curproc = myproc();
8010344e:	e8 db fe ff ff       	call   8010332e <myproc>
80103453:	89 c3                	mov    %eax,%ebx
  sz = curproc->sz;
80103455:	8b 00                	mov    (%eax),%eax
  if(n > 0){
80103457:	85 f6                	test   %esi,%esi
80103459:	7f 1c                	jg     80103477 <growproc+0x35>
  } else if(n < 0){
8010345b:	78 37                	js     80103494 <growproc+0x52>
  curproc->sz = sz;
8010345d:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
8010345f:	83 ec 0c             	sub    $0xc,%esp
80103462:	53                   	push   %ebx
80103463:	e8 ec 2b 00 00       	call   80106054 <switchuvm>
  return 0;
80103468:	83 c4 10             	add    $0x10,%esp
8010346b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103470:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103473:	5b                   	pop    %ebx
80103474:	5e                   	pop    %esi
80103475:	5d                   	pop    %ebp
80103476:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103477:	83 ec 04             	sub    $0x4,%esp
8010347a:	01 c6                	add    %eax,%esi
8010347c:	56                   	push   %esi
8010347d:	50                   	push   %eax
8010347e:	ff 73 04             	pushl  0x4(%ebx)
80103481:	e8 e0 2e 00 00       	call   80106366 <allocuvm>
80103486:	83 c4 10             	add    $0x10,%esp
80103489:	85 c0                	test   %eax,%eax
8010348b:	75 d0                	jne    8010345d <growproc+0x1b>
      return -1;
8010348d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103492:	eb dc                	jmp    80103470 <growproc+0x2e>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103494:	83 ec 04             	sub    $0x4,%esp
80103497:	01 c6                	add    %eax,%esi
80103499:	56                   	push   %esi
8010349a:	50                   	push   %eax
8010349b:	ff 73 04             	pushl  0x4(%ebx)
8010349e:	e8 19 2e 00 00       	call   801062bc <deallocuvm>
801034a3:	83 c4 10             	add    $0x10,%esp
801034a6:	85 c0                	test   %eax,%eax
801034a8:	75 b3                	jne    8010345d <growproc+0x1b>
      return -1;
801034aa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801034af:	eb bf                	jmp    80103470 <growproc+0x2e>

801034b1 <fork>:
{
801034b1:	f3 0f 1e fb          	endbr32 
801034b5:	55                   	push   %ebp
801034b6:	89 e5                	mov    %esp,%ebp
801034b8:	57                   	push   %edi
801034b9:	56                   	push   %esi
801034ba:	53                   	push   %ebx
801034bb:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *curproc = myproc();
801034be:	e8 6b fe ff ff       	call   8010332e <myproc>
801034c3:	89 c3                	mov    %eax,%ebx
  if((np = allocproc()) == 0){
801034c5:	e8 c2 fc ff ff       	call   8010318c <allocproc>
801034ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801034cd:	85 c0                	test   %eax,%eax
801034cf:	0f 84 e0 00 00 00    	je     801035b5 <fork+0x104>
801034d5:	89 c7                	mov    %eax,%edi
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801034d7:	83 ec 08             	sub    $0x8,%esp
801034da:	ff 33                	pushl  (%ebx)
801034dc:	ff 73 04             	pushl  0x4(%ebx)
801034df:	e8 cf 30 00 00       	call   801065b3 <copyuvm>
801034e4:	89 47 04             	mov    %eax,0x4(%edi)
801034e7:	83 c4 10             	add    $0x10,%esp
801034ea:	85 c0                	test   %eax,%eax
801034ec:	74 2a                	je     80103518 <fork+0x67>
  np->sz = curproc->sz;
801034ee:	8b 03                	mov    (%ebx),%eax
801034f0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801034f3:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
801034f5:	89 c8                	mov    %ecx,%eax
801034f7:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
801034fa:	8b 73 18             	mov    0x18(%ebx),%esi
801034fd:	8b 79 18             	mov    0x18(%ecx),%edi
80103500:	b9 13 00 00 00       	mov    $0x13,%ecx
80103505:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  np->tf->eax = 0;
80103507:	8b 40 18             	mov    0x18(%eax),%eax
8010350a:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103511:	be 00 00 00 00       	mov    $0x0,%esi
80103516:	eb 3c                	jmp    80103554 <fork+0xa3>
    kfree(np->kstack);
80103518:	83 ec 0c             	sub    $0xc,%esp
8010351b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010351e:	ff 73 08             	pushl  0x8(%ebx)
80103521:	e8 05 eb ff ff       	call   8010202b <kfree>
    np->kstack = 0;
80103526:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
8010352d:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103534:	83 c4 10             	add    $0x10,%esp
80103537:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010353c:	eb 6d                	jmp    801035ab <fork+0xfa>
      np->ofile[i] = filedup(curproc->ofile[i]);
8010353e:	83 ec 0c             	sub    $0xc,%esp
80103541:	50                   	push   %eax
80103542:	e8 75 d7 ff ff       	call   80100cbc <filedup>
80103547:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010354a:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
8010354e:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NOFILE; i++)
80103551:	83 c6 01             	add    $0x1,%esi
80103554:	83 fe 0f             	cmp    $0xf,%esi
80103557:	7f 0a                	jg     80103563 <fork+0xb2>
    if(curproc->ofile[i])
80103559:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
8010355d:	85 c0                	test   %eax,%eax
8010355f:	75 dd                	jne    8010353e <fork+0x8d>
80103561:	eb ee                	jmp    80103551 <fork+0xa0>
  np->cwd = idup(curproc->cwd);
80103563:	83 ec 0c             	sub    $0xc,%esp
80103566:	ff 73 68             	pushl  0x68(%ebx)
80103569:	e8 28 e0 ff ff       	call   80101596 <idup>
8010356e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103571:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103574:	83 c3 6c             	add    $0x6c,%ebx
80103577:	8d 47 6c             	lea    0x6c(%edi),%eax
8010357a:	83 c4 0c             	add    $0xc,%esp
8010357d:	6a 10                	push   $0x10
8010357f:	53                   	push   %ebx
80103580:	50                   	push   %eax
80103581:	e8 d2 09 00 00       	call   80103f58 <safestrcpy>
  pid = np->pid;
80103586:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103589:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103590:	e8 8f 07 00 00       	call   80103d24 <acquire>
  np->state = RUNNABLE;
80103595:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
8010359c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801035a3:	e8 e5 07 00 00       	call   80103d8d <release>
  return pid;
801035a8:	83 c4 10             	add    $0x10,%esp
}
801035ab:	89 d8                	mov    %ebx,%eax
801035ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035b0:	5b                   	pop    %ebx
801035b1:	5e                   	pop    %esi
801035b2:	5f                   	pop    %edi
801035b3:	5d                   	pop    %ebp
801035b4:	c3                   	ret    
    return -1;
801035b5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801035ba:	eb ef                	jmp    801035ab <fork+0xfa>

801035bc <scheduler>:
{
801035bc:	f3 0f 1e fb          	endbr32 
801035c0:	55                   	push   %ebp
801035c1:	89 e5                	mov    %esp,%ebp
801035c3:	56                   	push   %esi
801035c4:	53                   	push   %ebx
  struct cpu *c = mycpu();
801035c5:	e8 e5 fc ff ff       	call   801032af <mycpu>
801035ca:	89 c6                	mov    %eax,%esi
  c->proc = 0;
801035cc:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801035d3:	00 00 00 
801035d6:	eb 5a                	jmp    80103632 <scheduler+0x76>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801035d8:	83 c3 7c             	add    $0x7c,%ebx
801035db:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
801035e1:	73 3f                	jae    80103622 <scheduler+0x66>
      if(p->state != RUNNABLE)
801035e3:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801035e7:	75 ef                	jne    801035d8 <scheduler+0x1c>
      c->proc = p;
801035e9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
801035ef:	83 ec 0c             	sub    $0xc,%esp
801035f2:	53                   	push   %ebx
801035f3:	e8 5c 2a 00 00       	call   80106054 <switchuvm>
      p->state = RUNNING;
801035f8:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
801035ff:	83 c4 08             	add    $0x8,%esp
80103602:	ff 73 1c             	pushl  0x1c(%ebx)
80103605:	8d 46 04             	lea    0x4(%esi),%eax
80103608:	50                   	push   %eax
80103609:	e8 a7 09 00 00       	call   80103fb5 <swtch>
      switchkvm();
8010360e:	e8 18 2a 00 00       	call   8010602b <switchkvm>
      c->proc = 0;
80103613:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
8010361a:	00 00 00 
8010361d:	83 c4 10             	add    $0x10,%esp
80103620:	eb b6                	jmp    801035d8 <scheduler+0x1c>
    release(&ptable.lock);
80103622:	83 ec 0c             	sub    $0xc,%esp
80103625:	68 20 2d 11 80       	push   $0x80112d20
8010362a:	e8 5e 07 00 00       	call   80103d8d <release>
    sti();
8010362f:	83 c4 10             	add    $0x10,%esp
  asm volatile("sti");
80103632:	fb                   	sti    
    acquire(&ptable.lock);
80103633:	83 ec 0c             	sub    $0xc,%esp
80103636:	68 20 2d 11 80       	push   $0x80112d20
8010363b:	e8 e4 06 00 00       	call   80103d24 <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103640:	83 c4 10             	add    $0x10,%esp
80103643:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103648:	eb 91                	jmp    801035db <scheduler+0x1f>

8010364a <sched>:
{
8010364a:	f3 0f 1e fb          	endbr32 
8010364e:	55                   	push   %ebp
8010364f:	89 e5                	mov    %esp,%ebp
80103651:	56                   	push   %esi
80103652:	53                   	push   %ebx
  struct proc *p = myproc();
80103653:	e8 d6 fc ff ff       	call   8010332e <myproc>
80103658:	89 c3                	mov    %eax,%ebx
  if(!holding(&ptable.lock))
8010365a:	83 ec 0c             	sub    $0xc,%esp
8010365d:	68 20 2d 11 80       	push   $0x80112d20
80103662:	e8 79 06 00 00       	call   80103ce0 <holding>
80103667:	83 c4 10             	add    $0x10,%esp
8010366a:	85 c0                	test   %eax,%eax
8010366c:	74 4f                	je     801036bd <sched+0x73>
  if(mycpu()->ncli != 1)
8010366e:	e8 3c fc ff ff       	call   801032af <mycpu>
80103673:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010367a:	75 4e                	jne    801036ca <sched+0x80>
  if(p->state == RUNNING)
8010367c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103680:	74 55                	je     801036d7 <sched+0x8d>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103682:	9c                   	pushf  
80103683:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103684:	f6 c4 02             	test   $0x2,%ah
80103687:	75 5b                	jne    801036e4 <sched+0x9a>
  intena = mycpu()->intena;
80103689:	e8 21 fc ff ff       	call   801032af <mycpu>
8010368e:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103694:	e8 16 fc ff ff       	call   801032af <mycpu>
80103699:	83 ec 08             	sub    $0x8,%esp
8010369c:	ff 70 04             	pushl  0x4(%eax)
8010369f:	83 c3 1c             	add    $0x1c,%ebx
801036a2:	53                   	push   %ebx
801036a3:	e8 0d 09 00 00       	call   80103fb5 <swtch>
  mycpu()->intena = intena;
801036a8:	e8 02 fc ff ff       	call   801032af <mycpu>
801036ad:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801036b3:	83 c4 10             	add    $0x10,%esp
801036b6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801036b9:	5b                   	pop    %ebx
801036ba:	5e                   	pop    %esi
801036bb:	5d                   	pop    %ebp
801036bc:	c3                   	ret    
    panic("sched ptable.lock");
801036bd:	83 ec 0c             	sub    $0xc,%esp
801036c0:	68 d3 6d 10 80       	push   $0x80106dd3
801036c5:	e8 92 cc ff ff       	call   8010035c <panic>
    panic("sched locks");
801036ca:	83 ec 0c             	sub    $0xc,%esp
801036cd:	68 e5 6d 10 80       	push   $0x80106de5
801036d2:	e8 85 cc ff ff       	call   8010035c <panic>
    panic("sched running");
801036d7:	83 ec 0c             	sub    $0xc,%esp
801036da:	68 f1 6d 10 80       	push   $0x80106df1
801036df:	e8 78 cc ff ff       	call   8010035c <panic>
    panic("sched interruptible");
801036e4:	83 ec 0c             	sub    $0xc,%esp
801036e7:	68 ff 6d 10 80       	push   $0x80106dff
801036ec:	e8 6b cc ff ff       	call   8010035c <panic>

801036f1 <exit>:
{
801036f1:	f3 0f 1e fb          	endbr32 
801036f5:	55                   	push   %ebp
801036f6:	89 e5                	mov    %esp,%ebp
801036f8:	56                   	push   %esi
801036f9:	53                   	push   %ebx
  struct proc *curproc = myproc();
801036fa:	e8 2f fc ff ff       	call   8010332e <myproc>
  if(curproc == initproc)
801036ff:	39 05 b8 a5 10 80    	cmp    %eax,0x8010a5b8
80103705:	74 09                	je     80103710 <exit+0x1f>
80103707:	89 c6                	mov    %eax,%esi
  for(fd = 0; fd < NOFILE; fd++){
80103709:	bb 00 00 00 00       	mov    $0x0,%ebx
8010370e:	eb 24                	jmp    80103734 <exit+0x43>
    panic("init exiting");
80103710:	83 ec 0c             	sub    $0xc,%esp
80103713:	68 13 6e 10 80       	push   $0x80106e13
80103718:	e8 3f cc ff ff       	call   8010035c <panic>
      fileclose(curproc->ofile[fd]);
8010371d:	83 ec 0c             	sub    $0xc,%esp
80103720:	50                   	push   %eax
80103721:	e8 df d5 ff ff       	call   80100d05 <fileclose>
      curproc->ofile[fd] = 0;
80103726:	c7 44 9e 28 00 00 00 	movl   $0x0,0x28(%esi,%ebx,4)
8010372d:	00 
8010372e:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103731:	83 c3 01             	add    $0x1,%ebx
80103734:	83 fb 0f             	cmp    $0xf,%ebx
80103737:	7f 0a                	jg     80103743 <exit+0x52>
    if(curproc->ofile[fd]){
80103739:	8b 44 9e 28          	mov    0x28(%esi,%ebx,4),%eax
8010373d:	85 c0                	test   %eax,%eax
8010373f:	75 dc                	jne    8010371d <exit+0x2c>
80103741:	eb ee                	jmp    80103731 <exit+0x40>
  begin_op();
80103743:	e8 3d f1 ff ff       	call   80102885 <begin_op>
  iput(curproc->cwd);
80103748:	83 ec 0c             	sub    $0xc,%esp
8010374b:	ff 76 68             	pushl  0x68(%esi)
8010374e:	e8 86 df ff ff       	call   801016d9 <iput>
  end_op();
80103753:	e8 ab f1 ff ff       	call   80102903 <end_op>
  curproc->cwd = 0;
80103758:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
8010375f:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103766:	e8 b9 05 00 00       	call   80103d24 <acquire>
  wakeup1(curproc->parent);
8010376b:	8b 46 14             	mov    0x14(%esi),%eax
8010376e:	e8 f2 f9 ff ff       	call   80103165 <wakeup1>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103773:	83 c4 10             	add    $0x10,%esp
80103776:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
8010377b:	eb 03                	jmp    80103780 <exit+0x8f>
8010377d:	83 c3 7c             	add    $0x7c,%ebx
80103780:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103786:	73 1a                	jae    801037a2 <exit+0xb1>
    if(p->parent == curproc){
80103788:	39 73 14             	cmp    %esi,0x14(%ebx)
8010378b:	75 f0                	jne    8010377d <exit+0x8c>
      p->parent = initproc;
8010378d:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
80103792:	89 43 14             	mov    %eax,0x14(%ebx)
      if(p->state == ZOMBIE)
80103795:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103799:	75 e2                	jne    8010377d <exit+0x8c>
        wakeup1(initproc);
8010379b:	e8 c5 f9 ff ff       	call   80103165 <wakeup1>
801037a0:	eb db                	jmp    8010377d <exit+0x8c>
  curproc->state = ZOMBIE;
801037a2:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
801037a9:	e8 9c fe ff ff       	call   8010364a <sched>
  panic("zombie exit");
801037ae:	83 ec 0c             	sub    $0xc,%esp
801037b1:	68 20 6e 10 80       	push   $0x80106e20
801037b6:	e8 a1 cb ff ff       	call   8010035c <panic>

801037bb <yield>:
{
801037bb:	f3 0f 1e fb          	endbr32 
801037bf:	55                   	push   %ebp
801037c0:	89 e5                	mov    %esp,%ebp
801037c2:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801037c5:	68 20 2d 11 80       	push   $0x80112d20
801037ca:	e8 55 05 00 00       	call   80103d24 <acquire>
  myproc()->state = RUNNABLE;
801037cf:	e8 5a fb ff ff       	call   8010332e <myproc>
801037d4:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
801037db:	e8 6a fe ff ff       	call   8010364a <sched>
  release(&ptable.lock);
801037e0:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801037e7:	e8 a1 05 00 00       	call   80103d8d <release>
}
801037ec:	83 c4 10             	add    $0x10,%esp
801037ef:	c9                   	leave  
801037f0:	c3                   	ret    

801037f1 <sleep>:
{
801037f1:	f3 0f 1e fb          	endbr32 
801037f5:	55                   	push   %ebp
801037f6:	89 e5                	mov    %esp,%ebp
801037f8:	56                   	push   %esi
801037f9:	53                   	push   %ebx
801037fa:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct proc *p = myproc();
801037fd:	e8 2c fb ff ff       	call   8010332e <myproc>
  if(p == 0)
80103802:	85 c0                	test   %eax,%eax
80103804:	74 66                	je     8010386c <sleep+0x7b>
80103806:	89 c3                	mov    %eax,%ebx
  if(lk == 0)
80103808:	85 f6                	test   %esi,%esi
8010380a:	74 6d                	je     80103879 <sleep+0x88>
  if(lk != &ptable.lock){  //DOC: sleeplock0
8010380c:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103812:	74 18                	je     8010382c <sleep+0x3b>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103814:	83 ec 0c             	sub    $0xc,%esp
80103817:	68 20 2d 11 80       	push   $0x80112d20
8010381c:	e8 03 05 00 00       	call   80103d24 <acquire>
    release(lk);
80103821:	89 34 24             	mov    %esi,(%esp)
80103824:	e8 64 05 00 00       	call   80103d8d <release>
80103829:	83 c4 10             	add    $0x10,%esp
  p->chan = chan;
8010382c:	8b 45 08             	mov    0x8(%ebp),%eax
8010382f:	89 43 20             	mov    %eax,0x20(%ebx)
  p->state = SLEEPING;
80103832:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103839:	e8 0c fe ff ff       	call   8010364a <sched>
  p->chan = 0;
8010383e:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  if(lk != &ptable.lock){  //DOC: sleeplock2
80103845:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
8010384b:	74 18                	je     80103865 <sleep+0x74>
    release(&ptable.lock);
8010384d:	83 ec 0c             	sub    $0xc,%esp
80103850:	68 20 2d 11 80       	push   $0x80112d20
80103855:	e8 33 05 00 00       	call   80103d8d <release>
    acquire(lk);
8010385a:	89 34 24             	mov    %esi,(%esp)
8010385d:	e8 c2 04 00 00       	call   80103d24 <acquire>
80103862:	83 c4 10             	add    $0x10,%esp
}
80103865:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103868:	5b                   	pop    %ebx
80103869:	5e                   	pop    %esi
8010386a:	5d                   	pop    %ebp
8010386b:	c3                   	ret    
    panic("sleep");
8010386c:	83 ec 0c             	sub    $0xc,%esp
8010386f:	68 2c 6e 10 80       	push   $0x80106e2c
80103874:	e8 e3 ca ff ff       	call   8010035c <panic>
    panic("sleep without lk");
80103879:	83 ec 0c             	sub    $0xc,%esp
8010387c:	68 32 6e 10 80       	push   $0x80106e32
80103881:	e8 d6 ca ff ff       	call   8010035c <panic>

80103886 <wait>:
{
80103886:	f3 0f 1e fb          	endbr32 
8010388a:	55                   	push   %ebp
8010388b:	89 e5                	mov    %esp,%ebp
8010388d:	56                   	push   %esi
8010388e:	53                   	push   %ebx
  struct proc *curproc = myproc();
8010388f:	e8 9a fa ff ff       	call   8010332e <myproc>
80103894:	89 c6                	mov    %eax,%esi
  acquire(&ptable.lock);
80103896:	83 ec 0c             	sub    $0xc,%esp
80103899:	68 20 2d 11 80       	push   $0x80112d20
8010389e:	e8 81 04 00 00       	call   80103d24 <acquire>
801038a3:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801038a6:	b8 00 00 00 00       	mov    $0x0,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801038ab:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
801038b0:	eb 5b                	jmp    8010390d <wait+0x87>
        pid = p->pid;
801038b2:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801038b5:	83 ec 0c             	sub    $0xc,%esp
801038b8:	ff 73 08             	pushl  0x8(%ebx)
801038bb:	e8 6b e7 ff ff       	call   8010202b <kfree>
        p->kstack = 0;
801038c0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801038c7:	83 c4 04             	add    $0x4,%esp
801038ca:	ff 73 04             	pushl  0x4(%ebx)
801038cd:	e8 9c 2b 00 00       	call   8010646e <freevm>
        p->pid = 0;
801038d2:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801038d9:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801038e0:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801038e4:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801038eb:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801038f2:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801038f9:	e8 8f 04 00 00       	call   80103d8d <release>
        return pid;
801038fe:	83 c4 10             	add    $0x10,%esp
}
80103901:	89 f0                	mov    %esi,%eax
80103903:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103906:	5b                   	pop    %ebx
80103907:	5e                   	pop    %esi
80103908:	5d                   	pop    %ebp
80103909:	c3                   	ret    
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010390a:	83 c3 7c             	add    $0x7c,%ebx
8010390d:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103913:	73 12                	jae    80103927 <wait+0xa1>
      if(p->parent != curproc)
80103915:	39 73 14             	cmp    %esi,0x14(%ebx)
80103918:	75 f0                	jne    8010390a <wait+0x84>
      if(p->state == ZOMBIE){
8010391a:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010391e:	74 92                	je     801038b2 <wait+0x2c>
      havekids = 1;
80103920:	b8 01 00 00 00       	mov    $0x1,%eax
80103925:	eb e3                	jmp    8010390a <wait+0x84>
    if(!havekids || curproc->killed){
80103927:	85 c0                	test   %eax,%eax
80103929:	74 06                	je     80103931 <wait+0xab>
8010392b:	83 7e 24 00          	cmpl   $0x0,0x24(%esi)
8010392f:	74 17                	je     80103948 <wait+0xc2>
      release(&ptable.lock);
80103931:	83 ec 0c             	sub    $0xc,%esp
80103934:	68 20 2d 11 80       	push   $0x80112d20
80103939:	e8 4f 04 00 00       	call   80103d8d <release>
      return -1;
8010393e:	83 c4 10             	add    $0x10,%esp
80103941:	be ff ff ff ff       	mov    $0xffffffff,%esi
80103946:	eb b9                	jmp    80103901 <wait+0x7b>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103948:	83 ec 08             	sub    $0x8,%esp
8010394b:	68 20 2d 11 80       	push   $0x80112d20
80103950:	56                   	push   %esi
80103951:	e8 9b fe ff ff       	call   801037f1 <sleep>
    havekids = 0;
80103956:	83 c4 10             	add    $0x10,%esp
80103959:	e9 48 ff ff ff       	jmp    801038a6 <wait+0x20>

8010395e <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
8010395e:	f3 0f 1e fb          	endbr32 
80103962:	55                   	push   %ebp
80103963:	89 e5                	mov    %esp,%ebp
80103965:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);
80103968:	68 20 2d 11 80       	push   $0x80112d20
8010396d:	e8 b2 03 00 00       	call   80103d24 <acquire>
  wakeup1(chan);
80103972:	8b 45 08             	mov    0x8(%ebp),%eax
80103975:	e8 eb f7 ff ff       	call   80103165 <wakeup1>
  release(&ptable.lock);
8010397a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103981:	e8 07 04 00 00       	call   80103d8d <release>
}
80103986:	83 c4 10             	add    $0x10,%esp
80103989:	c9                   	leave  
8010398a:	c3                   	ret    

8010398b <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
8010398b:	f3 0f 1e fb          	endbr32 
8010398f:	55                   	push   %ebp
80103990:	89 e5                	mov    %esp,%ebp
80103992:	53                   	push   %ebx
80103993:	83 ec 10             	sub    $0x10,%esp
80103996:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103999:	68 20 2d 11 80       	push   $0x80112d20
8010399e:	e8 81 03 00 00       	call   80103d24 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039a3:	83 c4 10             	add    $0x10,%esp
801039a6:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801039ab:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
801039b0:	73 3a                	jae    801039ec <kill+0x61>
    if(p->pid == pid){
801039b2:	39 58 10             	cmp    %ebx,0x10(%eax)
801039b5:	74 05                	je     801039bc <kill+0x31>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039b7:	83 c0 7c             	add    $0x7c,%eax
801039ba:	eb ef                	jmp    801039ab <kill+0x20>
      p->killed = 1;
801039bc:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801039c3:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801039c7:	74 1a                	je     801039e3 <kill+0x58>
        p->state = RUNNABLE;
      release(&ptable.lock);
801039c9:	83 ec 0c             	sub    $0xc,%esp
801039cc:	68 20 2d 11 80       	push   $0x80112d20
801039d1:	e8 b7 03 00 00       	call   80103d8d <release>
      return 0;
801039d6:	83 c4 10             	add    $0x10,%esp
801039d9:	b8 00 00 00 00       	mov    $0x0,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
801039de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039e1:	c9                   	leave  
801039e2:	c3                   	ret    
        p->state = RUNNABLE;
801039e3:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801039ea:	eb dd                	jmp    801039c9 <kill+0x3e>
  release(&ptable.lock);
801039ec:	83 ec 0c             	sub    $0xc,%esp
801039ef:	68 20 2d 11 80       	push   $0x80112d20
801039f4:	e8 94 03 00 00       	call   80103d8d <release>
  return -1;
801039f9:	83 c4 10             	add    $0x10,%esp
801039fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a01:	eb db                	jmp    801039de <kill+0x53>

80103a03 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80103a03:	f3 0f 1e fb          	endbr32 
80103a07:	55                   	push   %ebp
80103a08:	89 e5                	mov    %esp,%ebp
80103a0a:	56                   	push   %esi
80103a0b:	53                   	push   %ebx
80103a0c:	83 ec 30             	sub    $0x30,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a0f:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103a14:	eb 33                	jmp    80103a49 <procdump+0x46>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
80103a16:	b8 43 6e 10 80       	mov    $0x80106e43,%eax
    cprintf("%d %s %s", p->pid, state, p->name);
80103a1b:	8d 53 6c             	lea    0x6c(%ebx),%edx
80103a1e:	52                   	push   %edx
80103a1f:	50                   	push   %eax
80103a20:	ff 73 10             	pushl  0x10(%ebx)
80103a23:	68 47 6e 10 80       	push   $0x80106e47
80103a28:	e8 fc cb ff ff       	call   80100629 <cprintf>
    if(p->state == SLEEPING){
80103a2d:	83 c4 10             	add    $0x10,%esp
80103a30:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80103a34:	74 39                	je     80103a6f <procdump+0x6c>
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80103a36:	83 ec 0c             	sub    $0xc,%esp
80103a39:	68 c3 71 10 80       	push   $0x801071c3
80103a3e:	e8 e6 cb ff ff       	call   80100629 <cprintf>
80103a43:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a46:	83 c3 7c             	add    $0x7c,%ebx
80103a49:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103a4f:	73 61                	jae    80103ab2 <procdump+0xaf>
    if(p->state == UNUSED)
80103a51:	8b 43 0c             	mov    0xc(%ebx),%eax
80103a54:	85 c0                	test   %eax,%eax
80103a56:	74 ee                	je     80103a46 <procdump+0x43>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103a58:	83 f8 05             	cmp    $0x5,%eax
80103a5b:	77 b9                	ja     80103a16 <procdump+0x13>
80103a5d:	8b 04 85 a4 6e 10 80 	mov    -0x7fef915c(,%eax,4),%eax
80103a64:	85 c0                	test   %eax,%eax
80103a66:	75 b3                	jne    80103a1b <procdump+0x18>
      state = "???";
80103a68:	b8 43 6e 10 80       	mov    $0x80106e43,%eax
80103a6d:	eb ac                	jmp    80103a1b <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80103a6f:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103a72:	8b 40 0c             	mov    0xc(%eax),%eax
80103a75:	83 c0 08             	add    $0x8,%eax
80103a78:	83 ec 08             	sub    $0x8,%esp
80103a7b:	8d 55 d0             	lea    -0x30(%ebp),%edx
80103a7e:	52                   	push   %edx
80103a7f:	50                   	push   %eax
80103a80:	e8 6e 01 00 00       	call   80103bf3 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80103a85:	83 c4 10             	add    $0x10,%esp
80103a88:	be 00 00 00 00       	mov    $0x0,%esi
80103a8d:	eb 14                	jmp    80103aa3 <procdump+0xa0>
        cprintf(" %p", pc[i]);
80103a8f:	83 ec 08             	sub    $0x8,%esp
80103a92:	50                   	push   %eax
80103a93:	68 e1 67 10 80       	push   $0x801067e1
80103a98:	e8 8c cb ff ff       	call   80100629 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80103a9d:	83 c6 01             	add    $0x1,%esi
80103aa0:	83 c4 10             	add    $0x10,%esp
80103aa3:	83 fe 09             	cmp    $0x9,%esi
80103aa6:	7f 8e                	jg     80103a36 <procdump+0x33>
80103aa8:	8b 44 b5 d0          	mov    -0x30(%ebp,%esi,4),%eax
80103aac:	85 c0                	test   %eax,%eax
80103aae:	75 df                	jne    80103a8f <procdump+0x8c>
80103ab0:	eb 84                	jmp    80103a36 <procdump+0x33>
  }
}
80103ab2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ab5:	5b                   	pop    %ebx
80103ab6:	5e                   	pop    %esi
80103ab7:	5d                   	pop    %ebp
80103ab8:	c3                   	ret    

80103ab9 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80103ab9:	f3 0f 1e fb          	endbr32 
80103abd:	55                   	push   %ebp
80103abe:	89 e5                	mov    %esp,%ebp
80103ac0:	53                   	push   %ebx
80103ac1:	83 ec 0c             	sub    $0xc,%esp
80103ac4:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80103ac7:	68 bc 6e 10 80       	push   $0x80106ebc
80103acc:	8d 43 04             	lea    0x4(%ebx),%eax
80103acf:	50                   	push   %eax
80103ad0:	e8 ff 00 00 00       	call   80103bd4 <initlock>
  lk->name = name;
80103ad5:	8b 45 0c             	mov    0xc(%ebp),%eax
80103ad8:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
80103adb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103ae1:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
}
80103ae8:	83 c4 10             	add    $0x10,%esp
80103aeb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103aee:	c9                   	leave  
80103aef:	c3                   	ret    

80103af0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80103af0:	f3 0f 1e fb          	endbr32 
80103af4:	55                   	push   %ebp
80103af5:	89 e5                	mov    %esp,%ebp
80103af7:	56                   	push   %esi
80103af8:	53                   	push   %ebx
80103af9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103afc:	8d 73 04             	lea    0x4(%ebx),%esi
80103aff:	83 ec 0c             	sub    $0xc,%esp
80103b02:	56                   	push   %esi
80103b03:	e8 1c 02 00 00       	call   80103d24 <acquire>
  while (lk->locked) {
80103b08:	83 c4 10             	add    $0x10,%esp
80103b0b:	83 3b 00             	cmpl   $0x0,(%ebx)
80103b0e:	74 0f                	je     80103b1f <acquiresleep+0x2f>
    sleep(lk, &lk->lk);
80103b10:	83 ec 08             	sub    $0x8,%esp
80103b13:	56                   	push   %esi
80103b14:	53                   	push   %ebx
80103b15:	e8 d7 fc ff ff       	call   801037f1 <sleep>
80103b1a:	83 c4 10             	add    $0x10,%esp
80103b1d:	eb ec                	jmp    80103b0b <acquiresleep+0x1b>
  }
  lk->locked = 1;
80103b1f:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80103b25:	e8 04 f8 ff ff       	call   8010332e <myproc>
80103b2a:	8b 40 10             	mov    0x10(%eax),%eax
80103b2d:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80103b30:	83 ec 0c             	sub    $0xc,%esp
80103b33:	56                   	push   %esi
80103b34:	e8 54 02 00 00       	call   80103d8d <release>
}
80103b39:	83 c4 10             	add    $0x10,%esp
80103b3c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b3f:	5b                   	pop    %ebx
80103b40:	5e                   	pop    %esi
80103b41:	5d                   	pop    %ebp
80103b42:	c3                   	ret    

80103b43 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80103b43:	f3 0f 1e fb          	endbr32 
80103b47:	55                   	push   %ebp
80103b48:	89 e5                	mov    %esp,%ebp
80103b4a:	56                   	push   %esi
80103b4b:	53                   	push   %ebx
80103b4c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103b4f:	8d 73 04             	lea    0x4(%ebx),%esi
80103b52:	83 ec 0c             	sub    $0xc,%esp
80103b55:	56                   	push   %esi
80103b56:	e8 c9 01 00 00       	call   80103d24 <acquire>
  lk->locked = 0;
80103b5b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103b61:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80103b68:	89 1c 24             	mov    %ebx,(%esp)
80103b6b:	e8 ee fd ff ff       	call   8010395e <wakeup>
  release(&lk->lk);
80103b70:	89 34 24             	mov    %esi,(%esp)
80103b73:	e8 15 02 00 00       	call   80103d8d <release>
}
80103b78:	83 c4 10             	add    $0x10,%esp
80103b7b:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b7e:	5b                   	pop    %ebx
80103b7f:	5e                   	pop    %esi
80103b80:	5d                   	pop    %ebp
80103b81:	c3                   	ret    

80103b82 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80103b82:	f3 0f 1e fb          	endbr32 
80103b86:	55                   	push   %ebp
80103b87:	89 e5                	mov    %esp,%ebp
80103b89:	56                   	push   %esi
80103b8a:	53                   	push   %ebx
80103b8b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80103b8e:	8d 73 04             	lea    0x4(%ebx),%esi
80103b91:	83 ec 0c             	sub    $0xc,%esp
80103b94:	56                   	push   %esi
80103b95:	e8 8a 01 00 00       	call   80103d24 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80103b9a:	83 c4 10             	add    $0x10,%esp
80103b9d:	83 3b 00             	cmpl   $0x0,(%ebx)
80103ba0:	75 17                	jne    80103bb9 <holdingsleep+0x37>
80103ba2:	bb 00 00 00 00       	mov    $0x0,%ebx
  release(&lk->lk);
80103ba7:	83 ec 0c             	sub    $0xc,%esp
80103baa:	56                   	push   %esi
80103bab:	e8 dd 01 00 00       	call   80103d8d <release>
  return r;
}
80103bb0:	89 d8                	mov    %ebx,%eax
80103bb2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103bb5:	5b                   	pop    %ebx
80103bb6:	5e                   	pop    %esi
80103bb7:	5d                   	pop    %ebp
80103bb8:	c3                   	ret    
  r = lk->locked && (lk->pid == myproc()->pid);
80103bb9:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80103bbc:	e8 6d f7 ff ff       	call   8010332e <myproc>
80103bc1:	3b 58 10             	cmp    0x10(%eax),%ebx
80103bc4:	74 07                	je     80103bcd <holdingsleep+0x4b>
80103bc6:	bb 00 00 00 00       	mov    $0x0,%ebx
80103bcb:	eb da                	jmp    80103ba7 <holdingsleep+0x25>
80103bcd:	bb 01 00 00 00       	mov    $0x1,%ebx
80103bd2:	eb d3                	jmp    80103ba7 <holdingsleep+0x25>

80103bd4 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80103bd4:	f3 0f 1e fb          	endbr32 
80103bd8:	55                   	push   %ebp
80103bd9:	89 e5                	mov    %esp,%ebp
80103bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80103bde:	8b 55 0c             	mov    0xc(%ebp),%edx
80103be1:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80103be4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80103bea:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80103bf1:	5d                   	pop    %ebp
80103bf2:	c3                   	ret    

80103bf3 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80103bf3:	f3 0f 1e fb          	endbr32 
80103bf7:	55                   	push   %ebp
80103bf8:	89 e5                	mov    %esp,%ebp
80103bfa:	53                   	push   %ebx
80103bfb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80103bfe:	8b 45 08             	mov    0x8(%ebp),%eax
80103c01:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
80103c04:	b8 00 00 00 00       	mov    $0x0,%eax
80103c09:	83 f8 09             	cmp    $0x9,%eax
80103c0c:	7f 25                	jg     80103c33 <getcallerpcs+0x40>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80103c0e:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80103c14:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80103c1a:	77 17                	ja     80103c33 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
80103c1c:	8b 5a 04             	mov    0x4(%edx),%ebx
80103c1f:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
    ebp = (uint*)ebp[0]; // saved %ebp
80103c22:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80103c24:	83 c0 01             	add    $0x1,%eax
80103c27:	eb e0                	jmp    80103c09 <getcallerpcs+0x16>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80103c29:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
80103c30:	83 c0 01             	add    $0x1,%eax
80103c33:	83 f8 09             	cmp    $0x9,%eax
80103c36:	7e f1                	jle    80103c29 <getcallerpcs+0x36>
}
80103c38:	5b                   	pop    %ebx
80103c39:	5d                   	pop    %ebp
80103c3a:	c3                   	ret    

80103c3b <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80103c3b:	f3 0f 1e fb          	endbr32 
80103c3f:	55                   	push   %ebp
80103c40:	89 e5                	mov    %esp,%ebp
80103c42:	53                   	push   %ebx
80103c43:	83 ec 04             	sub    $0x4,%esp
80103c46:	9c                   	pushf  
80103c47:	5b                   	pop    %ebx
  asm volatile("cli");
80103c48:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80103c49:	e8 61 f6 ff ff       	call   801032af <mycpu>
80103c4e:	83 b8 a4 00 00 00 00 	cmpl   $0x0,0xa4(%eax)
80103c55:	74 12                	je     80103c69 <pushcli+0x2e>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80103c57:	e8 53 f6 ff ff       	call   801032af <mycpu>
80103c5c:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80103c63:	83 c4 04             	add    $0x4,%esp
80103c66:	5b                   	pop    %ebx
80103c67:	5d                   	pop    %ebp
80103c68:	c3                   	ret    
    mycpu()->intena = eflags & FL_IF;
80103c69:	e8 41 f6 ff ff       	call   801032af <mycpu>
80103c6e:	81 e3 00 02 00 00    	and    $0x200,%ebx
80103c74:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80103c7a:	eb db                	jmp    80103c57 <pushcli+0x1c>

80103c7c <popcli>:

void
popcli(void)
{
80103c7c:	f3 0f 1e fb          	endbr32 
80103c80:	55                   	push   %ebp
80103c81:	89 e5                	mov    %esp,%ebp
80103c83:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103c86:	9c                   	pushf  
80103c87:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103c88:	f6 c4 02             	test   $0x2,%ah
80103c8b:	75 28                	jne    80103cb5 <popcli+0x39>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80103c8d:	e8 1d f6 ff ff       	call   801032af <mycpu>
80103c92:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80103c98:	8d 51 ff             	lea    -0x1(%ecx),%edx
80103c9b:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80103ca1:	85 d2                	test   %edx,%edx
80103ca3:	78 1d                	js     80103cc2 <popcli+0x46>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80103ca5:	e8 05 f6 ff ff       	call   801032af <mycpu>
80103caa:	83 b8 a4 00 00 00 00 	cmpl   $0x0,0xa4(%eax)
80103cb1:	74 1c                	je     80103ccf <popcli+0x53>
    sti();
}
80103cb3:	c9                   	leave  
80103cb4:	c3                   	ret    
    panic("popcli - interruptible");
80103cb5:	83 ec 0c             	sub    $0xc,%esp
80103cb8:	68 c7 6e 10 80       	push   $0x80106ec7
80103cbd:	e8 9a c6 ff ff       	call   8010035c <panic>
    panic("popcli");
80103cc2:	83 ec 0c             	sub    $0xc,%esp
80103cc5:	68 de 6e 10 80       	push   $0x80106ede
80103cca:	e8 8d c6 ff ff       	call   8010035c <panic>
  if(mycpu()->ncli == 0 && mycpu()->intena)
80103ccf:	e8 db f5 ff ff       	call   801032af <mycpu>
80103cd4:	83 b8 a8 00 00 00 00 	cmpl   $0x0,0xa8(%eax)
80103cdb:	74 d6                	je     80103cb3 <popcli+0x37>
  asm volatile("sti");
80103cdd:	fb                   	sti    
}
80103cde:	eb d3                	jmp    80103cb3 <popcli+0x37>

80103ce0 <holding>:
{
80103ce0:	f3 0f 1e fb          	endbr32 
80103ce4:	55                   	push   %ebp
80103ce5:	89 e5                	mov    %esp,%ebp
80103ce7:	53                   	push   %ebx
80103ce8:	83 ec 04             	sub    $0x4,%esp
80103ceb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80103cee:	e8 48 ff ff ff       	call   80103c3b <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80103cf3:	83 3b 00             	cmpl   $0x0,(%ebx)
80103cf6:	75 12                	jne    80103d0a <holding+0x2a>
80103cf8:	bb 00 00 00 00       	mov    $0x0,%ebx
  popcli();
80103cfd:	e8 7a ff ff ff       	call   80103c7c <popcli>
}
80103d02:	89 d8                	mov    %ebx,%eax
80103d04:	83 c4 04             	add    $0x4,%esp
80103d07:	5b                   	pop    %ebx
80103d08:	5d                   	pop    %ebp
80103d09:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80103d0a:	8b 5b 08             	mov    0x8(%ebx),%ebx
80103d0d:	e8 9d f5 ff ff       	call   801032af <mycpu>
80103d12:	39 c3                	cmp    %eax,%ebx
80103d14:	74 07                	je     80103d1d <holding+0x3d>
80103d16:	bb 00 00 00 00       	mov    $0x0,%ebx
80103d1b:	eb e0                	jmp    80103cfd <holding+0x1d>
80103d1d:	bb 01 00 00 00       	mov    $0x1,%ebx
80103d22:	eb d9                	jmp    80103cfd <holding+0x1d>

80103d24 <acquire>:
{
80103d24:	f3 0f 1e fb          	endbr32 
80103d28:	55                   	push   %ebp
80103d29:	89 e5                	mov    %esp,%ebp
80103d2b:	53                   	push   %ebx
80103d2c:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80103d2f:	e8 07 ff ff ff       	call   80103c3b <pushcli>
  if(holding(lk))
80103d34:	83 ec 0c             	sub    $0xc,%esp
80103d37:	ff 75 08             	pushl  0x8(%ebp)
80103d3a:	e8 a1 ff ff ff       	call   80103ce0 <holding>
80103d3f:	83 c4 10             	add    $0x10,%esp
80103d42:	85 c0                	test   %eax,%eax
80103d44:	75 3a                	jne    80103d80 <acquire+0x5c>
  while(xchg(&lk->locked, 1) != 0)
80103d46:	8b 55 08             	mov    0x8(%ebp),%edx
  asm volatile("lock; xchgl %0, %1" :
80103d49:	b8 01 00 00 00       	mov    $0x1,%eax
80103d4e:	f0 87 02             	lock xchg %eax,(%edx)
80103d51:	85 c0                	test   %eax,%eax
80103d53:	75 f1                	jne    80103d46 <acquire+0x22>
  __sync_synchronize();
80103d55:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80103d5a:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103d5d:	e8 4d f5 ff ff       	call   801032af <mycpu>
80103d62:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
80103d65:	8b 45 08             	mov    0x8(%ebp),%eax
80103d68:	83 c0 0c             	add    $0xc,%eax
80103d6b:	83 ec 08             	sub    $0x8,%esp
80103d6e:	50                   	push   %eax
80103d6f:	8d 45 08             	lea    0x8(%ebp),%eax
80103d72:	50                   	push   %eax
80103d73:	e8 7b fe ff ff       	call   80103bf3 <getcallerpcs>
}
80103d78:	83 c4 10             	add    $0x10,%esp
80103d7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d7e:	c9                   	leave  
80103d7f:	c3                   	ret    
    panic("acquire");
80103d80:	83 ec 0c             	sub    $0xc,%esp
80103d83:	68 e5 6e 10 80       	push   $0x80106ee5
80103d88:	e8 cf c5 ff ff       	call   8010035c <panic>

80103d8d <release>:
{
80103d8d:	f3 0f 1e fb          	endbr32 
80103d91:	55                   	push   %ebp
80103d92:	89 e5                	mov    %esp,%ebp
80103d94:	53                   	push   %ebx
80103d95:	83 ec 10             	sub    $0x10,%esp
80103d98:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80103d9b:	53                   	push   %ebx
80103d9c:	e8 3f ff ff ff       	call   80103ce0 <holding>
80103da1:	83 c4 10             	add    $0x10,%esp
80103da4:	85 c0                	test   %eax,%eax
80103da6:	74 23                	je     80103dcb <release+0x3e>
  lk->pcs[0] = 0;
80103da8:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80103daf:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80103db6:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80103dbb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  popcli();
80103dc1:	e8 b6 fe ff ff       	call   80103c7c <popcli>
}
80103dc6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103dc9:	c9                   	leave  
80103dca:	c3                   	ret    
    panic("release");
80103dcb:	83 ec 0c             	sub    $0xc,%esp
80103dce:	68 ed 6e 10 80       	push   $0x80106eed
80103dd3:	e8 84 c5 ff ff       	call   8010035c <panic>

80103dd8 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80103dd8:	f3 0f 1e fb          	endbr32 
80103ddc:	55                   	push   %ebp
80103ddd:	89 e5                	mov    %esp,%ebp
80103ddf:	57                   	push   %edi
80103de0:	53                   	push   %ebx
80103de1:	8b 55 08             	mov    0x8(%ebp),%edx
80103de4:	8b 45 0c             	mov    0xc(%ebp),%eax
80103de7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80103dea:	f6 c2 03             	test   $0x3,%dl
80103ded:	75 25                	jne    80103e14 <memset+0x3c>
80103def:	f6 c1 03             	test   $0x3,%cl
80103df2:	75 20                	jne    80103e14 <memset+0x3c>
    c &= 0xFF;
80103df4:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80103df7:	c1 e9 02             	shr    $0x2,%ecx
80103dfa:	c1 e0 18             	shl    $0x18,%eax
80103dfd:	89 fb                	mov    %edi,%ebx
80103dff:	c1 e3 10             	shl    $0x10,%ebx
80103e02:	09 d8                	or     %ebx,%eax
80103e04:	89 fb                	mov    %edi,%ebx
80103e06:	c1 e3 08             	shl    $0x8,%ebx
80103e09:	09 d8                	or     %ebx,%eax
80103e0b:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80103e0d:	89 d7                	mov    %edx,%edi
80103e0f:	fc                   	cld    
80103e10:	f3 ab                	rep stos %eax,%es:(%edi)
}
80103e12:	eb 05                	jmp    80103e19 <memset+0x41>
  asm volatile("cld; rep stosb" :
80103e14:	89 d7                	mov    %edx,%edi
80103e16:	fc                   	cld    
80103e17:	f3 aa                	rep stos %al,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80103e19:	89 d0                	mov    %edx,%eax
80103e1b:	5b                   	pop    %ebx
80103e1c:	5f                   	pop    %edi
80103e1d:	5d                   	pop    %ebp
80103e1e:	c3                   	ret    

80103e1f <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80103e1f:	f3 0f 1e fb          	endbr32 
80103e23:	55                   	push   %ebp
80103e24:	89 e5                	mov    %esp,%ebp
80103e26:	56                   	push   %esi
80103e27:	53                   	push   %ebx
80103e28:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103e2b:	8b 55 0c             	mov    0xc(%ebp),%edx
80103e2e:	8b 45 10             	mov    0x10(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80103e31:	8d 70 ff             	lea    -0x1(%eax),%esi
80103e34:	85 c0                	test   %eax,%eax
80103e36:	74 1c                	je     80103e54 <memcmp+0x35>
    if(*s1 != *s2)
80103e38:	0f b6 01             	movzbl (%ecx),%eax
80103e3b:	0f b6 1a             	movzbl (%edx),%ebx
80103e3e:	38 d8                	cmp    %bl,%al
80103e40:	75 0a                	jne    80103e4c <memcmp+0x2d>
      return *s1 - *s2;
    s1++, s2++;
80103e42:	83 c1 01             	add    $0x1,%ecx
80103e45:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80103e48:	89 f0                	mov    %esi,%eax
80103e4a:	eb e5                	jmp    80103e31 <memcmp+0x12>
      return *s1 - *s2;
80103e4c:	0f b6 c0             	movzbl %al,%eax
80103e4f:	0f b6 db             	movzbl %bl,%ebx
80103e52:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80103e54:	5b                   	pop    %ebx
80103e55:	5e                   	pop    %esi
80103e56:	5d                   	pop    %ebp
80103e57:	c3                   	ret    

80103e58 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80103e58:	f3 0f 1e fb          	endbr32 
80103e5c:	55                   	push   %ebp
80103e5d:	89 e5                	mov    %esp,%ebp
80103e5f:	56                   	push   %esi
80103e60:	53                   	push   %ebx
80103e61:	8b 75 08             	mov    0x8(%ebp),%esi
80103e64:	8b 55 0c             	mov    0xc(%ebp),%edx
80103e67:	8b 45 10             	mov    0x10(%ebp),%eax
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80103e6a:	39 f2                	cmp    %esi,%edx
80103e6c:	73 3a                	jae    80103ea8 <memmove+0x50>
80103e6e:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80103e71:	39 f1                	cmp    %esi,%ecx
80103e73:	76 37                	jbe    80103eac <memmove+0x54>
    s += n;
    d += n;
80103e75:	8d 14 06             	lea    (%esi,%eax,1),%edx
    while(n-- > 0)
80103e78:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103e7b:	85 c0                	test   %eax,%eax
80103e7d:	74 23                	je     80103ea2 <memmove+0x4a>
      *--d = *--s;
80103e7f:	83 e9 01             	sub    $0x1,%ecx
80103e82:	83 ea 01             	sub    $0x1,%edx
80103e85:	0f b6 01             	movzbl (%ecx),%eax
80103e88:	88 02                	mov    %al,(%edx)
    while(n-- > 0)
80103e8a:	89 d8                	mov    %ebx,%eax
80103e8c:	eb ea                	jmp    80103e78 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;
80103e8e:	0f b6 02             	movzbl (%edx),%eax
80103e91:	88 01                	mov    %al,(%ecx)
80103e93:	8d 49 01             	lea    0x1(%ecx),%ecx
80103e96:	8d 52 01             	lea    0x1(%edx),%edx
    while(n-- > 0)
80103e99:	89 d8                	mov    %ebx,%eax
80103e9b:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103e9e:	85 c0                	test   %eax,%eax
80103ea0:	75 ec                	jne    80103e8e <memmove+0x36>

  return dst;
}
80103ea2:	89 f0                	mov    %esi,%eax
80103ea4:	5b                   	pop    %ebx
80103ea5:	5e                   	pop    %esi
80103ea6:	5d                   	pop    %ebp
80103ea7:	c3                   	ret    
80103ea8:	89 f1                	mov    %esi,%ecx
80103eaa:	eb ef                	jmp    80103e9b <memmove+0x43>
80103eac:	89 f1                	mov    %esi,%ecx
80103eae:	eb eb                	jmp    80103e9b <memmove+0x43>

80103eb0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80103eb0:	f3 0f 1e fb          	endbr32 
80103eb4:	55                   	push   %ebp
80103eb5:	89 e5                	mov    %esp,%ebp
80103eb7:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
80103eba:	ff 75 10             	pushl  0x10(%ebp)
80103ebd:	ff 75 0c             	pushl  0xc(%ebp)
80103ec0:	ff 75 08             	pushl  0x8(%ebp)
80103ec3:	e8 90 ff ff ff       	call   80103e58 <memmove>
}
80103ec8:	c9                   	leave  
80103ec9:	c3                   	ret    

80103eca <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80103eca:	f3 0f 1e fb          	endbr32 
80103ece:	55                   	push   %ebp
80103ecf:	89 e5                	mov    %esp,%ebp
80103ed1:	53                   	push   %ebx
80103ed2:	8b 55 08             	mov    0x8(%ebp),%edx
80103ed5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103ed8:	8b 45 10             	mov    0x10(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80103edb:	eb 09                	jmp    80103ee6 <strncmp+0x1c>
    n--, p++, q++;
80103edd:	83 e8 01             	sub    $0x1,%eax
80103ee0:	83 c2 01             	add    $0x1,%edx
80103ee3:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80103ee6:	85 c0                	test   %eax,%eax
80103ee8:	74 0b                	je     80103ef5 <strncmp+0x2b>
80103eea:	0f b6 1a             	movzbl (%edx),%ebx
80103eed:	84 db                	test   %bl,%bl
80103eef:	74 04                	je     80103ef5 <strncmp+0x2b>
80103ef1:	3a 19                	cmp    (%ecx),%bl
80103ef3:	74 e8                	je     80103edd <strncmp+0x13>
  if(n == 0)
80103ef5:	85 c0                	test   %eax,%eax
80103ef7:	74 0b                	je     80103f04 <strncmp+0x3a>
    return 0;
  return (uchar)*p - (uchar)*q;
80103ef9:	0f b6 02             	movzbl (%edx),%eax
80103efc:	0f b6 11             	movzbl (%ecx),%edx
80103eff:	29 d0                	sub    %edx,%eax
}
80103f01:	5b                   	pop    %ebx
80103f02:	5d                   	pop    %ebp
80103f03:	c3                   	ret    
    return 0;
80103f04:	b8 00 00 00 00       	mov    $0x0,%eax
80103f09:	eb f6                	jmp    80103f01 <strncmp+0x37>

80103f0b <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80103f0b:	f3 0f 1e fb          	endbr32 
80103f0f:	55                   	push   %ebp
80103f10:	89 e5                	mov    %esp,%ebp
80103f12:	57                   	push   %edi
80103f13:	56                   	push   %esi
80103f14:	53                   	push   %ebx
80103f15:	8b 7d 08             	mov    0x8(%ebp),%edi
80103f18:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103f1b:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80103f1e:	89 fa                	mov    %edi,%edx
80103f20:	eb 04                	jmp    80103f26 <strncpy+0x1b>
80103f22:	89 f1                	mov    %esi,%ecx
80103f24:	89 da                	mov    %ebx,%edx
80103f26:	89 c3                	mov    %eax,%ebx
80103f28:	83 e8 01             	sub    $0x1,%eax
80103f2b:	85 db                	test   %ebx,%ebx
80103f2d:	7e 1b                	jle    80103f4a <strncpy+0x3f>
80103f2f:	8d 71 01             	lea    0x1(%ecx),%esi
80103f32:	8d 5a 01             	lea    0x1(%edx),%ebx
80103f35:	0f b6 09             	movzbl (%ecx),%ecx
80103f38:	88 0a                	mov    %cl,(%edx)
80103f3a:	84 c9                	test   %cl,%cl
80103f3c:	75 e4                	jne    80103f22 <strncpy+0x17>
80103f3e:	89 da                	mov    %ebx,%edx
80103f40:	eb 08                	jmp    80103f4a <strncpy+0x3f>
    ;
  while(n-- > 0)
    *s++ = 0;
80103f42:	c6 02 00             	movb   $0x0,(%edx)
  while(n-- > 0)
80103f45:	89 c8                	mov    %ecx,%eax
    *s++ = 0;
80103f47:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
80103f4a:	8d 48 ff             	lea    -0x1(%eax),%ecx
80103f4d:	85 c0                	test   %eax,%eax
80103f4f:	7f f1                	jg     80103f42 <strncpy+0x37>
  return os;
}
80103f51:	89 f8                	mov    %edi,%eax
80103f53:	5b                   	pop    %ebx
80103f54:	5e                   	pop    %esi
80103f55:	5f                   	pop    %edi
80103f56:	5d                   	pop    %ebp
80103f57:	c3                   	ret    

80103f58 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80103f58:	f3 0f 1e fb          	endbr32 
80103f5c:	55                   	push   %ebp
80103f5d:	89 e5                	mov    %esp,%ebp
80103f5f:	57                   	push   %edi
80103f60:	56                   	push   %esi
80103f61:	53                   	push   %ebx
80103f62:	8b 7d 08             	mov    0x8(%ebp),%edi
80103f65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103f68:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80103f6b:	85 c0                	test   %eax,%eax
80103f6d:	7e 23                	jle    80103f92 <safestrcpy+0x3a>
80103f6f:	89 fa                	mov    %edi,%edx
80103f71:	eb 04                	jmp    80103f77 <safestrcpy+0x1f>
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80103f73:	89 f1                	mov    %esi,%ecx
80103f75:	89 da                	mov    %ebx,%edx
80103f77:	83 e8 01             	sub    $0x1,%eax
80103f7a:	85 c0                	test   %eax,%eax
80103f7c:	7e 11                	jle    80103f8f <safestrcpy+0x37>
80103f7e:	8d 71 01             	lea    0x1(%ecx),%esi
80103f81:	8d 5a 01             	lea    0x1(%edx),%ebx
80103f84:	0f b6 09             	movzbl (%ecx),%ecx
80103f87:	88 0a                	mov    %cl,(%edx)
80103f89:	84 c9                	test   %cl,%cl
80103f8b:	75 e6                	jne    80103f73 <safestrcpy+0x1b>
80103f8d:	89 da                	mov    %ebx,%edx
    ;
  *s = 0;
80103f8f:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80103f92:	89 f8                	mov    %edi,%eax
80103f94:	5b                   	pop    %ebx
80103f95:	5e                   	pop    %esi
80103f96:	5f                   	pop    %edi
80103f97:	5d                   	pop    %ebp
80103f98:	c3                   	ret    

80103f99 <strlen>:

int
strlen(const char *s)
{
80103f99:	f3 0f 1e fb          	endbr32 
80103f9d:	55                   	push   %ebp
80103f9e:	89 e5                	mov    %esp,%ebp
80103fa0:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80103fa3:	b8 00 00 00 00       	mov    $0x0,%eax
80103fa8:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80103fac:	74 05                	je     80103fb3 <strlen+0x1a>
80103fae:	83 c0 01             	add    $0x1,%eax
80103fb1:	eb f5                	jmp    80103fa8 <strlen+0xf>
    ;
  return n;
}
80103fb3:	5d                   	pop    %ebp
80103fb4:	c3                   	ret    

80103fb5 <swtch>:
80103fb5:	8b 44 24 04          	mov    0x4(%esp),%eax
80103fb9:	8b 54 24 08          	mov    0x8(%esp),%edx
80103fbd:	55                   	push   %ebp
80103fbe:	53                   	push   %ebx
80103fbf:	56                   	push   %esi
80103fc0:	57                   	push   %edi
80103fc1:	89 20                	mov    %esp,(%eax)
80103fc3:	89 d4                	mov    %edx,%esp
80103fc5:	5f                   	pop    %edi
80103fc6:	5e                   	pop    %esi
80103fc7:	5b                   	pop    %ebx
80103fc8:	5d                   	pop    %ebp
80103fc9:	c3                   	ret    

80103fca <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80103fca:	f3 0f 1e fb          	endbr32 
80103fce:	55                   	push   %ebp
80103fcf:	89 e5                	mov    %esp,%ebp
80103fd1:	53                   	push   %ebx
80103fd2:	83 ec 04             	sub    $0x4,%esp
80103fd5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80103fd8:	e8 51 f3 ff ff       	call   8010332e <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80103fdd:	8b 00                	mov    (%eax),%eax
80103fdf:	39 d8                	cmp    %ebx,%eax
80103fe1:	76 19                	jbe    80103ffc <fetchint+0x32>
80103fe3:	8d 53 04             	lea    0x4(%ebx),%edx
80103fe6:	39 d0                	cmp    %edx,%eax
80103fe8:	72 19                	jb     80104003 <fetchint+0x39>
    return -1;
  *ip = *(int*)(addr);
80103fea:	8b 13                	mov    (%ebx),%edx
80103fec:	8b 45 0c             	mov    0xc(%ebp),%eax
80103fef:	89 10                	mov    %edx,(%eax)
  return 0;
80103ff1:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103ff6:	83 c4 04             	add    $0x4,%esp
80103ff9:	5b                   	pop    %ebx
80103ffa:	5d                   	pop    %ebp
80103ffb:	c3                   	ret    
    return -1;
80103ffc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104001:	eb f3                	jmp    80103ff6 <fetchint+0x2c>
80104003:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104008:	eb ec                	jmp    80103ff6 <fetchint+0x2c>

8010400a <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
8010400a:	f3 0f 1e fb          	endbr32 
8010400e:	55                   	push   %ebp
8010400f:	89 e5                	mov    %esp,%ebp
80104011:	53                   	push   %ebx
80104012:	83 ec 04             	sub    $0x4,%esp
80104015:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104018:	e8 11 f3 ff ff       	call   8010332e <myproc>

  if(addr >= curproc->sz)
8010401d:	39 18                	cmp    %ebx,(%eax)
8010401f:	76 26                	jbe    80104047 <fetchstr+0x3d>
    return -1;
  *pp = (char*)addr;
80104021:	8b 55 0c             	mov    0xc(%ebp),%edx
80104024:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104026:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104028:	89 d8                	mov    %ebx,%eax
8010402a:	39 d0                	cmp    %edx,%eax
8010402c:	73 0e                	jae    8010403c <fetchstr+0x32>
    if(*s == 0)
8010402e:	80 38 00             	cmpb   $0x0,(%eax)
80104031:	74 05                	je     80104038 <fetchstr+0x2e>
  for(s = *pp; s < ep; s++){
80104033:	83 c0 01             	add    $0x1,%eax
80104036:	eb f2                	jmp    8010402a <fetchstr+0x20>
      return s - *pp;
80104038:	29 d8                	sub    %ebx,%eax
8010403a:	eb 05                	jmp    80104041 <fetchstr+0x37>
  }
  return -1;
8010403c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104041:	83 c4 04             	add    $0x4,%esp
80104044:	5b                   	pop    %ebx
80104045:	5d                   	pop    %ebp
80104046:	c3                   	ret    
    return -1;
80104047:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010404c:	eb f3                	jmp    80104041 <fetchstr+0x37>

8010404e <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
8010404e:	f3 0f 1e fb          	endbr32 
80104052:	55                   	push   %ebp
80104053:	89 e5                	mov    %esp,%ebp
80104055:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104058:	e8 d1 f2 ff ff       	call   8010332e <myproc>
8010405d:	8b 50 18             	mov    0x18(%eax),%edx
80104060:	8b 45 08             	mov    0x8(%ebp),%eax
80104063:	c1 e0 02             	shl    $0x2,%eax
80104066:	03 42 44             	add    0x44(%edx),%eax
80104069:	83 ec 08             	sub    $0x8,%esp
8010406c:	ff 75 0c             	pushl  0xc(%ebp)
8010406f:	83 c0 04             	add    $0x4,%eax
80104072:	50                   	push   %eax
80104073:	e8 52 ff ff ff       	call   80103fca <fetchint>
}
80104078:	c9                   	leave  
80104079:	c3                   	ret    

8010407a <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
8010407a:	f3 0f 1e fb          	endbr32 
8010407e:	55                   	push   %ebp
8010407f:	89 e5                	mov    %esp,%ebp
80104081:	56                   	push   %esi
80104082:	53                   	push   %ebx
80104083:	83 ec 10             	sub    $0x10,%esp
80104086:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104089:	e8 a0 f2 ff ff       	call   8010332e <myproc>
8010408e:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104090:	83 ec 08             	sub    $0x8,%esp
80104093:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104096:	50                   	push   %eax
80104097:	ff 75 08             	pushl  0x8(%ebp)
8010409a:	e8 af ff ff ff       	call   8010404e <argint>
8010409f:	83 c4 10             	add    $0x10,%esp
801040a2:	85 c0                	test   %eax,%eax
801040a4:	78 24                	js     801040ca <argptr+0x50>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801040a6:	85 db                	test   %ebx,%ebx
801040a8:	78 27                	js     801040d1 <argptr+0x57>
801040aa:	8b 16                	mov    (%esi),%edx
801040ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040af:	39 c2                	cmp    %eax,%edx
801040b1:	76 25                	jbe    801040d8 <argptr+0x5e>
801040b3:	01 c3                	add    %eax,%ebx
801040b5:	39 da                	cmp    %ebx,%edx
801040b7:	72 26                	jb     801040df <argptr+0x65>
    return -1;
  *pp = (char*)i;
801040b9:	8b 55 0c             	mov    0xc(%ebp),%edx
801040bc:	89 02                	mov    %eax,(%edx)
  return 0;
801040be:	b8 00 00 00 00       	mov    $0x0,%eax
}
801040c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801040c6:	5b                   	pop    %ebx
801040c7:	5e                   	pop    %esi
801040c8:	5d                   	pop    %ebp
801040c9:	c3                   	ret    
    return -1;
801040ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801040cf:	eb f2                	jmp    801040c3 <argptr+0x49>
    return -1;
801040d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801040d6:	eb eb                	jmp    801040c3 <argptr+0x49>
801040d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801040dd:	eb e4                	jmp    801040c3 <argptr+0x49>
801040df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801040e4:	eb dd                	jmp    801040c3 <argptr+0x49>

801040e6 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801040e6:	f3 0f 1e fb          	endbr32 
801040ea:	55                   	push   %ebp
801040eb:	89 e5                	mov    %esp,%ebp
801040ed:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
801040f0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801040f3:	50                   	push   %eax
801040f4:	ff 75 08             	pushl  0x8(%ebp)
801040f7:	e8 52 ff ff ff       	call   8010404e <argint>
801040fc:	83 c4 10             	add    $0x10,%esp
801040ff:	85 c0                	test   %eax,%eax
80104101:	78 13                	js     80104116 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104103:	83 ec 08             	sub    $0x8,%esp
80104106:	ff 75 0c             	pushl  0xc(%ebp)
80104109:	ff 75 f4             	pushl  -0xc(%ebp)
8010410c:	e8 f9 fe ff ff       	call   8010400a <fetchstr>
80104111:	83 c4 10             	add    $0x10,%esp
}
80104114:	c9                   	leave  
80104115:	c3                   	ret    
    return -1;
80104116:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010411b:	eb f7                	jmp    80104114 <argstr+0x2e>

8010411d <syscall>:
[SYS_writecount] sys_writecount,
};

void
syscall(void)
{
8010411d:	f3 0f 1e fb          	endbr32 
80104121:	55                   	push   %ebp
80104122:	89 e5                	mov    %esp,%ebp
80104124:	53                   	push   %ebx
80104125:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104128:	e8 01 f2 ff ff       	call   8010332e <myproc>
8010412d:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010412f:	8b 40 18             	mov    0x18(%eax),%eax
80104132:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104135:	8d 50 ff             	lea    -0x1(%eax),%edx
80104138:	83 fa 17             	cmp    $0x17,%edx
8010413b:	77 17                	ja     80104154 <syscall+0x37>
8010413d:	8b 14 85 20 6f 10 80 	mov    -0x7fef90e0(,%eax,4),%edx
80104144:	85 d2                	test   %edx,%edx
80104146:	74 0c                	je     80104154 <syscall+0x37>
    curproc->tf->eax = syscalls[num]();
80104148:	ff d2                	call   *%edx
8010414a:	89 c2                	mov    %eax,%edx
8010414c:	8b 43 18             	mov    0x18(%ebx),%eax
8010414f:	89 50 1c             	mov    %edx,0x1c(%eax)
80104152:	eb 1f                	jmp    80104173 <syscall+0x56>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
80104154:	8d 53 6c             	lea    0x6c(%ebx),%edx
    cprintf("%d %s: unknown sys call %d\n",
80104157:	50                   	push   %eax
80104158:	52                   	push   %edx
80104159:	ff 73 10             	pushl  0x10(%ebx)
8010415c:	68 f5 6e 10 80       	push   $0x80106ef5
80104161:	e8 c3 c4 ff ff       	call   80100629 <cprintf>
    curproc->tf->eax = -1;
80104166:	8b 43 18             	mov    0x18(%ebx),%eax
80104169:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
80104170:	83 c4 10             	add    $0x10,%esp
  }
}
80104173:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104176:	c9                   	leave  
80104177:	c3                   	ret    

80104178 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80104178:	55                   	push   %ebp
80104179:	89 e5                	mov    %esp,%ebp
8010417b:	56                   	push   %esi
8010417c:	53                   	push   %ebx
8010417d:	83 ec 18             	sub    $0x18,%esp
80104180:	89 d6                	mov    %edx,%esi
80104182:	89 cb                	mov    %ecx,%ebx
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104184:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104187:	52                   	push   %edx
80104188:	50                   	push   %eax
80104189:	e8 c0 fe ff ff       	call   8010404e <argint>
8010418e:	83 c4 10             	add    $0x10,%esp
80104191:	85 c0                	test   %eax,%eax
80104193:	78 35                	js     801041ca <argfd+0x52>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104195:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104199:	77 28                	ja     801041c3 <argfd+0x4b>
8010419b:	e8 8e f1 ff ff       	call   8010332e <myproc>
801041a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801041a3:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
801041a7:	85 c0                	test   %eax,%eax
801041a9:	74 18                	je     801041c3 <argfd+0x4b>
    return -1;
  if(pfd)
801041ab:	85 f6                	test   %esi,%esi
801041ad:	74 02                	je     801041b1 <argfd+0x39>
    *pfd = fd;
801041af:	89 16                	mov    %edx,(%esi)
  if(pf)
801041b1:	85 db                	test   %ebx,%ebx
801041b3:	74 1c                	je     801041d1 <argfd+0x59>
    *pf = f;
801041b5:	89 03                	mov    %eax,(%ebx)
  return 0;
801041b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
801041bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801041bf:	5b                   	pop    %ebx
801041c0:	5e                   	pop    %esi
801041c1:	5d                   	pop    %ebp
801041c2:	c3                   	ret    
    return -1;
801041c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801041c8:	eb f2                	jmp    801041bc <argfd+0x44>
    return -1;
801041ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801041cf:	eb eb                	jmp    801041bc <argfd+0x44>
  return 0;
801041d1:	b8 00 00 00 00       	mov    $0x0,%eax
801041d6:	eb e4                	jmp    801041bc <argfd+0x44>

801041d8 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
801041d8:	55                   	push   %ebp
801041d9:	89 e5                	mov    %esp,%ebp
801041db:	53                   	push   %ebx
801041dc:	83 ec 04             	sub    $0x4,%esp
801041df:	89 c3                	mov    %eax,%ebx
  int fd;
  struct proc *curproc = myproc();
801041e1:	e8 48 f1 ff ff       	call   8010332e <myproc>
801041e6:	89 c2                	mov    %eax,%edx

  for(fd = 0; fd < NOFILE; fd++){
801041e8:	b8 00 00 00 00       	mov    $0x0,%eax
801041ed:	83 f8 0f             	cmp    $0xf,%eax
801041f0:	7f 12                	jg     80104204 <fdalloc+0x2c>
    if(curproc->ofile[fd] == 0){
801041f2:	83 7c 82 28 00       	cmpl   $0x0,0x28(%edx,%eax,4)
801041f7:	74 05                	je     801041fe <fdalloc+0x26>
  for(fd = 0; fd < NOFILE; fd++){
801041f9:	83 c0 01             	add    $0x1,%eax
801041fc:	eb ef                	jmp    801041ed <fdalloc+0x15>
      curproc->ofile[fd] = f;
801041fe:	89 5c 82 28          	mov    %ebx,0x28(%edx,%eax,4)
      return fd;
80104202:	eb 05                	jmp    80104209 <fdalloc+0x31>
    }
  }
  return -1;
80104204:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104209:	83 c4 04             	add    $0x4,%esp
8010420c:	5b                   	pop    %ebx
8010420d:	5d                   	pop    %ebp
8010420e:	c3                   	ret    

8010420f <isdirempty>:
}

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
8010420f:	55                   	push   %ebp
80104210:	89 e5                	mov    %esp,%ebp
80104212:	56                   	push   %esi
80104213:	53                   	push   %ebx
80104214:	83 ec 10             	sub    $0x10,%esp
80104217:	89 c3                	mov    %eax,%ebx
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104219:	b8 20 00 00 00       	mov    $0x20,%eax
8010421e:	89 c6                	mov    %eax,%esi
80104220:	39 43 58             	cmp    %eax,0x58(%ebx)
80104223:	76 2e                	jbe    80104253 <isdirempty+0x44>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104225:	6a 10                	push   $0x10
80104227:	50                   	push   %eax
80104228:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010422b:	50                   	push   %eax
8010422c:	53                   	push   %ebx
8010422d:	e8 9e d5 ff ff       	call   801017d0 <readi>
80104232:	83 c4 10             	add    $0x10,%esp
80104235:	83 f8 10             	cmp    $0x10,%eax
80104238:	75 0c                	jne    80104246 <isdirempty+0x37>
      panic("isdirempty: readi");
    if(de.inum != 0)
8010423a:	66 83 7d e8 00       	cmpw   $0x0,-0x18(%ebp)
8010423f:	75 1e                	jne    8010425f <isdirempty+0x50>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104241:	8d 46 10             	lea    0x10(%esi),%eax
80104244:	eb d8                	jmp    8010421e <isdirempty+0xf>
      panic("isdirempty: readi");
80104246:	83 ec 0c             	sub    $0xc,%esp
80104249:	68 84 6f 10 80       	push   $0x80106f84
8010424e:	e8 09 c1 ff ff       	call   8010035c <panic>
      return 0;
  }
  return 1;
80104253:	b8 01 00 00 00       	mov    $0x1,%eax
}
80104258:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010425b:	5b                   	pop    %ebx
8010425c:	5e                   	pop    %esi
8010425d:	5d                   	pop    %ebp
8010425e:	c3                   	ret    
      return 0;
8010425f:	b8 00 00 00 00       	mov    $0x0,%eax
80104264:	eb f2                	jmp    80104258 <isdirempty+0x49>

80104266 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104266:	55                   	push   %ebp
80104267:	89 e5                	mov    %esp,%ebp
80104269:	57                   	push   %edi
8010426a:	56                   	push   %esi
8010426b:	53                   	push   %ebx
8010426c:	83 ec 34             	sub    $0x34,%esp
8010426f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104272:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104275:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104278:	8d 55 da             	lea    -0x26(%ebp),%edx
8010427b:	52                   	push   %edx
8010427c:	50                   	push   %eax
8010427d:	e8 e9 d9 ff ff       	call   80101c6b <nameiparent>
80104282:	89 c6                	mov    %eax,%esi
80104284:	83 c4 10             	add    $0x10,%esp
80104287:	85 c0                	test   %eax,%eax
80104289:	0f 84 33 01 00 00    	je     801043c2 <create+0x15c>
    return 0;
  ilock(dp);
8010428f:	83 ec 0c             	sub    $0xc,%esp
80104292:	50                   	push   %eax
80104293:	e8 32 d3 ff ff       	call   801015ca <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104298:	83 c4 0c             	add    $0xc,%esp
8010429b:	6a 00                	push   $0x0
8010429d:	8d 45 da             	lea    -0x26(%ebp),%eax
801042a0:	50                   	push   %eax
801042a1:	56                   	push   %esi
801042a2:	e8 72 d7 ff ff       	call   80101a19 <dirlookup>
801042a7:	89 c3                	mov    %eax,%ebx
801042a9:	83 c4 10             	add    $0x10,%esp
801042ac:	85 c0                	test   %eax,%eax
801042ae:	74 3d                	je     801042ed <create+0x87>
    iunlockput(dp);
801042b0:	83 ec 0c             	sub    $0xc,%esp
801042b3:	56                   	push   %esi
801042b4:	e8 c4 d4 ff ff       	call   8010177d <iunlockput>
    ilock(ip);
801042b9:	89 1c 24             	mov    %ebx,(%esp)
801042bc:	e8 09 d3 ff ff       	call   801015ca <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801042c1:	83 c4 10             	add    $0x10,%esp
801042c4:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801042c9:	75 07                	jne    801042d2 <create+0x6c>
801042cb:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
801042d0:	74 11                	je     801042e3 <create+0x7d>
      return ip;
    iunlockput(ip);
801042d2:	83 ec 0c             	sub    $0xc,%esp
801042d5:	53                   	push   %ebx
801042d6:	e8 a2 d4 ff ff       	call   8010177d <iunlockput>
    return 0;
801042db:	83 c4 10             	add    $0x10,%esp
801042de:	bb 00 00 00 00       	mov    $0x0,%ebx
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801042e3:	89 d8                	mov    %ebx,%eax
801042e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042e8:	5b                   	pop    %ebx
801042e9:	5e                   	pop    %esi
801042ea:	5f                   	pop    %edi
801042eb:	5d                   	pop    %ebp
801042ec:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
801042ed:	83 ec 08             	sub    $0x8,%esp
801042f0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
801042f4:	50                   	push   %eax
801042f5:	ff 36                	pushl  (%esi)
801042f7:	e8 bf d0 ff ff       	call   801013bb <ialloc>
801042fc:	89 c3                	mov    %eax,%ebx
801042fe:	83 c4 10             	add    $0x10,%esp
80104301:	85 c0                	test   %eax,%eax
80104303:	74 52                	je     80104357 <create+0xf1>
  ilock(ip);
80104305:	83 ec 0c             	sub    $0xc,%esp
80104308:	50                   	push   %eax
80104309:	e8 bc d2 ff ff       	call   801015ca <ilock>
  ip->major = major;
8010430e:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104312:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
80104316:	66 89 7b 54          	mov    %di,0x54(%ebx)
  ip->nlink = 1;
8010431a:	66 c7 43 56 01 00    	movw   $0x1,0x56(%ebx)
  iupdate(ip);
80104320:	89 1c 24             	mov    %ebx,(%esp)
80104323:	e8 39 d1 ff ff       	call   80101461 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104328:	83 c4 10             	add    $0x10,%esp
8010432b:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104330:	74 32                	je     80104364 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
80104332:	83 ec 04             	sub    $0x4,%esp
80104335:	ff 73 04             	pushl  0x4(%ebx)
80104338:	8d 45 da             	lea    -0x26(%ebp),%eax
8010433b:	50                   	push   %eax
8010433c:	56                   	push   %esi
8010433d:	e8 58 d8 ff ff       	call   80101b9a <dirlink>
80104342:	83 c4 10             	add    $0x10,%esp
80104345:	85 c0                	test   %eax,%eax
80104347:	78 6c                	js     801043b5 <create+0x14f>
  iunlockput(dp);
80104349:	83 ec 0c             	sub    $0xc,%esp
8010434c:	56                   	push   %esi
8010434d:	e8 2b d4 ff ff       	call   8010177d <iunlockput>
  return ip;
80104352:	83 c4 10             	add    $0x10,%esp
80104355:	eb 8c                	jmp    801042e3 <create+0x7d>
    panic("create: ialloc");
80104357:	83 ec 0c             	sub    $0xc,%esp
8010435a:	68 96 6f 10 80       	push   $0x80106f96
8010435f:	e8 f8 bf ff ff       	call   8010035c <panic>
    dp->nlink++;  // for ".."
80104364:	0f b7 46 56          	movzwl 0x56(%esi),%eax
80104368:	83 c0 01             	add    $0x1,%eax
8010436b:	66 89 46 56          	mov    %ax,0x56(%esi)
    iupdate(dp);
8010436f:	83 ec 0c             	sub    $0xc,%esp
80104372:	56                   	push   %esi
80104373:	e8 e9 d0 ff ff       	call   80101461 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104378:	83 c4 0c             	add    $0xc,%esp
8010437b:	ff 73 04             	pushl  0x4(%ebx)
8010437e:	68 a6 6f 10 80       	push   $0x80106fa6
80104383:	53                   	push   %ebx
80104384:	e8 11 d8 ff ff       	call   80101b9a <dirlink>
80104389:	83 c4 10             	add    $0x10,%esp
8010438c:	85 c0                	test   %eax,%eax
8010438e:	78 18                	js     801043a8 <create+0x142>
80104390:	83 ec 04             	sub    $0x4,%esp
80104393:	ff 76 04             	pushl  0x4(%esi)
80104396:	68 a5 6f 10 80       	push   $0x80106fa5
8010439b:	53                   	push   %ebx
8010439c:	e8 f9 d7 ff ff       	call   80101b9a <dirlink>
801043a1:	83 c4 10             	add    $0x10,%esp
801043a4:	85 c0                	test   %eax,%eax
801043a6:	79 8a                	jns    80104332 <create+0xcc>
      panic("create dots");
801043a8:	83 ec 0c             	sub    $0xc,%esp
801043ab:	68 a8 6f 10 80       	push   $0x80106fa8
801043b0:	e8 a7 bf ff ff       	call   8010035c <panic>
    panic("create: dirlink");
801043b5:	83 ec 0c             	sub    $0xc,%esp
801043b8:	68 b4 6f 10 80       	push   $0x80106fb4
801043bd:	e8 9a bf ff ff       	call   8010035c <panic>
    return 0;
801043c2:	89 c3                	mov    %eax,%ebx
801043c4:	e9 1a ff ff ff       	jmp    801042e3 <create+0x7d>

801043c9 <sys_dup>:
{
801043c9:	f3 0f 1e fb          	endbr32 
801043cd:	55                   	push   %ebp
801043ce:	89 e5                	mov    %esp,%ebp
801043d0:	53                   	push   %ebx
801043d1:	83 ec 14             	sub    $0x14,%esp
  if(argfd(0, 0, &f) < 0)
801043d4:	8d 4d f4             	lea    -0xc(%ebp),%ecx
801043d7:	ba 00 00 00 00       	mov    $0x0,%edx
801043dc:	b8 00 00 00 00       	mov    $0x0,%eax
801043e1:	e8 92 fd ff ff       	call   80104178 <argfd>
801043e6:	85 c0                	test   %eax,%eax
801043e8:	78 23                	js     8010440d <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
801043ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043ed:	e8 e6 fd ff ff       	call   801041d8 <fdalloc>
801043f2:	89 c3                	mov    %eax,%ebx
801043f4:	85 c0                	test   %eax,%eax
801043f6:	78 1c                	js     80104414 <sys_dup+0x4b>
  filedup(f);
801043f8:	83 ec 0c             	sub    $0xc,%esp
801043fb:	ff 75 f4             	pushl  -0xc(%ebp)
801043fe:	e8 b9 c8 ff ff       	call   80100cbc <filedup>
  return fd;
80104403:	83 c4 10             	add    $0x10,%esp
}
80104406:	89 d8                	mov    %ebx,%eax
80104408:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010440b:	c9                   	leave  
8010440c:	c3                   	ret    
    return -1;
8010440d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104412:	eb f2                	jmp    80104406 <sys_dup+0x3d>
    return -1;
80104414:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104419:	eb eb                	jmp    80104406 <sys_dup+0x3d>

8010441b <sys_read>:
{
8010441b:	f3 0f 1e fb          	endbr32 
8010441f:	55                   	push   %ebp
80104420:	89 e5                	mov    %esp,%ebp
80104422:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104425:	8d 4d f4             	lea    -0xc(%ebp),%ecx
80104428:	ba 00 00 00 00       	mov    $0x0,%edx
8010442d:	b8 00 00 00 00       	mov    $0x0,%eax
80104432:	e8 41 fd ff ff       	call   80104178 <argfd>
80104437:	85 c0                	test   %eax,%eax
80104439:	78 43                	js     8010447e <sys_read+0x63>
8010443b:	83 ec 08             	sub    $0x8,%esp
8010443e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104441:	50                   	push   %eax
80104442:	6a 02                	push   $0x2
80104444:	e8 05 fc ff ff       	call   8010404e <argint>
80104449:	83 c4 10             	add    $0x10,%esp
8010444c:	85 c0                	test   %eax,%eax
8010444e:	78 2e                	js     8010447e <sys_read+0x63>
80104450:	83 ec 04             	sub    $0x4,%esp
80104453:	ff 75 f0             	pushl  -0x10(%ebp)
80104456:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104459:	50                   	push   %eax
8010445a:	6a 01                	push   $0x1
8010445c:	e8 19 fc ff ff       	call   8010407a <argptr>
80104461:	83 c4 10             	add    $0x10,%esp
80104464:	85 c0                	test   %eax,%eax
80104466:	78 16                	js     8010447e <sys_read+0x63>
  return fileread(f, p, n);
80104468:	83 ec 04             	sub    $0x4,%esp
8010446b:	ff 75 f0             	pushl  -0x10(%ebp)
8010446e:	ff 75 ec             	pushl  -0x14(%ebp)
80104471:	ff 75 f4             	pushl  -0xc(%ebp)
80104474:	e8 95 c9 ff ff       	call   80100e0e <fileread>
80104479:	83 c4 10             	add    $0x10,%esp
}
8010447c:	c9                   	leave  
8010447d:	c3                   	ret    
    return -1;
8010447e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104483:	eb f7                	jmp    8010447c <sys_read+0x61>

80104485 <sys_write>:
{
80104485:	f3 0f 1e fb          	endbr32 
80104489:	55                   	push   %ebp
8010448a:	89 e5                	mov    %esp,%ebp
8010448c:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010448f:	8d 4d f4             	lea    -0xc(%ebp),%ecx
80104492:	ba 00 00 00 00       	mov    $0x0,%edx
80104497:	b8 00 00 00 00       	mov    $0x0,%eax
8010449c:	e8 d7 fc ff ff       	call   80104178 <argfd>
801044a1:	85 c0                	test   %eax,%eax
801044a3:	78 4a                	js     801044ef <sys_write+0x6a>
801044a5:	83 ec 08             	sub    $0x8,%esp
801044a8:	8d 45 f0             	lea    -0x10(%ebp),%eax
801044ab:	50                   	push   %eax
801044ac:	6a 02                	push   $0x2
801044ae:	e8 9b fb ff ff       	call   8010404e <argint>
801044b3:	83 c4 10             	add    $0x10,%esp
801044b6:	85 c0                	test   %eax,%eax
801044b8:	78 35                	js     801044ef <sys_write+0x6a>
801044ba:	83 ec 04             	sub    $0x4,%esp
801044bd:	ff 75 f0             	pushl  -0x10(%ebp)
801044c0:	8d 45 ec             	lea    -0x14(%ebp),%eax
801044c3:	50                   	push   %eax
801044c4:	6a 01                	push   $0x1
801044c6:	e8 af fb ff ff       	call   8010407a <argptr>
801044cb:	83 c4 10             	add    $0x10,%esp
801044ce:	85 c0                	test   %eax,%eax
801044d0:	78 1d                	js     801044ef <sys_write+0x6a>
  writecount++;
801044d2:	83 05 54 4c 11 80 01 	addl   $0x1,0x80114c54
  return filewrite(f, p, n);
801044d9:	83 ec 04             	sub    $0x4,%esp
801044dc:	ff 75 f0             	pushl  -0x10(%ebp)
801044df:	ff 75 ec             	pushl  -0x14(%ebp)
801044e2:	ff 75 f4             	pushl  -0xc(%ebp)
801044e5:	e8 ad c9 ff ff       	call   80100e97 <filewrite>
801044ea:	83 c4 10             	add    $0x10,%esp
}
801044ed:	c9                   	leave  
801044ee:	c3                   	ret    
    return -1;
801044ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801044f4:	eb f7                	jmp    801044ed <sys_write+0x68>

801044f6 <sys_close>:
{
801044f6:	f3 0f 1e fb          	endbr32 
801044fa:	55                   	push   %ebp
801044fb:	89 e5                	mov    %esp,%ebp
801044fd:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80104500:	8d 4d f0             	lea    -0x10(%ebp),%ecx
80104503:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104506:	b8 00 00 00 00       	mov    $0x0,%eax
8010450b:	e8 68 fc ff ff       	call   80104178 <argfd>
80104510:	85 c0                	test   %eax,%eax
80104512:	78 25                	js     80104539 <sys_close+0x43>
  myproc()->ofile[fd] = 0;
80104514:	e8 15 ee ff ff       	call   8010332e <myproc>
80104519:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010451c:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104523:	00 
  fileclose(f);
80104524:	83 ec 0c             	sub    $0xc,%esp
80104527:	ff 75 f0             	pushl  -0x10(%ebp)
8010452a:	e8 d6 c7 ff ff       	call   80100d05 <fileclose>
  return 0;
8010452f:	83 c4 10             	add    $0x10,%esp
80104532:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104537:	c9                   	leave  
80104538:	c3                   	ret    
    return -1;
80104539:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010453e:	eb f7                	jmp    80104537 <sys_close+0x41>

80104540 <sys_fstat>:
{
80104540:	f3 0f 1e fb          	endbr32 
80104544:	55                   	push   %ebp
80104545:	89 e5                	mov    %esp,%ebp
80104547:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
8010454a:	8d 4d f4             	lea    -0xc(%ebp),%ecx
8010454d:	ba 00 00 00 00       	mov    $0x0,%edx
80104552:	b8 00 00 00 00       	mov    $0x0,%eax
80104557:	e8 1c fc ff ff       	call   80104178 <argfd>
8010455c:	85 c0                	test   %eax,%eax
8010455e:	78 2a                	js     8010458a <sys_fstat+0x4a>
80104560:	83 ec 04             	sub    $0x4,%esp
80104563:	6a 14                	push   $0x14
80104565:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104568:	50                   	push   %eax
80104569:	6a 01                	push   $0x1
8010456b:	e8 0a fb ff ff       	call   8010407a <argptr>
80104570:	83 c4 10             	add    $0x10,%esp
80104573:	85 c0                	test   %eax,%eax
80104575:	78 13                	js     8010458a <sys_fstat+0x4a>
  return filestat(f, st);
80104577:	83 ec 08             	sub    $0x8,%esp
8010457a:	ff 75 f0             	pushl  -0x10(%ebp)
8010457d:	ff 75 f4             	pushl  -0xc(%ebp)
80104580:	e8 3e c8 ff ff       	call   80100dc3 <filestat>
80104585:	83 c4 10             	add    $0x10,%esp
}
80104588:	c9                   	leave  
80104589:	c3                   	ret    
    return -1;
8010458a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010458f:	eb f7                	jmp    80104588 <sys_fstat+0x48>

80104591 <sys_link>:
{
80104591:	f3 0f 1e fb          	endbr32 
80104595:	55                   	push   %ebp
80104596:	89 e5                	mov    %esp,%ebp
80104598:	56                   	push   %esi
80104599:	53                   	push   %ebx
8010459a:	83 ec 28             	sub    $0x28,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010459d:	8d 45 e0             	lea    -0x20(%ebp),%eax
801045a0:	50                   	push   %eax
801045a1:	6a 00                	push   $0x0
801045a3:	e8 3e fb ff ff       	call   801040e6 <argstr>
801045a8:	83 c4 10             	add    $0x10,%esp
801045ab:	85 c0                	test   %eax,%eax
801045ad:	0f 88 d3 00 00 00    	js     80104686 <sys_link+0xf5>
801045b3:	83 ec 08             	sub    $0x8,%esp
801045b6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801045b9:	50                   	push   %eax
801045ba:	6a 01                	push   $0x1
801045bc:	e8 25 fb ff ff       	call   801040e6 <argstr>
801045c1:	83 c4 10             	add    $0x10,%esp
801045c4:	85 c0                	test   %eax,%eax
801045c6:	0f 88 ba 00 00 00    	js     80104686 <sys_link+0xf5>
  begin_op();
801045cc:	e8 b4 e2 ff ff       	call   80102885 <begin_op>
  if((ip = namei(old)) == 0){
801045d1:	83 ec 0c             	sub    $0xc,%esp
801045d4:	ff 75 e0             	pushl  -0x20(%ebp)
801045d7:	e8 73 d6 ff ff       	call   80101c4f <namei>
801045dc:	89 c3                	mov    %eax,%ebx
801045de:	83 c4 10             	add    $0x10,%esp
801045e1:	85 c0                	test   %eax,%eax
801045e3:	0f 84 a4 00 00 00    	je     8010468d <sys_link+0xfc>
  ilock(ip);
801045e9:	83 ec 0c             	sub    $0xc,%esp
801045ec:	50                   	push   %eax
801045ed:	e8 d8 cf ff ff       	call   801015ca <ilock>
  if(ip->type == T_DIR){
801045f2:	83 c4 10             	add    $0x10,%esp
801045f5:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801045fa:	0f 84 99 00 00 00    	je     80104699 <sys_link+0x108>
  ip->nlink++;
80104600:	0f b7 43 56          	movzwl 0x56(%ebx),%eax
80104604:	83 c0 01             	add    $0x1,%eax
80104607:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
8010460b:	83 ec 0c             	sub    $0xc,%esp
8010460e:	53                   	push   %ebx
8010460f:	e8 4d ce ff ff       	call   80101461 <iupdate>
  iunlock(ip);
80104614:	89 1c 24             	mov    %ebx,(%esp)
80104617:	e8 74 d0 ff ff       	call   80101690 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
8010461c:	83 c4 08             	add    $0x8,%esp
8010461f:	8d 45 ea             	lea    -0x16(%ebp),%eax
80104622:	50                   	push   %eax
80104623:	ff 75 e4             	pushl  -0x1c(%ebp)
80104626:	e8 40 d6 ff ff       	call   80101c6b <nameiparent>
8010462b:	89 c6                	mov    %eax,%esi
8010462d:	83 c4 10             	add    $0x10,%esp
80104630:	85 c0                	test   %eax,%eax
80104632:	0f 84 85 00 00 00    	je     801046bd <sys_link+0x12c>
  ilock(dp);
80104638:	83 ec 0c             	sub    $0xc,%esp
8010463b:	50                   	push   %eax
8010463c:	e8 89 cf ff ff       	call   801015ca <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104641:	83 c4 10             	add    $0x10,%esp
80104644:	8b 03                	mov    (%ebx),%eax
80104646:	39 06                	cmp    %eax,(%esi)
80104648:	75 67                	jne    801046b1 <sys_link+0x120>
8010464a:	83 ec 04             	sub    $0x4,%esp
8010464d:	ff 73 04             	pushl  0x4(%ebx)
80104650:	8d 45 ea             	lea    -0x16(%ebp),%eax
80104653:	50                   	push   %eax
80104654:	56                   	push   %esi
80104655:	e8 40 d5 ff ff       	call   80101b9a <dirlink>
8010465a:	83 c4 10             	add    $0x10,%esp
8010465d:	85 c0                	test   %eax,%eax
8010465f:	78 50                	js     801046b1 <sys_link+0x120>
  iunlockput(dp);
80104661:	83 ec 0c             	sub    $0xc,%esp
80104664:	56                   	push   %esi
80104665:	e8 13 d1 ff ff       	call   8010177d <iunlockput>
  iput(ip);
8010466a:	89 1c 24             	mov    %ebx,(%esp)
8010466d:	e8 67 d0 ff ff       	call   801016d9 <iput>
  end_op();
80104672:	e8 8c e2 ff ff       	call   80102903 <end_op>
  return 0;
80104677:	83 c4 10             	add    $0x10,%esp
8010467a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010467f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104682:	5b                   	pop    %ebx
80104683:	5e                   	pop    %esi
80104684:	5d                   	pop    %ebp
80104685:	c3                   	ret    
    return -1;
80104686:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010468b:	eb f2                	jmp    8010467f <sys_link+0xee>
    end_op();
8010468d:	e8 71 e2 ff ff       	call   80102903 <end_op>
    return -1;
80104692:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104697:	eb e6                	jmp    8010467f <sys_link+0xee>
    iunlockput(ip);
80104699:	83 ec 0c             	sub    $0xc,%esp
8010469c:	53                   	push   %ebx
8010469d:	e8 db d0 ff ff       	call   8010177d <iunlockput>
    end_op();
801046a2:	e8 5c e2 ff ff       	call   80102903 <end_op>
    return -1;
801046a7:	83 c4 10             	add    $0x10,%esp
801046aa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046af:	eb ce                	jmp    8010467f <sys_link+0xee>
    iunlockput(dp);
801046b1:	83 ec 0c             	sub    $0xc,%esp
801046b4:	56                   	push   %esi
801046b5:	e8 c3 d0 ff ff       	call   8010177d <iunlockput>
    goto bad;
801046ba:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801046bd:	83 ec 0c             	sub    $0xc,%esp
801046c0:	53                   	push   %ebx
801046c1:	e8 04 cf ff ff       	call   801015ca <ilock>
  ip->nlink--;
801046c6:	0f b7 43 56          	movzwl 0x56(%ebx),%eax
801046ca:	83 e8 01             	sub    $0x1,%eax
801046cd:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
801046d1:	89 1c 24             	mov    %ebx,(%esp)
801046d4:	e8 88 cd ff ff       	call   80101461 <iupdate>
  iunlockput(ip);
801046d9:	89 1c 24             	mov    %ebx,(%esp)
801046dc:	e8 9c d0 ff ff       	call   8010177d <iunlockput>
  end_op();
801046e1:	e8 1d e2 ff ff       	call   80102903 <end_op>
  return -1;
801046e6:	83 c4 10             	add    $0x10,%esp
801046e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046ee:	eb 8f                	jmp    8010467f <sys_link+0xee>

801046f0 <sys_unlink>:
{
801046f0:	f3 0f 1e fb          	endbr32 
801046f4:	55                   	push   %ebp
801046f5:	89 e5                	mov    %esp,%ebp
801046f7:	57                   	push   %edi
801046f8:	56                   	push   %esi
801046f9:	53                   	push   %ebx
801046fa:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
801046fd:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104700:	50                   	push   %eax
80104701:	6a 00                	push   $0x0
80104703:	e8 de f9 ff ff       	call   801040e6 <argstr>
80104708:	83 c4 10             	add    $0x10,%esp
8010470b:	85 c0                	test   %eax,%eax
8010470d:	0f 88 83 01 00 00    	js     80104896 <sys_unlink+0x1a6>
  begin_op();
80104713:	e8 6d e1 ff ff       	call   80102885 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104718:	83 ec 08             	sub    $0x8,%esp
8010471b:	8d 45 ca             	lea    -0x36(%ebp),%eax
8010471e:	50                   	push   %eax
8010471f:	ff 75 c4             	pushl  -0x3c(%ebp)
80104722:	e8 44 d5 ff ff       	call   80101c6b <nameiparent>
80104727:	89 c6                	mov    %eax,%esi
80104729:	83 c4 10             	add    $0x10,%esp
8010472c:	85 c0                	test   %eax,%eax
8010472e:	0f 84 ed 00 00 00    	je     80104821 <sys_unlink+0x131>
  ilock(dp);
80104734:	83 ec 0c             	sub    $0xc,%esp
80104737:	50                   	push   %eax
80104738:	e8 8d ce ff ff       	call   801015ca <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010473d:	83 c4 08             	add    $0x8,%esp
80104740:	68 a6 6f 10 80       	push   $0x80106fa6
80104745:	8d 45 ca             	lea    -0x36(%ebp),%eax
80104748:	50                   	push   %eax
80104749:	e8 b2 d2 ff ff       	call   80101a00 <namecmp>
8010474e:	83 c4 10             	add    $0x10,%esp
80104751:	85 c0                	test   %eax,%eax
80104753:	0f 84 fc 00 00 00    	je     80104855 <sys_unlink+0x165>
80104759:	83 ec 08             	sub    $0x8,%esp
8010475c:	68 a5 6f 10 80       	push   $0x80106fa5
80104761:	8d 45 ca             	lea    -0x36(%ebp),%eax
80104764:	50                   	push   %eax
80104765:	e8 96 d2 ff ff       	call   80101a00 <namecmp>
8010476a:	83 c4 10             	add    $0x10,%esp
8010476d:	85 c0                	test   %eax,%eax
8010476f:	0f 84 e0 00 00 00    	je     80104855 <sys_unlink+0x165>
  if((ip = dirlookup(dp, name, &off)) == 0)
80104775:	83 ec 04             	sub    $0x4,%esp
80104778:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010477b:	50                   	push   %eax
8010477c:	8d 45 ca             	lea    -0x36(%ebp),%eax
8010477f:	50                   	push   %eax
80104780:	56                   	push   %esi
80104781:	e8 93 d2 ff ff       	call   80101a19 <dirlookup>
80104786:	89 c3                	mov    %eax,%ebx
80104788:	83 c4 10             	add    $0x10,%esp
8010478b:	85 c0                	test   %eax,%eax
8010478d:	0f 84 c2 00 00 00    	je     80104855 <sys_unlink+0x165>
  ilock(ip);
80104793:	83 ec 0c             	sub    $0xc,%esp
80104796:	50                   	push   %eax
80104797:	e8 2e ce ff ff       	call   801015ca <ilock>
  if(ip->nlink < 1)
8010479c:	83 c4 10             	add    $0x10,%esp
8010479f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801047a4:	0f 8e 83 00 00 00    	jle    8010482d <sys_unlink+0x13d>
  if(ip->type == T_DIR && !isdirempty(ip)){
801047aa:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801047af:	0f 84 85 00 00 00    	je     8010483a <sys_unlink+0x14a>
  memset(&de, 0, sizeof(de));
801047b5:	83 ec 04             	sub    $0x4,%esp
801047b8:	6a 10                	push   $0x10
801047ba:	6a 00                	push   $0x0
801047bc:	8d 7d d8             	lea    -0x28(%ebp),%edi
801047bf:	57                   	push   %edi
801047c0:	e8 13 f6 ff ff       	call   80103dd8 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801047c5:	6a 10                	push   $0x10
801047c7:	ff 75 c0             	pushl  -0x40(%ebp)
801047ca:	57                   	push   %edi
801047cb:	56                   	push   %esi
801047cc:	e8 00 d1 ff ff       	call   801018d1 <writei>
801047d1:	83 c4 20             	add    $0x20,%esp
801047d4:	83 f8 10             	cmp    $0x10,%eax
801047d7:	0f 85 90 00 00 00    	jne    8010486d <sys_unlink+0x17d>
  if(ip->type == T_DIR){
801047dd:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801047e2:	0f 84 92 00 00 00    	je     8010487a <sys_unlink+0x18a>
  iunlockput(dp);
801047e8:	83 ec 0c             	sub    $0xc,%esp
801047eb:	56                   	push   %esi
801047ec:	e8 8c cf ff ff       	call   8010177d <iunlockput>
  ip->nlink--;
801047f1:	0f b7 43 56          	movzwl 0x56(%ebx),%eax
801047f5:	83 e8 01             	sub    $0x1,%eax
801047f8:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
801047fc:	89 1c 24             	mov    %ebx,(%esp)
801047ff:	e8 5d cc ff ff       	call   80101461 <iupdate>
  iunlockput(ip);
80104804:	89 1c 24             	mov    %ebx,(%esp)
80104807:	e8 71 cf ff ff       	call   8010177d <iunlockput>
  end_op();
8010480c:	e8 f2 e0 ff ff       	call   80102903 <end_op>
  return 0;
80104811:	83 c4 10             	add    $0x10,%esp
80104814:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104819:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010481c:	5b                   	pop    %ebx
8010481d:	5e                   	pop    %esi
8010481e:	5f                   	pop    %edi
8010481f:	5d                   	pop    %ebp
80104820:	c3                   	ret    
    end_op();
80104821:	e8 dd e0 ff ff       	call   80102903 <end_op>
    return -1;
80104826:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010482b:	eb ec                	jmp    80104819 <sys_unlink+0x129>
    panic("unlink: nlink < 1");
8010482d:	83 ec 0c             	sub    $0xc,%esp
80104830:	68 c4 6f 10 80       	push   $0x80106fc4
80104835:	e8 22 bb ff ff       	call   8010035c <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010483a:	89 d8                	mov    %ebx,%eax
8010483c:	e8 ce f9 ff ff       	call   8010420f <isdirempty>
80104841:	85 c0                	test   %eax,%eax
80104843:	0f 85 6c ff ff ff    	jne    801047b5 <sys_unlink+0xc5>
    iunlockput(ip);
80104849:	83 ec 0c             	sub    $0xc,%esp
8010484c:	53                   	push   %ebx
8010484d:	e8 2b cf ff ff       	call   8010177d <iunlockput>
    goto bad;
80104852:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80104855:	83 ec 0c             	sub    $0xc,%esp
80104858:	56                   	push   %esi
80104859:	e8 1f cf ff ff       	call   8010177d <iunlockput>
  end_op();
8010485e:	e8 a0 e0 ff ff       	call   80102903 <end_op>
  return -1;
80104863:	83 c4 10             	add    $0x10,%esp
80104866:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010486b:	eb ac                	jmp    80104819 <sys_unlink+0x129>
    panic("unlink: writei");
8010486d:	83 ec 0c             	sub    $0xc,%esp
80104870:	68 d6 6f 10 80       	push   $0x80106fd6
80104875:	e8 e2 ba ff ff       	call   8010035c <panic>
    dp->nlink--;
8010487a:	0f b7 46 56          	movzwl 0x56(%esi),%eax
8010487e:	83 e8 01             	sub    $0x1,%eax
80104881:	66 89 46 56          	mov    %ax,0x56(%esi)
    iupdate(dp);
80104885:	83 ec 0c             	sub    $0xc,%esp
80104888:	56                   	push   %esi
80104889:	e8 d3 cb ff ff       	call   80101461 <iupdate>
8010488e:	83 c4 10             	add    $0x10,%esp
80104891:	e9 52 ff ff ff       	jmp    801047e8 <sys_unlink+0xf8>
    return -1;
80104896:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010489b:	e9 79 ff ff ff       	jmp    80104819 <sys_unlink+0x129>

801048a0 <sys_open>:

int
sys_open(void)
{
801048a0:	f3 0f 1e fb          	endbr32 
801048a4:	55                   	push   %ebp
801048a5:	89 e5                	mov    %esp,%ebp
801048a7:	57                   	push   %edi
801048a8:	56                   	push   %esi
801048a9:	53                   	push   %ebx
801048aa:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801048ad:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801048b0:	50                   	push   %eax
801048b1:	6a 00                	push   $0x0
801048b3:	e8 2e f8 ff ff       	call   801040e6 <argstr>
801048b8:	83 c4 10             	add    $0x10,%esp
801048bb:	85 c0                	test   %eax,%eax
801048bd:	0f 88 a0 00 00 00    	js     80104963 <sys_open+0xc3>
801048c3:	83 ec 08             	sub    $0x8,%esp
801048c6:	8d 45 e0             	lea    -0x20(%ebp),%eax
801048c9:	50                   	push   %eax
801048ca:	6a 01                	push   $0x1
801048cc:	e8 7d f7 ff ff       	call   8010404e <argint>
801048d1:	83 c4 10             	add    $0x10,%esp
801048d4:	85 c0                	test   %eax,%eax
801048d6:	0f 88 87 00 00 00    	js     80104963 <sys_open+0xc3>
    return -1;

  begin_op();
801048dc:	e8 a4 df ff ff       	call   80102885 <begin_op>

  if(omode & O_CREATE){
801048e1:	f6 45 e1 02          	testb  $0x2,-0x1f(%ebp)
801048e5:	0f 84 8b 00 00 00    	je     80104976 <sys_open+0xd6>
    ip = create(path, T_FILE, 0, 0);
801048eb:	83 ec 0c             	sub    $0xc,%esp
801048ee:	6a 00                	push   $0x0
801048f0:	b9 00 00 00 00       	mov    $0x0,%ecx
801048f5:	ba 02 00 00 00       	mov    $0x2,%edx
801048fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801048fd:	e8 64 f9 ff ff       	call   80104266 <create>
80104902:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80104904:	83 c4 10             	add    $0x10,%esp
80104907:	85 c0                	test   %eax,%eax
80104909:	74 5f                	je     8010496a <sys_open+0xca>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010490b:	e8 47 c3 ff ff       	call   80100c57 <filealloc>
80104910:	89 c3                	mov    %eax,%ebx
80104912:	85 c0                	test   %eax,%eax
80104914:	0f 84 b5 00 00 00    	je     801049cf <sys_open+0x12f>
8010491a:	e8 b9 f8 ff ff       	call   801041d8 <fdalloc>
8010491f:	89 c7                	mov    %eax,%edi
80104921:	85 c0                	test   %eax,%eax
80104923:	0f 88 a6 00 00 00    	js     801049cf <sys_open+0x12f>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104929:	83 ec 0c             	sub    $0xc,%esp
8010492c:	56                   	push   %esi
8010492d:	e8 5e cd ff ff       	call   80101690 <iunlock>
  end_op();
80104932:	e8 cc df ff ff       	call   80102903 <end_op>

  f->type = FD_INODE;
80104937:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  f->ip = ip;
8010493d:	89 73 10             	mov    %esi,0x10(%ebx)
  f->off = 0;
80104940:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  f->readable = !(omode & O_WRONLY);
80104947:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010494a:	83 c4 10             	add    $0x10,%esp
8010494d:	a8 01                	test   $0x1,%al
8010494f:	0f 94 43 08          	sete   0x8(%ebx)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104953:	a8 03                	test   $0x3,%al
80104955:	0f 95 43 09          	setne  0x9(%ebx)
  return fd;
}
80104959:	89 f8                	mov    %edi,%eax
8010495b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010495e:	5b                   	pop    %ebx
8010495f:	5e                   	pop    %esi
80104960:	5f                   	pop    %edi
80104961:	5d                   	pop    %ebp
80104962:	c3                   	ret    
    return -1;
80104963:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104968:	eb ef                	jmp    80104959 <sys_open+0xb9>
      end_op();
8010496a:	e8 94 df ff ff       	call   80102903 <end_op>
      return -1;
8010496f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104974:	eb e3                	jmp    80104959 <sys_open+0xb9>
    if((ip = namei(path)) == 0){
80104976:	83 ec 0c             	sub    $0xc,%esp
80104979:	ff 75 e4             	pushl  -0x1c(%ebp)
8010497c:	e8 ce d2 ff ff       	call   80101c4f <namei>
80104981:	89 c6                	mov    %eax,%esi
80104983:	83 c4 10             	add    $0x10,%esp
80104986:	85 c0                	test   %eax,%eax
80104988:	74 39                	je     801049c3 <sys_open+0x123>
    ilock(ip);
8010498a:	83 ec 0c             	sub    $0xc,%esp
8010498d:	50                   	push   %eax
8010498e:	e8 37 cc ff ff       	call   801015ca <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80104993:	83 c4 10             	add    $0x10,%esp
80104996:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
8010499b:	0f 85 6a ff ff ff    	jne    8010490b <sys_open+0x6b>
801049a1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801049a5:	0f 84 60 ff ff ff    	je     8010490b <sys_open+0x6b>
      iunlockput(ip);
801049ab:	83 ec 0c             	sub    $0xc,%esp
801049ae:	56                   	push   %esi
801049af:	e8 c9 cd ff ff       	call   8010177d <iunlockput>
      end_op();
801049b4:	e8 4a df ff ff       	call   80102903 <end_op>
      return -1;
801049b9:	83 c4 10             	add    $0x10,%esp
801049bc:	bf ff ff ff ff       	mov    $0xffffffff,%edi
801049c1:	eb 96                	jmp    80104959 <sys_open+0xb9>
      end_op();
801049c3:	e8 3b df ff ff       	call   80102903 <end_op>
      return -1;
801049c8:	bf ff ff ff ff       	mov    $0xffffffff,%edi
801049cd:	eb 8a                	jmp    80104959 <sys_open+0xb9>
    if(f)
801049cf:	85 db                	test   %ebx,%ebx
801049d1:	74 0c                	je     801049df <sys_open+0x13f>
      fileclose(f);
801049d3:	83 ec 0c             	sub    $0xc,%esp
801049d6:	53                   	push   %ebx
801049d7:	e8 29 c3 ff ff       	call   80100d05 <fileclose>
801049dc:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801049df:	83 ec 0c             	sub    $0xc,%esp
801049e2:	56                   	push   %esi
801049e3:	e8 95 cd ff ff       	call   8010177d <iunlockput>
    end_op();
801049e8:	e8 16 df ff ff       	call   80102903 <end_op>
    return -1;
801049ed:	83 c4 10             	add    $0x10,%esp
801049f0:	bf ff ff ff ff       	mov    $0xffffffff,%edi
801049f5:	e9 5f ff ff ff       	jmp    80104959 <sys_open+0xb9>

801049fa <sys_mkdir>:

int
sys_mkdir(void)
{
801049fa:	f3 0f 1e fb          	endbr32 
801049fe:	55                   	push   %ebp
801049ff:	89 e5                	mov    %esp,%ebp
80104a01:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80104a04:	e8 7c de ff ff       	call   80102885 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80104a09:	83 ec 08             	sub    $0x8,%esp
80104a0c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a0f:	50                   	push   %eax
80104a10:	6a 00                	push   $0x0
80104a12:	e8 cf f6 ff ff       	call   801040e6 <argstr>
80104a17:	83 c4 10             	add    $0x10,%esp
80104a1a:	85 c0                	test   %eax,%eax
80104a1c:	78 36                	js     80104a54 <sys_mkdir+0x5a>
80104a1e:	83 ec 0c             	sub    $0xc,%esp
80104a21:	6a 00                	push   $0x0
80104a23:	b9 00 00 00 00       	mov    $0x0,%ecx
80104a28:	ba 01 00 00 00       	mov    $0x1,%edx
80104a2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a30:	e8 31 f8 ff ff       	call   80104266 <create>
80104a35:	83 c4 10             	add    $0x10,%esp
80104a38:	85 c0                	test   %eax,%eax
80104a3a:	74 18                	je     80104a54 <sys_mkdir+0x5a>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104a3c:	83 ec 0c             	sub    $0xc,%esp
80104a3f:	50                   	push   %eax
80104a40:	e8 38 cd ff ff       	call   8010177d <iunlockput>
  end_op();
80104a45:	e8 b9 de ff ff       	call   80102903 <end_op>
  return 0;
80104a4a:	83 c4 10             	add    $0x10,%esp
80104a4d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104a52:	c9                   	leave  
80104a53:	c3                   	ret    
    end_op();
80104a54:	e8 aa de ff ff       	call   80102903 <end_op>
    return -1;
80104a59:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a5e:	eb f2                	jmp    80104a52 <sys_mkdir+0x58>

80104a60 <sys_mknod>:

int
sys_mknod(void)
{
80104a60:	f3 0f 1e fb          	endbr32 
80104a64:	55                   	push   %ebp
80104a65:	89 e5                	mov    %esp,%ebp
80104a67:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80104a6a:	e8 16 de ff ff       	call   80102885 <begin_op>
  if((argstr(0, &path)) < 0 ||
80104a6f:	83 ec 08             	sub    $0x8,%esp
80104a72:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a75:	50                   	push   %eax
80104a76:	6a 00                	push   $0x0
80104a78:	e8 69 f6 ff ff       	call   801040e6 <argstr>
80104a7d:	83 c4 10             	add    $0x10,%esp
80104a80:	85 c0                	test   %eax,%eax
80104a82:	78 62                	js     80104ae6 <sys_mknod+0x86>
     argint(1, &major) < 0 ||
80104a84:	83 ec 08             	sub    $0x8,%esp
80104a87:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104a8a:	50                   	push   %eax
80104a8b:	6a 01                	push   $0x1
80104a8d:	e8 bc f5 ff ff       	call   8010404e <argint>
  if((argstr(0, &path)) < 0 ||
80104a92:	83 c4 10             	add    $0x10,%esp
80104a95:	85 c0                	test   %eax,%eax
80104a97:	78 4d                	js     80104ae6 <sys_mknod+0x86>
     argint(2, &minor) < 0 ||
80104a99:	83 ec 08             	sub    $0x8,%esp
80104a9c:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104a9f:	50                   	push   %eax
80104aa0:	6a 02                	push   $0x2
80104aa2:	e8 a7 f5 ff ff       	call   8010404e <argint>
     argint(1, &major) < 0 ||
80104aa7:	83 c4 10             	add    $0x10,%esp
80104aaa:	85 c0                	test   %eax,%eax
80104aac:	78 38                	js     80104ae6 <sys_mknod+0x86>
     (ip = create(path, T_DEV, major, minor)) == 0){
80104aae:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80104ab2:	83 ec 0c             	sub    $0xc,%esp
80104ab5:	0f bf 45 ec          	movswl -0x14(%ebp),%eax
80104ab9:	50                   	push   %eax
80104aba:	ba 03 00 00 00       	mov    $0x3,%edx
80104abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ac2:	e8 9f f7 ff ff       	call   80104266 <create>
     argint(2, &minor) < 0 ||
80104ac7:	83 c4 10             	add    $0x10,%esp
80104aca:	85 c0                	test   %eax,%eax
80104acc:	74 18                	je     80104ae6 <sys_mknod+0x86>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104ace:	83 ec 0c             	sub    $0xc,%esp
80104ad1:	50                   	push   %eax
80104ad2:	e8 a6 cc ff ff       	call   8010177d <iunlockput>
  end_op();
80104ad7:	e8 27 de ff ff       	call   80102903 <end_op>
  return 0;
80104adc:	83 c4 10             	add    $0x10,%esp
80104adf:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104ae4:	c9                   	leave  
80104ae5:	c3                   	ret    
    end_op();
80104ae6:	e8 18 de ff ff       	call   80102903 <end_op>
    return -1;
80104aeb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104af0:	eb f2                	jmp    80104ae4 <sys_mknod+0x84>

80104af2 <sys_chdir>:

int
sys_chdir(void)
{
80104af2:	f3 0f 1e fb          	endbr32 
80104af6:	55                   	push   %ebp
80104af7:	89 e5                	mov    %esp,%ebp
80104af9:	56                   	push   %esi
80104afa:	53                   	push   %ebx
80104afb:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80104afe:	e8 2b e8 ff ff       	call   8010332e <myproc>
80104b03:	89 c6                	mov    %eax,%esi
  
  begin_op();
80104b05:	e8 7b dd ff ff       	call   80102885 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80104b0a:	83 ec 08             	sub    $0x8,%esp
80104b0d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b10:	50                   	push   %eax
80104b11:	6a 00                	push   $0x0
80104b13:	e8 ce f5 ff ff       	call   801040e6 <argstr>
80104b18:	83 c4 10             	add    $0x10,%esp
80104b1b:	85 c0                	test   %eax,%eax
80104b1d:	78 52                	js     80104b71 <sys_chdir+0x7f>
80104b1f:	83 ec 0c             	sub    $0xc,%esp
80104b22:	ff 75 f4             	pushl  -0xc(%ebp)
80104b25:	e8 25 d1 ff ff       	call   80101c4f <namei>
80104b2a:	89 c3                	mov    %eax,%ebx
80104b2c:	83 c4 10             	add    $0x10,%esp
80104b2f:	85 c0                	test   %eax,%eax
80104b31:	74 3e                	je     80104b71 <sys_chdir+0x7f>
    end_op();
    return -1;
  }
  ilock(ip);
80104b33:	83 ec 0c             	sub    $0xc,%esp
80104b36:	50                   	push   %eax
80104b37:	e8 8e ca ff ff       	call   801015ca <ilock>
  if(ip->type != T_DIR){
80104b3c:	83 c4 10             	add    $0x10,%esp
80104b3f:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104b44:	75 37                	jne    80104b7d <sys_chdir+0x8b>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104b46:	83 ec 0c             	sub    $0xc,%esp
80104b49:	53                   	push   %ebx
80104b4a:	e8 41 cb ff ff       	call   80101690 <iunlock>
  iput(curproc->cwd);
80104b4f:	83 c4 04             	add    $0x4,%esp
80104b52:	ff 76 68             	pushl  0x68(%esi)
80104b55:	e8 7f cb ff ff       	call   801016d9 <iput>
  end_op();
80104b5a:	e8 a4 dd ff ff       	call   80102903 <end_op>
  curproc->cwd = ip;
80104b5f:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80104b62:	83 c4 10             	add    $0x10,%esp
80104b65:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104b6a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b6d:	5b                   	pop    %ebx
80104b6e:	5e                   	pop    %esi
80104b6f:	5d                   	pop    %ebp
80104b70:	c3                   	ret    
    end_op();
80104b71:	e8 8d dd ff ff       	call   80102903 <end_op>
    return -1;
80104b76:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b7b:	eb ed                	jmp    80104b6a <sys_chdir+0x78>
    iunlockput(ip);
80104b7d:	83 ec 0c             	sub    $0xc,%esp
80104b80:	53                   	push   %ebx
80104b81:	e8 f7 cb ff ff       	call   8010177d <iunlockput>
    end_op();
80104b86:	e8 78 dd ff ff       	call   80102903 <end_op>
    return -1;
80104b8b:	83 c4 10             	add    $0x10,%esp
80104b8e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b93:	eb d5                	jmp    80104b6a <sys_chdir+0x78>

80104b95 <sys_exec>:

int
sys_exec(void)
{
80104b95:	f3 0f 1e fb          	endbr32 
80104b99:	55                   	push   %ebp
80104b9a:	89 e5                	mov    %esp,%ebp
80104b9c:	53                   	push   %ebx
80104b9d:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80104ba3:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ba6:	50                   	push   %eax
80104ba7:	6a 00                	push   $0x0
80104ba9:	e8 38 f5 ff ff       	call   801040e6 <argstr>
80104bae:	83 c4 10             	add    $0x10,%esp
80104bb1:	85 c0                	test   %eax,%eax
80104bb3:	78 38                	js     80104bed <sys_exec+0x58>
80104bb5:	83 ec 08             	sub    $0x8,%esp
80104bb8:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80104bbe:	50                   	push   %eax
80104bbf:	6a 01                	push   $0x1
80104bc1:	e8 88 f4 ff ff       	call   8010404e <argint>
80104bc6:	83 c4 10             	add    $0x10,%esp
80104bc9:	85 c0                	test   %eax,%eax
80104bcb:	78 20                	js     80104bed <sys_exec+0x58>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80104bcd:	83 ec 04             	sub    $0x4,%esp
80104bd0:	68 80 00 00 00       	push   $0x80
80104bd5:	6a 00                	push   $0x0
80104bd7:	8d 85 74 ff ff ff    	lea    -0x8c(%ebp),%eax
80104bdd:	50                   	push   %eax
80104bde:	e8 f5 f1 ff ff       	call   80103dd8 <memset>
80104be3:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80104be6:	bb 00 00 00 00       	mov    $0x0,%ebx
80104beb:	eb 2c                	jmp    80104c19 <sys_exec+0x84>
    return -1;
80104bed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104bf2:	eb 78                	jmp    80104c6c <sys_exec+0xd7>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
80104bf4:	c7 84 9d 74 ff ff ff 	movl   $0x0,-0x8c(%ebp,%ebx,4)
80104bfb:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80104bff:	83 ec 08             	sub    $0x8,%esp
80104c02:	8d 85 74 ff ff ff    	lea    -0x8c(%ebp),%eax
80104c08:	50                   	push   %eax
80104c09:	ff 75 f4             	pushl  -0xc(%ebp)
80104c0c:	e8 eb bc ff ff       	call   801008fc <exec>
80104c11:	83 c4 10             	add    $0x10,%esp
80104c14:	eb 56                	jmp    80104c6c <sys_exec+0xd7>
  for(i=0;; i++){
80104c16:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80104c19:	83 fb 1f             	cmp    $0x1f,%ebx
80104c1c:	77 49                	ja     80104c67 <sys_exec+0xd2>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80104c1e:	83 ec 08             	sub    $0x8,%esp
80104c21:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80104c27:	50                   	push   %eax
80104c28:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
80104c2e:	8d 04 98             	lea    (%eax,%ebx,4),%eax
80104c31:	50                   	push   %eax
80104c32:	e8 93 f3 ff ff       	call   80103fca <fetchint>
80104c37:	83 c4 10             	add    $0x10,%esp
80104c3a:	85 c0                	test   %eax,%eax
80104c3c:	78 33                	js     80104c71 <sys_exec+0xdc>
    if(uarg == 0){
80104c3e:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80104c44:	85 c0                	test   %eax,%eax
80104c46:	74 ac                	je     80104bf4 <sys_exec+0x5f>
    if(fetchstr(uarg, &argv[i]) < 0)
80104c48:	83 ec 08             	sub    $0x8,%esp
80104c4b:	8d 94 9d 74 ff ff ff 	lea    -0x8c(%ebp,%ebx,4),%edx
80104c52:	52                   	push   %edx
80104c53:	50                   	push   %eax
80104c54:	e8 b1 f3 ff ff       	call   8010400a <fetchstr>
80104c59:	83 c4 10             	add    $0x10,%esp
80104c5c:	85 c0                	test   %eax,%eax
80104c5e:	79 b6                	jns    80104c16 <sys_exec+0x81>
      return -1;
80104c60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c65:	eb 05                	jmp    80104c6c <sys_exec+0xd7>
      return -1;
80104c67:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c6c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c6f:	c9                   	leave  
80104c70:	c3                   	ret    
      return -1;
80104c71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c76:	eb f4                	jmp    80104c6c <sys_exec+0xd7>

80104c78 <sys_pipe>:

int
sys_pipe(void)
{
80104c78:	f3 0f 1e fb          	endbr32 
80104c7c:	55                   	push   %ebp
80104c7d:	89 e5                	mov    %esp,%ebp
80104c7f:	53                   	push   %ebx
80104c80:	83 ec 18             	sub    $0x18,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80104c83:	6a 08                	push   $0x8
80104c85:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c88:	50                   	push   %eax
80104c89:	6a 00                	push   $0x0
80104c8b:	e8 ea f3 ff ff       	call   8010407a <argptr>
80104c90:	83 c4 10             	add    $0x10,%esp
80104c93:	85 c0                	test   %eax,%eax
80104c95:	78 79                	js     80104d10 <sys_pipe+0x98>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80104c97:	83 ec 08             	sub    $0x8,%esp
80104c9a:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104c9d:	50                   	push   %eax
80104c9e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104ca1:	50                   	push   %eax
80104ca2:	e8 b6 e1 ff ff       	call   80102e5d <pipealloc>
80104ca7:	83 c4 10             	add    $0x10,%esp
80104caa:	85 c0                	test   %eax,%eax
80104cac:	78 69                	js     80104d17 <sys_pipe+0x9f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80104cae:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104cb1:	e8 22 f5 ff ff       	call   801041d8 <fdalloc>
80104cb6:	89 c3                	mov    %eax,%ebx
80104cb8:	85 c0                	test   %eax,%eax
80104cba:	78 21                	js     80104cdd <sys_pipe+0x65>
80104cbc:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104cbf:	e8 14 f5 ff ff       	call   801041d8 <fdalloc>
80104cc4:	85 c0                	test   %eax,%eax
80104cc6:	78 15                	js     80104cdd <sys_pipe+0x65>
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80104cc8:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104ccb:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
80104ccd:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104cd0:	89 42 04             	mov    %eax,0x4(%edx)
  return 0;
80104cd3:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104cd8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104cdb:	c9                   	leave  
80104cdc:	c3                   	ret    
    if(fd0 >= 0)
80104cdd:	85 db                	test   %ebx,%ebx
80104cdf:	79 20                	jns    80104d01 <sys_pipe+0x89>
    fileclose(rf);
80104ce1:	83 ec 0c             	sub    $0xc,%esp
80104ce4:	ff 75 f0             	pushl  -0x10(%ebp)
80104ce7:	e8 19 c0 ff ff       	call   80100d05 <fileclose>
    fileclose(wf);
80104cec:	83 c4 04             	add    $0x4,%esp
80104cef:	ff 75 ec             	pushl  -0x14(%ebp)
80104cf2:	e8 0e c0 ff ff       	call   80100d05 <fileclose>
    return -1;
80104cf7:	83 c4 10             	add    $0x10,%esp
80104cfa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104cff:	eb d7                	jmp    80104cd8 <sys_pipe+0x60>
      myproc()->ofile[fd0] = 0;
80104d01:	e8 28 e6 ff ff       	call   8010332e <myproc>
80104d06:	c7 44 98 28 00 00 00 	movl   $0x0,0x28(%eax,%ebx,4)
80104d0d:	00 
80104d0e:	eb d1                	jmp    80104ce1 <sys_pipe+0x69>
    return -1;
80104d10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d15:	eb c1                	jmp    80104cd8 <sys_pipe+0x60>
    return -1;
80104d17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d1c:	eb ba                	jmp    80104cd8 <sys_pipe+0x60>

80104d1e <sys_writecount>:

int sys_writecount(void) {
80104d1e:	f3 0f 1e fb          	endbr32 
  return writecount;
}
80104d22:	a1 54 4c 11 80       	mov    0x80114c54,%eax
80104d27:	c3                   	ret    

80104d28 <sys_setwritecount>:

int sys_setwritecount(void) {
80104d28:	f3 0f 1e fb          	endbr32 
80104d2c:	55                   	push   %ebp
80104d2d:	89 e5                	mov    %esp,%ebp
80104d2f:	83 ec 20             	sub    $0x20,%esp
  int newcount;
  argint(0, &newcount);
80104d32:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d35:	50                   	push   %eax
80104d36:	6a 00                	push   $0x0
80104d38:	e8 11 f3 ff ff       	call   8010404e <argint>
  writecount = newcount;
80104d3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d40:	a3 54 4c 11 80       	mov    %eax,0x80114c54
  return 0;
}
80104d45:	b8 00 00 00 00       	mov    $0x0,%eax
80104d4a:	c9                   	leave  
80104d4b:	c3                   	ret    

80104d4c <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80104d4c:	f3 0f 1e fb          	endbr32 
80104d50:	55                   	push   %ebp
80104d51:	89 e5                	mov    %esp,%ebp
80104d53:	83 ec 08             	sub    $0x8,%esp
  return fork();
80104d56:	e8 56 e7 ff ff       	call   801034b1 <fork>
}
80104d5b:	c9                   	leave  
80104d5c:	c3                   	ret    

80104d5d <sys_exit>:

int
sys_exit(void)
{
80104d5d:	f3 0f 1e fb          	endbr32 
80104d61:	55                   	push   %ebp
80104d62:	89 e5                	mov    %esp,%ebp
80104d64:	83 ec 08             	sub    $0x8,%esp
  exit();
80104d67:	e8 85 e9 ff ff       	call   801036f1 <exit>
  return 0;  // not reached
}
80104d6c:	b8 00 00 00 00       	mov    $0x0,%eax
80104d71:	c9                   	leave  
80104d72:	c3                   	ret    

80104d73 <sys_wait>:

int
sys_wait(void)
{
80104d73:	f3 0f 1e fb          	endbr32 
80104d77:	55                   	push   %ebp
80104d78:	89 e5                	mov    %esp,%ebp
80104d7a:	83 ec 08             	sub    $0x8,%esp
  return wait();
80104d7d:	e8 04 eb ff ff       	call   80103886 <wait>
}
80104d82:	c9                   	leave  
80104d83:	c3                   	ret    

80104d84 <sys_kill>:

int
sys_kill(void)
{
80104d84:	f3 0f 1e fb          	endbr32 
80104d88:	55                   	push   %ebp
80104d89:	89 e5                	mov    %esp,%ebp
80104d8b:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80104d8e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d91:	50                   	push   %eax
80104d92:	6a 00                	push   $0x0
80104d94:	e8 b5 f2 ff ff       	call   8010404e <argint>
80104d99:	83 c4 10             	add    $0x10,%esp
80104d9c:	85 c0                	test   %eax,%eax
80104d9e:	78 10                	js     80104db0 <sys_kill+0x2c>
    return -1;
  return kill(pid);
80104da0:	83 ec 0c             	sub    $0xc,%esp
80104da3:	ff 75 f4             	pushl  -0xc(%ebp)
80104da6:	e8 e0 eb ff ff       	call   8010398b <kill>
80104dab:	83 c4 10             	add    $0x10,%esp
}
80104dae:	c9                   	leave  
80104daf:	c3                   	ret    
    return -1;
80104db0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104db5:	eb f7                	jmp    80104dae <sys_kill+0x2a>

80104db7 <sys_getpid>:

int
sys_getpid(void)
{
80104db7:	f3 0f 1e fb          	endbr32 
80104dbb:	55                   	push   %ebp
80104dbc:	89 e5                	mov    %esp,%ebp
80104dbe:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80104dc1:	e8 68 e5 ff ff       	call   8010332e <myproc>
80104dc6:	8b 40 10             	mov    0x10(%eax),%eax
}
80104dc9:	c9                   	leave  
80104dca:	c3                   	ret    

80104dcb <sys_sbrk>:

int
sys_sbrk(void)
{
80104dcb:	f3 0f 1e fb          	endbr32 
80104dcf:	55                   	push   %ebp
80104dd0:	89 e5                	mov    %esp,%ebp
80104dd2:	53                   	push   %ebx
80104dd3:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80104dd6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104dd9:	50                   	push   %eax
80104dda:	6a 00                	push   $0x0
80104ddc:	e8 6d f2 ff ff       	call   8010404e <argint>
80104de1:	83 c4 10             	add    $0x10,%esp
80104de4:	85 c0                	test   %eax,%eax
80104de6:	78 20                	js     80104e08 <sys_sbrk+0x3d>
    return -1;
  addr = myproc()->sz;
80104de8:	e8 41 e5 ff ff       	call   8010332e <myproc>
80104ded:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80104def:	83 ec 0c             	sub    $0xc,%esp
80104df2:	ff 75 f4             	pushl  -0xc(%ebp)
80104df5:	e8 48 e6 ff ff       	call   80103442 <growproc>
80104dfa:	83 c4 10             	add    $0x10,%esp
80104dfd:	85 c0                	test   %eax,%eax
80104dff:	78 0e                	js     80104e0f <sys_sbrk+0x44>
    return -1;
  return addr;
}
80104e01:	89 d8                	mov    %ebx,%eax
80104e03:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e06:	c9                   	leave  
80104e07:	c3                   	ret    
    return -1;
80104e08:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104e0d:	eb f2                	jmp    80104e01 <sys_sbrk+0x36>
    return -1;
80104e0f:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104e14:	eb eb                	jmp    80104e01 <sys_sbrk+0x36>

80104e16 <sys_sleep>:

int
sys_sleep(void)
{
80104e16:	f3 0f 1e fb          	endbr32 
80104e1a:	55                   	push   %ebp
80104e1b:	89 e5                	mov    %esp,%ebp
80104e1d:	53                   	push   %ebx
80104e1e:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80104e21:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e24:	50                   	push   %eax
80104e25:	6a 00                	push   $0x0
80104e27:	e8 22 f2 ff ff       	call   8010404e <argint>
80104e2c:	83 c4 10             	add    $0x10,%esp
80104e2f:	85 c0                	test   %eax,%eax
80104e31:	78 75                	js     80104ea8 <sys_sleep+0x92>
    return -1;
  acquire(&tickslock);
80104e33:	83 ec 0c             	sub    $0xc,%esp
80104e36:	68 60 4c 11 80       	push   $0x80114c60
80104e3b:	e8 e4 ee ff ff       	call   80103d24 <acquire>
  ticks0 = ticks;
80104e40:	8b 1d a0 54 11 80    	mov    0x801154a0,%ebx
  while(ticks - ticks0 < n){
80104e46:	83 c4 10             	add    $0x10,%esp
80104e49:	a1 a0 54 11 80       	mov    0x801154a0,%eax
80104e4e:	29 d8                	sub    %ebx,%eax
80104e50:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80104e53:	73 39                	jae    80104e8e <sys_sleep+0x78>
    if(myproc()->killed){
80104e55:	e8 d4 e4 ff ff       	call   8010332e <myproc>
80104e5a:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80104e5e:	75 17                	jne    80104e77 <sys_sleep+0x61>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80104e60:	83 ec 08             	sub    $0x8,%esp
80104e63:	68 60 4c 11 80       	push   $0x80114c60
80104e68:	68 a0 54 11 80       	push   $0x801154a0
80104e6d:	e8 7f e9 ff ff       	call   801037f1 <sleep>
80104e72:	83 c4 10             	add    $0x10,%esp
80104e75:	eb d2                	jmp    80104e49 <sys_sleep+0x33>
      release(&tickslock);
80104e77:	83 ec 0c             	sub    $0xc,%esp
80104e7a:	68 60 4c 11 80       	push   $0x80114c60
80104e7f:	e8 09 ef ff ff       	call   80103d8d <release>
      return -1;
80104e84:	83 c4 10             	add    $0x10,%esp
80104e87:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e8c:	eb 15                	jmp    80104ea3 <sys_sleep+0x8d>
  }
  release(&tickslock);
80104e8e:	83 ec 0c             	sub    $0xc,%esp
80104e91:	68 60 4c 11 80       	push   $0x80114c60
80104e96:	e8 f2 ee ff ff       	call   80103d8d <release>
  return 0;
80104e9b:	83 c4 10             	add    $0x10,%esp
80104e9e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104ea3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ea6:	c9                   	leave  
80104ea7:	c3                   	ret    
    return -1;
80104ea8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ead:	eb f4                	jmp    80104ea3 <sys_sleep+0x8d>

80104eaf <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80104eaf:	f3 0f 1e fb          	endbr32 
80104eb3:	55                   	push   %ebp
80104eb4:	89 e5                	mov    %esp,%ebp
80104eb6:	53                   	push   %ebx
80104eb7:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80104eba:	68 60 4c 11 80       	push   $0x80114c60
80104ebf:	e8 60 ee ff ff       	call   80103d24 <acquire>
  xticks = ticks;
80104ec4:	8b 1d a0 54 11 80    	mov    0x801154a0,%ebx
  release(&tickslock);
80104eca:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
80104ed1:	e8 b7 ee ff ff       	call   80103d8d <release>
  return xticks;
}
80104ed6:	89 d8                	mov    %ebx,%eax
80104ed8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104edb:	c9                   	leave  
80104edc:	c3                   	ret    

80104edd <sys_yield>:

int
sys_yield(void)
{
80104edd:	f3 0f 1e fb          	endbr32 
80104ee1:	55                   	push   %ebp
80104ee2:	89 e5                	mov    %esp,%ebp
80104ee4:	83 ec 08             	sub    $0x8,%esp
  yield();
80104ee7:	e8 cf e8 ff ff       	call   801037bb <yield>
  return 0;
}
80104eec:	b8 00 00 00 00       	mov    $0x0,%eax
80104ef1:	c9                   	leave  
80104ef2:	c3                   	ret    

80104ef3 <sys_shutdown>:

int sys_shutdown(void)
{
80104ef3:	f3 0f 1e fb          	endbr32 
80104ef7:	55                   	push   %ebp
80104ef8:	89 e5                	mov    %esp,%ebp
80104efa:	83 ec 08             	sub    $0x8,%esp
  shutdown();
80104efd:	e8 ad d3 ff ff       	call   801022af <shutdown>
  return 0;
}
80104f02:	b8 00 00 00 00       	mov    $0x0,%eax
80104f07:	c9                   	leave  
80104f08:	c3                   	ret    

80104f09 <alltraps>:
80104f09:	1e                   	push   %ds
80104f0a:	06                   	push   %es
80104f0b:	0f a0                	push   %fs
80104f0d:	0f a8                	push   %gs
80104f0f:	60                   	pusha  
80104f10:	66 b8 10 00          	mov    $0x10,%ax
80104f14:	8e d8                	mov    %eax,%ds
80104f16:	8e c0                	mov    %eax,%es
80104f18:	54                   	push   %esp
80104f19:	e8 eb 00 00 00       	call   80105009 <trap>
80104f1e:	83 c4 04             	add    $0x4,%esp

80104f21 <trapret>:
80104f21:	61                   	popa   
80104f22:	0f a9                	pop    %gs
80104f24:	0f a1                	pop    %fs
80104f26:	07                   	pop    %es
80104f27:	1f                   	pop    %ds
80104f28:	83 c4 08             	add    $0x8,%esp
80104f2b:	cf                   	iret   

80104f2c <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80104f2c:	f3 0f 1e fb          	endbr32 
80104f30:	55                   	push   %ebp
80104f31:	89 e5                	mov    %esp,%ebp
80104f33:	83 ec 08             	sub    $0x8,%esp
  int i;

  for(i = 0; i < 256; i++)
80104f36:	b8 00 00 00 00       	mov    $0x0,%eax
80104f3b:	3d ff 00 00 00       	cmp    $0xff,%eax
80104f40:	7f 4c                	jg     80104f8e <tvinit+0x62>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80104f42:	8b 0c 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%ecx
80104f49:	66 89 0c c5 a0 4c 11 	mov    %cx,-0x7feeb360(,%eax,8)
80104f50:	80 
80104f51:	66 c7 04 c5 a2 4c 11 	movw   $0x8,-0x7feeb35e(,%eax,8)
80104f58:	80 08 00 
80104f5b:	c6 04 c5 a4 4c 11 80 	movb   $0x0,-0x7feeb35c(,%eax,8)
80104f62:	00 
80104f63:	0f b6 14 c5 a5 4c 11 	movzbl -0x7feeb35b(,%eax,8),%edx
80104f6a:	80 
80104f6b:	83 e2 f0             	and    $0xfffffff0,%edx
80104f6e:	83 ca 0e             	or     $0xe,%edx
80104f71:	83 e2 8f             	and    $0xffffff8f,%edx
80104f74:	83 ca 80             	or     $0xffffff80,%edx
80104f77:	88 14 c5 a5 4c 11 80 	mov    %dl,-0x7feeb35b(,%eax,8)
80104f7e:	c1 e9 10             	shr    $0x10,%ecx
80104f81:	66 89 0c c5 a6 4c 11 	mov    %cx,-0x7feeb35a(,%eax,8)
80104f88:	80 
  for(i = 0; i < 256; i++)
80104f89:	83 c0 01             	add    $0x1,%eax
80104f8c:	eb ad                	jmp    80104f3b <tvinit+0xf>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80104f8e:	8b 15 08 a1 10 80    	mov    0x8010a108,%edx
80104f94:	66 89 15 a0 4e 11 80 	mov    %dx,0x80114ea0
80104f9b:	66 c7 05 a2 4e 11 80 	movw   $0x8,0x80114ea2
80104fa2:	08 00 
80104fa4:	c6 05 a4 4e 11 80 00 	movb   $0x0,0x80114ea4
80104fab:	0f b6 05 a5 4e 11 80 	movzbl 0x80114ea5,%eax
80104fb2:	83 c8 0f             	or     $0xf,%eax
80104fb5:	83 e0 ef             	and    $0xffffffef,%eax
80104fb8:	83 c8 e0             	or     $0xffffffe0,%eax
80104fbb:	a2 a5 4e 11 80       	mov    %al,0x80114ea5
80104fc0:	c1 ea 10             	shr    $0x10,%edx
80104fc3:	66 89 15 a6 4e 11 80 	mov    %dx,0x80114ea6

  initlock(&tickslock, "time");
80104fca:	83 ec 08             	sub    $0x8,%esp
80104fcd:	68 e5 6f 10 80       	push   $0x80106fe5
80104fd2:	68 60 4c 11 80       	push   $0x80114c60
80104fd7:	e8 f8 eb ff ff       	call   80103bd4 <initlock>
}
80104fdc:	83 c4 10             	add    $0x10,%esp
80104fdf:	c9                   	leave  
80104fe0:	c3                   	ret    

80104fe1 <idtinit>:

void
idtinit(void)
{
80104fe1:	f3 0f 1e fb          	endbr32 
80104fe5:	55                   	push   %ebp
80104fe6:	89 e5                	mov    %esp,%ebp
80104fe8:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80104feb:	66 c7 45 fa ff 07    	movw   $0x7ff,-0x6(%ebp)
  pd[1] = (uint)p;
80104ff1:	b8 a0 4c 11 80       	mov    $0x80114ca0,%eax
80104ff6:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80104ffa:	c1 e8 10             	shr    $0x10,%eax
80104ffd:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105001:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105004:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105007:	c9                   	leave  
80105008:	c3                   	ret    

80105009 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105009:	f3 0f 1e fb          	endbr32 
8010500d:	55                   	push   %ebp
8010500e:	89 e5                	mov    %esp,%ebp
80105010:	57                   	push   %edi
80105011:	56                   	push   %esi
80105012:	53                   	push   %ebx
80105013:	83 ec 1c             	sub    $0x1c,%esp
80105016:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105019:	8b 43 30             	mov    0x30(%ebx),%eax
8010501c:	83 f8 40             	cmp    $0x40,%eax
8010501f:	74 14                	je     80105035 <trap+0x2c>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105021:	83 e8 20             	sub    $0x20,%eax
80105024:	83 f8 1f             	cmp    $0x1f,%eax
80105027:	0f 87 3b 01 00 00    	ja     80105168 <trap+0x15f>
8010502d:	3e ff 24 85 8c 70 10 	notrack jmp *-0x7fef8f74(,%eax,4)
80105034:	80 
    if(myproc()->killed)
80105035:	e8 f4 e2 ff ff       	call   8010332e <myproc>
8010503a:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
8010503e:	75 1f                	jne    8010505f <trap+0x56>
    myproc()->tf = tf;
80105040:	e8 e9 e2 ff ff       	call   8010332e <myproc>
80105045:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105048:	e8 d0 f0 ff ff       	call   8010411d <syscall>
    if(myproc()->killed)
8010504d:	e8 dc e2 ff ff       	call   8010332e <myproc>
80105052:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80105056:	74 7e                	je     801050d6 <trap+0xcd>
      exit();
80105058:	e8 94 e6 ff ff       	call   801036f1 <exit>
    return;
8010505d:	eb 77                	jmp    801050d6 <trap+0xcd>
      exit();
8010505f:	e8 8d e6 ff ff       	call   801036f1 <exit>
80105064:	eb da                	jmp    80105040 <trap+0x37>
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80105066:	e8 a4 e2 ff ff       	call   8010330f <cpuid>
8010506b:	85 c0                	test   %eax,%eax
8010506d:	74 6f                	je     801050de <trap+0xd5>
      acquire(&tickslock);
      ticks++;
      wakeup(&ticks);
      release(&tickslock);
    }
    lapiceoi();
8010506f:	e8 f5 d3 ff ff       	call   80102469 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105074:	e8 b5 e2 ff ff       	call   8010332e <myproc>
80105079:	85 c0                	test   %eax,%eax
8010507b:	74 1c                	je     80105099 <trap+0x90>
8010507d:	e8 ac e2 ff ff       	call   8010332e <myproc>
80105082:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80105086:	74 11                	je     80105099 <trap+0x90>
80105088:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
8010508c:	83 e0 03             	and    $0x3,%eax
8010508f:	66 83 f8 03          	cmp    $0x3,%ax
80105093:	0f 84 62 01 00 00    	je     801051fb <trap+0x1f2>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105099:	e8 90 e2 ff ff       	call   8010332e <myproc>
8010509e:	85 c0                	test   %eax,%eax
801050a0:	74 0f                	je     801050b1 <trap+0xa8>
801050a2:	e8 87 e2 ff ff       	call   8010332e <myproc>
801050a7:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801050ab:	0f 84 54 01 00 00    	je     80105205 <trap+0x1fc>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801050b1:	e8 78 e2 ff ff       	call   8010332e <myproc>
801050b6:	85 c0                	test   %eax,%eax
801050b8:	74 1c                	je     801050d6 <trap+0xcd>
801050ba:	e8 6f e2 ff ff       	call   8010332e <myproc>
801050bf:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
801050c3:	74 11                	je     801050d6 <trap+0xcd>
801050c5:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801050c9:	83 e0 03             	and    $0x3,%eax
801050cc:	66 83 f8 03          	cmp    $0x3,%ax
801050d0:	0f 84 43 01 00 00    	je     80105219 <trap+0x210>
    exit();
}
801050d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801050d9:	5b                   	pop    %ebx
801050da:	5e                   	pop    %esi
801050db:	5f                   	pop    %edi
801050dc:	5d                   	pop    %ebp
801050dd:	c3                   	ret    
      acquire(&tickslock);
801050de:	83 ec 0c             	sub    $0xc,%esp
801050e1:	68 60 4c 11 80       	push   $0x80114c60
801050e6:	e8 39 ec ff ff       	call   80103d24 <acquire>
      ticks++;
801050eb:	83 05 a0 54 11 80 01 	addl   $0x1,0x801154a0
      wakeup(&ticks);
801050f2:	c7 04 24 a0 54 11 80 	movl   $0x801154a0,(%esp)
801050f9:	e8 60 e8 ff ff       	call   8010395e <wakeup>
      release(&tickslock);
801050fe:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
80105105:	e8 83 ec ff ff       	call   80103d8d <release>
8010510a:	83 c4 10             	add    $0x10,%esp
8010510d:	e9 5d ff ff ff       	jmp    8010506f <trap+0x66>
    ideintr();
80105112:	e8 d5 cc ff ff       	call   80101dec <ideintr>
    lapiceoi();
80105117:	e8 4d d3 ff ff       	call   80102469 <lapiceoi>
    break;
8010511c:	e9 53 ff ff ff       	jmp    80105074 <trap+0x6b>
    kbdintr();
80105121:	e8 70 d1 ff ff       	call   80102296 <kbdintr>
    lapiceoi();
80105126:	e8 3e d3 ff ff       	call   80102469 <lapiceoi>
    break;
8010512b:	e9 44 ff ff ff       	jmp    80105074 <trap+0x6b>
    uartintr();
80105130:	e8 0a 02 00 00       	call   8010533f <uartintr>
    lapiceoi();
80105135:	e8 2f d3 ff ff       	call   80102469 <lapiceoi>
    break;
8010513a:	e9 35 ff ff ff       	jmp    80105074 <trap+0x6b>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010513f:	8b 7b 38             	mov    0x38(%ebx),%edi
            cpuid(), tf->cs, tf->eip);
80105142:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105146:	e8 c4 e1 ff ff       	call   8010330f <cpuid>
8010514b:	57                   	push   %edi
8010514c:	0f b7 f6             	movzwl %si,%esi
8010514f:	56                   	push   %esi
80105150:	50                   	push   %eax
80105151:	68 f0 6f 10 80       	push   $0x80106ff0
80105156:	e8 ce b4 ff ff       	call   80100629 <cprintf>
    lapiceoi();
8010515b:	e8 09 d3 ff ff       	call   80102469 <lapiceoi>
    break;
80105160:	83 c4 10             	add    $0x10,%esp
80105163:	e9 0c ff ff ff       	jmp    80105074 <trap+0x6b>
    if(myproc() == 0 || (tf->cs&3) == 0){
80105168:	e8 c1 e1 ff ff       	call   8010332e <myproc>
8010516d:	85 c0                	test   %eax,%eax
8010516f:	74 5f                	je     801051d0 <trap+0x1c7>
80105171:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105175:	74 59                	je     801051d0 <trap+0x1c7>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105177:	0f 20 d7             	mov    %cr2,%edi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010517a:	8b 43 38             	mov    0x38(%ebx),%eax
8010517d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105180:	e8 8a e1 ff ff       	call   8010330f <cpuid>
80105185:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105188:	8b 53 34             	mov    0x34(%ebx),%edx
8010518b:	89 55 dc             	mov    %edx,-0x24(%ebp)
8010518e:	8b 73 30             	mov    0x30(%ebx),%esi
            myproc()->pid, myproc()->name, tf->trapno,
80105191:	e8 98 e1 ff ff       	call   8010332e <myproc>
80105196:	8d 48 6c             	lea    0x6c(%eax),%ecx
80105199:	89 4d d8             	mov    %ecx,-0x28(%ebp)
8010519c:	e8 8d e1 ff ff       	call   8010332e <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801051a1:	57                   	push   %edi
801051a2:	ff 75 e4             	pushl  -0x1c(%ebp)
801051a5:	ff 75 e0             	pushl  -0x20(%ebp)
801051a8:	ff 75 dc             	pushl  -0x24(%ebp)
801051ab:	56                   	push   %esi
801051ac:	ff 75 d8             	pushl  -0x28(%ebp)
801051af:	ff 70 10             	pushl  0x10(%eax)
801051b2:	68 48 70 10 80       	push   $0x80107048
801051b7:	e8 6d b4 ff ff       	call   80100629 <cprintf>
    myproc()->killed = 1;
801051bc:	83 c4 20             	add    $0x20,%esp
801051bf:	e8 6a e1 ff ff       	call   8010332e <myproc>
801051c4:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801051cb:	e9 a4 fe ff ff       	jmp    80105074 <trap+0x6b>
801051d0:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801051d3:	8b 73 38             	mov    0x38(%ebx),%esi
801051d6:	e8 34 e1 ff ff       	call   8010330f <cpuid>
801051db:	83 ec 0c             	sub    $0xc,%esp
801051de:	57                   	push   %edi
801051df:	56                   	push   %esi
801051e0:	50                   	push   %eax
801051e1:	ff 73 30             	pushl  0x30(%ebx)
801051e4:	68 14 70 10 80       	push   $0x80107014
801051e9:	e8 3b b4 ff ff       	call   80100629 <cprintf>
      panic("trap");
801051ee:	83 c4 14             	add    $0x14,%esp
801051f1:	68 ea 6f 10 80       	push   $0x80106fea
801051f6:	e8 61 b1 ff ff       	call   8010035c <panic>
    exit();
801051fb:	e8 f1 e4 ff ff       	call   801036f1 <exit>
80105200:	e9 94 fe ff ff       	jmp    80105099 <trap+0x90>
  if(myproc() && myproc()->state == RUNNING &&
80105205:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105209:	0f 85 a2 fe ff ff    	jne    801050b1 <trap+0xa8>
    yield();
8010520f:	e8 a7 e5 ff ff       	call   801037bb <yield>
80105214:	e9 98 fe ff ff       	jmp    801050b1 <trap+0xa8>
    exit();
80105219:	e8 d3 e4 ff ff       	call   801036f1 <exit>
8010521e:	e9 b3 fe ff ff       	jmp    801050d6 <trap+0xcd>

80105223 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80105223:	f3 0f 1e fb          	endbr32 
  if(!uart)
80105227:	83 3d bc a5 10 80 00 	cmpl   $0x0,0x8010a5bc
8010522e:	74 14                	je     80105244 <uartgetc+0x21>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105230:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105235:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105236:	a8 01                	test   $0x1,%al
80105238:	74 10                	je     8010524a <uartgetc+0x27>
8010523a:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010523f:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105240:	0f b6 c0             	movzbl %al,%eax
80105243:	c3                   	ret    
    return -1;
80105244:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105249:	c3                   	ret    
    return -1;
8010524a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010524f:	c3                   	ret    

80105250 <uartputc>:
{
80105250:	f3 0f 1e fb          	endbr32 
  if(!uart)
80105254:	83 3d bc a5 10 80 00 	cmpl   $0x0,0x8010a5bc
8010525b:	74 3b                	je     80105298 <uartputc+0x48>
{
8010525d:	55                   	push   %ebp
8010525e:	89 e5                	mov    %esp,%ebp
80105260:	53                   	push   %ebx
80105261:	83 ec 04             	sub    $0x4,%esp
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105264:	bb 00 00 00 00       	mov    $0x0,%ebx
80105269:	83 fb 7f             	cmp    $0x7f,%ebx
8010526c:	7f 1c                	jg     8010528a <uartputc+0x3a>
8010526e:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105273:	ec                   	in     (%dx),%al
80105274:	a8 20                	test   $0x20,%al
80105276:	75 12                	jne    8010528a <uartputc+0x3a>
    microdelay(10);
80105278:	83 ec 0c             	sub    $0xc,%esp
8010527b:	6a 0a                	push   $0xa
8010527d:	e8 0c d2 ff ff       	call   8010248e <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105282:	83 c3 01             	add    $0x1,%ebx
80105285:	83 c4 10             	add    $0x10,%esp
80105288:	eb df                	jmp    80105269 <uartputc+0x19>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010528a:	8b 45 08             	mov    0x8(%ebp),%eax
8010528d:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105292:	ee                   	out    %al,(%dx)
}
80105293:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105296:	c9                   	leave  
80105297:	c3                   	ret    
80105298:	c3                   	ret    

80105299 <uartinit>:
{
80105299:	f3 0f 1e fb          	endbr32 
8010529d:	55                   	push   %ebp
8010529e:	89 e5                	mov    %esp,%ebp
801052a0:	56                   	push   %esi
801052a1:	53                   	push   %ebx
801052a2:	b9 00 00 00 00       	mov    $0x0,%ecx
801052a7:	ba fa 03 00 00       	mov    $0x3fa,%edx
801052ac:	89 c8                	mov    %ecx,%eax
801052ae:	ee                   	out    %al,(%dx)
801052af:	be fb 03 00 00       	mov    $0x3fb,%esi
801052b4:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801052b9:	89 f2                	mov    %esi,%edx
801052bb:	ee                   	out    %al,(%dx)
801052bc:	b8 0c 00 00 00       	mov    $0xc,%eax
801052c1:	ba f8 03 00 00       	mov    $0x3f8,%edx
801052c6:	ee                   	out    %al,(%dx)
801052c7:	bb f9 03 00 00       	mov    $0x3f9,%ebx
801052cc:	89 c8                	mov    %ecx,%eax
801052ce:	89 da                	mov    %ebx,%edx
801052d0:	ee                   	out    %al,(%dx)
801052d1:	b8 03 00 00 00       	mov    $0x3,%eax
801052d6:	89 f2                	mov    %esi,%edx
801052d8:	ee                   	out    %al,(%dx)
801052d9:	ba fc 03 00 00       	mov    $0x3fc,%edx
801052de:	89 c8                	mov    %ecx,%eax
801052e0:	ee                   	out    %al,(%dx)
801052e1:	b8 01 00 00 00       	mov    $0x1,%eax
801052e6:	89 da                	mov    %ebx,%edx
801052e8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801052e9:	ba fd 03 00 00       	mov    $0x3fd,%edx
801052ee:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801052ef:	3c ff                	cmp    $0xff,%al
801052f1:	74 45                	je     80105338 <uartinit+0x9f>
  uart = 1;
801052f3:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
801052fa:	00 00 00 
801052fd:	ba fa 03 00 00       	mov    $0x3fa,%edx
80105302:	ec                   	in     (%dx),%al
80105303:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105308:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105309:	83 ec 08             	sub    $0x8,%esp
8010530c:	6a 00                	push   $0x0
8010530e:	6a 04                	push   $0x4
80105310:	e8 e6 cc ff ff       	call   80101ffb <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80105315:	83 c4 10             	add    $0x10,%esp
80105318:	bb 0c 71 10 80       	mov    $0x8010710c,%ebx
8010531d:	eb 12                	jmp    80105331 <uartinit+0x98>
    uartputc(*p);
8010531f:	83 ec 0c             	sub    $0xc,%esp
80105322:	0f be c0             	movsbl %al,%eax
80105325:	50                   	push   %eax
80105326:	e8 25 ff ff ff       	call   80105250 <uartputc>
  for(p="xv6...\n"; *p; p++)
8010532b:	83 c3 01             	add    $0x1,%ebx
8010532e:	83 c4 10             	add    $0x10,%esp
80105331:	0f b6 03             	movzbl (%ebx),%eax
80105334:	84 c0                	test   %al,%al
80105336:	75 e7                	jne    8010531f <uartinit+0x86>
}
80105338:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010533b:	5b                   	pop    %ebx
8010533c:	5e                   	pop    %esi
8010533d:	5d                   	pop    %ebp
8010533e:	c3                   	ret    

8010533f <uartintr>:

void
uartintr(void)
{
8010533f:	f3 0f 1e fb          	endbr32 
80105343:	55                   	push   %ebp
80105344:	89 e5                	mov    %esp,%ebp
80105346:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105349:	68 23 52 10 80       	push   $0x80105223
8010534e:	e8 06 b4 ff ff       	call   80100759 <consoleintr>
}
80105353:	83 c4 10             	add    $0x10,%esp
80105356:	c9                   	leave  
80105357:	c3                   	ret    

80105358 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105358:	6a 00                	push   $0x0
  pushl $0
8010535a:	6a 00                	push   $0x0
  jmp alltraps
8010535c:	e9 a8 fb ff ff       	jmp    80104f09 <alltraps>

80105361 <vector1>:
.globl vector1
vector1:
  pushl $0
80105361:	6a 00                	push   $0x0
  pushl $1
80105363:	6a 01                	push   $0x1
  jmp alltraps
80105365:	e9 9f fb ff ff       	jmp    80104f09 <alltraps>

8010536a <vector2>:
.globl vector2
vector2:
  pushl $0
8010536a:	6a 00                	push   $0x0
  pushl $2
8010536c:	6a 02                	push   $0x2
  jmp alltraps
8010536e:	e9 96 fb ff ff       	jmp    80104f09 <alltraps>

80105373 <vector3>:
.globl vector3
vector3:
  pushl $0
80105373:	6a 00                	push   $0x0
  pushl $3
80105375:	6a 03                	push   $0x3
  jmp alltraps
80105377:	e9 8d fb ff ff       	jmp    80104f09 <alltraps>

8010537c <vector4>:
.globl vector4
vector4:
  pushl $0
8010537c:	6a 00                	push   $0x0
  pushl $4
8010537e:	6a 04                	push   $0x4
  jmp alltraps
80105380:	e9 84 fb ff ff       	jmp    80104f09 <alltraps>

80105385 <vector5>:
.globl vector5
vector5:
  pushl $0
80105385:	6a 00                	push   $0x0
  pushl $5
80105387:	6a 05                	push   $0x5
  jmp alltraps
80105389:	e9 7b fb ff ff       	jmp    80104f09 <alltraps>

8010538e <vector6>:
.globl vector6
vector6:
  pushl $0
8010538e:	6a 00                	push   $0x0
  pushl $6
80105390:	6a 06                	push   $0x6
  jmp alltraps
80105392:	e9 72 fb ff ff       	jmp    80104f09 <alltraps>

80105397 <vector7>:
.globl vector7
vector7:
  pushl $0
80105397:	6a 00                	push   $0x0
  pushl $7
80105399:	6a 07                	push   $0x7
  jmp alltraps
8010539b:	e9 69 fb ff ff       	jmp    80104f09 <alltraps>

801053a0 <vector8>:
.globl vector8
vector8:
  pushl $8
801053a0:	6a 08                	push   $0x8
  jmp alltraps
801053a2:	e9 62 fb ff ff       	jmp    80104f09 <alltraps>

801053a7 <vector9>:
.globl vector9
vector9:
  pushl $0
801053a7:	6a 00                	push   $0x0
  pushl $9
801053a9:	6a 09                	push   $0x9
  jmp alltraps
801053ab:	e9 59 fb ff ff       	jmp    80104f09 <alltraps>

801053b0 <vector10>:
.globl vector10
vector10:
  pushl $10
801053b0:	6a 0a                	push   $0xa
  jmp alltraps
801053b2:	e9 52 fb ff ff       	jmp    80104f09 <alltraps>

801053b7 <vector11>:
.globl vector11
vector11:
  pushl $11
801053b7:	6a 0b                	push   $0xb
  jmp alltraps
801053b9:	e9 4b fb ff ff       	jmp    80104f09 <alltraps>

801053be <vector12>:
.globl vector12
vector12:
  pushl $12
801053be:	6a 0c                	push   $0xc
  jmp alltraps
801053c0:	e9 44 fb ff ff       	jmp    80104f09 <alltraps>

801053c5 <vector13>:
.globl vector13
vector13:
  pushl $13
801053c5:	6a 0d                	push   $0xd
  jmp alltraps
801053c7:	e9 3d fb ff ff       	jmp    80104f09 <alltraps>

801053cc <vector14>:
.globl vector14
vector14:
  pushl $14
801053cc:	6a 0e                	push   $0xe
  jmp alltraps
801053ce:	e9 36 fb ff ff       	jmp    80104f09 <alltraps>

801053d3 <vector15>:
.globl vector15
vector15:
  pushl $0
801053d3:	6a 00                	push   $0x0
  pushl $15
801053d5:	6a 0f                	push   $0xf
  jmp alltraps
801053d7:	e9 2d fb ff ff       	jmp    80104f09 <alltraps>

801053dc <vector16>:
.globl vector16
vector16:
  pushl $0
801053dc:	6a 00                	push   $0x0
  pushl $16
801053de:	6a 10                	push   $0x10
  jmp alltraps
801053e0:	e9 24 fb ff ff       	jmp    80104f09 <alltraps>

801053e5 <vector17>:
.globl vector17
vector17:
  pushl $17
801053e5:	6a 11                	push   $0x11
  jmp alltraps
801053e7:	e9 1d fb ff ff       	jmp    80104f09 <alltraps>

801053ec <vector18>:
.globl vector18
vector18:
  pushl $0
801053ec:	6a 00                	push   $0x0
  pushl $18
801053ee:	6a 12                	push   $0x12
  jmp alltraps
801053f0:	e9 14 fb ff ff       	jmp    80104f09 <alltraps>

801053f5 <vector19>:
.globl vector19
vector19:
  pushl $0
801053f5:	6a 00                	push   $0x0
  pushl $19
801053f7:	6a 13                	push   $0x13
  jmp alltraps
801053f9:	e9 0b fb ff ff       	jmp    80104f09 <alltraps>

801053fe <vector20>:
.globl vector20
vector20:
  pushl $0
801053fe:	6a 00                	push   $0x0
  pushl $20
80105400:	6a 14                	push   $0x14
  jmp alltraps
80105402:	e9 02 fb ff ff       	jmp    80104f09 <alltraps>

80105407 <vector21>:
.globl vector21
vector21:
  pushl $0
80105407:	6a 00                	push   $0x0
  pushl $21
80105409:	6a 15                	push   $0x15
  jmp alltraps
8010540b:	e9 f9 fa ff ff       	jmp    80104f09 <alltraps>

80105410 <vector22>:
.globl vector22
vector22:
  pushl $0
80105410:	6a 00                	push   $0x0
  pushl $22
80105412:	6a 16                	push   $0x16
  jmp alltraps
80105414:	e9 f0 fa ff ff       	jmp    80104f09 <alltraps>

80105419 <vector23>:
.globl vector23
vector23:
  pushl $0
80105419:	6a 00                	push   $0x0
  pushl $23
8010541b:	6a 17                	push   $0x17
  jmp alltraps
8010541d:	e9 e7 fa ff ff       	jmp    80104f09 <alltraps>

80105422 <vector24>:
.globl vector24
vector24:
  pushl $0
80105422:	6a 00                	push   $0x0
  pushl $24
80105424:	6a 18                	push   $0x18
  jmp alltraps
80105426:	e9 de fa ff ff       	jmp    80104f09 <alltraps>

8010542b <vector25>:
.globl vector25
vector25:
  pushl $0
8010542b:	6a 00                	push   $0x0
  pushl $25
8010542d:	6a 19                	push   $0x19
  jmp alltraps
8010542f:	e9 d5 fa ff ff       	jmp    80104f09 <alltraps>

80105434 <vector26>:
.globl vector26
vector26:
  pushl $0
80105434:	6a 00                	push   $0x0
  pushl $26
80105436:	6a 1a                	push   $0x1a
  jmp alltraps
80105438:	e9 cc fa ff ff       	jmp    80104f09 <alltraps>

8010543d <vector27>:
.globl vector27
vector27:
  pushl $0
8010543d:	6a 00                	push   $0x0
  pushl $27
8010543f:	6a 1b                	push   $0x1b
  jmp alltraps
80105441:	e9 c3 fa ff ff       	jmp    80104f09 <alltraps>

80105446 <vector28>:
.globl vector28
vector28:
  pushl $0
80105446:	6a 00                	push   $0x0
  pushl $28
80105448:	6a 1c                	push   $0x1c
  jmp alltraps
8010544a:	e9 ba fa ff ff       	jmp    80104f09 <alltraps>

8010544f <vector29>:
.globl vector29
vector29:
  pushl $0
8010544f:	6a 00                	push   $0x0
  pushl $29
80105451:	6a 1d                	push   $0x1d
  jmp alltraps
80105453:	e9 b1 fa ff ff       	jmp    80104f09 <alltraps>

80105458 <vector30>:
.globl vector30
vector30:
  pushl $0
80105458:	6a 00                	push   $0x0
  pushl $30
8010545a:	6a 1e                	push   $0x1e
  jmp alltraps
8010545c:	e9 a8 fa ff ff       	jmp    80104f09 <alltraps>

80105461 <vector31>:
.globl vector31
vector31:
  pushl $0
80105461:	6a 00                	push   $0x0
  pushl $31
80105463:	6a 1f                	push   $0x1f
  jmp alltraps
80105465:	e9 9f fa ff ff       	jmp    80104f09 <alltraps>

8010546a <vector32>:
.globl vector32
vector32:
  pushl $0
8010546a:	6a 00                	push   $0x0
  pushl $32
8010546c:	6a 20                	push   $0x20
  jmp alltraps
8010546e:	e9 96 fa ff ff       	jmp    80104f09 <alltraps>

80105473 <vector33>:
.globl vector33
vector33:
  pushl $0
80105473:	6a 00                	push   $0x0
  pushl $33
80105475:	6a 21                	push   $0x21
  jmp alltraps
80105477:	e9 8d fa ff ff       	jmp    80104f09 <alltraps>

8010547c <vector34>:
.globl vector34
vector34:
  pushl $0
8010547c:	6a 00                	push   $0x0
  pushl $34
8010547e:	6a 22                	push   $0x22
  jmp alltraps
80105480:	e9 84 fa ff ff       	jmp    80104f09 <alltraps>

80105485 <vector35>:
.globl vector35
vector35:
  pushl $0
80105485:	6a 00                	push   $0x0
  pushl $35
80105487:	6a 23                	push   $0x23
  jmp alltraps
80105489:	e9 7b fa ff ff       	jmp    80104f09 <alltraps>

8010548e <vector36>:
.globl vector36
vector36:
  pushl $0
8010548e:	6a 00                	push   $0x0
  pushl $36
80105490:	6a 24                	push   $0x24
  jmp alltraps
80105492:	e9 72 fa ff ff       	jmp    80104f09 <alltraps>

80105497 <vector37>:
.globl vector37
vector37:
  pushl $0
80105497:	6a 00                	push   $0x0
  pushl $37
80105499:	6a 25                	push   $0x25
  jmp alltraps
8010549b:	e9 69 fa ff ff       	jmp    80104f09 <alltraps>

801054a0 <vector38>:
.globl vector38
vector38:
  pushl $0
801054a0:	6a 00                	push   $0x0
  pushl $38
801054a2:	6a 26                	push   $0x26
  jmp alltraps
801054a4:	e9 60 fa ff ff       	jmp    80104f09 <alltraps>

801054a9 <vector39>:
.globl vector39
vector39:
  pushl $0
801054a9:	6a 00                	push   $0x0
  pushl $39
801054ab:	6a 27                	push   $0x27
  jmp alltraps
801054ad:	e9 57 fa ff ff       	jmp    80104f09 <alltraps>

801054b2 <vector40>:
.globl vector40
vector40:
  pushl $0
801054b2:	6a 00                	push   $0x0
  pushl $40
801054b4:	6a 28                	push   $0x28
  jmp alltraps
801054b6:	e9 4e fa ff ff       	jmp    80104f09 <alltraps>

801054bb <vector41>:
.globl vector41
vector41:
  pushl $0
801054bb:	6a 00                	push   $0x0
  pushl $41
801054bd:	6a 29                	push   $0x29
  jmp alltraps
801054bf:	e9 45 fa ff ff       	jmp    80104f09 <alltraps>

801054c4 <vector42>:
.globl vector42
vector42:
  pushl $0
801054c4:	6a 00                	push   $0x0
  pushl $42
801054c6:	6a 2a                	push   $0x2a
  jmp alltraps
801054c8:	e9 3c fa ff ff       	jmp    80104f09 <alltraps>

801054cd <vector43>:
.globl vector43
vector43:
  pushl $0
801054cd:	6a 00                	push   $0x0
  pushl $43
801054cf:	6a 2b                	push   $0x2b
  jmp alltraps
801054d1:	e9 33 fa ff ff       	jmp    80104f09 <alltraps>

801054d6 <vector44>:
.globl vector44
vector44:
  pushl $0
801054d6:	6a 00                	push   $0x0
  pushl $44
801054d8:	6a 2c                	push   $0x2c
  jmp alltraps
801054da:	e9 2a fa ff ff       	jmp    80104f09 <alltraps>

801054df <vector45>:
.globl vector45
vector45:
  pushl $0
801054df:	6a 00                	push   $0x0
  pushl $45
801054e1:	6a 2d                	push   $0x2d
  jmp alltraps
801054e3:	e9 21 fa ff ff       	jmp    80104f09 <alltraps>

801054e8 <vector46>:
.globl vector46
vector46:
  pushl $0
801054e8:	6a 00                	push   $0x0
  pushl $46
801054ea:	6a 2e                	push   $0x2e
  jmp alltraps
801054ec:	e9 18 fa ff ff       	jmp    80104f09 <alltraps>

801054f1 <vector47>:
.globl vector47
vector47:
  pushl $0
801054f1:	6a 00                	push   $0x0
  pushl $47
801054f3:	6a 2f                	push   $0x2f
  jmp alltraps
801054f5:	e9 0f fa ff ff       	jmp    80104f09 <alltraps>

801054fa <vector48>:
.globl vector48
vector48:
  pushl $0
801054fa:	6a 00                	push   $0x0
  pushl $48
801054fc:	6a 30                	push   $0x30
  jmp alltraps
801054fe:	e9 06 fa ff ff       	jmp    80104f09 <alltraps>

80105503 <vector49>:
.globl vector49
vector49:
  pushl $0
80105503:	6a 00                	push   $0x0
  pushl $49
80105505:	6a 31                	push   $0x31
  jmp alltraps
80105507:	e9 fd f9 ff ff       	jmp    80104f09 <alltraps>

8010550c <vector50>:
.globl vector50
vector50:
  pushl $0
8010550c:	6a 00                	push   $0x0
  pushl $50
8010550e:	6a 32                	push   $0x32
  jmp alltraps
80105510:	e9 f4 f9 ff ff       	jmp    80104f09 <alltraps>

80105515 <vector51>:
.globl vector51
vector51:
  pushl $0
80105515:	6a 00                	push   $0x0
  pushl $51
80105517:	6a 33                	push   $0x33
  jmp alltraps
80105519:	e9 eb f9 ff ff       	jmp    80104f09 <alltraps>

8010551e <vector52>:
.globl vector52
vector52:
  pushl $0
8010551e:	6a 00                	push   $0x0
  pushl $52
80105520:	6a 34                	push   $0x34
  jmp alltraps
80105522:	e9 e2 f9 ff ff       	jmp    80104f09 <alltraps>

80105527 <vector53>:
.globl vector53
vector53:
  pushl $0
80105527:	6a 00                	push   $0x0
  pushl $53
80105529:	6a 35                	push   $0x35
  jmp alltraps
8010552b:	e9 d9 f9 ff ff       	jmp    80104f09 <alltraps>

80105530 <vector54>:
.globl vector54
vector54:
  pushl $0
80105530:	6a 00                	push   $0x0
  pushl $54
80105532:	6a 36                	push   $0x36
  jmp alltraps
80105534:	e9 d0 f9 ff ff       	jmp    80104f09 <alltraps>

80105539 <vector55>:
.globl vector55
vector55:
  pushl $0
80105539:	6a 00                	push   $0x0
  pushl $55
8010553b:	6a 37                	push   $0x37
  jmp alltraps
8010553d:	e9 c7 f9 ff ff       	jmp    80104f09 <alltraps>

80105542 <vector56>:
.globl vector56
vector56:
  pushl $0
80105542:	6a 00                	push   $0x0
  pushl $56
80105544:	6a 38                	push   $0x38
  jmp alltraps
80105546:	e9 be f9 ff ff       	jmp    80104f09 <alltraps>

8010554b <vector57>:
.globl vector57
vector57:
  pushl $0
8010554b:	6a 00                	push   $0x0
  pushl $57
8010554d:	6a 39                	push   $0x39
  jmp alltraps
8010554f:	e9 b5 f9 ff ff       	jmp    80104f09 <alltraps>

80105554 <vector58>:
.globl vector58
vector58:
  pushl $0
80105554:	6a 00                	push   $0x0
  pushl $58
80105556:	6a 3a                	push   $0x3a
  jmp alltraps
80105558:	e9 ac f9 ff ff       	jmp    80104f09 <alltraps>

8010555d <vector59>:
.globl vector59
vector59:
  pushl $0
8010555d:	6a 00                	push   $0x0
  pushl $59
8010555f:	6a 3b                	push   $0x3b
  jmp alltraps
80105561:	e9 a3 f9 ff ff       	jmp    80104f09 <alltraps>

80105566 <vector60>:
.globl vector60
vector60:
  pushl $0
80105566:	6a 00                	push   $0x0
  pushl $60
80105568:	6a 3c                	push   $0x3c
  jmp alltraps
8010556a:	e9 9a f9 ff ff       	jmp    80104f09 <alltraps>

8010556f <vector61>:
.globl vector61
vector61:
  pushl $0
8010556f:	6a 00                	push   $0x0
  pushl $61
80105571:	6a 3d                	push   $0x3d
  jmp alltraps
80105573:	e9 91 f9 ff ff       	jmp    80104f09 <alltraps>

80105578 <vector62>:
.globl vector62
vector62:
  pushl $0
80105578:	6a 00                	push   $0x0
  pushl $62
8010557a:	6a 3e                	push   $0x3e
  jmp alltraps
8010557c:	e9 88 f9 ff ff       	jmp    80104f09 <alltraps>

80105581 <vector63>:
.globl vector63
vector63:
  pushl $0
80105581:	6a 00                	push   $0x0
  pushl $63
80105583:	6a 3f                	push   $0x3f
  jmp alltraps
80105585:	e9 7f f9 ff ff       	jmp    80104f09 <alltraps>

8010558a <vector64>:
.globl vector64
vector64:
  pushl $0
8010558a:	6a 00                	push   $0x0
  pushl $64
8010558c:	6a 40                	push   $0x40
  jmp alltraps
8010558e:	e9 76 f9 ff ff       	jmp    80104f09 <alltraps>

80105593 <vector65>:
.globl vector65
vector65:
  pushl $0
80105593:	6a 00                	push   $0x0
  pushl $65
80105595:	6a 41                	push   $0x41
  jmp alltraps
80105597:	e9 6d f9 ff ff       	jmp    80104f09 <alltraps>

8010559c <vector66>:
.globl vector66
vector66:
  pushl $0
8010559c:	6a 00                	push   $0x0
  pushl $66
8010559e:	6a 42                	push   $0x42
  jmp alltraps
801055a0:	e9 64 f9 ff ff       	jmp    80104f09 <alltraps>

801055a5 <vector67>:
.globl vector67
vector67:
  pushl $0
801055a5:	6a 00                	push   $0x0
  pushl $67
801055a7:	6a 43                	push   $0x43
  jmp alltraps
801055a9:	e9 5b f9 ff ff       	jmp    80104f09 <alltraps>

801055ae <vector68>:
.globl vector68
vector68:
  pushl $0
801055ae:	6a 00                	push   $0x0
  pushl $68
801055b0:	6a 44                	push   $0x44
  jmp alltraps
801055b2:	e9 52 f9 ff ff       	jmp    80104f09 <alltraps>

801055b7 <vector69>:
.globl vector69
vector69:
  pushl $0
801055b7:	6a 00                	push   $0x0
  pushl $69
801055b9:	6a 45                	push   $0x45
  jmp alltraps
801055bb:	e9 49 f9 ff ff       	jmp    80104f09 <alltraps>

801055c0 <vector70>:
.globl vector70
vector70:
  pushl $0
801055c0:	6a 00                	push   $0x0
  pushl $70
801055c2:	6a 46                	push   $0x46
  jmp alltraps
801055c4:	e9 40 f9 ff ff       	jmp    80104f09 <alltraps>

801055c9 <vector71>:
.globl vector71
vector71:
  pushl $0
801055c9:	6a 00                	push   $0x0
  pushl $71
801055cb:	6a 47                	push   $0x47
  jmp alltraps
801055cd:	e9 37 f9 ff ff       	jmp    80104f09 <alltraps>

801055d2 <vector72>:
.globl vector72
vector72:
  pushl $0
801055d2:	6a 00                	push   $0x0
  pushl $72
801055d4:	6a 48                	push   $0x48
  jmp alltraps
801055d6:	e9 2e f9 ff ff       	jmp    80104f09 <alltraps>

801055db <vector73>:
.globl vector73
vector73:
  pushl $0
801055db:	6a 00                	push   $0x0
  pushl $73
801055dd:	6a 49                	push   $0x49
  jmp alltraps
801055df:	e9 25 f9 ff ff       	jmp    80104f09 <alltraps>

801055e4 <vector74>:
.globl vector74
vector74:
  pushl $0
801055e4:	6a 00                	push   $0x0
  pushl $74
801055e6:	6a 4a                	push   $0x4a
  jmp alltraps
801055e8:	e9 1c f9 ff ff       	jmp    80104f09 <alltraps>

801055ed <vector75>:
.globl vector75
vector75:
  pushl $0
801055ed:	6a 00                	push   $0x0
  pushl $75
801055ef:	6a 4b                	push   $0x4b
  jmp alltraps
801055f1:	e9 13 f9 ff ff       	jmp    80104f09 <alltraps>

801055f6 <vector76>:
.globl vector76
vector76:
  pushl $0
801055f6:	6a 00                	push   $0x0
  pushl $76
801055f8:	6a 4c                	push   $0x4c
  jmp alltraps
801055fa:	e9 0a f9 ff ff       	jmp    80104f09 <alltraps>

801055ff <vector77>:
.globl vector77
vector77:
  pushl $0
801055ff:	6a 00                	push   $0x0
  pushl $77
80105601:	6a 4d                	push   $0x4d
  jmp alltraps
80105603:	e9 01 f9 ff ff       	jmp    80104f09 <alltraps>

80105608 <vector78>:
.globl vector78
vector78:
  pushl $0
80105608:	6a 00                	push   $0x0
  pushl $78
8010560a:	6a 4e                	push   $0x4e
  jmp alltraps
8010560c:	e9 f8 f8 ff ff       	jmp    80104f09 <alltraps>

80105611 <vector79>:
.globl vector79
vector79:
  pushl $0
80105611:	6a 00                	push   $0x0
  pushl $79
80105613:	6a 4f                	push   $0x4f
  jmp alltraps
80105615:	e9 ef f8 ff ff       	jmp    80104f09 <alltraps>

8010561a <vector80>:
.globl vector80
vector80:
  pushl $0
8010561a:	6a 00                	push   $0x0
  pushl $80
8010561c:	6a 50                	push   $0x50
  jmp alltraps
8010561e:	e9 e6 f8 ff ff       	jmp    80104f09 <alltraps>

80105623 <vector81>:
.globl vector81
vector81:
  pushl $0
80105623:	6a 00                	push   $0x0
  pushl $81
80105625:	6a 51                	push   $0x51
  jmp alltraps
80105627:	e9 dd f8 ff ff       	jmp    80104f09 <alltraps>

8010562c <vector82>:
.globl vector82
vector82:
  pushl $0
8010562c:	6a 00                	push   $0x0
  pushl $82
8010562e:	6a 52                	push   $0x52
  jmp alltraps
80105630:	e9 d4 f8 ff ff       	jmp    80104f09 <alltraps>

80105635 <vector83>:
.globl vector83
vector83:
  pushl $0
80105635:	6a 00                	push   $0x0
  pushl $83
80105637:	6a 53                	push   $0x53
  jmp alltraps
80105639:	e9 cb f8 ff ff       	jmp    80104f09 <alltraps>

8010563e <vector84>:
.globl vector84
vector84:
  pushl $0
8010563e:	6a 00                	push   $0x0
  pushl $84
80105640:	6a 54                	push   $0x54
  jmp alltraps
80105642:	e9 c2 f8 ff ff       	jmp    80104f09 <alltraps>

80105647 <vector85>:
.globl vector85
vector85:
  pushl $0
80105647:	6a 00                	push   $0x0
  pushl $85
80105649:	6a 55                	push   $0x55
  jmp alltraps
8010564b:	e9 b9 f8 ff ff       	jmp    80104f09 <alltraps>

80105650 <vector86>:
.globl vector86
vector86:
  pushl $0
80105650:	6a 00                	push   $0x0
  pushl $86
80105652:	6a 56                	push   $0x56
  jmp alltraps
80105654:	e9 b0 f8 ff ff       	jmp    80104f09 <alltraps>

80105659 <vector87>:
.globl vector87
vector87:
  pushl $0
80105659:	6a 00                	push   $0x0
  pushl $87
8010565b:	6a 57                	push   $0x57
  jmp alltraps
8010565d:	e9 a7 f8 ff ff       	jmp    80104f09 <alltraps>

80105662 <vector88>:
.globl vector88
vector88:
  pushl $0
80105662:	6a 00                	push   $0x0
  pushl $88
80105664:	6a 58                	push   $0x58
  jmp alltraps
80105666:	e9 9e f8 ff ff       	jmp    80104f09 <alltraps>

8010566b <vector89>:
.globl vector89
vector89:
  pushl $0
8010566b:	6a 00                	push   $0x0
  pushl $89
8010566d:	6a 59                	push   $0x59
  jmp alltraps
8010566f:	e9 95 f8 ff ff       	jmp    80104f09 <alltraps>

80105674 <vector90>:
.globl vector90
vector90:
  pushl $0
80105674:	6a 00                	push   $0x0
  pushl $90
80105676:	6a 5a                	push   $0x5a
  jmp alltraps
80105678:	e9 8c f8 ff ff       	jmp    80104f09 <alltraps>

8010567d <vector91>:
.globl vector91
vector91:
  pushl $0
8010567d:	6a 00                	push   $0x0
  pushl $91
8010567f:	6a 5b                	push   $0x5b
  jmp alltraps
80105681:	e9 83 f8 ff ff       	jmp    80104f09 <alltraps>

80105686 <vector92>:
.globl vector92
vector92:
  pushl $0
80105686:	6a 00                	push   $0x0
  pushl $92
80105688:	6a 5c                	push   $0x5c
  jmp alltraps
8010568a:	e9 7a f8 ff ff       	jmp    80104f09 <alltraps>

8010568f <vector93>:
.globl vector93
vector93:
  pushl $0
8010568f:	6a 00                	push   $0x0
  pushl $93
80105691:	6a 5d                	push   $0x5d
  jmp alltraps
80105693:	e9 71 f8 ff ff       	jmp    80104f09 <alltraps>

80105698 <vector94>:
.globl vector94
vector94:
  pushl $0
80105698:	6a 00                	push   $0x0
  pushl $94
8010569a:	6a 5e                	push   $0x5e
  jmp alltraps
8010569c:	e9 68 f8 ff ff       	jmp    80104f09 <alltraps>

801056a1 <vector95>:
.globl vector95
vector95:
  pushl $0
801056a1:	6a 00                	push   $0x0
  pushl $95
801056a3:	6a 5f                	push   $0x5f
  jmp alltraps
801056a5:	e9 5f f8 ff ff       	jmp    80104f09 <alltraps>

801056aa <vector96>:
.globl vector96
vector96:
  pushl $0
801056aa:	6a 00                	push   $0x0
  pushl $96
801056ac:	6a 60                	push   $0x60
  jmp alltraps
801056ae:	e9 56 f8 ff ff       	jmp    80104f09 <alltraps>

801056b3 <vector97>:
.globl vector97
vector97:
  pushl $0
801056b3:	6a 00                	push   $0x0
  pushl $97
801056b5:	6a 61                	push   $0x61
  jmp alltraps
801056b7:	e9 4d f8 ff ff       	jmp    80104f09 <alltraps>

801056bc <vector98>:
.globl vector98
vector98:
  pushl $0
801056bc:	6a 00                	push   $0x0
  pushl $98
801056be:	6a 62                	push   $0x62
  jmp alltraps
801056c0:	e9 44 f8 ff ff       	jmp    80104f09 <alltraps>

801056c5 <vector99>:
.globl vector99
vector99:
  pushl $0
801056c5:	6a 00                	push   $0x0
  pushl $99
801056c7:	6a 63                	push   $0x63
  jmp alltraps
801056c9:	e9 3b f8 ff ff       	jmp    80104f09 <alltraps>

801056ce <vector100>:
.globl vector100
vector100:
  pushl $0
801056ce:	6a 00                	push   $0x0
  pushl $100
801056d0:	6a 64                	push   $0x64
  jmp alltraps
801056d2:	e9 32 f8 ff ff       	jmp    80104f09 <alltraps>

801056d7 <vector101>:
.globl vector101
vector101:
  pushl $0
801056d7:	6a 00                	push   $0x0
  pushl $101
801056d9:	6a 65                	push   $0x65
  jmp alltraps
801056db:	e9 29 f8 ff ff       	jmp    80104f09 <alltraps>

801056e0 <vector102>:
.globl vector102
vector102:
  pushl $0
801056e0:	6a 00                	push   $0x0
  pushl $102
801056e2:	6a 66                	push   $0x66
  jmp alltraps
801056e4:	e9 20 f8 ff ff       	jmp    80104f09 <alltraps>

801056e9 <vector103>:
.globl vector103
vector103:
  pushl $0
801056e9:	6a 00                	push   $0x0
  pushl $103
801056eb:	6a 67                	push   $0x67
  jmp alltraps
801056ed:	e9 17 f8 ff ff       	jmp    80104f09 <alltraps>

801056f2 <vector104>:
.globl vector104
vector104:
  pushl $0
801056f2:	6a 00                	push   $0x0
  pushl $104
801056f4:	6a 68                	push   $0x68
  jmp alltraps
801056f6:	e9 0e f8 ff ff       	jmp    80104f09 <alltraps>

801056fb <vector105>:
.globl vector105
vector105:
  pushl $0
801056fb:	6a 00                	push   $0x0
  pushl $105
801056fd:	6a 69                	push   $0x69
  jmp alltraps
801056ff:	e9 05 f8 ff ff       	jmp    80104f09 <alltraps>

80105704 <vector106>:
.globl vector106
vector106:
  pushl $0
80105704:	6a 00                	push   $0x0
  pushl $106
80105706:	6a 6a                	push   $0x6a
  jmp alltraps
80105708:	e9 fc f7 ff ff       	jmp    80104f09 <alltraps>

8010570d <vector107>:
.globl vector107
vector107:
  pushl $0
8010570d:	6a 00                	push   $0x0
  pushl $107
8010570f:	6a 6b                	push   $0x6b
  jmp alltraps
80105711:	e9 f3 f7 ff ff       	jmp    80104f09 <alltraps>

80105716 <vector108>:
.globl vector108
vector108:
  pushl $0
80105716:	6a 00                	push   $0x0
  pushl $108
80105718:	6a 6c                	push   $0x6c
  jmp alltraps
8010571a:	e9 ea f7 ff ff       	jmp    80104f09 <alltraps>

8010571f <vector109>:
.globl vector109
vector109:
  pushl $0
8010571f:	6a 00                	push   $0x0
  pushl $109
80105721:	6a 6d                	push   $0x6d
  jmp alltraps
80105723:	e9 e1 f7 ff ff       	jmp    80104f09 <alltraps>

80105728 <vector110>:
.globl vector110
vector110:
  pushl $0
80105728:	6a 00                	push   $0x0
  pushl $110
8010572a:	6a 6e                	push   $0x6e
  jmp alltraps
8010572c:	e9 d8 f7 ff ff       	jmp    80104f09 <alltraps>

80105731 <vector111>:
.globl vector111
vector111:
  pushl $0
80105731:	6a 00                	push   $0x0
  pushl $111
80105733:	6a 6f                	push   $0x6f
  jmp alltraps
80105735:	e9 cf f7 ff ff       	jmp    80104f09 <alltraps>

8010573a <vector112>:
.globl vector112
vector112:
  pushl $0
8010573a:	6a 00                	push   $0x0
  pushl $112
8010573c:	6a 70                	push   $0x70
  jmp alltraps
8010573e:	e9 c6 f7 ff ff       	jmp    80104f09 <alltraps>

80105743 <vector113>:
.globl vector113
vector113:
  pushl $0
80105743:	6a 00                	push   $0x0
  pushl $113
80105745:	6a 71                	push   $0x71
  jmp alltraps
80105747:	e9 bd f7 ff ff       	jmp    80104f09 <alltraps>

8010574c <vector114>:
.globl vector114
vector114:
  pushl $0
8010574c:	6a 00                	push   $0x0
  pushl $114
8010574e:	6a 72                	push   $0x72
  jmp alltraps
80105750:	e9 b4 f7 ff ff       	jmp    80104f09 <alltraps>

80105755 <vector115>:
.globl vector115
vector115:
  pushl $0
80105755:	6a 00                	push   $0x0
  pushl $115
80105757:	6a 73                	push   $0x73
  jmp alltraps
80105759:	e9 ab f7 ff ff       	jmp    80104f09 <alltraps>

8010575e <vector116>:
.globl vector116
vector116:
  pushl $0
8010575e:	6a 00                	push   $0x0
  pushl $116
80105760:	6a 74                	push   $0x74
  jmp alltraps
80105762:	e9 a2 f7 ff ff       	jmp    80104f09 <alltraps>

80105767 <vector117>:
.globl vector117
vector117:
  pushl $0
80105767:	6a 00                	push   $0x0
  pushl $117
80105769:	6a 75                	push   $0x75
  jmp alltraps
8010576b:	e9 99 f7 ff ff       	jmp    80104f09 <alltraps>

80105770 <vector118>:
.globl vector118
vector118:
  pushl $0
80105770:	6a 00                	push   $0x0
  pushl $118
80105772:	6a 76                	push   $0x76
  jmp alltraps
80105774:	e9 90 f7 ff ff       	jmp    80104f09 <alltraps>

80105779 <vector119>:
.globl vector119
vector119:
  pushl $0
80105779:	6a 00                	push   $0x0
  pushl $119
8010577b:	6a 77                	push   $0x77
  jmp alltraps
8010577d:	e9 87 f7 ff ff       	jmp    80104f09 <alltraps>

80105782 <vector120>:
.globl vector120
vector120:
  pushl $0
80105782:	6a 00                	push   $0x0
  pushl $120
80105784:	6a 78                	push   $0x78
  jmp alltraps
80105786:	e9 7e f7 ff ff       	jmp    80104f09 <alltraps>

8010578b <vector121>:
.globl vector121
vector121:
  pushl $0
8010578b:	6a 00                	push   $0x0
  pushl $121
8010578d:	6a 79                	push   $0x79
  jmp alltraps
8010578f:	e9 75 f7 ff ff       	jmp    80104f09 <alltraps>

80105794 <vector122>:
.globl vector122
vector122:
  pushl $0
80105794:	6a 00                	push   $0x0
  pushl $122
80105796:	6a 7a                	push   $0x7a
  jmp alltraps
80105798:	e9 6c f7 ff ff       	jmp    80104f09 <alltraps>

8010579d <vector123>:
.globl vector123
vector123:
  pushl $0
8010579d:	6a 00                	push   $0x0
  pushl $123
8010579f:	6a 7b                	push   $0x7b
  jmp alltraps
801057a1:	e9 63 f7 ff ff       	jmp    80104f09 <alltraps>

801057a6 <vector124>:
.globl vector124
vector124:
  pushl $0
801057a6:	6a 00                	push   $0x0
  pushl $124
801057a8:	6a 7c                	push   $0x7c
  jmp alltraps
801057aa:	e9 5a f7 ff ff       	jmp    80104f09 <alltraps>

801057af <vector125>:
.globl vector125
vector125:
  pushl $0
801057af:	6a 00                	push   $0x0
  pushl $125
801057b1:	6a 7d                	push   $0x7d
  jmp alltraps
801057b3:	e9 51 f7 ff ff       	jmp    80104f09 <alltraps>

801057b8 <vector126>:
.globl vector126
vector126:
  pushl $0
801057b8:	6a 00                	push   $0x0
  pushl $126
801057ba:	6a 7e                	push   $0x7e
  jmp alltraps
801057bc:	e9 48 f7 ff ff       	jmp    80104f09 <alltraps>

801057c1 <vector127>:
.globl vector127
vector127:
  pushl $0
801057c1:	6a 00                	push   $0x0
  pushl $127
801057c3:	6a 7f                	push   $0x7f
  jmp alltraps
801057c5:	e9 3f f7 ff ff       	jmp    80104f09 <alltraps>

801057ca <vector128>:
.globl vector128
vector128:
  pushl $0
801057ca:	6a 00                	push   $0x0
  pushl $128
801057cc:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801057d1:	e9 33 f7 ff ff       	jmp    80104f09 <alltraps>

801057d6 <vector129>:
.globl vector129
vector129:
  pushl $0
801057d6:	6a 00                	push   $0x0
  pushl $129
801057d8:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801057dd:	e9 27 f7 ff ff       	jmp    80104f09 <alltraps>

801057e2 <vector130>:
.globl vector130
vector130:
  pushl $0
801057e2:	6a 00                	push   $0x0
  pushl $130
801057e4:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801057e9:	e9 1b f7 ff ff       	jmp    80104f09 <alltraps>

801057ee <vector131>:
.globl vector131
vector131:
  pushl $0
801057ee:	6a 00                	push   $0x0
  pushl $131
801057f0:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801057f5:	e9 0f f7 ff ff       	jmp    80104f09 <alltraps>

801057fa <vector132>:
.globl vector132
vector132:
  pushl $0
801057fa:	6a 00                	push   $0x0
  pushl $132
801057fc:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80105801:	e9 03 f7 ff ff       	jmp    80104f09 <alltraps>

80105806 <vector133>:
.globl vector133
vector133:
  pushl $0
80105806:	6a 00                	push   $0x0
  pushl $133
80105808:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010580d:	e9 f7 f6 ff ff       	jmp    80104f09 <alltraps>

80105812 <vector134>:
.globl vector134
vector134:
  pushl $0
80105812:	6a 00                	push   $0x0
  pushl $134
80105814:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80105819:	e9 eb f6 ff ff       	jmp    80104f09 <alltraps>

8010581e <vector135>:
.globl vector135
vector135:
  pushl $0
8010581e:	6a 00                	push   $0x0
  pushl $135
80105820:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80105825:	e9 df f6 ff ff       	jmp    80104f09 <alltraps>

8010582a <vector136>:
.globl vector136
vector136:
  pushl $0
8010582a:	6a 00                	push   $0x0
  pushl $136
8010582c:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80105831:	e9 d3 f6 ff ff       	jmp    80104f09 <alltraps>

80105836 <vector137>:
.globl vector137
vector137:
  pushl $0
80105836:	6a 00                	push   $0x0
  pushl $137
80105838:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010583d:	e9 c7 f6 ff ff       	jmp    80104f09 <alltraps>

80105842 <vector138>:
.globl vector138
vector138:
  pushl $0
80105842:	6a 00                	push   $0x0
  pushl $138
80105844:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80105849:	e9 bb f6 ff ff       	jmp    80104f09 <alltraps>

8010584e <vector139>:
.globl vector139
vector139:
  pushl $0
8010584e:	6a 00                	push   $0x0
  pushl $139
80105850:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80105855:	e9 af f6 ff ff       	jmp    80104f09 <alltraps>

8010585a <vector140>:
.globl vector140
vector140:
  pushl $0
8010585a:	6a 00                	push   $0x0
  pushl $140
8010585c:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80105861:	e9 a3 f6 ff ff       	jmp    80104f09 <alltraps>

80105866 <vector141>:
.globl vector141
vector141:
  pushl $0
80105866:	6a 00                	push   $0x0
  pushl $141
80105868:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010586d:	e9 97 f6 ff ff       	jmp    80104f09 <alltraps>

80105872 <vector142>:
.globl vector142
vector142:
  pushl $0
80105872:	6a 00                	push   $0x0
  pushl $142
80105874:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80105879:	e9 8b f6 ff ff       	jmp    80104f09 <alltraps>

8010587e <vector143>:
.globl vector143
vector143:
  pushl $0
8010587e:	6a 00                	push   $0x0
  pushl $143
80105880:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80105885:	e9 7f f6 ff ff       	jmp    80104f09 <alltraps>

8010588a <vector144>:
.globl vector144
vector144:
  pushl $0
8010588a:	6a 00                	push   $0x0
  pushl $144
8010588c:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80105891:	e9 73 f6 ff ff       	jmp    80104f09 <alltraps>

80105896 <vector145>:
.globl vector145
vector145:
  pushl $0
80105896:	6a 00                	push   $0x0
  pushl $145
80105898:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010589d:	e9 67 f6 ff ff       	jmp    80104f09 <alltraps>

801058a2 <vector146>:
.globl vector146
vector146:
  pushl $0
801058a2:	6a 00                	push   $0x0
  pushl $146
801058a4:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801058a9:	e9 5b f6 ff ff       	jmp    80104f09 <alltraps>

801058ae <vector147>:
.globl vector147
vector147:
  pushl $0
801058ae:	6a 00                	push   $0x0
  pushl $147
801058b0:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801058b5:	e9 4f f6 ff ff       	jmp    80104f09 <alltraps>

801058ba <vector148>:
.globl vector148
vector148:
  pushl $0
801058ba:	6a 00                	push   $0x0
  pushl $148
801058bc:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801058c1:	e9 43 f6 ff ff       	jmp    80104f09 <alltraps>

801058c6 <vector149>:
.globl vector149
vector149:
  pushl $0
801058c6:	6a 00                	push   $0x0
  pushl $149
801058c8:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801058cd:	e9 37 f6 ff ff       	jmp    80104f09 <alltraps>

801058d2 <vector150>:
.globl vector150
vector150:
  pushl $0
801058d2:	6a 00                	push   $0x0
  pushl $150
801058d4:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801058d9:	e9 2b f6 ff ff       	jmp    80104f09 <alltraps>

801058de <vector151>:
.globl vector151
vector151:
  pushl $0
801058de:	6a 00                	push   $0x0
  pushl $151
801058e0:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801058e5:	e9 1f f6 ff ff       	jmp    80104f09 <alltraps>

801058ea <vector152>:
.globl vector152
vector152:
  pushl $0
801058ea:	6a 00                	push   $0x0
  pushl $152
801058ec:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801058f1:	e9 13 f6 ff ff       	jmp    80104f09 <alltraps>

801058f6 <vector153>:
.globl vector153
vector153:
  pushl $0
801058f6:	6a 00                	push   $0x0
  pushl $153
801058f8:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801058fd:	e9 07 f6 ff ff       	jmp    80104f09 <alltraps>

80105902 <vector154>:
.globl vector154
vector154:
  pushl $0
80105902:	6a 00                	push   $0x0
  pushl $154
80105904:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80105909:	e9 fb f5 ff ff       	jmp    80104f09 <alltraps>

8010590e <vector155>:
.globl vector155
vector155:
  pushl $0
8010590e:	6a 00                	push   $0x0
  pushl $155
80105910:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80105915:	e9 ef f5 ff ff       	jmp    80104f09 <alltraps>

8010591a <vector156>:
.globl vector156
vector156:
  pushl $0
8010591a:	6a 00                	push   $0x0
  pushl $156
8010591c:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80105921:	e9 e3 f5 ff ff       	jmp    80104f09 <alltraps>

80105926 <vector157>:
.globl vector157
vector157:
  pushl $0
80105926:	6a 00                	push   $0x0
  pushl $157
80105928:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010592d:	e9 d7 f5 ff ff       	jmp    80104f09 <alltraps>

80105932 <vector158>:
.globl vector158
vector158:
  pushl $0
80105932:	6a 00                	push   $0x0
  pushl $158
80105934:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80105939:	e9 cb f5 ff ff       	jmp    80104f09 <alltraps>

8010593e <vector159>:
.globl vector159
vector159:
  pushl $0
8010593e:	6a 00                	push   $0x0
  pushl $159
80105940:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80105945:	e9 bf f5 ff ff       	jmp    80104f09 <alltraps>

8010594a <vector160>:
.globl vector160
vector160:
  pushl $0
8010594a:	6a 00                	push   $0x0
  pushl $160
8010594c:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80105951:	e9 b3 f5 ff ff       	jmp    80104f09 <alltraps>

80105956 <vector161>:
.globl vector161
vector161:
  pushl $0
80105956:	6a 00                	push   $0x0
  pushl $161
80105958:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010595d:	e9 a7 f5 ff ff       	jmp    80104f09 <alltraps>

80105962 <vector162>:
.globl vector162
vector162:
  pushl $0
80105962:	6a 00                	push   $0x0
  pushl $162
80105964:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80105969:	e9 9b f5 ff ff       	jmp    80104f09 <alltraps>

8010596e <vector163>:
.globl vector163
vector163:
  pushl $0
8010596e:	6a 00                	push   $0x0
  pushl $163
80105970:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80105975:	e9 8f f5 ff ff       	jmp    80104f09 <alltraps>

8010597a <vector164>:
.globl vector164
vector164:
  pushl $0
8010597a:	6a 00                	push   $0x0
  pushl $164
8010597c:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80105981:	e9 83 f5 ff ff       	jmp    80104f09 <alltraps>

80105986 <vector165>:
.globl vector165
vector165:
  pushl $0
80105986:	6a 00                	push   $0x0
  pushl $165
80105988:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010598d:	e9 77 f5 ff ff       	jmp    80104f09 <alltraps>

80105992 <vector166>:
.globl vector166
vector166:
  pushl $0
80105992:	6a 00                	push   $0x0
  pushl $166
80105994:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80105999:	e9 6b f5 ff ff       	jmp    80104f09 <alltraps>

8010599e <vector167>:
.globl vector167
vector167:
  pushl $0
8010599e:	6a 00                	push   $0x0
  pushl $167
801059a0:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801059a5:	e9 5f f5 ff ff       	jmp    80104f09 <alltraps>

801059aa <vector168>:
.globl vector168
vector168:
  pushl $0
801059aa:	6a 00                	push   $0x0
  pushl $168
801059ac:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801059b1:	e9 53 f5 ff ff       	jmp    80104f09 <alltraps>

801059b6 <vector169>:
.globl vector169
vector169:
  pushl $0
801059b6:	6a 00                	push   $0x0
  pushl $169
801059b8:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801059bd:	e9 47 f5 ff ff       	jmp    80104f09 <alltraps>

801059c2 <vector170>:
.globl vector170
vector170:
  pushl $0
801059c2:	6a 00                	push   $0x0
  pushl $170
801059c4:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801059c9:	e9 3b f5 ff ff       	jmp    80104f09 <alltraps>

801059ce <vector171>:
.globl vector171
vector171:
  pushl $0
801059ce:	6a 00                	push   $0x0
  pushl $171
801059d0:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801059d5:	e9 2f f5 ff ff       	jmp    80104f09 <alltraps>

801059da <vector172>:
.globl vector172
vector172:
  pushl $0
801059da:	6a 00                	push   $0x0
  pushl $172
801059dc:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801059e1:	e9 23 f5 ff ff       	jmp    80104f09 <alltraps>

801059e6 <vector173>:
.globl vector173
vector173:
  pushl $0
801059e6:	6a 00                	push   $0x0
  pushl $173
801059e8:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801059ed:	e9 17 f5 ff ff       	jmp    80104f09 <alltraps>

801059f2 <vector174>:
.globl vector174
vector174:
  pushl $0
801059f2:	6a 00                	push   $0x0
  pushl $174
801059f4:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801059f9:	e9 0b f5 ff ff       	jmp    80104f09 <alltraps>

801059fe <vector175>:
.globl vector175
vector175:
  pushl $0
801059fe:	6a 00                	push   $0x0
  pushl $175
80105a00:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80105a05:	e9 ff f4 ff ff       	jmp    80104f09 <alltraps>

80105a0a <vector176>:
.globl vector176
vector176:
  pushl $0
80105a0a:	6a 00                	push   $0x0
  pushl $176
80105a0c:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80105a11:	e9 f3 f4 ff ff       	jmp    80104f09 <alltraps>

80105a16 <vector177>:
.globl vector177
vector177:
  pushl $0
80105a16:	6a 00                	push   $0x0
  pushl $177
80105a18:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80105a1d:	e9 e7 f4 ff ff       	jmp    80104f09 <alltraps>

80105a22 <vector178>:
.globl vector178
vector178:
  pushl $0
80105a22:	6a 00                	push   $0x0
  pushl $178
80105a24:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80105a29:	e9 db f4 ff ff       	jmp    80104f09 <alltraps>

80105a2e <vector179>:
.globl vector179
vector179:
  pushl $0
80105a2e:	6a 00                	push   $0x0
  pushl $179
80105a30:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80105a35:	e9 cf f4 ff ff       	jmp    80104f09 <alltraps>

80105a3a <vector180>:
.globl vector180
vector180:
  pushl $0
80105a3a:	6a 00                	push   $0x0
  pushl $180
80105a3c:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80105a41:	e9 c3 f4 ff ff       	jmp    80104f09 <alltraps>

80105a46 <vector181>:
.globl vector181
vector181:
  pushl $0
80105a46:	6a 00                	push   $0x0
  pushl $181
80105a48:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80105a4d:	e9 b7 f4 ff ff       	jmp    80104f09 <alltraps>

80105a52 <vector182>:
.globl vector182
vector182:
  pushl $0
80105a52:	6a 00                	push   $0x0
  pushl $182
80105a54:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80105a59:	e9 ab f4 ff ff       	jmp    80104f09 <alltraps>

80105a5e <vector183>:
.globl vector183
vector183:
  pushl $0
80105a5e:	6a 00                	push   $0x0
  pushl $183
80105a60:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80105a65:	e9 9f f4 ff ff       	jmp    80104f09 <alltraps>

80105a6a <vector184>:
.globl vector184
vector184:
  pushl $0
80105a6a:	6a 00                	push   $0x0
  pushl $184
80105a6c:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80105a71:	e9 93 f4 ff ff       	jmp    80104f09 <alltraps>

80105a76 <vector185>:
.globl vector185
vector185:
  pushl $0
80105a76:	6a 00                	push   $0x0
  pushl $185
80105a78:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80105a7d:	e9 87 f4 ff ff       	jmp    80104f09 <alltraps>

80105a82 <vector186>:
.globl vector186
vector186:
  pushl $0
80105a82:	6a 00                	push   $0x0
  pushl $186
80105a84:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80105a89:	e9 7b f4 ff ff       	jmp    80104f09 <alltraps>

80105a8e <vector187>:
.globl vector187
vector187:
  pushl $0
80105a8e:	6a 00                	push   $0x0
  pushl $187
80105a90:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80105a95:	e9 6f f4 ff ff       	jmp    80104f09 <alltraps>

80105a9a <vector188>:
.globl vector188
vector188:
  pushl $0
80105a9a:	6a 00                	push   $0x0
  pushl $188
80105a9c:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80105aa1:	e9 63 f4 ff ff       	jmp    80104f09 <alltraps>

80105aa6 <vector189>:
.globl vector189
vector189:
  pushl $0
80105aa6:	6a 00                	push   $0x0
  pushl $189
80105aa8:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80105aad:	e9 57 f4 ff ff       	jmp    80104f09 <alltraps>

80105ab2 <vector190>:
.globl vector190
vector190:
  pushl $0
80105ab2:	6a 00                	push   $0x0
  pushl $190
80105ab4:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80105ab9:	e9 4b f4 ff ff       	jmp    80104f09 <alltraps>

80105abe <vector191>:
.globl vector191
vector191:
  pushl $0
80105abe:	6a 00                	push   $0x0
  pushl $191
80105ac0:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80105ac5:	e9 3f f4 ff ff       	jmp    80104f09 <alltraps>

80105aca <vector192>:
.globl vector192
vector192:
  pushl $0
80105aca:	6a 00                	push   $0x0
  pushl $192
80105acc:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80105ad1:	e9 33 f4 ff ff       	jmp    80104f09 <alltraps>

80105ad6 <vector193>:
.globl vector193
vector193:
  pushl $0
80105ad6:	6a 00                	push   $0x0
  pushl $193
80105ad8:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80105add:	e9 27 f4 ff ff       	jmp    80104f09 <alltraps>

80105ae2 <vector194>:
.globl vector194
vector194:
  pushl $0
80105ae2:	6a 00                	push   $0x0
  pushl $194
80105ae4:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80105ae9:	e9 1b f4 ff ff       	jmp    80104f09 <alltraps>

80105aee <vector195>:
.globl vector195
vector195:
  pushl $0
80105aee:	6a 00                	push   $0x0
  pushl $195
80105af0:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80105af5:	e9 0f f4 ff ff       	jmp    80104f09 <alltraps>

80105afa <vector196>:
.globl vector196
vector196:
  pushl $0
80105afa:	6a 00                	push   $0x0
  pushl $196
80105afc:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80105b01:	e9 03 f4 ff ff       	jmp    80104f09 <alltraps>

80105b06 <vector197>:
.globl vector197
vector197:
  pushl $0
80105b06:	6a 00                	push   $0x0
  pushl $197
80105b08:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80105b0d:	e9 f7 f3 ff ff       	jmp    80104f09 <alltraps>

80105b12 <vector198>:
.globl vector198
vector198:
  pushl $0
80105b12:	6a 00                	push   $0x0
  pushl $198
80105b14:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80105b19:	e9 eb f3 ff ff       	jmp    80104f09 <alltraps>

80105b1e <vector199>:
.globl vector199
vector199:
  pushl $0
80105b1e:	6a 00                	push   $0x0
  pushl $199
80105b20:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80105b25:	e9 df f3 ff ff       	jmp    80104f09 <alltraps>

80105b2a <vector200>:
.globl vector200
vector200:
  pushl $0
80105b2a:	6a 00                	push   $0x0
  pushl $200
80105b2c:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80105b31:	e9 d3 f3 ff ff       	jmp    80104f09 <alltraps>

80105b36 <vector201>:
.globl vector201
vector201:
  pushl $0
80105b36:	6a 00                	push   $0x0
  pushl $201
80105b38:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80105b3d:	e9 c7 f3 ff ff       	jmp    80104f09 <alltraps>

80105b42 <vector202>:
.globl vector202
vector202:
  pushl $0
80105b42:	6a 00                	push   $0x0
  pushl $202
80105b44:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80105b49:	e9 bb f3 ff ff       	jmp    80104f09 <alltraps>

80105b4e <vector203>:
.globl vector203
vector203:
  pushl $0
80105b4e:	6a 00                	push   $0x0
  pushl $203
80105b50:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80105b55:	e9 af f3 ff ff       	jmp    80104f09 <alltraps>

80105b5a <vector204>:
.globl vector204
vector204:
  pushl $0
80105b5a:	6a 00                	push   $0x0
  pushl $204
80105b5c:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80105b61:	e9 a3 f3 ff ff       	jmp    80104f09 <alltraps>

80105b66 <vector205>:
.globl vector205
vector205:
  pushl $0
80105b66:	6a 00                	push   $0x0
  pushl $205
80105b68:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80105b6d:	e9 97 f3 ff ff       	jmp    80104f09 <alltraps>

80105b72 <vector206>:
.globl vector206
vector206:
  pushl $0
80105b72:	6a 00                	push   $0x0
  pushl $206
80105b74:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80105b79:	e9 8b f3 ff ff       	jmp    80104f09 <alltraps>

80105b7e <vector207>:
.globl vector207
vector207:
  pushl $0
80105b7e:	6a 00                	push   $0x0
  pushl $207
80105b80:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80105b85:	e9 7f f3 ff ff       	jmp    80104f09 <alltraps>

80105b8a <vector208>:
.globl vector208
vector208:
  pushl $0
80105b8a:	6a 00                	push   $0x0
  pushl $208
80105b8c:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80105b91:	e9 73 f3 ff ff       	jmp    80104f09 <alltraps>

80105b96 <vector209>:
.globl vector209
vector209:
  pushl $0
80105b96:	6a 00                	push   $0x0
  pushl $209
80105b98:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80105b9d:	e9 67 f3 ff ff       	jmp    80104f09 <alltraps>

80105ba2 <vector210>:
.globl vector210
vector210:
  pushl $0
80105ba2:	6a 00                	push   $0x0
  pushl $210
80105ba4:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80105ba9:	e9 5b f3 ff ff       	jmp    80104f09 <alltraps>

80105bae <vector211>:
.globl vector211
vector211:
  pushl $0
80105bae:	6a 00                	push   $0x0
  pushl $211
80105bb0:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80105bb5:	e9 4f f3 ff ff       	jmp    80104f09 <alltraps>

80105bba <vector212>:
.globl vector212
vector212:
  pushl $0
80105bba:	6a 00                	push   $0x0
  pushl $212
80105bbc:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80105bc1:	e9 43 f3 ff ff       	jmp    80104f09 <alltraps>

80105bc6 <vector213>:
.globl vector213
vector213:
  pushl $0
80105bc6:	6a 00                	push   $0x0
  pushl $213
80105bc8:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80105bcd:	e9 37 f3 ff ff       	jmp    80104f09 <alltraps>

80105bd2 <vector214>:
.globl vector214
vector214:
  pushl $0
80105bd2:	6a 00                	push   $0x0
  pushl $214
80105bd4:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80105bd9:	e9 2b f3 ff ff       	jmp    80104f09 <alltraps>

80105bde <vector215>:
.globl vector215
vector215:
  pushl $0
80105bde:	6a 00                	push   $0x0
  pushl $215
80105be0:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80105be5:	e9 1f f3 ff ff       	jmp    80104f09 <alltraps>

80105bea <vector216>:
.globl vector216
vector216:
  pushl $0
80105bea:	6a 00                	push   $0x0
  pushl $216
80105bec:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80105bf1:	e9 13 f3 ff ff       	jmp    80104f09 <alltraps>

80105bf6 <vector217>:
.globl vector217
vector217:
  pushl $0
80105bf6:	6a 00                	push   $0x0
  pushl $217
80105bf8:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80105bfd:	e9 07 f3 ff ff       	jmp    80104f09 <alltraps>

80105c02 <vector218>:
.globl vector218
vector218:
  pushl $0
80105c02:	6a 00                	push   $0x0
  pushl $218
80105c04:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80105c09:	e9 fb f2 ff ff       	jmp    80104f09 <alltraps>

80105c0e <vector219>:
.globl vector219
vector219:
  pushl $0
80105c0e:	6a 00                	push   $0x0
  pushl $219
80105c10:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80105c15:	e9 ef f2 ff ff       	jmp    80104f09 <alltraps>

80105c1a <vector220>:
.globl vector220
vector220:
  pushl $0
80105c1a:	6a 00                	push   $0x0
  pushl $220
80105c1c:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80105c21:	e9 e3 f2 ff ff       	jmp    80104f09 <alltraps>

80105c26 <vector221>:
.globl vector221
vector221:
  pushl $0
80105c26:	6a 00                	push   $0x0
  pushl $221
80105c28:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80105c2d:	e9 d7 f2 ff ff       	jmp    80104f09 <alltraps>

80105c32 <vector222>:
.globl vector222
vector222:
  pushl $0
80105c32:	6a 00                	push   $0x0
  pushl $222
80105c34:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80105c39:	e9 cb f2 ff ff       	jmp    80104f09 <alltraps>

80105c3e <vector223>:
.globl vector223
vector223:
  pushl $0
80105c3e:	6a 00                	push   $0x0
  pushl $223
80105c40:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80105c45:	e9 bf f2 ff ff       	jmp    80104f09 <alltraps>

80105c4a <vector224>:
.globl vector224
vector224:
  pushl $0
80105c4a:	6a 00                	push   $0x0
  pushl $224
80105c4c:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80105c51:	e9 b3 f2 ff ff       	jmp    80104f09 <alltraps>

80105c56 <vector225>:
.globl vector225
vector225:
  pushl $0
80105c56:	6a 00                	push   $0x0
  pushl $225
80105c58:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80105c5d:	e9 a7 f2 ff ff       	jmp    80104f09 <alltraps>

80105c62 <vector226>:
.globl vector226
vector226:
  pushl $0
80105c62:	6a 00                	push   $0x0
  pushl $226
80105c64:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80105c69:	e9 9b f2 ff ff       	jmp    80104f09 <alltraps>

80105c6e <vector227>:
.globl vector227
vector227:
  pushl $0
80105c6e:	6a 00                	push   $0x0
  pushl $227
80105c70:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80105c75:	e9 8f f2 ff ff       	jmp    80104f09 <alltraps>

80105c7a <vector228>:
.globl vector228
vector228:
  pushl $0
80105c7a:	6a 00                	push   $0x0
  pushl $228
80105c7c:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80105c81:	e9 83 f2 ff ff       	jmp    80104f09 <alltraps>

80105c86 <vector229>:
.globl vector229
vector229:
  pushl $0
80105c86:	6a 00                	push   $0x0
  pushl $229
80105c88:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80105c8d:	e9 77 f2 ff ff       	jmp    80104f09 <alltraps>

80105c92 <vector230>:
.globl vector230
vector230:
  pushl $0
80105c92:	6a 00                	push   $0x0
  pushl $230
80105c94:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80105c99:	e9 6b f2 ff ff       	jmp    80104f09 <alltraps>

80105c9e <vector231>:
.globl vector231
vector231:
  pushl $0
80105c9e:	6a 00                	push   $0x0
  pushl $231
80105ca0:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80105ca5:	e9 5f f2 ff ff       	jmp    80104f09 <alltraps>

80105caa <vector232>:
.globl vector232
vector232:
  pushl $0
80105caa:	6a 00                	push   $0x0
  pushl $232
80105cac:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80105cb1:	e9 53 f2 ff ff       	jmp    80104f09 <alltraps>

80105cb6 <vector233>:
.globl vector233
vector233:
  pushl $0
80105cb6:	6a 00                	push   $0x0
  pushl $233
80105cb8:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80105cbd:	e9 47 f2 ff ff       	jmp    80104f09 <alltraps>

80105cc2 <vector234>:
.globl vector234
vector234:
  pushl $0
80105cc2:	6a 00                	push   $0x0
  pushl $234
80105cc4:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80105cc9:	e9 3b f2 ff ff       	jmp    80104f09 <alltraps>

80105cce <vector235>:
.globl vector235
vector235:
  pushl $0
80105cce:	6a 00                	push   $0x0
  pushl $235
80105cd0:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80105cd5:	e9 2f f2 ff ff       	jmp    80104f09 <alltraps>

80105cda <vector236>:
.globl vector236
vector236:
  pushl $0
80105cda:	6a 00                	push   $0x0
  pushl $236
80105cdc:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80105ce1:	e9 23 f2 ff ff       	jmp    80104f09 <alltraps>

80105ce6 <vector237>:
.globl vector237
vector237:
  pushl $0
80105ce6:	6a 00                	push   $0x0
  pushl $237
80105ce8:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80105ced:	e9 17 f2 ff ff       	jmp    80104f09 <alltraps>

80105cf2 <vector238>:
.globl vector238
vector238:
  pushl $0
80105cf2:	6a 00                	push   $0x0
  pushl $238
80105cf4:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80105cf9:	e9 0b f2 ff ff       	jmp    80104f09 <alltraps>

80105cfe <vector239>:
.globl vector239
vector239:
  pushl $0
80105cfe:	6a 00                	push   $0x0
  pushl $239
80105d00:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80105d05:	e9 ff f1 ff ff       	jmp    80104f09 <alltraps>

80105d0a <vector240>:
.globl vector240
vector240:
  pushl $0
80105d0a:	6a 00                	push   $0x0
  pushl $240
80105d0c:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80105d11:	e9 f3 f1 ff ff       	jmp    80104f09 <alltraps>

80105d16 <vector241>:
.globl vector241
vector241:
  pushl $0
80105d16:	6a 00                	push   $0x0
  pushl $241
80105d18:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80105d1d:	e9 e7 f1 ff ff       	jmp    80104f09 <alltraps>

80105d22 <vector242>:
.globl vector242
vector242:
  pushl $0
80105d22:	6a 00                	push   $0x0
  pushl $242
80105d24:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80105d29:	e9 db f1 ff ff       	jmp    80104f09 <alltraps>

80105d2e <vector243>:
.globl vector243
vector243:
  pushl $0
80105d2e:	6a 00                	push   $0x0
  pushl $243
80105d30:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80105d35:	e9 cf f1 ff ff       	jmp    80104f09 <alltraps>

80105d3a <vector244>:
.globl vector244
vector244:
  pushl $0
80105d3a:	6a 00                	push   $0x0
  pushl $244
80105d3c:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80105d41:	e9 c3 f1 ff ff       	jmp    80104f09 <alltraps>

80105d46 <vector245>:
.globl vector245
vector245:
  pushl $0
80105d46:	6a 00                	push   $0x0
  pushl $245
80105d48:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80105d4d:	e9 b7 f1 ff ff       	jmp    80104f09 <alltraps>

80105d52 <vector246>:
.globl vector246
vector246:
  pushl $0
80105d52:	6a 00                	push   $0x0
  pushl $246
80105d54:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80105d59:	e9 ab f1 ff ff       	jmp    80104f09 <alltraps>

80105d5e <vector247>:
.globl vector247
vector247:
  pushl $0
80105d5e:	6a 00                	push   $0x0
  pushl $247
80105d60:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80105d65:	e9 9f f1 ff ff       	jmp    80104f09 <alltraps>

80105d6a <vector248>:
.globl vector248
vector248:
  pushl $0
80105d6a:	6a 00                	push   $0x0
  pushl $248
80105d6c:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80105d71:	e9 93 f1 ff ff       	jmp    80104f09 <alltraps>

80105d76 <vector249>:
.globl vector249
vector249:
  pushl $0
80105d76:	6a 00                	push   $0x0
  pushl $249
80105d78:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80105d7d:	e9 87 f1 ff ff       	jmp    80104f09 <alltraps>

80105d82 <vector250>:
.globl vector250
vector250:
  pushl $0
80105d82:	6a 00                	push   $0x0
  pushl $250
80105d84:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80105d89:	e9 7b f1 ff ff       	jmp    80104f09 <alltraps>

80105d8e <vector251>:
.globl vector251
vector251:
  pushl $0
80105d8e:	6a 00                	push   $0x0
  pushl $251
80105d90:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80105d95:	e9 6f f1 ff ff       	jmp    80104f09 <alltraps>

80105d9a <vector252>:
.globl vector252
vector252:
  pushl $0
80105d9a:	6a 00                	push   $0x0
  pushl $252
80105d9c:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80105da1:	e9 63 f1 ff ff       	jmp    80104f09 <alltraps>

80105da6 <vector253>:
.globl vector253
vector253:
  pushl $0
80105da6:	6a 00                	push   $0x0
  pushl $253
80105da8:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80105dad:	e9 57 f1 ff ff       	jmp    80104f09 <alltraps>

80105db2 <vector254>:
.globl vector254
vector254:
  pushl $0
80105db2:	6a 00                	push   $0x0
  pushl $254
80105db4:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80105db9:	e9 4b f1 ff ff       	jmp    80104f09 <alltraps>

80105dbe <vector255>:
.globl vector255
vector255:
  pushl $0
80105dbe:	6a 00                	push   $0x0
  pushl $255
80105dc0:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80105dc5:	e9 3f f1 ff ff       	jmp    80104f09 <alltraps>

80105dca <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80105dca:	55                   	push   %ebp
80105dcb:	89 e5                	mov    %esp,%ebp
80105dcd:	57                   	push   %edi
80105dce:	56                   	push   %esi
80105dcf:	53                   	push   %ebx
80105dd0:	83 ec 0c             	sub    $0xc,%esp
80105dd3:	89 d3                	mov    %edx,%ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80105dd5:	c1 ea 16             	shr    $0x16,%edx
80105dd8:	8d 3c 90             	lea    (%eax,%edx,4),%edi
  if(*pde & PTE_P){
80105ddb:	8b 37                	mov    (%edi),%esi
80105ddd:	f7 c6 01 00 00 00    	test   $0x1,%esi
80105de3:	74 35                	je     80105e1a <walkpgdir+0x50>

#ifndef __ASSEMBLER__
// Address in page table or page directory entry
//   I changes these from macros into inline functions to make sure we
//   consistently get an error if a pointer is erroneously passed to them.
static inline uint PTE_ADDR(uint pte)  { return pte & ~0xFFF; }
80105de5:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    if (a > KERNBASE)
80105deb:	81 fe 00 00 00 80    	cmp    $0x80000000,%esi
80105df1:	77 1a                	ja     80105e0d <walkpgdir+0x43>
    return (char*)a + KERNBASE;
80105df3:	81 c6 00 00 00 80    	add    $0x80000000,%esi
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80105df9:	c1 eb 0c             	shr    $0xc,%ebx
80105dfc:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
80105e02:	8d 04 9e             	lea    (%esi,%ebx,4),%eax
}
80105e05:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e08:	5b                   	pop    %ebx
80105e09:	5e                   	pop    %esi
80105e0a:	5f                   	pop    %edi
80105e0b:	5d                   	pop    %ebp
80105e0c:	c3                   	ret    
        panic("P2V on address > KERNBASE");
80105e0d:	83 ec 0c             	sub    $0xc,%esp
80105e10:	68 38 6d 10 80       	push   $0x80106d38
80105e15:	e8 42 a5 ff ff       	call   8010035c <panic>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80105e1a:	85 c9                	test   %ecx,%ecx
80105e1c:	74 33                	je     80105e51 <walkpgdir+0x87>
80105e1e:	e8 55 c3 ff ff       	call   80102178 <kalloc>
80105e23:	89 c6                	mov    %eax,%esi
80105e25:	85 c0                	test   %eax,%eax
80105e27:	74 28                	je     80105e51 <walkpgdir+0x87>
    memset(pgtab, 0, PGSIZE);
80105e29:	83 ec 04             	sub    $0x4,%esp
80105e2c:	68 00 10 00 00       	push   $0x1000
80105e31:	6a 00                	push   $0x0
80105e33:	50                   	push   %eax
80105e34:	e8 9f df ff ff       	call   80103dd8 <memset>
    if (a < (void*) KERNBASE)
80105e39:	83 c4 10             	add    $0x10,%esp
80105e3c:	81 fe ff ff ff 7f    	cmp    $0x7fffffff,%esi
80105e42:	76 14                	jbe    80105e58 <walkpgdir+0x8e>
    return (uint)a - KERNBASE;
80105e44:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80105e4a:	83 c8 07             	or     $0x7,%eax
80105e4d:	89 07                	mov    %eax,(%edi)
80105e4f:	eb a8                	jmp    80105df9 <walkpgdir+0x2f>
      return 0;
80105e51:	b8 00 00 00 00       	mov    $0x0,%eax
80105e56:	eb ad                	jmp    80105e05 <walkpgdir+0x3b>
        panic("V2P on address < KERNBASE "
80105e58:	83 ec 0c             	sub    $0xc,%esp
80105e5b:	68 08 6a 10 80       	push   $0x80106a08
80105e60:	e8 f7 a4 ff ff       	call   8010035c <panic>

80105e65 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80105e65:	55                   	push   %ebp
80105e66:	89 e5                	mov    %esp,%ebp
80105e68:	57                   	push   %edi
80105e69:	56                   	push   %esi
80105e6a:	53                   	push   %ebx
80105e6b:	83 ec 1c             	sub    $0x1c,%esp
80105e6e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105e71:	8b 75 08             	mov    0x8(%ebp),%esi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80105e74:	89 d3                	mov    %edx,%ebx
80105e76:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80105e7c:	8d 7c 0a ff          	lea    -0x1(%edx,%ecx,1),%edi
80105e80:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80105e86:	b9 01 00 00 00       	mov    $0x1,%ecx
80105e8b:	89 da                	mov    %ebx,%edx
80105e8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105e90:	e8 35 ff ff ff       	call   80105dca <walkpgdir>
80105e95:	85 c0                	test   %eax,%eax
80105e97:	74 2e                	je     80105ec7 <mappages+0x62>
      return -1;
    if(*pte & PTE_P)
80105e99:	f6 00 01             	testb  $0x1,(%eax)
80105e9c:	75 1c                	jne    80105eba <mappages+0x55>
      panic("remap");
    *pte = pa | perm | PTE_P;
80105e9e:	89 f2                	mov    %esi,%edx
80105ea0:	0b 55 0c             	or     0xc(%ebp),%edx
80105ea3:	83 ca 01             	or     $0x1,%edx
80105ea6:	89 10                	mov    %edx,(%eax)
    if(a == last)
80105ea8:	39 fb                	cmp    %edi,%ebx
80105eaa:	74 28                	je     80105ed4 <mappages+0x6f>
      break;
    a += PGSIZE;
80105eac:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    pa += PGSIZE;
80105eb2:	81 c6 00 10 00 00    	add    $0x1000,%esi
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80105eb8:	eb cc                	jmp    80105e86 <mappages+0x21>
      panic("remap");
80105eba:	83 ec 0c             	sub    $0xc,%esp
80105ebd:	68 14 71 10 80       	push   $0x80107114
80105ec2:	e8 95 a4 ff ff       	call   8010035c <panic>
      return -1;
80105ec7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80105ecc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ecf:	5b                   	pop    %ebx
80105ed0:	5e                   	pop    %esi
80105ed1:	5f                   	pop    %edi
80105ed2:	5d                   	pop    %ebp
80105ed3:	c3                   	ret    
  return 0;
80105ed4:	b8 00 00 00 00       	mov    $0x0,%eax
80105ed9:	eb f1                	jmp    80105ecc <mappages+0x67>

80105edb <seginit>:
{
80105edb:	f3 0f 1e fb          	endbr32 
80105edf:	55                   	push   %ebp
80105ee0:	89 e5                	mov    %esp,%ebp
80105ee2:	53                   	push   %ebx
80105ee3:	83 ec 14             	sub    $0x14,%esp
  c = &cpus[cpuid()];
80105ee6:	e8 24 d4 ff ff       	call   8010330f <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80105eeb:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80105ef1:	66 c7 80 f8 27 11 80 	movw   $0xffff,-0x7feed808(%eax)
80105ef8:	ff ff 
80105efa:	66 c7 80 fa 27 11 80 	movw   $0x0,-0x7feed806(%eax)
80105f01:	00 00 
80105f03:	c6 80 fc 27 11 80 00 	movb   $0x0,-0x7feed804(%eax)
80105f0a:	0f b6 88 fd 27 11 80 	movzbl -0x7feed803(%eax),%ecx
80105f11:	83 e1 f0             	and    $0xfffffff0,%ecx
80105f14:	83 c9 1a             	or     $0x1a,%ecx
80105f17:	83 e1 9f             	and    $0xffffff9f,%ecx
80105f1a:	83 c9 80             	or     $0xffffff80,%ecx
80105f1d:	88 88 fd 27 11 80    	mov    %cl,-0x7feed803(%eax)
80105f23:	0f b6 88 fe 27 11 80 	movzbl -0x7feed802(%eax),%ecx
80105f2a:	83 c9 0f             	or     $0xf,%ecx
80105f2d:	83 e1 cf             	and    $0xffffffcf,%ecx
80105f30:	83 c9 c0             	or     $0xffffffc0,%ecx
80105f33:	88 88 fe 27 11 80    	mov    %cl,-0x7feed802(%eax)
80105f39:	c6 80 ff 27 11 80 00 	movb   $0x0,-0x7feed801(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80105f40:	66 c7 80 00 28 11 80 	movw   $0xffff,-0x7feed800(%eax)
80105f47:	ff ff 
80105f49:	66 c7 80 02 28 11 80 	movw   $0x0,-0x7feed7fe(%eax)
80105f50:	00 00 
80105f52:	c6 80 04 28 11 80 00 	movb   $0x0,-0x7feed7fc(%eax)
80105f59:	0f b6 88 05 28 11 80 	movzbl -0x7feed7fb(%eax),%ecx
80105f60:	83 e1 f0             	and    $0xfffffff0,%ecx
80105f63:	83 c9 12             	or     $0x12,%ecx
80105f66:	83 e1 9f             	and    $0xffffff9f,%ecx
80105f69:	83 c9 80             	or     $0xffffff80,%ecx
80105f6c:	88 88 05 28 11 80    	mov    %cl,-0x7feed7fb(%eax)
80105f72:	0f b6 88 06 28 11 80 	movzbl -0x7feed7fa(%eax),%ecx
80105f79:	83 c9 0f             	or     $0xf,%ecx
80105f7c:	83 e1 cf             	and    $0xffffffcf,%ecx
80105f7f:	83 c9 c0             	or     $0xffffffc0,%ecx
80105f82:	88 88 06 28 11 80    	mov    %cl,-0x7feed7fa(%eax)
80105f88:	c6 80 07 28 11 80 00 	movb   $0x0,-0x7feed7f9(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80105f8f:	66 c7 80 08 28 11 80 	movw   $0xffff,-0x7feed7f8(%eax)
80105f96:	ff ff 
80105f98:	66 c7 80 0a 28 11 80 	movw   $0x0,-0x7feed7f6(%eax)
80105f9f:	00 00 
80105fa1:	c6 80 0c 28 11 80 00 	movb   $0x0,-0x7feed7f4(%eax)
80105fa8:	c6 80 0d 28 11 80 fa 	movb   $0xfa,-0x7feed7f3(%eax)
80105faf:	0f b6 88 0e 28 11 80 	movzbl -0x7feed7f2(%eax),%ecx
80105fb6:	83 c9 0f             	or     $0xf,%ecx
80105fb9:	83 e1 cf             	and    $0xffffffcf,%ecx
80105fbc:	83 c9 c0             	or     $0xffffffc0,%ecx
80105fbf:	88 88 0e 28 11 80    	mov    %cl,-0x7feed7f2(%eax)
80105fc5:	c6 80 0f 28 11 80 00 	movb   $0x0,-0x7feed7f1(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80105fcc:	66 c7 80 10 28 11 80 	movw   $0xffff,-0x7feed7f0(%eax)
80105fd3:	ff ff 
80105fd5:	66 c7 80 12 28 11 80 	movw   $0x0,-0x7feed7ee(%eax)
80105fdc:	00 00 
80105fde:	c6 80 14 28 11 80 00 	movb   $0x0,-0x7feed7ec(%eax)
80105fe5:	c6 80 15 28 11 80 f2 	movb   $0xf2,-0x7feed7eb(%eax)
80105fec:	0f b6 88 16 28 11 80 	movzbl -0x7feed7ea(%eax),%ecx
80105ff3:	83 c9 0f             	or     $0xf,%ecx
80105ff6:	83 e1 cf             	and    $0xffffffcf,%ecx
80105ff9:	83 c9 c0             	or     $0xffffffc0,%ecx
80105ffc:	88 88 16 28 11 80    	mov    %cl,-0x7feed7ea(%eax)
80106002:	c6 80 17 28 11 80 00 	movb   $0x0,-0x7feed7e9(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
80106009:	05 f0 27 11 80       	add    $0x801127f0,%eax
  pd[0] = size-1;
8010600e:	66 c7 45 f2 2f 00    	movw   $0x2f,-0xe(%ebp)
  pd[1] = (uint)p;
80106014:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106018:	c1 e8 10             	shr    $0x10,%eax
8010601b:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010601f:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106022:	0f 01 10             	lgdtl  (%eax)
}
80106025:	83 c4 14             	add    $0x14,%esp
80106028:	5b                   	pop    %ebx
80106029:	5d                   	pop    %ebp
8010602a:	c3                   	ret    

8010602b <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
8010602b:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
8010602f:	a1 a4 54 11 80       	mov    0x801154a4,%eax
    if (a < (void*) KERNBASE)
80106034:	3d ff ff ff 7f       	cmp    $0x7fffffff,%eax
80106039:	76 09                	jbe    80106044 <switchkvm+0x19>
    return (uint)a - KERNBASE;
8010603b:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106040:	0f 22 d8             	mov    %eax,%cr3
80106043:	c3                   	ret    
{
80106044:	55                   	push   %ebp
80106045:	89 e5                	mov    %esp,%ebp
80106047:	83 ec 14             	sub    $0x14,%esp
        panic("V2P on address < KERNBASE "
8010604a:	68 08 6a 10 80       	push   $0x80106a08
8010604f:	e8 08 a3 ff ff       	call   8010035c <panic>

80106054 <switchuvm>:
}

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80106054:	f3 0f 1e fb          	endbr32 
80106058:	55                   	push   %ebp
80106059:	89 e5                	mov    %esp,%ebp
8010605b:	57                   	push   %edi
8010605c:	56                   	push   %esi
8010605d:	53                   	push   %ebx
8010605e:	83 ec 1c             	sub    $0x1c,%esp
80106061:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106064:	85 f6                	test   %esi,%esi
80106066:	0f 84 e4 00 00 00    	je     80106150 <switchuvm+0xfc>
    panic("switchuvm: no process");
  if(p->kstack == 0)
8010606c:	83 7e 08 00          	cmpl   $0x0,0x8(%esi)
80106070:	0f 84 e7 00 00 00    	je     8010615d <switchuvm+0x109>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
80106076:	83 7e 04 00          	cmpl   $0x0,0x4(%esi)
8010607a:	0f 84 ea 00 00 00    	je     8010616a <switchuvm+0x116>
    panic("switchuvm: no pgdir");

  pushcli();
80106080:	e8 b6 db ff ff       	call   80103c3b <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106085:	e8 25 d2 ff ff       	call   801032af <mycpu>
8010608a:	89 c3                	mov    %eax,%ebx
8010608c:	e8 1e d2 ff ff       	call   801032af <mycpu>
80106091:	8d 78 08             	lea    0x8(%eax),%edi
80106094:	e8 16 d2 ff ff       	call   801032af <mycpu>
80106099:	83 c0 08             	add    $0x8,%eax
8010609c:	c1 e8 10             	shr    $0x10,%eax
8010609f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801060a2:	e8 08 d2 ff ff       	call   801032af <mycpu>
801060a7:	83 c0 08             	add    $0x8,%eax
801060aa:	c1 e8 18             	shr    $0x18,%eax
801060ad:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
801060b4:	67 00 
801060b6:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
801060bd:	0f b6 4d e4          	movzbl -0x1c(%ebp),%ecx
801060c1:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
801060c7:	0f b6 93 9d 00 00 00 	movzbl 0x9d(%ebx),%edx
801060ce:	83 e2 f0             	and    $0xfffffff0,%edx
801060d1:	83 ca 19             	or     $0x19,%edx
801060d4:	83 e2 9f             	and    $0xffffff9f,%edx
801060d7:	83 ca 80             	or     $0xffffff80,%edx
801060da:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
801060e0:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
801060e7:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
801060ed:	e8 bd d1 ff ff       	call   801032af <mycpu>
801060f2:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801060f9:	83 e2 ef             	and    $0xffffffef,%edx
801060fc:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106102:	e8 a8 d1 ff ff       	call   801032af <mycpu>
80106107:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
8010610d:	8b 5e 08             	mov    0x8(%esi),%ebx
80106110:	e8 9a d1 ff ff       	call   801032af <mycpu>
80106115:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010611b:	89 58 0c             	mov    %ebx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010611e:	e8 8c d1 ff ff       	call   801032af <mycpu>
80106123:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106129:	b8 28 00 00 00       	mov    $0x28,%eax
8010612e:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106131:	8b 46 04             	mov    0x4(%esi),%eax
    if (a < (void*) KERNBASE)
80106134:	3d ff ff ff 7f       	cmp    $0x7fffffff,%eax
80106139:	76 3c                	jbe    80106177 <switchuvm+0x123>
    return (uint)a - KERNBASE;
8010613b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106140:	0f 22 d8             	mov    %eax,%cr3
  popcli();
80106143:	e8 34 db ff ff       	call   80103c7c <popcli>
}
80106148:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010614b:	5b                   	pop    %ebx
8010614c:	5e                   	pop    %esi
8010614d:	5f                   	pop    %edi
8010614e:	5d                   	pop    %ebp
8010614f:	c3                   	ret    
    panic("switchuvm: no process");
80106150:	83 ec 0c             	sub    $0xc,%esp
80106153:	68 1a 71 10 80       	push   $0x8010711a
80106158:	e8 ff a1 ff ff       	call   8010035c <panic>
    panic("switchuvm: no kstack");
8010615d:	83 ec 0c             	sub    $0xc,%esp
80106160:	68 30 71 10 80       	push   $0x80107130
80106165:	e8 f2 a1 ff ff       	call   8010035c <panic>
    panic("switchuvm: no pgdir");
8010616a:	83 ec 0c             	sub    $0xc,%esp
8010616d:	68 45 71 10 80       	push   $0x80107145
80106172:	e8 e5 a1 ff ff       	call   8010035c <panic>
        panic("V2P on address < KERNBASE "
80106177:	83 ec 0c             	sub    $0xc,%esp
8010617a:	68 08 6a 10 80       	push   $0x80106a08
8010617f:	e8 d8 a1 ff ff       	call   8010035c <panic>

80106184 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106184:	f3 0f 1e fb          	endbr32 
80106188:	55                   	push   %ebp
80106189:	89 e5                	mov    %esp,%ebp
8010618b:	56                   	push   %esi
8010618c:	53                   	push   %ebx
8010618d:	8b 75 10             	mov    0x10(%ebp),%esi
  char *mem;

  if(sz >= PGSIZE)
80106190:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106196:	77 57                	ja     801061ef <inituvm+0x6b>
    panic("inituvm: more than a page");
  mem = kalloc();
80106198:	e8 db bf ff ff       	call   80102178 <kalloc>
8010619d:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
8010619f:	83 ec 04             	sub    $0x4,%esp
801061a2:	68 00 10 00 00       	push   $0x1000
801061a7:	6a 00                	push   $0x0
801061a9:	50                   	push   %eax
801061aa:	e8 29 dc ff ff       	call   80103dd8 <memset>
    if (a < (void*) KERNBASE)
801061af:	83 c4 10             	add    $0x10,%esp
801061b2:	81 fb ff ff ff 7f    	cmp    $0x7fffffff,%ebx
801061b8:	76 42                	jbe    801061fc <inituvm+0x78>
    return (uint)a - KERNBASE;
801061ba:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801061c0:	83 ec 08             	sub    $0x8,%esp
801061c3:	6a 06                	push   $0x6
801061c5:	50                   	push   %eax
801061c6:	b9 00 10 00 00       	mov    $0x1000,%ecx
801061cb:	ba 00 00 00 00       	mov    $0x0,%edx
801061d0:	8b 45 08             	mov    0x8(%ebp),%eax
801061d3:	e8 8d fc ff ff       	call   80105e65 <mappages>
  memmove(mem, init, sz);
801061d8:	83 c4 0c             	add    $0xc,%esp
801061db:	56                   	push   %esi
801061dc:	ff 75 0c             	pushl  0xc(%ebp)
801061df:	53                   	push   %ebx
801061e0:	e8 73 dc ff ff       	call   80103e58 <memmove>
}
801061e5:	83 c4 10             	add    $0x10,%esp
801061e8:	8d 65 f8             	lea    -0x8(%ebp),%esp
801061eb:	5b                   	pop    %ebx
801061ec:	5e                   	pop    %esi
801061ed:	5d                   	pop    %ebp
801061ee:	c3                   	ret    
    panic("inituvm: more than a page");
801061ef:	83 ec 0c             	sub    $0xc,%esp
801061f2:	68 59 71 10 80       	push   $0x80107159
801061f7:	e8 60 a1 ff ff       	call   8010035c <panic>
        panic("V2P on address < KERNBASE "
801061fc:	83 ec 0c             	sub    $0xc,%esp
801061ff:	68 08 6a 10 80       	push   $0x80106a08
80106204:	e8 53 a1 ff ff       	call   8010035c <panic>

80106209 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80106209:	f3 0f 1e fb          	endbr32 
8010620d:	55                   	push   %ebp
8010620e:	89 e5                	mov    %esp,%ebp
80106210:	57                   	push   %edi
80106211:	56                   	push   %esi
80106212:	53                   	push   %ebx
80106213:	83 ec 0c             	sub    $0xc,%esp
80106216:	8b 7d 18             	mov    0x18(%ebp),%edi
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80106219:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010621c:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
80106222:	74 43                	je     80106267 <loaduvm+0x5e>
    panic("loaduvm: addr must be page aligned");
80106224:	83 ec 0c             	sub    $0xc,%esp
80106227:	68 14 72 10 80       	push   $0x80107214
8010622c:	e8 2b a1 ff ff       	call   8010035c <panic>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
80106231:	83 ec 0c             	sub    $0xc,%esp
80106234:	68 73 71 10 80       	push   $0x80107173
80106239:	e8 1e a1 ff ff       	call   8010035c <panic>
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010623e:	89 da                	mov    %ebx,%edx
80106240:	03 55 14             	add    0x14(%ebp),%edx
    if (a > KERNBASE)
80106243:	3d 00 00 00 80       	cmp    $0x80000000,%eax
80106248:	77 51                	ja     8010629b <loaduvm+0x92>
    return (char*)a + KERNBASE;
8010624a:	05 00 00 00 80       	add    $0x80000000,%eax
8010624f:	56                   	push   %esi
80106250:	52                   	push   %edx
80106251:	50                   	push   %eax
80106252:	ff 75 10             	pushl  0x10(%ebp)
80106255:	e8 76 b5 ff ff       	call   801017d0 <readi>
8010625a:	83 c4 10             	add    $0x10,%esp
8010625d:	39 f0                	cmp    %esi,%eax
8010625f:	75 54                	jne    801062b5 <loaduvm+0xac>
  for(i = 0; i < sz; i += PGSIZE){
80106261:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106267:	39 fb                	cmp    %edi,%ebx
80106269:	73 3d                	jae    801062a8 <loaduvm+0x9f>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
8010626b:	89 da                	mov    %ebx,%edx
8010626d:	03 55 0c             	add    0xc(%ebp),%edx
80106270:	b9 00 00 00 00       	mov    $0x0,%ecx
80106275:	8b 45 08             	mov    0x8(%ebp),%eax
80106278:	e8 4d fb ff ff       	call   80105dca <walkpgdir>
8010627d:	85 c0                	test   %eax,%eax
8010627f:	74 b0                	je     80106231 <loaduvm+0x28>
    pa = PTE_ADDR(*pte);
80106281:	8b 00                	mov    (%eax),%eax
80106283:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106288:	89 fe                	mov    %edi,%esi
8010628a:	29 de                	sub    %ebx,%esi
8010628c:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106292:	76 aa                	jbe    8010623e <loaduvm+0x35>
      n = PGSIZE;
80106294:	be 00 10 00 00       	mov    $0x1000,%esi
80106299:	eb a3                	jmp    8010623e <loaduvm+0x35>
        panic("P2V on address > KERNBASE");
8010629b:	83 ec 0c             	sub    $0xc,%esp
8010629e:	68 38 6d 10 80       	push   $0x80106d38
801062a3:	e8 b4 a0 ff ff       	call   8010035c <panic>
      return -1;
  }
  return 0;
801062a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801062ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801062b0:	5b                   	pop    %ebx
801062b1:	5e                   	pop    %esi
801062b2:	5f                   	pop    %edi
801062b3:	5d                   	pop    %ebp
801062b4:	c3                   	ret    
      return -1;
801062b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062ba:	eb f1                	jmp    801062ad <loaduvm+0xa4>

801062bc <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801062bc:	f3 0f 1e fb          	endbr32 
801062c0:	55                   	push   %ebp
801062c1:	89 e5                	mov    %esp,%ebp
801062c3:	57                   	push   %edi
801062c4:	56                   	push   %esi
801062c5:	53                   	push   %ebx
801062c6:	83 ec 0c             	sub    $0xc,%esp
801062c9:	8b 7d 0c             	mov    0xc(%ebp),%edi
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801062cc:	39 7d 10             	cmp    %edi,0x10(%ebp)
801062cf:	73 11                	jae    801062e2 <deallocuvm+0x26>
    return oldsz;

  a = PGROUNDUP(newsz);
801062d1:	8b 45 10             	mov    0x10(%ebp),%eax
801062d4:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801062da:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
801062e0:	eb 19                	jmp    801062fb <deallocuvm+0x3f>
    return oldsz;
801062e2:	89 f8                	mov    %edi,%eax
801062e4:	eb 78                	jmp    8010635e <deallocuvm+0xa2>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801062e6:	c1 eb 16             	shr    $0x16,%ebx
801062e9:	83 c3 01             	add    $0x1,%ebx
801062ec:	c1 e3 16             	shl    $0x16,%ebx
801062ef:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
  for(; a  < oldsz; a += PGSIZE){
801062f5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801062fb:	39 fb                	cmp    %edi,%ebx
801062fd:	73 5c                	jae    8010635b <deallocuvm+0x9f>
    pte = walkpgdir(pgdir, (char*)a, 0);
801062ff:	b9 00 00 00 00       	mov    $0x0,%ecx
80106304:	89 da                	mov    %ebx,%edx
80106306:	8b 45 08             	mov    0x8(%ebp),%eax
80106309:	e8 bc fa ff ff       	call   80105dca <walkpgdir>
8010630e:	89 c6                	mov    %eax,%esi
    if(!pte)
80106310:	85 c0                	test   %eax,%eax
80106312:	74 d2                	je     801062e6 <deallocuvm+0x2a>
    else if((*pte & PTE_P) != 0){
80106314:	8b 00                	mov    (%eax),%eax
80106316:	a8 01                	test   $0x1,%al
80106318:	74 db                	je     801062f5 <deallocuvm+0x39>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010631a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010631f:	74 20                	je     80106341 <deallocuvm+0x85>
    if (a > KERNBASE)
80106321:	3d 00 00 00 80       	cmp    $0x80000000,%eax
80106326:	77 26                	ja     8010634e <deallocuvm+0x92>
    return (char*)a + KERNBASE;
80106328:	05 00 00 00 80       	add    $0x80000000,%eax
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
8010632d:	83 ec 0c             	sub    $0xc,%esp
80106330:	50                   	push   %eax
80106331:	e8 f5 bc ff ff       	call   8010202b <kfree>
      *pte = 0;
80106336:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010633c:	83 c4 10             	add    $0x10,%esp
8010633f:	eb b4                	jmp    801062f5 <deallocuvm+0x39>
        panic("kfree");
80106341:	83 ec 0c             	sub    $0xc,%esp
80106344:	68 96 6a 10 80       	push   $0x80106a96
80106349:	e8 0e a0 ff ff       	call   8010035c <panic>
        panic("P2V on address > KERNBASE");
8010634e:	83 ec 0c             	sub    $0xc,%esp
80106351:	68 38 6d 10 80       	push   $0x80106d38
80106356:	e8 01 a0 ff ff       	call   8010035c <panic>
    }
  }
  return newsz;
8010635b:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010635e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106361:	5b                   	pop    %ebx
80106362:	5e                   	pop    %esi
80106363:	5f                   	pop    %edi
80106364:	5d                   	pop    %ebp
80106365:	c3                   	ret    

80106366 <allocuvm>:
{
80106366:	f3 0f 1e fb          	endbr32 
8010636a:	55                   	push   %ebp
8010636b:	89 e5                	mov    %esp,%ebp
8010636d:	57                   	push   %edi
8010636e:	56                   	push   %esi
8010636f:	53                   	push   %ebx
80106370:	83 ec 1c             	sub    $0x1c,%esp
80106373:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(newsz >= KERNBASE)
80106376:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80106379:	85 ff                	test   %edi,%edi
8010637b:	0f 88 db 00 00 00    	js     8010645c <allocuvm+0xf6>
  if(newsz < oldsz)
80106381:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106384:	72 11                	jb     80106397 <allocuvm+0x31>
  a = PGROUNDUP(oldsz);
80106386:	8b 45 0c             	mov    0xc(%ebp),%eax
80106389:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
8010638f:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80106395:	eb 49                	jmp    801063e0 <allocuvm+0x7a>
    return oldsz;
80106397:	8b 45 0c             	mov    0xc(%ebp),%eax
8010639a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010639d:	e9 c1 00 00 00       	jmp    80106463 <allocuvm+0xfd>
      cprintf("allocuvm out of memory\n");
801063a2:	83 ec 0c             	sub    $0xc,%esp
801063a5:	68 91 71 10 80       	push   $0x80107191
801063aa:	e8 7a a2 ff ff       	call   80100629 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
801063af:	83 c4 0c             	add    $0xc,%esp
801063b2:	ff 75 0c             	pushl  0xc(%ebp)
801063b5:	57                   	push   %edi
801063b6:	ff 75 08             	pushl  0x8(%ebp)
801063b9:	e8 fe fe ff ff       	call   801062bc <deallocuvm>
      return 0;
801063be:	83 c4 10             	add    $0x10,%esp
801063c1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801063c8:	e9 96 00 00 00       	jmp    80106463 <allocuvm+0xfd>
        panic("V2P on address < KERNBASE "
801063cd:	83 ec 0c             	sub    $0xc,%esp
801063d0:	68 08 6a 10 80       	push   $0x80106a08
801063d5:	e8 82 9f ff ff       	call   8010035c <panic>
  for(; a < newsz; a += PGSIZE){
801063da:	81 c6 00 10 00 00    	add    $0x1000,%esi
801063e0:	39 fe                	cmp    %edi,%esi
801063e2:	73 7f                	jae    80106463 <allocuvm+0xfd>
    mem = kalloc();
801063e4:	e8 8f bd ff ff       	call   80102178 <kalloc>
801063e9:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
801063eb:	85 c0                	test   %eax,%eax
801063ed:	74 b3                	je     801063a2 <allocuvm+0x3c>
    memset(mem, 0, PGSIZE);
801063ef:	83 ec 04             	sub    $0x4,%esp
801063f2:	68 00 10 00 00       	push   $0x1000
801063f7:	6a 00                	push   $0x0
801063f9:	50                   	push   %eax
801063fa:	e8 d9 d9 ff ff       	call   80103dd8 <memset>
    if (a < (void*) KERNBASE)
801063ff:	83 c4 10             	add    $0x10,%esp
80106402:	81 fb ff ff ff 7f    	cmp    $0x7fffffff,%ebx
80106408:	76 c3                	jbe    801063cd <allocuvm+0x67>
    return (uint)a - KERNBASE;
8010640a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106410:	83 ec 08             	sub    $0x8,%esp
80106413:	6a 06                	push   $0x6
80106415:	50                   	push   %eax
80106416:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010641b:	89 f2                	mov    %esi,%edx
8010641d:	8b 45 08             	mov    0x8(%ebp),%eax
80106420:	e8 40 fa ff ff       	call   80105e65 <mappages>
80106425:	83 c4 10             	add    $0x10,%esp
80106428:	85 c0                	test   %eax,%eax
8010642a:	79 ae                	jns    801063da <allocuvm+0x74>
      cprintf("allocuvm out of memory (2)\n");
8010642c:	83 ec 0c             	sub    $0xc,%esp
8010642f:	68 a9 71 10 80       	push   $0x801071a9
80106434:	e8 f0 a1 ff ff       	call   80100629 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80106439:	83 c4 0c             	add    $0xc,%esp
8010643c:	ff 75 0c             	pushl  0xc(%ebp)
8010643f:	57                   	push   %edi
80106440:	ff 75 08             	pushl  0x8(%ebp)
80106443:	e8 74 fe ff ff       	call   801062bc <deallocuvm>
      kfree(mem);
80106448:	89 1c 24             	mov    %ebx,(%esp)
8010644b:	e8 db bb ff ff       	call   8010202b <kfree>
      return 0;
80106450:	83 c4 10             	add    $0x10,%esp
80106453:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010645a:	eb 07                	jmp    80106463 <allocuvm+0xfd>
    return 0;
8010645c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80106463:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106466:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106469:	5b                   	pop    %ebx
8010646a:	5e                   	pop    %esi
8010646b:	5f                   	pop    %edi
8010646c:	5d                   	pop    %ebp
8010646d:	c3                   	ret    

8010646e <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
8010646e:	f3 0f 1e fb          	endbr32 
80106472:	55                   	push   %ebp
80106473:	89 e5                	mov    %esp,%ebp
80106475:	56                   	push   %esi
80106476:	53                   	push   %ebx
80106477:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010647a:	85 f6                	test   %esi,%esi
8010647c:	74 1a                	je     80106498 <freevm+0x2a>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
8010647e:	83 ec 04             	sub    $0x4,%esp
80106481:	6a 00                	push   $0x0
80106483:	68 00 00 00 80       	push   $0x80000000
80106488:	56                   	push   %esi
80106489:	e8 2e fe ff ff       	call   801062bc <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
8010648e:	83 c4 10             	add    $0x10,%esp
80106491:	bb 00 00 00 00       	mov    $0x0,%ebx
80106496:	eb 1d                	jmp    801064b5 <freevm+0x47>
    panic("freevm: no pgdir");
80106498:	83 ec 0c             	sub    $0xc,%esp
8010649b:	68 c5 71 10 80       	push   $0x801071c5
801064a0:	e8 b7 9e ff ff       	call   8010035c <panic>
        panic("P2V on address > KERNBASE");
801064a5:	83 ec 0c             	sub    $0xc,%esp
801064a8:	68 38 6d 10 80       	push   $0x80106d38
801064ad:	e8 aa 9e ff ff       	call   8010035c <panic>
  for(i = 0; i < NPDENTRIES; i++){
801064b2:	83 c3 01             	add    $0x1,%ebx
801064b5:	81 fb ff 03 00 00    	cmp    $0x3ff,%ebx
801064bb:	77 26                	ja     801064e3 <freevm+0x75>
    if(pgdir[i] & PTE_P){
801064bd:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
801064c0:	a8 01                	test   $0x1,%al
801064c2:	74 ee                	je     801064b2 <freevm+0x44>
801064c4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if (a > KERNBASE)
801064c9:	3d 00 00 00 80       	cmp    $0x80000000,%eax
801064ce:	77 d5                	ja     801064a5 <freevm+0x37>
    return (char*)a + KERNBASE;
801064d0:	05 00 00 00 80       	add    $0x80000000,%eax
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
801064d5:	83 ec 0c             	sub    $0xc,%esp
801064d8:	50                   	push   %eax
801064d9:	e8 4d bb ff ff       	call   8010202b <kfree>
801064de:	83 c4 10             	add    $0x10,%esp
801064e1:	eb cf                	jmp    801064b2 <freevm+0x44>
    }
  }
  kfree((char*)pgdir);
801064e3:	83 ec 0c             	sub    $0xc,%esp
801064e6:	56                   	push   %esi
801064e7:	e8 3f bb ff ff       	call   8010202b <kfree>
}
801064ec:	83 c4 10             	add    $0x10,%esp
801064ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801064f2:	5b                   	pop    %ebx
801064f3:	5e                   	pop    %esi
801064f4:	5d                   	pop    %ebp
801064f5:	c3                   	ret    

801064f6 <setupkvm>:
{
801064f6:	f3 0f 1e fb          	endbr32 
801064fa:	55                   	push   %ebp
801064fb:	89 e5                	mov    %esp,%ebp
801064fd:	56                   	push   %esi
801064fe:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801064ff:	e8 74 bc ff ff       	call   80102178 <kalloc>
80106504:	89 c6                	mov    %eax,%esi
80106506:	85 c0                	test   %eax,%eax
80106508:	74 55                	je     8010655f <setupkvm+0x69>
  memset(pgdir, 0, PGSIZE);
8010650a:	83 ec 04             	sub    $0x4,%esp
8010650d:	68 00 10 00 00       	push   $0x1000
80106512:	6a 00                	push   $0x0
80106514:	50                   	push   %eax
80106515:	e8 be d8 ff ff       	call   80103dd8 <memset>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010651a:	83 c4 10             	add    $0x10,%esp
8010651d:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
80106522:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106528:	73 35                	jae    8010655f <setupkvm+0x69>
                (uint)k->phys_start, k->perm) < 0) {
8010652a:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010652d:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106530:	29 c1                	sub    %eax,%ecx
80106532:	83 ec 08             	sub    $0x8,%esp
80106535:	ff 73 0c             	pushl  0xc(%ebx)
80106538:	50                   	push   %eax
80106539:	8b 13                	mov    (%ebx),%edx
8010653b:	89 f0                	mov    %esi,%eax
8010653d:	e8 23 f9 ff ff       	call   80105e65 <mappages>
80106542:	83 c4 10             	add    $0x10,%esp
80106545:	85 c0                	test   %eax,%eax
80106547:	78 05                	js     8010654e <setupkvm+0x58>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106549:	83 c3 10             	add    $0x10,%ebx
8010654c:	eb d4                	jmp    80106522 <setupkvm+0x2c>
      freevm(pgdir);
8010654e:	83 ec 0c             	sub    $0xc,%esp
80106551:	56                   	push   %esi
80106552:	e8 17 ff ff ff       	call   8010646e <freevm>
      return 0;
80106557:	83 c4 10             	add    $0x10,%esp
8010655a:	be 00 00 00 00       	mov    $0x0,%esi
}
8010655f:	89 f0                	mov    %esi,%eax
80106561:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106564:	5b                   	pop    %ebx
80106565:	5e                   	pop    %esi
80106566:	5d                   	pop    %ebp
80106567:	c3                   	ret    

80106568 <kvmalloc>:
{
80106568:	f3 0f 1e fb          	endbr32 
8010656c:	55                   	push   %ebp
8010656d:	89 e5                	mov    %esp,%ebp
8010656f:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106572:	e8 7f ff ff ff       	call   801064f6 <setupkvm>
80106577:	a3 a4 54 11 80       	mov    %eax,0x801154a4
  switchkvm();
8010657c:	e8 aa fa ff ff       	call   8010602b <switchkvm>
}
80106581:	c9                   	leave  
80106582:	c3                   	ret    

80106583 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106583:	f3 0f 1e fb          	endbr32 
80106587:	55                   	push   %ebp
80106588:	89 e5                	mov    %esp,%ebp
8010658a:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010658d:	b9 00 00 00 00       	mov    $0x0,%ecx
80106592:	8b 55 0c             	mov    0xc(%ebp),%edx
80106595:	8b 45 08             	mov    0x8(%ebp),%eax
80106598:	e8 2d f8 ff ff       	call   80105dca <walkpgdir>
  if(pte == 0)
8010659d:	85 c0                	test   %eax,%eax
8010659f:	74 05                	je     801065a6 <clearpteu+0x23>
    panic("clearpteu");
  *pte &= ~PTE_U;
801065a1:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801065a4:	c9                   	leave  
801065a5:	c3                   	ret    
    panic("clearpteu");
801065a6:	83 ec 0c             	sub    $0xc,%esp
801065a9:	68 d6 71 10 80       	push   $0x801071d6
801065ae:	e8 a9 9d ff ff       	call   8010035c <panic>

801065b3 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801065b3:	f3 0f 1e fb          	endbr32 
801065b7:	55                   	push   %ebp
801065b8:	89 e5                	mov    %esp,%ebp
801065ba:	57                   	push   %edi
801065bb:	56                   	push   %esi
801065bc:	53                   	push   %ebx
801065bd:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801065c0:	e8 31 ff ff ff       	call   801064f6 <setupkvm>
801065c5:	89 45 dc             	mov    %eax,-0x24(%ebp)
801065c8:	85 c0                	test   %eax,%eax
801065ca:	0f 84 f2 00 00 00    	je     801066c2 <copyuvm+0x10f>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801065d0:	bf 00 00 00 00       	mov    $0x0,%edi
801065d5:	eb 3a                	jmp    80106611 <copyuvm+0x5e>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
801065d7:	83 ec 0c             	sub    $0xc,%esp
801065da:	68 e0 71 10 80       	push   $0x801071e0
801065df:	e8 78 9d ff ff       	call   8010035c <panic>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
801065e4:	83 ec 0c             	sub    $0xc,%esp
801065e7:	68 fa 71 10 80       	push   $0x801071fa
801065ec:	e8 6b 9d ff ff       	call   8010035c <panic>
        panic("P2V on address > KERNBASE");
801065f1:	83 ec 0c             	sub    $0xc,%esp
801065f4:	68 38 6d 10 80       	push   $0x80106d38
801065f9:	e8 5e 9d ff ff       	call   8010035c <panic>
        panic("V2P on address < KERNBASE "
801065fe:	83 ec 0c             	sub    $0xc,%esp
80106601:	68 08 6a 10 80       	push   $0x80106a08
80106606:	e8 51 9d ff ff       	call   8010035c <panic>
  for(i = 0; i < sz; i += PGSIZE){
8010660b:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106611:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106614:	0f 83 a8 00 00 00    	jae    801066c2 <copyuvm+0x10f>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
8010661a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
8010661d:	b9 00 00 00 00       	mov    $0x0,%ecx
80106622:	89 fa                	mov    %edi,%edx
80106624:	8b 45 08             	mov    0x8(%ebp),%eax
80106627:	e8 9e f7 ff ff       	call   80105dca <walkpgdir>
8010662c:	85 c0                	test   %eax,%eax
8010662e:	74 a7                	je     801065d7 <copyuvm+0x24>
    if(!(*pte & PTE_P))
80106630:	8b 00                	mov    (%eax),%eax
80106632:	a8 01                	test   $0x1,%al
80106634:	74 ae                	je     801065e4 <copyuvm+0x31>
80106636:	89 c6                	mov    %eax,%esi
80106638:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
static inline uint PTE_FLAGS(uint pte) { return pte & 0xFFF; }
8010663e:	25 ff 0f 00 00       	and    $0xfff,%eax
80106643:	89 45 e0             	mov    %eax,-0x20(%ebp)
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
80106646:	e8 2d bb ff ff       	call   80102178 <kalloc>
8010664b:	89 c3                	mov    %eax,%ebx
8010664d:	85 c0                	test   %eax,%eax
8010664f:	74 5c                	je     801066ad <copyuvm+0xfa>
    if (a > KERNBASE)
80106651:	81 fe 00 00 00 80    	cmp    $0x80000000,%esi
80106657:	77 98                	ja     801065f1 <copyuvm+0x3e>
    return (char*)a + KERNBASE;
80106659:	81 c6 00 00 00 80    	add    $0x80000000,%esi
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
8010665f:	83 ec 04             	sub    $0x4,%esp
80106662:	68 00 10 00 00       	push   $0x1000
80106667:	56                   	push   %esi
80106668:	50                   	push   %eax
80106669:	e8 ea d7 ff ff       	call   80103e58 <memmove>
    if (a < (void*) KERNBASE)
8010666e:	83 c4 10             	add    $0x10,%esp
80106671:	81 fb ff ff ff 7f    	cmp    $0x7fffffff,%ebx
80106677:	76 85                	jbe    801065fe <copyuvm+0x4b>
    return (uint)a - KERNBASE;
80106679:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
8010667f:	83 ec 08             	sub    $0x8,%esp
80106682:	ff 75 e0             	pushl  -0x20(%ebp)
80106685:	50                   	push   %eax
80106686:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010668b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010668e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106691:	e8 cf f7 ff ff       	call   80105e65 <mappages>
80106696:	83 c4 10             	add    $0x10,%esp
80106699:	85 c0                	test   %eax,%eax
8010669b:	0f 89 6a ff ff ff    	jns    8010660b <copyuvm+0x58>
      kfree(mem);
801066a1:	83 ec 0c             	sub    $0xc,%esp
801066a4:	53                   	push   %ebx
801066a5:	e8 81 b9 ff ff       	call   8010202b <kfree>
      goto bad;
801066aa:	83 c4 10             	add    $0x10,%esp
    }
  }
  return d;

bad:
  freevm(d);
801066ad:	83 ec 0c             	sub    $0xc,%esp
801066b0:	ff 75 dc             	pushl  -0x24(%ebp)
801066b3:	e8 b6 fd ff ff       	call   8010646e <freevm>
  return 0;
801066b8:	83 c4 10             	add    $0x10,%esp
801066bb:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
}
801066c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
801066c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801066c8:	5b                   	pop    %ebx
801066c9:	5e                   	pop    %esi
801066ca:	5f                   	pop    %edi
801066cb:	5d                   	pop    %ebp
801066cc:	c3                   	ret    

801066cd <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801066cd:	f3 0f 1e fb          	endbr32 
801066d1:	55                   	push   %ebp
801066d2:	89 e5                	mov    %esp,%ebp
801066d4:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801066d7:	b9 00 00 00 00       	mov    $0x0,%ecx
801066dc:	8b 55 0c             	mov    0xc(%ebp),%edx
801066df:	8b 45 08             	mov    0x8(%ebp),%eax
801066e2:	e8 e3 f6 ff ff       	call   80105dca <walkpgdir>
  if((*pte & PTE_P) == 0)
801066e7:	8b 00                	mov    (%eax),%eax
801066e9:	a8 01                	test   $0x1,%al
801066eb:	74 24                	je     80106711 <uva2ka+0x44>
    return 0;
  if((*pte & PTE_U) == 0)
801066ed:	a8 04                	test   $0x4,%al
801066ef:	74 27                	je     80106718 <uva2ka+0x4b>
static inline uint PTE_ADDR(uint pte)  { return pte & ~0xFFF; }
801066f1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if (a > KERNBASE)
801066f6:	3d 00 00 00 80       	cmp    $0x80000000,%eax
801066fb:	77 07                	ja     80106704 <uva2ka+0x37>
    return (char*)a + KERNBASE;
801066fd:	05 00 00 00 80       	add    $0x80000000,%eax
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80106702:	c9                   	leave  
80106703:	c3                   	ret    
        panic("P2V on address > KERNBASE");
80106704:	83 ec 0c             	sub    $0xc,%esp
80106707:	68 38 6d 10 80       	push   $0x80106d38
8010670c:	e8 4b 9c ff ff       	call   8010035c <panic>
    return 0;
80106711:	b8 00 00 00 00       	mov    $0x0,%eax
80106716:	eb ea                	jmp    80106702 <uva2ka+0x35>
    return 0;
80106718:	b8 00 00 00 00       	mov    $0x0,%eax
8010671d:	eb e3                	jmp    80106702 <uva2ka+0x35>

8010671f <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
8010671f:	f3 0f 1e fb          	endbr32 
80106723:	55                   	push   %ebp
80106724:	89 e5                	mov    %esp,%ebp
80106726:	57                   	push   %edi
80106727:	56                   	push   %esi
80106728:	53                   	push   %ebx
80106729:	83 ec 0c             	sub    $0xc,%esp
8010672c:	8b 7d 14             	mov    0x14(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
8010672f:	eb 25                	jmp    80106756 <copyout+0x37>
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106731:	8b 55 0c             	mov    0xc(%ebp),%edx
80106734:	29 f2                	sub    %esi,%edx
80106736:	01 d0                	add    %edx,%eax
80106738:	83 ec 04             	sub    $0x4,%esp
8010673b:	53                   	push   %ebx
8010673c:	ff 75 10             	pushl  0x10(%ebp)
8010673f:	50                   	push   %eax
80106740:	e8 13 d7 ff ff       	call   80103e58 <memmove>
    len -= n;
80106745:	29 df                	sub    %ebx,%edi
    buf += n;
80106747:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
8010674a:	8d 86 00 10 00 00    	lea    0x1000(%esi),%eax
80106750:	89 45 0c             	mov    %eax,0xc(%ebp)
80106753:	83 c4 10             	add    $0x10,%esp
  while(len > 0){
80106756:	85 ff                	test   %edi,%edi
80106758:	74 2f                	je     80106789 <copyout+0x6a>
    va0 = (uint)PGROUNDDOWN(va);
8010675a:	8b 75 0c             	mov    0xc(%ebp),%esi
8010675d:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106763:	83 ec 08             	sub    $0x8,%esp
80106766:	56                   	push   %esi
80106767:	ff 75 08             	pushl  0x8(%ebp)
8010676a:	e8 5e ff ff ff       	call   801066cd <uva2ka>
    if(pa0 == 0)
8010676f:	83 c4 10             	add    $0x10,%esp
80106772:	85 c0                	test   %eax,%eax
80106774:	74 20                	je     80106796 <copyout+0x77>
    n = PGSIZE - (va - va0);
80106776:	89 f3                	mov    %esi,%ebx
80106778:	2b 5d 0c             	sub    0xc(%ebp),%ebx
8010677b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
80106781:	39 df                	cmp    %ebx,%edi
80106783:	73 ac                	jae    80106731 <copyout+0x12>
      n = len;
80106785:	89 fb                	mov    %edi,%ebx
80106787:	eb a8                	jmp    80106731 <copyout+0x12>
  }
  return 0;
80106789:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010678e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106791:	5b                   	pop    %ebx
80106792:	5e                   	pop    %esi
80106793:	5f                   	pop    %edi
80106794:	5d                   	pop    %ebp
80106795:	c3                   	ret    
      return -1;
80106796:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010679b:	eb f1                	jmp    8010678e <copyout+0x6f>
