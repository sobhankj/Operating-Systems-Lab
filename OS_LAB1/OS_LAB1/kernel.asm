
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 50 6c 11 80       	mov    $0x80116c50,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 60 44 10 80       	mov    $0x80104460,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 54 b5 10 80       	mov    $0x8010b554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 a0 85 10 80       	push   $0x801085a0
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 75 57 00 00       	call   801057d0 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c fc 10 80       	mov    $0x8010fc1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc6c
8010006a:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc70
80100074:	fc 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 a7 85 10 80       	push   $0x801085a7
80100097:	50                   	push   %eax
80100098:	e8 03 56 00 00       	call   801056a0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 f9 10 80    	cmp    $0x8010f9c0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 b5 10 80       	push   $0x8010b520
801000e4:	e8 b7 58 00 00       	call   801059a0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 fc 10 80    	mov    0x8010fc70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c fc 10 80    	mov    0x8010fc6c,%ebx
80100126:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 b5 10 80       	push   $0x8010b520
80100162:	e8 d9 57 00 00       	call   80105940 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 6e 55 00 00       	call   801056e0 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 4f 35 00 00       	call   801036e0 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 ae 85 10 80       	push   $0x801085ae
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001af:	90                   	nop

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 bd 55 00 00       	call   80105780 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave  
  iderw(b);
801001d4:	e9 07 35 00 00       	jmp    801036e0 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 bf 85 10 80       	push   $0x801085bf
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ed:	8d 76 00             	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 7c 55 00 00       	call   80105780 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 2c 55 00 00       	call   80105740 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 80 57 00 00       	call   801059a0 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2f                	jne    8010025f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 43 54             	mov    0x54(%ebx),%eax
80100233:	8b 53 50             	mov    0x50(%ebx),%edx
80100236:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100239:	8b 43 50             	mov    0x50(%ebx),%eax
8010023c:	8b 53 54             	mov    0x54(%ebx),%edx
8010023f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100242:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 20 b5 10 80 	movl   $0x8010b520,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 cf 56 00 00       	jmp    80105940 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 c6 85 10 80       	push   $0x801085c6
80100279:	e8 02 01 00 00       	call   80100380 <panic>
8010027e:	66 90                	xchg   %ax,%ax

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	push   0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 c7 29 00 00       	call   80102c60 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 80 06 11 80 	movl   $0x80110680,(%esp)
801002a0:	e8 fb 56 00 00       	call   801059a0 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 c0 05 11 80       	mov    0x801105c0,%eax
801002b5:	3b 05 c4 05 11 80    	cmp    0x801105c4,%eax
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 80 06 11 80       	push   $0x80110680
801002c8:	68 c0 05 11 80       	push   $0x801105c0
801002cd:	e8 6e 51 00 00       	call   80105440 <sleep>
    while(input.r == input.w){
801002d2:	a1 c0 05 11 80       	mov    0x801105c0,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 c4 05 11 80    	cmp    0x801105c4,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 89 4a 00 00       	call   80104d70 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 80 06 11 80       	push   $0x80110680
801002f6:	e8 45 56 00 00       	call   80105940 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 7c 28 00 00       	call   80102b80 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret    
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 c0 05 11 80    	mov    %edx,0x801105c0
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 40 05 11 80 	movsbl -0x7feefac0(%edx),%ecx
    if(c == C('D')){  // EOF
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 80 06 11 80       	push   $0x80110680
8010034c:	e8 ef 55 00 00       	call   80105940 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 26 28 00 00       	call   80102b80 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret    
      if(n < target){
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 c0 05 11 80       	mov    %eax,0x801105c0
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010037b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010037f:	90                   	nop

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli    
  cons.locking = 0;
80100389:	c7 05 b4 06 11 80 00 	movl   $0x0,0x801106b4
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 52 39 00 00       	call   80103cf0 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 cd 85 10 80       	push   $0x801085cd
801003a7:	e8 54 03 00 00       	call   80100700 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 4b 03 00 00       	call   80100700 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 57 8f 10 80 	movl   $0x80108f57,(%esp)
801003bc:	e8 3f 03 00 00       	call   80100700 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 23 54 00 00       	call   801057f0 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 e1 85 10 80       	push   $0x801085e1
801003dd:	e8 1e 03 00 00       	call   80100700 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 b8 06 11 80 01 	movl   $0x1,0x801106b8
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801003fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100400 <consputc.part.0>:
consputc(int c)
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 4a 01 00 00    	je     80100560 <consputc.part.0+0x160>
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 91 6c 00 00       	call   801070b0 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100441:	c1 e1 08             	shl    $0x8,%ecx
80100444:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100445:	89 f2                	mov    %esi,%edx
80100447:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100448:	0f b6 c0             	movzbl %al,%eax
8010044b:	09 c8                	or     %ecx,%eax
  if(c == '\n'){
8010044d:	83 fb 0a             	cmp    $0xa,%ebx
80100450:	0f 84 f2 00 00 00    	je     80100548 <consputc.part.0+0x148>
  for(int i = pos-1; i < pos + num_of_left_pressed; i++){
80100456:	8b 3d c4 06 11 80    	mov    0x801106c4,%edi
8010045c:	8d 34 38             	lea    (%eax,%edi,1),%esi
  else if(c == BACKSPACE){
8010045f:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
80100465:	0f 84 9d 00 00 00    	je     80100508 <consputc.part.0+0x108>
  for(int i = pos + num_of_left_pressed; i > pos; i--){
8010046b:	39 f0                	cmp    %esi,%eax
8010046d:	7d 1f                	jge    8010048e <consputc.part.0+0x8e>
8010046f:	8d 94 36 fe 7f 0b 80 	lea    -0x7ff48002(%esi,%esi,1),%edx
80100476:	8d b4 00 fe 7f 0b 80 	lea    -0x7ff48002(%eax,%eax,1),%esi
8010047d:	8d 76 00             	lea    0x0(%esi),%esi
    crt[i] = crt[i-1];
80100480:	0f b7 0a             	movzwl (%edx),%ecx
  for(int i = pos + num_of_left_pressed; i > pos; i--){
80100483:	83 ea 02             	sub    $0x2,%edx
    crt[i] = crt[i-1];
80100486:	66 89 4a 04          	mov    %cx,0x4(%edx)
  for(int i = pos + num_of_left_pressed; i > pos; i--){
8010048a:	39 d6                	cmp    %edx,%esi
8010048c:	75 f2                	jne    80100480 <consputc.part.0+0x80>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010048e:	0f b6 db             	movzbl %bl,%ebx
80100491:	8d 48 01             	lea    0x1(%eax),%ecx
80100494:	80 cf 07             	or     $0x7,%bh
80100497:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
8010049e:	80 
  if(pos < 0 || pos > 25*80)
8010049f:	81 f9 d0 07 00 00    	cmp    $0x7d0,%ecx
801004a5:	0f 8f 35 01 00 00    	jg     801005e0 <consputc.part.0+0x1e0>
  if((pos/80) >= 24){  // Scroll up.
801004ab:	81 f9 7f 07 00 00    	cmp    $0x77f,%ecx
801004b1:	0f 8f d9 00 00 00    	jg     80100590 <consputc.part.0+0x190>
  outb(CRTPORT+1, pos>>8);
801004b7:	0f b6 c5             	movzbl %ch,%eax
  crt[pos + num_of_left_pressed] = ' ' | 0x0700;
801004ba:	8b 3d c4 06 11 80    	mov    0x801106c4,%edi
  outb(CRTPORT+1, pos);
801004c0:	89 ce                	mov    %ecx,%esi
  outb(CRTPORT+1, pos>>8);
801004c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  crt[pos + num_of_left_pressed] = ' ' | 0x0700;
801004c5:	01 cf                	add    %ecx,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004c7:	bb d4 03 00 00       	mov    $0x3d4,%ebx
801004cc:	b8 0e 00 00 00       	mov    $0xe,%eax
801004d1:	89 da                	mov    %ebx,%edx
801004d3:	ee                   	out    %al,(%dx)
801004d4:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004d9:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
801004dd:	89 ca                	mov    %ecx,%edx
801004df:	ee                   	out    %al,(%dx)
801004e0:	b8 0f 00 00 00       	mov    $0xf,%eax
801004e5:	89 da                	mov    %ebx,%edx
801004e7:	ee                   	out    %al,(%dx)
801004e8:	89 f0                	mov    %esi,%eax
801004ea:	89 ca                	mov    %ecx,%edx
801004ec:	ee                   	out    %al,(%dx)
801004ed:	b8 20 07 00 00       	mov    $0x720,%eax
801004f2:	66 89 84 3f 00 80 0b 	mov    %ax,-0x7ff48000(%edi,%edi,1)
801004f9:	80 
}
801004fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004fd:	5b                   	pop    %ebx
801004fe:	5e                   	pop    %esi
801004ff:	5f                   	pop    %edi
80100500:	5d                   	pop    %ebp
80100501:	c3                   	ret    
80100502:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(int i = pos-1; i < pos + num_of_left_pressed; i++){
80100508:	8d 48 ff             	lea    -0x1(%eax),%ecx
8010050b:	8d 94 00 00 80 0b 80 	lea    -0x7ff48000(%eax,%eax,1),%edx
80100512:	89 cb                	mov    %ecx,%ebx
80100514:	85 ff                	test   %edi,%edi
80100516:	78 1c                	js     80100534 <consputc.part.0+0x134>
80100518:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010051b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010051f:	90                   	nop
    crt[i] = crt[i + 1];
80100520:	0f b7 02             	movzwl (%edx),%eax
  for(int i = pos-1; i < pos + num_of_left_pressed; i++){
80100523:	83 c3 01             	add    $0x1,%ebx
80100526:	83 c2 02             	add    $0x2,%edx
    crt[i] = crt[i + 1];
80100529:	66 89 42 fc          	mov    %ax,-0x4(%edx)
  for(int i = pos-1; i < pos + num_of_left_pressed; i++){
8010052d:	39 f3                	cmp    %esi,%ebx
8010052f:	7c ef                	jl     80100520 <consputc.part.0+0x120>
80100531:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if(pos > 0) --pos;
80100534:	85 c0                	test   %eax,%eax
80100536:	0f 85 63 ff ff ff    	jne    8010049f <consputc.part.0+0x9f>
8010053c:	c6 45 e4 00          	movb   $0x0,-0x1c(%ebp)
80100540:	31 f6                	xor    %esi,%esi
80100542:	eb 83                	jmp    801004c7 <consputc.part.0+0xc7>
80100544:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
80100548:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
8010054d:	f7 e2                	mul    %edx
8010054f:	c1 ea 06             	shr    $0x6,%edx
80100552:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100555:	c1 e0 04             	shl    $0x4,%eax
80100558:	8d 48 50             	lea    0x50(%eax),%ecx
8010055b:	e9 3f ff ff ff       	jmp    8010049f <consputc.part.0+0x9f>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100560:	83 ec 0c             	sub    $0xc,%esp
80100563:	6a 08                	push   $0x8
80100565:	e8 46 6b 00 00       	call   801070b0 <uartputc>
8010056a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100571:	e8 3a 6b 00 00       	call   801070b0 <uartputc>
80100576:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010057d:	e8 2e 6b 00 00       	call   801070b0 <uartputc>
80100582:	83 c4 10             	add    $0x10,%esp
80100585:	e9 98 fe ff ff       	jmp    80100422 <consputc.part.0+0x22>
8010058a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100590:	83 ec 04             	sub    $0x4,%esp
80100593:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80100596:	68 60 0e 00 00       	push   $0xe60
8010059b:	68 a0 80 0b 80       	push   $0x800b80a0
801005a0:	68 00 80 0b 80       	push   $0x800b8000
801005a5:	e8 56 55 00 00       	call   80105b00 <memmove>
    pos -= 80;
801005aa:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801005ad:	b8 80 07 00 00       	mov    $0x780,%eax
801005b2:	83 c4 0c             	add    $0xc,%esp
    pos -= 80;
801005b5:	8d 79 b0             	lea    -0x50(%ecx),%edi
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801005b8:	29 f8                	sub    %edi,%eax
  outb(CRTPORT+1, pos);
801005ba:	89 fe                	mov    %edi,%esi
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801005bc:	01 c0                	add    %eax,%eax
801005be:	50                   	push   %eax
801005bf:	8d 84 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%eax
801005c6:	6a 00                	push   $0x0
801005c8:	50                   	push   %eax
801005c9:	e8 92 54 00 00       	call   80105a60 <memset>
  crt[pos + num_of_left_pressed] = ' ' | 0x0700;
801005ce:	c6 45 e4 07          	movb   $0x7,-0x1c(%ebp)
801005d2:	03 3d c4 06 11 80    	add    0x801106c4,%edi
801005d8:	83 c4 10             	add    $0x10,%esp
801005db:	e9 e7 fe ff ff       	jmp    801004c7 <consputc.part.0+0xc7>
    panic("pos under/overflow");
801005e0:	83 ec 0c             	sub    $0xc,%esp
801005e3:	68 e5 85 10 80       	push   $0x801085e5
801005e8:	e8 93 fd ff ff       	call   80100380 <panic>
801005ed:	8d 76 00             	lea    0x0(%esi),%esi

801005f0 <consolewrite>:
int
consolewrite(struct inode *ip, char *buf, int n)
{
801005f0:	55                   	push   %ebp
801005f1:	89 e5                	mov    %esp,%ebp
801005f3:	57                   	push   %edi
801005f4:	56                   	push   %esi
801005f5:	53                   	push   %ebx
801005f6:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
801005f9:	ff 75 08             	push   0x8(%ebp)
{
801005fc:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
801005ff:	e8 5c 26 00 00       	call   80102c60 <iunlock>
  acquire(&cons.lock);
80100604:	c7 04 24 80 06 11 80 	movl   $0x80110680,(%esp)
8010060b:	e8 90 53 00 00       	call   801059a0 <acquire>
  for(i = 0; i < n; i++)
80100610:	83 c4 10             	add    $0x10,%esp
80100613:	85 f6                	test   %esi,%esi
80100615:	7e 25                	jle    8010063c <consolewrite+0x4c>
80100617:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010061a:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
8010061d:	8b 15 b8 06 11 80    	mov    0x801106b8,%edx
    consputc(buf[i] & 0xff);
80100623:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
80100626:	85 d2                	test   %edx,%edx
80100628:	74 06                	je     80100630 <consolewrite+0x40>
  asm volatile("cli");
8010062a:	fa                   	cli    
    for(;;)
8010062b:	eb fe                	jmp    8010062b <consolewrite+0x3b>
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
80100630:	e8 cb fd ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; i < n; i++)
80100635:	83 c3 01             	add    $0x1,%ebx
80100638:	39 df                	cmp    %ebx,%edi
8010063a:	75 e1                	jne    8010061d <consolewrite+0x2d>
  release(&cons.lock);
8010063c:	83 ec 0c             	sub    $0xc,%esp
8010063f:	68 80 06 11 80       	push   $0x80110680
80100644:	e8 f7 52 00 00       	call   80105940 <release>
  ilock(ip);
80100649:	58                   	pop    %eax
8010064a:	ff 75 08             	push   0x8(%ebp)
8010064d:	e8 2e 25 00 00       	call   80102b80 <ilock>
  return n;
}
80100652:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100655:	89 f0                	mov    %esi,%eax
80100657:	5b                   	pop    %ebx
80100658:	5e                   	pop    %esi
80100659:	5f                   	pop    %edi
8010065a:	5d                   	pop    %ebp
8010065b:	c3                   	ret    
8010065c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100660 <printint>:
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 2c             	sub    $0x2c,%esp
80100669:	89 55 d4             	mov    %edx,-0x2c(%ebp)
8010066c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  if(sign && (sign = xx < 0))
8010066f:	85 c9                	test   %ecx,%ecx
80100671:	74 04                	je     80100677 <printint+0x17>
80100673:	85 c0                	test   %eax,%eax
80100675:	78 6d                	js     801006e4 <printint+0x84>
    x = xx;
80100677:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
8010067e:	89 c1                	mov    %eax,%ecx
  i = 0;
80100680:	31 db                	xor    %ebx,%ebx
80100682:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    buf[i++] = digits[x % base];
80100688:	89 c8                	mov    %ecx,%eax
8010068a:	31 d2                	xor    %edx,%edx
8010068c:	89 de                	mov    %ebx,%esi
8010068e:	89 cf                	mov    %ecx,%edi
80100690:	f7 75 d4             	divl   -0x2c(%ebp)
80100693:	8d 5b 01             	lea    0x1(%ebx),%ebx
80100696:	0f b6 92 5c 86 10 80 	movzbl -0x7fef79a4(%edx),%edx
  }while((x /= base) != 0);
8010069d:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
8010069f:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
801006a3:	3b 7d d4             	cmp    -0x2c(%ebp),%edi
801006a6:	73 e0                	jae    80100688 <printint+0x28>
  if(sign)
801006a8:	8b 4d d0             	mov    -0x30(%ebp),%ecx
801006ab:	85 c9                	test   %ecx,%ecx
801006ad:	74 0c                	je     801006bb <printint+0x5b>
    buf[i++] = '-';
801006af:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
801006b4:	89 de                	mov    %ebx,%esi
    buf[i++] = '-';
801006b6:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
801006bb:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
801006bf:	0f be c2             	movsbl %dl,%eax
  if(panicked){
801006c2:	8b 15 b8 06 11 80    	mov    0x801106b8,%edx
801006c8:	85 d2                	test   %edx,%edx
801006ca:	74 04                	je     801006d0 <printint+0x70>
801006cc:	fa                   	cli    
    for(;;)
801006cd:	eb fe                	jmp    801006cd <printint+0x6d>
801006cf:	90                   	nop
801006d0:	e8 2b fd ff ff       	call   80100400 <consputc.part.0>
  while(--i >= 0)
801006d5:	8d 45 d7             	lea    -0x29(%ebp),%eax
801006d8:	39 c3                	cmp    %eax,%ebx
801006da:	74 0e                	je     801006ea <printint+0x8a>
    consputc(buf[i]);
801006dc:	0f be 03             	movsbl (%ebx),%eax
801006df:	83 eb 01             	sub    $0x1,%ebx
801006e2:	eb de                	jmp    801006c2 <printint+0x62>
    x = -xx;
801006e4:	f7 d8                	neg    %eax
801006e6:	89 c1                	mov    %eax,%ecx
801006e8:	eb 96                	jmp    80100680 <printint+0x20>
}
801006ea:	83 c4 2c             	add    $0x2c,%esp
801006ed:	5b                   	pop    %ebx
801006ee:	5e                   	pop    %esi
801006ef:	5f                   	pop    %edi
801006f0:	5d                   	pop    %ebp
801006f1:	c3                   	ret    
801006f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801006f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100700 <cprintf>:
{
80100700:	55                   	push   %ebp
80100701:	89 e5                	mov    %esp,%ebp
80100703:	57                   	push   %edi
80100704:	56                   	push   %esi
80100705:	53                   	push   %ebx
80100706:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100709:	a1 b4 06 11 80       	mov    0x801106b4,%eax
8010070e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(locking)
80100711:	85 c0                	test   %eax,%eax
80100713:	0f 85 27 01 00 00    	jne    80100840 <cprintf+0x140>
  if (fmt == 0)
80100719:	8b 75 08             	mov    0x8(%ebp),%esi
8010071c:	85 f6                	test   %esi,%esi
8010071e:	0f 84 ac 01 00 00    	je     801008d0 <cprintf+0x1d0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100724:	0f b6 06             	movzbl (%esi),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100727:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010072a:	31 db                	xor    %ebx,%ebx
8010072c:	85 c0                	test   %eax,%eax
8010072e:	74 56                	je     80100786 <cprintf+0x86>
    if(c != '%'){
80100730:	83 f8 25             	cmp    $0x25,%eax
80100733:	0f 85 cf 00 00 00    	jne    80100808 <cprintf+0x108>
    c = fmt[++i] & 0xff;
80100739:	83 c3 01             	add    $0x1,%ebx
8010073c:	0f b6 14 1e          	movzbl (%esi,%ebx,1),%edx
    if(c == 0)
80100740:	85 d2                	test   %edx,%edx
80100742:	74 42                	je     80100786 <cprintf+0x86>
    switch(c){
80100744:	83 fa 70             	cmp    $0x70,%edx
80100747:	0f 84 90 00 00 00    	je     801007dd <cprintf+0xdd>
8010074d:	7f 51                	jg     801007a0 <cprintf+0xa0>
8010074f:	83 fa 25             	cmp    $0x25,%edx
80100752:	0f 84 c0 00 00 00    	je     80100818 <cprintf+0x118>
80100758:	83 fa 64             	cmp    $0x64,%edx
8010075b:	0f 85 f4 00 00 00    	jne    80100855 <cprintf+0x155>
      printint(*argp++, 10, 1);
80100761:	8d 47 04             	lea    0x4(%edi),%eax
80100764:	b9 01 00 00 00       	mov    $0x1,%ecx
80100769:	ba 0a 00 00 00       	mov    $0xa,%edx
8010076e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100771:	8b 07                	mov    (%edi),%eax
80100773:	e8 e8 fe ff ff       	call   80100660 <printint>
80100778:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010077b:	83 c3 01             	add    $0x1,%ebx
8010077e:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100782:	85 c0                	test   %eax,%eax
80100784:	75 aa                	jne    80100730 <cprintf+0x30>
  if(locking)
80100786:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100789:	85 c0                	test   %eax,%eax
8010078b:	0f 85 22 01 00 00    	jne    801008b3 <cprintf+0x1b3>
}
80100791:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100794:	5b                   	pop    %ebx
80100795:	5e                   	pop    %esi
80100796:	5f                   	pop    %edi
80100797:	5d                   	pop    %ebp
80100798:	c3                   	ret    
80100799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
801007a0:	83 fa 73             	cmp    $0x73,%edx
801007a3:	75 33                	jne    801007d8 <cprintf+0xd8>
      if((s = (char*)*argp++) == 0)
801007a5:	8d 47 04             	lea    0x4(%edi),%eax
801007a8:	8b 3f                	mov    (%edi),%edi
801007aa:	89 45 e0             	mov    %eax,-0x20(%ebp)
801007ad:	85 ff                	test   %edi,%edi
801007af:	0f 84 e3 00 00 00    	je     80100898 <cprintf+0x198>
      for(; *s; s++)
801007b5:	0f be 07             	movsbl (%edi),%eax
801007b8:	84 c0                	test   %al,%al
801007ba:	0f 84 08 01 00 00    	je     801008c8 <cprintf+0x1c8>
  if(panicked){
801007c0:	8b 15 b8 06 11 80    	mov    0x801106b8,%edx
801007c6:	85 d2                	test   %edx,%edx
801007c8:	0f 84 b2 00 00 00    	je     80100880 <cprintf+0x180>
801007ce:	fa                   	cli    
    for(;;)
801007cf:	eb fe                	jmp    801007cf <cprintf+0xcf>
801007d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
801007d8:	83 fa 78             	cmp    $0x78,%edx
801007db:	75 78                	jne    80100855 <cprintf+0x155>
      printint(*argp++, 16, 0);
801007dd:	8d 47 04             	lea    0x4(%edi),%eax
801007e0:	31 c9                	xor    %ecx,%ecx
801007e2:	ba 10 00 00 00       	mov    $0x10,%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007e7:	83 c3 01             	add    $0x1,%ebx
      printint(*argp++, 16, 0);
801007ea:	89 45 e0             	mov    %eax,-0x20(%ebp)
801007ed:	8b 07                	mov    (%edi),%eax
801007ef:	e8 6c fe ff ff       	call   80100660 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007f4:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      printint(*argp++, 16, 0);
801007f8:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007fb:	85 c0                	test   %eax,%eax
801007fd:	0f 85 2d ff ff ff    	jne    80100730 <cprintf+0x30>
80100803:	eb 81                	jmp    80100786 <cprintf+0x86>
80100805:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
80100808:	8b 0d b8 06 11 80    	mov    0x801106b8,%ecx
8010080e:	85 c9                	test   %ecx,%ecx
80100810:	74 14                	je     80100826 <cprintf+0x126>
80100812:	fa                   	cli    
    for(;;)
80100813:	eb fe                	jmp    80100813 <cprintf+0x113>
80100815:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
80100818:	a1 b8 06 11 80       	mov    0x801106b8,%eax
8010081d:	85 c0                	test   %eax,%eax
8010081f:	75 6c                	jne    8010088d <cprintf+0x18d>
80100821:	b8 25 00 00 00       	mov    $0x25,%eax
80100826:	e8 d5 fb ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010082b:	83 c3 01             	add    $0x1,%ebx
8010082e:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100832:	85 c0                	test   %eax,%eax
80100834:	0f 85 f6 fe ff ff    	jne    80100730 <cprintf+0x30>
8010083a:	e9 47 ff ff ff       	jmp    80100786 <cprintf+0x86>
8010083f:	90                   	nop
    acquire(&cons.lock);
80100840:	83 ec 0c             	sub    $0xc,%esp
80100843:	68 80 06 11 80       	push   $0x80110680
80100848:	e8 53 51 00 00       	call   801059a0 <acquire>
8010084d:	83 c4 10             	add    $0x10,%esp
80100850:	e9 c4 fe ff ff       	jmp    80100719 <cprintf+0x19>
  if(panicked){
80100855:	8b 0d b8 06 11 80    	mov    0x801106b8,%ecx
8010085b:	85 c9                	test   %ecx,%ecx
8010085d:	75 31                	jne    80100890 <cprintf+0x190>
8010085f:	b8 25 00 00 00       	mov    $0x25,%eax
80100864:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100867:	e8 94 fb ff ff       	call   80100400 <consputc.part.0>
8010086c:	8b 15 b8 06 11 80    	mov    0x801106b8,%edx
80100872:	85 d2                	test   %edx,%edx
80100874:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100877:	74 2e                	je     801008a7 <cprintf+0x1a7>
80100879:	fa                   	cli    
    for(;;)
8010087a:	eb fe                	jmp    8010087a <cprintf+0x17a>
8010087c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100880:	e8 7b fb ff ff       	call   80100400 <consputc.part.0>
      for(; *s; s++)
80100885:	83 c7 01             	add    $0x1,%edi
80100888:	e9 28 ff ff ff       	jmp    801007b5 <cprintf+0xb5>
8010088d:	fa                   	cli    
    for(;;)
8010088e:	eb fe                	jmp    8010088e <cprintf+0x18e>
80100890:	fa                   	cli    
80100891:	eb fe                	jmp    80100891 <cprintf+0x191>
80100893:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100897:	90                   	nop
        s = "(null)";
80100898:	bf f8 85 10 80       	mov    $0x801085f8,%edi
      for(; *s; s++)
8010089d:	b8 28 00 00 00       	mov    $0x28,%eax
801008a2:	e9 19 ff ff ff       	jmp    801007c0 <cprintf+0xc0>
801008a7:	89 d0                	mov    %edx,%eax
801008a9:	e8 52 fb ff ff       	call   80100400 <consputc.part.0>
801008ae:	e9 c8 fe ff ff       	jmp    8010077b <cprintf+0x7b>
    release(&cons.lock);
801008b3:	83 ec 0c             	sub    $0xc,%esp
801008b6:	68 80 06 11 80       	push   $0x80110680
801008bb:	e8 80 50 00 00       	call   80105940 <release>
801008c0:	83 c4 10             	add    $0x10,%esp
}
801008c3:	e9 c9 fe ff ff       	jmp    80100791 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
801008c8:	8b 7d e0             	mov    -0x20(%ebp),%edi
801008cb:	e9 ab fe ff ff       	jmp    8010077b <cprintf+0x7b>
    panic("null fmt");
801008d0:	83 ec 0c             	sub    $0xc,%esp
801008d3:	68 ff 85 10 80       	push   $0x801085ff
801008d8:	e8 a3 fa ff ff       	call   80100380 <panic>
801008dd:	8d 76 00             	lea    0x0(%esi),%esi

801008e0 <shift_back>:
void shift_back(int pos){
801008e0:	55                   	push   %ebp
  for(int i = pos-1; i < pos + num_of_left_pressed; i++){
801008e1:	8b 0d c4 06 11 80    	mov    0x801106c4,%ecx
void shift_back(int pos){
801008e7:	89 e5                	mov    %esp,%ebp
801008e9:	53                   	push   %ebx
801008ea:	8b 45 08             	mov    0x8(%ebp),%eax
  for(int i = pos-1; i < pos + num_of_left_pressed; i++){
801008ed:	8d 1c 08             	lea    (%eax,%ecx,1),%ebx
801008f0:	85 c9                	test   %ecx,%ecx
801008f2:	78 1d                	js     80100911 <shift_back+0x31>
801008f4:	8d 50 ff             	lea    -0x1(%eax),%edx
801008f7:	8d 84 00 00 80 0b 80 	lea    -0x7ff48000(%eax,%eax,1),%eax
801008fe:	66 90                	xchg   %ax,%ax
    crt[i] = crt[i + 1];
80100900:	0f b7 08             	movzwl (%eax),%ecx
  for(int i = pos-1; i < pos + num_of_left_pressed; i++){
80100903:	83 c2 01             	add    $0x1,%edx
80100906:	83 c0 02             	add    $0x2,%eax
    crt[i] = crt[i + 1];
80100909:	66 89 48 fc          	mov    %cx,-0x4(%eax)
  for(int i = pos-1; i < pos + num_of_left_pressed; i++){
8010090d:	39 da                	cmp    %ebx,%edx
8010090f:	7c ef                	jl     80100900 <shift_back+0x20>
}
80100911:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100914:	c9                   	leave  
80100915:	c3                   	ret    
80100916:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010091d:	8d 76 00             	lea    0x0(%esi),%esi

80100920 <push_right>:
void push_right(int pos){
80100920:	55                   	push   %ebp
  for(int i = pos + num_of_left_pressed; i > pos; i--){
80100921:	a1 c4 06 11 80       	mov    0x801106c4,%eax
void push_right(int pos){
80100926:	89 e5                	mov    %esp,%ebp
80100928:	8b 55 08             	mov    0x8(%ebp),%edx
  for(int i = pos + num_of_left_pressed; i > pos; i--){
8010092b:	01 d0                	add    %edx,%eax
8010092d:	39 c2                	cmp    %eax,%edx
8010092f:	7d 1d                	jge    8010094e <push_right+0x2e>
80100931:	8d 84 00 fe 7f 0b 80 	lea    -0x7ff48002(%eax,%eax,1),%eax
80100938:	8d 8c 12 fe 7f 0b 80 	lea    -0x7ff48002(%edx,%edx,1),%ecx
8010093f:	90                   	nop
    crt[i] = crt[i-1];
80100940:	0f b7 10             	movzwl (%eax),%edx
  for(int i = pos + num_of_left_pressed; i > pos; i--){
80100943:	83 e8 02             	sub    $0x2,%eax
    crt[i] = crt[i-1];
80100946:	66 89 50 04          	mov    %dx,0x4(%eax)
  for(int i = pos + num_of_left_pressed; i > pos; i--){
8010094a:	39 c8                	cmp    %ecx,%eax
8010094c:	75 f2                	jne    80100940 <push_right+0x20>
}
8010094e:	5d                   	pop    %ebp
8010094f:	c3                   	ret    

80100950 <show_current_history>:
void show_current_history(int temp){
80100950:	55                   	push   %ebp
80100951:	89 e5                	mov    %esp,%ebp
80100953:	57                   	push   %edi
80100954:	56                   	push   %esi
80100955:	53                   	push   %ebx
80100956:	83 ec 0c             	sub    $0xc,%esp
80100959:	8b 5d 08             	mov    0x8(%ebp),%ebx
  for(int i = temp; i > 0; i--){
8010095c:	85 db                	test   %ebx,%ebx
8010095e:	7e 41                	jle    801009a1 <show_current_history+0x51>
80100960:	ba 98 04 11 80       	mov    $0x80110498,%edx
    if(input.buf[i - 1] != '\n'){
80100965:	83 eb 01             	sub    $0x1,%ebx
80100968:	80 bb 40 05 11 80 0a 	cmpb   $0xa,-0x7feefac0(%ebx)
8010096f:	74 1e                	je     8010098f <show_current_history+0x3f>
  if(panicked){
80100971:	8b 0d b8 06 11 80    	mov    0x801106b8,%ecx
80100977:	85 c9                	test   %ecx,%ecx
80100979:	74 05                	je     80100980 <show_current_history+0x30>
8010097b:	fa                   	cli    
    for(;;)
8010097c:	eb fe                	jmp    8010097c <show_current_history+0x2c>
8010097e:	66 90                	xchg   %ax,%ax
80100980:	b8 00 01 00 00       	mov    $0x100,%eax
80100985:	e8 76 fa ff ff       	call   80100400 <consputc.part.0>
8010098a:	ba 98 04 11 80       	mov    $0x80110498,%edx
  input = history_cmnd.current_command;
8010098f:	b9 23 00 00 00       	mov    $0x23,%ecx
80100994:	bf 40 05 11 80       	mov    $0x80110540,%edi
80100999:	89 d6                	mov    %edx,%esi
8010099b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(int i = temp; i > 0; i--){
8010099d:	85 db                	test   %ebx,%ebx
8010099f:	75 c4                	jne    80100965 <show_current_history+0x15>
  for(int j = input.w; j < input.e; j++){
801009a1:	8b 1d c4 05 11 80    	mov    0x801105c4,%ebx
801009a7:	3b 1d c8 05 11 80    	cmp    0x801105c8,%ebx
801009ad:	73 29                	jae    801009d8 <show_current_history+0x88>
  if(panicked){
801009af:	8b 15 b8 06 11 80    	mov    0x801106b8,%edx
        consputc(input.buf[j]);
801009b5:	0f be 83 40 05 11 80 	movsbl -0x7feefac0(%ebx),%eax
  if(panicked){
801009bc:	85 d2                	test   %edx,%edx
801009be:	74 08                	je     801009c8 <show_current_history+0x78>
801009c0:	fa                   	cli    
    for(;;)
801009c1:	eb fe                	jmp    801009c1 <show_current_history+0x71>
801009c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801009c7:	90                   	nop
801009c8:	e8 33 fa ff ff       	call   80100400 <consputc.part.0>
  for(int j = input.w; j < input.e; j++){
801009cd:	83 c3 01             	add    $0x1,%ebx
801009d0:	39 1d c8 05 11 80    	cmp    %ebx,0x801105c8
801009d6:	77 d7                	ja     801009af <show_current_history+0x5f>
}
801009d8:	83 c4 0c             	add    $0xc,%esp
801009db:	5b                   	pop    %ebx
801009dc:	5e                   	pop    %esi
801009dd:	5f                   	pop    %edi
801009de:	5d                   	pop    %ebp
801009df:	c3                   	ret    

801009e0 <is_history>:
int is_history(char* command){
801009e0:	55                   	push   %ebp
    if(command[i] != input.buf[i + input.w]){
801009e1:	8b 15 c4 05 11 80    	mov    0x801105c4,%edx
  for(int i = 0; i < 8; i++){
801009e7:	31 c0                	xor    %eax,%eax
int is_history(char* command){
801009e9:	89 e5                	mov    %esp,%ebp
801009eb:	53                   	push   %ebx
801009ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
801009ef:	90                   	nop
    if(command[i] != input.buf[i + input.w]){
801009f0:	0f b6 9c 02 40 05 11 	movzbl -0x7feefac0(%edx,%eax,1),%ebx
801009f7:	80 
801009f8:	38 1c 01             	cmp    %bl,(%ecx,%eax,1)
801009fb:	75 13                	jne    80100a10 <is_history+0x30>
  for(int i = 0; i < 8; i++){
801009fd:	83 c0 01             	add    $0x1,%eax
80100a00:	83 f8 08             	cmp    $0x8,%eax
80100a03:	75 eb                	jne    801009f0 <is_history+0x10>
}
80100a05:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return 1;
80100a08:	b8 01 00 00 00       	mov    $0x1,%eax
}
80100a0d:	c9                   	leave  
80100a0e:	c3                   	ret    
80100a0f:	90                   	nop
80100a10:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80100a13:	31 c0                	xor    %eax,%eax
}
80100a15:	c9                   	leave  
80100a16:	c3                   	ret    
80100a17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a1e:	66 90                	xchg   %ax,%ax

80100a20 <print_history>:
void print_history(){
80100a20:	55                   	push   %ebp
80100a21:	89 e5                	mov    %esp,%ebp
80100a23:	57                   	push   %edi
80100a24:	56                   	push   %esi
80100a25:	53                   	push   %ebx
80100a26:	83 ec 28             	sub    $0x28,%esp
  release(&cons.lock);
80100a29:	68 80 06 11 80       	push   $0x80110680
80100a2e:	e8 0d 4f 00 00       	call   80105940 <release>
  for(int i = 0; i < history_cmnd.num_of_cmnd; i++){
80100a33:	8b 0d 24 05 11 80    	mov    0x80110524,%ecx
80100a39:	83 c4 10             	add    $0x10,%esp
80100a3c:	85 c9                	test   %ecx,%ecx
80100a3e:	7e 6a                	jle    80100aaa <print_history+0x8a>
80100a40:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100a47:	bb 20 ff 10 80       	mov    $0x8010ff20,%ebx
80100a4c:	ba 40 05 11 80       	mov    $0x80110540,%edx
      input = history_cmnd.hist[i];
80100a51:	b9 23 00 00 00       	mov    $0x23,%ecx
80100a56:	89 d7                	mov    %edx,%edi
80100a58:	89 de                	mov    %ebx,%esi
80100a5a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
      for(int j = history_cmnd.hist[i].w; j < history_cmnd.hist[i].e; j++){
80100a5c:	8b b3 84 00 00 00    	mov    0x84(%ebx),%esi
80100a62:	3b b3 88 00 00 00    	cmp    0x88(%ebx),%esi
80100a68:	73 2b                	jae    80100a95 <print_history+0x75>
  if(panicked){
80100a6a:	8b 15 b8 06 11 80    	mov    0x801106b8,%edx
        consputc(input.buf[j]);
80100a70:	0f be 86 40 05 11 80 	movsbl -0x7feefac0(%esi),%eax
  if(panicked){
80100a77:	85 d2                	test   %edx,%edx
80100a79:	74 05                	je     80100a80 <print_history+0x60>
80100a7b:	fa                   	cli    
    for(;;)
80100a7c:	eb fe                	jmp    80100a7c <print_history+0x5c>
80100a7e:	66 90                	xchg   %ax,%ax
80100a80:	e8 7b f9 ff ff       	call   80100400 <consputc.part.0>
      for(int j = history_cmnd.hist[i].w; j < history_cmnd.hist[i].e; j++){
80100a85:	83 c6 01             	add    $0x1,%esi
80100a88:	39 b3 88 00 00 00    	cmp    %esi,0x88(%ebx)
80100a8e:	ba 40 05 11 80       	mov    $0x80110540,%edx
80100a93:	77 d5                	ja     80100a6a <print_history+0x4a>
  for(int i = 0; i < history_cmnd.num_of_cmnd; i++){
80100a95:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100a99:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
80100a9f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100aa2:	39 05 24 05 11 80    	cmp    %eax,0x80110524
80100aa8:	7f a7                	jg     80100a51 <print_history+0x31>
  acquire(&cons.lock);
80100aaa:	83 ec 0c             	sub    $0xc,%esp
80100aad:	68 80 06 11 80       	push   $0x80110680
80100ab2:	e8 e9 4e 00 00       	call   801059a0 <acquire>
}
80100ab7:	83 c4 10             	add    $0x10,%esp
80100aba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100abd:	5b                   	pop    %ebx
80100abe:	5e                   	pop    %esi
80100abf:	5f                   	pop    %edi
80100ac0:	5d                   	pop    %ebp
80100ac1:	c3                   	ret    
80100ac2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100ac9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ad0 <handle_shifting>:
void handle_shifting(int length, int cursor_pos){
80100ad0:	55                   	push   %ebp
  for (int i = input.e - 1; i >= cursor_pos; i--)
80100ad1:	a1 c8 05 11 80       	mov    0x801105c8,%eax
80100ad6:	83 e8 01             	sub    $0x1,%eax
void handle_shifting(int length, int cursor_pos){
80100ad9:	89 e5                	mov    %esp,%ebp
80100adb:	53                   	push   %ebx
80100adc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100adf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  for (int i = input.e - 1; i >= cursor_pos; i--)
80100ae2:	39 c8                	cmp    %ecx,%eax
80100ae4:	7c 1f                	jl     80100b05 <handle_shifting+0x35>
80100ae6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100aed:	8d 76 00             	lea    0x0(%esi),%esi
    input.buf[i + length] = input.buf[i];
80100af0:	0f b6 90 40 05 11 80 	movzbl -0x7feefac0(%eax),%edx
80100af7:	88 94 03 40 05 11 80 	mov    %dl,-0x7feefac0(%ebx,%eax,1)
  for (int i = input.e - 1; i >= cursor_pos; i--)
80100afe:	83 e8 01             	sub    $0x1,%eax
80100b01:	39 c1                	cmp    %eax,%ecx
80100b03:	7e eb                	jle    80100af0 <handle_shifting+0x20>
}
80100b05:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100b08:	c9                   	leave  
80100b09:	c3                   	ret    
80100b0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100b10 <print_copied_command>:
void print_copied_command(){
80100b10:	55                   	push   %ebp
80100b11:	89 e5                	mov    %esp,%ebp
80100b13:	57                   	push   %edi
80100b14:	56                   	push   %esi
80100b15:	53                   	push   %ebx
80100b16:	83 ec 0c             	sub    $0xc,%esp
  for(int i = 0; i < cur_index; i++){
80100b19:	a1 d4 05 11 80       	mov    0x801105d4,%eax
80100b1e:	85 c0                	test   %eax,%eax
80100b20:	7e 2f                	jle    80100b51 <print_copied_command+0x41>
80100b22:	31 db                	xor    %ebx,%ebx
  if(panicked){
80100b24:	8b 15 b8 06 11 80    	mov    0x801106b8,%edx
    consputc(coppied_input[i]);
80100b2a:	0f be 83 e0 05 11 80 	movsbl -0x7feefa20(%ebx),%eax
  if(panicked){
80100b31:	85 d2                	test   %edx,%edx
80100b33:	74 0b                	je     80100b40 <print_copied_command+0x30>
80100b35:	fa                   	cli    
    for(;;)
80100b36:	eb fe                	jmp    80100b36 <print_copied_command+0x26>
80100b38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b3f:	90                   	nop
80100b40:	e8 bb f8 ff ff       	call   80100400 <consputc.part.0>
  for(int i = 0; i < cur_index; i++){
80100b45:	a1 d4 05 11 80       	mov    0x801105d4,%eax
80100b4a:	83 c3 01             	add    $0x1,%ebx
80100b4d:	39 d8                	cmp    %ebx,%eax
80100b4f:	7f d3                	jg     80100b24 <print_copied_command+0x14>
  if(num_of_left_pressed > 0){
80100b51:	8b 35 c4 06 11 80    	mov    0x801106c4,%esi
    handle_shifting(cur_index, input.e - num_of_left_pressed);
80100b57:	8b 1d c8 05 11 80    	mov    0x801105c8,%ebx
  if(num_of_left_pressed > 0){
80100b5d:	85 f6                	test   %esi,%esi
80100b5f:	7f 3d                	jg     80100b9e <print_copied_command+0x8e>
  for(int i = 0; coppied_input[i] != '\0'; i++){
80100b61:	0f b6 15 e0 05 11 80 	movzbl 0x801105e0,%edx
    input.buf[x - num_of_left_pressed + i] = coppied_input[i];
80100b68:	89 df                	mov    %ebx,%edi
  for(int i = 0; coppied_input[i] != '\0'; i++){
80100b6a:	31 c0                	xor    %eax,%eax
80100b6c:	83 c3 01             	add    $0x1,%ebx
    input.buf[x - num_of_left_pressed + i] = coppied_input[i];
80100b6f:	29 f7                	sub    %esi,%edi
  for(int i = 0; coppied_input[i] != '\0'; i++){
80100b71:	84 d2                	test   %dl,%dl
80100b73:	74 21                	je     80100b96 <print_copied_command+0x86>
80100b75:	8d 76 00             	lea    0x0(%esi),%esi
    input.buf[x - num_of_left_pressed + i] = coppied_input[i];
80100b78:	88 94 07 40 05 11 80 	mov    %dl,-0x7feefac0(%edi,%eax,1)
    input.e++;
80100b7f:	8d 0c 03             	lea    (%ebx,%eax,1),%ecx
  for(int i = 0; coppied_input[i] != '\0'; i++){
80100b82:	83 c0 01             	add    $0x1,%eax
80100b85:	0f b6 90 e0 05 11 80 	movzbl -0x7feefa20(%eax),%edx
80100b8c:	84 d2                	test   %dl,%dl
80100b8e:	75 e8                	jne    80100b78 <print_copied_command+0x68>
80100b90:	89 0d c8 05 11 80    	mov    %ecx,0x801105c8
}
80100b96:	83 c4 0c             	add    $0xc,%esp
80100b99:	5b                   	pop    %ebx
80100b9a:	5e                   	pop    %esi
80100b9b:	5f                   	pop    %edi
80100b9c:	5d                   	pop    %ebp
80100b9d:	c3                   	ret    
    handle_shifting(cur_index, input.e - num_of_left_pressed);
80100b9e:	89 df                	mov    %ebx,%edi
  for (int i = input.e - 1; i >= cursor_pos; i--)
80100ba0:	8d 53 ff             	lea    -0x1(%ebx),%edx
    handle_shifting(cur_index, input.e - num_of_left_pressed);
80100ba3:	29 f7                	sub    %esi,%edi
  for (int i = input.e - 1; i >= cursor_pos; i--)
80100ba5:	39 d7                	cmp    %edx,%edi
80100ba7:	7f b8                	jg     80100b61 <print_copied_command+0x51>
    input.buf[i + length] = input.buf[i];
80100ba9:	0f b6 8a 40 05 11 80 	movzbl -0x7feefac0(%edx),%ecx
80100bb0:	88 8c 10 40 05 11 80 	mov    %cl,-0x7feefac0(%eax,%edx,1)
  for (int i = input.e - 1; i >= cursor_pos; i--)
80100bb7:	83 ea 01             	sub    $0x1,%edx
80100bba:	39 d7                	cmp    %edx,%edi
80100bbc:	7e eb                	jle    80100ba9 <print_copied_command+0x99>
80100bbe:	eb a1                	jmp    80100b61 <print_copied_command+0x51>

80100bc0 <handle_ctrl_s>:
void handle_ctrl_s(){
80100bc0:	55                   	push   %ebp
80100bc1:	89 e5                	mov    %esp,%ebp
80100bc3:	83 ec 0c             	sub    $0xc,%esp
  start_ctrl_s = input.e;
80100bc6:	a1 c8 05 11 80       	mov    0x801105c8,%eax
  memset(coppied_input, '\0', sizeof(coppied_input));
80100bcb:	68 80 00 00 00       	push   $0x80
80100bd0:	6a 00                	push   $0x0
80100bd2:	68 e0 05 11 80       	push   $0x801105e0
  start_ctrl_s = input.e;
80100bd7:	a3 bc 06 11 80       	mov    %eax,0x801106bc
  memset(coppied_input, '\0', sizeof(coppied_input));
80100bdc:	e8 7f 4e 00 00       	call   80105a60 <memset>
}
80100be1:	83 c4 10             	add    $0x10,%esp
80100be4:	c9                   	leave  
80100be5:	c3                   	ret    
80100be6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100bed:	8d 76 00             	lea    0x0(%esi),%esi

80100bf0 <handle_ctrl_f>:
  if(ctrl_s_pressed){
80100bf0:	a1 c0 06 11 80       	mov    0x801106c0,%eax
80100bf5:	85 c0                	test   %eax,%eax
80100bf7:	75 07                	jne    80100c00 <handle_ctrl_f+0x10>
}
80100bf9:	c3                   	ret    
80100bfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    print_copied_command();
80100c00:	e9 0b ff ff ff       	jmp    80100b10 <print_copied_command>
80100c05:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100c10 <update_coppied_commands>:
void update_coppied_commands(){
80100c10:	55                   	push   %ebp
  for(int i = start_ctrl_s; i < input.e; i++){
80100c11:	8b 0d c8 05 11 80    	mov    0x801105c8,%ecx
void update_coppied_commands(){
80100c17:	89 e5                	mov    %esp,%ebp
80100c19:	57                   	push   %edi
80100c1a:	56                   	push   %esi
80100c1b:	53                   	push   %ebx
  for(int i = start_ctrl_s; i < input.e; i++){
80100c1c:	8b 1d bc 06 11 80    	mov    0x801106bc,%ebx
80100c22:	39 d9                	cmp    %ebx,%ecx
80100c24:	76 41                	jbe    80100c67 <update_coppied_commands+0x57>
80100c26:	89 cf                	mov    %ecx,%edi
80100c28:	8b 15 08 ff 10 80    	mov    0x8010ff08,%edx
80100c2e:	31 c0                	xor    %eax,%eax
80100c30:	31 f6                	xor    %esi,%esi
80100c32:	29 df                	sub    %ebx,%edi
80100c34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(copied_command.e < INPUT_BUF){
80100c38:	83 fa 7f             	cmp    $0x7f,%edx
80100c3b:	77 17                	ja     80100c54 <update_coppied_commands+0x44>
      copied_command.buf[copied_command.e + (i - start_ctrl_s)] = input.buf[i];
80100c3d:	0f b6 8c 03 40 05 11 	movzbl -0x7feefac0(%ebx,%eax,1),%ecx
80100c44:	80 
      copied_command.e++;
80100c45:	be 01 00 00 00       	mov    $0x1,%esi
      copied_command.buf[copied_command.e + (i - start_ctrl_s)] = input.buf[i];
80100c4a:	88 8c 10 80 fe 10 80 	mov    %cl,-0x7fef0180(%eax,%edx,1)
      copied_command.e++;
80100c51:	83 c2 01             	add    $0x1,%edx
  for(int i = start_ctrl_s; i < input.e; i++){
80100c54:	83 c0 01             	add    $0x1,%eax
80100c57:	39 f8                	cmp    %edi,%eax
80100c59:	75 dd                	jne    80100c38 <update_coppied_commands+0x28>
80100c5b:	89 f0                	mov    %esi,%eax
80100c5d:	84 c0                	test   %al,%al
80100c5f:	74 06                	je     80100c67 <update_coppied_commands+0x57>
80100c61:	89 15 08 ff 10 80    	mov    %edx,0x8010ff08
}
80100c67:	5b                   	pop    %ebx
80100c68:	5e                   	pop    %esi
80100c69:	5f                   	pop    %edi
80100c6a:	5d                   	pop    %ebp
80100c6b:	c3                   	ret    
80100c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100c70 <convert_char_to_int>:
int convert_char_to_int(char* digits, int size_of_number){
80100c70:	55                   	push   %ebp
80100c71:	89 e5                	mov    %esp,%ebp
80100c73:	57                   	push   %edi
  int result = 0;
80100c74:	31 ff                	xor    %edi,%edi
  for(int i = 0; i < size_of_number; i++){
80100c76:	8b 45 0c             	mov    0xc(%ebp),%eax
int convert_char_to_int(char* digits, int size_of_number){
80100c79:	56                   	push   %esi
80100c7a:	53                   	push   %ebx
  for(int i = 0; i < size_of_number; i++){
80100c7b:	85 c0                	test   %eax,%eax
80100c7d:	7e 41                	jle    80100cc0 <convert_char_to_int+0x50>
80100c7f:	31 f6                	xor    %esi,%esi
80100c81:	b8 01 00 00 00       	mov    $0x1,%eax
80100c86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c8d:	8d 76 00             	lea    0x0(%esi),%esi
    result += ((int)digits[i] - 48) * power_10;
80100c90:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100c93:	0f be 14 33          	movsbl (%ebx,%esi,1),%edx
80100c97:	89 f3                	mov    %esi,%ebx
  for(int i = 0; i < size_of_number; i++){
80100c99:	83 c6 01             	add    $0x1,%esi
    result += ((int)digits[i] - 48) * power_10;
80100c9c:	83 ea 30             	sub    $0x30,%edx
80100c9f:	0f af c2             	imul   %edx,%eax
80100ca2:	01 c7                	add    %eax,%edi
  for(int i = 0; i < size_of_number; i++){
80100ca4:	39 75 0c             	cmp    %esi,0xc(%ebp)
80100ca7:	74 17                	je     80100cc0 <convert_char_to_int+0x50>
    for(int j = 0; j < i; j++){
80100ca9:	31 d2                	xor    %edx,%edx
    int power_10 = 1;
80100cab:	b8 01 00 00 00       	mov    $0x1,%eax
      power_10 *= 10;
80100cb0:	8d 04 80             	lea    (%eax,%eax,4),%eax
80100cb3:	89 d1                	mov    %edx,%ecx
    for(int j = 0; j < i; j++){
80100cb5:	83 c2 01             	add    $0x1,%edx
      power_10 *= 10;
80100cb8:	01 c0                	add    %eax,%eax
    for(int j = 0; j < i; j++){
80100cba:	39 cb                	cmp    %ecx,%ebx
80100cbc:	75 f2                	jne    80100cb0 <convert_char_to_int+0x40>
80100cbe:	eb d0                	jmp    80100c90 <convert_char_to_int+0x20>
}
80100cc0:	5b                   	pop    %ebx
80100cc1:	89 f8                	mov    %edi,%eax
80100cc3:	5e                   	pop    %esi
80100cc4:	5f                   	pop    %edi
80100cc5:	5d                   	pop    %ebp
80100cc6:	c3                   	ret    
80100cc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100cce:	66 90                	xchg   %ax,%ax

80100cd0 <int_to_string>:
int int_to_string(float num, char * string){
80100cd0:	55                   	push   %ebp
  if((int)(num * 10) % 10 != 0){
80100cd1:	ba 67 66 66 66       	mov    $0x66666667,%edx
int int_to_string(float num, char * string){
80100cd6:	89 e5                	mov    %esp,%ebp
80100cd8:	57                   	push   %edi
80100cd9:	56                   	push   %esi
80100cda:	53                   	push   %ebx
80100cdb:	83 ec 08             	sub    $0x8,%esp
80100cde:	d9 45 08             	flds   0x8(%ebp)
80100ce1:	8b 75 0c             	mov    0xc(%ebp),%esi
  int num1 = num;
80100ce4:	d9 7d f2             	fnstcw -0xe(%ebp)
80100ce7:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
80100ceb:	80 cc 0c             	or     $0xc,%ah
80100cee:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
80100cf2:	d9 6d f0             	fldcw  -0x10(%ebp)
80100cf5:	db 55 ec             	fistl  -0x14(%ebp)
80100cf8:	d9 6d f2             	fldcw  -0xe(%ebp)
  if((int)(num * 10) % 10 != 0){
80100cfb:	d8 0d 70 86 10 80    	fmuls  0x80108670
  int num1 = num;
80100d01:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  if((int)(num * 10) % 10 != 0){
80100d04:	d9 6d f0             	fldcw  -0x10(%ebp)
80100d07:	db 5d ec             	fistpl -0x14(%ebp)
80100d0a:	d9 6d f2             	fldcw  -0xe(%ebp)
80100d0d:	8b 7d ec             	mov    -0x14(%ebp),%edi
80100d10:	89 f8                	mov    %edi,%eax
80100d12:	f7 ea                	imul   %edx
80100d14:	89 f8                	mov    %edi,%eax
80100d16:	c1 f8 1f             	sar    $0x1f,%eax
80100d19:	c1 fa 02             	sar    $0x2,%edx
80100d1c:	89 d1                	mov    %edx,%ecx
80100d1e:	29 c1                	sub    %eax,%ecx
80100d20:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
80100d23:	89 f9                	mov    %edi,%ecx
80100d25:	01 c0                	add    %eax,%eax
80100d27:	29 c1                	sub    %eax,%ecx
80100d29:	74 0e                	je     80100d39 <int_to_string+0x69>
    string[i] = '.';
80100d2b:	c6 46 01 2e          	movb   $0x2e,0x1(%esi)
    string[i] = ((int)(num * 10) % 10) + '0';
80100d2f:	83 c1 30             	add    $0x30,%ecx
80100d32:	88 0e                	mov    %cl,(%esi)
    i++;
80100d34:	b9 02 00 00 00       	mov    $0x2,%ecx
  while(num1 > 0){
80100d39:	85 db                	test   %ebx,%ebx
80100d3b:	7e 28                	jle    80100d65 <int_to_string+0x95>
80100d3d:	8d 76 00             	lea    0x0(%esi),%esi
    int temp  = num1 % 10;
80100d40:	b8 cd cc cc cc       	mov    $0xcccccccd,%eax
80100d45:	f7 e3                	mul    %ebx
80100d47:	89 d8                	mov    %ebx,%eax
80100d49:	c1 ea 03             	shr    $0x3,%edx
80100d4c:	8d 3c 92             	lea    (%edx,%edx,4),%edi
80100d4f:	01 ff                	add    %edi,%edi
80100d51:	29 f8                	sub    %edi,%eax
    string[i] = temp + '0';
80100d53:	83 c0 30             	add    $0x30,%eax
80100d56:	88 04 0e             	mov    %al,(%esi,%ecx,1)
    i++;
80100d59:	89 d8                	mov    %ebx,%eax
80100d5b:	83 c1 01             	add    $0x1,%ecx
    num1 /= 10;
80100d5e:	89 d3                	mov    %edx,%ebx
  while(num1 > 0){
80100d60:	83 f8 09             	cmp    $0x9,%eax
80100d63:	7f db                	jg     80100d40 <int_to_string+0x70>
}
80100d65:	83 c4 08             	add    $0x8,%esp
80100d68:	89 c8                	mov    %ecx,%eax
80100d6a:	5b                   	pop    %ebx
80100d6b:	5e                   	pop    %esi
80100d6c:	5f                   	pop    %edi
80100d6d:	5d                   	pop    %ebp
80100d6e:	c3                   	ret    
80100d6f:	90                   	nop

80100d70 <change_cursor_position>:
change_cursor_position(int direction){
80100d70:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100d71:	b8 0e 00 00 00       	mov    $0xe,%eax
80100d76:	89 e5                	mov    %esp,%ebp
80100d78:	57                   	push   %edi
80100d79:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100d7e:	56                   	push   %esi
80100d7f:	89 fa                	mov    %edi,%edx
80100d81:	53                   	push   %ebx
80100d82:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100d85:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100d86:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100d8b:	89 ca                	mov    %ecx,%edx
80100d8d:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100d8e:	0f b6 f0             	movzbl %al,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100d91:	89 fa                	mov    %edi,%edx
80100d93:	b8 0f 00 00 00       	mov    $0xf,%eax
80100d98:	c1 e6 08             	shl    $0x8,%esi
80100d9b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100d9c:	89 ca                	mov    %ecx,%edx
80100d9e:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100d9f:	0f b6 c8             	movzbl %al,%ecx
80100da2:	09 f1                	or     %esi,%ecx
  switch(direction){
80100da4:	85 db                	test   %ebx,%ebx
80100da6:	74 38                	je     80100de0 <change_cursor_position+0x70>
      pos += 1;
80100da8:	31 c0                	xor    %eax,%eax
80100daa:	83 fb 01             	cmp    $0x1,%ebx
80100dad:	0f 94 c0             	sete   %al
80100db0:	01 c1                	add    %eax,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100db2:	be d4 03 00 00       	mov    $0x3d4,%esi
80100db7:	b8 0e 00 00 00       	mov    $0xe,%eax
80100dbc:	89 f2                	mov    %esi,%edx
80100dbe:	ee                   	out    %al,(%dx)
80100dbf:	bb d5 03 00 00       	mov    $0x3d5,%ebx
  outb(CRTPORT+1, pos>>8);
80100dc4:	89 c8                	mov    %ecx,%eax
80100dc6:	c1 f8 08             	sar    $0x8,%eax
80100dc9:	89 da                	mov    %ebx,%edx
80100dcb:	ee                   	out    %al,(%dx)
80100dcc:	b8 0f 00 00 00       	mov    $0xf,%eax
80100dd1:	89 f2                	mov    %esi,%edx
80100dd3:	ee                   	out    %al,(%dx)
80100dd4:	89 c8                	mov    %ecx,%eax
80100dd6:	89 da                	mov    %ebx,%edx
80100dd8:	ee                   	out    %al,(%dx)
}
80100dd9:	5b                   	pop    %ebx
80100dda:	5e                   	pop    %esi
80100ddb:	5f                   	pop    %edi
80100ddc:	5d                   	pop    %ebp
80100ddd:	c3                   	ret    
80100dde:	66 90                	xchg   %ax,%ax
      pos -= 1;
80100de0:	83 e9 01             	sub    $0x1,%ecx
      break;
80100de3:	eb cd                	jmp    80100db2 <change_cursor_position+0x42>
80100de5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100dec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100df0 <show_result>:
void show_result(int offset, char* result){
80100df0:	55                   	push   %ebp
80100df1:	89 e5                	mov    %esp,%ebp
80100df3:	57                   	push   %edi
80100df4:	56                   	push   %esi
80100df5:	53                   	push   %ebx
80100df6:	83 ec 1c             	sub    $0x1c,%esp
  for(int i = input.e - num_of_left_pressed; i <= index_question_mark; i++){
80100df9:	a1 c8 05 11 80       	mov    0x801105c8,%eax
80100dfe:	8b 35 64 06 11 80    	mov    0x80110664,%esi
80100e04:	89 c7                	mov    %eax,%edi
80100e06:	2b 3d c4 06 11 80    	sub    0x801106c4,%edi
80100e0c:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80100e0f:	39 fe                	cmp    %edi,%esi
80100e11:	7c 67                	jl     80100e7a <show_result+0x8a>
80100e13:	83 e8 01             	sub    $0x1,%eax
80100e16:	be d4 03 00 00       	mov    $0x3d4,%esi
80100e1b:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100e1e:	66 90                	xchg   %ax,%ax
80100e20:	b8 0e 00 00 00       	mov    $0xe,%eax
80100e25:	89 f2                	mov    %esi,%edx
80100e27:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100e28:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100e2d:	89 da                	mov    %ebx,%edx
80100e2f:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100e30:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100e33:	89 f2                	mov    %esi,%edx
80100e35:	b8 0f 00 00 00       	mov    $0xf,%eax
80100e3a:	c1 e1 08             	shl    $0x8,%ecx
80100e3d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100e3e:	89 da                	mov    %ebx,%edx
80100e40:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100e41:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100e44:	89 f2                	mov    %esi,%edx
80100e46:	09 c1                	or     %eax,%ecx
80100e48:	b8 0e 00 00 00       	mov    $0xe,%eax
      pos += 1;
80100e4d:	83 c1 01             	add    $0x1,%ecx
80100e50:	ee                   	out    %al,(%dx)
  outb(CRTPORT+1, pos>>8);
80100e51:	89 ca                	mov    %ecx,%edx
80100e53:	c1 fa 08             	sar    $0x8,%edx
80100e56:	89 d0                	mov    %edx,%eax
80100e58:	89 da                	mov    %ebx,%edx
80100e5a:	ee                   	out    %al,(%dx)
80100e5b:	b8 0f 00 00 00       	mov    $0xf,%eax
80100e60:	89 f2                	mov    %esi,%edx
80100e62:	ee                   	out    %al,(%dx)
80100e63:	89 c8                	mov    %ecx,%eax
80100e65:	89 da                	mov    %ebx,%edx
80100e67:	ee                   	out    %al,(%dx)
    num_of_left_pressed--;
80100e68:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100e6b:	29 f8                	sub    %edi,%eax
  for(int i = input.e - num_of_left_pressed; i <= index_question_mark; i++){
80100e6d:	83 c7 01             	add    $0x1,%edi
80100e70:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80100e73:	7d ab                	jge    80100e20 <show_result+0x30>
80100e75:	a3 c4 06 11 80       	mov    %eax,0x801106c4
void show_result(int offset, char* result){
80100e7a:	bb 05 00 00 00       	mov    $0x5,%ebx
  if(panicked){
80100e7f:	8b 0d b8 06 11 80    	mov    0x801106b8,%ecx
80100e85:	85 c9                	test   %ecx,%ecx
80100e87:	74 07                	je     80100e90 <show_result+0xa0>
  asm volatile("cli");
80100e89:	fa                   	cli    
    for(;;)
80100e8a:	eb fe                	jmp    80100e8a <show_result+0x9a>
80100e8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e90:	b8 00 01 00 00       	mov    $0x100,%eax
80100e95:	e8 66 f5 ff ff       	call   80100400 <consputc.part.0>
    input.e--;
80100e9a:	a1 c8 05 11 80       	mov    0x801105c8,%eax
80100e9f:	8d 48 ff             	lea    -0x1(%eax),%ecx
80100ea2:	89 0d c8 05 11 80    	mov    %ecx,0x801105c8
  for(int i = 0; i < 5; i++){
80100ea8:	83 eb 01             	sub    $0x1,%ebx
80100eab:	75 d2                	jne    80100e7f <show_result+0x8f>
    for(int j = index_question_mark + 1; j <= temp_e - 1; j++){
80100ead:	a1 64 06 11 80       	mov    0x80110664,%eax
80100eb2:	bb 05 00 00 00       	mov    $0x5,%ebx
80100eb7:	8d 70 01             	lea    0x1(%eax),%esi
80100eba:	89 f0                	mov    %esi,%eax
80100ebc:	39 f1                	cmp    %esi,%ecx
80100ebe:	7e 14                	jle    80100ed4 <show_result+0xe4>
      input.buf[j - 1] = input.buf[j];
80100ec0:	0f b6 90 40 05 11 80 	movzbl -0x7feefac0(%eax),%edx
    for(int j = index_question_mark + 1; j <= temp_e - 1; j++){
80100ec7:	83 c0 01             	add    $0x1,%eax
      input.buf[j - 1] = input.buf[j];
80100eca:	88 90 3e 05 11 80    	mov    %dl,-0x7feefac2(%eax)
    for(int j = index_question_mark + 1; j <= temp_e - 1; j++){
80100ed0:	39 c1                	cmp    %eax,%ecx
80100ed2:	75 ec                	jne    80100ec0 <show_result+0xd0>
  for(int i = 0; i < 5; i++){
80100ed4:	83 eb 01             	sub    $0x1,%ebx
80100ed7:	75 e1                	jne    80100eba <show_result+0xca>
  for(int j = offset - 1; j >= 0; j--){
80100ed9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100edc:	83 eb 01             	sub    $0x1,%ebx
80100edf:	78 37                	js     80100f18 <show_result+0x128>
    input.buf[input.e] = result[j];
80100ee1:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(panicked){
80100ee4:	8b 15 b8 06 11 80    	mov    0x801106b8,%edx
    input.buf[input.e] = result[j];
80100eea:	0f be 04 18          	movsbl (%eax,%ebx,1),%eax
80100eee:	88 81 40 05 11 80    	mov    %al,-0x7feefac0(%ecx)
  if(panicked){
80100ef4:	85 d2                	test   %edx,%edx
80100ef6:	74 08                	je     80100f00 <show_result+0x110>
80100ef8:	fa                   	cli    
    for(;;)
80100ef9:	eb fe                	jmp    80100ef9 <show_result+0x109>
80100efb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100eff:	90                   	nop
80100f00:	e8 fb f4 ff ff       	call   80100400 <consputc.part.0>
    input.e++;
80100f05:	a1 c8 05 11 80       	mov    0x801105c8,%eax
80100f0a:	8d 48 01             	lea    0x1(%eax),%ecx
80100f0d:	89 0d c8 05 11 80    	mov    %ecx,0x801105c8
  for(int j = offset - 1; j >= 0; j--){
80100f13:	83 eb 01             	sub    $0x1,%ebx
80100f16:	73 c9                	jae    80100ee1 <show_result+0xf1>
}
80100f18:	83 c4 1c             	add    $0x1c,%esp
80100f1b:	5b                   	pop    %ebx
80100f1c:	5e                   	pop    %esi
80100f1d:	5f                   	pop    %edi
80100f1e:	5d                   	pop    %ebp
80100f1f:	c3                   	ret    

80100f20 <do_operation>:
void do_operation(){
80100f20:	55                   	push   %ebp
80100f21:	89 e5                	mov    %esp,%ebp
80100f23:	57                   	push   %edi
80100f24:	56                   	push   %esi
80100f25:	53                   	push   %ebx
80100f26:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  int second_num = second_digit - '0';
80100f2c:	0f be 15 6d 06 11 80 	movsbl 0x8011066d,%edx
  switch (operand)
80100f33:	0f b6 05 6c 06 11 80 	movzbl 0x8011066c,%eax
  int second_num = second_digit - '0';
80100f3a:	83 ea 30             	sub    $0x30,%edx
    result = (float)second_num + (float)first_num;
80100f3d:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)
  int first_num = first_digit - '0';
80100f43:	0f be 15 6e 06 11 80 	movsbl 0x8011066e,%edx
    result = (float)second_num + (float)first_num;
80100f4a:	db 85 60 ff ff ff    	fildl  -0xa0(%ebp)
  int first_num = first_digit - '0';
80100f50:	83 ea 30             	sub    $0x30,%edx
    result = (float)second_num + (float)first_num;
80100f53:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)
80100f59:	db 85 60 ff ff ff    	fildl  -0xa0(%ebp)
  switch (operand)
80100f5f:	3c 2d                	cmp    $0x2d,%al
80100f61:	0f 84 01 01 00 00    	je     80101068 <do_operation+0x148>
80100f67:	3c 2f                	cmp    $0x2f,%al
80100f69:	0f 84 11 01 00 00    	je     80101080 <do_operation+0x160>
80100f6f:	3c 2a                	cmp    $0x2a,%al
80100f71:	0f 84 f9 00 00 00    	je     80101070 <do_operation+0x150>
    result = (float)second_num + (float)first_num;
80100f77:	de c1                	faddp  %st,%st(1)
  memset(result_as_string, '\0', sizeof(result_as_string));
80100f79:	83 ec 04             	sub    $0x4,%esp
80100f7c:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
80100f82:	d9 9d 60 ff ff ff    	fstps  -0xa0(%ebp)
80100f88:	68 80 00 00 00       	push   $0x80
80100f8d:	6a 00                	push   $0x0
80100f8f:	56                   	push   %esi
80100f90:	e8 cb 4a 00 00       	call   80105a60 <memset>
  int num1 = num;
80100f95:	d9 85 60 ff ff ff    	flds   -0xa0(%ebp)
  if((int)(num * 10) % 10 != 0){
80100f9b:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100fa0:	83 c4 10             	add    $0x10,%esp
  int num1 = num;
80100fa3:	d9 bd 66 ff ff ff    	fnstcw -0x9a(%ebp)
80100fa9:	0f b7 85 66 ff ff ff 	movzwl -0x9a(%ebp),%eax
80100fb0:	80 cc 0c             	or     $0xc,%ah
80100fb3:	66 89 85 64 ff ff ff 	mov    %ax,-0x9c(%ebp)
80100fba:	d9 ad 64 ff ff ff    	fldcw  -0x9c(%ebp)
80100fc0:	db 95 60 ff ff ff    	fistl  -0xa0(%ebp)
80100fc6:	d9 ad 66 ff ff ff    	fldcw  -0x9a(%ebp)
  if((int)(num * 10) % 10 != 0){
80100fcc:	d8 0d 70 86 10 80    	fmuls  0x80108670
  int num1 = num;
80100fd2:	8b 9d 60 ff ff ff    	mov    -0xa0(%ebp),%ebx
  if((int)(num * 10) % 10 != 0){
80100fd8:	d9 ad 64 ff ff ff    	fldcw  -0x9c(%ebp)
80100fde:	db 9d 60 ff ff ff    	fistpl -0xa0(%ebp)
80100fe4:	d9 ad 66 ff ff ff    	fldcw  -0x9a(%ebp)
80100fea:	8b bd 60 ff ff ff    	mov    -0xa0(%ebp),%edi
80100ff0:	89 f8                	mov    %edi,%eax
80100ff2:	f7 ea                	imul   %edx
80100ff4:	89 f8                	mov    %edi,%eax
80100ff6:	c1 f8 1f             	sar    $0x1f,%eax
80100ff9:	c1 fa 02             	sar    $0x2,%edx
80100ffc:	89 d1                	mov    %edx,%ecx
80100ffe:	29 c1                	sub    %eax,%ecx
80101000:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
80101003:	89 f9                	mov    %edi,%ecx
80101005:	01 c0                	add    %eax,%eax
80101007:	29 c1                	sub    %eax,%ecx
80101009:	74 15                	je     80101020 <do_operation+0x100>
    string[i] = '.';
8010100b:	c6 85 69 ff ff ff 2e 	movb   $0x2e,-0x97(%ebp)
    string[i] = ((int)(num * 10) % 10) + '0';
80101012:	83 c1 30             	add    $0x30,%ecx
80101015:	88 8d 68 ff ff ff    	mov    %cl,-0x98(%ebp)
    i++;
8010101b:	b9 02 00 00 00       	mov    $0x2,%ecx
  while(num1 > 0){
80101020:	85 db                	test   %ebx,%ebx
80101022:	7e 29                	jle    8010104d <do_operation+0x12d>
80101024:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    int temp  = num1 % 10;
80101028:	b8 cd cc cc cc       	mov    $0xcccccccd,%eax
8010102d:	f7 e3                	mul    %ebx
8010102f:	89 d8                	mov    %ebx,%eax
80101031:	c1 ea 03             	shr    $0x3,%edx
80101034:	8d 3c 92             	lea    (%edx,%edx,4),%edi
80101037:	01 ff                	add    %edi,%edi
80101039:	29 f8                	sub    %edi,%eax
    string[i] = temp + '0';
8010103b:	83 c0 30             	add    $0x30,%eax
8010103e:	88 04 0e             	mov    %al,(%esi,%ecx,1)
    i++;
80101041:	89 d8                	mov    %ebx,%eax
80101043:	83 c1 01             	add    $0x1,%ecx
    num1 /= 10;
80101046:	89 d3                	mov    %edx,%ebx
  while(num1 > 0){
80101048:	83 f8 09             	cmp    $0x9,%eax
8010104b:	7f db                	jg     80101028 <do_operation+0x108>
  show_result(num_res_digits, result_as_string);
8010104d:	83 ec 08             	sub    $0x8,%esp
80101050:	56                   	push   %esi
80101051:	51                   	push   %ecx
80101052:	e8 99 fd ff ff       	call   80100df0 <show_result>
}
80101057:	83 c4 10             	add    $0x10,%esp
8010105a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010105d:	5b                   	pop    %ebx
8010105e:	5e                   	pop    %esi
8010105f:	5f                   	pop    %edi
80101060:	5d                   	pop    %ebp
80101061:	c3                   	ret    
80101062:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    result = (float)second_num - (float)first_num;
80101068:	de e9                	fsubrp %st,%st(1)
    break;
8010106a:	e9 0a ff ff ff       	jmp    80100f79 <do_operation+0x59>
8010106f:	90                   	nop
    result = (float)second_num * (float)first_num;
80101070:	de c9                	fmulp  %st,%st(1)
    break;
80101072:	e9 02 ff ff ff       	jmp    80100f79 <do_operation+0x59>
80101077:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010107e:	66 90                	xchg   %ax,%ax
    result = (float)second_num / (float)first_num;
80101080:	de f9                	fdivrp %st,%st(1)
    break;
80101082:	e9 f2 fe ff ff       	jmp    80100f79 <do_operation+0x59>
80101087:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010108e:	66 90                	xchg   %ax,%ax

80101090 <is_digit>:
int is_digit(char c){
80101090:	55                   	push   %ebp
80101091:	89 e5                	mov    %esp,%ebp
  return c >= '0' && c <= '9';
80101093:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
}
80101097:	5d                   	pop    %ebp
  return c >= '0' && c <= '9';
80101098:	83 e8 30             	sub    $0x30,%eax
8010109b:	3c 09                	cmp    $0x9,%al
8010109d:	0f 96 c0             	setbe  %al
801010a0:	0f b6 c0             	movzbl %al,%eax
}
801010a3:	c3                   	ret    
801010a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801010af:	90                   	nop

801010b0 <is_operand>:
int is_operand(char c){
801010b0:	55                   	push   %ebp
801010b1:	89 e5                	mov    %esp,%ebp
801010b3:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
801010b7:	8d 48 d6             	lea    -0x2a(%eax),%ecx
801010ba:	80 f9 05             	cmp    $0x5,%cl
801010bd:	77 11                	ja     801010d0 <is_operand+0x20>
801010bf:	b8 2b 00 00 00       	mov    $0x2b,%eax
}
801010c4:	5d                   	pop    %ebp
801010c5:	d3 e8                	shr    %cl,%eax
801010c7:	83 e0 01             	and    $0x1,%eax
801010ca:	c3                   	ret    
801010cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801010cf:	90                   	nop
int is_operand(char c){
801010d0:	31 c0                	xor    %eax,%eax
}
801010d2:	5d                   	pop    %ebp
801010d3:	c3                   	ret    
801010d4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801010df:	90                   	nop

801010e0 <is_equal_mark>:
int is_equal_mark(char c){
801010e0:	55                   	push   %ebp
  return c == '=';
801010e1:	31 c0                	xor    %eax,%eax
int is_equal_mark(char c){
801010e3:	89 e5                	mov    %esp,%ebp
  return c == '=';
801010e5:	80 7d 08 3d          	cmpb   $0x3d,0x8(%ebp)
}
801010e9:	5d                   	pop    %ebp
  return c == '=';
801010ea:	0f 94 c0             	sete   %al
}
801010ed:	c3                   	ret    
801010ee:	66 90                	xchg   %ax,%ax

801010f0 <is_question_mark>:
int is_question_mark(char c){
801010f0:	55                   	push   %ebp
  return c == '?';
801010f1:	31 c0                	xor    %eax,%eax
int is_question_mark(char c){
801010f3:	89 e5                	mov    %esp,%ebp
  return c == '?';
801010f5:	80 7d 08 3f          	cmpb   $0x3f,0x8(%ebp)
}
801010f9:	5d                   	pop    %ebp
  return c == '?';
801010fa:	0f 94 c0             	sete   %al
}
801010fd:	c3                   	ret    
801010fe:	66 90                	xchg   %ax,%ax

80101100 <there_is_question_mark>:
  for(int i = input.w; i < input.e; i++){
80101100:	a1 c4 05 11 80       	mov    0x801105c4,%eax
80101105:	8b 15 c8 05 11 80    	mov    0x801105c8,%edx
8010110b:	39 d0                	cmp    %edx,%eax
8010110d:	72 10                	jb     8010111f <there_is_question_mark+0x1f>
8010110f:	eb 1f                	jmp    80101130 <there_is_question_mark+0x30>
80101111:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101118:	83 c0 01             	add    $0x1,%eax
8010111b:	39 d0                	cmp    %edx,%eax
8010111d:	73 11                	jae    80101130 <there_is_question_mark+0x30>
    if(input.buf[i] == '?'){
8010111f:	80 b8 40 05 11 80 3f 	cmpb   $0x3f,-0x7feefac0(%eax)
80101126:	75 f0                	jne    80101118 <there_is_question_mark+0x18>
      return 1;
80101128:	b8 01 00 00 00       	mov    $0x1,%eax
}
8010112d:	c3                   	ret    
8010112e:	66 90                	xchg   %ax,%ax
  return 0;
80101130:	31 c0                	xor    %eax,%eax
80101132:	c3                   	ret    
80101133:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010113a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101140 <find_question_mark_index>:
  for(int i = input.w; i < input.e; i++){
80101140:	a1 c4 05 11 80       	mov    0x801105c4,%eax
80101145:	8b 15 c8 05 11 80    	mov    0x801105c8,%edx
8010114b:	39 d0                	cmp    %edx,%eax
8010114d:	72 10                	jb     8010115f <find_question_mark_index+0x1f>
8010114f:	eb 1f                	jmp    80101170 <find_question_mark_index+0x30>
80101151:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101158:	83 c0 01             	add    $0x1,%eax
8010115b:	39 d0                	cmp    %edx,%eax
8010115d:	73 11                	jae    80101170 <find_question_mark_index+0x30>
    if(input.buf[i] == '?'){
8010115f:	80 b8 40 05 11 80 3f 	cmpb   $0x3f,-0x7feefac0(%eax)
80101166:	75 f0                	jne    80101158 <find_question_mark_index+0x18>
}
80101168:	c3                   	ret    
80101169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
80101170:	31 c0                	xor    %eax,%eax
}
80101172:	c3                   	ret    
80101173:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010117a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101180 <handle_up_and_down_arrow>:
void handle_up_and_down_arrow(enum Direction dir){
80101180:	55                   	push   %ebp
80101181:	89 e5                	mov    %esp,%ebp
80101183:	57                   	push   %edi
80101184:	56                   	push   %esi
80101185:	53                   	push   %ebx
80101186:	83 ec 0c             	sub    $0xc,%esp
  for(int i = input.e; i > input.w; i--){
80101189:	8b 1d c8 05 11 80    	mov    0x801105c8,%ebx
8010118f:	3b 1d c4 05 11 80    	cmp    0x801105c4,%ebx
80101195:	76 2b                	jbe    801011c2 <handle_up_and_down_arrow+0x42>
    if(input.buf[i - 1] != '\n'){
80101197:	83 eb 01             	sub    $0x1,%ebx
8010119a:	80 bb 40 05 11 80 0a 	cmpb   $0xa,-0x7feefac0(%ebx)
801011a1:	74 17                	je     801011ba <handle_up_and_down_arrow+0x3a>
  if(panicked){
801011a3:	8b 35 b8 06 11 80    	mov    0x801106b8,%esi
801011a9:	85 f6                	test   %esi,%esi
801011ab:	74 03                	je     801011b0 <handle_up_and_down_arrow+0x30>
801011ad:	fa                   	cli    
    for(;;)
801011ae:	eb fe                	jmp    801011ae <handle_up_and_down_arrow+0x2e>
801011b0:	b8 00 01 00 00       	mov    $0x100,%eax
801011b5:	e8 46 f2 ff ff       	call   80100400 <consputc.part.0>
  for(int i = input.e; i > input.w; i--){
801011ba:	39 1d c4 05 11 80    	cmp    %ebx,0x801105c4
801011c0:	72 d5                	jb     80101197 <handle_up_and_down_arrow+0x17>
  if(dir == UP){
801011c2:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
801011c6:	74 0c                	je     801011d4 <handle_up_and_down_arrow+0x54>
  if(dir == DOWN){
801011c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  for(int i = input.w; i < input.e; i++){
801011cb:	a1 c8 05 11 80       	mov    0x801105c8,%eax
  if(dir == DOWN){
801011d0:	85 c9                	test   %ecx,%ecx
801011d2:	75 33                	jne    80101207 <handle_up_and_down_arrow+0x87>
    input = history_cmnd.hist[history_cmnd.num_of_cmnd - history_cmnd.num_of_press];
801011d4:	a1 24 05 11 80       	mov    0x80110524,%eax
801011d9:	ba 40 05 11 80       	mov    $0x80110540,%edx
801011de:	b9 23 00 00 00       	mov    $0x23,%ecx
801011e3:	2b 05 2c 05 11 80    	sub    0x8011052c,%eax
801011e9:	69 c0 8c 00 00 00    	imul   $0x8c,%eax,%eax
801011ef:	89 d7                	mov    %edx,%edi
801011f1:	05 20 ff 10 80       	add    $0x8010ff20,%eax
801011f6:	89 c6                	mov    %eax,%esi
801011f8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    input.e--;
801011fa:	a1 c8 05 11 80       	mov    0x801105c8,%eax
801011ff:	83 e8 01             	sub    $0x1,%eax
80101202:	a3 c8 05 11 80       	mov    %eax,0x801105c8
  for(int i = input.w; i < input.e; i++){
80101207:	8b 1d c4 05 11 80    	mov    0x801105c4,%ebx
8010120d:	39 c3                	cmp    %eax,%ebx
8010120f:	73 27                	jae    80101238 <handle_up_and_down_arrow+0xb8>
  if(panicked){
80101211:	8b 15 b8 06 11 80    	mov    0x801106b8,%edx
    consputc(input.buf[i]);
80101217:	0f be 83 40 05 11 80 	movsbl -0x7feefac0(%ebx),%eax
  if(panicked){
8010121e:	85 d2                	test   %edx,%edx
80101220:	74 06                	je     80101228 <handle_up_and_down_arrow+0xa8>
80101222:	fa                   	cli    
    for(;;)
80101223:	eb fe                	jmp    80101223 <handle_up_and_down_arrow+0xa3>
80101225:	8d 76 00             	lea    0x0(%esi),%esi
80101228:	e8 d3 f1 ff ff       	call   80100400 <consputc.part.0>
  for(int i = input.w; i < input.e; i++){
8010122d:	83 c3 01             	add    $0x1,%ebx
80101230:	39 1d c8 05 11 80    	cmp    %ebx,0x801105c8
80101236:	77 d9                	ja     80101211 <handle_up_and_down_arrow+0x91>
}
80101238:	83 c4 0c             	add    $0xc,%esp
8010123b:	5b                   	pop    %ebx
8010123c:	5e                   	pop    %esi
8010123d:	5f                   	pop    %edi
8010123e:	5d                   	pop    %ebp
8010123f:	c3                   	ret    

80101240 <check_states_question_mark>:
void check_states_question_mark(char c){
80101240:	55                   	push   %ebp
80101241:	89 e5                	mov    %esp,%ebp
80101243:	83 ec 08             	sub    $0x8,%esp
  switch (state_of_question_mark)
80101246:	a1 68 06 11 80       	mov    0x80110668,%eax
void check_states_question_mark(char c){
8010124b:	8b 55 08             	mov    0x8(%ebp),%edx
  switch (state_of_question_mark)
8010124e:	83 f8 02             	cmp    $0x2,%eax
80101251:	74 65                	je     801012b8 <check_states_question_mark+0x78>
80101253:	7f 2b                	jg     80101280 <check_states_question_mark+0x40>
80101255:	85 c0                	test   %eax,%eax
80101257:	74 47                	je     801012a0 <check_states_question_mark+0x60>
80101259:	83 f8 01             	cmp    $0x1,%eax
8010125c:	75 2e                	jne    8010128c <check_states_question_mark+0x4c>
  return c >= '0' && c <= '9';
8010125e:	8d 42 d0             	lea    -0x30(%edx),%eax
    if(is_digit(c)){
80101261:	3c 09                	cmp    $0x9,%al
80101263:	77 27                	ja     8010128c <check_states_question_mark+0x4c>
      first_digit = c;
80101265:	88 15 6e 06 11 80    	mov    %dl,0x8011066e
      state_of_question_mark = 2;
8010126b:	c7 05 68 06 11 80 02 	movl   $0x2,0x80110668
80101272:	00 00 00 
}
80101275:	c9                   	leave  
80101276:	c3                   	ret    
80101277:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010127e:	66 90                	xchg   %ax,%ax
  switch (state_of_question_mark)
80101280:	83 f8 03             	cmp    $0x3,%eax
80101283:	75 07                	jne    8010128c <check_states_question_mark+0x4c>
  return c >= '0' && c <= '9';
80101285:	8d 42 d0             	lea    -0x30(%edx),%eax
    if(is_digit(c)){
80101288:	3c 09                	cmp    $0x9,%al
8010128a:	76 54                	jbe    801012e0 <check_states_question_mark+0xa0>
      state_of_question_mark = 0;
8010128c:	c7 05 68 06 11 80 00 	movl   $0x0,0x80110668
80101293:	00 00 00 
}
80101296:	c9                   	leave  
80101297:	c3                   	ret    
80101298:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010129f:	90                   	nop
    if(!is_equal_mark(c)){
801012a0:	80 fa 3d             	cmp    $0x3d,%dl
801012a3:	75 d0                	jne    80101275 <check_states_question_mark+0x35>
      state_of_question_mark = 1;
801012a5:	c7 05 68 06 11 80 01 	movl   $0x1,0x80110668
801012ac:	00 00 00 
}
801012af:	c9                   	leave  
801012b0:	c3                   	ret    
801012b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(is_operand(c)){
801012b8:	8d 42 d6             	lea    -0x2a(%edx),%eax
801012bb:	3c 05                	cmp    $0x5,%al
801012bd:	77 cd                	ja     8010128c <check_states_question_mark+0x4c>
801012bf:	b9 2b 00 00 00       	mov    $0x2b,%ecx
801012c4:	0f a3 c1             	bt     %eax,%ecx
801012c7:	73 c3                	jae    8010128c <check_states_question_mark+0x4c>
      state_of_question_mark = 3;
801012c9:	c7 05 68 06 11 80 03 	movl   $0x3,0x80110668
801012d0:	00 00 00 
      operand = c;
801012d3:	88 15 6c 06 11 80    	mov    %dl,0x8011066c
}
801012d9:	c9                   	leave  
801012da:	c3                   	ret    
801012db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801012df:	90                   	nop
      second_digit = c;
801012e0:	88 15 6d 06 11 80    	mov    %dl,0x8011066d
      do_operation();
801012e6:	e8 35 fc ff ff       	call   80100f20 <do_operation>
801012eb:	eb 9f                	jmp    8010128c <check_states_question_mark+0x4c>
801012ed:	8d 76 00             	lea    0x0(%esi),%esi

801012f0 <search_for_NON>:
void search_for_NON(int qm_index){
801012f0:	55                   	push   %ebp
801012f1:	89 e5                	mov    %esp,%ebp
801012f3:	56                   	push   %esi
801012f4:	8b 75 08             	mov    0x8(%ebp),%esi
801012f7:	53                   	push   %ebx
  index_question_mark = qm_index;
801012f8:	bb 04 00 00 00       	mov    $0x4,%ebx
801012fd:	89 35 64 06 11 80    	mov    %esi,0x80110664
    check_states_question_mark(input.buf[qm_index - i]);
80101303:	0f be 84 1e 3b 05 11 	movsbl -0x7feefac5(%esi,%ebx,1),%eax
8010130a:	80 
8010130b:	83 ec 0c             	sub    $0xc,%esp
8010130e:	50                   	push   %eax
8010130f:	e8 2c ff ff ff       	call   80101240 <check_states_question_mark>
  for(int i = 1;i <= 4; i++){
80101314:	83 c4 10             	add    $0x10,%esp
80101317:	83 eb 01             	sub    $0x1,%ebx
8010131a:	75 e7                	jne    80101303 <search_for_NON+0x13>
}
8010131c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010131f:	5b                   	pop    %ebx
80101320:	5e                   	pop    %esi
80101321:	5d                   	pop    %ebp
80101322:	c3                   	ret    
80101323:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010132a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101330 <update_history_memory>:
  if((input.e - input.w) > 1){
80101330:	a1 c8 05 11 80       	mov    0x801105c8,%eax
80101335:	2b 05 c4 05 11 80    	sub    0x801105c4,%eax
8010133b:	83 f8 01             	cmp    $0x1,%eax
8010133e:	76 78                	jbe    801013b8 <update_history_memory+0x88>
void update_history_memory(){
80101340:	55                   	push   %ebp
80101341:	ba 40 05 11 80       	mov    $0x80110540,%edx
80101346:	89 e5                	mov    %esp,%ebp
80101348:	57                   	push   %edi
80101349:	56                   	push   %esi
8010134a:	53                   	push   %ebx
    if(history_cmnd.num_of_cmnd < 10){
8010134b:	8b 1d 24 05 11 80    	mov    0x80110524,%ebx
80101351:	83 fb 09             	cmp    $0x9,%ebx
80101354:	7e 3a                	jle    80101390 <update_history_memory+0x60>
80101356:	b8 20 ff 10 80       	mov    $0x8010ff20,%eax
8010135b:	bb 0c 04 11 80       	mov    $0x8011040c,%ebx
          history_cmnd.hist[i] = history_cmnd.hist[i + 1];
80101360:	8d b0 8c 00 00 00    	lea    0x8c(%eax),%esi
80101366:	89 c7                	mov    %eax,%edi
      for(int i = 0; i < 9; i++){
80101368:	05 8c 00 00 00       	add    $0x8c,%eax
          history_cmnd.hist[i] = history_cmnd.hist[i + 1];
8010136d:	b9 23 00 00 00       	mov    $0x23,%ecx
80101372:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
      for(int i = 0; i < 9; i++){
80101374:	3d 0c 04 11 80       	cmp    $0x8011040c,%eax
80101379:	75 e5                	jne    80101360 <update_history_memory+0x30>
      history_cmnd.hist[NUM_OF_HISTORY_COMMAND - 1] = input;
8010137b:	89 df                	mov    %ebx,%edi
8010137d:	b9 23 00 00 00       	mov    $0x23,%ecx
80101382:	89 d6                	mov    %edx,%esi
80101384:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
} 
80101386:	5b                   	pop    %ebx
80101387:	5e                   	pop    %esi
80101388:	5f                   	pop    %edi
80101389:	5d                   	pop    %ebp
8010138a:	c3                   	ret    
8010138b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010138f:	90                   	nop
      history_cmnd.hist[history_cmnd.num_of_cmnd] = input;
80101390:	69 c3 8c 00 00 00    	imul   $0x8c,%ebx,%eax
80101396:	b9 23 00 00 00       	mov    $0x23,%ecx
8010139b:	89 d6                	mov    %edx,%esi
      history_cmnd.num_of_cmnd++;
8010139d:	83 c3 01             	add    $0x1,%ebx
801013a0:	89 1d 24 05 11 80    	mov    %ebx,0x80110524
      history_cmnd.hist[history_cmnd.num_of_cmnd] = input;
801013a6:	05 20 ff 10 80       	add    $0x8010ff20,%eax
801013ab:	89 c7                	mov    %eax,%edi
801013ad:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
} 
801013af:	5b                   	pop    %ebx
801013b0:	5e                   	pop    %esi
801013b1:	5f                   	pop    %edi
801013b2:	5d                   	pop    %ebp
801013b3:	c3                   	ret    
801013b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013b8:	c3                   	ret    
801013b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801013c0 <handle_deletion>:
void handle_deletion(){
801013c0:	55                   	push   %ebp
801013c1:	89 e5                	mov    %esp,%ebp
801013c3:	56                   	push   %esi
  for(int i = input.e - num_of_left_pressed - 1; i < input.e; i++){
801013c4:	8b 35 c8 05 11 80    	mov    0x801105c8,%esi
void handle_deletion(){
801013ca:	53                   	push   %ebx
  for(int i = input.e - num_of_left_pressed - 1; i < input.e; i++){
801013cb:	8d 56 ff             	lea    -0x1(%esi),%edx
801013ce:	2b 15 c4 06 11 80    	sub    0x801106c4,%edx
801013d4:	39 d6                	cmp    %edx,%esi
801013d6:	76 3d                	jbe    80101415 <handle_deletion+0x55>
801013d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801013df:	90                   	nop
    input.buf[i % INPUT_BUF] = input.buf[(i + 1) % INPUT_BUF];
801013e0:	89 d0                	mov    %edx,%eax
801013e2:	83 c2 01             	add    $0x1,%edx
801013e5:	89 d3                	mov    %edx,%ebx
801013e7:	c1 fb 1f             	sar    $0x1f,%ebx
801013ea:	c1 eb 19             	shr    $0x19,%ebx
801013ed:	8d 0c 1a             	lea    (%edx,%ebx,1),%ecx
801013f0:	83 e1 7f             	and    $0x7f,%ecx
801013f3:	29 d9                	sub    %ebx,%ecx
801013f5:	0f b6 99 40 05 11 80 	movzbl -0x7feefac0(%ecx),%ebx
801013fc:	89 c1                	mov    %eax,%ecx
801013fe:	c1 f9 1f             	sar    $0x1f,%ecx
80101401:	c1 e9 19             	shr    $0x19,%ecx
80101404:	01 c8                	add    %ecx,%eax
80101406:	83 e0 7f             	and    $0x7f,%eax
80101409:	29 c8                	sub    %ecx,%eax
8010140b:	88 98 40 05 11 80    	mov    %bl,-0x7feefac0(%eax)
  for(int i = input.e - num_of_left_pressed - 1; i < input.e; i++){
80101411:	39 f2                	cmp    %esi,%edx
80101413:	75 cb                	jne    801013e0 <handle_deletion+0x20>
}
80101415:	5b                   	pop    %ebx
80101416:	5e                   	pop    %esi
80101417:	5d                   	pop    %ebp
80101418:	c3                   	ret    
80101419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101420 <handle_copy_delete>:
void handle_copy_delete(){
80101420:	55                   	push   %ebp
80101421:	89 e5                	mov    %esp,%ebp
80101423:	56                   	push   %esi
  for(int i = cur_index - num_of_left_copy - 1; i < cur_index; i++){
80101424:	8b 35 d4 05 11 80    	mov    0x801105d4,%esi
void handle_copy_delete(){
8010142a:	53                   	push   %ebx
  for(int i = cur_index - num_of_left_copy - 1; i < cur_index; i++){
8010142b:	89 f2                	mov    %esi,%edx
8010142d:	2b 15 d0 05 11 80    	sub    0x801105d0,%edx
80101433:	83 ea 01             	sub    $0x1,%edx
80101436:	39 d6                	cmp    %edx,%esi
80101438:	7e 3b                	jle    80101475 <handle_copy_delete+0x55>
8010143a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    coppied_input[i % INPUT_BUF] = coppied_input[(i + 1) % INPUT_BUF];
80101440:	89 d0                	mov    %edx,%eax
80101442:	83 c2 01             	add    $0x1,%edx
80101445:	89 d3                	mov    %edx,%ebx
80101447:	c1 fb 1f             	sar    $0x1f,%ebx
8010144a:	c1 eb 19             	shr    $0x19,%ebx
8010144d:	8d 0c 1a             	lea    (%edx,%ebx,1),%ecx
80101450:	83 e1 7f             	and    $0x7f,%ecx
80101453:	29 d9                	sub    %ebx,%ecx
80101455:	0f b6 99 e0 05 11 80 	movzbl -0x7feefa20(%ecx),%ebx
8010145c:	89 c1                	mov    %eax,%ecx
8010145e:	c1 f9 1f             	sar    $0x1f,%ecx
80101461:	c1 e9 19             	shr    $0x19,%ecx
80101464:	01 c8                	add    %ecx,%eax
80101466:	83 e0 7f             	and    $0x7f,%eax
80101469:	29 c8                	sub    %ecx,%eax
8010146b:	88 98 e0 05 11 80    	mov    %bl,-0x7feefa20(%eax)
  for(int i = cur_index - num_of_left_copy - 1; i < cur_index; i++){
80101471:	39 d6                	cmp    %edx,%esi
80101473:	75 cb                	jne    80101440 <handle_copy_delete+0x20>
}
80101475:	5b                   	pop    %ebx
80101476:	5e                   	pop    %esi
80101477:	5d                   	pop    %ebp
80101478:	c3                   	ret    
80101479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101480 <handle_writing>:
void handle_writing(){
80101480:	55                   	push   %ebp
  int init = input.e - 1;
80101481:	a1 c8 05 11 80       	mov    0x801105c8,%eax
80101486:	8d 50 ff             	lea    -0x1(%eax),%edx
void handle_writing(){
80101489:	89 e5                	mov    %esp,%ebp
8010148b:	56                   	push   %esi
  int limit = input.e - num_of_left_pressed - 1;
8010148c:	89 d6                	mov    %edx,%esi
8010148e:	2b 35 c4 06 11 80    	sub    0x801106c4,%esi
void handle_writing(){
80101494:	53                   	push   %ebx
  for(int i = init; i > limit; i--){
80101495:	39 f2                	cmp    %esi,%edx
80101497:	7e 3d                	jle    801014d6 <handle_writing+0x56>
80101499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    input.buf[(i + 1) % INPUT_BUF] = input.buf[i % INPUT_BUF];
801014a0:	89 d1                	mov    %edx,%ecx
801014a2:	c1 f9 1f             	sar    $0x1f,%ecx
801014a5:	c1 e9 19             	shr    $0x19,%ecx
801014a8:	8d 04 0a             	lea    (%edx,%ecx,1),%eax
801014ab:	83 e0 7f             	and    $0x7f,%eax
801014ae:	29 c8                	sub    %ecx,%eax
801014b0:	0f b6 98 40 05 11 80 	movzbl -0x7feefac0(%eax),%ebx
801014b7:	8d 42 01             	lea    0x1(%edx),%eax
  for(int i = init; i > limit; i--){
801014ba:	83 ea 01             	sub    $0x1,%edx
    input.buf[(i + 1) % INPUT_BUF] = input.buf[i % INPUT_BUF];
801014bd:	89 c1                	mov    %eax,%ecx
801014bf:	c1 f9 1f             	sar    $0x1f,%ecx
801014c2:	c1 e9 19             	shr    $0x19,%ecx
801014c5:	01 c8                	add    %ecx,%eax
801014c7:	83 e0 7f             	and    $0x7f,%eax
801014ca:	29 c8                	sub    %ecx,%eax
801014cc:	88 98 40 05 11 80    	mov    %bl,-0x7feefac0(%eax)
  for(int i = init; i > limit; i--){
801014d2:	39 d6                	cmp    %edx,%esi
801014d4:	7c ca                	jl     801014a0 <handle_writing+0x20>
}
801014d6:	5b                   	pop    %ebx
801014d7:	5e                   	pop    %esi
801014d8:	5d                   	pop    %ebp
801014d9:	c3                   	ret    
801014da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801014e0 <handle_copying>:
void handle_copying(){
801014e0:	55                   	push   %ebp
  int init = cur_index - 1;
801014e1:	a1 d4 05 11 80       	mov    0x801105d4,%eax
801014e6:	8d 50 ff             	lea    -0x1(%eax),%edx
void handle_copying(){
801014e9:	89 e5                	mov    %esp,%ebp
801014eb:	56                   	push   %esi
  int limit = cur_index - 1 - num_of_left_copy;
801014ec:	89 d6                	mov    %edx,%esi
801014ee:	2b 35 d0 05 11 80    	sub    0x801105d0,%esi
void handle_copying(){
801014f4:	53                   	push   %ebx
  for(int i = init; i > limit; i--){
801014f5:	39 f2                	cmp    %esi,%edx
801014f7:	7e 3d                	jle    80101536 <handle_copying+0x56>
801014f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    coppied_input[(i + 1) % INPUT_BUF] = coppied_input[i % INPUT_BUF];
80101500:	89 d1                	mov    %edx,%ecx
80101502:	c1 f9 1f             	sar    $0x1f,%ecx
80101505:	c1 e9 19             	shr    $0x19,%ecx
80101508:	8d 04 0a             	lea    (%edx,%ecx,1),%eax
8010150b:	83 e0 7f             	and    $0x7f,%eax
8010150e:	29 c8                	sub    %ecx,%eax
80101510:	0f b6 98 e0 05 11 80 	movzbl -0x7feefa20(%eax),%ebx
80101517:	8d 42 01             	lea    0x1(%edx),%eax
  for(int i = init; i > limit; i--){
8010151a:	83 ea 01             	sub    $0x1,%edx
    coppied_input[(i + 1) % INPUT_BUF] = coppied_input[i % INPUT_BUF];
8010151d:	89 c1                	mov    %eax,%ecx
8010151f:	c1 f9 1f             	sar    $0x1f,%ecx
80101522:	c1 e9 19             	shr    $0x19,%ecx
80101525:	01 c8                	add    %ecx,%eax
80101527:	83 e0 7f             	and    $0x7f,%eax
8010152a:	29 c8                	sub    %ecx,%eax
8010152c:	88 98 e0 05 11 80    	mov    %bl,-0x7feefa20(%eax)
  for(int i = init; i > limit; i--){
80101532:	39 d6                	cmp    %edx,%esi
80101534:	75 ca                	jne    80101500 <handle_copying+0x20>
}
80101536:	5b                   	pop    %ebx
80101537:	5e                   	pop    %esi
80101538:	5d                   	pop    %ebp
80101539:	c3                   	ret    
8010153a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101540 <consoleintr>:
{
80101540:	55                   	push   %ebp
80101541:	89 e5                	mov    %esp,%ebp
80101543:	57                   	push   %edi
80101544:	56                   	push   %esi
80101545:	53                   	push   %ebx
80101546:	83 ec 38             	sub    $0x38,%esp
80101549:	8b 45 08             	mov    0x8(%ebp),%eax
  acquire(&cons.lock);
8010154c:	68 80 06 11 80       	push   $0x80110680
{
80101551:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  acquire(&cons.lock);
80101554:	e8 47 44 00 00       	call   801059a0 <acquire>
  int c, doprocdump = 0;
80101559:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  while((c = getc()) >= 0){
80101560:	83 c4 10             	add    $0x10,%esp
80101563:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101566:	ff d0                	call   *%eax
80101568:	89 c3                	mov    %eax,%ebx
8010156a:	85 c0                	test   %eax,%eax
8010156c:	0f 88 ae 00 00 00    	js     80101620 <consoleintr+0xe0>
    switch(c){
80101572:	83 fb 7f             	cmp    $0x7f,%ebx
80101575:	0f 84 ad 01 00 00    	je     80101728 <consoleintr+0x1e8>
8010157b:	7f 53                	jg     801015d0 <consoleintr+0x90>
8010157d:	8d 43 fa             	lea    -0x6(%ebx),%eax
80101580:	83 f8 0f             	cmp    $0xf,%eax
80101583:	0f 87 77 06 00 00    	ja     80101c00 <consoleintr+0x6c0>
80101589:	ff 24 85 1c 86 10 80 	jmp    *-0x7fef79e4(,%eax,4)
80101590:	b8 00 01 00 00       	mov    $0x100,%eax
80101595:	e8 66 ee ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
8010159a:	a1 c8 05 11 80       	mov    0x801105c8,%eax
8010159f:	3b 05 c4 05 11 80    	cmp    0x801105c4,%eax
801015a5:	74 bc                	je     80101563 <consoleintr+0x23>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801015a7:	83 e8 01             	sub    $0x1,%eax
801015aa:	89 c2                	mov    %eax,%edx
801015ac:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
801015af:	80 ba 40 05 11 80 0a 	cmpb   $0xa,-0x7feefac0(%edx)
801015b6:	74 ab                	je     80101563 <consoleintr+0x23>
  if(panicked){
801015b8:	8b 0d b8 06 11 80    	mov    0x801106b8,%ecx
        input.e--;
801015be:	a3 c8 05 11 80       	mov    %eax,0x801105c8
  if(panicked){
801015c3:	85 c9                	test   %ecx,%ecx
801015c5:	74 c9                	je     80101590 <consoleintr+0x50>
801015c7:	fa                   	cli    
    for(;;)
801015c8:	eb fe                	jmp    801015c8 <consoleintr+0x88>
801015ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    switch(c){
801015d0:	81 fb e4 00 00 00    	cmp    $0xe4,%ebx
801015d6:	0f 84 84 02 00 00    	je     80101860 <consoleintr+0x320>
801015dc:	7e 6a                	jle    80101648 <consoleintr+0x108>
801015de:	81 fb e5 00 00 00    	cmp    $0xe5,%ebx
801015e4:	0f 85 f6 03 00 00    	jne    801019e0 <consoleintr+0x4a0>
      if(num_of_left_pressed > 0){
801015ea:	8b 1d c4 06 11 80    	mov    0x801106c4,%ebx
801015f0:	85 db                	test   %ebx,%ebx
801015f2:	0f 8f d8 04 00 00    	jg     80101ad0 <consoleintr+0x590>
      if(num_of_left_copy > 0)
801015f8:	a1 d0 05 11 80       	mov    0x801105d0,%eax
801015fd:	85 c0                	test   %eax,%eax
801015ff:	0f 8e 5e ff ff ff    	jle    80101563 <consoleintr+0x23>
        num_of_left_copy--;
80101605:	83 e8 01             	sub    $0x1,%eax
80101608:	a3 d0 05 11 80       	mov    %eax,0x801105d0
  while((c = getc()) >= 0){
8010160d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101610:	ff d0                	call   *%eax
80101612:	89 c3                	mov    %eax,%ebx
80101614:	85 c0                	test   %eax,%eax
80101616:	0f 89 56 ff ff ff    	jns    80101572 <consoleintr+0x32>
8010161c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80101620:	83 ec 0c             	sub    $0xc,%esp
80101623:	68 80 06 11 80       	push   $0x80110680
80101628:	e8 13 43 00 00       	call   80105940 <release>
  if(doprocdump) {
8010162d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101630:	83 c4 10             	add    $0x10,%esp
80101633:	85 c0                	test   %eax,%eax
80101635:	0f 85 f2 04 00 00    	jne    80101b2d <consoleintr+0x5ed>
}
8010163b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010163e:	5b                   	pop    %ebx
8010163f:	5e                   	pop    %esi
80101640:	5f                   	pop    %edi
80101641:	5d                   	pop    %ebp
80101642:	c3                   	ret    
80101643:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101647:	90                   	nop
    switch(c){
80101648:	81 fb e2 00 00 00    	cmp    $0xe2,%ebx
8010164e:	0f 84 bc 02 00 00    	je     80101910 <consoleintr+0x3d0>
80101654:	81 fb e3 00 00 00    	cmp    $0xe3,%ebx
8010165a:	0f 85 80 03 00 00    	jne    801019e0 <consoleintr+0x4a0>
      for(int i = 0; i < num_of_left_pressed; i++)
80101660:	a1 c4 06 11 80       	mov    0x801106c4,%eax
80101665:	31 ff                	xor    %edi,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101667:	be d4 03 00 00       	mov    $0x3d4,%esi
8010166c:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010166f:	85 c0                	test   %eax,%eax
80101671:	7e 55                	jle    801016c8 <consoleintr+0x188>
80101673:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101677:	90                   	nop
80101678:	b8 0e 00 00 00       	mov    $0xe,%eax
8010167d:	89 f2                	mov    %esi,%edx
8010167f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101680:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80101685:	89 da                	mov    %ebx,%edx
80101687:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80101688:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010168b:	89 f2                	mov    %esi,%edx
8010168d:	b8 0f 00 00 00       	mov    $0xf,%eax
80101692:	c1 e1 08             	shl    $0x8,%ecx
80101695:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101696:	89 da                	mov    %ebx,%edx
80101698:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80101699:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010169c:	89 f2                	mov    %esi,%edx
8010169e:	09 c1                	or     %eax,%ecx
801016a0:	b8 0e 00 00 00       	mov    $0xe,%eax
      pos += 1;
801016a5:	83 c1 01             	add    $0x1,%ecx
801016a8:	ee                   	out    %al,(%dx)
  outb(CRTPORT+1, pos>>8);
801016a9:	89 ca                	mov    %ecx,%edx
801016ab:	c1 fa 08             	sar    $0x8,%edx
801016ae:	89 d0                	mov    %edx,%eax
801016b0:	89 da                	mov    %ebx,%edx
801016b2:	ee                   	out    %al,(%dx)
801016b3:	b8 0f 00 00 00       	mov    $0xf,%eax
801016b8:	89 f2                	mov    %esi,%edx
801016ba:	ee                   	out    %al,(%dx)
801016bb:	89 c8                	mov    %ecx,%eax
801016bd:	89 da                	mov    %ebx,%edx
801016bf:	ee                   	out    %al,(%dx)
      for(int i = 0; i < num_of_left_pressed; i++)
801016c0:	83 c7 01             	add    $0x1,%edi
801016c3:	3b 7d e0             	cmp    -0x20(%ebp),%edi
801016c6:	75 b0                	jne    80101678 <consoleintr+0x138>
      if(history_cmnd.num_of_cmnd != 0 && history_cmnd.num_of_press > 1){
801016c8:	8b 1d 24 05 11 80    	mov    0x80110524,%ebx
801016ce:	a1 2c 05 11 80       	mov    0x8011052c,%eax
      num_of_left_pressed = 0;
801016d3:	c7 05 c4 06 11 80 00 	movl   $0x0,0x801106c4
801016da:	00 00 00 
      if(history_cmnd.num_of_cmnd != 0 && history_cmnd.num_of_press > 1){
801016dd:	85 db                	test   %ebx,%ebx
801016df:	74 09                	je     801016ea <consoleintr+0x1aa>
801016e1:	83 f8 01             	cmp    $0x1,%eax
801016e4:	0f 8f 66 04 00 00    	jg     80101b50 <consoleintr+0x610>
      else if(history_cmnd.num_of_press == 1){
801016ea:	83 f8 01             	cmp    $0x1,%eax
801016ed:	0f 85 70 fe ff ff    	jne    80101563 <consoleintr+0x23>
        show_current_history(temp);
801016f3:	83 ec 0c             	sub    $0xc,%esp
        int temp = input.e - input.w;
801016f6:	a1 c8 05 11 80       	mov    0x801105c8,%eax
801016fb:	2b 05 c4 05 11 80    	sub    0x801105c4,%eax
        history_cmnd.num_of_press = 0;
80101701:	c7 05 2c 05 11 80 00 	movl   $0x0,0x8011052c
80101708:	00 00 00 
        show_current_history(temp);
8010170b:	50                   	push   %eax
8010170c:	e8 3f f2 ff ff       	call   80100950 <show_current_history>
        currecnt_com = 0;
80101711:	83 c4 10             	add    $0x10,%esp
80101714:	c7 05 60 06 11 80 00 	movl   $0x0,0x80110660
8010171b:	00 00 00 
8010171e:	e9 40 fe ff ff       	jmp    80101563 <consoleintr+0x23>
80101723:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101727:	90                   	nop
      if(input.e != input.w){
80101728:	a1 c8 05 11 80       	mov    0x801105c8,%eax
8010172d:	8b 0d c4 05 11 80    	mov    0x801105c4,%ecx
80101733:	39 c8                	cmp    %ecx,%eax
80101735:	0f 84 28 fe ff ff    	je     80101563 <consoleintr+0x23>
        if(ctrl_s_pressed){
8010173b:	8b 15 c0 06 11 80    	mov    0x801106c0,%edx
80101741:	85 d2                	test   %edx,%edx
80101743:	74 27                	je     8010176c <consoleintr+0x22c>
            coppied_input[cur_index - 1] = '\0';
80101745:	8b 3d d4 05 11 80    	mov    0x801105d4,%edi
          if(num_of_left_copy == 0){
8010174b:	8b 15 d0 05 11 80    	mov    0x801105d0,%edx
            coppied_input[cur_index - 1] = '\0';
80101751:	89 7d e0             	mov    %edi,-0x20(%ebp)
          if(num_of_left_copy == 0){
80101754:	85 d2                	test   %edx,%edx
80101756:	0f 85 84 04 00 00    	jne    80101be0 <consoleintr+0x6a0>
            coppied_input[cur_index - 1] = '\0';
8010175c:	83 ef 01             	sub    $0x1,%edi
8010175f:	c6 87 e0 05 11 80 00 	movb   $0x0,-0x7feefa20(%edi)
            cur_index--;
80101766:	89 3d d4 05 11 80    	mov    %edi,0x801105d4
        if(num_of_left_pressed == 0){
8010176c:	8b 15 c4 06 11 80    	mov    0x801106c4,%edx
80101772:	85 d2                	test   %edx,%edx
80101774:	0f 84 bf 03 00 00    	je     80101b39 <consoleintr+0x5f9>
        else if(num_of_left_pressed < input.e - input.w){
8010177a:	89 c3                	mov    %eax,%ebx
8010177c:	29 cb                	sub    %ecx,%ebx
8010177e:	39 d3                	cmp    %edx,%ebx
80101780:	0f 86 dd fd ff ff    	jbe    80101563 <consoleintr+0x23>
  for(int i = input.e - num_of_left_pressed - 1; i < input.e; i++){
80101786:	8d 78 ff             	lea    -0x1(%eax),%edi
80101789:	89 c6                	mov    %eax,%esi
8010178b:	89 f9                	mov    %edi,%ecx
8010178d:	29 d1                	sub    %edx,%ecx
8010178f:	39 c8                	cmp    %ecx,%eax
80101791:	76 3a                	jbe    801017cd <consoleintr+0x28d>
80101793:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101797:	90                   	nop
    input.buf[i % INPUT_BUF] = input.buf[(i + 1) % INPUT_BUF];
80101798:	89 ca                	mov    %ecx,%edx
8010179a:	83 c1 01             	add    $0x1,%ecx
8010179d:	89 cb                	mov    %ecx,%ebx
8010179f:	c1 fb 1f             	sar    $0x1f,%ebx
801017a2:	c1 eb 19             	shr    $0x19,%ebx
801017a5:	8d 04 19             	lea    (%ecx,%ebx,1),%eax
801017a8:	83 e0 7f             	and    $0x7f,%eax
801017ab:	29 d8                	sub    %ebx,%eax
801017ad:	89 d3                	mov    %edx,%ebx
801017af:	c1 fb 1f             	sar    $0x1f,%ebx
801017b2:	0f b6 80 40 05 11 80 	movzbl -0x7feefac0(%eax),%eax
801017b9:	c1 eb 19             	shr    $0x19,%ebx
801017bc:	01 da                	add    %ebx,%edx
801017be:	83 e2 7f             	and    $0x7f,%edx
801017c1:	29 da                	sub    %ebx,%edx
801017c3:	88 82 40 05 11 80    	mov    %al,-0x7feefac0(%edx)
  for(int i = input.e - num_of_left_pressed - 1; i < input.e; i++){
801017c9:	39 f1                	cmp    %esi,%ecx
801017cb:	75 cb                	jne    80101798 <consoleintr+0x258>
  if(panicked){
801017cd:	a1 b8 06 11 80       	mov    0x801106b8,%eax
          input.e--;
801017d2:	89 3d c8 05 11 80    	mov    %edi,0x801105c8
  if(panicked){
801017d8:	85 c0                	test   %eax,%eax
801017da:	0f 84 8a 03 00 00    	je     80101b6a <consoleintr+0x62a>
  asm volatile("cli");
801017e0:	fa                   	cli    
    for(;;)
801017e1:	eb fe                	jmp    801017e1 <consoleintr+0x2a1>
801017e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801017e7:	90                   	nop
  memset(coppied_input, '\0', sizeof(coppied_input));
801017e8:	83 ec 04             	sub    $0x4,%esp
      ctrl_s_start = input.e - input.w;
801017eb:	a1 c8 05 11 80       	mov    0x801105c8,%eax
      cur_index = 0;
801017f0:	c7 05 d4 05 11 80 00 	movl   $0x0,0x801105d4
801017f7:	00 00 00 
  memset(coppied_input, '\0', sizeof(coppied_input));
801017fa:	68 80 00 00 00       	push   $0x80
801017ff:	6a 00                	push   $0x0
      ctrl_s_start = input.e - input.w;
80101801:	89 c2                	mov    %eax,%edx
80101803:	2b 15 c4 05 11 80    	sub    0x801105c4,%edx
  memset(coppied_input, '\0', sizeof(coppied_input));
80101809:	68 e0 05 11 80       	push   $0x801105e0
      ctrl_s_pressed = 1;
8010180e:	c7 05 c0 06 11 80 01 	movl   $0x1,0x801106c0
80101815:	00 00 00 
      ctrl_s_start = input.e - input.w;
80101818:	89 15 cc 05 11 80    	mov    %edx,0x801105cc
  start_ctrl_s = input.e;
8010181e:	a3 bc 06 11 80       	mov    %eax,0x801106bc
  memset(coppied_input, '\0', sizeof(coppied_input));
80101823:	e8 38 42 00 00       	call   80105a60 <memset>
}
80101828:	83 c4 10             	add    $0x10,%esp
8010182b:	e9 33 fd ff ff       	jmp    80101563 <consoleintr+0x23>
  if(ctrl_s_pressed){
80101830:	8b 0d c0 06 11 80    	mov    0x801106c0,%ecx
80101836:	85 c9                	test   %ecx,%ecx
80101838:	0f 84 25 fd ff ff    	je     80101563 <consoleintr+0x23>
    print_copied_command();
8010183e:	e8 cd f2 ff ff       	call   80100b10 <print_copied_command>
80101843:	e9 1b fd ff ff       	jmp    80101563 <consoleintr+0x23>
80101848:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010184f:	90                   	nop
    switch(c){
80101850:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
80101857:	e9 07 fd ff ff       	jmp    80101563 <consoleintr+0x23>
8010185c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((input.e - num_of_left_pressed) > input.w){
80101860:	8b 0d c4 06 11 80    	mov    0x801106c4,%ecx
80101866:	a1 c8 05 11 80       	mov    0x801105c8,%eax
8010186b:	29 c8                	sub    %ecx,%eax
8010186d:	3b 05 c4 05 11 80    	cmp    0x801105c4,%eax
80101873:	0f 86 ea fc ff ff    	jbe    80101563 <consoleintr+0x23>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101879:	bf d4 03 00 00       	mov    $0x3d4,%edi
8010187e:	b8 0e 00 00 00       	mov    $0xe,%eax
80101883:	89 fa                	mov    %edi,%edx
80101885:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101886:	be d5 03 00 00       	mov    $0x3d5,%esi
8010188b:	89 f2                	mov    %esi,%edx
8010188d:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
8010188e:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101891:	89 fa                	mov    %edi,%edx
80101893:	89 c3                	mov    %eax,%ebx
80101895:	b8 0f 00 00 00       	mov    $0xf,%eax
8010189a:	c1 e3 08             	shl    $0x8,%ebx
8010189d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010189e:	89 f2                	mov    %esi,%edx
801018a0:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
801018a1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801018a4:	89 fa                	mov    %edi,%edx
801018a6:	09 c3                	or     %eax,%ebx
801018a8:	b8 0e 00 00 00       	mov    $0xe,%eax
      pos -= 1;
801018ad:	83 eb 01             	sub    $0x1,%ebx
801018b0:	ee                   	out    %al,(%dx)
  outb(CRTPORT+1, pos>>8);
801018b1:	89 da                	mov    %ebx,%edx
801018b3:	c1 fa 08             	sar    $0x8,%edx
801018b6:	89 d0                	mov    %edx,%eax
801018b8:	89 f2                	mov    %esi,%edx
801018ba:	ee                   	out    %al,(%dx)
801018bb:	b8 0f 00 00 00       	mov    $0xf,%eax
801018c0:	89 fa                	mov    %edi,%edx
801018c2:	ee                   	out    %al,(%dx)
801018c3:	89 d8                	mov    %ebx,%eax
801018c5:	89 f2                	mov    %esi,%edx
801018c7:	ee                   	out    %al,(%dx)
        if(ctrl_s_pressed && cur_index > 0 && num_of_left_copy < cur_index)
801018c8:	8b 3d c0 06 11 80    	mov    0x801106c0,%edi
        num_of_left_pressed++;
801018ce:	83 c1 01             	add    $0x1,%ecx
801018d1:	89 0d c4 06 11 80    	mov    %ecx,0x801106c4
        if(ctrl_s_pressed && cur_index > 0 && num_of_left_copy < cur_index)
801018d7:	85 ff                	test   %edi,%edi
801018d9:	0f 84 84 fc ff ff    	je     80101563 <consoleintr+0x23>
801018df:	8b 15 d4 05 11 80    	mov    0x801105d4,%edx
801018e5:	85 d2                	test   %edx,%edx
801018e7:	0f 8e 76 fc ff ff    	jle    80101563 <consoleintr+0x23>
801018ed:	a1 d0 05 11 80       	mov    0x801105d0,%eax
801018f2:	39 c2                	cmp    %eax,%edx
801018f4:	0f 8e 69 fc ff ff    	jle    80101563 <consoleintr+0x23>
          num_of_left_copy++;
801018fa:	83 c0 01             	add    $0x1,%eax
801018fd:	a3 d0 05 11 80       	mov    %eax,0x801105d0
80101902:	e9 5c fc ff ff       	jmp    80101563 <consoleintr+0x23>
80101907:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010190e:	66 90                	xchg   %ax,%ax
      for(int i = 0; i < num_of_left_pressed; i++)
80101910:	a1 c4 06 11 80       	mov    0x801106c4,%eax
80101915:	31 ff                	xor    %edi,%edi
80101917:	be d4 03 00 00       	mov    $0x3d4,%esi
8010191c:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010191f:	85 c0                	test   %eax,%eax
80101921:	7e 55                	jle    80101978 <consoleintr+0x438>
80101923:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101927:	90                   	nop
80101928:	b8 0e 00 00 00       	mov    $0xe,%eax
8010192d:	89 f2                	mov    %esi,%edx
8010192f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101930:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80101935:	89 da                	mov    %ebx,%edx
80101937:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80101938:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010193b:	89 f2                	mov    %esi,%edx
8010193d:	b8 0f 00 00 00       	mov    $0xf,%eax
80101942:	c1 e1 08             	shl    $0x8,%ecx
80101945:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101946:	89 da                	mov    %ebx,%edx
80101948:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80101949:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010194c:	89 f2                	mov    %esi,%edx
8010194e:	09 c1                	or     %eax,%ecx
80101950:	b8 0e 00 00 00       	mov    $0xe,%eax
      pos += 1;
80101955:	83 c1 01             	add    $0x1,%ecx
80101958:	ee                   	out    %al,(%dx)
  outb(CRTPORT+1, pos>>8);
80101959:	89 ca                	mov    %ecx,%edx
8010195b:	c1 fa 08             	sar    $0x8,%edx
8010195e:	89 d0                	mov    %edx,%eax
80101960:	89 da                	mov    %ebx,%edx
80101962:	ee                   	out    %al,(%dx)
80101963:	b8 0f 00 00 00       	mov    $0xf,%eax
80101968:	89 f2                	mov    %esi,%edx
8010196a:	ee                   	out    %al,(%dx)
8010196b:	89 c8                	mov    %ecx,%eax
8010196d:	89 da                	mov    %ebx,%edx
8010196f:	ee                   	out    %al,(%dx)
      for(int i = 0; i < num_of_left_pressed; i++)
80101970:	83 c7 01             	add    $0x1,%edi
80101973:	39 7d e0             	cmp    %edi,-0x20(%ebp)
80101976:	75 b0                	jne    80101928 <consoleintr+0x3e8>
      if(currecnt_com == 0){
80101978:	8b 35 60 06 11 80    	mov    0x80110660,%esi
      num_of_left_pressed = 0;
8010197e:	c7 05 c4 06 11 80 00 	movl   $0x0,0x801106c4
80101985:	00 00 00 
      if(currecnt_com == 0){
80101988:	85 f6                	test   %esi,%esi
8010198a:	75 1d                	jne    801019a9 <consoleintr+0x469>
        history_cmnd.current_command = input;
8010198c:	b8 98 04 11 80       	mov    $0x80110498,%eax
80101991:	be 40 05 11 80       	mov    $0x80110540,%esi
80101996:	b9 23 00 00 00       	mov    $0x23,%ecx
        currecnt_com = 1;
8010199b:	c7 05 60 06 11 80 01 	movl   $0x1,0x80110660
801019a2:	00 00 00 
        history_cmnd.current_command = input;
801019a5:	89 c7                	mov    %eax,%edi
801019a7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
      if(history_cmnd.num_of_cmnd != 0 && history_cmnd.num_of_press < history_cmnd.num_of_cmnd){
801019a9:	a1 24 05 11 80       	mov    0x80110524,%eax
801019ae:	85 c0                	test   %eax,%eax
801019b0:	0f 84 ad fb ff ff    	je     80101563 <consoleintr+0x23>
801019b6:	8b 15 2c 05 11 80    	mov    0x8011052c,%edx
801019bc:	39 d0                	cmp    %edx,%eax
801019be:	0f 8e 9f fb ff ff    	jle    80101563 <consoleintr+0x23>
        handle_up_and_down_arrow(UP);
801019c4:	83 ec 0c             	sub    $0xc,%esp
        history_cmnd.num_of_press++;
801019c7:	83 c2 01             	add    $0x1,%edx
        handle_up_and_down_arrow(UP);
801019ca:	6a 01                	push   $0x1
        history_cmnd.num_of_press++;
801019cc:	89 15 2c 05 11 80    	mov    %edx,0x8011052c
        handle_up_and_down_arrow(UP);
801019d2:	e8 a9 f7 ff ff       	call   80101180 <handle_up_and_down_arrow>
801019d7:	83 c4 10             	add    $0x10,%esp
801019da:	e9 84 fb ff ff       	jmp    80101563 <consoleintr+0x23>
801019df:	90                   	nop
  for(int i = input.w; i < input.e; i++){
801019e0:	8b 35 c4 05 11 80    	mov    0x801105c4,%esi
801019e6:	a1 c8 05 11 80       	mov    0x801105c8,%eax
801019eb:	39 c6                	cmp    %eax,%esi
801019ed:	73 66                	jae    80101a55 <consoleintr+0x515>
      for(int i = 0; i < num_of_left_pressed; i++)
801019ef:	89 f2                	mov    %esi,%edx
801019f1:	eb 0c                	jmp    801019ff <consoleintr+0x4bf>
801019f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801019f7:	90                   	nop
  for(int i = input.w; i < input.e; i++){
801019f8:	83 c2 01             	add    $0x1,%edx
801019fb:	39 d0                	cmp    %edx,%eax
801019fd:	76 49                	jbe    80101a48 <consoleintr+0x508>
    if(input.buf[i] == '?'){
801019ff:	80 ba 40 05 11 80 3f 	cmpb   $0x3f,-0x7feefac0(%edx)
80101a06:	75 f0                	jne    801019f8 <consoleintr+0x4b8>
80101a08:	eb 11                	jmp    80101a1b <consoleintr+0x4db>
80101a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(int i = input.w; i < input.e; i++){
80101a10:	83 c6 01             	add    $0x1,%esi
80101a13:	39 f0                	cmp    %esi,%eax
80101a15:	0f 86 de 01 00 00    	jbe    80101bf9 <consoleintr+0x6b9>
    if(input.buf[i] == '?'){
80101a1b:	80 be 40 05 11 80 3f 	cmpb   $0x3f,-0x7feefac0(%esi)
80101a22:	75 ec                	jne    80101a10 <consoleintr+0x4d0>
  index_question_mark = qm_index;
80101a24:	89 35 64 06 11 80    	mov    %esi,0x80110664
80101a2a:	bf 04 00 00 00       	mov    $0x4,%edi
    check_states_question_mark(input.buf[qm_index - i]);
80101a2f:	0f be 84 3e 3b 05 11 	movsbl -0x7feefac5(%esi,%edi,1),%eax
80101a36:	80 
80101a37:	83 ec 0c             	sub    $0xc,%esp
80101a3a:	50                   	push   %eax
80101a3b:	e8 00 f8 ff ff       	call   80101240 <check_states_question_mark>
  for(int i = 1;i <= 4; i++){
80101a40:	83 c4 10             	add    $0x10,%esp
80101a43:	83 ef 01             	sub    $0x1,%edi
80101a46:	75 e7                	jne    80101a2f <consoleintr+0x4ef>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80101a48:	a1 c8 05 11 80       	mov    0x801105c8,%eax
80101a4d:	85 db                	test   %ebx,%ebx
80101a4f:	0f 84 0e fb ff ff    	je     80101563 <consoleintr+0x23>
80101a55:	89 c2                	mov    %eax,%edx
80101a57:	2b 15 c0 05 11 80    	sub    0x801105c0,%edx
80101a5d:	83 fa 7f             	cmp    $0x7f,%edx
80101a60:	0f 87 fd fa ff ff    	ja     80101563 <consoleintr+0x23>
        if(ctrl_s_pressed){
80101a66:	8b 15 c0 06 11 80    	mov    0x801106c0,%edx
        c = (c == '\r') ? '\n' : c;
80101a6c:	83 fb 0d             	cmp    $0xd,%ebx
80101a6f:	0f 84 6f 02 00 00    	je     80101ce4 <consoleintr+0x7a4>
        if(num_of_left_pressed == 0 || c == '\n'){
80101a75:	83 fb 0a             	cmp    $0xa,%ebx
            coppied_input[cur_index] = c;
80101a78:	88 5d e0             	mov    %bl,-0x20(%ebp)
        if(num_of_left_pressed == 0 || c == '\n'){
80101a7b:	0f 94 45 d8          	sete   -0x28(%ebp)
        if(ctrl_s_pressed){
80101a7f:	85 d2                	test   %edx,%edx
80101a81:	0f 85 ff 00 00 00    	jne    80101b86 <consoleintr+0x646>
          if(num_of_left_pressed == 0){
80101a87:	8b 3d c4 06 11 80    	mov    0x801106c4,%edi
80101a8d:	89 7d d4             	mov    %edi,-0x2c(%ebp)
        if(num_of_left_pressed == 0 || c == '\n'){
80101a90:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80101a93:	85 d2                	test   %edx,%edx
80101a95:	0f 94 c2             	sete   %dl
80101a98:	0a 55 d8             	or     -0x28(%ebp),%dl
80101a9b:	0f 84 5d 02 00 00    	je     80101cfe <consoleintr+0x7be>
          input.buf[input.e++ % INPUT_BUF] = c;
80101aa1:	0f b6 4d e0          	movzbl -0x20(%ebp),%ecx
80101aa5:	8d 50 01             	lea    0x1(%eax),%edx
80101aa8:	83 e0 7f             	and    $0x7f,%eax
80101aab:	89 15 c8 05 11 80    	mov    %edx,0x801105c8
80101ab1:	88 88 40 05 11 80    	mov    %cl,-0x7feefac0(%eax)
  if(panicked){
80101ab7:	8b 35 b8 06 11 80    	mov    0x801106b8,%esi
80101abd:	85 f6                	test   %esi,%esi
80101abf:	0f 84 83 01 00 00    	je     80101c48 <consoleintr+0x708>
  asm volatile("cli");
80101ac5:	fa                   	cli    
    for(;;)
80101ac6:	eb fe                	jmp    80101ac6 <consoleintr+0x586>
80101ac8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101acf:	90                   	nop
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101ad0:	bf d4 03 00 00       	mov    $0x3d4,%edi
80101ad5:	b8 0e 00 00 00       	mov    $0xe,%eax
80101ada:	89 fa                	mov    %edi,%edx
80101adc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101add:	be d5 03 00 00       	mov    $0x3d5,%esi
80101ae2:	89 f2                	mov    %esi,%edx
80101ae4:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80101ae5:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101ae8:	89 fa                	mov    %edi,%edx
80101aea:	89 c1                	mov    %eax,%ecx
80101aec:	b8 0f 00 00 00       	mov    $0xf,%eax
80101af1:	c1 e1 08             	shl    $0x8,%ecx
80101af4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101af5:	89 f2                	mov    %esi,%edx
80101af7:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80101af8:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101afb:	89 fa                	mov    %edi,%edx
80101afd:	09 c1                	or     %eax,%ecx
80101aff:	b8 0e 00 00 00       	mov    $0xe,%eax
      pos += 1;
80101b04:	83 c1 01             	add    $0x1,%ecx
80101b07:	ee                   	out    %al,(%dx)
  outb(CRTPORT+1, pos>>8);
80101b08:	89 ca                	mov    %ecx,%edx
80101b0a:	c1 fa 08             	sar    $0x8,%edx
80101b0d:	89 d0                	mov    %edx,%eax
80101b0f:	89 f2                	mov    %esi,%edx
80101b11:	ee                   	out    %al,(%dx)
80101b12:	b8 0f 00 00 00       	mov    $0xf,%eax
80101b17:	89 fa                	mov    %edi,%edx
80101b19:	ee                   	out    %al,(%dx)
80101b1a:	89 c8                	mov    %ecx,%eax
80101b1c:	89 f2                	mov    %esi,%edx
80101b1e:	ee                   	out    %al,(%dx)
        num_of_left_pressed--;
80101b1f:	83 eb 01             	sub    $0x1,%ebx
80101b22:	89 1d c4 06 11 80    	mov    %ebx,0x801106c4
80101b28:	e9 cb fa ff ff       	jmp    801015f8 <consoleintr+0xb8>
}
80101b2d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b30:	5b                   	pop    %ebx
80101b31:	5e                   	pop    %esi
80101b32:	5f                   	pop    %edi
80101b33:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80101b34:	e9 a7 3a 00 00       	jmp    801055e0 <procdump>
        input.e--;
80101b39:	83 e8 01             	sub    $0x1,%eax
80101b3c:	a3 c8 05 11 80       	mov    %eax,0x801105c8
  if(panicked){
80101b41:	a1 b8 06 11 80       	mov    0x801106b8,%eax
80101b46:	85 c0                	test   %eax,%eax
80101b48:	74 20                	je     80101b6a <consoleintr+0x62a>
  asm volatile("cli");
80101b4a:	fa                   	cli    
    for(;;)
80101b4b:	eb fe                	jmp    80101b4b <consoleintr+0x60b>
80101b4d:	8d 76 00             	lea    0x0(%esi),%esi
        handle_up_and_down_arrow(DOWN);
80101b50:	83 ec 0c             	sub    $0xc,%esp
        history_cmnd.num_of_press--;
80101b53:	83 e8 01             	sub    $0x1,%eax
        handle_up_and_down_arrow(DOWN);
80101b56:	6a 00                	push   $0x0
        history_cmnd.num_of_press--;
80101b58:	a3 2c 05 11 80       	mov    %eax,0x8011052c
        handle_up_and_down_arrow(DOWN);
80101b5d:	e8 1e f6 ff ff       	call   80101180 <handle_up_and_down_arrow>
80101b62:	83 c4 10             	add    $0x10,%esp
80101b65:	e9 f9 f9 ff ff       	jmp    80101563 <consoleintr+0x23>
80101b6a:	b8 00 01 00 00       	mov    $0x100,%eax
80101b6f:	e8 8c e8 ff ff       	call   80100400 <consputc.part.0>
80101b74:	e9 ea f9 ff ff       	jmp    80101563 <consoleintr+0x23>
        if(ctrl_s_pressed){
80101b79:	c6 45 d8 01          	movb   $0x1,-0x28(%ebp)
        c = (c == '\r') ? '\n' : c;
80101b7d:	bb 0a 00 00 00       	mov    $0xa,%ebx
        if(ctrl_s_pressed){
80101b82:	c6 45 e0 0a          	movb   $0xa,-0x20(%ebp)
          if(num_of_left_pressed == 0){
80101b86:	8b 35 c4 06 11 80    	mov    0x801106c4,%esi
            coppied_input[cur_index] = c;
80101b8c:	8b 3d d4 05 11 80    	mov    0x801105d4,%edi
          if(num_of_left_pressed == 0){
80101b92:	89 75 d4             	mov    %esi,-0x2c(%ebp)
80101b95:	85 f6                	test   %esi,%esi
80101b97:	0f 84 93 00 00 00    	je     80101c30 <consoleintr+0x6f0>
  int limit = cur_index - 1 - num_of_left_copy;
80101b9d:	8b 15 d0 05 11 80    	mov    0x801105d0,%edx
80101ba3:	89 55 cc             	mov    %edx,-0x34(%ebp)
            if(cur_index - num_of_left_pressed >= 0){
80101ba6:	3b 7d d4             	cmp    -0x2c(%ebp),%edi
80101ba9:	0f 8d 21 02 00 00    	jge    80101dd0 <consoleintr+0x890>
            else if(num_of_left_copy > 0 && num_of_left_copy != cur_index){
80101baf:	8b 75 cc             	mov    -0x34(%ebp),%esi
80101bb2:	39 fe                	cmp    %edi,%esi
80101bb4:	0f 84 d6 fe ff ff    	je     80101a90 <consoleintr+0x550>
80101bba:	85 f6                	test   %esi,%esi
80101bbc:	0f 8e ce fe ff ff    	jle    80101a90 <consoleintr+0x550>
              coppied_input[cur_index - num_of_left_copy] = c;
80101bc2:	0f b6 4d e0          	movzbl -0x20(%ebp),%ecx
80101bc6:	89 fa                	mov    %edi,%edx
80101bc8:	29 f2                	sub    %esi,%edx
80101bca:	88 8a e0 05 11 80    	mov    %cl,-0x7feefa20(%edx)
              cur_index++;
80101bd0:	8d 57 01             	lea    0x1(%edi),%edx
80101bd3:	89 15 d4 05 11 80    	mov    %edx,0x801105d4
80101bd9:	e9 b2 fe ff ff       	jmp    80101a90 <consoleintr+0x550>
80101bde:	66 90                	xchg   %ax,%ax
          else if(num_of_left_copy > 0 && num_of_left_copy != cur_index){
80101be0:	7e 3e                	jle    80101c20 <consoleintr+0x6e0>
80101be2:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101be5:	39 fa                	cmp    %edi,%edx
80101be7:	0f 85 86 01 00 00    	jne    80101d73 <consoleintr+0x833>
            ctrl_s_start--;
80101bed:	83 2d cc 05 11 80 01 	subl   $0x1,0x801105cc
80101bf4:	e9 73 fb ff ff       	jmp    8010176c <consoleintr+0x22c>
  return 0;
80101bf9:	31 f6                	xor    %esi,%esi
80101bfb:	e9 24 fe ff ff       	jmp    80101a24 <consoleintr+0x4e4>
  for(int i = input.w; i < input.e; i++){
80101c00:	8b 35 c4 05 11 80    	mov    0x801105c4,%esi
80101c06:	a1 c8 05 11 80       	mov    0x801105c8,%eax
80101c0b:	39 c6                	cmp    %eax,%esi
80101c0d:	0f 82 dc fd ff ff    	jb     801019ef <consoleintr+0x4af>
80101c13:	e9 30 fe ff ff       	jmp    80101a48 <consoleintr+0x508>
80101c18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c1f:	90                   	nop
          else if(num_of_left_copy == cur_index){
80101c20:	3b 55 e0             	cmp    -0x20(%ebp),%edx
80101c23:	0f 85 43 fb ff ff    	jne    8010176c <consoleintr+0x22c>
80101c29:	eb c2                	jmp    80101bed <consoleintr+0x6ad>
80101c2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101c2f:	90                   	nop
            coppied_input[cur_index] = c;
80101c30:	0f b6 4d e0          	movzbl -0x20(%ebp),%ecx
            cur_index++;
80101c34:	8d 57 01             	lea    0x1(%edi),%edx
80101c37:	89 15 d4 05 11 80    	mov    %edx,0x801105d4
            coppied_input[cur_index] = c;
80101c3d:	88 8f e0 05 11 80    	mov    %cl,-0x7feefa20(%edi)
        if(num_of_left_pressed == 0 || c == '\n'){
80101c43:	e9 59 fe ff ff       	jmp    80101aa1 <consoleintr+0x561>
80101c48:	89 d8                	mov    %ebx,%eax
80101c4a:	e8 b1 e7 ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80101c4f:	83 fb 04             	cmp    $0x4,%ebx
80101c52:	74 1a                	je     80101c6e <consoleintr+0x72e>
80101c54:	80 7d d8 00          	cmpb   $0x0,-0x28(%ebp)
80101c58:	75 14                	jne    80101c6e <consoleintr+0x72e>
80101c5a:	a1 c0 05 11 80       	mov    0x801105c0,%eax
80101c5f:	83 e8 80             	sub    $0xffffff80,%eax
80101c62:	39 05 c8 05 11 80    	cmp    %eax,0x801105c8
80101c68:	0f 85 f5 f8 ff ff    	jne    80101563 <consoleintr+0x23>
          num_of_left_pressed = 0;
80101c6e:	c7 05 c4 06 11 80 00 	movl   $0x0,0x801106c4
80101c75:	00 00 00 
          num_of_left_copy = 0;
80101c78:	c7 05 d0 05 11 80 00 	movl   $0x0,0x801105d0
80101c7f:	00 00 00 
          history_cmnd.num_of_press = 0;
80101c82:	c7 05 2c 05 11 80 00 	movl   $0x0,0x8011052c
80101c89:	00 00 00 
          update_history_memory();
80101c8c:	e8 9f f6 ff ff       	call   80101330 <update_history_memory>
          if(is_history(hist)){
80101c91:	8b 15 00 90 10 80    	mov    0x80109000,%edx
    if(command[i] != input.buf[i + input.w]){
80101c97:	a1 c4 05 11 80       	mov    0x801105c4,%eax
80101c9c:	0f b6 8c 30 40 05 11 	movzbl -0x7feefac0(%eax,%esi,1),%ecx
80101ca3:	80 
80101ca4:	38 0c 32             	cmp    %cl,(%edx,%esi,1)
80101ca7:	75 0d                	jne    80101cb6 <consoleintr+0x776>
  for(int i = 0; i < 8; i++){
80101ca9:	83 c6 01             	add    $0x1,%esi
80101cac:	83 fe 08             	cmp    $0x8,%esi
80101caf:	75 eb                	jne    80101c9c <consoleintr+0x75c>
            print_history();
80101cb1:	e8 6a ed ff ff       	call   80100a20 <print_history>
          update_coppied_commands();
80101cb6:	e8 55 ef ff ff       	call   80100c10 <update_coppied_commands>
          wakeup(&input.r);
80101cbb:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80101cbe:	a1 c8 05 11 80       	mov    0x801105c8,%eax
          currecnt_com = 0;
80101cc3:	c7 05 60 06 11 80 00 	movl   $0x0,0x80110660
80101cca:	00 00 00 
          wakeup(&input.r);
80101ccd:	68 c0 05 11 80       	push   $0x801105c0
          input.w = input.e;
80101cd2:	a3 c4 05 11 80       	mov    %eax,0x801105c4
          wakeup(&input.r);
80101cd7:	e8 24 38 00 00       	call   80105500 <wakeup>
80101cdc:	83 c4 10             	add    $0x10,%esp
80101cdf:	e9 7f f8 ff ff       	jmp    80101563 <consoleintr+0x23>
        if(ctrl_s_pressed){
80101ce4:	85 d2                	test   %edx,%edx
80101ce6:	0f 85 8d fe ff ff    	jne    80101b79 <consoleintr+0x639>
80101cec:	c6 45 e0 0a          	movb   $0xa,-0x20(%ebp)
        c = (c == '\r') ? '\n' : c;
80101cf0:	bb 0a 00 00 00       	mov    $0xa,%ebx
        if(num_of_left_pressed == 0 || c == '\n'){
80101cf5:	c6 45 d8 01          	movb   $0x1,-0x28(%ebp)
80101cf9:	e9 a3 fd ff ff       	jmp    80101aa1 <consoleintr+0x561>
  int limit = input.e - num_of_left_pressed - 1;
80101cfe:	89 c7                	mov    %eax,%edi
80101d00:	2b 7d d4             	sub    -0x2c(%ebp),%edi
  int init = input.e - 1;
80101d03:	8d 48 ff             	lea    -0x1(%eax),%ecx
  int limit = input.e - num_of_left_pressed - 1;
80101d06:	89 7d d8             	mov    %edi,-0x28(%ebp)
80101d09:	83 ef 01             	sub    $0x1,%edi
  for(int i = init; i > limit; i--){
80101d0c:	39 f9                	cmp    %edi,%ecx
80101d0e:	7e 42                	jle    80101d52 <consoleintr+0x812>
80101d10:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
80101d13:	89 fb                	mov    %edi,%ebx
80101d15:	89 c7                	mov    %eax,%edi
    input.buf[(i + 1) % INPUT_BUF] = input.buf[i % INPUT_BUF];
80101d17:	89 ca                	mov    %ecx,%edx
80101d19:	c1 fa 1f             	sar    $0x1f,%edx
80101d1c:	c1 ea 19             	shr    $0x19,%edx
80101d1f:	8d 04 11             	lea    (%ecx,%edx,1),%eax
80101d22:	83 e0 7f             	and    $0x7f,%eax
80101d25:	29 d0                	sub    %edx,%eax
80101d27:	8d 51 01             	lea    0x1(%ecx),%edx
  for(int i = init; i > limit; i--){
80101d2a:	83 e9 01             	sub    $0x1,%ecx
    input.buf[(i + 1) % INPUT_BUF] = input.buf[i % INPUT_BUF];
80101d2d:	89 d6                	mov    %edx,%esi
80101d2f:	0f b6 80 40 05 11 80 	movzbl -0x7feefac0(%eax),%eax
80101d36:	c1 fe 1f             	sar    $0x1f,%esi
80101d39:	c1 ee 19             	shr    $0x19,%esi
80101d3c:	01 f2                	add    %esi,%edx
80101d3e:	83 e2 7f             	and    $0x7f,%edx
80101d41:	29 f2                	sub    %esi,%edx
80101d43:	88 82 40 05 11 80    	mov    %al,-0x7feefac0(%edx)
  for(int i = init; i > limit; i--){
80101d49:	39 cb                	cmp    %ecx,%ebx
80101d4b:	7c ca                	jl     80101d17 <consoleintr+0x7d7>
80101d4d:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
80101d50:	89 f8                	mov    %edi,%eax
          input.buf[(input.e - num_of_left_pressed) % INPUT_BUF] = c;
80101d52:	8b 55 d8             	mov    -0x28(%ebp),%edx
80101d55:	0f b6 4d e0          	movzbl -0x20(%ebp),%ecx
          input.e++;
80101d59:	83 c0 01             	add    $0x1,%eax
        if(num_of_left_pressed == 0 || c == '\n'){
80101d5c:	c6 45 d8 00          	movb   $0x0,-0x28(%ebp)
          input.e++;
80101d60:	a3 c8 05 11 80       	mov    %eax,0x801105c8
          input.buf[(input.e - num_of_left_pressed) % INPUT_BUF] = c;
80101d65:	83 e2 7f             	and    $0x7f,%edx
80101d68:	88 8a 40 05 11 80    	mov    %cl,-0x7feefac0(%edx)
          input.e++;
80101d6e:	e9 44 fd ff ff       	jmp    80101ab7 <consoleintr+0x577>
  for(int i = cur_index - num_of_left_copy - 1; i < cur_index; i++){
80101d73:	89 fb                	mov    %edi,%ebx
80101d75:	29 d3                	sub    %edx,%ebx
80101d77:	83 eb 01             	sub    $0x1,%ebx
80101d7a:	39 fb                	cmp    %edi,%ebx
80101d7c:	7d 3a                	jge    80101db8 <consoleintr+0x878>
80101d7e:	89 c7                	mov    %eax,%edi
    coppied_input[i % INPUT_BUF] = coppied_input[(i + 1) % INPUT_BUF];
80101d80:	89 da                	mov    %ebx,%edx
80101d82:	83 c3 01             	add    $0x1,%ebx
80101d85:	89 de                	mov    %ebx,%esi
80101d87:	c1 fe 1f             	sar    $0x1f,%esi
80101d8a:	c1 ee 19             	shr    $0x19,%esi
80101d8d:	8d 04 33             	lea    (%ebx,%esi,1),%eax
80101d90:	83 e0 7f             	and    $0x7f,%eax
80101d93:	29 f0                	sub    %esi,%eax
80101d95:	89 d6                	mov    %edx,%esi
80101d97:	c1 fe 1f             	sar    $0x1f,%esi
80101d9a:	0f b6 80 e0 05 11 80 	movzbl -0x7feefa20(%eax),%eax
80101da1:	c1 ee 19             	shr    $0x19,%esi
80101da4:	01 f2                	add    %esi,%edx
80101da6:	83 e2 7f             	and    $0x7f,%edx
80101da9:	29 f2                	sub    %esi,%edx
80101dab:	88 82 e0 05 11 80    	mov    %al,-0x7feefa20(%edx)
  for(int i = cur_index - num_of_left_copy - 1; i < cur_index; i++){
80101db1:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
80101db4:	75 ca                	jne    80101d80 <consoleintr+0x840>
80101db6:	89 f8                	mov    %edi,%eax
            coppied_input[cur_index - 1] = '\0';
80101db8:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101dbb:	c6 82 df 05 11 80 00 	movb   $0x0,-0x7feefa21(%edx)
80101dc2:	83 ea 01             	sub    $0x1,%edx
            cur_index--;
80101dc5:	89 15 d4 05 11 80    	mov    %edx,0x801105d4
80101dcb:	e9 9c f9 ff ff       	jmp    8010176c <consoleintr+0x22c>
  int init = cur_index - 1;
80101dd0:	8d 4f ff             	lea    -0x1(%edi),%ecx
  int limit = cur_index - 1 - num_of_left_copy;
80101dd3:	89 ce                	mov    %ecx,%esi
80101dd5:	29 d6                	sub    %edx,%esi
80101dd7:	89 75 d0             	mov    %esi,-0x30(%ebp)
  for(int i = init; i > limit; i--){
80101dda:	39 f1                	cmp    %esi,%ecx
80101ddc:	7e 41                	jle    80101e1f <consoleintr+0x8df>
80101dde:	89 5d c8             	mov    %ebx,-0x38(%ebp)
80101de1:	89 c6                	mov    %eax,%esi
    coppied_input[(i + 1) % INPUT_BUF] = coppied_input[i % INPUT_BUF];
80101de3:	89 ca                	mov    %ecx,%edx
80101de5:	c1 fa 1f             	sar    $0x1f,%edx
80101de8:	c1 ea 19             	shr    $0x19,%edx
80101deb:	8d 04 11             	lea    (%ecx,%edx,1),%eax
80101dee:	83 e0 7f             	and    $0x7f,%eax
80101df1:	29 d0                	sub    %edx,%eax
80101df3:	8d 51 01             	lea    0x1(%ecx),%edx
  for(int i = init; i > limit; i--){
80101df6:	83 e9 01             	sub    $0x1,%ecx
    coppied_input[(i + 1) % INPUT_BUF] = coppied_input[i % INPUT_BUF];
80101df9:	89 d3                	mov    %edx,%ebx
80101dfb:	0f b6 80 e0 05 11 80 	movzbl -0x7feefa20(%eax),%eax
80101e02:	c1 fb 1f             	sar    $0x1f,%ebx
80101e05:	c1 eb 19             	shr    $0x19,%ebx
80101e08:	01 da                	add    %ebx,%edx
80101e0a:	83 e2 7f             	and    $0x7f,%edx
80101e0d:	29 da                	sub    %ebx,%edx
80101e0f:	88 82 e0 05 11 80    	mov    %al,-0x7feefa20(%edx)
  for(int i = init; i > limit; i--){
80101e15:	39 4d d0             	cmp    %ecx,-0x30(%ebp)
80101e18:	75 c9                	jne    80101de3 <consoleintr+0x8a3>
80101e1a:	8b 5d c8             	mov    -0x38(%ebp),%ebx
80101e1d:	89 f0                	mov    %esi,%eax
              coppied_input[cur_index - num_of_left_copy] = c;
80101e1f:	0f b6 4d e0          	movzbl -0x20(%ebp),%ecx
80101e23:	89 fa                	mov    %edi,%edx
80101e25:	2b 55 cc             	sub    -0x34(%ebp),%edx
80101e28:	88 8a e0 05 11 80    	mov    %cl,-0x7feefa20(%edx)
              cur_index++;
80101e2e:	8d 57 01             	lea    0x1(%edi),%edx
80101e31:	89 15 d4 05 11 80    	mov    %edx,0x801105d4
80101e37:	e9 54 fc ff ff       	jmp    80101a90 <consoleintr+0x550>
80101e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101e40 <consoleinit>:

void
consoleinit(void)
{
80101e40:	55                   	push   %ebp
80101e41:	89 e5                	mov    %esp,%ebp
80101e43:	83 ec 10             	sub    $0x10,%esp

  history_cmnd.num_of_cmnd = 0;
80101e46:	c7 05 24 05 11 80 00 	movl   $0x0,0x80110524
80101e4d:	00 00 00 
  history_cmnd.start_index = 0;
  history_cmnd.num_of_press = 0;

  initlock(&cons.lock, "console");
80101e50:	68 08 86 10 80       	push   $0x80108608
80101e55:	68 80 06 11 80       	push   $0x80110680
  history_cmnd.start_index = 0;
80101e5a:	c7 05 28 05 11 80 00 	movl   $0x0,0x80110528
80101e61:	00 00 00 
  history_cmnd.num_of_press = 0;
80101e64:	c7 05 2c 05 11 80 00 	movl   $0x0,0x8011052c
80101e6b:	00 00 00 
  initlock(&cons.lock, "console");
80101e6e:	e8 5d 39 00 00       	call   801057d0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80101e73:	58                   	pop    %eax
80101e74:	5a                   	pop    %edx
80101e75:	6a 00                	push   $0x0
80101e77:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80101e79:	c7 05 8c 10 11 80 f0 	movl   $0x801005f0,0x8011108c
80101e80:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80101e83:	c7 05 88 10 11 80 80 	movl   $0x80100280,0x80111088
80101e8a:	02 10 80 
  cons.locking = 1;
80101e8d:	c7 05 b4 06 11 80 01 	movl   $0x1,0x801106b4
80101e94:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80101e97:	e8 e4 19 00 00       	call   80103880 <ioapicenable>
}
80101e9c:	83 c4 10             	add    $0x10,%esp
80101e9f:	c9                   	leave  
80101ea0:	c3                   	ret    
80101ea1:	66 90                	xchg   %ax,%ax
80101ea3:	66 90                	xchg   %ax,%ax
80101ea5:	66 90                	xchg   %ax,%ax
80101ea7:	66 90                	xchg   %ax,%ax
80101ea9:	66 90                	xchg   %ax,%ax
80101eab:	66 90                	xchg   %ax,%ax
80101ead:	66 90                	xchg   %ax,%ax
80101eaf:	90                   	nop

80101eb0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80101eb0:	55                   	push   %ebp
80101eb1:	89 e5                	mov    %esp,%ebp
80101eb3:	57                   	push   %edi
80101eb4:	56                   	push   %esi
80101eb5:	53                   	push   %ebx
80101eb6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80101ebc:	e8 af 2e 00 00       	call   80104d70 <myproc>
80101ec1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80101ec7:	e8 94 22 00 00       	call   80104160 <begin_op>

  if((ip = namei(path)) == 0){
80101ecc:	83 ec 0c             	sub    $0xc,%esp
80101ecf:	ff 75 08             	push   0x8(%ebp)
80101ed2:	e8 c9 15 00 00       	call   801034a0 <namei>
80101ed7:	83 c4 10             	add    $0x10,%esp
80101eda:	85 c0                	test   %eax,%eax
80101edc:	0f 84 02 03 00 00    	je     801021e4 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80101ee2:	83 ec 0c             	sub    $0xc,%esp
80101ee5:	89 c3                	mov    %eax,%ebx
80101ee7:	50                   	push   %eax
80101ee8:	e8 93 0c 00 00       	call   80102b80 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80101eed:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80101ef3:	6a 34                	push   $0x34
80101ef5:	6a 00                	push   $0x0
80101ef7:	50                   	push   %eax
80101ef8:	53                   	push   %ebx
80101ef9:	e8 92 0f 00 00       	call   80102e90 <readi>
80101efe:	83 c4 20             	add    $0x20,%esp
80101f01:	83 f8 34             	cmp    $0x34,%eax
80101f04:	74 22                	je     80101f28 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80101f06:	83 ec 0c             	sub    $0xc,%esp
80101f09:	53                   	push   %ebx
80101f0a:	e8 01 0f 00 00       	call   80102e10 <iunlockput>
    end_op();
80101f0f:	e8 bc 22 00 00       	call   801041d0 <end_op>
80101f14:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80101f17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101f1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f1f:	5b                   	pop    %ebx
80101f20:	5e                   	pop    %esi
80101f21:	5f                   	pop    %edi
80101f22:	5d                   	pop    %ebp
80101f23:	c3                   	ret    
80101f24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80101f28:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80101f2f:	45 4c 46 
80101f32:	75 d2                	jne    80101f06 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80101f34:	e8 07 63 00 00       	call   80108240 <setupkvm>
80101f39:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80101f3f:	85 c0                	test   %eax,%eax
80101f41:	74 c3                	je     80101f06 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101f43:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80101f4a:	00 
80101f4b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80101f51:	0f 84 ac 02 00 00    	je     80102203 <exec+0x353>
  sz = 0;
80101f57:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80101f5e:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101f61:	31 ff                	xor    %edi,%edi
80101f63:	e9 8e 00 00 00       	jmp    80101ff6 <exec+0x146>
80101f68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f6f:	90                   	nop
    if(ph.type != ELF_PROG_LOAD)
80101f70:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80101f77:	75 6c                	jne    80101fe5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80101f79:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80101f7f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80101f85:	0f 82 87 00 00 00    	jb     80102012 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80101f8b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80101f91:	72 7f                	jb     80102012 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80101f93:	83 ec 04             	sub    $0x4,%esp
80101f96:	50                   	push   %eax
80101f97:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80101f9d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80101fa3:	e8 b8 60 00 00       	call   80108060 <allocuvm>
80101fa8:	83 c4 10             	add    $0x10,%esp
80101fab:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80101fb1:	85 c0                	test   %eax,%eax
80101fb3:	74 5d                	je     80102012 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80101fb5:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80101fbb:	a9 ff 0f 00 00       	test   $0xfff,%eax
80101fc0:	75 50                	jne    80102012 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80101fc2:	83 ec 0c             	sub    $0xc,%esp
80101fc5:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80101fcb:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80101fd1:	53                   	push   %ebx
80101fd2:	50                   	push   %eax
80101fd3:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80101fd9:	e8 92 5f 00 00       	call   80107f70 <loaduvm>
80101fde:	83 c4 20             	add    $0x20,%esp
80101fe1:	85 c0                	test   %eax,%eax
80101fe3:	78 2d                	js     80102012 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101fe5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80101fec:	83 c7 01             	add    $0x1,%edi
80101fef:	83 c6 20             	add    $0x20,%esi
80101ff2:	39 f8                	cmp    %edi,%eax
80101ff4:	7e 3a                	jle    80102030 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80101ff6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80101ffc:	6a 20                	push   $0x20
80101ffe:	56                   	push   %esi
80101fff:	50                   	push   %eax
80102000:	53                   	push   %ebx
80102001:	e8 8a 0e 00 00       	call   80102e90 <readi>
80102006:	83 c4 10             	add    $0x10,%esp
80102009:	83 f8 20             	cmp    $0x20,%eax
8010200c:	0f 84 5e ff ff ff    	je     80101f70 <exec+0xc0>
    freevm(pgdir);
80102012:	83 ec 0c             	sub    $0xc,%esp
80102015:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
8010201b:	e8 a0 61 00 00       	call   801081c0 <freevm>
  if(ip){
80102020:	83 c4 10             	add    $0x10,%esp
80102023:	e9 de fe ff ff       	jmp    80101f06 <exec+0x56>
80102028:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010202f:	90                   	nop
  sz = PGROUNDUP(sz);
80102030:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80102036:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
8010203c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80102042:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80102048:	83 ec 0c             	sub    $0xc,%esp
8010204b:	53                   	push   %ebx
8010204c:	e8 bf 0d 00 00       	call   80102e10 <iunlockput>
  end_op();
80102051:	e8 7a 21 00 00       	call   801041d0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80102056:	83 c4 0c             	add    $0xc,%esp
80102059:	56                   	push   %esi
8010205a:	57                   	push   %edi
8010205b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80102061:	57                   	push   %edi
80102062:	e8 f9 5f 00 00       	call   80108060 <allocuvm>
80102067:	83 c4 10             	add    $0x10,%esp
8010206a:	89 c6                	mov    %eax,%esi
8010206c:	85 c0                	test   %eax,%eax
8010206e:	0f 84 94 00 00 00    	je     80102108 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80102074:	83 ec 08             	sub    $0x8,%esp
80102077:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
8010207d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
8010207f:	50                   	push   %eax
80102080:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80102081:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80102083:	e8 58 62 00 00       	call   801082e0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80102088:	8b 45 0c             	mov    0xc(%ebp),%eax
8010208b:	83 c4 10             	add    $0x10,%esp
8010208e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80102094:	8b 00                	mov    (%eax),%eax
80102096:	85 c0                	test   %eax,%eax
80102098:	0f 84 8b 00 00 00    	je     80102129 <exec+0x279>
8010209e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
801020a4:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
801020aa:	eb 23                	jmp    801020cf <exec+0x21f>
801020ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801020b0:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
801020b3:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
801020ba:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
801020bd:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
801020c3:	8b 04 b8             	mov    (%eax,%edi,4),%eax
801020c6:	85 c0                	test   %eax,%eax
801020c8:	74 59                	je     80102123 <exec+0x273>
    if(argc >= MAXARG)
801020ca:	83 ff 20             	cmp    $0x20,%edi
801020cd:	74 39                	je     80102108 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
801020cf:	83 ec 0c             	sub    $0xc,%esp
801020d2:	50                   	push   %eax
801020d3:	e8 88 3b 00 00       	call   80105c60 <strlen>
801020d8:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
801020da:	58                   	pop    %eax
801020db:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
801020de:	83 eb 01             	sub    $0x1,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
801020e1:	ff 34 b8             	push   (%eax,%edi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
801020e4:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
801020e7:	e8 74 3b 00 00       	call   80105c60 <strlen>
801020ec:	83 c0 01             	add    $0x1,%eax
801020ef:	50                   	push   %eax
801020f0:	8b 45 0c             	mov    0xc(%ebp),%eax
801020f3:	ff 34 b8             	push   (%eax,%edi,4)
801020f6:	53                   	push   %ebx
801020f7:	56                   	push   %esi
801020f8:	e8 b3 63 00 00       	call   801084b0 <copyout>
801020fd:	83 c4 20             	add    $0x20,%esp
80102100:	85 c0                	test   %eax,%eax
80102102:	79 ac                	jns    801020b0 <exec+0x200>
80102104:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80102108:	83 ec 0c             	sub    $0xc,%esp
8010210b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80102111:	e8 aa 60 00 00       	call   801081c0 <freevm>
80102116:	83 c4 10             	add    $0x10,%esp
  return -1;
80102119:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010211e:	e9 f9 fd ff ff       	jmp    80101f1c <exec+0x6c>
80102123:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80102129:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80102130:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80102132:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80102139:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010213d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
8010213f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80102142:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80102148:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
8010214a:	50                   	push   %eax
8010214b:	52                   	push   %edx
8010214c:	53                   	push   %ebx
8010214d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80102153:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
8010215a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010215d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80102163:	e8 48 63 00 00       	call   801084b0 <copyout>
80102168:	83 c4 10             	add    $0x10,%esp
8010216b:	85 c0                	test   %eax,%eax
8010216d:	78 99                	js     80102108 <exec+0x258>
  for(last=s=path; *s; s++)
8010216f:	8b 45 08             	mov    0x8(%ebp),%eax
80102172:	8b 55 08             	mov    0x8(%ebp),%edx
80102175:	0f b6 00             	movzbl (%eax),%eax
80102178:	84 c0                	test   %al,%al
8010217a:	74 13                	je     8010218f <exec+0x2df>
8010217c:	89 d1                	mov    %edx,%ecx
8010217e:	66 90                	xchg   %ax,%ax
      last = s+1;
80102180:	83 c1 01             	add    $0x1,%ecx
80102183:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80102185:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80102188:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
8010218b:	84 c0                	test   %al,%al
8010218d:	75 f1                	jne    80102180 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
8010218f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80102195:	83 ec 04             	sub    $0x4,%esp
80102198:	6a 10                	push   $0x10
8010219a:	89 f8                	mov    %edi,%eax
8010219c:	52                   	push   %edx
8010219d:	83 c0 6c             	add    $0x6c,%eax
801021a0:	50                   	push   %eax
801021a1:	e8 7a 3a 00 00       	call   80105c20 <safestrcpy>
  curproc->pgdir = pgdir;
801021a6:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
801021ac:	89 f8                	mov    %edi,%eax
801021ae:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
801021b1:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
801021b3:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
801021b6:	89 c1                	mov    %eax,%ecx
801021b8:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
801021be:	8b 40 18             	mov    0x18(%eax),%eax
801021c1:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
801021c4:	8b 41 18             	mov    0x18(%ecx),%eax
801021c7:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
801021ca:	89 0c 24             	mov    %ecx,(%esp)
801021cd:	e8 0e 5c 00 00       	call   80107de0 <switchuvm>
  freevm(oldpgdir);
801021d2:	89 3c 24             	mov    %edi,(%esp)
801021d5:	e8 e6 5f 00 00       	call   801081c0 <freevm>
  return 0;
801021da:	83 c4 10             	add    $0x10,%esp
801021dd:	31 c0                	xor    %eax,%eax
801021df:	e9 38 fd ff ff       	jmp    80101f1c <exec+0x6c>
    end_op();
801021e4:	e8 e7 1f 00 00       	call   801041d0 <end_op>
    cprintf("exec: fail\n");
801021e9:	83 ec 0c             	sub    $0xc,%esp
801021ec:	68 74 86 10 80       	push   $0x80108674
801021f1:	e8 0a e5 ff ff       	call   80100700 <cprintf>
    return -1;
801021f6:	83 c4 10             	add    $0x10,%esp
801021f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021fe:	e9 19 fd ff ff       	jmp    80101f1c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80102203:	be 00 20 00 00       	mov    $0x2000,%esi
80102208:	31 ff                	xor    %edi,%edi
8010220a:	e9 39 fe ff ff       	jmp    80102048 <exec+0x198>
8010220f:	90                   	nop

80102210 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80102210:	55                   	push   %ebp
80102211:	89 e5                	mov    %esp,%ebp
80102213:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80102216:	68 80 86 10 80       	push   $0x80108680
8010221b:	68 e0 06 11 80       	push   $0x801106e0
80102220:	e8 ab 35 00 00       	call   801057d0 <initlock>
}
80102225:	83 c4 10             	add    $0x10,%esp
80102228:	c9                   	leave  
80102229:	c3                   	ret    
8010222a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102230 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80102230:	55                   	push   %ebp
80102231:	89 e5                	mov    %esp,%ebp
80102233:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80102234:	bb 14 07 11 80       	mov    $0x80110714,%ebx
{
80102239:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
8010223c:	68 e0 06 11 80       	push   $0x801106e0
80102241:	e8 5a 37 00 00       	call   801059a0 <acquire>
80102246:	83 c4 10             	add    $0x10,%esp
80102249:	eb 10                	jmp    8010225b <filealloc+0x2b>
8010224b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010224f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80102250:	83 c3 18             	add    $0x18,%ebx
80102253:	81 fb 74 10 11 80    	cmp    $0x80111074,%ebx
80102259:	74 25                	je     80102280 <filealloc+0x50>
    if(f->ref == 0){
8010225b:	8b 43 04             	mov    0x4(%ebx),%eax
8010225e:	85 c0                	test   %eax,%eax
80102260:	75 ee                	jne    80102250 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80102262:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80102265:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
8010226c:	68 e0 06 11 80       	push   $0x801106e0
80102271:	e8 ca 36 00 00       	call   80105940 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80102276:	89 d8                	mov    %ebx,%eax
      return f;
80102278:	83 c4 10             	add    $0x10,%esp
}
8010227b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010227e:	c9                   	leave  
8010227f:	c3                   	ret    
  release(&ftable.lock);
80102280:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80102283:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80102285:	68 e0 06 11 80       	push   $0x801106e0
8010228a:	e8 b1 36 00 00       	call   80105940 <release>
}
8010228f:	89 d8                	mov    %ebx,%eax
  return 0;
80102291:	83 c4 10             	add    $0x10,%esp
}
80102294:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102297:	c9                   	leave  
80102298:	c3                   	ret    
80102299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801022a0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
801022a0:	55                   	push   %ebp
801022a1:	89 e5                	mov    %esp,%ebp
801022a3:	53                   	push   %ebx
801022a4:	83 ec 10             	sub    $0x10,%esp
801022a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
801022aa:	68 e0 06 11 80       	push   $0x801106e0
801022af:	e8 ec 36 00 00       	call   801059a0 <acquire>
  if(f->ref < 1)
801022b4:	8b 43 04             	mov    0x4(%ebx),%eax
801022b7:	83 c4 10             	add    $0x10,%esp
801022ba:	85 c0                	test   %eax,%eax
801022bc:	7e 1a                	jle    801022d8 <filedup+0x38>
    panic("filedup");
  f->ref++;
801022be:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
801022c1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
801022c4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
801022c7:	68 e0 06 11 80       	push   $0x801106e0
801022cc:	e8 6f 36 00 00       	call   80105940 <release>
  return f;
}
801022d1:	89 d8                	mov    %ebx,%eax
801022d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801022d6:	c9                   	leave  
801022d7:	c3                   	ret    
    panic("filedup");
801022d8:	83 ec 0c             	sub    $0xc,%esp
801022db:	68 87 86 10 80       	push   $0x80108687
801022e0:	e8 9b e0 ff ff       	call   80100380 <panic>
801022e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801022f0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
801022f0:	55                   	push   %ebp
801022f1:	89 e5                	mov    %esp,%ebp
801022f3:	57                   	push   %edi
801022f4:	56                   	push   %esi
801022f5:	53                   	push   %ebx
801022f6:	83 ec 28             	sub    $0x28,%esp
801022f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
801022fc:	68 e0 06 11 80       	push   $0x801106e0
80102301:	e8 9a 36 00 00       	call   801059a0 <acquire>
  if(f->ref < 1)
80102306:	8b 53 04             	mov    0x4(%ebx),%edx
80102309:	83 c4 10             	add    $0x10,%esp
8010230c:	85 d2                	test   %edx,%edx
8010230e:	0f 8e a5 00 00 00    	jle    801023b9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80102314:	83 ea 01             	sub    $0x1,%edx
80102317:	89 53 04             	mov    %edx,0x4(%ebx)
8010231a:	75 44                	jne    80102360 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
8010231c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80102320:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80102323:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80102325:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
8010232b:	8b 73 0c             	mov    0xc(%ebx),%esi
8010232e:	88 45 e7             	mov    %al,-0x19(%ebp)
80102331:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80102334:	68 e0 06 11 80       	push   $0x801106e0
  ff = *f;
80102339:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
8010233c:	e8 ff 35 00 00       	call   80105940 <release>

  if(ff.type == FD_PIPE)
80102341:	83 c4 10             	add    $0x10,%esp
80102344:	83 ff 01             	cmp    $0x1,%edi
80102347:	74 57                	je     801023a0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80102349:	83 ff 02             	cmp    $0x2,%edi
8010234c:	74 2a                	je     80102378 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
8010234e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102351:	5b                   	pop    %ebx
80102352:	5e                   	pop    %esi
80102353:	5f                   	pop    %edi
80102354:	5d                   	pop    %ebp
80102355:	c3                   	ret    
80102356:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010235d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80102360:	c7 45 08 e0 06 11 80 	movl   $0x801106e0,0x8(%ebp)
}
80102367:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010236a:	5b                   	pop    %ebx
8010236b:	5e                   	pop    %esi
8010236c:	5f                   	pop    %edi
8010236d:	5d                   	pop    %ebp
    release(&ftable.lock);
8010236e:	e9 cd 35 00 00       	jmp    80105940 <release>
80102373:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102377:	90                   	nop
    begin_op();
80102378:	e8 e3 1d 00 00       	call   80104160 <begin_op>
    iput(ff.ip);
8010237d:	83 ec 0c             	sub    $0xc,%esp
80102380:	ff 75 e0             	push   -0x20(%ebp)
80102383:	e8 28 09 00 00       	call   80102cb0 <iput>
    end_op();
80102388:	83 c4 10             	add    $0x10,%esp
}
8010238b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010238e:	5b                   	pop    %ebx
8010238f:	5e                   	pop    %esi
80102390:	5f                   	pop    %edi
80102391:	5d                   	pop    %ebp
    end_op();
80102392:	e9 39 1e 00 00       	jmp    801041d0 <end_op>
80102397:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010239e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
801023a0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
801023a4:	83 ec 08             	sub    $0x8,%esp
801023a7:	53                   	push   %ebx
801023a8:	56                   	push   %esi
801023a9:	e8 82 25 00 00       	call   80104930 <pipeclose>
801023ae:	83 c4 10             	add    $0x10,%esp
}
801023b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801023b4:	5b                   	pop    %ebx
801023b5:	5e                   	pop    %esi
801023b6:	5f                   	pop    %edi
801023b7:	5d                   	pop    %ebp
801023b8:	c3                   	ret    
    panic("fileclose");
801023b9:	83 ec 0c             	sub    $0xc,%esp
801023bc:	68 8f 86 10 80       	push   $0x8010868f
801023c1:	e8 ba df ff ff       	call   80100380 <panic>
801023c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023cd:	8d 76 00             	lea    0x0(%esi),%esi

801023d0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801023d0:	55                   	push   %ebp
801023d1:	89 e5                	mov    %esp,%ebp
801023d3:	53                   	push   %ebx
801023d4:	83 ec 04             	sub    $0x4,%esp
801023d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
801023da:	83 3b 02             	cmpl   $0x2,(%ebx)
801023dd:	75 31                	jne    80102410 <filestat+0x40>
    ilock(f->ip);
801023df:	83 ec 0c             	sub    $0xc,%esp
801023e2:	ff 73 10             	push   0x10(%ebx)
801023e5:	e8 96 07 00 00       	call   80102b80 <ilock>
    stati(f->ip, st);
801023ea:	58                   	pop    %eax
801023eb:	5a                   	pop    %edx
801023ec:	ff 75 0c             	push   0xc(%ebp)
801023ef:	ff 73 10             	push   0x10(%ebx)
801023f2:	e8 69 0a 00 00       	call   80102e60 <stati>
    iunlock(f->ip);
801023f7:	59                   	pop    %ecx
801023f8:	ff 73 10             	push   0x10(%ebx)
801023fb:	e8 60 08 00 00       	call   80102c60 <iunlock>
    return 0;
  }
  return -1;
}
80102400:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80102403:	83 c4 10             	add    $0x10,%esp
80102406:	31 c0                	xor    %eax,%eax
}
80102408:	c9                   	leave  
80102409:	c3                   	ret    
8010240a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102410:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80102413:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102418:	c9                   	leave  
80102419:	c3                   	ret    
8010241a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102420 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80102420:	55                   	push   %ebp
80102421:	89 e5                	mov    %esp,%ebp
80102423:	57                   	push   %edi
80102424:	56                   	push   %esi
80102425:	53                   	push   %ebx
80102426:	83 ec 0c             	sub    $0xc,%esp
80102429:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010242c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010242f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80102432:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80102436:	74 60                	je     80102498 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80102438:	8b 03                	mov    (%ebx),%eax
8010243a:	83 f8 01             	cmp    $0x1,%eax
8010243d:	74 41                	je     80102480 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010243f:	83 f8 02             	cmp    $0x2,%eax
80102442:	75 5b                	jne    8010249f <fileread+0x7f>
    ilock(f->ip);
80102444:	83 ec 0c             	sub    $0xc,%esp
80102447:	ff 73 10             	push   0x10(%ebx)
8010244a:	e8 31 07 00 00       	call   80102b80 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010244f:	57                   	push   %edi
80102450:	ff 73 14             	push   0x14(%ebx)
80102453:	56                   	push   %esi
80102454:	ff 73 10             	push   0x10(%ebx)
80102457:	e8 34 0a 00 00       	call   80102e90 <readi>
8010245c:	83 c4 20             	add    $0x20,%esp
8010245f:	89 c6                	mov    %eax,%esi
80102461:	85 c0                	test   %eax,%eax
80102463:	7e 03                	jle    80102468 <fileread+0x48>
      f->off += r;
80102465:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80102468:	83 ec 0c             	sub    $0xc,%esp
8010246b:	ff 73 10             	push   0x10(%ebx)
8010246e:	e8 ed 07 00 00       	call   80102c60 <iunlock>
    return r;
80102473:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80102476:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102479:	89 f0                	mov    %esi,%eax
8010247b:	5b                   	pop    %ebx
8010247c:	5e                   	pop    %esi
8010247d:	5f                   	pop    %edi
8010247e:	5d                   	pop    %ebp
8010247f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80102480:	8b 43 0c             	mov    0xc(%ebx),%eax
80102483:	89 45 08             	mov    %eax,0x8(%ebp)
}
80102486:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102489:	5b                   	pop    %ebx
8010248a:	5e                   	pop    %esi
8010248b:	5f                   	pop    %edi
8010248c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010248d:	e9 3e 26 00 00       	jmp    80104ad0 <piperead>
80102492:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80102498:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010249d:	eb d7                	jmp    80102476 <fileread+0x56>
  panic("fileread");
8010249f:	83 ec 0c             	sub    $0xc,%esp
801024a2:	68 99 86 10 80       	push   $0x80108699
801024a7:	e8 d4 de ff ff       	call   80100380 <panic>
801024ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801024b0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801024b0:	55                   	push   %ebp
801024b1:	89 e5                	mov    %esp,%ebp
801024b3:	57                   	push   %edi
801024b4:	56                   	push   %esi
801024b5:	53                   	push   %ebx
801024b6:	83 ec 1c             	sub    $0x1c,%esp
801024b9:	8b 45 0c             	mov    0xc(%ebp),%eax
801024bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
801024bf:	89 45 dc             	mov    %eax,-0x24(%ebp)
801024c2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801024c5:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
801024c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801024cc:	0f 84 bd 00 00 00    	je     8010258f <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
801024d2:	8b 03                	mov    (%ebx),%eax
801024d4:	83 f8 01             	cmp    $0x1,%eax
801024d7:	0f 84 bf 00 00 00    	je     8010259c <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801024dd:	83 f8 02             	cmp    $0x2,%eax
801024e0:	0f 85 c8 00 00 00    	jne    801025ae <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801024e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801024e9:	31 f6                	xor    %esi,%esi
    while(i < n){
801024eb:	85 c0                	test   %eax,%eax
801024ed:	7f 30                	jg     8010251f <filewrite+0x6f>
801024ef:	e9 94 00 00 00       	jmp    80102588 <filewrite+0xd8>
801024f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801024f8:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
801024fb:	83 ec 0c             	sub    $0xc,%esp
801024fe:	ff 73 10             	push   0x10(%ebx)
        f->off += r;
80102501:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80102504:	e8 57 07 00 00       	call   80102c60 <iunlock>
      end_op();
80102509:	e8 c2 1c 00 00       	call   801041d0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010250e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102511:	83 c4 10             	add    $0x10,%esp
80102514:	39 c7                	cmp    %eax,%edi
80102516:	75 5c                	jne    80102574 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80102518:	01 fe                	add    %edi,%esi
    while(i < n){
8010251a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010251d:	7e 69                	jle    80102588 <filewrite+0xd8>
      int n1 = n - i;
8010251f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80102522:	b8 00 06 00 00       	mov    $0x600,%eax
80102527:	29 f7                	sub    %esi,%edi
80102529:	39 c7                	cmp    %eax,%edi
8010252b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010252e:	e8 2d 1c 00 00       	call   80104160 <begin_op>
      ilock(f->ip);
80102533:	83 ec 0c             	sub    $0xc,%esp
80102536:	ff 73 10             	push   0x10(%ebx)
80102539:	e8 42 06 00 00       	call   80102b80 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010253e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80102541:	57                   	push   %edi
80102542:	ff 73 14             	push   0x14(%ebx)
80102545:	01 f0                	add    %esi,%eax
80102547:	50                   	push   %eax
80102548:	ff 73 10             	push   0x10(%ebx)
8010254b:	e8 40 0a 00 00       	call   80102f90 <writei>
80102550:	83 c4 20             	add    $0x20,%esp
80102553:	85 c0                	test   %eax,%eax
80102555:	7f a1                	jg     801024f8 <filewrite+0x48>
      iunlock(f->ip);
80102557:	83 ec 0c             	sub    $0xc,%esp
8010255a:	ff 73 10             	push   0x10(%ebx)
8010255d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80102560:	e8 fb 06 00 00       	call   80102c60 <iunlock>
      end_op();
80102565:	e8 66 1c 00 00       	call   801041d0 <end_op>
      if(r < 0)
8010256a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010256d:	83 c4 10             	add    $0x10,%esp
80102570:	85 c0                	test   %eax,%eax
80102572:	75 1b                	jne    8010258f <filewrite+0xdf>
        panic("short filewrite");
80102574:	83 ec 0c             	sub    $0xc,%esp
80102577:	68 a2 86 10 80       	push   $0x801086a2
8010257c:	e8 ff dd ff ff       	call   80100380 <panic>
80102581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
80102588:	89 f0                	mov    %esi,%eax
8010258a:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
8010258d:	74 05                	je     80102594 <filewrite+0xe4>
8010258f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80102594:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102597:	5b                   	pop    %ebx
80102598:	5e                   	pop    %esi
80102599:	5f                   	pop    %edi
8010259a:	5d                   	pop    %ebp
8010259b:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
8010259c:	8b 43 0c             	mov    0xc(%ebx),%eax
8010259f:	89 45 08             	mov    %eax,0x8(%ebp)
}
801025a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801025a5:	5b                   	pop    %ebx
801025a6:	5e                   	pop    %esi
801025a7:	5f                   	pop    %edi
801025a8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801025a9:	e9 22 24 00 00       	jmp    801049d0 <pipewrite>
  panic("filewrite");
801025ae:	83 ec 0c             	sub    $0xc,%esp
801025b1:	68 a8 86 10 80       	push   $0x801086a8
801025b6:	e8 c5 dd ff ff       	call   80100380 <panic>
801025bb:	66 90                	xchg   %ax,%ax
801025bd:	66 90                	xchg   %ax,%ax
801025bf:	90                   	nop

801025c0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801025c0:	55                   	push   %ebp
801025c1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801025c3:	89 d0                	mov    %edx,%eax
801025c5:	c1 e8 0c             	shr    $0xc,%eax
801025c8:	03 05 4c 2d 11 80    	add    0x80112d4c,%eax
{
801025ce:	89 e5                	mov    %esp,%ebp
801025d0:	56                   	push   %esi
801025d1:	53                   	push   %ebx
801025d2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801025d4:	83 ec 08             	sub    $0x8,%esp
801025d7:	50                   	push   %eax
801025d8:	51                   	push   %ecx
801025d9:	e8 f2 da ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801025de:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801025e0:	c1 fb 03             	sar    $0x3,%ebx
801025e3:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801025e6:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
801025e8:	83 e1 07             	and    $0x7,%ecx
801025eb:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
801025f0:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
801025f6:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
801025f8:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
801025fd:	85 c1                	test   %eax,%ecx
801025ff:	74 23                	je     80102624 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80102601:	f7 d0                	not    %eax
  log_write(bp);
80102603:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80102606:	21 c8                	and    %ecx,%eax
80102608:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010260c:	56                   	push   %esi
8010260d:	e8 2e 1d 00 00       	call   80104340 <log_write>
  brelse(bp);
80102612:	89 34 24             	mov    %esi,(%esp)
80102615:	e8 d6 db ff ff       	call   801001f0 <brelse>
}
8010261a:	83 c4 10             	add    $0x10,%esp
8010261d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102620:	5b                   	pop    %ebx
80102621:	5e                   	pop    %esi
80102622:	5d                   	pop    %ebp
80102623:	c3                   	ret    
    panic("freeing free block");
80102624:	83 ec 0c             	sub    $0xc,%esp
80102627:	68 b2 86 10 80       	push   $0x801086b2
8010262c:	e8 4f dd ff ff       	call   80100380 <panic>
80102631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102638:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010263f:	90                   	nop

80102640 <balloc>:
{
80102640:	55                   	push   %ebp
80102641:	89 e5                	mov    %esp,%ebp
80102643:	57                   	push   %edi
80102644:	56                   	push   %esi
80102645:	53                   	push   %ebx
80102646:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80102649:	8b 0d 34 2d 11 80    	mov    0x80112d34,%ecx
{
8010264f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80102652:	85 c9                	test   %ecx,%ecx
80102654:	0f 84 87 00 00 00    	je     801026e1 <balloc+0xa1>
8010265a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80102661:	8b 75 dc             	mov    -0x24(%ebp),%esi
80102664:	83 ec 08             	sub    $0x8,%esp
80102667:	89 f0                	mov    %esi,%eax
80102669:	c1 f8 0c             	sar    $0xc,%eax
8010266c:	03 05 4c 2d 11 80    	add    0x80112d4c,%eax
80102672:	50                   	push   %eax
80102673:	ff 75 d8             	push   -0x28(%ebp)
80102676:	e8 55 da ff ff       	call   801000d0 <bread>
8010267b:	83 c4 10             	add    $0x10,%esp
8010267e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80102681:	a1 34 2d 11 80       	mov    0x80112d34,%eax
80102686:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102689:	31 c0                	xor    %eax,%eax
8010268b:	eb 2f                	jmp    801026bc <balloc+0x7c>
8010268d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80102690:	89 c1                	mov    %eax,%ecx
80102692:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80102697:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010269a:	83 e1 07             	and    $0x7,%ecx
8010269d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010269f:	89 c1                	mov    %eax,%ecx
801026a1:	c1 f9 03             	sar    $0x3,%ecx
801026a4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801026a9:	89 fa                	mov    %edi,%edx
801026ab:	85 df                	test   %ebx,%edi
801026ad:	74 41                	je     801026f0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801026af:	83 c0 01             	add    $0x1,%eax
801026b2:	83 c6 01             	add    $0x1,%esi
801026b5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801026ba:	74 05                	je     801026c1 <balloc+0x81>
801026bc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801026bf:	77 cf                	ja     80102690 <balloc+0x50>
    brelse(bp);
801026c1:	83 ec 0c             	sub    $0xc,%esp
801026c4:	ff 75 e4             	push   -0x1c(%ebp)
801026c7:	e8 24 db ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801026cc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801026d3:	83 c4 10             	add    $0x10,%esp
801026d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801026d9:	39 05 34 2d 11 80    	cmp    %eax,0x80112d34
801026df:	77 80                	ja     80102661 <balloc+0x21>
  panic("balloc: out of blocks");
801026e1:	83 ec 0c             	sub    $0xc,%esp
801026e4:	68 c5 86 10 80       	push   $0x801086c5
801026e9:	e8 92 dc ff ff       	call   80100380 <panic>
801026ee:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801026f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801026f3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801026f6:	09 da                	or     %ebx,%edx
801026f8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801026fc:	57                   	push   %edi
801026fd:	e8 3e 1c 00 00       	call   80104340 <log_write>
        brelse(bp);
80102702:	89 3c 24             	mov    %edi,(%esp)
80102705:	e8 e6 da ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010270a:	58                   	pop    %eax
8010270b:	5a                   	pop    %edx
8010270c:	56                   	push   %esi
8010270d:	ff 75 d8             	push   -0x28(%ebp)
80102710:	e8 bb d9 ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80102715:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80102718:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010271a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010271d:	68 00 02 00 00       	push   $0x200
80102722:	6a 00                	push   $0x0
80102724:	50                   	push   %eax
80102725:	e8 36 33 00 00       	call   80105a60 <memset>
  log_write(bp);
8010272a:	89 1c 24             	mov    %ebx,(%esp)
8010272d:	e8 0e 1c 00 00       	call   80104340 <log_write>
  brelse(bp);
80102732:	89 1c 24             	mov    %ebx,(%esp)
80102735:	e8 b6 da ff ff       	call   801001f0 <brelse>
}
8010273a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010273d:	89 f0                	mov    %esi,%eax
8010273f:	5b                   	pop    %ebx
80102740:	5e                   	pop    %esi
80102741:	5f                   	pop    %edi
80102742:	5d                   	pop    %ebp
80102743:	c3                   	ret    
80102744:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010274b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010274f:	90                   	nop

80102750 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80102750:	55                   	push   %ebp
80102751:	89 e5                	mov    %esp,%ebp
80102753:	57                   	push   %edi
80102754:	89 c7                	mov    %eax,%edi
80102756:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80102757:	31 f6                	xor    %esi,%esi
{
80102759:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010275a:	bb 14 11 11 80       	mov    $0x80111114,%ebx
{
8010275f:	83 ec 28             	sub    $0x28,%esp
80102762:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80102765:	68 e0 10 11 80       	push   $0x801110e0
8010276a:	e8 31 32 00 00       	call   801059a0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010276f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80102772:	83 c4 10             	add    $0x10,%esp
80102775:	eb 1b                	jmp    80102792 <iget+0x42>
80102777:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010277e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80102780:	39 3b                	cmp    %edi,(%ebx)
80102782:	74 6c                	je     801027f0 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80102784:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010278a:	81 fb 34 2d 11 80    	cmp    $0x80112d34,%ebx
80102790:	73 26                	jae    801027b8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80102792:	8b 43 08             	mov    0x8(%ebx),%eax
80102795:	85 c0                	test   %eax,%eax
80102797:	7f e7                	jg     80102780 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80102799:	85 f6                	test   %esi,%esi
8010279b:	75 e7                	jne    80102784 <iget+0x34>
8010279d:	85 c0                	test   %eax,%eax
8010279f:	75 76                	jne    80102817 <iget+0xc7>
801027a1:	89 de                	mov    %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801027a3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801027a9:	81 fb 34 2d 11 80    	cmp    $0x80112d34,%ebx
801027af:	72 e1                	jb     80102792 <iget+0x42>
801027b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801027b8:	85 f6                	test   %esi,%esi
801027ba:	74 79                	je     80102835 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801027bc:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801027bf:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801027c1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801027c4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801027cb:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801027d2:	68 e0 10 11 80       	push   $0x801110e0
801027d7:	e8 64 31 00 00       	call   80105940 <release>

  return ip;
801027dc:	83 c4 10             	add    $0x10,%esp
}
801027df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801027e2:	89 f0                	mov    %esi,%eax
801027e4:	5b                   	pop    %ebx
801027e5:	5e                   	pop    %esi
801027e6:	5f                   	pop    %edi
801027e7:	5d                   	pop    %ebp
801027e8:	c3                   	ret    
801027e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801027f0:	39 53 04             	cmp    %edx,0x4(%ebx)
801027f3:	75 8f                	jne    80102784 <iget+0x34>
      release(&icache.lock);
801027f5:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801027f8:	83 c0 01             	add    $0x1,%eax
      return ip;
801027fb:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801027fd:	68 e0 10 11 80       	push   $0x801110e0
      ip->ref++;
80102802:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80102805:	e8 36 31 00 00       	call   80105940 <release>
      return ip;
8010280a:	83 c4 10             	add    $0x10,%esp
}
8010280d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102810:	89 f0                	mov    %esi,%eax
80102812:	5b                   	pop    %ebx
80102813:	5e                   	pop    %esi
80102814:	5f                   	pop    %edi
80102815:	5d                   	pop    %ebp
80102816:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80102817:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010281d:	81 fb 34 2d 11 80    	cmp    $0x80112d34,%ebx
80102823:	73 10                	jae    80102835 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80102825:	8b 43 08             	mov    0x8(%ebx),%eax
80102828:	85 c0                	test   %eax,%eax
8010282a:	0f 8f 50 ff ff ff    	jg     80102780 <iget+0x30>
80102830:	e9 68 ff ff ff       	jmp    8010279d <iget+0x4d>
    panic("iget: no inodes");
80102835:	83 ec 0c             	sub    $0xc,%esp
80102838:	68 db 86 10 80       	push   $0x801086db
8010283d:	e8 3e db ff ff       	call   80100380 <panic>
80102842:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102850 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80102850:	55                   	push   %ebp
80102851:	89 e5                	mov    %esp,%ebp
80102853:	57                   	push   %edi
80102854:	56                   	push   %esi
80102855:	89 c6                	mov    %eax,%esi
80102857:	53                   	push   %ebx
80102858:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010285b:	83 fa 0b             	cmp    $0xb,%edx
8010285e:	0f 86 8c 00 00 00    	jbe    801028f0 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80102864:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80102867:	83 fb 7f             	cmp    $0x7f,%ebx
8010286a:	0f 87 a2 00 00 00    	ja     80102912 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80102870:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80102876:	85 c0                	test   %eax,%eax
80102878:	74 5e                	je     801028d8 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010287a:	83 ec 08             	sub    $0x8,%esp
8010287d:	50                   	push   %eax
8010287e:	ff 36                	push   (%esi)
80102880:	e8 4b d8 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80102885:	83 c4 10             	add    $0x10,%esp
80102888:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
8010288c:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
8010288e:	8b 3b                	mov    (%ebx),%edi
80102890:	85 ff                	test   %edi,%edi
80102892:	74 1c                	je     801028b0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80102894:	83 ec 0c             	sub    $0xc,%esp
80102897:	52                   	push   %edx
80102898:	e8 53 d9 ff ff       	call   801001f0 <brelse>
8010289d:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801028a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801028a3:	89 f8                	mov    %edi,%eax
801028a5:	5b                   	pop    %ebx
801028a6:	5e                   	pop    %esi
801028a7:	5f                   	pop    %edi
801028a8:	5d                   	pop    %ebp
801028a9:	c3                   	ret    
801028aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801028b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
801028b3:	8b 06                	mov    (%esi),%eax
801028b5:	e8 86 fd ff ff       	call   80102640 <balloc>
      log_write(bp);
801028ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801028bd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801028c0:	89 03                	mov    %eax,(%ebx)
801028c2:	89 c7                	mov    %eax,%edi
      log_write(bp);
801028c4:	52                   	push   %edx
801028c5:	e8 76 1a 00 00       	call   80104340 <log_write>
801028ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801028cd:	83 c4 10             	add    $0x10,%esp
801028d0:	eb c2                	jmp    80102894 <bmap+0x44>
801028d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801028d8:	8b 06                	mov    (%esi),%eax
801028da:	e8 61 fd ff ff       	call   80102640 <balloc>
801028df:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801028e5:	eb 93                	jmp    8010287a <bmap+0x2a>
801028e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028ee:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
801028f0:	8d 5a 14             	lea    0x14(%edx),%ebx
801028f3:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
801028f7:	85 ff                	test   %edi,%edi
801028f9:	75 a5                	jne    801028a0 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
801028fb:	8b 00                	mov    (%eax),%eax
801028fd:	e8 3e fd ff ff       	call   80102640 <balloc>
80102902:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80102906:	89 c7                	mov    %eax,%edi
}
80102908:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010290b:	5b                   	pop    %ebx
8010290c:	89 f8                	mov    %edi,%eax
8010290e:	5e                   	pop    %esi
8010290f:	5f                   	pop    %edi
80102910:	5d                   	pop    %ebp
80102911:	c3                   	ret    
  panic("bmap: out of range");
80102912:	83 ec 0c             	sub    $0xc,%esp
80102915:	68 eb 86 10 80       	push   $0x801086eb
8010291a:	e8 61 da ff ff       	call   80100380 <panic>
8010291f:	90                   	nop

80102920 <readsb>:
{
80102920:	55                   	push   %ebp
80102921:	89 e5                	mov    %esp,%ebp
80102923:	56                   	push   %esi
80102924:	53                   	push   %ebx
80102925:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80102928:	83 ec 08             	sub    $0x8,%esp
8010292b:	6a 01                	push   $0x1
8010292d:	ff 75 08             	push   0x8(%ebp)
80102930:	e8 9b d7 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80102935:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80102938:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010293a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010293d:	6a 1c                	push   $0x1c
8010293f:	50                   	push   %eax
80102940:	56                   	push   %esi
80102941:	e8 ba 31 00 00       	call   80105b00 <memmove>
  brelse(bp);
80102946:	89 5d 08             	mov    %ebx,0x8(%ebp)
80102949:	83 c4 10             	add    $0x10,%esp
}
8010294c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010294f:	5b                   	pop    %ebx
80102950:	5e                   	pop    %esi
80102951:	5d                   	pop    %ebp
  brelse(bp);
80102952:	e9 99 d8 ff ff       	jmp    801001f0 <brelse>
80102957:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010295e:	66 90                	xchg   %ax,%ax

80102960 <iinit>:
{
80102960:	55                   	push   %ebp
80102961:	89 e5                	mov    %esp,%ebp
80102963:	53                   	push   %ebx
80102964:	bb 20 11 11 80       	mov    $0x80111120,%ebx
80102969:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010296c:	68 fe 86 10 80       	push   $0x801086fe
80102971:	68 e0 10 11 80       	push   $0x801110e0
80102976:	e8 55 2e 00 00       	call   801057d0 <initlock>
  for(i = 0; i < NINODE; i++) {
8010297b:	83 c4 10             	add    $0x10,%esp
8010297e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80102980:	83 ec 08             	sub    $0x8,%esp
80102983:	68 05 87 10 80       	push   $0x80108705
80102988:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80102989:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010298f:	e8 0c 2d 00 00       	call   801056a0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80102994:	83 c4 10             	add    $0x10,%esp
80102997:	81 fb 40 2d 11 80    	cmp    $0x80112d40,%ebx
8010299d:	75 e1                	jne    80102980 <iinit+0x20>
  bp = bread(dev, 1);
8010299f:	83 ec 08             	sub    $0x8,%esp
801029a2:	6a 01                	push   $0x1
801029a4:	ff 75 08             	push   0x8(%ebp)
801029a7:	e8 24 d7 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801029ac:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801029af:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801029b1:	8d 40 5c             	lea    0x5c(%eax),%eax
801029b4:	6a 1c                	push   $0x1c
801029b6:	50                   	push   %eax
801029b7:	68 34 2d 11 80       	push   $0x80112d34
801029bc:	e8 3f 31 00 00       	call   80105b00 <memmove>
  brelse(bp);
801029c1:	89 1c 24             	mov    %ebx,(%esp)
801029c4:	e8 27 d8 ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801029c9:	ff 35 4c 2d 11 80    	push   0x80112d4c
801029cf:	ff 35 48 2d 11 80    	push   0x80112d48
801029d5:	ff 35 44 2d 11 80    	push   0x80112d44
801029db:	ff 35 40 2d 11 80    	push   0x80112d40
801029e1:	ff 35 3c 2d 11 80    	push   0x80112d3c
801029e7:	ff 35 38 2d 11 80    	push   0x80112d38
801029ed:	ff 35 34 2d 11 80    	push   0x80112d34
801029f3:	68 68 87 10 80       	push   $0x80108768
801029f8:	e8 03 dd ff ff       	call   80100700 <cprintf>
}
801029fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a00:	83 c4 30             	add    $0x30,%esp
80102a03:	c9                   	leave  
80102a04:	c3                   	ret    
80102a05:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102a10 <ialloc>:
{
80102a10:	55                   	push   %ebp
80102a11:	89 e5                	mov    %esp,%ebp
80102a13:	57                   	push   %edi
80102a14:	56                   	push   %esi
80102a15:	53                   	push   %ebx
80102a16:	83 ec 1c             	sub    $0x1c,%esp
80102a19:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
80102a1c:	83 3d 3c 2d 11 80 01 	cmpl   $0x1,0x80112d3c
{
80102a23:	8b 75 08             	mov    0x8(%ebp),%esi
80102a26:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80102a29:	0f 86 91 00 00 00    	jbe    80102ac0 <ialloc+0xb0>
80102a2f:	bf 01 00 00 00       	mov    $0x1,%edi
80102a34:	eb 21                	jmp    80102a57 <ialloc+0x47>
80102a36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a3d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80102a40:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80102a43:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80102a46:	53                   	push   %ebx
80102a47:	e8 a4 d7 ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
80102a4c:	83 c4 10             	add    $0x10,%esp
80102a4f:	3b 3d 3c 2d 11 80    	cmp    0x80112d3c,%edi
80102a55:	73 69                	jae    80102ac0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80102a57:	89 f8                	mov    %edi,%eax
80102a59:	83 ec 08             	sub    $0x8,%esp
80102a5c:	c1 e8 03             	shr    $0x3,%eax
80102a5f:	03 05 48 2d 11 80    	add    0x80112d48,%eax
80102a65:	50                   	push   %eax
80102a66:	56                   	push   %esi
80102a67:	e8 64 d6 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
80102a6c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
80102a6f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80102a71:	89 f8                	mov    %edi,%eax
80102a73:	83 e0 07             	and    $0x7,%eax
80102a76:	c1 e0 06             	shl    $0x6,%eax
80102a79:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
80102a7d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80102a81:	75 bd                	jne    80102a40 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80102a83:	83 ec 04             	sub    $0x4,%esp
80102a86:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80102a89:	6a 40                	push   $0x40
80102a8b:	6a 00                	push   $0x0
80102a8d:	51                   	push   %ecx
80102a8e:	e8 cd 2f 00 00       	call   80105a60 <memset>
      dip->type = type;
80102a93:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80102a97:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80102a9a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
80102a9d:	89 1c 24             	mov    %ebx,(%esp)
80102aa0:	e8 9b 18 00 00       	call   80104340 <log_write>
      brelse(bp);
80102aa5:	89 1c 24             	mov    %ebx,(%esp)
80102aa8:	e8 43 d7 ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
80102aad:	83 c4 10             	add    $0x10,%esp
}
80102ab0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80102ab3:	89 fa                	mov    %edi,%edx
}
80102ab5:	5b                   	pop    %ebx
      return iget(dev, inum);
80102ab6:	89 f0                	mov    %esi,%eax
}
80102ab8:	5e                   	pop    %esi
80102ab9:	5f                   	pop    %edi
80102aba:	5d                   	pop    %ebp
      return iget(dev, inum);
80102abb:	e9 90 fc ff ff       	jmp    80102750 <iget>
  panic("ialloc: no inodes");
80102ac0:	83 ec 0c             	sub    $0xc,%esp
80102ac3:	68 0b 87 10 80       	push   $0x8010870b
80102ac8:	e8 b3 d8 ff ff       	call   80100380 <panic>
80102acd:	8d 76 00             	lea    0x0(%esi),%esi

80102ad0 <iupdate>:
{
80102ad0:	55                   	push   %ebp
80102ad1:	89 e5                	mov    %esp,%ebp
80102ad3:	56                   	push   %esi
80102ad4:	53                   	push   %ebx
80102ad5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80102ad8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80102adb:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80102ade:	83 ec 08             	sub    $0x8,%esp
80102ae1:	c1 e8 03             	shr    $0x3,%eax
80102ae4:	03 05 48 2d 11 80    	add    0x80112d48,%eax
80102aea:	50                   	push   %eax
80102aeb:	ff 73 a4             	push   -0x5c(%ebx)
80102aee:	e8 dd d5 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80102af3:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80102af7:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80102afa:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80102afc:	8b 43 a8             	mov    -0x58(%ebx),%eax
80102aff:	83 e0 07             	and    $0x7,%eax
80102b02:	c1 e0 06             	shl    $0x6,%eax
80102b05:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80102b09:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80102b0c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80102b10:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80102b13:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80102b17:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
80102b1b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80102b1f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80102b23:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80102b27:	8b 53 fc             	mov    -0x4(%ebx),%edx
80102b2a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80102b2d:	6a 34                	push   $0x34
80102b2f:	53                   	push   %ebx
80102b30:	50                   	push   %eax
80102b31:	e8 ca 2f 00 00       	call   80105b00 <memmove>
  log_write(bp);
80102b36:	89 34 24             	mov    %esi,(%esp)
80102b39:	e8 02 18 00 00       	call   80104340 <log_write>
  brelse(bp);
80102b3e:	89 75 08             	mov    %esi,0x8(%ebp)
80102b41:	83 c4 10             	add    $0x10,%esp
}
80102b44:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b47:	5b                   	pop    %ebx
80102b48:	5e                   	pop    %esi
80102b49:	5d                   	pop    %ebp
  brelse(bp);
80102b4a:	e9 a1 d6 ff ff       	jmp    801001f0 <brelse>
80102b4f:	90                   	nop

80102b50 <idup>:
{
80102b50:	55                   	push   %ebp
80102b51:	89 e5                	mov    %esp,%ebp
80102b53:	53                   	push   %ebx
80102b54:	83 ec 10             	sub    $0x10,%esp
80102b57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
80102b5a:	68 e0 10 11 80       	push   $0x801110e0
80102b5f:	e8 3c 2e 00 00       	call   801059a0 <acquire>
  ip->ref++;
80102b64:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80102b68:	c7 04 24 e0 10 11 80 	movl   $0x801110e0,(%esp)
80102b6f:	e8 cc 2d 00 00       	call   80105940 <release>
}
80102b74:	89 d8                	mov    %ebx,%eax
80102b76:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b79:	c9                   	leave  
80102b7a:	c3                   	ret    
80102b7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102b7f:	90                   	nop

80102b80 <ilock>:
{
80102b80:	55                   	push   %ebp
80102b81:	89 e5                	mov    %esp,%ebp
80102b83:	56                   	push   %esi
80102b84:	53                   	push   %ebx
80102b85:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80102b88:	85 db                	test   %ebx,%ebx
80102b8a:	0f 84 b7 00 00 00    	je     80102c47 <ilock+0xc7>
80102b90:	8b 53 08             	mov    0x8(%ebx),%edx
80102b93:	85 d2                	test   %edx,%edx
80102b95:	0f 8e ac 00 00 00    	jle    80102c47 <ilock+0xc7>
  acquiresleep(&ip->lock);
80102b9b:	83 ec 0c             	sub    $0xc,%esp
80102b9e:	8d 43 0c             	lea    0xc(%ebx),%eax
80102ba1:	50                   	push   %eax
80102ba2:	e8 39 2b 00 00       	call   801056e0 <acquiresleep>
  if(ip->valid == 0){
80102ba7:	8b 43 4c             	mov    0x4c(%ebx),%eax
80102baa:	83 c4 10             	add    $0x10,%esp
80102bad:	85 c0                	test   %eax,%eax
80102baf:	74 0f                	je     80102bc0 <ilock+0x40>
}
80102bb1:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102bb4:	5b                   	pop    %ebx
80102bb5:	5e                   	pop    %esi
80102bb6:	5d                   	pop    %ebp
80102bb7:	c3                   	ret    
80102bb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102bbf:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80102bc0:	8b 43 04             	mov    0x4(%ebx),%eax
80102bc3:	83 ec 08             	sub    $0x8,%esp
80102bc6:	c1 e8 03             	shr    $0x3,%eax
80102bc9:	03 05 48 2d 11 80    	add    0x80112d48,%eax
80102bcf:	50                   	push   %eax
80102bd0:	ff 33                	push   (%ebx)
80102bd2:	e8 f9 d4 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80102bd7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80102bda:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80102bdc:	8b 43 04             	mov    0x4(%ebx),%eax
80102bdf:	83 e0 07             	and    $0x7,%eax
80102be2:	c1 e0 06             	shl    $0x6,%eax
80102be5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80102be9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80102bec:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
80102bef:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80102bf3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80102bf7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80102bfb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
80102bff:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80102c03:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80102c07:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80102c0b:	8b 50 fc             	mov    -0x4(%eax),%edx
80102c0e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80102c11:	6a 34                	push   $0x34
80102c13:	50                   	push   %eax
80102c14:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102c17:	50                   	push   %eax
80102c18:	e8 e3 2e 00 00       	call   80105b00 <memmove>
    brelse(bp);
80102c1d:	89 34 24             	mov    %esi,(%esp)
80102c20:	e8 cb d5 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80102c25:	83 c4 10             	add    $0x10,%esp
80102c28:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
80102c2d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80102c34:	0f 85 77 ff ff ff    	jne    80102bb1 <ilock+0x31>
      panic("ilock: no type");
80102c3a:	83 ec 0c             	sub    $0xc,%esp
80102c3d:	68 23 87 10 80       	push   $0x80108723
80102c42:	e8 39 d7 ff ff       	call   80100380 <panic>
    panic("ilock");
80102c47:	83 ec 0c             	sub    $0xc,%esp
80102c4a:	68 1d 87 10 80       	push   $0x8010871d
80102c4f:	e8 2c d7 ff ff       	call   80100380 <panic>
80102c54:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c5f:	90                   	nop

80102c60 <iunlock>:
{
80102c60:	55                   	push   %ebp
80102c61:	89 e5                	mov    %esp,%ebp
80102c63:	56                   	push   %esi
80102c64:	53                   	push   %ebx
80102c65:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102c68:	85 db                	test   %ebx,%ebx
80102c6a:	74 28                	je     80102c94 <iunlock+0x34>
80102c6c:	83 ec 0c             	sub    $0xc,%esp
80102c6f:	8d 73 0c             	lea    0xc(%ebx),%esi
80102c72:	56                   	push   %esi
80102c73:	e8 08 2b 00 00       	call   80105780 <holdingsleep>
80102c78:	83 c4 10             	add    $0x10,%esp
80102c7b:	85 c0                	test   %eax,%eax
80102c7d:	74 15                	je     80102c94 <iunlock+0x34>
80102c7f:	8b 43 08             	mov    0x8(%ebx),%eax
80102c82:	85 c0                	test   %eax,%eax
80102c84:	7e 0e                	jle    80102c94 <iunlock+0x34>
  releasesleep(&ip->lock);
80102c86:	89 75 08             	mov    %esi,0x8(%ebp)
}
80102c89:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102c8c:	5b                   	pop    %ebx
80102c8d:	5e                   	pop    %esi
80102c8e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80102c8f:	e9 ac 2a 00 00       	jmp    80105740 <releasesleep>
    panic("iunlock");
80102c94:	83 ec 0c             	sub    $0xc,%esp
80102c97:	68 32 87 10 80       	push   $0x80108732
80102c9c:	e8 df d6 ff ff       	call   80100380 <panic>
80102ca1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ca8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102caf:	90                   	nop

80102cb0 <iput>:
{
80102cb0:	55                   	push   %ebp
80102cb1:	89 e5                	mov    %esp,%ebp
80102cb3:	57                   	push   %edi
80102cb4:	56                   	push   %esi
80102cb5:	53                   	push   %ebx
80102cb6:	83 ec 28             	sub    $0x28,%esp
80102cb9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80102cbc:	8d 7b 0c             	lea    0xc(%ebx),%edi
80102cbf:	57                   	push   %edi
80102cc0:	e8 1b 2a 00 00       	call   801056e0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80102cc5:	8b 53 4c             	mov    0x4c(%ebx),%edx
80102cc8:	83 c4 10             	add    $0x10,%esp
80102ccb:	85 d2                	test   %edx,%edx
80102ccd:	74 07                	je     80102cd6 <iput+0x26>
80102ccf:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80102cd4:	74 32                	je     80102d08 <iput+0x58>
  releasesleep(&ip->lock);
80102cd6:	83 ec 0c             	sub    $0xc,%esp
80102cd9:	57                   	push   %edi
80102cda:	e8 61 2a 00 00       	call   80105740 <releasesleep>
  acquire(&icache.lock);
80102cdf:	c7 04 24 e0 10 11 80 	movl   $0x801110e0,(%esp)
80102ce6:	e8 b5 2c 00 00       	call   801059a0 <acquire>
  ip->ref--;
80102ceb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80102cef:	83 c4 10             	add    $0x10,%esp
80102cf2:	c7 45 08 e0 10 11 80 	movl   $0x801110e0,0x8(%ebp)
}
80102cf9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102cfc:	5b                   	pop    %ebx
80102cfd:	5e                   	pop    %esi
80102cfe:	5f                   	pop    %edi
80102cff:	5d                   	pop    %ebp
  release(&icache.lock);
80102d00:	e9 3b 2c 00 00       	jmp    80105940 <release>
80102d05:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80102d08:	83 ec 0c             	sub    $0xc,%esp
80102d0b:	68 e0 10 11 80       	push   $0x801110e0
80102d10:	e8 8b 2c 00 00       	call   801059a0 <acquire>
    int r = ip->ref;
80102d15:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80102d18:	c7 04 24 e0 10 11 80 	movl   $0x801110e0,(%esp)
80102d1f:	e8 1c 2c 00 00       	call   80105940 <release>
    if(r == 1){
80102d24:	83 c4 10             	add    $0x10,%esp
80102d27:	83 fe 01             	cmp    $0x1,%esi
80102d2a:	75 aa                	jne    80102cd6 <iput+0x26>
80102d2c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80102d32:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80102d35:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102d38:	89 cf                	mov    %ecx,%edi
80102d3a:	eb 0b                	jmp    80102d47 <iput+0x97>
80102d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80102d40:	83 c6 04             	add    $0x4,%esi
80102d43:	39 fe                	cmp    %edi,%esi
80102d45:	74 19                	je     80102d60 <iput+0xb0>
    if(ip->addrs[i]){
80102d47:	8b 16                	mov    (%esi),%edx
80102d49:	85 d2                	test   %edx,%edx
80102d4b:	74 f3                	je     80102d40 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80102d4d:	8b 03                	mov    (%ebx),%eax
80102d4f:	e8 6c f8 ff ff       	call   801025c0 <bfree>
      ip->addrs[i] = 0;
80102d54:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80102d5a:	eb e4                	jmp    80102d40 <iput+0x90>
80102d5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80102d60:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80102d66:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80102d69:	85 c0                	test   %eax,%eax
80102d6b:	75 2d                	jne    80102d9a <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80102d6d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80102d70:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80102d77:	53                   	push   %ebx
80102d78:	e8 53 fd ff ff       	call   80102ad0 <iupdate>
      ip->type = 0;
80102d7d:	31 c0                	xor    %eax,%eax
80102d7f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80102d83:	89 1c 24             	mov    %ebx,(%esp)
80102d86:	e8 45 fd ff ff       	call   80102ad0 <iupdate>
      ip->valid = 0;
80102d8b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80102d92:	83 c4 10             	add    $0x10,%esp
80102d95:	e9 3c ff ff ff       	jmp    80102cd6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80102d9a:	83 ec 08             	sub    $0x8,%esp
80102d9d:	50                   	push   %eax
80102d9e:	ff 33                	push   (%ebx)
80102da0:	e8 2b d3 ff ff       	call   801000d0 <bread>
80102da5:	89 7d e0             	mov    %edi,-0x20(%ebp)
80102da8:	83 c4 10             	add    $0x10,%esp
80102dab:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80102db1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80102db4:	8d 70 5c             	lea    0x5c(%eax),%esi
80102db7:	89 cf                	mov    %ecx,%edi
80102db9:	eb 0c                	jmp    80102dc7 <iput+0x117>
80102dbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102dbf:	90                   	nop
80102dc0:	83 c6 04             	add    $0x4,%esi
80102dc3:	39 f7                	cmp    %esi,%edi
80102dc5:	74 0f                	je     80102dd6 <iput+0x126>
      if(a[j])
80102dc7:	8b 16                	mov    (%esi),%edx
80102dc9:	85 d2                	test   %edx,%edx
80102dcb:	74 f3                	je     80102dc0 <iput+0x110>
        bfree(ip->dev, a[j]);
80102dcd:	8b 03                	mov    (%ebx),%eax
80102dcf:	e8 ec f7 ff ff       	call   801025c0 <bfree>
80102dd4:	eb ea                	jmp    80102dc0 <iput+0x110>
    brelse(bp);
80102dd6:	83 ec 0c             	sub    $0xc,%esp
80102dd9:	ff 75 e4             	push   -0x1c(%ebp)
80102ddc:	8b 7d e0             	mov    -0x20(%ebp),%edi
80102ddf:	e8 0c d4 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80102de4:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80102dea:	8b 03                	mov    (%ebx),%eax
80102dec:	e8 cf f7 ff ff       	call   801025c0 <bfree>
    ip->addrs[NDIRECT] = 0;
80102df1:	83 c4 10             	add    $0x10,%esp
80102df4:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80102dfb:	00 00 00 
80102dfe:	e9 6a ff ff ff       	jmp    80102d6d <iput+0xbd>
80102e03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102e10 <iunlockput>:
{
80102e10:	55                   	push   %ebp
80102e11:	89 e5                	mov    %esp,%ebp
80102e13:	56                   	push   %esi
80102e14:	53                   	push   %ebx
80102e15:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102e18:	85 db                	test   %ebx,%ebx
80102e1a:	74 34                	je     80102e50 <iunlockput+0x40>
80102e1c:	83 ec 0c             	sub    $0xc,%esp
80102e1f:	8d 73 0c             	lea    0xc(%ebx),%esi
80102e22:	56                   	push   %esi
80102e23:	e8 58 29 00 00       	call   80105780 <holdingsleep>
80102e28:	83 c4 10             	add    $0x10,%esp
80102e2b:	85 c0                	test   %eax,%eax
80102e2d:	74 21                	je     80102e50 <iunlockput+0x40>
80102e2f:	8b 43 08             	mov    0x8(%ebx),%eax
80102e32:	85 c0                	test   %eax,%eax
80102e34:	7e 1a                	jle    80102e50 <iunlockput+0x40>
  releasesleep(&ip->lock);
80102e36:	83 ec 0c             	sub    $0xc,%esp
80102e39:	56                   	push   %esi
80102e3a:	e8 01 29 00 00       	call   80105740 <releasesleep>
  iput(ip);
80102e3f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80102e42:	83 c4 10             	add    $0x10,%esp
}
80102e45:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102e48:	5b                   	pop    %ebx
80102e49:	5e                   	pop    %esi
80102e4a:	5d                   	pop    %ebp
  iput(ip);
80102e4b:	e9 60 fe ff ff       	jmp    80102cb0 <iput>
    panic("iunlock");
80102e50:	83 ec 0c             	sub    $0xc,%esp
80102e53:	68 32 87 10 80       	push   $0x80108732
80102e58:	e8 23 d5 ff ff       	call   80100380 <panic>
80102e5d:	8d 76 00             	lea    0x0(%esi),%esi

80102e60 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80102e60:	55                   	push   %ebp
80102e61:	89 e5                	mov    %esp,%ebp
80102e63:	8b 55 08             	mov    0x8(%ebp),%edx
80102e66:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80102e69:	8b 0a                	mov    (%edx),%ecx
80102e6b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80102e6e:	8b 4a 04             	mov    0x4(%edx),%ecx
80102e71:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80102e74:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80102e78:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80102e7b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80102e7f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80102e83:	8b 52 58             	mov    0x58(%edx),%edx
80102e86:	89 50 10             	mov    %edx,0x10(%eax)
}
80102e89:	5d                   	pop    %ebp
80102e8a:	c3                   	ret    
80102e8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e8f:	90                   	nop

80102e90 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80102e90:	55                   	push   %ebp
80102e91:	89 e5                	mov    %esp,%ebp
80102e93:	57                   	push   %edi
80102e94:	56                   	push   %esi
80102e95:	53                   	push   %ebx
80102e96:	83 ec 1c             	sub    $0x1c,%esp
80102e99:	8b 7d 0c             	mov    0xc(%ebp),%edi
80102e9c:	8b 45 08             	mov    0x8(%ebp),%eax
80102e9f:	8b 75 10             	mov    0x10(%ebp),%esi
80102ea2:	89 7d e0             	mov    %edi,-0x20(%ebp)
80102ea5:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80102ea8:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80102ead:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102eb0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80102eb3:	0f 84 a7 00 00 00    	je     80102f60 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80102eb9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102ebc:	8b 40 58             	mov    0x58(%eax),%eax
80102ebf:	39 c6                	cmp    %eax,%esi
80102ec1:	0f 87 ba 00 00 00    	ja     80102f81 <readi+0xf1>
80102ec7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80102eca:	31 c9                	xor    %ecx,%ecx
80102ecc:	89 da                	mov    %ebx,%edx
80102ece:	01 f2                	add    %esi,%edx
80102ed0:	0f 92 c1             	setb   %cl
80102ed3:	89 cf                	mov    %ecx,%edi
80102ed5:	0f 82 a6 00 00 00    	jb     80102f81 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80102edb:	89 c1                	mov    %eax,%ecx
80102edd:	29 f1                	sub    %esi,%ecx
80102edf:	39 d0                	cmp    %edx,%eax
80102ee1:	0f 43 cb             	cmovae %ebx,%ecx
80102ee4:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102ee7:	85 c9                	test   %ecx,%ecx
80102ee9:	74 67                	je     80102f52 <readi+0xc2>
80102eeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102eef:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102ef0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80102ef3:	89 f2                	mov    %esi,%edx
80102ef5:	c1 ea 09             	shr    $0x9,%edx
80102ef8:	89 d8                	mov    %ebx,%eax
80102efa:	e8 51 f9 ff ff       	call   80102850 <bmap>
80102eff:	83 ec 08             	sub    $0x8,%esp
80102f02:	50                   	push   %eax
80102f03:	ff 33                	push   (%ebx)
80102f05:	e8 c6 d1 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80102f0a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80102f0d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102f12:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80102f14:	89 f0                	mov    %esi,%eax
80102f16:	25 ff 01 00 00       	and    $0x1ff,%eax
80102f1b:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80102f1d:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80102f20:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80102f22:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80102f26:	39 d9                	cmp    %ebx,%ecx
80102f28:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80102f2b:	83 c4 0c             	add    $0xc,%esp
80102f2e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102f2f:	01 df                	add    %ebx,%edi
80102f31:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80102f33:	50                   	push   %eax
80102f34:	ff 75 e0             	push   -0x20(%ebp)
80102f37:	e8 c4 2b 00 00       	call   80105b00 <memmove>
    brelse(bp);
80102f3c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80102f3f:	89 14 24             	mov    %edx,(%esp)
80102f42:	e8 a9 d2 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102f47:	01 5d e0             	add    %ebx,-0x20(%ebp)
80102f4a:	83 c4 10             	add    $0x10,%esp
80102f4d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80102f50:	77 9e                	ja     80102ef0 <readi+0x60>
  }
  return n;
80102f52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80102f55:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f58:	5b                   	pop    %ebx
80102f59:	5e                   	pop    %esi
80102f5a:	5f                   	pop    %edi
80102f5b:	5d                   	pop    %ebp
80102f5c:	c3                   	ret    
80102f5d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80102f60:	0f bf 40 52          	movswl 0x52(%eax),%eax
80102f64:	66 83 f8 09          	cmp    $0x9,%ax
80102f68:	77 17                	ja     80102f81 <readi+0xf1>
80102f6a:	8b 04 c5 80 10 11 80 	mov    -0x7feeef80(,%eax,8),%eax
80102f71:	85 c0                	test   %eax,%eax
80102f73:	74 0c                	je     80102f81 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80102f75:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80102f78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f7b:	5b                   	pop    %ebx
80102f7c:	5e                   	pop    %esi
80102f7d:	5f                   	pop    %edi
80102f7e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80102f7f:	ff e0                	jmp    *%eax
      return -1;
80102f81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102f86:	eb cd                	jmp    80102f55 <readi+0xc5>
80102f88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f8f:	90                   	nop

80102f90 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80102f90:	55                   	push   %ebp
80102f91:	89 e5                	mov    %esp,%ebp
80102f93:	57                   	push   %edi
80102f94:	56                   	push   %esi
80102f95:	53                   	push   %ebx
80102f96:	83 ec 1c             	sub    $0x1c,%esp
80102f99:	8b 45 08             	mov    0x8(%ebp),%eax
80102f9c:	8b 75 0c             	mov    0xc(%ebp),%esi
80102f9f:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80102fa2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80102fa7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80102faa:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102fad:	8b 75 10             	mov    0x10(%ebp),%esi
80102fb0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80102fb3:	0f 84 b7 00 00 00    	je     80103070 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80102fb9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102fbc:	3b 70 58             	cmp    0x58(%eax),%esi
80102fbf:	0f 87 e7 00 00 00    	ja     801030ac <writei+0x11c>
80102fc5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80102fc8:	31 d2                	xor    %edx,%edx
80102fca:	89 f8                	mov    %edi,%eax
80102fcc:	01 f0                	add    %esi,%eax
80102fce:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80102fd1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80102fd6:	0f 87 d0 00 00 00    	ja     801030ac <writei+0x11c>
80102fdc:	85 d2                	test   %edx,%edx
80102fde:	0f 85 c8 00 00 00    	jne    801030ac <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102fe4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80102feb:	85 ff                	test   %edi,%edi
80102fed:	74 72                	je     80103061 <writei+0xd1>
80102fef:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102ff0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80102ff3:	89 f2                	mov    %esi,%edx
80102ff5:	c1 ea 09             	shr    $0x9,%edx
80102ff8:	89 f8                	mov    %edi,%eax
80102ffa:	e8 51 f8 ff ff       	call   80102850 <bmap>
80102fff:	83 ec 08             	sub    $0x8,%esp
80103002:	50                   	push   %eax
80103003:	ff 37                	push   (%edi)
80103005:	e8 c6 d0 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
8010300a:	b9 00 02 00 00       	mov    $0x200,%ecx
8010300f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80103012:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80103015:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80103017:	89 f0                	mov    %esi,%eax
80103019:	25 ff 01 00 00       	and    $0x1ff,%eax
8010301e:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80103020:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80103024:	39 d9                	cmp    %ebx,%ecx
80103026:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80103029:	83 c4 0c             	add    $0xc,%esp
8010302c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010302d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
8010302f:	ff 75 dc             	push   -0x24(%ebp)
80103032:	50                   	push   %eax
80103033:	e8 c8 2a 00 00       	call   80105b00 <memmove>
    log_write(bp);
80103038:	89 3c 24             	mov    %edi,(%esp)
8010303b:	e8 00 13 00 00       	call   80104340 <log_write>
    brelse(bp);
80103040:	89 3c 24             	mov    %edi,(%esp)
80103043:	e8 a8 d1 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80103048:	01 5d e4             	add    %ebx,-0x1c(%ebp)
8010304b:	83 c4 10             	add    $0x10,%esp
8010304e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103051:	01 5d dc             	add    %ebx,-0x24(%ebp)
80103054:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80103057:	77 97                	ja     80102ff0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80103059:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010305c:	3b 70 58             	cmp    0x58(%eax),%esi
8010305f:	77 37                	ja     80103098 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80103061:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80103064:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103067:	5b                   	pop    %ebx
80103068:	5e                   	pop    %esi
80103069:	5f                   	pop    %edi
8010306a:	5d                   	pop    %ebp
8010306b:	c3                   	ret    
8010306c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80103070:	0f bf 40 52          	movswl 0x52(%eax),%eax
80103074:	66 83 f8 09          	cmp    $0x9,%ax
80103078:	77 32                	ja     801030ac <writei+0x11c>
8010307a:	8b 04 c5 84 10 11 80 	mov    -0x7feeef7c(,%eax,8),%eax
80103081:	85 c0                	test   %eax,%eax
80103083:	74 27                	je     801030ac <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80103085:	89 55 10             	mov    %edx,0x10(%ebp)
}
80103088:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010308b:	5b                   	pop    %ebx
8010308c:	5e                   	pop    %esi
8010308d:	5f                   	pop    %edi
8010308e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
8010308f:	ff e0                	jmp    *%eax
80103091:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80103098:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
8010309b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
8010309e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
801030a1:	50                   	push   %eax
801030a2:	e8 29 fa ff ff       	call   80102ad0 <iupdate>
801030a7:	83 c4 10             	add    $0x10,%esp
801030aa:	eb b5                	jmp    80103061 <writei+0xd1>
      return -1;
801030ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801030b1:	eb b1                	jmp    80103064 <writei+0xd4>
801030b3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801030c0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
801030c0:	55                   	push   %ebp
801030c1:	89 e5                	mov    %esp,%ebp
801030c3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
801030c6:	6a 0e                	push   $0xe
801030c8:	ff 75 0c             	push   0xc(%ebp)
801030cb:	ff 75 08             	push   0x8(%ebp)
801030ce:	e8 9d 2a 00 00       	call   80105b70 <strncmp>
}
801030d3:	c9                   	leave  
801030d4:	c3                   	ret    
801030d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801030e0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
801030e0:	55                   	push   %ebp
801030e1:	89 e5                	mov    %esp,%ebp
801030e3:	57                   	push   %edi
801030e4:	56                   	push   %esi
801030e5:	53                   	push   %ebx
801030e6:	83 ec 1c             	sub    $0x1c,%esp
801030e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
801030ec:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801030f1:	0f 85 85 00 00 00    	jne    8010317c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
801030f7:	8b 53 58             	mov    0x58(%ebx),%edx
801030fa:	31 ff                	xor    %edi,%edi
801030fc:	8d 75 d8             	lea    -0x28(%ebp),%esi
801030ff:	85 d2                	test   %edx,%edx
80103101:	74 3e                	je     80103141 <dirlookup+0x61>
80103103:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103107:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80103108:	6a 10                	push   $0x10
8010310a:	57                   	push   %edi
8010310b:	56                   	push   %esi
8010310c:	53                   	push   %ebx
8010310d:	e8 7e fd ff ff       	call   80102e90 <readi>
80103112:	83 c4 10             	add    $0x10,%esp
80103115:	83 f8 10             	cmp    $0x10,%eax
80103118:	75 55                	jne    8010316f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
8010311a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010311f:	74 18                	je     80103139 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80103121:	83 ec 04             	sub    $0x4,%esp
80103124:	8d 45 da             	lea    -0x26(%ebp),%eax
80103127:	6a 0e                	push   $0xe
80103129:	50                   	push   %eax
8010312a:	ff 75 0c             	push   0xc(%ebp)
8010312d:	e8 3e 2a 00 00       	call   80105b70 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80103132:	83 c4 10             	add    $0x10,%esp
80103135:	85 c0                	test   %eax,%eax
80103137:	74 17                	je     80103150 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80103139:	83 c7 10             	add    $0x10,%edi
8010313c:	3b 7b 58             	cmp    0x58(%ebx),%edi
8010313f:	72 c7                	jb     80103108 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80103141:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103144:	31 c0                	xor    %eax,%eax
}
80103146:	5b                   	pop    %ebx
80103147:	5e                   	pop    %esi
80103148:	5f                   	pop    %edi
80103149:	5d                   	pop    %ebp
8010314a:	c3                   	ret    
8010314b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010314f:	90                   	nop
      if(poff)
80103150:	8b 45 10             	mov    0x10(%ebp),%eax
80103153:	85 c0                	test   %eax,%eax
80103155:	74 05                	je     8010315c <dirlookup+0x7c>
        *poff = off;
80103157:	8b 45 10             	mov    0x10(%ebp),%eax
8010315a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
8010315c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80103160:	8b 03                	mov    (%ebx),%eax
80103162:	e8 e9 f5 ff ff       	call   80102750 <iget>
}
80103167:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010316a:	5b                   	pop    %ebx
8010316b:	5e                   	pop    %esi
8010316c:	5f                   	pop    %edi
8010316d:	5d                   	pop    %ebp
8010316e:	c3                   	ret    
      panic("dirlookup read");
8010316f:	83 ec 0c             	sub    $0xc,%esp
80103172:	68 4c 87 10 80       	push   $0x8010874c
80103177:	e8 04 d2 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
8010317c:	83 ec 0c             	sub    $0xc,%esp
8010317f:	68 3a 87 10 80       	push   $0x8010873a
80103184:	e8 f7 d1 ff ff       	call   80100380 <panic>
80103189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103190 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80103190:	55                   	push   %ebp
80103191:	89 e5                	mov    %esp,%ebp
80103193:	57                   	push   %edi
80103194:	56                   	push   %esi
80103195:	53                   	push   %ebx
80103196:	89 c3                	mov    %eax,%ebx
80103198:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010319b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
8010319e:	89 55 dc             	mov    %edx,-0x24(%ebp)
801031a1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
801031a4:	0f 84 64 01 00 00    	je     8010330e <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
801031aa:	e8 c1 1b 00 00       	call   80104d70 <myproc>
  acquire(&icache.lock);
801031af:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
801031b2:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
801031b5:	68 e0 10 11 80       	push   $0x801110e0
801031ba:	e8 e1 27 00 00       	call   801059a0 <acquire>
  ip->ref++;
801031bf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
801031c3:	c7 04 24 e0 10 11 80 	movl   $0x801110e0,(%esp)
801031ca:	e8 71 27 00 00       	call   80105940 <release>
801031cf:	83 c4 10             	add    $0x10,%esp
801031d2:	eb 07                	jmp    801031db <namex+0x4b>
801031d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
801031d8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
801031db:	0f b6 03             	movzbl (%ebx),%eax
801031de:	3c 2f                	cmp    $0x2f,%al
801031e0:	74 f6                	je     801031d8 <namex+0x48>
  if(*path == 0)
801031e2:	84 c0                	test   %al,%al
801031e4:	0f 84 06 01 00 00    	je     801032f0 <namex+0x160>
  while(*path != '/' && *path != 0)
801031ea:	0f b6 03             	movzbl (%ebx),%eax
801031ed:	84 c0                	test   %al,%al
801031ef:	0f 84 10 01 00 00    	je     80103305 <namex+0x175>
801031f5:	89 df                	mov    %ebx,%edi
801031f7:	3c 2f                	cmp    $0x2f,%al
801031f9:	0f 84 06 01 00 00    	je     80103305 <namex+0x175>
801031ff:	90                   	nop
80103200:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80103204:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80103207:	3c 2f                	cmp    $0x2f,%al
80103209:	74 04                	je     8010320f <namex+0x7f>
8010320b:	84 c0                	test   %al,%al
8010320d:	75 f1                	jne    80103200 <namex+0x70>
  len = path - s;
8010320f:	89 f8                	mov    %edi,%eax
80103211:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80103213:	83 f8 0d             	cmp    $0xd,%eax
80103216:	0f 8e ac 00 00 00    	jle    801032c8 <namex+0x138>
    memmove(name, s, DIRSIZ);
8010321c:	83 ec 04             	sub    $0x4,%esp
8010321f:	6a 0e                	push   $0xe
80103221:	53                   	push   %ebx
    path++;
80103222:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80103224:	ff 75 e4             	push   -0x1c(%ebp)
80103227:	e8 d4 28 00 00       	call   80105b00 <memmove>
8010322c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
8010322f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80103232:	75 0c                	jne    80103240 <namex+0xb0>
80103234:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80103238:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
8010323b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
8010323e:	74 f8                	je     80103238 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80103240:	83 ec 0c             	sub    $0xc,%esp
80103243:	56                   	push   %esi
80103244:	e8 37 f9 ff ff       	call   80102b80 <ilock>
    if(ip->type != T_DIR){
80103249:	83 c4 10             	add    $0x10,%esp
8010324c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80103251:	0f 85 cd 00 00 00    	jne    80103324 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80103257:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010325a:	85 c0                	test   %eax,%eax
8010325c:	74 09                	je     80103267 <namex+0xd7>
8010325e:	80 3b 00             	cmpb   $0x0,(%ebx)
80103261:	0f 84 22 01 00 00    	je     80103389 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80103267:	83 ec 04             	sub    $0x4,%esp
8010326a:	6a 00                	push   $0x0
8010326c:	ff 75 e4             	push   -0x1c(%ebp)
8010326f:	56                   	push   %esi
80103270:	e8 6b fe ff ff       	call   801030e0 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80103275:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80103278:	83 c4 10             	add    $0x10,%esp
8010327b:	89 c7                	mov    %eax,%edi
8010327d:	85 c0                	test   %eax,%eax
8010327f:	0f 84 e1 00 00 00    	je     80103366 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80103285:	83 ec 0c             	sub    $0xc,%esp
80103288:	89 55 e0             	mov    %edx,-0x20(%ebp)
8010328b:	52                   	push   %edx
8010328c:	e8 ef 24 00 00       	call   80105780 <holdingsleep>
80103291:	83 c4 10             	add    $0x10,%esp
80103294:	85 c0                	test   %eax,%eax
80103296:	0f 84 30 01 00 00    	je     801033cc <namex+0x23c>
8010329c:	8b 56 08             	mov    0x8(%esi),%edx
8010329f:	85 d2                	test   %edx,%edx
801032a1:	0f 8e 25 01 00 00    	jle    801033cc <namex+0x23c>
  releasesleep(&ip->lock);
801032a7:	8b 55 e0             	mov    -0x20(%ebp),%edx
801032aa:	83 ec 0c             	sub    $0xc,%esp
801032ad:	52                   	push   %edx
801032ae:	e8 8d 24 00 00       	call   80105740 <releasesleep>
  iput(ip);
801032b3:	89 34 24             	mov    %esi,(%esp)
801032b6:	89 fe                	mov    %edi,%esi
801032b8:	e8 f3 f9 ff ff       	call   80102cb0 <iput>
801032bd:	83 c4 10             	add    $0x10,%esp
801032c0:	e9 16 ff ff ff       	jmp    801031db <namex+0x4b>
801032c5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
801032c8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801032cb:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
801032ce:	83 ec 04             	sub    $0x4,%esp
801032d1:	89 55 e0             	mov    %edx,-0x20(%ebp)
801032d4:	50                   	push   %eax
801032d5:	53                   	push   %ebx
    name[len] = 0;
801032d6:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
801032d8:	ff 75 e4             	push   -0x1c(%ebp)
801032db:	e8 20 28 00 00       	call   80105b00 <memmove>
    name[len] = 0;
801032e0:	8b 55 e0             	mov    -0x20(%ebp),%edx
801032e3:	83 c4 10             	add    $0x10,%esp
801032e6:	c6 02 00             	movb   $0x0,(%edx)
801032e9:	e9 41 ff ff ff       	jmp    8010322f <namex+0x9f>
801032ee:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
801032f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
801032f3:	85 c0                	test   %eax,%eax
801032f5:	0f 85 be 00 00 00    	jne    801033b9 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
801032fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801032fe:	89 f0                	mov    %esi,%eax
80103300:	5b                   	pop    %ebx
80103301:	5e                   	pop    %esi
80103302:	5f                   	pop    %edi
80103303:	5d                   	pop    %ebp
80103304:	c3                   	ret    
  while(*path != '/' && *path != 0)
80103305:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103308:	89 df                	mov    %ebx,%edi
8010330a:	31 c0                	xor    %eax,%eax
8010330c:	eb c0                	jmp    801032ce <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
8010330e:	ba 01 00 00 00       	mov    $0x1,%edx
80103313:	b8 01 00 00 00       	mov    $0x1,%eax
80103318:	e8 33 f4 ff ff       	call   80102750 <iget>
8010331d:	89 c6                	mov    %eax,%esi
8010331f:	e9 b7 fe ff ff       	jmp    801031db <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80103324:	83 ec 0c             	sub    $0xc,%esp
80103327:	8d 5e 0c             	lea    0xc(%esi),%ebx
8010332a:	53                   	push   %ebx
8010332b:	e8 50 24 00 00       	call   80105780 <holdingsleep>
80103330:	83 c4 10             	add    $0x10,%esp
80103333:	85 c0                	test   %eax,%eax
80103335:	0f 84 91 00 00 00    	je     801033cc <namex+0x23c>
8010333b:	8b 46 08             	mov    0x8(%esi),%eax
8010333e:	85 c0                	test   %eax,%eax
80103340:	0f 8e 86 00 00 00    	jle    801033cc <namex+0x23c>
  releasesleep(&ip->lock);
80103346:	83 ec 0c             	sub    $0xc,%esp
80103349:	53                   	push   %ebx
8010334a:	e8 f1 23 00 00       	call   80105740 <releasesleep>
  iput(ip);
8010334f:	89 34 24             	mov    %esi,(%esp)
      return 0;
80103352:	31 f6                	xor    %esi,%esi
  iput(ip);
80103354:	e8 57 f9 ff ff       	call   80102cb0 <iput>
      return 0;
80103359:	83 c4 10             	add    $0x10,%esp
}
8010335c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010335f:	89 f0                	mov    %esi,%eax
80103361:	5b                   	pop    %ebx
80103362:	5e                   	pop    %esi
80103363:	5f                   	pop    %edi
80103364:	5d                   	pop    %ebp
80103365:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80103366:	83 ec 0c             	sub    $0xc,%esp
80103369:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010336c:	52                   	push   %edx
8010336d:	e8 0e 24 00 00       	call   80105780 <holdingsleep>
80103372:	83 c4 10             	add    $0x10,%esp
80103375:	85 c0                	test   %eax,%eax
80103377:	74 53                	je     801033cc <namex+0x23c>
80103379:	8b 4e 08             	mov    0x8(%esi),%ecx
8010337c:	85 c9                	test   %ecx,%ecx
8010337e:	7e 4c                	jle    801033cc <namex+0x23c>
  releasesleep(&ip->lock);
80103380:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103383:	83 ec 0c             	sub    $0xc,%esp
80103386:	52                   	push   %edx
80103387:	eb c1                	jmp    8010334a <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80103389:	83 ec 0c             	sub    $0xc,%esp
8010338c:	8d 5e 0c             	lea    0xc(%esi),%ebx
8010338f:	53                   	push   %ebx
80103390:	e8 eb 23 00 00       	call   80105780 <holdingsleep>
80103395:	83 c4 10             	add    $0x10,%esp
80103398:	85 c0                	test   %eax,%eax
8010339a:	74 30                	je     801033cc <namex+0x23c>
8010339c:	8b 7e 08             	mov    0x8(%esi),%edi
8010339f:	85 ff                	test   %edi,%edi
801033a1:	7e 29                	jle    801033cc <namex+0x23c>
  releasesleep(&ip->lock);
801033a3:	83 ec 0c             	sub    $0xc,%esp
801033a6:	53                   	push   %ebx
801033a7:	e8 94 23 00 00       	call   80105740 <releasesleep>
}
801033ac:	83 c4 10             	add    $0x10,%esp
}
801033af:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033b2:	89 f0                	mov    %esi,%eax
801033b4:	5b                   	pop    %ebx
801033b5:	5e                   	pop    %esi
801033b6:	5f                   	pop    %edi
801033b7:	5d                   	pop    %ebp
801033b8:	c3                   	ret    
    iput(ip);
801033b9:	83 ec 0c             	sub    $0xc,%esp
801033bc:	56                   	push   %esi
    return 0;
801033bd:	31 f6                	xor    %esi,%esi
    iput(ip);
801033bf:	e8 ec f8 ff ff       	call   80102cb0 <iput>
    return 0;
801033c4:	83 c4 10             	add    $0x10,%esp
801033c7:	e9 2f ff ff ff       	jmp    801032fb <namex+0x16b>
    panic("iunlock");
801033cc:	83 ec 0c             	sub    $0xc,%esp
801033cf:	68 32 87 10 80       	push   $0x80108732
801033d4:	e8 a7 cf ff ff       	call   80100380 <panic>
801033d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801033e0 <dirlink>:
{
801033e0:	55                   	push   %ebp
801033e1:	89 e5                	mov    %esp,%ebp
801033e3:	57                   	push   %edi
801033e4:	56                   	push   %esi
801033e5:	53                   	push   %ebx
801033e6:	83 ec 20             	sub    $0x20,%esp
801033e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
801033ec:	6a 00                	push   $0x0
801033ee:	ff 75 0c             	push   0xc(%ebp)
801033f1:	53                   	push   %ebx
801033f2:	e8 e9 fc ff ff       	call   801030e0 <dirlookup>
801033f7:	83 c4 10             	add    $0x10,%esp
801033fa:	85 c0                	test   %eax,%eax
801033fc:	75 67                	jne    80103465 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
801033fe:	8b 7b 58             	mov    0x58(%ebx),%edi
80103401:	8d 75 d8             	lea    -0x28(%ebp),%esi
80103404:	85 ff                	test   %edi,%edi
80103406:	74 29                	je     80103431 <dirlink+0x51>
80103408:	31 ff                	xor    %edi,%edi
8010340a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010340d:	eb 09                	jmp    80103418 <dirlink+0x38>
8010340f:	90                   	nop
80103410:	83 c7 10             	add    $0x10,%edi
80103413:	3b 7b 58             	cmp    0x58(%ebx),%edi
80103416:	73 19                	jae    80103431 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80103418:	6a 10                	push   $0x10
8010341a:	57                   	push   %edi
8010341b:	56                   	push   %esi
8010341c:	53                   	push   %ebx
8010341d:	e8 6e fa ff ff       	call   80102e90 <readi>
80103422:	83 c4 10             	add    $0x10,%esp
80103425:	83 f8 10             	cmp    $0x10,%eax
80103428:	75 4e                	jne    80103478 <dirlink+0x98>
    if(de.inum == 0)
8010342a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010342f:	75 df                	jne    80103410 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80103431:	83 ec 04             	sub    $0x4,%esp
80103434:	8d 45 da             	lea    -0x26(%ebp),%eax
80103437:	6a 0e                	push   $0xe
80103439:	ff 75 0c             	push   0xc(%ebp)
8010343c:	50                   	push   %eax
8010343d:	e8 7e 27 00 00       	call   80105bc0 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80103442:	6a 10                	push   $0x10
  de.inum = inum;
80103444:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80103447:	57                   	push   %edi
80103448:	56                   	push   %esi
80103449:	53                   	push   %ebx
  de.inum = inum;
8010344a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010344e:	e8 3d fb ff ff       	call   80102f90 <writei>
80103453:	83 c4 20             	add    $0x20,%esp
80103456:	83 f8 10             	cmp    $0x10,%eax
80103459:	75 2a                	jne    80103485 <dirlink+0xa5>
  return 0;
8010345b:	31 c0                	xor    %eax,%eax
}
8010345d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103460:	5b                   	pop    %ebx
80103461:	5e                   	pop    %esi
80103462:	5f                   	pop    %edi
80103463:	5d                   	pop    %ebp
80103464:	c3                   	ret    
    iput(ip);
80103465:	83 ec 0c             	sub    $0xc,%esp
80103468:	50                   	push   %eax
80103469:	e8 42 f8 ff ff       	call   80102cb0 <iput>
    return -1;
8010346e:	83 c4 10             	add    $0x10,%esp
80103471:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103476:	eb e5                	jmp    8010345d <dirlink+0x7d>
      panic("dirlink read");
80103478:	83 ec 0c             	sub    $0xc,%esp
8010347b:	68 5b 87 10 80       	push   $0x8010875b
80103480:	e8 fb ce ff ff       	call   80100380 <panic>
    panic("dirlink");
80103485:	83 ec 0c             	sub    $0xc,%esp
80103488:	68 3e 8d 10 80       	push   $0x80108d3e
8010348d:	e8 ee ce ff ff       	call   80100380 <panic>
80103492:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801034a0 <namei>:

struct inode*
namei(char *path)
{
801034a0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801034a1:	31 d2                	xor    %edx,%edx
{
801034a3:	89 e5                	mov    %esp,%ebp
801034a5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801034a8:	8b 45 08             	mov    0x8(%ebp),%eax
801034ab:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801034ae:	e8 dd fc ff ff       	call   80103190 <namex>
}
801034b3:	c9                   	leave  
801034b4:	c3                   	ret    
801034b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801034bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801034c0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801034c0:	55                   	push   %ebp
  return namex(path, 1, name);
801034c1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801034c6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801034c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801034cb:	8b 45 08             	mov    0x8(%ebp),%eax
}
801034ce:	5d                   	pop    %ebp
  return namex(path, 1, name);
801034cf:	e9 bc fc ff ff       	jmp    80103190 <namex>
801034d4:	66 90                	xchg   %ax,%ax
801034d6:	66 90                	xchg   %ax,%ax
801034d8:	66 90                	xchg   %ax,%ax
801034da:	66 90                	xchg   %ax,%ax
801034dc:	66 90                	xchg   %ax,%ax
801034de:	66 90                	xchg   %ax,%ax

801034e0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801034e0:	55                   	push   %ebp
801034e1:	89 e5                	mov    %esp,%ebp
801034e3:	57                   	push   %edi
801034e4:	56                   	push   %esi
801034e5:	53                   	push   %ebx
801034e6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801034e9:	85 c0                	test   %eax,%eax
801034eb:	0f 84 b4 00 00 00    	je     801035a5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801034f1:	8b 70 08             	mov    0x8(%eax),%esi
801034f4:	89 c3                	mov    %eax,%ebx
801034f6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801034fc:	0f 87 96 00 00 00    	ja     80103598 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103502:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80103507:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010350e:	66 90                	xchg   %ax,%ax
80103510:	89 ca                	mov    %ecx,%edx
80103512:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80103513:	83 e0 c0             	and    $0xffffffc0,%eax
80103516:	3c 40                	cmp    $0x40,%al
80103518:	75 f6                	jne    80103510 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010351a:	31 ff                	xor    %edi,%edi
8010351c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80103521:	89 f8                	mov    %edi,%eax
80103523:	ee                   	out    %al,(%dx)
80103524:	b8 01 00 00 00       	mov    $0x1,%eax
80103529:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010352e:	ee                   	out    %al,(%dx)
8010352f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80103534:	89 f0                	mov    %esi,%eax
80103536:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80103537:	89 f0                	mov    %esi,%eax
80103539:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010353e:	c1 f8 08             	sar    $0x8,%eax
80103541:	ee                   	out    %al,(%dx)
80103542:	ba f5 01 00 00       	mov    $0x1f5,%edx
80103547:	89 f8                	mov    %edi,%eax
80103549:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010354a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010354e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80103553:	c1 e0 04             	shl    $0x4,%eax
80103556:	83 e0 10             	and    $0x10,%eax
80103559:	83 c8 e0             	or     $0xffffffe0,%eax
8010355c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010355d:	f6 03 04             	testb  $0x4,(%ebx)
80103560:	75 16                	jne    80103578 <idestart+0x98>
80103562:	b8 20 00 00 00       	mov    $0x20,%eax
80103567:	89 ca                	mov    %ecx,%edx
80103569:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010356a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010356d:	5b                   	pop    %ebx
8010356e:	5e                   	pop    %esi
8010356f:	5f                   	pop    %edi
80103570:	5d                   	pop    %ebp
80103571:	c3                   	ret    
80103572:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103578:	b8 30 00 00 00       	mov    $0x30,%eax
8010357d:	89 ca                	mov    %ecx,%edx
8010357f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80103580:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80103585:	8d 73 5c             	lea    0x5c(%ebx),%esi
80103588:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010358d:	fc                   	cld    
8010358e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80103590:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103593:	5b                   	pop    %ebx
80103594:	5e                   	pop    %esi
80103595:	5f                   	pop    %edi
80103596:	5d                   	pop    %ebp
80103597:	c3                   	ret    
    panic("incorrect blockno");
80103598:	83 ec 0c             	sub    $0xc,%esp
8010359b:	68 c4 87 10 80       	push   $0x801087c4
801035a0:	e8 db cd ff ff       	call   80100380 <panic>
    panic("idestart");
801035a5:	83 ec 0c             	sub    $0xc,%esp
801035a8:	68 bb 87 10 80       	push   $0x801087bb
801035ad:	e8 ce cd ff ff       	call   80100380 <panic>
801035b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801035c0 <ideinit>:
{
801035c0:	55                   	push   %ebp
801035c1:	89 e5                	mov    %esp,%ebp
801035c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801035c6:	68 d6 87 10 80       	push   $0x801087d6
801035cb:	68 80 2d 11 80       	push   $0x80112d80
801035d0:	e8 fb 21 00 00       	call   801057d0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801035d5:	58                   	pop    %eax
801035d6:	a1 04 2f 11 80       	mov    0x80112f04,%eax
801035db:	5a                   	pop    %edx
801035dc:	83 e8 01             	sub    $0x1,%eax
801035df:	50                   	push   %eax
801035e0:	6a 0e                	push   $0xe
801035e2:	e8 99 02 00 00       	call   80103880 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801035e7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801035ea:	ba f7 01 00 00       	mov    $0x1f7,%edx
801035ef:	90                   	nop
801035f0:	ec                   	in     (%dx),%al
801035f1:	83 e0 c0             	and    $0xffffffc0,%eax
801035f4:	3c 40                	cmp    $0x40,%al
801035f6:	75 f8                	jne    801035f0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801035f8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801035fd:	ba f6 01 00 00       	mov    $0x1f6,%edx
80103602:	ee                   	out    %al,(%dx)
80103603:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103608:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010360d:	eb 06                	jmp    80103615 <ideinit+0x55>
8010360f:	90                   	nop
  for(i=0; i<1000; i++){
80103610:	83 e9 01             	sub    $0x1,%ecx
80103613:	74 0f                	je     80103624 <ideinit+0x64>
80103615:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80103616:	84 c0                	test   %al,%al
80103618:	74 f6                	je     80103610 <ideinit+0x50>
      havedisk1 = 1;
8010361a:	c7 05 60 2d 11 80 01 	movl   $0x1,0x80112d60
80103621:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103624:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80103629:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010362e:	ee                   	out    %al,(%dx)
}
8010362f:	c9                   	leave  
80103630:	c3                   	ret    
80103631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103638:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010363f:	90                   	nop

80103640 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80103640:	55                   	push   %ebp
80103641:	89 e5                	mov    %esp,%ebp
80103643:	57                   	push   %edi
80103644:	56                   	push   %esi
80103645:	53                   	push   %ebx
80103646:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80103649:	68 80 2d 11 80       	push   $0x80112d80
8010364e:	e8 4d 23 00 00       	call   801059a0 <acquire>

  if((b = idequeue) == 0){
80103653:	8b 1d 64 2d 11 80    	mov    0x80112d64,%ebx
80103659:	83 c4 10             	add    $0x10,%esp
8010365c:	85 db                	test   %ebx,%ebx
8010365e:	74 63                	je     801036c3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80103660:	8b 43 58             	mov    0x58(%ebx),%eax
80103663:	a3 64 2d 11 80       	mov    %eax,0x80112d64

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80103668:	8b 33                	mov    (%ebx),%esi
8010366a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80103670:	75 2f                	jne    801036a1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103672:	ba f7 01 00 00       	mov    $0x1f7,%edx
80103677:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010367e:	66 90                	xchg   %ax,%ax
80103680:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80103681:	89 c1                	mov    %eax,%ecx
80103683:	83 e1 c0             	and    $0xffffffc0,%ecx
80103686:	80 f9 40             	cmp    $0x40,%cl
80103689:	75 f5                	jne    80103680 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010368b:	a8 21                	test   $0x21,%al
8010368d:	75 12                	jne    801036a1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010368f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80103692:	b9 80 00 00 00       	mov    $0x80,%ecx
80103697:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010369c:	fc                   	cld    
8010369d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010369f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
801036a1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801036a4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801036a7:	83 ce 02             	or     $0x2,%esi
801036aa:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801036ac:	53                   	push   %ebx
801036ad:	e8 4e 1e 00 00       	call   80105500 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801036b2:	a1 64 2d 11 80       	mov    0x80112d64,%eax
801036b7:	83 c4 10             	add    $0x10,%esp
801036ba:	85 c0                	test   %eax,%eax
801036bc:	74 05                	je     801036c3 <ideintr+0x83>
    idestart(idequeue);
801036be:	e8 1d fe ff ff       	call   801034e0 <idestart>
    release(&idelock);
801036c3:	83 ec 0c             	sub    $0xc,%esp
801036c6:	68 80 2d 11 80       	push   $0x80112d80
801036cb:	e8 70 22 00 00       	call   80105940 <release>

  release(&idelock);
}
801036d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036d3:	5b                   	pop    %ebx
801036d4:	5e                   	pop    %esi
801036d5:	5f                   	pop    %edi
801036d6:	5d                   	pop    %ebp
801036d7:	c3                   	ret    
801036d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036df:	90                   	nop

801036e0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801036e0:	55                   	push   %ebp
801036e1:	89 e5                	mov    %esp,%ebp
801036e3:	53                   	push   %ebx
801036e4:	83 ec 10             	sub    $0x10,%esp
801036e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801036ea:	8d 43 0c             	lea    0xc(%ebx),%eax
801036ed:	50                   	push   %eax
801036ee:	e8 8d 20 00 00       	call   80105780 <holdingsleep>
801036f3:	83 c4 10             	add    $0x10,%esp
801036f6:	85 c0                	test   %eax,%eax
801036f8:	0f 84 c3 00 00 00    	je     801037c1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801036fe:	8b 03                	mov    (%ebx),%eax
80103700:	83 e0 06             	and    $0x6,%eax
80103703:	83 f8 02             	cmp    $0x2,%eax
80103706:	0f 84 a8 00 00 00    	je     801037b4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010370c:	8b 53 04             	mov    0x4(%ebx),%edx
8010370f:	85 d2                	test   %edx,%edx
80103711:	74 0d                	je     80103720 <iderw+0x40>
80103713:	a1 60 2d 11 80       	mov    0x80112d60,%eax
80103718:	85 c0                	test   %eax,%eax
8010371a:	0f 84 87 00 00 00    	je     801037a7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80103720:	83 ec 0c             	sub    $0xc,%esp
80103723:	68 80 2d 11 80       	push   $0x80112d80
80103728:	e8 73 22 00 00       	call   801059a0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010372d:	a1 64 2d 11 80       	mov    0x80112d64,%eax
  b->qnext = 0;
80103732:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80103739:	83 c4 10             	add    $0x10,%esp
8010373c:	85 c0                	test   %eax,%eax
8010373e:	74 60                	je     801037a0 <iderw+0xc0>
80103740:	89 c2                	mov    %eax,%edx
80103742:	8b 40 58             	mov    0x58(%eax),%eax
80103745:	85 c0                	test   %eax,%eax
80103747:	75 f7                	jne    80103740 <iderw+0x60>
80103749:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010374c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010374e:	39 1d 64 2d 11 80    	cmp    %ebx,0x80112d64
80103754:	74 3a                	je     80103790 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80103756:	8b 03                	mov    (%ebx),%eax
80103758:	83 e0 06             	and    $0x6,%eax
8010375b:	83 f8 02             	cmp    $0x2,%eax
8010375e:	74 1b                	je     8010377b <iderw+0x9b>
    sleep(b, &idelock);
80103760:	83 ec 08             	sub    $0x8,%esp
80103763:	68 80 2d 11 80       	push   $0x80112d80
80103768:	53                   	push   %ebx
80103769:	e8 d2 1c 00 00       	call   80105440 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010376e:	8b 03                	mov    (%ebx),%eax
80103770:	83 c4 10             	add    $0x10,%esp
80103773:	83 e0 06             	and    $0x6,%eax
80103776:	83 f8 02             	cmp    $0x2,%eax
80103779:	75 e5                	jne    80103760 <iderw+0x80>
  }


  release(&idelock);
8010377b:	c7 45 08 80 2d 11 80 	movl   $0x80112d80,0x8(%ebp)
}
80103782:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103785:	c9                   	leave  
  release(&idelock);
80103786:	e9 b5 21 00 00       	jmp    80105940 <release>
8010378b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010378f:	90                   	nop
    idestart(b);
80103790:	89 d8                	mov    %ebx,%eax
80103792:	e8 49 fd ff ff       	call   801034e0 <idestart>
80103797:	eb bd                	jmp    80103756 <iderw+0x76>
80103799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801037a0:	ba 64 2d 11 80       	mov    $0x80112d64,%edx
801037a5:	eb a5                	jmp    8010374c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
801037a7:	83 ec 0c             	sub    $0xc,%esp
801037aa:	68 05 88 10 80       	push   $0x80108805
801037af:	e8 cc cb ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801037b4:	83 ec 0c             	sub    $0xc,%esp
801037b7:	68 f0 87 10 80       	push   $0x801087f0
801037bc:	e8 bf cb ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801037c1:	83 ec 0c             	sub    $0xc,%esp
801037c4:	68 da 87 10 80       	push   $0x801087da
801037c9:	e8 b2 cb ff ff       	call   80100380 <panic>
801037ce:	66 90                	xchg   %ax,%ax

801037d0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801037d0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801037d1:	c7 05 b4 2d 11 80 00 	movl   $0xfec00000,0x80112db4
801037d8:	00 c0 fe 
{
801037db:	89 e5                	mov    %esp,%ebp
801037dd:	56                   	push   %esi
801037de:	53                   	push   %ebx
  ioapic->reg = reg;
801037df:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801037e6:	00 00 00 
  return ioapic->data;
801037e9:	8b 15 b4 2d 11 80    	mov    0x80112db4,%edx
801037ef:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801037f2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801037f8:	8b 0d b4 2d 11 80    	mov    0x80112db4,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801037fe:	0f b6 15 00 2f 11 80 	movzbl 0x80112f00,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80103805:	c1 ee 10             	shr    $0x10,%esi
80103808:	89 f0                	mov    %esi,%eax
8010380a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010380d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80103810:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80103813:	39 c2                	cmp    %eax,%edx
80103815:	74 16                	je     8010382d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80103817:	83 ec 0c             	sub    $0xc,%esp
8010381a:	68 24 88 10 80       	push   $0x80108824
8010381f:	e8 dc ce ff ff       	call   80100700 <cprintf>
  ioapic->reg = reg;
80103824:	8b 0d b4 2d 11 80    	mov    0x80112db4,%ecx
8010382a:	83 c4 10             	add    $0x10,%esp
8010382d:	83 c6 21             	add    $0x21,%esi
{
80103830:	ba 10 00 00 00       	mov    $0x10,%edx
80103835:	b8 20 00 00 00       	mov    $0x20,%eax
8010383a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80103840:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80103842:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80103844:	8b 0d b4 2d 11 80    	mov    0x80112db4,%ecx
  for(i = 0; i <= maxintr; i++){
8010384a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010384d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80103853:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80103856:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
80103859:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
8010385c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010385e:	8b 0d b4 2d 11 80    	mov    0x80112db4,%ecx
80103864:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010386b:	39 f0                	cmp    %esi,%eax
8010386d:	75 d1                	jne    80103840 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010386f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103872:	5b                   	pop    %ebx
80103873:	5e                   	pop    %esi
80103874:	5d                   	pop    %ebp
80103875:	c3                   	ret    
80103876:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010387d:	8d 76 00             	lea    0x0(%esi),%esi

80103880 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80103880:	55                   	push   %ebp
  ioapic->reg = reg;
80103881:	8b 0d b4 2d 11 80    	mov    0x80112db4,%ecx
{
80103887:	89 e5                	mov    %esp,%ebp
80103889:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010388c:	8d 50 20             	lea    0x20(%eax),%edx
8010388f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80103893:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80103895:	8b 0d b4 2d 11 80    	mov    0x80112db4,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010389b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010389e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801038a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801038a4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801038a6:	a1 b4 2d 11 80       	mov    0x80112db4,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801038ab:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801038ae:	89 50 10             	mov    %edx,0x10(%eax)
}
801038b1:	5d                   	pop    %ebp
801038b2:	c3                   	ret    
801038b3:	66 90                	xchg   %ax,%ax
801038b5:	66 90                	xchg   %ax,%ax
801038b7:	66 90                	xchg   %ax,%ax
801038b9:	66 90                	xchg   %ax,%ax
801038bb:	66 90                	xchg   %ax,%ax
801038bd:	66 90                	xchg   %ax,%ax
801038bf:	90                   	nop

801038c0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801038c0:	55                   	push   %ebp
801038c1:	89 e5                	mov    %esp,%ebp
801038c3:	53                   	push   %ebx
801038c4:	83 ec 04             	sub    $0x4,%esp
801038c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801038ca:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801038d0:	75 76                	jne    80103948 <kfree+0x88>
801038d2:	81 fb 50 6c 11 80    	cmp    $0x80116c50,%ebx
801038d8:	72 6e                	jb     80103948 <kfree+0x88>
801038da:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801038e0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801038e5:	77 61                	ja     80103948 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801038e7:	83 ec 04             	sub    $0x4,%esp
801038ea:	68 00 10 00 00       	push   $0x1000
801038ef:	6a 01                	push   $0x1
801038f1:	53                   	push   %ebx
801038f2:	e8 69 21 00 00       	call   80105a60 <memset>

  if(kmem.use_lock)
801038f7:	8b 15 f4 2d 11 80    	mov    0x80112df4,%edx
801038fd:	83 c4 10             	add    $0x10,%esp
80103900:	85 d2                	test   %edx,%edx
80103902:	75 1c                	jne    80103920 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80103904:	a1 f8 2d 11 80       	mov    0x80112df8,%eax
80103909:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010390b:	a1 f4 2d 11 80       	mov    0x80112df4,%eax
  kmem.freelist = r;
80103910:	89 1d f8 2d 11 80    	mov    %ebx,0x80112df8
  if(kmem.use_lock)
80103916:	85 c0                	test   %eax,%eax
80103918:	75 1e                	jne    80103938 <kfree+0x78>
    release(&kmem.lock);
}
8010391a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010391d:	c9                   	leave  
8010391e:	c3                   	ret    
8010391f:	90                   	nop
    acquire(&kmem.lock);
80103920:	83 ec 0c             	sub    $0xc,%esp
80103923:	68 c0 2d 11 80       	push   $0x80112dc0
80103928:	e8 73 20 00 00       	call   801059a0 <acquire>
8010392d:	83 c4 10             	add    $0x10,%esp
80103930:	eb d2                	jmp    80103904 <kfree+0x44>
80103932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80103938:	c7 45 08 c0 2d 11 80 	movl   $0x80112dc0,0x8(%ebp)
}
8010393f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103942:	c9                   	leave  
    release(&kmem.lock);
80103943:	e9 f8 1f 00 00       	jmp    80105940 <release>
    panic("kfree");
80103948:	83 ec 0c             	sub    $0xc,%esp
8010394b:	68 56 88 10 80       	push   $0x80108856
80103950:	e8 2b ca ff ff       	call   80100380 <panic>
80103955:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010395c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103960 <freerange>:
{
80103960:	55                   	push   %ebp
80103961:	89 e5                	mov    %esp,%ebp
80103963:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80103964:	8b 45 08             	mov    0x8(%ebp),%eax
{
80103967:	8b 75 0c             	mov    0xc(%ebp),%esi
8010396a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010396b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80103971:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80103977:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010397d:	39 de                	cmp    %ebx,%esi
8010397f:	72 23                	jb     801039a4 <freerange+0x44>
80103981:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80103988:	83 ec 0c             	sub    $0xc,%esp
8010398b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80103991:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80103997:	50                   	push   %eax
80103998:	e8 23 ff ff ff       	call   801038c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010399d:	83 c4 10             	add    $0x10,%esp
801039a0:	39 f3                	cmp    %esi,%ebx
801039a2:	76 e4                	jbe    80103988 <freerange+0x28>
}
801039a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801039a7:	5b                   	pop    %ebx
801039a8:	5e                   	pop    %esi
801039a9:	5d                   	pop    %ebp
801039aa:	c3                   	ret    
801039ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801039af:	90                   	nop

801039b0 <kinit2>:
{
801039b0:	55                   	push   %ebp
801039b1:	89 e5                	mov    %esp,%ebp
801039b3:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801039b4:	8b 45 08             	mov    0x8(%ebp),%eax
{
801039b7:	8b 75 0c             	mov    0xc(%ebp),%esi
801039ba:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801039bb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801039c1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801039c7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801039cd:	39 de                	cmp    %ebx,%esi
801039cf:	72 23                	jb     801039f4 <kinit2+0x44>
801039d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801039d8:	83 ec 0c             	sub    $0xc,%esp
801039db:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801039e1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801039e7:	50                   	push   %eax
801039e8:	e8 d3 fe ff ff       	call   801038c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801039ed:	83 c4 10             	add    $0x10,%esp
801039f0:	39 de                	cmp    %ebx,%esi
801039f2:	73 e4                	jae    801039d8 <kinit2+0x28>
  kmem.use_lock = 1;
801039f4:	c7 05 f4 2d 11 80 01 	movl   $0x1,0x80112df4
801039fb:	00 00 00 
}
801039fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a01:	5b                   	pop    %ebx
80103a02:	5e                   	pop    %esi
80103a03:	5d                   	pop    %ebp
80103a04:	c3                   	ret    
80103a05:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103a10 <kinit1>:
{
80103a10:	55                   	push   %ebp
80103a11:	89 e5                	mov    %esp,%ebp
80103a13:	56                   	push   %esi
80103a14:	53                   	push   %ebx
80103a15:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80103a18:	83 ec 08             	sub    $0x8,%esp
80103a1b:	68 5c 88 10 80       	push   $0x8010885c
80103a20:	68 c0 2d 11 80       	push   $0x80112dc0
80103a25:	e8 a6 1d 00 00       	call   801057d0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
80103a2a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80103a2d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80103a30:	c7 05 f4 2d 11 80 00 	movl   $0x0,0x80112df4
80103a37:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
80103a3a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80103a40:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80103a46:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80103a4c:	39 de                	cmp    %ebx,%esi
80103a4e:	72 1c                	jb     80103a6c <kinit1+0x5c>
    kfree(p);
80103a50:	83 ec 0c             	sub    $0xc,%esp
80103a53:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80103a59:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80103a5f:	50                   	push   %eax
80103a60:	e8 5b fe ff ff       	call   801038c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80103a65:	83 c4 10             	add    $0x10,%esp
80103a68:	39 de                	cmp    %ebx,%esi
80103a6a:	73 e4                	jae    80103a50 <kinit1+0x40>
}
80103a6c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a6f:	5b                   	pop    %ebx
80103a70:	5e                   	pop    %esi
80103a71:	5d                   	pop    %ebp
80103a72:	c3                   	ret    
80103a73:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103a80 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80103a80:	a1 f4 2d 11 80       	mov    0x80112df4,%eax
80103a85:	85 c0                	test   %eax,%eax
80103a87:	75 1f                	jne    80103aa8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80103a89:	a1 f8 2d 11 80       	mov    0x80112df8,%eax
  if(r)
80103a8e:	85 c0                	test   %eax,%eax
80103a90:	74 0e                	je     80103aa0 <kalloc+0x20>
    kmem.freelist = r->next;
80103a92:	8b 10                	mov    (%eax),%edx
80103a94:	89 15 f8 2d 11 80    	mov    %edx,0x80112df8
  if(kmem.use_lock)
80103a9a:	c3                   	ret    
80103a9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a9f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80103aa0:	c3                   	ret    
80103aa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80103aa8:	55                   	push   %ebp
80103aa9:	89 e5                	mov    %esp,%ebp
80103aab:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
80103aae:	68 c0 2d 11 80       	push   $0x80112dc0
80103ab3:	e8 e8 1e 00 00       	call   801059a0 <acquire>
  r = kmem.freelist;
80103ab8:	a1 f8 2d 11 80       	mov    0x80112df8,%eax
  if(kmem.use_lock)
80103abd:	8b 15 f4 2d 11 80    	mov    0x80112df4,%edx
  if(r)
80103ac3:	83 c4 10             	add    $0x10,%esp
80103ac6:	85 c0                	test   %eax,%eax
80103ac8:	74 08                	je     80103ad2 <kalloc+0x52>
    kmem.freelist = r->next;
80103aca:	8b 08                	mov    (%eax),%ecx
80103acc:	89 0d f8 2d 11 80    	mov    %ecx,0x80112df8
  if(kmem.use_lock)
80103ad2:	85 d2                	test   %edx,%edx
80103ad4:	74 16                	je     80103aec <kalloc+0x6c>
    release(&kmem.lock);
80103ad6:	83 ec 0c             	sub    $0xc,%esp
80103ad9:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103adc:	68 c0 2d 11 80       	push   $0x80112dc0
80103ae1:	e8 5a 1e 00 00       	call   80105940 <release>
  return (char*)r;
80103ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80103ae9:	83 c4 10             	add    $0x10,%esp
}
80103aec:	c9                   	leave  
80103aed:	c3                   	ret    
80103aee:	66 90                	xchg   %ax,%ax

80103af0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103af0:	ba 64 00 00 00       	mov    $0x64,%edx
80103af5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80103af6:	a8 01                	test   $0x1,%al
80103af8:	0f 84 c2 00 00 00    	je     80103bc0 <kbdgetc+0xd0>
{
80103afe:	55                   	push   %ebp
80103aff:	ba 60 00 00 00       	mov    $0x60,%edx
80103b04:	89 e5                	mov    %esp,%ebp
80103b06:	53                   	push   %ebx
80103b07:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80103b08:	8b 1d fc 2d 11 80    	mov    0x80112dfc,%ebx
  data = inb(KBDATAP);
80103b0e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80103b11:	3c e0                	cmp    $0xe0,%al
80103b13:	74 5b                	je     80103b70 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80103b15:	89 da                	mov    %ebx,%edx
80103b17:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
80103b1a:	84 c0                	test   %al,%al
80103b1c:	78 62                	js     80103b80 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80103b1e:	85 d2                	test   %edx,%edx
80103b20:	74 09                	je     80103b2b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80103b22:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80103b25:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80103b28:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
80103b2b:	0f b6 91 a0 89 10 80 	movzbl -0x7fef7660(%ecx),%edx
  shift ^= togglecode[data];
80103b32:	0f b6 81 a0 88 10 80 	movzbl -0x7fef7760(%ecx),%eax
  shift |= shiftcode[data];
80103b39:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
80103b3b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
80103b3d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
80103b3f:	89 15 fc 2d 11 80    	mov    %edx,0x80112dfc
  c = charcode[shift & (CTL | SHIFT)][data];
80103b45:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80103b48:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
80103b4b:	8b 04 85 80 88 10 80 	mov    -0x7fef7780(,%eax,4),%eax
80103b52:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80103b56:	74 0b                	je     80103b63 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80103b58:	8d 50 9f             	lea    -0x61(%eax),%edx
80103b5b:	83 fa 19             	cmp    $0x19,%edx
80103b5e:	77 48                	ja     80103ba8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80103b60:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80103b63:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b66:	c9                   	leave  
80103b67:	c3                   	ret    
80103b68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b6f:	90                   	nop
    shift |= E0ESC;
80103b70:	83 cb 40             	or     $0x40,%ebx
    return 0;
80103b73:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80103b75:	89 1d fc 2d 11 80    	mov    %ebx,0x80112dfc
}
80103b7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b7e:	c9                   	leave  
80103b7f:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80103b80:	83 e0 7f             	and    $0x7f,%eax
80103b83:	85 d2                	test   %edx,%edx
80103b85:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80103b88:	0f b6 81 a0 89 10 80 	movzbl -0x7fef7660(%ecx),%eax
80103b8f:	83 c8 40             	or     $0x40,%eax
80103b92:	0f b6 c0             	movzbl %al,%eax
80103b95:	f7 d0                	not    %eax
80103b97:	21 d8                	and    %ebx,%eax
}
80103b99:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
80103b9c:	a3 fc 2d 11 80       	mov    %eax,0x80112dfc
    return 0;
80103ba1:	31 c0                	xor    %eax,%eax
}
80103ba3:	c9                   	leave  
80103ba4:	c3                   	ret    
80103ba5:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80103ba8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80103bab:	8d 50 20             	lea    0x20(%eax),%edx
}
80103bae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103bb1:	c9                   	leave  
      c += 'a' - 'A';
80103bb2:	83 f9 1a             	cmp    $0x1a,%ecx
80103bb5:	0f 42 c2             	cmovb  %edx,%eax
}
80103bb8:	c3                   	ret    
80103bb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80103bc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103bc5:	c3                   	ret    
80103bc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103bcd:	8d 76 00             	lea    0x0(%esi),%esi

80103bd0 <kbdintr>:

void
kbdintr(void)
{
80103bd0:	55                   	push   %ebp
80103bd1:	89 e5                	mov    %esp,%ebp
80103bd3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80103bd6:	68 f0 3a 10 80       	push   $0x80103af0
80103bdb:	e8 60 d9 ff ff       	call   80101540 <consoleintr>
}
80103be0:	83 c4 10             	add    $0x10,%esp
80103be3:	c9                   	leave  
80103be4:	c3                   	ret    
80103be5:	66 90                	xchg   %ax,%ax
80103be7:	66 90                	xchg   %ax,%ax
80103be9:	66 90                	xchg   %ax,%ax
80103beb:	66 90                	xchg   %ax,%ax
80103bed:	66 90                	xchg   %ax,%ax
80103bef:	90                   	nop

80103bf0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80103bf0:	a1 00 2e 11 80       	mov    0x80112e00,%eax
80103bf5:	85 c0                	test   %eax,%eax
80103bf7:	0f 84 cb 00 00 00    	je     80103cc8 <lapicinit+0xd8>
  lapic[index] = value;
80103bfd:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80103c04:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103c07:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103c0a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80103c11:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103c14:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103c17:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80103c1e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80103c21:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103c24:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80103c2b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80103c2e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103c31:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80103c38:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80103c3b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103c3e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80103c45:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80103c48:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80103c4b:	8b 50 30             	mov    0x30(%eax),%edx
80103c4e:	c1 ea 10             	shr    $0x10,%edx
80103c51:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80103c57:	75 77                	jne    80103cd0 <lapicinit+0xe0>
  lapic[index] = value;
80103c59:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80103c60:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103c63:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103c66:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80103c6d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103c70:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103c73:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80103c7a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103c7d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103c80:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80103c87:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103c8a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103c8d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80103c94:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103c97:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103c9a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80103ca1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80103ca4:	8b 50 20             	mov    0x20(%eax),%edx
80103ca7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103cae:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80103cb0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80103cb6:	80 e6 10             	and    $0x10,%dh
80103cb9:	75 f5                	jne    80103cb0 <lapicinit+0xc0>
  lapic[index] = value;
80103cbb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80103cc2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103cc5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80103cc8:	c3                   	ret    
80103cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80103cd0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80103cd7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80103cda:	8b 50 20             	mov    0x20(%eax),%edx
}
80103cdd:	e9 77 ff ff ff       	jmp    80103c59 <lapicinit+0x69>
80103ce2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ce9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103cf0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80103cf0:	a1 00 2e 11 80       	mov    0x80112e00,%eax
80103cf5:	85 c0                	test   %eax,%eax
80103cf7:	74 07                	je     80103d00 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80103cf9:	8b 40 20             	mov    0x20(%eax),%eax
80103cfc:	c1 e8 18             	shr    $0x18,%eax
80103cff:	c3                   	ret    
    return 0;
80103d00:	31 c0                	xor    %eax,%eax
}
80103d02:	c3                   	ret    
80103d03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103d10 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80103d10:	a1 00 2e 11 80       	mov    0x80112e00,%eax
80103d15:	85 c0                	test   %eax,%eax
80103d17:	74 0d                	je     80103d26 <lapiceoi+0x16>
  lapic[index] = value;
80103d19:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80103d20:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103d23:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80103d26:	c3                   	ret    
80103d27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d2e:	66 90                	xchg   %ax,%ax

80103d30 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80103d30:	c3                   	ret    
80103d31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d3f:	90                   	nop

80103d40 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80103d40:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103d41:	b8 0f 00 00 00       	mov    $0xf,%eax
80103d46:	ba 70 00 00 00       	mov    $0x70,%edx
80103d4b:	89 e5                	mov    %esp,%ebp
80103d4d:	53                   	push   %ebx
80103d4e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103d51:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103d54:	ee                   	out    %al,(%dx)
80103d55:	b8 0a 00 00 00       	mov    $0xa,%eax
80103d5a:	ba 71 00 00 00       	mov    $0x71,%edx
80103d5f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80103d60:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80103d62:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80103d65:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80103d6b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80103d6d:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80103d70:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80103d72:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80103d75:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80103d78:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80103d7e:	a1 00 2e 11 80       	mov    0x80112e00,%eax
80103d83:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103d89:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103d8c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80103d93:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103d96:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103d99:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80103da0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103da3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103da6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103dac:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103daf:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103db5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103db8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103dbe:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103dc1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103dc7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80103dca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103dcd:	c9                   	leave  
80103dce:	c3                   	ret    
80103dcf:	90                   	nop

80103dd0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80103dd0:	55                   	push   %ebp
80103dd1:	b8 0b 00 00 00       	mov    $0xb,%eax
80103dd6:	ba 70 00 00 00       	mov    $0x70,%edx
80103ddb:	89 e5                	mov    %esp,%ebp
80103ddd:	57                   	push   %edi
80103dde:	56                   	push   %esi
80103ddf:	53                   	push   %ebx
80103de0:	83 ec 4c             	sub    $0x4c,%esp
80103de3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103de4:	ba 71 00 00 00       	mov    $0x71,%edx
80103de9:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80103dea:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103ded:	bb 70 00 00 00       	mov    $0x70,%ebx
80103df2:	88 45 b3             	mov    %al,-0x4d(%ebp)
80103df5:	8d 76 00             	lea    0x0(%esi),%esi
80103df8:	31 c0                	xor    %eax,%eax
80103dfa:	89 da                	mov    %ebx,%edx
80103dfc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103dfd:	b9 71 00 00 00       	mov    $0x71,%ecx
80103e02:	89 ca                	mov    %ecx,%edx
80103e04:	ec                   	in     (%dx),%al
80103e05:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103e08:	89 da                	mov    %ebx,%edx
80103e0a:	b8 02 00 00 00       	mov    $0x2,%eax
80103e0f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103e10:	89 ca                	mov    %ecx,%edx
80103e12:	ec                   	in     (%dx),%al
80103e13:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103e16:	89 da                	mov    %ebx,%edx
80103e18:	b8 04 00 00 00       	mov    $0x4,%eax
80103e1d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103e1e:	89 ca                	mov    %ecx,%edx
80103e20:	ec                   	in     (%dx),%al
80103e21:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103e24:	89 da                	mov    %ebx,%edx
80103e26:	b8 07 00 00 00       	mov    $0x7,%eax
80103e2b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103e2c:	89 ca                	mov    %ecx,%edx
80103e2e:	ec                   	in     (%dx),%al
80103e2f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103e32:	89 da                	mov    %ebx,%edx
80103e34:	b8 08 00 00 00       	mov    $0x8,%eax
80103e39:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103e3a:	89 ca                	mov    %ecx,%edx
80103e3c:	ec                   	in     (%dx),%al
80103e3d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103e3f:	89 da                	mov    %ebx,%edx
80103e41:	b8 09 00 00 00       	mov    $0x9,%eax
80103e46:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103e47:	89 ca                	mov    %ecx,%edx
80103e49:	ec                   	in     (%dx),%al
80103e4a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103e4c:	89 da                	mov    %ebx,%edx
80103e4e:	b8 0a 00 00 00       	mov    $0xa,%eax
80103e53:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103e54:	89 ca                	mov    %ecx,%edx
80103e56:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80103e57:	84 c0                	test   %al,%al
80103e59:	78 9d                	js     80103df8 <cmostime+0x28>
  return inb(CMOS_RETURN);
80103e5b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80103e5f:	89 fa                	mov    %edi,%edx
80103e61:	0f b6 fa             	movzbl %dl,%edi
80103e64:	89 f2                	mov    %esi,%edx
80103e66:	89 45 b8             	mov    %eax,-0x48(%ebp)
80103e69:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80103e6d:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103e70:	89 da                	mov    %ebx,%edx
80103e72:	89 7d c8             	mov    %edi,-0x38(%ebp)
80103e75:	89 45 bc             	mov    %eax,-0x44(%ebp)
80103e78:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80103e7c:	89 75 cc             	mov    %esi,-0x34(%ebp)
80103e7f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80103e82:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80103e86:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80103e89:	31 c0                	xor    %eax,%eax
80103e8b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103e8c:	89 ca                	mov    %ecx,%edx
80103e8e:	ec                   	in     (%dx),%al
80103e8f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103e92:	89 da                	mov    %ebx,%edx
80103e94:	89 45 d0             	mov    %eax,-0x30(%ebp)
80103e97:	b8 02 00 00 00       	mov    $0x2,%eax
80103e9c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103e9d:	89 ca                	mov    %ecx,%edx
80103e9f:	ec                   	in     (%dx),%al
80103ea0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103ea3:	89 da                	mov    %ebx,%edx
80103ea5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80103ea8:	b8 04 00 00 00       	mov    $0x4,%eax
80103ead:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103eae:	89 ca                	mov    %ecx,%edx
80103eb0:	ec                   	in     (%dx),%al
80103eb1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103eb4:	89 da                	mov    %ebx,%edx
80103eb6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80103eb9:	b8 07 00 00 00       	mov    $0x7,%eax
80103ebe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103ebf:	89 ca                	mov    %ecx,%edx
80103ec1:	ec                   	in     (%dx),%al
80103ec2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103ec5:	89 da                	mov    %ebx,%edx
80103ec7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80103eca:	b8 08 00 00 00       	mov    $0x8,%eax
80103ecf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103ed0:	89 ca                	mov    %ecx,%edx
80103ed2:	ec                   	in     (%dx),%al
80103ed3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103ed6:	89 da                	mov    %ebx,%edx
80103ed8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80103edb:	b8 09 00 00 00       	mov    $0x9,%eax
80103ee0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103ee1:	89 ca                	mov    %ecx,%edx
80103ee3:	ec                   	in     (%dx),%al
80103ee4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80103ee7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80103eea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80103eed:	8d 45 d0             	lea    -0x30(%ebp),%eax
80103ef0:	6a 18                	push   $0x18
80103ef2:	50                   	push   %eax
80103ef3:	8d 45 b8             	lea    -0x48(%ebp),%eax
80103ef6:	50                   	push   %eax
80103ef7:	e8 b4 1b 00 00       	call   80105ab0 <memcmp>
80103efc:	83 c4 10             	add    $0x10,%esp
80103eff:	85 c0                	test   %eax,%eax
80103f01:	0f 85 f1 fe ff ff    	jne    80103df8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80103f07:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80103f0b:	75 78                	jne    80103f85 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80103f0d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80103f10:	89 c2                	mov    %eax,%edx
80103f12:	83 e0 0f             	and    $0xf,%eax
80103f15:	c1 ea 04             	shr    $0x4,%edx
80103f18:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103f1b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103f1e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80103f21:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103f24:	89 c2                	mov    %eax,%edx
80103f26:	83 e0 0f             	and    $0xf,%eax
80103f29:	c1 ea 04             	shr    $0x4,%edx
80103f2c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103f2f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103f32:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80103f35:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103f38:	89 c2                	mov    %eax,%edx
80103f3a:	83 e0 0f             	and    $0xf,%eax
80103f3d:	c1 ea 04             	shr    $0x4,%edx
80103f40:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103f43:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103f46:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80103f49:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80103f4c:	89 c2                	mov    %eax,%edx
80103f4e:	83 e0 0f             	and    $0xf,%eax
80103f51:	c1 ea 04             	shr    $0x4,%edx
80103f54:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103f57:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103f5a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80103f5d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103f60:	89 c2                	mov    %eax,%edx
80103f62:	83 e0 0f             	and    $0xf,%eax
80103f65:	c1 ea 04             	shr    $0x4,%edx
80103f68:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103f6b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103f6e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80103f71:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103f74:	89 c2                	mov    %eax,%edx
80103f76:	83 e0 0f             	and    $0xf,%eax
80103f79:	c1 ea 04             	shr    $0x4,%edx
80103f7c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103f7f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103f82:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80103f85:	8b 75 08             	mov    0x8(%ebp),%esi
80103f88:	8b 45 b8             	mov    -0x48(%ebp),%eax
80103f8b:	89 06                	mov    %eax,(%esi)
80103f8d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103f90:	89 46 04             	mov    %eax,0x4(%esi)
80103f93:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103f96:	89 46 08             	mov    %eax,0x8(%esi)
80103f99:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80103f9c:	89 46 0c             	mov    %eax,0xc(%esi)
80103f9f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103fa2:	89 46 10             	mov    %eax,0x10(%esi)
80103fa5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103fa8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80103fab:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80103fb2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103fb5:	5b                   	pop    %ebx
80103fb6:	5e                   	pop    %esi
80103fb7:	5f                   	pop    %edi
80103fb8:	5d                   	pop    %ebp
80103fb9:	c3                   	ret    
80103fba:	66 90                	xchg   %ax,%ax
80103fbc:	66 90                	xchg   %ax,%ax
80103fbe:	66 90                	xchg   %ax,%ax

80103fc0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103fc0:	8b 0d 68 2e 11 80    	mov    0x80112e68,%ecx
80103fc6:	85 c9                	test   %ecx,%ecx
80103fc8:	0f 8e 8a 00 00 00    	jle    80104058 <install_trans+0x98>
{
80103fce:	55                   	push   %ebp
80103fcf:	89 e5                	mov    %esp,%ebp
80103fd1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80103fd2:	31 ff                	xor    %edi,%edi
{
80103fd4:	56                   	push   %esi
80103fd5:	53                   	push   %ebx
80103fd6:	83 ec 0c             	sub    $0xc,%esp
80103fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103fe0:	a1 54 2e 11 80       	mov    0x80112e54,%eax
80103fe5:	83 ec 08             	sub    $0x8,%esp
80103fe8:	01 f8                	add    %edi,%eax
80103fea:	83 c0 01             	add    $0x1,%eax
80103fed:	50                   	push   %eax
80103fee:	ff 35 64 2e 11 80    	push   0x80112e64
80103ff4:	e8 d7 c0 ff ff       	call   801000d0 <bread>
80103ff9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103ffb:	58                   	pop    %eax
80103ffc:	5a                   	pop    %edx
80103ffd:	ff 34 bd 6c 2e 11 80 	push   -0x7feed194(,%edi,4)
80104004:	ff 35 64 2e 11 80    	push   0x80112e64
  for (tail = 0; tail < log.lh.n; tail++) {
8010400a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010400d:	e8 be c0 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80104012:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80104015:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80104017:	8d 46 5c             	lea    0x5c(%esi),%eax
8010401a:	68 00 02 00 00       	push   $0x200
8010401f:	50                   	push   %eax
80104020:	8d 43 5c             	lea    0x5c(%ebx),%eax
80104023:	50                   	push   %eax
80104024:	e8 d7 1a 00 00       	call   80105b00 <memmove>
    bwrite(dbuf);  // write dst to disk
80104029:	89 1c 24             	mov    %ebx,(%esp)
8010402c:	e8 7f c1 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80104031:	89 34 24             	mov    %esi,(%esp)
80104034:	e8 b7 c1 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80104039:	89 1c 24             	mov    %ebx,(%esp)
8010403c:	e8 af c1 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80104041:	83 c4 10             	add    $0x10,%esp
80104044:	39 3d 68 2e 11 80    	cmp    %edi,0x80112e68
8010404a:	7f 94                	jg     80103fe0 <install_trans+0x20>
  }
}
8010404c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010404f:	5b                   	pop    %ebx
80104050:	5e                   	pop    %esi
80104051:	5f                   	pop    %edi
80104052:	5d                   	pop    %ebp
80104053:	c3                   	ret    
80104054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104058:	c3                   	ret    
80104059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104060 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80104060:	55                   	push   %ebp
80104061:	89 e5                	mov    %esp,%ebp
80104063:	53                   	push   %ebx
80104064:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80104067:	ff 35 54 2e 11 80    	push   0x80112e54
8010406d:	ff 35 64 2e 11 80    	push   0x80112e64
80104073:	e8 58 c0 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80104078:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
8010407b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
8010407d:	a1 68 2e 11 80       	mov    0x80112e68,%eax
80104082:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80104085:	85 c0                	test   %eax,%eax
80104087:	7e 19                	jle    801040a2 <write_head+0x42>
80104089:	31 d2                	xor    %edx,%edx
8010408b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010408f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80104090:	8b 0c 95 6c 2e 11 80 	mov    -0x7feed194(,%edx,4),%ecx
80104097:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010409b:	83 c2 01             	add    $0x1,%edx
8010409e:	39 d0                	cmp    %edx,%eax
801040a0:	75 ee                	jne    80104090 <write_head+0x30>
  }
  bwrite(buf);
801040a2:	83 ec 0c             	sub    $0xc,%esp
801040a5:	53                   	push   %ebx
801040a6:	e8 05 c1 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
801040ab:	89 1c 24             	mov    %ebx,(%esp)
801040ae:	e8 3d c1 ff ff       	call   801001f0 <brelse>
}
801040b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040b6:	83 c4 10             	add    $0x10,%esp
801040b9:	c9                   	leave  
801040ba:	c3                   	ret    
801040bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040bf:	90                   	nop

801040c0 <initlog>:
{
801040c0:	55                   	push   %ebp
801040c1:	89 e5                	mov    %esp,%ebp
801040c3:	53                   	push   %ebx
801040c4:	83 ec 2c             	sub    $0x2c,%esp
801040c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
801040ca:	68 a0 8a 10 80       	push   $0x80108aa0
801040cf:	68 20 2e 11 80       	push   $0x80112e20
801040d4:	e8 f7 16 00 00       	call   801057d0 <initlock>
  readsb(dev, &sb);
801040d9:	58                   	pop    %eax
801040da:	8d 45 dc             	lea    -0x24(%ebp),%eax
801040dd:	5a                   	pop    %edx
801040de:	50                   	push   %eax
801040df:	53                   	push   %ebx
801040e0:	e8 3b e8 ff ff       	call   80102920 <readsb>
  log.start = sb.logstart;
801040e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
801040e8:	59                   	pop    %ecx
  log.dev = dev;
801040e9:	89 1d 64 2e 11 80    	mov    %ebx,0x80112e64
  log.size = sb.nlog;
801040ef:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
801040f2:	a3 54 2e 11 80       	mov    %eax,0x80112e54
  log.size = sb.nlog;
801040f7:	89 15 58 2e 11 80    	mov    %edx,0x80112e58
  struct buf *buf = bread(log.dev, log.start);
801040fd:	5a                   	pop    %edx
801040fe:	50                   	push   %eax
801040ff:	53                   	push   %ebx
80104100:	e8 cb bf ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80104105:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80104108:	8b 58 5c             	mov    0x5c(%eax),%ebx
8010410b:	89 1d 68 2e 11 80    	mov    %ebx,0x80112e68
  for (i = 0; i < log.lh.n; i++) {
80104111:	85 db                	test   %ebx,%ebx
80104113:	7e 1d                	jle    80104132 <initlog+0x72>
80104115:	31 d2                	xor    %edx,%edx
80104117:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010411e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80104120:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80104124:	89 0c 95 6c 2e 11 80 	mov    %ecx,-0x7feed194(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010412b:	83 c2 01             	add    $0x1,%edx
8010412e:	39 d3                	cmp    %edx,%ebx
80104130:	75 ee                	jne    80104120 <initlog+0x60>
  brelse(buf);
80104132:	83 ec 0c             	sub    $0xc,%esp
80104135:	50                   	push   %eax
80104136:	e8 b5 c0 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
8010413b:	e8 80 fe ff ff       	call   80103fc0 <install_trans>
  log.lh.n = 0;
80104140:	c7 05 68 2e 11 80 00 	movl   $0x0,0x80112e68
80104147:	00 00 00 
  write_head(); // clear the log
8010414a:	e8 11 ff ff ff       	call   80104060 <write_head>
}
8010414f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104152:	83 c4 10             	add    $0x10,%esp
80104155:	c9                   	leave  
80104156:	c3                   	ret    
80104157:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010415e:	66 90                	xchg   %ax,%ax

80104160 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80104160:	55                   	push   %ebp
80104161:	89 e5                	mov    %esp,%ebp
80104163:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80104166:	68 20 2e 11 80       	push   $0x80112e20
8010416b:	e8 30 18 00 00       	call   801059a0 <acquire>
80104170:	83 c4 10             	add    $0x10,%esp
80104173:	eb 18                	jmp    8010418d <begin_op+0x2d>
80104175:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80104178:	83 ec 08             	sub    $0x8,%esp
8010417b:	68 20 2e 11 80       	push   $0x80112e20
80104180:	68 20 2e 11 80       	push   $0x80112e20
80104185:	e8 b6 12 00 00       	call   80105440 <sleep>
8010418a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
8010418d:	a1 60 2e 11 80       	mov    0x80112e60,%eax
80104192:	85 c0                	test   %eax,%eax
80104194:	75 e2                	jne    80104178 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80104196:	a1 5c 2e 11 80       	mov    0x80112e5c,%eax
8010419b:	8b 15 68 2e 11 80    	mov    0x80112e68,%edx
801041a1:	83 c0 01             	add    $0x1,%eax
801041a4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
801041a7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
801041aa:	83 fa 1e             	cmp    $0x1e,%edx
801041ad:	7f c9                	jg     80104178 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
801041af:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
801041b2:	a3 5c 2e 11 80       	mov    %eax,0x80112e5c
      release(&log.lock);
801041b7:	68 20 2e 11 80       	push   $0x80112e20
801041bc:	e8 7f 17 00 00       	call   80105940 <release>
      break;
    }
  }
}
801041c1:	83 c4 10             	add    $0x10,%esp
801041c4:	c9                   	leave  
801041c5:	c3                   	ret    
801041c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041cd:	8d 76 00             	lea    0x0(%esi),%esi

801041d0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
801041d0:	55                   	push   %ebp
801041d1:	89 e5                	mov    %esp,%ebp
801041d3:	57                   	push   %edi
801041d4:	56                   	push   %esi
801041d5:	53                   	push   %ebx
801041d6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
801041d9:	68 20 2e 11 80       	push   $0x80112e20
801041de:	e8 bd 17 00 00       	call   801059a0 <acquire>
  log.outstanding -= 1;
801041e3:	a1 5c 2e 11 80       	mov    0x80112e5c,%eax
  if(log.committing)
801041e8:	8b 35 60 2e 11 80    	mov    0x80112e60,%esi
801041ee:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
801041f1:	8d 58 ff             	lea    -0x1(%eax),%ebx
801041f4:	89 1d 5c 2e 11 80    	mov    %ebx,0x80112e5c
  if(log.committing)
801041fa:	85 f6                	test   %esi,%esi
801041fc:	0f 85 22 01 00 00    	jne    80104324 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80104202:	85 db                	test   %ebx,%ebx
80104204:	0f 85 f6 00 00 00    	jne    80104300 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
8010420a:	c7 05 60 2e 11 80 01 	movl   $0x1,0x80112e60
80104211:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80104214:	83 ec 0c             	sub    $0xc,%esp
80104217:	68 20 2e 11 80       	push   $0x80112e20
8010421c:	e8 1f 17 00 00       	call   80105940 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80104221:	8b 0d 68 2e 11 80    	mov    0x80112e68,%ecx
80104227:	83 c4 10             	add    $0x10,%esp
8010422a:	85 c9                	test   %ecx,%ecx
8010422c:	7f 42                	jg     80104270 <end_op+0xa0>
    acquire(&log.lock);
8010422e:	83 ec 0c             	sub    $0xc,%esp
80104231:	68 20 2e 11 80       	push   $0x80112e20
80104236:	e8 65 17 00 00       	call   801059a0 <acquire>
    wakeup(&log);
8010423b:	c7 04 24 20 2e 11 80 	movl   $0x80112e20,(%esp)
    log.committing = 0;
80104242:	c7 05 60 2e 11 80 00 	movl   $0x0,0x80112e60
80104249:	00 00 00 
    wakeup(&log);
8010424c:	e8 af 12 00 00       	call   80105500 <wakeup>
    release(&log.lock);
80104251:	c7 04 24 20 2e 11 80 	movl   $0x80112e20,(%esp)
80104258:	e8 e3 16 00 00       	call   80105940 <release>
8010425d:	83 c4 10             	add    $0x10,%esp
}
80104260:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104263:	5b                   	pop    %ebx
80104264:	5e                   	pop    %esi
80104265:	5f                   	pop    %edi
80104266:	5d                   	pop    %ebp
80104267:	c3                   	ret    
80104268:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010426f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80104270:	a1 54 2e 11 80       	mov    0x80112e54,%eax
80104275:	83 ec 08             	sub    $0x8,%esp
80104278:	01 d8                	add    %ebx,%eax
8010427a:	83 c0 01             	add    $0x1,%eax
8010427d:	50                   	push   %eax
8010427e:	ff 35 64 2e 11 80    	push   0x80112e64
80104284:	e8 47 be ff ff       	call   801000d0 <bread>
80104289:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010428b:	58                   	pop    %eax
8010428c:	5a                   	pop    %edx
8010428d:	ff 34 9d 6c 2e 11 80 	push   -0x7feed194(,%ebx,4)
80104294:	ff 35 64 2e 11 80    	push   0x80112e64
  for (tail = 0; tail < log.lh.n; tail++) {
8010429a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010429d:	e8 2e be ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
801042a2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801042a5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
801042a7:	8d 40 5c             	lea    0x5c(%eax),%eax
801042aa:	68 00 02 00 00       	push   $0x200
801042af:	50                   	push   %eax
801042b0:	8d 46 5c             	lea    0x5c(%esi),%eax
801042b3:	50                   	push   %eax
801042b4:	e8 47 18 00 00       	call   80105b00 <memmove>
    bwrite(to);  // write the log
801042b9:	89 34 24             	mov    %esi,(%esp)
801042bc:	e8 ef be ff ff       	call   801001b0 <bwrite>
    brelse(from);
801042c1:	89 3c 24             	mov    %edi,(%esp)
801042c4:	e8 27 bf ff ff       	call   801001f0 <brelse>
    brelse(to);
801042c9:	89 34 24             	mov    %esi,(%esp)
801042cc:	e8 1f bf ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801042d1:	83 c4 10             	add    $0x10,%esp
801042d4:	3b 1d 68 2e 11 80    	cmp    0x80112e68,%ebx
801042da:	7c 94                	jl     80104270 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
801042dc:	e8 7f fd ff ff       	call   80104060 <write_head>
    install_trans(); // Now install writes to home locations
801042e1:	e8 da fc ff ff       	call   80103fc0 <install_trans>
    log.lh.n = 0;
801042e6:	c7 05 68 2e 11 80 00 	movl   $0x0,0x80112e68
801042ed:	00 00 00 
    write_head();    // Erase the transaction from the log
801042f0:	e8 6b fd ff ff       	call   80104060 <write_head>
801042f5:	e9 34 ff ff ff       	jmp    8010422e <end_op+0x5e>
801042fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80104300:	83 ec 0c             	sub    $0xc,%esp
80104303:	68 20 2e 11 80       	push   $0x80112e20
80104308:	e8 f3 11 00 00       	call   80105500 <wakeup>
  release(&log.lock);
8010430d:	c7 04 24 20 2e 11 80 	movl   $0x80112e20,(%esp)
80104314:	e8 27 16 00 00       	call   80105940 <release>
80104319:	83 c4 10             	add    $0x10,%esp
}
8010431c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010431f:	5b                   	pop    %ebx
80104320:	5e                   	pop    %esi
80104321:	5f                   	pop    %edi
80104322:	5d                   	pop    %ebp
80104323:	c3                   	ret    
    panic("log.committing");
80104324:	83 ec 0c             	sub    $0xc,%esp
80104327:	68 a4 8a 10 80       	push   $0x80108aa4
8010432c:	e8 4f c0 ff ff       	call   80100380 <panic>
80104331:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104338:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010433f:	90                   	nop

80104340 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80104340:	55                   	push   %ebp
80104341:	89 e5                	mov    %esp,%ebp
80104343:	53                   	push   %ebx
80104344:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80104347:	8b 15 68 2e 11 80    	mov    0x80112e68,%edx
{
8010434d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80104350:	83 fa 1d             	cmp    $0x1d,%edx
80104353:	0f 8f 85 00 00 00    	jg     801043de <log_write+0x9e>
80104359:	a1 58 2e 11 80       	mov    0x80112e58,%eax
8010435e:	83 e8 01             	sub    $0x1,%eax
80104361:	39 c2                	cmp    %eax,%edx
80104363:	7d 79                	jge    801043de <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80104365:	a1 5c 2e 11 80       	mov    0x80112e5c,%eax
8010436a:	85 c0                	test   %eax,%eax
8010436c:	7e 7d                	jle    801043eb <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010436e:	83 ec 0c             	sub    $0xc,%esp
80104371:	68 20 2e 11 80       	push   $0x80112e20
80104376:	e8 25 16 00 00       	call   801059a0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
8010437b:	8b 15 68 2e 11 80    	mov    0x80112e68,%edx
80104381:	83 c4 10             	add    $0x10,%esp
80104384:	85 d2                	test   %edx,%edx
80104386:	7e 4a                	jle    801043d2 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80104388:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
8010438b:	31 c0                	xor    %eax,%eax
8010438d:	eb 08                	jmp    80104397 <log_write+0x57>
8010438f:	90                   	nop
80104390:	83 c0 01             	add    $0x1,%eax
80104393:	39 c2                	cmp    %eax,%edx
80104395:	74 29                	je     801043c0 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80104397:	39 0c 85 6c 2e 11 80 	cmp    %ecx,-0x7feed194(,%eax,4)
8010439e:	75 f0                	jne    80104390 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
801043a0:	89 0c 85 6c 2e 11 80 	mov    %ecx,-0x7feed194(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
801043a7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
801043aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
801043ad:	c7 45 08 20 2e 11 80 	movl   $0x80112e20,0x8(%ebp)
}
801043b4:	c9                   	leave  
  release(&log.lock);
801043b5:	e9 86 15 00 00       	jmp    80105940 <release>
801043ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
801043c0:	89 0c 95 6c 2e 11 80 	mov    %ecx,-0x7feed194(,%edx,4)
    log.lh.n++;
801043c7:	83 c2 01             	add    $0x1,%edx
801043ca:	89 15 68 2e 11 80    	mov    %edx,0x80112e68
801043d0:	eb d5                	jmp    801043a7 <log_write+0x67>
  log.lh.block[i] = b->blockno;
801043d2:	8b 43 08             	mov    0x8(%ebx),%eax
801043d5:	a3 6c 2e 11 80       	mov    %eax,0x80112e6c
  if (i == log.lh.n)
801043da:	75 cb                	jne    801043a7 <log_write+0x67>
801043dc:	eb e9                	jmp    801043c7 <log_write+0x87>
    panic("too big a transaction");
801043de:	83 ec 0c             	sub    $0xc,%esp
801043e1:	68 b3 8a 10 80       	push   $0x80108ab3
801043e6:	e8 95 bf ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
801043eb:	83 ec 0c             	sub    $0xc,%esp
801043ee:	68 c9 8a 10 80       	push   $0x80108ac9
801043f3:	e8 88 bf ff ff       	call   80100380 <panic>
801043f8:	66 90                	xchg   %ax,%ax
801043fa:	66 90                	xchg   %ax,%ax
801043fc:	66 90                	xchg   %ax,%ax
801043fe:	66 90                	xchg   %ax,%ax

80104400 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80104400:	55                   	push   %ebp
80104401:	89 e5                	mov    %esp,%ebp
80104403:	53                   	push   %ebx
80104404:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80104407:	e8 44 09 00 00       	call   80104d50 <cpuid>
8010440c:	89 c3                	mov    %eax,%ebx
8010440e:	e8 3d 09 00 00       	call   80104d50 <cpuid>
80104413:	83 ec 04             	sub    $0x4,%esp
80104416:	53                   	push   %ebx
80104417:	50                   	push   %eax
80104418:	68 e4 8a 10 80       	push   $0x80108ae4
8010441d:	e8 de c2 ff ff       	call   80100700 <cprintf>
  idtinit();       // load idt register
80104422:	e8 b9 28 00 00       	call   80106ce0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80104427:	e8 c4 08 00 00       	call   80104cf0 <mycpu>
8010442c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010442e:	b8 01 00 00 00       	mov    $0x1,%eax
80104433:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010443a:	e8 f1 0b 00 00       	call   80105030 <scheduler>
8010443f:	90                   	nop

80104440 <mpenter>:
{
80104440:	55                   	push   %ebp
80104441:	89 e5                	mov    %esp,%ebp
80104443:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80104446:	e8 85 39 00 00       	call   80107dd0 <switchkvm>
  seginit();
8010444b:	e8 f0 38 00 00       	call   80107d40 <seginit>
  lapicinit();
80104450:	e8 9b f7 ff ff       	call   80103bf0 <lapicinit>
  mpmain();
80104455:	e8 a6 ff ff ff       	call   80104400 <mpmain>
8010445a:	66 90                	xchg   %ax,%ax
8010445c:	66 90                	xchg   %ax,%ax
8010445e:	66 90                	xchg   %ax,%ax

80104460 <main>:
{
80104460:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80104464:	83 e4 f0             	and    $0xfffffff0,%esp
80104467:	ff 71 fc             	push   -0x4(%ecx)
8010446a:	55                   	push   %ebp
8010446b:	89 e5                	mov    %esp,%ebp
8010446d:	53                   	push   %ebx
8010446e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010446f:	83 ec 08             	sub    $0x8,%esp
80104472:	68 00 00 40 80       	push   $0x80400000
80104477:	68 50 6c 11 80       	push   $0x80116c50
8010447c:	e8 8f f5 ff ff       	call   80103a10 <kinit1>
  kvmalloc();      // kernel page table
80104481:	e8 3a 3e 00 00       	call   801082c0 <kvmalloc>
  mpinit();        // detect other processors
80104486:	e8 85 01 00 00       	call   80104610 <mpinit>
  lapicinit();     // interrupt controller
8010448b:	e8 60 f7 ff ff       	call   80103bf0 <lapicinit>
  seginit();       // segment descriptors
80104490:	e8 ab 38 00 00       	call   80107d40 <seginit>
  picinit();       // disable pic
80104495:	e8 76 03 00 00       	call   80104810 <picinit>
  ioapicinit();    // another interrupt controller
8010449a:	e8 31 f3 ff ff       	call   801037d0 <ioapicinit>
  consoleinit();   // console hardware
8010449f:	e8 9c d9 ff ff       	call   80101e40 <consoleinit>
  uartinit();      // serial port
801044a4:	e8 27 2b 00 00       	call   80106fd0 <uartinit>
  pinit();         // process table
801044a9:	e8 22 08 00 00       	call   80104cd0 <pinit>
  tvinit();        // trap vectors
801044ae:	e8 ad 27 00 00       	call   80106c60 <tvinit>
  binit();         // buffer cache
801044b3:	e8 88 bb ff ff       	call   80100040 <binit>
  fileinit();      // file table
801044b8:	e8 53 dd ff ff       	call   80102210 <fileinit>
  ideinit();       // disk 
801044bd:	e8 fe f0 ff ff       	call   801035c0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801044c2:	83 c4 0c             	add    $0xc,%esp
801044c5:	68 8a 00 00 00       	push   $0x8a
801044ca:	68 8c b4 10 80       	push   $0x8010b48c
801044cf:	68 00 70 00 80       	push   $0x80007000
801044d4:	e8 27 16 00 00       	call   80105b00 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801044d9:	83 c4 10             	add    $0x10,%esp
801044dc:	69 05 04 2f 11 80 b0 	imul   $0xb0,0x80112f04,%eax
801044e3:	00 00 00 
801044e6:	05 20 2f 11 80       	add    $0x80112f20,%eax
801044eb:	3d 20 2f 11 80       	cmp    $0x80112f20,%eax
801044f0:	76 7e                	jbe    80104570 <main+0x110>
801044f2:	bb 20 2f 11 80       	mov    $0x80112f20,%ebx
801044f7:	eb 20                	jmp    80104519 <main+0xb9>
801044f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104500:	69 05 04 2f 11 80 b0 	imul   $0xb0,0x80112f04,%eax
80104507:	00 00 00 
8010450a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80104510:	05 20 2f 11 80       	add    $0x80112f20,%eax
80104515:	39 c3                	cmp    %eax,%ebx
80104517:	73 57                	jae    80104570 <main+0x110>
    if(c == mycpu())  // We've started already.
80104519:	e8 d2 07 00 00       	call   80104cf0 <mycpu>
8010451e:	39 c3                	cmp    %eax,%ebx
80104520:	74 de                	je     80104500 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80104522:	e8 59 f5 ff ff       	call   80103a80 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80104527:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010452a:	c7 05 f8 6f 00 80 40 	movl   $0x80104440,0x80006ff8
80104531:	44 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80104534:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010453b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010453e:	05 00 10 00 00       	add    $0x1000,%eax
80104543:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80104548:	0f b6 03             	movzbl (%ebx),%eax
8010454b:	68 00 70 00 00       	push   $0x7000
80104550:	50                   	push   %eax
80104551:	e8 ea f7 ff ff       	call   80103d40 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80104556:	83 c4 10             	add    $0x10,%esp
80104559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104560:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80104566:	85 c0                	test   %eax,%eax
80104568:	74 f6                	je     80104560 <main+0x100>
8010456a:	eb 94                	jmp    80104500 <main+0xa0>
8010456c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80104570:	83 ec 08             	sub    $0x8,%esp
80104573:	68 00 00 00 8e       	push   $0x8e000000
80104578:	68 00 00 40 80       	push   $0x80400000
8010457d:	e8 2e f4 ff ff       	call   801039b0 <kinit2>
  userinit();      // first user process
80104582:	e8 19 08 00 00       	call   80104da0 <userinit>
  mpmain();        // finish this processor's setup
80104587:	e8 74 fe ff ff       	call   80104400 <mpmain>
8010458c:	66 90                	xchg   %ax,%ax
8010458e:	66 90                	xchg   %ax,%ax

80104590 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80104590:	55                   	push   %ebp
80104591:	89 e5                	mov    %esp,%ebp
80104593:	57                   	push   %edi
80104594:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80104595:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010459b:	53                   	push   %ebx
  e = addr+len;
8010459c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010459f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801045a2:	39 de                	cmp    %ebx,%esi
801045a4:	72 10                	jb     801045b6 <mpsearch1+0x26>
801045a6:	eb 50                	jmp    801045f8 <mpsearch1+0x68>
801045a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045af:	90                   	nop
801045b0:	89 fe                	mov    %edi,%esi
801045b2:	39 fb                	cmp    %edi,%ebx
801045b4:	76 42                	jbe    801045f8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801045b6:	83 ec 04             	sub    $0x4,%esp
801045b9:	8d 7e 10             	lea    0x10(%esi),%edi
801045bc:	6a 04                	push   $0x4
801045be:	68 f8 8a 10 80       	push   $0x80108af8
801045c3:	56                   	push   %esi
801045c4:	e8 e7 14 00 00       	call   80105ab0 <memcmp>
801045c9:	83 c4 10             	add    $0x10,%esp
801045cc:	85 c0                	test   %eax,%eax
801045ce:	75 e0                	jne    801045b0 <mpsearch1+0x20>
801045d0:	89 f2                	mov    %esi,%edx
801045d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801045d8:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801045db:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801045de:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801045e0:	39 fa                	cmp    %edi,%edx
801045e2:	75 f4                	jne    801045d8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801045e4:	84 c0                	test   %al,%al
801045e6:	75 c8                	jne    801045b0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801045e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801045eb:	89 f0                	mov    %esi,%eax
801045ed:	5b                   	pop    %ebx
801045ee:	5e                   	pop    %esi
801045ef:	5f                   	pop    %edi
801045f0:	5d                   	pop    %ebp
801045f1:	c3                   	ret    
801045f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801045f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801045fb:	31 f6                	xor    %esi,%esi
}
801045fd:	5b                   	pop    %ebx
801045fe:	89 f0                	mov    %esi,%eax
80104600:	5e                   	pop    %esi
80104601:	5f                   	pop    %edi
80104602:	5d                   	pop    %ebp
80104603:	c3                   	ret    
80104604:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010460b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010460f:	90                   	nop

80104610 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80104610:	55                   	push   %ebp
80104611:	89 e5                	mov    %esp,%ebp
80104613:	57                   	push   %edi
80104614:	56                   	push   %esi
80104615:	53                   	push   %ebx
80104616:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80104619:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80104620:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80104627:	c1 e0 08             	shl    $0x8,%eax
8010462a:	09 d0                	or     %edx,%eax
8010462c:	c1 e0 04             	shl    $0x4,%eax
8010462f:	75 1b                	jne    8010464c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80104631:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80104638:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010463f:	c1 e0 08             	shl    $0x8,%eax
80104642:	09 d0                	or     %edx,%eax
80104644:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80104647:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010464c:	ba 00 04 00 00       	mov    $0x400,%edx
80104651:	e8 3a ff ff ff       	call   80104590 <mpsearch1>
80104656:	89 c3                	mov    %eax,%ebx
80104658:	85 c0                	test   %eax,%eax
8010465a:	0f 84 40 01 00 00    	je     801047a0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80104660:	8b 73 04             	mov    0x4(%ebx),%esi
80104663:	85 f6                	test   %esi,%esi
80104665:	0f 84 25 01 00 00    	je     80104790 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
8010466b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010466e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80104674:	6a 04                	push   $0x4
80104676:	68 fd 8a 10 80       	push   $0x80108afd
8010467b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010467c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010467f:	e8 2c 14 00 00       	call   80105ab0 <memcmp>
80104684:	83 c4 10             	add    $0x10,%esp
80104687:	85 c0                	test   %eax,%eax
80104689:	0f 85 01 01 00 00    	jne    80104790 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
8010468f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80104696:	3c 01                	cmp    $0x1,%al
80104698:	74 08                	je     801046a2 <mpinit+0x92>
8010469a:	3c 04                	cmp    $0x4,%al
8010469c:	0f 85 ee 00 00 00    	jne    80104790 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
801046a2:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
801046a9:	66 85 d2             	test   %dx,%dx
801046ac:	74 22                	je     801046d0 <mpinit+0xc0>
801046ae:	8d 3c 32             	lea    (%edx,%esi,1),%edi
801046b1:	89 f0                	mov    %esi,%eax
  sum = 0;
801046b3:	31 d2                	xor    %edx,%edx
801046b5:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801046b8:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
801046bf:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801046c2:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801046c4:	39 c7                	cmp    %eax,%edi
801046c6:	75 f0                	jne    801046b8 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
801046c8:	84 d2                	test   %dl,%dl
801046ca:	0f 85 c0 00 00 00    	jne    80104790 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801046d0:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
801046d6:	a3 00 2e 11 80       	mov    %eax,0x80112e00
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801046db:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801046e2:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
801046e8:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801046ed:	03 55 e4             	add    -0x1c(%ebp),%edx
801046f0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801046f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046f7:	90                   	nop
801046f8:	39 d0                	cmp    %edx,%eax
801046fa:	73 15                	jae    80104711 <mpinit+0x101>
    switch(*p){
801046fc:	0f b6 08             	movzbl (%eax),%ecx
801046ff:	80 f9 02             	cmp    $0x2,%cl
80104702:	74 4c                	je     80104750 <mpinit+0x140>
80104704:	77 3a                	ja     80104740 <mpinit+0x130>
80104706:	84 c9                	test   %cl,%cl
80104708:	74 56                	je     80104760 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
8010470a:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010470d:	39 d0                	cmp    %edx,%eax
8010470f:	72 eb                	jb     801046fc <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80104711:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80104714:	85 f6                	test   %esi,%esi
80104716:	0f 84 d9 00 00 00    	je     801047f5 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010471c:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80104720:	74 15                	je     80104737 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80104722:	b8 70 00 00 00       	mov    $0x70,%eax
80104727:	ba 22 00 00 00       	mov    $0x22,%edx
8010472c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010472d:	ba 23 00 00 00       	mov    $0x23,%edx
80104732:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80104733:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80104736:	ee                   	out    %al,(%dx)
  }
}
80104737:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010473a:	5b                   	pop    %ebx
8010473b:	5e                   	pop    %esi
8010473c:	5f                   	pop    %edi
8010473d:	5d                   	pop    %ebp
8010473e:	c3                   	ret    
8010473f:	90                   	nop
    switch(*p){
80104740:	83 e9 03             	sub    $0x3,%ecx
80104743:	80 f9 01             	cmp    $0x1,%cl
80104746:	76 c2                	jbe    8010470a <mpinit+0xfa>
80104748:	31 f6                	xor    %esi,%esi
8010474a:	eb ac                	jmp    801046f8 <mpinit+0xe8>
8010474c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80104750:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80104754:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80104757:	88 0d 00 2f 11 80    	mov    %cl,0x80112f00
      continue;
8010475d:	eb 99                	jmp    801046f8 <mpinit+0xe8>
8010475f:	90                   	nop
      if(ncpu < NCPU) {
80104760:	8b 0d 04 2f 11 80    	mov    0x80112f04,%ecx
80104766:	83 f9 07             	cmp    $0x7,%ecx
80104769:	7f 19                	jg     80104784 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010476b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80104771:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80104775:	83 c1 01             	add    $0x1,%ecx
80104778:	89 0d 04 2f 11 80    	mov    %ecx,0x80112f04
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010477e:	88 9f 20 2f 11 80    	mov    %bl,-0x7feed0e0(%edi)
      p += sizeof(struct mpproc);
80104784:	83 c0 14             	add    $0x14,%eax
      continue;
80104787:	e9 6c ff ff ff       	jmp    801046f8 <mpinit+0xe8>
8010478c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80104790:	83 ec 0c             	sub    $0xc,%esp
80104793:	68 02 8b 10 80       	push   $0x80108b02
80104798:	e8 e3 bb ff ff       	call   80100380 <panic>
8010479d:	8d 76 00             	lea    0x0(%esi),%esi
{
801047a0:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
801047a5:	eb 13                	jmp    801047ba <mpinit+0x1aa>
801047a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047ae:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
801047b0:	89 f3                	mov    %esi,%ebx
801047b2:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
801047b8:	74 d6                	je     80104790 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801047ba:	83 ec 04             	sub    $0x4,%esp
801047bd:	8d 73 10             	lea    0x10(%ebx),%esi
801047c0:	6a 04                	push   $0x4
801047c2:	68 f8 8a 10 80       	push   $0x80108af8
801047c7:	53                   	push   %ebx
801047c8:	e8 e3 12 00 00       	call   80105ab0 <memcmp>
801047cd:	83 c4 10             	add    $0x10,%esp
801047d0:	85 c0                	test   %eax,%eax
801047d2:	75 dc                	jne    801047b0 <mpinit+0x1a0>
801047d4:	89 da                	mov    %ebx,%edx
801047d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047dd:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801047e0:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801047e3:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801047e6:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801047e8:	39 d6                	cmp    %edx,%esi
801047ea:	75 f4                	jne    801047e0 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801047ec:	84 c0                	test   %al,%al
801047ee:	75 c0                	jne    801047b0 <mpinit+0x1a0>
801047f0:	e9 6b fe ff ff       	jmp    80104660 <mpinit+0x50>
    panic("Didn't find a suitable machine");
801047f5:	83 ec 0c             	sub    $0xc,%esp
801047f8:	68 1c 8b 10 80       	push   $0x80108b1c
801047fd:	e8 7e bb ff ff       	call   80100380 <panic>
80104802:	66 90                	xchg   %ax,%ax
80104804:	66 90                	xchg   %ax,%ax
80104806:	66 90                	xchg   %ax,%ax
80104808:	66 90                	xchg   %ax,%ax
8010480a:	66 90                	xchg   %ax,%ax
8010480c:	66 90                	xchg   %ax,%ax
8010480e:	66 90                	xchg   %ax,%ax

80104810 <picinit>:
80104810:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104815:	ba 21 00 00 00       	mov    $0x21,%edx
8010481a:	ee                   	out    %al,(%dx)
8010481b:	ba a1 00 00 00       	mov    $0xa1,%edx
80104820:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80104821:	c3                   	ret    
80104822:	66 90                	xchg   %ax,%ax
80104824:	66 90                	xchg   %ax,%ax
80104826:	66 90                	xchg   %ax,%ax
80104828:	66 90                	xchg   %ax,%ax
8010482a:	66 90                	xchg   %ax,%ax
8010482c:	66 90                	xchg   %ax,%ax
8010482e:	66 90                	xchg   %ax,%ax

80104830 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80104830:	55                   	push   %ebp
80104831:	89 e5                	mov    %esp,%ebp
80104833:	57                   	push   %edi
80104834:	56                   	push   %esi
80104835:	53                   	push   %ebx
80104836:	83 ec 0c             	sub    $0xc,%esp
80104839:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010483c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010483f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80104845:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010484b:	e8 e0 d9 ff ff       	call   80102230 <filealloc>
80104850:	89 03                	mov    %eax,(%ebx)
80104852:	85 c0                	test   %eax,%eax
80104854:	0f 84 a8 00 00 00    	je     80104902 <pipealloc+0xd2>
8010485a:	e8 d1 d9 ff ff       	call   80102230 <filealloc>
8010485f:	89 06                	mov    %eax,(%esi)
80104861:	85 c0                	test   %eax,%eax
80104863:	0f 84 87 00 00 00    	je     801048f0 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80104869:	e8 12 f2 ff ff       	call   80103a80 <kalloc>
8010486e:	89 c7                	mov    %eax,%edi
80104870:	85 c0                	test   %eax,%eax
80104872:	0f 84 b0 00 00 00    	je     80104928 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80104878:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010487f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80104882:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80104885:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010488c:	00 00 00 
  p->nwrite = 0;
8010488f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80104896:	00 00 00 
  p->nread = 0;
80104899:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801048a0:	00 00 00 
  initlock(&p->lock, "pipe");
801048a3:	68 3b 8b 10 80       	push   $0x80108b3b
801048a8:	50                   	push   %eax
801048a9:	e8 22 0f 00 00       	call   801057d0 <initlock>
  (*f0)->type = FD_PIPE;
801048ae:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801048b0:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801048b3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801048b9:	8b 03                	mov    (%ebx),%eax
801048bb:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801048bf:	8b 03                	mov    (%ebx),%eax
801048c1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801048c5:	8b 03                	mov    (%ebx),%eax
801048c7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801048ca:	8b 06                	mov    (%esi),%eax
801048cc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801048d2:	8b 06                	mov    (%esi),%eax
801048d4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801048d8:	8b 06                	mov    (%esi),%eax
801048da:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801048de:	8b 06                	mov    (%esi),%eax
801048e0:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801048e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801048e6:	31 c0                	xor    %eax,%eax
}
801048e8:	5b                   	pop    %ebx
801048e9:	5e                   	pop    %esi
801048ea:	5f                   	pop    %edi
801048eb:	5d                   	pop    %ebp
801048ec:	c3                   	ret    
801048ed:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
801048f0:	8b 03                	mov    (%ebx),%eax
801048f2:	85 c0                	test   %eax,%eax
801048f4:	74 1e                	je     80104914 <pipealloc+0xe4>
    fileclose(*f0);
801048f6:	83 ec 0c             	sub    $0xc,%esp
801048f9:	50                   	push   %eax
801048fa:	e8 f1 d9 ff ff       	call   801022f0 <fileclose>
801048ff:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80104902:	8b 06                	mov    (%esi),%eax
80104904:	85 c0                	test   %eax,%eax
80104906:	74 0c                	je     80104914 <pipealloc+0xe4>
    fileclose(*f1);
80104908:	83 ec 0c             	sub    $0xc,%esp
8010490b:	50                   	push   %eax
8010490c:	e8 df d9 ff ff       	call   801022f0 <fileclose>
80104911:	83 c4 10             	add    $0x10,%esp
}
80104914:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80104917:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010491c:	5b                   	pop    %ebx
8010491d:	5e                   	pop    %esi
8010491e:	5f                   	pop    %edi
8010491f:	5d                   	pop    %ebp
80104920:	c3                   	ret    
80104921:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80104928:	8b 03                	mov    (%ebx),%eax
8010492a:	85 c0                	test   %eax,%eax
8010492c:	75 c8                	jne    801048f6 <pipealloc+0xc6>
8010492e:	eb d2                	jmp    80104902 <pipealloc+0xd2>

80104930 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80104930:	55                   	push   %ebp
80104931:	89 e5                	mov    %esp,%ebp
80104933:	56                   	push   %esi
80104934:	53                   	push   %ebx
80104935:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104938:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010493b:	83 ec 0c             	sub    $0xc,%esp
8010493e:	53                   	push   %ebx
8010493f:	e8 5c 10 00 00       	call   801059a0 <acquire>
  if(writable){
80104944:	83 c4 10             	add    $0x10,%esp
80104947:	85 f6                	test   %esi,%esi
80104949:	74 65                	je     801049b0 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010494b:	83 ec 0c             	sub    $0xc,%esp
8010494e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80104954:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010495b:	00 00 00 
    wakeup(&p->nread);
8010495e:	50                   	push   %eax
8010495f:	e8 9c 0b 00 00       	call   80105500 <wakeup>
80104964:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80104967:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010496d:	85 d2                	test   %edx,%edx
8010496f:	75 0a                	jne    8010497b <pipeclose+0x4b>
80104971:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80104977:	85 c0                	test   %eax,%eax
80104979:	74 15                	je     80104990 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010497b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010497e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104981:	5b                   	pop    %ebx
80104982:	5e                   	pop    %esi
80104983:	5d                   	pop    %ebp
    release(&p->lock);
80104984:	e9 b7 0f 00 00       	jmp    80105940 <release>
80104989:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80104990:	83 ec 0c             	sub    $0xc,%esp
80104993:	53                   	push   %ebx
80104994:	e8 a7 0f 00 00       	call   80105940 <release>
    kfree((char*)p);
80104999:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010499c:	83 c4 10             	add    $0x10,%esp
}
8010499f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801049a2:	5b                   	pop    %ebx
801049a3:	5e                   	pop    %esi
801049a4:	5d                   	pop    %ebp
    kfree((char*)p);
801049a5:	e9 16 ef ff ff       	jmp    801038c0 <kfree>
801049aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801049b0:	83 ec 0c             	sub    $0xc,%esp
801049b3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801049b9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801049c0:	00 00 00 
    wakeup(&p->nwrite);
801049c3:	50                   	push   %eax
801049c4:	e8 37 0b 00 00       	call   80105500 <wakeup>
801049c9:	83 c4 10             	add    $0x10,%esp
801049cc:	eb 99                	jmp    80104967 <pipeclose+0x37>
801049ce:	66 90                	xchg   %ax,%ax

801049d0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801049d0:	55                   	push   %ebp
801049d1:	89 e5                	mov    %esp,%ebp
801049d3:	57                   	push   %edi
801049d4:	56                   	push   %esi
801049d5:	53                   	push   %ebx
801049d6:	83 ec 28             	sub    $0x28,%esp
801049d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801049dc:	53                   	push   %ebx
801049dd:	e8 be 0f 00 00       	call   801059a0 <acquire>
  for(i = 0; i < n; i++){
801049e2:	8b 45 10             	mov    0x10(%ebp),%eax
801049e5:	83 c4 10             	add    $0x10,%esp
801049e8:	85 c0                	test   %eax,%eax
801049ea:	0f 8e c0 00 00 00    	jle    80104ab0 <pipewrite+0xe0>
801049f0:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801049f3:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801049f9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801049ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104a02:	03 45 10             	add    0x10(%ebp),%eax
80104a05:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104a08:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80104a0e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104a14:	89 ca                	mov    %ecx,%edx
80104a16:	05 00 02 00 00       	add    $0x200,%eax
80104a1b:	39 c1                	cmp    %eax,%ecx
80104a1d:	74 3f                	je     80104a5e <pipewrite+0x8e>
80104a1f:	eb 67                	jmp    80104a88 <pipewrite+0xb8>
80104a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80104a28:	e8 43 03 00 00       	call   80104d70 <myproc>
80104a2d:	8b 48 24             	mov    0x24(%eax),%ecx
80104a30:	85 c9                	test   %ecx,%ecx
80104a32:	75 34                	jne    80104a68 <pipewrite+0x98>
      wakeup(&p->nread);
80104a34:	83 ec 0c             	sub    $0xc,%esp
80104a37:	57                   	push   %edi
80104a38:	e8 c3 0a 00 00       	call   80105500 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80104a3d:	58                   	pop    %eax
80104a3e:	5a                   	pop    %edx
80104a3f:	53                   	push   %ebx
80104a40:	56                   	push   %esi
80104a41:	e8 fa 09 00 00       	call   80105440 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104a46:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80104a4c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80104a52:	83 c4 10             	add    $0x10,%esp
80104a55:	05 00 02 00 00       	add    $0x200,%eax
80104a5a:	39 c2                	cmp    %eax,%edx
80104a5c:	75 2a                	jne    80104a88 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
80104a5e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80104a64:	85 c0                	test   %eax,%eax
80104a66:	75 c0                	jne    80104a28 <pipewrite+0x58>
        release(&p->lock);
80104a68:	83 ec 0c             	sub    $0xc,%esp
80104a6b:	53                   	push   %ebx
80104a6c:	e8 cf 0e 00 00       	call   80105940 <release>
        return -1;
80104a71:	83 c4 10             	add    $0x10,%esp
80104a74:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80104a79:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a7c:	5b                   	pop    %ebx
80104a7d:	5e                   	pop    %esi
80104a7e:	5f                   	pop    %edi
80104a7f:	5d                   	pop    %ebp
80104a80:	c3                   	ret    
80104a81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80104a88:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80104a8b:	8d 4a 01             	lea    0x1(%edx),%ecx
80104a8e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80104a94:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
80104a9a:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
80104a9d:	83 c6 01             	add    $0x1,%esi
80104aa0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80104aa3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80104aa7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80104aaa:	0f 85 58 ff ff ff    	jne    80104a08 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80104ab0:	83 ec 0c             	sub    $0xc,%esp
80104ab3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80104ab9:	50                   	push   %eax
80104aba:	e8 41 0a 00 00       	call   80105500 <wakeup>
  release(&p->lock);
80104abf:	89 1c 24             	mov    %ebx,(%esp)
80104ac2:	e8 79 0e 00 00       	call   80105940 <release>
  return n;
80104ac7:	8b 45 10             	mov    0x10(%ebp),%eax
80104aca:	83 c4 10             	add    $0x10,%esp
80104acd:	eb aa                	jmp    80104a79 <pipewrite+0xa9>
80104acf:	90                   	nop

80104ad0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80104ad0:	55                   	push   %ebp
80104ad1:	89 e5                	mov    %esp,%ebp
80104ad3:	57                   	push   %edi
80104ad4:	56                   	push   %esi
80104ad5:	53                   	push   %ebx
80104ad6:	83 ec 18             	sub    $0x18,%esp
80104ad9:	8b 75 08             	mov    0x8(%ebp),%esi
80104adc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80104adf:	56                   	push   %esi
80104ae0:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80104ae6:	e8 b5 0e 00 00       	call   801059a0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104aeb:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80104af1:	83 c4 10             	add    $0x10,%esp
80104af4:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
80104afa:	74 2f                	je     80104b2b <piperead+0x5b>
80104afc:	eb 37                	jmp    80104b35 <piperead+0x65>
80104afe:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80104b00:	e8 6b 02 00 00       	call   80104d70 <myproc>
80104b05:	8b 48 24             	mov    0x24(%eax),%ecx
80104b08:	85 c9                	test   %ecx,%ecx
80104b0a:	0f 85 80 00 00 00    	jne    80104b90 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80104b10:	83 ec 08             	sub    $0x8,%esp
80104b13:	56                   	push   %esi
80104b14:	53                   	push   %ebx
80104b15:	e8 26 09 00 00       	call   80105440 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104b1a:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80104b20:	83 c4 10             	add    $0x10,%esp
80104b23:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80104b29:	75 0a                	jne    80104b35 <piperead+0x65>
80104b2b:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80104b31:	85 c0                	test   %eax,%eax
80104b33:	75 cb                	jne    80104b00 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104b35:	8b 55 10             	mov    0x10(%ebp),%edx
80104b38:	31 db                	xor    %ebx,%ebx
80104b3a:	85 d2                	test   %edx,%edx
80104b3c:	7f 20                	jg     80104b5e <piperead+0x8e>
80104b3e:	eb 2c                	jmp    80104b6c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80104b40:	8d 48 01             	lea    0x1(%eax),%ecx
80104b43:	25 ff 01 00 00       	and    $0x1ff,%eax
80104b48:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
80104b4e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80104b53:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104b56:	83 c3 01             	add    $0x1,%ebx
80104b59:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80104b5c:	74 0e                	je     80104b6c <piperead+0x9c>
    if(p->nread == p->nwrite)
80104b5e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80104b64:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80104b6a:	75 d4                	jne    80104b40 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80104b6c:	83 ec 0c             	sub    $0xc,%esp
80104b6f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80104b75:	50                   	push   %eax
80104b76:	e8 85 09 00 00       	call   80105500 <wakeup>
  release(&p->lock);
80104b7b:	89 34 24             	mov    %esi,(%esp)
80104b7e:	e8 bd 0d 00 00       	call   80105940 <release>
  return i;
80104b83:	83 c4 10             	add    $0x10,%esp
}
80104b86:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b89:	89 d8                	mov    %ebx,%eax
80104b8b:	5b                   	pop    %ebx
80104b8c:	5e                   	pop    %esi
80104b8d:	5f                   	pop    %edi
80104b8e:	5d                   	pop    %ebp
80104b8f:	c3                   	ret    
      release(&p->lock);
80104b90:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104b93:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80104b98:	56                   	push   %esi
80104b99:	e8 a2 0d 00 00       	call   80105940 <release>
      return -1;
80104b9e:	83 c4 10             	add    $0x10,%esp
}
80104ba1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ba4:	89 d8                	mov    %ebx,%eax
80104ba6:	5b                   	pop    %ebx
80104ba7:	5e                   	pop    %esi
80104ba8:	5f                   	pop    %edi
80104ba9:	5d                   	pop    %ebp
80104baa:	c3                   	ret    
80104bab:	66 90                	xchg   %ax,%ax
80104bad:	66 90                	xchg   %ax,%ax
80104baf:	90                   	nop

80104bb0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80104bb0:	55                   	push   %ebp
80104bb1:	89 e5                	mov    %esp,%ebp
80104bb3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104bb4:	bb d4 34 11 80       	mov    $0x801134d4,%ebx
{
80104bb9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80104bbc:	68 a0 34 11 80       	push   $0x801134a0
80104bc1:	e8 da 0d 00 00       	call   801059a0 <acquire>
80104bc6:	83 c4 10             	add    $0x10,%esp
80104bc9:	eb 10                	jmp    80104bdb <allocproc+0x2b>
80104bcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104bcf:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104bd0:	83 c3 7c             	add    $0x7c,%ebx
80104bd3:	81 fb d4 53 11 80    	cmp    $0x801153d4,%ebx
80104bd9:	74 75                	je     80104c50 <allocproc+0xa0>
    if(p->state == UNUSED)
80104bdb:	8b 43 0c             	mov    0xc(%ebx),%eax
80104bde:	85 c0                	test   %eax,%eax
80104be0:	75 ee                	jne    80104bd0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80104be2:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
80104be7:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80104bea:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80104bf1:	89 43 10             	mov    %eax,0x10(%ebx)
80104bf4:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80104bf7:	68 a0 34 11 80       	push   $0x801134a0
  p->pid = nextpid++;
80104bfc:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80104c02:	e8 39 0d 00 00       	call   80105940 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80104c07:	e8 74 ee ff ff       	call   80103a80 <kalloc>
80104c0c:	83 c4 10             	add    $0x10,%esp
80104c0f:	89 43 08             	mov    %eax,0x8(%ebx)
80104c12:	85 c0                	test   %eax,%eax
80104c14:	74 53                	je     80104c69 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80104c16:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80104c1c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80104c1f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80104c24:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80104c27:	c7 40 14 52 6c 10 80 	movl   $0x80106c52,0x14(%eax)
  p->context = (struct context*)sp;
80104c2e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80104c31:	6a 14                	push   $0x14
80104c33:	6a 00                	push   $0x0
80104c35:	50                   	push   %eax
80104c36:	e8 25 0e 00 00       	call   80105a60 <memset>
  p->context->eip = (uint)forkret;
80104c3b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80104c3e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80104c41:	c7 40 10 80 4c 10 80 	movl   $0x80104c80,0x10(%eax)
}
80104c48:	89 d8                	mov    %ebx,%eax
80104c4a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c4d:	c9                   	leave  
80104c4e:	c3                   	ret    
80104c4f:	90                   	nop
  release(&ptable.lock);
80104c50:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80104c53:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80104c55:	68 a0 34 11 80       	push   $0x801134a0
80104c5a:	e8 e1 0c 00 00       	call   80105940 <release>
}
80104c5f:	89 d8                	mov    %ebx,%eax
  return 0;
80104c61:	83 c4 10             	add    $0x10,%esp
}
80104c64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c67:	c9                   	leave  
80104c68:	c3                   	ret    
    p->state = UNUSED;
80104c69:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80104c70:	31 db                	xor    %ebx,%ebx
}
80104c72:	89 d8                	mov    %ebx,%eax
80104c74:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c77:	c9                   	leave  
80104c78:	c3                   	ret    
80104c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104c80 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104c80:	55                   	push   %ebp
80104c81:	89 e5                	mov    %esp,%ebp
80104c83:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104c86:	68 a0 34 11 80       	push   $0x801134a0
80104c8b:	e8 b0 0c 00 00       	call   80105940 <release>

  if (first) {
80104c90:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80104c95:	83 c4 10             	add    $0x10,%esp
80104c98:	85 c0                	test   %eax,%eax
80104c9a:	75 04                	jne    80104ca0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80104c9c:	c9                   	leave  
80104c9d:	c3                   	ret    
80104c9e:	66 90                	xchg   %ax,%ax
    first = 0;
80104ca0:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80104ca7:	00 00 00 
    iinit(ROOTDEV);
80104caa:	83 ec 0c             	sub    $0xc,%esp
80104cad:	6a 01                	push   $0x1
80104caf:	e8 ac dc ff ff       	call   80102960 <iinit>
    initlog(ROOTDEV);
80104cb4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104cbb:	e8 00 f4 ff ff       	call   801040c0 <initlog>
}
80104cc0:	83 c4 10             	add    $0x10,%esp
80104cc3:	c9                   	leave  
80104cc4:	c3                   	ret    
80104cc5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ccc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104cd0 <pinit>:
{
80104cd0:	55                   	push   %ebp
80104cd1:	89 e5                	mov    %esp,%ebp
80104cd3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80104cd6:	68 40 8b 10 80       	push   $0x80108b40
80104cdb:	68 a0 34 11 80       	push   $0x801134a0
80104ce0:	e8 eb 0a 00 00       	call   801057d0 <initlock>
}
80104ce5:	83 c4 10             	add    $0x10,%esp
80104ce8:	c9                   	leave  
80104ce9:	c3                   	ret    
80104cea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104cf0 <mycpu>:
{
80104cf0:	55                   	push   %ebp
80104cf1:	89 e5                	mov    %esp,%ebp
80104cf3:	56                   	push   %esi
80104cf4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104cf5:	9c                   	pushf  
80104cf6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104cf7:	f6 c4 02             	test   $0x2,%ah
80104cfa:	75 46                	jne    80104d42 <mycpu+0x52>
  apicid = lapicid();
80104cfc:	e8 ef ef ff ff       	call   80103cf0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80104d01:	8b 35 04 2f 11 80    	mov    0x80112f04,%esi
80104d07:	85 f6                	test   %esi,%esi
80104d09:	7e 2a                	jle    80104d35 <mycpu+0x45>
80104d0b:	31 d2                	xor    %edx,%edx
80104d0d:	eb 08                	jmp    80104d17 <mycpu+0x27>
80104d0f:	90                   	nop
80104d10:	83 c2 01             	add    $0x1,%edx
80104d13:	39 f2                	cmp    %esi,%edx
80104d15:	74 1e                	je     80104d35 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80104d17:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80104d1d:	0f b6 99 20 2f 11 80 	movzbl -0x7feed0e0(%ecx),%ebx
80104d24:	39 c3                	cmp    %eax,%ebx
80104d26:	75 e8                	jne    80104d10 <mycpu+0x20>
}
80104d28:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80104d2b:	8d 81 20 2f 11 80    	lea    -0x7feed0e0(%ecx),%eax
}
80104d31:	5b                   	pop    %ebx
80104d32:	5e                   	pop    %esi
80104d33:	5d                   	pop    %ebp
80104d34:	c3                   	ret    
  panic("unknown apicid\n");
80104d35:	83 ec 0c             	sub    $0xc,%esp
80104d38:	68 47 8b 10 80       	push   $0x80108b47
80104d3d:	e8 3e b6 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80104d42:	83 ec 0c             	sub    $0xc,%esp
80104d45:	68 24 8c 10 80       	push   $0x80108c24
80104d4a:	e8 31 b6 ff ff       	call   80100380 <panic>
80104d4f:	90                   	nop

80104d50 <cpuid>:
cpuid() {
80104d50:	55                   	push   %ebp
80104d51:	89 e5                	mov    %esp,%ebp
80104d53:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80104d56:	e8 95 ff ff ff       	call   80104cf0 <mycpu>
}
80104d5b:	c9                   	leave  
  return mycpu()-cpus;
80104d5c:	2d 20 2f 11 80       	sub    $0x80112f20,%eax
80104d61:	c1 f8 04             	sar    $0x4,%eax
80104d64:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80104d6a:	c3                   	ret    
80104d6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d6f:	90                   	nop

80104d70 <myproc>:
myproc(void) {
80104d70:	55                   	push   %ebp
80104d71:	89 e5                	mov    %esp,%ebp
80104d73:	53                   	push   %ebx
80104d74:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80104d77:	e8 d4 0a 00 00       	call   80105850 <pushcli>
  c = mycpu();
80104d7c:	e8 6f ff ff ff       	call   80104cf0 <mycpu>
  p = c->proc;
80104d81:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104d87:	e8 14 0b 00 00       	call   801058a0 <popcli>
}
80104d8c:	89 d8                	mov    %ebx,%eax
80104d8e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d91:	c9                   	leave  
80104d92:	c3                   	ret    
80104d93:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104da0 <userinit>:
{
80104da0:	55                   	push   %ebp
80104da1:	89 e5                	mov    %esp,%ebp
80104da3:	53                   	push   %ebx
80104da4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80104da7:	e8 04 fe ff ff       	call   80104bb0 <allocproc>
80104dac:	89 c3                	mov    %eax,%ebx
  initproc = p;
80104dae:	a3 d4 53 11 80       	mov    %eax,0x801153d4
  if((p->pgdir = setupkvm()) == 0)
80104db3:	e8 88 34 00 00       	call   80108240 <setupkvm>
80104db8:	89 43 04             	mov    %eax,0x4(%ebx)
80104dbb:	85 c0                	test   %eax,%eax
80104dbd:	0f 84 bd 00 00 00    	je     80104e80 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104dc3:	83 ec 04             	sub    $0x4,%esp
80104dc6:	68 2c 00 00 00       	push   $0x2c
80104dcb:	68 60 b4 10 80       	push   $0x8010b460
80104dd0:	50                   	push   %eax
80104dd1:	e8 1a 31 00 00       	call   80107ef0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80104dd6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80104dd9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80104ddf:	6a 4c                	push   $0x4c
80104de1:	6a 00                	push   $0x0
80104de3:	ff 73 18             	push   0x18(%ebx)
80104de6:	e8 75 0c 00 00       	call   80105a60 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104deb:	8b 43 18             	mov    0x18(%ebx),%eax
80104dee:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80104df3:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104df6:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104dfb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104dff:	8b 43 18             	mov    0x18(%ebx),%eax
80104e02:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104e06:	8b 43 18             	mov    0x18(%ebx),%eax
80104e09:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80104e0d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80104e11:	8b 43 18             	mov    0x18(%ebx),%eax
80104e14:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80104e18:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80104e1c:	8b 43 18             	mov    0x18(%ebx),%eax
80104e1f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80104e26:	8b 43 18             	mov    0x18(%ebx),%eax
80104e29:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104e30:	8b 43 18             	mov    0x18(%ebx),%eax
80104e33:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80104e3a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104e3d:	6a 10                	push   $0x10
80104e3f:	68 70 8b 10 80       	push   $0x80108b70
80104e44:	50                   	push   %eax
80104e45:	e8 d6 0d 00 00       	call   80105c20 <safestrcpy>
  p->cwd = namei("/");
80104e4a:	c7 04 24 79 8b 10 80 	movl   $0x80108b79,(%esp)
80104e51:	e8 4a e6 ff ff       	call   801034a0 <namei>
80104e56:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80104e59:	c7 04 24 a0 34 11 80 	movl   $0x801134a0,(%esp)
80104e60:	e8 3b 0b 00 00       	call   801059a0 <acquire>
  p->state = RUNNABLE;
80104e65:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80104e6c:	c7 04 24 a0 34 11 80 	movl   $0x801134a0,(%esp)
80104e73:	e8 c8 0a 00 00       	call   80105940 <release>
}
80104e78:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e7b:	83 c4 10             	add    $0x10,%esp
80104e7e:	c9                   	leave  
80104e7f:	c3                   	ret    
    panic("userinit: out of memory?");
80104e80:	83 ec 0c             	sub    $0xc,%esp
80104e83:	68 57 8b 10 80       	push   $0x80108b57
80104e88:	e8 f3 b4 ff ff       	call   80100380 <panic>
80104e8d:	8d 76 00             	lea    0x0(%esi),%esi

80104e90 <growproc>:
{
80104e90:	55                   	push   %ebp
80104e91:	89 e5                	mov    %esp,%ebp
80104e93:	56                   	push   %esi
80104e94:	53                   	push   %ebx
80104e95:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80104e98:	e8 b3 09 00 00       	call   80105850 <pushcli>
  c = mycpu();
80104e9d:	e8 4e fe ff ff       	call   80104cf0 <mycpu>
  p = c->proc;
80104ea2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104ea8:	e8 f3 09 00 00       	call   801058a0 <popcli>
  sz = curproc->sz;
80104ead:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80104eaf:	85 f6                	test   %esi,%esi
80104eb1:	7f 1d                	jg     80104ed0 <growproc+0x40>
  } else if(n < 0){
80104eb3:	75 3b                	jne    80104ef0 <growproc+0x60>
  switchuvm(curproc);
80104eb5:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80104eb8:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80104eba:	53                   	push   %ebx
80104ebb:	e8 20 2f 00 00       	call   80107de0 <switchuvm>
  return 0;
80104ec0:	83 c4 10             	add    $0x10,%esp
80104ec3:	31 c0                	xor    %eax,%eax
}
80104ec5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ec8:	5b                   	pop    %ebx
80104ec9:	5e                   	pop    %esi
80104eca:	5d                   	pop    %ebp
80104ecb:	c3                   	ret    
80104ecc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104ed0:	83 ec 04             	sub    $0x4,%esp
80104ed3:	01 c6                	add    %eax,%esi
80104ed5:	56                   	push   %esi
80104ed6:	50                   	push   %eax
80104ed7:	ff 73 04             	push   0x4(%ebx)
80104eda:	e8 81 31 00 00       	call   80108060 <allocuvm>
80104edf:	83 c4 10             	add    $0x10,%esp
80104ee2:	85 c0                	test   %eax,%eax
80104ee4:	75 cf                	jne    80104eb5 <growproc+0x25>
      return -1;
80104ee6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104eeb:	eb d8                	jmp    80104ec5 <growproc+0x35>
80104eed:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104ef0:	83 ec 04             	sub    $0x4,%esp
80104ef3:	01 c6                	add    %eax,%esi
80104ef5:	56                   	push   %esi
80104ef6:	50                   	push   %eax
80104ef7:	ff 73 04             	push   0x4(%ebx)
80104efa:	e8 91 32 00 00       	call   80108190 <deallocuvm>
80104eff:	83 c4 10             	add    $0x10,%esp
80104f02:	85 c0                	test   %eax,%eax
80104f04:	75 af                	jne    80104eb5 <growproc+0x25>
80104f06:	eb de                	jmp    80104ee6 <growproc+0x56>
80104f08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f0f:	90                   	nop

80104f10 <fork>:
{
80104f10:	55                   	push   %ebp
80104f11:	89 e5                	mov    %esp,%ebp
80104f13:	57                   	push   %edi
80104f14:	56                   	push   %esi
80104f15:	53                   	push   %ebx
80104f16:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80104f19:	e8 32 09 00 00       	call   80105850 <pushcli>
  c = mycpu();
80104f1e:	e8 cd fd ff ff       	call   80104cf0 <mycpu>
  p = c->proc;
80104f23:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104f29:	e8 72 09 00 00       	call   801058a0 <popcli>
  if((np = allocproc()) == 0){
80104f2e:	e8 7d fc ff ff       	call   80104bb0 <allocproc>
80104f33:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104f36:	85 c0                	test   %eax,%eax
80104f38:	0f 84 b7 00 00 00    	je     80104ff5 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80104f3e:	83 ec 08             	sub    $0x8,%esp
80104f41:	ff 33                	push   (%ebx)
80104f43:	89 c7                	mov    %eax,%edi
80104f45:	ff 73 04             	push   0x4(%ebx)
80104f48:	e8 e3 33 00 00       	call   80108330 <copyuvm>
80104f4d:	83 c4 10             	add    $0x10,%esp
80104f50:	89 47 04             	mov    %eax,0x4(%edi)
80104f53:	85 c0                	test   %eax,%eax
80104f55:	0f 84 a1 00 00 00    	je     80104ffc <fork+0xec>
  np->sz = curproc->sz;
80104f5b:	8b 03                	mov    (%ebx),%eax
80104f5d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104f60:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80104f62:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80104f65:	89 c8                	mov    %ecx,%eax
80104f67:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80104f6a:	b9 13 00 00 00       	mov    $0x13,%ecx
80104f6f:	8b 73 18             	mov    0x18(%ebx),%esi
80104f72:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80104f74:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80104f76:	8b 40 18             	mov    0x18(%eax),%eax
80104f79:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80104f80:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80104f84:	85 c0                	test   %eax,%eax
80104f86:	74 13                	je     80104f9b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104f88:	83 ec 0c             	sub    $0xc,%esp
80104f8b:	50                   	push   %eax
80104f8c:	e8 0f d3 ff ff       	call   801022a0 <filedup>
80104f91:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104f94:	83 c4 10             	add    $0x10,%esp
80104f97:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80104f9b:	83 c6 01             	add    $0x1,%esi
80104f9e:	83 fe 10             	cmp    $0x10,%esi
80104fa1:	75 dd                	jne    80104f80 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80104fa3:	83 ec 0c             	sub    $0xc,%esp
80104fa6:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104fa9:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80104fac:	e8 9f db ff ff       	call   80102b50 <idup>
80104fb1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104fb4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80104fb7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104fba:	8d 47 6c             	lea    0x6c(%edi),%eax
80104fbd:	6a 10                	push   $0x10
80104fbf:	53                   	push   %ebx
80104fc0:	50                   	push   %eax
80104fc1:	e8 5a 0c 00 00       	call   80105c20 <safestrcpy>
  pid = np->pid;
80104fc6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80104fc9:	c7 04 24 a0 34 11 80 	movl   $0x801134a0,(%esp)
80104fd0:	e8 cb 09 00 00       	call   801059a0 <acquire>
  np->state = RUNNABLE;
80104fd5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80104fdc:	c7 04 24 a0 34 11 80 	movl   $0x801134a0,(%esp)
80104fe3:	e8 58 09 00 00       	call   80105940 <release>
  return pid;
80104fe8:	83 c4 10             	add    $0x10,%esp
}
80104feb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104fee:	89 d8                	mov    %ebx,%eax
80104ff0:	5b                   	pop    %ebx
80104ff1:	5e                   	pop    %esi
80104ff2:	5f                   	pop    %edi
80104ff3:	5d                   	pop    %ebp
80104ff4:	c3                   	ret    
    return -1;
80104ff5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104ffa:	eb ef                	jmp    80104feb <fork+0xdb>
    kfree(np->kstack);
80104ffc:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80104fff:	83 ec 0c             	sub    $0xc,%esp
80105002:	ff 73 08             	push   0x8(%ebx)
80105005:	e8 b6 e8 ff ff       	call   801038c0 <kfree>
    np->kstack = 0;
8010500a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80105011:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80105014:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
8010501b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105020:	eb c9                	jmp    80104feb <fork+0xdb>
80105022:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105029:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105030 <scheduler>:
{
80105030:	55                   	push   %ebp
80105031:	89 e5                	mov    %esp,%ebp
80105033:	57                   	push   %edi
80105034:	56                   	push   %esi
80105035:	53                   	push   %ebx
80105036:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80105039:	e8 b2 fc ff ff       	call   80104cf0 <mycpu>
  c->proc = 0;
8010503e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80105045:	00 00 00 
  struct cpu *c = mycpu();
80105048:	89 c6                	mov    %eax,%esi
  c->proc = 0;
8010504a:	8d 78 04             	lea    0x4(%eax),%edi
8010504d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80105050:	fb                   	sti    
    acquire(&ptable.lock);
80105051:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105054:	bb d4 34 11 80       	mov    $0x801134d4,%ebx
    acquire(&ptable.lock);
80105059:	68 a0 34 11 80       	push   $0x801134a0
8010505e:	e8 3d 09 00 00       	call   801059a0 <acquire>
80105063:	83 c4 10             	add    $0x10,%esp
80105066:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010506d:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
80105070:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80105074:	75 33                	jne    801050a9 <scheduler+0x79>
      switchuvm(p);
80105076:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80105079:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010507f:	53                   	push   %ebx
80105080:	e8 5b 2d 00 00       	call   80107de0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80105085:	58                   	pop    %eax
80105086:	5a                   	pop    %edx
80105087:	ff 73 1c             	push   0x1c(%ebx)
8010508a:	57                   	push   %edi
      p->state = RUNNING;
8010508b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80105092:	e8 e4 0b 00 00       	call   80105c7b <swtch>
      switchkvm();
80105097:	e8 34 2d 00 00       	call   80107dd0 <switchkvm>
      c->proc = 0;
8010509c:	83 c4 10             	add    $0x10,%esp
8010509f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
801050a6:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801050a9:	83 c3 7c             	add    $0x7c,%ebx
801050ac:	81 fb d4 53 11 80    	cmp    $0x801153d4,%ebx
801050b2:	75 bc                	jne    80105070 <scheduler+0x40>
    release(&ptable.lock);
801050b4:	83 ec 0c             	sub    $0xc,%esp
801050b7:	68 a0 34 11 80       	push   $0x801134a0
801050bc:	e8 7f 08 00 00       	call   80105940 <release>
    sti();
801050c1:	83 c4 10             	add    $0x10,%esp
801050c4:	eb 8a                	jmp    80105050 <scheduler+0x20>
801050c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050cd:	8d 76 00             	lea    0x0(%esi),%esi

801050d0 <sched>:
{
801050d0:	55                   	push   %ebp
801050d1:	89 e5                	mov    %esp,%ebp
801050d3:	56                   	push   %esi
801050d4:	53                   	push   %ebx
  pushcli();
801050d5:	e8 76 07 00 00       	call   80105850 <pushcli>
  c = mycpu();
801050da:	e8 11 fc ff ff       	call   80104cf0 <mycpu>
  p = c->proc;
801050df:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801050e5:	e8 b6 07 00 00       	call   801058a0 <popcli>
  if(!holding(&ptable.lock))
801050ea:	83 ec 0c             	sub    $0xc,%esp
801050ed:	68 a0 34 11 80       	push   $0x801134a0
801050f2:	e8 09 08 00 00       	call   80105900 <holding>
801050f7:	83 c4 10             	add    $0x10,%esp
801050fa:	85 c0                	test   %eax,%eax
801050fc:	74 4f                	je     8010514d <sched+0x7d>
  if(mycpu()->ncli != 1)
801050fe:	e8 ed fb ff ff       	call   80104cf0 <mycpu>
80105103:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010510a:	75 68                	jne    80105174 <sched+0xa4>
  if(p->state == RUNNING)
8010510c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80105110:	74 55                	je     80105167 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105112:	9c                   	pushf  
80105113:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80105114:	f6 c4 02             	test   $0x2,%ah
80105117:	75 41                	jne    8010515a <sched+0x8a>
  intena = mycpu()->intena;
80105119:	e8 d2 fb ff ff       	call   80104cf0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010511e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80105121:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80105127:	e8 c4 fb ff ff       	call   80104cf0 <mycpu>
8010512c:	83 ec 08             	sub    $0x8,%esp
8010512f:	ff 70 04             	push   0x4(%eax)
80105132:	53                   	push   %ebx
80105133:	e8 43 0b 00 00       	call   80105c7b <swtch>
  mycpu()->intena = intena;
80105138:	e8 b3 fb ff ff       	call   80104cf0 <mycpu>
}
8010513d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80105140:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80105146:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105149:	5b                   	pop    %ebx
8010514a:	5e                   	pop    %esi
8010514b:	5d                   	pop    %ebp
8010514c:	c3                   	ret    
    panic("sched ptable.lock");
8010514d:	83 ec 0c             	sub    $0xc,%esp
80105150:	68 7b 8b 10 80       	push   $0x80108b7b
80105155:	e8 26 b2 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
8010515a:	83 ec 0c             	sub    $0xc,%esp
8010515d:	68 a7 8b 10 80       	push   $0x80108ba7
80105162:	e8 19 b2 ff ff       	call   80100380 <panic>
    panic("sched running");
80105167:	83 ec 0c             	sub    $0xc,%esp
8010516a:	68 99 8b 10 80       	push   $0x80108b99
8010516f:	e8 0c b2 ff ff       	call   80100380 <panic>
    panic("sched locks");
80105174:	83 ec 0c             	sub    $0xc,%esp
80105177:	68 8d 8b 10 80       	push   $0x80108b8d
8010517c:	e8 ff b1 ff ff       	call   80100380 <panic>
80105181:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105188:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010518f:	90                   	nop

80105190 <exit>:
{
80105190:	55                   	push   %ebp
80105191:	89 e5                	mov    %esp,%ebp
80105193:	57                   	push   %edi
80105194:	56                   	push   %esi
80105195:	53                   	push   %ebx
80105196:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80105199:	e8 d2 fb ff ff       	call   80104d70 <myproc>
  if(curproc == initproc)
8010519e:	39 05 d4 53 11 80    	cmp    %eax,0x801153d4
801051a4:	0f 84 fd 00 00 00    	je     801052a7 <exit+0x117>
801051aa:	89 c3                	mov    %eax,%ebx
801051ac:	8d 70 28             	lea    0x28(%eax),%esi
801051af:	8d 78 68             	lea    0x68(%eax),%edi
801051b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
801051b8:	8b 06                	mov    (%esi),%eax
801051ba:	85 c0                	test   %eax,%eax
801051bc:	74 12                	je     801051d0 <exit+0x40>
      fileclose(curproc->ofile[fd]);
801051be:	83 ec 0c             	sub    $0xc,%esp
801051c1:	50                   	push   %eax
801051c2:	e8 29 d1 ff ff       	call   801022f0 <fileclose>
      curproc->ofile[fd] = 0;
801051c7:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801051cd:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
801051d0:	83 c6 04             	add    $0x4,%esi
801051d3:	39 f7                	cmp    %esi,%edi
801051d5:	75 e1                	jne    801051b8 <exit+0x28>
  begin_op();
801051d7:	e8 84 ef ff ff       	call   80104160 <begin_op>
  iput(curproc->cwd);
801051dc:	83 ec 0c             	sub    $0xc,%esp
801051df:	ff 73 68             	push   0x68(%ebx)
801051e2:	e8 c9 da ff ff       	call   80102cb0 <iput>
  end_op();
801051e7:	e8 e4 ef ff ff       	call   801041d0 <end_op>
  curproc->cwd = 0;
801051ec:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
801051f3:	c7 04 24 a0 34 11 80 	movl   $0x801134a0,(%esp)
801051fa:	e8 a1 07 00 00       	call   801059a0 <acquire>
  wakeup1(curproc->parent);
801051ff:	8b 53 14             	mov    0x14(%ebx),%edx
80105202:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105205:	b8 d4 34 11 80       	mov    $0x801134d4,%eax
8010520a:	eb 0e                	jmp    8010521a <exit+0x8a>
8010520c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105210:	83 c0 7c             	add    $0x7c,%eax
80105213:	3d d4 53 11 80       	cmp    $0x801153d4,%eax
80105218:	74 1c                	je     80105236 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
8010521a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010521e:	75 f0                	jne    80105210 <exit+0x80>
80105220:	3b 50 20             	cmp    0x20(%eax),%edx
80105223:	75 eb                	jne    80105210 <exit+0x80>
      p->state = RUNNABLE;
80105225:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010522c:	83 c0 7c             	add    $0x7c,%eax
8010522f:	3d d4 53 11 80       	cmp    $0x801153d4,%eax
80105234:	75 e4                	jne    8010521a <exit+0x8a>
      p->parent = initproc;
80105236:	8b 0d d4 53 11 80    	mov    0x801153d4,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010523c:	ba d4 34 11 80       	mov    $0x801134d4,%edx
80105241:	eb 10                	jmp    80105253 <exit+0xc3>
80105243:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105247:	90                   	nop
80105248:	83 c2 7c             	add    $0x7c,%edx
8010524b:	81 fa d4 53 11 80    	cmp    $0x801153d4,%edx
80105251:	74 3b                	je     8010528e <exit+0xfe>
    if(p->parent == curproc){
80105253:	39 5a 14             	cmp    %ebx,0x14(%edx)
80105256:	75 f0                	jne    80105248 <exit+0xb8>
      if(p->state == ZOMBIE)
80105258:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
8010525c:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010525f:	75 e7                	jne    80105248 <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105261:	b8 d4 34 11 80       	mov    $0x801134d4,%eax
80105266:	eb 12                	jmp    8010527a <exit+0xea>
80105268:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010526f:	90                   	nop
80105270:	83 c0 7c             	add    $0x7c,%eax
80105273:	3d d4 53 11 80       	cmp    $0x801153d4,%eax
80105278:	74 ce                	je     80105248 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
8010527a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010527e:	75 f0                	jne    80105270 <exit+0xe0>
80105280:	3b 48 20             	cmp    0x20(%eax),%ecx
80105283:	75 eb                	jne    80105270 <exit+0xe0>
      p->state = RUNNABLE;
80105285:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010528c:	eb e2                	jmp    80105270 <exit+0xe0>
  curproc->state = ZOMBIE;
8010528e:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80105295:	e8 36 fe ff ff       	call   801050d0 <sched>
  panic("zombie exit");
8010529a:	83 ec 0c             	sub    $0xc,%esp
8010529d:	68 c8 8b 10 80       	push   $0x80108bc8
801052a2:	e8 d9 b0 ff ff       	call   80100380 <panic>
    panic("init exiting");
801052a7:	83 ec 0c             	sub    $0xc,%esp
801052aa:	68 bb 8b 10 80       	push   $0x80108bbb
801052af:	e8 cc b0 ff ff       	call   80100380 <panic>
801052b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801052bf:	90                   	nop

801052c0 <wait>:
{
801052c0:	55                   	push   %ebp
801052c1:	89 e5                	mov    %esp,%ebp
801052c3:	56                   	push   %esi
801052c4:	53                   	push   %ebx
  pushcli();
801052c5:	e8 86 05 00 00       	call   80105850 <pushcli>
  c = mycpu();
801052ca:	e8 21 fa ff ff       	call   80104cf0 <mycpu>
  p = c->proc;
801052cf:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801052d5:	e8 c6 05 00 00       	call   801058a0 <popcli>
  acquire(&ptable.lock);
801052da:	83 ec 0c             	sub    $0xc,%esp
801052dd:	68 a0 34 11 80       	push   $0x801134a0
801052e2:	e8 b9 06 00 00       	call   801059a0 <acquire>
801052e7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801052ea:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801052ec:	bb d4 34 11 80       	mov    $0x801134d4,%ebx
801052f1:	eb 10                	jmp    80105303 <wait+0x43>
801052f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801052f7:	90                   	nop
801052f8:	83 c3 7c             	add    $0x7c,%ebx
801052fb:	81 fb d4 53 11 80    	cmp    $0x801153d4,%ebx
80105301:	74 1b                	je     8010531e <wait+0x5e>
      if(p->parent != curproc)
80105303:	39 73 14             	cmp    %esi,0x14(%ebx)
80105306:	75 f0                	jne    801052f8 <wait+0x38>
      if(p->state == ZOMBIE){
80105308:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010530c:	74 62                	je     80105370 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010530e:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80105311:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105316:	81 fb d4 53 11 80    	cmp    $0x801153d4,%ebx
8010531c:	75 e5                	jne    80105303 <wait+0x43>
    if(!havekids || curproc->killed){
8010531e:	85 c0                	test   %eax,%eax
80105320:	0f 84 a0 00 00 00    	je     801053c6 <wait+0x106>
80105326:	8b 46 24             	mov    0x24(%esi),%eax
80105329:	85 c0                	test   %eax,%eax
8010532b:	0f 85 95 00 00 00    	jne    801053c6 <wait+0x106>
  pushcli();
80105331:	e8 1a 05 00 00       	call   80105850 <pushcli>
  c = mycpu();
80105336:	e8 b5 f9 ff ff       	call   80104cf0 <mycpu>
  p = c->proc;
8010533b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80105341:	e8 5a 05 00 00       	call   801058a0 <popcli>
  if(p == 0)
80105346:	85 db                	test   %ebx,%ebx
80105348:	0f 84 8f 00 00 00    	je     801053dd <wait+0x11d>
  p->chan = chan;
8010534e:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80105351:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80105358:	e8 73 fd ff ff       	call   801050d0 <sched>
  p->chan = 0;
8010535d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80105364:	eb 84                	jmp    801052ea <wait+0x2a>
80105366:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010536d:	8d 76 00             	lea    0x0(%esi),%esi
        kfree(p->kstack);
80105370:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80105373:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80105376:	ff 73 08             	push   0x8(%ebx)
80105379:	e8 42 e5 ff ff       	call   801038c0 <kfree>
        p->kstack = 0;
8010537e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80105385:	5a                   	pop    %edx
80105386:	ff 73 04             	push   0x4(%ebx)
80105389:	e8 32 2e 00 00       	call   801081c0 <freevm>
        p->pid = 0;
8010538e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80105395:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010539c:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801053a0:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801053a7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801053ae:	c7 04 24 a0 34 11 80 	movl   $0x801134a0,(%esp)
801053b5:	e8 86 05 00 00       	call   80105940 <release>
        return pid;
801053ba:	83 c4 10             	add    $0x10,%esp
}
801053bd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801053c0:	89 f0                	mov    %esi,%eax
801053c2:	5b                   	pop    %ebx
801053c3:	5e                   	pop    %esi
801053c4:	5d                   	pop    %ebp
801053c5:	c3                   	ret    
      release(&ptable.lock);
801053c6:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801053c9:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801053ce:	68 a0 34 11 80       	push   $0x801134a0
801053d3:	e8 68 05 00 00       	call   80105940 <release>
      return -1;
801053d8:	83 c4 10             	add    $0x10,%esp
801053db:	eb e0                	jmp    801053bd <wait+0xfd>
    panic("sleep");
801053dd:	83 ec 0c             	sub    $0xc,%esp
801053e0:	68 d4 8b 10 80       	push   $0x80108bd4
801053e5:	e8 96 af ff ff       	call   80100380 <panic>
801053ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801053f0 <yield>:
{
801053f0:	55                   	push   %ebp
801053f1:	89 e5                	mov    %esp,%ebp
801053f3:	53                   	push   %ebx
801053f4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801053f7:	68 a0 34 11 80       	push   $0x801134a0
801053fc:	e8 9f 05 00 00       	call   801059a0 <acquire>
  pushcli();
80105401:	e8 4a 04 00 00       	call   80105850 <pushcli>
  c = mycpu();
80105406:	e8 e5 f8 ff ff       	call   80104cf0 <mycpu>
  p = c->proc;
8010540b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80105411:	e8 8a 04 00 00       	call   801058a0 <popcli>
  myproc()->state = RUNNABLE;
80105416:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010541d:	e8 ae fc ff ff       	call   801050d0 <sched>
  release(&ptable.lock);
80105422:	c7 04 24 a0 34 11 80 	movl   $0x801134a0,(%esp)
80105429:	e8 12 05 00 00       	call   80105940 <release>
}
8010542e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105431:	83 c4 10             	add    $0x10,%esp
80105434:	c9                   	leave  
80105435:	c3                   	ret    
80105436:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010543d:	8d 76 00             	lea    0x0(%esi),%esi

80105440 <sleep>:
{
80105440:	55                   	push   %ebp
80105441:	89 e5                	mov    %esp,%ebp
80105443:	57                   	push   %edi
80105444:	56                   	push   %esi
80105445:	53                   	push   %ebx
80105446:	83 ec 0c             	sub    $0xc,%esp
80105449:	8b 7d 08             	mov    0x8(%ebp),%edi
8010544c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010544f:	e8 fc 03 00 00       	call   80105850 <pushcli>
  c = mycpu();
80105454:	e8 97 f8 ff ff       	call   80104cf0 <mycpu>
  p = c->proc;
80105459:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010545f:	e8 3c 04 00 00       	call   801058a0 <popcli>
  if(p == 0)
80105464:	85 db                	test   %ebx,%ebx
80105466:	0f 84 87 00 00 00    	je     801054f3 <sleep+0xb3>
  if(lk == 0)
8010546c:	85 f6                	test   %esi,%esi
8010546e:	74 76                	je     801054e6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80105470:	81 fe a0 34 11 80    	cmp    $0x801134a0,%esi
80105476:	74 50                	je     801054c8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80105478:	83 ec 0c             	sub    $0xc,%esp
8010547b:	68 a0 34 11 80       	push   $0x801134a0
80105480:	e8 1b 05 00 00       	call   801059a0 <acquire>
    release(lk);
80105485:	89 34 24             	mov    %esi,(%esp)
80105488:	e8 b3 04 00 00       	call   80105940 <release>
  p->chan = chan;
8010548d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80105490:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80105497:	e8 34 fc ff ff       	call   801050d0 <sched>
  p->chan = 0;
8010549c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801054a3:	c7 04 24 a0 34 11 80 	movl   $0x801134a0,(%esp)
801054aa:	e8 91 04 00 00       	call   80105940 <release>
    acquire(lk);
801054af:	89 75 08             	mov    %esi,0x8(%ebp)
801054b2:	83 c4 10             	add    $0x10,%esp
}
801054b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801054b8:	5b                   	pop    %ebx
801054b9:	5e                   	pop    %esi
801054ba:	5f                   	pop    %edi
801054bb:	5d                   	pop    %ebp
    acquire(lk);
801054bc:	e9 df 04 00 00       	jmp    801059a0 <acquire>
801054c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801054c8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801054cb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801054d2:	e8 f9 fb ff ff       	call   801050d0 <sched>
  p->chan = 0;
801054d7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801054de:	8d 65 f4             	lea    -0xc(%ebp),%esp
801054e1:	5b                   	pop    %ebx
801054e2:	5e                   	pop    %esi
801054e3:	5f                   	pop    %edi
801054e4:	5d                   	pop    %ebp
801054e5:	c3                   	ret    
    panic("sleep without lk");
801054e6:	83 ec 0c             	sub    $0xc,%esp
801054e9:	68 da 8b 10 80       	push   $0x80108bda
801054ee:	e8 8d ae ff ff       	call   80100380 <panic>
    panic("sleep");
801054f3:	83 ec 0c             	sub    $0xc,%esp
801054f6:	68 d4 8b 10 80       	push   $0x80108bd4
801054fb:	e8 80 ae ff ff       	call   80100380 <panic>

80105500 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80105500:	55                   	push   %ebp
80105501:	89 e5                	mov    %esp,%ebp
80105503:	53                   	push   %ebx
80105504:	83 ec 10             	sub    $0x10,%esp
80105507:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010550a:	68 a0 34 11 80       	push   $0x801134a0
8010550f:	e8 8c 04 00 00       	call   801059a0 <acquire>
80105514:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105517:	b8 d4 34 11 80       	mov    $0x801134d4,%eax
8010551c:	eb 0c                	jmp    8010552a <wakeup+0x2a>
8010551e:	66 90                	xchg   %ax,%ax
80105520:	83 c0 7c             	add    $0x7c,%eax
80105523:	3d d4 53 11 80       	cmp    $0x801153d4,%eax
80105528:	74 1c                	je     80105546 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010552a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010552e:	75 f0                	jne    80105520 <wakeup+0x20>
80105530:	3b 58 20             	cmp    0x20(%eax),%ebx
80105533:	75 eb                	jne    80105520 <wakeup+0x20>
      p->state = RUNNABLE;
80105535:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010553c:	83 c0 7c             	add    $0x7c,%eax
8010553f:	3d d4 53 11 80       	cmp    $0x801153d4,%eax
80105544:	75 e4                	jne    8010552a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80105546:	c7 45 08 a0 34 11 80 	movl   $0x801134a0,0x8(%ebp)
}
8010554d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105550:	c9                   	leave  
  release(&ptable.lock);
80105551:	e9 ea 03 00 00       	jmp    80105940 <release>
80105556:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010555d:	8d 76 00             	lea    0x0(%esi),%esi

80105560 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80105560:	55                   	push   %ebp
80105561:	89 e5                	mov    %esp,%ebp
80105563:	53                   	push   %ebx
80105564:	83 ec 10             	sub    $0x10,%esp
80105567:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010556a:	68 a0 34 11 80       	push   $0x801134a0
8010556f:	e8 2c 04 00 00       	call   801059a0 <acquire>
80105574:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105577:	b8 d4 34 11 80       	mov    $0x801134d4,%eax
8010557c:	eb 0c                	jmp    8010558a <kill+0x2a>
8010557e:	66 90                	xchg   %ax,%ax
80105580:	83 c0 7c             	add    $0x7c,%eax
80105583:	3d d4 53 11 80       	cmp    $0x801153d4,%eax
80105588:	74 36                	je     801055c0 <kill+0x60>
    if(p->pid == pid){
8010558a:	39 58 10             	cmp    %ebx,0x10(%eax)
8010558d:	75 f1                	jne    80105580 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010558f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80105593:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010559a:	75 07                	jne    801055a3 <kill+0x43>
        p->state = RUNNABLE;
8010559c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801055a3:	83 ec 0c             	sub    $0xc,%esp
801055a6:	68 a0 34 11 80       	push   $0x801134a0
801055ab:	e8 90 03 00 00       	call   80105940 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801055b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801055b3:	83 c4 10             	add    $0x10,%esp
801055b6:	31 c0                	xor    %eax,%eax
}
801055b8:	c9                   	leave  
801055b9:	c3                   	ret    
801055ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801055c0:	83 ec 0c             	sub    $0xc,%esp
801055c3:	68 a0 34 11 80       	push   $0x801134a0
801055c8:	e8 73 03 00 00       	call   80105940 <release>
}
801055cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801055d0:	83 c4 10             	add    $0x10,%esp
801055d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055d8:	c9                   	leave  
801055d9:	c3                   	ret    
801055da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801055e0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801055e0:	55                   	push   %ebp
801055e1:	89 e5                	mov    %esp,%ebp
801055e3:	57                   	push   %edi
801055e4:	56                   	push   %esi
801055e5:	8d 75 e8             	lea    -0x18(%ebp),%esi
801055e8:	53                   	push   %ebx
801055e9:	bb 40 35 11 80       	mov    $0x80113540,%ebx
801055ee:	83 ec 3c             	sub    $0x3c,%esp
801055f1:	eb 24                	jmp    80105617 <procdump+0x37>
801055f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801055f7:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801055f8:	83 ec 0c             	sub    $0xc,%esp
801055fb:	68 57 8f 10 80       	push   $0x80108f57
80105600:	e8 fb b0 ff ff       	call   80100700 <cprintf>
80105605:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105608:	83 c3 7c             	add    $0x7c,%ebx
8010560b:	81 fb 40 54 11 80    	cmp    $0x80115440,%ebx
80105611:	0f 84 81 00 00 00    	je     80105698 <procdump+0xb8>
    if(p->state == UNUSED)
80105617:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010561a:	85 c0                	test   %eax,%eax
8010561c:	74 ea                	je     80105608 <procdump+0x28>
      state = "???";
8010561e:	ba eb 8b 10 80       	mov    $0x80108beb,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80105623:	83 f8 05             	cmp    $0x5,%eax
80105626:	77 11                	ja     80105639 <procdump+0x59>
80105628:	8b 14 85 4c 8c 10 80 	mov    -0x7fef73b4(,%eax,4),%edx
      state = "???";
8010562f:	b8 eb 8b 10 80       	mov    $0x80108beb,%eax
80105634:	85 d2                	test   %edx,%edx
80105636:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80105639:	53                   	push   %ebx
8010563a:	52                   	push   %edx
8010563b:	ff 73 a4             	push   -0x5c(%ebx)
8010563e:	68 ef 8b 10 80       	push   $0x80108bef
80105643:	e8 b8 b0 ff ff       	call   80100700 <cprintf>
    if(p->state == SLEEPING){
80105648:	83 c4 10             	add    $0x10,%esp
8010564b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010564f:	75 a7                	jne    801055f8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80105651:	83 ec 08             	sub    $0x8,%esp
80105654:	8d 45 c0             	lea    -0x40(%ebp),%eax
80105657:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010565a:	50                   	push   %eax
8010565b:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010565e:	8b 40 0c             	mov    0xc(%eax),%eax
80105661:	83 c0 08             	add    $0x8,%eax
80105664:	50                   	push   %eax
80105665:	e8 86 01 00 00       	call   801057f0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010566a:	83 c4 10             	add    $0x10,%esp
8010566d:	8d 76 00             	lea    0x0(%esi),%esi
80105670:	8b 17                	mov    (%edi),%edx
80105672:	85 d2                	test   %edx,%edx
80105674:	74 82                	je     801055f8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80105676:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80105679:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
8010567c:	52                   	push   %edx
8010567d:	68 e1 85 10 80       	push   $0x801085e1
80105682:	e8 79 b0 ff ff       	call   80100700 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80105687:	83 c4 10             	add    $0x10,%esp
8010568a:	39 fe                	cmp    %edi,%esi
8010568c:	75 e2                	jne    80105670 <procdump+0x90>
8010568e:	e9 65 ff ff ff       	jmp    801055f8 <procdump+0x18>
80105693:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105697:	90                   	nop
  }
}
80105698:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010569b:	5b                   	pop    %ebx
8010569c:	5e                   	pop    %esi
8010569d:	5f                   	pop    %edi
8010569e:	5d                   	pop    %ebp
8010569f:	c3                   	ret    

801056a0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801056a0:	55                   	push   %ebp
801056a1:	89 e5                	mov    %esp,%ebp
801056a3:	53                   	push   %ebx
801056a4:	83 ec 0c             	sub    $0xc,%esp
801056a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801056aa:	68 64 8c 10 80       	push   $0x80108c64
801056af:	8d 43 04             	lea    0x4(%ebx),%eax
801056b2:	50                   	push   %eax
801056b3:	e8 18 01 00 00       	call   801057d0 <initlock>
  lk->name = name;
801056b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801056bb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801056c1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801056c4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801056cb:	89 43 38             	mov    %eax,0x38(%ebx)
}
801056ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801056d1:	c9                   	leave  
801056d2:	c3                   	ret    
801056d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801056e0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801056e0:	55                   	push   %ebp
801056e1:	89 e5                	mov    %esp,%ebp
801056e3:	56                   	push   %esi
801056e4:	53                   	push   %ebx
801056e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801056e8:	8d 73 04             	lea    0x4(%ebx),%esi
801056eb:	83 ec 0c             	sub    $0xc,%esp
801056ee:	56                   	push   %esi
801056ef:	e8 ac 02 00 00       	call   801059a0 <acquire>
  while (lk->locked) {
801056f4:	8b 13                	mov    (%ebx),%edx
801056f6:	83 c4 10             	add    $0x10,%esp
801056f9:	85 d2                	test   %edx,%edx
801056fb:	74 16                	je     80105713 <acquiresleep+0x33>
801056fd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80105700:	83 ec 08             	sub    $0x8,%esp
80105703:	56                   	push   %esi
80105704:	53                   	push   %ebx
80105705:	e8 36 fd ff ff       	call   80105440 <sleep>
  while (lk->locked) {
8010570a:	8b 03                	mov    (%ebx),%eax
8010570c:	83 c4 10             	add    $0x10,%esp
8010570f:	85 c0                	test   %eax,%eax
80105711:	75 ed                	jne    80105700 <acquiresleep+0x20>
  }
  lk->locked = 1;
80105713:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80105719:	e8 52 f6 ff ff       	call   80104d70 <myproc>
8010571e:	8b 40 10             	mov    0x10(%eax),%eax
80105721:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80105724:	89 75 08             	mov    %esi,0x8(%ebp)
}
80105727:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010572a:	5b                   	pop    %ebx
8010572b:	5e                   	pop    %esi
8010572c:	5d                   	pop    %ebp
  release(&lk->lk);
8010572d:	e9 0e 02 00 00       	jmp    80105940 <release>
80105732:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105740 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80105740:	55                   	push   %ebp
80105741:	89 e5                	mov    %esp,%ebp
80105743:	56                   	push   %esi
80105744:	53                   	push   %ebx
80105745:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80105748:	8d 73 04             	lea    0x4(%ebx),%esi
8010574b:	83 ec 0c             	sub    $0xc,%esp
8010574e:	56                   	push   %esi
8010574f:	e8 4c 02 00 00       	call   801059a0 <acquire>
  lk->locked = 0;
80105754:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010575a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80105761:	89 1c 24             	mov    %ebx,(%esp)
80105764:	e8 97 fd ff ff       	call   80105500 <wakeup>
  release(&lk->lk);
80105769:	89 75 08             	mov    %esi,0x8(%ebp)
8010576c:	83 c4 10             	add    $0x10,%esp
}
8010576f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105772:	5b                   	pop    %ebx
80105773:	5e                   	pop    %esi
80105774:	5d                   	pop    %ebp
  release(&lk->lk);
80105775:	e9 c6 01 00 00       	jmp    80105940 <release>
8010577a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105780 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80105780:	55                   	push   %ebp
80105781:	89 e5                	mov    %esp,%ebp
80105783:	57                   	push   %edi
80105784:	31 ff                	xor    %edi,%edi
80105786:	56                   	push   %esi
80105787:	53                   	push   %ebx
80105788:	83 ec 18             	sub    $0x18,%esp
8010578b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010578e:	8d 73 04             	lea    0x4(%ebx),%esi
80105791:	56                   	push   %esi
80105792:	e8 09 02 00 00       	call   801059a0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80105797:	8b 03                	mov    (%ebx),%eax
80105799:	83 c4 10             	add    $0x10,%esp
8010579c:	85 c0                	test   %eax,%eax
8010579e:	75 18                	jne    801057b8 <holdingsleep+0x38>
  release(&lk->lk);
801057a0:	83 ec 0c             	sub    $0xc,%esp
801057a3:	56                   	push   %esi
801057a4:	e8 97 01 00 00       	call   80105940 <release>
  return r;
}
801057a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057ac:	89 f8                	mov    %edi,%eax
801057ae:	5b                   	pop    %ebx
801057af:	5e                   	pop    %esi
801057b0:	5f                   	pop    %edi
801057b1:	5d                   	pop    %ebp
801057b2:	c3                   	ret    
801057b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801057b7:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
801057b8:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801057bb:	e8 b0 f5 ff ff       	call   80104d70 <myproc>
801057c0:	39 58 10             	cmp    %ebx,0x10(%eax)
801057c3:	0f 94 c0             	sete   %al
801057c6:	0f b6 c0             	movzbl %al,%eax
801057c9:	89 c7                	mov    %eax,%edi
801057cb:	eb d3                	jmp    801057a0 <holdingsleep+0x20>
801057cd:	66 90                	xchg   %ax,%ax
801057cf:	90                   	nop

801057d0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801057d0:	55                   	push   %ebp
801057d1:	89 e5                	mov    %esp,%ebp
801057d3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801057d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801057d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801057df:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801057e2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801057e9:	5d                   	pop    %ebp
801057ea:	c3                   	ret    
801057eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801057ef:	90                   	nop

801057f0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801057f0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801057f1:	31 d2                	xor    %edx,%edx
{
801057f3:	89 e5                	mov    %esp,%ebp
801057f5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801057f6:	8b 45 08             	mov    0x8(%ebp),%eax
{
801057f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801057fc:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
801057ff:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105800:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80105806:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010580c:	77 1a                	ja     80105828 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010580e:	8b 58 04             	mov    0x4(%eax),%ebx
80105811:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80105814:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80105817:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80105819:	83 fa 0a             	cmp    $0xa,%edx
8010581c:	75 e2                	jne    80105800 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010581e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105821:	c9                   	leave  
80105822:	c3                   	ret    
80105823:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105827:	90                   	nop
  for(; i < 10; i++)
80105828:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010582b:	8d 51 28             	lea    0x28(%ecx),%edx
8010582e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80105830:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80105836:	83 c0 04             	add    $0x4,%eax
80105839:	39 d0                	cmp    %edx,%eax
8010583b:	75 f3                	jne    80105830 <getcallerpcs+0x40>
}
8010583d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105840:	c9                   	leave  
80105841:	c3                   	ret    
80105842:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105850 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105850:	55                   	push   %ebp
80105851:	89 e5                	mov    %esp,%ebp
80105853:	53                   	push   %ebx
80105854:	83 ec 04             	sub    $0x4,%esp
80105857:	9c                   	pushf  
80105858:	5b                   	pop    %ebx
  asm volatile("cli");
80105859:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010585a:	e8 91 f4 ff ff       	call   80104cf0 <mycpu>
8010585f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105865:	85 c0                	test   %eax,%eax
80105867:	74 17                	je     80105880 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80105869:	e8 82 f4 ff ff       	call   80104cf0 <mycpu>
8010586e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80105875:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105878:	c9                   	leave  
80105879:	c3                   	ret    
8010587a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80105880:	e8 6b f4 ff ff       	call   80104cf0 <mycpu>
80105885:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010588b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80105891:	eb d6                	jmp    80105869 <pushcli+0x19>
80105893:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010589a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801058a0 <popcli>:

void
popcli(void)
{
801058a0:	55                   	push   %ebp
801058a1:	89 e5                	mov    %esp,%ebp
801058a3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801058a6:	9c                   	pushf  
801058a7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801058a8:	f6 c4 02             	test   $0x2,%ah
801058ab:	75 35                	jne    801058e2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801058ad:	e8 3e f4 ff ff       	call   80104cf0 <mycpu>
801058b2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801058b9:	78 34                	js     801058ef <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801058bb:	e8 30 f4 ff ff       	call   80104cf0 <mycpu>
801058c0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801058c6:	85 d2                	test   %edx,%edx
801058c8:	74 06                	je     801058d0 <popcli+0x30>
    sti();
}
801058ca:	c9                   	leave  
801058cb:	c3                   	ret    
801058cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801058d0:	e8 1b f4 ff ff       	call   80104cf0 <mycpu>
801058d5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801058db:	85 c0                	test   %eax,%eax
801058dd:	74 eb                	je     801058ca <popcli+0x2a>
  asm volatile("sti");
801058df:	fb                   	sti    
}
801058e0:	c9                   	leave  
801058e1:	c3                   	ret    
    panic("popcli - interruptible");
801058e2:	83 ec 0c             	sub    $0xc,%esp
801058e5:	68 6f 8c 10 80       	push   $0x80108c6f
801058ea:	e8 91 aa ff ff       	call   80100380 <panic>
    panic("popcli");
801058ef:	83 ec 0c             	sub    $0xc,%esp
801058f2:	68 86 8c 10 80       	push   $0x80108c86
801058f7:	e8 84 aa ff ff       	call   80100380 <panic>
801058fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105900 <holding>:
{
80105900:	55                   	push   %ebp
80105901:	89 e5                	mov    %esp,%ebp
80105903:	56                   	push   %esi
80105904:	53                   	push   %ebx
80105905:	8b 75 08             	mov    0x8(%ebp),%esi
80105908:	31 db                	xor    %ebx,%ebx
  pushcli();
8010590a:	e8 41 ff ff ff       	call   80105850 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010590f:	8b 06                	mov    (%esi),%eax
80105911:	85 c0                	test   %eax,%eax
80105913:	75 0b                	jne    80105920 <holding+0x20>
  popcli();
80105915:	e8 86 ff ff ff       	call   801058a0 <popcli>
}
8010591a:	89 d8                	mov    %ebx,%eax
8010591c:	5b                   	pop    %ebx
8010591d:	5e                   	pop    %esi
8010591e:	5d                   	pop    %ebp
8010591f:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80105920:	8b 5e 08             	mov    0x8(%esi),%ebx
80105923:	e8 c8 f3 ff ff       	call   80104cf0 <mycpu>
80105928:	39 c3                	cmp    %eax,%ebx
8010592a:	0f 94 c3             	sete   %bl
  popcli();
8010592d:	e8 6e ff ff ff       	call   801058a0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80105932:	0f b6 db             	movzbl %bl,%ebx
}
80105935:	89 d8                	mov    %ebx,%eax
80105937:	5b                   	pop    %ebx
80105938:	5e                   	pop    %esi
80105939:	5d                   	pop    %ebp
8010593a:	c3                   	ret    
8010593b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010593f:	90                   	nop

80105940 <release>:
{
80105940:	55                   	push   %ebp
80105941:	89 e5                	mov    %esp,%ebp
80105943:	56                   	push   %esi
80105944:	53                   	push   %ebx
80105945:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80105948:	e8 03 ff ff ff       	call   80105850 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010594d:	8b 03                	mov    (%ebx),%eax
8010594f:	85 c0                	test   %eax,%eax
80105951:	75 15                	jne    80105968 <release+0x28>
  popcli();
80105953:	e8 48 ff ff ff       	call   801058a0 <popcli>
    panic("release");
80105958:	83 ec 0c             	sub    $0xc,%esp
8010595b:	68 8d 8c 10 80       	push   $0x80108c8d
80105960:	e8 1b aa ff ff       	call   80100380 <panic>
80105965:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80105968:	8b 73 08             	mov    0x8(%ebx),%esi
8010596b:	e8 80 f3 ff ff       	call   80104cf0 <mycpu>
80105970:	39 c6                	cmp    %eax,%esi
80105972:	75 df                	jne    80105953 <release+0x13>
  popcli();
80105974:	e8 27 ff ff ff       	call   801058a0 <popcli>
  lk->pcs[0] = 0;
80105979:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80105980:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80105987:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010598c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80105992:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105995:	5b                   	pop    %ebx
80105996:	5e                   	pop    %esi
80105997:	5d                   	pop    %ebp
  popcli();
80105998:	e9 03 ff ff ff       	jmp    801058a0 <popcli>
8010599d:	8d 76 00             	lea    0x0(%esi),%esi

801059a0 <acquire>:
{
801059a0:	55                   	push   %ebp
801059a1:	89 e5                	mov    %esp,%ebp
801059a3:	53                   	push   %ebx
801059a4:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801059a7:	e8 a4 fe ff ff       	call   80105850 <pushcli>
  if(holding(lk))
801059ac:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801059af:	e8 9c fe ff ff       	call   80105850 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801059b4:	8b 03                	mov    (%ebx),%eax
801059b6:	85 c0                	test   %eax,%eax
801059b8:	75 7e                	jne    80105a38 <acquire+0x98>
  popcli();
801059ba:	e8 e1 fe ff ff       	call   801058a0 <popcli>
  asm volatile("lock; xchgl %0, %1" :
801059bf:	b9 01 00 00 00       	mov    $0x1,%ecx
801059c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
801059c8:	8b 55 08             	mov    0x8(%ebp),%edx
801059cb:	89 c8                	mov    %ecx,%eax
801059cd:	f0 87 02             	lock xchg %eax,(%edx)
801059d0:	85 c0                	test   %eax,%eax
801059d2:	75 f4                	jne    801059c8 <acquire+0x28>
  __sync_synchronize();
801059d4:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801059d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801059dc:	e8 0f f3 ff ff       	call   80104cf0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
801059e1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
801059e4:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
801059e6:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
801059e9:	31 c0                	xor    %eax,%eax
801059eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801059ef:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801059f0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801059f6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801059fc:	77 1a                	ja     80105a18 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
801059fe:	8b 5a 04             	mov    0x4(%edx),%ebx
80105a01:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80105a05:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80105a08:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80105a0a:	83 f8 0a             	cmp    $0xa,%eax
80105a0d:	75 e1                	jne    801059f0 <acquire+0x50>
}
80105a0f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a12:	c9                   	leave  
80105a13:	c3                   	ret    
80105a14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80105a18:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
80105a1c:	8d 51 34             	lea    0x34(%ecx),%edx
80105a1f:	90                   	nop
    pcs[i] = 0;
80105a20:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80105a26:	83 c0 04             	add    $0x4,%eax
80105a29:	39 c2                	cmp    %eax,%edx
80105a2b:	75 f3                	jne    80105a20 <acquire+0x80>
}
80105a2d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a30:	c9                   	leave  
80105a31:	c3                   	ret    
80105a32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80105a38:	8b 5b 08             	mov    0x8(%ebx),%ebx
80105a3b:	e8 b0 f2 ff ff       	call   80104cf0 <mycpu>
80105a40:	39 c3                	cmp    %eax,%ebx
80105a42:	0f 85 72 ff ff ff    	jne    801059ba <acquire+0x1a>
  popcli();
80105a48:	e8 53 fe ff ff       	call   801058a0 <popcli>
    panic("acquire");
80105a4d:	83 ec 0c             	sub    $0xc,%esp
80105a50:	68 95 8c 10 80       	push   $0x80108c95
80105a55:	e8 26 a9 ff ff       	call   80100380 <panic>
80105a5a:	66 90                	xchg   %ax,%ax
80105a5c:	66 90                	xchg   %ax,%ax
80105a5e:	66 90                	xchg   %ax,%ax

80105a60 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105a60:	55                   	push   %ebp
80105a61:	89 e5                	mov    %esp,%ebp
80105a63:	57                   	push   %edi
80105a64:	8b 55 08             	mov    0x8(%ebp),%edx
80105a67:	8b 4d 10             	mov    0x10(%ebp),%ecx
80105a6a:	53                   	push   %ebx
80105a6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80105a6e:	89 d7                	mov    %edx,%edi
80105a70:	09 cf                	or     %ecx,%edi
80105a72:	83 e7 03             	and    $0x3,%edi
80105a75:	75 29                	jne    80105aa0 <memset+0x40>
    c &= 0xFF;
80105a77:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80105a7a:	c1 e0 18             	shl    $0x18,%eax
80105a7d:	89 fb                	mov    %edi,%ebx
80105a7f:	c1 e9 02             	shr    $0x2,%ecx
80105a82:	c1 e3 10             	shl    $0x10,%ebx
80105a85:	09 d8                	or     %ebx,%eax
80105a87:	09 f8                	or     %edi,%eax
80105a89:	c1 e7 08             	shl    $0x8,%edi
80105a8c:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80105a8e:	89 d7                	mov    %edx,%edi
80105a90:	fc                   	cld    
80105a91:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80105a93:	5b                   	pop    %ebx
80105a94:	89 d0                	mov    %edx,%eax
80105a96:	5f                   	pop    %edi
80105a97:	5d                   	pop    %ebp
80105a98:	c3                   	ret    
80105a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80105aa0:	89 d7                	mov    %edx,%edi
80105aa2:	fc                   	cld    
80105aa3:	f3 aa                	rep stos %al,%es:(%edi)
80105aa5:	5b                   	pop    %ebx
80105aa6:	89 d0                	mov    %edx,%eax
80105aa8:	5f                   	pop    %edi
80105aa9:	5d                   	pop    %ebp
80105aaa:	c3                   	ret    
80105aab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105aaf:	90                   	nop

80105ab0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105ab0:	55                   	push   %ebp
80105ab1:	89 e5                	mov    %esp,%ebp
80105ab3:	56                   	push   %esi
80105ab4:	8b 75 10             	mov    0x10(%ebp),%esi
80105ab7:	8b 55 08             	mov    0x8(%ebp),%edx
80105aba:	53                   	push   %ebx
80105abb:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80105abe:	85 f6                	test   %esi,%esi
80105ac0:	74 2e                	je     80105af0 <memcmp+0x40>
80105ac2:	01 c6                	add    %eax,%esi
80105ac4:	eb 14                	jmp    80105ada <memcmp+0x2a>
80105ac6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105acd:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80105ad0:	83 c0 01             	add    $0x1,%eax
80105ad3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80105ad6:	39 f0                	cmp    %esi,%eax
80105ad8:	74 16                	je     80105af0 <memcmp+0x40>
    if(*s1 != *s2)
80105ada:	0f b6 0a             	movzbl (%edx),%ecx
80105add:	0f b6 18             	movzbl (%eax),%ebx
80105ae0:	38 d9                	cmp    %bl,%cl
80105ae2:	74 ec                	je     80105ad0 <memcmp+0x20>
      return *s1 - *s2;
80105ae4:	0f b6 c1             	movzbl %cl,%eax
80105ae7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80105ae9:	5b                   	pop    %ebx
80105aea:	5e                   	pop    %esi
80105aeb:	5d                   	pop    %ebp
80105aec:	c3                   	ret    
80105aed:	8d 76 00             	lea    0x0(%esi),%esi
80105af0:	5b                   	pop    %ebx
  return 0;
80105af1:	31 c0                	xor    %eax,%eax
}
80105af3:	5e                   	pop    %esi
80105af4:	5d                   	pop    %ebp
80105af5:	c3                   	ret    
80105af6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105afd:	8d 76 00             	lea    0x0(%esi),%esi

80105b00 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105b00:	55                   	push   %ebp
80105b01:	89 e5                	mov    %esp,%ebp
80105b03:	57                   	push   %edi
80105b04:	8b 55 08             	mov    0x8(%ebp),%edx
80105b07:	8b 4d 10             	mov    0x10(%ebp),%ecx
80105b0a:	56                   	push   %esi
80105b0b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80105b0e:	39 d6                	cmp    %edx,%esi
80105b10:	73 26                	jae    80105b38 <memmove+0x38>
80105b12:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80105b15:	39 fa                	cmp    %edi,%edx
80105b17:	73 1f                	jae    80105b38 <memmove+0x38>
80105b19:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80105b1c:	85 c9                	test   %ecx,%ecx
80105b1e:	74 0c                	je     80105b2c <memmove+0x2c>
      *--d = *--s;
80105b20:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80105b24:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80105b27:	83 e8 01             	sub    $0x1,%eax
80105b2a:	73 f4                	jae    80105b20 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80105b2c:	5e                   	pop    %esi
80105b2d:	89 d0                	mov    %edx,%eax
80105b2f:	5f                   	pop    %edi
80105b30:	5d                   	pop    %ebp
80105b31:	c3                   	ret    
80105b32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80105b38:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80105b3b:	89 d7                	mov    %edx,%edi
80105b3d:	85 c9                	test   %ecx,%ecx
80105b3f:	74 eb                	je     80105b2c <memmove+0x2c>
80105b41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80105b48:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80105b49:	39 c6                	cmp    %eax,%esi
80105b4b:	75 fb                	jne    80105b48 <memmove+0x48>
}
80105b4d:	5e                   	pop    %esi
80105b4e:	89 d0                	mov    %edx,%eax
80105b50:	5f                   	pop    %edi
80105b51:	5d                   	pop    %ebp
80105b52:	c3                   	ret    
80105b53:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105b60 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80105b60:	eb 9e                	jmp    80105b00 <memmove>
80105b62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105b70 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80105b70:	55                   	push   %ebp
80105b71:	89 e5                	mov    %esp,%ebp
80105b73:	56                   	push   %esi
80105b74:	8b 75 10             	mov    0x10(%ebp),%esi
80105b77:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105b7a:	53                   	push   %ebx
80105b7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
80105b7e:	85 f6                	test   %esi,%esi
80105b80:	74 2e                	je     80105bb0 <strncmp+0x40>
80105b82:	01 d6                	add    %edx,%esi
80105b84:	eb 18                	jmp    80105b9e <strncmp+0x2e>
80105b86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b8d:	8d 76 00             	lea    0x0(%esi),%esi
80105b90:	38 d8                	cmp    %bl,%al
80105b92:	75 14                	jne    80105ba8 <strncmp+0x38>
    n--, p++, q++;
80105b94:	83 c2 01             	add    $0x1,%edx
80105b97:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80105b9a:	39 f2                	cmp    %esi,%edx
80105b9c:	74 12                	je     80105bb0 <strncmp+0x40>
80105b9e:	0f b6 01             	movzbl (%ecx),%eax
80105ba1:	0f b6 1a             	movzbl (%edx),%ebx
80105ba4:	84 c0                	test   %al,%al
80105ba6:	75 e8                	jne    80105b90 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80105ba8:	29 d8                	sub    %ebx,%eax
}
80105baa:	5b                   	pop    %ebx
80105bab:	5e                   	pop    %esi
80105bac:	5d                   	pop    %ebp
80105bad:	c3                   	ret    
80105bae:	66 90                	xchg   %ax,%ax
80105bb0:	5b                   	pop    %ebx
    return 0;
80105bb1:	31 c0                	xor    %eax,%eax
}
80105bb3:	5e                   	pop    %esi
80105bb4:	5d                   	pop    %ebp
80105bb5:	c3                   	ret    
80105bb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bbd:	8d 76 00             	lea    0x0(%esi),%esi

80105bc0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105bc0:	55                   	push   %ebp
80105bc1:	89 e5                	mov    %esp,%ebp
80105bc3:	57                   	push   %edi
80105bc4:	56                   	push   %esi
80105bc5:	8b 75 08             	mov    0x8(%ebp),%esi
80105bc8:	53                   	push   %ebx
80105bc9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80105bcc:	89 f0                	mov    %esi,%eax
80105bce:	eb 15                	jmp    80105be5 <strncpy+0x25>
80105bd0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80105bd4:	8b 7d 0c             	mov    0xc(%ebp),%edi
80105bd7:	83 c0 01             	add    $0x1,%eax
80105bda:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
80105bde:	88 50 ff             	mov    %dl,-0x1(%eax)
80105be1:	84 d2                	test   %dl,%dl
80105be3:	74 09                	je     80105bee <strncpy+0x2e>
80105be5:	89 cb                	mov    %ecx,%ebx
80105be7:	83 e9 01             	sub    $0x1,%ecx
80105bea:	85 db                	test   %ebx,%ebx
80105bec:	7f e2                	jg     80105bd0 <strncpy+0x10>
    ;
  while(n-- > 0)
80105bee:	89 c2                	mov    %eax,%edx
80105bf0:	85 c9                	test   %ecx,%ecx
80105bf2:	7e 17                	jle    80105c0b <strncpy+0x4b>
80105bf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80105bf8:	83 c2 01             	add    $0x1,%edx
80105bfb:	89 c1                	mov    %eax,%ecx
80105bfd:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80105c01:	29 d1                	sub    %edx,%ecx
80105c03:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80105c07:	85 c9                	test   %ecx,%ecx
80105c09:	7f ed                	jg     80105bf8 <strncpy+0x38>
  return os;
}
80105c0b:	5b                   	pop    %ebx
80105c0c:	89 f0                	mov    %esi,%eax
80105c0e:	5e                   	pop    %esi
80105c0f:	5f                   	pop    %edi
80105c10:	5d                   	pop    %ebp
80105c11:	c3                   	ret    
80105c12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105c20 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105c20:	55                   	push   %ebp
80105c21:	89 e5                	mov    %esp,%ebp
80105c23:	56                   	push   %esi
80105c24:	8b 55 10             	mov    0x10(%ebp),%edx
80105c27:	8b 75 08             	mov    0x8(%ebp),%esi
80105c2a:	53                   	push   %ebx
80105c2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80105c2e:	85 d2                	test   %edx,%edx
80105c30:	7e 25                	jle    80105c57 <safestrcpy+0x37>
80105c32:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80105c36:	89 f2                	mov    %esi,%edx
80105c38:	eb 16                	jmp    80105c50 <safestrcpy+0x30>
80105c3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105c40:	0f b6 08             	movzbl (%eax),%ecx
80105c43:	83 c0 01             	add    $0x1,%eax
80105c46:	83 c2 01             	add    $0x1,%edx
80105c49:	88 4a ff             	mov    %cl,-0x1(%edx)
80105c4c:	84 c9                	test   %cl,%cl
80105c4e:	74 04                	je     80105c54 <safestrcpy+0x34>
80105c50:	39 d8                	cmp    %ebx,%eax
80105c52:	75 ec                	jne    80105c40 <safestrcpy+0x20>
    ;
  *s = 0;
80105c54:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80105c57:	89 f0                	mov    %esi,%eax
80105c59:	5b                   	pop    %ebx
80105c5a:	5e                   	pop    %esi
80105c5b:	5d                   	pop    %ebp
80105c5c:	c3                   	ret    
80105c5d:	8d 76 00             	lea    0x0(%esi),%esi

80105c60 <strlen>:

int
strlen(const char *s)
{
80105c60:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105c61:	31 c0                	xor    %eax,%eax
{
80105c63:	89 e5                	mov    %esp,%ebp
80105c65:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80105c68:	80 3a 00             	cmpb   $0x0,(%edx)
80105c6b:	74 0c                	je     80105c79 <strlen+0x19>
80105c6d:	8d 76 00             	lea    0x0(%esi),%esi
80105c70:	83 c0 01             	add    $0x1,%eax
80105c73:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80105c77:	75 f7                	jne    80105c70 <strlen+0x10>
    ;
  return n;
}
80105c79:	5d                   	pop    %ebp
80105c7a:	c3                   	ret    

80105c7b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105c7b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105c7f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80105c83:	55                   	push   %ebp
  pushl %ebx
80105c84:	53                   	push   %ebx
  pushl %esi
80105c85:	56                   	push   %esi
  pushl %edi
80105c86:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105c87:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105c89:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80105c8b:	5f                   	pop    %edi
  popl %esi
80105c8c:	5e                   	pop    %esi
  popl %ebx
80105c8d:	5b                   	pop    %ebx
  popl %ebp
80105c8e:	5d                   	pop    %ebp
  ret
80105c8f:	c3                   	ret    

80105c90 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105c90:	55                   	push   %ebp
80105c91:	89 e5                	mov    %esp,%ebp
80105c93:	53                   	push   %ebx
80105c94:	83 ec 04             	sub    $0x4,%esp
80105c97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80105c9a:	e8 d1 f0 ff ff       	call   80104d70 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105c9f:	8b 00                	mov    (%eax),%eax
80105ca1:	39 d8                	cmp    %ebx,%eax
80105ca3:	76 1b                	jbe    80105cc0 <fetchint+0x30>
80105ca5:	8d 53 04             	lea    0x4(%ebx),%edx
80105ca8:	39 d0                	cmp    %edx,%eax
80105caa:	72 14                	jb     80105cc0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80105cac:	8b 45 0c             	mov    0xc(%ebp),%eax
80105caf:	8b 13                	mov    (%ebx),%edx
80105cb1:	89 10                	mov    %edx,(%eax)
  return 0;
80105cb3:	31 c0                	xor    %eax,%eax
}
80105cb5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105cb8:	c9                   	leave  
80105cb9:	c3                   	ret    
80105cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105cc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cc5:	eb ee                	jmp    80105cb5 <fetchint+0x25>
80105cc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cce:	66 90                	xchg   %ax,%ax

80105cd0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105cd0:	55                   	push   %ebp
80105cd1:	89 e5                	mov    %esp,%ebp
80105cd3:	53                   	push   %ebx
80105cd4:	83 ec 04             	sub    $0x4,%esp
80105cd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80105cda:	e8 91 f0 ff ff       	call   80104d70 <myproc>

  if(addr >= curproc->sz)
80105cdf:	39 18                	cmp    %ebx,(%eax)
80105ce1:	76 2d                	jbe    80105d10 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80105ce3:	8b 55 0c             	mov    0xc(%ebp),%edx
80105ce6:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80105ce8:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80105cea:	39 d3                	cmp    %edx,%ebx
80105cec:	73 22                	jae    80105d10 <fetchstr+0x40>
80105cee:	89 d8                	mov    %ebx,%eax
80105cf0:	eb 0d                	jmp    80105cff <fetchstr+0x2f>
80105cf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105cf8:	83 c0 01             	add    $0x1,%eax
80105cfb:	39 c2                	cmp    %eax,%edx
80105cfd:	76 11                	jbe    80105d10 <fetchstr+0x40>
    if(*s == 0)
80105cff:	80 38 00             	cmpb   $0x0,(%eax)
80105d02:	75 f4                	jne    80105cf8 <fetchstr+0x28>
      return s - *pp;
80105d04:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80105d06:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d09:	c9                   	leave  
80105d0a:	c3                   	ret    
80105d0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105d0f:	90                   	nop
80105d10:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80105d13:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d18:	c9                   	leave  
80105d19:	c3                   	ret    
80105d1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105d20 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105d20:	55                   	push   %ebp
80105d21:	89 e5                	mov    %esp,%ebp
80105d23:	56                   	push   %esi
80105d24:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105d25:	e8 46 f0 ff ff       	call   80104d70 <myproc>
80105d2a:	8b 55 08             	mov    0x8(%ebp),%edx
80105d2d:	8b 40 18             	mov    0x18(%eax),%eax
80105d30:	8b 40 44             	mov    0x44(%eax),%eax
80105d33:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105d36:	e8 35 f0 ff ff       	call   80104d70 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105d3b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105d3e:	8b 00                	mov    (%eax),%eax
80105d40:	39 c6                	cmp    %eax,%esi
80105d42:	73 1c                	jae    80105d60 <argint+0x40>
80105d44:	8d 53 08             	lea    0x8(%ebx),%edx
80105d47:	39 d0                	cmp    %edx,%eax
80105d49:	72 15                	jb     80105d60 <argint+0x40>
  *ip = *(int*)(addr);
80105d4b:	8b 45 0c             	mov    0xc(%ebp),%eax
80105d4e:	8b 53 04             	mov    0x4(%ebx),%edx
80105d51:	89 10                	mov    %edx,(%eax)
  return 0;
80105d53:	31 c0                	xor    %eax,%eax
}
80105d55:	5b                   	pop    %ebx
80105d56:	5e                   	pop    %esi
80105d57:	5d                   	pop    %ebp
80105d58:	c3                   	ret    
80105d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105d60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105d65:	eb ee                	jmp    80105d55 <argint+0x35>
80105d67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d6e:	66 90                	xchg   %ax,%ax

80105d70 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105d70:	55                   	push   %ebp
80105d71:	89 e5                	mov    %esp,%ebp
80105d73:	57                   	push   %edi
80105d74:	56                   	push   %esi
80105d75:	53                   	push   %ebx
80105d76:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80105d79:	e8 f2 ef ff ff       	call   80104d70 <myproc>
80105d7e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105d80:	e8 eb ef ff ff       	call   80104d70 <myproc>
80105d85:	8b 55 08             	mov    0x8(%ebp),%edx
80105d88:	8b 40 18             	mov    0x18(%eax),%eax
80105d8b:	8b 40 44             	mov    0x44(%eax),%eax
80105d8e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105d91:	e8 da ef ff ff       	call   80104d70 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105d96:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105d99:	8b 00                	mov    (%eax),%eax
80105d9b:	39 c7                	cmp    %eax,%edi
80105d9d:	73 31                	jae    80105dd0 <argptr+0x60>
80105d9f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80105da2:	39 c8                	cmp    %ecx,%eax
80105da4:	72 2a                	jb     80105dd0 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105da6:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80105da9:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105dac:	85 d2                	test   %edx,%edx
80105dae:	78 20                	js     80105dd0 <argptr+0x60>
80105db0:	8b 16                	mov    (%esi),%edx
80105db2:	39 c2                	cmp    %eax,%edx
80105db4:	76 1a                	jbe    80105dd0 <argptr+0x60>
80105db6:	8b 5d 10             	mov    0x10(%ebp),%ebx
80105db9:	01 c3                	add    %eax,%ebx
80105dbb:	39 da                	cmp    %ebx,%edx
80105dbd:	72 11                	jb     80105dd0 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80105dbf:	8b 55 0c             	mov    0xc(%ebp),%edx
80105dc2:	89 02                	mov    %eax,(%edx)
  return 0;
80105dc4:	31 c0                	xor    %eax,%eax
}
80105dc6:	83 c4 0c             	add    $0xc,%esp
80105dc9:	5b                   	pop    %ebx
80105dca:	5e                   	pop    %esi
80105dcb:	5f                   	pop    %edi
80105dcc:	5d                   	pop    %ebp
80105dcd:	c3                   	ret    
80105dce:	66 90                	xchg   %ax,%ax
    return -1;
80105dd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dd5:	eb ef                	jmp    80105dc6 <argptr+0x56>
80105dd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dde:	66 90                	xchg   %ax,%ax

80105de0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105de0:	55                   	push   %ebp
80105de1:	89 e5                	mov    %esp,%ebp
80105de3:	56                   	push   %esi
80105de4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105de5:	e8 86 ef ff ff       	call   80104d70 <myproc>
80105dea:	8b 55 08             	mov    0x8(%ebp),%edx
80105ded:	8b 40 18             	mov    0x18(%eax),%eax
80105df0:	8b 40 44             	mov    0x44(%eax),%eax
80105df3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105df6:	e8 75 ef ff ff       	call   80104d70 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105dfb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105dfe:	8b 00                	mov    (%eax),%eax
80105e00:	39 c6                	cmp    %eax,%esi
80105e02:	73 44                	jae    80105e48 <argstr+0x68>
80105e04:	8d 53 08             	lea    0x8(%ebx),%edx
80105e07:	39 d0                	cmp    %edx,%eax
80105e09:	72 3d                	jb     80105e48 <argstr+0x68>
  *ip = *(int*)(addr);
80105e0b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80105e0e:	e8 5d ef ff ff       	call   80104d70 <myproc>
  if(addr >= curproc->sz)
80105e13:	3b 18                	cmp    (%eax),%ebx
80105e15:	73 31                	jae    80105e48 <argstr+0x68>
  *pp = (char*)addr;
80105e17:	8b 55 0c             	mov    0xc(%ebp),%edx
80105e1a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80105e1c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80105e1e:	39 d3                	cmp    %edx,%ebx
80105e20:	73 26                	jae    80105e48 <argstr+0x68>
80105e22:	89 d8                	mov    %ebx,%eax
80105e24:	eb 11                	jmp    80105e37 <argstr+0x57>
80105e26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e2d:	8d 76 00             	lea    0x0(%esi),%esi
80105e30:	83 c0 01             	add    $0x1,%eax
80105e33:	39 c2                	cmp    %eax,%edx
80105e35:	76 11                	jbe    80105e48 <argstr+0x68>
    if(*s == 0)
80105e37:	80 38 00             	cmpb   $0x0,(%eax)
80105e3a:	75 f4                	jne    80105e30 <argstr+0x50>
      return s - *pp;
80105e3c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80105e3e:	5b                   	pop    %ebx
80105e3f:	5e                   	pop    %esi
80105e40:	5d                   	pop    %ebp
80105e41:	c3                   	ret    
80105e42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105e48:	5b                   	pop    %ebx
    return -1;
80105e49:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e4e:	5e                   	pop    %esi
80105e4f:	5d                   	pop    %ebp
80105e50:	c3                   	ret    
80105e51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e5f:	90                   	nop

80105e60 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80105e60:	55                   	push   %ebp
80105e61:	89 e5                	mov    %esp,%ebp
80105e63:	53                   	push   %ebx
80105e64:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80105e67:	e8 04 ef ff ff       	call   80104d70 <myproc>
80105e6c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80105e6e:	8b 40 18             	mov    0x18(%eax),%eax
80105e71:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105e74:	8d 50 ff             	lea    -0x1(%eax),%edx
80105e77:	83 fa 14             	cmp    $0x14,%edx
80105e7a:	77 24                	ja     80105ea0 <syscall+0x40>
80105e7c:	8b 14 85 c0 8c 10 80 	mov    -0x7fef7340(,%eax,4),%edx
80105e83:	85 d2                	test   %edx,%edx
80105e85:	74 19                	je     80105ea0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80105e87:	ff d2                	call   *%edx
80105e89:	89 c2                	mov    %eax,%edx
80105e8b:	8b 43 18             	mov    0x18(%ebx),%eax
80105e8e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105e91:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105e94:	c9                   	leave  
80105e95:	c3                   	ret    
80105e96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e9d:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105ea0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105ea1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80105ea4:	50                   	push   %eax
80105ea5:	ff 73 10             	push   0x10(%ebx)
80105ea8:	68 9d 8c 10 80       	push   $0x80108c9d
80105ead:	e8 4e a8 ff ff       	call   80100700 <cprintf>
    curproc->tf->eax = -1;
80105eb2:	8b 43 18             	mov    0x18(%ebx),%eax
80105eb5:	83 c4 10             	add    $0x10,%esp
80105eb8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80105ebf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ec2:	c9                   	leave  
80105ec3:	c3                   	ret    
80105ec4:	66 90                	xchg   %ax,%ax
80105ec6:	66 90                	xchg   %ax,%ax
80105ec8:	66 90                	xchg   %ax,%ax
80105eca:	66 90                	xchg   %ax,%ax
80105ecc:	66 90                	xchg   %ax,%ax
80105ece:	66 90                	xchg   %ax,%ax

80105ed0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105ed0:	55                   	push   %ebp
80105ed1:	89 e5                	mov    %esp,%ebp
80105ed3:	57                   	push   %edi
80105ed4:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105ed5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80105ed8:	53                   	push   %ebx
80105ed9:	83 ec 34             	sub    $0x34,%esp
80105edc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80105edf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105ee2:	57                   	push   %edi
80105ee3:	50                   	push   %eax
{
80105ee4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105ee7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80105eea:	e8 d1 d5 ff ff       	call   801034c0 <nameiparent>
80105eef:	83 c4 10             	add    $0x10,%esp
80105ef2:	85 c0                	test   %eax,%eax
80105ef4:	0f 84 46 01 00 00    	je     80106040 <create+0x170>
    return 0;
  ilock(dp);
80105efa:	83 ec 0c             	sub    $0xc,%esp
80105efd:	89 c3                	mov    %eax,%ebx
80105eff:	50                   	push   %eax
80105f00:	e8 7b cc ff ff       	call   80102b80 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105f05:	83 c4 0c             	add    $0xc,%esp
80105f08:	6a 00                	push   $0x0
80105f0a:	57                   	push   %edi
80105f0b:	53                   	push   %ebx
80105f0c:	e8 cf d1 ff ff       	call   801030e0 <dirlookup>
80105f11:	83 c4 10             	add    $0x10,%esp
80105f14:	89 c6                	mov    %eax,%esi
80105f16:	85 c0                	test   %eax,%eax
80105f18:	74 56                	je     80105f70 <create+0xa0>
    iunlockput(dp);
80105f1a:	83 ec 0c             	sub    $0xc,%esp
80105f1d:	53                   	push   %ebx
80105f1e:	e8 ed ce ff ff       	call   80102e10 <iunlockput>
    ilock(ip);
80105f23:	89 34 24             	mov    %esi,(%esp)
80105f26:	e8 55 cc ff ff       	call   80102b80 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105f2b:	83 c4 10             	add    $0x10,%esp
80105f2e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105f33:	75 1b                	jne    80105f50 <create+0x80>
80105f35:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80105f3a:	75 14                	jne    80105f50 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105f3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f3f:	89 f0                	mov    %esi,%eax
80105f41:	5b                   	pop    %ebx
80105f42:	5e                   	pop    %esi
80105f43:	5f                   	pop    %edi
80105f44:	5d                   	pop    %ebp
80105f45:	c3                   	ret    
80105f46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f4d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105f50:	83 ec 0c             	sub    $0xc,%esp
80105f53:	56                   	push   %esi
    return 0;
80105f54:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80105f56:	e8 b5 ce ff ff       	call   80102e10 <iunlockput>
    return 0;
80105f5b:	83 c4 10             	add    $0x10,%esp
}
80105f5e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f61:	89 f0                	mov    %esi,%eax
80105f63:	5b                   	pop    %ebx
80105f64:	5e                   	pop    %esi
80105f65:	5f                   	pop    %edi
80105f66:	5d                   	pop    %ebp
80105f67:	c3                   	ret    
80105f68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f6f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80105f70:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105f74:	83 ec 08             	sub    $0x8,%esp
80105f77:	50                   	push   %eax
80105f78:	ff 33                	push   (%ebx)
80105f7a:	e8 91 ca ff ff       	call   80102a10 <ialloc>
80105f7f:	83 c4 10             	add    $0x10,%esp
80105f82:	89 c6                	mov    %eax,%esi
80105f84:	85 c0                	test   %eax,%eax
80105f86:	0f 84 cd 00 00 00    	je     80106059 <create+0x189>
  ilock(ip);
80105f8c:	83 ec 0c             	sub    $0xc,%esp
80105f8f:	50                   	push   %eax
80105f90:	e8 eb cb ff ff       	call   80102b80 <ilock>
  ip->major = major;
80105f95:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105f99:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80105f9d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105fa1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80105fa5:	b8 01 00 00 00       	mov    $0x1,%eax
80105faa:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80105fae:	89 34 24             	mov    %esi,(%esp)
80105fb1:	e8 1a cb ff ff       	call   80102ad0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105fb6:	83 c4 10             	add    $0x10,%esp
80105fb9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105fbe:	74 30                	je     80105ff0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105fc0:	83 ec 04             	sub    $0x4,%esp
80105fc3:	ff 76 04             	push   0x4(%esi)
80105fc6:	57                   	push   %edi
80105fc7:	53                   	push   %ebx
80105fc8:	e8 13 d4 ff ff       	call   801033e0 <dirlink>
80105fcd:	83 c4 10             	add    $0x10,%esp
80105fd0:	85 c0                	test   %eax,%eax
80105fd2:	78 78                	js     8010604c <create+0x17c>
  iunlockput(dp);
80105fd4:	83 ec 0c             	sub    $0xc,%esp
80105fd7:	53                   	push   %ebx
80105fd8:	e8 33 ce ff ff       	call   80102e10 <iunlockput>
  return ip;
80105fdd:	83 c4 10             	add    $0x10,%esp
}
80105fe0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105fe3:	89 f0                	mov    %esi,%eax
80105fe5:	5b                   	pop    %ebx
80105fe6:	5e                   	pop    %esi
80105fe7:	5f                   	pop    %edi
80105fe8:	5d                   	pop    %ebp
80105fe9:	c3                   	ret    
80105fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105ff0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80105ff3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105ff8:	53                   	push   %ebx
80105ff9:	e8 d2 ca ff ff       	call   80102ad0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105ffe:	83 c4 0c             	add    $0xc,%esp
80106001:	ff 76 04             	push   0x4(%esi)
80106004:	68 34 8d 10 80       	push   $0x80108d34
80106009:	56                   	push   %esi
8010600a:	e8 d1 d3 ff ff       	call   801033e0 <dirlink>
8010600f:	83 c4 10             	add    $0x10,%esp
80106012:	85 c0                	test   %eax,%eax
80106014:	78 18                	js     8010602e <create+0x15e>
80106016:	83 ec 04             	sub    $0x4,%esp
80106019:	ff 73 04             	push   0x4(%ebx)
8010601c:	68 33 8d 10 80       	push   $0x80108d33
80106021:	56                   	push   %esi
80106022:	e8 b9 d3 ff ff       	call   801033e0 <dirlink>
80106027:	83 c4 10             	add    $0x10,%esp
8010602a:	85 c0                	test   %eax,%eax
8010602c:	79 92                	jns    80105fc0 <create+0xf0>
      panic("create dots");
8010602e:	83 ec 0c             	sub    $0xc,%esp
80106031:	68 27 8d 10 80       	push   $0x80108d27
80106036:	e8 45 a3 ff ff       	call   80100380 <panic>
8010603b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010603f:	90                   	nop
}
80106040:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80106043:	31 f6                	xor    %esi,%esi
}
80106045:	5b                   	pop    %ebx
80106046:	89 f0                	mov    %esi,%eax
80106048:	5e                   	pop    %esi
80106049:	5f                   	pop    %edi
8010604a:	5d                   	pop    %ebp
8010604b:	c3                   	ret    
    panic("create: dirlink");
8010604c:	83 ec 0c             	sub    $0xc,%esp
8010604f:	68 36 8d 10 80       	push   $0x80108d36
80106054:	e8 27 a3 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80106059:	83 ec 0c             	sub    $0xc,%esp
8010605c:	68 18 8d 10 80       	push   $0x80108d18
80106061:	e8 1a a3 ff ff       	call   80100380 <panic>
80106066:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010606d:	8d 76 00             	lea    0x0(%esi),%esi

80106070 <sys_dup>:
{
80106070:	55                   	push   %ebp
80106071:	89 e5                	mov    %esp,%ebp
80106073:	56                   	push   %esi
80106074:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80106075:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106078:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010607b:	50                   	push   %eax
8010607c:	6a 00                	push   $0x0
8010607e:	e8 9d fc ff ff       	call   80105d20 <argint>
80106083:	83 c4 10             	add    $0x10,%esp
80106086:	85 c0                	test   %eax,%eax
80106088:	78 36                	js     801060c0 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010608a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010608e:	77 30                	ja     801060c0 <sys_dup+0x50>
80106090:	e8 db ec ff ff       	call   80104d70 <myproc>
80106095:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106098:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010609c:	85 f6                	test   %esi,%esi
8010609e:	74 20                	je     801060c0 <sys_dup+0x50>
  struct proc *curproc = myproc();
801060a0:	e8 cb ec ff ff       	call   80104d70 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801060a5:	31 db                	xor    %ebx,%ebx
801060a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060ae:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
801060b0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801060b4:	85 d2                	test   %edx,%edx
801060b6:	74 18                	je     801060d0 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
801060b8:	83 c3 01             	add    $0x1,%ebx
801060bb:	83 fb 10             	cmp    $0x10,%ebx
801060be:	75 f0                	jne    801060b0 <sys_dup+0x40>
}
801060c0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801060c3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801060c8:	89 d8                	mov    %ebx,%eax
801060ca:	5b                   	pop    %ebx
801060cb:	5e                   	pop    %esi
801060cc:	5d                   	pop    %ebp
801060cd:	c3                   	ret    
801060ce:	66 90                	xchg   %ax,%ax
  filedup(f);
801060d0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801060d3:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
801060d7:	56                   	push   %esi
801060d8:	e8 c3 c1 ff ff       	call   801022a0 <filedup>
  return fd;
801060dd:	83 c4 10             	add    $0x10,%esp
}
801060e0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801060e3:	89 d8                	mov    %ebx,%eax
801060e5:	5b                   	pop    %ebx
801060e6:	5e                   	pop    %esi
801060e7:	5d                   	pop    %ebp
801060e8:	c3                   	ret    
801060e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801060f0 <sys_read>:
{
801060f0:	55                   	push   %ebp
801060f1:	89 e5                	mov    %esp,%ebp
801060f3:	56                   	push   %esi
801060f4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801060f5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801060f8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801060fb:	53                   	push   %ebx
801060fc:	6a 00                	push   $0x0
801060fe:	e8 1d fc ff ff       	call   80105d20 <argint>
80106103:	83 c4 10             	add    $0x10,%esp
80106106:	85 c0                	test   %eax,%eax
80106108:	78 5e                	js     80106168 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010610a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010610e:	77 58                	ja     80106168 <sys_read+0x78>
80106110:	e8 5b ec ff ff       	call   80104d70 <myproc>
80106115:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106118:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010611c:	85 f6                	test   %esi,%esi
8010611e:	74 48                	je     80106168 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106120:	83 ec 08             	sub    $0x8,%esp
80106123:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106126:	50                   	push   %eax
80106127:	6a 02                	push   $0x2
80106129:	e8 f2 fb ff ff       	call   80105d20 <argint>
8010612e:	83 c4 10             	add    $0x10,%esp
80106131:	85 c0                	test   %eax,%eax
80106133:	78 33                	js     80106168 <sys_read+0x78>
80106135:	83 ec 04             	sub    $0x4,%esp
80106138:	ff 75 f0             	push   -0x10(%ebp)
8010613b:	53                   	push   %ebx
8010613c:	6a 01                	push   $0x1
8010613e:	e8 2d fc ff ff       	call   80105d70 <argptr>
80106143:	83 c4 10             	add    $0x10,%esp
80106146:	85 c0                	test   %eax,%eax
80106148:	78 1e                	js     80106168 <sys_read+0x78>
  return fileread(f, p, n);
8010614a:	83 ec 04             	sub    $0x4,%esp
8010614d:	ff 75 f0             	push   -0x10(%ebp)
80106150:	ff 75 f4             	push   -0xc(%ebp)
80106153:	56                   	push   %esi
80106154:	e8 c7 c2 ff ff       	call   80102420 <fileread>
80106159:	83 c4 10             	add    $0x10,%esp
}
8010615c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010615f:	5b                   	pop    %ebx
80106160:	5e                   	pop    %esi
80106161:	5d                   	pop    %ebp
80106162:	c3                   	ret    
80106163:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106167:	90                   	nop
    return -1;
80106168:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010616d:	eb ed                	jmp    8010615c <sys_read+0x6c>
8010616f:	90                   	nop

80106170 <sys_write>:
{
80106170:	55                   	push   %ebp
80106171:	89 e5                	mov    %esp,%ebp
80106173:	56                   	push   %esi
80106174:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80106175:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80106178:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010617b:	53                   	push   %ebx
8010617c:	6a 00                	push   $0x0
8010617e:	e8 9d fb ff ff       	call   80105d20 <argint>
80106183:	83 c4 10             	add    $0x10,%esp
80106186:	85 c0                	test   %eax,%eax
80106188:	78 5e                	js     801061e8 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010618a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010618e:	77 58                	ja     801061e8 <sys_write+0x78>
80106190:	e8 db eb ff ff       	call   80104d70 <myproc>
80106195:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106198:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010619c:	85 f6                	test   %esi,%esi
8010619e:	74 48                	je     801061e8 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801061a0:	83 ec 08             	sub    $0x8,%esp
801061a3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801061a6:	50                   	push   %eax
801061a7:	6a 02                	push   $0x2
801061a9:	e8 72 fb ff ff       	call   80105d20 <argint>
801061ae:	83 c4 10             	add    $0x10,%esp
801061b1:	85 c0                	test   %eax,%eax
801061b3:	78 33                	js     801061e8 <sys_write+0x78>
801061b5:	83 ec 04             	sub    $0x4,%esp
801061b8:	ff 75 f0             	push   -0x10(%ebp)
801061bb:	53                   	push   %ebx
801061bc:	6a 01                	push   $0x1
801061be:	e8 ad fb ff ff       	call   80105d70 <argptr>
801061c3:	83 c4 10             	add    $0x10,%esp
801061c6:	85 c0                	test   %eax,%eax
801061c8:	78 1e                	js     801061e8 <sys_write+0x78>
  return filewrite(f, p, n);
801061ca:	83 ec 04             	sub    $0x4,%esp
801061cd:	ff 75 f0             	push   -0x10(%ebp)
801061d0:	ff 75 f4             	push   -0xc(%ebp)
801061d3:	56                   	push   %esi
801061d4:	e8 d7 c2 ff ff       	call   801024b0 <filewrite>
801061d9:	83 c4 10             	add    $0x10,%esp
}
801061dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801061df:	5b                   	pop    %ebx
801061e0:	5e                   	pop    %esi
801061e1:	5d                   	pop    %ebp
801061e2:	c3                   	ret    
801061e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801061e7:	90                   	nop
    return -1;
801061e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061ed:	eb ed                	jmp    801061dc <sys_write+0x6c>
801061ef:	90                   	nop

801061f0 <sys_close>:
{
801061f0:	55                   	push   %ebp
801061f1:	89 e5                	mov    %esp,%ebp
801061f3:	56                   	push   %esi
801061f4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801061f5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801061f8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801061fb:	50                   	push   %eax
801061fc:	6a 00                	push   $0x0
801061fe:	e8 1d fb ff ff       	call   80105d20 <argint>
80106203:	83 c4 10             	add    $0x10,%esp
80106206:	85 c0                	test   %eax,%eax
80106208:	78 3e                	js     80106248 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010620a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010620e:	77 38                	ja     80106248 <sys_close+0x58>
80106210:	e8 5b eb ff ff       	call   80104d70 <myproc>
80106215:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106218:	8d 5a 08             	lea    0x8(%edx),%ebx
8010621b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
8010621f:	85 f6                	test   %esi,%esi
80106221:	74 25                	je     80106248 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80106223:	e8 48 eb ff ff       	call   80104d70 <myproc>
  fileclose(f);
80106228:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
8010622b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80106232:	00 
  fileclose(f);
80106233:	56                   	push   %esi
80106234:	e8 b7 c0 ff ff       	call   801022f0 <fileclose>
  return 0;
80106239:	83 c4 10             	add    $0x10,%esp
8010623c:	31 c0                	xor    %eax,%eax
}
8010623e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106241:	5b                   	pop    %ebx
80106242:	5e                   	pop    %esi
80106243:	5d                   	pop    %ebp
80106244:	c3                   	ret    
80106245:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106248:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010624d:	eb ef                	jmp    8010623e <sys_close+0x4e>
8010624f:	90                   	nop

80106250 <sys_fstat>:
{
80106250:	55                   	push   %ebp
80106251:	89 e5                	mov    %esp,%ebp
80106253:	56                   	push   %esi
80106254:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80106255:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80106258:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010625b:	53                   	push   %ebx
8010625c:	6a 00                	push   $0x0
8010625e:	e8 bd fa ff ff       	call   80105d20 <argint>
80106263:	83 c4 10             	add    $0x10,%esp
80106266:	85 c0                	test   %eax,%eax
80106268:	78 46                	js     801062b0 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010626a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010626e:	77 40                	ja     801062b0 <sys_fstat+0x60>
80106270:	e8 fb ea ff ff       	call   80104d70 <myproc>
80106275:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106278:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010627c:	85 f6                	test   %esi,%esi
8010627e:	74 30                	je     801062b0 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80106280:	83 ec 04             	sub    $0x4,%esp
80106283:	6a 14                	push   $0x14
80106285:	53                   	push   %ebx
80106286:	6a 01                	push   $0x1
80106288:	e8 e3 fa ff ff       	call   80105d70 <argptr>
8010628d:	83 c4 10             	add    $0x10,%esp
80106290:	85 c0                	test   %eax,%eax
80106292:	78 1c                	js     801062b0 <sys_fstat+0x60>
  return filestat(f, st);
80106294:	83 ec 08             	sub    $0x8,%esp
80106297:	ff 75 f4             	push   -0xc(%ebp)
8010629a:	56                   	push   %esi
8010629b:	e8 30 c1 ff ff       	call   801023d0 <filestat>
801062a0:	83 c4 10             	add    $0x10,%esp
}
801062a3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801062a6:	5b                   	pop    %ebx
801062a7:	5e                   	pop    %esi
801062a8:	5d                   	pop    %ebp
801062a9:	c3                   	ret    
801062aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801062b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062b5:	eb ec                	jmp    801062a3 <sys_fstat+0x53>
801062b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801062be:	66 90                	xchg   %ax,%ax

801062c0 <sys_link>:
{
801062c0:	55                   	push   %ebp
801062c1:	89 e5                	mov    %esp,%ebp
801062c3:	57                   	push   %edi
801062c4:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801062c5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801062c8:	53                   	push   %ebx
801062c9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801062cc:	50                   	push   %eax
801062cd:	6a 00                	push   $0x0
801062cf:	e8 0c fb ff ff       	call   80105de0 <argstr>
801062d4:	83 c4 10             	add    $0x10,%esp
801062d7:	85 c0                	test   %eax,%eax
801062d9:	0f 88 fb 00 00 00    	js     801063da <sys_link+0x11a>
801062df:	83 ec 08             	sub    $0x8,%esp
801062e2:	8d 45 d0             	lea    -0x30(%ebp),%eax
801062e5:	50                   	push   %eax
801062e6:	6a 01                	push   $0x1
801062e8:	e8 f3 fa ff ff       	call   80105de0 <argstr>
801062ed:	83 c4 10             	add    $0x10,%esp
801062f0:	85 c0                	test   %eax,%eax
801062f2:	0f 88 e2 00 00 00    	js     801063da <sys_link+0x11a>
  begin_op();
801062f8:	e8 63 de ff ff       	call   80104160 <begin_op>
  if((ip = namei(old)) == 0){
801062fd:	83 ec 0c             	sub    $0xc,%esp
80106300:	ff 75 d4             	push   -0x2c(%ebp)
80106303:	e8 98 d1 ff ff       	call   801034a0 <namei>
80106308:	83 c4 10             	add    $0x10,%esp
8010630b:	89 c3                	mov    %eax,%ebx
8010630d:	85 c0                	test   %eax,%eax
8010630f:	0f 84 e4 00 00 00    	je     801063f9 <sys_link+0x139>
  ilock(ip);
80106315:	83 ec 0c             	sub    $0xc,%esp
80106318:	50                   	push   %eax
80106319:	e8 62 c8 ff ff       	call   80102b80 <ilock>
  if(ip->type == T_DIR){
8010631e:	83 c4 10             	add    $0x10,%esp
80106321:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80106326:	0f 84 b5 00 00 00    	je     801063e1 <sys_link+0x121>
  iupdate(ip);
8010632c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010632f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80106334:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80106337:	53                   	push   %ebx
80106338:	e8 93 c7 ff ff       	call   80102ad0 <iupdate>
  iunlock(ip);
8010633d:	89 1c 24             	mov    %ebx,(%esp)
80106340:	e8 1b c9 ff ff       	call   80102c60 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80106345:	58                   	pop    %eax
80106346:	5a                   	pop    %edx
80106347:	57                   	push   %edi
80106348:	ff 75 d0             	push   -0x30(%ebp)
8010634b:	e8 70 d1 ff ff       	call   801034c0 <nameiparent>
80106350:	83 c4 10             	add    $0x10,%esp
80106353:	89 c6                	mov    %eax,%esi
80106355:	85 c0                	test   %eax,%eax
80106357:	74 5b                	je     801063b4 <sys_link+0xf4>
  ilock(dp);
80106359:	83 ec 0c             	sub    $0xc,%esp
8010635c:	50                   	push   %eax
8010635d:	e8 1e c8 ff ff       	call   80102b80 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80106362:	8b 03                	mov    (%ebx),%eax
80106364:	83 c4 10             	add    $0x10,%esp
80106367:	39 06                	cmp    %eax,(%esi)
80106369:	75 3d                	jne    801063a8 <sys_link+0xe8>
8010636b:	83 ec 04             	sub    $0x4,%esp
8010636e:	ff 73 04             	push   0x4(%ebx)
80106371:	57                   	push   %edi
80106372:	56                   	push   %esi
80106373:	e8 68 d0 ff ff       	call   801033e0 <dirlink>
80106378:	83 c4 10             	add    $0x10,%esp
8010637b:	85 c0                	test   %eax,%eax
8010637d:	78 29                	js     801063a8 <sys_link+0xe8>
  iunlockput(dp);
8010637f:	83 ec 0c             	sub    $0xc,%esp
80106382:	56                   	push   %esi
80106383:	e8 88 ca ff ff       	call   80102e10 <iunlockput>
  iput(ip);
80106388:	89 1c 24             	mov    %ebx,(%esp)
8010638b:	e8 20 c9 ff ff       	call   80102cb0 <iput>
  end_op();
80106390:	e8 3b de ff ff       	call   801041d0 <end_op>
  return 0;
80106395:	83 c4 10             	add    $0x10,%esp
80106398:	31 c0                	xor    %eax,%eax
}
8010639a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010639d:	5b                   	pop    %ebx
8010639e:	5e                   	pop    %esi
8010639f:	5f                   	pop    %edi
801063a0:	5d                   	pop    %ebp
801063a1:	c3                   	ret    
801063a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
801063a8:	83 ec 0c             	sub    $0xc,%esp
801063ab:	56                   	push   %esi
801063ac:	e8 5f ca ff ff       	call   80102e10 <iunlockput>
    goto bad;
801063b1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801063b4:	83 ec 0c             	sub    $0xc,%esp
801063b7:	53                   	push   %ebx
801063b8:	e8 c3 c7 ff ff       	call   80102b80 <ilock>
  ip->nlink--;
801063bd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801063c2:	89 1c 24             	mov    %ebx,(%esp)
801063c5:	e8 06 c7 ff ff       	call   80102ad0 <iupdate>
  iunlockput(ip);
801063ca:	89 1c 24             	mov    %ebx,(%esp)
801063cd:	e8 3e ca ff ff       	call   80102e10 <iunlockput>
  end_op();
801063d2:	e8 f9 dd ff ff       	call   801041d0 <end_op>
  return -1;
801063d7:	83 c4 10             	add    $0x10,%esp
801063da:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063df:	eb b9                	jmp    8010639a <sys_link+0xda>
    iunlockput(ip);
801063e1:	83 ec 0c             	sub    $0xc,%esp
801063e4:	53                   	push   %ebx
801063e5:	e8 26 ca ff ff       	call   80102e10 <iunlockput>
    end_op();
801063ea:	e8 e1 dd ff ff       	call   801041d0 <end_op>
    return -1;
801063ef:	83 c4 10             	add    $0x10,%esp
801063f2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063f7:	eb a1                	jmp    8010639a <sys_link+0xda>
    end_op();
801063f9:	e8 d2 dd ff ff       	call   801041d0 <end_op>
    return -1;
801063fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106403:	eb 95                	jmp    8010639a <sys_link+0xda>
80106405:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010640c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106410 <sys_unlink>:
{
80106410:	55                   	push   %ebp
80106411:	89 e5                	mov    %esp,%ebp
80106413:	57                   	push   %edi
80106414:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80106415:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80106418:	53                   	push   %ebx
80106419:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010641c:	50                   	push   %eax
8010641d:	6a 00                	push   $0x0
8010641f:	e8 bc f9 ff ff       	call   80105de0 <argstr>
80106424:	83 c4 10             	add    $0x10,%esp
80106427:	85 c0                	test   %eax,%eax
80106429:	0f 88 7a 01 00 00    	js     801065a9 <sys_unlink+0x199>
  begin_op();
8010642f:	e8 2c dd ff ff       	call   80104160 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80106434:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80106437:	83 ec 08             	sub    $0x8,%esp
8010643a:	53                   	push   %ebx
8010643b:	ff 75 c0             	push   -0x40(%ebp)
8010643e:	e8 7d d0 ff ff       	call   801034c0 <nameiparent>
80106443:	83 c4 10             	add    $0x10,%esp
80106446:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80106449:	85 c0                	test   %eax,%eax
8010644b:	0f 84 62 01 00 00    	je     801065b3 <sys_unlink+0x1a3>
  ilock(dp);
80106451:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80106454:	83 ec 0c             	sub    $0xc,%esp
80106457:	57                   	push   %edi
80106458:	e8 23 c7 ff ff       	call   80102b80 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010645d:	58                   	pop    %eax
8010645e:	5a                   	pop    %edx
8010645f:	68 34 8d 10 80       	push   $0x80108d34
80106464:	53                   	push   %ebx
80106465:	e8 56 cc ff ff       	call   801030c0 <namecmp>
8010646a:	83 c4 10             	add    $0x10,%esp
8010646d:	85 c0                	test   %eax,%eax
8010646f:	0f 84 fb 00 00 00    	je     80106570 <sys_unlink+0x160>
80106475:	83 ec 08             	sub    $0x8,%esp
80106478:	68 33 8d 10 80       	push   $0x80108d33
8010647d:	53                   	push   %ebx
8010647e:	e8 3d cc ff ff       	call   801030c0 <namecmp>
80106483:	83 c4 10             	add    $0x10,%esp
80106486:	85 c0                	test   %eax,%eax
80106488:	0f 84 e2 00 00 00    	je     80106570 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010648e:	83 ec 04             	sub    $0x4,%esp
80106491:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80106494:	50                   	push   %eax
80106495:	53                   	push   %ebx
80106496:	57                   	push   %edi
80106497:	e8 44 cc ff ff       	call   801030e0 <dirlookup>
8010649c:	83 c4 10             	add    $0x10,%esp
8010649f:	89 c3                	mov    %eax,%ebx
801064a1:	85 c0                	test   %eax,%eax
801064a3:	0f 84 c7 00 00 00    	je     80106570 <sys_unlink+0x160>
  ilock(ip);
801064a9:	83 ec 0c             	sub    $0xc,%esp
801064ac:	50                   	push   %eax
801064ad:	e8 ce c6 ff ff       	call   80102b80 <ilock>
  if(ip->nlink < 1)
801064b2:	83 c4 10             	add    $0x10,%esp
801064b5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801064ba:	0f 8e 1c 01 00 00    	jle    801065dc <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
801064c0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801064c5:	8d 7d d8             	lea    -0x28(%ebp),%edi
801064c8:	74 66                	je     80106530 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801064ca:	83 ec 04             	sub    $0x4,%esp
801064cd:	6a 10                	push   $0x10
801064cf:	6a 00                	push   $0x0
801064d1:	57                   	push   %edi
801064d2:	e8 89 f5 ff ff       	call   80105a60 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801064d7:	6a 10                	push   $0x10
801064d9:	ff 75 c4             	push   -0x3c(%ebp)
801064dc:	57                   	push   %edi
801064dd:	ff 75 b4             	push   -0x4c(%ebp)
801064e0:	e8 ab ca ff ff       	call   80102f90 <writei>
801064e5:	83 c4 20             	add    $0x20,%esp
801064e8:	83 f8 10             	cmp    $0x10,%eax
801064eb:	0f 85 de 00 00 00    	jne    801065cf <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
801064f1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801064f6:	0f 84 94 00 00 00    	je     80106590 <sys_unlink+0x180>
  iunlockput(dp);
801064fc:	83 ec 0c             	sub    $0xc,%esp
801064ff:	ff 75 b4             	push   -0x4c(%ebp)
80106502:	e8 09 c9 ff ff       	call   80102e10 <iunlockput>
  ip->nlink--;
80106507:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010650c:	89 1c 24             	mov    %ebx,(%esp)
8010650f:	e8 bc c5 ff ff       	call   80102ad0 <iupdate>
  iunlockput(ip);
80106514:	89 1c 24             	mov    %ebx,(%esp)
80106517:	e8 f4 c8 ff ff       	call   80102e10 <iunlockput>
  end_op();
8010651c:	e8 af dc ff ff       	call   801041d0 <end_op>
  return 0;
80106521:	83 c4 10             	add    $0x10,%esp
80106524:	31 c0                	xor    %eax,%eax
}
80106526:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106529:	5b                   	pop    %ebx
8010652a:	5e                   	pop    %esi
8010652b:	5f                   	pop    %edi
8010652c:	5d                   	pop    %ebp
8010652d:	c3                   	ret    
8010652e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80106530:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80106534:	76 94                	jbe    801064ca <sys_unlink+0xba>
80106536:	be 20 00 00 00       	mov    $0x20,%esi
8010653b:	eb 0b                	jmp    80106548 <sys_unlink+0x138>
8010653d:	8d 76 00             	lea    0x0(%esi),%esi
80106540:	83 c6 10             	add    $0x10,%esi
80106543:	3b 73 58             	cmp    0x58(%ebx),%esi
80106546:	73 82                	jae    801064ca <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106548:	6a 10                	push   $0x10
8010654a:	56                   	push   %esi
8010654b:	57                   	push   %edi
8010654c:	53                   	push   %ebx
8010654d:	e8 3e c9 ff ff       	call   80102e90 <readi>
80106552:	83 c4 10             	add    $0x10,%esp
80106555:	83 f8 10             	cmp    $0x10,%eax
80106558:	75 68                	jne    801065c2 <sys_unlink+0x1b2>
    if(de.inum != 0)
8010655a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010655f:	74 df                	je     80106540 <sys_unlink+0x130>
    iunlockput(ip);
80106561:	83 ec 0c             	sub    $0xc,%esp
80106564:	53                   	push   %ebx
80106565:	e8 a6 c8 ff ff       	call   80102e10 <iunlockput>
    goto bad;
8010656a:	83 c4 10             	add    $0x10,%esp
8010656d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80106570:	83 ec 0c             	sub    $0xc,%esp
80106573:	ff 75 b4             	push   -0x4c(%ebp)
80106576:	e8 95 c8 ff ff       	call   80102e10 <iunlockput>
  end_op();
8010657b:	e8 50 dc ff ff       	call   801041d0 <end_op>
  return -1;
80106580:	83 c4 10             	add    $0x10,%esp
80106583:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106588:	eb 9c                	jmp    80106526 <sys_unlink+0x116>
8010658a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80106590:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80106593:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80106596:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010659b:	50                   	push   %eax
8010659c:	e8 2f c5 ff ff       	call   80102ad0 <iupdate>
801065a1:	83 c4 10             	add    $0x10,%esp
801065a4:	e9 53 ff ff ff       	jmp    801064fc <sys_unlink+0xec>
    return -1;
801065a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065ae:	e9 73 ff ff ff       	jmp    80106526 <sys_unlink+0x116>
    end_op();
801065b3:	e8 18 dc ff ff       	call   801041d0 <end_op>
    return -1;
801065b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065bd:	e9 64 ff ff ff       	jmp    80106526 <sys_unlink+0x116>
      panic("isdirempty: readi");
801065c2:	83 ec 0c             	sub    $0xc,%esp
801065c5:	68 58 8d 10 80       	push   $0x80108d58
801065ca:	e8 b1 9d ff ff       	call   80100380 <panic>
    panic("unlink: writei");
801065cf:	83 ec 0c             	sub    $0xc,%esp
801065d2:	68 6a 8d 10 80       	push   $0x80108d6a
801065d7:	e8 a4 9d ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
801065dc:	83 ec 0c             	sub    $0xc,%esp
801065df:	68 46 8d 10 80       	push   $0x80108d46
801065e4:	e8 97 9d ff ff       	call   80100380 <panic>
801065e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801065f0 <sys_open>:

int
sys_open(void)
{
801065f0:	55                   	push   %ebp
801065f1:	89 e5                	mov    %esp,%ebp
801065f3:	57                   	push   %edi
801065f4:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801065f5:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801065f8:	53                   	push   %ebx
801065f9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801065fc:	50                   	push   %eax
801065fd:	6a 00                	push   $0x0
801065ff:	e8 dc f7 ff ff       	call   80105de0 <argstr>
80106604:	83 c4 10             	add    $0x10,%esp
80106607:	85 c0                	test   %eax,%eax
80106609:	0f 88 8e 00 00 00    	js     8010669d <sys_open+0xad>
8010660f:	83 ec 08             	sub    $0x8,%esp
80106612:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106615:	50                   	push   %eax
80106616:	6a 01                	push   $0x1
80106618:	e8 03 f7 ff ff       	call   80105d20 <argint>
8010661d:	83 c4 10             	add    $0x10,%esp
80106620:	85 c0                	test   %eax,%eax
80106622:	78 79                	js     8010669d <sys_open+0xad>
    return -1;

  begin_op();
80106624:	e8 37 db ff ff       	call   80104160 <begin_op>

  if(omode & O_CREATE){
80106629:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010662d:	75 79                	jne    801066a8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010662f:	83 ec 0c             	sub    $0xc,%esp
80106632:	ff 75 e0             	push   -0x20(%ebp)
80106635:	e8 66 ce ff ff       	call   801034a0 <namei>
8010663a:	83 c4 10             	add    $0x10,%esp
8010663d:	89 c6                	mov    %eax,%esi
8010663f:	85 c0                	test   %eax,%eax
80106641:	0f 84 7e 00 00 00    	je     801066c5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80106647:	83 ec 0c             	sub    $0xc,%esp
8010664a:	50                   	push   %eax
8010664b:	e8 30 c5 ff ff       	call   80102b80 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80106650:	83 c4 10             	add    $0x10,%esp
80106653:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80106658:	0f 84 c2 00 00 00    	je     80106720 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010665e:	e8 cd bb ff ff       	call   80102230 <filealloc>
80106663:	89 c7                	mov    %eax,%edi
80106665:	85 c0                	test   %eax,%eax
80106667:	74 23                	je     8010668c <sys_open+0x9c>
  struct proc *curproc = myproc();
80106669:	e8 02 e7 ff ff       	call   80104d70 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010666e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80106670:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80106674:	85 d2                	test   %edx,%edx
80106676:	74 60                	je     801066d8 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80106678:	83 c3 01             	add    $0x1,%ebx
8010667b:	83 fb 10             	cmp    $0x10,%ebx
8010667e:	75 f0                	jne    80106670 <sys_open+0x80>
    if(f)
      fileclose(f);
80106680:	83 ec 0c             	sub    $0xc,%esp
80106683:	57                   	push   %edi
80106684:	e8 67 bc ff ff       	call   801022f0 <fileclose>
80106689:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010668c:	83 ec 0c             	sub    $0xc,%esp
8010668f:	56                   	push   %esi
80106690:	e8 7b c7 ff ff       	call   80102e10 <iunlockput>
    end_op();
80106695:	e8 36 db ff ff       	call   801041d0 <end_op>
    return -1;
8010669a:	83 c4 10             	add    $0x10,%esp
8010669d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801066a2:	eb 6d                	jmp    80106711 <sys_open+0x121>
801066a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
801066a8:	83 ec 0c             	sub    $0xc,%esp
801066ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
801066ae:	31 c9                	xor    %ecx,%ecx
801066b0:	ba 02 00 00 00       	mov    $0x2,%edx
801066b5:	6a 00                	push   $0x0
801066b7:	e8 14 f8 ff ff       	call   80105ed0 <create>
    if(ip == 0){
801066bc:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
801066bf:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801066c1:	85 c0                	test   %eax,%eax
801066c3:	75 99                	jne    8010665e <sys_open+0x6e>
      end_op();
801066c5:	e8 06 db ff ff       	call   801041d0 <end_op>
      return -1;
801066ca:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801066cf:	eb 40                	jmp    80106711 <sys_open+0x121>
801066d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
801066d8:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801066db:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801066df:	56                   	push   %esi
801066e0:	e8 7b c5 ff ff       	call   80102c60 <iunlock>
  end_op();
801066e5:	e8 e6 da ff ff       	call   801041d0 <end_op>

  f->type = FD_INODE;
801066ea:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801066f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801066f3:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801066f6:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
801066f9:	89 d0                	mov    %edx,%eax
  f->off = 0;
801066fb:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80106702:	f7 d0                	not    %eax
80106704:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106707:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010670a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010670d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80106711:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106714:	89 d8                	mov    %ebx,%eax
80106716:	5b                   	pop    %ebx
80106717:	5e                   	pop    %esi
80106718:	5f                   	pop    %edi
80106719:	5d                   	pop    %ebp
8010671a:	c3                   	ret    
8010671b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010671f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80106720:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106723:	85 c9                	test   %ecx,%ecx
80106725:	0f 84 33 ff ff ff    	je     8010665e <sys_open+0x6e>
8010672b:	e9 5c ff ff ff       	jmp    8010668c <sys_open+0x9c>

80106730 <sys_mkdir>:

int
sys_mkdir(void)
{
80106730:	55                   	push   %ebp
80106731:	89 e5                	mov    %esp,%ebp
80106733:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106736:	e8 25 da ff ff       	call   80104160 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010673b:	83 ec 08             	sub    $0x8,%esp
8010673e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106741:	50                   	push   %eax
80106742:	6a 00                	push   $0x0
80106744:	e8 97 f6 ff ff       	call   80105de0 <argstr>
80106749:	83 c4 10             	add    $0x10,%esp
8010674c:	85 c0                	test   %eax,%eax
8010674e:	78 30                	js     80106780 <sys_mkdir+0x50>
80106750:	83 ec 0c             	sub    $0xc,%esp
80106753:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106756:	31 c9                	xor    %ecx,%ecx
80106758:	ba 01 00 00 00       	mov    $0x1,%edx
8010675d:	6a 00                	push   $0x0
8010675f:	e8 6c f7 ff ff       	call   80105ed0 <create>
80106764:	83 c4 10             	add    $0x10,%esp
80106767:	85 c0                	test   %eax,%eax
80106769:	74 15                	je     80106780 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010676b:	83 ec 0c             	sub    $0xc,%esp
8010676e:	50                   	push   %eax
8010676f:	e8 9c c6 ff ff       	call   80102e10 <iunlockput>
  end_op();
80106774:	e8 57 da ff ff       	call   801041d0 <end_op>
  return 0;
80106779:	83 c4 10             	add    $0x10,%esp
8010677c:	31 c0                	xor    %eax,%eax
}
8010677e:	c9                   	leave  
8010677f:	c3                   	ret    
    end_op();
80106780:	e8 4b da ff ff       	call   801041d0 <end_op>
    return -1;
80106785:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010678a:	c9                   	leave  
8010678b:	c3                   	ret    
8010678c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106790 <sys_mknod>:

int
sys_mknod(void)
{
80106790:	55                   	push   %ebp
80106791:	89 e5                	mov    %esp,%ebp
80106793:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80106796:	e8 c5 d9 ff ff       	call   80104160 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010679b:	83 ec 08             	sub    $0x8,%esp
8010679e:	8d 45 ec             	lea    -0x14(%ebp),%eax
801067a1:	50                   	push   %eax
801067a2:	6a 00                	push   $0x0
801067a4:	e8 37 f6 ff ff       	call   80105de0 <argstr>
801067a9:	83 c4 10             	add    $0x10,%esp
801067ac:	85 c0                	test   %eax,%eax
801067ae:	78 60                	js     80106810 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801067b0:	83 ec 08             	sub    $0x8,%esp
801067b3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801067b6:	50                   	push   %eax
801067b7:	6a 01                	push   $0x1
801067b9:	e8 62 f5 ff ff       	call   80105d20 <argint>
  if((argstr(0, &path)) < 0 ||
801067be:	83 c4 10             	add    $0x10,%esp
801067c1:	85 c0                	test   %eax,%eax
801067c3:	78 4b                	js     80106810 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801067c5:	83 ec 08             	sub    $0x8,%esp
801067c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801067cb:	50                   	push   %eax
801067cc:	6a 02                	push   $0x2
801067ce:	e8 4d f5 ff ff       	call   80105d20 <argint>
     argint(1, &major) < 0 ||
801067d3:	83 c4 10             	add    $0x10,%esp
801067d6:	85 c0                	test   %eax,%eax
801067d8:	78 36                	js     80106810 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801067da:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
801067de:	83 ec 0c             	sub    $0xc,%esp
801067e1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801067e5:	ba 03 00 00 00       	mov    $0x3,%edx
801067ea:	50                   	push   %eax
801067eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801067ee:	e8 dd f6 ff ff       	call   80105ed0 <create>
     argint(2, &minor) < 0 ||
801067f3:	83 c4 10             	add    $0x10,%esp
801067f6:	85 c0                	test   %eax,%eax
801067f8:	74 16                	je     80106810 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801067fa:	83 ec 0c             	sub    $0xc,%esp
801067fd:	50                   	push   %eax
801067fe:	e8 0d c6 ff ff       	call   80102e10 <iunlockput>
  end_op();
80106803:	e8 c8 d9 ff ff       	call   801041d0 <end_op>
  return 0;
80106808:	83 c4 10             	add    $0x10,%esp
8010680b:	31 c0                	xor    %eax,%eax
}
8010680d:	c9                   	leave  
8010680e:	c3                   	ret    
8010680f:	90                   	nop
    end_op();
80106810:	e8 bb d9 ff ff       	call   801041d0 <end_op>
    return -1;
80106815:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010681a:	c9                   	leave  
8010681b:	c3                   	ret    
8010681c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106820 <sys_chdir>:

int
sys_chdir(void)
{
80106820:	55                   	push   %ebp
80106821:	89 e5                	mov    %esp,%ebp
80106823:	56                   	push   %esi
80106824:	53                   	push   %ebx
80106825:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80106828:	e8 43 e5 ff ff       	call   80104d70 <myproc>
8010682d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010682f:	e8 2c d9 ff ff       	call   80104160 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80106834:	83 ec 08             	sub    $0x8,%esp
80106837:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010683a:	50                   	push   %eax
8010683b:	6a 00                	push   $0x0
8010683d:	e8 9e f5 ff ff       	call   80105de0 <argstr>
80106842:	83 c4 10             	add    $0x10,%esp
80106845:	85 c0                	test   %eax,%eax
80106847:	78 77                	js     801068c0 <sys_chdir+0xa0>
80106849:	83 ec 0c             	sub    $0xc,%esp
8010684c:	ff 75 f4             	push   -0xc(%ebp)
8010684f:	e8 4c cc ff ff       	call   801034a0 <namei>
80106854:	83 c4 10             	add    $0x10,%esp
80106857:	89 c3                	mov    %eax,%ebx
80106859:	85 c0                	test   %eax,%eax
8010685b:	74 63                	je     801068c0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010685d:	83 ec 0c             	sub    $0xc,%esp
80106860:	50                   	push   %eax
80106861:	e8 1a c3 ff ff       	call   80102b80 <ilock>
  if(ip->type != T_DIR){
80106866:	83 c4 10             	add    $0x10,%esp
80106869:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010686e:	75 30                	jne    801068a0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80106870:	83 ec 0c             	sub    $0xc,%esp
80106873:	53                   	push   %ebx
80106874:	e8 e7 c3 ff ff       	call   80102c60 <iunlock>
  iput(curproc->cwd);
80106879:	58                   	pop    %eax
8010687a:	ff 76 68             	push   0x68(%esi)
8010687d:	e8 2e c4 ff ff       	call   80102cb0 <iput>
  end_op();
80106882:	e8 49 d9 ff ff       	call   801041d0 <end_op>
  curproc->cwd = ip;
80106887:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010688a:	83 c4 10             	add    $0x10,%esp
8010688d:	31 c0                	xor    %eax,%eax
}
8010688f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106892:	5b                   	pop    %ebx
80106893:	5e                   	pop    %esi
80106894:	5d                   	pop    %ebp
80106895:	c3                   	ret    
80106896:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010689d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
801068a0:	83 ec 0c             	sub    $0xc,%esp
801068a3:	53                   	push   %ebx
801068a4:	e8 67 c5 ff ff       	call   80102e10 <iunlockput>
    end_op();
801068a9:	e8 22 d9 ff ff       	call   801041d0 <end_op>
    return -1;
801068ae:	83 c4 10             	add    $0x10,%esp
801068b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068b6:	eb d7                	jmp    8010688f <sys_chdir+0x6f>
801068b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801068bf:	90                   	nop
    end_op();
801068c0:	e8 0b d9 ff ff       	call   801041d0 <end_op>
    return -1;
801068c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068ca:	eb c3                	jmp    8010688f <sys_chdir+0x6f>
801068cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801068d0 <sys_exec>:

int
sys_exec(void)
{
801068d0:	55                   	push   %ebp
801068d1:	89 e5                	mov    %esp,%ebp
801068d3:	57                   	push   %edi
801068d4:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801068d5:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801068db:	53                   	push   %ebx
801068dc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801068e2:	50                   	push   %eax
801068e3:	6a 00                	push   $0x0
801068e5:	e8 f6 f4 ff ff       	call   80105de0 <argstr>
801068ea:	83 c4 10             	add    $0x10,%esp
801068ed:	85 c0                	test   %eax,%eax
801068ef:	0f 88 87 00 00 00    	js     8010697c <sys_exec+0xac>
801068f5:	83 ec 08             	sub    $0x8,%esp
801068f8:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801068fe:	50                   	push   %eax
801068ff:	6a 01                	push   $0x1
80106901:	e8 1a f4 ff ff       	call   80105d20 <argint>
80106906:	83 c4 10             	add    $0x10,%esp
80106909:	85 c0                	test   %eax,%eax
8010690b:	78 6f                	js     8010697c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010690d:	83 ec 04             	sub    $0x4,%esp
80106910:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80106916:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80106918:	68 80 00 00 00       	push   $0x80
8010691d:	6a 00                	push   $0x0
8010691f:	56                   	push   %esi
80106920:	e8 3b f1 ff ff       	call   80105a60 <memset>
80106925:	83 c4 10             	add    $0x10,%esp
80106928:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010692f:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106930:	83 ec 08             	sub    $0x8,%esp
80106933:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80106939:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80106940:	50                   	push   %eax
80106941:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80106947:	01 f8                	add    %edi,%eax
80106949:	50                   	push   %eax
8010694a:	e8 41 f3 ff ff       	call   80105c90 <fetchint>
8010694f:	83 c4 10             	add    $0x10,%esp
80106952:	85 c0                	test   %eax,%eax
80106954:	78 26                	js     8010697c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80106956:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010695c:	85 c0                	test   %eax,%eax
8010695e:	74 30                	je     80106990 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80106960:	83 ec 08             	sub    $0x8,%esp
80106963:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80106966:	52                   	push   %edx
80106967:	50                   	push   %eax
80106968:	e8 63 f3 ff ff       	call   80105cd0 <fetchstr>
8010696d:	83 c4 10             	add    $0x10,%esp
80106970:	85 c0                	test   %eax,%eax
80106972:	78 08                	js     8010697c <sys_exec+0xac>
  for(i=0;; i++){
80106974:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80106977:	83 fb 20             	cmp    $0x20,%ebx
8010697a:	75 b4                	jne    80106930 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010697c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010697f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106984:	5b                   	pop    %ebx
80106985:	5e                   	pop    %esi
80106986:	5f                   	pop    %edi
80106987:	5d                   	pop    %ebp
80106988:	c3                   	ret    
80106989:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80106990:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80106997:	00 00 00 00 
  return exec(path, argv);
8010699b:	83 ec 08             	sub    $0x8,%esp
8010699e:	56                   	push   %esi
8010699f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
801069a5:	e8 06 b5 ff ff       	call   80101eb0 <exec>
801069aa:	83 c4 10             	add    $0x10,%esp
}
801069ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801069b0:	5b                   	pop    %ebx
801069b1:	5e                   	pop    %esi
801069b2:	5f                   	pop    %edi
801069b3:	5d                   	pop    %ebp
801069b4:	c3                   	ret    
801069b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801069bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801069c0 <sys_pipe>:

int
sys_pipe(void)
{
801069c0:	55                   	push   %ebp
801069c1:	89 e5                	mov    %esp,%ebp
801069c3:	57                   	push   %edi
801069c4:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801069c5:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801069c8:	53                   	push   %ebx
801069c9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801069cc:	6a 08                	push   $0x8
801069ce:	50                   	push   %eax
801069cf:	6a 00                	push   $0x0
801069d1:	e8 9a f3 ff ff       	call   80105d70 <argptr>
801069d6:	83 c4 10             	add    $0x10,%esp
801069d9:	85 c0                	test   %eax,%eax
801069db:	78 4a                	js     80106a27 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801069dd:	83 ec 08             	sub    $0x8,%esp
801069e0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801069e3:	50                   	push   %eax
801069e4:	8d 45 e0             	lea    -0x20(%ebp),%eax
801069e7:	50                   	push   %eax
801069e8:	e8 43 de ff ff       	call   80104830 <pipealloc>
801069ed:	83 c4 10             	add    $0x10,%esp
801069f0:	85 c0                	test   %eax,%eax
801069f2:	78 33                	js     80106a27 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801069f4:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801069f7:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801069f9:	e8 72 e3 ff ff       	call   80104d70 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801069fe:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80106a00:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80106a04:	85 f6                	test   %esi,%esi
80106a06:	74 28                	je     80106a30 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80106a08:	83 c3 01             	add    $0x1,%ebx
80106a0b:	83 fb 10             	cmp    $0x10,%ebx
80106a0e:	75 f0                	jne    80106a00 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80106a10:	83 ec 0c             	sub    $0xc,%esp
80106a13:	ff 75 e0             	push   -0x20(%ebp)
80106a16:	e8 d5 b8 ff ff       	call   801022f0 <fileclose>
    fileclose(wf);
80106a1b:	58                   	pop    %eax
80106a1c:	ff 75 e4             	push   -0x1c(%ebp)
80106a1f:	e8 cc b8 ff ff       	call   801022f0 <fileclose>
    return -1;
80106a24:	83 c4 10             	add    $0x10,%esp
80106a27:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a2c:	eb 53                	jmp    80106a81 <sys_pipe+0xc1>
80106a2e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80106a30:	8d 73 08             	lea    0x8(%ebx),%esi
80106a33:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106a37:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80106a3a:	e8 31 e3 ff ff       	call   80104d70 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80106a3f:	31 d2                	xor    %edx,%edx
80106a41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80106a48:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80106a4c:	85 c9                	test   %ecx,%ecx
80106a4e:	74 20                	je     80106a70 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80106a50:	83 c2 01             	add    $0x1,%edx
80106a53:	83 fa 10             	cmp    $0x10,%edx
80106a56:	75 f0                	jne    80106a48 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80106a58:	e8 13 e3 ff ff       	call   80104d70 <myproc>
80106a5d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80106a64:	00 
80106a65:	eb a9                	jmp    80106a10 <sys_pipe+0x50>
80106a67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a6e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80106a70:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80106a74:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106a77:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80106a79:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106a7c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80106a7f:	31 c0                	xor    %eax,%eax
}
80106a81:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a84:	5b                   	pop    %ebx
80106a85:	5e                   	pop    %esi
80106a86:	5f                   	pop    %edi
80106a87:	5d                   	pop    %ebp
80106a88:	c3                   	ret    
80106a89:	66 90                	xchg   %ax,%ax
80106a8b:	66 90                	xchg   %ax,%ax
80106a8d:	66 90                	xchg   %ax,%ax
80106a8f:	90                   	nop

80106a90 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80106a90:	e9 7b e4 ff ff       	jmp    80104f10 <fork>
80106a95:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106aa0 <sys_exit>:
}

int
sys_exit(void)
{
80106aa0:	55                   	push   %ebp
80106aa1:	89 e5                	mov    %esp,%ebp
80106aa3:	83 ec 08             	sub    $0x8,%esp
  exit();
80106aa6:	e8 e5 e6 ff ff       	call   80105190 <exit>
  return 0;  // not reached
}
80106aab:	31 c0                	xor    %eax,%eax
80106aad:	c9                   	leave  
80106aae:	c3                   	ret    
80106aaf:	90                   	nop

80106ab0 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80106ab0:	e9 0b e8 ff ff       	jmp    801052c0 <wait>
80106ab5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106abc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106ac0 <sys_kill>:
}

int
sys_kill(void)
{
80106ac0:	55                   	push   %ebp
80106ac1:	89 e5                	mov    %esp,%ebp
80106ac3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106ac6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106ac9:	50                   	push   %eax
80106aca:	6a 00                	push   $0x0
80106acc:	e8 4f f2 ff ff       	call   80105d20 <argint>
80106ad1:	83 c4 10             	add    $0x10,%esp
80106ad4:	85 c0                	test   %eax,%eax
80106ad6:	78 18                	js     80106af0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80106ad8:	83 ec 0c             	sub    $0xc,%esp
80106adb:	ff 75 f4             	push   -0xc(%ebp)
80106ade:	e8 7d ea ff ff       	call   80105560 <kill>
80106ae3:	83 c4 10             	add    $0x10,%esp
}
80106ae6:	c9                   	leave  
80106ae7:	c3                   	ret    
80106ae8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106aef:	90                   	nop
80106af0:	c9                   	leave  
    return -1;
80106af1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106af6:	c3                   	ret    
80106af7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106afe:	66 90                	xchg   %ax,%ax

80106b00 <sys_getpid>:

int
sys_getpid(void)
{
80106b00:	55                   	push   %ebp
80106b01:	89 e5                	mov    %esp,%ebp
80106b03:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80106b06:	e8 65 e2 ff ff       	call   80104d70 <myproc>
80106b0b:	8b 40 10             	mov    0x10(%eax),%eax
}
80106b0e:	c9                   	leave  
80106b0f:	c3                   	ret    

80106b10 <sys_sbrk>:

int
sys_sbrk(void)
{
80106b10:	55                   	push   %ebp
80106b11:	89 e5                	mov    %esp,%ebp
80106b13:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106b14:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106b17:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80106b1a:	50                   	push   %eax
80106b1b:	6a 00                	push   $0x0
80106b1d:	e8 fe f1 ff ff       	call   80105d20 <argint>
80106b22:	83 c4 10             	add    $0x10,%esp
80106b25:	85 c0                	test   %eax,%eax
80106b27:	78 27                	js     80106b50 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80106b29:	e8 42 e2 ff ff       	call   80104d70 <myproc>
  if(growproc(n) < 0)
80106b2e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106b31:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106b33:	ff 75 f4             	push   -0xc(%ebp)
80106b36:	e8 55 e3 ff ff       	call   80104e90 <growproc>
80106b3b:	83 c4 10             	add    $0x10,%esp
80106b3e:	85 c0                	test   %eax,%eax
80106b40:	78 0e                	js     80106b50 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80106b42:	89 d8                	mov    %ebx,%eax
80106b44:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106b47:	c9                   	leave  
80106b48:	c3                   	ret    
80106b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106b50:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106b55:	eb eb                	jmp    80106b42 <sys_sbrk+0x32>
80106b57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b5e:	66 90                	xchg   %ax,%ax

80106b60 <sys_sleep>:

int
sys_sleep(void)
{
80106b60:	55                   	push   %ebp
80106b61:	89 e5                	mov    %esp,%ebp
80106b63:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106b64:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106b67:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80106b6a:	50                   	push   %eax
80106b6b:	6a 00                	push   $0x0
80106b6d:	e8 ae f1 ff ff       	call   80105d20 <argint>
80106b72:	83 c4 10             	add    $0x10,%esp
80106b75:	85 c0                	test   %eax,%eax
80106b77:	0f 88 8a 00 00 00    	js     80106c07 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80106b7d:	83 ec 0c             	sub    $0xc,%esp
80106b80:	68 00 54 11 80       	push   $0x80115400
80106b85:	e8 16 ee ff ff       	call   801059a0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80106b8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80106b8d:	8b 1d e0 53 11 80    	mov    0x801153e0,%ebx
  while(ticks - ticks0 < n){
80106b93:	83 c4 10             	add    $0x10,%esp
80106b96:	85 d2                	test   %edx,%edx
80106b98:	75 27                	jne    80106bc1 <sys_sleep+0x61>
80106b9a:	eb 54                	jmp    80106bf0 <sys_sleep+0x90>
80106b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106ba0:	83 ec 08             	sub    $0x8,%esp
80106ba3:	68 00 54 11 80       	push   $0x80115400
80106ba8:	68 e0 53 11 80       	push   $0x801153e0
80106bad:	e8 8e e8 ff ff       	call   80105440 <sleep>
  while(ticks - ticks0 < n){
80106bb2:	a1 e0 53 11 80       	mov    0x801153e0,%eax
80106bb7:	83 c4 10             	add    $0x10,%esp
80106bba:	29 d8                	sub    %ebx,%eax
80106bbc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80106bbf:	73 2f                	jae    80106bf0 <sys_sleep+0x90>
    if(myproc()->killed){
80106bc1:	e8 aa e1 ff ff       	call   80104d70 <myproc>
80106bc6:	8b 40 24             	mov    0x24(%eax),%eax
80106bc9:	85 c0                	test   %eax,%eax
80106bcb:	74 d3                	je     80106ba0 <sys_sleep+0x40>
      release(&tickslock);
80106bcd:	83 ec 0c             	sub    $0xc,%esp
80106bd0:	68 00 54 11 80       	push   $0x80115400
80106bd5:	e8 66 ed ff ff       	call   80105940 <release>
  }
  release(&tickslock);
  return 0;
}
80106bda:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80106bdd:	83 c4 10             	add    $0x10,%esp
80106be0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106be5:	c9                   	leave  
80106be6:	c3                   	ret    
80106be7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106bee:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80106bf0:	83 ec 0c             	sub    $0xc,%esp
80106bf3:	68 00 54 11 80       	push   $0x80115400
80106bf8:	e8 43 ed ff ff       	call   80105940 <release>
  return 0;
80106bfd:	83 c4 10             	add    $0x10,%esp
80106c00:	31 c0                	xor    %eax,%eax
}
80106c02:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106c05:	c9                   	leave  
80106c06:	c3                   	ret    
    return -1;
80106c07:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c0c:	eb f4                	jmp    80106c02 <sys_sleep+0xa2>
80106c0e:	66 90                	xchg   %ax,%ax

80106c10 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106c10:	55                   	push   %ebp
80106c11:	89 e5                	mov    %esp,%ebp
80106c13:	53                   	push   %ebx
80106c14:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80106c17:	68 00 54 11 80       	push   $0x80115400
80106c1c:	e8 7f ed ff ff       	call   801059a0 <acquire>
  xticks = ticks;
80106c21:	8b 1d e0 53 11 80    	mov    0x801153e0,%ebx
  release(&tickslock);
80106c27:	c7 04 24 00 54 11 80 	movl   $0x80115400,(%esp)
80106c2e:	e8 0d ed ff ff       	call   80105940 <release>
  return xticks;
}
80106c33:	89 d8                	mov    %ebx,%eax
80106c35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106c38:	c9                   	leave  
80106c39:	c3                   	ret    

80106c3a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106c3a:	1e                   	push   %ds
  pushl %es
80106c3b:	06                   	push   %es
  pushl %fs
80106c3c:	0f a0                	push   %fs
  pushl %gs
80106c3e:	0f a8                	push   %gs
  pushal
80106c40:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106c41:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106c45:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106c47:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106c49:	54                   	push   %esp
  call trap
80106c4a:	e8 c1 00 00 00       	call   80106d10 <trap>
  addl $4, %esp
80106c4f:	83 c4 04             	add    $0x4,%esp

80106c52 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106c52:	61                   	popa   
  popl %gs
80106c53:	0f a9                	pop    %gs
  popl %fs
80106c55:	0f a1                	pop    %fs
  popl %es
80106c57:	07                   	pop    %es
  popl %ds
80106c58:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106c59:	83 c4 08             	add    $0x8,%esp
  iret
80106c5c:	cf                   	iret   
80106c5d:	66 90                	xchg   %ax,%ax
80106c5f:	90                   	nop

80106c60 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106c60:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106c61:	31 c0                	xor    %eax,%eax
{
80106c63:	89 e5                	mov    %esp,%ebp
80106c65:	83 ec 08             	sub    $0x8,%esp
80106c68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c6f:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106c70:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80106c77:	c7 04 c5 42 54 11 80 	movl   $0x8e000008,-0x7feeabbe(,%eax,8)
80106c7e:	08 00 00 8e 
80106c82:	66 89 14 c5 40 54 11 	mov    %dx,-0x7feeabc0(,%eax,8)
80106c89:	80 
80106c8a:	c1 ea 10             	shr    $0x10,%edx
80106c8d:	66 89 14 c5 46 54 11 	mov    %dx,-0x7feeabba(,%eax,8)
80106c94:	80 
  for(i = 0; i < 256; i++)
80106c95:	83 c0 01             	add    $0x1,%eax
80106c98:	3d 00 01 00 00       	cmp    $0x100,%eax
80106c9d:	75 d1                	jne    80106c70 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80106c9f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106ca2:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80106ca7:	c7 05 42 56 11 80 08 	movl   $0xef000008,0x80115642
80106cae:	00 00 ef 
  initlock(&tickslock, "time");
80106cb1:	68 79 8d 10 80       	push   $0x80108d79
80106cb6:	68 00 54 11 80       	push   $0x80115400
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106cbb:	66 a3 40 56 11 80    	mov    %ax,0x80115640
80106cc1:	c1 e8 10             	shr    $0x10,%eax
80106cc4:	66 a3 46 56 11 80    	mov    %ax,0x80115646
  initlock(&tickslock, "time");
80106cca:	e8 01 eb ff ff       	call   801057d0 <initlock>
}
80106ccf:	83 c4 10             	add    $0x10,%esp
80106cd2:	c9                   	leave  
80106cd3:	c3                   	ret    
80106cd4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106cdb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106cdf:	90                   	nop

80106ce0 <idtinit>:

void
idtinit(void)
{
80106ce0:	55                   	push   %ebp
  pd[0] = size-1;
80106ce1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106ce6:	89 e5                	mov    %esp,%ebp
80106ce8:	83 ec 10             	sub    $0x10,%esp
80106ceb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106cef:	b8 40 54 11 80       	mov    $0x80115440,%eax
80106cf4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106cf8:	c1 e8 10             	shr    $0x10,%eax
80106cfb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106cff:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106d02:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106d05:	c9                   	leave  
80106d06:	c3                   	ret    
80106d07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d0e:	66 90                	xchg   %ax,%ax

80106d10 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106d10:	55                   	push   %ebp
80106d11:	89 e5                	mov    %esp,%ebp
80106d13:	57                   	push   %edi
80106d14:	56                   	push   %esi
80106d15:	53                   	push   %ebx
80106d16:	83 ec 1c             	sub    $0x1c,%esp
80106d19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80106d1c:	8b 43 30             	mov    0x30(%ebx),%eax
80106d1f:	83 f8 40             	cmp    $0x40,%eax
80106d22:	0f 84 68 01 00 00    	je     80106e90 <trap+0x180>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80106d28:	83 e8 20             	sub    $0x20,%eax
80106d2b:	83 f8 1f             	cmp    $0x1f,%eax
80106d2e:	0f 87 8c 00 00 00    	ja     80106dc0 <trap+0xb0>
80106d34:	ff 24 85 20 8e 10 80 	jmp    *-0x7fef71e0(,%eax,4)
80106d3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106d3f:	90                   	nop
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106d40:	e8 fb c8 ff ff       	call   80103640 <ideintr>
    lapiceoi();
80106d45:	e8 c6 cf ff ff       	call   80103d10 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106d4a:	e8 21 e0 ff ff       	call   80104d70 <myproc>
80106d4f:	85 c0                	test   %eax,%eax
80106d51:	74 1d                	je     80106d70 <trap+0x60>
80106d53:	e8 18 e0 ff ff       	call   80104d70 <myproc>
80106d58:	8b 50 24             	mov    0x24(%eax),%edx
80106d5b:	85 d2                	test   %edx,%edx
80106d5d:	74 11                	je     80106d70 <trap+0x60>
80106d5f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106d63:	83 e0 03             	and    $0x3,%eax
80106d66:	66 83 f8 03          	cmp    $0x3,%ax
80106d6a:	0f 84 e8 01 00 00    	je     80106f58 <trap+0x248>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106d70:	e8 fb df ff ff       	call   80104d70 <myproc>
80106d75:	85 c0                	test   %eax,%eax
80106d77:	74 0f                	je     80106d88 <trap+0x78>
80106d79:	e8 f2 df ff ff       	call   80104d70 <myproc>
80106d7e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106d82:	0f 84 b8 00 00 00    	je     80106e40 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106d88:	e8 e3 df ff ff       	call   80104d70 <myproc>
80106d8d:	85 c0                	test   %eax,%eax
80106d8f:	74 1d                	je     80106dae <trap+0x9e>
80106d91:	e8 da df ff ff       	call   80104d70 <myproc>
80106d96:	8b 40 24             	mov    0x24(%eax),%eax
80106d99:	85 c0                	test   %eax,%eax
80106d9b:	74 11                	je     80106dae <trap+0x9e>
80106d9d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106da1:	83 e0 03             	and    $0x3,%eax
80106da4:	66 83 f8 03          	cmp    $0x3,%ax
80106da8:	0f 84 0f 01 00 00    	je     80106ebd <trap+0x1ad>
    exit();
}
80106dae:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106db1:	5b                   	pop    %ebx
80106db2:	5e                   	pop    %esi
80106db3:	5f                   	pop    %edi
80106db4:	5d                   	pop    %ebp
80106db5:	c3                   	ret    
80106db6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106dbd:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
80106dc0:	e8 ab df ff ff       	call   80104d70 <myproc>
80106dc5:	8b 7b 38             	mov    0x38(%ebx),%edi
80106dc8:	85 c0                	test   %eax,%eax
80106dca:	0f 84 a2 01 00 00    	je     80106f72 <trap+0x262>
80106dd0:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80106dd4:	0f 84 98 01 00 00    	je     80106f72 <trap+0x262>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106dda:	0f 20 d1             	mov    %cr2,%ecx
80106ddd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106de0:	e8 6b df ff ff       	call   80104d50 <cpuid>
80106de5:	8b 73 30             	mov    0x30(%ebx),%esi
80106de8:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106deb:	8b 43 34             	mov    0x34(%ebx),%eax
80106dee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80106df1:	e8 7a df ff ff       	call   80104d70 <myproc>
80106df6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106df9:	e8 72 df ff ff       	call   80104d70 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106dfe:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106e01:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106e04:	51                   	push   %ecx
80106e05:	57                   	push   %edi
80106e06:	52                   	push   %edx
80106e07:	ff 75 e4             	push   -0x1c(%ebp)
80106e0a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80106e0b:	8b 75 e0             	mov    -0x20(%ebp),%esi
80106e0e:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106e11:	56                   	push   %esi
80106e12:	ff 70 10             	push   0x10(%eax)
80106e15:	68 dc 8d 10 80       	push   $0x80108ddc
80106e1a:	e8 e1 98 ff ff       	call   80100700 <cprintf>
    myproc()->killed = 1;
80106e1f:	83 c4 20             	add    $0x20,%esp
80106e22:	e8 49 df ff ff       	call   80104d70 <myproc>
80106e27:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106e2e:	e8 3d df ff ff       	call   80104d70 <myproc>
80106e33:	85 c0                	test   %eax,%eax
80106e35:	0f 85 18 ff ff ff    	jne    80106d53 <trap+0x43>
80106e3b:	e9 30 ff ff ff       	jmp    80106d70 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
80106e40:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80106e44:	0f 85 3e ff ff ff    	jne    80106d88 <trap+0x78>
    yield();
80106e4a:	e8 a1 e5 ff ff       	call   801053f0 <yield>
80106e4f:	e9 34 ff ff ff       	jmp    80106d88 <trap+0x78>
80106e54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106e58:	8b 7b 38             	mov    0x38(%ebx),%edi
80106e5b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80106e5f:	e8 ec de ff ff       	call   80104d50 <cpuid>
80106e64:	57                   	push   %edi
80106e65:	56                   	push   %esi
80106e66:	50                   	push   %eax
80106e67:	68 84 8d 10 80       	push   $0x80108d84
80106e6c:	e8 8f 98 ff ff       	call   80100700 <cprintf>
    lapiceoi();
80106e71:	e8 9a ce ff ff       	call   80103d10 <lapiceoi>
    break;
80106e76:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106e79:	e8 f2 de ff ff       	call   80104d70 <myproc>
80106e7e:	85 c0                	test   %eax,%eax
80106e80:	0f 85 cd fe ff ff    	jne    80106d53 <trap+0x43>
80106e86:	e9 e5 fe ff ff       	jmp    80106d70 <trap+0x60>
80106e8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106e8f:	90                   	nop
    if(myproc()->killed)
80106e90:	e8 db de ff ff       	call   80104d70 <myproc>
80106e95:	8b 70 24             	mov    0x24(%eax),%esi
80106e98:	85 f6                	test   %esi,%esi
80106e9a:	0f 85 c8 00 00 00    	jne    80106f68 <trap+0x258>
    myproc()->tf = tf;
80106ea0:	e8 cb de ff ff       	call   80104d70 <myproc>
80106ea5:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80106ea8:	e8 b3 ef ff ff       	call   80105e60 <syscall>
    if(myproc()->killed)
80106ead:	e8 be de ff ff       	call   80104d70 <myproc>
80106eb2:	8b 48 24             	mov    0x24(%eax),%ecx
80106eb5:	85 c9                	test   %ecx,%ecx
80106eb7:	0f 84 f1 fe ff ff    	je     80106dae <trap+0x9e>
}
80106ebd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ec0:	5b                   	pop    %ebx
80106ec1:	5e                   	pop    %esi
80106ec2:	5f                   	pop    %edi
80106ec3:	5d                   	pop    %ebp
      exit();
80106ec4:	e9 c7 e2 ff ff       	jmp    80105190 <exit>
80106ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80106ed0:	e8 3b 02 00 00       	call   80107110 <uartintr>
    lapiceoi();
80106ed5:	e8 36 ce ff ff       	call   80103d10 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106eda:	e8 91 de ff ff       	call   80104d70 <myproc>
80106edf:	85 c0                	test   %eax,%eax
80106ee1:	0f 85 6c fe ff ff    	jne    80106d53 <trap+0x43>
80106ee7:	e9 84 fe ff ff       	jmp    80106d70 <trap+0x60>
80106eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106ef0:	e8 db cc ff ff       	call   80103bd0 <kbdintr>
    lapiceoi();
80106ef5:	e8 16 ce ff ff       	call   80103d10 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106efa:	e8 71 de ff ff       	call   80104d70 <myproc>
80106eff:	85 c0                	test   %eax,%eax
80106f01:	0f 85 4c fe ff ff    	jne    80106d53 <trap+0x43>
80106f07:	e9 64 fe ff ff       	jmp    80106d70 <trap+0x60>
80106f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80106f10:	e8 3b de ff ff       	call   80104d50 <cpuid>
80106f15:	85 c0                	test   %eax,%eax
80106f17:	0f 85 28 fe ff ff    	jne    80106d45 <trap+0x35>
      acquire(&tickslock);
80106f1d:	83 ec 0c             	sub    $0xc,%esp
80106f20:	68 00 54 11 80       	push   $0x80115400
80106f25:	e8 76 ea ff ff       	call   801059a0 <acquire>
      wakeup(&ticks);
80106f2a:	c7 04 24 e0 53 11 80 	movl   $0x801153e0,(%esp)
      ticks++;
80106f31:	83 05 e0 53 11 80 01 	addl   $0x1,0x801153e0
      wakeup(&ticks);
80106f38:	e8 c3 e5 ff ff       	call   80105500 <wakeup>
      release(&tickslock);
80106f3d:	c7 04 24 00 54 11 80 	movl   $0x80115400,(%esp)
80106f44:	e8 f7 e9 ff ff       	call   80105940 <release>
80106f49:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80106f4c:	e9 f4 fd ff ff       	jmp    80106d45 <trap+0x35>
80106f51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80106f58:	e8 33 e2 ff ff       	call   80105190 <exit>
80106f5d:	e9 0e fe ff ff       	jmp    80106d70 <trap+0x60>
80106f62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106f68:	e8 23 e2 ff ff       	call   80105190 <exit>
80106f6d:	e9 2e ff ff ff       	jmp    80106ea0 <trap+0x190>
80106f72:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106f75:	e8 d6 dd ff ff       	call   80104d50 <cpuid>
80106f7a:	83 ec 0c             	sub    $0xc,%esp
80106f7d:	56                   	push   %esi
80106f7e:	57                   	push   %edi
80106f7f:	50                   	push   %eax
80106f80:	ff 73 30             	push   0x30(%ebx)
80106f83:	68 a8 8d 10 80       	push   $0x80108da8
80106f88:	e8 73 97 ff ff       	call   80100700 <cprintf>
      panic("trap");
80106f8d:	83 c4 14             	add    $0x14,%esp
80106f90:	68 7e 8d 10 80       	push   $0x80108d7e
80106f95:	e8 e6 93 ff ff       	call   80100380 <panic>
80106f9a:	66 90                	xchg   %ax,%ax
80106f9c:	66 90                	xchg   %ax,%ax
80106f9e:	66 90                	xchg   %ax,%ax

80106fa0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106fa0:	a1 40 5c 11 80       	mov    0x80115c40,%eax
80106fa5:	85 c0                	test   %eax,%eax
80106fa7:	74 17                	je     80106fc0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106fa9:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106fae:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106faf:	a8 01                	test   $0x1,%al
80106fb1:	74 0d                	je     80106fc0 <uartgetc+0x20>
80106fb3:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106fb8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106fb9:	0f b6 c0             	movzbl %al,%eax
80106fbc:	c3                   	ret    
80106fbd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106fc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106fc5:	c3                   	ret    
80106fc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fcd:	8d 76 00             	lea    0x0(%esi),%esi

80106fd0 <uartinit>:
{
80106fd0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106fd1:	31 c9                	xor    %ecx,%ecx
80106fd3:	89 c8                	mov    %ecx,%eax
80106fd5:	89 e5                	mov    %esp,%ebp
80106fd7:	57                   	push   %edi
80106fd8:	bf fa 03 00 00       	mov    $0x3fa,%edi
80106fdd:	56                   	push   %esi
80106fde:	89 fa                	mov    %edi,%edx
80106fe0:	53                   	push   %ebx
80106fe1:	83 ec 1c             	sub    $0x1c,%esp
80106fe4:	ee                   	out    %al,(%dx)
80106fe5:	be fb 03 00 00       	mov    $0x3fb,%esi
80106fea:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80106fef:	89 f2                	mov    %esi,%edx
80106ff1:	ee                   	out    %al,(%dx)
80106ff2:	b8 0c 00 00 00       	mov    $0xc,%eax
80106ff7:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106ffc:	ee                   	out    %al,(%dx)
80106ffd:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80107002:	89 c8                	mov    %ecx,%eax
80107004:	89 da                	mov    %ebx,%edx
80107006:	ee                   	out    %al,(%dx)
80107007:	b8 03 00 00 00       	mov    $0x3,%eax
8010700c:	89 f2                	mov    %esi,%edx
8010700e:	ee                   	out    %al,(%dx)
8010700f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80107014:	89 c8                	mov    %ecx,%eax
80107016:	ee                   	out    %al,(%dx)
80107017:	b8 01 00 00 00       	mov    $0x1,%eax
8010701c:	89 da                	mov    %ebx,%edx
8010701e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010701f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80107024:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80107025:	3c ff                	cmp    $0xff,%al
80107027:	74 78                	je     801070a1 <uartinit+0xd1>
  uart = 1;
80107029:	c7 05 40 5c 11 80 01 	movl   $0x1,0x80115c40
80107030:	00 00 00 
80107033:	89 fa                	mov    %edi,%edx
80107035:	ec                   	in     (%dx),%al
80107036:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010703b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010703c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010703f:	bf a0 8e 10 80       	mov    $0x80108ea0,%edi
80107044:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80107049:	6a 00                	push   $0x0
8010704b:	6a 04                	push   $0x4
8010704d:	e8 2e c8 ff ff       	call   80103880 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80107052:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80107056:	83 c4 10             	add    $0x10,%esp
80107059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80107060:	a1 40 5c 11 80       	mov    0x80115c40,%eax
80107065:	bb 80 00 00 00       	mov    $0x80,%ebx
8010706a:	85 c0                	test   %eax,%eax
8010706c:	75 14                	jne    80107082 <uartinit+0xb2>
8010706e:	eb 23                	jmp    80107093 <uartinit+0xc3>
    microdelay(10);
80107070:	83 ec 0c             	sub    $0xc,%esp
80107073:	6a 0a                	push   $0xa
80107075:	e8 b6 cc ff ff       	call   80103d30 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010707a:	83 c4 10             	add    $0x10,%esp
8010707d:	83 eb 01             	sub    $0x1,%ebx
80107080:	74 07                	je     80107089 <uartinit+0xb9>
80107082:	89 f2                	mov    %esi,%edx
80107084:	ec                   	in     (%dx),%al
80107085:	a8 20                	test   $0x20,%al
80107087:	74 e7                	je     80107070 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107089:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
8010708d:	ba f8 03 00 00       	mov    $0x3f8,%edx
80107092:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80107093:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80107097:	83 c7 01             	add    $0x1,%edi
8010709a:	88 45 e7             	mov    %al,-0x19(%ebp)
8010709d:	84 c0                	test   %al,%al
8010709f:	75 bf                	jne    80107060 <uartinit+0x90>
}
801070a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070a4:	5b                   	pop    %ebx
801070a5:	5e                   	pop    %esi
801070a6:	5f                   	pop    %edi
801070a7:	5d                   	pop    %ebp
801070a8:	c3                   	ret    
801070a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801070b0 <uartputc>:
  if(!uart)
801070b0:	a1 40 5c 11 80       	mov    0x80115c40,%eax
801070b5:	85 c0                	test   %eax,%eax
801070b7:	74 47                	je     80107100 <uartputc+0x50>
{
801070b9:	55                   	push   %ebp
801070ba:	89 e5                	mov    %esp,%ebp
801070bc:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801070bd:	be fd 03 00 00       	mov    $0x3fd,%esi
801070c2:	53                   	push   %ebx
801070c3:	bb 80 00 00 00       	mov    $0x80,%ebx
801070c8:	eb 18                	jmp    801070e2 <uartputc+0x32>
801070ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
801070d0:	83 ec 0c             	sub    $0xc,%esp
801070d3:	6a 0a                	push   $0xa
801070d5:	e8 56 cc ff ff       	call   80103d30 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801070da:	83 c4 10             	add    $0x10,%esp
801070dd:	83 eb 01             	sub    $0x1,%ebx
801070e0:	74 07                	je     801070e9 <uartputc+0x39>
801070e2:	89 f2                	mov    %esi,%edx
801070e4:	ec                   	in     (%dx),%al
801070e5:	a8 20                	test   $0x20,%al
801070e7:	74 e7                	je     801070d0 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801070e9:	8b 45 08             	mov    0x8(%ebp),%eax
801070ec:	ba f8 03 00 00       	mov    $0x3f8,%edx
801070f1:	ee                   	out    %al,(%dx)
}
801070f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801070f5:	5b                   	pop    %ebx
801070f6:	5e                   	pop    %esi
801070f7:	5d                   	pop    %ebp
801070f8:	c3                   	ret    
801070f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107100:	c3                   	ret    
80107101:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107108:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010710f:	90                   	nop

80107110 <uartintr>:

void
uartintr(void)
{
80107110:	55                   	push   %ebp
80107111:	89 e5                	mov    %esp,%ebp
80107113:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80107116:	68 a0 6f 10 80       	push   $0x80106fa0
8010711b:	e8 20 a4 ff ff       	call   80101540 <consoleintr>
}
80107120:	83 c4 10             	add    $0x10,%esp
80107123:	c9                   	leave  
80107124:	c3                   	ret    

80107125 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80107125:	6a 00                	push   $0x0
  pushl $0
80107127:	6a 00                	push   $0x0
  jmp alltraps
80107129:	e9 0c fb ff ff       	jmp    80106c3a <alltraps>

8010712e <vector1>:
.globl vector1
vector1:
  pushl $0
8010712e:	6a 00                	push   $0x0
  pushl $1
80107130:	6a 01                	push   $0x1
  jmp alltraps
80107132:	e9 03 fb ff ff       	jmp    80106c3a <alltraps>

80107137 <vector2>:
.globl vector2
vector2:
  pushl $0
80107137:	6a 00                	push   $0x0
  pushl $2
80107139:	6a 02                	push   $0x2
  jmp alltraps
8010713b:	e9 fa fa ff ff       	jmp    80106c3a <alltraps>

80107140 <vector3>:
.globl vector3
vector3:
  pushl $0
80107140:	6a 00                	push   $0x0
  pushl $3
80107142:	6a 03                	push   $0x3
  jmp alltraps
80107144:	e9 f1 fa ff ff       	jmp    80106c3a <alltraps>

80107149 <vector4>:
.globl vector4
vector4:
  pushl $0
80107149:	6a 00                	push   $0x0
  pushl $4
8010714b:	6a 04                	push   $0x4
  jmp alltraps
8010714d:	e9 e8 fa ff ff       	jmp    80106c3a <alltraps>

80107152 <vector5>:
.globl vector5
vector5:
  pushl $0
80107152:	6a 00                	push   $0x0
  pushl $5
80107154:	6a 05                	push   $0x5
  jmp alltraps
80107156:	e9 df fa ff ff       	jmp    80106c3a <alltraps>

8010715b <vector6>:
.globl vector6
vector6:
  pushl $0
8010715b:	6a 00                	push   $0x0
  pushl $6
8010715d:	6a 06                	push   $0x6
  jmp alltraps
8010715f:	e9 d6 fa ff ff       	jmp    80106c3a <alltraps>

80107164 <vector7>:
.globl vector7
vector7:
  pushl $0
80107164:	6a 00                	push   $0x0
  pushl $7
80107166:	6a 07                	push   $0x7
  jmp alltraps
80107168:	e9 cd fa ff ff       	jmp    80106c3a <alltraps>

8010716d <vector8>:
.globl vector8
vector8:
  pushl $8
8010716d:	6a 08                	push   $0x8
  jmp alltraps
8010716f:	e9 c6 fa ff ff       	jmp    80106c3a <alltraps>

80107174 <vector9>:
.globl vector9
vector9:
  pushl $0
80107174:	6a 00                	push   $0x0
  pushl $9
80107176:	6a 09                	push   $0x9
  jmp alltraps
80107178:	e9 bd fa ff ff       	jmp    80106c3a <alltraps>

8010717d <vector10>:
.globl vector10
vector10:
  pushl $10
8010717d:	6a 0a                	push   $0xa
  jmp alltraps
8010717f:	e9 b6 fa ff ff       	jmp    80106c3a <alltraps>

80107184 <vector11>:
.globl vector11
vector11:
  pushl $11
80107184:	6a 0b                	push   $0xb
  jmp alltraps
80107186:	e9 af fa ff ff       	jmp    80106c3a <alltraps>

8010718b <vector12>:
.globl vector12
vector12:
  pushl $12
8010718b:	6a 0c                	push   $0xc
  jmp alltraps
8010718d:	e9 a8 fa ff ff       	jmp    80106c3a <alltraps>

80107192 <vector13>:
.globl vector13
vector13:
  pushl $13
80107192:	6a 0d                	push   $0xd
  jmp alltraps
80107194:	e9 a1 fa ff ff       	jmp    80106c3a <alltraps>

80107199 <vector14>:
.globl vector14
vector14:
  pushl $14
80107199:	6a 0e                	push   $0xe
  jmp alltraps
8010719b:	e9 9a fa ff ff       	jmp    80106c3a <alltraps>

801071a0 <vector15>:
.globl vector15
vector15:
  pushl $0
801071a0:	6a 00                	push   $0x0
  pushl $15
801071a2:	6a 0f                	push   $0xf
  jmp alltraps
801071a4:	e9 91 fa ff ff       	jmp    80106c3a <alltraps>

801071a9 <vector16>:
.globl vector16
vector16:
  pushl $0
801071a9:	6a 00                	push   $0x0
  pushl $16
801071ab:	6a 10                	push   $0x10
  jmp alltraps
801071ad:	e9 88 fa ff ff       	jmp    80106c3a <alltraps>

801071b2 <vector17>:
.globl vector17
vector17:
  pushl $17
801071b2:	6a 11                	push   $0x11
  jmp alltraps
801071b4:	e9 81 fa ff ff       	jmp    80106c3a <alltraps>

801071b9 <vector18>:
.globl vector18
vector18:
  pushl $0
801071b9:	6a 00                	push   $0x0
  pushl $18
801071bb:	6a 12                	push   $0x12
  jmp alltraps
801071bd:	e9 78 fa ff ff       	jmp    80106c3a <alltraps>

801071c2 <vector19>:
.globl vector19
vector19:
  pushl $0
801071c2:	6a 00                	push   $0x0
  pushl $19
801071c4:	6a 13                	push   $0x13
  jmp alltraps
801071c6:	e9 6f fa ff ff       	jmp    80106c3a <alltraps>

801071cb <vector20>:
.globl vector20
vector20:
  pushl $0
801071cb:	6a 00                	push   $0x0
  pushl $20
801071cd:	6a 14                	push   $0x14
  jmp alltraps
801071cf:	e9 66 fa ff ff       	jmp    80106c3a <alltraps>

801071d4 <vector21>:
.globl vector21
vector21:
  pushl $0
801071d4:	6a 00                	push   $0x0
  pushl $21
801071d6:	6a 15                	push   $0x15
  jmp alltraps
801071d8:	e9 5d fa ff ff       	jmp    80106c3a <alltraps>

801071dd <vector22>:
.globl vector22
vector22:
  pushl $0
801071dd:	6a 00                	push   $0x0
  pushl $22
801071df:	6a 16                	push   $0x16
  jmp alltraps
801071e1:	e9 54 fa ff ff       	jmp    80106c3a <alltraps>

801071e6 <vector23>:
.globl vector23
vector23:
  pushl $0
801071e6:	6a 00                	push   $0x0
  pushl $23
801071e8:	6a 17                	push   $0x17
  jmp alltraps
801071ea:	e9 4b fa ff ff       	jmp    80106c3a <alltraps>

801071ef <vector24>:
.globl vector24
vector24:
  pushl $0
801071ef:	6a 00                	push   $0x0
  pushl $24
801071f1:	6a 18                	push   $0x18
  jmp alltraps
801071f3:	e9 42 fa ff ff       	jmp    80106c3a <alltraps>

801071f8 <vector25>:
.globl vector25
vector25:
  pushl $0
801071f8:	6a 00                	push   $0x0
  pushl $25
801071fa:	6a 19                	push   $0x19
  jmp alltraps
801071fc:	e9 39 fa ff ff       	jmp    80106c3a <alltraps>

80107201 <vector26>:
.globl vector26
vector26:
  pushl $0
80107201:	6a 00                	push   $0x0
  pushl $26
80107203:	6a 1a                	push   $0x1a
  jmp alltraps
80107205:	e9 30 fa ff ff       	jmp    80106c3a <alltraps>

8010720a <vector27>:
.globl vector27
vector27:
  pushl $0
8010720a:	6a 00                	push   $0x0
  pushl $27
8010720c:	6a 1b                	push   $0x1b
  jmp alltraps
8010720e:	e9 27 fa ff ff       	jmp    80106c3a <alltraps>

80107213 <vector28>:
.globl vector28
vector28:
  pushl $0
80107213:	6a 00                	push   $0x0
  pushl $28
80107215:	6a 1c                	push   $0x1c
  jmp alltraps
80107217:	e9 1e fa ff ff       	jmp    80106c3a <alltraps>

8010721c <vector29>:
.globl vector29
vector29:
  pushl $0
8010721c:	6a 00                	push   $0x0
  pushl $29
8010721e:	6a 1d                	push   $0x1d
  jmp alltraps
80107220:	e9 15 fa ff ff       	jmp    80106c3a <alltraps>

80107225 <vector30>:
.globl vector30
vector30:
  pushl $0
80107225:	6a 00                	push   $0x0
  pushl $30
80107227:	6a 1e                	push   $0x1e
  jmp alltraps
80107229:	e9 0c fa ff ff       	jmp    80106c3a <alltraps>

8010722e <vector31>:
.globl vector31
vector31:
  pushl $0
8010722e:	6a 00                	push   $0x0
  pushl $31
80107230:	6a 1f                	push   $0x1f
  jmp alltraps
80107232:	e9 03 fa ff ff       	jmp    80106c3a <alltraps>

80107237 <vector32>:
.globl vector32
vector32:
  pushl $0
80107237:	6a 00                	push   $0x0
  pushl $32
80107239:	6a 20                	push   $0x20
  jmp alltraps
8010723b:	e9 fa f9 ff ff       	jmp    80106c3a <alltraps>

80107240 <vector33>:
.globl vector33
vector33:
  pushl $0
80107240:	6a 00                	push   $0x0
  pushl $33
80107242:	6a 21                	push   $0x21
  jmp alltraps
80107244:	e9 f1 f9 ff ff       	jmp    80106c3a <alltraps>

80107249 <vector34>:
.globl vector34
vector34:
  pushl $0
80107249:	6a 00                	push   $0x0
  pushl $34
8010724b:	6a 22                	push   $0x22
  jmp alltraps
8010724d:	e9 e8 f9 ff ff       	jmp    80106c3a <alltraps>

80107252 <vector35>:
.globl vector35
vector35:
  pushl $0
80107252:	6a 00                	push   $0x0
  pushl $35
80107254:	6a 23                	push   $0x23
  jmp alltraps
80107256:	e9 df f9 ff ff       	jmp    80106c3a <alltraps>

8010725b <vector36>:
.globl vector36
vector36:
  pushl $0
8010725b:	6a 00                	push   $0x0
  pushl $36
8010725d:	6a 24                	push   $0x24
  jmp alltraps
8010725f:	e9 d6 f9 ff ff       	jmp    80106c3a <alltraps>

80107264 <vector37>:
.globl vector37
vector37:
  pushl $0
80107264:	6a 00                	push   $0x0
  pushl $37
80107266:	6a 25                	push   $0x25
  jmp alltraps
80107268:	e9 cd f9 ff ff       	jmp    80106c3a <alltraps>

8010726d <vector38>:
.globl vector38
vector38:
  pushl $0
8010726d:	6a 00                	push   $0x0
  pushl $38
8010726f:	6a 26                	push   $0x26
  jmp alltraps
80107271:	e9 c4 f9 ff ff       	jmp    80106c3a <alltraps>

80107276 <vector39>:
.globl vector39
vector39:
  pushl $0
80107276:	6a 00                	push   $0x0
  pushl $39
80107278:	6a 27                	push   $0x27
  jmp alltraps
8010727a:	e9 bb f9 ff ff       	jmp    80106c3a <alltraps>

8010727f <vector40>:
.globl vector40
vector40:
  pushl $0
8010727f:	6a 00                	push   $0x0
  pushl $40
80107281:	6a 28                	push   $0x28
  jmp alltraps
80107283:	e9 b2 f9 ff ff       	jmp    80106c3a <alltraps>

80107288 <vector41>:
.globl vector41
vector41:
  pushl $0
80107288:	6a 00                	push   $0x0
  pushl $41
8010728a:	6a 29                	push   $0x29
  jmp alltraps
8010728c:	e9 a9 f9 ff ff       	jmp    80106c3a <alltraps>

80107291 <vector42>:
.globl vector42
vector42:
  pushl $0
80107291:	6a 00                	push   $0x0
  pushl $42
80107293:	6a 2a                	push   $0x2a
  jmp alltraps
80107295:	e9 a0 f9 ff ff       	jmp    80106c3a <alltraps>

8010729a <vector43>:
.globl vector43
vector43:
  pushl $0
8010729a:	6a 00                	push   $0x0
  pushl $43
8010729c:	6a 2b                	push   $0x2b
  jmp alltraps
8010729e:	e9 97 f9 ff ff       	jmp    80106c3a <alltraps>

801072a3 <vector44>:
.globl vector44
vector44:
  pushl $0
801072a3:	6a 00                	push   $0x0
  pushl $44
801072a5:	6a 2c                	push   $0x2c
  jmp alltraps
801072a7:	e9 8e f9 ff ff       	jmp    80106c3a <alltraps>

801072ac <vector45>:
.globl vector45
vector45:
  pushl $0
801072ac:	6a 00                	push   $0x0
  pushl $45
801072ae:	6a 2d                	push   $0x2d
  jmp alltraps
801072b0:	e9 85 f9 ff ff       	jmp    80106c3a <alltraps>

801072b5 <vector46>:
.globl vector46
vector46:
  pushl $0
801072b5:	6a 00                	push   $0x0
  pushl $46
801072b7:	6a 2e                	push   $0x2e
  jmp alltraps
801072b9:	e9 7c f9 ff ff       	jmp    80106c3a <alltraps>

801072be <vector47>:
.globl vector47
vector47:
  pushl $0
801072be:	6a 00                	push   $0x0
  pushl $47
801072c0:	6a 2f                	push   $0x2f
  jmp alltraps
801072c2:	e9 73 f9 ff ff       	jmp    80106c3a <alltraps>

801072c7 <vector48>:
.globl vector48
vector48:
  pushl $0
801072c7:	6a 00                	push   $0x0
  pushl $48
801072c9:	6a 30                	push   $0x30
  jmp alltraps
801072cb:	e9 6a f9 ff ff       	jmp    80106c3a <alltraps>

801072d0 <vector49>:
.globl vector49
vector49:
  pushl $0
801072d0:	6a 00                	push   $0x0
  pushl $49
801072d2:	6a 31                	push   $0x31
  jmp alltraps
801072d4:	e9 61 f9 ff ff       	jmp    80106c3a <alltraps>

801072d9 <vector50>:
.globl vector50
vector50:
  pushl $0
801072d9:	6a 00                	push   $0x0
  pushl $50
801072db:	6a 32                	push   $0x32
  jmp alltraps
801072dd:	e9 58 f9 ff ff       	jmp    80106c3a <alltraps>

801072e2 <vector51>:
.globl vector51
vector51:
  pushl $0
801072e2:	6a 00                	push   $0x0
  pushl $51
801072e4:	6a 33                	push   $0x33
  jmp alltraps
801072e6:	e9 4f f9 ff ff       	jmp    80106c3a <alltraps>

801072eb <vector52>:
.globl vector52
vector52:
  pushl $0
801072eb:	6a 00                	push   $0x0
  pushl $52
801072ed:	6a 34                	push   $0x34
  jmp alltraps
801072ef:	e9 46 f9 ff ff       	jmp    80106c3a <alltraps>

801072f4 <vector53>:
.globl vector53
vector53:
  pushl $0
801072f4:	6a 00                	push   $0x0
  pushl $53
801072f6:	6a 35                	push   $0x35
  jmp alltraps
801072f8:	e9 3d f9 ff ff       	jmp    80106c3a <alltraps>

801072fd <vector54>:
.globl vector54
vector54:
  pushl $0
801072fd:	6a 00                	push   $0x0
  pushl $54
801072ff:	6a 36                	push   $0x36
  jmp alltraps
80107301:	e9 34 f9 ff ff       	jmp    80106c3a <alltraps>

80107306 <vector55>:
.globl vector55
vector55:
  pushl $0
80107306:	6a 00                	push   $0x0
  pushl $55
80107308:	6a 37                	push   $0x37
  jmp alltraps
8010730a:	e9 2b f9 ff ff       	jmp    80106c3a <alltraps>

8010730f <vector56>:
.globl vector56
vector56:
  pushl $0
8010730f:	6a 00                	push   $0x0
  pushl $56
80107311:	6a 38                	push   $0x38
  jmp alltraps
80107313:	e9 22 f9 ff ff       	jmp    80106c3a <alltraps>

80107318 <vector57>:
.globl vector57
vector57:
  pushl $0
80107318:	6a 00                	push   $0x0
  pushl $57
8010731a:	6a 39                	push   $0x39
  jmp alltraps
8010731c:	e9 19 f9 ff ff       	jmp    80106c3a <alltraps>

80107321 <vector58>:
.globl vector58
vector58:
  pushl $0
80107321:	6a 00                	push   $0x0
  pushl $58
80107323:	6a 3a                	push   $0x3a
  jmp alltraps
80107325:	e9 10 f9 ff ff       	jmp    80106c3a <alltraps>

8010732a <vector59>:
.globl vector59
vector59:
  pushl $0
8010732a:	6a 00                	push   $0x0
  pushl $59
8010732c:	6a 3b                	push   $0x3b
  jmp alltraps
8010732e:	e9 07 f9 ff ff       	jmp    80106c3a <alltraps>

80107333 <vector60>:
.globl vector60
vector60:
  pushl $0
80107333:	6a 00                	push   $0x0
  pushl $60
80107335:	6a 3c                	push   $0x3c
  jmp alltraps
80107337:	e9 fe f8 ff ff       	jmp    80106c3a <alltraps>

8010733c <vector61>:
.globl vector61
vector61:
  pushl $0
8010733c:	6a 00                	push   $0x0
  pushl $61
8010733e:	6a 3d                	push   $0x3d
  jmp alltraps
80107340:	e9 f5 f8 ff ff       	jmp    80106c3a <alltraps>

80107345 <vector62>:
.globl vector62
vector62:
  pushl $0
80107345:	6a 00                	push   $0x0
  pushl $62
80107347:	6a 3e                	push   $0x3e
  jmp alltraps
80107349:	e9 ec f8 ff ff       	jmp    80106c3a <alltraps>

8010734e <vector63>:
.globl vector63
vector63:
  pushl $0
8010734e:	6a 00                	push   $0x0
  pushl $63
80107350:	6a 3f                	push   $0x3f
  jmp alltraps
80107352:	e9 e3 f8 ff ff       	jmp    80106c3a <alltraps>

80107357 <vector64>:
.globl vector64
vector64:
  pushl $0
80107357:	6a 00                	push   $0x0
  pushl $64
80107359:	6a 40                	push   $0x40
  jmp alltraps
8010735b:	e9 da f8 ff ff       	jmp    80106c3a <alltraps>

80107360 <vector65>:
.globl vector65
vector65:
  pushl $0
80107360:	6a 00                	push   $0x0
  pushl $65
80107362:	6a 41                	push   $0x41
  jmp alltraps
80107364:	e9 d1 f8 ff ff       	jmp    80106c3a <alltraps>

80107369 <vector66>:
.globl vector66
vector66:
  pushl $0
80107369:	6a 00                	push   $0x0
  pushl $66
8010736b:	6a 42                	push   $0x42
  jmp alltraps
8010736d:	e9 c8 f8 ff ff       	jmp    80106c3a <alltraps>

80107372 <vector67>:
.globl vector67
vector67:
  pushl $0
80107372:	6a 00                	push   $0x0
  pushl $67
80107374:	6a 43                	push   $0x43
  jmp alltraps
80107376:	e9 bf f8 ff ff       	jmp    80106c3a <alltraps>

8010737b <vector68>:
.globl vector68
vector68:
  pushl $0
8010737b:	6a 00                	push   $0x0
  pushl $68
8010737d:	6a 44                	push   $0x44
  jmp alltraps
8010737f:	e9 b6 f8 ff ff       	jmp    80106c3a <alltraps>

80107384 <vector69>:
.globl vector69
vector69:
  pushl $0
80107384:	6a 00                	push   $0x0
  pushl $69
80107386:	6a 45                	push   $0x45
  jmp alltraps
80107388:	e9 ad f8 ff ff       	jmp    80106c3a <alltraps>

8010738d <vector70>:
.globl vector70
vector70:
  pushl $0
8010738d:	6a 00                	push   $0x0
  pushl $70
8010738f:	6a 46                	push   $0x46
  jmp alltraps
80107391:	e9 a4 f8 ff ff       	jmp    80106c3a <alltraps>

80107396 <vector71>:
.globl vector71
vector71:
  pushl $0
80107396:	6a 00                	push   $0x0
  pushl $71
80107398:	6a 47                	push   $0x47
  jmp alltraps
8010739a:	e9 9b f8 ff ff       	jmp    80106c3a <alltraps>

8010739f <vector72>:
.globl vector72
vector72:
  pushl $0
8010739f:	6a 00                	push   $0x0
  pushl $72
801073a1:	6a 48                	push   $0x48
  jmp alltraps
801073a3:	e9 92 f8 ff ff       	jmp    80106c3a <alltraps>

801073a8 <vector73>:
.globl vector73
vector73:
  pushl $0
801073a8:	6a 00                	push   $0x0
  pushl $73
801073aa:	6a 49                	push   $0x49
  jmp alltraps
801073ac:	e9 89 f8 ff ff       	jmp    80106c3a <alltraps>

801073b1 <vector74>:
.globl vector74
vector74:
  pushl $0
801073b1:	6a 00                	push   $0x0
  pushl $74
801073b3:	6a 4a                	push   $0x4a
  jmp alltraps
801073b5:	e9 80 f8 ff ff       	jmp    80106c3a <alltraps>

801073ba <vector75>:
.globl vector75
vector75:
  pushl $0
801073ba:	6a 00                	push   $0x0
  pushl $75
801073bc:	6a 4b                	push   $0x4b
  jmp alltraps
801073be:	e9 77 f8 ff ff       	jmp    80106c3a <alltraps>

801073c3 <vector76>:
.globl vector76
vector76:
  pushl $0
801073c3:	6a 00                	push   $0x0
  pushl $76
801073c5:	6a 4c                	push   $0x4c
  jmp alltraps
801073c7:	e9 6e f8 ff ff       	jmp    80106c3a <alltraps>

801073cc <vector77>:
.globl vector77
vector77:
  pushl $0
801073cc:	6a 00                	push   $0x0
  pushl $77
801073ce:	6a 4d                	push   $0x4d
  jmp alltraps
801073d0:	e9 65 f8 ff ff       	jmp    80106c3a <alltraps>

801073d5 <vector78>:
.globl vector78
vector78:
  pushl $0
801073d5:	6a 00                	push   $0x0
  pushl $78
801073d7:	6a 4e                	push   $0x4e
  jmp alltraps
801073d9:	e9 5c f8 ff ff       	jmp    80106c3a <alltraps>

801073de <vector79>:
.globl vector79
vector79:
  pushl $0
801073de:	6a 00                	push   $0x0
  pushl $79
801073e0:	6a 4f                	push   $0x4f
  jmp alltraps
801073e2:	e9 53 f8 ff ff       	jmp    80106c3a <alltraps>

801073e7 <vector80>:
.globl vector80
vector80:
  pushl $0
801073e7:	6a 00                	push   $0x0
  pushl $80
801073e9:	6a 50                	push   $0x50
  jmp alltraps
801073eb:	e9 4a f8 ff ff       	jmp    80106c3a <alltraps>

801073f0 <vector81>:
.globl vector81
vector81:
  pushl $0
801073f0:	6a 00                	push   $0x0
  pushl $81
801073f2:	6a 51                	push   $0x51
  jmp alltraps
801073f4:	e9 41 f8 ff ff       	jmp    80106c3a <alltraps>

801073f9 <vector82>:
.globl vector82
vector82:
  pushl $0
801073f9:	6a 00                	push   $0x0
  pushl $82
801073fb:	6a 52                	push   $0x52
  jmp alltraps
801073fd:	e9 38 f8 ff ff       	jmp    80106c3a <alltraps>

80107402 <vector83>:
.globl vector83
vector83:
  pushl $0
80107402:	6a 00                	push   $0x0
  pushl $83
80107404:	6a 53                	push   $0x53
  jmp alltraps
80107406:	e9 2f f8 ff ff       	jmp    80106c3a <alltraps>

8010740b <vector84>:
.globl vector84
vector84:
  pushl $0
8010740b:	6a 00                	push   $0x0
  pushl $84
8010740d:	6a 54                	push   $0x54
  jmp alltraps
8010740f:	e9 26 f8 ff ff       	jmp    80106c3a <alltraps>

80107414 <vector85>:
.globl vector85
vector85:
  pushl $0
80107414:	6a 00                	push   $0x0
  pushl $85
80107416:	6a 55                	push   $0x55
  jmp alltraps
80107418:	e9 1d f8 ff ff       	jmp    80106c3a <alltraps>

8010741d <vector86>:
.globl vector86
vector86:
  pushl $0
8010741d:	6a 00                	push   $0x0
  pushl $86
8010741f:	6a 56                	push   $0x56
  jmp alltraps
80107421:	e9 14 f8 ff ff       	jmp    80106c3a <alltraps>

80107426 <vector87>:
.globl vector87
vector87:
  pushl $0
80107426:	6a 00                	push   $0x0
  pushl $87
80107428:	6a 57                	push   $0x57
  jmp alltraps
8010742a:	e9 0b f8 ff ff       	jmp    80106c3a <alltraps>

8010742f <vector88>:
.globl vector88
vector88:
  pushl $0
8010742f:	6a 00                	push   $0x0
  pushl $88
80107431:	6a 58                	push   $0x58
  jmp alltraps
80107433:	e9 02 f8 ff ff       	jmp    80106c3a <alltraps>

80107438 <vector89>:
.globl vector89
vector89:
  pushl $0
80107438:	6a 00                	push   $0x0
  pushl $89
8010743a:	6a 59                	push   $0x59
  jmp alltraps
8010743c:	e9 f9 f7 ff ff       	jmp    80106c3a <alltraps>

80107441 <vector90>:
.globl vector90
vector90:
  pushl $0
80107441:	6a 00                	push   $0x0
  pushl $90
80107443:	6a 5a                	push   $0x5a
  jmp alltraps
80107445:	e9 f0 f7 ff ff       	jmp    80106c3a <alltraps>

8010744a <vector91>:
.globl vector91
vector91:
  pushl $0
8010744a:	6a 00                	push   $0x0
  pushl $91
8010744c:	6a 5b                	push   $0x5b
  jmp alltraps
8010744e:	e9 e7 f7 ff ff       	jmp    80106c3a <alltraps>

80107453 <vector92>:
.globl vector92
vector92:
  pushl $0
80107453:	6a 00                	push   $0x0
  pushl $92
80107455:	6a 5c                	push   $0x5c
  jmp alltraps
80107457:	e9 de f7 ff ff       	jmp    80106c3a <alltraps>

8010745c <vector93>:
.globl vector93
vector93:
  pushl $0
8010745c:	6a 00                	push   $0x0
  pushl $93
8010745e:	6a 5d                	push   $0x5d
  jmp alltraps
80107460:	e9 d5 f7 ff ff       	jmp    80106c3a <alltraps>

80107465 <vector94>:
.globl vector94
vector94:
  pushl $0
80107465:	6a 00                	push   $0x0
  pushl $94
80107467:	6a 5e                	push   $0x5e
  jmp alltraps
80107469:	e9 cc f7 ff ff       	jmp    80106c3a <alltraps>

8010746e <vector95>:
.globl vector95
vector95:
  pushl $0
8010746e:	6a 00                	push   $0x0
  pushl $95
80107470:	6a 5f                	push   $0x5f
  jmp alltraps
80107472:	e9 c3 f7 ff ff       	jmp    80106c3a <alltraps>

80107477 <vector96>:
.globl vector96
vector96:
  pushl $0
80107477:	6a 00                	push   $0x0
  pushl $96
80107479:	6a 60                	push   $0x60
  jmp alltraps
8010747b:	e9 ba f7 ff ff       	jmp    80106c3a <alltraps>

80107480 <vector97>:
.globl vector97
vector97:
  pushl $0
80107480:	6a 00                	push   $0x0
  pushl $97
80107482:	6a 61                	push   $0x61
  jmp alltraps
80107484:	e9 b1 f7 ff ff       	jmp    80106c3a <alltraps>

80107489 <vector98>:
.globl vector98
vector98:
  pushl $0
80107489:	6a 00                	push   $0x0
  pushl $98
8010748b:	6a 62                	push   $0x62
  jmp alltraps
8010748d:	e9 a8 f7 ff ff       	jmp    80106c3a <alltraps>

80107492 <vector99>:
.globl vector99
vector99:
  pushl $0
80107492:	6a 00                	push   $0x0
  pushl $99
80107494:	6a 63                	push   $0x63
  jmp alltraps
80107496:	e9 9f f7 ff ff       	jmp    80106c3a <alltraps>

8010749b <vector100>:
.globl vector100
vector100:
  pushl $0
8010749b:	6a 00                	push   $0x0
  pushl $100
8010749d:	6a 64                	push   $0x64
  jmp alltraps
8010749f:	e9 96 f7 ff ff       	jmp    80106c3a <alltraps>

801074a4 <vector101>:
.globl vector101
vector101:
  pushl $0
801074a4:	6a 00                	push   $0x0
  pushl $101
801074a6:	6a 65                	push   $0x65
  jmp alltraps
801074a8:	e9 8d f7 ff ff       	jmp    80106c3a <alltraps>

801074ad <vector102>:
.globl vector102
vector102:
  pushl $0
801074ad:	6a 00                	push   $0x0
  pushl $102
801074af:	6a 66                	push   $0x66
  jmp alltraps
801074b1:	e9 84 f7 ff ff       	jmp    80106c3a <alltraps>

801074b6 <vector103>:
.globl vector103
vector103:
  pushl $0
801074b6:	6a 00                	push   $0x0
  pushl $103
801074b8:	6a 67                	push   $0x67
  jmp alltraps
801074ba:	e9 7b f7 ff ff       	jmp    80106c3a <alltraps>

801074bf <vector104>:
.globl vector104
vector104:
  pushl $0
801074bf:	6a 00                	push   $0x0
  pushl $104
801074c1:	6a 68                	push   $0x68
  jmp alltraps
801074c3:	e9 72 f7 ff ff       	jmp    80106c3a <alltraps>

801074c8 <vector105>:
.globl vector105
vector105:
  pushl $0
801074c8:	6a 00                	push   $0x0
  pushl $105
801074ca:	6a 69                	push   $0x69
  jmp alltraps
801074cc:	e9 69 f7 ff ff       	jmp    80106c3a <alltraps>

801074d1 <vector106>:
.globl vector106
vector106:
  pushl $0
801074d1:	6a 00                	push   $0x0
  pushl $106
801074d3:	6a 6a                	push   $0x6a
  jmp alltraps
801074d5:	e9 60 f7 ff ff       	jmp    80106c3a <alltraps>

801074da <vector107>:
.globl vector107
vector107:
  pushl $0
801074da:	6a 00                	push   $0x0
  pushl $107
801074dc:	6a 6b                	push   $0x6b
  jmp alltraps
801074de:	e9 57 f7 ff ff       	jmp    80106c3a <alltraps>

801074e3 <vector108>:
.globl vector108
vector108:
  pushl $0
801074e3:	6a 00                	push   $0x0
  pushl $108
801074e5:	6a 6c                	push   $0x6c
  jmp alltraps
801074e7:	e9 4e f7 ff ff       	jmp    80106c3a <alltraps>

801074ec <vector109>:
.globl vector109
vector109:
  pushl $0
801074ec:	6a 00                	push   $0x0
  pushl $109
801074ee:	6a 6d                	push   $0x6d
  jmp alltraps
801074f0:	e9 45 f7 ff ff       	jmp    80106c3a <alltraps>

801074f5 <vector110>:
.globl vector110
vector110:
  pushl $0
801074f5:	6a 00                	push   $0x0
  pushl $110
801074f7:	6a 6e                	push   $0x6e
  jmp alltraps
801074f9:	e9 3c f7 ff ff       	jmp    80106c3a <alltraps>

801074fe <vector111>:
.globl vector111
vector111:
  pushl $0
801074fe:	6a 00                	push   $0x0
  pushl $111
80107500:	6a 6f                	push   $0x6f
  jmp alltraps
80107502:	e9 33 f7 ff ff       	jmp    80106c3a <alltraps>

80107507 <vector112>:
.globl vector112
vector112:
  pushl $0
80107507:	6a 00                	push   $0x0
  pushl $112
80107509:	6a 70                	push   $0x70
  jmp alltraps
8010750b:	e9 2a f7 ff ff       	jmp    80106c3a <alltraps>

80107510 <vector113>:
.globl vector113
vector113:
  pushl $0
80107510:	6a 00                	push   $0x0
  pushl $113
80107512:	6a 71                	push   $0x71
  jmp alltraps
80107514:	e9 21 f7 ff ff       	jmp    80106c3a <alltraps>

80107519 <vector114>:
.globl vector114
vector114:
  pushl $0
80107519:	6a 00                	push   $0x0
  pushl $114
8010751b:	6a 72                	push   $0x72
  jmp alltraps
8010751d:	e9 18 f7 ff ff       	jmp    80106c3a <alltraps>

80107522 <vector115>:
.globl vector115
vector115:
  pushl $0
80107522:	6a 00                	push   $0x0
  pushl $115
80107524:	6a 73                	push   $0x73
  jmp alltraps
80107526:	e9 0f f7 ff ff       	jmp    80106c3a <alltraps>

8010752b <vector116>:
.globl vector116
vector116:
  pushl $0
8010752b:	6a 00                	push   $0x0
  pushl $116
8010752d:	6a 74                	push   $0x74
  jmp alltraps
8010752f:	e9 06 f7 ff ff       	jmp    80106c3a <alltraps>

80107534 <vector117>:
.globl vector117
vector117:
  pushl $0
80107534:	6a 00                	push   $0x0
  pushl $117
80107536:	6a 75                	push   $0x75
  jmp alltraps
80107538:	e9 fd f6 ff ff       	jmp    80106c3a <alltraps>

8010753d <vector118>:
.globl vector118
vector118:
  pushl $0
8010753d:	6a 00                	push   $0x0
  pushl $118
8010753f:	6a 76                	push   $0x76
  jmp alltraps
80107541:	e9 f4 f6 ff ff       	jmp    80106c3a <alltraps>

80107546 <vector119>:
.globl vector119
vector119:
  pushl $0
80107546:	6a 00                	push   $0x0
  pushl $119
80107548:	6a 77                	push   $0x77
  jmp alltraps
8010754a:	e9 eb f6 ff ff       	jmp    80106c3a <alltraps>

8010754f <vector120>:
.globl vector120
vector120:
  pushl $0
8010754f:	6a 00                	push   $0x0
  pushl $120
80107551:	6a 78                	push   $0x78
  jmp alltraps
80107553:	e9 e2 f6 ff ff       	jmp    80106c3a <alltraps>

80107558 <vector121>:
.globl vector121
vector121:
  pushl $0
80107558:	6a 00                	push   $0x0
  pushl $121
8010755a:	6a 79                	push   $0x79
  jmp alltraps
8010755c:	e9 d9 f6 ff ff       	jmp    80106c3a <alltraps>

80107561 <vector122>:
.globl vector122
vector122:
  pushl $0
80107561:	6a 00                	push   $0x0
  pushl $122
80107563:	6a 7a                	push   $0x7a
  jmp alltraps
80107565:	e9 d0 f6 ff ff       	jmp    80106c3a <alltraps>

8010756a <vector123>:
.globl vector123
vector123:
  pushl $0
8010756a:	6a 00                	push   $0x0
  pushl $123
8010756c:	6a 7b                	push   $0x7b
  jmp alltraps
8010756e:	e9 c7 f6 ff ff       	jmp    80106c3a <alltraps>

80107573 <vector124>:
.globl vector124
vector124:
  pushl $0
80107573:	6a 00                	push   $0x0
  pushl $124
80107575:	6a 7c                	push   $0x7c
  jmp alltraps
80107577:	e9 be f6 ff ff       	jmp    80106c3a <alltraps>

8010757c <vector125>:
.globl vector125
vector125:
  pushl $0
8010757c:	6a 00                	push   $0x0
  pushl $125
8010757e:	6a 7d                	push   $0x7d
  jmp alltraps
80107580:	e9 b5 f6 ff ff       	jmp    80106c3a <alltraps>

80107585 <vector126>:
.globl vector126
vector126:
  pushl $0
80107585:	6a 00                	push   $0x0
  pushl $126
80107587:	6a 7e                	push   $0x7e
  jmp alltraps
80107589:	e9 ac f6 ff ff       	jmp    80106c3a <alltraps>

8010758e <vector127>:
.globl vector127
vector127:
  pushl $0
8010758e:	6a 00                	push   $0x0
  pushl $127
80107590:	6a 7f                	push   $0x7f
  jmp alltraps
80107592:	e9 a3 f6 ff ff       	jmp    80106c3a <alltraps>

80107597 <vector128>:
.globl vector128
vector128:
  pushl $0
80107597:	6a 00                	push   $0x0
  pushl $128
80107599:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010759e:	e9 97 f6 ff ff       	jmp    80106c3a <alltraps>

801075a3 <vector129>:
.globl vector129
vector129:
  pushl $0
801075a3:	6a 00                	push   $0x0
  pushl $129
801075a5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801075aa:	e9 8b f6 ff ff       	jmp    80106c3a <alltraps>

801075af <vector130>:
.globl vector130
vector130:
  pushl $0
801075af:	6a 00                	push   $0x0
  pushl $130
801075b1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801075b6:	e9 7f f6 ff ff       	jmp    80106c3a <alltraps>

801075bb <vector131>:
.globl vector131
vector131:
  pushl $0
801075bb:	6a 00                	push   $0x0
  pushl $131
801075bd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801075c2:	e9 73 f6 ff ff       	jmp    80106c3a <alltraps>

801075c7 <vector132>:
.globl vector132
vector132:
  pushl $0
801075c7:	6a 00                	push   $0x0
  pushl $132
801075c9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801075ce:	e9 67 f6 ff ff       	jmp    80106c3a <alltraps>

801075d3 <vector133>:
.globl vector133
vector133:
  pushl $0
801075d3:	6a 00                	push   $0x0
  pushl $133
801075d5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801075da:	e9 5b f6 ff ff       	jmp    80106c3a <alltraps>

801075df <vector134>:
.globl vector134
vector134:
  pushl $0
801075df:	6a 00                	push   $0x0
  pushl $134
801075e1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801075e6:	e9 4f f6 ff ff       	jmp    80106c3a <alltraps>

801075eb <vector135>:
.globl vector135
vector135:
  pushl $0
801075eb:	6a 00                	push   $0x0
  pushl $135
801075ed:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801075f2:	e9 43 f6 ff ff       	jmp    80106c3a <alltraps>

801075f7 <vector136>:
.globl vector136
vector136:
  pushl $0
801075f7:	6a 00                	push   $0x0
  pushl $136
801075f9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801075fe:	e9 37 f6 ff ff       	jmp    80106c3a <alltraps>

80107603 <vector137>:
.globl vector137
vector137:
  pushl $0
80107603:	6a 00                	push   $0x0
  pushl $137
80107605:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010760a:	e9 2b f6 ff ff       	jmp    80106c3a <alltraps>

8010760f <vector138>:
.globl vector138
vector138:
  pushl $0
8010760f:	6a 00                	push   $0x0
  pushl $138
80107611:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80107616:	e9 1f f6 ff ff       	jmp    80106c3a <alltraps>

8010761b <vector139>:
.globl vector139
vector139:
  pushl $0
8010761b:	6a 00                	push   $0x0
  pushl $139
8010761d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107622:	e9 13 f6 ff ff       	jmp    80106c3a <alltraps>

80107627 <vector140>:
.globl vector140
vector140:
  pushl $0
80107627:	6a 00                	push   $0x0
  pushl $140
80107629:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010762e:	e9 07 f6 ff ff       	jmp    80106c3a <alltraps>

80107633 <vector141>:
.globl vector141
vector141:
  pushl $0
80107633:	6a 00                	push   $0x0
  pushl $141
80107635:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010763a:	e9 fb f5 ff ff       	jmp    80106c3a <alltraps>

8010763f <vector142>:
.globl vector142
vector142:
  pushl $0
8010763f:	6a 00                	push   $0x0
  pushl $142
80107641:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107646:	e9 ef f5 ff ff       	jmp    80106c3a <alltraps>

8010764b <vector143>:
.globl vector143
vector143:
  pushl $0
8010764b:	6a 00                	push   $0x0
  pushl $143
8010764d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107652:	e9 e3 f5 ff ff       	jmp    80106c3a <alltraps>

80107657 <vector144>:
.globl vector144
vector144:
  pushl $0
80107657:	6a 00                	push   $0x0
  pushl $144
80107659:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010765e:	e9 d7 f5 ff ff       	jmp    80106c3a <alltraps>

80107663 <vector145>:
.globl vector145
vector145:
  pushl $0
80107663:	6a 00                	push   $0x0
  pushl $145
80107665:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010766a:	e9 cb f5 ff ff       	jmp    80106c3a <alltraps>

8010766f <vector146>:
.globl vector146
vector146:
  pushl $0
8010766f:	6a 00                	push   $0x0
  pushl $146
80107671:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80107676:	e9 bf f5 ff ff       	jmp    80106c3a <alltraps>

8010767b <vector147>:
.globl vector147
vector147:
  pushl $0
8010767b:	6a 00                	push   $0x0
  pushl $147
8010767d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107682:	e9 b3 f5 ff ff       	jmp    80106c3a <alltraps>

80107687 <vector148>:
.globl vector148
vector148:
  pushl $0
80107687:	6a 00                	push   $0x0
  pushl $148
80107689:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010768e:	e9 a7 f5 ff ff       	jmp    80106c3a <alltraps>

80107693 <vector149>:
.globl vector149
vector149:
  pushl $0
80107693:	6a 00                	push   $0x0
  pushl $149
80107695:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010769a:	e9 9b f5 ff ff       	jmp    80106c3a <alltraps>

8010769f <vector150>:
.globl vector150
vector150:
  pushl $0
8010769f:	6a 00                	push   $0x0
  pushl $150
801076a1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801076a6:	e9 8f f5 ff ff       	jmp    80106c3a <alltraps>

801076ab <vector151>:
.globl vector151
vector151:
  pushl $0
801076ab:	6a 00                	push   $0x0
  pushl $151
801076ad:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801076b2:	e9 83 f5 ff ff       	jmp    80106c3a <alltraps>

801076b7 <vector152>:
.globl vector152
vector152:
  pushl $0
801076b7:	6a 00                	push   $0x0
  pushl $152
801076b9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801076be:	e9 77 f5 ff ff       	jmp    80106c3a <alltraps>

801076c3 <vector153>:
.globl vector153
vector153:
  pushl $0
801076c3:	6a 00                	push   $0x0
  pushl $153
801076c5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801076ca:	e9 6b f5 ff ff       	jmp    80106c3a <alltraps>

801076cf <vector154>:
.globl vector154
vector154:
  pushl $0
801076cf:	6a 00                	push   $0x0
  pushl $154
801076d1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801076d6:	e9 5f f5 ff ff       	jmp    80106c3a <alltraps>

801076db <vector155>:
.globl vector155
vector155:
  pushl $0
801076db:	6a 00                	push   $0x0
  pushl $155
801076dd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801076e2:	e9 53 f5 ff ff       	jmp    80106c3a <alltraps>

801076e7 <vector156>:
.globl vector156
vector156:
  pushl $0
801076e7:	6a 00                	push   $0x0
  pushl $156
801076e9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801076ee:	e9 47 f5 ff ff       	jmp    80106c3a <alltraps>

801076f3 <vector157>:
.globl vector157
vector157:
  pushl $0
801076f3:	6a 00                	push   $0x0
  pushl $157
801076f5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801076fa:	e9 3b f5 ff ff       	jmp    80106c3a <alltraps>

801076ff <vector158>:
.globl vector158
vector158:
  pushl $0
801076ff:	6a 00                	push   $0x0
  pushl $158
80107701:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107706:	e9 2f f5 ff ff       	jmp    80106c3a <alltraps>

8010770b <vector159>:
.globl vector159
vector159:
  pushl $0
8010770b:	6a 00                	push   $0x0
  pushl $159
8010770d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107712:	e9 23 f5 ff ff       	jmp    80106c3a <alltraps>

80107717 <vector160>:
.globl vector160
vector160:
  pushl $0
80107717:	6a 00                	push   $0x0
  pushl $160
80107719:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010771e:	e9 17 f5 ff ff       	jmp    80106c3a <alltraps>

80107723 <vector161>:
.globl vector161
vector161:
  pushl $0
80107723:	6a 00                	push   $0x0
  pushl $161
80107725:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010772a:	e9 0b f5 ff ff       	jmp    80106c3a <alltraps>

8010772f <vector162>:
.globl vector162
vector162:
  pushl $0
8010772f:	6a 00                	push   $0x0
  pushl $162
80107731:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107736:	e9 ff f4 ff ff       	jmp    80106c3a <alltraps>

8010773b <vector163>:
.globl vector163
vector163:
  pushl $0
8010773b:	6a 00                	push   $0x0
  pushl $163
8010773d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107742:	e9 f3 f4 ff ff       	jmp    80106c3a <alltraps>

80107747 <vector164>:
.globl vector164
vector164:
  pushl $0
80107747:	6a 00                	push   $0x0
  pushl $164
80107749:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010774e:	e9 e7 f4 ff ff       	jmp    80106c3a <alltraps>

80107753 <vector165>:
.globl vector165
vector165:
  pushl $0
80107753:	6a 00                	push   $0x0
  pushl $165
80107755:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010775a:	e9 db f4 ff ff       	jmp    80106c3a <alltraps>

8010775f <vector166>:
.globl vector166
vector166:
  pushl $0
8010775f:	6a 00                	push   $0x0
  pushl $166
80107761:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107766:	e9 cf f4 ff ff       	jmp    80106c3a <alltraps>

8010776b <vector167>:
.globl vector167
vector167:
  pushl $0
8010776b:	6a 00                	push   $0x0
  pushl $167
8010776d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107772:	e9 c3 f4 ff ff       	jmp    80106c3a <alltraps>

80107777 <vector168>:
.globl vector168
vector168:
  pushl $0
80107777:	6a 00                	push   $0x0
  pushl $168
80107779:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010777e:	e9 b7 f4 ff ff       	jmp    80106c3a <alltraps>

80107783 <vector169>:
.globl vector169
vector169:
  pushl $0
80107783:	6a 00                	push   $0x0
  pushl $169
80107785:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010778a:	e9 ab f4 ff ff       	jmp    80106c3a <alltraps>

8010778f <vector170>:
.globl vector170
vector170:
  pushl $0
8010778f:	6a 00                	push   $0x0
  pushl $170
80107791:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107796:	e9 9f f4 ff ff       	jmp    80106c3a <alltraps>

8010779b <vector171>:
.globl vector171
vector171:
  pushl $0
8010779b:	6a 00                	push   $0x0
  pushl $171
8010779d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801077a2:	e9 93 f4 ff ff       	jmp    80106c3a <alltraps>

801077a7 <vector172>:
.globl vector172
vector172:
  pushl $0
801077a7:	6a 00                	push   $0x0
  pushl $172
801077a9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801077ae:	e9 87 f4 ff ff       	jmp    80106c3a <alltraps>

801077b3 <vector173>:
.globl vector173
vector173:
  pushl $0
801077b3:	6a 00                	push   $0x0
  pushl $173
801077b5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801077ba:	e9 7b f4 ff ff       	jmp    80106c3a <alltraps>

801077bf <vector174>:
.globl vector174
vector174:
  pushl $0
801077bf:	6a 00                	push   $0x0
  pushl $174
801077c1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801077c6:	e9 6f f4 ff ff       	jmp    80106c3a <alltraps>

801077cb <vector175>:
.globl vector175
vector175:
  pushl $0
801077cb:	6a 00                	push   $0x0
  pushl $175
801077cd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801077d2:	e9 63 f4 ff ff       	jmp    80106c3a <alltraps>

801077d7 <vector176>:
.globl vector176
vector176:
  pushl $0
801077d7:	6a 00                	push   $0x0
  pushl $176
801077d9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801077de:	e9 57 f4 ff ff       	jmp    80106c3a <alltraps>

801077e3 <vector177>:
.globl vector177
vector177:
  pushl $0
801077e3:	6a 00                	push   $0x0
  pushl $177
801077e5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801077ea:	e9 4b f4 ff ff       	jmp    80106c3a <alltraps>

801077ef <vector178>:
.globl vector178
vector178:
  pushl $0
801077ef:	6a 00                	push   $0x0
  pushl $178
801077f1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801077f6:	e9 3f f4 ff ff       	jmp    80106c3a <alltraps>

801077fb <vector179>:
.globl vector179
vector179:
  pushl $0
801077fb:	6a 00                	push   $0x0
  pushl $179
801077fd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107802:	e9 33 f4 ff ff       	jmp    80106c3a <alltraps>

80107807 <vector180>:
.globl vector180
vector180:
  pushl $0
80107807:	6a 00                	push   $0x0
  pushl $180
80107809:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010780e:	e9 27 f4 ff ff       	jmp    80106c3a <alltraps>

80107813 <vector181>:
.globl vector181
vector181:
  pushl $0
80107813:	6a 00                	push   $0x0
  pushl $181
80107815:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010781a:	e9 1b f4 ff ff       	jmp    80106c3a <alltraps>

8010781f <vector182>:
.globl vector182
vector182:
  pushl $0
8010781f:	6a 00                	push   $0x0
  pushl $182
80107821:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107826:	e9 0f f4 ff ff       	jmp    80106c3a <alltraps>

8010782b <vector183>:
.globl vector183
vector183:
  pushl $0
8010782b:	6a 00                	push   $0x0
  pushl $183
8010782d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107832:	e9 03 f4 ff ff       	jmp    80106c3a <alltraps>

80107837 <vector184>:
.globl vector184
vector184:
  pushl $0
80107837:	6a 00                	push   $0x0
  pushl $184
80107839:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010783e:	e9 f7 f3 ff ff       	jmp    80106c3a <alltraps>

80107843 <vector185>:
.globl vector185
vector185:
  pushl $0
80107843:	6a 00                	push   $0x0
  pushl $185
80107845:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010784a:	e9 eb f3 ff ff       	jmp    80106c3a <alltraps>

8010784f <vector186>:
.globl vector186
vector186:
  pushl $0
8010784f:	6a 00                	push   $0x0
  pushl $186
80107851:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107856:	e9 df f3 ff ff       	jmp    80106c3a <alltraps>

8010785b <vector187>:
.globl vector187
vector187:
  pushl $0
8010785b:	6a 00                	push   $0x0
  pushl $187
8010785d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107862:	e9 d3 f3 ff ff       	jmp    80106c3a <alltraps>

80107867 <vector188>:
.globl vector188
vector188:
  pushl $0
80107867:	6a 00                	push   $0x0
  pushl $188
80107869:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010786e:	e9 c7 f3 ff ff       	jmp    80106c3a <alltraps>

80107873 <vector189>:
.globl vector189
vector189:
  pushl $0
80107873:	6a 00                	push   $0x0
  pushl $189
80107875:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010787a:	e9 bb f3 ff ff       	jmp    80106c3a <alltraps>

8010787f <vector190>:
.globl vector190
vector190:
  pushl $0
8010787f:	6a 00                	push   $0x0
  pushl $190
80107881:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107886:	e9 af f3 ff ff       	jmp    80106c3a <alltraps>

8010788b <vector191>:
.globl vector191
vector191:
  pushl $0
8010788b:	6a 00                	push   $0x0
  pushl $191
8010788d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107892:	e9 a3 f3 ff ff       	jmp    80106c3a <alltraps>

80107897 <vector192>:
.globl vector192
vector192:
  pushl $0
80107897:	6a 00                	push   $0x0
  pushl $192
80107899:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010789e:	e9 97 f3 ff ff       	jmp    80106c3a <alltraps>

801078a3 <vector193>:
.globl vector193
vector193:
  pushl $0
801078a3:	6a 00                	push   $0x0
  pushl $193
801078a5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801078aa:	e9 8b f3 ff ff       	jmp    80106c3a <alltraps>

801078af <vector194>:
.globl vector194
vector194:
  pushl $0
801078af:	6a 00                	push   $0x0
  pushl $194
801078b1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801078b6:	e9 7f f3 ff ff       	jmp    80106c3a <alltraps>

801078bb <vector195>:
.globl vector195
vector195:
  pushl $0
801078bb:	6a 00                	push   $0x0
  pushl $195
801078bd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801078c2:	e9 73 f3 ff ff       	jmp    80106c3a <alltraps>

801078c7 <vector196>:
.globl vector196
vector196:
  pushl $0
801078c7:	6a 00                	push   $0x0
  pushl $196
801078c9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801078ce:	e9 67 f3 ff ff       	jmp    80106c3a <alltraps>

801078d3 <vector197>:
.globl vector197
vector197:
  pushl $0
801078d3:	6a 00                	push   $0x0
  pushl $197
801078d5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801078da:	e9 5b f3 ff ff       	jmp    80106c3a <alltraps>

801078df <vector198>:
.globl vector198
vector198:
  pushl $0
801078df:	6a 00                	push   $0x0
  pushl $198
801078e1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801078e6:	e9 4f f3 ff ff       	jmp    80106c3a <alltraps>

801078eb <vector199>:
.globl vector199
vector199:
  pushl $0
801078eb:	6a 00                	push   $0x0
  pushl $199
801078ed:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801078f2:	e9 43 f3 ff ff       	jmp    80106c3a <alltraps>

801078f7 <vector200>:
.globl vector200
vector200:
  pushl $0
801078f7:	6a 00                	push   $0x0
  pushl $200
801078f9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801078fe:	e9 37 f3 ff ff       	jmp    80106c3a <alltraps>

80107903 <vector201>:
.globl vector201
vector201:
  pushl $0
80107903:	6a 00                	push   $0x0
  pushl $201
80107905:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010790a:	e9 2b f3 ff ff       	jmp    80106c3a <alltraps>

8010790f <vector202>:
.globl vector202
vector202:
  pushl $0
8010790f:	6a 00                	push   $0x0
  pushl $202
80107911:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107916:	e9 1f f3 ff ff       	jmp    80106c3a <alltraps>

8010791b <vector203>:
.globl vector203
vector203:
  pushl $0
8010791b:	6a 00                	push   $0x0
  pushl $203
8010791d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107922:	e9 13 f3 ff ff       	jmp    80106c3a <alltraps>

80107927 <vector204>:
.globl vector204
vector204:
  pushl $0
80107927:	6a 00                	push   $0x0
  pushl $204
80107929:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010792e:	e9 07 f3 ff ff       	jmp    80106c3a <alltraps>

80107933 <vector205>:
.globl vector205
vector205:
  pushl $0
80107933:	6a 00                	push   $0x0
  pushl $205
80107935:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010793a:	e9 fb f2 ff ff       	jmp    80106c3a <alltraps>

8010793f <vector206>:
.globl vector206
vector206:
  pushl $0
8010793f:	6a 00                	push   $0x0
  pushl $206
80107941:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107946:	e9 ef f2 ff ff       	jmp    80106c3a <alltraps>

8010794b <vector207>:
.globl vector207
vector207:
  pushl $0
8010794b:	6a 00                	push   $0x0
  pushl $207
8010794d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107952:	e9 e3 f2 ff ff       	jmp    80106c3a <alltraps>

80107957 <vector208>:
.globl vector208
vector208:
  pushl $0
80107957:	6a 00                	push   $0x0
  pushl $208
80107959:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010795e:	e9 d7 f2 ff ff       	jmp    80106c3a <alltraps>

80107963 <vector209>:
.globl vector209
vector209:
  pushl $0
80107963:	6a 00                	push   $0x0
  pushl $209
80107965:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010796a:	e9 cb f2 ff ff       	jmp    80106c3a <alltraps>

8010796f <vector210>:
.globl vector210
vector210:
  pushl $0
8010796f:	6a 00                	push   $0x0
  pushl $210
80107971:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107976:	e9 bf f2 ff ff       	jmp    80106c3a <alltraps>

8010797b <vector211>:
.globl vector211
vector211:
  pushl $0
8010797b:	6a 00                	push   $0x0
  pushl $211
8010797d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107982:	e9 b3 f2 ff ff       	jmp    80106c3a <alltraps>

80107987 <vector212>:
.globl vector212
vector212:
  pushl $0
80107987:	6a 00                	push   $0x0
  pushl $212
80107989:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010798e:	e9 a7 f2 ff ff       	jmp    80106c3a <alltraps>

80107993 <vector213>:
.globl vector213
vector213:
  pushl $0
80107993:	6a 00                	push   $0x0
  pushl $213
80107995:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010799a:	e9 9b f2 ff ff       	jmp    80106c3a <alltraps>

8010799f <vector214>:
.globl vector214
vector214:
  pushl $0
8010799f:	6a 00                	push   $0x0
  pushl $214
801079a1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801079a6:	e9 8f f2 ff ff       	jmp    80106c3a <alltraps>

801079ab <vector215>:
.globl vector215
vector215:
  pushl $0
801079ab:	6a 00                	push   $0x0
  pushl $215
801079ad:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801079b2:	e9 83 f2 ff ff       	jmp    80106c3a <alltraps>

801079b7 <vector216>:
.globl vector216
vector216:
  pushl $0
801079b7:	6a 00                	push   $0x0
  pushl $216
801079b9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801079be:	e9 77 f2 ff ff       	jmp    80106c3a <alltraps>

801079c3 <vector217>:
.globl vector217
vector217:
  pushl $0
801079c3:	6a 00                	push   $0x0
  pushl $217
801079c5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801079ca:	e9 6b f2 ff ff       	jmp    80106c3a <alltraps>

801079cf <vector218>:
.globl vector218
vector218:
  pushl $0
801079cf:	6a 00                	push   $0x0
  pushl $218
801079d1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801079d6:	e9 5f f2 ff ff       	jmp    80106c3a <alltraps>

801079db <vector219>:
.globl vector219
vector219:
  pushl $0
801079db:	6a 00                	push   $0x0
  pushl $219
801079dd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801079e2:	e9 53 f2 ff ff       	jmp    80106c3a <alltraps>

801079e7 <vector220>:
.globl vector220
vector220:
  pushl $0
801079e7:	6a 00                	push   $0x0
  pushl $220
801079e9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801079ee:	e9 47 f2 ff ff       	jmp    80106c3a <alltraps>

801079f3 <vector221>:
.globl vector221
vector221:
  pushl $0
801079f3:	6a 00                	push   $0x0
  pushl $221
801079f5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801079fa:	e9 3b f2 ff ff       	jmp    80106c3a <alltraps>

801079ff <vector222>:
.globl vector222
vector222:
  pushl $0
801079ff:	6a 00                	push   $0x0
  pushl $222
80107a01:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107a06:	e9 2f f2 ff ff       	jmp    80106c3a <alltraps>

80107a0b <vector223>:
.globl vector223
vector223:
  pushl $0
80107a0b:	6a 00                	push   $0x0
  pushl $223
80107a0d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107a12:	e9 23 f2 ff ff       	jmp    80106c3a <alltraps>

80107a17 <vector224>:
.globl vector224
vector224:
  pushl $0
80107a17:	6a 00                	push   $0x0
  pushl $224
80107a19:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107a1e:	e9 17 f2 ff ff       	jmp    80106c3a <alltraps>

80107a23 <vector225>:
.globl vector225
vector225:
  pushl $0
80107a23:	6a 00                	push   $0x0
  pushl $225
80107a25:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80107a2a:	e9 0b f2 ff ff       	jmp    80106c3a <alltraps>

80107a2f <vector226>:
.globl vector226
vector226:
  pushl $0
80107a2f:	6a 00                	push   $0x0
  pushl $226
80107a31:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107a36:	e9 ff f1 ff ff       	jmp    80106c3a <alltraps>

80107a3b <vector227>:
.globl vector227
vector227:
  pushl $0
80107a3b:	6a 00                	push   $0x0
  pushl $227
80107a3d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107a42:	e9 f3 f1 ff ff       	jmp    80106c3a <alltraps>

80107a47 <vector228>:
.globl vector228
vector228:
  pushl $0
80107a47:	6a 00                	push   $0x0
  pushl $228
80107a49:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107a4e:	e9 e7 f1 ff ff       	jmp    80106c3a <alltraps>

80107a53 <vector229>:
.globl vector229
vector229:
  pushl $0
80107a53:	6a 00                	push   $0x0
  pushl $229
80107a55:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80107a5a:	e9 db f1 ff ff       	jmp    80106c3a <alltraps>

80107a5f <vector230>:
.globl vector230
vector230:
  pushl $0
80107a5f:	6a 00                	push   $0x0
  pushl $230
80107a61:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107a66:	e9 cf f1 ff ff       	jmp    80106c3a <alltraps>

80107a6b <vector231>:
.globl vector231
vector231:
  pushl $0
80107a6b:	6a 00                	push   $0x0
  pushl $231
80107a6d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107a72:	e9 c3 f1 ff ff       	jmp    80106c3a <alltraps>

80107a77 <vector232>:
.globl vector232
vector232:
  pushl $0
80107a77:	6a 00                	push   $0x0
  pushl $232
80107a79:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107a7e:	e9 b7 f1 ff ff       	jmp    80106c3a <alltraps>

80107a83 <vector233>:
.globl vector233
vector233:
  pushl $0
80107a83:	6a 00                	push   $0x0
  pushl $233
80107a85:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107a8a:	e9 ab f1 ff ff       	jmp    80106c3a <alltraps>

80107a8f <vector234>:
.globl vector234
vector234:
  pushl $0
80107a8f:	6a 00                	push   $0x0
  pushl $234
80107a91:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107a96:	e9 9f f1 ff ff       	jmp    80106c3a <alltraps>

80107a9b <vector235>:
.globl vector235
vector235:
  pushl $0
80107a9b:	6a 00                	push   $0x0
  pushl $235
80107a9d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107aa2:	e9 93 f1 ff ff       	jmp    80106c3a <alltraps>

80107aa7 <vector236>:
.globl vector236
vector236:
  pushl $0
80107aa7:	6a 00                	push   $0x0
  pushl $236
80107aa9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107aae:	e9 87 f1 ff ff       	jmp    80106c3a <alltraps>

80107ab3 <vector237>:
.globl vector237
vector237:
  pushl $0
80107ab3:	6a 00                	push   $0x0
  pushl $237
80107ab5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107aba:	e9 7b f1 ff ff       	jmp    80106c3a <alltraps>

80107abf <vector238>:
.globl vector238
vector238:
  pushl $0
80107abf:	6a 00                	push   $0x0
  pushl $238
80107ac1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107ac6:	e9 6f f1 ff ff       	jmp    80106c3a <alltraps>

80107acb <vector239>:
.globl vector239
vector239:
  pushl $0
80107acb:	6a 00                	push   $0x0
  pushl $239
80107acd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107ad2:	e9 63 f1 ff ff       	jmp    80106c3a <alltraps>

80107ad7 <vector240>:
.globl vector240
vector240:
  pushl $0
80107ad7:	6a 00                	push   $0x0
  pushl $240
80107ad9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107ade:	e9 57 f1 ff ff       	jmp    80106c3a <alltraps>

80107ae3 <vector241>:
.globl vector241
vector241:
  pushl $0
80107ae3:	6a 00                	push   $0x0
  pushl $241
80107ae5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80107aea:	e9 4b f1 ff ff       	jmp    80106c3a <alltraps>

80107aef <vector242>:
.globl vector242
vector242:
  pushl $0
80107aef:	6a 00                	push   $0x0
  pushl $242
80107af1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107af6:	e9 3f f1 ff ff       	jmp    80106c3a <alltraps>

80107afb <vector243>:
.globl vector243
vector243:
  pushl $0
80107afb:	6a 00                	push   $0x0
  pushl $243
80107afd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107b02:	e9 33 f1 ff ff       	jmp    80106c3a <alltraps>

80107b07 <vector244>:
.globl vector244
vector244:
  pushl $0
80107b07:	6a 00                	push   $0x0
  pushl $244
80107b09:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107b0e:	e9 27 f1 ff ff       	jmp    80106c3a <alltraps>

80107b13 <vector245>:
.globl vector245
vector245:
  pushl $0
80107b13:	6a 00                	push   $0x0
  pushl $245
80107b15:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80107b1a:	e9 1b f1 ff ff       	jmp    80106c3a <alltraps>

80107b1f <vector246>:
.globl vector246
vector246:
  pushl $0
80107b1f:	6a 00                	push   $0x0
  pushl $246
80107b21:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107b26:	e9 0f f1 ff ff       	jmp    80106c3a <alltraps>

80107b2b <vector247>:
.globl vector247
vector247:
  pushl $0
80107b2b:	6a 00                	push   $0x0
  pushl $247
80107b2d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107b32:	e9 03 f1 ff ff       	jmp    80106c3a <alltraps>

80107b37 <vector248>:
.globl vector248
vector248:
  pushl $0
80107b37:	6a 00                	push   $0x0
  pushl $248
80107b39:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107b3e:	e9 f7 f0 ff ff       	jmp    80106c3a <alltraps>

80107b43 <vector249>:
.globl vector249
vector249:
  pushl $0
80107b43:	6a 00                	push   $0x0
  pushl $249
80107b45:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80107b4a:	e9 eb f0 ff ff       	jmp    80106c3a <alltraps>

80107b4f <vector250>:
.globl vector250
vector250:
  pushl $0
80107b4f:	6a 00                	push   $0x0
  pushl $250
80107b51:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107b56:	e9 df f0 ff ff       	jmp    80106c3a <alltraps>

80107b5b <vector251>:
.globl vector251
vector251:
  pushl $0
80107b5b:	6a 00                	push   $0x0
  pushl $251
80107b5d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107b62:	e9 d3 f0 ff ff       	jmp    80106c3a <alltraps>

80107b67 <vector252>:
.globl vector252
vector252:
  pushl $0
80107b67:	6a 00                	push   $0x0
  pushl $252
80107b69:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107b6e:	e9 c7 f0 ff ff       	jmp    80106c3a <alltraps>

80107b73 <vector253>:
.globl vector253
vector253:
  pushl $0
80107b73:	6a 00                	push   $0x0
  pushl $253
80107b75:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107b7a:	e9 bb f0 ff ff       	jmp    80106c3a <alltraps>

80107b7f <vector254>:
.globl vector254
vector254:
  pushl $0
80107b7f:	6a 00                	push   $0x0
  pushl $254
80107b81:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107b86:	e9 af f0 ff ff       	jmp    80106c3a <alltraps>

80107b8b <vector255>:
.globl vector255
vector255:
  pushl $0
80107b8b:	6a 00                	push   $0x0
  pushl $255
80107b8d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107b92:	e9 a3 f0 ff ff       	jmp    80106c3a <alltraps>
80107b97:	66 90                	xchg   %ax,%ax
80107b99:	66 90                	xchg   %ax,%ax
80107b9b:	66 90                	xchg   %ax,%ax
80107b9d:	66 90                	xchg   %ax,%ax
80107b9f:	90                   	nop

80107ba0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107ba0:	55                   	push   %ebp
80107ba1:	89 e5                	mov    %esp,%ebp
80107ba3:	57                   	push   %edi
80107ba4:	56                   	push   %esi
80107ba5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80107ba6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80107bac:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107bb2:	83 ec 1c             	sub    $0x1c,%esp
80107bb5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107bb8:	39 d3                	cmp    %edx,%ebx
80107bba:	73 49                	jae    80107c05 <deallocuvm.part.0+0x65>
80107bbc:	89 c7                	mov    %eax,%edi
80107bbe:	eb 0c                	jmp    80107bcc <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107bc0:	83 c0 01             	add    $0x1,%eax
80107bc3:	c1 e0 16             	shl    $0x16,%eax
80107bc6:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
80107bc8:	39 da                	cmp    %ebx,%edx
80107bca:	76 39                	jbe    80107c05 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
80107bcc:	89 d8                	mov    %ebx,%eax
80107bce:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107bd1:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80107bd4:	f6 c1 01             	test   $0x1,%cl
80107bd7:	74 e7                	je     80107bc0 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80107bd9:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107bdb:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80107be1:	c1 ee 0a             	shr    $0xa,%esi
80107be4:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
80107bea:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
80107bf1:	85 f6                	test   %esi,%esi
80107bf3:	74 cb                	je     80107bc0 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80107bf5:	8b 06                	mov    (%esi),%eax
80107bf7:	a8 01                	test   $0x1,%al
80107bf9:	75 15                	jne    80107c10 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
80107bfb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107c01:	39 da                	cmp    %ebx,%edx
80107c03:	77 c7                	ja     80107bcc <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80107c05:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107c08:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107c0b:	5b                   	pop    %ebx
80107c0c:	5e                   	pop    %esi
80107c0d:	5f                   	pop    %edi
80107c0e:	5d                   	pop    %ebp
80107c0f:	c3                   	ret    
      if(pa == 0)
80107c10:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107c15:	74 25                	je     80107c3c <deallocuvm.part.0+0x9c>
      kfree(v);
80107c17:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80107c1a:	05 00 00 00 80       	add    $0x80000000,%eax
80107c1f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107c22:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80107c28:	50                   	push   %eax
80107c29:	e8 92 bc ff ff       	call   801038c0 <kfree>
      *pte = 0;
80107c2e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80107c34:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107c37:	83 c4 10             	add    $0x10,%esp
80107c3a:	eb 8c                	jmp    80107bc8 <deallocuvm.part.0+0x28>
        panic("kfree");
80107c3c:	83 ec 0c             	sub    $0xc,%esp
80107c3f:	68 56 88 10 80       	push   $0x80108856
80107c44:	e8 37 87 ff ff       	call   80100380 <panic>
80107c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107c50 <mappages>:
{
80107c50:	55                   	push   %ebp
80107c51:	89 e5                	mov    %esp,%ebp
80107c53:	57                   	push   %edi
80107c54:	56                   	push   %esi
80107c55:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80107c56:	89 d3                	mov    %edx,%ebx
80107c58:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80107c5e:	83 ec 1c             	sub    $0x1c,%esp
80107c61:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107c64:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107c68:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107c6d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107c70:	8b 45 08             	mov    0x8(%ebp),%eax
80107c73:	29 d8                	sub    %ebx,%eax
80107c75:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107c78:	eb 3d                	jmp    80107cb7 <mappages+0x67>
80107c7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107c80:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107c82:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107c87:	c1 ea 0a             	shr    $0xa,%edx
80107c8a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107c90:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107c97:	85 c0                	test   %eax,%eax
80107c99:	74 75                	je     80107d10 <mappages+0xc0>
    if(*pte & PTE_P)
80107c9b:	f6 00 01             	testb  $0x1,(%eax)
80107c9e:	0f 85 86 00 00 00    	jne    80107d2a <mappages+0xda>
    *pte = pa | perm | PTE_P;
80107ca4:	0b 75 0c             	or     0xc(%ebp),%esi
80107ca7:	83 ce 01             	or     $0x1,%esi
80107caa:	89 30                	mov    %esi,(%eax)
    if(a == last)
80107cac:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
80107caf:	74 6f                	je     80107d20 <mappages+0xd0>
    a += PGSIZE;
80107cb1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80107cb7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
80107cba:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107cbd:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80107cc0:	89 d8                	mov    %ebx,%eax
80107cc2:	c1 e8 16             	shr    $0x16,%eax
80107cc5:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80107cc8:	8b 07                	mov    (%edi),%eax
80107cca:	a8 01                	test   $0x1,%al
80107ccc:	75 b2                	jne    80107c80 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107cce:	e8 ad bd ff ff       	call   80103a80 <kalloc>
80107cd3:	85 c0                	test   %eax,%eax
80107cd5:	74 39                	je     80107d10 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80107cd7:	83 ec 04             	sub    $0x4,%esp
80107cda:	89 45 d8             	mov    %eax,-0x28(%ebp)
80107cdd:	68 00 10 00 00       	push   $0x1000
80107ce2:	6a 00                	push   $0x0
80107ce4:	50                   	push   %eax
80107ce5:	e8 76 dd ff ff       	call   80105a60 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107cea:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80107ced:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107cf0:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80107cf6:	83 c8 07             	or     $0x7,%eax
80107cf9:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80107cfb:	89 d8                	mov    %ebx,%eax
80107cfd:	c1 e8 0a             	shr    $0xa,%eax
80107d00:	25 fc 0f 00 00       	and    $0xffc,%eax
80107d05:	01 d0                	add    %edx,%eax
80107d07:	eb 92                	jmp    80107c9b <mappages+0x4b>
80107d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80107d10:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107d13:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107d18:	5b                   	pop    %ebx
80107d19:	5e                   	pop    %esi
80107d1a:	5f                   	pop    %edi
80107d1b:	5d                   	pop    %ebp
80107d1c:	c3                   	ret    
80107d1d:	8d 76 00             	lea    0x0(%esi),%esi
80107d20:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107d23:	31 c0                	xor    %eax,%eax
}
80107d25:	5b                   	pop    %ebx
80107d26:	5e                   	pop    %esi
80107d27:	5f                   	pop    %edi
80107d28:	5d                   	pop    %ebp
80107d29:	c3                   	ret    
      panic("remap");
80107d2a:	83 ec 0c             	sub    $0xc,%esp
80107d2d:	68 a8 8e 10 80       	push   $0x80108ea8
80107d32:	e8 49 86 ff ff       	call   80100380 <panic>
80107d37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107d3e:	66 90                	xchg   %ax,%ax

80107d40 <seginit>:
{
80107d40:	55                   	push   %ebp
80107d41:	89 e5                	mov    %esp,%ebp
80107d43:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107d46:	e8 05 d0 ff ff       	call   80104d50 <cpuid>
  pd[0] = size-1;
80107d4b:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107d50:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80107d56:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107d5a:	c7 80 98 2f 11 80 ff 	movl   $0xffff,-0x7feed068(%eax)
80107d61:	ff 00 00 
80107d64:	c7 80 9c 2f 11 80 00 	movl   $0xcf9a00,-0x7feed064(%eax)
80107d6b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107d6e:	c7 80 a0 2f 11 80 ff 	movl   $0xffff,-0x7feed060(%eax)
80107d75:	ff 00 00 
80107d78:	c7 80 a4 2f 11 80 00 	movl   $0xcf9200,-0x7feed05c(%eax)
80107d7f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107d82:	c7 80 a8 2f 11 80 ff 	movl   $0xffff,-0x7feed058(%eax)
80107d89:	ff 00 00 
80107d8c:	c7 80 ac 2f 11 80 00 	movl   $0xcffa00,-0x7feed054(%eax)
80107d93:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107d96:	c7 80 b0 2f 11 80 ff 	movl   $0xffff,-0x7feed050(%eax)
80107d9d:	ff 00 00 
80107da0:	c7 80 b4 2f 11 80 00 	movl   $0xcff200,-0x7feed04c(%eax)
80107da7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80107daa:	05 90 2f 11 80       	add    $0x80112f90,%eax
  pd[1] = (uint)p;
80107daf:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107db3:	c1 e8 10             	shr    $0x10,%eax
80107db6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80107dba:	8d 45 f2             	lea    -0xe(%ebp),%eax
80107dbd:	0f 01 10             	lgdtl  (%eax)
}
80107dc0:	c9                   	leave  
80107dc1:	c3                   	ret    
80107dc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107dd0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107dd0:	a1 44 5c 11 80       	mov    0x80115c44,%eax
80107dd5:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107dda:	0f 22 d8             	mov    %eax,%cr3
}
80107ddd:	c3                   	ret    
80107dde:	66 90                	xchg   %ax,%ax

80107de0 <switchuvm>:
{
80107de0:	55                   	push   %ebp
80107de1:	89 e5                	mov    %esp,%ebp
80107de3:	57                   	push   %edi
80107de4:	56                   	push   %esi
80107de5:	53                   	push   %ebx
80107de6:	83 ec 1c             	sub    $0x1c,%esp
80107de9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80107dec:	85 f6                	test   %esi,%esi
80107dee:	0f 84 cb 00 00 00    	je     80107ebf <switchuvm+0xdf>
  if(p->kstack == 0)
80107df4:	8b 46 08             	mov    0x8(%esi),%eax
80107df7:	85 c0                	test   %eax,%eax
80107df9:	0f 84 da 00 00 00    	je     80107ed9 <switchuvm+0xf9>
  if(p->pgdir == 0)
80107dff:	8b 46 04             	mov    0x4(%esi),%eax
80107e02:	85 c0                	test   %eax,%eax
80107e04:	0f 84 c2 00 00 00    	je     80107ecc <switchuvm+0xec>
  pushcli();
80107e0a:	e8 41 da ff ff       	call   80105850 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107e0f:	e8 dc ce ff ff       	call   80104cf0 <mycpu>
80107e14:	89 c3                	mov    %eax,%ebx
80107e16:	e8 d5 ce ff ff       	call   80104cf0 <mycpu>
80107e1b:	89 c7                	mov    %eax,%edi
80107e1d:	e8 ce ce ff ff       	call   80104cf0 <mycpu>
80107e22:	83 c7 08             	add    $0x8,%edi
80107e25:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107e28:	e8 c3 ce ff ff       	call   80104cf0 <mycpu>
80107e2d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107e30:	ba 67 00 00 00       	mov    $0x67,%edx
80107e35:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80107e3c:	83 c0 08             	add    $0x8,%eax
80107e3f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107e46:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107e4b:	83 c1 08             	add    $0x8,%ecx
80107e4e:	c1 e8 18             	shr    $0x18,%eax
80107e51:	c1 e9 10             	shr    $0x10,%ecx
80107e54:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80107e5a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107e60:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107e65:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107e6c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107e71:	e8 7a ce ff ff       	call   80104cf0 <mycpu>
80107e76:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107e7d:	e8 6e ce ff ff       	call   80104cf0 <mycpu>
80107e82:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107e86:	8b 5e 08             	mov    0x8(%esi),%ebx
80107e89:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107e8f:	e8 5c ce ff ff       	call   80104cf0 <mycpu>
80107e94:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107e97:	e8 54 ce ff ff       	call   80104cf0 <mycpu>
80107e9c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107ea0:	b8 28 00 00 00       	mov    $0x28,%eax
80107ea5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107ea8:	8b 46 04             	mov    0x4(%esi),%eax
80107eab:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107eb0:	0f 22 d8             	mov    %eax,%cr3
}
80107eb3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107eb6:	5b                   	pop    %ebx
80107eb7:	5e                   	pop    %esi
80107eb8:	5f                   	pop    %edi
80107eb9:	5d                   	pop    %ebp
  popcli();
80107eba:	e9 e1 d9 ff ff       	jmp    801058a0 <popcli>
    panic("switchuvm: no process");
80107ebf:	83 ec 0c             	sub    $0xc,%esp
80107ec2:	68 ae 8e 10 80       	push   $0x80108eae
80107ec7:	e8 b4 84 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
80107ecc:	83 ec 0c             	sub    $0xc,%esp
80107ecf:	68 d9 8e 10 80       	push   $0x80108ed9
80107ed4:	e8 a7 84 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80107ed9:	83 ec 0c             	sub    $0xc,%esp
80107edc:	68 c4 8e 10 80       	push   $0x80108ec4
80107ee1:	e8 9a 84 ff ff       	call   80100380 <panic>
80107ee6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107eed:	8d 76 00             	lea    0x0(%esi),%esi

80107ef0 <inituvm>:
{
80107ef0:	55                   	push   %ebp
80107ef1:	89 e5                	mov    %esp,%ebp
80107ef3:	57                   	push   %edi
80107ef4:	56                   	push   %esi
80107ef5:	53                   	push   %ebx
80107ef6:	83 ec 1c             	sub    $0x1c,%esp
80107ef9:	8b 45 0c             	mov    0xc(%ebp),%eax
80107efc:	8b 75 10             	mov    0x10(%ebp),%esi
80107eff:	8b 7d 08             	mov    0x8(%ebp),%edi
80107f02:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107f05:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107f0b:	77 4b                	ja     80107f58 <inituvm+0x68>
  mem = kalloc();
80107f0d:	e8 6e bb ff ff       	call   80103a80 <kalloc>
  memset(mem, 0, PGSIZE);
80107f12:	83 ec 04             	sub    $0x4,%esp
80107f15:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80107f1a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107f1c:	6a 00                	push   $0x0
80107f1e:	50                   	push   %eax
80107f1f:	e8 3c db ff ff       	call   80105a60 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107f24:	58                   	pop    %eax
80107f25:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107f2b:	5a                   	pop    %edx
80107f2c:	6a 06                	push   $0x6
80107f2e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107f33:	31 d2                	xor    %edx,%edx
80107f35:	50                   	push   %eax
80107f36:	89 f8                	mov    %edi,%eax
80107f38:	e8 13 fd ff ff       	call   80107c50 <mappages>
  memmove(mem, init, sz);
80107f3d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107f40:	89 75 10             	mov    %esi,0x10(%ebp)
80107f43:	83 c4 10             	add    $0x10,%esp
80107f46:	89 5d 08             	mov    %ebx,0x8(%ebp)
80107f49:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80107f4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107f4f:	5b                   	pop    %ebx
80107f50:	5e                   	pop    %esi
80107f51:	5f                   	pop    %edi
80107f52:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107f53:	e9 a8 db ff ff       	jmp    80105b00 <memmove>
    panic("inituvm: more than a page");
80107f58:	83 ec 0c             	sub    $0xc,%esp
80107f5b:	68 ed 8e 10 80       	push   $0x80108eed
80107f60:	e8 1b 84 ff ff       	call   80100380 <panic>
80107f65:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107f6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107f70 <loaduvm>:
{
80107f70:	55                   	push   %ebp
80107f71:	89 e5                	mov    %esp,%ebp
80107f73:	57                   	push   %edi
80107f74:	56                   	push   %esi
80107f75:	53                   	push   %ebx
80107f76:	83 ec 1c             	sub    $0x1c,%esp
80107f79:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f7c:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80107f7f:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107f84:	0f 85 bb 00 00 00    	jne    80108045 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
80107f8a:	01 f0                	add    %esi,%eax
80107f8c:	89 f3                	mov    %esi,%ebx
80107f8e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107f91:	8b 45 14             	mov    0x14(%ebp),%eax
80107f94:	01 f0                	add    %esi,%eax
80107f96:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80107f99:	85 f6                	test   %esi,%esi
80107f9b:	0f 84 87 00 00 00    	je     80108028 <loaduvm+0xb8>
80107fa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80107fa8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
80107fab:	8b 4d 08             	mov    0x8(%ebp),%ecx
80107fae:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80107fb0:	89 c2                	mov    %eax,%edx
80107fb2:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80107fb5:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80107fb8:	f6 c2 01             	test   $0x1,%dl
80107fbb:	75 13                	jne    80107fd0 <loaduvm+0x60>
      panic("loaduvm: address should exist");
80107fbd:	83 ec 0c             	sub    $0xc,%esp
80107fc0:	68 07 8f 10 80       	push   $0x80108f07
80107fc5:	e8 b6 83 ff ff       	call   80100380 <panic>
80107fca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107fd0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107fd3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107fd9:	25 fc 0f 00 00       	and    $0xffc,%eax
80107fde:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107fe5:	85 c0                	test   %eax,%eax
80107fe7:	74 d4                	je     80107fbd <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80107fe9:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107feb:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80107fee:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107ff3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107ff8:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80107ffe:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80108001:	29 d9                	sub    %ebx,%ecx
80108003:	05 00 00 00 80       	add    $0x80000000,%eax
80108008:	57                   	push   %edi
80108009:	51                   	push   %ecx
8010800a:	50                   	push   %eax
8010800b:	ff 75 10             	push   0x10(%ebp)
8010800e:	e8 7d ae ff ff       	call   80102e90 <readi>
80108013:	83 c4 10             	add    $0x10,%esp
80108016:	39 f8                	cmp    %edi,%eax
80108018:	75 1e                	jne    80108038 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
8010801a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80108020:	89 f0                	mov    %esi,%eax
80108022:	29 d8                	sub    %ebx,%eax
80108024:	39 c6                	cmp    %eax,%esi
80108026:	77 80                	ja     80107fa8 <loaduvm+0x38>
}
80108028:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010802b:	31 c0                	xor    %eax,%eax
}
8010802d:	5b                   	pop    %ebx
8010802e:	5e                   	pop    %esi
8010802f:	5f                   	pop    %edi
80108030:	5d                   	pop    %ebp
80108031:	c3                   	ret    
80108032:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80108038:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010803b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108040:	5b                   	pop    %ebx
80108041:	5e                   	pop    %esi
80108042:	5f                   	pop    %edi
80108043:	5d                   	pop    %ebp
80108044:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
80108045:	83 ec 0c             	sub    $0xc,%esp
80108048:	68 a8 8f 10 80       	push   $0x80108fa8
8010804d:	e8 2e 83 ff ff       	call   80100380 <panic>
80108052:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80108060 <allocuvm>:
{
80108060:	55                   	push   %ebp
80108061:	89 e5                	mov    %esp,%ebp
80108063:	57                   	push   %edi
80108064:	56                   	push   %esi
80108065:	53                   	push   %ebx
80108066:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80108069:	8b 45 10             	mov    0x10(%ebp),%eax
{
8010806c:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
8010806f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80108072:	85 c0                	test   %eax,%eax
80108074:	0f 88 b6 00 00 00    	js     80108130 <allocuvm+0xd0>
  if(newsz < oldsz)
8010807a:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
8010807d:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80108080:	0f 82 9a 00 00 00    	jb     80108120 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80108086:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
8010808c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80108092:	39 75 10             	cmp    %esi,0x10(%ebp)
80108095:	77 44                	ja     801080db <allocuvm+0x7b>
80108097:	e9 87 00 00 00       	jmp    80108123 <allocuvm+0xc3>
8010809c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
801080a0:	83 ec 04             	sub    $0x4,%esp
801080a3:	68 00 10 00 00       	push   $0x1000
801080a8:	6a 00                	push   $0x0
801080aa:	50                   	push   %eax
801080ab:	e8 b0 d9 ff ff       	call   80105a60 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801080b0:	58                   	pop    %eax
801080b1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801080b7:	5a                   	pop    %edx
801080b8:	6a 06                	push   $0x6
801080ba:	b9 00 10 00 00       	mov    $0x1000,%ecx
801080bf:	89 f2                	mov    %esi,%edx
801080c1:	50                   	push   %eax
801080c2:	89 f8                	mov    %edi,%eax
801080c4:	e8 87 fb ff ff       	call   80107c50 <mappages>
801080c9:	83 c4 10             	add    $0x10,%esp
801080cc:	85 c0                	test   %eax,%eax
801080ce:	78 78                	js     80108148 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
801080d0:	81 c6 00 10 00 00    	add    $0x1000,%esi
801080d6:	39 75 10             	cmp    %esi,0x10(%ebp)
801080d9:	76 48                	jbe    80108123 <allocuvm+0xc3>
    mem = kalloc();
801080db:	e8 a0 b9 ff ff       	call   80103a80 <kalloc>
801080e0:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
801080e2:	85 c0                	test   %eax,%eax
801080e4:	75 ba                	jne    801080a0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801080e6:	83 ec 0c             	sub    $0xc,%esp
801080e9:	68 25 8f 10 80       	push   $0x80108f25
801080ee:	e8 0d 86 ff ff       	call   80100700 <cprintf>
  if(newsz >= oldsz)
801080f3:	8b 45 0c             	mov    0xc(%ebp),%eax
801080f6:	83 c4 10             	add    $0x10,%esp
801080f9:	39 45 10             	cmp    %eax,0x10(%ebp)
801080fc:	74 32                	je     80108130 <allocuvm+0xd0>
801080fe:	8b 55 10             	mov    0x10(%ebp),%edx
80108101:	89 c1                	mov    %eax,%ecx
80108103:	89 f8                	mov    %edi,%eax
80108105:	e8 96 fa ff ff       	call   80107ba0 <deallocuvm.part.0>
      return 0;
8010810a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80108111:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108114:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108117:	5b                   	pop    %ebx
80108118:	5e                   	pop    %esi
80108119:	5f                   	pop    %edi
8010811a:	5d                   	pop    %ebp
8010811b:	c3                   	ret    
8010811c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80108120:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80108123:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108126:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108129:	5b                   	pop    %ebx
8010812a:	5e                   	pop    %esi
8010812b:	5f                   	pop    %edi
8010812c:	5d                   	pop    %ebp
8010812d:	c3                   	ret    
8010812e:	66 90                	xchg   %ax,%ax
    return 0;
80108130:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80108137:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010813a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010813d:	5b                   	pop    %ebx
8010813e:	5e                   	pop    %esi
8010813f:	5f                   	pop    %edi
80108140:	5d                   	pop    %ebp
80108141:	c3                   	ret    
80108142:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80108148:	83 ec 0c             	sub    $0xc,%esp
8010814b:	68 3d 8f 10 80       	push   $0x80108f3d
80108150:	e8 ab 85 ff ff       	call   80100700 <cprintf>
  if(newsz >= oldsz)
80108155:	8b 45 0c             	mov    0xc(%ebp),%eax
80108158:	83 c4 10             	add    $0x10,%esp
8010815b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010815e:	74 0c                	je     8010816c <allocuvm+0x10c>
80108160:	8b 55 10             	mov    0x10(%ebp),%edx
80108163:	89 c1                	mov    %eax,%ecx
80108165:	89 f8                	mov    %edi,%eax
80108167:	e8 34 fa ff ff       	call   80107ba0 <deallocuvm.part.0>
      kfree(mem);
8010816c:	83 ec 0c             	sub    $0xc,%esp
8010816f:	53                   	push   %ebx
80108170:	e8 4b b7 ff ff       	call   801038c0 <kfree>
      return 0;
80108175:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010817c:	83 c4 10             	add    $0x10,%esp
}
8010817f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108182:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108185:	5b                   	pop    %ebx
80108186:	5e                   	pop    %esi
80108187:	5f                   	pop    %edi
80108188:	5d                   	pop    %ebp
80108189:	c3                   	ret    
8010818a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108190 <deallocuvm>:
{
80108190:	55                   	push   %ebp
80108191:	89 e5                	mov    %esp,%ebp
80108193:	8b 55 0c             	mov    0xc(%ebp),%edx
80108196:	8b 4d 10             	mov    0x10(%ebp),%ecx
80108199:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010819c:	39 d1                	cmp    %edx,%ecx
8010819e:	73 10                	jae    801081b0 <deallocuvm+0x20>
}
801081a0:	5d                   	pop    %ebp
801081a1:	e9 fa f9 ff ff       	jmp    80107ba0 <deallocuvm.part.0>
801081a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801081ad:	8d 76 00             	lea    0x0(%esi),%esi
801081b0:	89 d0                	mov    %edx,%eax
801081b2:	5d                   	pop    %ebp
801081b3:	c3                   	ret    
801081b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801081bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801081bf:	90                   	nop

801081c0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801081c0:	55                   	push   %ebp
801081c1:	89 e5                	mov    %esp,%ebp
801081c3:	57                   	push   %edi
801081c4:	56                   	push   %esi
801081c5:	53                   	push   %ebx
801081c6:	83 ec 0c             	sub    $0xc,%esp
801081c9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801081cc:	85 f6                	test   %esi,%esi
801081ce:	74 59                	je     80108229 <freevm+0x69>
  if(newsz >= oldsz)
801081d0:	31 c9                	xor    %ecx,%ecx
801081d2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801081d7:	89 f0                	mov    %esi,%eax
801081d9:	89 f3                	mov    %esi,%ebx
801081db:	e8 c0 f9 ff ff       	call   80107ba0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801081e0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801081e6:	eb 0f                	jmp    801081f7 <freevm+0x37>
801081e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801081ef:	90                   	nop
801081f0:	83 c3 04             	add    $0x4,%ebx
801081f3:	39 df                	cmp    %ebx,%edi
801081f5:	74 23                	je     8010821a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801081f7:	8b 03                	mov    (%ebx),%eax
801081f9:	a8 01                	test   $0x1,%al
801081fb:	74 f3                	je     801081f0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801081fd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80108202:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80108205:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80108208:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010820d:	50                   	push   %eax
8010820e:	e8 ad b6 ff ff       	call   801038c0 <kfree>
80108213:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80108216:	39 df                	cmp    %ebx,%edi
80108218:	75 dd                	jne    801081f7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010821a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010821d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108220:	5b                   	pop    %ebx
80108221:	5e                   	pop    %esi
80108222:	5f                   	pop    %edi
80108223:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80108224:	e9 97 b6 ff ff       	jmp    801038c0 <kfree>
    panic("freevm: no pgdir");
80108229:	83 ec 0c             	sub    $0xc,%esp
8010822c:	68 59 8f 10 80       	push   $0x80108f59
80108231:	e8 4a 81 ff ff       	call   80100380 <panic>
80108236:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010823d:	8d 76 00             	lea    0x0(%esi),%esi

80108240 <setupkvm>:
{
80108240:	55                   	push   %ebp
80108241:	89 e5                	mov    %esp,%ebp
80108243:	56                   	push   %esi
80108244:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80108245:	e8 36 b8 ff ff       	call   80103a80 <kalloc>
8010824a:	89 c6                	mov    %eax,%esi
8010824c:	85 c0                	test   %eax,%eax
8010824e:	74 42                	je     80108292 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80108250:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108253:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80108258:	68 00 10 00 00       	push   $0x1000
8010825d:	6a 00                	push   $0x0
8010825f:	50                   	push   %eax
80108260:	e8 fb d7 ff ff       	call   80105a60 <memset>
80108265:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80108268:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010826b:	83 ec 08             	sub    $0x8,%esp
8010826e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80108271:	ff 73 0c             	push   0xc(%ebx)
80108274:	8b 13                	mov    (%ebx),%edx
80108276:	50                   	push   %eax
80108277:	29 c1                	sub    %eax,%ecx
80108279:	89 f0                	mov    %esi,%eax
8010827b:	e8 d0 f9 ff ff       	call   80107c50 <mappages>
80108280:	83 c4 10             	add    $0x10,%esp
80108283:	85 c0                	test   %eax,%eax
80108285:	78 19                	js     801082a0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108287:	83 c3 10             	add    $0x10,%ebx
8010828a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80108290:	75 d6                	jne    80108268 <setupkvm+0x28>
}
80108292:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108295:	89 f0                	mov    %esi,%eax
80108297:	5b                   	pop    %ebx
80108298:	5e                   	pop    %esi
80108299:	5d                   	pop    %ebp
8010829a:	c3                   	ret    
8010829b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010829f:	90                   	nop
      freevm(pgdir);
801082a0:	83 ec 0c             	sub    $0xc,%esp
801082a3:	56                   	push   %esi
      return 0;
801082a4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801082a6:	e8 15 ff ff ff       	call   801081c0 <freevm>
      return 0;
801082ab:	83 c4 10             	add    $0x10,%esp
}
801082ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801082b1:	89 f0                	mov    %esi,%eax
801082b3:	5b                   	pop    %ebx
801082b4:	5e                   	pop    %esi
801082b5:	5d                   	pop    %ebp
801082b6:	c3                   	ret    
801082b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801082be:	66 90                	xchg   %ax,%ax

801082c0 <kvmalloc>:
{
801082c0:	55                   	push   %ebp
801082c1:	89 e5                	mov    %esp,%ebp
801082c3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801082c6:	e8 75 ff ff ff       	call   80108240 <setupkvm>
801082cb:	a3 44 5c 11 80       	mov    %eax,0x80115c44
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801082d0:	05 00 00 00 80       	add    $0x80000000,%eax
801082d5:	0f 22 d8             	mov    %eax,%cr3
}
801082d8:	c9                   	leave  
801082d9:	c3                   	ret    
801082da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801082e0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801082e0:	55                   	push   %ebp
801082e1:	89 e5                	mov    %esp,%ebp
801082e3:	83 ec 08             	sub    $0x8,%esp
801082e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801082e9:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801082ec:	89 c1                	mov    %eax,%ecx
801082ee:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801082f1:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801082f4:	f6 c2 01             	test   $0x1,%dl
801082f7:	75 17                	jne    80108310 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
801082f9:	83 ec 0c             	sub    $0xc,%esp
801082fc:	68 6a 8f 10 80       	push   $0x80108f6a
80108301:	e8 7a 80 ff ff       	call   80100380 <panic>
80108306:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010830d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80108310:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80108313:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80108319:	25 fc 0f 00 00       	and    $0xffc,%eax
8010831e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80108325:	85 c0                	test   %eax,%eax
80108327:	74 d0                	je     801082f9 <clearpteu+0x19>
  *pte &= ~PTE_U;
80108329:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010832c:	c9                   	leave  
8010832d:	c3                   	ret    
8010832e:	66 90                	xchg   %ax,%ax

80108330 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108330:	55                   	push   %ebp
80108331:	89 e5                	mov    %esp,%ebp
80108333:	57                   	push   %edi
80108334:	56                   	push   %esi
80108335:	53                   	push   %ebx
80108336:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80108339:	e8 02 ff ff ff       	call   80108240 <setupkvm>
8010833e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108341:	85 c0                	test   %eax,%eax
80108343:	0f 84 bd 00 00 00    	je     80108406 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80108349:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010834c:	85 c9                	test   %ecx,%ecx
8010834e:	0f 84 b2 00 00 00    	je     80108406 <copyuvm+0xd6>
80108354:	31 f6                	xor    %esi,%esi
80108356:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010835d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
80108360:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80108363:	89 f0                	mov    %esi,%eax
80108365:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80108368:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010836b:	a8 01                	test   $0x1,%al
8010836d:	75 11                	jne    80108380 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010836f:	83 ec 0c             	sub    $0xc,%esp
80108372:	68 74 8f 10 80       	push   $0x80108f74
80108377:	e8 04 80 ff ff       	call   80100380 <panic>
8010837c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80108380:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80108382:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80108387:	c1 ea 0a             	shr    $0xa,%edx
8010838a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80108390:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108397:	85 c0                	test   %eax,%eax
80108399:	74 d4                	je     8010836f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010839b:	8b 00                	mov    (%eax),%eax
8010839d:	a8 01                	test   $0x1,%al
8010839f:	0f 84 9f 00 00 00    	je     80108444 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801083a5:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
801083a7:	25 ff 0f 00 00       	and    $0xfff,%eax
801083ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
801083af:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
801083b5:	e8 c6 b6 ff ff       	call   80103a80 <kalloc>
801083ba:	89 c3                	mov    %eax,%ebx
801083bc:	85 c0                	test   %eax,%eax
801083be:	74 64                	je     80108424 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801083c0:	83 ec 04             	sub    $0x4,%esp
801083c3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801083c9:	68 00 10 00 00       	push   $0x1000
801083ce:	57                   	push   %edi
801083cf:	50                   	push   %eax
801083d0:	e8 2b d7 ff ff       	call   80105b00 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801083d5:	58                   	pop    %eax
801083d6:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801083dc:	5a                   	pop    %edx
801083dd:	ff 75 e4             	push   -0x1c(%ebp)
801083e0:	b9 00 10 00 00       	mov    $0x1000,%ecx
801083e5:	89 f2                	mov    %esi,%edx
801083e7:	50                   	push   %eax
801083e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801083eb:	e8 60 f8 ff ff       	call   80107c50 <mappages>
801083f0:	83 c4 10             	add    $0x10,%esp
801083f3:	85 c0                	test   %eax,%eax
801083f5:	78 21                	js     80108418 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
801083f7:	81 c6 00 10 00 00    	add    $0x1000,%esi
801083fd:	39 75 0c             	cmp    %esi,0xc(%ebp)
80108400:	0f 87 5a ff ff ff    	ja     80108360 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80108406:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108409:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010840c:	5b                   	pop    %ebx
8010840d:	5e                   	pop    %esi
8010840e:	5f                   	pop    %edi
8010840f:	5d                   	pop    %ebp
80108410:	c3                   	ret    
80108411:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80108418:	83 ec 0c             	sub    $0xc,%esp
8010841b:	53                   	push   %ebx
8010841c:	e8 9f b4 ff ff       	call   801038c0 <kfree>
      goto bad;
80108421:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80108424:	83 ec 0c             	sub    $0xc,%esp
80108427:	ff 75 e0             	push   -0x20(%ebp)
8010842a:	e8 91 fd ff ff       	call   801081c0 <freevm>
  return 0;
8010842f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80108436:	83 c4 10             	add    $0x10,%esp
}
80108439:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010843c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010843f:	5b                   	pop    %ebx
80108440:	5e                   	pop    %esi
80108441:	5f                   	pop    %edi
80108442:	5d                   	pop    %ebp
80108443:	c3                   	ret    
      panic("copyuvm: page not present");
80108444:	83 ec 0c             	sub    $0xc,%esp
80108447:	68 8e 8f 10 80       	push   $0x80108f8e
8010844c:	e8 2f 7f ff ff       	call   80100380 <panic>
80108451:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108458:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010845f:	90                   	nop

80108460 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108460:	55                   	push   %ebp
80108461:	89 e5                	mov    %esp,%ebp
80108463:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80108466:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80108469:	89 c1                	mov    %eax,%ecx
8010846b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010846e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80108471:	f6 c2 01             	test   $0x1,%dl
80108474:	0f 84 00 01 00 00    	je     8010857a <uva2ka.cold>
  return &pgtab[PTX(va)];
8010847a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010847d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80108483:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80108484:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80108489:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
80108490:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80108492:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80108497:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010849a:	05 00 00 00 80       	add    $0x80000000,%eax
8010849f:	83 fa 05             	cmp    $0x5,%edx
801084a2:	ba 00 00 00 00       	mov    $0x0,%edx
801084a7:	0f 45 c2             	cmovne %edx,%eax
}
801084aa:	c3                   	ret    
801084ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801084af:	90                   	nop

801084b0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801084b0:	55                   	push   %ebp
801084b1:	89 e5                	mov    %esp,%ebp
801084b3:	57                   	push   %edi
801084b4:	56                   	push   %esi
801084b5:	53                   	push   %ebx
801084b6:	83 ec 0c             	sub    $0xc,%esp
801084b9:	8b 75 14             	mov    0x14(%ebp),%esi
801084bc:	8b 45 0c             	mov    0xc(%ebp),%eax
801084bf:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801084c2:	85 f6                	test   %esi,%esi
801084c4:	75 51                	jne    80108517 <copyout+0x67>
801084c6:	e9 a5 00 00 00       	jmp    80108570 <copyout+0xc0>
801084cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801084cf:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
801084d0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801084d6:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
801084dc:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
801084e2:	74 75                	je     80108559 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
801084e4:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801084e6:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
801084e9:	29 c3                	sub    %eax,%ebx
801084eb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801084f1:	39 f3                	cmp    %esi,%ebx
801084f3:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
801084f6:	29 f8                	sub    %edi,%eax
801084f8:	83 ec 04             	sub    $0x4,%esp
801084fb:	01 c1                	add    %eax,%ecx
801084fd:	53                   	push   %ebx
801084fe:	52                   	push   %edx
801084ff:	51                   	push   %ecx
80108500:	e8 fb d5 ff ff       	call   80105b00 <memmove>
    len -= n;
    buf += n;
80108505:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80108508:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
8010850e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80108511:	01 da                	add    %ebx,%edx
  while(len > 0){
80108513:	29 de                	sub    %ebx,%esi
80108515:	74 59                	je     80108570 <copyout+0xc0>
  if(*pde & PTE_P){
80108517:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010851a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010851c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010851e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80108521:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80108527:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
8010852a:	f6 c1 01             	test   $0x1,%cl
8010852d:	0f 84 4e 00 00 00    	je     80108581 <copyout.cold>
  return &pgtab[PTX(va)];
80108533:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80108535:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
8010853b:	c1 eb 0c             	shr    $0xc,%ebx
8010853e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80108544:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
8010854b:	89 d9                	mov    %ebx,%ecx
8010854d:	83 e1 05             	and    $0x5,%ecx
80108550:	83 f9 05             	cmp    $0x5,%ecx
80108553:	0f 84 77 ff ff ff    	je     801084d0 <copyout+0x20>
  }
  return 0;
}
80108559:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010855c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108561:	5b                   	pop    %ebx
80108562:	5e                   	pop    %esi
80108563:	5f                   	pop    %edi
80108564:	5d                   	pop    %ebp
80108565:	c3                   	ret    
80108566:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010856d:	8d 76 00             	lea    0x0(%esi),%esi
80108570:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80108573:	31 c0                	xor    %eax,%eax
}
80108575:	5b                   	pop    %ebx
80108576:	5e                   	pop    %esi
80108577:	5f                   	pop    %edi
80108578:	5d                   	pop    %ebp
80108579:	c3                   	ret    

8010857a <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
8010857a:	a1 00 00 00 00       	mov    0x0,%eax
8010857f:	0f 0b                	ud2    

80108581 <copyout.cold>:
80108581:	a1 00 00 00 00       	mov    0x0,%eax
80108586:	0f 0b                	ud2    
