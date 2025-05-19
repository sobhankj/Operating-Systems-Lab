
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
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
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
80100028:	bc 50 97 11 80       	mov    $0x80119750,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 70 44 10 80       	mov    $0x80104470,%eax
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
80100044:	bb 54 c5 10 80       	mov    $0x8010c554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 00 8c 10 80       	push   $0x80108c00
80100051:	68 20 c5 10 80       	push   $0x8010c520
80100056:	e8 35 5a 00 00       	call   80105a90 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c 0c 11 80       	mov    $0x80110c1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c 0c 11 80 1c 	movl   $0x80110c1c,0x80110c6c
8010006a:	0c 11 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 0c 11 80 1c 	movl   $0x80110c1c,0x80110c70
80100074:	0c 11 80 
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
8010008b:	c7 43 50 1c 0c 11 80 	movl   $0x80110c1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 07 8c 10 80       	push   $0x80108c07
80100097:	50                   	push   %eax
80100098:	e8 c3 58 00 00       	call   80105960 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 0c 11 80       	mov    0x80110c70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 0c 11 80    	mov    %ebx,0x80110c70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 09 11 80    	cmp    $0x801109c0,%ebx
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
801000df:	68 20 c5 10 80       	push   $0x8010c520
801000e4:	e8 77 5b 00 00       	call   80105c60 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 0c 11 80    	mov    0x80110c70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c 0c 11 80    	cmp    $0x80110c1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c 0c 11 80    	cmp    $0x80110c1c,%ebx
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
80100120:	8b 1d 6c 0c 11 80    	mov    0x80110c6c,%ebx
80100126:	81 fb 1c 0c 11 80    	cmp    $0x80110c1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c 0c 11 80    	cmp    $0x80110c1c,%ebx
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
8010015d:	68 20 c5 10 80       	push   $0x8010c520
80100162:	e8 99 5a 00 00       	call   80105c00 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 2e 58 00 00       	call   801059a0 <acquiresleep>
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
8010018c:	e8 5f 35 00 00       	call   801036f0 <iderw>
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
801001a1:	68 0e 8c 10 80       	push   $0x80108c0e
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
801001be:	e8 7d 58 00 00       	call   80105a40 <holdingsleep>
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
801001d4:	e9 17 35 00 00       	jmp    801036f0 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 1f 8c 10 80       	push   $0x80108c1f
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
801001ff:	e8 3c 58 00 00       	call   80105a40 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 ec 57 00 00       	call   80105a00 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
8010021b:	e8 40 5a 00 00       	call   80105c60 <acquire>
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
80100242:	a1 70 0c 11 80       	mov    0x80110c70,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 1c 0c 11 80 	movl   $0x80110c1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 70 0c 11 80       	mov    0x80110c70,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 70 0c 11 80    	mov    %ebx,0x80110c70
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 20 c5 10 80 	movl   $0x8010c520,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 8f 59 00 00       	jmp    80105c00 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 26 8c 10 80       	push   $0x80108c26
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
80100294:	e8 d7 29 00 00       	call   80102c70 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 80 16 11 80 	movl   $0x80111680,(%esp)
801002a0:	e8 bb 59 00 00       	call   80105c60 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 c0 15 11 80       	mov    0x801115c0,%eax
801002b5:	3b 05 c4 15 11 80    	cmp    0x801115c4,%eax
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
801002c3:	68 80 16 11 80       	push   $0x80111680
801002c8:	68 c0 15 11 80       	push   $0x801115c0
801002cd:	e8 9e 51 00 00       	call   80105470 <sleep>
    while(input.r == input.w){
801002d2:	a1 c0 15 11 80       	mov    0x801115c0,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 c4 15 11 80    	cmp    0x801115c4,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 b9 4a 00 00       	call   80104da0 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 80 16 11 80       	push   $0x80111680
801002f6:	e8 05 59 00 00       	call   80105c00 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 8c 28 00 00       	call   80102b90 <ilock>
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
8010031b:	89 15 c0 15 11 80    	mov    %edx,0x801115c0
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 40 15 11 80 	movsbl -0x7feeeac0(%edx),%ecx
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
80100347:	68 80 16 11 80       	push   $0x80111680
8010034c:	e8 af 58 00 00       	call   80105c00 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 36 28 00 00       	call   80102b90 <ilock>
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
8010036d:	a3 c0 15 11 80       	mov    %eax,0x801115c0
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
80100389:	c7 05 b4 16 11 80 00 	movl   $0x0,0x801116b4
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 62 39 00 00       	call   80103d00 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 2d 8c 10 80       	push   $0x80108c2d
801003a7:	e8 54 03 00 00       	call   80100700 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 4b 03 00 00       	call   80100700 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 97 96 10 80 	movl   $0x80109697,(%esp)
801003bc:	e8 3f 03 00 00       	call   80100700 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 e3 56 00 00       	call   80105ab0 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 41 8c 10 80       	push   $0x80108c41
801003dd:	e8 1e 03 00 00       	call   80100700 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 b8 16 11 80 01 	movl   $0x1,0x801116b8
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
8010041a:	e8 f1 72 00 00       	call   80107710 <uartputc>
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
80100456:	8b 3d c4 16 11 80    	mov    0x801116c4,%edi
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
801004ba:	8b 3d c4 16 11 80    	mov    0x801116c4,%edi
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
80100565:	e8 a6 71 00 00       	call   80107710 <uartputc>
8010056a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100571:	e8 9a 71 00 00       	call   80107710 <uartputc>
80100576:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010057d:	e8 8e 71 00 00       	call   80107710 <uartputc>
80100582:	83 c4 10             	add    $0x10,%esp
80100585:	e9 98 fe ff ff       	jmp    80100422 <consputc.part.0+0x22>
8010058a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100590:	83 ec 04             	sub    $0x4,%esp
80100593:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80100596:	68 60 0e 00 00       	push   $0xe60
8010059b:	68 a0 80 0b 80       	push   $0x800b80a0
801005a0:	68 00 80 0b 80       	push   $0x800b8000
801005a5:	e8 16 58 00 00       	call   80105dc0 <memmove>
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
801005c9:	e8 52 57 00 00       	call   80105d20 <memset>
  crt[pos + num_of_left_pressed] = ' ' | 0x0700;
801005ce:	c6 45 e4 07          	movb   $0x7,-0x1c(%ebp)
801005d2:	03 3d c4 16 11 80    	add    0x801116c4,%edi
801005d8:	83 c4 10             	add    $0x10,%esp
801005db:	e9 e7 fe ff ff       	jmp    801004c7 <consputc.part.0+0xc7>
    panic("pos under/overflow");
801005e0:	83 ec 0c             	sub    $0xc,%esp
801005e3:	68 45 8c 10 80       	push   $0x80108c45
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
801005ff:	e8 6c 26 00 00       	call   80102c70 <iunlock>
  acquire(&cons.lock);
80100604:	c7 04 24 80 16 11 80 	movl   $0x80111680,(%esp)
8010060b:	e8 50 56 00 00       	call   80105c60 <acquire>
  for(i = 0; i < n; i++)
80100610:	83 c4 10             	add    $0x10,%esp
80100613:	85 f6                	test   %esi,%esi
80100615:	7e 25                	jle    8010063c <consolewrite+0x4c>
80100617:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010061a:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
8010061d:	8b 15 b8 16 11 80    	mov    0x801116b8,%edx
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
8010063f:	68 80 16 11 80       	push   $0x80111680
80100644:	e8 b7 55 00 00       	call   80105c00 <release>
  ilock(ip);
80100649:	58                   	pop    %eax
8010064a:	ff 75 08             	push   0x8(%ebp)
8010064d:	e8 3e 25 00 00       	call   80102b90 <ilock>
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
80100696:	0f b6 92 bc 8c 10 80 	movzbl -0x7fef7344(%edx),%edx
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
801006c2:	8b 15 b8 16 11 80    	mov    0x801116b8,%edx
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
80100709:	a1 b4 16 11 80       	mov    0x801116b4,%eax
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
801007c0:	8b 15 b8 16 11 80    	mov    0x801116b8,%edx
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
80100808:	8b 0d b8 16 11 80    	mov    0x801116b8,%ecx
8010080e:	85 c9                	test   %ecx,%ecx
80100810:	74 14                	je     80100826 <cprintf+0x126>
80100812:	fa                   	cli    
    for(;;)
80100813:	eb fe                	jmp    80100813 <cprintf+0x113>
80100815:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
80100818:	a1 b8 16 11 80       	mov    0x801116b8,%eax
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
80100843:	68 80 16 11 80       	push   $0x80111680
80100848:	e8 13 54 00 00       	call   80105c60 <acquire>
8010084d:	83 c4 10             	add    $0x10,%esp
80100850:	e9 c4 fe ff ff       	jmp    80100719 <cprintf+0x19>
  if(panicked){
80100855:	8b 0d b8 16 11 80    	mov    0x801116b8,%ecx
8010085b:	85 c9                	test   %ecx,%ecx
8010085d:	75 31                	jne    80100890 <cprintf+0x190>
8010085f:	b8 25 00 00 00       	mov    $0x25,%eax
80100864:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100867:	e8 94 fb ff ff       	call   80100400 <consputc.part.0>
8010086c:	8b 15 b8 16 11 80    	mov    0x801116b8,%edx
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
80100898:	bf 58 8c 10 80       	mov    $0x80108c58,%edi
      for(; *s; s++)
8010089d:	b8 28 00 00 00       	mov    $0x28,%eax
801008a2:	e9 19 ff ff ff       	jmp    801007c0 <cprintf+0xc0>
801008a7:	89 d0                	mov    %edx,%eax
801008a9:	e8 52 fb ff ff       	call   80100400 <consputc.part.0>
801008ae:	e9 c8 fe ff ff       	jmp    8010077b <cprintf+0x7b>
    release(&cons.lock);
801008b3:	83 ec 0c             	sub    $0xc,%esp
801008b6:	68 80 16 11 80       	push   $0x80111680
801008bb:	e8 40 53 00 00       	call   80105c00 <release>
801008c0:	83 c4 10             	add    $0x10,%esp
}
801008c3:	e9 c9 fe ff ff       	jmp    80100791 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
801008c8:	8b 7d e0             	mov    -0x20(%ebp),%edi
801008cb:	e9 ab fe ff ff       	jmp    8010077b <cprintf+0x7b>
    panic("null fmt");
801008d0:	83 ec 0c             	sub    $0xc,%esp
801008d3:	68 5f 8c 10 80       	push   $0x80108c5f
801008d8:	e8 a3 fa ff ff       	call   80100380 <panic>
801008dd:	8d 76 00             	lea    0x0(%esi),%esi

801008e0 <shift_back>:
void shift_back(int pos){
801008e0:	55                   	push   %ebp
  for(int i = pos-1; i < pos + num_of_left_pressed; i++){
801008e1:	8b 0d c4 16 11 80    	mov    0x801116c4,%ecx
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
80100921:	a1 c4 16 11 80       	mov    0x801116c4,%eax
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
80100960:	ba 98 14 11 80       	mov    $0x80111498,%edx
    if(input.buf[i - 1] != '\n'){
80100965:	83 eb 01             	sub    $0x1,%ebx
80100968:	80 bb 40 15 11 80 0a 	cmpb   $0xa,-0x7feeeac0(%ebx)
8010096f:	74 1e                	je     8010098f <show_current_history+0x3f>
  if(panicked){
80100971:	8b 0d b8 16 11 80    	mov    0x801116b8,%ecx
80100977:	85 c9                	test   %ecx,%ecx
80100979:	74 05                	je     80100980 <show_current_history+0x30>
8010097b:	fa                   	cli    
    for(;;)
8010097c:	eb fe                	jmp    8010097c <show_current_history+0x2c>
8010097e:	66 90                	xchg   %ax,%ax
80100980:	b8 00 01 00 00       	mov    $0x100,%eax
80100985:	e8 76 fa ff ff       	call   80100400 <consputc.part.0>
8010098a:	ba 98 14 11 80       	mov    $0x80111498,%edx
  input = history_cmnd.current_command;
8010098f:	b9 23 00 00 00       	mov    $0x23,%ecx
80100994:	bf 40 15 11 80       	mov    $0x80111540,%edi
80100999:	89 d6                	mov    %edx,%esi
8010099b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(int i = temp; i > 0; i--){
8010099d:	85 db                	test   %ebx,%ebx
8010099f:	75 c4                	jne    80100965 <show_current_history+0x15>
  for(int j = input.w; j < input.e; j++){
801009a1:	8b 1d c4 15 11 80    	mov    0x801115c4,%ebx
801009a7:	3b 1d c8 15 11 80    	cmp    0x801115c8,%ebx
801009ad:	73 29                	jae    801009d8 <show_current_history+0x88>
  if(panicked){
801009af:	8b 15 b8 16 11 80    	mov    0x801116b8,%edx
        consputc(input.buf[j]);
801009b5:	0f be 83 40 15 11 80 	movsbl -0x7feeeac0(%ebx),%eax
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
801009d0:	39 1d c8 15 11 80    	cmp    %ebx,0x801115c8
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
801009e1:	8b 15 c4 15 11 80    	mov    0x801115c4,%edx
  for(int i = 0; i < 8; i++){
801009e7:	31 c0                	xor    %eax,%eax
int is_history(char* command){
801009e9:	89 e5                	mov    %esp,%ebp
801009eb:	53                   	push   %ebx
801009ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
801009ef:	90                   	nop
    if(command[i] != input.buf[i + input.w]){
801009f0:	0f b6 9c 02 40 15 11 	movzbl -0x7feeeac0(%edx,%eax,1),%ebx
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
80100a29:	68 80 16 11 80       	push   $0x80111680
80100a2e:	e8 cd 51 00 00       	call   80105c00 <release>
  for(int i = 0; i < history_cmnd.num_of_cmnd; i++){
80100a33:	8b 0d 24 15 11 80    	mov    0x80111524,%ecx
80100a39:	83 c4 10             	add    $0x10,%esp
80100a3c:	85 c9                	test   %ecx,%ecx
80100a3e:	7e 6a                	jle    80100aaa <print_history+0x8a>
80100a40:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100a47:	bb 20 0f 11 80       	mov    $0x80110f20,%ebx
80100a4c:	ba 40 15 11 80       	mov    $0x80111540,%edx
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
80100a6a:	8b 15 b8 16 11 80    	mov    0x801116b8,%edx
        consputc(input.buf[j]);
80100a70:	0f be 86 40 15 11 80 	movsbl -0x7feeeac0(%esi),%eax
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
80100a8e:	ba 40 15 11 80       	mov    $0x80111540,%edx
80100a93:	77 d5                	ja     80100a6a <print_history+0x4a>
  for(int i = 0; i < history_cmnd.num_of_cmnd; i++){
80100a95:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100a99:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
80100a9f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100aa2:	39 05 24 15 11 80    	cmp    %eax,0x80111524
80100aa8:	7f a7                	jg     80100a51 <print_history+0x31>
  acquire(&cons.lock);
80100aaa:	83 ec 0c             	sub    $0xc,%esp
80100aad:	68 80 16 11 80       	push   $0x80111680
80100ab2:	e8 a9 51 00 00       	call   80105c60 <acquire>
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
80100ad1:	a1 c8 15 11 80       	mov    0x801115c8,%eax
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
80100af0:	0f b6 90 40 15 11 80 	movzbl -0x7feeeac0(%eax),%edx
80100af7:	88 94 03 40 15 11 80 	mov    %dl,-0x7feeeac0(%ebx,%eax,1)
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
80100b19:	a1 d4 15 11 80       	mov    0x801115d4,%eax
80100b1e:	85 c0                	test   %eax,%eax
80100b20:	7e 2f                	jle    80100b51 <print_copied_command+0x41>
80100b22:	31 db                	xor    %ebx,%ebx
  if(panicked){
80100b24:	8b 15 b8 16 11 80    	mov    0x801116b8,%edx
    consputc(coppied_input[i]);
80100b2a:	0f be 83 e0 15 11 80 	movsbl -0x7feeea20(%ebx),%eax
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
80100b45:	a1 d4 15 11 80       	mov    0x801115d4,%eax
80100b4a:	83 c3 01             	add    $0x1,%ebx
80100b4d:	39 d8                	cmp    %ebx,%eax
80100b4f:	7f d3                	jg     80100b24 <print_copied_command+0x14>
  if(num_of_left_pressed > 0){
80100b51:	8b 35 c4 16 11 80    	mov    0x801116c4,%esi
    handle_shifting(cur_index, input.e - num_of_left_pressed);
80100b57:	8b 1d c8 15 11 80    	mov    0x801115c8,%ebx
  if(num_of_left_pressed > 0){
80100b5d:	85 f6                	test   %esi,%esi
80100b5f:	7f 3d                	jg     80100b9e <print_copied_command+0x8e>
  for(int i = 0; coppied_input[i] != '\0'; i++){
80100b61:	0f b6 15 e0 15 11 80 	movzbl 0x801115e0,%edx
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
80100b78:	88 94 07 40 15 11 80 	mov    %dl,-0x7feeeac0(%edi,%eax,1)
    input.e++;
80100b7f:	8d 0c 03             	lea    (%ebx,%eax,1),%ecx
  for(int i = 0; coppied_input[i] != '\0'; i++){
80100b82:	83 c0 01             	add    $0x1,%eax
80100b85:	0f b6 90 e0 15 11 80 	movzbl -0x7feeea20(%eax),%edx
80100b8c:	84 d2                	test   %dl,%dl
80100b8e:	75 e8                	jne    80100b78 <print_copied_command+0x68>
80100b90:	89 0d c8 15 11 80    	mov    %ecx,0x801115c8
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
80100ba9:	0f b6 8a 40 15 11 80 	movzbl -0x7feeeac0(%edx),%ecx
80100bb0:	88 8c 10 40 15 11 80 	mov    %cl,-0x7feeeac0(%eax,%edx,1)
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
80100bc6:	a1 c8 15 11 80       	mov    0x801115c8,%eax
  memset(coppied_input, '\0', sizeof(coppied_input));
80100bcb:	68 80 00 00 00       	push   $0x80
80100bd0:	6a 00                	push   $0x0
80100bd2:	68 e0 15 11 80       	push   $0x801115e0
  start_ctrl_s = input.e;
80100bd7:	a3 bc 16 11 80       	mov    %eax,0x801116bc
  memset(coppied_input, '\0', sizeof(coppied_input));
80100bdc:	e8 3f 51 00 00       	call   80105d20 <memset>
}
80100be1:	83 c4 10             	add    $0x10,%esp
80100be4:	c9                   	leave  
80100be5:	c3                   	ret    
80100be6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100bed:	8d 76 00             	lea    0x0(%esi),%esi

80100bf0 <handle_ctrl_f>:
  if(ctrl_s_pressed){
80100bf0:	a1 c0 16 11 80       	mov    0x801116c0,%eax
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
80100c11:	8b 0d c8 15 11 80    	mov    0x801115c8,%ecx
void update_coppied_commands(){
80100c17:	89 e5                	mov    %esp,%ebp
80100c19:	57                   	push   %edi
80100c1a:	56                   	push   %esi
80100c1b:	53                   	push   %ebx
  for(int i = start_ctrl_s; i < input.e; i++){
80100c1c:	8b 1d bc 16 11 80    	mov    0x801116bc,%ebx
80100c22:	39 d9                	cmp    %ebx,%ecx
80100c24:	76 41                	jbe    80100c67 <update_coppied_commands+0x57>
80100c26:	89 cf                	mov    %ecx,%edi
80100c28:	8b 15 08 0f 11 80    	mov    0x80110f08,%edx
80100c2e:	31 c0                	xor    %eax,%eax
80100c30:	31 f6                	xor    %esi,%esi
80100c32:	29 df                	sub    %ebx,%edi
80100c34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(copied_command.e < INPUT_BUF){
80100c38:	83 fa 7f             	cmp    $0x7f,%edx
80100c3b:	77 17                	ja     80100c54 <update_coppied_commands+0x44>
      copied_command.buf[copied_command.e + (i - start_ctrl_s)] = input.buf[i];
80100c3d:	0f b6 8c 03 40 15 11 	movzbl -0x7feeeac0(%ebx,%eax,1),%ecx
80100c44:	80 
      copied_command.e++;
80100c45:	be 01 00 00 00       	mov    $0x1,%esi
      copied_command.buf[copied_command.e + (i - start_ctrl_s)] = input.buf[i];
80100c4a:	88 8c 10 80 0e 11 80 	mov    %cl,-0x7feef180(%eax,%edx,1)
      copied_command.e++;
80100c51:	83 c2 01             	add    $0x1,%edx
  for(int i = start_ctrl_s; i < input.e; i++){
80100c54:	83 c0 01             	add    $0x1,%eax
80100c57:	39 f8                	cmp    %edi,%eax
80100c59:	75 dd                	jne    80100c38 <update_coppied_commands+0x28>
80100c5b:	89 f0                	mov    %esi,%eax
80100c5d:	84 c0                	test   %al,%al
80100c5f:	74 06                	je     80100c67 <update_coppied_commands+0x57>
80100c61:	89 15 08 0f 11 80    	mov    %edx,0x80110f08
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
80100cfb:	d8 0d d0 8c 10 80    	fmuls  0x80108cd0
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
80100df9:	a1 c8 15 11 80       	mov    0x801115c8,%eax
80100dfe:	8b 35 64 16 11 80    	mov    0x80111664,%esi
80100e04:	89 c7                	mov    %eax,%edi
80100e06:	2b 3d c4 16 11 80    	sub    0x801116c4,%edi
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
80100e75:	a3 c4 16 11 80       	mov    %eax,0x801116c4
void show_result(int offset, char* result){
80100e7a:	bb 05 00 00 00       	mov    $0x5,%ebx
  if(panicked){
80100e7f:	8b 0d b8 16 11 80    	mov    0x801116b8,%ecx
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
80100e9a:	a1 c8 15 11 80       	mov    0x801115c8,%eax
80100e9f:	8d 48 ff             	lea    -0x1(%eax),%ecx
80100ea2:	89 0d c8 15 11 80    	mov    %ecx,0x801115c8
  for(int i = 0; i < 5; i++){
80100ea8:	83 eb 01             	sub    $0x1,%ebx
80100eab:	75 d2                	jne    80100e7f <show_result+0x8f>
    for(int j = index_question_mark + 1; j <= temp_e - 1; j++){
80100ead:	a1 64 16 11 80       	mov    0x80111664,%eax
80100eb2:	bb 05 00 00 00       	mov    $0x5,%ebx
80100eb7:	8d 70 01             	lea    0x1(%eax),%esi
80100eba:	89 f0                	mov    %esi,%eax
80100ebc:	39 f1                	cmp    %esi,%ecx
80100ebe:	7e 14                	jle    80100ed4 <show_result+0xe4>
      input.buf[j - 1] = input.buf[j];
80100ec0:	0f b6 90 40 15 11 80 	movzbl -0x7feeeac0(%eax),%edx
    for(int j = index_question_mark + 1; j <= temp_e - 1; j++){
80100ec7:	83 c0 01             	add    $0x1,%eax
      input.buf[j - 1] = input.buf[j];
80100eca:	88 90 3e 15 11 80    	mov    %dl,-0x7feeeac2(%eax)
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
80100ee4:	8b 15 b8 16 11 80    	mov    0x801116b8,%edx
    input.buf[input.e] = result[j];
80100eea:	0f be 04 18          	movsbl (%eax,%ebx,1),%eax
80100eee:	88 81 40 15 11 80    	mov    %al,-0x7feeeac0(%ecx)
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
80100f05:	a1 c8 15 11 80       	mov    0x801115c8,%eax
80100f0a:	8d 48 01             	lea    0x1(%eax),%ecx
80100f0d:	89 0d c8 15 11 80    	mov    %ecx,0x801115c8
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
80100f2c:	0f be 15 6d 16 11 80 	movsbl 0x8011166d,%edx
  switch (operand)
80100f33:	0f b6 05 6c 16 11 80 	movzbl 0x8011166c,%eax
  int second_num = second_digit - '0';
80100f3a:	83 ea 30             	sub    $0x30,%edx
    result = (float)second_num + (float)first_num;
80100f3d:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)
  int first_num = first_digit - '0';
80100f43:	0f be 15 6e 16 11 80 	movsbl 0x8011166e,%edx
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
80100f90:	e8 8b 4d 00 00       	call   80105d20 <memset>
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
80100fcc:	d8 0d d0 8c 10 80    	fmuls  0x80108cd0
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
80101100:	a1 c4 15 11 80       	mov    0x801115c4,%eax
80101105:	8b 15 c8 15 11 80    	mov    0x801115c8,%edx
8010110b:	39 d0                	cmp    %edx,%eax
8010110d:	72 10                	jb     8010111f <there_is_question_mark+0x1f>
8010110f:	eb 1f                	jmp    80101130 <there_is_question_mark+0x30>
80101111:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101118:	83 c0 01             	add    $0x1,%eax
8010111b:	39 d0                	cmp    %edx,%eax
8010111d:	73 11                	jae    80101130 <there_is_question_mark+0x30>
    if(input.buf[i] == '?'){
8010111f:	80 b8 40 15 11 80 3f 	cmpb   $0x3f,-0x7feeeac0(%eax)
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
80101140:	a1 c4 15 11 80       	mov    0x801115c4,%eax
80101145:	8b 15 c8 15 11 80    	mov    0x801115c8,%edx
8010114b:	39 d0                	cmp    %edx,%eax
8010114d:	72 10                	jb     8010115f <find_question_mark_index+0x1f>
8010114f:	eb 1f                	jmp    80101170 <find_question_mark_index+0x30>
80101151:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101158:	83 c0 01             	add    $0x1,%eax
8010115b:	39 d0                	cmp    %edx,%eax
8010115d:	73 11                	jae    80101170 <find_question_mark_index+0x30>
    if(input.buf[i] == '?'){
8010115f:	80 b8 40 15 11 80 3f 	cmpb   $0x3f,-0x7feeeac0(%eax)
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
80101189:	8b 1d c8 15 11 80    	mov    0x801115c8,%ebx
8010118f:	3b 1d c4 15 11 80    	cmp    0x801115c4,%ebx
80101195:	76 2b                	jbe    801011c2 <handle_up_and_down_arrow+0x42>
    if(input.buf[i - 1] != '\n'){
80101197:	83 eb 01             	sub    $0x1,%ebx
8010119a:	80 bb 40 15 11 80 0a 	cmpb   $0xa,-0x7feeeac0(%ebx)
801011a1:	74 17                	je     801011ba <handle_up_and_down_arrow+0x3a>
  if(panicked){
801011a3:	8b 35 b8 16 11 80    	mov    0x801116b8,%esi
801011a9:	85 f6                	test   %esi,%esi
801011ab:	74 03                	je     801011b0 <handle_up_and_down_arrow+0x30>
801011ad:	fa                   	cli    
    for(;;)
801011ae:	eb fe                	jmp    801011ae <handle_up_and_down_arrow+0x2e>
801011b0:	b8 00 01 00 00       	mov    $0x100,%eax
801011b5:	e8 46 f2 ff ff       	call   80100400 <consputc.part.0>
  for(int i = input.e; i > input.w; i--){
801011ba:	39 1d c4 15 11 80    	cmp    %ebx,0x801115c4
801011c0:	72 d5                	jb     80101197 <handle_up_and_down_arrow+0x17>
  if(dir == UP){
801011c2:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
801011c6:	74 0c                	je     801011d4 <handle_up_and_down_arrow+0x54>
  if(dir == DOWN){
801011c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  for(int i = input.w; i < input.e; i++){
801011cb:	a1 c8 15 11 80       	mov    0x801115c8,%eax
  if(dir == DOWN){
801011d0:	85 c9                	test   %ecx,%ecx
801011d2:	75 33                	jne    80101207 <handle_up_and_down_arrow+0x87>
    input = history_cmnd.hist[history_cmnd.num_of_cmnd - history_cmnd.num_of_press];
801011d4:	a1 24 15 11 80       	mov    0x80111524,%eax
801011d9:	ba 40 15 11 80       	mov    $0x80111540,%edx
801011de:	b9 23 00 00 00       	mov    $0x23,%ecx
801011e3:	2b 05 2c 15 11 80    	sub    0x8011152c,%eax
801011e9:	69 c0 8c 00 00 00    	imul   $0x8c,%eax,%eax
801011ef:	89 d7                	mov    %edx,%edi
801011f1:	05 20 0f 11 80       	add    $0x80110f20,%eax
801011f6:	89 c6                	mov    %eax,%esi
801011f8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    input.e--;
801011fa:	a1 c8 15 11 80       	mov    0x801115c8,%eax
801011ff:	83 e8 01             	sub    $0x1,%eax
80101202:	a3 c8 15 11 80       	mov    %eax,0x801115c8
  for(int i = input.w; i < input.e; i++){
80101207:	8b 1d c4 15 11 80    	mov    0x801115c4,%ebx
8010120d:	39 c3                	cmp    %eax,%ebx
8010120f:	73 27                	jae    80101238 <handle_up_and_down_arrow+0xb8>
  if(panicked){
80101211:	8b 15 b8 16 11 80    	mov    0x801116b8,%edx
    consputc(input.buf[i]);
80101217:	0f be 83 40 15 11 80 	movsbl -0x7feeeac0(%ebx),%eax
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
80101230:	39 1d c8 15 11 80    	cmp    %ebx,0x801115c8
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
80101246:	a1 68 16 11 80       	mov    0x80111668,%eax
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
80101265:	88 15 6e 16 11 80    	mov    %dl,0x8011166e
      state_of_question_mark = 2;
8010126b:	c7 05 68 16 11 80 02 	movl   $0x2,0x80111668
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
8010128c:	c7 05 68 16 11 80 00 	movl   $0x0,0x80111668
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
801012a5:	c7 05 68 16 11 80 01 	movl   $0x1,0x80111668
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
801012c9:	c7 05 68 16 11 80 03 	movl   $0x3,0x80111668
801012d0:	00 00 00 
      operand = c;
801012d3:	88 15 6c 16 11 80    	mov    %dl,0x8011166c
}
801012d9:	c9                   	leave  
801012da:	c3                   	ret    
801012db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801012df:	90                   	nop
      second_digit = c;
801012e0:	88 15 6d 16 11 80    	mov    %dl,0x8011166d
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
801012fd:	89 35 64 16 11 80    	mov    %esi,0x80111664
    check_states_question_mark(input.buf[qm_index - i]);
80101303:	0f be 84 1e 3b 15 11 	movsbl -0x7feeeac5(%esi,%ebx,1),%eax
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
80101330:	a1 c8 15 11 80       	mov    0x801115c8,%eax
80101335:	2b 05 c4 15 11 80    	sub    0x801115c4,%eax
8010133b:	83 f8 01             	cmp    $0x1,%eax
8010133e:	76 78                	jbe    801013b8 <update_history_memory+0x88>
void update_history_memory(){
80101340:	55                   	push   %ebp
80101341:	ba 40 15 11 80       	mov    $0x80111540,%edx
80101346:	89 e5                	mov    %esp,%ebp
80101348:	57                   	push   %edi
80101349:	56                   	push   %esi
8010134a:	53                   	push   %ebx
    if(history_cmnd.num_of_cmnd < 10){
8010134b:	8b 1d 24 15 11 80    	mov    0x80111524,%ebx
80101351:	83 fb 09             	cmp    $0x9,%ebx
80101354:	7e 3a                	jle    80101390 <update_history_memory+0x60>
80101356:	b8 20 0f 11 80       	mov    $0x80110f20,%eax
8010135b:	bb 0c 14 11 80       	mov    $0x8011140c,%ebx
          history_cmnd.hist[i] = history_cmnd.hist[i + 1];
80101360:	8d b0 8c 00 00 00    	lea    0x8c(%eax),%esi
80101366:	89 c7                	mov    %eax,%edi
      for(int i = 0; i < 9; i++){
80101368:	05 8c 00 00 00       	add    $0x8c,%eax
          history_cmnd.hist[i] = history_cmnd.hist[i + 1];
8010136d:	b9 23 00 00 00       	mov    $0x23,%ecx
80101372:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
      for(int i = 0; i < 9; i++){
80101374:	3d 0c 14 11 80       	cmp    $0x8011140c,%eax
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
801013a0:	89 1d 24 15 11 80    	mov    %ebx,0x80111524
      history_cmnd.hist[history_cmnd.num_of_cmnd] = input;
801013a6:	05 20 0f 11 80       	add    $0x80110f20,%eax
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
801013c4:	8b 35 c8 15 11 80    	mov    0x801115c8,%esi
void handle_deletion(){
801013ca:	53                   	push   %ebx
  for(int i = input.e - num_of_left_pressed - 1; i < input.e; i++){
801013cb:	8d 56 ff             	lea    -0x1(%esi),%edx
801013ce:	2b 15 c4 16 11 80    	sub    0x801116c4,%edx
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
801013f5:	0f b6 99 40 15 11 80 	movzbl -0x7feeeac0(%ecx),%ebx
801013fc:	89 c1                	mov    %eax,%ecx
801013fe:	c1 f9 1f             	sar    $0x1f,%ecx
80101401:	c1 e9 19             	shr    $0x19,%ecx
80101404:	01 c8                	add    %ecx,%eax
80101406:	83 e0 7f             	and    $0x7f,%eax
80101409:	29 c8                	sub    %ecx,%eax
8010140b:	88 98 40 15 11 80    	mov    %bl,-0x7feeeac0(%eax)
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
80101424:	8b 35 d4 15 11 80    	mov    0x801115d4,%esi
void handle_copy_delete(){
8010142a:	53                   	push   %ebx
  for(int i = cur_index - num_of_left_copy - 1; i < cur_index; i++){
8010142b:	89 f2                	mov    %esi,%edx
8010142d:	2b 15 d0 15 11 80    	sub    0x801115d0,%edx
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
80101455:	0f b6 99 e0 15 11 80 	movzbl -0x7feeea20(%ecx),%ebx
8010145c:	89 c1                	mov    %eax,%ecx
8010145e:	c1 f9 1f             	sar    $0x1f,%ecx
80101461:	c1 e9 19             	shr    $0x19,%ecx
80101464:	01 c8                	add    %ecx,%eax
80101466:	83 e0 7f             	and    $0x7f,%eax
80101469:	29 c8                	sub    %ecx,%eax
8010146b:	88 98 e0 15 11 80    	mov    %bl,-0x7feeea20(%eax)
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
80101481:	a1 c8 15 11 80       	mov    0x801115c8,%eax
80101486:	8d 50 ff             	lea    -0x1(%eax),%edx
void handle_writing(){
80101489:	89 e5                	mov    %esp,%ebp
8010148b:	56                   	push   %esi
  int limit = input.e - num_of_left_pressed - 1;
8010148c:	89 d6                	mov    %edx,%esi
8010148e:	2b 35 c4 16 11 80    	sub    0x801116c4,%esi
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
801014b0:	0f b6 98 40 15 11 80 	movzbl -0x7feeeac0(%eax),%ebx
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
801014cc:	88 98 40 15 11 80    	mov    %bl,-0x7feeeac0(%eax)
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
801014e1:	a1 d4 15 11 80       	mov    0x801115d4,%eax
801014e6:	8d 50 ff             	lea    -0x1(%eax),%edx
void handle_copying(){
801014e9:	89 e5                	mov    %esp,%ebp
801014eb:	56                   	push   %esi
  int limit = cur_index - 1 - num_of_left_copy;
801014ec:	89 d6                	mov    %edx,%esi
801014ee:	2b 35 d0 15 11 80    	sub    0x801115d0,%esi
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
80101510:	0f b6 98 e0 15 11 80 	movzbl -0x7feeea20(%eax),%ebx
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
8010152c:	88 98 e0 15 11 80    	mov    %bl,-0x7feeea20(%eax)
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
8010154c:	68 80 16 11 80       	push   $0x80111680
{
80101551:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  acquire(&cons.lock);
80101554:	e8 07 47 00 00       	call   80105c60 <acquire>
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
80101575:	0f 84 b5 01 00 00    	je     80101730 <consoleintr+0x1f0>
8010157b:	7f 53                	jg     801015d0 <consoleintr+0x90>
8010157d:	8d 43 fa             	lea    -0x6(%ebx),%eax
80101580:	83 f8 0f             	cmp    $0xf,%eax
80101583:	0f 87 87 06 00 00    	ja     80101c10 <consoleintr+0x6d0>
80101589:	ff 24 85 7c 8c 10 80 	jmp    *-0x7fef7384(,%eax,4)
80101590:	b8 00 01 00 00       	mov    $0x100,%eax
80101595:	e8 66 ee ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
8010159a:	a1 c8 15 11 80       	mov    0x801115c8,%eax
8010159f:	3b 05 c4 15 11 80    	cmp    0x801115c4,%eax
801015a5:	74 bc                	je     80101563 <consoleintr+0x23>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801015a7:	83 e8 01             	sub    $0x1,%eax
801015aa:	89 c2                	mov    %eax,%edx
801015ac:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
801015af:	80 ba 40 15 11 80 0a 	cmpb   $0xa,-0x7feeeac0(%edx)
801015b6:	74 ab                	je     80101563 <consoleintr+0x23>
  if(panicked){
801015b8:	8b 0d b8 16 11 80    	mov    0x801116b8,%ecx
        input.e--;
801015be:	a3 c8 15 11 80       	mov    %eax,0x801115c8
  if(panicked){
801015c3:	85 c9                	test   %ecx,%ecx
801015c5:	74 c9                	je     80101590 <consoleintr+0x50>
801015c7:	fa                   	cli    
    for(;;)
801015c8:	eb fe                	jmp    801015c8 <consoleintr+0x88>
801015ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    switch(c){
801015d0:	81 fb e4 00 00 00    	cmp    $0xe4,%ebx
801015d6:	0f 84 94 02 00 00    	je     80101870 <consoleintr+0x330>
801015dc:	7e 6a                	jle    80101648 <consoleintr+0x108>
801015de:	81 fb e5 00 00 00    	cmp    $0xe5,%ebx
801015e4:	0f 85 06 04 00 00    	jne    801019f0 <consoleintr+0x4b0>
      if(num_of_left_pressed > 0){
801015ea:	8b 1d c4 16 11 80    	mov    0x801116c4,%ebx
801015f0:	85 db                	test   %ebx,%ebx
801015f2:	0f 8f e8 04 00 00    	jg     80101ae0 <consoleintr+0x5a0>
      if(num_of_left_copy > 0)
801015f8:	a1 d0 15 11 80       	mov    0x801115d0,%eax
801015fd:	85 c0                	test   %eax,%eax
801015ff:	0f 8e 5e ff ff ff    	jle    80101563 <consoleintr+0x23>
        num_of_left_copy--;
80101605:	83 e8 01             	sub    $0x1,%eax
80101608:	a3 d0 15 11 80       	mov    %eax,0x801115d0
  while((c = getc()) >= 0){
8010160d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101610:	ff d0                	call   *%eax
80101612:	89 c3                	mov    %eax,%ebx
80101614:	85 c0                	test   %eax,%eax
80101616:	0f 89 56 ff ff ff    	jns    80101572 <consoleintr+0x32>
8010161c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80101620:	83 ec 0c             	sub    $0xc,%esp
80101623:	68 80 16 11 80       	push   $0x80111680
80101628:	e8 d3 45 00 00       	call   80105c00 <release>
  if(doprocdump) {
8010162d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101630:	83 c4 10             	add    $0x10,%esp
80101633:	85 c0                	test   %eax,%eax
80101635:	0f 85 02 05 00 00    	jne    80101b3d <consoleintr+0x5fd>
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
8010164e:	0f 84 cc 02 00 00    	je     80101920 <consoleintr+0x3e0>
80101654:	81 fb e3 00 00 00    	cmp    $0xe3,%ebx
8010165a:	0f 85 90 03 00 00    	jne    801019f0 <consoleintr+0x4b0>
      for(int i = 0; i < num_of_left_pressed; i++)
80101660:	a1 c4 16 11 80       	mov    0x801116c4,%eax
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
801016c8:	8b 1d 24 15 11 80    	mov    0x80111524,%ebx
801016ce:	a1 2c 15 11 80       	mov    0x8011152c,%eax
      num_of_left_pressed = 0;
801016d3:	c7 05 c4 16 11 80 00 	movl   $0x0,0x801116c4
801016da:	00 00 00 
      if(history_cmnd.num_of_cmnd != 0 && history_cmnd.num_of_press > 1){
801016dd:	85 db                	test   %ebx,%ebx
801016df:	74 09                	je     801016ea <consoleintr+0x1aa>
801016e1:	83 f8 01             	cmp    $0x1,%eax
801016e4:	0f 8f 76 04 00 00    	jg     80101b60 <consoleintr+0x620>
      else if(history_cmnd.num_of_press == 1){
801016ea:	83 f8 01             	cmp    $0x1,%eax
801016ed:	0f 85 70 fe ff ff    	jne    80101563 <consoleintr+0x23>
        int temp = input.e - input.w + 1;
801016f3:	a1 c8 15 11 80       	mov    0x801115c8,%eax
        show_current_history(temp);
801016f8:	83 ec 0c             	sub    $0xc,%esp
        history_cmnd.num_of_press = 0;
801016fb:	c7 05 2c 15 11 80 00 	movl   $0x0,0x8011152c
80101702:	00 00 00 
        int temp = input.e - input.w + 1;
80101705:	83 c0 01             	add    $0x1,%eax
80101708:	2b 05 c4 15 11 80    	sub    0x801115c4,%eax
        show_current_history(temp);
8010170e:	50                   	push   %eax
8010170f:	e8 3c f2 ff ff       	call   80100950 <show_current_history>
        currecnt_com = 0;
80101714:	83 c4 10             	add    $0x10,%esp
80101717:	c7 05 60 16 11 80 00 	movl   $0x0,0x80111660
8010171e:	00 00 00 
80101721:	e9 3d fe ff ff       	jmp    80101563 <consoleintr+0x23>
80101726:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010172d:	8d 76 00             	lea    0x0(%esi),%esi
      if(input.e != input.w){
80101730:	a1 c8 15 11 80       	mov    0x801115c8,%eax
80101735:	8b 0d c4 15 11 80    	mov    0x801115c4,%ecx
8010173b:	39 c8                	cmp    %ecx,%eax
8010173d:	0f 84 20 fe ff ff    	je     80101563 <consoleintr+0x23>
        if(ctrl_s_pressed){
80101743:	8b 15 c0 16 11 80    	mov    0x801116c0,%edx
80101749:	85 d2                	test   %edx,%edx
8010174b:	74 27                	je     80101774 <consoleintr+0x234>
            coppied_input[cur_index - 1] = '\0';
8010174d:	8b 3d d4 15 11 80    	mov    0x801115d4,%edi
          if(num_of_left_copy == 0){
80101753:	8b 15 d0 15 11 80    	mov    0x801115d0,%edx
            coppied_input[cur_index - 1] = '\0';
80101759:	89 7d e0             	mov    %edi,-0x20(%ebp)
          if(num_of_left_copy == 0){
8010175c:	85 d2                	test   %edx,%edx
8010175e:	0f 85 8c 04 00 00    	jne    80101bf0 <consoleintr+0x6b0>
            coppied_input[cur_index - 1] = '\0';
80101764:	83 ef 01             	sub    $0x1,%edi
80101767:	c6 87 e0 15 11 80 00 	movb   $0x0,-0x7feeea20(%edi)
            cur_index--;
8010176e:	89 3d d4 15 11 80    	mov    %edi,0x801115d4
        if(num_of_left_pressed == 0){
80101774:	8b 15 c4 16 11 80    	mov    0x801116c4,%edx
8010177a:	85 d2                	test   %edx,%edx
8010177c:	0f 84 c7 03 00 00    	je     80101b49 <consoleintr+0x609>
        else if(num_of_left_pressed < input.e - input.w){
80101782:	89 c3                	mov    %eax,%ebx
80101784:	29 cb                	sub    %ecx,%ebx
80101786:	39 d3                	cmp    %edx,%ebx
80101788:	0f 86 d5 fd ff ff    	jbe    80101563 <consoleintr+0x23>
  for(int i = input.e - num_of_left_pressed - 1; i < input.e; i++){
8010178e:	8d 78 ff             	lea    -0x1(%eax),%edi
80101791:	89 c6                	mov    %eax,%esi
80101793:	89 f9                	mov    %edi,%ecx
80101795:	29 d1                	sub    %edx,%ecx
80101797:	39 c8                	cmp    %ecx,%eax
80101799:	76 3a                	jbe    801017d5 <consoleintr+0x295>
8010179b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010179f:	90                   	nop
    input.buf[i % INPUT_BUF] = input.buf[(i + 1) % INPUT_BUF];
801017a0:	89 ca                	mov    %ecx,%edx
801017a2:	83 c1 01             	add    $0x1,%ecx
801017a5:	89 cb                	mov    %ecx,%ebx
801017a7:	c1 fb 1f             	sar    $0x1f,%ebx
801017aa:	c1 eb 19             	shr    $0x19,%ebx
801017ad:	8d 04 19             	lea    (%ecx,%ebx,1),%eax
801017b0:	83 e0 7f             	and    $0x7f,%eax
801017b3:	29 d8                	sub    %ebx,%eax
801017b5:	89 d3                	mov    %edx,%ebx
801017b7:	c1 fb 1f             	sar    $0x1f,%ebx
801017ba:	0f b6 80 40 15 11 80 	movzbl -0x7feeeac0(%eax),%eax
801017c1:	c1 eb 19             	shr    $0x19,%ebx
801017c4:	01 da                	add    %ebx,%edx
801017c6:	83 e2 7f             	and    $0x7f,%edx
801017c9:	29 da                	sub    %ebx,%edx
801017cb:	88 82 40 15 11 80    	mov    %al,-0x7feeeac0(%edx)
  for(int i = input.e - num_of_left_pressed - 1; i < input.e; i++){
801017d1:	39 f1                	cmp    %esi,%ecx
801017d3:	75 cb                	jne    801017a0 <consoleintr+0x260>
  if(panicked){
801017d5:	a1 b8 16 11 80       	mov    0x801116b8,%eax
          input.e--;
801017da:	89 3d c8 15 11 80    	mov    %edi,0x801115c8
  if(panicked){
801017e0:	85 c0                	test   %eax,%eax
801017e2:	0f 84 92 03 00 00    	je     80101b7a <consoleintr+0x63a>
  asm volatile("cli");
801017e8:	fa                   	cli    
    for(;;)
801017e9:	eb fe                	jmp    801017e9 <consoleintr+0x2a9>
801017eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801017ef:	90                   	nop
  memset(coppied_input, '\0', sizeof(coppied_input));
801017f0:	83 ec 04             	sub    $0x4,%esp
      ctrl_s_start = input.e - input.w;
801017f3:	a1 c8 15 11 80       	mov    0x801115c8,%eax
      cur_index = 0;
801017f8:	c7 05 d4 15 11 80 00 	movl   $0x0,0x801115d4
801017ff:	00 00 00 
  memset(coppied_input, '\0', sizeof(coppied_input));
80101802:	68 80 00 00 00       	push   $0x80
80101807:	6a 00                	push   $0x0
      ctrl_s_start = input.e - input.w;
80101809:	89 c2                	mov    %eax,%edx
8010180b:	2b 15 c4 15 11 80    	sub    0x801115c4,%edx
  memset(coppied_input, '\0', sizeof(coppied_input));
80101811:	68 e0 15 11 80       	push   $0x801115e0
      ctrl_s_pressed = 1;
80101816:	c7 05 c0 16 11 80 01 	movl   $0x1,0x801116c0
8010181d:	00 00 00 
      ctrl_s_start = input.e - input.w;
80101820:	89 15 cc 15 11 80    	mov    %edx,0x801115cc
  start_ctrl_s = input.e;
80101826:	a3 bc 16 11 80       	mov    %eax,0x801116bc
  memset(coppied_input, '\0', sizeof(coppied_input));
8010182b:	e8 f0 44 00 00       	call   80105d20 <memset>
}
80101830:	83 c4 10             	add    $0x10,%esp
80101833:	e9 2b fd ff ff       	jmp    80101563 <consoleintr+0x23>
80101838:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010183f:	90                   	nop
  if(ctrl_s_pressed){
80101840:	8b 0d c0 16 11 80    	mov    0x801116c0,%ecx
80101846:	85 c9                	test   %ecx,%ecx
80101848:	0f 84 15 fd ff ff    	je     80101563 <consoleintr+0x23>
    print_copied_command();
8010184e:	e8 bd f2 ff ff       	call   80100b10 <print_copied_command>
80101853:	e9 0b fd ff ff       	jmp    80101563 <consoleintr+0x23>
80101858:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010185f:	90                   	nop
    switch(c){
80101860:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
80101867:	e9 f7 fc ff ff       	jmp    80101563 <consoleintr+0x23>
8010186c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((input.e - num_of_left_pressed) > input.w){
80101870:	8b 0d c4 16 11 80    	mov    0x801116c4,%ecx
80101876:	a1 c8 15 11 80       	mov    0x801115c8,%eax
8010187b:	29 c8                	sub    %ecx,%eax
8010187d:	3b 05 c4 15 11 80    	cmp    0x801115c4,%eax
80101883:	0f 86 da fc ff ff    	jbe    80101563 <consoleintr+0x23>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101889:	bf d4 03 00 00       	mov    $0x3d4,%edi
8010188e:	b8 0e 00 00 00       	mov    $0xe,%eax
80101893:	89 fa                	mov    %edi,%edx
80101895:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101896:	be d5 03 00 00       	mov    $0x3d5,%esi
8010189b:	89 f2                	mov    %esi,%edx
8010189d:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
8010189e:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801018a1:	89 fa                	mov    %edi,%edx
801018a3:	89 c3                	mov    %eax,%ebx
801018a5:	b8 0f 00 00 00       	mov    $0xf,%eax
801018aa:	c1 e3 08             	shl    $0x8,%ebx
801018ad:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801018ae:	89 f2                	mov    %esi,%edx
801018b0:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
801018b1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801018b4:	89 fa                	mov    %edi,%edx
801018b6:	09 c3                	or     %eax,%ebx
801018b8:	b8 0e 00 00 00       	mov    $0xe,%eax
      pos -= 1;
801018bd:	83 eb 01             	sub    $0x1,%ebx
801018c0:	ee                   	out    %al,(%dx)
  outb(CRTPORT+1, pos>>8);
801018c1:	89 da                	mov    %ebx,%edx
801018c3:	c1 fa 08             	sar    $0x8,%edx
801018c6:	89 d0                	mov    %edx,%eax
801018c8:	89 f2                	mov    %esi,%edx
801018ca:	ee                   	out    %al,(%dx)
801018cb:	b8 0f 00 00 00       	mov    $0xf,%eax
801018d0:	89 fa                	mov    %edi,%edx
801018d2:	ee                   	out    %al,(%dx)
801018d3:	89 d8                	mov    %ebx,%eax
801018d5:	89 f2                	mov    %esi,%edx
801018d7:	ee                   	out    %al,(%dx)
        if(ctrl_s_pressed && cur_index > 0 && num_of_left_copy < cur_index)
801018d8:	8b 3d c0 16 11 80    	mov    0x801116c0,%edi
        num_of_left_pressed++;
801018de:	83 c1 01             	add    $0x1,%ecx
801018e1:	89 0d c4 16 11 80    	mov    %ecx,0x801116c4
        if(ctrl_s_pressed && cur_index > 0 && num_of_left_copy < cur_index)
801018e7:	85 ff                	test   %edi,%edi
801018e9:	0f 84 74 fc ff ff    	je     80101563 <consoleintr+0x23>
801018ef:	8b 15 d4 15 11 80    	mov    0x801115d4,%edx
801018f5:	85 d2                	test   %edx,%edx
801018f7:	0f 8e 66 fc ff ff    	jle    80101563 <consoleintr+0x23>
801018fd:	a1 d0 15 11 80       	mov    0x801115d0,%eax
80101902:	39 c2                	cmp    %eax,%edx
80101904:	0f 8e 59 fc ff ff    	jle    80101563 <consoleintr+0x23>
          num_of_left_copy++;
8010190a:	83 c0 01             	add    $0x1,%eax
8010190d:	a3 d0 15 11 80       	mov    %eax,0x801115d0
80101912:	e9 4c fc ff ff       	jmp    80101563 <consoleintr+0x23>
80101917:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010191e:	66 90                	xchg   %ax,%ax
      for(int i = 0; i < num_of_left_pressed; i++)
80101920:	a1 c4 16 11 80       	mov    0x801116c4,%eax
80101925:	31 ff                	xor    %edi,%edi
80101927:	be d4 03 00 00       	mov    $0x3d4,%esi
8010192c:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010192f:	85 c0                	test   %eax,%eax
80101931:	7e 55                	jle    80101988 <consoleintr+0x448>
80101933:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101937:	90                   	nop
80101938:	b8 0e 00 00 00       	mov    $0xe,%eax
8010193d:	89 f2                	mov    %esi,%edx
8010193f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101940:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80101945:	89 da                	mov    %ebx,%edx
80101947:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80101948:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010194b:	89 f2                	mov    %esi,%edx
8010194d:	b8 0f 00 00 00       	mov    $0xf,%eax
80101952:	c1 e1 08             	shl    $0x8,%ecx
80101955:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101956:	89 da                	mov    %ebx,%edx
80101958:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80101959:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010195c:	89 f2                	mov    %esi,%edx
8010195e:	09 c1                	or     %eax,%ecx
80101960:	b8 0e 00 00 00       	mov    $0xe,%eax
      pos += 1;
80101965:	83 c1 01             	add    $0x1,%ecx
80101968:	ee                   	out    %al,(%dx)
  outb(CRTPORT+1, pos>>8);
80101969:	89 ca                	mov    %ecx,%edx
8010196b:	c1 fa 08             	sar    $0x8,%edx
8010196e:	89 d0                	mov    %edx,%eax
80101970:	89 da                	mov    %ebx,%edx
80101972:	ee                   	out    %al,(%dx)
80101973:	b8 0f 00 00 00       	mov    $0xf,%eax
80101978:	89 f2                	mov    %esi,%edx
8010197a:	ee                   	out    %al,(%dx)
8010197b:	89 c8                	mov    %ecx,%eax
8010197d:	89 da                	mov    %ebx,%edx
8010197f:	ee                   	out    %al,(%dx)
      for(int i = 0; i < num_of_left_pressed; i++)
80101980:	83 c7 01             	add    $0x1,%edi
80101983:	39 7d e0             	cmp    %edi,-0x20(%ebp)
80101986:	75 b0                	jne    80101938 <consoleintr+0x3f8>
      if(currecnt_com == 0){
80101988:	8b 35 60 16 11 80    	mov    0x80111660,%esi
      num_of_left_pressed = 0;
8010198e:	c7 05 c4 16 11 80 00 	movl   $0x0,0x801116c4
80101995:	00 00 00 
      if(currecnt_com == 0){
80101998:	85 f6                	test   %esi,%esi
8010199a:	75 1d                	jne    801019b9 <consoleintr+0x479>
        history_cmnd.current_command = input;
8010199c:	b8 98 14 11 80       	mov    $0x80111498,%eax
801019a1:	be 40 15 11 80       	mov    $0x80111540,%esi
801019a6:	b9 23 00 00 00       	mov    $0x23,%ecx
        currecnt_com = 1;
801019ab:	c7 05 60 16 11 80 01 	movl   $0x1,0x80111660
801019b2:	00 00 00 
        history_cmnd.current_command = input;
801019b5:	89 c7                	mov    %eax,%edi
801019b7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
      if(history_cmnd.num_of_cmnd != 0 && history_cmnd.num_of_press < history_cmnd.num_of_cmnd){
801019b9:	a1 24 15 11 80       	mov    0x80111524,%eax
801019be:	85 c0                	test   %eax,%eax
801019c0:	0f 84 9d fb ff ff    	je     80101563 <consoleintr+0x23>
801019c6:	8b 15 2c 15 11 80    	mov    0x8011152c,%edx
801019cc:	39 d0                	cmp    %edx,%eax
801019ce:	0f 8e 8f fb ff ff    	jle    80101563 <consoleintr+0x23>
        handle_up_and_down_arrow(UP);
801019d4:	83 ec 0c             	sub    $0xc,%esp
        history_cmnd.num_of_press++;
801019d7:	83 c2 01             	add    $0x1,%edx
        handle_up_and_down_arrow(UP);
801019da:	6a 01                	push   $0x1
        history_cmnd.num_of_press++;
801019dc:	89 15 2c 15 11 80    	mov    %edx,0x8011152c
        handle_up_and_down_arrow(UP);
801019e2:	e8 99 f7 ff ff       	call   80101180 <handle_up_and_down_arrow>
801019e7:	83 c4 10             	add    $0x10,%esp
801019ea:	e9 74 fb ff ff       	jmp    80101563 <consoleintr+0x23>
801019ef:	90                   	nop
  for(int i = input.w; i < input.e; i++){
801019f0:	8b 35 c4 15 11 80    	mov    0x801115c4,%esi
801019f6:	a1 c8 15 11 80       	mov    0x801115c8,%eax
801019fb:	39 f0                	cmp    %esi,%eax
801019fd:	76 66                	jbe    80101a65 <consoleintr+0x525>
      for(int i = 0; i < num_of_left_pressed; i++)
801019ff:	89 f2                	mov    %esi,%edx
80101a01:	eb 0c                	jmp    80101a0f <consoleintr+0x4cf>
80101a03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a07:	90                   	nop
  for(int i = input.w; i < input.e; i++){
80101a08:	83 c2 01             	add    $0x1,%edx
80101a0b:	39 c2                	cmp    %eax,%edx
80101a0d:	73 49                	jae    80101a58 <consoleintr+0x518>
    if(input.buf[i] == '?'){
80101a0f:	80 ba 40 15 11 80 3f 	cmpb   $0x3f,-0x7feeeac0(%edx)
80101a16:	75 f0                	jne    80101a08 <consoleintr+0x4c8>
80101a18:	eb 11                	jmp    80101a2b <consoleintr+0x4eb>
80101a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(int i = input.w; i < input.e; i++){
80101a20:	83 c6 01             	add    $0x1,%esi
80101a23:	39 f0                	cmp    %esi,%eax
80101a25:	0f 86 de 01 00 00    	jbe    80101c09 <consoleintr+0x6c9>
    if(input.buf[i] == '?'){
80101a2b:	80 be 40 15 11 80 3f 	cmpb   $0x3f,-0x7feeeac0(%esi)
80101a32:	75 ec                	jne    80101a20 <consoleintr+0x4e0>
  index_question_mark = qm_index;
80101a34:	89 35 64 16 11 80    	mov    %esi,0x80111664
80101a3a:	bf 04 00 00 00       	mov    $0x4,%edi
    check_states_question_mark(input.buf[qm_index - i]);
80101a3f:	0f be 84 3e 3b 15 11 	movsbl -0x7feeeac5(%esi,%edi,1),%eax
80101a46:	80 
80101a47:	83 ec 0c             	sub    $0xc,%esp
80101a4a:	50                   	push   %eax
80101a4b:	e8 f0 f7 ff ff       	call   80101240 <check_states_question_mark>
  for(int i = 1;i <= 4; i++){
80101a50:	83 c4 10             	add    $0x10,%esp
80101a53:	83 ef 01             	sub    $0x1,%edi
80101a56:	75 e7                	jne    80101a3f <consoleintr+0x4ff>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80101a58:	a1 c8 15 11 80       	mov    0x801115c8,%eax
80101a5d:	85 db                	test   %ebx,%ebx
80101a5f:	0f 84 fe fa ff ff    	je     80101563 <consoleintr+0x23>
80101a65:	89 c2                	mov    %eax,%edx
80101a67:	2b 15 c0 15 11 80    	sub    0x801115c0,%edx
80101a6d:	83 fa 7f             	cmp    $0x7f,%edx
80101a70:	0f 87 ed fa ff ff    	ja     80101563 <consoleintr+0x23>
        if(ctrl_s_pressed){
80101a76:	8b 15 c0 16 11 80    	mov    0x801116c0,%edx
        c = (c == '\r') ? '\n' : c;
80101a7c:	83 fb 0d             	cmp    $0xd,%ebx
80101a7f:	0f 84 6f 02 00 00    	je     80101cf4 <consoleintr+0x7b4>
        if(num_of_left_pressed == 0 || c == '\n'){
80101a85:	83 fb 0a             	cmp    $0xa,%ebx
            coppied_input[cur_index] = c;
80101a88:	88 5d e0             	mov    %bl,-0x20(%ebp)
        if(num_of_left_pressed == 0 || c == '\n'){
80101a8b:	0f 94 45 d8          	sete   -0x28(%ebp)
        if(ctrl_s_pressed){
80101a8f:	85 d2                	test   %edx,%edx
80101a91:	0f 85 ff 00 00 00    	jne    80101b96 <consoleintr+0x656>
          if(num_of_left_pressed == 0){
80101a97:	8b 3d c4 16 11 80    	mov    0x801116c4,%edi
80101a9d:	89 7d d4             	mov    %edi,-0x2c(%ebp)
        if(num_of_left_pressed == 0 || c == '\n'){
80101aa0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80101aa3:	85 d2                	test   %edx,%edx
80101aa5:	0f 94 c2             	sete   %dl
80101aa8:	0a 55 d8             	or     -0x28(%ebp),%dl
80101aab:	0f 84 5d 02 00 00    	je     80101d0e <consoleintr+0x7ce>
          input.buf[input.e++ % INPUT_BUF] = c;
80101ab1:	0f b6 4d e0          	movzbl -0x20(%ebp),%ecx
80101ab5:	8d 50 01             	lea    0x1(%eax),%edx
80101ab8:	83 e0 7f             	and    $0x7f,%eax
80101abb:	89 15 c8 15 11 80    	mov    %edx,0x801115c8
80101ac1:	88 88 40 15 11 80    	mov    %cl,-0x7feeeac0(%eax)
  if(panicked){
80101ac7:	8b 35 b8 16 11 80    	mov    0x801116b8,%esi
80101acd:	85 f6                	test   %esi,%esi
80101acf:	0f 84 83 01 00 00    	je     80101c58 <consoleintr+0x718>
  asm volatile("cli");
80101ad5:	fa                   	cli    
    for(;;)
80101ad6:	eb fe                	jmp    80101ad6 <consoleintr+0x596>
80101ad8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101adf:	90                   	nop
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101ae0:	bf d4 03 00 00       	mov    $0x3d4,%edi
80101ae5:	b8 0e 00 00 00       	mov    $0xe,%eax
80101aea:	89 fa                	mov    %edi,%edx
80101aec:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101aed:	be d5 03 00 00       	mov    $0x3d5,%esi
80101af2:	89 f2                	mov    %esi,%edx
80101af4:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80101af5:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101af8:	89 fa                	mov    %edi,%edx
80101afa:	89 c1                	mov    %eax,%ecx
80101afc:	b8 0f 00 00 00       	mov    $0xf,%eax
80101b01:	c1 e1 08             	shl    $0x8,%ecx
80101b04:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101b05:	89 f2                	mov    %esi,%edx
80101b07:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80101b08:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101b0b:	89 fa                	mov    %edi,%edx
80101b0d:	09 c1                	or     %eax,%ecx
80101b0f:	b8 0e 00 00 00       	mov    $0xe,%eax
      pos += 1;
80101b14:	83 c1 01             	add    $0x1,%ecx
80101b17:	ee                   	out    %al,(%dx)
  outb(CRTPORT+1, pos>>8);
80101b18:	89 ca                	mov    %ecx,%edx
80101b1a:	c1 fa 08             	sar    $0x8,%edx
80101b1d:	89 d0                	mov    %edx,%eax
80101b1f:	89 f2                	mov    %esi,%edx
80101b21:	ee                   	out    %al,(%dx)
80101b22:	b8 0f 00 00 00       	mov    $0xf,%eax
80101b27:	89 fa                	mov    %edi,%edx
80101b29:	ee                   	out    %al,(%dx)
80101b2a:	89 c8                	mov    %ecx,%eax
80101b2c:	89 f2                	mov    %esi,%edx
80101b2e:	ee                   	out    %al,(%dx)
        num_of_left_pressed--;
80101b2f:	83 eb 01             	sub    $0x1,%ebx
80101b32:	89 1d c4 16 11 80    	mov    %ebx,0x801116c4
80101b38:	e9 bb fa ff ff       	jmp    801015f8 <consoleintr+0xb8>
}
80101b3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b40:	5b                   	pop    %ebx
80101b41:	5e                   	pop    %esi
80101b42:	5f                   	pop    %edi
80101b43:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80101b44:	e9 c7 3a 00 00       	jmp    80105610 <procdump>
        input.e--;
80101b49:	83 e8 01             	sub    $0x1,%eax
80101b4c:	a3 c8 15 11 80       	mov    %eax,0x801115c8
  if(panicked){
80101b51:	a1 b8 16 11 80       	mov    0x801116b8,%eax
80101b56:	85 c0                	test   %eax,%eax
80101b58:	74 20                	je     80101b7a <consoleintr+0x63a>
  asm volatile("cli");
80101b5a:	fa                   	cli    
    for(;;)
80101b5b:	eb fe                	jmp    80101b5b <consoleintr+0x61b>
80101b5d:	8d 76 00             	lea    0x0(%esi),%esi
        handle_up_and_down_arrow(DOWN);
80101b60:	83 ec 0c             	sub    $0xc,%esp
        history_cmnd.num_of_press--;
80101b63:	83 e8 01             	sub    $0x1,%eax
        handle_up_and_down_arrow(DOWN);
80101b66:	6a 00                	push   $0x0
        history_cmnd.num_of_press--;
80101b68:	a3 2c 15 11 80       	mov    %eax,0x8011152c
        handle_up_and_down_arrow(DOWN);
80101b6d:	e8 0e f6 ff ff       	call   80101180 <handle_up_and_down_arrow>
80101b72:	83 c4 10             	add    $0x10,%esp
80101b75:	e9 e9 f9 ff ff       	jmp    80101563 <consoleintr+0x23>
80101b7a:	b8 00 01 00 00       	mov    $0x100,%eax
80101b7f:	e8 7c e8 ff ff       	call   80100400 <consputc.part.0>
80101b84:	e9 da f9 ff ff       	jmp    80101563 <consoleintr+0x23>
        if(ctrl_s_pressed){
80101b89:	c6 45 d8 01          	movb   $0x1,-0x28(%ebp)
        c = (c == '\r') ? '\n' : c;
80101b8d:	bb 0a 00 00 00       	mov    $0xa,%ebx
        if(ctrl_s_pressed){
80101b92:	c6 45 e0 0a          	movb   $0xa,-0x20(%ebp)
          if(num_of_left_pressed == 0){
80101b96:	8b 35 c4 16 11 80    	mov    0x801116c4,%esi
            coppied_input[cur_index] = c;
80101b9c:	8b 3d d4 15 11 80    	mov    0x801115d4,%edi
          if(num_of_left_pressed == 0){
80101ba2:	89 75 d4             	mov    %esi,-0x2c(%ebp)
80101ba5:	85 f6                	test   %esi,%esi
80101ba7:	0f 84 93 00 00 00    	je     80101c40 <consoleintr+0x700>
  int limit = cur_index - 1 - num_of_left_copy;
80101bad:	8b 15 d0 15 11 80    	mov    0x801115d0,%edx
80101bb3:	89 55 cc             	mov    %edx,-0x34(%ebp)
            if(cur_index - num_of_left_pressed >= 0){
80101bb6:	3b 7d d4             	cmp    -0x2c(%ebp),%edi
80101bb9:	0f 8d 21 02 00 00    	jge    80101de0 <consoleintr+0x8a0>
            else if(num_of_left_copy > 0 && num_of_left_copy != cur_index){
80101bbf:	8b 75 cc             	mov    -0x34(%ebp),%esi
80101bc2:	39 fe                	cmp    %edi,%esi
80101bc4:	0f 84 d6 fe ff ff    	je     80101aa0 <consoleintr+0x560>
80101bca:	85 f6                	test   %esi,%esi
80101bcc:	0f 8e ce fe ff ff    	jle    80101aa0 <consoleintr+0x560>
              coppied_input[cur_index - num_of_left_copy] = c;
80101bd2:	0f b6 4d e0          	movzbl -0x20(%ebp),%ecx
80101bd6:	89 fa                	mov    %edi,%edx
80101bd8:	29 f2                	sub    %esi,%edx
80101bda:	88 8a e0 15 11 80    	mov    %cl,-0x7feeea20(%edx)
              cur_index++;
80101be0:	8d 57 01             	lea    0x1(%edi),%edx
80101be3:	89 15 d4 15 11 80    	mov    %edx,0x801115d4
80101be9:	e9 b2 fe ff ff       	jmp    80101aa0 <consoleintr+0x560>
80101bee:	66 90                	xchg   %ax,%ax
          else if(num_of_left_copy > 0 && num_of_left_copy != cur_index){
80101bf0:	7e 3e                	jle    80101c30 <consoleintr+0x6f0>
80101bf2:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101bf5:	39 fa                	cmp    %edi,%edx
80101bf7:	0f 85 86 01 00 00    	jne    80101d83 <consoleintr+0x843>
            ctrl_s_start--;
80101bfd:	83 2d cc 15 11 80 01 	subl   $0x1,0x801115cc
80101c04:	e9 6b fb ff ff       	jmp    80101774 <consoleintr+0x234>
  return 0;
80101c09:	31 f6                	xor    %esi,%esi
80101c0b:	e9 24 fe ff ff       	jmp    80101a34 <consoleintr+0x4f4>
  for(int i = input.w; i < input.e; i++){
80101c10:	8b 35 c4 15 11 80    	mov    0x801115c4,%esi
80101c16:	a1 c8 15 11 80       	mov    0x801115c8,%eax
80101c1b:	39 c6                	cmp    %eax,%esi
80101c1d:	0f 82 dc fd ff ff    	jb     801019ff <consoleintr+0x4bf>
80101c23:	e9 30 fe ff ff       	jmp    80101a58 <consoleintr+0x518>
80101c28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c2f:	90                   	nop
          else if(num_of_left_copy == cur_index){
80101c30:	3b 55 e0             	cmp    -0x20(%ebp),%edx
80101c33:	0f 85 3b fb ff ff    	jne    80101774 <consoleintr+0x234>
80101c39:	eb c2                	jmp    80101bfd <consoleintr+0x6bd>
80101c3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101c3f:	90                   	nop
            coppied_input[cur_index] = c;
80101c40:	0f b6 4d e0          	movzbl -0x20(%ebp),%ecx
            cur_index++;
80101c44:	8d 57 01             	lea    0x1(%edi),%edx
80101c47:	89 15 d4 15 11 80    	mov    %edx,0x801115d4
            coppied_input[cur_index] = c;
80101c4d:	88 8f e0 15 11 80    	mov    %cl,-0x7feeea20(%edi)
        if(num_of_left_pressed == 0 || c == '\n'){
80101c53:	e9 59 fe ff ff       	jmp    80101ab1 <consoleintr+0x571>
80101c58:	89 d8                	mov    %ebx,%eax
80101c5a:	e8 a1 e7 ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80101c5f:	83 fb 04             	cmp    $0x4,%ebx
80101c62:	74 1a                	je     80101c7e <consoleintr+0x73e>
80101c64:	80 7d d8 00          	cmpb   $0x0,-0x28(%ebp)
80101c68:	75 14                	jne    80101c7e <consoleintr+0x73e>
80101c6a:	a1 c0 15 11 80       	mov    0x801115c0,%eax
80101c6f:	83 e8 80             	sub    $0xffffff80,%eax
80101c72:	39 05 c8 15 11 80    	cmp    %eax,0x801115c8
80101c78:	0f 85 e5 f8 ff ff    	jne    80101563 <consoleintr+0x23>
          num_of_left_pressed = 0;
80101c7e:	c7 05 c4 16 11 80 00 	movl   $0x0,0x801116c4
80101c85:	00 00 00 
          num_of_left_copy = 0;
80101c88:	c7 05 d0 15 11 80 00 	movl   $0x0,0x801115d0
80101c8f:	00 00 00 
          history_cmnd.num_of_press = 0;
80101c92:	c7 05 2c 15 11 80 00 	movl   $0x0,0x8011152c
80101c99:	00 00 00 
          update_history_memory();
80101c9c:	e8 8f f6 ff ff       	call   80101330 <update_history_memory>
          if(is_history(hist)){
80101ca1:	8b 15 00 a0 10 80    	mov    0x8010a000,%edx
    if(command[i] != input.buf[i + input.w]){
80101ca7:	a1 c4 15 11 80       	mov    0x801115c4,%eax
80101cac:	0f b6 8c 30 40 15 11 	movzbl -0x7feeeac0(%eax,%esi,1),%ecx
80101cb3:	80 
80101cb4:	38 0c 32             	cmp    %cl,(%edx,%esi,1)
80101cb7:	75 0d                	jne    80101cc6 <consoleintr+0x786>
  for(int i = 0; i < 8; i++){
80101cb9:	83 c6 01             	add    $0x1,%esi
80101cbc:	83 fe 08             	cmp    $0x8,%esi
80101cbf:	75 eb                	jne    80101cac <consoleintr+0x76c>
            print_history();
80101cc1:	e8 5a ed ff ff       	call   80100a20 <print_history>
          update_coppied_commands();
80101cc6:	e8 45 ef ff ff       	call   80100c10 <update_coppied_commands>
          wakeup(&input.r);
80101ccb:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80101cce:	a1 c8 15 11 80       	mov    0x801115c8,%eax
          currecnt_com = 0;
80101cd3:	c7 05 60 16 11 80 00 	movl   $0x0,0x80111660
80101cda:	00 00 00 
          wakeup(&input.r);
80101cdd:	68 c0 15 11 80       	push   $0x801115c0
          input.w = input.e;
80101ce2:	a3 c4 15 11 80       	mov    %eax,0x801115c4
          wakeup(&input.r);
80101ce7:	e8 44 38 00 00       	call   80105530 <wakeup>
80101cec:	83 c4 10             	add    $0x10,%esp
80101cef:	e9 6f f8 ff ff       	jmp    80101563 <consoleintr+0x23>
        if(ctrl_s_pressed){
80101cf4:	85 d2                	test   %edx,%edx
80101cf6:	0f 85 8d fe ff ff    	jne    80101b89 <consoleintr+0x649>
80101cfc:	c6 45 e0 0a          	movb   $0xa,-0x20(%ebp)
        c = (c == '\r') ? '\n' : c;
80101d00:	bb 0a 00 00 00       	mov    $0xa,%ebx
        if(num_of_left_pressed == 0 || c == '\n'){
80101d05:	c6 45 d8 01          	movb   $0x1,-0x28(%ebp)
80101d09:	e9 a3 fd ff ff       	jmp    80101ab1 <consoleintr+0x571>
  int limit = input.e - num_of_left_pressed - 1;
80101d0e:	89 c7                	mov    %eax,%edi
80101d10:	2b 7d d4             	sub    -0x2c(%ebp),%edi
  int init = input.e - 1;
80101d13:	8d 48 ff             	lea    -0x1(%eax),%ecx
  int limit = input.e - num_of_left_pressed - 1;
80101d16:	89 7d d8             	mov    %edi,-0x28(%ebp)
80101d19:	83 ef 01             	sub    $0x1,%edi
  for(int i = init; i > limit; i--){
80101d1c:	39 f9                	cmp    %edi,%ecx
80101d1e:	7e 42                	jle    80101d62 <consoleintr+0x822>
80101d20:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
80101d23:	89 fb                	mov    %edi,%ebx
80101d25:	89 c7                	mov    %eax,%edi
    input.buf[(i + 1) % INPUT_BUF] = input.buf[i % INPUT_BUF];
80101d27:	89 ca                	mov    %ecx,%edx
80101d29:	c1 fa 1f             	sar    $0x1f,%edx
80101d2c:	c1 ea 19             	shr    $0x19,%edx
80101d2f:	8d 04 11             	lea    (%ecx,%edx,1),%eax
80101d32:	83 e0 7f             	and    $0x7f,%eax
80101d35:	29 d0                	sub    %edx,%eax
80101d37:	8d 51 01             	lea    0x1(%ecx),%edx
  for(int i = init; i > limit; i--){
80101d3a:	83 e9 01             	sub    $0x1,%ecx
    input.buf[(i + 1) % INPUT_BUF] = input.buf[i % INPUT_BUF];
80101d3d:	89 d6                	mov    %edx,%esi
80101d3f:	0f b6 80 40 15 11 80 	movzbl -0x7feeeac0(%eax),%eax
80101d46:	c1 fe 1f             	sar    $0x1f,%esi
80101d49:	c1 ee 19             	shr    $0x19,%esi
80101d4c:	01 f2                	add    %esi,%edx
80101d4e:	83 e2 7f             	and    $0x7f,%edx
80101d51:	29 f2                	sub    %esi,%edx
80101d53:	88 82 40 15 11 80    	mov    %al,-0x7feeeac0(%edx)
  for(int i = init; i > limit; i--){
80101d59:	39 cb                	cmp    %ecx,%ebx
80101d5b:	7c ca                	jl     80101d27 <consoleintr+0x7e7>
80101d5d:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
80101d60:	89 f8                	mov    %edi,%eax
          input.buf[(input.e - num_of_left_pressed) % INPUT_BUF] = c;
80101d62:	8b 55 d8             	mov    -0x28(%ebp),%edx
80101d65:	0f b6 4d e0          	movzbl -0x20(%ebp),%ecx
          input.e++;
80101d69:	83 c0 01             	add    $0x1,%eax
        if(num_of_left_pressed == 0 || c == '\n'){
80101d6c:	c6 45 d8 00          	movb   $0x0,-0x28(%ebp)
          input.e++;
80101d70:	a3 c8 15 11 80       	mov    %eax,0x801115c8
          input.buf[(input.e - num_of_left_pressed) % INPUT_BUF] = c;
80101d75:	83 e2 7f             	and    $0x7f,%edx
80101d78:	88 8a 40 15 11 80    	mov    %cl,-0x7feeeac0(%edx)
          input.e++;
80101d7e:	e9 44 fd ff ff       	jmp    80101ac7 <consoleintr+0x587>
  for(int i = cur_index - num_of_left_copy - 1; i < cur_index; i++){
80101d83:	89 fb                	mov    %edi,%ebx
80101d85:	29 d3                	sub    %edx,%ebx
80101d87:	83 eb 01             	sub    $0x1,%ebx
80101d8a:	39 fb                	cmp    %edi,%ebx
80101d8c:	7d 3a                	jge    80101dc8 <consoleintr+0x888>
80101d8e:	89 c7                	mov    %eax,%edi
    coppied_input[i % INPUT_BUF] = coppied_input[(i + 1) % INPUT_BUF];
80101d90:	89 da                	mov    %ebx,%edx
80101d92:	83 c3 01             	add    $0x1,%ebx
80101d95:	89 de                	mov    %ebx,%esi
80101d97:	c1 fe 1f             	sar    $0x1f,%esi
80101d9a:	c1 ee 19             	shr    $0x19,%esi
80101d9d:	8d 04 33             	lea    (%ebx,%esi,1),%eax
80101da0:	83 e0 7f             	and    $0x7f,%eax
80101da3:	29 f0                	sub    %esi,%eax
80101da5:	89 d6                	mov    %edx,%esi
80101da7:	c1 fe 1f             	sar    $0x1f,%esi
80101daa:	0f b6 80 e0 15 11 80 	movzbl -0x7feeea20(%eax),%eax
80101db1:	c1 ee 19             	shr    $0x19,%esi
80101db4:	01 f2                	add    %esi,%edx
80101db6:	83 e2 7f             	and    $0x7f,%edx
80101db9:	29 f2                	sub    %esi,%edx
80101dbb:	88 82 e0 15 11 80    	mov    %al,-0x7feeea20(%edx)
  for(int i = cur_index - num_of_left_copy - 1; i < cur_index; i++){
80101dc1:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
80101dc4:	75 ca                	jne    80101d90 <consoleintr+0x850>
80101dc6:	89 f8                	mov    %edi,%eax
            coppied_input[cur_index - 1] = '\0';
80101dc8:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101dcb:	c6 82 df 15 11 80 00 	movb   $0x0,-0x7feeea21(%edx)
80101dd2:	83 ea 01             	sub    $0x1,%edx
            cur_index--;
80101dd5:	89 15 d4 15 11 80    	mov    %edx,0x801115d4
80101ddb:	e9 94 f9 ff ff       	jmp    80101774 <consoleintr+0x234>
  int init = cur_index - 1;
80101de0:	8d 4f ff             	lea    -0x1(%edi),%ecx
  int limit = cur_index - 1 - num_of_left_copy;
80101de3:	89 ce                	mov    %ecx,%esi
80101de5:	29 d6                	sub    %edx,%esi
80101de7:	89 75 d0             	mov    %esi,-0x30(%ebp)
  for(int i = init; i > limit; i--){
80101dea:	39 f1                	cmp    %esi,%ecx
80101dec:	7e 41                	jle    80101e2f <consoleintr+0x8ef>
80101dee:	89 5d c8             	mov    %ebx,-0x38(%ebp)
80101df1:	89 c6                	mov    %eax,%esi
    coppied_input[(i + 1) % INPUT_BUF] = coppied_input[i % INPUT_BUF];
80101df3:	89 ca                	mov    %ecx,%edx
80101df5:	c1 fa 1f             	sar    $0x1f,%edx
80101df8:	c1 ea 19             	shr    $0x19,%edx
80101dfb:	8d 04 11             	lea    (%ecx,%edx,1),%eax
80101dfe:	83 e0 7f             	and    $0x7f,%eax
80101e01:	29 d0                	sub    %edx,%eax
80101e03:	8d 51 01             	lea    0x1(%ecx),%edx
  for(int i = init; i > limit; i--){
80101e06:	83 e9 01             	sub    $0x1,%ecx
    coppied_input[(i + 1) % INPUT_BUF] = coppied_input[i % INPUT_BUF];
80101e09:	89 d3                	mov    %edx,%ebx
80101e0b:	0f b6 80 e0 15 11 80 	movzbl -0x7feeea20(%eax),%eax
80101e12:	c1 fb 1f             	sar    $0x1f,%ebx
80101e15:	c1 eb 19             	shr    $0x19,%ebx
80101e18:	01 da                	add    %ebx,%edx
80101e1a:	83 e2 7f             	and    $0x7f,%edx
80101e1d:	29 da                	sub    %ebx,%edx
80101e1f:	88 82 e0 15 11 80    	mov    %al,-0x7feeea20(%edx)
  for(int i = init; i > limit; i--){
80101e25:	39 4d d0             	cmp    %ecx,-0x30(%ebp)
80101e28:	75 c9                	jne    80101df3 <consoleintr+0x8b3>
80101e2a:	8b 5d c8             	mov    -0x38(%ebp),%ebx
80101e2d:	89 f0                	mov    %esi,%eax
              coppied_input[cur_index - num_of_left_copy] = c;
80101e2f:	0f b6 4d e0          	movzbl -0x20(%ebp),%ecx
80101e33:	89 fa                	mov    %edi,%edx
80101e35:	2b 55 cc             	sub    -0x34(%ebp),%edx
80101e38:	88 8a e0 15 11 80    	mov    %cl,-0x7feeea20(%edx)
              cur_index++;
80101e3e:	8d 57 01             	lea    0x1(%edi),%edx
80101e41:	89 15 d4 15 11 80    	mov    %edx,0x801115d4
80101e47:	e9 54 fc ff ff       	jmp    80101aa0 <consoleintr+0x560>
80101e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101e50 <consoleinit>:

void
consoleinit(void)
{
80101e50:	55                   	push   %ebp
80101e51:	89 e5                	mov    %esp,%ebp
80101e53:	83 ec 10             	sub    $0x10,%esp

  history_cmnd.num_of_cmnd = 0;
80101e56:	c7 05 24 15 11 80 00 	movl   $0x0,0x80111524
80101e5d:	00 00 00 
  history_cmnd.start_index = 0;
  history_cmnd.num_of_press = 0;

  initlock(&cons.lock, "console");
80101e60:	68 68 8c 10 80       	push   $0x80108c68
80101e65:	68 80 16 11 80       	push   $0x80111680
  history_cmnd.start_index = 0;
80101e6a:	c7 05 28 15 11 80 00 	movl   $0x0,0x80111528
80101e71:	00 00 00 
  history_cmnd.num_of_press = 0;
80101e74:	c7 05 2c 15 11 80 00 	movl   $0x0,0x8011152c
80101e7b:	00 00 00 
  initlock(&cons.lock, "console");
80101e7e:	e8 0d 3c 00 00       	call   80105a90 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80101e83:	58                   	pop    %eax
80101e84:	5a                   	pop    %edx
80101e85:	6a 00                	push   $0x0
80101e87:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80101e89:	c7 05 8c 20 11 80 f0 	movl   $0x801005f0,0x8011208c
80101e90:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80101e93:	c7 05 88 20 11 80 80 	movl   $0x80100280,0x80112088
80101e9a:	02 10 80 
  cons.locking = 1;
80101e9d:	c7 05 b4 16 11 80 01 	movl   $0x1,0x801116b4
80101ea4:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80101ea7:	e8 e4 19 00 00       	call   80103890 <ioapicenable>
}
80101eac:	83 c4 10             	add    $0x10,%esp
80101eaf:	c9                   	leave  
80101eb0:	c3                   	ret    
80101eb1:	66 90                	xchg   %ax,%ax
80101eb3:	66 90                	xchg   %ax,%ax
80101eb5:	66 90                	xchg   %ax,%ax
80101eb7:	66 90                	xchg   %ax,%ax
80101eb9:	66 90                	xchg   %ax,%ax
80101ebb:	66 90                	xchg   %ax,%ax
80101ebd:	66 90                	xchg   %ax,%ax
80101ebf:	90                   	nop

80101ec0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80101ec0:	55                   	push   %ebp
80101ec1:	89 e5                	mov    %esp,%ebp
80101ec3:	57                   	push   %edi
80101ec4:	56                   	push   %esi
80101ec5:	53                   	push   %ebx
80101ec6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80101ecc:	e8 cf 2e 00 00       	call   80104da0 <myproc>
80101ed1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80101ed7:	e8 94 22 00 00       	call   80104170 <begin_op>

  if((ip = namei(path)) == 0){
80101edc:	83 ec 0c             	sub    $0xc,%esp
80101edf:	ff 75 08             	push   0x8(%ebp)
80101ee2:	e8 c9 15 00 00       	call   801034b0 <namei>
80101ee7:	83 c4 10             	add    $0x10,%esp
80101eea:	85 c0                	test   %eax,%eax
80101eec:	0f 84 02 03 00 00    	je     801021f4 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80101ef2:	83 ec 0c             	sub    $0xc,%esp
80101ef5:	89 c3                	mov    %eax,%ebx
80101ef7:	50                   	push   %eax
80101ef8:	e8 93 0c 00 00       	call   80102b90 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80101efd:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80101f03:	6a 34                	push   $0x34
80101f05:	6a 00                	push   $0x0
80101f07:	50                   	push   %eax
80101f08:	53                   	push   %ebx
80101f09:	e8 92 0f 00 00       	call   80102ea0 <readi>
80101f0e:	83 c4 20             	add    $0x20,%esp
80101f11:	83 f8 34             	cmp    $0x34,%eax
80101f14:	74 22                	je     80101f38 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80101f16:	83 ec 0c             	sub    $0xc,%esp
80101f19:	53                   	push   %ebx
80101f1a:	e8 01 0f 00 00       	call   80102e20 <iunlockput>
    end_op();
80101f1f:	e8 bc 22 00 00       	call   801041e0 <end_op>
80101f24:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80101f27:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101f2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f2f:	5b                   	pop    %ebx
80101f30:	5e                   	pop    %esi
80101f31:	5f                   	pop    %edi
80101f32:	5d                   	pop    %ebp
80101f33:	c3                   	ret    
80101f34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80101f38:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80101f3f:	45 4c 46 
80101f42:	75 d2                	jne    80101f16 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80101f44:	e8 57 69 00 00       	call   801088a0 <setupkvm>
80101f49:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80101f4f:	85 c0                	test   %eax,%eax
80101f51:	74 c3                	je     80101f16 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101f53:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80101f5a:	00 
80101f5b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80101f61:	0f 84 ac 02 00 00    	je     80102213 <exec+0x353>
  sz = 0;
80101f67:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80101f6e:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101f71:	31 ff                	xor    %edi,%edi
80101f73:	e9 8e 00 00 00       	jmp    80102006 <exec+0x146>
80101f78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f7f:	90                   	nop
    if(ph.type != ELF_PROG_LOAD)
80101f80:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80101f87:	75 6c                	jne    80101ff5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80101f89:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80101f8f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80101f95:	0f 82 87 00 00 00    	jb     80102022 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80101f9b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80101fa1:	72 7f                	jb     80102022 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80101fa3:	83 ec 04             	sub    $0x4,%esp
80101fa6:	50                   	push   %eax
80101fa7:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80101fad:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80101fb3:	e8 08 67 00 00       	call   801086c0 <allocuvm>
80101fb8:	83 c4 10             	add    $0x10,%esp
80101fbb:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80101fc1:	85 c0                	test   %eax,%eax
80101fc3:	74 5d                	je     80102022 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80101fc5:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80101fcb:	a9 ff 0f 00 00       	test   $0xfff,%eax
80101fd0:	75 50                	jne    80102022 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80101fd2:	83 ec 0c             	sub    $0xc,%esp
80101fd5:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80101fdb:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80101fe1:	53                   	push   %ebx
80101fe2:	50                   	push   %eax
80101fe3:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80101fe9:	e8 e2 65 00 00       	call   801085d0 <loaduvm>
80101fee:	83 c4 20             	add    $0x20,%esp
80101ff1:	85 c0                	test   %eax,%eax
80101ff3:	78 2d                	js     80102022 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101ff5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80101ffc:	83 c7 01             	add    $0x1,%edi
80101fff:	83 c6 20             	add    $0x20,%esi
80102002:	39 f8                	cmp    %edi,%eax
80102004:	7e 3a                	jle    80102040 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80102006:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
8010200c:	6a 20                	push   $0x20
8010200e:	56                   	push   %esi
8010200f:	50                   	push   %eax
80102010:	53                   	push   %ebx
80102011:	e8 8a 0e 00 00       	call   80102ea0 <readi>
80102016:	83 c4 10             	add    $0x10,%esp
80102019:	83 f8 20             	cmp    $0x20,%eax
8010201c:	0f 84 5e ff ff ff    	je     80101f80 <exec+0xc0>
    freevm(pgdir);
80102022:	83 ec 0c             	sub    $0xc,%esp
80102025:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
8010202b:	e8 f0 67 00 00       	call   80108820 <freevm>
  if(ip){
80102030:	83 c4 10             	add    $0x10,%esp
80102033:	e9 de fe ff ff       	jmp    80101f16 <exec+0x56>
80102038:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010203f:	90                   	nop
  sz = PGROUNDUP(sz);
80102040:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80102046:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
8010204c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80102052:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80102058:	83 ec 0c             	sub    $0xc,%esp
8010205b:	53                   	push   %ebx
8010205c:	e8 bf 0d 00 00       	call   80102e20 <iunlockput>
  end_op();
80102061:	e8 7a 21 00 00       	call   801041e0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80102066:	83 c4 0c             	add    $0xc,%esp
80102069:	56                   	push   %esi
8010206a:	57                   	push   %edi
8010206b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80102071:	57                   	push   %edi
80102072:	e8 49 66 00 00       	call   801086c0 <allocuvm>
80102077:	83 c4 10             	add    $0x10,%esp
8010207a:	89 c6                	mov    %eax,%esi
8010207c:	85 c0                	test   %eax,%eax
8010207e:	0f 84 94 00 00 00    	je     80102118 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80102084:	83 ec 08             	sub    $0x8,%esp
80102087:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
8010208d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
8010208f:	50                   	push   %eax
80102090:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80102091:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80102093:	e8 a8 68 00 00       	call   80108940 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80102098:	8b 45 0c             	mov    0xc(%ebp),%eax
8010209b:	83 c4 10             	add    $0x10,%esp
8010209e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
801020a4:	8b 00                	mov    (%eax),%eax
801020a6:	85 c0                	test   %eax,%eax
801020a8:	0f 84 8b 00 00 00    	je     80102139 <exec+0x279>
801020ae:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
801020b4:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
801020ba:	eb 23                	jmp    801020df <exec+0x21f>
801020bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801020c0:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
801020c3:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
801020ca:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
801020cd:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
801020d3:	8b 04 b8             	mov    (%eax,%edi,4),%eax
801020d6:	85 c0                	test   %eax,%eax
801020d8:	74 59                	je     80102133 <exec+0x273>
    if(argc >= MAXARG)
801020da:	83 ff 20             	cmp    $0x20,%edi
801020dd:	74 39                	je     80102118 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
801020df:	83 ec 0c             	sub    $0xc,%esp
801020e2:	50                   	push   %eax
801020e3:	e8 38 3e 00 00       	call   80105f20 <strlen>
801020e8:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
801020ea:	58                   	pop    %eax
801020eb:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
801020ee:	83 eb 01             	sub    $0x1,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
801020f1:	ff 34 b8             	push   (%eax,%edi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
801020f4:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
801020f7:	e8 24 3e 00 00       	call   80105f20 <strlen>
801020fc:	83 c0 01             	add    $0x1,%eax
801020ff:	50                   	push   %eax
80102100:	8b 45 0c             	mov    0xc(%ebp),%eax
80102103:	ff 34 b8             	push   (%eax,%edi,4)
80102106:	53                   	push   %ebx
80102107:	56                   	push   %esi
80102108:	e8 03 6a 00 00       	call   80108b10 <copyout>
8010210d:	83 c4 20             	add    $0x20,%esp
80102110:	85 c0                	test   %eax,%eax
80102112:	79 ac                	jns    801020c0 <exec+0x200>
80102114:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80102118:	83 ec 0c             	sub    $0xc,%esp
8010211b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80102121:	e8 fa 66 00 00       	call   80108820 <freevm>
80102126:	83 c4 10             	add    $0x10,%esp
  return -1;
80102129:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010212e:	e9 f9 fd ff ff       	jmp    80101f2c <exec+0x6c>
80102133:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80102139:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80102140:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80102142:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80102149:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010214d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
8010214f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80102152:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80102158:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
8010215a:	50                   	push   %eax
8010215b:	52                   	push   %edx
8010215c:	53                   	push   %ebx
8010215d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80102163:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
8010216a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010216d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80102173:	e8 98 69 00 00       	call   80108b10 <copyout>
80102178:	83 c4 10             	add    $0x10,%esp
8010217b:	85 c0                	test   %eax,%eax
8010217d:	78 99                	js     80102118 <exec+0x258>
  for(last=s=path; *s; s++)
8010217f:	8b 45 08             	mov    0x8(%ebp),%eax
80102182:	8b 55 08             	mov    0x8(%ebp),%edx
80102185:	0f b6 00             	movzbl (%eax),%eax
80102188:	84 c0                	test   %al,%al
8010218a:	74 13                	je     8010219f <exec+0x2df>
8010218c:	89 d1                	mov    %edx,%ecx
8010218e:	66 90                	xchg   %ax,%ax
      last = s+1;
80102190:	83 c1 01             	add    $0x1,%ecx
80102193:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80102195:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80102198:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
8010219b:	84 c0                	test   %al,%al
8010219d:	75 f1                	jne    80102190 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
8010219f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
801021a5:	83 ec 04             	sub    $0x4,%esp
801021a8:	6a 10                	push   $0x10
801021aa:	89 f8                	mov    %edi,%eax
801021ac:	52                   	push   %edx
801021ad:	83 c0 6c             	add    $0x6c,%eax
801021b0:	50                   	push   %eax
801021b1:	e8 2a 3d 00 00       	call   80105ee0 <safestrcpy>
  curproc->pgdir = pgdir;
801021b6:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
801021bc:	89 f8                	mov    %edi,%eax
801021be:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
801021c1:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
801021c3:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
801021c6:	89 c1                	mov    %eax,%ecx
801021c8:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
801021ce:	8b 40 18             	mov    0x18(%eax),%eax
801021d1:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
801021d4:	8b 41 18             	mov    0x18(%ecx),%eax
801021d7:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
801021da:	89 0c 24             	mov    %ecx,(%esp)
801021dd:	e8 5e 62 00 00       	call   80108440 <switchuvm>
  freevm(oldpgdir);
801021e2:	89 3c 24             	mov    %edi,(%esp)
801021e5:	e8 36 66 00 00       	call   80108820 <freevm>
  return 0;
801021ea:	83 c4 10             	add    $0x10,%esp
801021ed:	31 c0                	xor    %eax,%eax
801021ef:	e9 38 fd ff ff       	jmp    80101f2c <exec+0x6c>
    end_op();
801021f4:	e8 e7 1f 00 00       	call   801041e0 <end_op>
    cprintf("exec: fail\n");
801021f9:	83 ec 0c             	sub    $0xc,%esp
801021fc:	68 d4 8c 10 80       	push   $0x80108cd4
80102201:	e8 fa e4 ff ff       	call   80100700 <cprintf>
    return -1;
80102206:	83 c4 10             	add    $0x10,%esp
80102209:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010220e:	e9 19 fd ff ff       	jmp    80101f2c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80102213:	be 00 20 00 00       	mov    $0x2000,%esi
80102218:	31 ff                	xor    %edi,%edi
8010221a:	e9 39 fe ff ff       	jmp    80102058 <exec+0x198>
8010221f:	90                   	nop

80102220 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80102220:	55                   	push   %ebp
80102221:	89 e5                	mov    %esp,%ebp
80102223:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80102226:	68 e0 8c 10 80       	push   $0x80108ce0
8010222b:	68 e0 16 11 80       	push   $0x801116e0
80102230:	e8 5b 38 00 00       	call   80105a90 <initlock>
}
80102235:	83 c4 10             	add    $0x10,%esp
80102238:	c9                   	leave  
80102239:	c3                   	ret    
8010223a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102240 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80102240:	55                   	push   %ebp
80102241:	89 e5                	mov    %esp,%ebp
80102243:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80102244:	bb 14 17 11 80       	mov    $0x80111714,%ebx
{
80102249:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
8010224c:	68 e0 16 11 80       	push   $0x801116e0
80102251:	e8 0a 3a 00 00       	call   80105c60 <acquire>
80102256:	83 c4 10             	add    $0x10,%esp
80102259:	eb 10                	jmp    8010226b <filealloc+0x2b>
8010225b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010225f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80102260:	83 c3 18             	add    $0x18,%ebx
80102263:	81 fb 74 20 11 80    	cmp    $0x80112074,%ebx
80102269:	74 25                	je     80102290 <filealloc+0x50>
    if(f->ref == 0){
8010226b:	8b 43 04             	mov    0x4(%ebx),%eax
8010226e:	85 c0                	test   %eax,%eax
80102270:	75 ee                	jne    80102260 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80102272:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80102275:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
8010227c:	68 e0 16 11 80       	push   $0x801116e0
80102281:	e8 7a 39 00 00       	call   80105c00 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80102286:	89 d8                	mov    %ebx,%eax
      return f;
80102288:	83 c4 10             	add    $0x10,%esp
}
8010228b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010228e:	c9                   	leave  
8010228f:	c3                   	ret    
  release(&ftable.lock);
80102290:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80102293:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80102295:	68 e0 16 11 80       	push   $0x801116e0
8010229a:	e8 61 39 00 00       	call   80105c00 <release>
}
8010229f:	89 d8                	mov    %ebx,%eax
  return 0;
801022a1:	83 c4 10             	add    $0x10,%esp
}
801022a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801022a7:	c9                   	leave  
801022a8:	c3                   	ret    
801022a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801022b0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
801022b0:	55                   	push   %ebp
801022b1:	89 e5                	mov    %esp,%ebp
801022b3:	53                   	push   %ebx
801022b4:	83 ec 10             	sub    $0x10,%esp
801022b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
801022ba:	68 e0 16 11 80       	push   $0x801116e0
801022bf:	e8 9c 39 00 00       	call   80105c60 <acquire>
  if(f->ref < 1)
801022c4:	8b 43 04             	mov    0x4(%ebx),%eax
801022c7:	83 c4 10             	add    $0x10,%esp
801022ca:	85 c0                	test   %eax,%eax
801022cc:	7e 1a                	jle    801022e8 <filedup+0x38>
    panic("filedup");
  f->ref++;
801022ce:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
801022d1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
801022d4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
801022d7:	68 e0 16 11 80       	push   $0x801116e0
801022dc:	e8 1f 39 00 00       	call   80105c00 <release>
  return f;
}
801022e1:	89 d8                	mov    %ebx,%eax
801022e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801022e6:	c9                   	leave  
801022e7:	c3                   	ret    
    panic("filedup");
801022e8:	83 ec 0c             	sub    $0xc,%esp
801022eb:	68 e7 8c 10 80       	push   $0x80108ce7
801022f0:	e8 8b e0 ff ff       	call   80100380 <panic>
801022f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102300 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80102300:	55                   	push   %ebp
80102301:	89 e5                	mov    %esp,%ebp
80102303:	57                   	push   %edi
80102304:	56                   	push   %esi
80102305:	53                   	push   %ebx
80102306:	83 ec 28             	sub    $0x28,%esp
80102309:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
8010230c:	68 e0 16 11 80       	push   $0x801116e0
80102311:	e8 4a 39 00 00       	call   80105c60 <acquire>
  if(f->ref < 1)
80102316:	8b 53 04             	mov    0x4(%ebx),%edx
80102319:	83 c4 10             	add    $0x10,%esp
8010231c:	85 d2                	test   %edx,%edx
8010231e:	0f 8e a5 00 00 00    	jle    801023c9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80102324:	83 ea 01             	sub    $0x1,%edx
80102327:	89 53 04             	mov    %edx,0x4(%ebx)
8010232a:	75 44                	jne    80102370 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
8010232c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80102330:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80102333:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80102335:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
8010233b:	8b 73 0c             	mov    0xc(%ebx),%esi
8010233e:	88 45 e7             	mov    %al,-0x19(%ebp)
80102341:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80102344:	68 e0 16 11 80       	push   $0x801116e0
  ff = *f;
80102349:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
8010234c:	e8 af 38 00 00       	call   80105c00 <release>

  if(ff.type == FD_PIPE)
80102351:	83 c4 10             	add    $0x10,%esp
80102354:	83 ff 01             	cmp    $0x1,%edi
80102357:	74 57                	je     801023b0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80102359:	83 ff 02             	cmp    $0x2,%edi
8010235c:	74 2a                	je     80102388 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
8010235e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102361:	5b                   	pop    %ebx
80102362:	5e                   	pop    %esi
80102363:	5f                   	pop    %edi
80102364:	5d                   	pop    %ebp
80102365:	c3                   	ret    
80102366:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010236d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80102370:	c7 45 08 e0 16 11 80 	movl   $0x801116e0,0x8(%ebp)
}
80102377:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010237a:	5b                   	pop    %ebx
8010237b:	5e                   	pop    %esi
8010237c:	5f                   	pop    %edi
8010237d:	5d                   	pop    %ebp
    release(&ftable.lock);
8010237e:	e9 7d 38 00 00       	jmp    80105c00 <release>
80102383:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102387:	90                   	nop
    begin_op();
80102388:	e8 e3 1d 00 00       	call   80104170 <begin_op>
    iput(ff.ip);
8010238d:	83 ec 0c             	sub    $0xc,%esp
80102390:	ff 75 e0             	push   -0x20(%ebp)
80102393:	e8 28 09 00 00       	call   80102cc0 <iput>
    end_op();
80102398:	83 c4 10             	add    $0x10,%esp
}
8010239b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010239e:	5b                   	pop    %ebx
8010239f:	5e                   	pop    %esi
801023a0:	5f                   	pop    %edi
801023a1:	5d                   	pop    %ebp
    end_op();
801023a2:	e9 39 1e 00 00       	jmp    801041e0 <end_op>
801023a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023ae:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
801023b0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
801023b4:	83 ec 08             	sub    $0x8,%esp
801023b7:	53                   	push   %ebx
801023b8:	56                   	push   %esi
801023b9:	e8 82 25 00 00       	call   80104940 <pipeclose>
801023be:	83 c4 10             	add    $0x10,%esp
}
801023c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801023c4:	5b                   	pop    %ebx
801023c5:	5e                   	pop    %esi
801023c6:	5f                   	pop    %edi
801023c7:	5d                   	pop    %ebp
801023c8:	c3                   	ret    
    panic("fileclose");
801023c9:	83 ec 0c             	sub    $0xc,%esp
801023cc:	68 ef 8c 10 80       	push   $0x80108cef
801023d1:	e8 aa df ff ff       	call   80100380 <panic>
801023d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023dd:	8d 76 00             	lea    0x0(%esi),%esi

801023e0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801023e0:	55                   	push   %ebp
801023e1:	89 e5                	mov    %esp,%ebp
801023e3:	53                   	push   %ebx
801023e4:	83 ec 04             	sub    $0x4,%esp
801023e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
801023ea:	83 3b 02             	cmpl   $0x2,(%ebx)
801023ed:	75 31                	jne    80102420 <filestat+0x40>
    ilock(f->ip);
801023ef:	83 ec 0c             	sub    $0xc,%esp
801023f2:	ff 73 10             	push   0x10(%ebx)
801023f5:	e8 96 07 00 00       	call   80102b90 <ilock>
    stati(f->ip, st);
801023fa:	58                   	pop    %eax
801023fb:	5a                   	pop    %edx
801023fc:	ff 75 0c             	push   0xc(%ebp)
801023ff:	ff 73 10             	push   0x10(%ebx)
80102402:	e8 69 0a 00 00       	call   80102e70 <stati>
    iunlock(f->ip);
80102407:	59                   	pop    %ecx
80102408:	ff 73 10             	push   0x10(%ebx)
8010240b:	e8 60 08 00 00       	call   80102c70 <iunlock>
    return 0;
  }
  return -1;
}
80102410:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80102413:	83 c4 10             	add    $0x10,%esp
80102416:	31 c0                	xor    %eax,%eax
}
80102418:	c9                   	leave  
80102419:	c3                   	ret    
8010241a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102420:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80102423:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102428:	c9                   	leave  
80102429:	c3                   	ret    
8010242a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102430 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80102430:	55                   	push   %ebp
80102431:	89 e5                	mov    %esp,%ebp
80102433:	57                   	push   %edi
80102434:	56                   	push   %esi
80102435:	53                   	push   %ebx
80102436:	83 ec 0c             	sub    $0xc,%esp
80102439:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010243c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010243f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80102442:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80102446:	74 60                	je     801024a8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80102448:	8b 03                	mov    (%ebx),%eax
8010244a:	83 f8 01             	cmp    $0x1,%eax
8010244d:	74 41                	je     80102490 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010244f:	83 f8 02             	cmp    $0x2,%eax
80102452:	75 5b                	jne    801024af <fileread+0x7f>
    ilock(f->ip);
80102454:	83 ec 0c             	sub    $0xc,%esp
80102457:	ff 73 10             	push   0x10(%ebx)
8010245a:	e8 31 07 00 00       	call   80102b90 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010245f:	57                   	push   %edi
80102460:	ff 73 14             	push   0x14(%ebx)
80102463:	56                   	push   %esi
80102464:	ff 73 10             	push   0x10(%ebx)
80102467:	e8 34 0a 00 00       	call   80102ea0 <readi>
8010246c:	83 c4 20             	add    $0x20,%esp
8010246f:	89 c6                	mov    %eax,%esi
80102471:	85 c0                	test   %eax,%eax
80102473:	7e 03                	jle    80102478 <fileread+0x48>
      f->off += r;
80102475:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80102478:	83 ec 0c             	sub    $0xc,%esp
8010247b:	ff 73 10             	push   0x10(%ebx)
8010247e:	e8 ed 07 00 00       	call   80102c70 <iunlock>
    return r;
80102483:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80102486:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102489:	89 f0                	mov    %esi,%eax
8010248b:	5b                   	pop    %ebx
8010248c:	5e                   	pop    %esi
8010248d:	5f                   	pop    %edi
8010248e:	5d                   	pop    %ebp
8010248f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80102490:	8b 43 0c             	mov    0xc(%ebx),%eax
80102493:	89 45 08             	mov    %eax,0x8(%ebp)
}
80102496:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102499:	5b                   	pop    %ebx
8010249a:	5e                   	pop    %esi
8010249b:	5f                   	pop    %edi
8010249c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010249d:	e9 3e 26 00 00       	jmp    80104ae0 <piperead>
801024a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801024a8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801024ad:	eb d7                	jmp    80102486 <fileread+0x56>
  panic("fileread");
801024af:	83 ec 0c             	sub    $0xc,%esp
801024b2:	68 f9 8c 10 80       	push   $0x80108cf9
801024b7:	e8 c4 de ff ff       	call   80100380 <panic>
801024bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801024c0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801024c0:	55                   	push   %ebp
801024c1:	89 e5                	mov    %esp,%ebp
801024c3:	57                   	push   %edi
801024c4:	56                   	push   %esi
801024c5:	53                   	push   %ebx
801024c6:	83 ec 1c             	sub    $0x1c,%esp
801024c9:	8b 45 0c             	mov    0xc(%ebp),%eax
801024cc:	8b 5d 08             	mov    0x8(%ebp),%ebx
801024cf:	89 45 dc             	mov    %eax,-0x24(%ebp)
801024d2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801024d5:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
801024d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801024dc:	0f 84 bd 00 00 00    	je     8010259f <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
801024e2:	8b 03                	mov    (%ebx),%eax
801024e4:	83 f8 01             	cmp    $0x1,%eax
801024e7:	0f 84 bf 00 00 00    	je     801025ac <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801024ed:	83 f8 02             	cmp    $0x2,%eax
801024f0:	0f 85 c8 00 00 00    	jne    801025be <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801024f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801024f9:	31 f6                	xor    %esi,%esi
    while(i < n){
801024fb:	85 c0                	test   %eax,%eax
801024fd:	7f 30                	jg     8010252f <filewrite+0x6f>
801024ff:	e9 94 00 00 00       	jmp    80102598 <filewrite+0xd8>
80102504:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80102508:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
8010250b:	83 ec 0c             	sub    $0xc,%esp
8010250e:	ff 73 10             	push   0x10(%ebx)
        f->off += r;
80102511:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80102514:	e8 57 07 00 00       	call   80102c70 <iunlock>
      end_op();
80102519:	e8 c2 1c 00 00       	call   801041e0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010251e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102521:	83 c4 10             	add    $0x10,%esp
80102524:	39 c7                	cmp    %eax,%edi
80102526:	75 5c                	jne    80102584 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80102528:	01 fe                	add    %edi,%esi
    while(i < n){
8010252a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010252d:	7e 69                	jle    80102598 <filewrite+0xd8>
      int n1 = n - i;
8010252f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80102532:	b8 00 06 00 00       	mov    $0x600,%eax
80102537:	29 f7                	sub    %esi,%edi
80102539:	39 c7                	cmp    %eax,%edi
8010253b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010253e:	e8 2d 1c 00 00       	call   80104170 <begin_op>
      ilock(f->ip);
80102543:	83 ec 0c             	sub    $0xc,%esp
80102546:	ff 73 10             	push   0x10(%ebx)
80102549:	e8 42 06 00 00       	call   80102b90 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010254e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80102551:	57                   	push   %edi
80102552:	ff 73 14             	push   0x14(%ebx)
80102555:	01 f0                	add    %esi,%eax
80102557:	50                   	push   %eax
80102558:	ff 73 10             	push   0x10(%ebx)
8010255b:	e8 40 0a 00 00       	call   80102fa0 <writei>
80102560:	83 c4 20             	add    $0x20,%esp
80102563:	85 c0                	test   %eax,%eax
80102565:	7f a1                	jg     80102508 <filewrite+0x48>
      iunlock(f->ip);
80102567:	83 ec 0c             	sub    $0xc,%esp
8010256a:	ff 73 10             	push   0x10(%ebx)
8010256d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80102570:	e8 fb 06 00 00       	call   80102c70 <iunlock>
      end_op();
80102575:	e8 66 1c 00 00       	call   801041e0 <end_op>
      if(r < 0)
8010257a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010257d:	83 c4 10             	add    $0x10,%esp
80102580:	85 c0                	test   %eax,%eax
80102582:	75 1b                	jne    8010259f <filewrite+0xdf>
        panic("short filewrite");
80102584:	83 ec 0c             	sub    $0xc,%esp
80102587:	68 02 8d 10 80       	push   $0x80108d02
8010258c:	e8 ef dd ff ff       	call   80100380 <panic>
80102591:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
80102598:	89 f0                	mov    %esi,%eax
8010259a:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
8010259d:	74 05                	je     801025a4 <filewrite+0xe4>
8010259f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
801025a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801025a7:	5b                   	pop    %ebx
801025a8:	5e                   	pop    %esi
801025a9:	5f                   	pop    %edi
801025aa:	5d                   	pop    %ebp
801025ab:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
801025ac:	8b 43 0c             	mov    0xc(%ebx),%eax
801025af:	89 45 08             	mov    %eax,0x8(%ebp)
}
801025b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801025b5:	5b                   	pop    %ebx
801025b6:	5e                   	pop    %esi
801025b7:	5f                   	pop    %edi
801025b8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801025b9:	e9 22 24 00 00       	jmp    801049e0 <pipewrite>
  panic("filewrite");
801025be:	83 ec 0c             	sub    $0xc,%esp
801025c1:	68 08 8d 10 80       	push   $0x80108d08
801025c6:	e8 b5 dd ff ff       	call   80100380 <panic>
801025cb:	66 90                	xchg   %ax,%ax
801025cd:	66 90                	xchg   %ax,%ax
801025cf:	90                   	nop

801025d0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801025d0:	55                   	push   %ebp
801025d1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801025d3:	89 d0                	mov    %edx,%eax
801025d5:	c1 e8 0c             	shr    $0xc,%eax
801025d8:	03 05 4c 3d 11 80    	add    0x80113d4c,%eax
{
801025de:	89 e5                	mov    %esp,%ebp
801025e0:	56                   	push   %esi
801025e1:	53                   	push   %ebx
801025e2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801025e4:	83 ec 08             	sub    $0x8,%esp
801025e7:	50                   	push   %eax
801025e8:	51                   	push   %ecx
801025e9:	e8 e2 da ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801025ee:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801025f0:	c1 fb 03             	sar    $0x3,%ebx
801025f3:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801025f6:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
801025f8:	83 e1 07             	and    $0x7,%ecx
801025fb:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80102600:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
80102606:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80102608:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
8010260d:	85 c1                	test   %eax,%ecx
8010260f:	74 23                	je     80102634 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80102611:	f7 d0                	not    %eax
  log_write(bp);
80102613:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80102616:	21 c8                	and    %ecx,%eax
80102618:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010261c:	56                   	push   %esi
8010261d:	e8 2e 1d 00 00       	call   80104350 <log_write>
  brelse(bp);
80102622:	89 34 24             	mov    %esi,(%esp)
80102625:	e8 c6 db ff ff       	call   801001f0 <brelse>
}
8010262a:	83 c4 10             	add    $0x10,%esp
8010262d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102630:	5b                   	pop    %ebx
80102631:	5e                   	pop    %esi
80102632:	5d                   	pop    %ebp
80102633:	c3                   	ret    
    panic("freeing free block");
80102634:	83 ec 0c             	sub    $0xc,%esp
80102637:	68 12 8d 10 80       	push   $0x80108d12
8010263c:	e8 3f dd ff ff       	call   80100380 <panic>
80102641:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102648:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010264f:	90                   	nop

80102650 <balloc>:
{
80102650:	55                   	push   %ebp
80102651:	89 e5                	mov    %esp,%ebp
80102653:	57                   	push   %edi
80102654:	56                   	push   %esi
80102655:	53                   	push   %ebx
80102656:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80102659:	8b 0d 34 3d 11 80    	mov    0x80113d34,%ecx
{
8010265f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80102662:	85 c9                	test   %ecx,%ecx
80102664:	0f 84 87 00 00 00    	je     801026f1 <balloc+0xa1>
8010266a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80102671:	8b 75 dc             	mov    -0x24(%ebp),%esi
80102674:	83 ec 08             	sub    $0x8,%esp
80102677:	89 f0                	mov    %esi,%eax
80102679:	c1 f8 0c             	sar    $0xc,%eax
8010267c:	03 05 4c 3d 11 80    	add    0x80113d4c,%eax
80102682:	50                   	push   %eax
80102683:	ff 75 d8             	push   -0x28(%ebp)
80102686:	e8 45 da ff ff       	call   801000d0 <bread>
8010268b:	83 c4 10             	add    $0x10,%esp
8010268e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80102691:	a1 34 3d 11 80       	mov    0x80113d34,%eax
80102696:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102699:	31 c0                	xor    %eax,%eax
8010269b:	eb 2f                	jmp    801026cc <balloc+0x7c>
8010269d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801026a0:	89 c1                	mov    %eax,%ecx
801026a2:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801026a7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801026aa:	83 e1 07             	and    $0x7,%ecx
801026ad:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801026af:	89 c1                	mov    %eax,%ecx
801026b1:	c1 f9 03             	sar    $0x3,%ecx
801026b4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801026b9:	89 fa                	mov    %edi,%edx
801026bb:	85 df                	test   %ebx,%edi
801026bd:	74 41                	je     80102700 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801026bf:	83 c0 01             	add    $0x1,%eax
801026c2:	83 c6 01             	add    $0x1,%esi
801026c5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801026ca:	74 05                	je     801026d1 <balloc+0x81>
801026cc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801026cf:	77 cf                	ja     801026a0 <balloc+0x50>
    brelse(bp);
801026d1:	83 ec 0c             	sub    $0xc,%esp
801026d4:	ff 75 e4             	push   -0x1c(%ebp)
801026d7:	e8 14 db ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801026dc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801026e3:	83 c4 10             	add    $0x10,%esp
801026e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801026e9:	39 05 34 3d 11 80    	cmp    %eax,0x80113d34
801026ef:	77 80                	ja     80102671 <balloc+0x21>
  panic("balloc: out of blocks");
801026f1:	83 ec 0c             	sub    $0xc,%esp
801026f4:	68 25 8d 10 80       	push   $0x80108d25
801026f9:	e8 82 dc ff ff       	call   80100380 <panic>
801026fe:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80102700:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80102703:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80102706:	09 da                	or     %ebx,%edx
80102708:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010270c:	57                   	push   %edi
8010270d:	e8 3e 1c 00 00       	call   80104350 <log_write>
        brelse(bp);
80102712:	89 3c 24             	mov    %edi,(%esp)
80102715:	e8 d6 da ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010271a:	58                   	pop    %eax
8010271b:	5a                   	pop    %edx
8010271c:	56                   	push   %esi
8010271d:	ff 75 d8             	push   -0x28(%ebp)
80102720:	e8 ab d9 ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80102725:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80102728:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010272a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010272d:	68 00 02 00 00       	push   $0x200
80102732:	6a 00                	push   $0x0
80102734:	50                   	push   %eax
80102735:	e8 e6 35 00 00       	call   80105d20 <memset>
  log_write(bp);
8010273a:	89 1c 24             	mov    %ebx,(%esp)
8010273d:	e8 0e 1c 00 00       	call   80104350 <log_write>
  brelse(bp);
80102742:	89 1c 24             	mov    %ebx,(%esp)
80102745:	e8 a6 da ff ff       	call   801001f0 <brelse>
}
8010274a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010274d:	89 f0                	mov    %esi,%eax
8010274f:	5b                   	pop    %ebx
80102750:	5e                   	pop    %esi
80102751:	5f                   	pop    %edi
80102752:	5d                   	pop    %ebp
80102753:	c3                   	ret    
80102754:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010275b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010275f:	90                   	nop

80102760 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80102760:	55                   	push   %ebp
80102761:	89 e5                	mov    %esp,%ebp
80102763:	57                   	push   %edi
80102764:	89 c7                	mov    %eax,%edi
80102766:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80102767:	31 f6                	xor    %esi,%esi
{
80102769:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010276a:	bb 14 21 11 80       	mov    $0x80112114,%ebx
{
8010276f:	83 ec 28             	sub    $0x28,%esp
80102772:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80102775:	68 e0 20 11 80       	push   $0x801120e0
8010277a:	e8 e1 34 00 00       	call   80105c60 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010277f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80102782:	83 c4 10             	add    $0x10,%esp
80102785:	eb 1b                	jmp    801027a2 <iget+0x42>
80102787:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010278e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80102790:	39 3b                	cmp    %edi,(%ebx)
80102792:	74 6c                	je     80102800 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80102794:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010279a:	81 fb 34 3d 11 80    	cmp    $0x80113d34,%ebx
801027a0:	73 26                	jae    801027c8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801027a2:	8b 43 08             	mov    0x8(%ebx),%eax
801027a5:	85 c0                	test   %eax,%eax
801027a7:	7f e7                	jg     80102790 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801027a9:	85 f6                	test   %esi,%esi
801027ab:	75 e7                	jne    80102794 <iget+0x34>
801027ad:	85 c0                	test   %eax,%eax
801027af:	75 76                	jne    80102827 <iget+0xc7>
801027b1:	89 de                	mov    %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801027b3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801027b9:	81 fb 34 3d 11 80    	cmp    $0x80113d34,%ebx
801027bf:	72 e1                	jb     801027a2 <iget+0x42>
801027c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801027c8:	85 f6                	test   %esi,%esi
801027ca:	74 79                	je     80102845 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801027cc:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801027cf:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801027d1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801027d4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801027db:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801027e2:	68 e0 20 11 80       	push   $0x801120e0
801027e7:	e8 14 34 00 00       	call   80105c00 <release>

  return ip;
801027ec:	83 c4 10             	add    $0x10,%esp
}
801027ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
801027f2:	89 f0                	mov    %esi,%eax
801027f4:	5b                   	pop    %ebx
801027f5:	5e                   	pop    %esi
801027f6:	5f                   	pop    %edi
801027f7:	5d                   	pop    %ebp
801027f8:	c3                   	ret    
801027f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80102800:	39 53 04             	cmp    %edx,0x4(%ebx)
80102803:	75 8f                	jne    80102794 <iget+0x34>
      release(&icache.lock);
80102805:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80102808:	83 c0 01             	add    $0x1,%eax
      return ip;
8010280b:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010280d:	68 e0 20 11 80       	push   $0x801120e0
      ip->ref++;
80102812:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80102815:	e8 e6 33 00 00       	call   80105c00 <release>
      return ip;
8010281a:	83 c4 10             	add    $0x10,%esp
}
8010281d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102820:	89 f0                	mov    %esi,%eax
80102822:	5b                   	pop    %ebx
80102823:	5e                   	pop    %esi
80102824:	5f                   	pop    %edi
80102825:	5d                   	pop    %ebp
80102826:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80102827:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010282d:	81 fb 34 3d 11 80    	cmp    $0x80113d34,%ebx
80102833:	73 10                	jae    80102845 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80102835:	8b 43 08             	mov    0x8(%ebx),%eax
80102838:	85 c0                	test   %eax,%eax
8010283a:	0f 8f 50 ff ff ff    	jg     80102790 <iget+0x30>
80102840:	e9 68 ff ff ff       	jmp    801027ad <iget+0x4d>
    panic("iget: no inodes");
80102845:	83 ec 0c             	sub    $0xc,%esp
80102848:	68 3b 8d 10 80       	push   $0x80108d3b
8010284d:	e8 2e db ff ff       	call   80100380 <panic>
80102852:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102860 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80102860:	55                   	push   %ebp
80102861:	89 e5                	mov    %esp,%ebp
80102863:	57                   	push   %edi
80102864:	56                   	push   %esi
80102865:	89 c6                	mov    %eax,%esi
80102867:	53                   	push   %ebx
80102868:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010286b:	83 fa 0b             	cmp    $0xb,%edx
8010286e:	0f 86 8c 00 00 00    	jbe    80102900 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80102874:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80102877:	83 fb 7f             	cmp    $0x7f,%ebx
8010287a:	0f 87 a2 00 00 00    	ja     80102922 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80102880:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80102886:	85 c0                	test   %eax,%eax
80102888:	74 5e                	je     801028e8 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010288a:	83 ec 08             	sub    $0x8,%esp
8010288d:	50                   	push   %eax
8010288e:	ff 36                	push   (%esi)
80102890:	e8 3b d8 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80102895:	83 c4 10             	add    $0x10,%esp
80102898:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
8010289c:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
8010289e:	8b 3b                	mov    (%ebx),%edi
801028a0:	85 ff                	test   %edi,%edi
801028a2:	74 1c                	je     801028c0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801028a4:	83 ec 0c             	sub    $0xc,%esp
801028a7:	52                   	push   %edx
801028a8:	e8 43 d9 ff ff       	call   801001f0 <brelse>
801028ad:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801028b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801028b3:	89 f8                	mov    %edi,%eax
801028b5:	5b                   	pop    %ebx
801028b6:	5e                   	pop    %esi
801028b7:	5f                   	pop    %edi
801028b8:	5d                   	pop    %ebp
801028b9:	c3                   	ret    
801028ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801028c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
801028c3:	8b 06                	mov    (%esi),%eax
801028c5:	e8 86 fd ff ff       	call   80102650 <balloc>
      log_write(bp);
801028ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801028cd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801028d0:	89 03                	mov    %eax,(%ebx)
801028d2:	89 c7                	mov    %eax,%edi
      log_write(bp);
801028d4:	52                   	push   %edx
801028d5:	e8 76 1a 00 00       	call   80104350 <log_write>
801028da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801028dd:	83 c4 10             	add    $0x10,%esp
801028e0:	eb c2                	jmp    801028a4 <bmap+0x44>
801028e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801028e8:	8b 06                	mov    (%esi),%eax
801028ea:	e8 61 fd ff ff       	call   80102650 <balloc>
801028ef:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801028f5:	eb 93                	jmp    8010288a <bmap+0x2a>
801028f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028fe:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
80102900:	8d 5a 14             	lea    0x14(%edx),%ebx
80102903:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80102907:	85 ff                	test   %edi,%edi
80102909:	75 a5                	jne    801028b0 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010290b:	8b 00                	mov    (%eax),%eax
8010290d:	e8 3e fd ff ff       	call   80102650 <balloc>
80102912:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80102916:	89 c7                	mov    %eax,%edi
}
80102918:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010291b:	5b                   	pop    %ebx
8010291c:	89 f8                	mov    %edi,%eax
8010291e:	5e                   	pop    %esi
8010291f:	5f                   	pop    %edi
80102920:	5d                   	pop    %ebp
80102921:	c3                   	ret    
  panic("bmap: out of range");
80102922:	83 ec 0c             	sub    $0xc,%esp
80102925:	68 4b 8d 10 80       	push   $0x80108d4b
8010292a:	e8 51 da ff ff       	call   80100380 <panic>
8010292f:	90                   	nop

80102930 <readsb>:
{
80102930:	55                   	push   %ebp
80102931:	89 e5                	mov    %esp,%ebp
80102933:	56                   	push   %esi
80102934:	53                   	push   %ebx
80102935:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80102938:	83 ec 08             	sub    $0x8,%esp
8010293b:	6a 01                	push   $0x1
8010293d:	ff 75 08             	push   0x8(%ebp)
80102940:	e8 8b d7 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80102945:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80102948:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010294a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010294d:	6a 1c                	push   $0x1c
8010294f:	50                   	push   %eax
80102950:	56                   	push   %esi
80102951:	e8 6a 34 00 00       	call   80105dc0 <memmove>
  brelse(bp);
80102956:	89 5d 08             	mov    %ebx,0x8(%ebp)
80102959:	83 c4 10             	add    $0x10,%esp
}
8010295c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010295f:	5b                   	pop    %ebx
80102960:	5e                   	pop    %esi
80102961:	5d                   	pop    %ebp
  brelse(bp);
80102962:	e9 89 d8 ff ff       	jmp    801001f0 <brelse>
80102967:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010296e:	66 90                	xchg   %ax,%ax

80102970 <iinit>:
{
80102970:	55                   	push   %ebp
80102971:	89 e5                	mov    %esp,%ebp
80102973:	53                   	push   %ebx
80102974:	bb 20 21 11 80       	mov    $0x80112120,%ebx
80102979:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010297c:	68 5e 8d 10 80       	push   $0x80108d5e
80102981:	68 e0 20 11 80       	push   $0x801120e0
80102986:	e8 05 31 00 00       	call   80105a90 <initlock>
  for(i = 0; i < NINODE; i++) {
8010298b:	83 c4 10             	add    $0x10,%esp
8010298e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80102990:	83 ec 08             	sub    $0x8,%esp
80102993:	68 65 8d 10 80       	push   $0x80108d65
80102998:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80102999:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010299f:	e8 bc 2f 00 00       	call   80105960 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801029a4:	83 c4 10             	add    $0x10,%esp
801029a7:	81 fb 40 3d 11 80    	cmp    $0x80113d40,%ebx
801029ad:	75 e1                	jne    80102990 <iinit+0x20>
  bp = bread(dev, 1);
801029af:	83 ec 08             	sub    $0x8,%esp
801029b2:	6a 01                	push   $0x1
801029b4:	ff 75 08             	push   0x8(%ebp)
801029b7:	e8 14 d7 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801029bc:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801029bf:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801029c1:	8d 40 5c             	lea    0x5c(%eax),%eax
801029c4:	6a 1c                	push   $0x1c
801029c6:	50                   	push   %eax
801029c7:	68 34 3d 11 80       	push   $0x80113d34
801029cc:	e8 ef 33 00 00       	call   80105dc0 <memmove>
  brelse(bp);
801029d1:	89 1c 24             	mov    %ebx,(%esp)
801029d4:	e8 17 d8 ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801029d9:	ff 35 4c 3d 11 80    	push   0x80113d4c
801029df:	ff 35 48 3d 11 80    	push   0x80113d48
801029e5:	ff 35 44 3d 11 80    	push   0x80113d44
801029eb:	ff 35 40 3d 11 80    	push   0x80113d40
801029f1:	ff 35 3c 3d 11 80    	push   0x80113d3c
801029f7:	ff 35 38 3d 11 80    	push   0x80113d38
801029fd:	ff 35 34 3d 11 80    	push   0x80113d34
80102a03:	68 c8 8d 10 80       	push   $0x80108dc8
80102a08:	e8 f3 dc ff ff       	call   80100700 <cprintf>
}
80102a0d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a10:	83 c4 30             	add    $0x30,%esp
80102a13:	c9                   	leave  
80102a14:	c3                   	ret    
80102a15:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102a20 <ialloc>:
{
80102a20:	55                   	push   %ebp
80102a21:	89 e5                	mov    %esp,%ebp
80102a23:	57                   	push   %edi
80102a24:	56                   	push   %esi
80102a25:	53                   	push   %ebx
80102a26:	83 ec 1c             	sub    $0x1c,%esp
80102a29:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
80102a2c:	83 3d 3c 3d 11 80 01 	cmpl   $0x1,0x80113d3c
{
80102a33:	8b 75 08             	mov    0x8(%ebp),%esi
80102a36:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80102a39:	0f 86 91 00 00 00    	jbe    80102ad0 <ialloc+0xb0>
80102a3f:	bf 01 00 00 00       	mov    $0x1,%edi
80102a44:	eb 21                	jmp    80102a67 <ialloc+0x47>
80102a46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a4d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80102a50:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80102a53:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80102a56:	53                   	push   %ebx
80102a57:	e8 94 d7 ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
80102a5c:	83 c4 10             	add    $0x10,%esp
80102a5f:	3b 3d 3c 3d 11 80    	cmp    0x80113d3c,%edi
80102a65:	73 69                	jae    80102ad0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80102a67:	89 f8                	mov    %edi,%eax
80102a69:	83 ec 08             	sub    $0x8,%esp
80102a6c:	c1 e8 03             	shr    $0x3,%eax
80102a6f:	03 05 48 3d 11 80    	add    0x80113d48,%eax
80102a75:	50                   	push   %eax
80102a76:	56                   	push   %esi
80102a77:	e8 54 d6 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
80102a7c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
80102a7f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80102a81:	89 f8                	mov    %edi,%eax
80102a83:	83 e0 07             	and    $0x7,%eax
80102a86:	c1 e0 06             	shl    $0x6,%eax
80102a89:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
80102a8d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80102a91:	75 bd                	jne    80102a50 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80102a93:	83 ec 04             	sub    $0x4,%esp
80102a96:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80102a99:	6a 40                	push   $0x40
80102a9b:	6a 00                	push   $0x0
80102a9d:	51                   	push   %ecx
80102a9e:	e8 7d 32 00 00       	call   80105d20 <memset>
      dip->type = type;
80102aa3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80102aa7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80102aaa:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
80102aad:	89 1c 24             	mov    %ebx,(%esp)
80102ab0:	e8 9b 18 00 00       	call   80104350 <log_write>
      brelse(bp);
80102ab5:	89 1c 24             	mov    %ebx,(%esp)
80102ab8:	e8 33 d7 ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
80102abd:	83 c4 10             	add    $0x10,%esp
}
80102ac0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80102ac3:	89 fa                	mov    %edi,%edx
}
80102ac5:	5b                   	pop    %ebx
      return iget(dev, inum);
80102ac6:	89 f0                	mov    %esi,%eax
}
80102ac8:	5e                   	pop    %esi
80102ac9:	5f                   	pop    %edi
80102aca:	5d                   	pop    %ebp
      return iget(dev, inum);
80102acb:	e9 90 fc ff ff       	jmp    80102760 <iget>
  panic("ialloc: no inodes");
80102ad0:	83 ec 0c             	sub    $0xc,%esp
80102ad3:	68 6b 8d 10 80       	push   $0x80108d6b
80102ad8:	e8 a3 d8 ff ff       	call   80100380 <panic>
80102add:	8d 76 00             	lea    0x0(%esi),%esi

80102ae0 <iupdate>:
{
80102ae0:	55                   	push   %ebp
80102ae1:	89 e5                	mov    %esp,%ebp
80102ae3:	56                   	push   %esi
80102ae4:	53                   	push   %ebx
80102ae5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80102ae8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80102aeb:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80102aee:	83 ec 08             	sub    $0x8,%esp
80102af1:	c1 e8 03             	shr    $0x3,%eax
80102af4:	03 05 48 3d 11 80    	add    0x80113d48,%eax
80102afa:	50                   	push   %eax
80102afb:	ff 73 a4             	push   -0x5c(%ebx)
80102afe:	e8 cd d5 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80102b03:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80102b07:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80102b0a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80102b0c:	8b 43 a8             	mov    -0x58(%ebx),%eax
80102b0f:	83 e0 07             	and    $0x7,%eax
80102b12:	c1 e0 06             	shl    $0x6,%eax
80102b15:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80102b19:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80102b1c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80102b20:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80102b23:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80102b27:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
80102b2b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80102b2f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80102b33:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80102b37:	8b 53 fc             	mov    -0x4(%ebx),%edx
80102b3a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80102b3d:	6a 34                	push   $0x34
80102b3f:	53                   	push   %ebx
80102b40:	50                   	push   %eax
80102b41:	e8 7a 32 00 00       	call   80105dc0 <memmove>
  log_write(bp);
80102b46:	89 34 24             	mov    %esi,(%esp)
80102b49:	e8 02 18 00 00       	call   80104350 <log_write>
  brelse(bp);
80102b4e:	89 75 08             	mov    %esi,0x8(%ebp)
80102b51:	83 c4 10             	add    $0x10,%esp
}
80102b54:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b57:	5b                   	pop    %ebx
80102b58:	5e                   	pop    %esi
80102b59:	5d                   	pop    %ebp
  brelse(bp);
80102b5a:	e9 91 d6 ff ff       	jmp    801001f0 <brelse>
80102b5f:	90                   	nop

80102b60 <idup>:
{
80102b60:	55                   	push   %ebp
80102b61:	89 e5                	mov    %esp,%ebp
80102b63:	53                   	push   %ebx
80102b64:	83 ec 10             	sub    $0x10,%esp
80102b67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
80102b6a:	68 e0 20 11 80       	push   $0x801120e0
80102b6f:	e8 ec 30 00 00       	call   80105c60 <acquire>
  ip->ref++;
80102b74:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80102b78:	c7 04 24 e0 20 11 80 	movl   $0x801120e0,(%esp)
80102b7f:	e8 7c 30 00 00       	call   80105c00 <release>
}
80102b84:	89 d8                	mov    %ebx,%eax
80102b86:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b89:	c9                   	leave  
80102b8a:	c3                   	ret    
80102b8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102b8f:	90                   	nop

80102b90 <ilock>:
{
80102b90:	55                   	push   %ebp
80102b91:	89 e5                	mov    %esp,%ebp
80102b93:	56                   	push   %esi
80102b94:	53                   	push   %ebx
80102b95:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80102b98:	85 db                	test   %ebx,%ebx
80102b9a:	0f 84 b7 00 00 00    	je     80102c57 <ilock+0xc7>
80102ba0:	8b 53 08             	mov    0x8(%ebx),%edx
80102ba3:	85 d2                	test   %edx,%edx
80102ba5:	0f 8e ac 00 00 00    	jle    80102c57 <ilock+0xc7>
  acquiresleep(&ip->lock);
80102bab:	83 ec 0c             	sub    $0xc,%esp
80102bae:	8d 43 0c             	lea    0xc(%ebx),%eax
80102bb1:	50                   	push   %eax
80102bb2:	e8 e9 2d 00 00       	call   801059a0 <acquiresleep>
  if(ip->valid == 0){
80102bb7:	8b 43 4c             	mov    0x4c(%ebx),%eax
80102bba:	83 c4 10             	add    $0x10,%esp
80102bbd:	85 c0                	test   %eax,%eax
80102bbf:	74 0f                	je     80102bd0 <ilock+0x40>
}
80102bc1:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102bc4:	5b                   	pop    %ebx
80102bc5:	5e                   	pop    %esi
80102bc6:	5d                   	pop    %ebp
80102bc7:	c3                   	ret    
80102bc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102bcf:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80102bd0:	8b 43 04             	mov    0x4(%ebx),%eax
80102bd3:	83 ec 08             	sub    $0x8,%esp
80102bd6:	c1 e8 03             	shr    $0x3,%eax
80102bd9:	03 05 48 3d 11 80    	add    0x80113d48,%eax
80102bdf:	50                   	push   %eax
80102be0:	ff 33                	push   (%ebx)
80102be2:	e8 e9 d4 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80102be7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80102bea:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80102bec:	8b 43 04             	mov    0x4(%ebx),%eax
80102bef:	83 e0 07             	and    $0x7,%eax
80102bf2:	c1 e0 06             	shl    $0x6,%eax
80102bf5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80102bf9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80102bfc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
80102bff:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80102c03:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80102c07:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80102c0b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
80102c0f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80102c13:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80102c17:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80102c1b:	8b 50 fc             	mov    -0x4(%eax),%edx
80102c1e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80102c21:	6a 34                	push   $0x34
80102c23:	50                   	push   %eax
80102c24:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102c27:	50                   	push   %eax
80102c28:	e8 93 31 00 00       	call   80105dc0 <memmove>
    brelse(bp);
80102c2d:	89 34 24             	mov    %esi,(%esp)
80102c30:	e8 bb d5 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80102c35:	83 c4 10             	add    $0x10,%esp
80102c38:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
80102c3d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80102c44:	0f 85 77 ff ff ff    	jne    80102bc1 <ilock+0x31>
      panic("ilock: no type");
80102c4a:	83 ec 0c             	sub    $0xc,%esp
80102c4d:	68 83 8d 10 80       	push   $0x80108d83
80102c52:	e8 29 d7 ff ff       	call   80100380 <panic>
    panic("ilock");
80102c57:	83 ec 0c             	sub    $0xc,%esp
80102c5a:	68 7d 8d 10 80       	push   $0x80108d7d
80102c5f:	e8 1c d7 ff ff       	call   80100380 <panic>
80102c64:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c6f:	90                   	nop

80102c70 <iunlock>:
{
80102c70:	55                   	push   %ebp
80102c71:	89 e5                	mov    %esp,%ebp
80102c73:	56                   	push   %esi
80102c74:	53                   	push   %ebx
80102c75:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102c78:	85 db                	test   %ebx,%ebx
80102c7a:	74 28                	je     80102ca4 <iunlock+0x34>
80102c7c:	83 ec 0c             	sub    $0xc,%esp
80102c7f:	8d 73 0c             	lea    0xc(%ebx),%esi
80102c82:	56                   	push   %esi
80102c83:	e8 b8 2d 00 00       	call   80105a40 <holdingsleep>
80102c88:	83 c4 10             	add    $0x10,%esp
80102c8b:	85 c0                	test   %eax,%eax
80102c8d:	74 15                	je     80102ca4 <iunlock+0x34>
80102c8f:	8b 43 08             	mov    0x8(%ebx),%eax
80102c92:	85 c0                	test   %eax,%eax
80102c94:	7e 0e                	jle    80102ca4 <iunlock+0x34>
  releasesleep(&ip->lock);
80102c96:	89 75 08             	mov    %esi,0x8(%ebp)
}
80102c99:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102c9c:	5b                   	pop    %ebx
80102c9d:	5e                   	pop    %esi
80102c9e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80102c9f:	e9 5c 2d 00 00       	jmp    80105a00 <releasesleep>
    panic("iunlock");
80102ca4:	83 ec 0c             	sub    $0xc,%esp
80102ca7:	68 92 8d 10 80       	push   $0x80108d92
80102cac:	e8 cf d6 ff ff       	call   80100380 <panic>
80102cb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102cb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102cbf:	90                   	nop

80102cc0 <iput>:
{
80102cc0:	55                   	push   %ebp
80102cc1:	89 e5                	mov    %esp,%ebp
80102cc3:	57                   	push   %edi
80102cc4:	56                   	push   %esi
80102cc5:	53                   	push   %ebx
80102cc6:	83 ec 28             	sub    $0x28,%esp
80102cc9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80102ccc:	8d 7b 0c             	lea    0xc(%ebx),%edi
80102ccf:	57                   	push   %edi
80102cd0:	e8 cb 2c 00 00       	call   801059a0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80102cd5:	8b 53 4c             	mov    0x4c(%ebx),%edx
80102cd8:	83 c4 10             	add    $0x10,%esp
80102cdb:	85 d2                	test   %edx,%edx
80102cdd:	74 07                	je     80102ce6 <iput+0x26>
80102cdf:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80102ce4:	74 32                	je     80102d18 <iput+0x58>
  releasesleep(&ip->lock);
80102ce6:	83 ec 0c             	sub    $0xc,%esp
80102ce9:	57                   	push   %edi
80102cea:	e8 11 2d 00 00       	call   80105a00 <releasesleep>
  acquire(&icache.lock);
80102cef:	c7 04 24 e0 20 11 80 	movl   $0x801120e0,(%esp)
80102cf6:	e8 65 2f 00 00       	call   80105c60 <acquire>
  ip->ref--;
80102cfb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80102cff:	83 c4 10             	add    $0x10,%esp
80102d02:	c7 45 08 e0 20 11 80 	movl   $0x801120e0,0x8(%ebp)
}
80102d09:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d0c:	5b                   	pop    %ebx
80102d0d:	5e                   	pop    %esi
80102d0e:	5f                   	pop    %edi
80102d0f:	5d                   	pop    %ebp
  release(&icache.lock);
80102d10:	e9 eb 2e 00 00       	jmp    80105c00 <release>
80102d15:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80102d18:	83 ec 0c             	sub    $0xc,%esp
80102d1b:	68 e0 20 11 80       	push   $0x801120e0
80102d20:	e8 3b 2f 00 00       	call   80105c60 <acquire>
    int r = ip->ref;
80102d25:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80102d28:	c7 04 24 e0 20 11 80 	movl   $0x801120e0,(%esp)
80102d2f:	e8 cc 2e 00 00       	call   80105c00 <release>
    if(r == 1){
80102d34:	83 c4 10             	add    $0x10,%esp
80102d37:	83 fe 01             	cmp    $0x1,%esi
80102d3a:	75 aa                	jne    80102ce6 <iput+0x26>
80102d3c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80102d42:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80102d45:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102d48:	89 cf                	mov    %ecx,%edi
80102d4a:	eb 0b                	jmp    80102d57 <iput+0x97>
80102d4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80102d50:	83 c6 04             	add    $0x4,%esi
80102d53:	39 fe                	cmp    %edi,%esi
80102d55:	74 19                	je     80102d70 <iput+0xb0>
    if(ip->addrs[i]){
80102d57:	8b 16                	mov    (%esi),%edx
80102d59:	85 d2                	test   %edx,%edx
80102d5b:	74 f3                	je     80102d50 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80102d5d:	8b 03                	mov    (%ebx),%eax
80102d5f:	e8 6c f8 ff ff       	call   801025d0 <bfree>
      ip->addrs[i] = 0;
80102d64:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80102d6a:	eb e4                	jmp    80102d50 <iput+0x90>
80102d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80102d70:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80102d76:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80102d79:	85 c0                	test   %eax,%eax
80102d7b:	75 2d                	jne    80102daa <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80102d7d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80102d80:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80102d87:	53                   	push   %ebx
80102d88:	e8 53 fd ff ff       	call   80102ae0 <iupdate>
      ip->type = 0;
80102d8d:	31 c0                	xor    %eax,%eax
80102d8f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80102d93:	89 1c 24             	mov    %ebx,(%esp)
80102d96:	e8 45 fd ff ff       	call   80102ae0 <iupdate>
      ip->valid = 0;
80102d9b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80102da2:	83 c4 10             	add    $0x10,%esp
80102da5:	e9 3c ff ff ff       	jmp    80102ce6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80102daa:	83 ec 08             	sub    $0x8,%esp
80102dad:	50                   	push   %eax
80102dae:	ff 33                	push   (%ebx)
80102db0:	e8 1b d3 ff ff       	call   801000d0 <bread>
80102db5:	89 7d e0             	mov    %edi,-0x20(%ebp)
80102db8:	83 c4 10             	add    $0x10,%esp
80102dbb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80102dc1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80102dc4:	8d 70 5c             	lea    0x5c(%eax),%esi
80102dc7:	89 cf                	mov    %ecx,%edi
80102dc9:	eb 0c                	jmp    80102dd7 <iput+0x117>
80102dcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102dcf:	90                   	nop
80102dd0:	83 c6 04             	add    $0x4,%esi
80102dd3:	39 f7                	cmp    %esi,%edi
80102dd5:	74 0f                	je     80102de6 <iput+0x126>
      if(a[j])
80102dd7:	8b 16                	mov    (%esi),%edx
80102dd9:	85 d2                	test   %edx,%edx
80102ddb:	74 f3                	je     80102dd0 <iput+0x110>
        bfree(ip->dev, a[j]);
80102ddd:	8b 03                	mov    (%ebx),%eax
80102ddf:	e8 ec f7 ff ff       	call   801025d0 <bfree>
80102de4:	eb ea                	jmp    80102dd0 <iput+0x110>
    brelse(bp);
80102de6:	83 ec 0c             	sub    $0xc,%esp
80102de9:	ff 75 e4             	push   -0x1c(%ebp)
80102dec:	8b 7d e0             	mov    -0x20(%ebp),%edi
80102def:	e8 fc d3 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80102df4:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80102dfa:	8b 03                	mov    (%ebx),%eax
80102dfc:	e8 cf f7 ff ff       	call   801025d0 <bfree>
    ip->addrs[NDIRECT] = 0;
80102e01:	83 c4 10             	add    $0x10,%esp
80102e04:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80102e0b:	00 00 00 
80102e0e:	e9 6a ff ff ff       	jmp    80102d7d <iput+0xbd>
80102e13:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102e20 <iunlockput>:
{
80102e20:	55                   	push   %ebp
80102e21:	89 e5                	mov    %esp,%ebp
80102e23:	56                   	push   %esi
80102e24:	53                   	push   %ebx
80102e25:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102e28:	85 db                	test   %ebx,%ebx
80102e2a:	74 34                	je     80102e60 <iunlockput+0x40>
80102e2c:	83 ec 0c             	sub    $0xc,%esp
80102e2f:	8d 73 0c             	lea    0xc(%ebx),%esi
80102e32:	56                   	push   %esi
80102e33:	e8 08 2c 00 00       	call   80105a40 <holdingsleep>
80102e38:	83 c4 10             	add    $0x10,%esp
80102e3b:	85 c0                	test   %eax,%eax
80102e3d:	74 21                	je     80102e60 <iunlockput+0x40>
80102e3f:	8b 43 08             	mov    0x8(%ebx),%eax
80102e42:	85 c0                	test   %eax,%eax
80102e44:	7e 1a                	jle    80102e60 <iunlockput+0x40>
  releasesleep(&ip->lock);
80102e46:	83 ec 0c             	sub    $0xc,%esp
80102e49:	56                   	push   %esi
80102e4a:	e8 b1 2b 00 00       	call   80105a00 <releasesleep>
  iput(ip);
80102e4f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80102e52:	83 c4 10             	add    $0x10,%esp
}
80102e55:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102e58:	5b                   	pop    %ebx
80102e59:	5e                   	pop    %esi
80102e5a:	5d                   	pop    %ebp
  iput(ip);
80102e5b:	e9 60 fe ff ff       	jmp    80102cc0 <iput>
    panic("iunlock");
80102e60:	83 ec 0c             	sub    $0xc,%esp
80102e63:	68 92 8d 10 80       	push   $0x80108d92
80102e68:	e8 13 d5 ff ff       	call   80100380 <panic>
80102e6d:	8d 76 00             	lea    0x0(%esi),%esi

80102e70 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80102e70:	55                   	push   %ebp
80102e71:	89 e5                	mov    %esp,%ebp
80102e73:	8b 55 08             	mov    0x8(%ebp),%edx
80102e76:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80102e79:	8b 0a                	mov    (%edx),%ecx
80102e7b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80102e7e:	8b 4a 04             	mov    0x4(%edx),%ecx
80102e81:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80102e84:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80102e88:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80102e8b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80102e8f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80102e93:	8b 52 58             	mov    0x58(%edx),%edx
80102e96:	89 50 10             	mov    %edx,0x10(%eax)
}
80102e99:	5d                   	pop    %ebp
80102e9a:	c3                   	ret    
80102e9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e9f:	90                   	nop

80102ea0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80102ea0:	55                   	push   %ebp
80102ea1:	89 e5                	mov    %esp,%ebp
80102ea3:	57                   	push   %edi
80102ea4:	56                   	push   %esi
80102ea5:	53                   	push   %ebx
80102ea6:	83 ec 1c             	sub    $0x1c,%esp
80102ea9:	8b 7d 0c             	mov    0xc(%ebp),%edi
80102eac:	8b 45 08             	mov    0x8(%ebp),%eax
80102eaf:	8b 75 10             	mov    0x10(%ebp),%esi
80102eb2:	89 7d e0             	mov    %edi,-0x20(%ebp)
80102eb5:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80102eb8:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80102ebd:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102ec0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80102ec3:	0f 84 a7 00 00 00    	je     80102f70 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80102ec9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102ecc:	8b 40 58             	mov    0x58(%eax),%eax
80102ecf:	39 c6                	cmp    %eax,%esi
80102ed1:	0f 87 ba 00 00 00    	ja     80102f91 <readi+0xf1>
80102ed7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80102eda:	31 c9                	xor    %ecx,%ecx
80102edc:	89 da                	mov    %ebx,%edx
80102ede:	01 f2                	add    %esi,%edx
80102ee0:	0f 92 c1             	setb   %cl
80102ee3:	89 cf                	mov    %ecx,%edi
80102ee5:	0f 82 a6 00 00 00    	jb     80102f91 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80102eeb:	89 c1                	mov    %eax,%ecx
80102eed:	29 f1                	sub    %esi,%ecx
80102eef:	39 d0                	cmp    %edx,%eax
80102ef1:	0f 43 cb             	cmovae %ebx,%ecx
80102ef4:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102ef7:	85 c9                	test   %ecx,%ecx
80102ef9:	74 67                	je     80102f62 <readi+0xc2>
80102efb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102eff:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102f00:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80102f03:	89 f2                	mov    %esi,%edx
80102f05:	c1 ea 09             	shr    $0x9,%edx
80102f08:	89 d8                	mov    %ebx,%eax
80102f0a:	e8 51 f9 ff ff       	call   80102860 <bmap>
80102f0f:	83 ec 08             	sub    $0x8,%esp
80102f12:	50                   	push   %eax
80102f13:	ff 33                	push   (%ebx)
80102f15:	e8 b6 d1 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80102f1a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80102f1d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102f22:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80102f24:	89 f0                	mov    %esi,%eax
80102f26:	25 ff 01 00 00       	and    $0x1ff,%eax
80102f2b:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80102f2d:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80102f30:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80102f32:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80102f36:	39 d9                	cmp    %ebx,%ecx
80102f38:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80102f3b:	83 c4 0c             	add    $0xc,%esp
80102f3e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102f3f:	01 df                	add    %ebx,%edi
80102f41:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80102f43:	50                   	push   %eax
80102f44:	ff 75 e0             	push   -0x20(%ebp)
80102f47:	e8 74 2e 00 00       	call   80105dc0 <memmove>
    brelse(bp);
80102f4c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80102f4f:	89 14 24             	mov    %edx,(%esp)
80102f52:	e8 99 d2 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102f57:	01 5d e0             	add    %ebx,-0x20(%ebp)
80102f5a:	83 c4 10             	add    $0x10,%esp
80102f5d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80102f60:	77 9e                	ja     80102f00 <readi+0x60>
  }
  return n;
80102f62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80102f65:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f68:	5b                   	pop    %ebx
80102f69:	5e                   	pop    %esi
80102f6a:	5f                   	pop    %edi
80102f6b:	5d                   	pop    %ebp
80102f6c:	c3                   	ret    
80102f6d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80102f70:	0f bf 40 52          	movswl 0x52(%eax),%eax
80102f74:	66 83 f8 09          	cmp    $0x9,%ax
80102f78:	77 17                	ja     80102f91 <readi+0xf1>
80102f7a:	8b 04 c5 80 20 11 80 	mov    -0x7feedf80(,%eax,8),%eax
80102f81:	85 c0                	test   %eax,%eax
80102f83:	74 0c                	je     80102f91 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80102f85:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80102f88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f8b:	5b                   	pop    %ebx
80102f8c:	5e                   	pop    %esi
80102f8d:	5f                   	pop    %edi
80102f8e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80102f8f:	ff e0                	jmp    *%eax
      return -1;
80102f91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102f96:	eb cd                	jmp    80102f65 <readi+0xc5>
80102f98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f9f:	90                   	nop

80102fa0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80102fa0:	55                   	push   %ebp
80102fa1:	89 e5                	mov    %esp,%ebp
80102fa3:	57                   	push   %edi
80102fa4:	56                   	push   %esi
80102fa5:	53                   	push   %ebx
80102fa6:	83 ec 1c             	sub    $0x1c,%esp
80102fa9:	8b 45 08             	mov    0x8(%ebp),%eax
80102fac:	8b 75 0c             	mov    0xc(%ebp),%esi
80102faf:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80102fb2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80102fb7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80102fba:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102fbd:	8b 75 10             	mov    0x10(%ebp),%esi
80102fc0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80102fc3:	0f 84 b7 00 00 00    	je     80103080 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80102fc9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102fcc:	3b 70 58             	cmp    0x58(%eax),%esi
80102fcf:	0f 87 e7 00 00 00    	ja     801030bc <writei+0x11c>
80102fd5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80102fd8:	31 d2                	xor    %edx,%edx
80102fda:	89 f8                	mov    %edi,%eax
80102fdc:	01 f0                	add    %esi,%eax
80102fde:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80102fe1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80102fe6:	0f 87 d0 00 00 00    	ja     801030bc <writei+0x11c>
80102fec:	85 d2                	test   %edx,%edx
80102fee:	0f 85 c8 00 00 00    	jne    801030bc <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102ff4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80102ffb:	85 ff                	test   %edi,%edi
80102ffd:	74 72                	je     80103071 <writei+0xd1>
80102fff:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80103000:	8b 7d d8             	mov    -0x28(%ebp),%edi
80103003:	89 f2                	mov    %esi,%edx
80103005:	c1 ea 09             	shr    $0x9,%edx
80103008:	89 f8                	mov    %edi,%eax
8010300a:	e8 51 f8 ff ff       	call   80102860 <bmap>
8010300f:	83 ec 08             	sub    $0x8,%esp
80103012:	50                   	push   %eax
80103013:	ff 37                	push   (%edi)
80103015:	e8 b6 d0 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
8010301a:	b9 00 02 00 00       	mov    $0x200,%ecx
8010301f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80103022:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80103025:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80103027:	89 f0                	mov    %esi,%eax
80103029:	25 ff 01 00 00       	and    $0x1ff,%eax
8010302e:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80103030:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80103034:	39 d9                	cmp    %ebx,%ecx
80103036:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80103039:	83 c4 0c             	add    $0xc,%esp
8010303c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010303d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
8010303f:	ff 75 dc             	push   -0x24(%ebp)
80103042:	50                   	push   %eax
80103043:	e8 78 2d 00 00       	call   80105dc0 <memmove>
    log_write(bp);
80103048:	89 3c 24             	mov    %edi,(%esp)
8010304b:	e8 00 13 00 00       	call   80104350 <log_write>
    brelse(bp);
80103050:	89 3c 24             	mov    %edi,(%esp)
80103053:	e8 98 d1 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80103058:	01 5d e4             	add    %ebx,-0x1c(%ebp)
8010305b:	83 c4 10             	add    $0x10,%esp
8010305e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103061:	01 5d dc             	add    %ebx,-0x24(%ebp)
80103064:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80103067:	77 97                	ja     80103000 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80103069:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010306c:	3b 70 58             	cmp    0x58(%eax),%esi
8010306f:	77 37                	ja     801030a8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80103071:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80103074:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103077:	5b                   	pop    %ebx
80103078:	5e                   	pop    %esi
80103079:	5f                   	pop    %edi
8010307a:	5d                   	pop    %ebp
8010307b:	c3                   	ret    
8010307c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80103080:	0f bf 40 52          	movswl 0x52(%eax),%eax
80103084:	66 83 f8 09          	cmp    $0x9,%ax
80103088:	77 32                	ja     801030bc <writei+0x11c>
8010308a:	8b 04 c5 84 20 11 80 	mov    -0x7feedf7c(,%eax,8),%eax
80103091:	85 c0                	test   %eax,%eax
80103093:	74 27                	je     801030bc <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80103095:	89 55 10             	mov    %edx,0x10(%ebp)
}
80103098:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010309b:	5b                   	pop    %ebx
8010309c:	5e                   	pop    %esi
8010309d:	5f                   	pop    %edi
8010309e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
8010309f:	ff e0                	jmp    *%eax
801030a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
801030a8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
801030ab:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
801030ae:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
801030b1:	50                   	push   %eax
801030b2:	e8 29 fa ff ff       	call   80102ae0 <iupdate>
801030b7:	83 c4 10             	add    $0x10,%esp
801030ba:	eb b5                	jmp    80103071 <writei+0xd1>
      return -1;
801030bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801030c1:	eb b1                	jmp    80103074 <writei+0xd4>
801030c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801030d0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
801030d0:	55                   	push   %ebp
801030d1:	89 e5                	mov    %esp,%ebp
801030d3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
801030d6:	6a 0e                	push   $0xe
801030d8:	ff 75 0c             	push   0xc(%ebp)
801030db:	ff 75 08             	push   0x8(%ebp)
801030de:	e8 4d 2d 00 00       	call   80105e30 <strncmp>
}
801030e3:	c9                   	leave  
801030e4:	c3                   	ret    
801030e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801030f0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
801030f0:	55                   	push   %ebp
801030f1:	89 e5                	mov    %esp,%ebp
801030f3:	57                   	push   %edi
801030f4:	56                   	push   %esi
801030f5:	53                   	push   %ebx
801030f6:	83 ec 1c             	sub    $0x1c,%esp
801030f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
801030fc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80103101:	0f 85 85 00 00 00    	jne    8010318c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80103107:	8b 53 58             	mov    0x58(%ebx),%edx
8010310a:	31 ff                	xor    %edi,%edi
8010310c:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010310f:	85 d2                	test   %edx,%edx
80103111:	74 3e                	je     80103151 <dirlookup+0x61>
80103113:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103117:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80103118:	6a 10                	push   $0x10
8010311a:	57                   	push   %edi
8010311b:	56                   	push   %esi
8010311c:	53                   	push   %ebx
8010311d:	e8 7e fd ff ff       	call   80102ea0 <readi>
80103122:	83 c4 10             	add    $0x10,%esp
80103125:	83 f8 10             	cmp    $0x10,%eax
80103128:	75 55                	jne    8010317f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
8010312a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010312f:	74 18                	je     80103149 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80103131:	83 ec 04             	sub    $0x4,%esp
80103134:	8d 45 da             	lea    -0x26(%ebp),%eax
80103137:	6a 0e                	push   $0xe
80103139:	50                   	push   %eax
8010313a:	ff 75 0c             	push   0xc(%ebp)
8010313d:	e8 ee 2c 00 00       	call   80105e30 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80103142:	83 c4 10             	add    $0x10,%esp
80103145:	85 c0                	test   %eax,%eax
80103147:	74 17                	je     80103160 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80103149:	83 c7 10             	add    $0x10,%edi
8010314c:	3b 7b 58             	cmp    0x58(%ebx),%edi
8010314f:	72 c7                	jb     80103118 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80103151:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103154:	31 c0                	xor    %eax,%eax
}
80103156:	5b                   	pop    %ebx
80103157:	5e                   	pop    %esi
80103158:	5f                   	pop    %edi
80103159:	5d                   	pop    %ebp
8010315a:	c3                   	ret    
8010315b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010315f:	90                   	nop
      if(poff)
80103160:	8b 45 10             	mov    0x10(%ebp),%eax
80103163:	85 c0                	test   %eax,%eax
80103165:	74 05                	je     8010316c <dirlookup+0x7c>
        *poff = off;
80103167:	8b 45 10             	mov    0x10(%ebp),%eax
8010316a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
8010316c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80103170:	8b 03                	mov    (%ebx),%eax
80103172:	e8 e9 f5 ff ff       	call   80102760 <iget>
}
80103177:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010317a:	5b                   	pop    %ebx
8010317b:	5e                   	pop    %esi
8010317c:	5f                   	pop    %edi
8010317d:	5d                   	pop    %ebp
8010317e:	c3                   	ret    
      panic("dirlookup read");
8010317f:	83 ec 0c             	sub    $0xc,%esp
80103182:	68 ac 8d 10 80       	push   $0x80108dac
80103187:	e8 f4 d1 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
8010318c:	83 ec 0c             	sub    $0xc,%esp
8010318f:	68 9a 8d 10 80       	push   $0x80108d9a
80103194:	e8 e7 d1 ff ff       	call   80100380 <panic>
80103199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801031a0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
801031a0:	55                   	push   %ebp
801031a1:	89 e5                	mov    %esp,%ebp
801031a3:	57                   	push   %edi
801031a4:	56                   	push   %esi
801031a5:	53                   	push   %ebx
801031a6:	89 c3                	mov    %eax,%ebx
801031a8:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
801031ab:	80 38 2f             	cmpb   $0x2f,(%eax)
{
801031ae:	89 55 dc             	mov    %edx,-0x24(%ebp)
801031b1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
801031b4:	0f 84 64 01 00 00    	je     8010331e <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
801031ba:	e8 e1 1b 00 00       	call   80104da0 <myproc>
  acquire(&icache.lock);
801031bf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
801031c2:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
801031c5:	68 e0 20 11 80       	push   $0x801120e0
801031ca:	e8 91 2a 00 00       	call   80105c60 <acquire>
  ip->ref++;
801031cf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
801031d3:	c7 04 24 e0 20 11 80 	movl   $0x801120e0,(%esp)
801031da:	e8 21 2a 00 00       	call   80105c00 <release>
801031df:	83 c4 10             	add    $0x10,%esp
801031e2:	eb 07                	jmp    801031eb <namex+0x4b>
801031e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
801031e8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
801031eb:	0f b6 03             	movzbl (%ebx),%eax
801031ee:	3c 2f                	cmp    $0x2f,%al
801031f0:	74 f6                	je     801031e8 <namex+0x48>
  if(*path == 0)
801031f2:	84 c0                	test   %al,%al
801031f4:	0f 84 06 01 00 00    	je     80103300 <namex+0x160>
  while(*path != '/' && *path != 0)
801031fa:	0f b6 03             	movzbl (%ebx),%eax
801031fd:	84 c0                	test   %al,%al
801031ff:	0f 84 10 01 00 00    	je     80103315 <namex+0x175>
80103205:	89 df                	mov    %ebx,%edi
80103207:	3c 2f                	cmp    $0x2f,%al
80103209:	0f 84 06 01 00 00    	je     80103315 <namex+0x175>
8010320f:	90                   	nop
80103210:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80103214:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80103217:	3c 2f                	cmp    $0x2f,%al
80103219:	74 04                	je     8010321f <namex+0x7f>
8010321b:	84 c0                	test   %al,%al
8010321d:	75 f1                	jne    80103210 <namex+0x70>
  len = path - s;
8010321f:	89 f8                	mov    %edi,%eax
80103221:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80103223:	83 f8 0d             	cmp    $0xd,%eax
80103226:	0f 8e ac 00 00 00    	jle    801032d8 <namex+0x138>
    memmove(name, s, DIRSIZ);
8010322c:	83 ec 04             	sub    $0x4,%esp
8010322f:	6a 0e                	push   $0xe
80103231:	53                   	push   %ebx
    path++;
80103232:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80103234:	ff 75 e4             	push   -0x1c(%ebp)
80103237:	e8 84 2b 00 00       	call   80105dc0 <memmove>
8010323c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
8010323f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80103242:	75 0c                	jne    80103250 <namex+0xb0>
80103244:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80103248:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
8010324b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
8010324e:	74 f8                	je     80103248 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80103250:	83 ec 0c             	sub    $0xc,%esp
80103253:	56                   	push   %esi
80103254:	e8 37 f9 ff ff       	call   80102b90 <ilock>
    if(ip->type != T_DIR){
80103259:	83 c4 10             	add    $0x10,%esp
8010325c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80103261:	0f 85 cd 00 00 00    	jne    80103334 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80103267:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010326a:	85 c0                	test   %eax,%eax
8010326c:	74 09                	je     80103277 <namex+0xd7>
8010326e:	80 3b 00             	cmpb   $0x0,(%ebx)
80103271:	0f 84 22 01 00 00    	je     80103399 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80103277:	83 ec 04             	sub    $0x4,%esp
8010327a:	6a 00                	push   $0x0
8010327c:	ff 75 e4             	push   -0x1c(%ebp)
8010327f:	56                   	push   %esi
80103280:	e8 6b fe ff ff       	call   801030f0 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80103285:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80103288:	83 c4 10             	add    $0x10,%esp
8010328b:	89 c7                	mov    %eax,%edi
8010328d:	85 c0                	test   %eax,%eax
8010328f:	0f 84 e1 00 00 00    	je     80103376 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80103295:	83 ec 0c             	sub    $0xc,%esp
80103298:	89 55 e0             	mov    %edx,-0x20(%ebp)
8010329b:	52                   	push   %edx
8010329c:	e8 9f 27 00 00       	call   80105a40 <holdingsleep>
801032a1:	83 c4 10             	add    $0x10,%esp
801032a4:	85 c0                	test   %eax,%eax
801032a6:	0f 84 30 01 00 00    	je     801033dc <namex+0x23c>
801032ac:	8b 56 08             	mov    0x8(%esi),%edx
801032af:	85 d2                	test   %edx,%edx
801032b1:	0f 8e 25 01 00 00    	jle    801033dc <namex+0x23c>
  releasesleep(&ip->lock);
801032b7:	8b 55 e0             	mov    -0x20(%ebp),%edx
801032ba:	83 ec 0c             	sub    $0xc,%esp
801032bd:	52                   	push   %edx
801032be:	e8 3d 27 00 00       	call   80105a00 <releasesleep>
  iput(ip);
801032c3:	89 34 24             	mov    %esi,(%esp)
801032c6:	89 fe                	mov    %edi,%esi
801032c8:	e8 f3 f9 ff ff       	call   80102cc0 <iput>
801032cd:	83 c4 10             	add    $0x10,%esp
801032d0:	e9 16 ff ff ff       	jmp    801031eb <namex+0x4b>
801032d5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
801032d8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801032db:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
801032de:	83 ec 04             	sub    $0x4,%esp
801032e1:	89 55 e0             	mov    %edx,-0x20(%ebp)
801032e4:	50                   	push   %eax
801032e5:	53                   	push   %ebx
    name[len] = 0;
801032e6:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
801032e8:	ff 75 e4             	push   -0x1c(%ebp)
801032eb:	e8 d0 2a 00 00       	call   80105dc0 <memmove>
    name[len] = 0;
801032f0:	8b 55 e0             	mov    -0x20(%ebp),%edx
801032f3:	83 c4 10             	add    $0x10,%esp
801032f6:	c6 02 00             	movb   $0x0,(%edx)
801032f9:	e9 41 ff ff ff       	jmp    8010323f <namex+0x9f>
801032fe:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80103300:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103303:	85 c0                	test   %eax,%eax
80103305:	0f 85 be 00 00 00    	jne    801033c9 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
8010330b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010330e:	89 f0                	mov    %esi,%eax
80103310:	5b                   	pop    %ebx
80103311:	5e                   	pop    %esi
80103312:	5f                   	pop    %edi
80103313:	5d                   	pop    %ebp
80103314:	c3                   	ret    
  while(*path != '/' && *path != 0)
80103315:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103318:	89 df                	mov    %ebx,%edi
8010331a:	31 c0                	xor    %eax,%eax
8010331c:	eb c0                	jmp    801032de <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
8010331e:	ba 01 00 00 00       	mov    $0x1,%edx
80103323:	b8 01 00 00 00       	mov    $0x1,%eax
80103328:	e8 33 f4 ff ff       	call   80102760 <iget>
8010332d:	89 c6                	mov    %eax,%esi
8010332f:	e9 b7 fe ff ff       	jmp    801031eb <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80103334:	83 ec 0c             	sub    $0xc,%esp
80103337:	8d 5e 0c             	lea    0xc(%esi),%ebx
8010333a:	53                   	push   %ebx
8010333b:	e8 00 27 00 00       	call   80105a40 <holdingsleep>
80103340:	83 c4 10             	add    $0x10,%esp
80103343:	85 c0                	test   %eax,%eax
80103345:	0f 84 91 00 00 00    	je     801033dc <namex+0x23c>
8010334b:	8b 46 08             	mov    0x8(%esi),%eax
8010334e:	85 c0                	test   %eax,%eax
80103350:	0f 8e 86 00 00 00    	jle    801033dc <namex+0x23c>
  releasesleep(&ip->lock);
80103356:	83 ec 0c             	sub    $0xc,%esp
80103359:	53                   	push   %ebx
8010335a:	e8 a1 26 00 00       	call   80105a00 <releasesleep>
  iput(ip);
8010335f:	89 34 24             	mov    %esi,(%esp)
      return 0;
80103362:	31 f6                	xor    %esi,%esi
  iput(ip);
80103364:	e8 57 f9 ff ff       	call   80102cc0 <iput>
      return 0;
80103369:	83 c4 10             	add    $0x10,%esp
}
8010336c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010336f:	89 f0                	mov    %esi,%eax
80103371:	5b                   	pop    %ebx
80103372:	5e                   	pop    %esi
80103373:	5f                   	pop    %edi
80103374:	5d                   	pop    %ebp
80103375:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80103376:	83 ec 0c             	sub    $0xc,%esp
80103379:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010337c:	52                   	push   %edx
8010337d:	e8 be 26 00 00       	call   80105a40 <holdingsleep>
80103382:	83 c4 10             	add    $0x10,%esp
80103385:	85 c0                	test   %eax,%eax
80103387:	74 53                	je     801033dc <namex+0x23c>
80103389:	8b 4e 08             	mov    0x8(%esi),%ecx
8010338c:	85 c9                	test   %ecx,%ecx
8010338e:	7e 4c                	jle    801033dc <namex+0x23c>
  releasesleep(&ip->lock);
80103390:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103393:	83 ec 0c             	sub    $0xc,%esp
80103396:	52                   	push   %edx
80103397:	eb c1                	jmp    8010335a <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80103399:	83 ec 0c             	sub    $0xc,%esp
8010339c:	8d 5e 0c             	lea    0xc(%esi),%ebx
8010339f:	53                   	push   %ebx
801033a0:	e8 9b 26 00 00       	call   80105a40 <holdingsleep>
801033a5:	83 c4 10             	add    $0x10,%esp
801033a8:	85 c0                	test   %eax,%eax
801033aa:	74 30                	je     801033dc <namex+0x23c>
801033ac:	8b 7e 08             	mov    0x8(%esi),%edi
801033af:	85 ff                	test   %edi,%edi
801033b1:	7e 29                	jle    801033dc <namex+0x23c>
  releasesleep(&ip->lock);
801033b3:	83 ec 0c             	sub    $0xc,%esp
801033b6:	53                   	push   %ebx
801033b7:	e8 44 26 00 00       	call   80105a00 <releasesleep>
}
801033bc:	83 c4 10             	add    $0x10,%esp
}
801033bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033c2:	89 f0                	mov    %esi,%eax
801033c4:	5b                   	pop    %ebx
801033c5:	5e                   	pop    %esi
801033c6:	5f                   	pop    %edi
801033c7:	5d                   	pop    %ebp
801033c8:	c3                   	ret    
    iput(ip);
801033c9:	83 ec 0c             	sub    $0xc,%esp
801033cc:	56                   	push   %esi
    return 0;
801033cd:	31 f6                	xor    %esi,%esi
    iput(ip);
801033cf:	e8 ec f8 ff ff       	call   80102cc0 <iput>
    return 0;
801033d4:	83 c4 10             	add    $0x10,%esp
801033d7:	e9 2f ff ff ff       	jmp    8010330b <namex+0x16b>
    panic("iunlock");
801033dc:	83 ec 0c             	sub    $0xc,%esp
801033df:	68 92 8d 10 80       	push   $0x80108d92
801033e4:	e8 97 cf ff ff       	call   80100380 <panic>
801033e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801033f0 <dirlink>:
{
801033f0:	55                   	push   %ebp
801033f1:	89 e5                	mov    %esp,%ebp
801033f3:	57                   	push   %edi
801033f4:	56                   	push   %esi
801033f5:	53                   	push   %ebx
801033f6:	83 ec 20             	sub    $0x20,%esp
801033f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
801033fc:	6a 00                	push   $0x0
801033fe:	ff 75 0c             	push   0xc(%ebp)
80103401:	53                   	push   %ebx
80103402:	e8 e9 fc ff ff       	call   801030f0 <dirlookup>
80103407:	83 c4 10             	add    $0x10,%esp
8010340a:	85 c0                	test   %eax,%eax
8010340c:	75 67                	jne    80103475 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010340e:	8b 7b 58             	mov    0x58(%ebx),%edi
80103411:	8d 75 d8             	lea    -0x28(%ebp),%esi
80103414:	85 ff                	test   %edi,%edi
80103416:	74 29                	je     80103441 <dirlink+0x51>
80103418:	31 ff                	xor    %edi,%edi
8010341a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010341d:	eb 09                	jmp    80103428 <dirlink+0x38>
8010341f:	90                   	nop
80103420:	83 c7 10             	add    $0x10,%edi
80103423:	3b 7b 58             	cmp    0x58(%ebx),%edi
80103426:	73 19                	jae    80103441 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80103428:	6a 10                	push   $0x10
8010342a:	57                   	push   %edi
8010342b:	56                   	push   %esi
8010342c:	53                   	push   %ebx
8010342d:	e8 6e fa ff ff       	call   80102ea0 <readi>
80103432:	83 c4 10             	add    $0x10,%esp
80103435:	83 f8 10             	cmp    $0x10,%eax
80103438:	75 4e                	jne    80103488 <dirlink+0x98>
    if(de.inum == 0)
8010343a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010343f:	75 df                	jne    80103420 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80103441:	83 ec 04             	sub    $0x4,%esp
80103444:	8d 45 da             	lea    -0x26(%ebp),%eax
80103447:	6a 0e                	push   $0xe
80103449:	ff 75 0c             	push   0xc(%ebp)
8010344c:	50                   	push   %eax
8010344d:	e8 2e 2a 00 00       	call   80105e80 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80103452:	6a 10                	push   $0x10
  de.inum = inum;
80103454:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80103457:	57                   	push   %edi
80103458:	56                   	push   %esi
80103459:	53                   	push   %ebx
  de.inum = inum;
8010345a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010345e:	e8 3d fb ff ff       	call   80102fa0 <writei>
80103463:	83 c4 20             	add    $0x20,%esp
80103466:	83 f8 10             	cmp    $0x10,%eax
80103469:	75 2a                	jne    80103495 <dirlink+0xa5>
  return 0;
8010346b:	31 c0                	xor    %eax,%eax
}
8010346d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103470:	5b                   	pop    %ebx
80103471:	5e                   	pop    %esi
80103472:	5f                   	pop    %edi
80103473:	5d                   	pop    %ebp
80103474:	c3                   	ret    
    iput(ip);
80103475:	83 ec 0c             	sub    $0xc,%esp
80103478:	50                   	push   %eax
80103479:	e8 42 f8 ff ff       	call   80102cc0 <iput>
    return -1;
8010347e:	83 c4 10             	add    $0x10,%esp
80103481:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103486:	eb e5                	jmp    8010346d <dirlink+0x7d>
      panic("dirlink read");
80103488:	83 ec 0c             	sub    $0xc,%esp
8010348b:	68 bb 8d 10 80       	push   $0x80108dbb
80103490:	e8 eb ce ff ff       	call   80100380 <panic>
    panic("dirlink");
80103495:	83 ec 0c             	sub    $0xc,%esp
80103498:	68 32 94 10 80       	push   $0x80109432
8010349d:	e8 de ce ff ff       	call   80100380 <panic>
801034a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801034a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801034b0 <namei>:

struct inode*
namei(char *path)
{
801034b0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801034b1:	31 d2                	xor    %edx,%edx
{
801034b3:	89 e5                	mov    %esp,%ebp
801034b5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801034b8:	8b 45 08             	mov    0x8(%ebp),%eax
801034bb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801034be:	e8 dd fc ff ff       	call   801031a0 <namex>
}
801034c3:	c9                   	leave  
801034c4:	c3                   	ret    
801034c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801034cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801034d0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801034d0:	55                   	push   %ebp
  return namex(path, 1, name);
801034d1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801034d6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801034d8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801034db:	8b 45 08             	mov    0x8(%ebp),%eax
}
801034de:	5d                   	pop    %ebp
  return namex(path, 1, name);
801034df:	e9 bc fc ff ff       	jmp    801031a0 <namex>
801034e4:	66 90                	xchg   %ax,%ax
801034e6:	66 90                	xchg   %ax,%ax
801034e8:	66 90                	xchg   %ax,%ax
801034ea:	66 90                	xchg   %ax,%ax
801034ec:	66 90                	xchg   %ax,%ax
801034ee:	66 90                	xchg   %ax,%ax

801034f0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801034f0:	55                   	push   %ebp
801034f1:	89 e5                	mov    %esp,%ebp
801034f3:	57                   	push   %edi
801034f4:	56                   	push   %esi
801034f5:	53                   	push   %ebx
801034f6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801034f9:	85 c0                	test   %eax,%eax
801034fb:	0f 84 b4 00 00 00    	je     801035b5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80103501:	8b 70 08             	mov    0x8(%eax),%esi
80103504:	89 c3                	mov    %eax,%ebx
80103506:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010350c:	0f 87 96 00 00 00    	ja     801035a8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103512:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80103517:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010351e:	66 90                	xchg   %ax,%ax
80103520:	89 ca                	mov    %ecx,%edx
80103522:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80103523:	83 e0 c0             	and    $0xffffffc0,%eax
80103526:	3c 40                	cmp    $0x40,%al
80103528:	75 f6                	jne    80103520 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010352a:	31 ff                	xor    %edi,%edi
8010352c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80103531:	89 f8                	mov    %edi,%eax
80103533:	ee                   	out    %al,(%dx)
80103534:	b8 01 00 00 00       	mov    $0x1,%eax
80103539:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010353e:	ee                   	out    %al,(%dx)
8010353f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80103544:	89 f0                	mov    %esi,%eax
80103546:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80103547:	89 f0                	mov    %esi,%eax
80103549:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010354e:	c1 f8 08             	sar    $0x8,%eax
80103551:	ee                   	out    %al,(%dx)
80103552:	ba f5 01 00 00       	mov    $0x1f5,%edx
80103557:	89 f8                	mov    %edi,%eax
80103559:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010355a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010355e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80103563:	c1 e0 04             	shl    $0x4,%eax
80103566:	83 e0 10             	and    $0x10,%eax
80103569:	83 c8 e0             	or     $0xffffffe0,%eax
8010356c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010356d:	f6 03 04             	testb  $0x4,(%ebx)
80103570:	75 16                	jne    80103588 <idestart+0x98>
80103572:	b8 20 00 00 00       	mov    $0x20,%eax
80103577:	89 ca                	mov    %ecx,%edx
80103579:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010357a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010357d:	5b                   	pop    %ebx
8010357e:	5e                   	pop    %esi
8010357f:	5f                   	pop    %edi
80103580:	5d                   	pop    %ebp
80103581:	c3                   	ret    
80103582:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103588:	b8 30 00 00 00       	mov    $0x30,%eax
8010358d:	89 ca                	mov    %ecx,%edx
8010358f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80103590:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80103595:	8d 73 5c             	lea    0x5c(%ebx),%esi
80103598:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010359d:	fc                   	cld    
8010359e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801035a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035a3:	5b                   	pop    %ebx
801035a4:	5e                   	pop    %esi
801035a5:	5f                   	pop    %edi
801035a6:	5d                   	pop    %ebp
801035a7:	c3                   	ret    
    panic("incorrect blockno");
801035a8:	83 ec 0c             	sub    $0xc,%esp
801035ab:	68 24 8e 10 80       	push   $0x80108e24
801035b0:	e8 cb cd ff ff       	call   80100380 <panic>
    panic("idestart");
801035b5:	83 ec 0c             	sub    $0xc,%esp
801035b8:	68 1b 8e 10 80       	push   $0x80108e1b
801035bd:	e8 be cd ff ff       	call   80100380 <panic>
801035c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801035d0 <ideinit>:
{
801035d0:	55                   	push   %ebp
801035d1:	89 e5                	mov    %esp,%ebp
801035d3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801035d6:	68 36 8e 10 80       	push   $0x80108e36
801035db:	68 80 3d 11 80       	push   $0x80113d80
801035e0:	e8 ab 24 00 00       	call   80105a90 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801035e5:	58                   	pop    %eax
801035e6:	a1 04 3f 11 80       	mov    0x80113f04,%eax
801035eb:	5a                   	pop    %edx
801035ec:	83 e8 01             	sub    $0x1,%eax
801035ef:	50                   	push   %eax
801035f0:	6a 0e                	push   $0xe
801035f2:	e8 99 02 00 00       	call   80103890 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801035f7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801035fa:	ba f7 01 00 00       	mov    $0x1f7,%edx
801035ff:	90                   	nop
80103600:	ec                   	in     (%dx),%al
80103601:	83 e0 c0             	and    $0xffffffc0,%eax
80103604:	3c 40                	cmp    $0x40,%al
80103606:	75 f8                	jne    80103600 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103608:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010360d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80103612:	ee                   	out    %al,(%dx)
80103613:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103618:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010361d:	eb 06                	jmp    80103625 <ideinit+0x55>
8010361f:	90                   	nop
  for(i=0; i<1000; i++){
80103620:	83 e9 01             	sub    $0x1,%ecx
80103623:	74 0f                	je     80103634 <ideinit+0x64>
80103625:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80103626:	84 c0                	test   %al,%al
80103628:	74 f6                	je     80103620 <ideinit+0x50>
      havedisk1 = 1;
8010362a:	c7 05 60 3d 11 80 01 	movl   $0x1,0x80113d60
80103631:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103634:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80103639:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010363e:	ee                   	out    %al,(%dx)
}
8010363f:	c9                   	leave  
80103640:	c3                   	ret    
80103641:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103648:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010364f:	90                   	nop

80103650 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80103650:	55                   	push   %ebp
80103651:	89 e5                	mov    %esp,%ebp
80103653:	57                   	push   %edi
80103654:	56                   	push   %esi
80103655:	53                   	push   %ebx
80103656:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80103659:	68 80 3d 11 80       	push   $0x80113d80
8010365e:	e8 fd 25 00 00       	call   80105c60 <acquire>

  if((b = idequeue) == 0){
80103663:	8b 1d 64 3d 11 80    	mov    0x80113d64,%ebx
80103669:	83 c4 10             	add    $0x10,%esp
8010366c:	85 db                	test   %ebx,%ebx
8010366e:	74 63                	je     801036d3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80103670:	8b 43 58             	mov    0x58(%ebx),%eax
80103673:	a3 64 3d 11 80       	mov    %eax,0x80113d64

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80103678:	8b 33                	mov    (%ebx),%esi
8010367a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80103680:	75 2f                	jne    801036b1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103682:	ba f7 01 00 00       	mov    $0x1f7,%edx
80103687:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010368e:	66 90                	xchg   %ax,%ax
80103690:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80103691:	89 c1                	mov    %eax,%ecx
80103693:	83 e1 c0             	and    $0xffffffc0,%ecx
80103696:	80 f9 40             	cmp    $0x40,%cl
80103699:	75 f5                	jne    80103690 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010369b:	a8 21                	test   $0x21,%al
8010369d:	75 12                	jne    801036b1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010369f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801036a2:	b9 80 00 00 00       	mov    $0x80,%ecx
801036a7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801036ac:	fc                   	cld    
801036ad:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
801036af:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
801036b1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801036b4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801036b7:	83 ce 02             	or     $0x2,%esi
801036ba:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801036bc:	53                   	push   %ebx
801036bd:	e8 6e 1e 00 00       	call   80105530 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801036c2:	a1 64 3d 11 80       	mov    0x80113d64,%eax
801036c7:	83 c4 10             	add    $0x10,%esp
801036ca:	85 c0                	test   %eax,%eax
801036cc:	74 05                	je     801036d3 <ideintr+0x83>
    idestart(idequeue);
801036ce:	e8 1d fe ff ff       	call   801034f0 <idestart>
    release(&idelock);
801036d3:	83 ec 0c             	sub    $0xc,%esp
801036d6:	68 80 3d 11 80       	push   $0x80113d80
801036db:	e8 20 25 00 00       	call   80105c00 <release>

  release(&idelock);
}
801036e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036e3:	5b                   	pop    %ebx
801036e4:	5e                   	pop    %esi
801036e5:	5f                   	pop    %edi
801036e6:	5d                   	pop    %ebp
801036e7:	c3                   	ret    
801036e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036ef:	90                   	nop

801036f0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801036f0:	55                   	push   %ebp
801036f1:	89 e5                	mov    %esp,%ebp
801036f3:	53                   	push   %ebx
801036f4:	83 ec 10             	sub    $0x10,%esp
801036f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801036fa:	8d 43 0c             	lea    0xc(%ebx),%eax
801036fd:	50                   	push   %eax
801036fe:	e8 3d 23 00 00       	call   80105a40 <holdingsleep>
80103703:	83 c4 10             	add    $0x10,%esp
80103706:	85 c0                	test   %eax,%eax
80103708:	0f 84 c3 00 00 00    	je     801037d1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010370e:	8b 03                	mov    (%ebx),%eax
80103710:	83 e0 06             	and    $0x6,%eax
80103713:	83 f8 02             	cmp    $0x2,%eax
80103716:	0f 84 a8 00 00 00    	je     801037c4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010371c:	8b 53 04             	mov    0x4(%ebx),%edx
8010371f:	85 d2                	test   %edx,%edx
80103721:	74 0d                	je     80103730 <iderw+0x40>
80103723:	a1 60 3d 11 80       	mov    0x80113d60,%eax
80103728:	85 c0                	test   %eax,%eax
8010372a:	0f 84 87 00 00 00    	je     801037b7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80103730:	83 ec 0c             	sub    $0xc,%esp
80103733:	68 80 3d 11 80       	push   $0x80113d80
80103738:	e8 23 25 00 00       	call   80105c60 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010373d:	a1 64 3d 11 80       	mov    0x80113d64,%eax
  b->qnext = 0;
80103742:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80103749:	83 c4 10             	add    $0x10,%esp
8010374c:	85 c0                	test   %eax,%eax
8010374e:	74 60                	je     801037b0 <iderw+0xc0>
80103750:	89 c2                	mov    %eax,%edx
80103752:	8b 40 58             	mov    0x58(%eax),%eax
80103755:	85 c0                	test   %eax,%eax
80103757:	75 f7                	jne    80103750 <iderw+0x60>
80103759:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010375c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010375e:	39 1d 64 3d 11 80    	cmp    %ebx,0x80113d64
80103764:	74 3a                	je     801037a0 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80103766:	8b 03                	mov    (%ebx),%eax
80103768:	83 e0 06             	and    $0x6,%eax
8010376b:	83 f8 02             	cmp    $0x2,%eax
8010376e:	74 1b                	je     8010378b <iderw+0x9b>
    sleep(b, &idelock);
80103770:	83 ec 08             	sub    $0x8,%esp
80103773:	68 80 3d 11 80       	push   $0x80113d80
80103778:	53                   	push   %ebx
80103779:	e8 f2 1c 00 00       	call   80105470 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010377e:	8b 03                	mov    (%ebx),%eax
80103780:	83 c4 10             	add    $0x10,%esp
80103783:	83 e0 06             	and    $0x6,%eax
80103786:	83 f8 02             	cmp    $0x2,%eax
80103789:	75 e5                	jne    80103770 <iderw+0x80>
  }


  release(&idelock);
8010378b:	c7 45 08 80 3d 11 80 	movl   $0x80113d80,0x8(%ebp)
}
80103792:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103795:	c9                   	leave  
  release(&idelock);
80103796:	e9 65 24 00 00       	jmp    80105c00 <release>
8010379b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010379f:	90                   	nop
    idestart(b);
801037a0:	89 d8                	mov    %ebx,%eax
801037a2:	e8 49 fd ff ff       	call   801034f0 <idestart>
801037a7:	eb bd                	jmp    80103766 <iderw+0x76>
801037a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801037b0:	ba 64 3d 11 80       	mov    $0x80113d64,%edx
801037b5:	eb a5                	jmp    8010375c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
801037b7:	83 ec 0c             	sub    $0xc,%esp
801037ba:	68 65 8e 10 80       	push   $0x80108e65
801037bf:	e8 bc cb ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801037c4:	83 ec 0c             	sub    $0xc,%esp
801037c7:	68 50 8e 10 80       	push   $0x80108e50
801037cc:	e8 af cb ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801037d1:	83 ec 0c             	sub    $0xc,%esp
801037d4:	68 3a 8e 10 80       	push   $0x80108e3a
801037d9:	e8 a2 cb ff ff       	call   80100380 <panic>
801037de:	66 90                	xchg   %ax,%ax

801037e0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801037e0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801037e1:	c7 05 b4 3d 11 80 00 	movl   $0xfec00000,0x80113db4
801037e8:	00 c0 fe 
{
801037eb:	89 e5                	mov    %esp,%ebp
801037ed:	56                   	push   %esi
801037ee:	53                   	push   %ebx
  ioapic->reg = reg;
801037ef:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801037f6:	00 00 00 
  return ioapic->data;
801037f9:	8b 15 b4 3d 11 80    	mov    0x80113db4,%edx
801037ff:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80103802:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80103808:	8b 0d b4 3d 11 80    	mov    0x80113db4,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010380e:	0f b6 15 00 3f 11 80 	movzbl 0x80113f00,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80103815:	c1 ee 10             	shr    $0x10,%esi
80103818:	89 f0                	mov    %esi,%eax
8010381a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010381d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80103820:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80103823:	39 c2                	cmp    %eax,%edx
80103825:	74 16                	je     8010383d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80103827:	83 ec 0c             	sub    $0xc,%esp
8010382a:	68 84 8e 10 80       	push   $0x80108e84
8010382f:	e8 cc ce ff ff       	call   80100700 <cprintf>
  ioapic->reg = reg;
80103834:	8b 0d b4 3d 11 80    	mov    0x80113db4,%ecx
8010383a:	83 c4 10             	add    $0x10,%esp
8010383d:	83 c6 21             	add    $0x21,%esi
{
80103840:	ba 10 00 00 00       	mov    $0x10,%edx
80103845:	b8 20 00 00 00       	mov    $0x20,%eax
8010384a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80103850:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80103852:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80103854:	8b 0d b4 3d 11 80    	mov    0x80113db4,%ecx
  for(i = 0; i <= maxintr; i++){
8010385a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010385d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80103863:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80103866:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
80103869:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
8010386c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010386e:	8b 0d b4 3d 11 80    	mov    0x80113db4,%ecx
80103874:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010387b:	39 f0                	cmp    %esi,%eax
8010387d:	75 d1                	jne    80103850 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010387f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103882:	5b                   	pop    %ebx
80103883:	5e                   	pop    %esi
80103884:	5d                   	pop    %ebp
80103885:	c3                   	ret    
80103886:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010388d:	8d 76 00             	lea    0x0(%esi),%esi

80103890 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80103890:	55                   	push   %ebp
  ioapic->reg = reg;
80103891:	8b 0d b4 3d 11 80    	mov    0x80113db4,%ecx
{
80103897:	89 e5                	mov    %esp,%ebp
80103899:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010389c:	8d 50 20             	lea    0x20(%eax),%edx
8010389f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801038a3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801038a5:	8b 0d b4 3d 11 80    	mov    0x80113db4,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801038ab:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801038ae:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801038b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801038b4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801038b6:	a1 b4 3d 11 80       	mov    0x80113db4,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801038bb:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801038be:	89 50 10             	mov    %edx,0x10(%eax)
}
801038c1:	5d                   	pop    %ebp
801038c2:	c3                   	ret    
801038c3:	66 90                	xchg   %ax,%ax
801038c5:	66 90                	xchg   %ax,%ax
801038c7:	66 90                	xchg   %ax,%ax
801038c9:	66 90                	xchg   %ax,%ax
801038cb:	66 90                	xchg   %ax,%ax
801038cd:	66 90                	xchg   %ax,%ax
801038cf:	90                   	nop

801038d0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801038d0:	55                   	push   %ebp
801038d1:	89 e5                	mov    %esp,%ebp
801038d3:	53                   	push   %ebx
801038d4:	83 ec 04             	sub    $0x4,%esp
801038d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801038da:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801038e0:	75 76                	jne    80103958 <kfree+0x88>
801038e2:	81 fb 50 97 11 80    	cmp    $0x80119750,%ebx
801038e8:	72 6e                	jb     80103958 <kfree+0x88>
801038ea:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801038f0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801038f5:	77 61                	ja     80103958 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801038f7:	83 ec 04             	sub    $0x4,%esp
801038fa:	68 00 10 00 00       	push   $0x1000
801038ff:	6a 01                	push   $0x1
80103901:	53                   	push   %ebx
80103902:	e8 19 24 00 00       	call   80105d20 <memset>

  if(kmem.use_lock)
80103907:	8b 15 f4 3d 11 80    	mov    0x80113df4,%edx
8010390d:	83 c4 10             	add    $0x10,%esp
80103910:	85 d2                	test   %edx,%edx
80103912:	75 1c                	jne    80103930 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80103914:	a1 f8 3d 11 80       	mov    0x80113df8,%eax
80103919:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010391b:	a1 f4 3d 11 80       	mov    0x80113df4,%eax
  kmem.freelist = r;
80103920:	89 1d f8 3d 11 80    	mov    %ebx,0x80113df8
  if(kmem.use_lock)
80103926:	85 c0                	test   %eax,%eax
80103928:	75 1e                	jne    80103948 <kfree+0x78>
    release(&kmem.lock);
}
8010392a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010392d:	c9                   	leave  
8010392e:	c3                   	ret    
8010392f:	90                   	nop
    acquire(&kmem.lock);
80103930:	83 ec 0c             	sub    $0xc,%esp
80103933:	68 c0 3d 11 80       	push   $0x80113dc0
80103938:	e8 23 23 00 00       	call   80105c60 <acquire>
8010393d:	83 c4 10             	add    $0x10,%esp
80103940:	eb d2                	jmp    80103914 <kfree+0x44>
80103942:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80103948:	c7 45 08 c0 3d 11 80 	movl   $0x80113dc0,0x8(%ebp)
}
8010394f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103952:	c9                   	leave  
    release(&kmem.lock);
80103953:	e9 a8 22 00 00       	jmp    80105c00 <release>
    panic("kfree");
80103958:	83 ec 0c             	sub    $0xc,%esp
8010395b:	68 b6 8e 10 80       	push   $0x80108eb6
80103960:	e8 1b ca ff ff       	call   80100380 <panic>
80103965:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010396c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103970 <freerange>:
{
80103970:	55                   	push   %ebp
80103971:	89 e5                	mov    %esp,%ebp
80103973:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80103974:	8b 45 08             	mov    0x8(%ebp),%eax
{
80103977:	8b 75 0c             	mov    0xc(%ebp),%esi
8010397a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010397b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80103981:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80103987:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010398d:	39 de                	cmp    %ebx,%esi
8010398f:	72 23                	jb     801039b4 <freerange+0x44>
80103991:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80103998:	83 ec 0c             	sub    $0xc,%esp
8010399b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801039a1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801039a7:	50                   	push   %eax
801039a8:	e8 23 ff ff ff       	call   801038d0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801039ad:	83 c4 10             	add    $0x10,%esp
801039b0:	39 f3                	cmp    %esi,%ebx
801039b2:	76 e4                	jbe    80103998 <freerange+0x28>
}
801039b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801039b7:	5b                   	pop    %ebx
801039b8:	5e                   	pop    %esi
801039b9:	5d                   	pop    %ebp
801039ba:	c3                   	ret    
801039bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801039bf:	90                   	nop

801039c0 <kinit2>:
{
801039c0:	55                   	push   %ebp
801039c1:	89 e5                	mov    %esp,%ebp
801039c3:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801039c4:	8b 45 08             	mov    0x8(%ebp),%eax
{
801039c7:	8b 75 0c             	mov    0xc(%ebp),%esi
801039ca:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801039cb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801039d1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801039d7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801039dd:	39 de                	cmp    %ebx,%esi
801039df:	72 23                	jb     80103a04 <kinit2+0x44>
801039e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801039e8:	83 ec 0c             	sub    $0xc,%esp
801039eb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801039f1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801039f7:	50                   	push   %eax
801039f8:	e8 d3 fe ff ff       	call   801038d0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801039fd:	83 c4 10             	add    $0x10,%esp
80103a00:	39 de                	cmp    %ebx,%esi
80103a02:	73 e4                	jae    801039e8 <kinit2+0x28>
  kmem.use_lock = 1;
80103a04:	c7 05 f4 3d 11 80 01 	movl   $0x1,0x80113df4
80103a0b:	00 00 00 
}
80103a0e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a11:	5b                   	pop    %ebx
80103a12:	5e                   	pop    %esi
80103a13:	5d                   	pop    %ebp
80103a14:	c3                   	ret    
80103a15:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103a20 <kinit1>:
{
80103a20:	55                   	push   %ebp
80103a21:	89 e5                	mov    %esp,%ebp
80103a23:	56                   	push   %esi
80103a24:	53                   	push   %ebx
80103a25:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80103a28:	83 ec 08             	sub    $0x8,%esp
80103a2b:	68 bc 8e 10 80       	push   $0x80108ebc
80103a30:	68 c0 3d 11 80       	push   $0x80113dc0
80103a35:	e8 56 20 00 00       	call   80105a90 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
80103a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80103a3d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80103a40:	c7 05 f4 3d 11 80 00 	movl   $0x0,0x80113df4
80103a47:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
80103a4a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80103a50:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80103a56:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80103a5c:	39 de                	cmp    %ebx,%esi
80103a5e:	72 1c                	jb     80103a7c <kinit1+0x5c>
    kfree(p);
80103a60:	83 ec 0c             	sub    $0xc,%esp
80103a63:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80103a69:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80103a6f:	50                   	push   %eax
80103a70:	e8 5b fe ff ff       	call   801038d0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80103a75:	83 c4 10             	add    $0x10,%esp
80103a78:	39 de                	cmp    %ebx,%esi
80103a7a:	73 e4                	jae    80103a60 <kinit1+0x40>
}
80103a7c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a7f:	5b                   	pop    %ebx
80103a80:	5e                   	pop    %esi
80103a81:	5d                   	pop    %ebp
80103a82:	c3                   	ret    
80103a83:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103a90 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80103a90:	a1 f4 3d 11 80       	mov    0x80113df4,%eax
80103a95:	85 c0                	test   %eax,%eax
80103a97:	75 1f                	jne    80103ab8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80103a99:	a1 f8 3d 11 80       	mov    0x80113df8,%eax
  if(r)
80103a9e:	85 c0                	test   %eax,%eax
80103aa0:	74 0e                	je     80103ab0 <kalloc+0x20>
    kmem.freelist = r->next;
80103aa2:	8b 10                	mov    (%eax),%edx
80103aa4:	89 15 f8 3d 11 80    	mov    %edx,0x80113df8
  if(kmem.use_lock)
80103aaa:	c3                   	ret    
80103aab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103aaf:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80103ab0:	c3                   	ret    
80103ab1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80103ab8:	55                   	push   %ebp
80103ab9:	89 e5                	mov    %esp,%ebp
80103abb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
80103abe:	68 c0 3d 11 80       	push   $0x80113dc0
80103ac3:	e8 98 21 00 00       	call   80105c60 <acquire>
  r = kmem.freelist;
80103ac8:	a1 f8 3d 11 80       	mov    0x80113df8,%eax
  if(kmem.use_lock)
80103acd:	8b 15 f4 3d 11 80    	mov    0x80113df4,%edx
  if(r)
80103ad3:	83 c4 10             	add    $0x10,%esp
80103ad6:	85 c0                	test   %eax,%eax
80103ad8:	74 08                	je     80103ae2 <kalloc+0x52>
    kmem.freelist = r->next;
80103ada:	8b 08                	mov    (%eax),%ecx
80103adc:	89 0d f8 3d 11 80    	mov    %ecx,0x80113df8
  if(kmem.use_lock)
80103ae2:	85 d2                	test   %edx,%edx
80103ae4:	74 16                	je     80103afc <kalloc+0x6c>
    release(&kmem.lock);
80103ae6:	83 ec 0c             	sub    $0xc,%esp
80103ae9:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103aec:	68 c0 3d 11 80       	push   $0x80113dc0
80103af1:	e8 0a 21 00 00       	call   80105c00 <release>
  return (char*)r;
80103af6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80103af9:	83 c4 10             	add    $0x10,%esp
}
80103afc:	c9                   	leave  
80103afd:	c3                   	ret    
80103afe:	66 90                	xchg   %ax,%ax

80103b00 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103b00:	ba 64 00 00 00       	mov    $0x64,%edx
80103b05:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80103b06:	a8 01                	test   $0x1,%al
80103b08:	0f 84 c2 00 00 00    	je     80103bd0 <kbdgetc+0xd0>
{
80103b0e:	55                   	push   %ebp
80103b0f:	ba 60 00 00 00       	mov    $0x60,%edx
80103b14:	89 e5                	mov    %esp,%ebp
80103b16:	53                   	push   %ebx
80103b17:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80103b18:	8b 1d fc 3d 11 80    	mov    0x80113dfc,%ebx
  data = inb(KBDATAP);
80103b1e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80103b21:	3c e0                	cmp    $0xe0,%al
80103b23:	74 5b                	je     80103b80 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80103b25:	89 da                	mov    %ebx,%edx
80103b27:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
80103b2a:	84 c0                	test   %al,%al
80103b2c:	78 62                	js     80103b90 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80103b2e:	85 d2                	test   %edx,%edx
80103b30:	74 09                	je     80103b3b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80103b32:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80103b35:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80103b38:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
80103b3b:	0f b6 91 00 90 10 80 	movzbl -0x7fef7000(%ecx),%edx
  shift ^= togglecode[data];
80103b42:	0f b6 81 00 8f 10 80 	movzbl -0x7fef7100(%ecx),%eax
  shift |= shiftcode[data];
80103b49:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
80103b4b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
80103b4d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
80103b4f:	89 15 fc 3d 11 80    	mov    %edx,0x80113dfc
  c = charcode[shift & (CTL | SHIFT)][data];
80103b55:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80103b58:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
80103b5b:	8b 04 85 e0 8e 10 80 	mov    -0x7fef7120(,%eax,4),%eax
80103b62:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80103b66:	74 0b                	je     80103b73 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80103b68:	8d 50 9f             	lea    -0x61(%eax),%edx
80103b6b:	83 fa 19             	cmp    $0x19,%edx
80103b6e:	77 48                	ja     80103bb8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80103b70:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80103b73:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b76:	c9                   	leave  
80103b77:	c3                   	ret    
80103b78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b7f:	90                   	nop
    shift |= E0ESC;
80103b80:	83 cb 40             	or     $0x40,%ebx
    return 0;
80103b83:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80103b85:	89 1d fc 3d 11 80    	mov    %ebx,0x80113dfc
}
80103b8b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b8e:	c9                   	leave  
80103b8f:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80103b90:	83 e0 7f             	and    $0x7f,%eax
80103b93:	85 d2                	test   %edx,%edx
80103b95:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80103b98:	0f b6 81 00 90 10 80 	movzbl -0x7fef7000(%ecx),%eax
80103b9f:	83 c8 40             	or     $0x40,%eax
80103ba2:	0f b6 c0             	movzbl %al,%eax
80103ba5:	f7 d0                	not    %eax
80103ba7:	21 d8                	and    %ebx,%eax
}
80103ba9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
80103bac:	a3 fc 3d 11 80       	mov    %eax,0x80113dfc
    return 0;
80103bb1:	31 c0                	xor    %eax,%eax
}
80103bb3:	c9                   	leave  
80103bb4:	c3                   	ret    
80103bb5:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80103bb8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80103bbb:	8d 50 20             	lea    0x20(%eax),%edx
}
80103bbe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103bc1:	c9                   	leave  
      c += 'a' - 'A';
80103bc2:	83 f9 1a             	cmp    $0x1a,%ecx
80103bc5:	0f 42 c2             	cmovb  %edx,%eax
}
80103bc8:	c3                   	ret    
80103bc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80103bd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103bd5:	c3                   	ret    
80103bd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103bdd:	8d 76 00             	lea    0x0(%esi),%esi

80103be0 <kbdintr>:

void
kbdintr(void)
{
80103be0:	55                   	push   %ebp
80103be1:	89 e5                	mov    %esp,%ebp
80103be3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80103be6:	68 00 3b 10 80       	push   $0x80103b00
80103beb:	e8 50 d9 ff ff       	call   80101540 <consoleintr>
}
80103bf0:	83 c4 10             	add    $0x10,%esp
80103bf3:	c9                   	leave  
80103bf4:	c3                   	ret    
80103bf5:	66 90                	xchg   %ax,%ax
80103bf7:	66 90                	xchg   %ax,%ax
80103bf9:	66 90                	xchg   %ax,%ax
80103bfb:	66 90                	xchg   %ax,%ax
80103bfd:	66 90                	xchg   %ax,%ax
80103bff:	90                   	nop

80103c00 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80103c00:	a1 00 3e 11 80       	mov    0x80113e00,%eax
80103c05:	85 c0                	test   %eax,%eax
80103c07:	0f 84 cb 00 00 00    	je     80103cd8 <lapicinit+0xd8>
  lapic[index] = value;
80103c0d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80103c14:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103c17:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103c1a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80103c21:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103c24:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103c27:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80103c2e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80103c31:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103c34:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80103c3b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80103c3e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103c41:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80103c48:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80103c4b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103c4e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80103c55:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80103c58:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80103c5b:	8b 50 30             	mov    0x30(%eax),%edx
80103c5e:	c1 ea 10             	shr    $0x10,%edx
80103c61:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80103c67:	75 77                	jne    80103ce0 <lapicinit+0xe0>
  lapic[index] = value;
80103c69:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80103c70:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103c73:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103c76:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80103c7d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103c80:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103c83:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80103c8a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103c8d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103c90:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80103c97:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103c9a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103c9d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80103ca4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103ca7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103caa:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80103cb1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80103cb4:	8b 50 20             	mov    0x20(%eax),%edx
80103cb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103cbe:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80103cc0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80103cc6:	80 e6 10             	and    $0x10,%dh
80103cc9:	75 f5                	jne    80103cc0 <lapicinit+0xc0>
  lapic[index] = value;
80103ccb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80103cd2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103cd5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80103cd8:	c3                   	ret    
80103cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80103ce0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80103ce7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80103cea:	8b 50 20             	mov    0x20(%eax),%edx
}
80103ced:	e9 77 ff ff ff       	jmp    80103c69 <lapicinit+0x69>
80103cf2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103d00 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80103d00:	a1 00 3e 11 80       	mov    0x80113e00,%eax
80103d05:	85 c0                	test   %eax,%eax
80103d07:	74 07                	je     80103d10 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80103d09:	8b 40 20             	mov    0x20(%eax),%eax
80103d0c:	c1 e8 18             	shr    $0x18,%eax
80103d0f:	c3                   	ret    
    return 0;
80103d10:	31 c0                	xor    %eax,%eax
}
80103d12:	c3                   	ret    
80103d13:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103d20 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80103d20:	a1 00 3e 11 80       	mov    0x80113e00,%eax
80103d25:	85 c0                	test   %eax,%eax
80103d27:	74 0d                	je     80103d36 <lapiceoi+0x16>
  lapic[index] = value;
80103d29:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80103d30:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103d33:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80103d36:	c3                   	ret    
80103d37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d3e:	66 90                	xchg   %ax,%ax

80103d40 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80103d40:	c3                   	ret    
80103d41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d4f:	90                   	nop

80103d50 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80103d50:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103d51:	b8 0f 00 00 00       	mov    $0xf,%eax
80103d56:	ba 70 00 00 00       	mov    $0x70,%edx
80103d5b:	89 e5                	mov    %esp,%ebp
80103d5d:	53                   	push   %ebx
80103d5e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103d61:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103d64:	ee                   	out    %al,(%dx)
80103d65:	b8 0a 00 00 00       	mov    $0xa,%eax
80103d6a:	ba 71 00 00 00       	mov    $0x71,%edx
80103d6f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80103d70:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80103d72:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80103d75:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80103d7b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80103d7d:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80103d80:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80103d82:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80103d85:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80103d88:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80103d8e:	a1 00 3e 11 80       	mov    0x80113e00,%eax
80103d93:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103d99:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103d9c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80103da3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103da6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103da9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80103db0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103db3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103db6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103dbc:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103dbf:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103dc5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103dc8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103dce:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103dd1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103dd7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80103dda:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ddd:	c9                   	leave  
80103dde:	c3                   	ret    
80103ddf:	90                   	nop

80103de0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80103de0:	55                   	push   %ebp
80103de1:	b8 0b 00 00 00       	mov    $0xb,%eax
80103de6:	ba 70 00 00 00       	mov    $0x70,%edx
80103deb:	89 e5                	mov    %esp,%ebp
80103ded:	57                   	push   %edi
80103dee:	56                   	push   %esi
80103def:	53                   	push   %ebx
80103df0:	83 ec 4c             	sub    $0x4c,%esp
80103df3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103df4:	ba 71 00 00 00       	mov    $0x71,%edx
80103df9:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80103dfa:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103dfd:	bb 70 00 00 00       	mov    $0x70,%ebx
80103e02:	88 45 b3             	mov    %al,-0x4d(%ebp)
80103e05:	8d 76 00             	lea    0x0(%esi),%esi
80103e08:	31 c0                	xor    %eax,%eax
80103e0a:	89 da                	mov    %ebx,%edx
80103e0c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103e0d:	b9 71 00 00 00       	mov    $0x71,%ecx
80103e12:	89 ca                	mov    %ecx,%edx
80103e14:	ec                   	in     (%dx),%al
80103e15:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103e18:	89 da                	mov    %ebx,%edx
80103e1a:	b8 02 00 00 00       	mov    $0x2,%eax
80103e1f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103e20:	89 ca                	mov    %ecx,%edx
80103e22:	ec                   	in     (%dx),%al
80103e23:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103e26:	89 da                	mov    %ebx,%edx
80103e28:	b8 04 00 00 00       	mov    $0x4,%eax
80103e2d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103e2e:	89 ca                	mov    %ecx,%edx
80103e30:	ec                   	in     (%dx),%al
80103e31:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103e34:	89 da                	mov    %ebx,%edx
80103e36:	b8 07 00 00 00       	mov    $0x7,%eax
80103e3b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103e3c:	89 ca                	mov    %ecx,%edx
80103e3e:	ec                   	in     (%dx),%al
80103e3f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103e42:	89 da                	mov    %ebx,%edx
80103e44:	b8 08 00 00 00       	mov    $0x8,%eax
80103e49:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103e4a:	89 ca                	mov    %ecx,%edx
80103e4c:	ec                   	in     (%dx),%al
80103e4d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103e4f:	89 da                	mov    %ebx,%edx
80103e51:	b8 09 00 00 00       	mov    $0x9,%eax
80103e56:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103e57:	89 ca                	mov    %ecx,%edx
80103e59:	ec                   	in     (%dx),%al
80103e5a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103e5c:	89 da                	mov    %ebx,%edx
80103e5e:	b8 0a 00 00 00       	mov    $0xa,%eax
80103e63:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103e64:	89 ca                	mov    %ecx,%edx
80103e66:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80103e67:	84 c0                	test   %al,%al
80103e69:	78 9d                	js     80103e08 <cmostime+0x28>
  return inb(CMOS_RETURN);
80103e6b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80103e6f:	89 fa                	mov    %edi,%edx
80103e71:	0f b6 fa             	movzbl %dl,%edi
80103e74:	89 f2                	mov    %esi,%edx
80103e76:	89 45 b8             	mov    %eax,-0x48(%ebp)
80103e79:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80103e7d:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103e80:	89 da                	mov    %ebx,%edx
80103e82:	89 7d c8             	mov    %edi,-0x38(%ebp)
80103e85:	89 45 bc             	mov    %eax,-0x44(%ebp)
80103e88:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80103e8c:	89 75 cc             	mov    %esi,-0x34(%ebp)
80103e8f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80103e92:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80103e96:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80103e99:	31 c0                	xor    %eax,%eax
80103e9b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103e9c:	89 ca                	mov    %ecx,%edx
80103e9e:	ec                   	in     (%dx),%al
80103e9f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103ea2:	89 da                	mov    %ebx,%edx
80103ea4:	89 45 d0             	mov    %eax,-0x30(%ebp)
80103ea7:	b8 02 00 00 00       	mov    $0x2,%eax
80103eac:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103ead:	89 ca                	mov    %ecx,%edx
80103eaf:	ec                   	in     (%dx),%al
80103eb0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103eb3:	89 da                	mov    %ebx,%edx
80103eb5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80103eb8:	b8 04 00 00 00       	mov    $0x4,%eax
80103ebd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103ebe:	89 ca                	mov    %ecx,%edx
80103ec0:	ec                   	in     (%dx),%al
80103ec1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103ec4:	89 da                	mov    %ebx,%edx
80103ec6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80103ec9:	b8 07 00 00 00       	mov    $0x7,%eax
80103ece:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103ecf:	89 ca                	mov    %ecx,%edx
80103ed1:	ec                   	in     (%dx),%al
80103ed2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103ed5:	89 da                	mov    %ebx,%edx
80103ed7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80103eda:	b8 08 00 00 00       	mov    $0x8,%eax
80103edf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103ee0:	89 ca                	mov    %ecx,%edx
80103ee2:	ec                   	in     (%dx),%al
80103ee3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103ee6:	89 da                	mov    %ebx,%edx
80103ee8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80103eeb:	b8 09 00 00 00       	mov    $0x9,%eax
80103ef0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103ef1:	89 ca                	mov    %ecx,%edx
80103ef3:	ec                   	in     (%dx),%al
80103ef4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80103ef7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80103efa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80103efd:	8d 45 d0             	lea    -0x30(%ebp),%eax
80103f00:	6a 18                	push   $0x18
80103f02:	50                   	push   %eax
80103f03:	8d 45 b8             	lea    -0x48(%ebp),%eax
80103f06:	50                   	push   %eax
80103f07:	e8 64 1e 00 00       	call   80105d70 <memcmp>
80103f0c:	83 c4 10             	add    $0x10,%esp
80103f0f:	85 c0                	test   %eax,%eax
80103f11:	0f 85 f1 fe ff ff    	jne    80103e08 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80103f17:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80103f1b:	75 78                	jne    80103f95 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80103f1d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80103f20:	89 c2                	mov    %eax,%edx
80103f22:	83 e0 0f             	and    $0xf,%eax
80103f25:	c1 ea 04             	shr    $0x4,%edx
80103f28:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103f2b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103f2e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80103f31:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103f34:	89 c2                	mov    %eax,%edx
80103f36:	83 e0 0f             	and    $0xf,%eax
80103f39:	c1 ea 04             	shr    $0x4,%edx
80103f3c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103f3f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103f42:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80103f45:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103f48:	89 c2                	mov    %eax,%edx
80103f4a:	83 e0 0f             	and    $0xf,%eax
80103f4d:	c1 ea 04             	shr    $0x4,%edx
80103f50:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103f53:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103f56:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80103f59:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80103f5c:	89 c2                	mov    %eax,%edx
80103f5e:	83 e0 0f             	and    $0xf,%eax
80103f61:	c1 ea 04             	shr    $0x4,%edx
80103f64:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103f67:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103f6a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80103f6d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103f70:	89 c2                	mov    %eax,%edx
80103f72:	83 e0 0f             	and    $0xf,%eax
80103f75:	c1 ea 04             	shr    $0x4,%edx
80103f78:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103f7b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103f7e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80103f81:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103f84:	89 c2                	mov    %eax,%edx
80103f86:	83 e0 0f             	and    $0xf,%eax
80103f89:	c1 ea 04             	shr    $0x4,%edx
80103f8c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103f8f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103f92:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80103f95:	8b 75 08             	mov    0x8(%ebp),%esi
80103f98:	8b 45 b8             	mov    -0x48(%ebp),%eax
80103f9b:	89 06                	mov    %eax,(%esi)
80103f9d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103fa0:	89 46 04             	mov    %eax,0x4(%esi)
80103fa3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103fa6:	89 46 08             	mov    %eax,0x8(%esi)
80103fa9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80103fac:	89 46 0c             	mov    %eax,0xc(%esi)
80103faf:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103fb2:	89 46 10             	mov    %eax,0x10(%esi)
80103fb5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103fb8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80103fbb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80103fc2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103fc5:	5b                   	pop    %ebx
80103fc6:	5e                   	pop    %esi
80103fc7:	5f                   	pop    %edi
80103fc8:	5d                   	pop    %ebp
80103fc9:	c3                   	ret    
80103fca:	66 90                	xchg   %ax,%ax
80103fcc:	66 90                	xchg   %ax,%ax
80103fce:	66 90                	xchg   %ax,%ax

80103fd0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103fd0:	8b 0d 68 3e 11 80    	mov    0x80113e68,%ecx
80103fd6:	85 c9                	test   %ecx,%ecx
80103fd8:	0f 8e 8a 00 00 00    	jle    80104068 <install_trans+0x98>
{
80103fde:	55                   	push   %ebp
80103fdf:	89 e5                	mov    %esp,%ebp
80103fe1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80103fe2:	31 ff                	xor    %edi,%edi
{
80103fe4:	56                   	push   %esi
80103fe5:	53                   	push   %ebx
80103fe6:	83 ec 0c             	sub    $0xc,%esp
80103fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103ff0:	a1 54 3e 11 80       	mov    0x80113e54,%eax
80103ff5:	83 ec 08             	sub    $0x8,%esp
80103ff8:	01 f8                	add    %edi,%eax
80103ffa:	83 c0 01             	add    $0x1,%eax
80103ffd:	50                   	push   %eax
80103ffe:	ff 35 64 3e 11 80    	push   0x80113e64
80104004:	e8 c7 c0 ff ff       	call   801000d0 <bread>
80104009:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010400b:	58                   	pop    %eax
8010400c:	5a                   	pop    %edx
8010400d:	ff 34 bd 6c 3e 11 80 	push   -0x7feec194(,%edi,4)
80104014:	ff 35 64 3e 11 80    	push   0x80113e64
  for (tail = 0; tail < log.lh.n; tail++) {
8010401a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010401d:	e8 ae c0 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80104022:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80104025:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80104027:	8d 46 5c             	lea    0x5c(%esi),%eax
8010402a:	68 00 02 00 00       	push   $0x200
8010402f:	50                   	push   %eax
80104030:	8d 43 5c             	lea    0x5c(%ebx),%eax
80104033:	50                   	push   %eax
80104034:	e8 87 1d 00 00       	call   80105dc0 <memmove>
    bwrite(dbuf);  // write dst to disk
80104039:	89 1c 24             	mov    %ebx,(%esp)
8010403c:	e8 6f c1 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80104041:	89 34 24             	mov    %esi,(%esp)
80104044:	e8 a7 c1 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80104049:	89 1c 24             	mov    %ebx,(%esp)
8010404c:	e8 9f c1 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80104051:	83 c4 10             	add    $0x10,%esp
80104054:	39 3d 68 3e 11 80    	cmp    %edi,0x80113e68
8010405a:	7f 94                	jg     80103ff0 <install_trans+0x20>
  }
}
8010405c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010405f:	5b                   	pop    %ebx
80104060:	5e                   	pop    %esi
80104061:	5f                   	pop    %edi
80104062:	5d                   	pop    %ebp
80104063:	c3                   	ret    
80104064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104068:	c3                   	ret    
80104069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104070 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80104070:	55                   	push   %ebp
80104071:	89 e5                	mov    %esp,%ebp
80104073:	53                   	push   %ebx
80104074:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80104077:	ff 35 54 3e 11 80    	push   0x80113e54
8010407d:	ff 35 64 3e 11 80    	push   0x80113e64
80104083:	e8 48 c0 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80104088:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
8010408b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
8010408d:	a1 68 3e 11 80       	mov    0x80113e68,%eax
80104092:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80104095:	85 c0                	test   %eax,%eax
80104097:	7e 19                	jle    801040b2 <write_head+0x42>
80104099:	31 d2                	xor    %edx,%edx
8010409b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010409f:	90                   	nop
    hb->block[i] = log.lh.block[i];
801040a0:	8b 0c 95 6c 3e 11 80 	mov    -0x7feec194(,%edx,4),%ecx
801040a7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801040ab:	83 c2 01             	add    $0x1,%edx
801040ae:	39 d0                	cmp    %edx,%eax
801040b0:	75 ee                	jne    801040a0 <write_head+0x30>
  }
  bwrite(buf);
801040b2:	83 ec 0c             	sub    $0xc,%esp
801040b5:	53                   	push   %ebx
801040b6:	e8 f5 c0 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
801040bb:	89 1c 24             	mov    %ebx,(%esp)
801040be:	e8 2d c1 ff ff       	call   801001f0 <brelse>
}
801040c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040c6:	83 c4 10             	add    $0x10,%esp
801040c9:	c9                   	leave  
801040ca:	c3                   	ret    
801040cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040cf:	90                   	nop

801040d0 <initlog>:
{
801040d0:	55                   	push   %ebp
801040d1:	89 e5                	mov    %esp,%ebp
801040d3:	53                   	push   %ebx
801040d4:	83 ec 2c             	sub    $0x2c,%esp
801040d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
801040da:	68 00 91 10 80       	push   $0x80109100
801040df:	68 20 3e 11 80       	push   $0x80113e20
801040e4:	e8 a7 19 00 00       	call   80105a90 <initlock>
  readsb(dev, &sb);
801040e9:	58                   	pop    %eax
801040ea:	8d 45 dc             	lea    -0x24(%ebp),%eax
801040ed:	5a                   	pop    %edx
801040ee:	50                   	push   %eax
801040ef:	53                   	push   %ebx
801040f0:	e8 3b e8 ff ff       	call   80102930 <readsb>
  log.start = sb.logstart;
801040f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
801040f8:	59                   	pop    %ecx
  log.dev = dev;
801040f9:	89 1d 64 3e 11 80    	mov    %ebx,0x80113e64
  log.size = sb.nlog;
801040ff:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80104102:	a3 54 3e 11 80       	mov    %eax,0x80113e54
  log.size = sb.nlog;
80104107:	89 15 58 3e 11 80    	mov    %edx,0x80113e58
  struct buf *buf = bread(log.dev, log.start);
8010410d:	5a                   	pop    %edx
8010410e:	50                   	push   %eax
8010410f:	53                   	push   %ebx
80104110:	e8 bb bf ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80104115:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80104118:	8b 58 5c             	mov    0x5c(%eax),%ebx
8010411b:	89 1d 68 3e 11 80    	mov    %ebx,0x80113e68
  for (i = 0; i < log.lh.n; i++) {
80104121:	85 db                	test   %ebx,%ebx
80104123:	7e 1d                	jle    80104142 <initlog+0x72>
80104125:	31 d2                	xor    %edx,%edx
80104127:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010412e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80104130:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80104134:	89 0c 95 6c 3e 11 80 	mov    %ecx,-0x7feec194(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010413b:	83 c2 01             	add    $0x1,%edx
8010413e:	39 d3                	cmp    %edx,%ebx
80104140:	75 ee                	jne    80104130 <initlog+0x60>
  brelse(buf);
80104142:	83 ec 0c             	sub    $0xc,%esp
80104145:	50                   	push   %eax
80104146:	e8 a5 c0 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
8010414b:	e8 80 fe ff ff       	call   80103fd0 <install_trans>
  log.lh.n = 0;
80104150:	c7 05 68 3e 11 80 00 	movl   $0x0,0x80113e68
80104157:	00 00 00 
  write_head(); // clear the log
8010415a:	e8 11 ff ff ff       	call   80104070 <write_head>
}
8010415f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104162:	83 c4 10             	add    $0x10,%esp
80104165:	c9                   	leave  
80104166:	c3                   	ret    
80104167:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010416e:	66 90                	xchg   %ax,%ax

80104170 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80104170:	55                   	push   %ebp
80104171:	89 e5                	mov    %esp,%ebp
80104173:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80104176:	68 20 3e 11 80       	push   $0x80113e20
8010417b:	e8 e0 1a 00 00       	call   80105c60 <acquire>
80104180:	83 c4 10             	add    $0x10,%esp
80104183:	eb 18                	jmp    8010419d <begin_op+0x2d>
80104185:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80104188:	83 ec 08             	sub    $0x8,%esp
8010418b:	68 20 3e 11 80       	push   $0x80113e20
80104190:	68 20 3e 11 80       	push   $0x80113e20
80104195:	e8 d6 12 00 00       	call   80105470 <sleep>
8010419a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
8010419d:	a1 60 3e 11 80       	mov    0x80113e60,%eax
801041a2:	85 c0                	test   %eax,%eax
801041a4:	75 e2                	jne    80104188 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801041a6:	a1 5c 3e 11 80       	mov    0x80113e5c,%eax
801041ab:	8b 15 68 3e 11 80    	mov    0x80113e68,%edx
801041b1:	83 c0 01             	add    $0x1,%eax
801041b4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
801041b7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
801041ba:	83 fa 1e             	cmp    $0x1e,%edx
801041bd:	7f c9                	jg     80104188 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
801041bf:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
801041c2:	a3 5c 3e 11 80       	mov    %eax,0x80113e5c
      release(&log.lock);
801041c7:	68 20 3e 11 80       	push   $0x80113e20
801041cc:	e8 2f 1a 00 00       	call   80105c00 <release>
      break;
    }
  }
}
801041d1:	83 c4 10             	add    $0x10,%esp
801041d4:	c9                   	leave  
801041d5:	c3                   	ret    
801041d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041dd:	8d 76 00             	lea    0x0(%esi),%esi

801041e0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
801041e0:	55                   	push   %ebp
801041e1:	89 e5                	mov    %esp,%ebp
801041e3:	57                   	push   %edi
801041e4:	56                   	push   %esi
801041e5:	53                   	push   %ebx
801041e6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
801041e9:	68 20 3e 11 80       	push   $0x80113e20
801041ee:	e8 6d 1a 00 00       	call   80105c60 <acquire>
  log.outstanding -= 1;
801041f3:	a1 5c 3e 11 80       	mov    0x80113e5c,%eax
  if(log.committing)
801041f8:	8b 35 60 3e 11 80    	mov    0x80113e60,%esi
801041fe:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80104201:	8d 58 ff             	lea    -0x1(%eax),%ebx
80104204:	89 1d 5c 3e 11 80    	mov    %ebx,0x80113e5c
  if(log.committing)
8010420a:	85 f6                	test   %esi,%esi
8010420c:	0f 85 22 01 00 00    	jne    80104334 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80104212:	85 db                	test   %ebx,%ebx
80104214:	0f 85 f6 00 00 00    	jne    80104310 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
8010421a:	c7 05 60 3e 11 80 01 	movl   $0x1,0x80113e60
80104221:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80104224:	83 ec 0c             	sub    $0xc,%esp
80104227:	68 20 3e 11 80       	push   $0x80113e20
8010422c:	e8 cf 19 00 00       	call   80105c00 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80104231:	8b 0d 68 3e 11 80    	mov    0x80113e68,%ecx
80104237:	83 c4 10             	add    $0x10,%esp
8010423a:	85 c9                	test   %ecx,%ecx
8010423c:	7f 42                	jg     80104280 <end_op+0xa0>
    acquire(&log.lock);
8010423e:	83 ec 0c             	sub    $0xc,%esp
80104241:	68 20 3e 11 80       	push   $0x80113e20
80104246:	e8 15 1a 00 00       	call   80105c60 <acquire>
    wakeup(&log);
8010424b:	c7 04 24 20 3e 11 80 	movl   $0x80113e20,(%esp)
    log.committing = 0;
80104252:	c7 05 60 3e 11 80 00 	movl   $0x0,0x80113e60
80104259:	00 00 00 
    wakeup(&log);
8010425c:	e8 cf 12 00 00       	call   80105530 <wakeup>
    release(&log.lock);
80104261:	c7 04 24 20 3e 11 80 	movl   $0x80113e20,(%esp)
80104268:	e8 93 19 00 00       	call   80105c00 <release>
8010426d:	83 c4 10             	add    $0x10,%esp
}
80104270:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104273:	5b                   	pop    %ebx
80104274:	5e                   	pop    %esi
80104275:	5f                   	pop    %edi
80104276:	5d                   	pop    %ebp
80104277:	c3                   	ret    
80104278:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010427f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80104280:	a1 54 3e 11 80       	mov    0x80113e54,%eax
80104285:	83 ec 08             	sub    $0x8,%esp
80104288:	01 d8                	add    %ebx,%eax
8010428a:	83 c0 01             	add    $0x1,%eax
8010428d:	50                   	push   %eax
8010428e:	ff 35 64 3e 11 80    	push   0x80113e64
80104294:	e8 37 be ff ff       	call   801000d0 <bread>
80104299:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010429b:	58                   	pop    %eax
8010429c:	5a                   	pop    %edx
8010429d:	ff 34 9d 6c 3e 11 80 	push   -0x7feec194(,%ebx,4)
801042a4:	ff 35 64 3e 11 80    	push   0x80113e64
  for (tail = 0; tail < log.lh.n; tail++) {
801042aa:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801042ad:	e8 1e be ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
801042b2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801042b5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
801042b7:	8d 40 5c             	lea    0x5c(%eax),%eax
801042ba:	68 00 02 00 00       	push   $0x200
801042bf:	50                   	push   %eax
801042c0:	8d 46 5c             	lea    0x5c(%esi),%eax
801042c3:	50                   	push   %eax
801042c4:	e8 f7 1a 00 00       	call   80105dc0 <memmove>
    bwrite(to);  // write the log
801042c9:	89 34 24             	mov    %esi,(%esp)
801042cc:	e8 df be ff ff       	call   801001b0 <bwrite>
    brelse(from);
801042d1:	89 3c 24             	mov    %edi,(%esp)
801042d4:	e8 17 bf ff ff       	call   801001f0 <brelse>
    brelse(to);
801042d9:	89 34 24             	mov    %esi,(%esp)
801042dc:	e8 0f bf ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801042e1:	83 c4 10             	add    $0x10,%esp
801042e4:	3b 1d 68 3e 11 80    	cmp    0x80113e68,%ebx
801042ea:	7c 94                	jl     80104280 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
801042ec:	e8 7f fd ff ff       	call   80104070 <write_head>
    install_trans(); // Now install writes to home locations
801042f1:	e8 da fc ff ff       	call   80103fd0 <install_trans>
    log.lh.n = 0;
801042f6:	c7 05 68 3e 11 80 00 	movl   $0x0,0x80113e68
801042fd:	00 00 00 
    write_head();    // Erase the transaction from the log
80104300:	e8 6b fd ff ff       	call   80104070 <write_head>
80104305:	e9 34 ff ff ff       	jmp    8010423e <end_op+0x5e>
8010430a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80104310:	83 ec 0c             	sub    $0xc,%esp
80104313:	68 20 3e 11 80       	push   $0x80113e20
80104318:	e8 13 12 00 00       	call   80105530 <wakeup>
  release(&log.lock);
8010431d:	c7 04 24 20 3e 11 80 	movl   $0x80113e20,(%esp)
80104324:	e8 d7 18 00 00       	call   80105c00 <release>
80104329:	83 c4 10             	add    $0x10,%esp
}
8010432c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010432f:	5b                   	pop    %ebx
80104330:	5e                   	pop    %esi
80104331:	5f                   	pop    %edi
80104332:	5d                   	pop    %ebp
80104333:	c3                   	ret    
    panic("log.committing");
80104334:	83 ec 0c             	sub    $0xc,%esp
80104337:	68 04 91 10 80       	push   $0x80109104
8010433c:	e8 3f c0 ff ff       	call   80100380 <panic>
80104341:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104348:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010434f:	90                   	nop

80104350 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80104350:	55                   	push   %ebp
80104351:	89 e5                	mov    %esp,%ebp
80104353:	53                   	push   %ebx
80104354:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80104357:	8b 15 68 3e 11 80    	mov    0x80113e68,%edx
{
8010435d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80104360:	83 fa 1d             	cmp    $0x1d,%edx
80104363:	0f 8f 85 00 00 00    	jg     801043ee <log_write+0x9e>
80104369:	a1 58 3e 11 80       	mov    0x80113e58,%eax
8010436e:	83 e8 01             	sub    $0x1,%eax
80104371:	39 c2                	cmp    %eax,%edx
80104373:	7d 79                	jge    801043ee <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80104375:	a1 5c 3e 11 80       	mov    0x80113e5c,%eax
8010437a:	85 c0                	test   %eax,%eax
8010437c:	7e 7d                	jle    801043fb <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010437e:	83 ec 0c             	sub    $0xc,%esp
80104381:	68 20 3e 11 80       	push   $0x80113e20
80104386:	e8 d5 18 00 00       	call   80105c60 <acquire>
  for (i = 0; i < log.lh.n; i++) {
8010438b:	8b 15 68 3e 11 80    	mov    0x80113e68,%edx
80104391:	83 c4 10             	add    $0x10,%esp
80104394:	85 d2                	test   %edx,%edx
80104396:	7e 4a                	jle    801043e2 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80104398:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
8010439b:	31 c0                	xor    %eax,%eax
8010439d:	eb 08                	jmp    801043a7 <log_write+0x57>
8010439f:	90                   	nop
801043a0:	83 c0 01             	add    $0x1,%eax
801043a3:	39 c2                	cmp    %eax,%edx
801043a5:	74 29                	je     801043d0 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801043a7:	39 0c 85 6c 3e 11 80 	cmp    %ecx,-0x7feec194(,%eax,4)
801043ae:	75 f0                	jne    801043a0 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
801043b0:	89 0c 85 6c 3e 11 80 	mov    %ecx,-0x7feec194(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
801043b7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
801043ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
801043bd:	c7 45 08 20 3e 11 80 	movl   $0x80113e20,0x8(%ebp)
}
801043c4:	c9                   	leave  
  release(&log.lock);
801043c5:	e9 36 18 00 00       	jmp    80105c00 <release>
801043ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
801043d0:	89 0c 95 6c 3e 11 80 	mov    %ecx,-0x7feec194(,%edx,4)
    log.lh.n++;
801043d7:	83 c2 01             	add    $0x1,%edx
801043da:	89 15 68 3e 11 80    	mov    %edx,0x80113e68
801043e0:	eb d5                	jmp    801043b7 <log_write+0x67>
  log.lh.block[i] = b->blockno;
801043e2:	8b 43 08             	mov    0x8(%ebx),%eax
801043e5:	a3 6c 3e 11 80       	mov    %eax,0x80113e6c
  if (i == log.lh.n)
801043ea:	75 cb                	jne    801043b7 <log_write+0x67>
801043ec:	eb e9                	jmp    801043d7 <log_write+0x87>
    panic("too big a transaction");
801043ee:	83 ec 0c             	sub    $0xc,%esp
801043f1:	68 13 91 10 80       	push   $0x80109113
801043f6:	e8 85 bf ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
801043fb:	83 ec 0c             	sub    $0xc,%esp
801043fe:	68 29 91 10 80       	push   $0x80109129
80104403:	e8 78 bf ff ff       	call   80100380 <panic>
80104408:	66 90                	xchg   %ax,%ax
8010440a:	66 90                	xchg   %ax,%ax
8010440c:	66 90                	xchg   %ax,%ax
8010440e:	66 90                	xchg   %ax,%ax

80104410 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80104410:	55                   	push   %ebp
80104411:	89 e5                	mov    %esp,%ebp
80104413:	53                   	push   %ebx
80104414:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80104417:	e8 64 09 00 00       	call   80104d80 <cpuid>
8010441c:	89 c3                	mov    %eax,%ebx
8010441e:	e8 5d 09 00 00       	call   80104d80 <cpuid>
80104423:	83 ec 04             	sub    $0x4,%esp
80104426:	53                   	push   %ebx
80104427:	50                   	push   %eax
80104428:	68 44 91 10 80       	push   $0x80109144
8010442d:	e8 ce c2 ff ff       	call   80100700 <cprintf>
  idtinit();       // load idt register
80104432:	e8 09 2f 00 00       	call   80107340 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80104437:	e8 e4 08 00 00       	call   80104d20 <mycpu>
8010443c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010443e:	b8 01 00 00 00       	mov    $0x1,%eax
80104443:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010444a:	e8 11 0c 00 00       	call   80105060 <scheduler>
8010444f:	90                   	nop

80104450 <mpenter>:
{
80104450:	55                   	push   %ebp
80104451:	89 e5                	mov    %esp,%ebp
80104453:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80104456:	e8 d5 3f 00 00       	call   80108430 <switchkvm>
  seginit();
8010445b:	e8 40 3f 00 00       	call   801083a0 <seginit>
  lapicinit();
80104460:	e8 9b f7 ff ff       	call   80103c00 <lapicinit>
  mpmain();
80104465:	e8 a6 ff ff ff       	call   80104410 <mpmain>
8010446a:	66 90                	xchg   %ax,%ax
8010446c:	66 90                	xchg   %ax,%ax
8010446e:	66 90                	xchg   %ax,%ax

80104470 <main>:
{
80104470:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80104474:	83 e4 f0             	and    $0xfffffff0,%esp
80104477:	ff 71 fc             	push   -0x4(%ecx)
8010447a:	55                   	push   %ebp
8010447b:	89 e5                	mov    %esp,%ebp
8010447d:	53                   	push   %ebx
8010447e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010447f:	83 ec 08             	sub    $0x8,%esp
80104482:	68 00 00 40 80       	push   $0x80400000
80104487:	68 50 97 11 80       	push   $0x80119750
8010448c:	e8 8f f5 ff ff       	call   80103a20 <kinit1>
  kvmalloc();      // kernel page table
80104491:	e8 8a 44 00 00       	call   80108920 <kvmalloc>
  mpinit();        // detect other processors
80104496:	e8 85 01 00 00       	call   80104620 <mpinit>
  lapicinit();     // interrupt controller
8010449b:	e8 60 f7 ff ff       	call   80103c00 <lapicinit>
  seginit();       // segment descriptors
801044a0:	e8 fb 3e 00 00       	call   801083a0 <seginit>
  picinit();       // disable pic
801044a5:	e8 76 03 00 00       	call   80104820 <picinit>
  ioapicinit();    // another interrupt controller
801044aa:	e8 31 f3 ff ff       	call   801037e0 <ioapicinit>
  consoleinit();   // console hardware
801044af:	e8 9c d9 ff ff       	call   80101e50 <consoleinit>
  uartinit();      // serial port
801044b4:	e8 77 31 00 00       	call   80107630 <uartinit>
  pinit();         // process table
801044b9:	e8 42 08 00 00       	call   80104d00 <pinit>
  tvinit();        // trap vectors
801044be:	e8 fd 2d 00 00       	call   801072c0 <tvinit>
  binit();         // buffer cache
801044c3:	e8 78 bb ff ff       	call   80100040 <binit>
  fileinit();      // file table
801044c8:	e8 53 dd ff ff       	call   80102220 <fileinit>
  ideinit();       // disk 
801044cd:	e8 fe f0 ff ff       	call   801035d0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801044d2:	83 c4 0c             	add    $0xc,%esp
801044d5:	68 8a 00 00 00       	push   $0x8a
801044da:	68 8c c4 10 80       	push   $0x8010c48c
801044df:	68 00 70 00 80       	push   $0x80007000
801044e4:	e8 d7 18 00 00       	call   80105dc0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801044e9:	83 c4 10             	add    $0x10,%esp
801044ec:	69 05 04 3f 11 80 b0 	imul   $0xb0,0x80113f04,%eax
801044f3:	00 00 00 
801044f6:	05 20 3f 11 80       	add    $0x80113f20,%eax
801044fb:	3d 20 3f 11 80       	cmp    $0x80113f20,%eax
80104500:	76 7e                	jbe    80104580 <main+0x110>
80104502:	bb 20 3f 11 80       	mov    $0x80113f20,%ebx
80104507:	eb 20                	jmp    80104529 <main+0xb9>
80104509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104510:	69 05 04 3f 11 80 b0 	imul   $0xb0,0x80113f04,%eax
80104517:	00 00 00 
8010451a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80104520:	05 20 3f 11 80       	add    $0x80113f20,%eax
80104525:	39 c3                	cmp    %eax,%ebx
80104527:	73 57                	jae    80104580 <main+0x110>
    if(c == mycpu())  // We've started already.
80104529:	e8 f2 07 00 00       	call   80104d20 <mycpu>
8010452e:	39 c3                	cmp    %eax,%ebx
80104530:	74 de                	je     80104510 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80104532:	e8 59 f5 ff ff       	call   80103a90 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80104537:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010453a:	c7 05 f8 6f 00 80 50 	movl   $0x80104450,0x80006ff8
80104541:	44 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80104544:	c7 05 f4 6f 00 80 00 	movl   $0x10b000,0x80006ff4
8010454b:	b0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010454e:	05 00 10 00 00       	add    $0x1000,%eax
80104553:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80104558:	0f b6 03             	movzbl (%ebx),%eax
8010455b:	68 00 70 00 00       	push   $0x7000
80104560:	50                   	push   %eax
80104561:	e8 ea f7 ff ff       	call   80103d50 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80104566:	83 c4 10             	add    $0x10,%esp
80104569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104570:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80104576:	85 c0                	test   %eax,%eax
80104578:	74 f6                	je     80104570 <main+0x100>
8010457a:	eb 94                	jmp    80104510 <main+0xa0>
8010457c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80104580:	83 ec 08             	sub    $0x8,%esp
80104583:	68 00 00 00 8e       	push   $0x8e000000
80104588:	68 00 00 40 80       	push   $0x80400000
8010458d:	e8 2e f4 ff ff       	call   801039c0 <kinit2>
  userinit();      // first user process
80104592:	e8 39 08 00 00       	call   80104dd0 <userinit>
  mpmain();        // finish this processor's setup
80104597:	e8 74 fe ff ff       	call   80104410 <mpmain>
8010459c:	66 90                	xchg   %ax,%ax
8010459e:	66 90                	xchg   %ax,%ax

801045a0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801045a0:	55                   	push   %ebp
801045a1:	89 e5                	mov    %esp,%ebp
801045a3:	57                   	push   %edi
801045a4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801045a5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801045ab:	53                   	push   %ebx
  e = addr+len;
801045ac:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801045af:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801045b2:	39 de                	cmp    %ebx,%esi
801045b4:	72 10                	jb     801045c6 <mpsearch1+0x26>
801045b6:	eb 50                	jmp    80104608 <mpsearch1+0x68>
801045b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045bf:	90                   	nop
801045c0:	89 fe                	mov    %edi,%esi
801045c2:	39 fb                	cmp    %edi,%ebx
801045c4:	76 42                	jbe    80104608 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801045c6:	83 ec 04             	sub    $0x4,%esp
801045c9:	8d 7e 10             	lea    0x10(%esi),%edi
801045cc:	6a 04                	push   $0x4
801045ce:	68 58 91 10 80       	push   $0x80109158
801045d3:	56                   	push   %esi
801045d4:	e8 97 17 00 00       	call   80105d70 <memcmp>
801045d9:	83 c4 10             	add    $0x10,%esp
801045dc:	85 c0                	test   %eax,%eax
801045de:	75 e0                	jne    801045c0 <mpsearch1+0x20>
801045e0:	89 f2                	mov    %esi,%edx
801045e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801045e8:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801045eb:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801045ee:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801045f0:	39 fa                	cmp    %edi,%edx
801045f2:	75 f4                	jne    801045e8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801045f4:	84 c0                	test   %al,%al
801045f6:	75 c8                	jne    801045c0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801045f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801045fb:	89 f0                	mov    %esi,%eax
801045fd:	5b                   	pop    %ebx
801045fe:	5e                   	pop    %esi
801045ff:	5f                   	pop    %edi
80104600:	5d                   	pop    %ebp
80104601:	c3                   	ret    
80104602:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104608:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010460b:	31 f6                	xor    %esi,%esi
}
8010460d:	5b                   	pop    %ebx
8010460e:	89 f0                	mov    %esi,%eax
80104610:	5e                   	pop    %esi
80104611:	5f                   	pop    %edi
80104612:	5d                   	pop    %ebp
80104613:	c3                   	ret    
80104614:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010461b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010461f:	90                   	nop

80104620 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80104620:	55                   	push   %ebp
80104621:	89 e5                	mov    %esp,%ebp
80104623:	57                   	push   %edi
80104624:	56                   	push   %esi
80104625:	53                   	push   %ebx
80104626:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80104629:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80104630:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80104637:	c1 e0 08             	shl    $0x8,%eax
8010463a:	09 d0                	or     %edx,%eax
8010463c:	c1 e0 04             	shl    $0x4,%eax
8010463f:	75 1b                	jne    8010465c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80104641:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80104648:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010464f:	c1 e0 08             	shl    $0x8,%eax
80104652:	09 d0                	or     %edx,%eax
80104654:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80104657:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010465c:	ba 00 04 00 00       	mov    $0x400,%edx
80104661:	e8 3a ff ff ff       	call   801045a0 <mpsearch1>
80104666:	89 c3                	mov    %eax,%ebx
80104668:	85 c0                	test   %eax,%eax
8010466a:	0f 84 40 01 00 00    	je     801047b0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80104670:	8b 73 04             	mov    0x4(%ebx),%esi
80104673:	85 f6                	test   %esi,%esi
80104675:	0f 84 25 01 00 00    	je     801047a0 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
8010467b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010467e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80104684:	6a 04                	push   $0x4
80104686:	68 5d 91 10 80       	push   $0x8010915d
8010468b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010468c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010468f:	e8 dc 16 00 00       	call   80105d70 <memcmp>
80104694:	83 c4 10             	add    $0x10,%esp
80104697:	85 c0                	test   %eax,%eax
80104699:	0f 85 01 01 00 00    	jne    801047a0 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
8010469f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
801046a6:	3c 01                	cmp    $0x1,%al
801046a8:	74 08                	je     801046b2 <mpinit+0x92>
801046aa:	3c 04                	cmp    $0x4,%al
801046ac:	0f 85 ee 00 00 00    	jne    801047a0 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
801046b2:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
801046b9:	66 85 d2             	test   %dx,%dx
801046bc:	74 22                	je     801046e0 <mpinit+0xc0>
801046be:	8d 3c 32             	lea    (%edx,%esi,1),%edi
801046c1:	89 f0                	mov    %esi,%eax
  sum = 0;
801046c3:	31 d2                	xor    %edx,%edx
801046c5:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801046c8:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
801046cf:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801046d2:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801046d4:	39 c7                	cmp    %eax,%edi
801046d6:	75 f0                	jne    801046c8 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
801046d8:	84 d2                	test   %dl,%dl
801046da:	0f 85 c0 00 00 00    	jne    801047a0 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801046e0:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
801046e6:	a3 00 3e 11 80       	mov    %eax,0x80113e00
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801046eb:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801046f2:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
801046f8:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801046fd:	03 55 e4             	add    -0x1c(%ebp),%edx
80104700:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80104703:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104707:	90                   	nop
80104708:	39 d0                	cmp    %edx,%eax
8010470a:	73 15                	jae    80104721 <mpinit+0x101>
    switch(*p){
8010470c:	0f b6 08             	movzbl (%eax),%ecx
8010470f:	80 f9 02             	cmp    $0x2,%cl
80104712:	74 4c                	je     80104760 <mpinit+0x140>
80104714:	77 3a                	ja     80104750 <mpinit+0x130>
80104716:	84 c9                	test   %cl,%cl
80104718:	74 56                	je     80104770 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
8010471a:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010471d:	39 d0                	cmp    %edx,%eax
8010471f:	72 eb                	jb     8010470c <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80104721:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80104724:	85 f6                	test   %esi,%esi
80104726:	0f 84 d9 00 00 00    	je     80104805 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010472c:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80104730:	74 15                	je     80104747 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80104732:	b8 70 00 00 00       	mov    $0x70,%eax
80104737:	ba 22 00 00 00       	mov    $0x22,%edx
8010473c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010473d:	ba 23 00 00 00       	mov    $0x23,%edx
80104742:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80104743:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80104746:	ee                   	out    %al,(%dx)
  }
}
80104747:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010474a:	5b                   	pop    %ebx
8010474b:	5e                   	pop    %esi
8010474c:	5f                   	pop    %edi
8010474d:	5d                   	pop    %ebp
8010474e:	c3                   	ret    
8010474f:	90                   	nop
    switch(*p){
80104750:	83 e9 03             	sub    $0x3,%ecx
80104753:	80 f9 01             	cmp    $0x1,%cl
80104756:	76 c2                	jbe    8010471a <mpinit+0xfa>
80104758:	31 f6                	xor    %esi,%esi
8010475a:	eb ac                	jmp    80104708 <mpinit+0xe8>
8010475c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80104760:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80104764:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80104767:	88 0d 00 3f 11 80    	mov    %cl,0x80113f00
      continue;
8010476d:	eb 99                	jmp    80104708 <mpinit+0xe8>
8010476f:	90                   	nop
      if(ncpu < NCPU) {
80104770:	8b 0d 04 3f 11 80    	mov    0x80113f04,%ecx
80104776:	83 f9 07             	cmp    $0x7,%ecx
80104779:	7f 19                	jg     80104794 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010477b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80104781:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80104785:	83 c1 01             	add    $0x1,%ecx
80104788:	89 0d 04 3f 11 80    	mov    %ecx,0x80113f04
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010478e:	88 9f 20 3f 11 80    	mov    %bl,-0x7feec0e0(%edi)
      p += sizeof(struct mpproc);
80104794:	83 c0 14             	add    $0x14,%eax
      continue;
80104797:	e9 6c ff ff ff       	jmp    80104708 <mpinit+0xe8>
8010479c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801047a0:	83 ec 0c             	sub    $0xc,%esp
801047a3:	68 62 91 10 80       	push   $0x80109162
801047a8:	e8 d3 bb ff ff       	call   80100380 <panic>
801047ad:	8d 76 00             	lea    0x0(%esi),%esi
{
801047b0:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
801047b5:	eb 13                	jmp    801047ca <mpinit+0x1aa>
801047b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047be:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
801047c0:	89 f3                	mov    %esi,%ebx
801047c2:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
801047c8:	74 d6                	je     801047a0 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801047ca:	83 ec 04             	sub    $0x4,%esp
801047cd:	8d 73 10             	lea    0x10(%ebx),%esi
801047d0:	6a 04                	push   $0x4
801047d2:	68 58 91 10 80       	push   $0x80109158
801047d7:	53                   	push   %ebx
801047d8:	e8 93 15 00 00       	call   80105d70 <memcmp>
801047dd:	83 c4 10             	add    $0x10,%esp
801047e0:	85 c0                	test   %eax,%eax
801047e2:	75 dc                	jne    801047c0 <mpinit+0x1a0>
801047e4:	89 da                	mov    %ebx,%edx
801047e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047ed:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801047f0:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801047f3:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801047f6:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801047f8:	39 d6                	cmp    %edx,%esi
801047fa:	75 f4                	jne    801047f0 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801047fc:	84 c0                	test   %al,%al
801047fe:	75 c0                	jne    801047c0 <mpinit+0x1a0>
80104800:	e9 6b fe ff ff       	jmp    80104670 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80104805:	83 ec 0c             	sub    $0xc,%esp
80104808:	68 7c 91 10 80       	push   $0x8010917c
8010480d:	e8 6e bb ff ff       	call   80100380 <panic>
80104812:	66 90                	xchg   %ax,%ax
80104814:	66 90                	xchg   %ax,%ax
80104816:	66 90                	xchg   %ax,%ax
80104818:	66 90                	xchg   %ax,%ax
8010481a:	66 90                	xchg   %ax,%ax
8010481c:	66 90                	xchg   %ax,%ax
8010481e:	66 90                	xchg   %ax,%ax

80104820 <picinit>:
80104820:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104825:	ba 21 00 00 00       	mov    $0x21,%edx
8010482a:	ee                   	out    %al,(%dx)
8010482b:	ba a1 00 00 00       	mov    $0xa1,%edx
80104830:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80104831:	c3                   	ret    
80104832:	66 90                	xchg   %ax,%ax
80104834:	66 90                	xchg   %ax,%ax
80104836:	66 90                	xchg   %ax,%ax
80104838:	66 90                	xchg   %ax,%ax
8010483a:	66 90                	xchg   %ax,%ax
8010483c:	66 90                	xchg   %ax,%ax
8010483e:	66 90                	xchg   %ax,%ax

80104840 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80104840:	55                   	push   %ebp
80104841:	89 e5                	mov    %esp,%ebp
80104843:	57                   	push   %edi
80104844:	56                   	push   %esi
80104845:	53                   	push   %ebx
80104846:	83 ec 0c             	sub    $0xc,%esp
80104849:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010484c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010484f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80104855:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010485b:	e8 e0 d9 ff ff       	call   80102240 <filealloc>
80104860:	89 03                	mov    %eax,(%ebx)
80104862:	85 c0                	test   %eax,%eax
80104864:	0f 84 a8 00 00 00    	je     80104912 <pipealloc+0xd2>
8010486a:	e8 d1 d9 ff ff       	call   80102240 <filealloc>
8010486f:	89 06                	mov    %eax,(%esi)
80104871:	85 c0                	test   %eax,%eax
80104873:	0f 84 87 00 00 00    	je     80104900 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80104879:	e8 12 f2 ff ff       	call   80103a90 <kalloc>
8010487e:	89 c7                	mov    %eax,%edi
80104880:	85 c0                	test   %eax,%eax
80104882:	0f 84 b0 00 00 00    	je     80104938 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80104888:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010488f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80104892:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80104895:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010489c:	00 00 00 
  p->nwrite = 0;
8010489f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801048a6:	00 00 00 
  p->nread = 0;
801048a9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801048b0:	00 00 00 
  initlock(&p->lock, "pipe");
801048b3:	68 9b 91 10 80       	push   $0x8010919b
801048b8:	50                   	push   %eax
801048b9:	e8 d2 11 00 00       	call   80105a90 <initlock>
  (*f0)->type = FD_PIPE;
801048be:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801048c0:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801048c3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801048c9:	8b 03                	mov    (%ebx),%eax
801048cb:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801048cf:	8b 03                	mov    (%ebx),%eax
801048d1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801048d5:	8b 03                	mov    (%ebx),%eax
801048d7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801048da:	8b 06                	mov    (%esi),%eax
801048dc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801048e2:	8b 06                	mov    (%esi),%eax
801048e4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801048e8:	8b 06                	mov    (%esi),%eax
801048ea:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801048ee:	8b 06                	mov    (%esi),%eax
801048f0:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801048f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801048f6:	31 c0                	xor    %eax,%eax
}
801048f8:	5b                   	pop    %ebx
801048f9:	5e                   	pop    %esi
801048fa:	5f                   	pop    %edi
801048fb:	5d                   	pop    %ebp
801048fc:	c3                   	ret    
801048fd:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
80104900:	8b 03                	mov    (%ebx),%eax
80104902:	85 c0                	test   %eax,%eax
80104904:	74 1e                	je     80104924 <pipealloc+0xe4>
    fileclose(*f0);
80104906:	83 ec 0c             	sub    $0xc,%esp
80104909:	50                   	push   %eax
8010490a:	e8 f1 d9 ff ff       	call   80102300 <fileclose>
8010490f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80104912:	8b 06                	mov    (%esi),%eax
80104914:	85 c0                	test   %eax,%eax
80104916:	74 0c                	je     80104924 <pipealloc+0xe4>
    fileclose(*f1);
80104918:	83 ec 0c             	sub    $0xc,%esp
8010491b:	50                   	push   %eax
8010491c:	e8 df d9 ff ff       	call   80102300 <fileclose>
80104921:	83 c4 10             	add    $0x10,%esp
}
80104924:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80104927:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010492c:	5b                   	pop    %ebx
8010492d:	5e                   	pop    %esi
8010492e:	5f                   	pop    %edi
8010492f:	5d                   	pop    %ebp
80104930:	c3                   	ret    
80104931:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80104938:	8b 03                	mov    (%ebx),%eax
8010493a:	85 c0                	test   %eax,%eax
8010493c:	75 c8                	jne    80104906 <pipealloc+0xc6>
8010493e:	eb d2                	jmp    80104912 <pipealloc+0xd2>

80104940 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80104940:	55                   	push   %ebp
80104941:	89 e5                	mov    %esp,%ebp
80104943:	56                   	push   %esi
80104944:	53                   	push   %ebx
80104945:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104948:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010494b:	83 ec 0c             	sub    $0xc,%esp
8010494e:	53                   	push   %ebx
8010494f:	e8 0c 13 00 00       	call   80105c60 <acquire>
  if(writable){
80104954:	83 c4 10             	add    $0x10,%esp
80104957:	85 f6                	test   %esi,%esi
80104959:	74 65                	je     801049c0 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010495b:	83 ec 0c             	sub    $0xc,%esp
8010495e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80104964:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010496b:	00 00 00 
    wakeup(&p->nread);
8010496e:	50                   	push   %eax
8010496f:	e8 bc 0b 00 00       	call   80105530 <wakeup>
80104974:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80104977:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010497d:	85 d2                	test   %edx,%edx
8010497f:	75 0a                	jne    8010498b <pipeclose+0x4b>
80104981:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80104987:	85 c0                	test   %eax,%eax
80104989:	74 15                	je     801049a0 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010498b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010498e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104991:	5b                   	pop    %ebx
80104992:	5e                   	pop    %esi
80104993:	5d                   	pop    %ebp
    release(&p->lock);
80104994:	e9 67 12 00 00       	jmp    80105c00 <release>
80104999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
801049a0:	83 ec 0c             	sub    $0xc,%esp
801049a3:	53                   	push   %ebx
801049a4:	e8 57 12 00 00       	call   80105c00 <release>
    kfree((char*)p);
801049a9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801049ac:	83 c4 10             	add    $0x10,%esp
}
801049af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801049b2:	5b                   	pop    %ebx
801049b3:	5e                   	pop    %esi
801049b4:	5d                   	pop    %ebp
    kfree((char*)p);
801049b5:	e9 16 ef ff ff       	jmp    801038d0 <kfree>
801049ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801049c0:	83 ec 0c             	sub    $0xc,%esp
801049c3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801049c9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801049d0:	00 00 00 
    wakeup(&p->nwrite);
801049d3:	50                   	push   %eax
801049d4:	e8 57 0b 00 00       	call   80105530 <wakeup>
801049d9:	83 c4 10             	add    $0x10,%esp
801049dc:	eb 99                	jmp    80104977 <pipeclose+0x37>
801049de:	66 90                	xchg   %ax,%ax

801049e0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801049e0:	55                   	push   %ebp
801049e1:	89 e5                	mov    %esp,%ebp
801049e3:	57                   	push   %edi
801049e4:	56                   	push   %esi
801049e5:	53                   	push   %ebx
801049e6:	83 ec 28             	sub    $0x28,%esp
801049e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801049ec:	53                   	push   %ebx
801049ed:	e8 6e 12 00 00       	call   80105c60 <acquire>
  for(i = 0; i < n; i++){
801049f2:	8b 45 10             	mov    0x10(%ebp),%eax
801049f5:	83 c4 10             	add    $0x10,%esp
801049f8:	85 c0                	test   %eax,%eax
801049fa:	0f 8e c0 00 00 00    	jle    80104ac0 <pipewrite+0xe0>
80104a00:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104a03:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80104a09:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80104a0f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104a12:	03 45 10             	add    0x10(%ebp),%eax
80104a15:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104a18:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80104a1e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104a24:	89 ca                	mov    %ecx,%edx
80104a26:	05 00 02 00 00       	add    $0x200,%eax
80104a2b:	39 c1                	cmp    %eax,%ecx
80104a2d:	74 3f                	je     80104a6e <pipewrite+0x8e>
80104a2f:	eb 67                	jmp    80104a98 <pipewrite+0xb8>
80104a31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80104a38:	e8 63 03 00 00       	call   80104da0 <myproc>
80104a3d:	8b 48 24             	mov    0x24(%eax),%ecx
80104a40:	85 c9                	test   %ecx,%ecx
80104a42:	75 34                	jne    80104a78 <pipewrite+0x98>
      wakeup(&p->nread);
80104a44:	83 ec 0c             	sub    $0xc,%esp
80104a47:	57                   	push   %edi
80104a48:	e8 e3 0a 00 00       	call   80105530 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80104a4d:	58                   	pop    %eax
80104a4e:	5a                   	pop    %edx
80104a4f:	53                   	push   %ebx
80104a50:	56                   	push   %esi
80104a51:	e8 1a 0a 00 00       	call   80105470 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104a56:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80104a5c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80104a62:	83 c4 10             	add    $0x10,%esp
80104a65:	05 00 02 00 00       	add    $0x200,%eax
80104a6a:	39 c2                	cmp    %eax,%edx
80104a6c:	75 2a                	jne    80104a98 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
80104a6e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80104a74:	85 c0                	test   %eax,%eax
80104a76:	75 c0                	jne    80104a38 <pipewrite+0x58>
        release(&p->lock);
80104a78:	83 ec 0c             	sub    $0xc,%esp
80104a7b:	53                   	push   %ebx
80104a7c:	e8 7f 11 00 00       	call   80105c00 <release>
        return -1;
80104a81:	83 c4 10             	add    $0x10,%esp
80104a84:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80104a89:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a8c:	5b                   	pop    %ebx
80104a8d:	5e                   	pop    %esi
80104a8e:	5f                   	pop    %edi
80104a8f:	5d                   	pop    %ebp
80104a90:	c3                   	ret    
80104a91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80104a98:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80104a9b:	8d 4a 01             	lea    0x1(%edx),%ecx
80104a9e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80104aa4:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
80104aaa:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
80104aad:	83 c6 01             	add    $0x1,%esi
80104ab0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80104ab3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80104ab7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80104aba:	0f 85 58 ff ff ff    	jne    80104a18 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80104ac0:	83 ec 0c             	sub    $0xc,%esp
80104ac3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80104ac9:	50                   	push   %eax
80104aca:	e8 61 0a 00 00       	call   80105530 <wakeup>
  release(&p->lock);
80104acf:	89 1c 24             	mov    %ebx,(%esp)
80104ad2:	e8 29 11 00 00       	call   80105c00 <release>
  return n;
80104ad7:	8b 45 10             	mov    0x10(%ebp),%eax
80104ada:	83 c4 10             	add    $0x10,%esp
80104add:	eb aa                	jmp    80104a89 <pipewrite+0xa9>
80104adf:	90                   	nop

80104ae0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80104ae0:	55                   	push   %ebp
80104ae1:	89 e5                	mov    %esp,%ebp
80104ae3:	57                   	push   %edi
80104ae4:	56                   	push   %esi
80104ae5:	53                   	push   %ebx
80104ae6:	83 ec 18             	sub    $0x18,%esp
80104ae9:	8b 75 08             	mov    0x8(%ebp),%esi
80104aec:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80104aef:	56                   	push   %esi
80104af0:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80104af6:	e8 65 11 00 00       	call   80105c60 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104afb:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80104b01:	83 c4 10             	add    $0x10,%esp
80104b04:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
80104b0a:	74 2f                	je     80104b3b <piperead+0x5b>
80104b0c:	eb 37                	jmp    80104b45 <piperead+0x65>
80104b0e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80104b10:	e8 8b 02 00 00       	call   80104da0 <myproc>
80104b15:	8b 48 24             	mov    0x24(%eax),%ecx
80104b18:	85 c9                	test   %ecx,%ecx
80104b1a:	0f 85 80 00 00 00    	jne    80104ba0 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80104b20:	83 ec 08             	sub    $0x8,%esp
80104b23:	56                   	push   %esi
80104b24:	53                   	push   %ebx
80104b25:	e8 46 09 00 00       	call   80105470 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104b2a:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80104b30:	83 c4 10             	add    $0x10,%esp
80104b33:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80104b39:	75 0a                	jne    80104b45 <piperead+0x65>
80104b3b:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80104b41:	85 c0                	test   %eax,%eax
80104b43:	75 cb                	jne    80104b10 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104b45:	8b 55 10             	mov    0x10(%ebp),%edx
80104b48:	31 db                	xor    %ebx,%ebx
80104b4a:	85 d2                	test   %edx,%edx
80104b4c:	7f 20                	jg     80104b6e <piperead+0x8e>
80104b4e:	eb 2c                	jmp    80104b7c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80104b50:	8d 48 01             	lea    0x1(%eax),%ecx
80104b53:	25 ff 01 00 00       	and    $0x1ff,%eax
80104b58:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
80104b5e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80104b63:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104b66:	83 c3 01             	add    $0x1,%ebx
80104b69:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80104b6c:	74 0e                	je     80104b7c <piperead+0x9c>
    if(p->nread == p->nwrite)
80104b6e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80104b74:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80104b7a:	75 d4                	jne    80104b50 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80104b7c:	83 ec 0c             	sub    $0xc,%esp
80104b7f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80104b85:	50                   	push   %eax
80104b86:	e8 a5 09 00 00       	call   80105530 <wakeup>
  release(&p->lock);
80104b8b:	89 34 24             	mov    %esi,(%esp)
80104b8e:	e8 6d 10 00 00       	call   80105c00 <release>
  return i;
80104b93:	83 c4 10             	add    $0x10,%esp
}
80104b96:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b99:	89 d8                	mov    %ebx,%eax
80104b9b:	5b                   	pop    %ebx
80104b9c:	5e                   	pop    %esi
80104b9d:	5f                   	pop    %edi
80104b9e:	5d                   	pop    %ebp
80104b9f:	c3                   	ret    
      release(&p->lock);
80104ba0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104ba3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80104ba8:	56                   	push   %esi
80104ba9:	e8 52 10 00 00       	call   80105c00 <release>
      return -1;
80104bae:	83 c4 10             	add    $0x10,%esp
}
80104bb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104bb4:	89 d8                	mov    %ebx,%eax
80104bb6:	5b                   	pop    %ebx
80104bb7:	5e                   	pop    %esi
80104bb8:	5f                   	pop    %edi
80104bb9:	5d                   	pop    %ebp
80104bba:	c3                   	ret    
80104bbb:	66 90                	xchg   %ax,%ax
80104bbd:	66 90                	xchg   %ax,%ax
80104bbf:	90                   	nop

80104bc0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80104bc0:	55                   	push   %ebp
80104bc1:	89 e5                	mov    %esp,%ebp
80104bc3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104bc4:	bb d4 44 11 80       	mov    $0x801144d4,%ebx
{
80104bc9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80104bcc:	68 a0 44 11 80       	push   $0x801144a0
80104bd1:	e8 8a 10 00 00       	call   80105c60 <acquire>
80104bd6:	83 c4 10             	add    $0x10,%esp
80104bd9:	eb 17                	jmp    80104bf2 <allocproc+0x32>
80104bdb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104bdf:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104be0:	81 c3 e8 00 00 00    	add    $0xe8,%ebx
80104be6:	81 fb d4 7e 11 80    	cmp    $0x80117ed4,%ebx
80104bec:	0f 84 8e 00 00 00    	je     80104c80 <allocproc+0xc0>
    if(p->state == UNUSED)
80104bf2:	8b 43 0c             	mov    0xc(%ebx),%eax
80104bf5:	85 c0                	test   %eax,%eax
80104bf7:	75 e7                	jne    80104be0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80104bf9:	a1 04 c0 10 80       	mov    0x8010c004,%eax

  release(&ptable.lock);
80104bfe:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80104c01:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80104c08:	89 43 10             	mov    %eax,0x10(%ebx)
80104c0b:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80104c0e:	68 a0 44 11 80       	push   $0x801144a0
  p->pid = nextpid++;
80104c13:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
  release(&ptable.lock);
80104c19:	e8 e2 0f 00 00       	call   80105c00 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80104c1e:	e8 6d ee ff ff       	call   80103a90 <kalloc>
80104c23:	83 c4 10             	add    $0x10,%esp
80104c26:	89 43 08             	mov    %eax,0x8(%ebx)
80104c29:	85 c0                	test   %eax,%eax
80104c2b:	74 6c                	je     80104c99 <allocproc+0xd9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80104c2d:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80104c33:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80104c36:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80104c3b:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80104c3e:	c7 40 14 b2 72 10 80 	movl   $0x801072b2,0x14(%eax)
  p->context = (struct context*)sp;
80104c45:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80104c48:	6a 14                	push   $0x14
80104c4a:	6a 00                	push   $0x0
80104c4c:	50                   	push   %eax
80104c4d:	e8 ce 10 00 00       	call   80105d20 <memset>
  p->context->eip = (uint)forkret;
80104c52:	8b 43 1c             	mov    0x1c(%ebx),%eax
  p->syscall_count = 0;
  memset(p->syscall_history, 0, sizeof(p->syscall_history));
80104c55:	83 c4 0c             	add    $0xc,%esp
  p->context->eip = (uint)forkret;
80104c58:	c7 40 10 b0 4c 10 80 	movl   $0x80104cb0,0x10(%eax)
  memset(p->syscall_history, 0, sizeof(p->syscall_history));
80104c5f:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
  p->syscall_count = 0;
80104c65:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
  memset(p->syscall_history, 0, sizeof(p->syscall_history));
80104c6c:	6a 68                	push   $0x68
80104c6e:	6a 00                	push   $0x0
80104c70:	50                   	push   %eax
80104c71:	e8 aa 10 00 00       	call   80105d20 <memset>
  return p;
}
80104c76:	89 d8                	mov    %ebx,%eax
  return p;
80104c78:	83 c4 10             	add    $0x10,%esp
}
80104c7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c7e:	c9                   	leave  
80104c7f:	c3                   	ret    
  release(&ptable.lock);
80104c80:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80104c83:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80104c85:	68 a0 44 11 80       	push   $0x801144a0
80104c8a:	e8 71 0f 00 00       	call   80105c00 <release>
}
80104c8f:	89 d8                	mov    %ebx,%eax
  return 0;
80104c91:	83 c4 10             	add    $0x10,%esp
}
80104c94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c97:	c9                   	leave  
80104c98:	c3                   	ret    
    p->state = UNUSED;
80104c99:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80104ca0:	31 db                	xor    %ebx,%ebx
}
80104ca2:	89 d8                	mov    %ebx,%eax
80104ca4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ca7:	c9                   	leave  
80104ca8:	c3                   	ret    
80104ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104cb0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104cb0:	55                   	push   %ebp
80104cb1:	89 e5                	mov    %esp,%ebp
80104cb3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104cb6:	68 a0 44 11 80       	push   $0x801144a0
80104cbb:	e8 40 0f 00 00       	call   80105c00 <release>

  if (first) {
80104cc0:	a1 00 c0 10 80       	mov    0x8010c000,%eax
80104cc5:	83 c4 10             	add    $0x10,%esp
80104cc8:	85 c0                	test   %eax,%eax
80104cca:	75 04                	jne    80104cd0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80104ccc:	c9                   	leave  
80104ccd:	c3                   	ret    
80104cce:	66 90                	xchg   %ax,%ax
    first = 0;
80104cd0:	c7 05 00 c0 10 80 00 	movl   $0x0,0x8010c000
80104cd7:	00 00 00 
    iinit(ROOTDEV);
80104cda:	83 ec 0c             	sub    $0xc,%esp
80104cdd:	6a 01                	push   $0x1
80104cdf:	e8 8c dc ff ff       	call   80102970 <iinit>
    initlog(ROOTDEV);
80104ce4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104ceb:	e8 e0 f3 ff ff       	call   801040d0 <initlog>
}
80104cf0:	83 c4 10             	add    $0x10,%esp
80104cf3:	c9                   	leave  
80104cf4:	c3                   	ret    
80104cf5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104d00 <pinit>:
{
80104d00:	55                   	push   %ebp
80104d01:	89 e5                	mov    %esp,%ebp
80104d03:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80104d06:	68 a0 91 10 80       	push   $0x801091a0
80104d0b:	68 a0 44 11 80       	push   $0x801144a0
80104d10:	e8 7b 0d 00 00       	call   80105a90 <initlock>
}
80104d15:	83 c4 10             	add    $0x10,%esp
80104d18:	c9                   	leave  
80104d19:	c3                   	ret    
80104d1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104d20 <mycpu>:
{
80104d20:	55                   	push   %ebp
80104d21:	89 e5                	mov    %esp,%ebp
80104d23:	56                   	push   %esi
80104d24:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104d25:	9c                   	pushf  
80104d26:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104d27:	f6 c4 02             	test   $0x2,%ah
80104d2a:	75 46                	jne    80104d72 <mycpu+0x52>
  apicid = lapicid();
80104d2c:	e8 cf ef ff ff       	call   80103d00 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80104d31:	8b 35 04 3f 11 80    	mov    0x80113f04,%esi
80104d37:	85 f6                	test   %esi,%esi
80104d39:	7e 2a                	jle    80104d65 <mycpu+0x45>
80104d3b:	31 d2                	xor    %edx,%edx
80104d3d:	eb 08                	jmp    80104d47 <mycpu+0x27>
80104d3f:	90                   	nop
80104d40:	83 c2 01             	add    $0x1,%edx
80104d43:	39 f2                	cmp    %esi,%edx
80104d45:	74 1e                	je     80104d65 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80104d47:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80104d4d:	0f b6 99 20 3f 11 80 	movzbl -0x7feec0e0(%ecx),%ebx
80104d54:	39 c3                	cmp    %eax,%ebx
80104d56:	75 e8                	jne    80104d40 <mycpu+0x20>
}
80104d58:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80104d5b:	8d 81 20 3f 11 80    	lea    -0x7feec0e0(%ecx),%eax
}
80104d61:	5b                   	pop    %ebx
80104d62:	5e                   	pop    %esi
80104d63:	5d                   	pop    %ebp
80104d64:	c3                   	ret    
  panic("unknown apicid\n");
80104d65:	83 ec 0c             	sub    $0xc,%esp
80104d68:	68 a7 91 10 80       	push   $0x801091a7
80104d6d:	e8 0e b6 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80104d72:	83 ec 0c             	sub    $0xc,%esp
80104d75:	68 c8 92 10 80       	push   $0x801092c8
80104d7a:	e8 01 b6 ff ff       	call   80100380 <panic>
80104d7f:	90                   	nop

80104d80 <cpuid>:
cpuid() {
80104d80:	55                   	push   %ebp
80104d81:	89 e5                	mov    %esp,%ebp
80104d83:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80104d86:	e8 95 ff ff ff       	call   80104d20 <mycpu>
}
80104d8b:	c9                   	leave  
  return mycpu()-cpus;
80104d8c:	2d 20 3f 11 80       	sub    $0x80113f20,%eax
80104d91:	c1 f8 04             	sar    $0x4,%eax
80104d94:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80104d9a:	c3                   	ret    
80104d9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d9f:	90                   	nop

80104da0 <myproc>:
myproc(void) {
80104da0:	55                   	push   %ebp
80104da1:	89 e5                	mov    %esp,%ebp
80104da3:	53                   	push   %ebx
80104da4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80104da7:	e8 64 0d 00 00       	call   80105b10 <pushcli>
  c = mycpu();
80104dac:	e8 6f ff ff ff       	call   80104d20 <mycpu>
  p = c->proc;
80104db1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104db7:	e8 a4 0d 00 00       	call   80105b60 <popcli>
}
80104dbc:	89 d8                	mov    %ebx,%eax
80104dbe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104dc1:	c9                   	leave  
80104dc2:	c3                   	ret    
80104dc3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104dd0 <userinit>:
{
80104dd0:	55                   	push   %ebp
80104dd1:	89 e5                	mov    %esp,%ebp
80104dd3:	53                   	push   %ebx
80104dd4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80104dd7:	e8 e4 fd ff ff       	call   80104bc0 <allocproc>
80104ddc:	89 c3                	mov    %eax,%ebx
  initproc = p;
80104dde:	a3 d4 7e 11 80       	mov    %eax,0x80117ed4
  if((p->pgdir = setupkvm()) == 0)
80104de3:	e8 b8 3a 00 00       	call   801088a0 <setupkvm>
80104de8:	89 43 04             	mov    %eax,0x4(%ebx)
80104deb:	85 c0                	test   %eax,%eax
80104ded:	0f 84 bd 00 00 00    	je     80104eb0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104df3:	83 ec 04             	sub    $0x4,%esp
80104df6:	68 2c 00 00 00       	push   $0x2c
80104dfb:	68 60 c4 10 80       	push   $0x8010c460
80104e00:	50                   	push   %eax
80104e01:	e8 4a 37 00 00       	call   80108550 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80104e06:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80104e09:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80104e0f:	6a 4c                	push   $0x4c
80104e11:	6a 00                	push   $0x0
80104e13:	ff 73 18             	push   0x18(%ebx)
80104e16:	e8 05 0f 00 00       	call   80105d20 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104e1b:	8b 43 18             	mov    0x18(%ebx),%eax
80104e1e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80104e23:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104e26:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104e2b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104e2f:	8b 43 18             	mov    0x18(%ebx),%eax
80104e32:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104e36:	8b 43 18             	mov    0x18(%ebx),%eax
80104e39:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80104e3d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80104e41:	8b 43 18             	mov    0x18(%ebx),%eax
80104e44:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80104e48:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80104e4c:	8b 43 18             	mov    0x18(%ebx),%eax
80104e4f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80104e56:	8b 43 18             	mov    0x18(%ebx),%eax
80104e59:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104e60:	8b 43 18             	mov    0x18(%ebx),%eax
80104e63:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80104e6a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104e6d:	6a 10                	push   $0x10
80104e6f:	68 d0 91 10 80       	push   $0x801091d0
80104e74:	50                   	push   %eax
80104e75:	e8 66 10 00 00       	call   80105ee0 <safestrcpy>
  p->cwd = namei("/");
80104e7a:	c7 04 24 d9 91 10 80 	movl   $0x801091d9,(%esp)
80104e81:	e8 2a e6 ff ff       	call   801034b0 <namei>
80104e86:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80104e89:	c7 04 24 a0 44 11 80 	movl   $0x801144a0,(%esp)
80104e90:	e8 cb 0d 00 00       	call   80105c60 <acquire>
  p->state = RUNNABLE;
80104e95:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80104e9c:	c7 04 24 a0 44 11 80 	movl   $0x801144a0,(%esp)
80104ea3:	e8 58 0d 00 00       	call   80105c00 <release>
}
80104ea8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104eab:	83 c4 10             	add    $0x10,%esp
80104eae:	c9                   	leave  
80104eaf:	c3                   	ret    
    panic("userinit: out of memory?");
80104eb0:	83 ec 0c             	sub    $0xc,%esp
80104eb3:	68 b7 91 10 80       	push   $0x801091b7
80104eb8:	e8 c3 b4 ff ff       	call   80100380 <panic>
80104ebd:	8d 76 00             	lea    0x0(%esi),%esi

80104ec0 <growproc>:
{
80104ec0:	55                   	push   %ebp
80104ec1:	89 e5                	mov    %esp,%ebp
80104ec3:	56                   	push   %esi
80104ec4:	53                   	push   %ebx
80104ec5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80104ec8:	e8 43 0c 00 00       	call   80105b10 <pushcli>
  c = mycpu();
80104ecd:	e8 4e fe ff ff       	call   80104d20 <mycpu>
  p = c->proc;
80104ed2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104ed8:	e8 83 0c 00 00       	call   80105b60 <popcli>
  sz = curproc->sz;
80104edd:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80104edf:	85 f6                	test   %esi,%esi
80104ee1:	7f 1d                	jg     80104f00 <growproc+0x40>
  } else if(n < 0){
80104ee3:	75 3b                	jne    80104f20 <growproc+0x60>
  switchuvm(curproc);
80104ee5:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80104ee8:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80104eea:	53                   	push   %ebx
80104eeb:	e8 50 35 00 00       	call   80108440 <switchuvm>
  return 0;
80104ef0:	83 c4 10             	add    $0x10,%esp
80104ef3:	31 c0                	xor    %eax,%eax
}
80104ef5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ef8:	5b                   	pop    %ebx
80104ef9:	5e                   	pop    %esi
80104efa:	5d                   	pop    %ebp
80104efb:	c3                   	ret    
80104efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104f00:	83 ec 04             	sub    $0x4,%esp
80104f03:	01 c6                	add    %eax,%esi
80104f05:	56                   	push   %esi
80104f06:	50                   	push   %eax
80104f07:	ff 73 04             	push   0x4(%ebx)
80104f0a:	e8 b1 37 00 00       	call   801086c0 <allocuvm>
80104f0f:	83 c4 10             	add    $0x10,%esp
80104f12:	85 c0                	test   %eax,%eax
80104f14:	75 cf                	jne    80104ee5 <growproc+0x25>
      return -1;
80104f16:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f1b:	eb d8                	jmp    80104ef5 <growproc+0x35>
80104f1d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104f20:	83 ec 04             	sub    $0x4,%esp
80104f23:	01 c6                	add    %eax,%esi
80104f25:	56                   	push   %esi
80104f26:	50                   	push   %eax
80104f27:	ff 73 04             	push   0x4(%ebx)
80104f2a:	e8 c1 38 00 00       	call   801087f0 <deallocuvm>
80104f2f:	83 c4 10             	add    $0x10,%esp
80104f32:	85 c0                	test   %eax,%eax
80104f34:	75 af                	jne    80104ee5 <growproc+0x25>
80104f36:	eb de                	jmp    80104f16 <growproc+0x56>
80104f38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f3f:	90                   	nop

80104f40 <fork>:
{
80104f40:	55                   	push   %ebp
80104f41:	89 e5                	mov    %esp,%ebp
80104f43:	57                   	push   %edi
80104f44:	56                   	push   %esi
80104f45:	53                   	push   %ebx
80104f46:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80104f49:	e8 c2 0b 00 00       	call   80105b10 <pushcli>
  c = mycpu();
80104f4e:	e8 cd fd ff ff       	call   80104d20 <mycpu>
  p = c->proc;
80104f53:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104f59:	e8 02 0c 00 00       	call   80105b60 <popcli>
  if((np = allocproc()) == 0){
80104f5e:	e8 5d fc ff ff       	call   80104bc0 <allocproc>
80104f63:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104f66:	85 c0                	test   %eax,%eax
80104f68:	0f 84 b7 00 00 00    	je     80105025 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80104f6e:	83 ec 08             	sub    $0x8,%esp
80104f71:	ff 33                	push   (%ebx)
80104f73:	89 c7                	mov    %eax,%edi
80104f75:	ff 73 04             	push   0x4(%ebx)
80104f78:	e8 13 3a 00 00       	call   80108990 <copyuvm>
80104f7d:	83 c4 10             	add    $0x10,%esp
80104f80:	89 47 04             	mov    %eax,0x4(%edi)
80104f83:	85 c0                	test   %eax,%eax
80104f85:	0f 84 a1 00 00 00    	je     8010502c <fork+0xec>
  np->sz = curproc->sz;
80104f8b:	8b 03                	mov    (%ebx),%eax
80104f8d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104f90:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80104f92:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80104f95:	89 c8                	mov    %ecx,%eax
80104f97:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80104f9a:	b9 13 00 00 00       	mov    $0x13,%ecx
80104f9f:	8b 73 18             	mov    0x18(%ebx),%esi
80104fa2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80104fa4:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80104fa6:	8b 40 18             	mov    0x18(%eax),%eax
80104fa9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80104fb0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80104fb4:	85 c0                	test   %eax,%eax
80104fb6:	74 13                	je     80104fcb <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104fb8:	83 ec 0c             	sub    $0xc,%esp
80104fbb:	50                   	push   %eax
80104fbc:	e8 ef d2 ff ff       	call   801022b0 <filedup>
80104fc1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104fc4:	83 c4 10             	add    $0x10,%esp
80104fc7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80104fcb:	83 c6 01             	add    $0x1,%esi
80104fce:	83 fe 10             	cmp    $0x10,%esi
80104fd1:	75 dd                	jne    80104fb0 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80104fd3:	83 ec 0c             	sub    $0xc,%esp
80104fd6:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104fd9:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80104fdc:	e8 7f db ff ff       	call   80102b60 <idup>
80104fe1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104fe4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80104fe7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104fea:	8d 47 6c             	lea    0x6c(%edi),%eax
80104fed:	6a 10                	push   $0x10
80104fef:	53                   	push   %ebx
80104ff0:	50                   	push   %eax
80104ff1:	e8 ea 0e 00 00       	call   80105ee0 <safestrcpy>
  pid = np->pid;
80104ff6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80104ff9:	c7 04 24 a0 44 11 80 	movl   $0x801144a0,(%esp)
80105000:	e8 5b 0c 00 00       	call   80105c60 <acquire>
  np->state = RUNNABLE;
80105005:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
8010500c:	c7 04 24 a0 44 11 80 	movl   $0x801144a0,(%esp)
80105013:	e8 e8 0b 00 00       	call   80105c00 <release>
  return pid;
80105018:	83 c4 10             	add    $0x10,%esp
}
8010501b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010501e:	89 d8                	mov    %ebx,%eax
80105020:	5b                   	pop    %ebx
80105021:	5e                   	pop    %esi
80105022:	5f                   	pop    %edi
80105023:	5d                   	pop    %ebp
80105024:	c3                   	ret    
    return -1;
80105025:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010502a:	eb ef                	jmp    8010501b <fork+0xdb>
    kfree(np->kstack);
8010502c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010502f:	83 ec 0c             	sub    $0xc,%esp
80105032:	ff 73 08             	push   0x8(%ebx)
80105035:	e8 96 e8 ff ff       	call   801038d0 <kfree>
    np->kstack = 0;
8010503a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80105041:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80105044:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
8010504b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105050:	eb c9                	jmp    8010501b <fork+0xdb>
80105052:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105060 <scheduler>:
{
80105060:	55                   	push   %ebp
80105061:	89 e5                	mov    %esp,%ebp
80105063:	57                   	push   %edi
80105064:	56                   	push   %esi
80105065:	53                   	push   %ebx
80105066:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80105069:	e8 b2 fc ff ff       	call   80104d20 <mycpu>
  c->proc = 0;
8010506e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80105075:	00 00 00 
  struct cpu *c = mycpu();
80105078:	89 c6                	mov    %eax,%esi
  c->proc = 0;
8010507a:	8d 78 04             	lea    0x4(%eax),%edi
8010507d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80105080:	fb                   	sti    
    acquire(&ptable.lock);
80105081:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105084:	bb d4 44 11 80       	mov    $0x801144d4,%ebx
    acquire(&ptable.lock);
80105089:	68 a0 44 11 80       	push   $0x801144a0
8010508e:	e8 cd 0b 00 00       	call   80105c60 <acquire>
80105093:	83 c4 10             	add    $0x10,%esp
80105096:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010509d:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
801050a0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801050a4:	75 33                	jne    801050d9 <scheduler+0x79>
      switchuvm(p);
801050a6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
801050a9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
801050af:	53                   	push   %ebx
801050b0:	e8 8b 33 00 00       	call   80108440 <switchuvm>
      swtch(&(c->scheduler), p->context);
801050b5:	58                   	pop    %eax
801050b6:	5a                   	pop    %edx
801050b7:	ff 73 1c             	push   0x1c(%ebx)
801050ba:	57                   	push   %edi
      p->state = RUNNING;
801050bb:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
801050c2:	e8 74 0e 00 00       	call   80105f3b <swtch>
      switchkvm();
801050c7:	e8 64 33 00 00       	call   80108430 <switchkvm>
      c->proc = 0;
801050cc:	83 c4 10             	add    $0x10,%esp
801050cf:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
801050d6:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801050d9:	81 c3 e8 00 00 00    	add    $0xe8,%ebx
801050df:	81 fb d4 7e 11 80    	cmp    $0x80117ed4,%ebx
801050e5:	75 b9                	jne    801050a0 <scheduler+0x40>
    release(&ptable.lock);
801050e7:	83 ec 0c             	sub    $0xc,%esp
801050ea:	68 a0 44 11 80       	push   $0x801144a0
801050ef:	e8 0c 0b 00 00       	call   80105c00 <release>
    sti();
801050f4:	83 c4 10             	add    $0x10,%esp
801050f7:	eb 87                	jmp    80105080 <scheduler+0x20>
801050f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105100 <sched>:
{
80105100:	55                   	push   %ebp
80105101:	89 e5                	mov    %esp,%ebp
80105103:	56                   	push   %esi
80105104:	53                   	push   %ebx
  pushcli();
80105105:	e8 06 0a 00 00       	call   80105b10 <pushcli>
  c = mycpu();
8010510a:	e8 11 fc ff ff       	call   80104d20 <mycpu>
  p = c->proc;
8010510f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80105115:	e8 46 0a 00 00       	call   80105b60 <popcli>
  if(!holding(&ptable.lock))
8010511a:	83 ec 0c             	sub    $0xc,%esp
8010511d:	68 a0 44 11 80       	push   $0x801144a0
80105122:	e8 99 0a 00 00       	call   80105bc0 <holding>
80105127:	83 c4 10             	add    $0x10,%esp
8010512a:	85 c0                	test   %eax,%eax
8010512c:	74 4f                	je     8010517d <sched+0x7d>
  if(mycpu()->ncli != 1)
8010512e:	e8 ed fb ff ff       	call   80104d20 <mycpu>
80105133:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010513a:	75 68                	jne    801051a4 <sched+0xa4>
  if(p->state == RUNNING)
8010513c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80105140:	74 55                	je     80105197 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105142:	9c                   	pushf  
80105143:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80105144:	f6 c4 02             	test   $0x2,%ah
80105147:	75 41                	jne    8010518a <sched+0x8a>
  intena = mycpu()->intena;
80105149:	e8 d2 fb ff ff       	call   80104d20 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010514e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80105151:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80105157:	e8 c4 fb ff ff       	call   80104d20 <mycpu>
8010515c:	83 ec 08             	sub    $0x8,%esp
8010515f:	ff 70 04             	push   0x4(%eax)
80105162:	53                   	push   %ebx
80105163:	e8 d3 0d 00 00       	call   80105f3b <swtch>
  mycpu()->intena = intena;
80105168:	e8 b3 fb ff ff       	call   80104d20 <mycpu>
}
8010516d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80105170:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80105176:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105179:	5b                   	pop    %ebx
8010517a:	5e                   	pop    %esi
8010517b:	5d                   	pop    %ebp
8010517c:	c3                   	ret    
    panic("sched ptable.lock");
8010517d:	83 ec 0c             	sub    $0xc,%esp
80105180:	68 db 91 10 80       	push   $0x801091db
80105185:	e8 f6 b1 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
8010518a:	83 ec 0c             	sub    $0xc,%esp
8010518d:	68 07 92 10 80       	push   $0x80109207
80105192:	e8 e9 b1 ff ff       	call   80100380 <panic>
    panic("sched running");
80105197:	83 ec 0c             	sub    $0xc,%esp
8010519a:	68 f9 91 10 80       	push   $0x801091f9
8010519f:	e8 dc b1 ff ff       	call   80100380 <panic>
    panic("sched locks");
801051a4:	83 ec 0c             	sub    $0xc,%esp
801051a7:	68 ed 91 10 80       	push   $0x801091ed
801051ac:	e8 cf b1 ff ff       	call   80100380 <panic>
801051b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051bf:	90                   	nop

801051c0 <exit>:
{
801051c0:	55                   	push   %ebp
801051c1:	89 e5                	mov    %esp,%ebp
801051c3:	57                   	push   %edi
801051c4:	56                   	push   %esi
801051c5:	53                   	push   %ebx
801051c6:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
801051c9:	e8 d2 fb ff ff       	call   80104da0 <myproc>
  if(curproc == initproc)
801051ce:	39 05 d4 7e 11 80    	cmp    %eax,0x80117ed4
801051d4:	0f 84 07 01 00 00    	je     801052e1 <exit+0x121>
801051da:	89 c3                	mov    %eax,%ebx
801051dc:	8d 70 28             	lea    0x28(%eax),%esi
801051df:	8d 78 68             	lea    0x68(%eax),%edi
801051e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
801051e8:	8b 06                	mov    (%esi),%eax
801051ea:	85 c0                	test   %eax,%eax
801051ec:	74 12                	je     80105200 <exit+0x40>
      fileclose(curproc->ofile[fd]);
801051ee:	83 ec 0c             	sub    $0xc,%esp
801051f1:	50                   	push   %eax
801051f2:	e8 09 d1 ff ff       	call   80102300 <fileclose>
      curproc->ofile[fd] = 0;
801051f7:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801051fd:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80105200:	83 c6 04             	add    $0x4,%esi
80105203:	39 f7                	cmp    %esi,%edi
80105205:	75 e1                	jne    801051e8 <exit+0x28>
  begin_op();
80105207:	e8 64 ef ff ff       	call   80104170 <begin_op>
  iput(curproc->cwd);
8010520c:	83 ec 0c             	sub    $0xc,%esp
8010520f:	ff 73 68             	push   0x68(%ebx)
80105212:	e8 a9 da ff ff       	call   80102cc0 <iput>
  end_op();
80105217:	e8 c4 ef ff ff       	call   801041e0 <end_op>
  curproc->cwd = 0;
8010521c:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80105223:	c7 04 24 a0 44 11 80 	movl   $0x801144a0,(%esp)
8010522a:	e8 31 0a 00 00       	call   80105c60 <acquire>
  wakeup1(curproc->parent);
8010522f:	8b 53 14             	mov    0x14(%ebx),%edx
80105232:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105235:	b8 d4 44 11 80       	mov    $0x801144d4,%eax
8010523a:	eb 10                	jmp    8010524c <exit+0x8c>
8010523c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105240:	05 e8 00 00 00       	add    $0xe8,%eax
80105245:	3d d4 7e 11 80       	cmp    $0x80117ed4,%eax
8010524a:	74 1e                	je     8010526a <exit+0xaa>
    if(p->state == SLEEPING && p->chan == chan)
8010524c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80105250:	75 ee                	jne    80105240 <exit+0x80>
80105252:	3b 50 20             	cmp    0x20(%eax),%edx
80105255:	75 e9                	jne    80105240 <exit+0x80>
      p->state = RUNNABLE;
80105257:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010525e:	05 e8 00 00 00       	add    $0xe8,%eax
80105263:	3d d4 7e 11 80       	cmp    $0x80117ed4,%eax
80105268:	75 e2                	jne    8010524c <exit+0x8c>
      p->parent = initproc;
8010526a:	8b 0d d4 7e 11 80    	mov    0x80117ed4,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105270:	ba d4 44 11 80       	mov    $0x801144d4,%edx
80105275:	eb 17                	jmp    8010528e <exit+0xce>
80105277:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010527e:	66 90                	xchg   %ax,%ax
80105280:	81 c2 e8 00 00 00    	add    $0xe8,%edx
80105286:	81 fa d4 7e 11 80    	cmp    $0x80117ed4,%edx
8010528c:	74 3a                	je     801052c8 <exit+0x108>
    if(p->parent == curproc){
8010528e:	39 5a 14             	cmp    %ebx,0x14(%edx)
80105291:	75 ed                	jne    80105280 <exit+0xc0>
      if(p->state == ZOMBIE)
80105293:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80105297:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010529a:	75 e4                	jne    80105280 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010529c:	b8 d4 44 11 80       	mov    $0x801144d4,%eax
801052a1:	eb 11                	jmp    801052b4 <exit+0xf4>
801052a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801052a7:	90                   	nop
801052a8:	05 e8 00 00 00       	add    $0xe8,%eax
801052ad:	3d d4 7e 11 80       	cmp    $0x80117ed4,%eax
801052b2:	74 cc                	je     80105280 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
801052b4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801052b8:	75 ee                	jne    801052a8 <exit+0xe8>
801052ba:	3b 48 20             	cmp    0x20(%eax),%ecx
801052bd:	75 e9                	jne    801052a8 <exit+0xe8>
      p->state = RUNNABLE;
801052bf:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801052c6:	eb e0                	jmp    801052a8 <exit+0xe8>
  curproc->state = ZOMBIE;
801052c8:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
801052cf:	e8 2c fe ff ff       	call   80105100 <sched>
  panic("zombie exit");
801052d4:	83 ec 0c             	sub    $0xc,%esp
801052d7:	68 28 92 10 80       	push   $0x80109228
801052dc:	e8 9f b0 ff ff       	call   80100380 <panic>
    panic("init exiting");
801052e1:	83 ec 0c             	sub    $0xc,%esp
801052e4:	68 1b 92 10 80       	push   $0x8010921b
801052e9:	e8 92 b0 ff ff       	call   80100380 <panic>
801052ee:	66 90                	xchg   %ax,%ax

801052f0 <wait>:
{
801052f0:	55                   	push   %ebp
801052f1:	89 e5                	mov    %esp,%ebp
801052f3:	56                   	push   %esi
801052f4:	53                   	push   %ebx
  pushcli();
801052f5:	e8 16 08 00 00       	call   80105b10 <pushcli>
  c = mycpu();
801052fa:	e8 21 fa ff ff       	call   80104d20 <mycpu>
  p = c->proc;
801052ff:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80105305:	e8 56 08 00 00       	call   80105b60 <popcli>
  acquire(&ptable.lock);
8010530a:	83 ec 0c             	sub    $0xc,%esp
8010530d:	68 a0 44 11 80       	push   $0x801144a0
80105312:	e8 49 09 00 00       	call   80105c60 <acquire>
80105317:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010531a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010531c:	bb d4 44 11 80       	mov    $0x801144d4,%ebx
80105321:	eb 13                	jmp    80105336 <wait+0x46>
80105323:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105327:	90                   	nop
80105328:	81 c3 e8 00 00 00    	add    $0xe8,%ebx
8010532e:	81 fb d4 7e 11 80    	cmp    $0x80117ed4,%ebx
80105334:	74 1e                	je     80105354 <wait+0x64>
      if(p->parent != curproc)
80105336:	39 73 14             	cmp    %esi,0x14(%ebx)
80105339:	75 ed                	jne    80105328 <wait+0x38>
      if(p->state == ZOMBIE){
8010533b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010533f:	74 5f                	je     801053a0 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105341:	81 c3 e8 00 00 00    	add    $0xe8,%ebx
      havekids = 1;
80105347:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010534c:	81 fb d4 7e 11 80    	cmp    $0x80117ed4,%ebx
80105352:	75 e2                	jne    80105336 <wait+0x46>
    if(!havekids || curproc->killed){
80105354:	85 c0                	test   %eax,%eax
80105356:	0f 84 9a 00 00 00    	je     801053f6 <wait+0x106>
8010535c:	8b 46 24             	mov    0x24(%esi),%eax
8010535f:	85 c0                	test   %eax,%eax
80105361:	0f 85 8f 00 00 00    	jne    801053f6 <wait+0x106>
  pushcli();
80105367:	e8 a4 07 00 00       	call   80105b10 <pushcli>
  c = mycpu();
8010536c:	e8 af f9 ff ff       	call   80104d20 <mycpu>
  p = c->proc;
80105371:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80105377:	e8 e4 07 00 00       	call   80105b60 <popcli>
  if(p == 0)
8010537c:	85 db                	test   %ebx,%ebx
8010537e:	0f 84 89 00 00 00    	je     8010540d <wait+0x11d>
  p->chan = chan;
80105384:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80105387:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
8010538e:	e8 6d fd ff ff       	call   80105100 <sched>
  p->chan = 0;
80105393:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010539a:	e9 7b ff ff ff       	jmp    8010531a <wait+0x2a>
8010539f:	90                   	nop
        kfree(p->kstack);
801053a0:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
801053a3:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801053a6:	ff 73 08             	push   0x8(%ebx)
801053a9:	e8 22 e5 ff ff       	call   801038d0 <kfree>
        p->kstack = 0;
801053ae:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801053b5:	5a                   	pop    %edx
801053b6:	ff 73 04             	push   0x4(%ebx)
801053b9:	e8 62 34 00 00       	call   80108820 <freevm>
        p->pid = 0;
801053be:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801053c5:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801053cc:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801053d0:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801053d7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801053de:	c7 04 24 a0 44 11 80 	movl   $0x801144a0,(%esp)
801053e5:	e8 16 08 00 00       	call   80105c00 <release>
        return pid;
801053ea:	83 c4 10             	add    $0x10,%esp
}
801053ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
801053f0:	89 f0                	mov    %esi,%eax
801053f2:	5b                   	pop    %ebx
801053f3:	5e                   	pop    %esi
801053f4:	5d                   	pop    %ebp
801053f5:	c3                   	ret    
      release(&ptable.lock);
801053f6:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801053f9:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801053fe:	68 a0 44 11 80       	push   $0x801144a0
80105403:	e8 f8 07 00 00       	call   80105c00 <release>
      return -1;
80105408:	83 c4 10             	add    $0x10,%esp
8010540b:	eb e0                	jmp    801053ed <wait+0xfd>
    panic("sleep");
8010540d:	83 ec 0c             	sub    $0xc,%esp
80105410:	68 34 92 10 80       	push   $0x80109234
80105415:	e8 66 af ff ff       	call   80100380 <panic>
8010541a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105420 <yield>:
{
80105420:	55                   	push   %ebp
80105421:	89 e5                	mov    %esp,%ebp
80105423:	53                   	push   %ebx
80105424:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80105427:	68 a0 44 11 80       	push   $0x801144a0
8010542c:	e8 2f 08 00 00       	call   80105c60 <acquire>
  pushcli();
80105431:	e8 da 06 00 00       	call   80105b10 <pushcli>
  c = mycpu();
80105436:	e8 e5 f8 ff ff       	call   80104d20 <mycpu>
  p = c->proc;
8010543b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80105441:	e8 1a 07 00 00       	call   80105b60 <popcli>
  myproc()->state = RUNNABLE;
80105446:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010544d:	e8 ae fc ff ff       	call   80105100 <sched>
  release(&ptable.lock);
80105452:	c7 04 24 a0 44 11 80 	movl   $0x801144a0,(%esp)
80105459:	e8 a2 07 00 00       	call   80105c00 <release>
}
8010545e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105461:	83 c4 10             	add    $0x10,%esp
80105464:	c9                   	leave  
80105465:	c3                   	ret    
80105466:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010546d:	8d 76 00             	lea    0x0(%esi),%esi

80105470 <sleep>:
{
80105470:	55                   	push   %ebp
80105471:	89 e5                	mov    %esp,%ebp
80105473:	57                   	push   %edi
80105474:	56                   	push   %esi
80105475:	53                   	push   %ebx
80105476:	83 ec 0c             	sub    $0xc,%esp
80105479:	8b 7d 08             	mov    0x8(%ebp),%edi
8010547c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010547f:	e8 8c 06 00 00       	call   80105b10 <pushcli>
  c = mycpu();
80105484:	e8 97 f8 ff ff       	call   80104d20 <mycpu>
  p = c->proc;
80105489:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010548f:	e8 cc 06 00 00       	call   80105b60 <popcli>
  if(p == 0)
80105494:	85 db                	test   %ebx,%ebx
80105496:	0f 84 87 00 00 00    	je     80105523 <sleep+0xb3>
  if(lk == 0)
8010549c:	85 f6                	test   %esi,%esi
8010549e:	74 76                	je     80105516 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801054a0:	81 fe a0 44 11 80    	cmp    $0x801144a0,%esi
801054a6:	74 50                	je     801054f8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801054a8:	83 ec 0c             	sub    $0xc,%esp
801054ab:	68 a0 44 11 80       	push   $0x801144a0
801054b0:	e8 ab 07 00 00       	call   80105c60 <acquire>
    release(lk);
801054b5:	89 34 24             	mov    %esi,(%esp)
801054b8:	e8 43 07 00 00       	call   80105c00 <release>
  p->chan = chan;
801054bd:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801054c0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801054c7:	e8 34 fc ff ff       	call   80105100 <sched>
  p->chan = 0;
801054cc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801054d3:	c7 04 24 a0 44 11 80 	movl   $0x801144a0,(%esp)
801054da:	e8 21 07 00 00       	call   80105c00 <release>
    acquire(lk);
801054df:	89 75 08             	mov    %esi,0x8(%ebp)
801054e2:	83 c4 10             	add    $0x10,%esp
}
801054e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801054e8:	5b                   	pop    %ebx
801054e9:	5e                   	pop    %esi
801054ea:	5f                   	pop    %edi
801054eb:	5d                   	pop    %ebp
    acquire(lk);
801054ec:	e9 6f 07 00 00       	jmp    80105c60 <acquire>
801054f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801054f8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801054fb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80105502:	e8 f9 fb ff ff       	call   80105100 <sched>
  p->chan = 0;
80105507:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010550e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105511:	5b                   	pop    %ebx
80105512:	5e                   	pop    %esi
80105513:	5f                   	pop    %edi
80105514:	5d                   	pop    %ebp
80105515:	c3                   	ret    
    panic("sleep without lk");
80105516:	83 ec 0c             	sub    $0xc,%esp
80105519:	68 3a 92 10 80       	push   $0x8010923a
8010551e:	e8 5d ae ff ff       	call   80100380 <panic>
    panic("sleep");
80105523:	83 ec 0c             	sub    $0xc,%esp
80105526:	68 34 92 10 80       	push   $0x80109234
8010552b:	e8 50 ae ff ff       	call   80100380 <panic>

80105530 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80105530:	55                   	push   %ebp
80105531:	89 e5                	mov    %esp,%ebp
80105533:	53                   	push   %ebx
80105534:	83 ec 10             	sub    $0x10,%esp
80105537:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010553a:	68 a0 44 11 80       	push   $0x801144a0
8010553f:	e8 1c 07 00 00       	call   80105c60 <acquire>
80105544:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105547:	b8 d4 44 11 80       	mov    $0x801144d4,%eax
8010554c:	eb 0e                	jmp    8010555c <wakeup+0x2c>
8010554e:	66 90                	xchg   %ax,%ax
80105550:	05 e8 00 00 00       	add    $0xe8,%eax
80105555:	3d d4 7e 11 80       	cmp    $0x80117ed4,%eax
8010555a:	74 1e                	je     8010557a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
8010555c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80105560:	75 ee                	jne    80105550 <wakeup+0x20>
80105562:	3b 58 20             	cmp    0x20(%eax),%ebx
80105565:	75 e9                	jne    80105550 <wakeup+0x20>
      p->state = RUNNABLE;
80105567:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010556e:	05 e8 00 00 00       	add    $0xe8,%eax
80105573:	3d d4 7e 11 80       	cmp    $0x80117ed4,%eax
80105578:	75 e2                	jne    8010555c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
8010557a:	c7 45 08 a0 44 11 80 	movl   $0x801144a0,0x8(%ebp)
}
80105581:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105584:	c9                   	leave  
  release(&ptable.lock);
80105585:	e9 76 06 00 00       	jmp    80105c00 <release>
8010558a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105590 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80105590:	55                   	push   %ebp
80105591:	89 e5                	mov    %esp,%ebp
80105593:	53                   	push   %ebx
80105594:	83 ec 10             	sub    $0x10,%esp
80105597:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010559a:	68 a0 44 11 80       	push   $0x801144a0
8010559f:	e8 bc 06 00 00       	call   80105c60 <acquire>
801055a4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801055a7:	b8 d4 44 11 80       	mov    $0x801144d4,%eax
801055ac:	eb 0e                	jmp    801055bc <kill+0x2c>
801055ae:	66 90                	xchg   %ax,%ax
801055b0:	05 e8 00 00 00       	add    $0xe8,%eax
801055b5:	3d d4 7e 11 80       	cmp    $0x80117ed4,%eax
801055ba:	74 34                	je     801055f0 <kill+0x60>
    if(p->pid == pid){
801055bc:	39 58 10             	cmp    %ebx,0x10(%eax)
801055bf:	75 ef                	jne    801055b0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801055c1:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801055c5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801055cc:	75 07                	jne    801055d5 <kill+0x45>
        p->state = RUNNABLE;
801055ce:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801055d5:	83 ec 0c             	sub    $0xc,%esp
801055d8:	68 a0 44 11 80       	push   $0x801144a0
801055dd:	e8 1e 06 00 00       	call   80105c00 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801055e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801055e5:	83 c4 10             	add    $0x10,%esp
801055e8:	31 c0                	xor    %eax,%eax
}
801055ea:	c9                   	leave  
801055eb:	c3                   	ret    
801055ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
801055f0:	83 ec 0c             	sub    $0xc,%esp
801055f3:	68 a0 44 11 80       	push   $0x801144a0
801055f8:	e8 03 06 00 00       	call   80105c00 <release>
}
801055fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80105600:	83 c4 10             	add    $0x10,%esp
80105603:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105608:	c9                   	leave  
80105609:	c3                   	ret    
8010560a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105610 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80105610:	55                   	push   %ebp
80105611:	89 e5                	mov    %esp,%ebp
80105613:	57                   	push   %edi
80105614:	56                   	push   %esi
80105615:	8d 75 e8             	lea    -0x18(%ebp),%esi
80105618:	53                   	push   %ebx
80105619:	bb 40 45 11 80       	mov    $0x80114540,%ebx
8010561e:	83 ec 3c             	sub    $0x3c,%esp
80105621:	eb 27                	jmp    8010564a <procdump+0x3a>
80105623:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105627:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80105628:	83 ec 0c             	sub    $0xc,%esp
8010562b:	68 97 96 10 80       	push   $0x80109697
80105630:	e8 cb b0 ff ff       	call   80100700 <cprintf>
80105635:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105638:	81 c3 e8 00 00 00    	add    $0xe8,%ebx
8010563e:	81 fb 40 7f 11 80    	cmp    $0x80117f40,%ebx
80105644:	0f 84 7e 00 00 00    	je     801056c8 <procdump+0xb8>
    if(p->state == UNUSED)
8010564a:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010564d:	85 c0                	test   %eax,%eax
8010564f:	74 e7                	je     80105638 <procdump+0x28>
      state = "???";
80105651:	ba 4b 92 10 80       	mov    $0x8010924b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80105656:	83 f8 05             	cmp    $0x5,%eax
80105659:	77 11                	ja     8010566c <procdump+0x5c>
8010565b:	8b 14 85 18 93 10 80 	mov    -0x7fef6ce8(,%eax,4),%edx
      state = "???";
80105662:	b8 4b 92 10 80       	mov    $0x8010924b,%eax
80105667:	85 d2                	test   %edx,%edx
80105669:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010566c:	53                   	push   %ebx
8010566d:	52                   	push   %edx
8010566e:	ff 73 a4             	push   -0x5c(%ebx)
80105671:	68 4f 92 10 80       	push   $0x8010924f
80105676:	e8 85 b0 ff ff       	call   80100700 <cprintf>
    if(p->state == SLEEPING){
8010567b:	83 c4 10             	add    $0x10,%esp
8010567e:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80105682:	75 a4                	jne    80105628 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80105684:	83 ec 08             	sub    $0x8,%esp
80105687:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010568a:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010568d:	50                   	push   %eax
8010568e:	8b 43 b0             	mov    -0x50(%ebx),%eax
80105691:	8b 40 0c             	mov    0xc(%eax),%eax
80105694:	83 c0 08             	add    $0x8,%eax
80105697:	50                   	push   %eax
80105698:	e8 13 04 00 00       	call   80105ab0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010569d:	83 c4 10             	add    $0x10,%esp
801056a0:	8b 17                	mov    (%edi),%edx
801056a2:	85 d2                	test   %edx,%edx
801056a4:	74 82                	je     80105628 <procdump+0x18>
        cprintf(" %p", pc[i]);
801056a6:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801056a9:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
801056ac:	52                   	push   %edx
801056ad:	68 41 8c 10 80       	push   $0x80108c41
801056b2:	e8 49 b0 ff ff       	call   80100700 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801056b7:	83 c4 10             	add    $0x10,%esp
801056ba:	39 fe                	cmp    %edi,%esi
801056bc:	75 e2                	jne    801056a0 <procdump+0x90>
801056be:	e9 65 ff ff ff       	jmp    80105628 <procdump+0x18>
801056c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801056c7:	90                   	nop
  }
}
801056c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056cb:	5b                   	pop    %ebx
801056cc:	5e                   	pop    %esi
801056cd:	5f                   	pop    %edi
801056ce:	5d                   	pop    %ebp
801056cf:	c3                   	ret    

801056d0 <create_palindrome>:


int create_palindrome(int num){
801056d0:	55                   	push   %ebp
801056d1:	89 e5                	mov    %esp,%ebp
801056d3:	57                   	push   %edi
  int reversed = 0;
  int temp = num;
  int num_of_digits = 0;

  while (temp > 0) 
801056d4:	8b 45 08             	mov    0x8(%ebp),%eax
int create_palindrome(int num){
801056d7:	56                   	push   %esi
801056d8:	53                   	push   %ebx
  while (temp > 0) 
801056d9:	85 c0                	test   %eax,%eax
801056db:	7e 63                	jle    80105740 <create_palindrome+0x70>
801056dd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int num_of_digits = 0;
801056e0:	31 db                	xor    %ebx,%ebx
  int reversed = 0;
801056e2:	31 c0                	xor    %eax,%eax
801056e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  {
      reversed = reversed * 10 + (temp % 10);
801056e8:	8d 34 80             	lea    (%eax,%eax,4),%esi
801056eb:	b8 cd cc cc cc       	mov    $0xcccccccd,%eax
801056f0:	89 cf                	mov    %ecx,%edi
801056f2:	f7 e1                	mul    %ecx
801056f4:	c1 ea 03             	shr    $0x3,%edx
801056f7:	8d 04 92             	lea    (%edx,%edx,4),%eax
801056fa:	01 c0                	add    %eax,%eax
801056fc:	29 c7                	sub    %eax,%edi
801056fe:	8d 04 77             	lea    (%edi,%esi,2),%eax
      temp /= 10;
80105701:	89 ce                	mov    %ecx,%esi
80105703:	89 d1                	mov    %edx,%ecx
      num_of_digits += 1;
80105705:	89 da                	mov    %ebx,%edx
80105707:	8d 5b 01             	lea    0x1(%ebx),%ebx
  while (temp > 0) 
8010570a:	83 fe 09             	cmp    $0x9,%esi
8010570d:	7f d9                	jg     801056e8 <create_palindrome+0x18>
  }

  int palindrome = reversed;
  int powers_of_ten = 1;
  for(int i = 0; i < num_of_digits; i++)
8010570f:	31 db                	xor    %ebx,%ebx
  int powers_of_ten = 1;
80105711:	b9 01 00 00 00       	mov    $0x1,%ecx
80105716:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010571d:	8d 76 00             	lea    0x0(%esi),%esi
  {
      powers_of_ten *= 10;
80105720:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
80105723:	89 de                	mov    %ebx,%esi
  for(int i = 0; i < num_of_digits; i++)
80105725:	83 c3 01             	add    $0x1,%ebx
      powers_of_ten *= 10;
80105728:	01 c9                	add    %ecx,%ecx
  for(int i = 0; i < num_of_digits; i++)
8010572a:	39 f2                	cmp    %esi,%edx
8010572c:	75 f2                	jne    80105720 <create_palindrome+0x50>
  }
  palindrome += (num * powers_of_ten);
8010572e:	0f af 4d 08          	imul   0x8(%ebp),%ecx
  return palindrome;
}
80105732:	5b                   	pop    %ebx
80105733:	5e                   	pop    %esi
80105734:	5f                   	pop    %edi
80105735:	5d                   	pop    %ebp
  palindrome += (num * powers_of_ten);
80105736:	01 c8                	add    %ecx,%eax
}
80105738:	c3                   	ret    
80105739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105740:	5b                   	pop    %ebx
  while (temp > 0) 
80105741:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105744:	5e                   	pop    %esi
80105745:	5f                   	pop    %edi
80105746:	5d                   	pop    %ebp
80105747:	c3                   	ret    
80105748:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010574f:	90                   	nop

80105750 <sys_get_most_invoked_syscall>:

int sys_get_most_invoked_syscall(void){
80105750:	55                   	push   %ebp
80105751:	89 e5                	mov    %esp,%ebp
80105753:	56                   	push   %esi
80105754:	53                   	push   %ebx
  int pid;
  if(argint(0, &pid) < 0){
80105755:	8d 45 f4             	lea    -0xc(%ebp),%eax
int sys_get_most_invoked_syscall(void){
80105758:	83 ec 18             	sub    $0x18,%esp
  if(argint(0, &pid) < 0){
8010575b:	50                   	push   %eax
8010575c:	6a 00                	push   $0x0
8010575e:	e8 7d 08 00 00       	call   80105fe0 <argint>
80105763:	83 c4 10             	add    $0x10,%esp
80105766:	85 c0                	test   %eax,%eax
80105768:	0f 88 98 00 00 00    	js     80105806 <sys_get_most_invoked_syscall+0xb6>
    return -1;
  }

  struct proc* p;
  acquire(&ptable.lock);
8010576e:	83 ec 0c             	sub    $0xc,%esp
80105771:	68 a0 44 11 80       	push   $0x801144a0
80105776:	e8 e5 04 00 00       	call   80105c60 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
8010577b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010577e:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105781:	ba d4 44 11 80       	mov    $0x801144d4,%edx
80105786:	eb 16                	jmp    8010579e <sys_get_most_invoked_syscall+0x4e>
80105788:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010578f:	90                   	nop
80105790:	81 c2 e8 00 00 00    	add    $0xe8,%edx
80105796:	81 fa d4 7e 11 80    	cmp    $0x80117ed4,%edx
8010579c:	74 4a                	je     801057e8 <sys_get_most_invoked_syscall+0x98>
    if(p->pid == pid){
8010579e:	39 42 10             	cmp    %eax,0x10(%edx)
801057a1:	75 ed                	jne    80105790 <sys_get_most_invoked_syscall+0x40>
      int max = p->syscall_history[0];
801057a3:	8b 9a 80 00 00 00    	mov    0x80(%edx),%ebx
801057a9:	b8 02 00 00 00       	mov    $0x2,%eax
      int index = 1;
801057ae:	be 01 00 00 00       	mov    $0x1,%esi
801057b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801057b7:	90                   	nop
      for(int i = 0; i < SYSCALL_NUM; i++){
        if(p->syscall_history[i] > max){
801057b8:	8b 4c 82 7c          	mov    0x7c(%edx,%eax,4),%ecx
801057bc:	39 d9                	cmp    %ebx,%ecx
801057be:	7e 04                	jle    801057c4 <sys_get_most_invoked_syscall+0x74>
          max = p->syscall_history[i];
          index = i + 1;//for array index
801057c0:	89 c6                	mov    %eax,%esi
801057c2:	89 cb                	mov    %ecx,%ebx
801057c4:	83 c0 01             	add    $0x1,%eax
      for(int i = 0; i < SYSCALL_NUM; i++){
801057c7:	83 f8 1b             	cmp    $0x1b,%eax
801057ca:	75 ec                	jne    801057b8 <sys_get_most_invoked_syscall+0x68>
        }
      }
      release(&ptable.lock);
801057cc:	83 ec 0c             	sub    $0xc,%esp
801057cf:	68 a0 44 11 80       	push   $0x801144a0
801057d4:	e8 27 04 00 00       	call   80105c00 <release>
      return index;
801057d9:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ptable.lock);
  return -1;
}
801057dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801057df:	89 f0                	mov    %esi,%eax
801057e1:	5b                   	pop    %ebx
801057e2:	5e                   	pop    %esi
801057e3:	5d                   	pop    %ebp
801057e4:	c3                   	ret    
801057e5:	8d 76 00             	lea    0x0(%esi),%esi
  release(&ptable.lock);
801057e8:	83 ec 0c             	sub    $0xc,%esp
  return -1;
801057eb:	be ff ff ff ff       	mov    $0xffffffff,%esi
  release(&ptable.lock);
801057f0:	68 a0 44 11 80       	push   $0x801144a0
801057f5:	e8 06 04 00 00       	call   80105c00 <release>
  return -1;
801057fa:	83 c4 10             	add    $0x10,%esp
}
801057fd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105800:	89 f0                	mov    %esi,%eax
80105802:	5b                   	pop    %ebx
80105803:	5e                   	pop    %esi
80105804:	5d                   	pop    %ebp
80105805:	c3                   	ret    
    return -1;
80105806:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010580b:	eb cf                	jmp    801057dc <sys_get_most_invoked_syscall+0x8c>
8010580d:	8d 76 00             	lea    0x0(%esi),%esi

80105810 <sys_sort_syscalls>:

int sys_sort_syscalls(void){
80105810:	55                   	push   %ebp
80105811:	89 e5                	mov    %esp,%ebp
80105813:	56                   	push   %esi
80105814:	53                   	push   %ebx
  int pid;
  if(argint(0, &pid) < 0){
80105815:	8d 45 f4             	lea    -0xc(%ebp),%eax
int sys_sort_syscalls(void){
80105818:	83 ec 18             	sub    $0x18,%esp
  if(argint(0, &pid) < 0){
8010581b:	50                   	push   %eax
8010581c:	6a 00                	push   $0x0
8010581e:	e8 bd 07 00 00       	call   80105fe0 <argint>
80105823:	83 c4 10             	add    $0x10,%esp
80105826:	85 c0                	test   %eax,%eax
80105828:	0f 88 ae 00 00 00    	js     801058dc <sys_sort_syscalls+0xcc>
    return -1;
  }

  struct proc* p;
  acquire(&ptable.lock);
8010582e:	83 ec 0c             	sub    $0xc,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105831:	bb d4 44 11 80       	mov    $0x801144d4,%ebx
  acquire(&ptable.lock);
80105836:	68 a0 44 11 80       	push   $0x801144a0
8010583b:	e8 20 04 00 00       	call   80105c60 <acquire>
    if((p->pid == pid) && (p->pid > 0)){
80105840:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105843:	83 c4 10             	add    $0x10,%esp
80105846:	eb 16                	jmp    8010585e <sys_sort_syscalls+0x4e>
80105848:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010584f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105850:	81 c3 e8 00 00 00    	add    $0xe8,%ebx
80105856:	81 fb d4 7e 11 80    	cmp    $0x80117ed4,%ebx
8010585c:	74 62                	je     801058c0 <sys_sort_syscalls+0xb0>
    if((p->pid == pid) && (p->pid > 0)){
8010585e:	8b 43 10             	mov    0x10(%ebx),%eax
80105861:	39 d0                	cmp    %edx,%eax
80105863:	75 eb                	jne    80105850 <sys_sort_syscalls+0x40>
80105865:	85 c0                	test   %eax,%eax
80105867:	7e e7                	jle    80105850 <sys_sort_syscalls+0x40>
      cprintf("Sorted system calls of %d/frequencies:\n", pid);
80105869:	83 ec 08             	sub    $0x8,%esp
      for(int i = 0; i < SYSCALL_NUM; i++)
8010586c:	31 f6                	xor    %esi,%esi
      cprintf("Sorted system calls of %d/frequencies:\n", pid);
8010586e:	52                   	push   %edx
8010586f:	68 f0 92 10 80       	push   $0x801092f0
80105874:	e8 87 ae ff ff       	call   80100700 <cprintf>
80105879:	83 c4 10             	add    $0x10,%esp
8010587c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      {
        if(p->syscall_history[i] > 0)
80105880:	8b 84 b3 80 00 00 00 	mov    0x80(%ebx,%esi,4),%eax
          cprintf("system call %d : %d\n", i + 1, p->syscall_history[i]);
80105887:	83 c6 01             	add    $0x1,%esi
        if(p->syscall_history[i] > 0)
8010588a:	85 c0                	test   %eax,%eax
8010588c:	7e 12                	jle    801058a0 <sys_sort_syscalls+0x90>
          cprintf("system call %d : %d\n", i + 1, p->syscall_history[i]);
8010588e:	83 ec 04             	sub    $0x4,%esp
80105891:	50                   	push   %eax
80105892:	56                   	push   %esi
80105893:	68 58 92 10 80       	push   $0x80109258
80105898:	e8 63 ae ff ff       	call   80100700 <cprintf>
8010589d:	83 c4 10             	add    $0x10,%esp
      for(int i = 0; i < SYSCALL_NUM; i++)
801058a0:	83 fe 1a             	cmp    $0x1a,%esi
801058a3:	75 db                	jne    80105880 <sys_sort_syscalls+0x70>
      } 
      release(&ptable.lock);
801058a5:	83 ec 0c             	sub    $0xc,%esp
801058a8:	68 a0 44 11 80       	push   $0x801144a0
801058ad:	e8 4e 03 00 00       	call   80105c00 <release>
      return 0;
801058b2:	83 c4 10             	add    $0x10,%esp
801058b5:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
801058b7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801058ba:	5b                   	pop    %ebx
801058bb:	5e                   	pop    %esi
801058bc:	5d                   	pop    %ebp
801058bd:	c3                   	ret    
801058be:	66 90                	xchg   %ax,%ax
  release(&ptable.lock);
801058c0:	83 ec 0c             	sub    $0xc,%esp
801058c3:	68 a0 44 11 80       	push   $0x801144a0
801058c8:	e8 33 03 00 00       	call   80105c00 <release>
  return -1;
801058cd:	83 c4 10             	add    $0x10,%esp
}
801058d0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  return -1;
801058d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058d8:	5b                   	pop    %ebx
801058d9:	5e                   	pop    %esi
801058da:	5d                   	pop    %ebp
801058db:	c3                   	ret    
    return -1;
801058dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058e1:	eb d4                	jmp    801058b7 <sys_sort_syscalls+0xa7>
801058e3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801058f0 <sys_list_all_processes>:

void sys_list_all_processes(void){
801058f0:	55                   	push   %ebp
801058f1:	89 e5                	mov    %esp,%ebp
801058f3:	53                   	push   %ebx
  struct proc* p;
  acquire(&ptable.lock);
  cprintf("Processes Info:\n");
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801058f4:	bb d4 44 11 80       	mov    $0x801144d4,%ebx
void sys_list_all_processes(void){
801058f9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801058fc:	68 a0 44 11 80       	push   $0x801144a0
80105901:	e8 5a 03 00 00       	call   80105c60 <acquire>
  cprintf("Processes Info:\n");
80105906:	c7 04 24 6d 92 10 80 	movl   $0x8010926d,(%esp)
8010590d:	e8 ee ad ff ff       	call   80100700 <cprintf>
80105912:	83 c4 10             	add    $0x10,%esp
80105915:	eb 2b                	jmp    80105942 <sys_list_all_processes+0x52>
80105917:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010591e:	66 90                	xchg   %ax,%ax
    if(p->pid > 0)
      cprintf("Process %d -> %d systemcalls\n", p->pid, p->syscall_count);
80105920:	83 ec 04             	sub    $0x4,%esp
80105923:	ff 73 7c             	push   0x7c(%ebx)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105926:	81 c3 e8 00 00 00    	add    $0xe8,%ebx
      cprintf("Process %d -> %d systemcalls\n", p->pid, p->syscall_count);
8010592c:	50                   	push   %eax
8010592d:	68 7e 92 10 80       	push   $0x8010927e
80105932:	e8 c9 ad ff ff       	call   80100700 <cprintf>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105937:	83 c4 10             	add    $0x10,%esp
8010593a:	81 fb d4 7e 11 80    	cmp    $0x80117ed4,%ebx
80105940:	74 17                	je     80105959 <sys_list_all_processes+0x69>
    if(p->pid > 0)
80105942:	8b 43 10             	mov    0x10(%ebx),%eax
80105945:	85 c0                	test   %eax,%eax
80105947:	7f d7                	jg     80105920 <sys_list_all_processes+0x30>
    else
    {
      release(&ptable.lock);
80105949:	83 ec 0c             	sub    $0xc,%esp
8010594c:	68 a0 44 11 80       	push   $0x801144a0
80105951:	e8 aa 02 00 00       	call   80105c00 <release>
      break;
80105956:	83 c4 10             	add    $0x10,%esp
    }
  }
80105959:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010595c:	c9                   	leave  
8010595d:	c3                   	ret    
8010595e:	66 90                	xchg   %ax,%ax

80105960 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80105960:	55                   	push   %ebp
80105961:	89 e5                	mov    %esp,%ebp
80105963:	53                   	push   %ebx
80105964:	83 ec 0c             	sub    $0xc,%esp
80105967:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010596a:	68 30 93 10 80       	push   $0x80109330
8010596f:	8d 43 04             	lea    0x4(%ebx),%eax
80105972:	50                   	push   %eax
80105973:	e8 18 01 00 00       	call   80105a90 <initlock>
  lk->name = name;
80105978:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010597b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80105981:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80105984:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010598b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010598e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105991:	c9                   	leave  
80105992:	c3                   	ret    
80105993:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010599a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801059a0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801059a0:	55                   	push   %ebp
801059a1:	89 e5                	mov    %esp,%ebp
801059a3:	56                   	push   %esi
801059a4:	53                   	push   %ebx
801059a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801059a8:	8d 73 04             	lea    0x4(%ebx),%esi
801059ab:	83 ec 0c             	sub    $0xc,%esp
801059ae:	56                   	push   %esi
801059af:	e8 ac 02 00 00       	call   80105c60 <acquire>
  while (lk->locked) {
801059b4:	8b 13                	mov    (%ebx),%edx
801059b6:	83 c4 10             	add    $0x10,%esp
801059b9:	85 d2                	test   %edx,%edx
801059bb:	74 16                	je     801059d3 <acquiresleep+0x33>
801059bd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801059c0:	83 ec 08             	sub    $0x8,%esp
801059c3:	56                   	push   %esi
801059c4:	53                   	push   %ebx
801059c5:	e8 a6 fa ff ff       	call   80105470 <sleep>
  while (lk->locked) {
801059ca:	8b 03                	mov    (%ebx),%eax
801059cc:	83 c4 10             	add    $0x10,%esp
801059cf:	85 c0                	test   %eax,%eax
801059d1:	75 ed                	jne    801059c0 <acquiresleep+0x20>
  }
  lk->locked = 1;
801059d3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801059d9:	e8 c2 f3 ff ff       	call   80104da0 <myproc>
801059de:	8b 40 10             	mov    0x10(%eax),%eax
801059e1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801059e4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801059e7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801059ea:	5b                   	pop    %ebx
801059eb:	5e                   	pop    %esi
801059ec:	5d                   	pop    %ebp
  release(&lk->lk);
801059ed:	e9 0e 02 00 00       	jmp    80105c00 <release>
801059f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105a00 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80105a00:	55                   	push   %ebp
80105a01:	89 e5                	mov    %esp,%ebp
80105a03:	56                   	push   %esi
80105a04:	53                   	push   %ebx
80105a05:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80105a08:	8d 73 04             	lea    0x4(%ebx),%esi
80105a0b:	83 ec 0c             	sub    $0xc,%esp
80105a0e:	56                   	push   %esi
80105a0f:	e8 4c 02 00 00       	call   80105c60 <acquire>
  lk->locked = 0;
80105a14:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80105a1a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80105a21:	89 1c 24             	mov    %ebx,(%esp)
80105a24:	e8 07 fb ff ff       	call   80105530 <wakeup>
  release(&lk->lk);
80105a29:	89 75 08             	mov    %esi,0x8(%ebp)
80105a2c:	83 c4 10             	add    $0x10,%esp
}
80105a2f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105a32:	5b                   	pop    %ebx
80105a33:	5e                   	pop    %esi
80105a34:	5d                   	pop    %ebp
  release(&lk->lk);
80105a35:	e9 c6 01 00 00       	jmp    80105c00 <release>
80105a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105a40 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80105a40:	55                   	push   %ebp
80105a41:	89 e5                	mov    %esp,%ebp
80105a43:	57                   	push   %edi
80105a44:	31 ff                	xor    %edi,%edi
80105a46:	56                   	push   %esi
80105a47:	53                   	push   %ebx
80105a48:	83 ec 18             	sub    $0x18,%esp
80105a4b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80105a4e:	8d 73 04             	lea    0x4(%ebx),%esi
80105a51:	56                   	push   %esi
80105a52:	e8 09 02 00 00       	call   80105c60 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80105a57:	8b 03                	mov    (%ebx),%eax
80105a59:	83 c4 10             	add    $0x10,%esp
80105a5c:	85 c0                	test   %eax,%eax
80105a5e:	75 18                	jne    80105a78 <holdingsleep+0x38>
  release(&lk->lk);
80105a60:	83 ec 0c             	sub    $0xc,%esp
80105a63:	56                   	push   %esi
80105a64:	e8 97 01 00 00       	call   80105c00 <release>
  return r;
}
80105a69:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a6c:	89 f8                	mov    %edi,%eax
80105a6e:	5b                   	pop    %ebx
80105a6f:	5e                   	pop    %esi
80105a70:	5f                   	pop    %edi
80105a71:	5d                   	pop    %ebp
80105a72:	c3                   	ret    
80105a73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a77:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
80105a78:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80105a7b:	e8 20 f3 ff ff       	call   80104da0 <myproc>
80105a80:	39 58 10             	cmp    %ebx,0x10(%eax)
80105a83:	0f 94 c0             	sete   %al
80105a86:	0f b6 c0             	movzbl %al,%eax
80105a89:	89 c7                	mov    %eax,%edi
80105a8b:	eb d3                	jmp    80105a60 <holdingsleep+0x20>
80105a8d:	66 90                	xchg   %ax,%ax
80105a8f:	90                   	nop

80105a90 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80105a90:	55                   	push   %ebp
80105a91:	89 e5                	mov    %esp,%ebp
80105a93:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80105a96:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80105a99:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80105a9f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80105aa2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80105aa9:	5d                   	pop    %ebp
80105aaa:	c3                   	ret    
80105aab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105aaf:	90                   	nop

80105ab0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105ab0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80105ab1:	31 d2                	xor    %edx,%edx
{
80105ab3:	89 e5                	mov    %esp,%ebp
80105ab5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80105ab6:	8b 45 08             	mov    0x8(%ebp),%eax
{
80105ab9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80105abc:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80105abf:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105ac0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80105ac6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80105acc:	77 1a                	ja     80105ae8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80105ace:	8b 58 04             	mov    0x4(%eax),%ebx
80105ad1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80105ad4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80105ad7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80105ad9:	83 fa 0a             	cmp    $0xa,%edx
80105adc:	75 e2                	jne    80105ac0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80105ade:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ae1:	c9                   	leave  
80105ae2:	c3                   	ret    
80105ae3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105ae7:	90                   	nop
  for(; i < 10; i++)
80105ae8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80105aeb:	8d 51 28             	lea    0x28(%ecx),%edx
80105aee:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80105af0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80105af6:	83 c0 04             	add    $0x4,%eax
80105af9:	39 d0                	cmp    %edx,%eax
80105afb:	75 f3                	jne    80105af0 <getcallerpcs+0x40>
}
80105afd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b00:	c9                   	leave  
80105b01:	c3                   	ret    
80105b02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105b10 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105b10:	55                   	push   %ebp
80105b11:	89 e5                	mov    %esp,%ebp
80105b13:	53                   	push   %ebx
80105b14:	83 ec 04             	sub    $0x4,%esp
80105b17:	9c                   	pushf  
80105b18:	5b                   	pop    %ebx
  asm volatile("cli");
80105b19:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80105b1a:	e8 01 f2 ff ff       	call   80104d20 <mycpu>
80105b1f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105b25:	85 c0                	test   %eax,%eax
80105b27:	74 17                	je     80105b40 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80105b29:	e8 f2 f1 ff ff       	call   80104d20 <mycpu>
80105b2e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80105b35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b38:	c9                   	leave  
80105b39:	c3                   	ret    
80105b3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80105b40:	e8 db f1 ff ff       	call   80104d20 <mycpu>
80105b45:	81 e3 00 02 00 00    	and    $0x200,%ebx
80105b4b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80105b51:	eb d6                	jmp    80105b29 <pushcli+0x19>
80105b53:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105b60 <popcli>:

void
popcli(void)
{
80105b60:	55                   	push   %ebp
80105b61:	89 e5                	mov    %esp,%ebp
80105b63:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105b66:	9c                   	pushf  
80105b67:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80105b68:	f6 c4 02             	test   $0x2,%ah
80105b6b:	75 35                	jne    80105ba2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80105b6d:	e8 ae f1 ff ff       	call   80104d20 <mycpu>
80105b72:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80105b79:	78 34                	js     80105baf <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80105b7b:	e8 a0 f1 ff ff       	call   80104d20 <mycpu>
80105b80:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80105b86:	85 d2                	test   %edx,%edx
80105b88:	74 06                	je     80105b90 <popcli+0x30>
    sti();
}
80105b8a:	c9                   	leave  
80105b8b:	c3                   	ret    
80105b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80105b90:	e8 8b f1 ff ff       	call   80104d20 <mycpu>
80105b95:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80105b9b:	85 c0                	test   %eax,%eax
80105b9d:	74 eb                	je     80105b8a <popcli+0x2a>
  asm volatile("sti");
80105b9f:	fb                   	sti    
}
80105ba0:	c9                   	leave  
80105ba1:	c3                   	ret    
    panic("popcli - interruptible");
80105ba2:	83 ec 0c             	sub    $0xc,%esp
80105ba5:	68 3b 93 10 80       	push   $0x8010933b
80105baa:	e8 d1 a7 ff ff       	call   80100380 <panic>
    panic("popcli");
80105baf:	83 ec 0c             	sub    $0xc,%esp
80105bb2:	68 52 93 10 80       	push   $0x80109352
80105bb7:	e8 c4 a7 ff ff       	call   80100380 <panic>
80105bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105bc0 <holding>:
{
80105bc0:	55                   	push   %ebp
80105bc1:	89 e5                	mov    %esp,%ebp
80105bc3:	56                   	push   %esi
80105bc4:	53                   	push   %ebx
80105bc5:	8b 75 08             	mov    0x8(%ebp),%esi
80105bc8:	31 db                	xor    %ebx,%ebx
  pushcli();
80105bca:	e8 41 ff ff ff       	call   80105b10 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80105bcf:	8b 06                	mov    (%esi),%eax
80105bd1:	85 c0                	test   %eax,%eax
80105bd3:	75 0b                	jne    80105be0 <holding+0x20>
  popcli();
80105bd5:	e8 86 ff ff ff       	call   80105b60 <popcli>
}
80105bda:	89 d8                	mov    %ebx,%eax
80105bdc:	5b                   	pop    %ebx
80105bdd:	5e                   	pop    %esi
80105bde:	5d                   	pop    %ebp
80105bdf:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80105be0:	8b 5e 08             	mov    0x8(%esi),%ebx
80105be3:	e8 38 f1 ff ff       	call   80104d20 <mycpu>
80105be8:	39 c3                	cmp    %eax,%ebx
80105bea:	0f 94 c3             	sete   %bl
  popcli();
80105bed:	e8 6e ff ff ff       	call   80105b60 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80105bf2:	0f b6 db             	movzbl %bl,%ebx
}
80105bf5:	89 d8                	mov    %ebx,%eax
80105bf7:	5b                   	pop    %ebx
80105bf8:	5e                   	pop    %esi
80105bf9:	5d                   	pop    %ebp
80105bfa:	c3                   	ret    
80105bfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105bff:	90                   	nop

80105c00 <release>:
{
80105c00:	55                   	push   %ebp
80105c01:	89 e5                	mov    %esp,%ebp
80105c03:	56                   	push   %esi
80105c04:	53                   	push   %ebx
80105c05:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80105c08:	e8 03 ff ff ff       	call   80105b10 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80105c0d:	8b 03                	mov    (%ebx),%eax
80105c0f:	85 c0                	test   %eax,%eax
80105c11:	75 15                	jne    80105c28 <release+0x28>
  popcli();
80105c13:	e8 48 ff ff ff       	call   80105b60 <popcli>
    panic("release");
80105c18:	83 ec 0c             	sub    $0xc,%esp
80105c1b:	68 59 93 10 80       	push   $0x80109359
80105c20:	e8 5b a7 ff ff       	call   80100380 <panic>
80105c25:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80105c28:	8b 73 08             	mov    0x8(%ebx),%esi
80105c2b:	e8 f0 f0 ff ff       	call   80104d20 <mycpu>
80105c30:	39 c6                	cmp    %eax,%esi
80105c32:	75 df                	jne    80105c13 <release+0x13>
  popcli();
80105c34:	e8 27 ff ff ff       	call   80105b60 <popcli>
  lk->pcs[0] = 0;
80105c39:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80105c40:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80105c47:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80105c4c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80105c52:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105c55:	5b                   	pop    %ebx
80105c56:	5e                   	pop    %esi
80105c57:	5d                   	pop    %ebp
  popcli();
80105c58:	e9 03 ff ff ff       	jmp    80105b60 <popcli>
80105c5d:	8d 76 00             	lea    0x0(%esi),%esi

80105c60 <acquire>:
{
80105c60:	55                   	push   %ebp
80105c61:	89 e5                	mov    %esp,%ebp
80105c63:	53                   	push   %ebx
80105c64:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80105c67:	e8 a4 fe ff ff       	call   80105b10 <pushcli>
  if(holding(lk))
80105c6c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80105c6f:	e8 9c fe ff ff       	call   80105b10 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80105c74:	8b 03                	mov    (%ebx),%eax
80105c76:	85 c0                	test   %eax,%eax
80105c78:	75 7e                	jne    80105cf8 <acquire+0x98>
  popcli();
80105c7a:	e8 e1 fe ff ff       	call   80105b60 <popcli>
  asm volatile("lock; xchgl %0, %1" :
80105c7f:	b9 01 00 00 00       	mov    $0x1,%ecx
80105c84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
80105c88:	8b 55 08             	mov    0x8(%ebp),%edx
80105c8b:	89 c8                	mov    %ecx,%eax
80105c8d:	f0 87 02             	lock xchg %eax,(%edx)
80105c90:	85 c0                	test   %eax,%eax
80105c92:	75 f4                	jne    80105c88 <acquire+0x28>
  __sync_synchronize();
80105c94:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80105c99:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105c9c:	e8 7f f0 ff ff       	call   80104d20 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80105ca1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
80105ca4:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80105ca6:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80105ca9:	31 c0                	xor    %eax,%eax
80105cab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105caf:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105cb0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80105cb6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80105cbc:	77 1a                	ja     80105cd8 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
80105cbe:	8b 5a 04             	mov    0x4(%edx),%ebx
80105cc1:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80105cc5:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80105cc8:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80105cca:	83 f8 0a             	cmp    $0xa,%eax
80105ccd:	75 e1                	jne    80105cb0 <acquire+0x50>
}
80105ccf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105cd2:	c9                   	leave  
80105cd3:	c3                   	ret    
80105cd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80105cd8:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
80105cdc:	8d 51 34             	lea    0x34(%ecx),%edx
80105cdf:	90                   	nop
    pcs[i] = 0;
80105ce0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80105ce6:	83 c0 04             	add    $0x4,%eax
80105ce9:	39 c2                	cmp    %eax,%edx
80105ceb:	75 f3                	jne    80105ce0 <acquire+0x80>
}
80105ced:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105cf0:	c9                   	leave  
80105cf1:	c3                   	ret    
80105cf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80105cf8:	8b 5b 08             	mov    0x8(%ebx),%ebx
80105cfb:	e8 20 f0 ff ff       	call   80104d20 <mycpu>
80105d00:	39 c3                	cmp    %eax,%ebx
80105d02:	0f 85 72 ff ff ff    	jne    80105c7a <acquire+0x1a>
  popcli();
80105d08:	e8 53 fe ff ff       	call   80105b60 <popcli>
    panic("acquire");
80105d0d:	83 ec 0c             	sub    $0xc,%esp
80105d10:	68 61 93 10 80       	push   $0x80109361
80105d15:	e8 66 a6 ff ff       	call   80100380 <panic>
80105d1a:	66 90                	xchg   %ax,%ax
80105d1c:	66 90                	xchg   %ax,%ax
80105d1e:	66 90                	xchg   %ax,%ax

80105d20 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105d20:	55                   	push   %ebp
80105d21:	89 e5                	mov    %esp,%ebp
80105d23:	57                   	push   %edi
80105d24:	8b 55 08             	mov    0x8(%ebp),%edx
80105d27:	8b 4d 10             	mov    0x10(%ebp),%ecx
80105d2a:	53                   	push   %ebx
80105d2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80105d2e:	89 d7                	mov    %edx,%edi
80105d30:	09 cf                	or     %ecx,%edi
80105d32:	83 e7 03             	and    $0x3,%edi
80105d35:	75 29                	jne    80105d60 <memset+0x40>
    c &= 0xFF;
80105d37:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80105d3a:	c1 e0 18             	shl    $0x18,%eax
80105d3d:	89 fb                	mov    %edi,%ebx
80105d3f:	c1 e9 02             	shr    $0x2,%ecx
80105d42:	c1 e3 10             	shl    $0x10,%ebx
80105d45:	09 d8                	or     %ebx,%eax
80105d47:	09 f8                	or     %edi,%eax
80105d49:	c1 e7 08             	shl    $0x8,%edi
80105d4c:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80105d4e:	89 d7                	mov    %edx,%edi
80105d50:	fc                   	cld    
80105d51:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80105d53:	5b                   	pop    %ebx
80105d54:	89 d0                	mov    %edx,%eax
80105d56:	5f                   	pop    %edi
80105d57:	5d                   	pop    %ebp
80105d58:	c3                   	ret    
80105d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80105d60:	89 d7                	mov    %edx,%edi
80105d62:	fc                   	cld    
80105d63:	f3 aa                	rep stos %al,%es:(%edi)
80105d65:	5b                   	pop    %ebx
80105d66:	89 d0                	mov    %edx,%eax
80105d68:	5f                   	pop    %edi
80105d69:	5d                   	pop    %ebp
80105d6a:	c3                   	ret    
80105d6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105d6f:	90                   	nop

80105d70 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105d70:	55                   	push   %ebp
80105d71:	89 e5                	mov    %esp,%ebp
80105d73:	56                   	push   %esi
80105d74:	8b 75 10             	mov    0x10(%ebp),%esi
80105d77:	8b 55 08             	mov    0x8(%ebp),%edx
80105d7a:	53                   	push   %ebx
80105d7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80105d7e:	85 f6                	test   %esi,%esi
80105d80:	74 2e                	je     80105db0 <memcmp+0x40>
80105d82:	01 c6                	add    %eax,%esi
80105d84:	eb 14                	jmp    80105d9a <memcmp+0x2a>
80105d86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d8d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80105d90:	83 c0 01             	add    $0x1,%eax
80105d93:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80105d96:	39 f0                	cmp    %esi,%eax
80105d98:	74 16                	je     80105db0 <memcmp+0x40>
    if(*s1 != *s2)
80105d9a:	0f b6 0a             	movzbl (%edx),%ecx
80105d9d:	0f b6 18             	movzbl (%eax),%ebx
80105da0:	38 d9                	cmp    %bl,%cl
80105da2:	74 ec                	je     80105d90 <memcmp+0x20>
      return *s1 - *s2;
80105da4:	0f b6 c1             	movzbl %cl,%eax
80105da7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80105da9:	5b                   	pop    %ebx
80105daa:	5e                   	pop    %esi
80105dab:	5d                   	pop    %ebp
80105dac:	c3                   	ret    
80105dad:	8d 76 00             	lea    0x0(%esi),%esi
80105db0:	5b                   	pop    %ebx
  return 0;
80105db1:	31 c0                	xor    %eax,%eax
}
80105db3:	5e                   	pop    %esi
80105db4:	5d                   	pop    %ebp
80105db5:	c3                   	ret    
80105db6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dbd:	8d 76 00             	lea    0x0(%esi),%esi

80105dc0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105dc0:	55                   	push   %ebp
80105dc1:	89 e5                	mov    %esp,%ebp
80105dc3:	57                   	push   %edi
80105dc4:	8b 55 08             	mov    0x8(%ebp),%edx
80105dc7:	8b 4d 10             	mov    0x10(%ebp),%ecx
80105dca:	56                   	push   %esi
80105dcb:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80105dce:	39 d6                	cmp    %edx,%esi
80105dd0:	73 26                	jae    80105df8 <memmove+0x38>
80105dd2:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80105dd5:	39 fa                	cmp    %edi,%edx
80105dd7:	73 1f                	jae    80105df8 <memmove+0x38>
80105dd9:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80105ddc:	85 c9                	test   %ecx,%ecx
80105dde:	74 0c                	je     80105dec <memmove+0x2c>
      *--d = *--s;
80105de0:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80105de4:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80105de7:	83 e8 01             	sub    $0x1,%eax
80105dea:	73 f4                	jae    80105de0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80105dec:	5e                   	pop    %esi
80105ded:	89 d0                	mov    %edx,%eax
80105def:	5f                   	pop    %edi
80105df0:	5d                   	pop    %ebp
80105df1:	c3                   	ret    
80105df2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80105df8:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80105dfb:	89 d7                	mov    %edx,%edi
80105dfd:	85 c9                	test   %ecx,%ecx
80105dff:	74 eb                	je     80105dec <memmove+0x2c>
80105e01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80105e08:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80105e09:	39 c6                	cmp    %eax,%esi
80105e0b:	75 fb                	jne    80105e08 <memmove+0x48>
}
80105e0d:	5e                   	pop    %esi
80105e0e:	89 d0                	mov    %edx,%eax
80105e10:	5f                   	pop    %edi
80105e11:	5d                   	pop    %ebp
80105e12:	c3                   	ret    
80105e13:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105e20 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80105e20:	eb 9e                	jmp    80105dc0 <memmove>
80105e22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105e30 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80105e30:	55                   	push   %ebp
80105e31:	89 e5                	mov    %esp,%ebp
80105e33:	56                   	push   %esi
80105e34:	8b 75 10             	mov    0x10(%ebp),%esi
80105e37:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105e3a:	53                   	push   %ebx
80105e3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
80105e3e:	85 f6                	test   %esi,%esi
80105e40:	74 2e                	je     80105e70 <strncmp+0x40>
80105e42:	01 d6                	add    %edx,%esi
80105e44:	eb 18                	jmp    80105e5e <strncmp+0x2e>
80105e46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e4d:	8d 76 00             	lea    0x0(%esi),%esi
80105e50:	38 d8                	cmp    %bl,%al
80105e52:	75 14                	jne    80105e68 <strncmp+0x38>
    n--, p++, q++;
80105e54:	83 c2 01             	add    $0x1,%edx
80105e57:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80105e5a:	39 f2                	cmp    %esi,%edx
80105e5c:	74 12                	je     80105e70 <strncmp+0x40>
80105e5e:	0f b6 01             	movzbl (%ecx),%eax
80105e61:	0f b6 1a             	movzbl (%edx),%ebx
80105e64:	84 c0                	test   %al,%al
80105e66:	75 e8                	jne    80105e50 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80105e68:	29 d8                	sub    %ebx,%eax
}
80105e6a:	5b                   	pop    %ebx
80105e6b:	5e                   	pop    %esi
80105e6c:	5d                   	pop    %ebp
80105e6d:	c3                   	ret    
80105e6e:	66 90                	xchg   %ax,%ax
80105e70:	5b                   	pop    %ebx
    return 0;
80105e71:	31 c0                	xor    %eax,%eax
}
80105e73:	5e                   	pop    %esi
80105e74:	5d                   	pop    %ebp
80105e75:	c3                   	ret    
80105e76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e7d:	8d 76 00             	lea    0x0(%esi),%esi

80105e80 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105e80:	55                   	push   %ebp
80105e81:	89 e5                	mov    %esp,%ebp
80105e83:	57                   	push   %edi
80105e84:	56                   	push   %esi
80105e85:	8b 75 08             	mov    0x8(%ebp),%esi
80105e88:	53                   	push   %ebx
80105e89:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80105e8c:	89 f0                	mov    %esi,%eax
80105e8e:	eb 15                	jmp    80105ea5 <strncpy+0x25>
80105e90:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80105e94:	8b 7d 0c             	mov    0xc(%ebp),%edi
80105e97:	83 c0 01             	add    $0x1,%eax
80105e9a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
80105e9e:	88 50 ff             	mov    %dl,-0x1(%eax)
80105ea1:	84 d2                	test   %dl,%dl
80105ea3:	74 09                	je     80105eae <strncpy+0x2e>
80105ea5:	89 cb                	mov    %ecx,%ebx
80105ea7:	83 e9 01             	sub    $0x1,%ecx
80105eaa:	85 db                	test   %ebx,%ebx
80105eac:	7f e2                	jg     80105e90 <strncpy+0x10>
    ;
  while(n-- > 0)
80105eae:	89 c2                	mov    %eax,%edx
80105eb0:	85 c9                	test   %ecx,%ecx
80105eb2:	7e 17                	jle    80105ecb <strncpy+0x4b>
80105eb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80105eb8:	83 c2 01             	add    $0x1,%edx
80105ebb:	89 c1                	mov    %eax,%ecx
80105ebd:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80105ec1:	29 d1                	sub    %edx,%ecx
80105ec3:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80105ec7:	85 c9                	test   %ecx,%ecx
80105ec9:	7f ed                	jg     80105eb8 <strncpy+0x38>
  return os;
}
80105ecb:	5b                   	pop    %ebx
80105ecc:	89 f0                	mov    %esi,%eax
80105ece:	5e                   	pop    %esi
80105ecf:	5f                   	pop    %edi
80105ed0:	5d                   	pop    %ebp
80105ed1:	c3                   	ret    
80105ed2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105ee0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105ee0:	55                   	push   %ebp
80105ee1:	89 e5                	mov    %esp,%ebp
80105ee3:	56                   	push   %esi
80105ee4:	8b 55 10             	mov    0x10(%ebp),%edx
80105ee7:	8b 75 08             	mov    0x8(%ebp),%esi
80105eea:	53                   	push   %ebx
80105eeb:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80105eee:	85 d2                	test   %edx,%edx
80105ef0:	7e 25                	jle    80105f17 <safestrcpy+0x37>
80105ef2:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80105ef6:	89 f2                	mov    %esi,%edx
80105ef8:	eb 16                	jmp    80105f10 <safestrcpy+0x30>
80105efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105f00:	0f b6 08             	movzbl (%eax),%ecx
80105f03:	83 c0 01             	add    $0x1,%eax
80105f06:	83 c2 01             	add    $0x1,%edx
80105f09:	88 4a ff             	mov    %cl,-0x1(%edx)
80105f0c:	84 c9                	test   %cl,%cl
80105f0e:	74 04                	je     80105f14 <safestrcpy+0x34>
80105f10:	39 d8                	cmp    %ebx,%eax
80105f12:	75 ec                	jne    80105f00 <safestrcpy+0x20>
    ;
  *s = 0;
80105f14:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80105f17:	89 f0                	mov    %esi,%eax
80105f19:	5b                   	pop    %ebx
80105f1a:	5e                   	pop    %esi
80105f1b:	5d                   	pop    %ebp
80105f1c:	c3                   	ret    
80105f1d:	8d 76 00             	lea    0x0(%esi),%esi

80105f20 <strlen>:

int
strlen(const char *s)
{
80105f20:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105f21:	31 c0                	xor    %eax,%eax
{
80105f23:	89 e5                	mov    %esp,%ebp
80105f25:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80105f28:	80 3a 00             	cmpb   $0x0,(%edx)
80105f2b:	74 0c                	je     80105f39 <strlen+0x19>
80105f2d:	8d 76 00             	lea    0x0(%esi),%esi
80105f30:	83 c0 01             	add    $0x1,%eax
80105f33:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80105f37:	75 f7                	jne    80105f30 <strlen+0x10>
    ;
  return n;
}
80105f39:	5d                   	pop    %ebp
80105f3a:	c3                   	ret    

80105f3b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105f3b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105f3f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80105f43:	55                   	push   %ebp
  pushl %ebx
80105f44:	53                   	push   %ebx
  pushl %esi
80105f45:	56                   	push   %esi
  pushl %edi
80105f46:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105f47:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105f49:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80105f4b:	5f                   	pop    %edi
  popl %esi
80105f4c:	5e                   	pop    %esi
  popl %ebx
80105f4d:	5b                   	pop    %ebx
  popl %ebp
80105f4e:	5d                   	pop    %ebp
  ret
80105f4f:	c3                   	ret    

80105f50 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105f50:	55                   	push   %ebp
80105f51:	89 e5                	mov    %esp,%ebp
80105f53:	53                   	push   %ebx
80105f54:	83 ec 04             	sub    $0x4,%esp
80105f57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80105f5a:	e8 41 ee ff ff       	call   80104da0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105f5f:	8b 00                	mov    (%eax),%eax
80105f61:	39 d8                	cmp    %ebx,%eax
80105f63:	76 1b                	jbe    80105f80 <fetchint+0x30>
80105f65:	8d 53 04             	lea    0x4(%ebx),%edx
80105f68:	39 d0                	cmp    %edx,%eax
80105f6a:	72 14                	jb     80105f80 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80105f6c:	8b 45 0c             	mov    0xc(%ebp),%eax
80105f6f:	8b 13                	mov    (%ebx),%edx
80105f71:	89 10                	mov    %edx,(%eax)
  return 0;
80105f73:	31 c0                	xor    %eax,%eax
}
80105f75:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105f78:	c9                   	leave  
80105f79:	c3                   	ret    
80105f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105f80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f85:	eb ee                	jmp    80105f75 <fetchint+0x25>
80105f87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f8e:	66 90                	xchg   %ax,%ax

80105f90 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105f90:	55                   	push   %ebp
80105f91:	89 e5                	mov    %esp,%ebp
80105f93:	53                   	push   %ebx
80105f94:	83 ec 04             	sub    $0x4,%esp
80105f97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80105f9a:	e8 01 ee ff ff       	call   80104da0 <myproc>

  if(addr >= curproc->sz)
80105f9f:	39 18                	cmp    %ebx,(%eax)
80105fa1:	76 2d                	jbe    80105fd0 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80105fa3:	8b 55 0c             	mov    0xc(%ebp),%edx
80105fa6:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80105fa8:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80105faa:	39 d3                	cmp    %edx,%ebx
80105fac:	73 22                	jae    80105fd0 <fetchstr+0x40>
80105fae:	89 d8                	mov    %ebx,%eax
80105fb0:	eb 0d                	jmp    80105fbf <fetchstr+0x2f>
80105fb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105fb8:	83 c0 01             	add    $0x1,%eax
80105fbb:	39 c2                	cmp    %eax,%edx
80105fbd:	76 11                	jbe    80105fd0 <fetchstr+0x40>
    if(*s == 0)
80105fbf:	80 38 00             	cmpb   $0x0,(%eax)
80105fc2:	75 f4                	jne    80105fb8 <fetchstr+0x28>
      return s - *pp;
80105fc4:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80105fc6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105fc9:	c9                   	leave  
80105fca:	c3                   	ret    
80105fcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105fcf:	90                   	nop
80105fd0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80105fd3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105fd8:	c9                   	leave  
80105fd9:	c3                   	ret    
80105fda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105fe0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105fe0:	55                   	push   %ebp
80105fe1:	89 e5                	mov    %esp,%ebp
80105fe3:	56                   	push   %esi
80105fe4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105fe5:	e8 b6 ed ff ff       	call   80104da0 <myproc>
80105fea:	8b 55 08             	mov    0x8(%ebp),%edx
80105fed:	8b 40 18             	mov    0x18(%eax),%eax
80105ff0:	8b 40 44             	mov    0x44(%eax),%eax
80105ff3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105ff6:	e8 a5 ed ff ff       	call   80104da0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105ffb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105ffe:	8b 00                	mov    (%eax),%eax
80106000:	39 c6                	cmp    %eax,%esi
80106002:	73 1c                	jae    80106020 <argint+0x40>
80106004:	8d 53 08             	lea    0x8(%ebx),%edx
80106007:	39 d0                	cmp    %edx,%eax
80106009:	72 15                	jb     80106020 <argint+0x40>
  *ip = *(int*)(addr);
8010600b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010600e:	8b 53 04             	mov    0x4(%ebx),%edx
80106011:	89 10                	mov    %edx,(%eax)
  return 0;
80106013:	31 c0                	xor    %eax,%eax
}
80106015:	5b                   	pop    %ebx
80106016:	5e                   	pop    %esi
80106017:	5d                   	pop    %ebp
80106018:	c3                   	ret    
80106019:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106020:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80106025:	eb ee                	jmp    80106015 <argint+0x35>
80106027:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010602e:	66 90                	xchg   %ax,%ax

80106030 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80106030:	55                   	push   %ebp
80106031:	89 e5                	mov    %esp,%ebp
80106033:	57                   	push   %edi
80106034:	56                   	push   %esi
80106035:	53                   	push   %ebx
80106036:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80106039:	e8 62 ed ff ff       	call   80104da0 <myproc>
8010603e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80106040:	e8 5b ed ff ff       	call   80104da0 <myproc>
80106045:	8b 55 08             	mov    0x8(%ebp),%edx
80106048:	8b 40 18             	mov    0x18(%eax),%eax
8010604b:	8b 40 44             	mov    0x44(%eax),%eax
8010604e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80106051:	e8 4a ed ff ff       	call   80104da0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80106056:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80106059:	8b 00                	mov    (%eax),%eax
8010605b:	39 c7                	cmp    %eax,%edi
8010605d:	73 31                	jae    80106090 <argptr+0x60>
8010605f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80106062:	39 c8                	cmp    %ecx,%eax
80106064:	72 2a                	jb     80106090 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80106066:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80106069:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
8010606c:	85 d2                	test   %edx,%edx
8010606e:	78 20                	js     80106090 <argptr+0x60>
80106070:	8b 16                	mov    (%esi),%edx
80106072:	39 c2                	cmp    %eax,%edx
80106074:	76 1a                	jbe    80106090 <argptr+0x60>
80106076:	8b 5d 10             	mov    0x10(%ebp),%ebx
80106079:	01 c3                	add    %eax,%ebx
8010607b:	39 da                	cmp    %ebx,%edx
8010607d:	72 11                	jb     80106090 <argptr+0x60>
    return -1;
  *pp = (char*)i;
8010607f:	8b 55 0c             	mov    0xc(%ebp),%edx
80106082:	89 02                	mov    %eax,(%edx)
  return 0;
80106084:	31 c0                	xor    %eax,%eax
}
80106086:	83 c4 0c             	add    $0xc,%esp
80106089:	5b                   	pop    %ebx
8010608a:	5e                   	pop    %esi
8010608b:	5f                   	pop    %edi
8010608c:	5d                   	pop    %ebp
8010608d:	c3                   	ret    
8010608e:	66 90                	xchg   %ax,%ax
    return -1;
80106090:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106095:	eb ef                	jmp    80106086 <argptr+0x56>
80106097:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010609e:	66 90                	xchg   %ax,%ax

801060a0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801060a0:	55                   	push   %ebp
801060a1:	89 e5                	mov    %esp,%ebp
801060a3:	56                   	push   %esi
801060a4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801060a5:	e8 f6 ec ff ff       	call   80104da0 <myproc>
801060aa:	8b 55 08             	mov    0x8(%ebp),%edx
801060ad:	8b 40 18             	mov    0x18(%eax),%eax
801060b0:	8b 40 44             	mov    0x44(%eax),%eax
801060b3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801060b6:	e8 e5 ec ff ff       	call   80104da0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801060bb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801060be:	8b 00                	mov    (%eax),%eax
801060c0:	39 c6                	cmp    %eax,%esi
801060c2:	73 44                	jae    80106108 <argstr+0x68>
801060c4:	8d 53 08             	lea    0x8(%ebx),%edx
801060c7:	39 d0                	cmp    %edx,%eax
801060c9:	72 3d                	jb     80106108 <argstr+0x68>
  *ip = *(int*)(addr);
801060cb:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
801060ce:	e8 cd ec ff ff       	call   80104da0 <myproc>
  if(addr >= curproc->sz)
801060d3:	3b 18                	cmp    (%eax),%ebx
801060d5:	73 31                	jae    80106108 <argstr+0x68>
  *pp = (char*)addr;
801060d7:	8b 55 0c             	mov    0xc(%ebp),%edx
801060da:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
801060dc:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
801060de:	39 d3                	cmp    %edx,%ebx
801060e0:	73 26                	jae    80106108 <argstr+0x68>
801060e2:	89 d8                	mov    %ebx,%eax
801060e4:	eb 11                	jmp    801060f7 <argstr+0x57>
801060e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060ed:	8d 76 00             	lea    0x0(%esi),%esi
801060f0:	83 c0 01             	add    $0x1,%eax
801060f3:	39 c2                	cmp    %eax,%edx
801060f5:	76 11                	jbe    80106108 <argstr+0x68>
    if(*s == 0)
801060f7:	80 38 00             	cmpb   $0x0,(%eax)
801060fa:	75 f4                	jne    801060f0 <argstr+0x50>
      return s - *pp;
801060fc:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
801060fe:	5b                   	pop    %ebx
801060ff:	5e                   	pop    %esi
80106100:	5d                   	pop    %ebp
80106101:	c3                   	ret    
80106102:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106108:	5b                   	pop    %ebx
    return -1;
80106109:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010610e:	5e                   	pop    %esi
8010610f:	5d                   	pop    %ebp
80106110:	c3                   	ret    
80106111:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106118:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010611f:	90                   	nop

80106120 <syscall>:
[SYS_list_all_processes] sys_list_all_processes,
};

void
syscall(void)
{
80106120:	55                   	push   %ebp
80106121:	89 e5                	mov    %esp,%ebp
80106123:	53                   	push   %ebx
80106124:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80106127:	e8 74 ec ff ff       	call   80104da0 <myproc>
8010612c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010612e:	8b 40 18             	mov    0x18(%eax),%eax
80106131:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80106134:	8d 50 ff             	lea    -0x1(%eax),%edx
80106137:	83 fa 19             	cmp    $0x19,%edx
8010613a:	77 24                	ja     80106160 <syscall+0x40>
8010613c:	8b 14 85 a0 93 10 80 	mov    -0x7fef6c60(,%eax,4),%edx
80106143:	85 d2                	test   %edx,%edx
80106145:	74 19                	je     80106160 <syscall+0x40>
    curproc->syscall_count++;
80106147:	83 43 7c 01          	addl   $0x1,0x7c(%ebx)
    curproc->syscall_history[num-1]++;
8010614b:	83 44 83 7c 01       	addl   $0x1,0x7c(%ebx,%eax,4)
    curproc->tf->eax = syscalls[num]();
80106150:	ff d2                	call   *%edx
80106152:	89 c2                	mov    %eax,%edx
80106154:	8b 43 18             	mov    0x18(%ebx),%eax
80106157:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
8010615a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010615d:	c9                   	leave  
8010615e:	c3                   	ret    
8010615f:	90                   	nop
    cprintf("%d %s: unknown sys call %d\n",
80106160:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80106161:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80106164:	50                   	push   %eax
80106165:	ff 73 10             	push   0x10(%ebx)
80106168:	68 69 93 10 80       	push   $0x80109369
8010616d:	e8 8e a5 ff ff       	call   80100700 <cprintf>
    curproc->tf->eax = -1;
80106172:	8b 43 18             	mov    0x18(%ebx),%eax
80106175:	83 c4 10             	add    $0x10,%esp
80106178:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
8010617f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106182:	c9                   	leave  
80106183:	c3                   	ret    
80106184:	66 90                	xchg   %ax,%ax
80106186:	66 90                	xchg   %ax,%ax
80106188:	66 90                	xchg   %ax,%ax
8010618a:	66 90                	xchg   %ax,%ax
8010618c:	66 90                	xchg   %ax,%ax
8010618e:	66 90                	xchg   %ax,%ax

80106190 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80106190:	55                   	push   %ebp
80106191:	89 e5                	mov    %esp,%ebp
80106193:	57                   	push   %edi
80106194:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80106195:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80106198:	53                   	push   %ebx
80106199:	83 ec 34             	sub    $0x34,%esp
8010619c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010619f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
801061a2:	57                   	push   %edi
801061a3:	50                   	push   %eax
{
801061a4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801061a7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
801061aa:	e8 21 d3 ff ff       	call   801034d0 <nameiparent>
801061af:	83 c4 10             	add    $0x10,%esp
801061b2:	85 c0                	test   %eax,%eax
801061b4:	0f 84 46 01 00 00    	je     80106300 <create+0x170>
    return 0;
  ilock(dp);
801061ba:	83 ec 0c             	sub    $0xc,%esp
801061bd:	89 c3                	mov    %eax,%ebx
801061bf:	50                   	push   %eax
801061c0:	e8 cb c9 ff ff       	call   80102b90 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
801061c5:	83 c4 0c             	add    $0xc,%esp
801061c8:	6a 00                	push   $0x0
801061ca:	57                   	push   %edi
801061cb:	53                   	push   %ebx
801061cc:	e8 1f cf ff ff       	call   801030f0 <dirlookup>
801061d1:	83 c4 10             	add    $0x10,%esp
801061d4:	89 c6                	mov    %eax,%esi
801061d6:	85 c0                	test   %eax,%eax
801061d8:	74 56                	je     80106230 <create+0xa0>
    iunlockput(dp);
801061da:	83 ec 0c             	sub    $0xc,%esp
801061dd:	53                   	push   %ebx
801061de:	e8 3d cc ff ff       	call   80102e20 <iunlockput>
    ilock(ip);
801061e3:	89 34 24             	mov    %esi,(%esp)
801061e6:	e8 a5 c9 ff ff       	call   80102b90 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801061eb:	83 c4 10             	add    $0x10,%esp
801061ee:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801061f3:	75 1b                	jne    80106210 <create+0x80>
801061f5:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
801061fa:	75 14                	jne    80106210 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801061fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801061ff:	89 f0                	mov    %esi,%eax
80106201:	5b                   	pop    %ebx
80106202:	5e                   	pop    %esi
80106203:	5f                   	pop    %edi
80106204:	5d                   	pop    %ebp
80106205:	c3                   	ret    
80106206:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010620d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80106210:	83 ec 0c             	sub    $0xc,%esp
80106213:	56                   	push   %esi
    return 0;
80106214:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80106216:	e8 05 cc ff ff       	call   80102e20 <iunlockput>
    return 0;
8010621b:	83 c4 10             	add    $0x10,%esp
}
8010621e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106221:	89 f0                	mov    %esi,%eax
80106223:	5b                   	pop    %ebx
80106224:	5e                   	pop    %esi
80106225:	5f                   	pop    %edi
80106226:	5d                   	pop    %ebp
80106227:	c3                   	ret    
80106228:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010622f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80106230:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80106234:	83 ec 08             	sub    $0x8,%esp
80106237:	50                   	push   %eax
80106238:	ff 33                	push   (%ebx)
8010623a:	e8 e1 c7 ff ff       	call   80102a20 <ialloc>
8010623f:	83 c4 10             	add    $0x10,%esp
80106242:	89 c6                	mov    %eax,%esi
80106244:	85 c0                	test   %eax,%eax
80106246:	0f 84 cd 00 00 00    	je     80106319 <create+0x189>
  ilock(ip);
8010624c:	83 ec 0c             	sub    $0xc,%esp
8010624f:	50                   	push   %eax
80106250:	e8 3b c9 ff ff       	call   80102b90 <ilock>
  ip->major = major;
80106255:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80106259:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010625d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80106261:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80106265:	b8 01 00 00 00       	mov    $0x1,%eax
8010626a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010626e:	89 34 24             	mov    %esi,(%esp)
80106271:	e8 6a c8 ff ff       	call   80102ae0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80106276:	83 c4 10             	add    $0x10,%esp
80106279:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010627e:	74 30                	je     801062b0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80106280:	83 ec 04             	sub    $0x4,%esp
80106283:	ff 76 04             	push   0x4(%esi)
80106286:	57                   	push   %edi
80106287:	53                   	push   %ebx
80106288:	e8 63 d1 ff ff       	call   801033f0 <dirlink>
8010628d:	83 c4 10             	add    $0x10,%esp
80106290:	85 c0                	test   %eax,%eax
80106292:	78 78                	js     8010630c <create+0x17c>
  iunlockput(dp);
80106294:	83 ec 0c             	sub    $0xc,%esp
80106297:	53                   	push   %ebx
80106298:	e8 83 cb ff ff       	call   80102e20 <iunlockput>
  return ip;
8010629d:	83 c4 10             	add    $0x10,%esp
}
801062a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801062a3:	89 f0                	mov    %esi,%eax
801062a5:	5b                   	pop    %ebx
801062a6:	5e                   	pop    %esi
801062a7:	5f                   	pop    %edi
801062a8:	5d                   	pop    %ebp
801062a9:	c3                   	ret    
801062aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
801062b0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
801062b3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
801062b8:	53                   	push   %ebx
801062b9:	e8 22 c8 ff ff       	call   80102ae0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801062be:	83 c4 0c             	add    $0xc,%esp
801062c1:	ff 76 04             	push   0x4(%esi)
801062c4:	68 28 94 10 80       	push   $0x80109428
801062c9:	56                   	push   %esi
801062ca:	e8 21 d1 ff ff       	call   801033f0 <dirlink>
801062cf:	83 c4 10             	add    $0x10,%esp
801062d2:	85 c0                	test   %eax,%eax
801062d4:	78 18                	js     801062ee <create+0x15e>
801062d6:	83 ec 04             	sub    $0x4,%esp
801062d9:	ff 73 04             	push   0x4(%ebx)
801062dc:	68 27 94 10 80       	push   $0x80109427
801062e1:	56                   	push   %esi
801062e2:	e8 09 d1 ff ff       	call   801033f0 <dirlink>
801062e7:	83 c4 10             	add    $0x10,%esp
801062ea:	85 c0                	test   %eax,%eax
801062ec:	79 92                	jns    80106280 <create+0xf0>
      panic("create dots");
801062ee:	83 ec 0c             	sub    $0xc,%esp
801062f1:	68 1b 94 10 80       	push   $0x8010941b
801062f6:	e8 85 a0 ff ff       	call   80100380 <panic>
801062fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801062ff:	90                   	nop
}
80106300:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80106303:	31 f6                	xor    %esi,%esi
}
80106305:	5b                   	pop    %ebx
80106306:	89 f0                	mov    %esi,%eax
80106308:	5e                   	pop    %esi
80106309:	5f                   	pop    %edi
8010630a:	5d                   	pop    %ebp
8010630b:	c3                   	ret    
    panic("create: dirlink");
8010630c:	83 ec 0c             	sub    $0xc,%esp
8010630f:	68 2a 94 10 80       	push   $0x8010942a
80106314:	e8 67 a0 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80106319:	83 ec 0c             	sub    $0xc,%esp
8010631c:	68 0c 94 10 80       	push   $0x8010940c
80106321:	e8 5a a0 ff ff       	call   80100380 <panic>
80106326:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010632d:	8d 76 00             	lea    0x0(%esi),%esi

80106330 <create_full_pathchar>:
void create_full_pathchar(char* full_path, char* dir, char* filename) {
80106330:	55                   	push   %ebp
80106331:	89 e5                	mov    %esp,%ebp
80106333:	56                   	push   %esi
80106334:	8b 45 08             	mov    0x8(%ebp),%eax
80106337:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010633a:	53                   	push   %ebx
8010633b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    while (*dir) {
8010633e:	0f b6 13             	movzbl (%ebx),%edx
80106341:	84 d2                	test   %dl,%dl
80106343:	74 4b                	je     80106390 <create_full_pathchar+0x60>
80106345:	8d 76 00             	lea    0x0(%esi),%esi
        *p++ = *dir++;
80106348:	83 c3 01             	add    $0x1,%ebx
8010634b:	89 d6                	mov    %edx,%esi
8010634d:	88 10                	mov    %dl,(%eax)
8010634f:	83 c0 01             	add    $0x1,%eax
    while (*dir) {
80106352:	0f b6 13             	movzbl (%ebx),%edx
80106355:	84 d2                	test   %dl,%dl
80106357:	75 ef                	jne    80106348 <create_full_pathchar+0x18>
    if (*(p - 1) != '/') {
80106359:	89 f3                	mov    %esi,%ebx
8010635b:	80 fb 2f             	cmp    $0x2f,%bl
8010635e:	74 18                	je     80106378 <create_full_pathchar+0x48>
        *p++ = '/';
80106360:	c6 00 2f             	movb   $0x2f,(%eax)
80106363:	83 c0 01             	add    $0x1,%eax
    while (*filename) {
80106366:	eb 10                	jmp    80106378 <create_full_pathchar+0x48>
80106368:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010636f:	90                   	nop
        *p++ = *filename++;
80106370:	88 10                	mov    %dl,(%eax)
80106372:	83 c0 01             	add    $0x1,%eax
80106375:	83 c1 01             	add    $0x1,%ecx
    while (*filename) {
80106378:	0f b6 11             	movzbl (%ecx),%edx
8010637b:	84 d2                	test   %dl,%dl
8010637d:	75 f1                	jne    80106370 <create_full_pathchar+0x40>
    *p = '\0';
8010637f:	c6 00 00             	movb   $0x0,(%eax)
}
80106382:	5b                   	pop    %ebx
80106383:	5e                   	pop    %esi
80106384:	5d                   	pop    %ebp
80106385:	c3                   	ret    
80106386:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010638d:	8d 76 00             	lea    0x0(%esi),%esi
    if (*(p - 1) != '/') {
80106390:	0f b6 70 ff          	movzbl -0x1(%eax),%esi
80106394:	eb c3                	jmp    80106359 <create_full_pathchar+0x29>
80106396:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010639d:	8d 76 00             	lea    0x0(%esi),%esi

801063a0 <remove_file>:
int remove_file(struct inode *dp, char *name) {
801063a0:	55                   	push   %ebp
801063a1:	89 e5                	mov    %esp,%ebp
801063a3:	57                   	push   %edi
801063a4:	56                   	push   %esi
801063a5:	53                   	push   %ebx
801063a6:	83 ec 2c             	sub    $0x2c,%esp
801063a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
    for (i = 0; i < dp->size; i += sizeof(de)) {
801063ac:	8b 43 58             	mov    0x58(%ebx),%eax
801063af:	85 c0                	test   %eax,%eax
801063b1:	74 44                	je     801063f7 <remove_file+0x57>
801063b3:	31 ff                	xor    %edi,%edi
801063b5:	8d 75 d8             	lea    -0x28(%ebp),%esi
801063b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801063bf:	90                   	nop
        if (readi(dp, (char*)&de, i, sizeof(de)) != sizeof(de)) {
801063c0:	6a 10                	push   $0x10
801063c2:	57                   	push   %edi
801063c3:	56                   	push   %esi
801063c4:	53                   	push   %ebx
801063c5:	e8 d6 ca ff ff       	call   80102ea0 <readi>
801063ca:	83 c4 10             	add    $0x10,%esp
801063cd:	83 f8 10             	cmp    $0x10,%eax
801063d0:	75 76                	jne    80106448 <remove_file+0xa8>
        if (de.inum == 0) {
801063d2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801063d7:	74 16                	je     801063ef <remove_file+0x4f>
        if (namecmp(name, de.name) == 0) {
801063d9:	83 ec 08             	sub    $0x8,%esp
801063dc:	8d 45 da             	lea    -0x26(%ebp),%eax
801063df:	50                   	push   %eax
801063e0:	ff 75 0c             	push   0xc(%ebp)
801063e3:	e8 e8 cc ff ff       	call   801030d0 <namecmp>
801063e8:	83 c4 10             	add    $0x10,%esp
801063eb:	85 c0                	test   %eax,%eax
801063ed:	74 21                	je     80106410 <remove_file+0x70>
    for (i = 0; i < dp->size; i += sizeof(de)) {
801063ef:	83 c7 10             	add    $0x10,%edi
801063f2:	39 7b 58             	cmp    %edi,0x58(%ebx)
801063f5:	77 c9                	ja     801063c0 <remove_file+0x20>
    return -1;
801063f7:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
}
801063fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801063ff:	89 c8                	mov    %ecx,%eax
80106401:	5b                   	pop    %ebx
80106402:	5e                   	pop    %esi
80106403:	5f                   	pop    %edi
80106404:	5d                   	pop    %ebp
80106405:	c3                   	ret    
80106406:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010640d:	8d 76 00             	lea    0x0(%esi),%esi
            memset(&de, 0, sizeof(de));
80106410:	83 ec 04             	sub    $0x4,%esp
80106413:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80106416:	6a 10                	push   $0x10
80106418:	6a 00                	push   $0x0
8010641a:	56                   	push   %esi
8010641b:	e8 00 f9 ff ff       	call   80105d20 <memset>
            if (writei(dp, (char*)&de, i, sizeof(de)) != sizeof(de)) {
80106420:	6a 10                	push   $0x10
80106422:	57                   	push   %edi
80106423:	56                   	push   %esi
80106424:	53                   	push   %ebx
80106425:	e8 76 cb ff ff       	call   80102fa0 <writei>
8010642a:	83 c4 20             	add    $0x20,%esp
8010642d:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
80106430:	83 f8 10             	cmp    $0x10,%eax
80106433:	74 c7                	je     801063fc <remove_file+0x5c>
                panic("remove_file: writei");
80106435:	83 ec 0c             	sub    $0xc,%esp
80106438:	68 4d 94 10 80       	push   $0x8010944d
8010643d:	e8 3e 9f ff ff       	call   80100380 <panic>
80106442:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            panic("remove_file: readi");
80106448:	83 ec 0c             	sub    $0xc,%esp
8010644b:	68 3a 94 10 80       	push   $0x8010943a
80106450:	e8 2b 9f ff ff       	call   80100380 <panic>
80106455:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010645c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106460 <sys_dup>:
{
80106460:	55                   	push   %ebp
80106461:	89 e5                	mov    %esp,%ebp
80106463:	56                   	push   %esi
80106464:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80106465:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106468:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010646b:	50                   	push   %eax
8010646c:	6a 00                	push   $0x0
8010646e:	e8 6d fb ff ff       	call   80105fe0 <argint>
80106473:	83 c4 10             	add    $0x10,%esp
80106476:	85 c0                	test   %eax,%eax
80106478:	78 36                	js     801064b0 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010647a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010647e:	77 30                	ja     801064b0 <sys_dup+0x50>
80106480:	e8 1b e9 ff ff       	call   80104da0 <myproc>
80106485:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106488:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010648c:	85 f6                	test   %esi,%esi
8010648e:	74 20                	je     801064b0 <sys_dup+0x50>
  struct proc *curproc = myproc();
80106490:	e8 0b e9 ff ff       	call   80104da0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80106495:	31 db                	xor    %ebx,%ebx
80106497:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010649e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
801064a0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801064a4:	85 d2                	test   %edx,%edx
801064a6:	74 18                	je     801064c0 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
801064a8:	83 c3 01             	add    $0x1,%ebx
801064ab:	83 fb 10             	cmp    $0x10,%ebx
801064ae:	75 f0                	jne    801064a0 <sys_dup+0x40>
}
801064b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801064b3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801064b8:	89 d8                	mov    %ebx,%eax
801064ba:	5b                   	pop    %ebx
801064bb:	5e                   	pop    %esi
801064bc:	5d                   	pop    %ebp
801064bd:	c3                   	ret    
801064be:	66 90                	xchg   %ax,%ax
  filedup(f);
801064c0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801064c3:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
801064c7:	56                   	push   %esi
801064c8:	e8 e3 bd ff ff       	call   801022b0 <filedup>
  return fd;
801064cd:	83 c4 10             	add    $0x10,%esp
}
801064d0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801064d3:	89 d8                	mov    %ebx,%eax
801064d5:	5b                   	pop    %ebx
801064d6:	5e                   	pop    %esi
801064d7:	5d                   	pop    %ebp
801064d8:	c3                   	ret    
801064d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801064e0 <sys_read>:
{
801064e0:	55                   	push   %ebp
801064e1:	89 e5                	mov    %esp,%ebp
801064e3:	56                   	push   %esi
801064e4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801064e5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801064e8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801064eb:	53                   	push   %ebx
801064ec:	6a 00                	push   $0x0
801064ee:	e8 ed fa ff ff       	call   80105fe0 <argint>
801064f3:	83 c4 10             	add    $0x10,%esp
801064f6:	85 c0                	test   %eax,%eax
801064f8:	78 5e                	js     80106558 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801064fa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801064fe:	77 58                	ja     80106558 <sys_read+0x78>
80106500:	e8 9b e8 ff ff       	call   80104da0 <myproc>
80106505:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106508:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010650c:	85 f6                	test   %esi,%esi
8010650e:	74 48                	je     80106558 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106510:	83 ec 08             	sub    $0x8,%esp
80106513:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106516:	50                   	push   %eax
80106517:	6a 02                	push   $0x2
80106519:	e8 c2 fa ff ff       	call   80105fe0 <argint>
8010651e:	83 c4 10             	add    $0x10,%esp
80106521:	85 c0                	test   %eax,%eax
80106523:	78 33                	js     80106558 <sys_read+0x78>
80106525:	83 ec 04             	sub    $0x4,%esp
80106528:	ff 75 f0             	push   -0x10(%ebp)
8010652b:	53                   	push   %ebx
8010652c:	6a 01                	push   $0x1
8010652e:	e8 fd fa ff ff       	call   80106030 <argptr>
80106533:	83 c4 10             	add    $0x10,%esp
80106536:	85 c0                	test   %eax,%eax
80106538:	78 1e                	js     80106558 <sys_read+0x78>
  return fileread(f, p, n);
8010653a:	83 ec 04             	sub    $0x4,%esp
8010653d:	ff 75 f0             	push   -0x10(%ebp)
80106540:	ff 75 f4             	push   -0xc(%ebp)
80106543:	56                   	push   %esi
80106544:	e8 e7 be ff ff       	call   80102430 <fileread>
80106549:	83 c4 10             	add    $0x10,%esp
}
8010654c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010654f:	5b                   	pop    %ebx
80106550:	5e                   	pop    %esi
80106551:	5d                   	pop    %ebp
80106552:	c3                   	ret    
80106553:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106557:	90                   	nop
    return -1;
80106558:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010655d:	eb ed                	jmp    8010654c <sys_read+0x6c>
8010655f:	90                   	nop

80106560 <sys_write>:
{
80106560:	55                   	push   %ebp
80106561:	89 e5                	mov    %esp,%ebp
80106563:	56                   	push   %esi
80106564:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80106565:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80106568:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010656b:	53                   	push   %ebx
8010656c:	6a 00                	push   $0x0
8010656e:	e8 6d fa ff ff       	call   80105fe0 <argint>
80106573:	83 c4 10             	add    $0x10,%esp
80106576:	85 c0                	test   %eax,%eax
80106578:	78 5e                	js     801065d8 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010657a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010657e:	77 58                	ja     801065d8 <sys_write+0x78>
80106580:	e8 1b e8 ff ff       	call   80104da0 <myproc>
80106585:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106588:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010658c:	85 f6                	test   %esi,%esi
8010658e:	74 48                	je     801065d8 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106590:	83 ec 08             	sub    $0x8,%esp
80106593:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106596:	50                   	push   %eax
80106597:	6a 02                	push   $0x2
80106599:	e8 42 fa ff ff       	call   80105fe0 <argint>
8010659e:	83 c4 10             	add    $0x10,%esp
801065a1:	85 c0                	test   %eax,%eax
801065a3:	78 33                	js     801065d8 <sys_write+0x78>
801065a5:	83 ec 04             	sub    $0x4,%esp
801065a8:	ff 75 f0             	push   -0x10(%ebp)
801065ab:	53                   	push   %ebx
801065ac:	6a 01                	push   $0x1
801065ae:	e8 7d fa ff ff       	call   80106030 <argptr>
801065b3:	83 c4 10             	add    $0x10,%esp
801065b6:	85 c0                	test   %eax,%eax
801065b8:	78 1e                	js     801065d8 <sys_write+0x78>
  return filewrite(f, p, n);
801065ba:	83 ec 04             	sub    $0x4,%esp
801065bd:	ff 75 f0             	push   -0x10(%ebp)
801065c0:	ff 75 f4             	push   -0xc(%ebp)
801065c3:	56                   	push   %esi
801065c4:	e8 f7 be ff ff       	call   801024c0 <filewrite>
801065c9:	83 c4 10             	add    $0x10,%esp
}
801065cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801065cf:	5b                   	pop    %ebx
801065d0:	5e                   	pop    %esi
801065d1:	5d                   	pop    %ebp
801065d2:	c3                   	ret    
801065d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801065d7:	90                   	nop
    return -1;
801065d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065dd:	eb ed                	jmp    801065cc <sys_write+0x6c>
801065df:	90                   	nop

801065e0 <sys_close>:
{
801065e0:	55                   	push   %ebp
801065e1:	89 e5                	mov    %esp,%ebp
801065e3:	56                   	push   %esi
801065e4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801065e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801065e8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801065eb:	50                   	push   %eax
801065ec:	6a 00                	push   $0x0
801065ee:	e8 ed f9 ff ff       	call   80105fe0 <argint>
801065f3:	83 c4 10             	add    $0x10,%esp
801065f6:	85 c0                	test   %eax,%eax
801065f8:	78 3e                	js     80106638 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801065fa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801065fe:	77 38                	ja     80106638 <sys_close+0x58>
80106600:	e8 9b e7 ff ff       	call   80104da0 <myproc>
80106605:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106608:	8d 5a 08             	lea    0x8(%edx),%ebx
8010660b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
8010660f:	85 f6                	test   %esi,%esi
80106611:	74 25                	je     80106638 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80106613:	e8 88 e7 ff ff       	call   80104da0 <myproc>
  fileclose(f);
80106618:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
8010661b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80106622:	00 
  fileclose(f);
80106623:	56                   	push   %esi
80106624:	e8 d7 bc ff ff       	call   80102300 <fileclose>
  return 0;
80106629:	83 c4 10             	add    $0x10,%esp
8010662c:	31 c0                	xor    %eax,%eax
}
8010662e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106631:	5b                   	pop    %ebx
80106632:	5e                   	pop    %esi
80106633:	5d                   	pop    %ebp
80106634:	c3                   	ret    
80106635:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106638:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010663d:	eb ef                	jmp    8010662e <sys_close+0x4e>
8010663f:	90                   	nop

80106640 <sys_fstat>:
{
80106640:	55                   	push   %ebp
80106641:	89 e5                	mov    %esp,%ebp
80106643:	56                   	push   %esi
80106644:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80106645:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80106648:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010664b:	53                   	push   %ebx
8010664c:	6a 00                	push   $0x0
8010664e:	e8 8d f9 ff ff       	call   80105fe0 <argint>
80106653:	83 c4 10             	add    $0x10,%esp
80106656:	85 c0                	test   %eax,%eax
80106658:	78 46                	js     801066a0 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010665a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010665e:	77 40                	ja     801066a0 <sys_fstat+0x60>
80106660:	e8 3b e7 ff ff       	call   80104da0 <myproc>
80106665:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106668:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010666c:	85 f6                	test   %esi,%esi
8010666e:	74 30                	je     801066a0 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80106670:	83 ec 04             	sub    $0x4,%esp
80106673:	6a 14                	push   $0x14
80106675:	53                   	push   %ebx
80106676:	6a 01                	push   $0x1
80106678:	e8 b3 f9 ff ff       	call   80106030 <argptr>
8010667d:	83 c4 10             	add    $0x10,%esp
80106680:	85 c0                	test   %eax,%eax
80106682:	78 1c                	js     801066a0 <sys_fstat+0x60>
  return filestat(f, st);
80106684:	83 ec 08             	sub    $0x8,%esp
80106687:	ff 75 f4             	push   -0xc(%ebp)
8010668a:	56                   	push   %esi
8010668b:	e8 50 bd ff ff       	call   801023e0 <filestat>
80106690:	83 c4 10             	add    $0x10,%esp
}
80106693:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106696:	5b                   	pop    %ebx
80106697:	5e                   	pop    %esi
80106698:	5d                   	pop    %ebp
80106699:	c3                   	ret    
8010669a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801066a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066a5:	eb ec                	jmp    80106693 <sys_fstat+0x53>
801066a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801066ae:	66 90                	xchg   %ax,%ax

801066b0 <sys_link>:
{
801066b0:	55                   	push   %ebp
801066b1:	89 e5                	mov    %esp,%ebp
801066b3:	57                   	push   %edi
801066b4:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801066b5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801066b8:	53                   	push   %ebx
801066b9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801066bc:	50                   	push   %eax
801066bd:	6a 00                	push   $0x0
801066bf:	e8 dc f9 ff ff       	call   801060a0 <argstr>
801066c4:	83 c4 10             	add    $0x10,%esp
801066c7:	85 c0                	test   %eax,%eax
801066c9:	0f 88 fb 00 00 00    	js     801067ca <sys_link+0x11a>
801066cf:	83 ec 08             	sub    $0x8,%esp
801066d2:	8d 45 d0             	lea    -0x30(%ebp),%eax
801066d5:	50                   	push   %eax
801066d6:	6a 01                	push   $0x1
801066d8:	e8 c3 f9 ff ff       	call   801060a0 <argstr>
801066dd:	83 c4 10             	add    $0x10,%esp
801066e0:	85 c0                	test   %eax,%eax
801066e2:	0f 88 e2 00 00 00    	js     801067ca <sys_link+0x11a>
  begin_op();
801066e8:	e8 83 da ff ff       	call   80104170 <begin_op>
  if((ip = namei(old)) == 0){
801066ed:	83 ec 0c             	sub    $0xc,%esp
801066f0:	ff 75 d4             	push   -0x2c(%ebp)
801066f3:	e8 b8 cd ff ff       	call   801034b0 <namei>
801066f8:	83 c4 10             	add    $0x10,%esp
801066fb:	89 c3                	mov    %eax,%ebx
801066fd:	85 c0                	test   %eax,%eax
801066ff:	0f 84 e4 00 00 00    	je     801067e9 <sys_link+0x139>
  ilock(ip);
80106705:	83 ec 0c             	sub    $0xc,%esp
80106708:	50                   	push   %eax
80106709:	e8 82 c4 ff ff       	call   80102b90 <ilock>
  if(ip->type == T_DIR){
8010670e:	83 c4 10             	add    $0x10,%esp
80106711:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80106716:	0f 84 b5 00 00 00    	je     801067d1 <sys_link+0x121>
  iupdate(ip);
8010671c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010671f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80106724:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80106727:	53                   	push   %ebx
80106728:	e8 b3 c3 ff ff       	call   80102ae0 <iupdate>
  iunlock(ip);
8010672d:	89 1c 24             	mov    %ebx,(%esp)
80106730:	e8 3b c5 ff ff       	call   80102c70 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80106735:	58                   	pop    %eax
80106736:	5a                   	pop    %edx
80106737:	57                   	push   %edi
80106738:	ff 75 d0             	push   -0x30(%ebp)
8010673b:	e8 90 cd ff ff       	call   801034d0 <nameiparent>
80106740:	83 c4 10             	add    $0x10,%esp
80106743:	89 c6                	mov    %eax,%esi
80106745:	85 c0                	test   %eax,%eax
80106747:	74 5b                	je     801067a4 <sys_link+0xf4>
  ilock(dp);
80106749:	83 ec 0c             	sub    $0xc,%esp
8010674c:	50                   	push   %eax
8010674d:	e8 3e c4 ff ff       	call   80102b90 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80106752:	8b 03                	mov    (%ebx),%eax
80106754:	83 c4 10             	add    $0x10,%esp
80106757:	39 06                	cmp    %eax,(%esi)
80106759:	75 3d                	jne    80106798 <sys_link+0xe8>
8010675b:	83 ec 04             	sub    $0x4,%esp
8010675e:	ff 73 04             	push   0x4(%ebx)
80106761:	57                   	push   %edi
80106762:	56                   	push   %esi
80106763:	e8 88 cc ff ff       	call   801033f0 <dirlink>
80106768:	83 c4 10             	add    $0x10,%esp
8010676b:	85 c0                	test   %eax,%eax
8010676d:	78 29                	js     80106798 <sys_link+0xe8>
  iunlockput(dp);
8010676f:	83 ec 0c             	sub    $0xc,%esp
80106772:	56                   	push   %esi
80106773:	e8 a8 c6 ff ff       	call   80102e20 <iunlockput>
  iput(ip);
80106778:	89 1c 24             	mov    %ebx,(%esp)
8010677b:	e8 40 c5 ff ff       	call   80102cc0 <iput>
  end_op();
80106780:	e8 5b da ff ff       	call   801041e0 <end_op>
  return 0;
80106785:	83 c4 10             	add    $0x10,%esp
80106788:	31 c0                	xor    %eax,%eax
}
8010678a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010678d:	5b                   	pop    %ebx
8010678e:	5e                   	pop    %esi
8010678f:	5f                   	pop    %edi
80106790:	5d                   	pop    %ebp
80106791:	c3                   	ret    
80106792:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80106798:	83 ec 0c             	sub    $0xc,%esp
8010679b:	56                   	push   %esi
8010679c:	e8 7f c6 ff ff       	call   80102e20 <iunlockput>
    goto bad;
801067a1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801067a4:	83 ec 0c             	sub    $0xc,%esp
801067a7:	53                   	push   %ebx
801067a8:	e8 e3 c3 ff ff       	call   80102b90 <ilock>
  ip->nlink--;
801067ad:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801067b2:	89 1c 24             	mov    %ebx,(%esp)
801067b5:	e8 26 c3 ff ff       	call   80102ae0 <iupdate>
  iunlockput(ip);
801067ba:	89 1c 24             	mov    %ebx,(%esp)
801067bd:	e8 5e c6 ff ff       	call   80102e20 <iunlockput>
  end_op();
801067c2:	e8 19 da ff ff       	call   801041e0 <end_op>
  return -1;
801067c7:	83 c4 10             	add    $0x10,%esp
801067ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067cf:	eb b9                	jmp    8010678a <sys_link+0xda>
    iunlockput(ip);
801067d1:	83 ec 0c             	sub    $0xc,%esp
801067d4:	53                   	push   %ebx
801067d5:	e8 46 c6 ff ff       	call   80102e20 <iunlockput>
    end_op();
801067da:	e8 01 da ff ff       	call   801041e0 <end_op>
    return -1;
801067df:	83 c4 10             	add    $0x10,%esp
801067e2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067e7:	eb a1                	jmp    8010678a <sys_link+0xda>
    end_op();
801067e9:	e8 f2 d9 ff ff       	call   801041e0 <end_op>
    return -1;
801067ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067f3:	eb 95                	jmp    8010678a <sys_link+0xda>
801067f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801067fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106800 <sys_unlink>:
{
80106800:	55                   	push   %ebp
80106801:	89 e5                	mov    %esp,%ebp
80106803:	57                   	push   %edi
80106804:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80106805:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80106808:	53                   	push   %ebx
80106809:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010680c:	50                   	push   %eax
8010680d:	6a 00                	push   $0x0
8010680f:	e8 8c f8 ff ff       	call   801060a0 <argstr>
80106814:	83 c4 10             	add    $0x10,%esp
80106817:	85 c0                	test   %eax,%eax
80106819:	0f 88 7a 01 00 00    	js     80106999 <sys_unlink+0x199>
  begin_op();
8010681f:	e8 4c d9 ff ff       	call   80104170 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80106824:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80106827:	83 ec 08             	sub    $0x8,%esp
8010682a:	53                   	push   %ebx
8010682b:	ff 75 c0             	push   -0x40(%ebp)
8010682e:	e8 9d cc ff ff       	call   801034d0 <nameiparent>
80106833:	83 c4 10             	add    $0x10,%esp
80106836:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80106839:	85 c0                	test   %eax,%eax
8010683b:	0f 84 62 01 00 00    	je     801069a3 <sys_unlink+0x1a3>
  ilock(dp);
80106841:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80106844:	83 ec 0c             	sub    $0xc,%esp
80106847:	57                   	push   %edi
80106848:	e8 43 c3 ff ff       	call   80102b90 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010684d:	58                   	pop    %eax
8010684e:	5a                   	pop    %edx
8010684f:	68 28 94 10 80       	push   $0x80109428
80106854:	53                   	push   %ebx
80106855:	e8 76 c8 ff ff       	call   801030d0 <namecmp>
8010685a:	83 c4 10             	add    $0x10,%esp
8010685d:	85 c0                	test   %eax,%eax
8010685f:	0f 84 fb 00 00 00    	je     80106960 <sys_unlink+0x160>
80106865:	83 ec 08             	sub    $0x8,%esp
80106868:	68 27 94 10 80       	push   $0x80109427
8010686d:	53                   	push   %ebx
8010686e:	e8 5d c8 ff ff       	call   801030d0 <namecmp>
80106873:	83 c4 10             	add    $0x10,%esp
80106876:	85 c0                	test   %eax,%eax
80106878:	0f 84 e2 00 00 00    	je     80106960 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010687e:	83 ec 04             	sub    $0x4,%esp
80106881:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80106884:	50                   	push   %eax
80106885:	53                   	push   %ebx
80106886:	57                   	push   %edi
80106887:	e8 64 c8 ff ff       	call   801030f0 <dirlookup>
8010688c:	83 c4 10             	add    $0x10,%esp
8010688f:	89 c3                	mov    %eax,%ebx
80106891:	85 c0                	test   %eax,%eax
80106893:	0f 84 c7 00 00 00    	je     80106960 <sys_unlink+0x160>
  ilock(ip);
80106899:	83 ec 0c             	sub    $0xc,%esp
8010689c:	50                   	push   %eax
8010689d:	e8 ee c2 ff ff       	call   80102b90 <ilock>
  if(ip->nlink < 1)
801068a2:	83 c4 10             	add    $0x10,%esp
801068a5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801068aa:	0f 8e 1c 01 00 00    	jle    801069cc <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
801068b0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801068b5:	8d 7d d8             	lea    -0x28(%ebp),%edi
801068b8:	74 66                	je     80106920 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801068ba:	83 ec 04             	sub    $0x4,%esp
801068bd:	6a 10                	push   $0x10
801068bf:	6a 00                	push   $0x0
801068c1:	57                   	push   %edi
801068c2:	e8 59 f4 ff ff       	call   80105d20 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801068c7:	6a 10                	push   $0x10
801068c9:	ff 75 c4             	push   -0x3c(%ebp)
801068cc:	57                   	push   %edi
801068cd:	ff 75 b4             	push   -0x4c(%ebp)
801068d0:	e8 cb c6 ff ff       	call   80102fa0 <writei>
801068d5:	83 c4 20             	add    $0x20,%esp
801068d8:	83 f8 10             	cmp    $0x10,%eax
801068db:	0f 85 de 00 00 00    	jne    801069bf <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
801068e1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801068e6:	0f 84 94 00 00 00    	je     80106980 <sys_unlink+0x180>
  iunlockput(dp);
801068ec:	83 ec 0c             	sub    $0xc,%esp
801068ef:	ff 75 b4             	push   -0x4c(%ebp)
801068f2:	e8 29 c5 ff ff       	call   80102e20 <iunlockput>
  ip->nlink--;
801068f7:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801068fc:	89 1c 24             	mov    %ebx,(%esp)
801068ff:	e8 dc c1 ff ff       	call   80102ae0 <iupdate>
  iunlockput(ip);
80106904:	89 1c 24             	mov    %ebx,(%esp)
80106907:	e8 14 c5 ff ff       	call   80102e20 <iunlockput>
  end_op();
8010690c:	e8 cf d8 ff ff       	call   801041e0 <end_op>
  return 0;
80106911:	83 c4 10             	add    $0x10,%esp
80106914:	31 c0                	xor    %eax,%eax
}
80106916:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106919:	5b                   	pop    %ebx
8010691a:	5e                   	pop    %esi
8010691b:	5f                   	pop    %edi
8010691c:	5d                   	pop    %ebp
8010691d:	c3                   	ret    
8010691e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80106920:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80106924:	76 94                	jbe    801068ba <sys_unlink+0xba>
80106926:	be 20 00 00 00       	mov    $0x20,%esi
8010692b:	eb 0b                	jmp    80106938 <sys_unlink+0x138>
8010692d:	8d 76 00             	lea    0x0(%esi),%esi
80106930:	83 c6 10             	add    $0x10,%esi
80106933:	3b 73 58             	cmp    0x58(%ebx),%esi
80106936:	73 82                	jae    801068ba <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106938:	6a 10                	push   $0x10
8010693a:	56                   	push   %esi
8010693b:	57                   	push   %edi
8010693c:	53                   	push   %ebx
8010693d:	e8 5e c5 ff ff       	call   80102ea0 <readi>
80106942:	83 c4 10             	add    $0x10,%esp
80106945:	83 f8 10             	cmp    $0x10,%eax
80106948:	75 68                	jne    801069b2 <sys_unlink+0x1b2>
    if(de.inum != 0)
8010694a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010694f:	74 df                	je     80106930 <sys_unlink+0x130>
    iunlockput(ip);
80106951:	83 ec 0c             	sub    $0xc,%esp
80106954:	53                   	push   %ebx
80106955:	e8 c6 c4 ff ff       	call   80102e20 <iunlockput>
    goto bad;
8010695a:	83 c4 10             	add    $0x10,%esp
8010695d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80106960:	83 ec 0c             	sub    $0xc,%esp
80106963:	ff 75 b4             	push   -0x4c(%ebp)
80106966:	e8 b5 c4 ff ff       	call   80102e20 <iunlockput>
  end_op();
8010696b:	e8 70 d8 ff ff       	call   801041e0 <end_op>
  return -1;
80106970:	83 c4 10             	add    $0x10,%esp
80106973:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106978:	eb 9c                	jmp    80106916 <sys_unlink+0x116>
8010697a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80106980:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80106983:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80106986:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010698b:	50                   	push   %eax
8010698c:	e8 4f c1 ff ff       	call   80102ae0 <iupdate>
80106991:	83 c4 10             	add    $0x10,%esp
80106994:	e9 53 ff ff ff       	jmp    801068ec <sys_unlink+0xec>
    return -1;
80106999:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010699e:	e9 73 ff ff ff       	jmp    80106916 <sys_unlink+0x116>
    end_op();
801069a3:	e8 38 d8 ff ff       	call   801041e0 <end_op>
    return -1;
801069a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069ad:	e9 64 ff ff ff       	jmp    80106916 <sys_unlink+0x116>
      panic("isdirempty: readi");
801069b2:	83 ec 0c             	sub    $0xc,%esp
801069b5:	68 73 94 10 80       	push   $0x80109473
801069ba:	e8 c1 99 ff ff       	call   80100380 <panic>
    panic("unlink: writei");
801069bf:	83 ec 0c             	sub    $0xc,%esp
801069c2:	68 85 94 10 80       	push   $0x80109485
801069c7:	e8 b4 99 ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
801069cc:	83 ec 0c             	sub    $0xc,%esp
801069cf:	68 61 94 10 80       	push   $0x80109461
801069d4:	e8 a7 99 ff ff       	call   80100380 <panic>
801069d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801069e0 <sys_open>:

int
sys_open(void)
{
801069e0:	55                   	push   %ebp
801069e1:	89 e5                	mov    %esp,%ebp
801069e3:	57                   	push   %edi
801069e4:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801069e5:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801069e8:	53                   	push   %ebx
801069e9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801069ec:	50                   	push   %eax
801069ed:	6a 00                	push   $0x0
801069ef:	e8 ac f6 ff ff       	call   801060a0 <argstr>
801069f4:	83 c4 10             	add    $0x10,%esp
801069f7:	85 c0                	test   %eax,%eax
801069f9:	0f 88 8e 00 00 00    	js     80106a8d <sys_open+0xad>
801069ff:	83 ec 08             	sub    $0x8,%esp
80106a02:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106a05:	50                   	push   %eax
80106a06:	6a 01                	push   $0x1
80106a08:	e8 d3 f5 ff ff       	call   80105fe0 <argint>
80106a0d:	83 c4 10             	add    $0x10,%esp
80106a10:	85 c0                	test   %eax,%eax
80106a12:	78 79                	js     80106a8d <sys_open+0xad>
    return -1;

  begin_op();
80106a14:	e8 57 d7 ff ff       	call   80104170 <begin_op>

  if(omode & O_CREATE){
80106a19:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80106a1d:	75 79                	jne    80106a98 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80106a1f:	83 ec 0c             	sub    $0xc,%esp
80106a22:	ff 75 e0             	push   -0x20(%ebp)
80106a25:	e8 86 ca ff ff       	call   801034b0 <namei>
80106a2a:	83 c4 10             	add    $0x10,%esp
80106a2d:	89 c6                	mov    %eax,%esi
80106a2f:	85 c0                	test   %eax,%eax
80106a31:	0f 84 7e 00 00 00    	je     80106ab5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80106a37:	83 ec 0c             	sub    $0xc,%esp
80106a3a:	50                   	push   %eax
80106a3b:	e8 50 c1 ff ff       	call   80102b90 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80106a40:	83 c4 10             	add    $0x10,%esp
80106a43:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80106a48:	0f 84 c2 00 00 00    	je     80106b10 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80106a4e:	e8 ed b7 ff ff       	call   80102240 <filealloc>
80106a53:	89 c7                	mov    %eax,%edi
80106a55:	85 c0                	test   %eax,%eax
80106a57:	74 23                	je     80106a7c <sys_open+0x9c>
  struct proc *curproc = myproc();
80106a59:	e8 42 e3 ff ff       	call   80104da0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80106a5e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80106a60:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80106a64:	85 d2                	test   %edx,%edx
80106a66:	74 60                	je     80106ac8 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80106a68:	83 c3 01             	add    $0x1,%ebx
80106a6b:	83 fb 10             	cmp    $0x10,%ebx
80106a6e:	75 f0                	jne    80106a60 <sys_open+0x80>
    if(f)
      fileclose(f);
80106a70:	83 ec 0c             	sub    $0xc,%esp
80106a73:	57                   	push   %edi
80106a74:	e8 87 b8 ff ff       	call   80102300 <fileclose>
80106a79:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80106a7c:	83 ec 0c             	sub    $0xc,%esp
80106a7f:	56                   	push   %esi
80106a80:	e8 9b c3 ff ff       	call   80102e20 <iunlockput>
    end_op();
80106a85:	e8 56 d7 ff ff       	call   801041e0 <end_op>
    return -1;
80106a8a:	83 c4 10             	add    $0x10,%esp
80106a8d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106a92:	eb 6d                	jmp    80106b01 <sys_open+0x121>
80106a94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80106a98:	83 ec 0c             	sub    $0xc,%esp
80106a9b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106a9e:	31 c9                	xor    %ecx,%ecx
80106aa0:	ba 02 00 00 00       	mov    $0x2,%edx
80106aa5:	6a 00                	push   $0x0
80106aa7:	e8 e4 f6 ff ff       	call   80106190 <create>
    if(ip == 0){
80106aac:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
80106aaf:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80106ab1:	85 c0                	test   %eax,%eax
80106ab3:	75 99                	jne    80106a4e <sys_open+0x6e>
      end_op();
80106ab5:	e8 26 d7 ff ff       	call   801041e0 <end_op>
      return -1;
80106aba:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106abf:	eb 40                	jmp    80106b01 <sys_open+0x121>
80106ac1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80106ac8:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80106acb:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80106acf:	56                   	push   %esi
80106ad0:	e8 9b c1 ff ff       	call   80102c70 <iunlock>
  end_op();
80106ad5:	e8 06 d7 ff ff       	call   801041e0 <end_op>

  f->type = FD_INODE;
80106ada:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80106ae0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106ae3:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80106ae6:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80106ae9:	89 d0                	mov    %edx,%eax
  f->off = 0;
80106aeb:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80106af2:	f7 d0                	not    %eax
80106af4:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106af7:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80106afa:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106afd:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80106b01:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b04:	89 d8                	mov    %ebx,%eax
80106b06:	5b                   	pop    %ebx
80106b07:	5e                   	pop    %esi
80106b08:	5f                   	pop    %edi
80106b09:	5d                   	pop    %ebp
80106b0a:	c3                   	ret    
80106b0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106b0f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80106b10:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106b13:	85 c9                	test   %ecx,%ecx
80106b15:	0f 84 33 ff ff ff    	je     80106a4e <sys_open+0x6e>
80106b1b:	e9 5c ff ff ff       	jmp    80106a7c <sys_open+0x9c>

80106b20 <sys_mkdir>:

int
sys_mkdir(void)
{
80106b20:	55                   	push   %ebp
80106b21:	89 e5                	mov    %esp,%ebp
80106b23:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106b26:	e8 45 d6 ff ff       	call   80104170 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80106b2b:	83 ec 08             	sub    $0x8,%esp
80106b2e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106b31:	50                   	push   %eax
80106b32:	6a 00                	push   $0x0
80106b34:	e8 67 f5 ff ff       	call   801060a0 <argstr>
80106b39:	83 c4 10             	add    $0x10,%esp
80106b3c:	85 c0                	test   %eax,%eax
80106b3e:	78 30                	js     80106b70 <sys_mkdir+0x50>
80106b40:	83 ec 0c             	sub    $0xc,%esp
80106b43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b46:	31 c9                	xor    %ecx,%ecx
80106b48:	ba 01 00 00 00       	mov    $0x1,%edx
80106b4d:	6a 00                	push   $0x0
80106b4f:	e8 3c f6 ff ff       	call   80106190 <create>
80106b54:	83 c4 10             	add    $0x10,%esp
80106b57:	85 c0                	test   %eax,%eax
80106b59:	74 15                	je     80106b70 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80106b5b:	83 ec 0c             	sub    $0xc,%esp
80106b5e:	50                   	push   %eax
80106b5f:	e8 bc c2 ff ff       	call   80102e20 <iunlockput>
  end_op();
80106b64:	e8 77 d6 ff ff       	call   801041e0 <end_op>
  return 0;
80106b69:	83 c4 10             	add    $0x10,%esp
80106b6c:	31 c0                	xor    %eax,%eax
}
80106b6e:	c9                   	leave  
80106b6f:	c3                   	ret    
    end_op();
80106b70:	e8 6b d6 ff ff       	call   801041e0 <end_op>
    return -1;
80106b75:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106b7a:	c9                   	leave  
80106b7b:	c3                   	ret    
80106b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106b80 <sys_move_file>:

// Kernel function for copying a file and deleting the source
int sys_move_file(void) {
80106b80:	55                   	push   %ebp
80106b81:	89 e5                	mov    %esp,%ebp
80106b83:	57                   	push   %edi
80106b84:	56                   	push   %esi
    struct inode *ip_dst;
    struct inode *ip_src;
    int red_bytes;
    char buffer[1024];

    if (argstr(0, &source) < 0 || argstr(1, &dest) < 0)
80106b85:	8d 85 6c fb ff ff    	lea    -0x494(%ebp),%eax
int sys_move_file(void) {
80106b8b:	53                   	push   %ebx
80106b8c:	81 ec a4 04 00 00    	sub    $0x4a4,%esp
    if (argstr(0, &source) < 0 || argstr(1, &dest) < 0)
80106b92:	50                   	push   %eax
80106b93:	6a 00                	push   $0x0
80106b95:	e8 06 f5 ff ff       	call   801060a0 <argstr>
80106b9a:	83 c4 10             	add    $0x10,%esp
80106b9d:	85 c0                	test   %eax,%eax
80106b9f:	0f 88 c5 01 00 00    	js     80106d6a <sys_move_file+0x1ea>
80106ba5:	83 ec 08             	sub    $0x8,%esp
80106ba8:	8d 85 70 fb ff ff    	lea    -0x490(%ebp),%eax
80106bae:	50                   	push   %eax
80106baf:	6a 01                	push   $0x1
80106bb1:	e8 ea f4 ff ff       	call   801060a0 <argstr>
80106bb6:	83 c4 10             	add    $0x10,%esp
80106bb9:	85 c0                	test   %eax,%eax
80106bbb:	0f 88 a9 01 00 00    	js     80106d6a <sys_move_file+0x1ea>
        return -1;

    begin_op();
80106bc1:	e8 aa d5 ff ff       	call   80104170 <begin_op>
    if ((ip_src = namei(source)) == 0) {
80106bc6:	83 ec 0c             	sub    $0xc,%esp
80106bc9:	ff b5 6c fb ff ff    	push   -0x494(%ebp)
80106bcf:	e8 dc c8 ff ff       	call   801034b0 <namei>
80106bd4:	83 c4 10             	add    $0x10,%esp
80106bd7:	89 85 64 fb ff ff    	mov    %eax,-0x49c(%ebp)
80106bdd:	85 c0                	test   %eax,%eax
80106bdf:	0f 84 af 01 00 00    	je     80106d94 <sys_move_file+0x214>
        end_op();
        return -1;
    }

    char full_path[100];
    create_full_pathchar(full_path, dest, source);
80106be5:	8b 9d 70 fb ff ff    	mov    -0x490(%ebp),%ebx
80106beb:	8b 8d 6c fb ff ff    	mov    -0x494(%ebp),%ecx
    while (*dir) {
80106bf1:	0f b6 13             	movzbl (%ebx),%edx
80106bf4:	84 d2                	test   %dl,%dl
80106bf6:	0f 84 84 01 00 00    	je     80106d80 <sys_move_file+0x200>
    char *p = full_path;
80106bfc:	8d bd 84 fb ff ff    	lea    -0x47c(%ebp),%edi
80106c02:	89 f8                	mov    %edi,%eax
80106c04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        *p++ = *dir++;
80106c08:	83 c3 01             	add    $0x1,%ebx
80106c0b:	89 d6                	mov    %edx,%esi
80106c0d:	88 10                	mov    %dl,(%eax)
80106c0f:	83 c0 01             	add    $0x1,%eax
    while (*dir) {
80106c12:	0f b6 13             	movzbl (%ebx),%edx
80106c15:	84 d2                	test   %dl,%dl
80106c17:	75 ef                	jne    80106c08 <sys_move_file+0x88>
    if (*(p - 1) != '/') {
80106c19:	89 f3                	mov    %esi,%ebx
80106c1b:	80 fb 2f             	cmp    $0x2f,%bl
80106c1e:	74 18                	je     80106c38 <sys_move_file+0xb8>
        *p++ = '/';
80106c20:	c6 00 2f             	movb   $0x2f,(%eax)
80106c23:	83 c0 01             	add    $0x1,%eax
    while (*filename) {
80106c26:	eb 10                	jmp    80106c38 <sys_move_file+0xb8>
80106c28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c2f:	90                   	nop
        *p++ = *filename++;
80106c30:	88 10                	mov    %dl,(%eax)
80106c32:	83 c0 01             	add    $0x1,%eax
80106c35:	83 c1 01             	add    $0x1,%ecx
    while (*filename) {
80106c38:	0f b6 11             	movzbl (%ecx),%edx
80106c3b:	84 d2                	test   %dl,%dl
80106c3d:	75 f1                	jne    80106c30 <sys_move_file+0xb0>
   
    struct inode *ip_check = namei(full_path);
80106c3f:	83 ec 0c             	sub    $0xc,%esp
    *p = '\0';
80106c42:	c6 00 00             	movb   $0x0,(%eax)
    struct inode *ip_check = namei(full_path);
80106c45:	57                   	push   %edi
80106c46:	e8 65 c8 ff ff       	call   801034b0 <namei>
    if (ip_check != 0) {
80106c4b:	83 c4 10             	add    $0x10,%esp
80106c4e:	85 c0                	test   %eax,%eax
80106c50:	0f 85 3e 01 00 00    	jne    80106d94 <sys_move_file+0x214>
        end_op();
        return -1;
    }

    ip_dst = create(full_path, T_FILE, 0, 0);
80106c56:	83 ec 0c             	sub    $0xc,%esp
80106c59:	31 c9                	xor    %ecx,%ecx
80106c5b:	ba 02 00 00 00       	mov    $0x2,%edx
80106c60:	89 f8                	mov    %edi,%eax
80106c62:	6a 00                	push   $0x0
80106c64:	e8 27 f5 ff ff       	call   80106190 <create>
    if (ip_dst == 0) {
80106c69:	83 c4 10             	add    $0x10,%esp
    ip_dst = create(full_path, T_FILE, 0, 0);
80106c6c:	89 85 60 fb ff ff    	mov    %eax,-0x4a0(%ebp)
    if (ip_dst == 0) {
80106c72:	85 c0                	test   %eax,%eax
80106c74:	0f 84 1a 01 00 00    	je     80106d94 <sys_move_file+0x214>

    int written_bytes = 0;
    int read_offset = 0;
    int write_offset = 0;

    ilock(ip_src);
80106c7a:	83 ec 0c             	sub    $0xc,%esp
80106c7d:	ff b5 64 fb ff ff    	push   -0x49c(%ebp)
    int write_offset = 0;
80106c83:	31 f6                	xor    %esi,%esi
    int read_offset = 0;
80106c85:	31 db                	xor    %ebx,%ebx
80106c87:	8d bd e8 fb ff ff    	lea    -0x418(%ebp),%edi
    ilock(ip_src);
80106c8d:	e8 fe be ff ff       	call   80102b90 <ilock>
    while ((red_bytes = readi(ip_src, buffer, read_offset, sizeof(buffer))) > 0) {
80106c92:	83 c4 10             	add    $0x10,%esp
80106c95:	eb 26                	jmp    80106cbd <sys_move_file+0x13d>
80106c97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c9e:	66 90                	xchg   %ax,%ax
        read_offset += red_bytes;
        if ((written_bytes = writei(ip_dst, buffer, write_offset, red_bytes)) <= 0) {
80106ca0:	50                   	push   %eax
        read_offset += red_bytes;
80106ca1:	01 c3                	add    %eax,%ebx
        if ((written_bytes = writei(ip_dst, buffer, write_offset, red_bytes)) <= 0) {
80106ca3:	56                   	push   %esi
80106ca4:	57                   	push   %edi
80106ca5:	ff b5 60 fb ff ff    	push   -0x4a0(%ebp)
80106cab:	e8 f0 c2 ff ff       	call   80102fa0 <writei>
80106cb0:	83 c4 10             	add    $0x10,%esp
80106cb3:	85 c0                	test   %eax,%eax
80106cb5:	0f 8e 8d 00 00 00    	jle    80106d48 <sys_move_file+0x1c8>
            iunlock(ip_src);
            iunlock(ip_dst);
            end_op();
            return -1;
        }
        write_offset += written_bytes;
80106cbb:	01 c6                	add    %eax,%esi
    while ((red_bytes = readi(ip_src, buffer, read_offset, sizeof(buffer))) > 0) {
80106cbd:	68 00 04 00 00       	push   $0x400
80106cc2:	53                   	push   %ebx
80106cc3:	57                   	push   %edi
80106cc4:	ff b5 64 fb ff ff    	push   -0x49c(%ebp)
80106cca:	e8 d1 c1 ff ff       	call   80102ea0 <readi>
80106ccf:	83 c4 10             	add    $0x10,%esp
80106cd2:	85 c0                	test   %eax,%eax
80106cd4:	7f ca                	jg     80106ca0 <sys_move_file+0x120>
    }
    iunlock(ip_src);
80106cd6:	83 ec 0c             	sub    $0xc,%esp
80106cd9:	ff b5 64 fb ff ff    	push   -0x49c(%ebp)
80106cdf:	e8 8c bf ff ff       	call   80102c70 <iunlock>
    iunlock(ip_dst);
80106ce4:	59                   	pop    %ecx
80106ce5:	ff b5 60 fb ff ff    	push   -0x4a0(%ebp)
80106ceb:	e8 80 bf ff ff       	call   80102c70 <iunlock>

    char src_name[DIRSIZ];
    struct inode *ip_src_parent = nameiparent(source, src_name);
80106cf0:	5b                   	pop    %ebx
80106cf1:	5e                   	pop    %esi
80106cf2:	8d b5 76 fb ff ff    	lea    -0x48a(%ebp),%esi
80106cf8:	56                   	push   %esi
80106cf9:	ff b5 6c fb ff ff    	push   -0x494(%ebp)
80106cff:	e8 cc c7 ff ff       	call   801034d0 <nameiparent>
    if (ip_src_parent == 0) {
80106d04:	83 c4 10             	add    $0x10,%esp
    struct inode *ip_src_parent = nameiparent(source, src_name);
80106d07:	89 c3                	mov    %eax,%ebx
    if (ip_src_parent == 0) {
80106d09:	85 c0                	test   %eax,%eax
80106d0b:	0f 84 83 00 00 00    	je     80106d94 <sys_move_file+0x214>
        end_op();
        return -1;
    }
    ilock(ip_src_parent);
80106d11:	83 ec 0c             	sub    $0xc,%esp
80106d14:	50                   	push   %eax
80106d15:	e8 76 be ff ff       	call   80102b90 <ilock>
    if (remove_file(ip_src_parent, src_name) < 0) {
80106d1a:	58                   	pop    %eax
80106d1b:	5a                   	pop    %edx
80106d1c:	56                   	push   %esi
80106d1d:	53                   	push   %ebx
80106d1e:	e8 7d f6 ff ff       	call   801063a0 <remove_file>
80106d23:	83 c4 10             	add    $0x10,%esp
80106d26:	85 c0                	test   %eax,%eax
80106d28:	78 76                	js     80106da0 <sys_move_file+0x220>
        iunlock(ip_src_parent);
        end_op();
        return -1;
    }
    iunlock(ip_src_parent);
80106d2a:	83 ec 0c             	sub    $0xc,%esp
80106d2d:	53                   	push   %ebx
80106d2e:	e8 3d bf ff ff       	call   80102c70 <iunlock>

    end_op();
80106d33:	e8 a8 d4 ff ff       	call   801041e0 <end_op>
    return 0;
80106d38:	83 c4 10             	add    $0x10,%esp
80106d3b:	31 c0                	xor    %eax,%eax
}
80106d3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d40:	5b                   	pop    %ebx
80106d41:	5e                   	pop    %esi
80106d42:	5f                   	pop    %edi
80106d43:	5d                   	pop    %ebp
80106d44:	c3                   	ret    
80106d45:	8d 76 00             	lea    0x0(%esi),%esi
            iunlock(ip_src);
80106d48:	83 ec 0c             	sub    $0xc,%esp
80106d4b:	ff b5 64 fb ff ff    	push   -0x49c(%ebp)
80106d51:	e8 1a bf ff ff       	call   80102c70 <iunlock>
            iunlock(ip_dst);
80106d56:	5f                   	pop    %edi
80106d57:	ff b5 60 fb ff ff    	push   -0x4a0(%ebp)
80106d5d:	e8 0e bf ff ff       	call   80102c70 <iunlock>
            end_op();
80106d62:	e8 79 d4 ff ff       	call   801041e0 <end_op>
            return -1;
80106d67:	83 c4 10             	add    $0x10,%esp
}
80106d6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
            return -1;
80106d6d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106d72:	5b                   	pop    %ebx
80106d73:	5e                   	pop    %esi
80106d74:	5f                   	pop    %edi
80106d75:	5d                   	pop    %ebp
80106d76:	c3                   	ret    
80106d77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d7e:	66 90                	xchg   %ax,%ax
    char *p = full_path;
80106d80:	8d bd 84 fb ff ff    	lea    -0x47c(%ebp),%edi
    if (*(p - 1) != '/') {
80106d86:	0f b6 b5 83 fb ff ff 	movzbl -0x47d(%ebp),%esi
    char *p = full_path;
80106d8d:	89 f8                	mov    %edi,%eax
80106d8f:	e9 85 fe ff ff       	jmp    80106c19 <sys_move_file+0x99>
        end_op();
80106d94:	e8 47 d4 ff ff       	call   801041e0 <end_op>
        return -1;
80106d99:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d9e:	eb 9d                	jmp    80106d3d <sys_move_file+0x1bd>
        iunlock(ip_src_parent);
80106da0:	83 ec 0c             	sub    $0xc,%esp
80106da3:	53                   	push   %ebx
80106da4:	e8 c7 be ff ff       	call   80102c70 <iunlock>
        end_op();
80106da9:	e8 32 d4 ff ff       	call   801041e0 <end_op>
        return -1;
80106dae:	83 c4 10             	add    $0x10,%esp
80106db1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106db6:	eb 85                	jmp    80106d3d <sys_move_file+0x1bd>
80106db8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106dbf:	90                   	nop

80106dc0 <sys_mknod>:



int
sys_mknod(void)
{
80106dc0:	55                   	push   %ebp
80106dc1:	89 e5                	mov    %esp,%ebp
80106dc3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80106dc6:	e8 a5 d3 ff ff       	call   80104170 <begin_op>
  if((argstr(0, &path)) < 0 ||
80106dcb:	83 ec 08             	sub    $0x8,%esp
80106dce:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106dd1:	50                   	push   %eax
80106dd2:	6a 00                	push   $0x0
80106dd4:	e8 c7 f2 ff ff       	call   801060a0 <argstr>
80106dd9:	83 c4 10             	add    $0x10,%esp
80106ddc:	85 c0                	test   %eax,%eax
80106dde:	78 60                	js     80106e40 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80106de0:	83 ec 08             	sub    $0x8,%esp
80106de3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106de6:	50                   	push   %eax
80106de7:	6a 01                	push   $0x1
80106de9:	e8 f2 f1 ff ff       	call   80105fe0 <argint>
  if((argstr(0, &path)) < 0 ||
80106dee:	83 c4 10             	add    $0x10,%esp
80106df1:	85 c0                	test   %eax,%eax
80106df3:	78 4b                	js     80106e40 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80106df5:	83 ec 08             	sub    $0x8,%esp
80106df8:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106dfb:	50                   	push   %eax
80106dfc:	6a 02                	push   $0x2
80106dfe:	e8 dd f1 ff ff       	call   80105fe0 <argint>
     argint(1, &major) < 0 ||
80106e03:	83 c4 10             	add    $0x10,%esp
80106e06:	85 c0                	test   %eax,%eax
80106e08:	78 36                	js     80106e40 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80106e0a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80106e0e:	83 ec 0c             	sub    $0xc,%esp
80106e11:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80106e15:	ba 03 00 00 00       	mov    $0x3,%edx
80106e1a:	50                   	push   %eax
80106e1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106e1e:	e8 6d f3 ff ff       	call   80106190 <create>
     argint(2, &minor) < 0 ||
80106e23:	83 c4 10             	add    $0x10,%esp
80106e26:	85 c0                	test   %eax,%eax
80106e28:	74 16                	je     80106e40 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80106e2a:	83 ec 0c             	sub    $0xc,%esp
80106e2d:	50                   	push   %eax
80106e2e:	e8 ed bf ff ff       	call   80102e20 <iunlockput>
  end_op();
80106e33:	e8 a8 d3 ff ff       	call   801041e0 <end_op>
  return 0;
80106e38:	83 c4 10             	add    $0x10,%esp
80106e3b:	31 c0                	xor    %eax,%eax
}
80106e3d:	c9                   	leave  
80106e3e:	c3                   	ret    
80106e3f:	90                   	nop
    end_op();
80106e40:	e8 9b d3 ff ff       	call   801041e0 <end_op>
    return -1;
80106e45:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106e4a:	c9                   	leave  
80106e4b:	c3                   	ret    
80106e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106e50 <sys_chdir>:

int
sys_chdir(void)
{
80106e50:	55                   	push   %ebp
80106e51:	89 e5                	mov    %esp,%ebp
80106e53:	56                   	push   %esi
80106e54:	53                   	push   %ebx
80106e55:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80106e58:	e8 43 df ff ff       	call   80104da0 <myproc>
80106e5d:	89 c6                	mov    %eax,%esi
  
  begin_op();
80106e5f:	e8 0c d3 ff ff       	call   80104170 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80106e64:	83 ec 08             	sub    $0x8,%esp
80106e67:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106e6a:	50                   	push   %eax
80106e6b:	6a 00                	push   $0x0
80106e6d:	e8 2e f2 ff ff       	call   801060a0 <argstr>
80106e72:	83 c4 10             	add    $0x10,%esp
80106e75:	85 c0                	test   %eax,%eax
80106e77:	78 77                	js     80106ef0 <sys_chdir+0xa0>
80106e79:	83 ec 0c             	sub    $0xc,%esp
80106e7c:	ff 75 f4             	push   -0xc(%ebp)
80106e7f:	e8 2c c6 ff ff       	call   801034b0 <namei>
80106e84:	83 c4 10             	add    $0x10,%esp
80106e87:	89 c3                	mov    %eax,%ebx
80106e89:	85 c0                	test   %eax,%eax
80106e8b:	74 63                	je     80106ef0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80106e8d:	83 ec 0c             	sub    $0xc,%esp
80106e90:	50                   	push   %eax
80106e91:	e8 fa bc ff ff       	call   80102b90 <ilock>
  if(ip->type != T_DIR){
80106e96:	83 c4 10             	add    $0x10,%esp
80106e99:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80106e9e:	75 30                	jne    80106ed0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80106ea0:	83 ec 0c             	sub    $0xc,%esp
80106ea3:	53                   	push   %ebx
80106ea4:	e8 c7 bd ff ff       	call   80102c70 <iunlock>
  iput(curproc->cwd);
80106ea9:	58                   	pop    %eax
80106eaa:	ff 76 68             	push   0x68(%esi)
80106ead:	e8 0e be ff ff       	call   80102cc0 <iput>
  end_op();
80106eb2:	e8 29 d3 ff ff       	call   801041e0 <end_op>
  curproc->cwd = ip;
80106eb7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80106eba:	83 c4 10             	add    $0x10,%esp
80106ebd:	31 c0                	xor    %eax,%eax
}
80106ebf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106ec2:	5b                   	pop    %ebx
80106ec3:	5e                   	pop    %esi
80106ec4:	5d                   	pop    %ebp
80106ec5:	c3                   	ret    
80106ec6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ecd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80106ed0:	83 ec 0c             	sub    $0xc,%esp
80106ed3:	53                   	push   %ebx
80106ed4:	e8 47 bf ff ff       	call   80102e20 <iunlockput>
    end_op();
80106ed9:	e8 02 d3 ff ff       	call   801041e0 <end_op>
    return -1;
80106ede:	83 c4 10             	add    $0x10,%esp
80106ee1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ee6:	eb d7                	jmp    80106ebf <sys_chdir+0x6f>
80106ee8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106eef:	90                   	nop
    end_op();
80106ef0:	e8 eb d2 ff ff       	call   801041e0 <end_op>
    return -1;
80106ef5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106efa:	eb c3                	jmp    80106ebf <sys_chdir+0x6f>
80106efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106f00 <sys_exec>:

int
sys_exec(void)
{
80106f00:	55                   	push   %ebp
80106f01:	89 e5                	mov    %esp,%ebp
80106f03:	57                   	push   %edi
80106f04:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106f05:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80106f0b:	53                   	push   %ebx
80106f0c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106f12:	50                   	push   %eax
80106f13:	6a 00                	push   $0x0
80106f15:	e8 86 f1 ff ff       	call   801060a0 <argstr>
80106f1a:	83 c4 10             	add    $0x10,%esp
80106f1d:	85 c0                	test   %eax,%eax
80106f1f:	0f 88 87 00 00 00    	js     80106fac <sys_exec+0xac>
80106f25:	83 ec 08             	sub    $0x8,%esp
80106f28:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80106f2e:	50                   	push   %eax
80106f2f:	6a 01                	push   $0x1
80106f31:	e8 aa f0 ff ff       	call   80105fe0 <argint>
80106f36:	83 c4 10             	add    $0x10,%esp
80106f39:	85 c0                	test   %eax,%eax
80106f3b:	78 6f                	js     80106fac <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80106f3d:	83 ec 04             	sub    $0x4,%esp
80106f40:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80106f46:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80106f48:	68 80 00 00 00       	push   $0x80
80106f4d:	6a 00                	push   $0x0
80106f4f:	56                   	push   %esi
80106f50:	e8 cb ed ff ff       	call   80105d20 <memset>
80106f55:	83 c4 10             	add    $0x10,%esp
80106f58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f5f:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106f60:	83 ec 08             	sub    $0x8,%esp
80106f63:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80106f69:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80106f70:	50                   	push   %eax
80106f71:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80106f77:	01 f8                	add    %edi,%eax
80106f79:	50                   	push   %eax
80106f7a:	e8 d1 ef ff ff       	call   80105f50 <fetchint>
80106f7f:	83 c4 10             	add    $0x10,%esp
80106f82:	85 c0                	test   %eax,%eax
80106f84:	78 26                	js     80106fac <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80106f86:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80106f8c:	85 c0                	test   %eax,%eax
80106f8e:	74 30                	je     80106fc0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80106f90:	83 ec 08             	sub    $0x8,%esp
80106f93:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80106f96:	52                   	push   %edx
80106f97:	50                   	push   %eax
80106f98:	e8 f3 ef ff ff       	call   80105f90 <fetchstr>
80106f9d:	83 c4 10             	add    $0x10,%esp
80106fa0:	85 c0                	test   %eax,%eax
80106fa2:	78 08                	js     80106fac <sys_exec+0xac>
  for(i=0;; i++){
80106fa4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80106fa7:	83 fb 20             	cmp    $0x20,%ebx
80106faa:	75 b4                	jne    80106f60 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80106fac:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80106faf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106fb4:	5b                   	pop    %ebx
80106fb5:	5e                   	pop    %esi
80106fb6:	5f                   	pop    %edi
80106fb7:	5d                   	pop    %ebp
80106fb8:	c3                   	ret    
80106fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80106fc0:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80106fc7:	00 00 00 00 
  return exec(path, argv);
80106fcb:	83 ec 08             	sub    $0x8,%esp
80106fce:	56                   	push   %esi
80106fcf:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80106fd5:	e8 e6 ae ff ff       	call   80101ec0 <exec>
80106fda:	83 c4 10             	add    $0x10,%esp
}
80106fdd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fe0:	5b                   	pop    %ebx
80106fe1:	5e                   	pop    %esi
80106fe2:	5f                   	pop    %edi
80106fe3:	5d                   	pop    %ebp
80106fe4:	c3                   	ret    
80106fe5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106ff0 <sys_pipe>:

int
sys_pipe(void)
{
80106ff0:	55                   	push   %ebp
80106ff1:	89 e5                	mov    %esp,%ebp
80106ff3:	57                   	push   %edi
80106ff4:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106ff5:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80106ff8:	53                   	push   %ebx
80106ff9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106ffc:	6a 08                	push   $0x8
80106ffe:	50                   	push   %eax
80106fff:	6a 00                	push   $0x0
80107001:	e8 2a f0 ff ff       	call   80106030 <argptr>
80107006:	83 c4 10             	add    $0x10,%esp
80107009:	85 c0                	test   %eax,%eax
8010700b:	78 4a                	js     80107057 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010700d:	83 ec 08             	sub    $0x8,%esp
80107010:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80107013:	50                   	push   %eax
80107014:	8d 45 e0             	lea    -0x20(%ebp),%eax
80107017:	50                   	push   %eax
80107018:	e8 23 d8 ff ff       	call   80104840 <pipealloc>
8010701d:	83 c4 10             	add    $0x10,%esp
80107020:	85 c0                	test   %eax,%eax
80107022:	78 33                	js     80107057 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80107024:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80107027:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80107029:	e8 72 dd ff ff       	call   80104da0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010702e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80107030:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80107034:	85 f6                	test   %esi,%esi
80107036:	74 28                	je     80107060 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80107038:	83 c3 01             	add    $0x1,%ebx
8010703b:	83 fb 10             	cmp    $0x10,%ebx
8010703e:	75 f0                	jne    80107030 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80107040:	83 ec 0c             	sub    $0xc,%esp
80107043:	ff 75 e0             	push   -0x20(%ebp)
80107046:	e8 b5 b2 ff ff       	call   80102300 <fileclose>
    fileclose(wf);
8010704b:	58                   	pop    %eax
8010704c:	ff 75 e4             	push   -0x1c(%ebp)
8010704f:	e8 ac b2 ff ff       	call   80102300 <fileclose>
    return -1;
80107054:	83 c4 10             	add    $0x10,%esp
80107057:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010705c:	eb 53                	jmp    801070b1 <sys_pipe+0xc1>
8010705e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80107060:	8d 73 08             	lea    0x8(%ebx),%esi
80107063:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80107067:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010706a:	e8 31 dd ff ff       	call   80104da0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010706f:	31 d2                	xor    %edx,%edx
80107071:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80107078:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010707c:	85 c9                	test   %ecx,%ecx
8010707e:	74 20                	je     801070a0 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80107080:	83 c2 01             	add    $0x1,%edx
80107083:	83 fa 10             	cmp    $0x10,%edx
80107086:	75 f0                	jne    80107078 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80107088:	e8 13 dd ff ff       	call   80104da0 <myproc>
8010708d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80107094:	00 
80107095:	eb a9                	jmp    80107040 <sys_pipe+0x50>
80107097:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010709e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801070a0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
801070a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801070a7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801070a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801070ac:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801070af:	31 c0                	xor    %eax,%eax
}
801070b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070b4:	5b                   	pop    %ebx
801070b5:	5e                   	pop    %esi
801070b6:	5f                   	pop    %edi
801070b7:	5d                   	pop    %ebp
801070b8:	c3                   	ret    
801070b9:	66 90                	xchg   %ax,%ax
801070bb:	66 90                	xchg   %ax,%ax
801070bd:	66 90                	xchg   %ax,%ax
801070bf:	90                   	nop

801070c0 <sys_fork>:
// extern struct proc proc[NPROC];

int
sys_fork(void)
{
  return fork();
801070c0:	e9 7b de ff ff       	jmp    80104f40 <fork>
801070c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801070d0 <sys_exit>:
}

int
sys_exit(void)
{
801070d0:	55                   	push   %ebp
801070d1:	89 e5                	mov    %esp,%ebp
801070d3:	83 ec 08             	sub    $0x8,%esp
  exit();
801070d6:	e8 e5 e0 ff ff       	call   801051c0 <exit>
  return 0;  // not reached
}
801070db:	31 c0                	xor    %eax,%eax
801070dd:	c9                   	leave  
801070de:	c3                   	ret    
801070df:	90                   	nop

801070e0 <sys_wait>:

int
sys_wait(void)
{
  return wait();
801070e0:	e9 0b e2 ff ff       	jmp    801052f0 <wait>
801070e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801070f0 <sys_kill>:
}

int
sys_kill(void)
{
801070f0:	55                   	push   %ebp
801070f1:	89 e5                	mov    %esp,%ebp
801070f3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801070f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801070f9:	50                   	push   %eax
801070fa:	6a 00                	push   $0x0
801070fc:	e8 df ee ff ff       	call   80105fe0 <argint>
80107101:	83 c4 10             	add    $0x10,%esp
80107104:	85 c0                	test   %eax,%eax
80107106:	78 18                	js     80107120 <sys_kill+0x30>
    return -1;
  return kill(pid);
80107108:	83 ec 0c             	sub    $0xc,%esp
8010710b:	ff 75 f4             	push   -0xc(%ebp)
8010710e:	e8 7d e4 ff ff       	call   80105590 <kill>
80107113:	83 c4 10             	add    $0x10,%esp
}
80107116:	c9                   	leave  
80107117:	c3                   	ret    
80107118:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010711f:	90                   	nop
80107120:	c9                   	leave  
    return -1;
80107121:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107126:	c3                   	ret    
80107127:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010712e:	66 90                	xchg   %ax,%ax

80107130 <sys_create_palindrome>:

int
sys_create_palindrome(void){
80107130:	55                   	push   %ebp
80107131:	89 e5                	mov    %esp,%ebp
80107133:	53                   	push   %ebx
80107134:	83 ec 04             	sub    $0x4,%esp
  int n = myproc()->tf->ebx;
80107137:	e8 64 dc ff ff       	call   80104da0 <myproc>
  cprintf("KERNEL: sys_create_palindrome(%d)\n", n);
8010713c:	83 ec 08             	sub    $0x8,%esp
  int n = myproc()->tf->ebx;
8010713f:	8b 40 18             	mov    0x18(%eax),%eax
80107142:	8b 58 10             	mov    0x10(%eax),%ebx
  cprintf("KERNEL: sys_create_palindrome(%d)\n", n);
80107145:	53                   	push   %ebx
80107146:	68 94 94 10 80       	push   $0x80109494
8010714b:	e8 b0 95 ff ff       	call   80100700 <cprintf>
  return create_palindrome(n);
80107150:	89 1c 24             	mov    %ebx,(%esp)
80107153:	e8 78 e5 ff ff       	call   801056d0 <create_palindrome>
}
80107158:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010715b:	c9                   	leave  
8010715c:	c3                   	ret    
8010715d:	8d 76 00             	lea    0x0(%esi),%esi

80107160 <sys_getpid>:

int
sys_getpid(void)
{
80107160:	55                   	push   %ebp
80107161:	89 e5                	mov    %esp,%ebp
80107163:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80107166:	e8 35 dc ff ff       	call   80104da0 <myproc>
8010716b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010716e:	c9                   	leave  
8010716f:	c3                   	ret    

80107170 <sys_sbrk>:

int
sys_sbrk(void)
{
80107170:	55                   	push   %ebp
80107171:	89 e5                	mov    %esp,%ebp
80107173:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80107174:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80107177:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010717a:	50                   	push   %eax
8010717b:	6a 00                	push   $0x0
8010717d:	e8 5e ee ff ff       	call   80105fe0 <argint>
80107182:	83 c4 10             	add    $0x10,%esp
80107185:	85 c0                	test   %eax,%eax
80107187:	78 27                	js     801071b0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80107189:	e8 12 dc ff ff       	call   80104da0 <myproc>
  if(growproc(n) < 0)
8010718e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80107191:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80107193:	ff 75 f4             	push   -0xc(%ebp)
80107196:	e8 25 dd ff ff       	call   80104ec0 <growproc>
8010719b:	83 c4 10             	add    $0x10,%esp
8010719e:	85 c0                	test   %eax,%eax
801071a0:	78 0e                	js     801071b0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801071a2:	89 d8                	mov    %ebx,%eax
801071a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801071a7:	c9                   	leave  
801071a8:	c3                   	ret    
801071a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801071b0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801071b5:	eb eb                	jmp    801071a2 <sys_sbrk+0x32>
801071b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071be:	66 90                	xchg   %ax,%ax

801071c0 <sys_sleep>:

int
sys_sleep(void)
{
801071c0:	55                   	push   %ebp
801071c1:	89 e5                	mov    %esp,%ebp
801071c3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801071c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801071c7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801071ca:	50                   	push   %eax
801071cb:	6a 00                	push   $0x0
801071cd:	e8 0e ee ff ff       	call   80105fe0 <argint>
801071d2:	83 c4 10             	add    $0x10,%esp
801071d5:	85 c0                	test   %eax,%eax
801071d7:	0f 88 8a 00 00 00    	js     80107267 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801071dd:	83 ec 0c             	sub    $0xc,%esp
801071e0:	68 00 7f 11 80       	push   $0x80117f00
801071e5:	e8 76 ea ff ff       	call   80105c60 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801071ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
801071ed:	8b 1d e0 7e 11 80    	mov    0x80117ee0,%ebx
  while(ticks - ticks0 < n){
801071f3:	83 c4 10             	add    $0x10,%esp
801071f6:	85 d2                	test   %edx,%edx
801071f8:	75 27                	jne    80107221 <sys_sleep+0x61>
801071fa:	eb 54                	jmp    80107250 <sys_sleep+0x90>
801071fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80107200:	83 ec 08             	sub    $0x8,%esp
80107203:	68 00 7f 11 80       	push   $0x80117f00
80107208:	68 e0 7e 11 80       	push   $0x80117ee0
8010720d:	e8 5e e2 ff ff       	call   80105470 <sleep>
  while(ticks - ticks0 < n){
80107212:	a1 e0 7e 11 80       	mov    0x80117ee0,%eax
80107217:	83 c4 10             	add    $0x10,%esp
8010721a:	29 d8                	sub    %ebx,%eax
8010721c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010721f:	73 2f                	jae    80107250 <sys_sleep+0x90>
    if(myproc()->killed){
80107221:	e8 7a db ff ff       	call   80104da0 <myproc>
80107226:	8b 40 24             	mov    0x24(%eax),%eax
80107229:	85 c0                	test   %eax,%eax
8010722b:	74 d3                	je     80107200 <sys_sleep+0x40>
      release(&tickslock);
8010722d:	83 ec 0c             	sub    $0xc,%esp
80107230:	68 00 7f 11 80       	push   $0x80117f00
80107235:	e8 c6 e9 ff ff       	call   80105c00 <release>
  }
  release(&tickslock);
  return 0;
}
8010723a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
8010723d:	83 c4 10             	add    $0x10,%esp
80107240:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107245:	c9                   	leave  
80107246:	c3                   	ret    
80107247:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010724e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80107250:	83 ec 0c             	sub    $0xc,%esp
80107253:	68 00 7f 11 80       	push   $0x80117f00
80107258:	e8 a3 e9 ff ff       	call   80105c00 <release>
  return 0;
8010725d:	83 c4 10             	add    $0x10,%esp
80107260:	31 c0                	xor    %eax,%eax
}
80107262:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107265:	c9                   	leave  
80107266:	c3                   	ret    
    return -1;
80107267:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010726c:	eb f4                	jmp    80107262 <sys_sleep+0xa2>
8010726e:	66 90                	xchg   %ax,%ax

80107270 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80107270:	55                   	push   %ebp
80107271:	89 e5                	mov    %esp,%ebp
80107273:	53                   	push   %ebx
80107274:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80107277:	68 00 7f 11 80       	push   $0x80117f00
8010727c:	e8 df e9 ff ff       	call   80105c60 <acquire>
  xticks = ticks;
80107281:	8b 1d e0 7e 11 80    	mov    0x80117ee0,%ebx
  release(&tickslock);
80107287:	c7 04 24 00 7f 11 80 	movl   $0x80117f00,(%esp)
8010728e:	e8 6d e9 ff ff       	call   80105c00 <release>
  return xticks;
80107293:	89 d8                	mov    %ebx,%eax
80107295:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107298:	c9                   	leave  
80107299:	c3                   	ret    

8010729a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010729a:	1e                   	push   %ds
  pushl %es
8010729b:	06                   	push   %es
  pushl %fs
8010729c:	0f a0                	push   %fs
  pushl %gs
8010729e:	0f a8                	push   %gs
  pushal
801072a0:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801072a1:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801072a5:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801072a7:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801072a9:	54                   	push   %esp
  call trap
801072aa:	e8 c1 00 00 00       	call   80107370 <trap>
  addl $4, %esp
801072af:	83 c4 04             	add    $0x4,%esp

801072b2 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801072b2:	61                   	popa   
  popl %gs
801072b3:	0f a9                	pop    %gs
  popl %fs
801072b5:	0f a1                	pop    %fs
  popl %es
801072b7:	07                   	pop    %es
  popl %ds
801072b8:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801072b9:	83 c4 08             	add    $0x8,%esp
  iret
801072bc:	cf                   	iret   
801072bd:	66 90                	xchg   %ax,%ax
801072bf:	90                   	nop

801072c0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801072c0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
801072c1:	31 c0                	xor    %eax,%eax
{
801072c3:	89 e5                	mov    %esp,%ebp
801072c5:	83 ec 08             	sub    $0x8,%esp
801072c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072cf:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801072d0:	8b 14 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%edx
801072d7:	c7 04 c5 42 7f 11 80 	movl   $0x8e000008,-0x7fee80be(,%eax,8)
801072de:	08 00 00 8e 
801072e2:	66 89 14 c5 40 7f 11 	mov    %dx,-0x7fee80c0(,%eax,8)
801072e9:	80 
801072ea:	c1 ea 10             	shr    $0x10,%edx
801072ed:	66 89 14 c5 46 7f 11 	mov    %dx,-0x7fee80ba(,%eax,8)
801072f4:	80 
  for(i = 0; i < 256; i++)
801072f5:	83 c0 01             	add    $0x1,%eax
801072f8:	3d 00 01 00 00       	cmp    $0x100,%eax
801072fd:	75 d1                	jne    801072d0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
801072ff:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80107302:	a1 08 c1 10 80       	mov    0x8010c108,%eax
80107307:	c7 05 42 81 11 80 08 	movl   $0xef000008,0x80118142
8010730e:	00 00 ef 
  initlock(&tickslock, "time");
80107311:	68 b7 94 10 80       	push   $0x801094b7
80107316:	68 00 7f 11 80       	push   $0x80117f00
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010731b:	66 a3 40 81 11 80    	mov    %ax,0x80118140
80107321:	c1 e8 10             	shr    $0x10,%eax
80107324:	66 a3 46 81 11 80    	mov    %ax,0x80118146
  initlock(&tickslock, "time");
8010732a:	e8 61 e7 ff ff       	call   80105a90 <initlock>
}
8010732f:	83 c4 10             	add    $0x10,%esp
80107332:	c9                   	leave  
80107333:	c3                   	ret    
80107334:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010733b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010733f:	90                   	nop

80107340 <idtinit>:

void
idtinit(void)
{
80107340:	55                   	push   %ebp
  pd[0] = size-1;
80107341:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80107346:	89 e5                	mov    %esp,%ebp
80107348:	83 ec 10             	sub    $0x10,%esp
8010734b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010734f:	b8 40 7f 11 80       	mov    $0x80117f40,%eax
80107354:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107358:	c1 e8 10             	shr    $0x10,%eax
8010735b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010735f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107362:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80107365:	c9                   	leave  
80107366:	c3                   	ret    
80107367:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010736e:	66 90                	xchg   %ax,%ax

80107370 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80107370:	55                   	push   %ebp
80107371:	89 e5                	mov    %esp,%ebp
80107373:	57                   	push   %edi
80107374:	56                   	push   %esi
80107375:	53                   	push   %ebx
80107376:	83 ec 1c             	sub    $0x1c,%esp
80107379:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
8010737c:	8b 43 30             	mov    0x30(%ebx),%eax
8010737f:	83 f8 40             	cmp    $0x40,%eax
80107382:	0f 84 68 01 00 00    	je     801074f0 <trap+0x180>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80107388:	83 e8 20             	sub    $0x20,%eax
8010738b:	83 f8 1f             	cmp    $0x1f,%eax
8010738e:	0f 87 8c 00 00 00    	ja     80107420 <trap+0xb0>
80107394:	ff 24 85 60 95 10 80 	jmp    *-0x7fef6aa0(,%eax,4)
8010739b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010739f:	90                   	nop
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801073a0:	e8 ab c2 ff ff       	call   80103650 <ideintr>
    lapiceoi();
801073a5:	e8 76 c9 ff ff       	call   80103d20 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801073aa:	e8 f1 d9 ff ff       	call   80104da0 <myproc>
801073af:	85 c0                	test   %eax,%eax
801073b1:	74 1d                	je     801073d0 <trap+0x60>
801073b3:	e8 e8 d9 ff ff       	call   80104da0 <myproc>
801073b8:	8b 50 24             	mov    0x24(%eax),%edx
801073bb:	85 d2                	test   %edx,%edx
801073bd:	74 11                	je     801073d0 <trap+0x60>
801073bf:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801073c3:	83 e0 03             	and    $0x3,%eax
801073c6:	66 83 f8 03          	cmp    $0x3,%ax
801073ca:	0f 84 e8 01 00 00    	je     801075b8 <trap+0x248>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801073d0:	e8 cb d9 ff ff       	call   80104da0 <myproc>
801073d5:	85 c0                	test   %eax,%eax
801073d7:	74 0f                	je     801073e8 <trap+0x78>
801073d9:	e8 c2 d9 ff ff       	call   80104da0 <myproc>
801073de:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801073e2:	0f 84 b8 00 00 00    	je     801074a0 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801073e8:	e8 b3 d9 ff ff       	call   80104da0 <myproc>
801073ed:	85 c0                	test   %eax,%eax
801073ef:	74 1d                	je     8010740e <trap+0x9e>
801073f1:	e8 aa d9 ff ff       	call   80104da0 <myproc>
801073f6:	8b 40 24             	mov    0x24(%eax),%eax
801073f9:	85 c0                	test   %eax,%eax
801073fb:	74 11                	je     8010740e <trap+0x9e>
801073fd:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80107401:	83 e0 03             	and    $0x3,%eax
80107404:	66 83 f8 03          	cmp    $0x3,%ax
80107408:	0f 84 0f 01 00 00    	je     8010751d <trap+0x1ad>
    exit();
}
8010740e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107411:	5b                   	pop    %ebx
80107412:	5e                   	pop    %esi
80107413:	5f                   	pop    %edi
80107414:	5d                   	pop    %ebp
80107415:	c3                   	ret    
80107416:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010741d:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
80107420:	e8 7b d9 ff ff       	call   80104da0 <myproc>
80107425:	8b 7b 38             	mov    0x38(%ebx),%edi
80107428:	85 c0                	test   %eax,%eax
8010742a:	0f 84 a2 01 00 00    	je     801075d2 <trap+0x262>
80107430:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80107434:	0f 84 98 01 00 00    	je     801075d2 <trap+0x262>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010743a:	0f 20 d1             	mov    %cr2,%ecx
8010743d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107440:	e8 3b d9 ff ff       	call   80104d80 <cpuid>
80107445:	8b 73 30             	mov    0x30(%ebx),%esi
80107448:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010744b:	8b 43 34             	mov    0x34(%ebx),%eax
8010744e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80107451:	e8 4a d9 ff ff       	call   80104da0 <myproc>
80107456:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107459:	e8 42 d9 ff ff       	call   80104da0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010745e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80107461:	8b 55 dc             	mov    -0x24(%ebp),%edx
80107464:	51                   	push   %ecx
80107465:	57                   	push   %edi
80107466:	52                   	push   %edx
80107467:	ff 75 e4             	push   -0x1c(%ebp)
8010746a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
8010746b:	8b 75 e0             	mov    -0x20(%ebp),%esi
8010746e:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107471:	56                   	push   %esi
80107472:	ff 70 10             	push   0x10(%eax)
80107475:	68 1c 95 10 80       	push   $0x8010951c
8010747a:	e8 81 92 ff ff       	call   80100700 <cprintf>
    myproc()->killed = 1;
8010747f:	83 c4 20             	add    $0x20,%esp
80107482:	e8 19 d9 ff ff       	call   80104da0 <myproc>
80107487:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010748e:	e8 0d d9 ff ff       	call   80104da0 <myproc>
80107493:	85 c0                	test   %eax,%eax
80107495:	0f 85 18 ff ff ff    	jne    801073b3 <trap+0x43>
8010749b:	e9 30 ff ff ff       	jmp    801073d0 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
801074a0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
801074a4:	0f 85 3e ff ff ff    	jne    801073e8 <trap+0x78>
    yield();
801074aa:	e8 71 df ff ff       	call   80105420 <yield>
801074af:	e9 34 ff ff ff       	jmp    801073e8 <trap+0x78>
801074b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801074b8:	8b 7b 38             	mov    0x38(%ebx),%edi
801074bb:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
801074bf:	e8 bc d8 ff ff       	call   80104d80 <cpuid>
801074c4:	57                   	push   %edi
801074c5:	56                   	push   %esi
801074c6:	50                   	push   %eax
801074c7:	68 c4 94 10 80       	push   $0x801094c4
801074cc:	e8 2f 92 ff ff       	call   80100700 <cprintf>
    lapiceoi();
801074d1:	e8 4a c8 ff ff       	call   80103d20 <lapiceoi>
    break;
801074d6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801074d9:	e8 c2 d8 ff ff       	call   80104da0 <myproc>
801074de:	85 c0                	test   %eax,%eax
801074e0:	0f 85 cd fe ff ff    	jne    801073b3 <trap+0x43>
801074e6:	e9 e5 fe ff ff       	jmp    801073d0 <trap+0x60>
801074eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801074ef:	90                   	nop
    if(myproc()->killed)
801074f0:	e8 ab d8 ff ff       	call   80104da0 <myproc>
801074f5:	8b 70 24             	mov    0x24(%eax),%esi
801074f8:	85 f6                	test   %esi,%esi
801074fa:	0f 85 c8 00 00 00    	jne    801075c8 <trap+0x258>
    myproc()->tf = tf;
80107500:	e8 9b d8 ff ff       	call   80104da0 <myproc>
80107505:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80107508:	e8 13 ec ff ff       	call   80106120 <syscall>
    if(myproc()->killed)
8010750d:	e8 8e d8 ff ff       	call   80104da0 <myproc>
80107512:	8b 48 24             	mov    0x24(%eax),%ecx
80107515:	85 c9                	test   %ecx,%ecx
80107517:	0f 84 f1 fe ff ff    	je     8010740e <trap+0x9e>
}
8010751d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107520:	5b                   	pop    %ebx
80107521:	5e                   	pop    %esi
80107522:	5f                   	pop    %edi
80107523:	5d                   	pop    %ebp
      exit();
80107524:	e9 97 dc ff ff       	jmp    801051c0 <exit>
80107529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80107530:	e8 3b 02 00 00       	call   80107770 <uartintr>
    lapiceoi();
80107535:	e8 e6 c7 ff ff       	call   80103d20 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010753a:	e8 61 d8 ff ff       	call   80104da0 <myproc>
8010753f:	85 c0                	test   %eax,%eax
80107541:	0f 85 6c fe ff ff    	jne    801073b3 <trap+0x43>
80107547:	e9 84 fe ff ff       	jmp    801073d0 <trap+0x60>
8010754c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80107550:	e8 8b c6 ff ff       	call   80103be0 <kbdintr>
    lapiceoi();
80107555:	e8 c6 c7 ff ff       	call   80103d20 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010755a:	e8 41 d8 ff ff       	call   80104da0 <myproc>
8010755f:	85 c0                	test   %eax,%eax
80107561:	0f 85 4c fe ff ff    	jne    801073b3 <trap+0x43>
80107567:	e9 64 fe ff ff       	jmp    801073d0 <trap+0x60>
8010756c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80107570:	e8 0b d8 ff ff       	call   80104d80 <cpuid>
80107575:	85 c0                	test   %eax,%eax
80107577:	0f 85 28 fe ff ff    	jne    801073a5 <trap+0x35>
      acquire(&tickslock);
8010757d:	83 ec 0c             	sub    $0xc,%esp
80107580:	68 00 7f 11 80       	push   $0x80117f00
80107585:	e8 d6 e6 ff ff       	call   80105c60 <acquire>
      wakeup(&ticks);
8010758a:	c7 04 24 e0 7e 11 80 	movl   $0x80117ee0,(%esp)
      ticks++;
80107591:	83 05 e0 7e 11 80 01 	addl   $0x1,0x80117ee0
      wakeup(&ticks);
80107598:	e8 93 df ff ff       	call   80105530 <wakeup>
      release(&tickslock);
8010759d:	c7 04 24 00 7f 11 80 	movl   $0x80117f00,(%esp)
801075a4:	e8 57 e6 ff ff       	call   80105c00 <release>
801075a9:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
801075ac:	e9 f4 fd ff ff       	jmp    801073a5 <trap+0x35>
801075b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
801075b8:	e8 03 dc ff ff       	call   801051c0 <exit>
801075bd:	e9 0e fe ff ff       	jmp    801073d0 <trap+0x60>
801075c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
801075c8:	e8 f3 db ff ff       	call   801051c0 <exit>
801075cd:	e9 2e ff ff ff       	jmp    80107500 <trap+0x190>
801075d2:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801075d5:	e8 a6 d7 ff ff       	call   80104d80 <cpuid>
801075da:	83 ec 0c             	sub    $0xc,%esp
801075dd:	56                   	push   %esi
801075de:	57                   	push   %edi
801075df:	50                   	push   %eax
801075e0:	ff 73 30             	push   0x30(%ebx)
801075e3:	68 e8 94 10 80       	push   $0x801094e8
801075e8:	e8 13 91 ff ff       	call   80100700 <cprintf>
      panic("trap");
801075ed:	83 c4 14             	add    $0x14,%esp
801075f0:	68 bc 94 10 80       	push   $0x801094bc
801075f5:	e8 86 8d ff ff       	call   80100380 <panic>
801075fa:	66 90                	xchg   %ax,%ax
801075fc:	66 90                	xchg   %ax,%ax
801075fe:	66 90                	xchg   %ax,%ax

80107600 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80107600:	a1 40 87 11 80       	mov    0x80118740,%eax
80107605:	85 c0                	test   %eax,%eax
80107607:	74 17                	je     80107620 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80107609:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010760e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
8010760f:	a8 01                	test   $0x1,%al
80107611:	74 0d                	je     80107620 <uartgetc+0x20>
80107613:	ba f8 03 00 00       	mov    $0x3f8,%edx
80107618:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80107619:	0f b6 c0             	movzbl %al,%eax
8010761c:	c3                   	ret    
8010761d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80107620:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107625:	c3                   	ret    
80107626:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010762d:	8d 76 00             	lea    0x0(%esi),%esi

80107630 <uartinit>:
{
80107630:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107631:	31 c9                	xor    %ecx,%ecx
80107633:	89 c8                	mov    %ecx,%eax
80107635:	89 e5                	mov    %esp,%ebp
80107637:	57                   	push   %edi
80107638:	bf fa 03 00 00       	mov    $0x3fa,%edi
8010763d:	56                   	push   %esi
8010763e:	89 fa                	mov    %edi,%edx
80107640:	53                   	push   %ebx
80107641:	83 ec 1c             	sub    $0x1c,%esp
80107644:	ee                   	out    %al,(%dx)
80107645:	be fb 03 00 00       	mov    $0x3fb,%esi
8010764a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010764f:	89 f2                	mov    %esi,%edx
80107651:	ee                   	out    %al,(%dx)
80107652:	b8 0c 00 00 00       	mov    $0xc,%eax
80107657:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010765c:	ee                   	out    %al,(%dx)
8010765d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80107662:	89 c8                	mov    %ecx,%eax
80107664:	89 da                	mov    %ebx,%edx
80107666:	ee                   	out    %al,(%dx)
80107667:	b8 03 00 00 00       	mov    $0x3,%eax
8010766c:	89 f2                	mov    %esi,%edx
8010766e:	ee                   	out    %al,(%dx)
8010766f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80107674:	89 c8                	mov    %ecx,%eax
80107676:	ee                   	out    %al,(%dx)
80107677:	b8 01 00 00 00       	mov    $0x1,%eax
8010767c:	89 da                	mov    %ebx,%edx
8010767e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010767f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80107684:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80107685:	3c ff                	cmp    $0xff,%al
80107687:	74 78                	je     80107701 <uartinit+0xd1>
  uart = 1;
80107689:	c7 05 40 87 11 80 01 	movl   $0x1,0x80118740
80107690:	00 00 00 
80107693:	89 fa                	mov    %edi,%edx
80107695:	ec                   	in     (%dx),%al
80107696:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010769b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010769c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010769f:	bf e0 95 10 80       	mov    $0x801095e0,%edi
801076a4:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
801076a9:	6a 00                	push   $0x0
801076ab:	6a 04                	push   $0x4
801076ad:	e8 de c1 ff ff       	call   80103890 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
801076b2:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
801076b6:	83 c4 10             	add    $0x10,%esp
801076b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
801076c0:	a1 40 87 11 80       	mov    0x80118740,%eax
801076c5:	bb 80 00 00 00       	mov    $0x80,%ebx
801076ca:	85 c0                	test   %eax,%eax
801076cc:	75 14                	jne    801076e2 <uartinit+0xb2>
801076ce:	eb 23                	jmp    801076f3 <uartinit+0xc3>
    microdelay(10);
801076d0:	83 ec 0c             	sub    $0xc,%esp
801076d3:	6a 0a                	push   $0xa
801076d5:	e8 66 c6 ff ff       	call   80103d40 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801076da:	83 c4 10             	add    $0x10,%esp
801076dd:	83 eb 01             	sub    $0x1,%ebx
801076e0:	74 07                	je     801076e9 <uartinit+0xb9>
801076e2:	89 f2                	mov    %esi,%edx
801076e4:	ec                   	in     (%dx),%al
801076e5:	a8 20                	test   $0x20,%al
801076e7:	74 e7                	je     801076d0 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801076e9:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801076ed:	ba f8 03 00 00       	mov    $0x3f8,%edx
801076f2:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
801076f3:	0f b6 47 01          	movzbl 0x1(%edi),%eax
801076f7:	83 c7 01             	add    $0x1,%edi
801076fa:	88 45 e7             	mov    %al,-0x19(%ebp)
801076fd:	84 c0                	test   %al,%al
801076ff:	75 bf                	jne    801076c0 <uartinit+0x90>
}
80107701:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107704:	5b                   	pop    %ebx
80107705:	5e                   	pop    %esi
80107706:	5f                   	pop    %edi
80107707:	5d                   	pop    %ebp
80107708:	c3                   	ret    
80107709:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107710 <uartputc>:
  if(!uart)
80107710:	a1 40 87 11 80       	mov    0x80118740,%eax
80107715:	85 c0                	test   %eax,%eax
80107717:	74 47                	je     80107760 <uartputc+0x50>
{
80107719:	55                   	push   %ebp
8010771a:	89 e5                	mov    %esp,%ebp
8010771c:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010771d:	be fd 03 00 00       	mov    $0x3fd,%esi
80107722:	53                   	push   %ebx
80107723:	bb 80 00 00 00       	mov    $0x80,%ebx
80107728:	eb 18                	jmp    80107742 <uartputc+0x32>
8010772a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80107730:	83 ec 0c             	sub    $0xc,%esp
80107733:	6a 0a                	push   $0xa
80107735:	e8 06 c6 ff ff       	call   80103d40 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010773a:	83 c4 10             	add    $0x10,%esp
8010773d:	83 eb 01             	sub    $0x1,%ebx
80107740:	74 07                	je     80107749 <uartputc+0x39>
80107742:	89 f2                	mov    %esi,%edx
80107744:	ec                   	in     (%dx),%al
80107745:	a8 20                	test   $0x20,%al
80107747:	74 e7                	je     80107730 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107749:	8b 45 08             	mov    0x8(%ebp),%eax
8010774c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80107751:	ee                   	out    %al,(%dx)
}
80107752:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107755:	5b                   	pop    %ebx
80107756:	5e                   	pop    %esi
80107757:	5d                   	pop    %ebp
80107758:	c3                   	ret    
80107759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107760:	c3                   	ret    
80107761:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107768:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010776f:	90                   	nop

80107770 <uartintr>:

void
uartintr(void)
{
80107770:	55                   	push   %ebp
80107771:	89 e5                	mov    %esp,%ebp
80107773:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80107776:	68 00 76 10 80       	push   $0x80107600
8010777b:	e8 c0 9d ff ff       	call   80101540 <consoleintr>
}
80107780:	83 c4 10             	add    $0x10,%esp
80107783:	c9                   	leave  
80107784:	c3                   	ret    

80107785 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80107785:	6a 00                	push   $0x0
  pushl $0
80107787:	6a 00                	push   $0x0
  jmp alltraps
80107789:	e9 0c fb ff ff       	jmp    8010729a <alltraps>

8010778e <vector1>:
.globl vector1
vector1:
  pushl $0
8010778e:	6a 00                	push   $0x0
  pushl $1
80107790:	6a 01                	push   $0x1
  jmp alltraps
80107792:	e9 03 fb ff ff       	jmp    8010729a <alltraps>

80107797 <vector2>:
.globl vector2
vector2:
  pushl $0
80107797:	6a 00                	push   $0x0
  pushl $2
80107799:	6a 02                	push   $0x2
  jmp alltraps
8010779b:	e9 fa fa ff ff       	jmp    8010729a <alltraps>

801077a0 <vector3>:
.globl vector3
vector3:
  pushl $0
801077a0:	6a 00                	push   $0x0
  pushl $3
801077a2:	6a 03                	push   $0x3
  jmp alltraps
801077a4:	e9 f1 fa ff ff       	jmp    8010729a <alltraps>

801077a9 <vector4>:
.globl vector4
vector4:
  pushl $0
801077a9:	6a 00                	push   $0x0
  pushl $4
801077ab:	6a 04                	push   $0x4
  jmp alltraps
801077ad:	e9 e8 fa ff ff       	jmp    8010729a <alltraps>

801077b2 <vector5>:
.globl vector5
vector5:
  pushl $0
801077b2:	6a 00                	push   $0x0
  pushl $5
801077b4:	6a 05                	push   $0x5
  jmp alltraps
801077b6:	e9 df fa ff ff       	jmp    8010729a <alltraps>

801077bb <vector6>:
.globl vector6
vector6:
  pushl $0
801077bb:	6a 00                	push   $0x0
  pushl $6
801077bd:	6a 06                	push   $0x6
  jmp alltraps
801077bf:	e9 d6 fa ff ff       	jmp    8010729a <alltraps>

801077c4 <vector7>:
.globl vector7
vector7:
  pushl $0
801077c4:	6a 00                	push   $0x0
  pushl $7
801077c6:	6a 07                	push   $0x7
  jmp alltraps
801077c8:	e9 cd fa ff ff       	jmp    8010729a <alltraps>

801077cd <vector8>:
.globl vector8
vector8:
  pushl $8
801077cd:	6a 08                	push   $0x8
  jmp alltraps
801077cf:	e9 c6 fa ff ff       	jmp    8010729a <alltraps>

801077d4 <vector9>:
.globl vector9
vector9:
  pushl $0
801077d4:	6a 00                	push   $0x0
  pushl $9
801077d6:	6a 09                	push   $0x9
  jmp alltraps
801077d8:	e9 bd fa ff ff       	jmp    8010729a <alltraps>

801077dd <vector10>:
.globl vector10
vector10:
  pushl $10
801077dd:	6a 0a                	push   $0xa
  jmp alltraps
801077df:	e9 b6 fa ff ff       	jmp    8010729a <alltraps>

801077e4 <vector11>:
.globl vector11
vector11:
  pushl $11
801077e4:	6a 0b                	push   $0xb
  jmp alltraps
801077e6:	e9 af fa ff ff       	jmp    8010729a <alltraps>

801077eb <vector12>:
.globl vector12
vector12:
  pushl $12
801077eb:	6a 0c                	push   $0xc
  jmp alltraps
801077ed:	e9 a8 fa ff ff       	jmp    8010729a <alltraps>

801077f2 <vector13>:
.globl vector13
vector13:
  pushl $13
801077f2:	6a 0d                	push   $0xd
  jmp alltraps
801077f4:	e9 a1 fa ff ff       	jmp    8010729a <alltraps>

801077f9 <vector14>:
.globl vector14
vector14:
  pushl $14
801077f9:	6a 0e                	push   $0xe
  jmp alltraps
801077fb:	e9 9a fa ff ff       	jmp    8010729a <alltraps>

80107800 <vector15>:
.globl vector15
vector15:
  pushl $0
80107800:	6a 00                	push   $0x0
  pushl $15
80107802:	6a 0f                	push   $0xf
  jmp alltraps
80107804:	e9 91 fa ff ff       	jmp    8010729a <alltraps>

80107809 <vector16>:
.globl vector16
vector16:
  pushl $0
80107809:	6a 00                	push   $0x0
  pushl $16
8010780b:	6a 10                	push   $0x10
  jmp alltraps
8010780d:	e9 88 fa ff ff       	jmp    8010729a <alltraps>

80107812 <vector17>:
.globl vector17
vector17:
  pushl $17
80107812:	6a 11                	push   $0x11
  jmp alltraps
80107814:	e9 81 fa ff ff       	jmp    8010729a <alltraps>

80107819 <vector18>:
.globl vector18
vector18:
  pushl $0
80107819:	6a 00                	push   $0x0
  pushl $18
8010781b:	6a 12                	push   $0x12
  jmp alltraps
8010781d:	e9 78 fa ff ff       	jmp    8010729a <alltraps>

80107822 <vector19>:
.globl vector19
vector19:
  pushl $0
80107822:	6a 00                	push   $0x0
  pushl $19
80107824:	6a 13                	push   $0x13
  jmp alltraps
80107826:	e9 6f fa ff ff       	jmp    8010729a <alltraps>

8010782b <vector20>:
.globl vector20
vector20:
  pushl $0
8010782b:	6a 00                	push   $0x0
  pushl $20
8010782d:	6a 14                	push   $0x14
  jmp alltraps
8010782f:	e9 66 fa ff ff       	jmp    8010729a <alltraps>

80107834 <vector21>:
.globl vector21
vector21:
  pushl $0
80107834:	6a 00                	push   $0x0
  pushl $21
80107836:	6a 15                	push   $0x15
  jmp alltraps
80107838:	e9 5d fa ff ff       	jmp    8010729a <alltraps>

8010783d <vector22>:
.globl vector22
vector22:
  pushl $0
8010783d:	6a 00                	push   $0x0
  pushl $22
8010783f:	6a 16                	push   $0x16
  jmp alltraps
80107841:	e9 54 fa ff ff       	jmp    8010729a <alltraps>

80107846 <vector23>:
.globl vector23
vector23:
  pushl $0
80107846:	6a 00                	push   $0x0
  pushl $23
80107848:	6a 17                	push   $0x17
  jmp alltraps
8010784a:	e9 4b fa ff ff       	jmp    8010729a <alltraps>

8010784f <vector24>:
.globl vector24
vector24:
  pushl $0
8010784f:	6a 00                	push   $0x0
  pushl $24
80107851:	6a 18                	push   $0x18
  jmp alltraps
80107853:	e9 42 fa ff ff       	jmp    8010729a <alltraps>

80107858 <vector25>:
.globl vector25
vector25:
  pushl $0
80107858:	6a 00                	push   $0x0
  pushl $25
8010785a:	6a 19                	push   $0x19
  jmp alltraps
8010785c:	e9 39 fa ff ff       	jmp    8010729a <alltraps>

80107861 <vector26>:
.globl vector26
vector26:
  pushl $0
80107861:	6a 00                	push   $0x0
  pushl $26
80107863:	6a 1a                	push   $0x1a
  jmp alltraps
80107865:	e9 30 fa ff ff       	jmp    8010729a <alltraps>

8010786a <vector27>:
.globl vector27
vector27:
  pushl $0
8010786a:	6a 00                	push   $0x0
  pushl $27
8010786c:	6a 1b                	push   $0x1b
  jmp alltraps
8010786e:	e9 27 fa ff ff       	jmp    8010729a <alltraps>

80107873 <vector28>:
.globl vector28
vector28:
  pushl $0
80107873:	6a 00                	push   $0x0
  pushl $28
80107875:	6a 1c                	push   $0x1c
  jmp alltraps
80107877:	e9 1e fa ff ff       	jmp    8010729a <alltraps>

8010787c <vector29>:
.globl vector29
vector29:
  pushl $0
8010787c:	6a 00                	push   $0x0
  pushl $29
8010787e:	6a 1d                	push   $0x1d
  jmp alltraps
80107880:	e9 15 fa ff ff       	jmp    8010729a <alltraps>

80107885 <vector30>:
.globl vector30
vector30:
  pushl $0
80107885:	6a 00                	push   $0x0
  pushl $30
80107887:	6a 1e                	push   $0x1e
  jmp alltraps
80107889:	e9 0c fa ff ff       	jmp    8010729a <alltraps>

8010788e <vector31>:
.globl vector31
vector31:
  pushl $0
8010788e:	6a 00                	push   $0x0
  pushl $31
80107890:	6a 1f                	push   $0x1f
  jmp alltraps
80107892:	e9 03 fa ff ff       	jmp    8010729a <alltraps>

80107897 <vector32>:
.globl vector32
vector32:
  pushl $0
80107897:	6a 00                	push   $0x0
  pushl $32
80107899:	6a 20                	push   $0x20
  jmp alltraps
8010789b:	e9 fa f9 ff ff       	jmp    8010729a <alltraps>

801078a0 <vector33>:
.globl vector33
vector33:
  pushl $0
801078a0:	6a 00                	push   $0x0
  pushl $33
801078a2:	6a 21                	push   $0x21
  jmp alltraps
801078a4:	e9 f1 f9 ff ff       	jmp    8010729a <alltraps>

801078a9 <vector34>:
.globl vector34
vector34:
  pushl $0
801078a9:	6a 00                	push   $0x0
  pushl $34
801078ab:	6a 22                	push   $0x22
  jmp alltraps
801078ad:	e9 e8 f9 ff ff       	jmp    8010729a <alltraps>

801078b2 <vector35>:
.globl vector35
vector35:
  pushl $0
801078b2:	6a 00                	push   $0x0
  pushl $35
801078b4:	6a 23                	push   $0x23
  jmp alltraps
801078b6:	e9 df f9 ff ff       	jmp    8010729a <alltraps>

801078bb <vector36>:
.globl vector36
vector36:
  pushl $0
801078bb:	6a 00                	push   $0x0
  pushl $36
801078bd:	6a 24                	push   $0x24
  jmp alltraps
801078bf:	e9 d6 f9 ff ff       	jmp    8010729a <alltraps>

801078c4 <vector37>:
.globl vector37
vector37:
  pushl $0
801078c4:	6a 00                	push   $0x0
  pushl $37
801078c6:	6a 25                	push   $0x25
  jmp alltraps
801078c8:	e9 cd f9 ff ff       	jmp    8010729a <alltraps>

801078cd <vector38>:
.globl vector38
vector38:
  pushl $0
801078cd:	6a 00                	push   $0x0
  pushl $38
801078cf:	6a 26                	push   $0x26
  jmp alltraps
801078d1:	e9 c4 f9 ff ff       	jmp    8010729a <alltraps>

801078d6 <vector39>:
.globl vector39
vector39:
  pushl $0
801078d6:	6a 00                	push   $0x0
  pushl $39
801078d8:	6a 27                	push   $0x27
  jmp alltraps
801078da:	e9 bb f9 ff ff       	jmp    8010729a <alltraps>

801078df <vector40>:
.globl vector40
vector40:
  pushl $0
801078df:	6a 00                	push   $0x0
  pushl $40
801078e1:	6a 28                	push   $0x28
  jmp alltraps
801078e3:	e9 b2 f9 ff ff       	jmp    8010729a <alltraps>

801078e8 <vector41>:
.globl vector41
vector41:
  pushl $0
801078e8:	6a 00                	push   $0x0
  pushl $41
801078ea:	6a 29                	push   $0x29
  jmp alltraps
801078ec:	e9 a9 f9 ff ff       	jmp    8010729a <alltraps>

801078f1 <vector42>:
.globl vector42
vector42:
  pushl $0
801078f1:	6a 00                	push   $0x0
  pushl $42
801078f3:	6a 2a                	push   $0x2a
  jmp alltraps
801078f5:	e9 a0 f9 ff ff       	jmp    8010729a <alltraps>

801078fa <vector43>:
.globl vector43
vector43:
  pushl $0
801078fa:	6a 00                	push   $0x0
  pushl $43
801078fc:	6a 2b                	push   $0x2b
  jmp alltraps
801078fe:	e9 97 f9 ff ff       	jmp    8010729a <alltraps>

80107903 <vector44>:
.globl vector44
vector44:
  pushl $0
80107903:	6a 00                	push   $0x0
  pushl $44
80107905:	6a 2c                	push   $0x2c
  jmp alltraps
80107907:	e9 8e f9 ff ff       	jmp    8010729a <alltraps>

8010790c <vector45>:
.globl vector45
vector45:
  pushl $0
8010790c:	6a 00                	push   $0x0
  pushl $45
8010790e:	6a 2d                	push   $0x2d
  jmp alltraps
80107910:	e9 85 f9 ff ff       	jmp    8010729a <alltraps>

80107915 <vector46>:
.globl vector46
vector46:
  pushl $0
80107915:	6a 00                	push   $0x0
  pushl $46
80107917:	6a 2e                	push   $0x2e
  jmp alltraps
80107919:	e9 7c f9 ff ff       	jmp    8010729a <alltraps>

8010791e <vector47>:
.globl vector47
vector47:
  pushl $0
8010791e:	6a 00                	push   $0x0
  pushl $47
80107920:	6a 2f                	push   $0x2f
  jmp alltraps
80107922:	e9 73 f9 ff ff       	jmp    8010729a <alltraps>

80107927 <vector48>:
.globl vector48
vector48:
  pushl $0
80107927:	6a 00                	push   $0x0
  pushl $48
80107929:	6a 30                	push   $0x30
  jmp alltraps
8010792b:	e9 6a f9 ff ff       	jmp    8010729a <alltraps>

80107930 <vector49>:
.globl vector49
vector49:
  pushl $0
80107930:	6a 00                	push   $0x0
  pushl $49
80107932:	6a 31                	push   $0x31
  jmp alltraps
80107934:	e9 61 f9 ff ff       	jmp    8010729a <alltraps>

80107939 <vector50>:
.globl vector50
vector50:
  pushl $0
80107939:	6a 00                	push   $0x0
  pushl $50
8010793b:	6a 32                	push   $0x32
  jmp alltraps
8010793d:	e9 58 f9 ff ff       	jmp    8010729a <alltraps>

80107942 <vector51>:
.globl vector51
vector51:
  pushl $0
80107942:	6a 00                	push   $0x0
  pushl $51
80107944:	6a 33                	push   $0x33
  jmp alltraps
80107946:	e9 4f f9 ff ff       	jmp    8010729a <alltraps>

8010794b <vector52>:
.globl vector52
vector52:
  pushl $0
8010794b:	6a 00                	push   $0x0
  pushl $52
8010794d:	6a 34                	push   $0x34
  jmp alltraps
8010794f:	e9 46 f9 ff ff       	jmp    8010729a <alltraps>

80107954 <vector53>:
.globl vector53
vector53:
  pushl $0
80107954:	6a 00                	push   $0x0
  pushl $53
80107956:	6a 35                	push   $0x35
  jmp alltraps
80107958:	e9 3d f9 ff ff       	jmp    8010729a <alltraps>

8010795d <vector54>:
.globl vector54
vector54:
  pushl $0
8010795d:	6a 00                	push   $0x0
  pushl $54
8010795f:	6a 36                	push   $0x36
  jmp alltraps
80107961:	e9 34 f9 ff ff       	jmp    8010729a <alltraps>

80107966 <vector55>:
.globl vector55
vector55:
  pushl $0
80107966:	6a 00                	push   $0x0
  pushl $55
80107968:	6a 37                	push   $0x37
  jmp alltraps
8010796a:	e9 2b f9 ff ff       	jmp    8010729a <alltraps>

8010796f <vector56>:
.globl vector56
vector56:
  pushl $0
8010796f:	6a 00                	push   $0x0
  pushl $56
80107971:	6a 38                	push   $0x38
  jmp alltraps
80107973:	e9 22 f9 ff ff       	jmp    8010729a <alltraps>

80107978 <vector57>:
.globl vector57
vector57:
  pushl $0
80107978:	6a 00                	push   $0x0
  pushl $57
8010797a:	6a 39                	push   $0x39
  jmp alltraps
8010797c:	e9 19 f9 ff ff       	jmp    8010729a <alltraps>

80107981 <vector58>:
.globl vector58
vector58:
  pushl $0
80107981:	6a 00                	push   $0x0
  pushl $58
80107983:	6a 3a                	push   $0x3a
  jmp alltraps
80107985:	e9 10 f9 ff ff       	jmp    8010729a <alltraps>

8010798a <vector59>:
.globl vector59
vector59:
  pushl $0
8010798a:	6a 00                	push   $0x0
  pushl $59
8010798c:	6a 3b                	push   $0x3b
  jmp alltraps
8010798e:	e9 07 f9 ff ff       	jmp    8010729a <alltraps>

80107993 <vector60>:
.globl vector60
vector60:
  pushl $0
80107993:	6a 00                	push   $0x0
  pushl $60
80107995:	6a 3c                	push   $0x3c
  jmp alltraps
80107997:	e9 fe f8 ff ff       	jmp    8010729a <alltraps>

8010799c <vector61>:
.globl vector61
vector61:
  pushl $0
8010799c:	6a 00                	push   $0x0
  pushl $61
8010799e:	6a 3d                	push   $0x3d
  jmp alltraps
801079a0:	e9 f5 f8 ff ff       	jmp    8010729a <alltraps>

801079a5 <vector62>:
.globl vector62
vector62:
  pushl $0
801079a5:	6a 00                	push   $0x0
  pushl $62
801079a7:	6a 3e                	push   $0x3e
  jmp alltraps
801079a9:	e9 ec f8 ff ff       	jmp    8010729a <alltraps>

801079ae <vector63>:
.globl vector63
vector63:
  pushl $0
801079ae:	6a 00                	push   $0x0
  pushl $63
801079b0:	6a 3f                	push   $0x3f
  jmp alltraps
801079b2:	e9 e3 f8 ff ff       	jmp    8010729a <alltraps>

801079b7 <vector64>:
.globl vector64
vector64:
  pushl $0
801079b7:	6a 00                	push   $0x0
  pushl $64
801079b9:	6a 40                	push   $0x40
  jmp alltraps
801079bb:	e9 da f8 ff ff       	jmp    8010729a <alltraps>

801079c0 <vector65>:
.globl vector65
vector65:
  pushl $0
801079c0:	6a 00                	push   $0x0
  pushl $65
801079c2:	6a 41                	push   $0x41
  jmp alltraps
801079c4:	e9 d1 f8 ff ff       	jmp    8010729a <alltraps>

801079c9 <vector66>:
.globl vector66
vector66:
  pushl $0
801079c9:	6a 00                	push   $0x0
  pushl $66
801079cb:	6a 42                	push   $0x42
  jmp alltraps
801079cd:	e9 c8 f8 ff ff       	jmp    8010729a <alltraps>

801079d2 <vector67>:
.globl vector67
vector67:
  pushl $0
801079d2:	6a 00                	push   $0x0
  pushl $67
801079d4:	6a 43                	push   $0x43
  jmp alltraps
801079d6:	e9 bf f8 ff ff       	jmp    8010729a <alltraps>

801079db <vector68>:
.globl vector68
vector68:
  pushl $0
801079db:	6a 00                	push   $0x0
  pushl $68
801079dd:	6a 44                	push   $0x44
  jmp alltraps
801079df:	e9 b6 f8 ff ff       	jmp    8010729a <alltraps>

801079e4 <vector69>:
.globl vector69
vector69:
  pushl $0
801079e4:	6a 00                	push   $0x0
  pushl $69
801079e6:	6a 45                	push   $0x45
  jmp alltraps
801079e8:	e9 ad f8 ff ff       	jmp    8010729a <alltraps>

801079ed <vector70>:
.globl vector70
vector70:
  pushl $0
801079ed:	6a 00                	push   $0x0
  pushl $70
801079ef:	6a 46                	push   $0x46
  jmp alltraps
801079f1:	e9 a4 f8 ff ff       	jmp    8010729a <alltraps>

801079f6 <vector71>:
.globl vector71
vector71:
  pushl $0
801079f6:	6a 00                	push   $0x0
  pushl $71
801079f8:	6a 47                	push   $0x47
  jmp alltraps
801079fa:	e9 9b f8 ff ff       	jmp    8010729a <alltraps>

801079ff <vector72>:
.globl vector72
vector72:
  pushl $0
801079ff:	6a 00                	push   $0x0
  pushl $72
80107a01:	6a 48                	push   $0x48
  jmp alltraps
80107a03:	e9 92 f8 ff ff       	jmp    8010729a <alltraps>

80107a08 <vector73>:
.globl vector73
vector73:
  pushl $0
80107a08:	6a 00                	push   $0x0
  pushl $73
80107a0a:	6a 49                	push   $0x49
  jmp alltraps
80107a0c:	e9 89 f8 ff ff       	jmp    8010729a <alltraps>

80107a11 <vector74>:
.globl vector74
vector74:
  pushl $0
80107a11:	6a 00                	push   $0x0
  pushl $74
80107a13:	6a 4a                	push   $0x4a
  jmp alltraps
80107a15:	e9 80 f8 ff ff       	jmp    8010729a <alltraps>

80107a1a <vector75>:
.globl vector75
vector75:
  pushl $0
80107a1a:	6a 00                	push   $0x0
  pushl $75
80107a1c:	6a 4b                	push   $0x4b
  jmp alltraps
80107a1e:	e9 77 f8 ff ff       	jmp    8010729a <alltraps>

80107a23 <vector76>:
.globl vector76
vector76:
  pushl $0
80107a23:	6a 00                	push   $0x0
  pushl $76
80107a25:	6a 4c                	push   $0x4c
  jmp alltraps
80107a27:	e9 6e f8 ff ff       	jmp    8010729a <alltraps>

80107a2c <vector77>:
.globl vector77
vector77:
  pushl $0
80107a2c:	6a 00                	push   $0x0
  pushl $77
80107a2e:	6a 4d                	push   $0x4d
  jmp alltraps
80107a30:	e9 65 f8 ff ff       	jmp    8010729a <alltraps>

80107a35 <vector78>:
.globl vector78
vector78:
  pushl $0
80107a35:	6a 00                	push   $0x0
  pushl $78
80107a37:	6a 4e                	push   $0x4e
  jmp alltraps
80107a39:	e9 5c f8 ff ff       	jmp    8010729a <alltraps>

80107a3e <vector79>:
.globl vector79
vector79:
  pushl $0
80107a3e:	6a 00                	push   $0x0
  pushl $79
80107a40:	6a 4f                	push   $0x4f
  jmp alltraps
80107a42:	e9 53 f8 ff ff       	jmp    8010729a <alltraps>

80107a47 <vector80>:
.globl vector80
vector80:
  pushl $0
80107a47:	6a 00                	push   $0x0
  pushl $80
80107a49:	6a 50                	push   $0x50
  jmp alltraps
80107a4b:	e9 4a f8 ff ff       	jmp    8010729a <alltraps>

80107a50 <vector81>:
.globl vector81
vector81:
  pushl $0
80107a50:	6a 00                	push   $0x0
  pushl $81
80107a52:	6a 51                	push   $0x51
  jmp alltraps
80107a54:	e9 41 f8 ff ff       	jmp    8010729a <alltraps>

80107a59 <vector82>:
.globl vector82
vector82:
  pushl $0
80107a59:	6a 00                	push   $0x0
  pushl $82
80107a5b:	6a 52                	push   $0x52
  jmp alltraps
80107a5d:	e9 38 f8 ff ff       	jmp    8010729a <alltraps>

80107a62 <vector83>:
.globl vector83
vector83:
  pushl $0
80107a62:	6a 00                	push   $0x0
  pushl $83
80107a64:	6a 53                	push   $0x53
  jmp alltraps
80107a66:	e9 2f f8 ff ff       	jmp    8010729a <alltraps>

80107a6b <vector84>:
.globl vector84
vector84:
  pushl $0
80107a6b:	6a 00                	push   $0x0
  pushl $84
80107a6d:	6a 54                	push   $0x54
  jmp alltraps
80107a6f:	e9 26 f8 ff ff       	jmp    8010729a <alltraps>

80107a74 <vector85>:
.globl vector85
vector85:
  pushl $0
80107a74:	6a 00                	push   $0x0
  pushl $85
80107a76:	6a 55                	push   $0x55
  jmp alltraps
80107a78:	e9 1d f8 ff ff       	jmp    8010729a <alltraps>

80107a7d <vector86>:
.globl vector86
vector86:
  pushl $0
80107a7d:	6a 00                	push   $0x0
  pushl $86
80107a7f:	6a 56                	push   $0x56
  jmp alltraps
80107a81:	e9 14 f8 ff ff       	jmp    8010729a <alltraps>

80107a86 <vector87>:
.globl vector87
vector87:
  pushl $0
80107a86:	6a 00                	push   $0x0
  pushl $87
80107a88:	6a 57                	push   $0x57
  jmp alltraps
80107a8a:	e9 0b f8 ff ff       	jmp    8010729a <alltraps>

80107a8f <vector88>:
.globl vector88
vector88:
  pushl $0
80107a8f:	6a 00                	push   $0x0
  pushl $88
80107a91:	6a 58                	push   $0x58
  jmp alltraps
80107a93:	e9 02 f8 ff ff       	jmp    8010729a <alltraps>

80107a98 <vector89>:
.globl vector89
vector89:
  pushl $0
80107a98:	6a 00                	push   $0x0
  pushl $89
80107a9a:	6a 59                	push   $0x59
  jmp alltraps
80107a9c:	e9 f9 f7 ff ff       	jmp    8010729a <alltraps>

80107aa1 <vector90>:
.globl vector90
vector90:
  pushl $0
80107aa1:	6a 00                	push   $0x0
  pushl $90
80107aa3:	6a 5a                	push   $0x5a
  jmp alltraps
80107aa5:	e9 f0 f7 ff ff       	jmp    8010729a <alltraps>

80107aaa <vector91>:
.globl vector91
vector91:
  pushl $0
80107aaa:	6a 00                	push   $0x0
  pushl $91
80107aac:	6a 5b                	push   $0x5b
  jmp alltraps
80107aae:	e9 e7 f7 ff ff       	jmp    8010729a <alltraps>

80107ab3 <vector92>:
.globl vector92
vector92:
  pushl $0
80107ab3:	6a 00                	push   $0x0
  pushl $92
80107ab5:	6a 5c                	push   $0x5c
  jmp alltraps
80107ab7:	e9 de f7 ff ff       	jmp    8010729a <alltraps>

80107abc <vector93>:
.globl vector93
vector93:
  pushl $0
80107abc:	6a 00                	push   $0x0
  pushl $93
80107abe:	6a 5d                	push   $0x5d
  jmp alltraps
80107ac0:	e9 d5 f7 ff ff       	jmp    8010729a <alltraps>

80107ac5 <vector94>:
.globl vector94
vector94:
  pushl $0
80107ac5:	6a 00                	push   $0x0
  pushl $94
80107ac7:	6a 5e                	push   $0x5e
  jmp alltraps
80107ac9:	e9 cc f7 ff ff       	jmp    8010729a <alltraps>

80107ace <vector95>:
.globl vector95
vector95:
  pushl $0
80107ace:	6a 00                	push   $0x0
  pushl $95
80107ad0:	6a 5f                	push   $0x5f
  jmp alltraps
80107ad2:	e9 c3 f7 ff ff       	jmp    8010729a <alltraps>

80107ad7 <vector96>:
.globl vector96
vector96:
  pushl $0
80107ad7:	6a 00                	push   $0x0
  pushl $96
80107ad9:	6a 60                	push   $0x60
  jmp alltraps
80107adb:	e9 ba f7 ff ff       	jmp    8010729a <alltraps>

80107ae0 <vector97>:
.globl vector97
vector97:
  pushl $0
80107ae0:	6a 00                	push   $0x0
  pushl $97
80107ae2:	6a 61                	push   $0x61
  jmp alltraps
80107ae4:	e9 b1 f7 ff ff       	jmp    8010729a <alltraps>

80107ae9 <vector98>:
.globl vector98
vector98:
  pushl $0
80107ae9:	6a 00                	push   $0x0
  pushl $98
80107aeb:	6a 62                	push   $0x62
  jmp alltraps
80107aed:	e9 a8 f7 ff ff       	jmp    8010729a <alltraps>

80107af2 <vector99>:
.globl vector99
vector99:
  pushl $0
80107af2:	6a 00                	push   $0x0
  pushl $99
80107af4:	6a 63                	push   $0x63
  jmp alltraps
80107af6:	e9 9f f7 ff ff       	jmp    8010729a <alltraps>

80107afb <vector100>:
.globl vector100
vector100:
  pushl $0
80107afb:	6a 00                	push   $0x0
  pushl $100
80107afd:	6a 64                	push   $0x64
  jmp alltraps
80107aff:	e9 96 f7 ff ff       	jmp    8010729a <alltraps>

80107b04 <vector101>:
.globl vector101
vector101:
  pushl $0
80107b04:	6a 00                	push   $0x0
  pushl $101
80107b06:	6a 65                	push   $0x65
  jmp alltraps
80107b08:	e9 8d f7 ff ff       	jmp    8010729a <alltraps>

80107b0d <vector102>:
.globl vector102
vector102:
  pushl $0
80107b0d:	6a 00                	push   $0x0
  pushl $102
80107b0f:	6a 66                	push   $0x66
  jmp alltraps
80107b11:	e9 84 f7 ff ff       	jmp    8010729a <alltraps>

80107b16 <vector103>:
.globl vector103
vector103:
  pushl $0
80107b16:	6a 00                	push   $0x0
  pushl $103
80107b18:	6a 67                	push   $0x67
  jmp alltraps
80107b1a:	e9 7b f7 ff ff       	jmp    8010729a <alltraps>

80107b1f <vector104>:
.globl vector104
vector104:
  pushl $0
80107b1f:	6a 00                	push   $0x0
  pushl $104
80107b21:	6a 68                	push   $0x68
  jmp alltraps
80107b23:	e9 72 f7 ff ff       	jmp    8010729a <alltraps>

80107b28 <vector105>:
.globl vector105
vector105:
  pushl $0
80107b28:	6a 00                	push   $0x0
  pushl $105
80107b2a:	6a 69                	push   $0x69
  jmp alltraps
80107b2c:	e9 69 f7 ff ff       	jmp    8010729a <alltraps>

80107b31 <vector106>:
.globl vector106
vector106:
  pushl $0
80107b31:	6a 00                	push   $0x0
  pushl $106
80107b33:	6a 6a                	push   $0x6a
  jmp alltraps
80107b35:	e9 60 f7 ff ff       	jmp    8010729a <alltraps>

80107b3a <vector107>:
.globl vector107
vector107:
  pushl $0
80107b3a:	6a 00                	push   $0x0
  pushl $107
80107b3c:	6a 6b                	push   $0x6b
  jmp alltraps
80107b3e:	e9 57 f7 ff ff       	jmp    8010729a <alltraps>

80107b43 <vector108>:
.globl vector108
vector108:
  pushl $0
80107b43:	6a 00                	push   $0x0
  pushl $108
80107b45:	6a 6c                	push   $0x6c
  jmp alltraps
80107b47:	e9 4e f7 ff ff       	jmp    8010729a <alltraps>

80107b4c <vector109>:
.globl vector109
vector109:
  pushl $0
80107b4c:	6a 00                	push   $0x0
  pushl $109
80107b4e:	6a 6d                	push   $0x6d
  jmp alltraps
80107b50:	e9 45 f7 ff ff       	jmp    8010729a <alltraps>

80107b55 <vector110>:
.globl vector110
vector110:
  pushl $0
80107b55:	6a 00                	push   $0x0
  pushl $110
80107b57:	6a 6e                	push   $0x6e
  jmp alltraps
80107b59:	e9 3c f7 ff ff       	jmp    8010729a <alltraps>

80107b5e <vector111>:
.globl vector111
vector111:
  pushl $0
80107b5e:	6a 00                	push   $0x0
  pushl $111
80107b60:	6a 6f                	push   $0x6f
  jmp alltraps
80107b62:	e9 33 f7 ff ff       	jmp    8010729a <alltraps>

80107b67 <vector112>:
.globl vector112
vector112:
  pushl $0
80107b67:	6a 00                	push   $0x0
  pushl $112
80107b69:	6a 70                	push   $0x70
  jmp alltraps
80107b6b:	e9 2a f7 ff ff       	jmp    8010729a <alltraps>

80107b70 <vector113>:
.globl vector113
vector113:
  pushl $0
80107b70:	6a 00                	push   $0x0
  pushl $113
80107b72:	6a 71                	push   $0x71
  jmp alltraps
80107b74:	e9 21 f7 ff ff       	jmp    8010729a <alltraps>

80107b79 <vector114>:
.globl vector114
vector114:
  pushl $0
80107b79:	6a 00                	push   $0x0
  pushl $114
80107b7b:	6a 72                	push   $0x72
  jmp alltraps
80107b7d:	e9 18 f7 ff ff       	jmp    8010729a <alltraps>

80107b82 <vector115>:
.globl vector115
vector115:
  pushl $0
80107b82:	6a 00                	push   $0x0
  pushl $115
80107b84:	6a 73                	push   $0x73
  jmp alltraps
80107b86:	e9 0f f7 ff ff       	jmp    8010729a <alltraps>

80107b8b <vector116>:
.globl vector116
vector116:
  pushl $0
80107b8b:	6a 00                	push   $0x0
  pushl $116
80107b8d:	6a 74                	push   $0x74
  jmp alltraps
80107b8f:	e9 06 f7 ff ff       	jmp    8010729a <alltraps>

80107b94 <vector117>:
.globl vector117
vector117:
  pushl $0
80107b94:	6a 00                	push   $0x0
  pushl $117
80107b96:	6a 75                	push   $0x75
  jmp alltraps
80107b98:	e9 fd f6 ff ff       	jmp    8010729a <alltraps>

80107b9d <vector118>:
.globl vector118
vector118:
  pushl $0
80107b9d:	6a 00                	push   $0x0
  pushl $118
80107b9f:	6a 76                	push   $0x76
  jmp alltraps
80107ba1:	e9 f4 f6 ff ff       	jmp    8010729a <alltraps>

80107ba6 <vector119>:
.globl vector119
vector119:
  pushl $0
80107ba6:	6a 00                	push   $0x0
  pushl $119
80107ba8:	6a 77                	push   $0x77
  jmp alltraps
80107baa:	e9 eb f6 ff ff       	jmp    8010729a <alltraps>

80107baf <vector120>:
.globl vector120
vector120:
  pushl $0
80107baf:	6a 00                	push   $0x0
  pushl $120
80107bb1:	6a 78                	push   $0x78
  jmp alltraps
80107bb3:	e9 e2 f6 ff ff       	jmp    8010729a <alltraps>

80107bb8 <vector121>:
.globl vector121
vector121:
  pushl $0
80107bb8:	6a 00                	push   $0x0
  pushl $121
80107bba:	6a 79                	push   $0x79
  jmp alltraps
80107bbc:	e9 d9 f6 ff ff       	jmp    8010729a <alltraps>

80107bc1 <vector122>:
.globl vector122
vector122:
  pushl $0
80107bc1:	6a 00                	push   $0x0
  pushl $122
80107bc3:	6a 7a                	push   $0x7a
  jmp alltraps
80107bc5:	e9 d0 f6 ff ff       	jmp    8010729a <alltraps>

80107bca <vector123>:
.globl vector123
vector123:
  pushl $0
80107bca:	6a 00                	push   $0x0
  pushl $123
80107bcc:	6a 7b                	push   $0x7b
  jmp alltraps
80107bce:	e9 c7 f6 ff ff       	jmp    8010729a <alltraps>

80107bd3 <vector124>:
.globl vector124
vector124:
  pushl $0
80107bd3:	6a 00                	push   $0x0
  pushl $124
80107bd5:	6a 7c                	push   $0x7c
  jmp alltraps
80107bd7:	e9 be f6 ff ff       	jmp    8010729a <alltraps>

80107bdc <vector125>:
.globl vector125
vector125:
  pushl $0
80107bdc:	6a 00                	push   $0x0
  pushl $125
80107bde:	6a 7d                	push   $0x7d
  jmp alltraps
80107be0:	e9 b5 f6 ff ff       	jmp    8010729a <alltraps>

80107be5 <vector126>:
.globl vector126
vector126:
  pushl $0
80107be5:	6a 00                	push   $0x0
  pushl $126
80107be7:	6a 7e                	push   $0x7e
  jmp alltraps
80107be9:	e9 ac f6 ff ff       	jmp    8010729a <alltraps>

80107bee <vector127>:
.globl vector127
vector127:
  pushl $0
80107bee:	6a 00                	push   $0x0
  pushl $127
80107bf0:	6a 7f                	push   $0x7f
  jmp alltraps
80107bf2:	e9 a3 f6 ff ff       	jmp    8010729a <alltraps>

80107bf7 <vector128>:
.globl vector128
vector128:
  pushl $0
80107bf7:	6a 00                	push   $0x0
  pushl $128
80107bf9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80107bfe:	e9 97 f6 ff ff       	jmp    8010729a <alltraps>

80107c03 <vector129>:
.globl vector129
vector129:
  pushl $0
80107c03:	6a 00                	push   $0x0
  pushl $129
80107c05:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80107c0a:	e9 8b f6 ff ff       	jmp    8010729a <alltraps>

80107c0f <vector130>:
.globl vector130
vector130:
  pushl $0
80107c0f:	6a 00                	push   $0x0
  pushl $130
80107c11:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80107c16:	e9 7f f6 ff ff       	jmp    8010729a <alltraps>

80107c1b <vector131>:
.globl vector131
vector131:
  pushl $0
80107c1b:	6a 00                	push   $0x0
  pushl $131
80107c1d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80107c22:	e9 73 f6 ff ff       	jmp    8010729a <alltraps>

80107c27 <vector132>:
.globl vector132
vector132:
  pushl $0
80107c27:	6a 00                	push   $0x0
  pushl $132
80107c29:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80107c2e:	e9 67 f6 ff ff       	jmp    8010729a <alltraps>

80107c33 <vector133>:
.globl vector133
vector133:
  pushl $0
80107c33:	6a 00                	push   $0x0
  pushl $133
80107c35:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80107c3a:	e9 5b f6 ff ff       	jmp    8010729a <alltraps>

80107c3f <vector134>:
.globl vector134
vector134:
  pushl $0
80107c3f:	6a 00                	push   $0x0
  pushl $134
80107c41:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80107c46:	e9 4f f6 ff ff       	jmp    8010729a <alltraps>

80107c4b <vector135>:
.globl vector135
vector135:
  pushl $0
80107c4b:	6a 00                	push   $0x0
  pushl $135
80107c4d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107c52:	e9 43 f6 ff ff       	jmp    8010729a <alltraps>

80107c57 <vector136>:
.globl vector136
vector136:
  pushl $0
80107c57:	6a 00                	push   $0x0
  pushl $136
80107c59:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80107c5e:	e9 37 f6 ff ff       	jmp    8010729a <alltraps>

80107c63 <vector137>:
.globl vector137
vector137:
  pushl $0
80107c63:	6a 00                	push   $0x0
  pushl $137
80107c65:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80107c6a:	e9 2b f6 ff ff       	jmp    8010729a <alltraps>

80107c6f <vector138>:
.globl vector138
vector138:
  pushl $0
80107c6f:	6a 00                	push   $0x0
  pushl $138
80107c71:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80107c76:	e9 1f f6 ff ff       	jmp    8010729a <alltraps>

80107c7b <vector139>:
.globl vector139
vector139:
  pushl $0
80107c7b:	6a 00                	push   $0x0
  pushl $139
80107c7d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107c82:	e9 13 f6 ff ff       	jmp    8010729a <alltraps>

80107c87 <vector140>:
.globl vector140
vector140:
  pushl $0
80107c87:	6a 00                	push   $0x0
  pushl $140
80107c89:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80107c8e:	e9 07 f6 ff ff       	jmp    8010729a <alltraps>

80107c93 <vector141>:
.globl vector141
vector141:
  pushl $0
80107c93:	6a 00                	push   $0x0
  pushl $141
80107c95:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80107c9a:	e9 fb f5 ff ff       	jmp    8010729a <alltraps>

80107c9f <vector142>:
.globl vector142
vector142:
  pushl $0
80107c9f:	6a 00                	push   $0x0
  pushl $142
80107ca1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107ca6:	e9 ef f5 ff ff       	jmp    8010729a <alltraps>

80107cab <vector143>:
.globl vector143
vector143:
  pushl $0
80107cab:	6a 00                	push   $0x0
  pushl $143
80107cad:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107cb2:	e9 e3 f5 ff ff       	jmp    8010729a <alltraps>

80107cb7 <vector144>:
.globl vector144
vector144:
  pushl $0
80107cb7:	6a 00                	push   $0x0
  pushl $144
80107cb9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80107cbe:	e9 d7 f5 ff ff       	jmp    8010729a <alltraps>

80107cc3 <vector145>:
.globl vector145
vector145:
  pushl $0
80107cc3:	6a 00                	push   $0x0
  pushl $145
80107cc5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80107cca:	e9 cb f5 ff ff       	jmp    8010729a <alltraps>

80107ccf <vector146>:
.globl vector146
vector146:
  pushl $0
80107ccf:	6a 00                	push   $0x0
  pushl $146
80107cd1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80107cd6:	e9 bf f5 ff ff       	jmp    8010729a <alltraps>

80107cdb <vector147>:
.globl vector147
vector147:
  pushl $0
80107cdb:	6a 00                	push   $0x0
  pushl $147
80107cdd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107ce2:	e9 b3 f5 ff ff       	jmp    8010729a <alltraps>

80107ce7 <vector148>:
.globl vector148
vector148:
  pushl $0
80107ce7:	6a 00                	push   $0x0
  pushl $148
80107ce9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80107cee:	e9 a7 f5 ff ff       	jmp    8010729a <alltraps>

80107cf3 <vector149>:
.globl vector149
vector149:
  pushl $0
80107cf3:	6a 00                	push   $0x0
  pushl $149
80107cf5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80107cfa:	e9 9b f5 ff ff       	jmp    8010729a <alltraps>

80107cff <vector150>:
.globl vector150
vector150:
  pushl $0
80107cff:	6a 00                	push   $0x0
  pushl $150
80107d01:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80107d06:	e9 8f f5 ff ff       	jmp    8010729a <alltraps>

80107d0b <vector151>:
.globl vector151
vector151:
  pushl $0
80107d0b:	6a 00                	push   $0x0
  pushl $151
80107d0d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107d12:	e9 83 f5 ff ff       	jmp    8010729a <alltraps>

80107d17 <vector152>:
.globl vector152
vector152:
  pushl $0
80107d17:	6a 00                	push   $0x0
  pushl $152
80107d19:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80107d1e:	e9 77 f5 ff ff       	jmp    8010729a <alltraps>

80107d23 <vector153>:
.globl vector153
vector153:
  pushl $0
80107d23:	6a 00                	push   $0x0
  pushl $153
80107d25:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80107d2a:	e9 6b f5 ff ff       	jmp    8010729a <alltraps>

80107d2f <vector154>:
.globl vector154
vector154:
  pushl $0
80107d2f:	6a 00                	push   $0x0
  pushl $154
80107d31:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107d36:	e9 5f f5 ff ff       	jmp    8010729a <alltraps>

80107d3b <vector155>:
.globl vector155
vector155:
  pushl $0
80107d3b:	6a 00                	push   $0x0
  pushl $155
80107d3d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107d42:	e9 53 f5 ff ff       	jmp    8010729a <alltraps>

80107d47 <vector156>:
.globl vector156
vector156:
  pushl $0
80107d47:	6a 00                	push   $0x0
  pushl $156
80107d49:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80107d4e:	e9 47 f5 ff ff       	jmp    8010729a <alltraps>

80107d53 <vector157>:
.globl vector157
vector157:
  pushl $0
80107d53:	6a 00                	push   $0x0
  pushl $157
80107d55:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80107d5a:	e9 3b f5 ff ff       	jmp    8010729a <alltraps>

80107d5f <vector158>:
.globl vector158
vector158:
  pushl $0
80107d5f:	6a 00                	push   $0x0
  pushl $158
80107d61:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107d66:	e9 2f f5 ff ff       	jmp    8010729a <alltraps>

80107d6b <vector159>:
.globl vector159
vector159:
  pushl $0
80107d6b:	6a 00                	push   $0x0
  pushl $159
80107d6d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107d72:	e9 23 f5 ff ff       	jmp    8010729a <alltraps>

80107d77 <vector160>:
.globl vector160
vector160:
  pushl $0
80107d77:	6a 00                	push   $0x0
  pushl $160
80107d79:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80107d7e:	e9 17 f5 ff ff       	jmp    8010729a <alltraps>

80107d83 <vector161>:
.globl vector161
vector161:
  pushl $0
80107d83:	6a 00                	push   $0x0
  pushl $161
80107d85:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80107d8a:	e9 0b f5 ff ff       	jmp    8010729a <alltraps>

80107d8f <vector162>:
.globl vector162
vector162:
  pushl $0
80107d8f:	6a 00                	push   $0x0
  pushl $162
80107d91:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107d96:	e9 ff f4 ff ff       	jmp    8010729a <alltraps>

80107d9b <vector163>:
.globl vector163
vector163:
  pushl $0
80107d9b:	6a 00                	push   $0x0
  pushl $163
80107d9d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107da2:	e9 f3 f4 ff ff       	jmp    8010729a <alltraps>

80107da7 <vector164>:
.globl vector164
vector164:
  pushl $0
80107da7:	6a 00                	push   $0x0
  pushl $164
80107da9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80107dae:	e9 e7 f4 ff ff       	jmp    8010729a <alltraps>

80107db3 <vector165>:
.globl vector165
vector165:
  pushl $0
80107db3:	6a 00                	push   $0x0
  pushl $165
80107db5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80107dba:	e9 db f4 ff ff       	jmp    8010729a <alltraps>

80107dbf <vector166>:
.globl vector166
vector166:
  pushl $0
80107dbf:	6a 00                	push   $0x0
  pushl $166
80107dc1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107dc6:	e9 cf f4 ff ff       	jmp    8010729a <alltraps>

80107dcb <vector167>:
.globl vector167
vector167:
  pushl $0
80107dcb:	6a 00                	push   $0x0
  pushl $167
80107dcd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107dd2:	e9 c3 f4 ff ff       	jmp    8010729a <alltraps>

80107dd7 <vector168>:
.globl vector168
vector168:
  pushl $0
80107dd7:	6a 00                	push   $0x0
  pushl $168
80107dd9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80107dde:	e9 b7 f4 ff ff       	jmp    8010729a <alltraps>

80107de3 <vector169>:
.globl vector169
vector169:
  pushl $0
80107de3:	6a 00                	push   $0x0
  pushl $169
80107de5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80107dea:	e9 ab f4 ff ff       	jmp    8010729a <alltraps>

80107def <vector170>:
.globl vector170
vector170:
  pushl $0
80107def:	6a 00                	push   $0x0
  pushl $170
80107df1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107df6:	e9 9f f4 ff ff       	jmp    8010729a <alltraps>

80107dfb <vector171>:
.globl vector171
vector171:
  pushl $0
80107dfb:	6a 00                	push   $0x0
  pushl $171
80107dfd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107e02:	e9 93 f4 ff ff       	jmp    8010729a <alltraps>

80107e07 <vector172>:
.globl vector172
vector172:
  pushl $0
80107e07:	6a 00                	push   $0x0
  pushl $172
80107e09:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107e0e:	e9 87 f4 ff ff       	jmp    8010729a <alltraps>

80107e13 <vector173>:
.globl vector173
vector173:
  pushl $0
80107e13:	6a 00                	push   $0x0
  pushl $173
80107e15:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80107e1a:	e9 7b f4 ff ff       	jmp    8010729a <alltraps>

80107e1f <vector174>:
.globl vector174
vector174:
  pushl $0
80107e1f:	6a 00                	push   $0x0
  pushl $174
80107e21:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107e26:	e9 6f f4 ff ff       	jmp    8010729a <alltraps>

80107e2b <vector175>:
.globl vector175
vector175:
  pushl $0
80107e2b:	6a 00                	push   $0x0
  pushl $175
80107e2d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107e32:	e9 63 f4 ff ff       	jmp    8010729a <alltraps>

80107e37 <vector176>:
.globl vector176
vector176:
  pushl $0
80107e37:	6a 00                	push   $0x0
  pushl $176
80107e39:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80107e3e:	e9 57 f4 ff ff       	jmp    8010729a <alltraps>

80107e43 <vector177>:
.globl vector177
vector177:
  pushl $0
80107e43:	6a 00                	push   $0x0
  pushl $177
80107e45:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80107e4a:	e9 4b f4 ff ff       	jmp    8010729a <alltraps>

80107e4f <vector178>:
.globl vector178
vector178:
  pushl $0
80107e4f:	6a 00                	push   $0x0
  pushl $178
80107e51:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107e56:	e9 3f f4 ff ff       	jmp    8010729a <alltraps>

80107e5b <vector179>:
.globl vector179
vector179:
  pushl $0
80107e5b:	6a 00                	push   $0x0
  pushl $179
80107e5d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107e62:	e9 33 f4 ff ff       	jmp    8010729a <alltraps>

80107e67 <vector180>:
.globl vector180
vector180:
  pushl $0
80107e67:	6a 00                	push   $0x0
  pushl $180
80107e69:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80107e6e:	e9 27 f4 ff ff       	jmp    8010729a <alltraps>

80107e73 <vector181>:
.globl vector181
vector181:
  pushl $0
80107e73:	6a 00                	push   $0x0
  pushl $181
80107e75:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80107e7a:	e9 1b f4 ff ff       	jmp    8010729a <alltraps>

80107e7f <vector182>:
.globl vector182
vector182:
  pushl $0
80107e7f:	6a 00                	push   $0x0
  pushl $182
80107e81:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107e86:	e9 0f f4 ff ff       	jmp    8010729a <alltraps>

80107e8b <vector183>:
.globl vector183
vector183:
  pushl $0
80107e8b:	6a 00                	push   $0x0
  pushl $183
80107e8d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107e92:	e9 03 f4 ff ff       	jmp    8010729a <alltraps>

80107e97 <vector184>:
.globl vector184
vector184:
  pushl $0
80107e97:	6a 00                	push   $0x0
  pushl $184
80107e99:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80107e9e:	e9 f7 f3 ff ff       	jmp    8010729a <alltraps>

80107ea3 <vector185>:
.globl vector185
vector185:
  pushl $0
80107ea3:	6a 00                	push   $0x0
  pushl $185
80107ea5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80107eaa:	e9 eb f3 ff ff       	jmp    8010729a <alltraps>

80107eaf <vector186>:
.globl vector186
vector186:
  pushl $0
80107eaf:	6a 00                	push   $0x0
  pushl $186
80107eb1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107eb6:	e9 df f3 ff ff       	jmp    8010729a <alltraps>

80107ebb <vector187>:
.globl vector187
vector187:
  pushl $0
80107ebb:	6a 00                	push   $0x0
  pushl $187
80107ebd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107ec2:	e9 d3 f3 ff ff       	jmp    8010729a <alltraps>

80107ec7 <vector188>:
.globl vector188
vector188:
  pushl $0
80107ec7:	6a 00                	push   $0x0
  pushl $188
80107ec9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107ece:	e9 c7 f3 ff ff       	jmp    8010729a <alltraps>

80107ed3 <vector189>:
.globl vector189
vector189:
  pushl $0
80107ed3:	6a 00                	push   $0x0
  pushl $189
80107ed5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80107eda:	e9 bb f3 ff ff       	jmp    8010729a <alltraps>

80107edf <vector190>:
.globl vector190
vector190:
  pushl $0
80107edf:	6a 00                	push   $0x0
  pushl $190
80107ee1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107ee6:	e9 af f3 ff ff       	jmp    8010729a <alltraps>

80107eeb <vector191>:
.globl vector191
vector191:
  pushl $0
80107eeb:	6a 00                	push   $0x0
  pushl $191
80107eed:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107ef2:	e9 a3 f3 ff ff       	jmp    8010729a <alltraps>

80107ef7 <vector192>:
.globl vector192
vector192:
  pushl $0
80107ef7:	6a 00                	push   $0x0
  pushl $192
80107ef9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107efe:	e9 97 f3 ff ff       	jmp    8010729a <alltraps>

80107f03 <vector193>:
.globl vector193
vector193:
  pushl $0
80107f03:	6a 00                	push   $0x0
  pushl $193
80107f05:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80107f0a:	e9 8b f3 ff ff       	jmp    8010729a <alltraps>

80107f0f <vector194>:
.globl vector194
vector194:
  pushl $0
80107f0f:	6a 00                	push   $0x0
  pushl $194
80107f11:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107f16:	e9 7f f3 ff ff       	jmp    8010729a <alltraps>

80107f1b <vector195>:
.globl vector195
vector195:
  pushl $0
80107f1b:	6a 00                	push   $0x0
  pushl $195
80107f1d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107f22:	e9 73 f3 ff ff       	jmp    8010729a <alltraps>

80107f27 <vector196>:
.globl vector196
vector196:
  pushl $0
80107f27:	6a 00                	push   $0x0
  pushl $196
80107f29:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107f2e:	e9 67 f3 ff ff       	jmp    8010729a <alltraps>

80107f33 <vector197>:
.globl vector197
vector197:
  pushl $0
80107f33:	6a 00                	push   $0x0
  pushl $197
80107f35:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80107f3a:	e9 5b f3 ff ff       	jmp    8010729a <alltraps>

80107f3f <vector198>:
.globl vector198
vector198:
  pushl $0
80107f3f:	6a 00                	push   $0x0
  pushl $198
80107f41:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107f46:	e9 4f f3 ff ff       	jmp    8010729a <alltraps>

80107f4b <vector199>:
.globl vector199
vector199:
  pushl $0
80107f4b:	6a 00                	push   $0x0
  pushl $199
80107f4d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107f52:	e9 43 f3 ff ff       	jmp    8010729a <alltraps>

80107f57 <vector200>:
.globl vector200
vector200:
  pushl $0
80107f57:	6a 00                	push   $0x0
  pushl $200
80107f59:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107f5e:	e9 37 f3 ff ff       	jmp    8010729a <alltraps>

80107f63 <vector201>:
.globl vector201
vector201:
  pushl $0
80107f63:	6a 00                	push   $0x0
  pushl $201
80107f65:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80107f6a:	e9 2b f3 ff ff       	jmp    8010729a <alltraps>

80107f6f <vector202>:
.globl vector202
vector202:
  pushl $0
80107f6f:	6a 00                	push   $0x0
  pushl $202
80107f71:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107f76:	e9 1f f3 ff ff       	jmp    8010729a <alltraps>

80107f7b <vector203>:
.globl vector203
vector203:
  pushl $0
80107f7b:	6a 00                	push   $0x0
  pushl $203
80107f7d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107f82:	e9 13 f3 ff ff       	jmp    8010729a <alltraps>

80107f87 <vector204>:
.globl vector204
vector204:
  pushl $0
80107f87:	6a 00                	push   $0x0
  pushl $204
80107f89:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107f8e:	e9 07 f3 ff ff       	jmp    8010729a <alltraps>

80107f93 <vector205>:
.globl vector205
vector205:
  pushl $0
80107f93:	6a 00                	push   $0x0
  pushl $205
80107f95:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80107f9a:	e9 fb f2 ff ff       	jmp    8010729a <alltraps>

80107f9f <vector206>:
.globl vector206
vector206:
  pushl $0
80107f9f:	6a 00                	push   $0x0
  pushl $206
80107fa1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107fa6:	e9 ef f2 ff ff       	jmp    8010729a <alltraps>

80107fab <vector207>:
.globl vector207
vector207:
  pushl $0
80107fab:	6a 00                	push   $0x0
  pushl $207
80107fad:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107fb2:	e9 e3 f2 ff ff       	jmp    8010729a <alltraps>

80107fb7 <vector208>:
.globl vector208
vector208:
  pushl $0
80107fb7:	6a 00                	push   $0x0
  pushl $208
80107fb9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107fbe:	e9 d7 f2 ff ff       	jmp    8010729a <alltraps>

80107fc3 <vector209>:
.globl vector209
vector209:
  pushl $0
80107fc3:	6a 00                	push   $0x0
  pushl $209
80107fc5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80107fca:	e9 cb f2 ff ff       	jmp    8010729a <alltraps>

80107fcf <vector210>:
.globl vector210
vector210:
  pushl $0
80107fcf:	6a 00                	push   $0x0
  pushl $210
80107fd1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107fd6:	e9 bf f2 ff ff       	jmp    8010729a <alltraps>

80107fdb <vector211>:
.globl vector211
vector211:
  pushl $0
80107fdb:	6a 00                	push   $0x0
  pushl $211
80107fdd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107fe2:	e9 b3 f2 ff ff       	jmp    8010729a <alltraps>

80107fe7 <vector212>:
.globl vector212
vector212:
  pushl $0
80107fe7:	6a 00                	push   $0x0
  pushl $212
80107fe9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107fee:	e9 a7 f2 ff ff       	jmp    8010729a <alltraps>

80107ff3 <vector213>:
.globl vector213
vector213:
  pushl $0
80107ff3:	6a 00                	push   $0x0
  pushl $213
80107ff5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107ffa:	e9 9b f2 ff ff       	jmp    8010729a <alltraps>

80107fff <vector214>:
.globl vector214
vector214:
  pushl $0
80107fff:	6a 00                	push   $0x0
  pushl $214
80108001:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80108006:	e9 8f f2 ff ff       	jmp    8010729a <alltraps>

8010800b <vector215>:
.globl vector215
vector215:
  pushl $0
8010800b:	6a 00                	push   $0x0
  pushl $215
8010800d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80108012:	e9 83 f2 ff ff       	jmp    8010729a <alltraps>

80108017 <vector216>:
.globl vector216
vector216:
  pushl $0
80108017:	6a 00                	push   $0x0
  pushl $216
80108019:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010801e:	e9 77 f2 ff ff       	jmp    8010729a <alltraps>

80108023 <vector217>:
.globl vector217
vector217:
  pushl $0
80108023:	6a 00                	push   $0x0
  pushl $217
80108025:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010802a:	e9 6b f2 ff ff       	jmp    8010729a <alltraps>

8010802f <vector218>:
.globl vector218
vector218:
  pushl $0
8010802f:	6a 00                	push   $0x0
  pushl $218
80108031:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80108036:	e9 5f f2 ff ff       	jmp    8010729a <alltraps>

8010803b <vector219>:
.globl vector219
vector219:
  pushl $0
8010803b:	6a 00                	push   $0x0
  pushl $219
8010803d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80108042:	e9 53 f2 ff ff       	jmp    8010729a <alltraps>

80108047 <vector220>:
.globl vector220
vector220:
  pushl $0
80108047:	6a 00                	push   $0x0
  pushl $220
80108049:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010804e:	e9 47 f2 ff ff       	jmp    8010729a <alltraps>

80108053 <vector221>:
.globl vector221
vector221:
  pushl $0
80108053:	6a 00                	push   $0x0
  pushl $221
80108055:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010805a:	e9 3b f2 ff ff       	jmp    8010729a <alltraps>

8010805f <vector222>:
.globl vector222
vector222:
  pushl $0
8010805f:	6a 00                	push   $0x0
  pushl $222
80108061:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80108066:	e9 2f f2 ff ff       	jmp    8010729a <alltraps>

8010806b <vector223>:
.globl vector223
vector223:
  pushl $0
8010806b:	6a 00                	push   $0x0
  pushl $223
8010806d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80108072:	e9 23 f2 ff ff       	jmp    8010729a <alltraps>

80108077 <vector224>:
.globl vector224
vector224:
  pushl $0
80108077:	6a 00                	push   $0x0
  pushl $224
80108079:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010807e:	e9 17 f2 ff ff       	jmp    8010729a <alltraps>

80108083 <vector225>:
.globl vector225
vector225:
  pushl $0
80108083:	6a 00                	push   $0x0
  pushl $225
80108085:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010808a:	e9 0b f2 ff ff       	jmp    8010729a <alltraps>

8010808f <vector226>:
.globl vector226
vector226:
  pushl $0
8010808f:	6a 00                	push   $0x0
  pushl $226
80108091:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80108096:	e9 ff f1 ff ff       	jmp    8010729a <alltraps>

8010809b <vector227>:
.globl vector227
vector227:
  pushl $0
8010809b:	6a 00                	push   $0x0
  pushl $227
8010809d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801080a2:	e9 f3 f1 ff ff       	jmp    8010729a <alltraps>

801080a7 <vector228>:
.globl vector228
vector228:
  pushl $0
801080a7:	6a 00                	push   $0x0
  pushl $228
801080a9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801080ae:	e9 e7 f1 ff ff       	jmp    8010729a <alltraps>

801080b3 <vector229>:
.globl vector229
vector229:
  pushl $0
801080b3:	6a 00                	push   $0x0
  pushl $229
801080b5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801080ba:	e9 db f1 ff ff       	jmp    8010729a <alltraps>

801080bf <vector230>:
.globl vector230
vector230:
  pushl $0
801080bf:	6a 00                	push   $0x0
  pushl $230
801080c1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801080c6:	e9 cf f1 ff ff       	jmp    8010729a <alltraps>

801080cb <vector231>:
.globl vector231
vector231:
  pushl $0
801080cb:	6a 00                	push   $0x0
  pushl $231
801080cd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801080d2:	e9 c3 f1 ff ff       	jmp    8010729a <alltraps>

801080d7 <vector232>:
.globl vector232
vector232:
  pushl $0
801080d7:	6a 00                	push   $0x0
  pushl $232
801080d9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801080de:	e9 b7 f1 ff ff       	jmp    8010729a <alltraps>

801080e3 <vector233>:
.globl vector233
vector233:
  pushl $0
801080e3:	6a 00                	push   $0x0
  pushl $233
801080e5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801080ea:	e9 ab f1 ff ff       	jmp    8010729a <alltraps>

801080ef <vector234>:
.globl vector234
vector234:
  pushl $0
801080ef:	6a 00                	push   $0x0
  pushl $234
801080f1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801080f6:	e9 9f f1 ff ff       	jmp    8010729a <alltraps>

801080fb <vector235>:
.globl vector235
vector235:
  pushl $0
801080fb:	6a 00                	push   $0x0
  pushl $235
801080fd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80108102:	e9 93 f1 ff ff       	jmp    8010729a <alltraps>

80108107 <vector236>:
.globl vector236
vector236:
  pushl $0
80108107:	6a 00                	push   $0x0
  pushl $236
80108109:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010810e:	e9 87 f1 ff ff       	jmp    8010729a <alltraps>

80108113 <vector237>:
.globl vector237
vector237:
  pushl $0
80108113:	6a 00                	push   $0x0
  pushl $237
80108115:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010811a:	e9 7b f1 ff ff       	jmp    8010729a <alltraps>

8010811f <vector238>:
.globl vector238
vector238:
  pushl $0
8010811f:	6a 00                	push   $0x0
  pushl $238
80108121:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80108126:	e9 6f f1 ff ff       	jmp    8010729a <alltraps>

8010812b <vector239>:
.globl vector239
vector239:
  pushl $0
8010812b:	6a 00                	push   $0x0
  pushl $239
8010812d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80108132:	e9 63 f1 ff ff       	jmp    8010729a <alltraps>

80108137 <vector240>:
.globl vector240
vector240:
  pushl $0
80108137:	6a 00                	push   $0x0
  pushl $240
80108139:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010813e:	e9 57 f1 ff ff       	jmp    8010729a <alltraps>

80108143 <vector241>:
.globl vector241
vector241:
  pushl $0
80108143:	6a 00                	push   $0x0
  pushl $241
80108145:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010814a:	e9 4b f1 ff ff       	jmp    8010729a <alltraps>

8010814f <vector242>:
.globl vector242
vector242:
  pushl $0
8010814f:	6a 00                	push   $0x0
  pushl $242
80108151:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80108156:	e9 3f f1 ff ff       	jmp    8010729a <alltraps>

8010815b <vector243>:
.globl vector243
vector243:
  pushl $0
8010815b:	6a 00                	push   $0x0
  pushl $243
8010815d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80108162:	e9 33 f1 ff ff       	jmp    8010729a <alltraps>

80108167 <vector244>:
.globl vector244
vector244:
  pushl $0
80108167:	6a 00                	push   $0x0
  pushl $244
80108169:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010816e:	e9 27 f1 ff ff       	jmp    8010729a <alltraps>

80108173 <vector245>:
.globl vector245
vector245:
  pushl $0
80108173:	6a 00                	push   $0x0
  pushl $245
80108175:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010817a:	e9 1b f1 ff ff       	jmp    8010729a <alltraps>

8010817f <vector246>:
.globl vector246
vector246:
  pushl $0
8010817f:	6a 00                	push   $0x0
  pushl $246
80108181:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80108186:	e9 0f f1 ff ff       	jmp    8010729a <alltraps>

8010818b <vector247>:
.globl vector247
vector247:
  pushl $0
8010818b:	6a 00                	push   $0x0
  pushl $247
8010818d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80108192:	e9 03 f1 ff ff       	jmp    8010729a <alltraps>

80108197 <vector248>:
.globl vector248
vector248:
  pushl $0
80108197:	6a 00                	push   $0x0
  pushl $248
80108199:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010819e:	e9 f7 f0 ff ff       	jmp    8010729a <alltraps>

801081a3 <vector249>:
.globl vector249
vector249:
  pushl $0
801081a3:	6a 00                	push   $0x0
  pushl $249
801081a5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801081aa:	e9 eb f0 ff ff       	jmp    8010729a <alltraps>

801081af <vector250>:
.globl vector250
vector250:
  pushl $0
801081af:	6a 00                	push   $0x0
  pushl $250
801081b1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801081b6:	e9 df f0 ff ff       	jmp    8010729a <alltraps>

801081bb <vector251>:
.globl vector251
vector251:
  pushl $0
801081bb:	6a 00                	push   $0x0
  pushl $251
801081bd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801081c2:	e9 d3 f0 ff ff       	jmp    8010729a <alltraps>

801081c7 <vector252>:
.globl vector252
vector252:
  pushl $0
801081c7:	6a 00                	push   $0x0
  pushl $252
801081c9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801081ce:	e9 c7 f0 ff ff       	jmp    8010729a <alltraps>

801081d3 <vector253>:
.globl vector253
vector253:
  pushl $0
801081d3:	6a 00                	push   $0x0
  pushl $253
801081d5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801081da:	e9 bb f0 ff ff       	jmp    8010729a <alltraps>

801081df <vector254>:
.globl vector254
vector254:
  pushl $0
801081df:	6a 00                	push   $0x0
  pushl $254
801081e1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801081e6:	e9 af f0 ff ff       	jmp    8010729a <alltraps>

801081eb <vector255>:
.globl vector255
vector255:
  pushl $0
801081eb:	6a 00                	push   $0x0
  pushl $255
801081ed:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801081f2:	e9 a3 f0 ff ff       	jmp    8010729a <alltraps>
801081f7:	66 90                	xchg   %ax,%ax
801081f9:	66 90                	xchg   %ax,%ax
801081fb:	66 90                	xchg   %ax,%ax
801081fd:	66 90                	xchg   %ax,%ax
801081ff:	90                   	nop

80108200 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80108200:	55                   	push   %ebp
80108201:	89 e5                	mov    %esp,%ebp
80108203:	57                   	push   %edi
80108204:	56                   	push   %esi
80108205:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80108206:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
8010820c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80108212:	83 ec 1c             	sub    $0x1c,%esp
80108215:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80108218:	39 d3                	cmp    %edx,%ebx
8010821a:	73 49                	jae    80108265 <deallocuvm.part.0+0x65>
8010821c:	89 c7                	mov    %eax,%edi
8010821e:	eb 0c                	jmp    8010822c <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80108220:	83 c0 01             	add    $0x1,%eax
80108223:	c1 e0 16             	shl    $0x16,%eax
80108226:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
80108228:	39 da                	cmp    %ebx,%edx
8010822a:	76 39                	jbe    80108265 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
8010822c:	89 d8                	mov    %ebx,%eax
8010822e:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80108231:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80108234:	f6 c1 01             	test   $0x1,%cl
80108237:	74 e7                	je     80108220 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80108239:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010823b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80108241:	c1 ee 0a             	shr    $0xa,%esi
80108244:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
8010824a:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
80108251:	85 f6                	test   %esi,%esi
80108253:	74 cb                	je     80108220 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80108255:	8b 06                	mov    (%esi),%eax
80108257:	a8 01                	test   $0x1,%al
80108259:	75 15                	jne    80108270 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
8010825b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80108261:	39 da                	cmp    %ebx,%edx
80108263:	77 c7                	ja     8010822c <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80108265:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108268:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010826b:	5b                   	pop    %ebx
8010826c:	5e                   	pop    %esi
8010826d:	5f                   	pop    %edi
8010826e:	5d                   	pop    %ebp
8010826f:	c3                   	ret    
      if(pa == 0)
80108270:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108275:	74 25                	je     8010829c <deallocuvm.part.0+0x9c>
      kfree(v);
80108277:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010827a:	05 00 00 00 80       	add    $0x80000000,%eax
8010827f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80108282:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80108288:	50                   	push   %eax
80108289:	e8 42 b6 ff ff       	call   801038d0 <kfree>
      *pte = 0;
8010828e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80108294:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80108297:	83 c4 10             	add    $0x10,%esp
8010829a:	eb 8c                	jmp    80108228 <deallocuvm.part.0+0x28>
        panic("kfree");
8010829c:	83 ec 0c             	sub    $0xc,%esp
8010829f:	68 b6 8e 10 80       	push   $0x80108eb6
801082a4:	e8 d7 80 ff ff       	call   80100380 <panic>
801082a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801082b0 <mappages>:
{
801082b0:	55                   	push   %ebp
801082b1:	89 e5                	mov    %esp,%ebp
801082b3:	57                   	push   %edi
801082b4:	56                   	push   %esi
801082b5:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
801082b6:	89 d3                	mov    %edx,%ebx
801082b8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
801082be:	83 ec 1c             	sub    $0x1c,%esp
801082c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801082c4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
801082c8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801082cd:	89 45 dc             	mov    %eax,-0x24(%ebp)
801082d0:	8b 45 08             	mov    0x8(%ebp),%eax
801082d3:	29 d8                	sub    %ebx,%eax
801082d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801082d8:	eb 3d                	jmp    80108317 <mappages+0x67>
801082da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801082e0:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801082e2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801082e7:	c1 ea 0a             	shr    $0xa,%edx
801082ea:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801082f0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801082f7:	85 c0                	test   %eax,%eax
801082f9:	74 75                	je     80108370 <mappages+0xc0>
    if(*pte & PTE_P)
801082fb:	f6 00 01             	testb  $0x1,(%eax)
801082fe:	0f 85 86 00 00 00    	jne    8010838a <mappages+0xda>
    *pte = pa | perm | PTE_P;
80108304:	0b 75 0c             	or     0xc(%ebp),%esi
80108307:	83 ce 01             	or     $0x1,%esi
8010830a:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010830c:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
8010830f:	74 6f                	je     80108380 <mappages+0xd0>
    a += PGSIZE;
80108311:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80108317:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
8010831a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010831d:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80108320:	89 d8                	mov    %ebx,%eax
80108322:	c1 e8 16             	shr    $0x16,%eax
80108325:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80108328:	8b 07                	mov    (%edi),%eax
8010832a:	a8 01                	test   $0x1,%al
8010832c:	75 b2                	jne    801082e0 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
8010832e:	e8 5d b7 ff ff       	call   80103a90 <kalloc>
80108333:	85 c0                	test   %eax,%eax
80108335:	74 39                	je     80108370 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80108337:	83 ec 04             	sub    $0x4,%esp
8010833a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010833d:	68 00 10 00 00       	push   $0x1000
80108342:	6a 00                	push   $0x0
80108344:	50                   	push   %eax
80108345:	e8 d6 d9 ff ff       	call   80105d20 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010834a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
8010834d:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80108350:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80108356:	83 c8 07             	or     $0x7,%eax
80108359:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
8010835b:	89 d8                	mov    %ebx,%eax
8010835d:	c1 e8 0a             	shr    $0xa,%eax
80108360:	25 fc 0f 00 00       	and    $0xffc,%eax
80108365:	01 d0                	add    %edx,%eax
80108367:	eb 92                	jmp    801082fb <mappages+0x4b>
80108369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80108370:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80108373:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108378:	5b                   	pop    %ebx
80108379:	5e                   	pop    %esi
8010837a:	5f                   	pop    %edi
8010837b:	5d                   	pop    %ebp
8010837c:	c3                   	ret    
8010837d:	8d 76 00             	lea    0x0(%esi),%esi
80108380:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80108383:	31 c0                	xor    %eax,%eax
}
80108385:	5b                   	pop    %ebx
80108386:	5e                   	pop    %esi
80108387:	5f                   	pop    %edi
80108388:	5d                   	pop    %ebp
80108389:	c3                   	ret    
      panic("remap");
8010838a:	83 ec 0c             	sub    $0xc,%esp
8010838d:	68 e8 95 10 80       	push   $0x801095e8
80108392:	e8 e9 7f ff ff       	call   80100380 <panic>
80108397:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010839e:	66 90                	xchg   %ax,%ax

801083a0 <seginit>:
{
801083a0:	55                   	push   %ebp
801083a1:	89 e5                	mov    %esp,%ebp
801083a3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801083a6:	e8 d5 c9 ff ff       	call   80104d80 <cpuid>
  pd[0] = size-1;
801083ab:	ba 2f 00 00 00       	mov    $0x2f,%edx
801083b0:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801083b6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801083ba:	c7 80 98 3f 11 80 ff 	movl   $0xffff,-0x7feec068(%eax)
801083c1:	ff 00 00 
801083c4:	c7 80 9c 3f 11 80 00 	movl   $0xcf9a00,-0x7feec064(%eax)
801083cb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801083ce:	c7 80 a0 3f 11 80 ff 	movl   $0xffff,-0x7feec060(%eax)
801083d5:	ff 00 00 
801083d8:	c7 80 a4 3f 11 80 00 	movl   $0xcf9200,-0x7feec05c(%eax)
801083df:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801083e2:	c7 80 a8 3f 11 80 ff 	movl   $0xffff,-0x7feec058(%eax)
801083e9:	ff 00 00 
801083ec:	c7 80 ac 3f 11 80 00 	movl   $0xcffa00,-0x7feec054(%eax)
801083f3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801083f6:	c7 80 b0 3f 11 80 ff 	movl   $0xffff,-0x7feec050(%eax)
801083fd:	ff 00 00 
80108400:	c7 80 b4 3f 11 80 00 	movl   $0xcff200,-0x7feec04c(%eax)
80108407:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010840a:	05 90 3f 11 80       	add    $0x80113f90,%eax
  pd[1] = (uint)p;
8010840f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80108413:	c1 e8 10             	shr    $0x10,%eax
80108416:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010841a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010841d:	0f 01 10             	lgdtl  (%eax)
}
80108420:	c9                   	leave  
80108421:	c3                   	ret    
80108422:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108429:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80108430 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80108430:	a1 44 87 11 80       	mov    0x80118744,%eax
80108435:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010843a:	0f 22 d8             	mov    %eax,%cr3
}
8010843d:	c3                   	ret    
8010843e:	66 90                	xchg   %ax,%ax

80108440 <switchuvm>:
{
80108440:	55                   	push   %ebp
80108441:	89 e5                	mov    %esp,%ebp
80108443:	57                   	push   %edi
80108444:	56                   	push   %esi
80108445:	53                   	push   %ebx
80108446:	83 ec 1c             	sub    $0x1c,%esp
80108449:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
8010844c:	85 f6                	test   %esi,%esi
8010844e:	0f 84 cb 00 00 00    	je     8010851f <switchuvm+0xdf>
  if(p->kstack == 0)
80108454:	8b 46 08             	mov    0x8(%esi),%eax
80108457:	85 c0                	test   %eax,%eax
80108459:	0f 84 da 00 00 00    	je     80108539 <switchuvm+0xf9>
  if(p->pgdir == 0)
8010845f:	8b 46 04             	mov    0x4(%esi),%eax
80108462:	85 c0                	test   %eax,%eax
80108464:	0f 84 c2 00 00 00    	je     8010852c <switchuvm+0xec>
  pushcli();
8010846a:	e8 a1 d6 ff ff       	call   80105b10 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010846f:	e8 ac c8 ff ff       	call   80104d20 <mycpu>
80108474:	89 c3                	mov    %eax,%ebx
80108476:	e8 a5 c8 ff ff       	call   80104d20 <mycpu>
8010847b:	89 c7                	mov    %eax,%edi
8010847d:	e8 9e c8 ff ff       	call   80104d20 <mycpu>
80108482:	83 c7 08             	add    $0x8,%edi
80108485:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80108488:	e8 93 c8 ff ff       	call   80104d20 <mycpu>
8010848d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80108490:	ba 67 00 00 00       	mov    $0x67,%edx
80108495:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
8010849c:	83 c0 08             	add    $0x8,%eax
8010849f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801084a6:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801084ab:	83 c1 08             	add    $0x8,%ecx
801084ae:	c1 e8 18             	shr    $0x18,%eax
801084b1:	c1 e9 10             	shr    $0x10,%ecx
801084b4:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
801084ba:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
801084c0:	b9 99 40 00 00       	mov    $0x4099,%ecx
801084c5:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801084cc:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
801084d1:	e8 4a c8 ff ff       	call   80104d20 <mycpu>
801084d6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801084dd:	e8 3e c8 ff ff       	call   80104d20 <mycpu>
801084e2:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801084e6:	8b 5e 08             	mov    0x8(%esi),%ebx
801084e9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801084ef:	e8 2c c8 ff ff       	call   80104d20 <mycpu>
801084f4:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801084f7:	e8 24 c8 ff ff       	call   80104d20 <mycpu>
801084fc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80108500:	b8 28 00 00 00       	mov    $0x28,%eax
80108505:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80108508:	8b 46 04             	mov    0x4(%esi),%eax
8010850b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80108510:	0f 22 d8             	mov    %eax,%cr3
}
80108513:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108516:	5b                   	pop    %ebx
80108517:	5e                   	pop    %esi
80108518:	5f                   	pop    %edi
80108519:	5d                   	pop    %ebp
  popcli();
8010851a:	e9 41 d6 ff ff       	jmp    80105b60 <popcli>
    panic("switchuvm: no process");
8010851f:	83 ec 0c             	sub    $0xc,%esp
80108522:	68 ee 95 10 80       	push   $0x801095ee
80108527:	e8 54 7e ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
8010852c:	83 ec 0c             	sub    $0xc,%esp
8010852f:	68 19 96 10 80       	push   $0x80109619
80108534:	e8 47 7e ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80108539:	83 ec 0c             	sub    $0xc,%esp
8010853c:	68 04 96 10 80       	push   $0x80109604
80108541:	e8 3a 7e ff ff       	call   80100380 <panic>
80108546:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010854d:	8d 76 00             	lea    0x0(%esi),%esi

80108550 <inituvm>:
{
80108550:	55                   	push   %ebp
80108551:	89 e5                	mov    %esp,%ebp
80108553:	57                   	push   %edi
80108554:	56                   	push   %esi
80108555:	53                   	push   %ebx
80108556:	83 ec 1c             	sub    $0x1c,%esp
80108559:	8b 45 0c             	mov    0xc(%ebp),%eax
8010855c:	8b 75 10             	mov    0x10(%ebp),%esi
8010855f:	8b 7d 08             	mov    0x8(%ebp),%edi
80108562:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80108565:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010856b:	77 4b                	ja     801085b8 <inituvm+0x68>
  mem = kalloc();
8010856d:	e8 1e b5 ff ff       	call   80103a90 <kalloc>
  memset(mem, 0, PGSIZE);
80108572:	83 ec 04             	sub    $0x4,%esp
80108575:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010857a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
8010857c:	6a 00                	push   $0x0
8010857e:	50                   	push   %eax
8010857f:	e8 9c d7 ff ff       	call   80105d20 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80108584:	58                   	pop    %eax
80108585:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010858b:	5a                   	pop    %edx
8010858c:	6a 06                	push   $0x6
8010858e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80108593:	31 d2                	xor    %edx,%edx
80108595:	50                   	push   %eax
80108596:	89 f8                	mov    %edi,%eax
80108598:	e8 13 fd ff ff       	call   801082b0 <mappages>
  memmove(mem, init, sz);
8010859d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801085a0:	89 75 10             	mov    %esi,0x10(%ebp)
801085a3:	83 c4 10             	add    $0x10,%esp
801085a6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801085a9:	89 45 0c             	mov    %eax,0xc(%ebp)
}
801085ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
801085af:	5b                   	pop    %ebx
801085b0:	5e                   	pop    %esi
801085b1:	5f                   	pop    %edi
801085b2:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801085b3:	e9 08 d8 ff ff       	jmp    80105dc0 <memmove>
    panic("inituvm: more than a page");
801085b8:	83 ec 0c             	sub    $0xc,%esp
801085bb:	68 2d 96 10 80       	push   $0x8010962d
801085c0:	e8 bb 7d ff ff       	call   80100380 <panic>
801085c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801085cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801085d0 <loaduvm>:
{
801085d0:	55                   	push   %ebp
801085d1:	89 e5                	mov    %esp,%ebp
801085d3:	57                   	push   %edi
801085d4:	56                   	push   %esi
801085d5:	53                   	push   %ebx
801085d6:	83 ec 1c             	sub    $0x1c,%esp
801085d9:	8b 45 0c             	mov    0xc(%ebp),%eax
801085dc:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
801085df:	a9 ff 0f 00 00       	test   $0xfff,%eax
801085e4:	0f 85 bb 00 00 00    	jne    801086a5 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
801085ea:	01 f0                	add    %esi,%eax
801085ec:	89 f3                	mov    %esi,%ebx
801085ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
801085f1:	8b 45 14             	mov    0x14(%ebp),%eax
801085f4:	01 f0                	add    %esi,%eax
801085f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
801085f9:	85 f6                	test   %esi,%esi
801085fb:	0f 84 87 00 00 00    	je     80108688 <loaduvm+0xb8>
80108601:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80108608:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
8010860b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010860e:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80108610:	89 c2                	mov    %eax,%edx
80108612:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80108615:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80108618:	f6 c2 01             	test   $0x1,%dl
8010861b:	75 13                	jne    80108630 <loaduvm+0x60>
      panic("loaduvm: address should exist");
8010861d:	83 ec 0c             	sub    $0xc,%esp
80108620:	68 47 96 10 80       	push   $0x80109647
80108625:	e8 56 7d ff ff       	call   80100380 <panic>
8010862a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80108630:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80108633:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80108639:	25 fc 0f 00 00       	and    $0xffc,%eax
8010863e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80108645:	85 c0                	test   %eax,%eax
80108647:	74 d4                	je     8010861d <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80108649:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010864b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
8010864e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80108653:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80108658:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
8010865e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80108661:	29 d9                	sub    %ebx,%ecx
80108663:	05 00 00 00 80       	add    $0x80000000,%eax
80108668:	57                   	push   %edi
80108669:	51                   	push   %ecx
8010866a:	50                   	push   %eax
8010866b:	ff 75 10             	push   0x10(%ebp)
8010866e:	e8 2d a8 ff ff       	call   80102ea0 <readi>
80108673:	83 c4 10             	add    $0x10,%esp
80108676:	39 f8                	cmp    %edi,%eax
80108678:	75 1e                	jne    80108698 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
8010867a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80108680:	89 f0                	mov    %esi,%eax
80108682:	29 d8                	sub    %ebx,%eax
80108684:	39 c6                	cmp    %eax,%esi
80108686:	77 80                	ja     80108608 <loaduvm+0x38>
}
80108688:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010868b:	31 c0                	xor    %eax,%eax
}
8010868d:	5b                   	pop    %ebx
8010868e:	5e                   	pop    %esi
8010868f:	5f                   	pop    %edi
80108690:	5d                   	pop    %ebp
80108691:	c3                   	ret    
80108692:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80108698:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010869b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801086a0:	5b                   	pop    %ebx
801086a1:	5e                   	pop    %esi
801086a2:	5f                   	pop    %edi
801086a3:	5d                   	pop    %ebp
801086a4:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
801086a5:	83 ec 0c             	sub    $0xc,%esp
801086a8:	68 e8 96 10 80       	push   $0x801096e8
801086ad:	e8 ce 7c ff ff       	call   80100380 <panic>
801086b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801086b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801086c0 <allocuvm>:
{
801086c0:	55                   	push   %ebp
801086c1:	89 e5                	mov    %esp,%ebp
801086c3:	57                   	push   %edi
801086c4:	56                   	push   %esi
801086c5:	53                   	push   %ebx
801086c6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
801086c9:	8b 45 10             	mov    0x10(%ebp),%eax
{
801086cc:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
801086cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801086d2:	85 c0                	test   %eax,%eax
801086d4:	0f 88 b6 00 00 00    	js     80108790 <allocuvm+0xd0>
  if(newsz < oldsz)
801086da:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
801086dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
801086e0:	0f 82 9a 00 00 00    	jb     80108780 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
801086e6:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
801086ec:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
801086f2:	39 75 10             	cmp    %esi,0x10(%ebp)
801086f5:	77 44                	ja     8010873b <allocuvm+0x7b>
801086f7:	e9 87 00 00 00       	jmp    80108783 <allocuvm+0xc3>
801086fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80108700:	83 ec 04             	sub    $0x4,%esp
80108703:	68 00 10 00 00       	push   $0x1000
80108708:	6a 00                	push   $0x0
8010870a:	50                   	push   %eax
8010870b:	e8 10 d6 ff ff       	call   80105d20 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80108710:	58                   	pop    %eax
80108711:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80108717:	5a                   	pop    %edx
80108718:	6a 06                	push   $0x6
8010871a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010871f:	89 f2                	mov    %esi,%edx
80108721:	50                   	push   %eax
80108722:	89 f8                	mov    %edi,%eax
80108724:	e8 87 fb ff ff       	call   801082b0 <mappages>
80108729:	83 c4 10             	add    $0x10,%esp
8010872c:	85 c0                	test   %eax,%eax
8010872e:	78 78                	js     801087a8 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80108730:	81 c6 00 10 00 00    	add    $0x1000,%esi
80108736:	39 75 10             	cmp    %esi,0x10(%ebp)
80108739:	76 48                	jbe    80108783 <allocuvm+0xc3>
    mem = kalloc();
8010873b:	e8 50 b3 ff ff       	call   80103a90 <kalloc>
80108740:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80108742:	85 c0                	test   %eax,%eax
80108744:	75 ba                	jne    80108700 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80108746:	83 ec 0c             	sub    $0xc,%esp
80108749:	68 65 96 10 80       	push   $0x80109665
8010874e:	e8 ad 7f ff ff       	call   80100700 <cprintf>
  if(newsz >= oldsz)
80108753:	8b 45 0c             	mov    0xc(%ebp),%eax
80108756:	83 c4 10             	add    $0x10,%esp
80108759:	39 45 10             	cmp    %eax,0x10(%ebp)
8010875c:	74 32                	je     80108790 <allocuvm+0xd0>
8010875e:	8b 55 10             	mov    0x10(%ebp),%edx
80108761:	89 c1                	mov    %eax,%ecx
80108763:	89 f8                	mov    %edi,%eax
80108765:	e8 96 fa ff ff       	call   80108200 <deallocuvm.part.0>
      return 0;
8010876a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80108771:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108774:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108777:	5b                   	pop    %ebx
80108778:	5e                   	pop    %esi
80108779:	5f                   	pop    %edi
8010877a:	5d                   	pop    %ebp
8010877b:	c3                   	ret    
8010877c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80108780:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80108783:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108786:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108789:	5b                   	pop    %ebx
8010878a:	5e                   	pop    %esi
8010878b:	5f                   	pop    %edi
8010878c:	5d                   	pop    %ebp
8010878d:	c3                   	ret    
8010878e:	66 90                	xchg   %ax,%ax
    return 0;
80108790:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80108797:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010879a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010879d:	5b                   	pop    %ebx
8010879e:	5e                   	pop    %esi
8010879f:	5f                   	pop    %edi
801087a0:	5d                   	pop    %ebp
801087a1:	c3                   	ret    
801087a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801087a8:	83 ec 0c             	sub    $0xc,%esp
801087ab:	68 7d 96 10 80       	push   $0x8010967d
801087b0:	e8 4b 7f ff ff       	call   80100700 <cprintf>
  if(newsz >= oldsz)
801087b5:	8b 45 0c             	mov    0xc(%ebp),%eax
801087b8:	83 c4 10             	add    $0x10,%esp
801087bb:	39 45 10             	cmp    %eax,0x10(%ebp)
801087be:	74 0c                	je     801087cc <allocuvm+0x10c>
801087c0:	8b 55 10             	mov    0x10(%ebp),%edx
801087c3:	89 c1                	mov    %eax,%ecx
801087c5:	89 f8                	mov    %edi,%eax
801087c7:	e8 34 fa ff ff       	call   80108200 <deallocuvm.part.0>
      kfree(mem);
801087cc:	83 ec 0c             	sub    $0xc,%esp
801087cf:	53                   	push   %ebx
801087d0:	e8 fb b0 ff ff       	call   801038d0 <kfree>
      return 0;
801087d5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801087dc:	83 c4 10             	add    $0x10,%esp
}
801087df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801087e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801087e5:	5b                   	pop    %ebx
801087e6:	5e                   	pop    %esi
801087e7:	5f                   	pop    %edi
801087e8:	5d                   	pop    %ebp
801087e9:	c3                   	ret    
801087ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801087f0 <deallocuvm>:
{
801087f0:	55                   	push   %ebp
801087f1:	89 e5                	mov    %esp,%ebp
801087f3:	8b 55 0c             	mov    0xc(%ebp),%edx
801087f6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801087f9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801087fc:	39 d1                	cmp    %edx,%ecx
801087fe:	73 10                	jae    80108810 <deallocuvm+0x20>
}
80108800:	5d                   	pop    %ebp
80108801:	e9 fa f9 ff ff       	jmp    80108200 <deallocuvm.part.0>
80108806:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010880d:	8d 76 00             	lea    0x0(%esi),%esi
80108810:	89 d0                	mov    %edx,%eax
80108812:	5d                   	pop    %ebp
80108813:	c3                   	ret    
80108814:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010881b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010881f:	90                   	nop

80108820 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108820:	55                   	push   %ebp
80108821:	89 e5                	mov    %esp,%ebp
80108823:	57                   	push   %edi
80108824:	56                   	push   %esi
80108825:	53                   	push   %ebx
80108826:	83 ec 0c             	sub    $0xc,%esp
80108829:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010882c:	85 f6                	test   %esi,%esi
8010882e:	74 59                	je     80108889 <freevm+0x69>
  if(newsz >= oldsz)
80108830:	31 c9                	xor    %ecx,%ecx
80108832:	ba 00 00 00 80       	mov    $0x80000000,%edx
80108837:	89 f0                	mov    %esi,%eax
80108839:	89 f3                	mov    %esi,%ebx
8010883b:	e8 c0 f9 ff ff       	call   80108200 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80108840:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80108846:	eb 0f                	jmp    80108857 <freevm+0x37>
80108848:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010884f:	90                   	nop
80108850:	83 c3 04             	add    $0x4,%ebx
80108853:	39 df                	cmp    %ebx,%edi
80108855:	74 23                	je     8010887a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80108857:	8b 03                	mov    (%ebx),%eax
80108859:	a8 01                	test   $0x1,%al
8010885b:	74 f3                	je     80108850 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010885d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80108862:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80108865:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80108868:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010886d:	50                   	push   %eax
8010886e:	e8 5d b0 ff ff       	call   801038d0 <kfree>
80108873:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80108876:	39 df                	cmp    %ebx,%edi
80108878:	75 dd                	jne    80108857 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010887a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010887d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108880:	5b                   	pop    %ebx
80108881:	5e                   	pop    %esi
80108882:	5f                   	pop    %edi
80108883:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80108884:	e9 47 b0 ff ff       	jmp    801038d0 <kfree>
    panic("freevm: no pgdir");
80108889:	83 ec 0c             	sub    $0xc,%esp
8010888c:	68 99 96 10 80       	push   $0x80109699
80108891:	e8 ea 7a ff ff       	call   80100380 <panic>
80108896:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010889d:	8d 76 00             	lea    0x0(%esi),%esi

801088a0 <setupkvm>:
{
801088a0:	55                   	push   %ebp
801088a1:	89 e5                	mov    %esp,%ebp
801088a3:	56                   	push   %esi
801088a4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801088a5:	e8 e6 b1 ff ff       	call   80103a90 <kalloc>
801088aa:	89 c6                	mov    %eax,%esi
801088ac:	85 c0                	test   %eax,%eax
801088ae:	74 42                	je     801088f2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
801088b0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801088b3:	bb 20 c4 10 80       	mov    $0x8010c420,%ebx
  memset(pgdir, 0, PGSIZE);
801088b8:	68 00 10 00 00       	push   $0x1000
801088bd:	6a 00                	push   $0x0
801088bf:	50                   	push   %eax
801088c0:	e8 5b d4 ff ff       	call   80105d20 <memset>
801088c5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801088c8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801088cb:	83 ec 08             	sub    $0x8,%esp
801088ce:	8b 4b 08             	mov    0x8(%ebx),%ecx
801088d1:	ff 73 0c             	push   0xc(%ebx)
801088d4:	8b 13                	mov    (%ebx),%edx
801088d6:	50                   	push   %eax
801088d7:	29 c1                	sub    %eax,%ecx
801088d9:	89 f0                	mov    %esi,%eax
801088db:	e8 d0 f9 ff ff       	call   801082b0 <mappages>
801088e0:	83 c4 10             	add    $0x10,%esp
801088e3:	85 c0                	test   %eax,%eax
801088e5:	78 19                	js     80108900 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801088e7:	83 c3 10             	add    $0x10,%ebx
801088ea:	81 fb 60 c4 10 80    	cmp    $0x8010c460,%ebx
801088f0:	75 d6                	jne    801088c8 <setupkvm+0x28>
}
801088f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801088f5:	89 f0                	mov    %esi,%eax
801088f7:	5b                   	pop    %ebx
801088f8:	5e                   	pop    %esi
801088f9:	5d                   	pop    %ebp
801088fa:	c3                   	ret    
801088fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801088ff:	90                   	nop
      freevm(pgdir);
80108900:	83 ec 0c             	sub    $0xc,%esp
80108903:	56                   	push   %esi
      return 0;
80108904:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80108906:	e8 15 ff ff ff       	call   80108820 <freevm>
      return 0;
8010890b:	83 c4 10             	add    $0x10,%esp
}
8010890e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108911:	89 f0                	mov    %esi,%eax
80108913:	5b                   	pop    %ebx
80108914:	5e                   	pop    %esi
80108915:	5d                   	pop    %ebp
80108916:	c3                   	ret    
80108917:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010891e:	66 90                	xchg   %ax,%ax

80108920 <kvmalloc>:
{
80108920:	55                   	push   %ebp
80108921:	89 e5                	mov    %esp,%ebp
80108923:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80108926:	e8 75 ff ff ff       	call   801088a0 <setupkvm>
8010892b:	a3 44 87 11 80       	mov    %eax,0x80118744
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80108930:	05 00 00 00 80       	add    $0x80000000,%eax
80108935:	0f 22 d8             	mov    %eax,%cr3
}
80108938:	c9                   	leave  
80108939:	c3                   	ret    
8010893a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108940 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108940:	55                   	push   %ebp
80108941:	89 e5                	mov    %esp,%ebp
80108943:	83 ec 08             	sub    $0x8,%esp
80108946:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80108949:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010894c:	89 c1                	mov    %eax,%ecx
8010894e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80108951:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80108954:	f6 c2 01             	test   $0x1,%dl
80108957:	75 17                	jne    80108970 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80108959:	83 ec 0c             	sub    $0xc,%esp
8010895c:	68 aa 96 10 80       	push   $0x801096aa
80108961:	e8 1a 7a ff ff       	call   80100380 <panic>
80108966:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010896d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80108970:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80108973:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80108979:	25 fc 0f 00 00       	and    $0xffc,%eax
8010897e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80108985:	85 c0                	test   %eax,%eax
80108987:	74 d0                	je     80108959 <clearpteu+0x19>
  *pte &= ~PTE_U;
80108989:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010898c:	c9                   	leave  
8010898d:	c3                   	ret    
8010898e:	66 90                	xchg   %ax,%ax

80108990 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108990:	55                   	push   %ebp
80108991:	89 e5                	mov    %esp,%ebp
80108993:	57                   	push   %edi
80108994:	56                   	push   %esi
80108995:	53                   	push   %ebx
80108996:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80108999:	e8 02 ff ff ff       	call   801088a0 <setupkvm>
8010899e:	89 45 e0             	mov    %eax,-0x20(%ebp)
801089a1:	85 c0                	test   %eax,%eax
801089a3:	0f 84 bd 00 00 00    	je     80108a66 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801089a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801089ac:	85 c9                	test   %ecx,%ecx
801089ae:	0f 84 b2 00 00 00    	je     80108a66 <copyuvm+0xd6>
801089b4:	31 f6                	xor    %esi,%esi
801089b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801089bd:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
801089c0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
801089c3:	89 f0                	mov    %esi,%eax
801089c5:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801089c8:	8b 04 81             	mov    (%ecx,%eax,4),%eax
801089cb:	a8 01                	test   $0x1,%al
801089cd:	75 11                	jne    801089e0 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
801089cf:	83 ec 0c             	sub    $0xc,%esp
801089d2:	68 b4 96 10 80       	push   $0x801096b4
801089d7:	e8 a4 79 ff ff       	call   80100380 <panic>
801089dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
801089e0:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801089e2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801089e7:	c1 ea 0a             	shr    $0xa,%edx
801089ea:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801089f0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801089f7:	85 c0                	test   %eax,%eax
801089f9:	74 d4                	je     801089cf <copyuvm+0x3f>
    if(!(*pte & PTE_P))
801089fb:	8b 00                	mov    (%eax),%eax
801089fd:	a8 01                	test   $0x1,%al
801089ff:	0f 84 9f 00 00 00    	je     80108aa4 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80108a05:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80108a07:	25 ff 0f 00 00       	and    $0xfff,%eax
80108a0c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80108a0f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80108a15:	e8 76 b0 ff ff       	call   80103a90 <kalloc>
80108a1a:	89 c3                	mov    %eax,%ebx
80108a1c:	85 c0                	test   %eax,%eax
80108a1e:	74 64                	je     80108a84 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80108a20:	83 ec 04             	sub    $0x4,%esp
80108a23:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80108a29:	68 00 10 00 00       	push   $0x1000
80108a2e:	57                   	push   %edi
80108a2f:	50                   	push   %eax
80108a30:	e8 8b d3 ff ff       	call   80105dc0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80108a35:	58                   	pop    %eax
80108a36:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80108a3c:	5a                   	pop    %edx
80108a3d:	ff 75 e4             	push   -0x1c(%ebp)
80108a40:	b9 00 10 00 00       	mov    $0x1000,%ecx
80108a45:	89 f2                	mov    %esi,%edx
80108a47:	50                   	push   %eax
80108a48:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108a4b:	e8 60 f8 ff ff       	call   801082b0 <mappages>
80108a50:	83 c4 10             	add    $0x10,%esp
80108a53:	85 c0                	test   %eax,%eax
80108a55:	78 21                	js     80108a78 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80108a57:	81 c6 00 10 00 00    	add    $0x1000,%esi
80108a5d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80108a60:	0f 87 5a ff ff ff    	ja     801089c0 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80108a66:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108a69:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108a6c:	5b                   	pop    %ebx
80108a6d:	5e                   	pop    %esi
80108a6e:	5f                   	pop    %edi
80108a6f:	5d                   	pop    %ebp
80108a70:	c3                   	ret    
80108a71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80108a78:	83 ec 0c             	sub    $0xc,%esp
80108a7b:	53                   	push   %ebx
80108a7c:	e8 4f ae ff ff       	call   801038d0 <kfree>
      goto bad;
80108a81:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80108a84:	83 ec 0c             	sub    $0xc,%esp
80108a87:	ff 75 e0             	push   -0x20(%ebp)
80108a8a:	e8 91 fd ff ff       	call   80108820 <freevm>
  return 0;
80108a8f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80108a96:	83 c4 10             	add    $0x10,%esp
}
80108a99:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108a9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108a9f:	5b                   	pop    %ebx
80108aa0:	5e                   	pop    %esi
80108aa1:	5f                   	pop    %edi
80108aa2:	5d                   	pop    %ebp
80108aa3:	c3                   	ret    
      panic("copyuvm: page not present");
80108aa4:	83 ec 0c             	sub    $0xc,%esp
80108aa7:	68 ce 96 10 80       	push   $0x801096ce
80108aac:	e8 cf 78 ff ff       	call   80100380 <panic>
80108ab1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108ab8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108abf:	90                   	nop

80108ac0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108ac0:	55                   	push   %ebp
80108ac1:	89 e5                	mov    %esp,%ebp
80108ac3:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80108ac6:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80108ac9:	89 c1                	mov    %eax,%ecx
80108acb:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80108ace:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80108ad1:	f6 c2 01             	test   $0x1,%dl
80108ad4:	0f 84 00 01 00 00    	je     80108bda <uva2ka.cold>
  return &pgtab[PTX(va)];
80108ada:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80108add:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80108ae3:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80108ae4:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80108ae9:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
80108af0:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80108af2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80108af7:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80108afa:	05 00 00 00 80       	add    $0x80000000,%eax
80108aff:	83 fa 05             	cmp    $0x5,%edx
80108b02:	ba 00 00 00 00       	mov    $0x0,%edx
80108b07:	0f 45 c2             	cmovne %edx,%eax
}
80108b0a:	c3                   	ret    
80108b0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108b0f:	90                   	nop

80108b10 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108b10:	55                   	push   %ebp
80108b11:	89 e5                	mov    %esp,%ebp
80108b13:	57                   	push   %edi
80108b14:	56                   	push   %esi
80108b15:	53                   	push   %ebx
80108b16:	83 ec 0c             	sub    $0xc,%esp
80108b19:	8b 75 14             	mov    0x14(%ebp),%esi
80108b1c:	8b 45 0c             	mov    0xc(%ebp),%eax
80108b1f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108b22:	85 f6                	test   %esi,%esi
80108b24:	75 51                	jne    80108b77 <copyout+0x67>
80108b26:	e9 a5 00 00 00       	jmp    80108bd0 <copyout+0xc0>
80108b2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108b2f:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80108b30:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80108b36:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
80108b3c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80108b42:	74 75                	je     80108bb9 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80108b44:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80108b46:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
80108b49:	29 c3                	sub    %eax,%ebx
80108b4b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80108b51:	39 f3                	cmp    %esi,%ebx
80108b53:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80108b56:	29 f8                	sub    %edi,%eax
80108b58:	83 ec 04             	sub    $0x4,%esp
80108b5b:	01 c1                	add    %eax,%ecx
80108b5d:	53                   	push   %ebx
80108b5e:	52                   	push   %edx
80108b5f:	51                   	push   %ecx
80108b60:	e8 5b d2 ff ff       	call   80105dc0 <memmove>
    len -= n;
    buf += n;
80108b65:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80108b68:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
80108b6e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80108b71:	01 da                	add    %ebx,%edx
  while(len > 0){
80108b73:	29 de                	sub    %ebx,%esi
80108b75:	74 59                	je     80108bd0 <copyout+0xc0>
  if(*pde & PTE_P){
80108b77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
80108b7a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80108b7c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
80108b7e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80108b81:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80108b87:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
80108b8a:	f6 c1 01             	test   $0x1,%cl
80108b8d:	0f 84 4e 00 00 00    	je     80108be1 <copyout.cold>
  return &pgtab[PTX(va)];
80108b93:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80108b95:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80108b9b:	c1 eb 0c             	shr    $0xc,%ebx
80108b9e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80108ba4:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
80108bab:	89 d9                	mov    %ebx,%ecx
80108bad:	83 e1 05             	and    $0x5,%ecx
80108bb0:	83 f9 05             	cmp    $0x5,%ecx
80108bb3:	0f 84 77 ff ff ff    	je     80108b30 <copyout+0x20>
  }
  return 0;
}
80108bb9:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80108bbc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108bc1:	5b                   	pop    %ebx
80108bc2:	5e                   	pop    %esi
80108bc3:	5f                   	pop    %edi
80108bc4:	5d                   	pop    %ebp
80108bc5:	c3                   	ret    
80108bc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108bcd:	8d 76 00             	lea    0x0(%esi),%esi
80108bd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80108bd3:	31 c0                	xor    %eax,%eax
}
80108bd5:	5b                   	pop    %ebx
80108bd6:	5e                   	pop    %esi
80108bd7:	5f                   	pop    %edi
80108bd8:	5d                   	pop    %ebp
80108bd9:	c3                   	ret    

80108bda <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
80108bda:	a1 00 00 00 00       	mov    0x0,%eax
80108bdf:	0f 0b                	ud2    

80108be1 <copyout.cold>:
80108be1:	a1 00 00 00 00       	mov    0x0,%eax
80108be6:	0f 0b                	ud2    
