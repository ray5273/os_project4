
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
80100028:	bc 80 d6 10 80       	mov    $0x8010d680,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 69 38 10 80       	mov    $0x80103869,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	83 ec 08             	sub    $0x8,%esp
8010003d:	68 34 8d 10 80       	push   $0x80108d34
80100042:	68 80 d6 10 80       	push   $0x8010d680
80100047:	e8 02 55 00 00       	call   8010554e <initlock>
8010004c:	83 c4 10             	add    $0x10,%esp

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004f:	c7 05 90 15 11 80 84 	movl   $0x80111584,0x80111590
80100056:	15 11 80 
  bcache.head.next = &bcache.head;
80100059:	c7 05 94 15 11 80 84 	movl   $0x80111584,0x80111594
80100060:	15 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100063:	c7 45 f4 b4 d6 10 80 	movl   $0x8010d6b4,-0xc(%ebp)
8010006a:	eb 3a                	jmp    801000a6 <binit+0x72>
    b->next = bcache.head.next;
8010006c:	8b 15 94 15 11 80    	mov    0x80111594,%edx
80100072:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100075:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100078:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007b:	c7 40 0c 84 15 11 80 	movl   $0x80111584,0xc(%eax)
    b->dev = -1;
80100082:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100085:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008c:	a1 94 15 11 80       	mov    0x80111594,%eax
80100091:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100094:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100097:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010009a:	a3 94 15 11 80       	mov    %eax,0x80111594

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009f:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a6:	b8 84 15 11 80       	mov    $0x80111584,%eax
801000ab:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801000ae:	72 bc                	jb     8010006c <binit+0x38>
    b->prev = &bcache.head;
    b->dev = -1;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000b0:	90                   	nop
801000b1:	c9                   	leave  
801000b2:	c3                   	ret    

801000b3 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return B_BUSY buffer.
static struct buf*
bget(uint dev, uint blockno)
{
801000b3:	55                   	push   %ebp
801000b4:	89 e5                	mov    %esp,%ebp
801000b6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000b9:	83 ec 0c             	sub    $0xc,%esp
801000bc:	68 80 d6 10 80       	push   $0x8010d680
801000c1:	e8 aa 54 00 00       	call   80105570 <acquire>
801000c6:	83 c4 10             	add    $0x10,%esp

 loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c9:	a1 94 15 11 80       	mov    0x80111594,%eax
801000ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000d1:	eb 67                	jmp    8010013a <bget+0x87>
    if(b->dev == dev && b->blockno == blockno){
801000d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000d6:	8b 40 04             	mov    0x4(%eax),%eax
801000d9:	3b 45 08             	cmp    0x8(%ebp),%eax
801000dc:	75 53                	jne    80100131 <bget+0x7e>
801000de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000e1:	8b 40 08             	mov    0x8(%eax),%eax
801000e4:	3b 45 0c             	cmp    0xc(%ebp),%eax
801000e7:	75 48                	jne    80100131 <bget+0x7e>
      if(!(b->flags & B_BUSY)){
801000e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000ec:	8b 00                	mov    (%eax),%eax
801000ee:	83 e0 01             	and    $0x1,%eax
801000f1:	85 c0                	test   %eax,%eax
801000f3:	75 27                	jne    8010011c <bget+0x69>
        b->flags |= B_BUSY;
801000f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f8:	8b 00                	mov    (%eax),%eax
801000fa:	83 c8 01             	or     $0x1,%eax
801000fd:	89 c2                	mov    %eax,%edx
801000ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100102:	89 10                	mov    %edx,(%eax)
        release(&bcache.lock);
80100104:	83 ec 0c             	sub    $0xc,%esp
80100107:	68 80 d6 10 80       	push   $0x8010d680
8010010c:	e8 c6 54 00 00       	call   801055d7 <release>
80100111:	83 c4 10             	add    $0x10,%esp
        return b;
80100114:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100117:	e9 98 00 00 00       	jmp    801001b4 <bget+0x101>
      }
      sleep(b, &bcache.lock);
8010011c:	83 ec 08             	sub    $0x8,%esp
8010011f:	68 80 d6 10 80       	push   $0x8010d680
80100124:	ff 75 f4             	pushl  -0xc(%ebp)
80100127:	e8 34 51 00 00       	call   80105260 <sleep>
8010012c:	83 c4 10             	add    $0x10,%esp
      goto loop;
8010012f:	eb 98                	jmp    801000c9 <bget+0x16>

  acquire(&bcache.lock);

 loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100131:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100134:	8b 40 10             	mov    0x10(%eax),%eax
80100137:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010013a:	81 7d f4 84 15 11 80 	cmpl   $0x80111584,-0xc(%ebp)
80100141:	75 90                	jne    801000d3 <bget+0x20>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100143:	a1 90 15 11 80       	mov    0x80111590,%eax
80100148:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010014b:	eb 51                	jmp    8010019e <bget+0xeb>
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
8010014d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100150:	8b 00                	mov    (%eax),%eax
80100152:	83 e0 01             	and    $0x1,%eax
80100155:	85 c0                	test   %eax,%eax
80100157:	75 3c                	jne    80100195 <bget+0xe2>
80100159:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015c:	8b 00                	mov    (%eax),%eax
8010015e:	83 e0 04             	and    $0x4,%eax
80100161:	85 c0                	test   %eax,%eax
80100163:	75 30                	jne    80100195 <bget+0xe2>
      b->dev = dev;
80100165:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100168:	8b 55 08             	mov    0x8(%ebp),%edx
8010016b:	89 50 04             	mov    %edx,0x4(%eax)
      b->blockno = blockno;
8010016e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100171:	8b 55 0c             	mov    0xc(%ebp),%edx
80100174:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = B_BUSY;
80100177:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010017a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
      release(&bcache.lock);
80100180:	83 ec 0c             	sub    $0xc,%esp
80100183:	68 80 d6 10 80       	push   $0x8010d680
80100188:	e8 4a 54 00 00       	call   801055d7 <release>
8010018d:	83 c4 10             	add    $0x10,%esp
      return b;
80100190:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100193:	eb 1f                	jmp    801001b4 <bget+0x101>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100195:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100198:	8b 40 0c             	mov    0xc(%eax),%eax
8010019b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010019e:	81 7d f4 84 15 11 80 	cmpl   $0x80111584,-0xc(%ebp)
801001a5:	75 a6                	jne    8010014d <bget+0x9a>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
801001a7:	83 ec 0c             	sub    $0xc,%esp
801001aa:	68 3b 8d 10 80       	push   $0x80108d3b
801001af:	e8 b2 03 00 00       	call   80100566 <panic>
}
801001b4:	c9                   	leave  
801001b5:	c3                   	ret    

801001b6 <bread>:

// Return a B_BUSY buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801001b6:	55                   	push   %ebp
801001b7:	89 e5                	mov    %esp,%ebp
801001b9:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  b = bget(dev, blockno);
801001bc:	83 ec 08             	sub    $0x8,%esp
801001bf:	ff 75 0c             	pushl  0xc(%ebp)
801001c2:	ff 75 08             	pushl  0x8(%ebp)
801001c5:	e8 e9 fe ff ff       	call   801000b3 <bget>
801001ca:	83 c4 10             	add    $0x10,%esp
801001cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!(b->flags & B_VALID)) {
801001d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d3:	8b 00                	mov    (%eax),%eax
801001d5:	83 e0 02             	and    $0x2,%eax
801001d8:	85 c0                	test   %eax,%eax
801001da:	75 0e                	jne    801001ea <bread+0x34>
    iderw(b);
801001dc:	83 ec 0c             	sub    $0xc,%esp
801001df:	ff 75 f4             	pushl  -0xc(%ebp)
801001e2:	e8 dc 26 00 00       	call   801028c3 <iderw>
801001e7:	83 c4 10             	add    $0x10,%esp
  }
  return b;
801001ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001ed:	c9                   	leave  
801001ee:	c3                   	ret    

801001ef <bwrite>:

// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
801001ef:	55                   	push   %ebp
801001f0:	89 e5                	mov    %esp,%ebp
801001f2:	83 ec 08             	sub    $0x8,%esp
  if((b->flags & B_BUSY) == 0)
801001f5:	8b 45 08             	mov    0x8(%ebp),%eax
801001f8:	8b 00                	mov    (%eax),%eax
801001fa:	83 e0 01             	and    $0x1,%eax
801001fd:	85 c0                	test   %eax,%eax
801001ff:	75 0d                	jne    8010020e <bwrite+0x1f>
    panic("bwrite");
80100201:	83 ec 0c             	sub    $0xc,%esp
80100204:	68 4c 8d 10 80       	push   $0x80108d4c
80100209:	e8 58 03 00 00       	call   80100566 <panic>
  b->flags |= B_DIRTY;
8010020e:	8b 45 08             	mov    0x8(%ebp),%eax
80100211:	8b 00                	mov    (%eax),%eax
80100213:	83 c8 04             	or     $0x4,%eax
80100216:	89 c2                	mov    %eax,%edx
80100218:	8b 45 08             	mov    0x8(%ebp),%eax
8010021b:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010021d:	83 ec 0c             	sub    $0xc,%esp
80100220:	ff 75 08             	pushl  0x8(%ebp)
80100223:	e8 9b 26 00 00       	call   801028c3 <iderw>
80100228:	83 c4 10             	add    $0x10,%esp
}
8010022b:	90                   	nop
8010022c:	c9                   	leave  
8010022d:	c3                   	ret    

8010022e <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
8010022e:	55                   	push   %ebp
8010022f:	89 e5                	mov    %esp,%ebp
80100231:	83 ec 08             	sub    $0x8,%esp
  if((b->flags & B_BUSY) == 0)
80100234:	8b 45 08             	mov    0x8(%ebp),%eax
80100237:	8b 00                	mov    (%eax),%eax
80100239:	83 e0 01             	and    $0x1,%eax
8010023c:	85 c0                	test   %eax,%eax
8010023e:	75 0d                	jne    8010024d <brelse+0x1f>
    panic("brelse");
80100240:	83 ec 0c             	sub    $0xc,%esp
80100243:	68 53 8d 10 80       	push   $0x80108d53
80100248:	e8 19 03 00 00       	call   80100566 <panic>

  acquire(&bcache.lock);
8010024d:	83 ec 0c             	sub    $0xc,%esp
80100250:	68 80 d6 10 80       	push   $0x8010d680
80100255:	e8 16 53 00 00       	call   80105570 <acquire>
8010025a:	83 c4 10             	add    $0x10,%esp

  b->next->prev = b->prev;
8010025d:	8b 45 08             	mov    0x8(%ebp),%eax
80100260:	8b 40 10             	mov    0x10(%eax),%eax
80100263:	8b 55 08             	mov    0x8(%ebp),%edx
80100266:	8b 52 0c             	mov    0xc(%edx),%edx
80100269:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
8010026c:	8b 45 08             	mov    0x8(%ebp),%eax
8010026f:	8b 40 0c             	mov    0xc(%eax),%eax
80100272:	8b 55 08             	mov    0x8(%ebp),%edx
80100275:	8b 52 10             	mov    0x10(%edx),%edx
80100278:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
8010027b:	8b 15 94 15 11 80    	mov    0x80111594,%edx
80100281:	8b 45 08             	mov    0x8(%ebp),%eax
80100284:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
80100287:	8b 45 08             	mov    0x8(%ebp),%eax
8010028a:	c7 40 0c 84 15 11 80 	movl   $0x80111584,0xc(%eax)
  bcache.head.next->prev = b;
80100291:	a1 94 15 11 80       	mov    0x80111594,%eax
80100296:	8b 55 08             	mov    0x8(%ebp),%edx
80100299:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
8010029c:	8b 45 08             	mov    0x8(%ebp),%eax
8010029f:	a3 94 15 11 80       	mov    %eax,0x80111594

  b->flags &= ~B_BUSY;
801002a4:	8b 45 08             	mov    0x8(%ebp),%eax
801002a7:	8b 00                	mov    (%eax),%eax
801002a9:	83 e0 fe             	and    $0xfffffffe,%eax
801002ac:	89 c2                	mov    %eax,%edx
801002ae:	8b 45 08             	mov    0x8(%ebp),%eax
801002b1:	89 10                	mov    %edx,(%eax)
  wakeup(b);
801002b3:	83 ec 0c             	sub    $0xc,%esp
801002b6:	ff 75 08             	pushl  0x8(%ebp)
801002b9:	e8 90 50 00 00       	call   8010534e <wakeup>
801002be:	83 c4 10             	add    $0x10,%esp

  release(&bcache.lock);
801002c1:	83 ec 0c             	sub    $0xc,%esp
801002c4:	68 80 d6 10 80       	push   $0x8010d680
801002c9:	e8 09 53 00 00       	call   801055d7 <release>
801002ce:	83 c4 10             	add    $0x10,%esp
}
801002d1:	90                   	nop
801002d2:	c9                   	leave  
801002d3:	c3                   	ret    

801002d4 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801002d4:	55                   	push   %ebp
801002d5:	89 e5                	mov    %esp,%ebp
801002d7:	83 ec 14             	sub    $0x14,%esp
801002da:	8b 45 08             	mov    0x8(%ebp),%eax
801002dd:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002e1:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801002e5:	89 c2                	mov    %eax,%edx
801002e7:	ec                   	in     (%dx),%al
801002e8:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801002eb:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801002ef:	c9                   	leave  
801002f0:	c3                   	ret    

801002f1 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801002f1:	55                   	push   %ebp
801002f2:	89 e5                	mov    %esp,%ebp
801002f4:	83 ec 08             	sub    $0x8,%esp
801002f7:	8b 55 08             	mov    0x8(%ebp),%edx
801002fa:	8b 45 0c             	mov    0xc(%ebp),%eax
801002fd:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80100301:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100304:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80100308:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010030c:	ee                   	out    %al,(%dx)
}
8010030d:	90                   	nop
8010030e:	c9                   	leave  
8010030f:	c3                   	ret    

80100310 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80100310:	55                   	push   %ebp
80100311:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80100313:	fa                   	cli    
}
80100314:	90                   	nop
80100315:	5d                   	pop    %ebp
80100316:	c3                   	ret    

80100317 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100317:	55                   	push   %ebp
80100318:	89 e5                	mov    %esp,%ebp
8010031a:	53                   	push   %ebx
8010031b:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010031e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100322:	74 1c                	je     80100340 <printint+0x29>
80100324:	8b 45 08             	mov    0x8(%ebp),%eax
80100327:	c1 e8 1f             	shr    $0x1f,%eax
8010032a:	0f b6 c0             	movzbl %al,%eax
8010032d:	89 45 10             	mov    %eax,0x10(%ebp)
80100330:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100334:	74 0a                	je     80100340 <printint+0x29>
    x = -xx;
80100336:	8b 45 08             	mov    0x8(%ebp),%eax
80100339:	f7 d8                	neg    %eax
8010033b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010033e:	eb 06                	jmp    80100346 <printint+0x2f>
  else
    x = xx;
80100340:	8b 45 08             	mov    0x8(%ebp),%eax
80100343:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
80100346:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
8010034d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100350:	8d 41 01             	lea    0x1(%ecx),%eax
80100353:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100356:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100359:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010035c:	ba 00 00 00 00       	mov    $0x0,%edx
80100361:	f7 f3                	div    %ebx
80100363:	89 d0                	mov    %edx,%eax
80100365:	0f b6 80 04 a0 10 80 	movzbl -0x7fef5ffc(%eax),%eax
8010036c:	88 44 0d e0          	mov    %al,-0x20(%ebp,%ecx,1)
  }while((x /= base) != 0);
80100370:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100373:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100376:	ba 00 00 00 00       	mov    $0x0,%edx
8010037b:	f7 f3                	div    %ebx
8010037d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100380:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100384:	75 c7                	jne    8010034d <printint+0x36>

  if(sign)
80100386:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010038a:	74 2a                	je     801003b6 <printint+0x9f>
    buf[i++] = '-';
8010038c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010038f:	8d 50 01             	lea    0x1(%eax),%edx
80100392:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100395:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
8010039a:	eb 1a                	jmp    801003b6 <printint+0x9f>
    consputc(buf[i]);
8010039c:	8d 55 e0             	lea    -0x20(%ebp),%edx
8010039f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003a2:	01 d0                	add    %edx,%eax
801003a4:	0f b6 00             	movzbl (%eax),%eax
801003a7:	0f be c0             	movsbl %al,%eax
801003aa:	83 ec 0c             	sub    $0xc,%esp
801003ad:	50                   	push   %eax
801003ae:	e8 df 03 00 00       	call   80100792 <consputc>
801003b3:	83 c4 10             	add    $0x10,%esp
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801003b6:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
801003ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801003be:	79 dc                	jns    8010039c <printint+0x85>
    consputc(buf[i]);
}
801003c0:	90                   	nop
801003c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801003c4:	c9                   	leave  
801003c5:	c3                   	ret    

801003c6 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003c6:	55                   	push   %ebp
801003c7:	89 e5                	mov    %esp,%ebp
801003c9:	83 ec 28             	sub    $0x28,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003cc:	a1 14 c6 10 80       	mov    0x8010c614,%eax
801003d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003d4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003d8:	74 10                	je     801003ea <cprintf+0x24>
    acquire(&cons.lock);
801003da:	83 ec 0c             	sub    $0xc,%esp
801003dd:	68 e0 c5 10 80       	push   $0x8010c5e0
801003e2:	e8 89 51 00 00       	call   80105570 <acquire>
801003e7:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
801003ea:	8b 45 08             	mov    0x8(%ebp),%eax
801003ed:	85 c0                	test   %eax,%eax
801003ef:	75 0d                	jne    801003fe <cprintf+0x38>
    panic("null fmt");
801003f1:	83 ec 0c             	sub    $0xc,%esp
801003f4:	68 5a 8d 10 80       	push   $0x80108d5a
801003f9:	e8 68 01 00 00       	call   80100566 <panic>

  argp = (uint*)(void*)(&fmt + 1);
801003fe:	8d 45 0c             	lea    0xc(%ebp),%eax
80100401:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100404:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010040b:	e9 1a 01 00 00       	jmp    8010052a <cprintf+0x164>
    if(c != '%'){
80100410:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
80100414:	74 13                	je     80100429 <cprintf+0x63>
      consputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	ff 75 e4             	pushl  -0x1c(%ebp)
8010041c:	e8 71 03 00 00       	call   80100792 <consputc>
80100421:	83 c4 10             	add    $0x10,%esp
      continue;
80100424:	e9 fd 00 00 00       	jmp    80100526 <cprintf+0x160>
    }
    c = fmt[++i] & 0xff;
80100429:	8b 55 08             	mov    0x8(%ebp),%edx
8010042c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100430:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100433:	01 d0                	add    %edx,%eax
80100435:	0f b6 00             	movzbl (%eax),%eax
80100438:	0f be c0             	movsbl %al,%eax
8010043b:	25 ff 00 00 00       	and    $0xff,%eax
80100440:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
80100443:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100447:	0f 84 ff 00 00 00    	je     8010054c <cprintf+0x186>
      break;
    switch(c){
8010044d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100450:	83 f8 70             	cmp    $0x70,%eax
80100453:	74 47                	je     8010049c <cprintf+0xd6>
80100455:	83 f8 70             	cmp    $0x70,%eax
80100458:	7f 13                	jg     8010046d <cprintf+0xa7>
8010045a:	83 f8 25             	cmp    $0x25,%eax
8010045d:	0f 84 98 00 00 00    	je     801004fb <cprintf+0x135>
80100463:	83 f8 64             	cmp    $0x64,%eax
80100466:	74 14                	je     8010047c <cprintf+0xb6>
80100468:	e9 9d 00 00 00       	jmp    8010050a <cprintf+0x144>
8010046d:	83 f8 73             	cmp    $0x73,%eax
80100470:	74 47                	je     801004b9 <cprintf+0xf3>
80100472:	83 f8 78             	cmp    $0x78,%eax
80100475:	74 25                	je     8010049c <cprintf+0xd6>
80100477:	e9 8e 00 00 00       	jmp    8010050a <cprintf+0x144>
    case 'd':
      printint(*argp++, 10, 1);
8010047c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010047f:	8d 50 04             	lea    0x4(%eax),%edx
80100482:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100485:	8b 00                	mov    (%eax),%eax
80100487:	83 ec 04             	sub    $0x4,%esp
8010048a:	6a 01                	push   $0x1
8010048c:	6a 0a                	push   $0xa
8010048e:	50                   	push   %eax
8010048f:	e8 83 fe ff ff       	call   80100317 <printint>
80100494:	83 c4 10             	add    $0x10,%esp
      break;
80100497:	e9 8a 00 00 00       	jmp    80100526 <cprintf+0x160>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010049c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010049f:	8d 50 04             	lea    0x4(%eax),%edx
801004a2:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004a5:	8b 00                	mov    (%eax),%eax
801004a7:	83 ec 04             	sub    $0x4,%esp
801004aa:	6a 00                	push   $0x0
801004ac:	6a 10                	push   $0x10
801004ae:	50                   	push   %eax
801004af:	e8 63 fe ff ff       	call   80100317 <printint>
801004b4:	83 c4 10             	add    $0x10,%esp
      break;
801004b7:	eb 6d                	jmp    80100526 <cprintf+0x160>
    case 's':
      if((s = (char*)*argp++) == 0)
801004b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004bc:	8d 50 04             	lea    0x4(%eax),%edx
801004bf:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004c2:	8b 00                	mov    (%eax),%eax
801004c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
801004c7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801004cb:	75 22                	jne    801004ef <cprintf+0x129>
        s = "(null)";
801004cd:	c7 45 ec 63 8d 10 80 	movl   $0x80108d63,-0x14(%ebp)
      for(; *s; s++)
801004d4:	eb 19                	jmp    801004ef <cprintf+0x129>
        consputc(*s);
801004d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004d9:	0f b6 00             	movzbl (%eax),%eax
801004dc:	0f be c0             	movsbl %al,%eax
801004df:	83 ec 0c             	sub    $0xc,%esp
801004e2:	50                   	push   %eax
801004e3:	e8 aa 02 00 00       	call   80100792 <consputc>
801004e8:	83 c4 10             	add    $0x10,%esp
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801004eb:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801004ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004f2:	0f b6 00             	movzbl (%eax),%eax
801004f5:	84 c0                	test   %al,%al
801004f7:	75 dd                	jne    801004d6 <cprintf+0x110>
        consputc(*s);
      break;
801004f9:	eb 2b                	jmp    80100526 <cprintf+0x160>
    case '%':
      consputc('%');
801004fb:	83 ec 0c             	sub    $0xc,%esp
801004fe:	6a 25                	push   $0x25
80100500:	e8 8d 02 00 00       	call   80100792 <consputc>
80100505:	83 c4 10             	add    $0x10,%esp
      break;
80100508:	eb 1c                	jmp    80100526 <cprintf+0x160>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
8010050a:	83 ec 0c             	sub    $0xc,%esp
8010050d:	6a 25                	push   $0x25
8010050f:	e8 7e 02 00 00       	call   80100792 <consputc>
80100514:	83 c4 10             	add    $0x10,%esp
      consputc(c);
80100517:	83 ec 0c             	sub    $0xc,%esp
8010051a:	ff 75 e4             	pushl  -0x1c(%ebp)
8010051d:	e8 70 02 00 00       	call   80100792 <consputc>
80100522:	83 c4 10             	add    $0x10,%esp
      break;
80100525:	90                   	nop

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100526:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010052a:	8b 55 08             	mov    0x8(%ebp),%edx
8010052d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100530:	01 d0                	add    %edx,%eax
80100532:	0f b6 00             	movzbl (%eax),%eax
80100535:	0f be c0             	movsbl %al,%eax
80100538:	25 ff 00 00 00       	and    $0xff,%eax
8010053d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100540:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100544:	0f 85 c6 fe ff ff    	jne    80100410 <cprintf+0x4a>
8010054a:	eb 01                	jmp    8010054d <cprintf+0x187>
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
8010054c:	90                   	nop
      consputc(c);
      break;
    }
  }

  if(locking)
8010054d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100551:	74 10                	je     80100563 <cprintf+0x19d>
    release(&cons.lock);
80100553:	83 ec 0c             	sub    $0xc,%esp
80100556:	68 e0 c5 10 80       	push   $0x8010c5e0
8010055b:	e8 77 50 00 00       	call   801055d7 <release>
80100560:	83 c4 10             	add    $0x10,%esp
}
80100563:	90                   	nop
80100564:	c9                   	leave  
80100565:	c3                   	ret    

80100566 <panic>:

void
panic(char *s)
{
80100566:	55                   	push   %ebp
80100567:	89 e5                	mov    %esp,%ebp
80100569:	83 ec 38             	sub    $0x38,%esp
  int i;
  uint pcs[10];
  
  cli();
8010056c:	e8 9f fd ff ff       	call   80100310 <cli>
  cons.locking = 0;
80100571:	c7 05 14 c6 10 80 00 	movl   $0x0,0x8010c614
80100578:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
8010057b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100581:	0f b6 00             	movzbl (%eax),%eax
80100584:	0f b6 c0             	movzbl %al,%eax
80100587:	83 ec 08             	sub    $0x8,%esp
8010058a:	50                   	push   %eax
8010058b:	68 6a 8d 10 80       	push   $0x80108d6a
80100590:	e8 31 fe ff ff       	call   801003c6 <cprintf>
80100595:	83 c4 10             	add    $0x10,%esp
  cprintf(s);
80100598:	8b 45 08             	mov    0x8(%ebp),%eax
8010059b:	83 ec 0c             	sub    $0xc,%esp
8010059e:	50                   	push   %eax
8010059f:	e8 22 fe ff ff       	call   801003c6 <cprintf>
801005a4:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
801005a7:	83 ec 0c             	sub    $0xc,%esp
801005aa:	68 79 8d 10 80       	push   $0x80108d79
801005af:	e8 12 fe ff ff       	call   801003c6 <cprintf>
801005b4:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005b7:	83 ec 08             	sub    $0x8,%esp
801005ba:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005bd:	50                   	push   %eax
801005be:	8d 45 08             	lea    0x8(%ebp),%eax
801005c1:	50                   	push   %eax
801005c2:	e8 62 50 00 00       	call   80105629 <getcallerpcs>
801005c7:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
801005ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005d1:	eb 1c                	jmp    801005ef <panic+0x89>
    cprintf(" %p", pcs[i]);
801005d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005d6:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005da:	83 ec 08             	sub    $0x8,%esp
801005dd:	50                   	push   %eax
801005de:	68 7b 8d 10 80       	push   $0x80108d7b
801005e3:	e8 de fd ff ff       	call   801003c6 <cprintf>
801005e8:	83 c4 10             	add    $0x10,%esp
  cons.locking = 0;
  cprintf("cpu%d: panic: ", cpu->id);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801005eb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801005ef:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801005f3:	7e de                	jle    801005d3 <panic+0x6d>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801005f5:	c7 05 c0 c5 10 80 01 	movl   $0x1,0x8010c5c0
801005fc:	00 00 00 
  for(;;)
    ;
801005ff:	eb fe                	jmp    801005ff <panic+0x99>

80100601 <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
80100601:	55                   	push   %ebp
80100602:	89 e5                	mov    %esp,%ebp
80100604:	83 ec 18             	sub    $0x18,%esp
  int pos;
  
  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
80100607:	6a 0e                	push   $0xe
80100609:	68 d4 03 00 00       	push   $0x3d4
8010060e:	e8 de fc ff ff       	call   801002f1 <outb>
80100613:	83 c4 08             	add    $0x8,%esp
  pos = inb(CRTPORT+1) << 8;
80100616:	68 d5 03 00 00       	push   $0x3d5
8010061b:	e8 b4 fc ff ff       	call   801002d4 <inb>
80100620:	83 c4 04             	add    $0x4,%esp
80100623:	0f b6 c0             	movzbl %al,%eax
80100626:	c1 e0 08             	shl    $0x8,%eax
80100629:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
8010062c:	6a 0f                	push   $0xf
8010062e:	68 d4 03 00 00       	push   $0x3d4
80100633:	e8 b9 fc ff ff       	call   801002f1 <outb>
80100638:	83 c4 08             	add    $0x8,%esp
  pos |= inb(CRTPORT+1);
8010063b:	68 d5 03 00 00       	push   $0x3d5
80100640:	e8 8f fc ff ff       	call   801002d4 <inb>
80100645:	83 c4 04             	add    $0x4,%esp
80100648:	0f b6 c0             	movzbl %al,%eax
8010064b:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
8010064e:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
80100652:	75 30                	jne    80100684 <cgaputc+0x83>
    pos += 80 - pos%80;
80100654:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100657:	ba 67 66 66 66       	mov    $0x66666667,%edx
8010065c:	89 c8                	mov    %ecx,%eax
8010065e:	f7 ea                	imul   %edx
80100660:	c1 fa 05             	sar    $0x5,%edx
80100663:	89 c8                	mov    %ecx,%eax
80100665:	c1 f8 1f             	sar    $0x1f,%eax
80100668:	29 c2                	sub    %eax,%edx
8010066a:	89 d0                	mov    %edx,%eax
8010066c:	c1 e0 02             	shl    $0x2,%eax
8010066f:	01 d0                	add    %edx,%eax
80100671:	c1 e0 04             	shl    $0x4,%eax
80100674:	29 c1                	sub    %eax,%ecx
80100676:	89 ca                	mov    %ecx,%edx
80100678:	b8 50 00 00 00       	mov    $0x50,%eax
8010067d:	29 d0                	sub    %edx,%eax
8010067f:	01 45 f4             	add    %eax,-0xc(%ebp)
80100682:	eb 34                	jmp    801006b8 <cgaputc+0xb7>
  else if(c == BACKSPACE){
80100684:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010068b:	75 0c                	jne    80100699 <cgaputc+0x98>
    if(pos > 0) --pos;
8010068d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100691:	7e 25                	jle    801006b8 <cgaputc+0xb7>
80100693:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
80100697:	eb 1f                	jmp    801006b8 <cgaputc+0xb7>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100699:	8b 0d 00 a0 10 80    	mov    0x8010a000,%ecx
8010069f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801006a2:	8d 50 01             	lea    0x1(%eax),%edx
801006a5:	89 55 f4             	mov    %edx,-0xc(%ebp)
801006a8:	01 c0                	add    %eax,%eax
801006aa:	01 c8                	add    %ecx,%eax
801006ac:	8b 55 08             	mov    0x8(%ebp),%edx
801006af:	0f b6 d2             	movzbl %dl,%edx
801006b2:	80 ce 07             	or     $0x7,%dh
801006b5:	66 89 10             	mov    %dx,(%eax)

  if(pos < 0 || pos > 25*80)
801006b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801006bc:	78 09                	js     801006c7 <cgaputc+0xc6>
801006be:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
801006c5:	7e 0d                	jle    801006d4 <cgaputc+0xd3>
    panic("pos under/overflow");
801006c7:	83 ec 0c             	sub    $0xc,%esp
801006ca:	68 7f 8d 10 80       	push   $0x80108d7f
801006cf:	e8 92 fe ff ff       	call   80100566 <panic>
  
  if((pos/80) >= 24){  // Scroll up.
801006d4:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
801006db:	7e 4c                	jle    80100729 <cgaputc+0x128>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801006dd:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801006e2:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
801006e8:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801006ed:	83 ec 04             	sub    $0x4,%esp
801006f0:	68 60 0e 00 00       	push   $0xe60
801006f5:	52                   	push   %edx
801006f6:	50                   	push   %eax
801006f7:	e8 96 51 00 00       	call   80105892 <memmove>
801006fc:	83 c4 10             	add    $0x10,%esp
    pos -= 80;
801006ff:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100703:	b8 80 07 00 00       	mov    $0x780,%eax
80100708:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010070b:	8d 14 00             	lea    (%eax,%eax,1),%edx
8010070e:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80100713:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100716:	01 c9                	add    %ecx,%ecx
80100718:	01 c8                	add    %ecx,%eax
8010071a:	83 ec 04             	sub    $0x4,%esp
8010071d:	52                   	push   %edx
8010071e:	6a 00                	push   $0x0
80100720:	50                   	push   %eax
80100721:	e8 ad 50 00 00       	call   801057d3 <memset>
80100726:	83 c4 10             	add    $0x10,%esp
  }
  
  outb(CRTPORT, 14);
80100729:	83 ec 08             	sub    $0x8,%esp
8010072c:	6a 0e                	push   $0xe
8010072e:	68 d4 03 00 00       	push   $0x3d4
80100733:	e8 b9 fb ff ff       	call   801002f1 <outb>
80100738:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos>>8);
8010073b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010073e:	c1 f8 08             	sar    $0x8,%eax
80100741:	0f b6 c0             	movzbl %al,%eax
80100744:	83 ec 08             	sub    $0x8,%esp
80100747:	50                   	push   %eax
80100748:	68 d5 03 00 00       	push   $0x3d5
8010074d:	e8 9f fb ff ff       	call   801002f1 <outb>
80100752:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT, 15);
80100755:	83 ec 08             	sub    $0x8,%esp
80100758:	6a 0f                	push   $0xf
8010075a:	68 d4 03 00 00       	push   $0x3d4
8010075f:	e8 8d fb ff ff       	call   801002f1 <outb>
80100764:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos);
80100767:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010076a:	0f b6 c0             	movzbl %al,%eax
8010076d:	83 ec 08             	sub    $0x8,%esp
80100770:	50                   	push   %eax
80100771:	68 d5 03 00 00       	push   $0x3d5
80100776:	e8 76 fb ff ff       	call   801002f1 <outb>
8010077b:	83 c4 10             	add    $0x10,%esp
  crt[pos] = ' ' | 0x0700;
8010077e:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80100783:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100786:	01 d2                	add    %edx,%edx
80100788:	01 d0                	add    %edx,%eax
8010078a:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
8010078f:	90                   	nop
80100790:	c9                   	leave  
80100791:	c3                   	ret    

80100792 <consputc>:

void
consputc(int c)
{
80100792:	55                   	push   %ebp
80100793:	89 e5                	mov    %esp,%ebp
80100795:	83 ec 08             	sub    $0x8,%esp
  if(panicked){
80100798:	a1 c0 c5 10 80       	mov    0x8010c5c0,%eax
8010079d:	85 c0                	test   %eax,%eax
8010079f:	74 07                	je     801007a8 <consputc+0x16>
    cli();
801007a1:	e8 6a fb ff ff       	call   80100310 <cli>
    for(;;)
      ;
801007a6:	eb fe                	jmp    801007a6 <consputc+0x14>
  }

  if(c == BACKSPACE){
801007a8:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
801007af:	75 29                	jne    801007da <consputc+0x48>
    uartputc('\b'); uartputc(' '); uartputc('\b');
801007b1:	83 ec 0c             	sub    $0xc,%esp
801007b4:	6a 08                	push   $0x8
801007b6:	e8 01 6b 00 00       	call   801072bc <uartputc>
801007bb:	83 c4 10             	add    $0x10,%esp
801007be:	83 ec 0c             	sub    $0xc,%esp
801007c1:	6a 20                	push   $0x20
801007c3:	e8 f4 6a 00 00       	call   801072bc <uartputc>
801007c8:	83 c4 10             	add    $0x10,%esp
801007cb:	83 ec 0c             	sub    $0xc,%esp
801007ce:	6a 08                	push   $0x8
801007d0:	e8 e7 6a 00 00       	call   801072bc <uartputc>
801007d5:	83 c4 10             	add    $0x10,%esp
801007d8:	eb 0e                	jmp    801007e8 <consputc+0x56>
  } else
    uartputc(c);
801007da:	83 ec 0c             	sub    $0xc,%esp
801007dd:	ff 75 08             	pushl  0x8(%ebp)
801007e0:	e8 d7 6a 00 00       	call   801072bc <uartputc>
801007e5:	83 c4 10             	add    $0x10,%esp
  cgaputc(c);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	ff 75 08             	pushl  0x8(%ebp)
801007ee:	e8 0e fe ff ff       	call   80100601 <cgaputc>
801007f3:	83 c4 10             	add    $0x10,%esp
}
801007f6:	90                   	nop
801007f7:	c9                   	leave  
801007f8:	c3                   	ret    

801007f9 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f9:	55                   	push   %ebp
801007fa:	89 e5                	mov    %esp,%ebp
801007fc:	83 ec 18             	sub    $0x18,%esp
  int c, doprocdump = 0;
801007ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&cons.lock);
80100806:	83 ec 0c             	sub    $0xc,%esp
80100809:	68 e0 c5 10 80       	push   $0x8010c5e0
8010080e:	e8 5d 4d 00 00       	call   80105570 <acquire>
80100813:	83 c4 10             	add    $0x10,%esp
  while((c = getc()) >= 0){
80100816:	e9 44 01 00 00       	jmp    8010095f <consoleintr+0x166>
    switch(c){
8010081b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010081e:	83 f8 10             	cmp    $0x10,%eax
80100821:	74 1e                	je     80100841 <consoleintr+0x48>
80100823:	83 f8 10             	cmp    $0x10,%eax
80100826:	7f 0a                	jg     80100832 <consoleintr+0x39>
80100828:	83 f8 08             	cmp    $0x8,%eax
8010082b:	74 6b                	je     80100898 <consoleintr+0x9f>
8010082d:	e9 9b 00 00 00       	jmp    801008cd <consoleintr+0xd4>
80100832:	83 f8 15             	cmp    $0x15,%eax
80100835:	74 33                	je     8010086a <consoleintr+0x71>
80100837:	83 f8 7f             	cmp    $0x7f,%eax
8010083a:	74 5c                	je     80100898 <consoleintr+0x9f>
8010083c:	e9 8c 00 00 00       	jmp    801008cd <consoleintr+0xd4>
    case C('P'):  // Process listing.
      doprocdump = 1;   // procdump() locks cons.lock indirectly; invoke later
80100841:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
      break;
80100848:	e9 12 01 00 00       	jmp    8010095f <consoleintr+0x166>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
8010084d:	a1 28 18 11 80       	mov    0x80111828,%eax
80100852:	83 e8 01             	sub    $0x1,%eax
80100855:	a3 28 18 11 80       	mov    %eax,0x80111828
        consputc(BACKSPACE);
8010085a:	83 ec 0c             	sub    $0xc,%esp
8010085d:	68 00 01 00 00       	push   $0x100
80100862:	e8 2b ff ff ff       	call   80100792 <consputc>
80100867:	83 c4 10             	add    $0x10,%esp
    switch(c){
    case C('P'):  // Process listing.
      doprocdump = 1;   // procdump() locks cons.lock indirectly; invoke later
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010086a:	8b 15 28 18 11 80    	mov    0x80111828,%edx
80100870:	a1 24 18 11 80       	mov    0x80111824,%eax
80100875:	39 c2                	cmp    %eax,%edx
80100877:	0f 84 e2 00 00 00    	je     8010095f <consoleintr+0x166>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
8010087d:	a1 28 18 11 80       	mov    0x80111828,%eax
80100882:	83 e8 01             	sub    $0x1,%eax
80100885:	83 e0 7f             	and    $0x7f,%eax
80100888:	0f b6 80 a0 17 11 80 	movzbl -0x7feee860(%eax),%eax
    switch(c){
    case C('P'):  // Process listing.
      doprocdump = 1;   // procdump() locks cons.lock indirectly; invoke later
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010088f:	3c 0a                	cmp    $0xa,%al
80100891:	75 ba                	jne    8010084d <consoleintr+0x54>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
80100893:	e9 c7 00 00 00       	jmp    8010095f <consoleintr+0x166>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100898:	8b 15 28 18 11 80    	mov    0x80111828,%edx
8010089e:	a1 24 18 11 80       	mov    0x80111824,%eax
801008a3:	39 c2                	cmp    %eax,%edx
801008a5:	0f 84 b4 00 00 00    	je     8010095f <consoleintr+0x166>
        input.e--;
801008ab:	a1 28 18 11 80       	mov    0x80111828,%eax
801008b0:	83 e8 01             	sub    $0x1,%eax
801008b3:	a3 28 18 11 80       	mov    %eax,0x80111828
        consputc(BACKSPACE);
801008b8:	83 ec 0c             	sub    $0xc,%esp
801008bb:	68 00 01 00 00       	push   $0x100
801008c0:	e8 cd fe ff ff       	call   80100792 <consputc>
801008c5:	83 c4 10             	add    $0x10,%esp
      }
      break;
801008c8:	e9 92 00 00 00       	jmp    8010095f <consoleintr+0x166>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008cd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801008d1:	0f 84 87 00 00 00    	je     8010095e <consoleintr+0x165>
801008d7:	8b 15 28 18 11 80    	mov    0x80111828,%edx
801008dd:	a1 20 18 11 80       	mov    0x80111820,%eax
801008e2:	29 c2                	sub    %eax,%edx
801008e4:	89 d0                	mov    %edx,%eax
801008e6:	83 f8 7f             	cmp    $0x7f,%eax
801008e9:	77 73                	ja     8010095e <consoleintr+0x165>
        c = (c == '\r') ? '\n' : c;
801008eb:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
801008ef:	74 05                	je     801008f6 <consoleintr+0xfd>
801008f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801008f4:	eb 05                	jmp    801008fb <consoleintr+0x102>
801008f6:	b8 0a 00 00 00       	mov    $0xa,%eax
801008fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
801008fe:	a1 28 18 11 80       	mov    0x80111828,%eax
80100903:	8d 50 01             	lea    0x1(%eax),%edx
80100906:	89 15 28 18 11 80    	mov    %edx,0x80111828
8010090c:	83 e0 7f             	and    $0x7f,%eax
8010090f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100912:	88 90 a0 17 11 80    	mov    %dl,-0x7feee860(%eax)
        consputc(c);
80100918:	83 ec 0c             	sub    $0xc,%esp
8010091b:	ff 75 f0             	pushl  -0x10(%ebp)
8010091e:	e8 6f fe ff ff       	call   80100792 <consputc>
80100923:	83 c4 10             	add    $0x10,%esp
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100926:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
8010092a:	74 18                	je     80100944 <consoleintr+0x14b>
8010092c:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100930:	74 12                	je     80100944 <consoleintr+0x14b>
80100932:	a1 28 18 11 80       	mov    0x80111828,%eax
80100937:	8b 15 20 18 11 80    	mov    0x80111820,%edx
8010093d:	83 ea 80             	sub    $0xffffff80,%edx
80100940:	39 d0                	cmp    %edx,%eax
80100942:	75 1a                	jne    8010095e <consoleintr+0x165>
          input.w = input.e;
80100944:	a1 28 18 11 80       	mov    0x80111828,%eax
80100949:	a3 24 18 11 80       	mov    %eax,0x80111824
          wakeup(&input.r);
8010094e:	83 ec 0c             	sub    $0xc,%esp
80100951:	68 20 18 11 80       	push   $0x80111820
80100956:	e8 f3 49 00 00       	call   8010534e <wakeup>
8010095b:	83 c4 10             	add    $0x10,%esp
        }
      }
      break;
8010095e:	90                   	nop
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
8010095f:	8b 45 08             	mov    0x8(%ebp),%eax
80100962:	ff d0                	call   *%eax
80100964:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100967:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010096b:	0f 89 aa fe ff ff    	jns    8010081b <consoleintr+0x22>
        }
      }
      break;
    }
  }
  release(&cons.lock);
80100971:	83 ec 0c             	sub    $0xc,%esp
80100974:	68 e0 c5 10 80       	push   $0x8010c5e0
80100979:	e8 59 4c 00 00       	call   801055d7 <release>
8010097e:	83 c4 10             	add    $0x10,%esp
  if(doprocdump) {
80100981:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100985:	74 05                	je     8010098c <consoleintr+0x193>
    procdump();  // now call procdump() wo. cons.lock held
80100987:	e8 80 4a 00 00       	call   8010540c <procdump>
  }
}
8010098c:	90                   	nop
8010098d:	c9                   	leave  
8010098e:	c3                   	ret    

8010098f <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
8010098f:	55                   	push   %ebp
80100990:	89 e5                	mov    %esp,%ebp
80100992:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
80100995:	83 ec 0c             	sub    $0xc,%esp
80100998:	ff 75 08             	pushl  0x8(%ebp)
8010099b:	e8 de 10 00 00       	call   80101a7e <iunlock>
801009a0:	83 c4 10             	add    $0x10,%esp
  target = n;
801009a3:	8b 45 10             	mov    0x10(%ebp),%eax
801009a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&cons.lock);
801009a9:	83 ec 0c             	sub    $0xc,%esp
801009ac:	68 e0 c5 10 80       	push   $0x8010c5e0
801009b1:	e8 ba 4b 00 00       	call   80105570 <acquire>
801009b6:	83 c4 10             	add    $0x10,%esp
  while(n > 0){
801009b9:	e9 ac 00 00 00       	jmp    80100a6a <consoleread+0xdb>
    while(input.r == input.w){
      if(proc->killed){
801009be:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801009c4:	8b 40 24             	mov    0x24(%eax),%eax
801009c7:	85 c0                	test   %eax,%eax
801009c9:	74 28                	je     801009f3 <consoleread+0x64>
        release(&cons.lock);
801009cb:	83 ec 0c             	sub    $0xc,%esp
801009ce:	68 e0 c5 10 80       	push   $0x8010c5e0
801009d3:	e8 ff 4b 00 00       	call   801055d7 <release>
801009d8:	83 c4 10             	add    $0x10,%esp
        ilock(ip);
801009db:	83 ec 0c             	sub    $0xc,%esp
801009de:	ff 75 08             	pushl  0x8(%ebp)
801009e1:	e8 3a 0f 00 00       	call   80101920 <ilock>
801009e6:	83 c4 10             	add    $0x10,%esp
        return -1;
801009e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801009ee:	e9 ab 00 00 00       	jmp    80100a9e <consoleread+0x10f>
      }
      sleep(&input.r, &cons.lock);
801009f3:	83 ec 08             	sub    $0x8,%esp
801009f6:	68 e0 c5 10 80       	push   $0x8010c5e0
801009fb:	68 20 18 11 80       	push   $0x80111820
80100a00:	e8 5b 48 00 00       	call   80105260 <sleep>
80100a05:	83 c4 10             	add    $0x10,%esp

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
80100a08:	8b 15 20 18 11 80    	mov    0x80111820,%edx
80100a0e:	a1 24 18 11 80       	mov    0x80111824,%eax
80100a13:	39 c2                	cmp    %eax,%edx
80100a15:	74 a7                	je     801009be <consoleread+0x2f>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100a17:	a1 20 18 11 80       	mov    0x80111820,%eax
80100a1c:	8d 50 01             	lea    0x1(%eax),%edx
80100a1f:	89 15 20 18 11 80    	mov    %edx,0x80111820
80100a25:	83 e0 7f             	and    $0x7f,%eax
80100a28:	0f b6 80 a0 17 11 80 	movzbl -0x7feee860(%eax),%eax
80100a2f:	0f be c0             	movsbl %al,%eax
80100a32:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
80100a35:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100a39:	75 17                	jne    80100a52 <consoleread+0xc3>
      if(n < target){
80100a3b:	8b 45 10             	mov    0x10(%ebp),%eax
80100a3e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80100a41:	73 2f                	jae    80100a72 <consoleread+0xe3>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100a43:	a1 20 18 11 80       	mov    0x80111820,%eax
80100a48:	83 e8 01             	sub    $0x1,%eax
80100a4b:	a3 20 18 11 80       	mov    %eax,0x80111820
      }
      break;
80100a50:	eb 20                	jmp    80100a72 <consoleread+0xe3>
    }
    *dst++ = c;
80100a52:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a55:	8d 50 01             	lea    0x1(%eax),%edx
80100a58:	89 55 0c             	mov    %edx,0xc(%ebp)
80100a5b:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100a5e:	88 10                	mov    %dl,(%eax)
    --n;
80100a60:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
80100a64:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100a68:	74 0b                	je     80100a75 <consoleread+0xe6>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100a6a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100a6e:	7f 98                	jg     80100a08 <consoleread+0x79>
80100a70:	eb 04                	jmp    80100a76 <consoleread+0xe7>
      if(n < target){
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
80100a72:	90                   	nop
80100a73:	eb 01                	jmp    80100a76 <consoleread+0xe7>
    }
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
80100a75:	90                   	nop
  }
  release(&cons.lock);
80100a76:	83 ec 0c             	sub    $0xc,%esp
80100a79:	68 e0 c5 10 80       	push   $0x8010c5e0
80100a7e:	e8 54 4b 00 00       	call   801055d7 <release>
80100a83:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100a86:	83 ec 0c             	sub    $0xc,%esp
80100a89:	ff 75 08             	pushl  0x8(%ebp)
80100a8c:	e8 8f 0e 00 00       	call   80101920 <ilock>
80100a91:	83 c4 10             	add    $0x10,%esp

  return target - n;
80100a94:	8b 45 10             	mov    0x10(%ebp),%eax
80100a97:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a9a:	29 c2                	sub    %eax,%edx
80100a9c:	89 d0                	mov    %edx,%eax
}
80100a9e:	c9                   	leave  
80100a9f:	c3                   	ret    

80100aa0 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100aa0:	55                   	push   %ebp
80100aa1:	89 e5                	mov    %esp,%ebp
80100aa3:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100aa6:	83 ec 0c             	sub    $0xc,%esp
80100aa9:	ff 75 08             	pushl  0x8(%ebp)
80100aac:	e8 cd 0f 00 00       	call   80101a7e <iunlock>
80100ab1:	83 c4 10             	add    $0x10,%esp
  acquire(&cons.lock);
80100ab4:	83 ec 0c             	sub    $0xc,%esp
80100ab7:	68 e0 c5 10 80       	push   $0x8010c5e0
80100abc:	e8 af 4a 00 00       	call   80105570 <acquire>
80100ac1:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100ac4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100acb:	eb 21                	jmp    80100aee <consolewrite+0x4e>
    consputc(buf[i] & 0xff);
80100acd:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100ad0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ad3:	01 d0                	add    %edx,%eax
80100ad5:	0f b6 00             	movzbl (%eax),%eax
80100ad8:	0f be c0             	movsbl %al,%eax
80100adb:	0f b6 c0             	movzbl %al,%eax
80100ade:	83 ec 0c             	sub    $0xc,%esp
80100ae1:	50                   	push   %eax
80100ae2:	e8 ab fc ff ff       	call   80100792 <consputc>
80100ae7:	83 c4 10             	add    $0x10,%esp
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
80100aea:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100af1:	3b 45 10             	cmp    0x10(%ebp),%eax
80100af4:	7c d7                	jl     80100acd <consolewrite+0x2d>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
80100af6:	83 ec 0c             	sub    $0xc,%esp
80100af9:	68 e0 c5 10 80       	push   $0x8010c5e0
80100afe:	e8 d4 4a 00 00       	call   801055d7 <release>
80100b03:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100b06:	83 ec 0c             	sub    $0xc,%esp
80100b09:	ff 75 08             	pushl  0x8(%ebp)
80100b0c:	e8 0f 0e 00 00       	call   80101920 <ilock>
80100b11:	83 c4 10             	add    $0x10,%esp

  return n;
80100b14:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100b17:	c9                   	leave  
80100b18:	c3                   	ret    

80100b19 <consoleinit>:

void
consoleinit(void)
{
80100b19:	55                   	push   %ebp
80100b1a:	89 e5                	mov    %esp,%ebp
80100b1c:	83 ec 08             	sub    $0x8,%esp
  initlock(&cons.lock, "console");
80100b1f:	83 ec 08             	sub    $0x8,%esp
80100b22:	68 92 8d 10 80       	push   $0x80108d92
80100b27:	68 e0 c5 10 80       	push   $0x8010c5e0
80100b2c:	e8 1d 4a 00 00       	call   8010554e <initlock>
80100b31:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100b34:	c7 05 ec 21 11 80 a0 	movl   $0x80100aa0,0x801121ec
80100b3b:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100b3e:	c7 05 e8 21 11 80 8f 	movl   $0x8010098f,0x801121e8
80100b45:	09 10 80 
  cons.locking = 1;
80100b48:	c7 05 14 c6 10 80 01 	movl   $0x1,0x8010c614
80100b4f:	00 00 00 

  picenable(IRQ_KBD);
80100b52:	83 ec 0c             	sub    $0xc,%esp
80100b55:	6a 01                	push   $0x1
80100b57:	e8 6f 33 00 00       	call   80103ecb <picenable>
80100b5c:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_KBD, 0);
80100b5f:	83 ec 08             	sub    $0x8,%esp
80100b62:	6a 00                	push   $0x0
80100b64:	6a 01                	push   $0x1
80100b66:	e8 25 1f 00 00       	call   80102a90 <ioapicenable>
80100b6b:	83 c4 10             	add    $0x10,%esp
}
80100b6e:	90                   	nop
80100b6f:	c9                   	leave  
80100b70:	c3                   	ret    

80100b71 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100b71:	55                   	push   %ebp
80100b72:	89 e5                	mov    %esp,%ebp
80100b74:	81 ec 18 01 00 00    	sub    $0x118,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
80100b7a:	e8 a8 29 00 00       	call   80103527 <begin_op>
  if((ip = namei(path)) == 0){
80100b7f:	83 ec 0c             	sub    $0xc,%esp
80100b82:	ff 75 08             	pushl  0x8(%ebp)
80100b85:	e8 54 19 00 00       	call   801024de <namei>
80100b8a:	83 c4 10             	add    $0x10,%esp
80100b8d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100b90:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100b94:	75 0f                	jne    80100ba5 <exec+0x34>
    end_op();
80100b96:	e8 18 2a 00 00       	call   801035b3 <end_op>
    return -1;
80100b9b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100ba0:	e9 ce 03 00 00       	jmp    80100f73 <exec+0x402>
  }
  ilock(ip);
80100ba5:	83 ec 0c             	sub    $0xc,%esp
80100ba8:	ff 75 d8             	pushl  -0x28(%ebp)
80100bab:	e8 70 0d 00 00       	call   80101920 <ilock>
80100bb0:	83 c4 10             	add    $0x10,%esp
  pgdir = 0;
80100bb3:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100bba:	6a 34                	push   $0x34
80100bbc:	6a 00                	push   $0x0
80100bbe:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
80100bc4:	50                   	push   %eax
80100bc5:	ff 75 d8             	pushl  -0x28(%ebp)
80100bc8:	e8 c1 12 00 00       	call   80101e8e <readi>
80100bcd:	83 c4 10             	add    $0x10,%esp
80100bd0:	83 f8 33             	cmp    $0x33,%eax
80100bd3:	0f 86 49 03 00 00    	jbe    80100f22 <exec+0x3b1>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100bd9:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100bdf:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100be4:	0f 85 3b 03 00 00    	jne    80100f25 <exec+0x3b4>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100bea:	e8 38 78 00 00       	call   80108427 <setupkvm>
80100bef:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100bf2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100bf6:	0f 84 2c 03 00 00    	je     80100f28 <exec+0x3b7>
    goto bad;

  // Load program into memory.
  sz = 0;
80100bfc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c03:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100c0a:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
80100c10:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100c13:	e9 ab 00 00 00       	jmp    80100cc3 <exec+0x152>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100c18:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100c1b:	6a 20                	push   $0x20
80100c1d:	50                   	push   %eax
80100c1e:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
80100c24:	50                   	push   %eax
80100c25:	ff 75 d8             	pushl  -0x28(%ebp)
80100c28:	e8 61 12 00 00       	call   80101e8e <readi>
80100c2d:	83 c4 10             	add    $0x10,%esp
80100c30:	83 f8 20             	cmp    $0x20,%eax
80100c33:	0f 85 f2 02 00 00    	jne    80100f2b <exec+0x3ba>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100c39:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100c3f:	83 f8 01             	cmp    $0x1,%eax
80100c42:	75 71                	jne    80100cb5 <exec+0x144>
      continue;
    if(ph.memsz < ph.filesz)
80100c44:	8b 95 00 ff ff ff    	mov    -0x100(%ebp),%edx
80100c4a:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100c50:	39 c2                	cmp    %eax,%edx
80100c52:	0f 82 d6 02 00 00    	jb     80100f2e <exec+0x3bd>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100c58:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100c5e:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100c64:	01 d0                	add    %edx,%eax
80100c66:	83 ec 04             	sub    $0x4,%esp
80100c69:	50                   	push   %eax
80100c6a:	ff 75 e0             	pushl  -0x20(%ebp)
80100c6d:	ff 75 d4             	pushl  -0x2c(%ebp)
80100c70:	e8 59 7b 00 00       	call   801087ce <allocuvm>
80100c75:	83 c4 10             	add    $0x10,%esp
80100c78:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100c7b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100c7f:	0f 84 ac 02 00 00    	je     80100f31 <exec+0x3c0>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c85:	8b 95 fc fe ff ff    	mov    -0x104(%ebp),%edx
80100c8b:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c91:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
80100c97:	83 ec 0c             	sub    $0xc,%esp
80100c9a:	52                   	push   %edx
80100c9b:	50                   	push   %eax
80100c9c:	ff 75 d8             	pushl  -0x28(%ebp)
80100c9f:	51                   	push   %ecx
80100ca0:	ff 75 d4             	pushl  -0x2c(%ebp)
80100ca3:	e8 4f 7a 00 00       	call   801086f7 <loaduvm>
80100ca8:	83 c4 20             	add    $0x20,%esp
80100cab:	85 c0                	test   %eax,%eax
80100cad:	0f 88 81 02 00 00    	js     80100f34 <exec+0x3c3>
80100cb3:	eb 01                	jmp    80100cb6 <exec+0x145>
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
      continue;
80100cb5:	90                   	nop
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100cb6:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100cba:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100cbd:	83 c0 20             	add    $0x20,%eax
80100cc0:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100cc3:	0f b7 85 38 ff ff ff 	movzwl -0xc8(%ebp),%eax
80100cca:	0f b7 c0             	movzwl %ax,%eax
80100ccd:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100cd0:	0f 8f 42 ff ff ff    	jg     80100c18 <exec+0xa7>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100cd6:	83 ec 0c             	sub    $0xc,%esp
80100cd9:	ff 75 d8             	pushl  -0x28(%ebp)
80100cdc:	e8 ff 0e 00 00       	call   80101be0 <iunlockput>
80100ce1:	83 c4 10             	add    $0x10,%esp
  end_op();
80100ce4:	e8 ca 28 00 00       	call   801035b3 <end_op>
  ip = 0;
80100ce9:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100cf0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cf3:	05 ff 0f 00 00       	add    $0xfff,%eax
80100cf8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100cfd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100d00:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d03:	05 00 20 00 00       	add    $0x2000,%eax
80100d08:	83 ec 04             	sub    $0x4,%esp
80100d0b:	50                   	push   %eax
80100d0c:	ff 75 e0             	pushl  -0x20(%ebp)
80100d0f:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d12:	e8 b7 7a 00 00       	call   801087ce <allocuvm>
80100d17:	83 c4 10             	add    $0x10,%esp
80100d1a:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d1d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100d21:	0f 84 10 02 00 00    	je     80100f37 <exec+0x3c6>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100d27:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d2a:	2d 00 20 00 00       	sub    $0x2000,%eax
80100d2f:	83 ec 08             	sub    $0x8,%esp
80100d32:	50                   	push   %eax
80100d33:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d36:	e8 b9 7c 00 00       	call   801089f4 <clearpteu>
80100d3b:	83 c4 10             	add    $0x10,%esp
  sp = sz;
80100d3e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d41:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d44:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100d4b:	e9 96 00 00 00       	jmp    80100de6 <exec+0x275>
    if(argc >= MAXARG)
80100d50:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100d54:	0f 87 e0 01 00 00    	ja     80100f3a <exec+0x3c9>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d5a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d5d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d64:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d67:	01 d0                	add    %edx,%eax
80100d69:	8b 00                	mov    (%eax),%eax
80100d6b:	83 ec 0c             	sub    $0xc,%esp
80100d6e:	50                   	push   %eax
80100d6f:	e8 ac 4c 00 00       	call   80105a20 <strlen>
80100d74:	83 c4 10             	add    $0x10,%esp
80100d77:	89 c2                	mov    %eax,%edx
80100d79:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d7c:	29 d0                	sub    %edx,%eax
80100d7e:	83 e8 01             	sub    $0x1,%eax
80100d81:	83 e0 fc             	and    $0xfffffffc,%eax
80100d84:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d8a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d91:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d94:	01 d0                	add    %edx,%eax
80100d96:	8b 00                	mov    (%eax),%eax
80100d98:	83 ec 0c             	sub    $0xc,%esp
80100d9b:	50                   	push   %eax
80100d9c:	e8 7f 4c 00 00       	call   80105a20 <strlen>
80100da1:	83 c4 10             	add    $0x10,%esp
80100da4:	83 c0 01             	add    $0x1,%eax
80100da7:	89 c1                	mov    %eax,%ecx
80100da9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dac:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100db3:	8b 45 0c             	mov    0xc(%ebp),%eax
80100db6:	01 d0                	add    %edx,%eax
80100db8:	8b 00                	mov    (%eax),%eax
80100dba:	51                   	push   %ecx
80100dbb:	50                   	push   %eax
80100dbc:	ff 75 dc             	pushl  -0x24(%ebp)
80100dbf:	ff 75 d4             	pushl  -0x2c(%ebp)
80100dc2:	e8 e4 7d 00 00       	call   80108bab <copyout>
80100dc7:	83 c4 10             	add    $0x10,%esp
80100dca:	85 c0                	test   %eax,%eax
80100dcc:	0f 88 6b 01 00 00    	js     80100f3d <exec+0x3cc>
      goto bad;
    ustack[3+argc] = sp;
80100dd2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dd5:	8d 50 03             	lea    0x3(%eax),%edx
80100dd8:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100ddb:	89 84 95 40 ff ff ff 	mov    %eax,-0xc0(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100de2:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100de6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100de9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100df0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100df3:	01 d0                	add    %edx,%eax
80100df5:	8b 00                	mov    (%eax),%eax
80100df7:	85 c0                	test   %eax,%eax
80100df9:	0f 85 51 ff ff ff    	jne    80100d50 <exec+0x1df>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100dff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e02:	83 c0 03             	add    $0x3,%eax
80100e05:	c7 84 85 40 ff ff ff 	movl   $0x0,-0xc0(%ebp,%eax,4)
80100e0c:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100e10:	c7 85 40 ff ff ff ff 	movl   $0xffffffff,-0xc0(%ebp)
80100e17:	ff ff ff 
  ustack[1] = argc;
80100e1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e1d:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e26:	83 c0 01             	add    $0x1,%eax
80100e29:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e30:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e33:	29 d0                	sub    %edx,%eax
80100e35:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

  sp -= (3+argc+1) * 4;
80100e3b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e3e:	83 c0 04             	add    $0x4,%eax
80100e41:	c1 e0 02             	shl    $0x2,%eax
80100e44:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100e47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e4a:	83 c0 04             	add    $0x4,%eax
80100e4d:	c1 e0 02             	shl    $0x2,%eax
80100e50:	50                   	push   %eax
80100e51:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
80100e57:	50                   	push   %eax
80100e58:	ff 75 dc             	pushl  -0x24(%ebp)
80100e5b:	ff 75 d4             	pushl  -0x2c(%ebp)
80100e5e:	e8 48 7d 00 00       	call   80108bab <copyout>
80100e63:	83 c4 10             	add    $0x10,%esp
80100e66:	85 c0                	test   %eax,%eax
80100e68:	0f 88 d2 00 00 00    	js     80100f40 <exec+0x3cf>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e6e:	8b 45 08             	mov    0x8(%ebp),%eax
80100e71:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100e74:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e77:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100e7a:	eb 17                	jmp    80100e93 <exec+0x322>
    if(*s == '/')
80100e7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e7f:	0f b6 00             	movzbl (%eax),%eax
80100e82:	3c 2f                	cmp    $0x2f,%al
80100e84:	75 09                	jne    80100e8f <exec+0x31e>
      last = s+1;
80100e86:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e89:	83 c0 01             	add    $0x1,%eax
80100e8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e8f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100e93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e96:	0f b6 00             	movzbl (%eax),%eax
80100e99:	84 c0                	test   %al,%al
80100e9b:	75 df                	jne    80100e7c <exec+0x30b>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100e9d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ea3:	83 c0 6c             	add    $0x6c,%eax
80100ea6:	83 ec 04             	sub    $0x4,%esp
80100ea9:	6a 10                	push   $0x10
80100eab:	ff 75 f0             	pushl  -0x10(%ebp)
80100eae:	50                   	push   %eax
80100eaf:	e8 22 4b 00 00       	call   801059d6 <safestrcpy>
80100eb4:	83 c4 10             	add    $0x10,%esp

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100eb7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ebd:	8b 40 04             	mov    0x4(%eax),%eax
80100ec0:	89 45 d0             	mov    %eax,-0x30(%ebp)
  proc->pgdir = pgdir;
80100ec3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ec9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100ecc:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100ecf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ed5:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100ed8:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100eda:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ee0:	8b 40 18             	mov    0x18(%eax),%eax
80100ee3:	8b 95 24 ff ff ff    	mov    -0xdc(%ebp),%edx
80100ee9:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80100eec:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ef2:	8b 40 18             	mov    0x18(%eax),%eax
80100ef5:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100ef8:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(proc);
80100efb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f01:	83 ec 0c             	sub    $0xc,%esp
80100f04:	50                   	push   %eax
80100f05:	e8 04 76 00 00       	call   8010850e <switchuvm>
80100f0a:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100f0d:	83 ec 0c             	sub    $0xc,%esp
80100f10:	ff 75 d0             	pushl  -0x30(%ebp)
80100f13:	e8 3c 7a 00 00       	call   80108954 <freevm>
80100f18:	83 c4 10             	add    $0x10,%esp
  return 0;
80100f1b:	b8 00 00 00 00       	mov    $0x0,%eax
80100f20:	eb 51                	jmp    80100f73 <exec+0x402>
  ilock(ip);
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
    goto bad;
80100f22:	90                   	nop
80100f23:	eb 1c                	jmp    80100f41 <exec+0x3d0>
  if(elf.magic != ELF_MAGIC)
    goto bad;
80100f25:	90                   	nop
80100f26:	eb 19                	jmp    80100f41 <exec+0x3d0>

  if((pgdir = setupkvm()) == 0)
    goto bad;
80100f28:	90                   	nop
80100f29:	eb 16                	jmp    80100f41 <exec+0x3d0>

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
80100f2b:	90                   	nop
80100f2c:	eb 13                	jmp    80100f41 <exec+0x3d0>
    if(ph.type != ELF_PROG_LOAD)
      continue;
    if(ph.memsz < ph.filesz)
      goto bad;
80100f2e:	90                   	nop
80100f2f:	eb 10                	jmp    80100f41 <exec+0x3d0>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
80100f31:	90                   	nop
80100f32:	eb 0d                	jmp    80100f41 <exec+0x3d0>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
80100f34:	90                   	nop
80100f35:	eb 0a                	jmp    80100f41 <exec+0x3d0>

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
80100f37:	90                   	nop
80100f38:	eb 07                	jmp    80100f41 <exec+0x3d0>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
80100f3a:	90                   	nop
80100f3b:	eb 04                	jmp    80100f41 <exec+0x3d0>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
80100f3d:	90                   	nop
80100f3e:	eb 01                	jmp    80100f41 <exec+0x3d0>
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;
80100f40:	90                   	nop
  switchuvm(proc);
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
80100f41:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100f45:	74 0e                	je     80100f55 <exec+0x3e4>
    freevm(pgdir);
80100f47:	83 ec 0c             	sub    $0xc,%esp
80100f4a:	ff 75 d4             	pushl  -0x2c(%ebp)
80100f4d:	e8 02 7a 00 00       	call   80108954 <freevm>
80100f52:	83 c4 10             	add    $0x10,%esp
  if(ip){
80100f55:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100f59:	74 13                	je     80100f6e <exec+0x3fd>
    iunlockput(ip);
80100f5b:	83 ec 0c             	sub    $0xc,%esp
80100f5e:	ff 75 d8             	pushl  -0x28(%ebp)
80100f61:	e8 7a 0c 00 00       	call   80101be0 <iunlockput>
80100f66:	83 c4 10             	add    $0x10,%esp
    end_op();
80100f69:	e8 45 26 00 00       	call   801035b3 <end_op>
  }
  return -1;
80100f6e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f73:	c9                   	leave  
80100f74:	c3                   	ret    

80100f75 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f75:	55                   	push   %ebp
80100f76:	89 e5                	mov    %esp,%ebp
80100f78:	83 ec 08             	sub    $0x8,%esp
  initlock(&ftable.lock, "ftable");
80100f7b:	83 ec 08             	sub    $0x8,%esp
80100f7e:	68 9a 8d 10 80       	push   $0x80108d9a
80100f83:	68 40 18 11 80       	push   $0x80111840
80100f88:	e8 c1 45 00 00       	call   8010554e <initlock>
80100f8d:	83 c4 10             	add    $0x10,%esp
}
80100f90:	90                   	nop
80100f91:	c9                   	leave  
80100f92:	c3                   	ret    

80100f93 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f93:	55                   	push   %ebp
80100f94:	89 e5                	mov    %esp,%ebp
80100f96:	83 ec 18             	sub    $0x18,%esp
  struct file *f;

  acquire(&ftable.lock);
80100f99:	83 ec 0c             	sub    $0xc,%esp
80100f9c:	68 40 18 11 80       	push   $0x80111840
80100fa1:	e8 ca 45 00 00       	call   80105570 <acquire>
80100fa6:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100fa9:	c7 45 f4 74 18 11 80 	movl   $0x80111874,-0xc(%ebp)
80100fb0:	eb 2d                	jmp    80100fdf <filealloc+0x4c>
    if(f->ref == 0){
80100fb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fb5:	8b 40 04             	mov    0x4(%eax),%eax
80100fb8:	85 c0                	test   %eax,%eax
80100fba:	75 1f                	jne    80100fdb <filealloc+0x48>
      f->ref = 1;
80100fbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fbf:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80100fc6:	83 ec 0c             	sub    $0xc,%esp
80100fc9:	68 40 18 11 80       	push   $0x80111840
80100fce:	e8 04 46 00 00       	call   801055d7 <release>
80100fd3:	83 c4 10             	add    $0x10,%esp
      return f;
80100fd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fd9:	eb 23                	jmp    80100ffe <filealloc+0x6b>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100fdb:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80100fdf:	b8 d4 21 11 80       	mov    $0x801121d4,%eax
80100fe4:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80100fe7:	72 c9                	jb     80100fb2 <filealloc+0x1f>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100fe9:	83 ec 0c             	sub    $0xc,%esp
80100fec:	68 40 18 11 80       	push   $0x80111840
80100ff1:	e8 e1 45 00 00       	call   801055d7 <release>
80100ff6:	83 c4 10             	add    $0x10,%esp
  return 0;
80100ff9:	b8 00 00 00 00       	mov    $0x0,%eax
}
80100ffe:	c9                   	leave  
80100fff:	c3                   	ret    

80101000 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101000:	55                   	push   %ebp
80101001:	89 e5                	mov    %esp,%ebp
80101003:	83 ec 08             	sub    $0x8,%esp
  acquire(&ftable.lock);
80101006:	83 ec 0c             	sub    $0xc,%esp
80101009:	68 40 18 11 80       	push   $0x80111840
8010100e:	e8 5d 45 00 00       	call   80105570 <acquire>
80101013:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80101016:	8b 45 08             	mov    0x8(%ebp),%eax
80101019:	8b 40 04             	mov    0x4(%eax),%eax
8010101c:	85 c0                	test   %eax,%eax
8010101e:	7f 0d                	jg     8010102d <filedup+0x2d>
    panic("filedup");
80101020:	83 ec 0c             	sub    $0xc,%esp
80101023:	68 a1 8d 10 80       	push   $0x80108da1
80101028:	e8 39 f5 ff ff       	call   80100566 <panic>
  f->ref++;
8010102d:	8b 45 08             	mov    0x8(%ebp),%eax
80101030:	8b 40 04             	mov    0x4(%eax),%eax
80101033:	8d 50 01             	lea    0x1(%eax),%edx
80101036:	8b 45 08             	mov    0x8(%ebp),%eax
80101039:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
8010103c:	83 ec 0c             	sub    $0xc,%esp
8010103f:	68 40 18 11 80       	push   $0x80111840
80101044:	e8 8e 45 00 00       	call   801055d7 <release>
80101049:	83 c4 10             	add    $0x10,%esp
  return f;
8010104c:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010104f:	c9                   	leave  
80101050:	c3                   	ret    

80101051 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101051:	55                   	push   %ebp
80101052:	89 e5                	mov    %esp,%ebp
80101054:	83 ec 28             	sub    $0x28,%esp
  struct file ff;

  acquire(&ftable.lock);
80101057:	83 ec 0c             	sub    $0xc,%esp
8010105a:	68 40 18 11 80       	push   $0x80111840
8010105f:	e8 0c 45 00 00       	call   80105570 <acquire>
80101064:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80101067:	8b 45 08             	mov    0x8(%ebp),%eax
8010106a:	8b 40 04             	mov    0x4(%eax),%eax
8010106d:	85 c0                	test   %eax,%eax
8010106f:	7f 0d                	jg     8010107e <fileclose+0x2d>
    panic("fileclose");
80101071:	83 ec 0c             	sub    $0xc,%esp
80101074:	68 a9 8d 10 80       	push   $0x80108da9
80101079:	e8 e8 f4 ff ff       	call   80100566 <panic>
  if(--f->ref > 0){
8010107e:	8b 45 08             	mov    0x8(%ebp),%eax
80101081:	8b 40 04             	mov    0x4(%eax),%eax
80101084:	8d 50 ff             	lea    -0x1(%eax),%edx
80101087:	8b 45 08             	mov    0x8(%ebp),%eax
8010108a:	89 50 04             	mov    %edx,0x4(%eax)
8010108d:	8b 45 08             	mov    0x8(%ebp),%eax
80101090:	8b 40 04             	mov    0x4(%eax),%eax
80101093:	85 c0                	test   %eax,%eax
80101095:	7e 15                	jle    801010ac <fileclose+0x5b>
    release(&ftable.lock);
80101097:	83 ec 0c             	sub    $0xc,%esp
8010109a:	68 40 18 11 80       	push   $0x80111840
8010109f:	e8 33 45 00 00       	call   801055d7 <release>
801010a4:	83 c4 10             	add    $0x10,%esp
801010a7:	e9 8b 00 00 00       	jmp    80101137 <fileclose+0xe6>
    return;
  }
  ff = *f;
801010ac:	8b 45 08             	mov    0x8(%ebp),%eax
801010af:	8b 10                	mov    (%eax),%edx
801010b1:	89 55 e0             	mov    %edx,-0x20(%ebp)
801010b4:	8b 50 04             	mov    0x4(%eax),%edx
801010b7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801010ba:	8b 50 08             	mov    0x8(%eax),%edx
801010bd:	89 55 e8             	mov    %edx,-0x18(%ebp)
801010c0:	8b 50 0c             	mov    0xc(%eax),%edx
801010c3:	89 55 ec             	mov    %edx,-0x14(%ebp)
801010c6:	8b 50 10             	mov    0x10(%eax),%edx
801010c9:	89 55 f0             	mov    %edx,-0x10(%ebp)
801010cc:	8b 40 14             	mov    0x14(%eax),%eax
801010cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
801010d2:	8b 45 08             	mov    0x8(%ebp),%eax
801010d5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
801010dc:	8b 45 08             	mov    0x8(%ebp),%eax
801010df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
801010e5:	83 ec 0c             	sub    $0xc,%esp
801010e8:	68 40 18 11 80       	push   $0x80111840
801010ed:	e8 e5 44 00 00       	call   801055d7 <release>
801010f2:	83 c4 10             	add    $0x10,%esp
  
  if(ff.type == FD_PIPE)
801010f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010f8:	83 f8 01             	cmp    $0x1,%eax
801010fb:	75 19                	jne    80101116 <fileclose+0xc5>
    pipeclose(ff.pipe, ff.writable);
801010fd:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
80101101:	0f be d0             	movsbl %al,%edx
80101104:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101107:	83 ec 08             	sub    $0x8,%esp
8010110a:	52                   	push   %edx
8010110b:	50                   	push   %eax
8010110c:	e8 23 30 00 00       	call   80104134 <pipeclose>
80101111:	83 c4 10             	add    $0x10,%esp
80101114:	eb 21                	jmp    80101137 <fileclose+0xe6>
  else if(ff.type == FD_INODE){
80101116:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101119:	83 f8 02             	cmp    $0x2,%eax
8010111c:	75 19                	jne    80101137 <fileclose+0xe6>
    begin_op();
8010111e:	e8 04 24 00 00       	call   80103527 <begin_op>
    iput(ff.ip);
80101123:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101126:	83 ec 0c             	sub    $0xc,%esp
80101129:	50                   	push   %eax
8010112a:	e8 c1 09 00 00       	call   80101af0 <iput>
8010112f:	83 c4 10             	add    $0x10,%esp
    end_op();
80101132:	e8 7c 24 00 00       	call   801035b3 <end_op>
  }
}
80101137:	c9                   	leave  
80101138:	c3                   	ret    

80101139 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101139:	55                   	push   %ebp
8010113a:	89 e5                	mov    %esp,%ebp
8010113c:	83 ec 08             	sub    $0x8,%esp
  if(f->type == FD_INODE){
8010113f:	8b 45 08             	mov    0x8(%ebp),%eax
80101142:	8b 00                	mov    (%eax),%eax
80101144:	83 f8 02             	cmp    $0x2,%eax
80101147:	75 40                	jne    80101189 <filestat+0x50>
    ilock(f->ip);
80101149:	8b 45 08             	mov    0x8(%ebp),%eax
8010114c:	8b 40 10             	mov    0x10(%eax),%eax
8010114f:	83 ec 0c             	sub    $0xc,%esp
80101152:	50                   	push   %eax
80101153:	e8 c8 07 00 00       	call   80101920 <ilock>
80101158:	83 c4 10             	add    $0x10,%esp
    stati(f->ip, st);
8010115b:	8b 45 08             	mov    0x8(%ebp),%eax
8010115e:	8b 40 10             	mov    0x10(%eax),%eax
80101161:	83 ec 08             	sub    $0x8,%esp
80101164:	ff 75 0c             	pushl  0xc(%ebp)
80101167:	50                   	push   %eax
80101168:	e8 db 0c 00 00       	call   80101e48 <stati>
8010116d:	83 c4 10             	add    $0x10,%esp
    iunlock(f->ip);
80101170:	8b 45 08             	mov    0x8(%ebp),%eax
80101173:	8b 40 10             	mov    0x10(%eax),%eax
80101176:	83 ec 0c             	sub    $0xc,%esp
80101179:	50                   	push   %eax
8010117a:	e8 ff 08 00 00       	call   80101a7e <iunlock>
8010117f:	83 c4 10             	add    $0x10,%esp
    return 0;
80101182:	b8 00 00 00 00       	mov    $0x0,%eax
80101187:	eb 05                	jmp    8010118e <filestat+0x55>
  }
  return -1;
80101189:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010118e:	c9                   	leave  
8010118f:	c3                   	ret    

80101190 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101190:	55                   	push   %ebp
80101191:	89 e5                	mov    %esp,%ebp
80101193:	83 ec 18             	sub    $0x18,%esp
  int r;

  if(f->readable == 0)
80101196:	8b 45 08             	mov    0x8(%ebp),%eax
80101199:	0f b6 40 08          	movzbl 0x8(%eax),%eax
8010119d:	84 c0                	test   %al,%al
8010119f:	75 0a                	jne    801011ab <fileread+0x1b>
    return -1;
801011a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801011a6:	e9 9b 00 00 00       	jmp    80101246 <fileread+0xb6>
  if(f->type == FD_PIPE)
801011ab:	8b 45 08             	mov    0x8(%ebp),%eax
801011ae:	8b 00                	mov    (%eax),%eax
801011b0:	83 f8 01             	cmp    $0x1,%eax
801011b3:	75 1a                	jne    801011cf <fileread+0x3f>
    return piperead(f->pipe, addr, n);
801011b5:	8b 45 08             	mov    0x8(%ebp),%eax
801011b8:	8b 40 0c             	mov    0xc(%eax),%eax
801011bb:	83 ec 04             	sub    $0x4,%esp
801011be:	ff 75 10             	pushl  0x10(%ebp)
801011c1:	ff 75 0c             	pushl  0xc(%ebp)
801011c4:	50                   	push   %eax
801011c5:	e8 12 31 00 00       	call   801042dc <piperead>
801011ca:	83 c4 10             	add    $0x10,%esp
801011cd:	eb 77                	jmp    80101246 <fileread+0xb6>
  if(f->type == FD_INODE){
801011cf:	8b 45 08             	mov    0x8(%ebp),%eax
801011d2:	8b 00                	mov    (%eax),%eax
801011d4:	83 f8 02             	cmp    $0x2,%eax
801011d7:	75 60                	jne    80101239 <fileread+0xa9>
    ilock(f->ip);
801011d9:	8b 45 08             	mov    0x8(%ebp),%eax
801011dc:	8b 40 10             	mov    0x10(%eax),%eax
801011df:	83 ec 0c             	sub    $0xc,%esp
801011e2:	50                   	push   %eax
801011e3:	e8 38 07 00 00       	call   80101920 <ilock>
801011e8:	83 c4 10             	add    $0x10,%esp
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801011eb:	8b 4d 10             	mov    0x10(%ebp),%ecx
801011ee:	8b 45 08             	mov    0x8(%ebp),%eax
801011f1:	8b 50 14             	mov    0x14(%eax),%edx
801011f4:	8b 45 08             	mov    0x8(%ebp),%eax
801011f7:	8b 40 10             	mov    0x10(%eax),%eax
801011fa:	51                   	push   %ecx
801011fb:	52                   	push   %edx
801011fc:	ff 75 0c             	pushl  0xc(%ebp)
801011ff:	50                   	push   %eax
80101200:	e8 89 0c 00 00       	call   80101e8e <readi>
80101205:	83 c4 10             	add    $0x10,%esp
80101208:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010120b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010120f:	7e 11                	jle    80101222 <fileread+0x92>
      f->off += r;
80101211:	8b 45 08             	mov    0x8(%ebp),%eax
80101214:	8b 50 14             	mov    0x14(%eax),%edx
80101217:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010121a:	01 c2                	add    %eax,%edx
8010121c:	8b 45 08             	mov    0x8(%ebp),%eax
8010121f:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
80101222:	8b 45 08             	mov    0x8(%ebp),%eax
80101225:	8b 40 10             	mov    0x10(%eax),%eax
80101228:	83 ec 0c             	sub    $0xc,%esp
8010122b:	50                   	push   %eax
8010122c:	e8 4d 08 00 00       	call   80101a7e <iunlock>
80101231:	83 c4 10             	add    $0x10,%esp
    return r;
80101234:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101237:	eb 0d                	jmp    80101246 <fileread+0xb6>
  }
  panic("fileread");
80101239:	83 ec 0c             	sub    $0xc,%esp
8010123c:	68 b3 8d 10 80       	push   $0x80108db3
80101241:	e8 20 f3 ff ff       	call   80100566 <panic>
}
80101246:	c9                   	leave  
80101247:	c3                   	ret    

80101248 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101248:	55                   	push   %ebp
80101249:	89 e5                	mov    %esp,%ebp
8010124b:	53                   	push   %ebx
8010124c:	83 ec 14             	sub    $0x14,%esp
  int r;

  if(f->writable == 0)
8010124f:	8b 45 08             	mov    0x8(%ebp),%eax
80101252:	0f b6 40 09          	movzbl 0x9(%eax),%eax
80101256:	84 c0                	test   %al,%al
80101258:	75 0a                	jne    80101264 <filewrite+0x1c>
    return -1;
8010125a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010125f:	e9 1b 01 00 00       	jmp    8010137f <filewrite+0x137>
  if(f->type == FD_PIPE)
80101264:	8b 45 08             	mov    0x8(%ebp),%eax
80101267:	8b 00                	mov    (%eax),%eax
80101269:	83 f8 01             	cmp    $0x1,%eax
8010126c:	75 1d                	jne    8010128b <filewrite+0x43>
    return pipewrite(f->pipe, addr, n);
8010126e:	8b 45 08             	mov    0x8(%ebp),%eax
80101271:	8b 40 0c             	mov    0xc(%eax),%eax
80101274:	83 ec 04             	sub    $0x4,%esp
80101277:	ff 75 10             	pushl  0x10(%ebp)
8010127a:	ff 75 0c             	pushl  0xc(%ebp)
8010127d:	50                   	push   %eax
8010127e:	e8 5b 2f 00 00       	call   801041de <pipewrite>
80101283:	83 c4 10             	add    $0x10,%esp
80101286:	e9 f4 00 00 00       	jmp    8010137f <filewrite+0x137>
  if(f->type == FD_INODE){
8010128b:	8b 45 08             	mov    0x8(%ebp),%eax
8010128e:	8b 00                	mov    (%eax),%eax
80101290:	83 f8 02             	cmp    $0x2,%eax
80101293:	0f 85 d9 00 00 00    	jne    80101372 <filewrite+0x12a>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
80101299:	c7 45 ec 00 1a 00 00 	movl   $0x1a00,-0x14(%ebp)
    int i = 0;
801012a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
801012a7:	e9 a3 00 00 00       	jmp    8010134f <filewrite+0x107>
      int n1 = n - i;
801012ac:	8b 45 10             	mov    0x10(%ebp),%eax
801012af:	2b 45 f4             	sub    -0xc(%ebp),%eax
801012b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
801012b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801012b8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801012bb:	7e 06                	jle    801012c3 <filewrite+0x7b>
        n1 = max;
801012bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
801012c0:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
801012c3:	e8 5f 22 00 00       	call   80103527 <begin_op>
      ilock(f->ip);
801012c8:	8b 45 08             	mov    0x8(%ebp),%eax
801012cb:	8b 40 10             	mov    0x10(%eax),%eax
801012ce:	83 ec 0c             	sub    $0xc,%esp
801012d1:	50                   	push   %eax
801012d2:	e8 49 06 00 00       	call   80101920 <ilock>
801012d7:	83 c4 10             	add    $0x10,%esp
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801012da:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801012dd:	8b 45 08             	mov    0x8(%ebp),%eax
801012e0:	8b 50 14             	mov    0x14(%eax),%edx
801012e3:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801012e6:	8b 45 0c             	mov    0xc(%ebp),%eax
801012e9:	01 c3                	add    %eax,%ebx
801012eb:	8b 45 08             	mov    0x8(%ebp),%eax
801012ee:	8b 40 10             	mov    0x10(%eax),%eax
801012f1:	51                   	push   %ecx
801012f2:	52                   	push   %edx
801012f3:	53                   	push   %ebx
801012f4:	50                   	push   %eax
801012f5:	e8 eb 0c 00 00       	call   80101fe5 <writei>
801012fa:	83 c4 10             	add    $0x10,%esp
801012fd:	89 45 e8             	mov    %eax,-0x18(%ebp)
80101300:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101304:	7e 11                	jle    80101317 <filewrite+0xcf>
        f->off += r;
80101306:	8b 45 08             	mov    0x8(%ebp),%eax
80101309:	8b 50 14             	mov    0x14(%eax),%edx
8010130c:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010130f:	01 c2                	add    %eax,%edx
80101311:	8b 45 08             	mov    0x8(%ebp),%eax
80101314:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
80101317:	8b 45 08             	mov    0x8(%ebp),%eax
8010131a:	8b 40 10             	mov    0x10(%eax),%eax
8010131d:	83 ec 0c             	sub    $0xc,%esp
80101320:	50                   	push   %eax
80101321:	e8 58 07 00 00       	call   80101a7e <iunlock>
80101326:	83 c4 10             	add    $0x10,%esp
      end_op();
80101329:	e8 85 22 00 00       	call   801035b3 <end_op>

      if(r < 0)
8010132e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101332:	78 29                	js     8010135d <filewrite+0x115>
        break;
      if(r != n1)
80101334:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101337:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010133a:	74 0d                	je     80101349 <filewrite+0x101>
        panic("short filewrite");
8010133c:	83 ec 0c             	sub    $0xc,%esp
8010133f:	68 bc 8d 10 80       	push   $0x80108dbc
80101344:	e8 1d f2 ff ff       	call   80100566 <panic>
      i += r;
80101349:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010134c:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010134f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101352:	3b 45 10             	cmp    0x10(%ebp),%eax
80101355:	0f 8c 51 ff ff ff    	jl     801012ac <filewrite+0x64>
8010135b:	eb 01                	jmp    8010135e <filewrite+0x116>
        f->off += r;
      iunlock(f->ip);
      end_op();

      if(r < 0)
        break;
8010135d:	90                   	nop
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
8010135e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101361:	3b 45 10             	cmp    0x10(%ebp),%eax
80101364:	75 05                	jne    8010136b <filewrite+0x123>
80101366:	8b 45 10             	mov    0x10(%ebp),%eax
80101369:	eb 14                	jmp    8010137f <filewrite+0x137>
8010136b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101370:	eb 0d                	jmp    8010137f <filewrite+0x137>
  }
  panic("filewrite");
80101372:	83 ec 0c             	sub    $0xc,%esp
80101375:	68 cc 8d 10 80       	push   $0x80108dcc
8010137a:	e8 e7 f1 ff ff       	call   80100566 <panic>
}
8010137f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101382:	c9                   	leave  
80101383:	c3                   	ret    

80101384 <readsb>:
struct superblock sb;   // there should be one per dev, but we run with one dev

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101384:	55                   	push   %ebp
80101385:	89 e5                	mov    %esp,%ebp
80101387:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
8010138a:	8b 45 08             	mov    0x8(%ebp),%eax
8010138d:	83 ec 08             	sub    $0x8,%esp
80101390:	6a 01                	push   $0x1
80101392:	50                   	push   %eax
80101393:	e8 1e ee ff ff       	call   801001b6 <bread>
80101398:	83 c4 10             	add    $0x10,%esp
8010139b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
8010139e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013a1:	83 c0 18             	add    $0x18,%eax
801013a4:	83 ec 04             	sub    $0x4,%esp
801013a7:	6a 1c                	push   $0x1c
801013a9:	50                   	push   %eax
801013aa:	ff 75 0c             	pushl  0xc(%ebp)
801013ad:	e8 e0 44 00 00       	call   80105892 <memmove>
801013b2:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801013b5:	83 ec 0c             	sub    $0xc,%esp
801013b8:	ff 75 f4             	pushl  -0xc(%ebp)
801013bb:	e8 6e ee ff ff       	call   8010022e <brelse>
801013c0:	83 c4 10             	add    $0x10,%esp
}
801013c3:	90                   	nop
801013c4:	c9                   	leave  
801013c5:	c3                   	ret    

801013c6 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
801013c6:	55                   	push   %ebp
801013c7:	89 e5                	mov    %esp,%ebp
801013c9:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
801013cc:	8b 55 0c             	mov    0xc(%ebp),%edx
801013cf:	8b 45 08             	mov    0x8(%ebp),%eax
801013d2:	83 ec 08             	sub    $0x8,%esp
801013d5:	52                   	push   %edx
801013d6:	50                   	push   %eax
801013d7:	e8 da ed ff ff       	call   801001b6 <bread>
801013dc:	83 c4 10             	add    $0x10,%esp
801013df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
801013e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013e5:	83 c0 18             	add    $0x18,%eax
801013e8:	83 ec 04             	sub    $0x4,%esp
801013eb:	68 00 02 00 00       	push   $0x200
801013f0:	6a 00                	push   $0x0
801013f2:	50                   	push   %eax
801013f3:	e8 db 43 00 00       	call   801057d3 <memset>
801013f8:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
801013fb:	83 ec 0c             	sub    $0xc,%esp
801013fe:	ff 75 f4             	pushl  -0xc(%ebp)
80101401:	e8 59 23 00 00       	call   8010375f <log_write>
80101406:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101409:	83 ec 0c             	sub    $0xc,%esp
8010140c:	ff 75 f4             	pushl  -0xc(%ebp)
8010140f:	e8 1a ee ff ff       	call   8010022e <brelse>
80101414:	83 c4 10             	add    $0x10,%esp
}
80101417:	90                   	nop
80101418:	c9                   	leave  
80101419:	c3                   	ret    

8010141a <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
8010141a:	55                   	push   %ebp
8010141b:	89 e5                	mov    %esp,%ebp
8010141d:	83 ec 18             	sub    $0x18,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
80101420:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101427:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010142e:	e9 13 01 00 00       	jmp    80101546 <balloc+0x12c>
    bp = bread(dev, BBLOCK(b, sb));
80101433:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101436:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
8010143c:	85 c0                	test   %eax,%eax
8010143e:	0f 48 c2             	cmovs  %edx,%eax
80101441:	c1 f8 0c             	sar    $0xc,%eax
80101444:	89 c2                	mov    %eax,%edx
80101446:	a1 58 22 11 80       	mov    0x80112258,%eax
8010144b:	01 d0                	add    %edx,%eax
8010144d:	83 ec 08             	sub    $0x8,%esp
80101450:	50                   	push   %eax
80101451:	ff 75 08             	pushl  0x8(%ebp)
80101454:	e8 5d ed ff ff       	call   801001b6 <bread>
80101459:	83 c4 10             	add    $0x10,%esp
8010145c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010145f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101466:	e9 a6 00 00 00       	jmp    80101511 <balloc+0xf7>
      m = 1 << (bi % 8);
8010146b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010146e:	99                   	cltd   
8010146f:	c1 ea 1d             	shr    $0x1d,%edx
80101472:	01 d0                	add    %edx,%eax
80101474:	83 e0 07             	and    $0x7,%eax
80101477:	29 d0                	sub    %edx,%eax
80101479:	ba 01 00 00 00       	mov    $0x1,%edx
8010147e:	89 c1                	mov    %eax,%ecx
80101480:	d3 e2                	shl    %cl,%edx
80101482:	89 d0                	mov    %edx,%eax
80101484:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101487:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010148a:	8d 50 07             	lea    0x7(%eax),%edx
8010148d:	85 c0                	test   %eax,%eax
8010148f:	0f 48 c2             	cmovs  %edx,%eax
80101492:	c1 f8 03             	sar    $0x3,%eax
80101495:	89 c2                	mov    %eax,%edx
80101497:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010149a:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
8010149f:	0f b6 c0             	movzbl %al,%eax
801014a2:	23 45 e8             	and    -0x18(%ebp),%eax
801014a5:	85 c0                	test   %eax,%eax
801014a7:	75 64                	jne    8010150d <balloc+0xf3>
        bp->data[bi/8] |= m;  // Mark block in use.
801014a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014ac:	8d 50 07             	lea    0x7(%eax),%edx
801014af:	85 c0                	test   %eax,%eax
801014b1:	0f 48 c2             	cmovs  %edx,%eax
801014b4:	c1 f8 03             	sar    $0x3,%eax
801014b7:	8b 55 ec             	mov    -0x14(%ebp),%edx
801014ba:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
801014bf:	89 d1                	mov    %edx,%ecx
801014c1:	8b 55 e8             	mov    -0x18(%ebp),%edx
801014c4:	09 ca                	or     %ecx,%edx
801014c6:	89 d1                	mov    %edx,%ecx
801014c8:	8b 55 ec             	mov    -0x14(%ebp),%edx
801014cb:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
801014cf:	83 ec 0c             	sub    $0xc,%esp
801014d2:	ff 75 ec             	pushl  -0x14(%ebp)
801014d5:	e8 85 22 00 00       	call   8010375f <log_write>
801014da:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
801014dd:	83 ec 0c             	sub    $0xc,%esp
801014e0:	ff 75 ec             	pushl  -0x14(%ebp)
801014e3:	e8 46 ed ff ff       	call   8010022e <brelse>
801014e8:	83 c4 10             	add    $0x10,%esp
        bzero(dev, b + bi);
801014eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014f1:	01 c2                	add    %eax,%edx
801014f3:	8b 45 08             	mov    0x8(%ebp),%eax
801014f6:	83 ec 08             	sub    $0x8,%esp
801014f9:	52                   	push   %edx
801014fa:	50                   	push   %eax
801014fb:	e8 c6 fe ff ff       	call   801013c6 <bzero>
80101500:	83 c4 10             	add    $0x10,%esp
        return b + bi;
80101503:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101506:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101509:	01 d0                	add    %edx,%eax
8010150b:	eb 57                	jmp    80101564 <balloc+0x14a>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010150d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101511:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
80101518:	7f 17                	jg     80101531 <balloc+0x117>
8010151a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010151d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101520:	01 d0                	add    %edx,%eax
80101522:	89 c2                	mov    %eax,%edx
80101524:	a1 40 22 11 80       	mov    0x80112240,%eax
80101529:	39 c2                	cmp    %eax,%edx
8010152b:	0f 82 3a ff ff ff    	jb     8010146b <balloc+0x51>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101531:	83 ec 0c             	sub    $0xc,%esp
80101534:	ff 75 ec             	pushl  -0x14(%ebp)
80101537:	e8 f2 ec ff ff       	call   8010022e <brelse>
8010153c:	83 c4 10             	add    $0x10,%esp
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010153f:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80101546:	8b 15 40 22 11 80    	mov    0x80112240,%edx
8010154c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010154f:	39 c2                	cmp    %eax,%edx
80101551:	0f 87 dc fe ff ff    	ja     80101433 <balloc+0x19>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
80101557:	83 ec 0c             	sub    $0xc,%esp
8010155a:	68 d6 8d 10 80       	push   $0x80108dd6
8010155f:	e8 02 f0 ff ff       	call   80100566 <panic>
}
80101564:	c9                   	leave  
80101565:	c3                   	ret    

80101566 <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101566:	55                   	push   %ebp
80101567:	89 e5                	mov    %esp,%ebp
80101569:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
8010156c:	83 ec 08             	sub    $0x8,%esp
8010156f:	68 40 22 11 80       	push   $0x80112240
80101574:	ff 75 08             	pushl  0x8(%ebp)
80101577:	e8 08 fe ff ff       	call   80101384 <readsb>
8010157c:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
8010157f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101582:	c1 e8 0c             	shr    $0xc,%eax
80101585:	89 c2                	mov    %eax,%edx
80101587:	a1 58 22 11 80       	mov    0x80112258,%eax
8010158c:	01 c2                	add    %eax,%edx
8010158e:	8b 45 08             	mov    0x8(%ebp),%eax
80101591:	83 ec 08             	sub    $0x8,%esp
80101594:	52                   	push   %edx
80101595:	50                   	push   %eax
80101596:	e8 1b ec ff ff       	call   801001b6 <bread>
8010159b:	83 c4 10             	add    $0x10,%esp
8010159e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
801015a1:	8b 45 0c             	mov    0xc(%ebp),%eax
801015a4:	25 ff 0f 00 00       	and    $0xfff,%eax
801015a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
801015ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015af:	99                   	cltd   
801015b0:	c1 ea 1d             	shr    $0x1d,%edx
801015b3:	01 d0                	add    %edx,%eax
801015b5:	83 e0 07             	and    $0x7,%eax
801015b8:	29 d0                	sub    %edx,%eax
801015ba:	ba 01 00 00 00       	mov    $0x1,%edx
801015bf:	89 c1                	mov    %eax,%ecx
801015c1:	d3 e2                	shl    %cl,%edx
801015c3:	89 d0                	mov    %edx,%eax
801015c5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
801015c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015cb:	8d 50 07             	lea    0x7(%eax),%edx
801015ce:	85 c0                	test   %eax,%eax
801015d0:	0f 48 c2             	cmovs  %edx,%eax
801015d3:	c1 f8 03             	sar    $0x3,%eax
801015d6:	89 c2                	mov    %eax,%edx
801015d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015db:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
801015e0:	0f b6 c0             	movzbl %al,%eax
801015e3:	23 45 ec             	and    -0x14(%ebp),%eax
801015e6:	85 c0                	test   %eax,%eax
801015e8:	75 0d                	jne    801015f7 <bfree+0x91>
    panic("freeing free block");
801015ea:	83 ec 0c             	sub    $0xc,%esp
801015ed:	68 ec 8d 10 80       	push   $0x80108dec
801015f2:	e8 6f ef ff ff       	call   80100566 <panic>
  bp->data[bi/8] &= ~m;
801015f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015fa:	8d 50 07             	lea    0x7(%eax),%edx
801015fd:	85 c0                	test   %eax,%eax
801015ff:	0f 48 c2             	cmovs  %edx,%eax
80101602:	c1 f8 03             	sar    $0x3,%eax
80101605:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101608:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
8010160d:	89 d1                	mov    %edx,%ecx
8010160f:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101612:	f7 d2                	not    %edx
80101614:	21 ca                	and    %ecx,%edx
80101616:	89 d1                	mov    %edx,%ecx
80101618:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010161b:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
8010161f:	83 ec 0c             	sub    $0xc,%esp
80101622:	ff 75 f4             	pushl  -0xc(%ebp)
80101625:	e8 35 21 00 00       	call   8010375f <log_write>
8010162a:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
8010162d:	83 ec 0c             	sub    $0xc,%esp
80101630:	ff 75 f4             	pushl  -0xc(%ebp)
80101633:	e8 f6 eb ff ff       	call   8010022e <brelse>
80101638:	83 c4 10             	add    $0x10,%esp
}
8010163b:	90                   	nop
8010163c:	c9                   	leave  
8010163d:	c3                   	ret    

8010163e <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
8010163e:	55                   	push   %ebp
8010163f:	89 e5                	mov    %esp,%ebp
80101641:	83 ec 08             	sub    $0x8,%esp
  initlock(&icache.lock, "icache");
80101644:	83 ec 08             	sub    $0x8,%esp
80101647:	68 ff 8d 10 80       	push   $0x80108dff
8010164c:	68 60 22 11 80       	push   $0x80112260
80101651:	e8 f8 3e 00 00       	call   8010554e <initlock>
80101656:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
80101659:	83 ec 08             	sub    $0x8,%esp
8010165c:	68 40 22 11 80       	push   $0x80112240
80101661:	ff 75 08             	pushl  0x8(%ebp)
80101664:	e8 1b fd ff ff       	call   80101384 <readsb>
80101669:	83 c4 10             	add    $0x10,%esp
}
8010166c:	90                   	nop
8010166d:	c9                   	leave  
8010166e:	c3                   	ret    

8010166f <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
8010166f:	55                   	push   %ebp
80101670:	89 e5                	mov    %esp,%ebp
80101672:	83 ec 28             	sub    $0x28,%esp
80101675:	8b 45 0c             	mov    0xc(%ebp),%eax
80101678:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010167c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
80101683:	e9 9e 00 00 00       	jmp    80101726 <ialloc+0xb7>
    bp = bread(dev, IBLOCK(inum, sb));
80101688:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010168b:	c1 e8 03             	shr    $0x3,%eax
8010168e:	89 c2                	mov    %eax,%edx
80101690:	a1 54 22 11 80       	mov    0x80112254,%eax
80101695:	01 d0                	add    %edx,%eax
80101697:	83 ec 08             	sub    $0x8,%esp
8010169a:	50                   	push   %eax
8010169b:	ff 75 08             	pushl  0x8(%ebp)
8010169e:	e8 13 eb ff ff       	call   801001b6 <bread>
801016a3:	83 c4 10             	add    $0x10,%esp
801016a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
801016a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016ac:	8d 50 18             	lea    0x18(%eax),%edx
801016af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016b2:	83 e0 07             	and    $0x7,%eax
801016b5:	c1 e0 06             	shl    $0x6,%eax
801016b8:	01 d0                	add    %edx,%eax
801016ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
801016bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
801016c0:	0f b7 00             	movzwl (%eax),%eax
801016c3:	66 85 c0             	test   %ax,%ax
801016c6:	75 4c                	jne    80101714 <ialloc+0xa5>
      memset(dip, 0, sizeof(*dip));
801016c8:	83 ec 04             	sub    $0x4,%esp
801016cb:	6a 40                	push   $0x40
801016cd:	6a 00                	push   $0x0
801016cf:	ff 75 ec             	pushl  -0x14(%ebp)
801016d2:	e8 fc 40 00 00       	call   801057d3 <memset>
801016d7:	83 c4 10             	add    $0x10,%esp
      dip->type = type;
801016da:	8b 45 ec             	mov    -0x14(%ebp),%eax
801016dd:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
801016e1:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
801016e4:	83 ec 0c             	sub    $0xc,%esp
801016e7:	ff 75 f0             	pushl  -0x10(%ebp)
801016ea:	e8 70 20 00 00       	call   8010375f <log_write>
801016ef:	83 c4 10             	add    $0x10,%esp
      brelse(bp);
801016f2:	83 ec 0c             	sub    $0xc,%esp
801016f5:	ff 75 f0             	pushl  -0x10(%ebp)
801016f8:	e8 31 eb ff ff       	call   8010022e <brelse>
801016fd:	83 c4 10             	add    $0x10,%esp
      return iget(dev, inum);
80101700:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101703:	83 ec 08             	sub    $0x8,%esp
80101706:	50                   	push   %eax
80101707:	ff 75 08             	pushl  0x8(%ebp)
8010170a:	e8 f8 00 00 00       	call   80101807 <iget>
8010170f:	83 c4 10             	add    $0x10,%esp
80101712:	eb 30                	jmp    80101744 <ialloc+0xd5>
    }
    brelse(bp);
80101714:	83 ec 0c             	sub    $0xc,%esp
80101717:	ff 75 f0             	pushl  -0x10(%ebp)
8010171a:	e8 0f eb ff ff       	call   8010022e <brelse>
8010171f:	83 c4 10             	add    $0x10,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101722:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101726:	8b 15 48 22 11 80    	mov    0x80112248,%edx
8010172c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010172f:	39 c2                	cmp    %eax,%edx
80101731:	0f 87 51 ff ff ff    	ja     80101688 <ialloc+0x19>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
80101737:	83 ec 0c             	sub    $0xc,%esp
8010173a:	68 06 8e 10 80       	push   $0x80108e06
8010173f:	e8 22 ee ff ff       	call   80100566 <panic>
}
80101744:	c9                   	leave  
80101745:	c3                   	ret    

80101746 <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
80101746:	55                   	push   %ebp
80101747:	89 e5                	mov    %esp,%ebp
80101749:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010174c:	8b 45 08             	mov    0x8(%ebp),%eax
8010174f:	8b 40 04             	mov    0x4(%eax),%eax
80101752:	c1 e8 03             	shr    $0x3,%eax
80101755:	89 c2                	mov    %eax,%edx
80101757:	a1 54 22 11 80       	mov    0x80112254,%eax
8010175c:	01 c2                	add    %eax,%edx
8010175e:	8b 45 08             	mov    0x8(%ebp),%eax
80101761:	8b 00                	mov    (%eax),%eax
80101763:	83 ec 08             	sub    $0x8,%esp
80101766:	52                   	push   %edx
80101767:	50                   	push   %eax
80101768:	e8 49 ea ff ff       	call   801001b6 <bread>
8010176d:	83 c4 10             	add    $0x10,%esp
80101770:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101773:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101776:	8d 50 18             	lea    0x18(%eax),%edx
80101779:	8b 45 08             	mov    0x8(%ebp),%eax
8010177c:	8b 40 04             	mov    0x4(%eax),%eax
8010177f:	83 e0 07             	and    $0x7,%eax
80101782:	c1 e0 06             	shl    $0x6,%eax
80101785:	01 d0                	add    %edx,%eax
80101787:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
8010178a:	8b 45 08             	mov    0x8(%ebp),%eax
8010178d:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101791:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101794:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101797:	8b 45 08             	mov    0x8(%ebp),%eax
8010179a:	0f b7 50 12          	movzwl 0x12(%eax),%edx
8010179e:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017a1:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
801017a5:	8b 45 08             	mov    0x8(%ebp),%eax
801017a8:	0f b7 50 14          	movzwl 0x14(%eax),%edx
801017ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017af:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
801017b3:	8b 45 08             	mov    0x8(%ebp),%eax
801017b6:	0f b7 50 16          	movzwl 0x16(%eax),%edx
801017ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017bd:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
801017c1:	8b 45 08             	mov    0x8(%ebp),%eax
801017c4:	8b 50 18             	mov    0x18(%eax),%edx
801017c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017ca:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801017cd:	8b 45 08             	mov    0x8(%ebp),%eax
801017d0:	8d 50 1c             	lea    0x1c(%eax),%edx
801017d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017d6:	83 c0 0c             	add    $0xc,%eax
801017d9:	83 ec 04             	sub    $0x4,%esp
801017dc:	6a 34                	push   $0x34
801017de:	52                   	push   %edx
801017df:	50                   	push   %eax
801017e0:	e8 ad 40 00 00       	call   80105892 <memmove>
801017e5:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
801017e8:	83 ec 0c             	sub    $0xc,%esp
801017eb:	ff 75 f4             	pushl  -0xc(%ebp)
801017ee:	e8 6c 1f 00 00       	call   8010375f <log_write>
801017f3:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801017f6:	83 ec 0c             	sub    $0xc,%esp
801017f9:	ff 75 f4             	pushl  -0xc(%ebp)
801017fc:	e8 2d ea ff ff       	call   8010022e <brelse>
80101801:	83 c4 10             	add    $0x10,%esp
}
80101804:	90                   	nop
80101805:	c9                   	leave  
80101806:	c3                   	ret    

80101807 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101807:	55                   	push   %ebp
80101808:	89 e5                	mov    %esp,%ebp
8010180a:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
8010180d:	83 ec 0c             	sub    $0xc,%esp
80101810:	68 60 22 11 80       	push   $0x80112260
80101815:	e8 56 3d 00 00       	call   80105570 <acquire>
8010181a:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
8010181d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101824:	c7 45 f4 94 22 11 80 	movl   $0x80112294,-0xc(%ebp)
8010182b:	eb 5d                	jmp    8010188a <iget+0x83>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010182d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101830:	8b 40 08             	mov    0x8(%eax),%eax
80101833:	85 c0                	test   %eax,%eax
80101835:	7e 39                	jle    80101870 <iget+0x69>
80101837:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010183a:	8b 00                	mov    (%eax),%eax
8010183c:	3b 45 08             	cmp    0x8(%ebp),%eax
8010183f:	75 2f                	jne    80101870 <iget+0x69>
80101841:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101844:	8b 40 04             	mov    0x4(%eax),%eax
80101847:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010184a:	75 24                	jne    80101870 <iget+0x69>
      ip->ref++;
8010184c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010184f:	8b 40 08             	mov    0x8(%eax),%eax
80101852:	8d 50 01             	lea    0x1(%eax),%edx
80101855:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101858:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
8010185b:	83 ec 0c             	sub    $0xc,%esp
8010185e:	68 60 22 11 80       	push   $0x80112260
80101863:	e8 6f 3d 00 00       	call   801055d7 <release>
80101868:	83 c4 10             	add    $0x10,%esp
      return ip;
8010186b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010186e:	eb 74                	jmp    801018e4 <iget+0xdd>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101870:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101874:	75 10                	jne    80101886 <iget+0x7f>
80101876:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101879:	8b 40 08             	mov    0x8(%eax),%eax
8010187c:	85 c0                	test   %eax,%eax
8010187e:	75 06                	jne    80101886 <iget+0x7f>
      empty = ip;
80101880:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101883:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101886:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
8010188a:	81 7d f4 34 32 11 80 	cmpl   $0x80113234,-0xc(%ebp)
80101891:	72 9a                	jb     8010182d <iget+0x26>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101893:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101897:	75 0d                	jne    801018a6 <iget+0x9f>
    panic("iget: no inodes");
80101899:	83 ec 0c             	sub    $0xc,%esp
8010189c:	68 18 8e 10 80       	push   $0x80108e18
801018a1:	e8 c0 ec ff ff       	call   80100566 <panic>

  ip = empty;
801018a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
801018ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018af:	8b 55 08             	mov    0x8(%ebp),%edx
801018b2:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
801018b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018b7:	8b 55 0c             	mov    0xc(%ebp),%edx
801018ba:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
801018bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018c0:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
801018c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018ca:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
801018d1:	83 ec 0c             	sub    $0xc,%esp
801018d4:	68 60 22 11 80       	push   $0x80112260
801018d9:	e8 f9 3c 00 00       	call   801055d7 <release>
801018de:	83 c4 10             	add    $0x10,%esp

  return ip;
801018e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801018e4:	c9                   	leave  
801018e5:	c3                   	ret    

801018e6 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
801018e6:	55                   	push   %ebp
801018e7:	89 e5                	mov    %esp,%ebp
801018e9:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
801018ec:	83 ec 0c             	sub    $0xc,%esp
801018ef:	68 60 22 11 80       	push   $0x80112260
801018f4:	e8 77 3c 00 00       	call   80105570 <acquire>
801018f9:	83 c4 10             	add    $0x10,%esp
  ip->ref++;
801018fc:	8b 45 08             	mov    0x8(%ebp),%eax
801018ff:	8b 40 08             	mov    0x8(%eax),%eax
80101902:	8d 50 01             	lea    0x1(%eax),%edx
80101905:	8b 45 08             	mov    0x8(%ebp),%eax
80101908:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
8010190b:	83 ec 0c             	sub    $0xc,%esp
8010190e:	68 60 22 11 80       	push   $0x80112260
80101913:	e8 bf 3c 00 00       	call   801055d7 <release>
80101918:	83 c4 10             	add    $0x10,%esp
  return ip;
8010191b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010191e:	c9                   	leave  
8010191f:	c3                   	ret    

80101920 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101920:	55                   	push   %ebp
80101921:	89 e5                	mov    %esp,%ebp
80101923:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101926:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010192a:	74 0a                	je     80101936 <ilock+0x16>
8010192c:	8b 45 08             	mov    0x8(%ebp),%eax
8010192f:	8b 40 08             	mov    0x8(%eax),%eax
80101932:	85 c0                	test   %eax,%eax
80101934:	7f 0d                	jg     80101943 <ilock+0x23>
    panic("ilock");
80101936:	83 ec 0c             	sub    $0xc,%esp
80101939:	68 28 8e 10 80       	push   $0x80108e28
8010193e:	e8 23 ec ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
80101943:	83 ec 0c             	sub    $0xc,%esp
80101946:	68 60 22 11 80       	push   $0x80112260
8010194b:	e8 20 3c 00 00       	call   80105570 <acquire>
80101950:	83 c4 10             	add    $0x10,%esp
  while(ip->flags & I_BUSY)
80101953:	eb 13                	jmp    80101968 <ilock+0x48>
    sleep(ip, &icache.lock);
80101955:	83 ec 08             	sub    $0x8,%esp
80101958:	68 60 22 11 80       	push   $0x80112260
8010195d:	ff 75 08             	pushl  0x8(%ebp)
80101960:	e8 fb 38 00 00       	call   80105260 <sleep>
80101965:	83 c4 10             	add    $0x10,%esp

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
80101968:	8b 45 08             	mov    0x8(%ebp),%eax
8010196b:	8b 40 0c             	mov    0xc(%eax),%eax
8010196e:	83 e0 01             	and    $0x1,%eax
80101971:	85 c0                	test   %eax,%eax
80101973:	75 e0                	jne    80101955 <ilock+0x35>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
80101975:	8b 45 08             	mov    0x8(%ebp),%eax
80101978:	8b 40 0c             	mov    0xc(%eax),%eax
8010197b:	83 c8 01             	or     $0x1,%eax
8010197e:	89 c2                	mov    %eax,%edx
80101980:	8b 45 08             	mov    0x8(%ebp),%eax
80101983:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
80101986:	83 ec 0c             	sub    $0xc,%esp
80101989:	68 60 22 11 80       	push   $0x80112260
8010198e:	e8 44 3c 00 00       	call   801055d7 <release>
80101993:	83 c4 10             	add    $0x10,%esp

  if(!(ip->flags & I_VALID)){
80101996:	8b 45 08             	mov    0x8(%ebp),%eax
80101999:	8b 40 0c             	mov    0xc(%eax),%eax
8010199c:	83 e0 02             	and    $0x2,%eax
8010199f:	85 c0                	test   %eax,%eax
801019a1:	0f 85 d4 00 00 00    	jne    80101a7b <ilock+0x15b>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801019a7:	8b 45 08             	mov    0x8(%ebp),%eax
801019aa:	8b 40 04             	mov    0x4(%eax),%eax
801019ad:	c1 e8 03             	shr    $0x3,%eax
801019b0:	89 c2                	mov    %eax,%edx
801019b2:	a1 54 22 11 80       	mov    0x80112254,%eax
801019b7:	01 c2                	add    %eax,%edx
801019b9:	8b 45 08             	mov    0x8(%ebp),%eax
801019bc:	8b 00                	mov    (%eax),%eax
801019be:	83 ec 08             	sub    $0x8,%esp
801019c1:	52                   	push   %edx
801019c2:	50                   	push   %eax
801019c3:	e8 ee e7 ff ff       	call   801001b6 <bread>
801019c8:	83 c4 10             	add    $0x10,%esp
801019cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801019ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019d1:	8d 50 18             	lea    0x18(%eax),%edx
801019d4:	8b 45 08             	mov    0x8(%ebp),%eax
801019d7:	8b 40 04             	mov    0x4(%eax),%eax
801019da:	83 e0 07             	and    $0x7,%eax
801019dd:	c1 e0 06             	shl    $0x6,%eax
801019e0:	01 d0                	add    %edx,%eax
801019e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
801019e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019e8:	0f b7 10             	movzwl (%eax),%edx
801019eb:	8b 45 08             	mov    0x8(%ebp),%eax
801019ee:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
801019f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019f5:	0f b7 50 02          	movzwl 0x2(%eax),%edx
801019f9:	8b 45 08             	mov    0x8(%ebp),%eax
801019fc:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
80101a00:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a03:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101a07:	8b 45 08             	mov    0x8(%ebp),%eax
80101a0a:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
80101a0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a11:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101a15:	8b 45 08             	mov    0x8(%ebp),%eax
80101a18:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
80101a1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a1f:	8b 50 08             	mov    0x8(%eax),%edx
80101a22:	8b 45 08             	mov    0x8(%ebp),%eax
80101a25:	89 50 18             	mov    %edx,0x18(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101a28:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a2b:	8d 50 0c             	lea    0xc(%eax),%edx
80101a2e:	8b 45 08             	mov    0x8(%ebp),%eax
80101a31:	83 c0 1c             	add    $0x1c,%eax
80101a34:	83 ec 04             	sub    $0x4,%esp
80101a37:	6a 34                	push   $0x34
80101a39:	52                   	push   %edx
80101a3a:	50                   	push   %eax
80101a3b:	e8 52 3e 00 00       	call   80105892 <memmove>
80101a40:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101a43:	83 ec 0c             	sub    $0xc,%esp
80101a46:	ff 75 f4             	pushl  -0xc(%ebp)
80101a49:	e8 e0 e7 ff ff       	call   8010022e <brelse>
80101a4e:	83 c4 10             	add    $0x10,%esp
    ip->flags |= I_VALID;
80101a51:	8b 45 08             	mov    0x8(%ebp),%eax
80101a54:	8b 40 0c             	mov    0xc(%eax),%eax
80101a57:	83 c8 02             	or     $0x2,%eax
80101a5a:	89 c2                	mov    %eax,%edx
80101a5c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a5f:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
80101a62:	8b 45 08             	mov    0x8(%ebp),%eax
80101a65:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101a69:	66 85 c0             	test   %ax,%ax
80101a6c:	75 0d                	jne    80101a7b <ilock+0x15b>
      panic("ilock: no type");
80101a6e:	83 ec 0c             	sub    $0xc,%esp
80101a71:	68 2e 8e 10 80       	push   $0x80108e2e
80101a76:	e8 eb ea ff ff       	call   80100566 <panic>
  }
}
80101a7b:	90                   	nop
80101a7c:	c9                   	leave  
80101a7d:	c3                   	ret    

80101a7e <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101a7e:	55                   	push   %ebp
80101a7f:	89 e5                	mov    %esp,%ebp
80101a81:	83 ec 08             	sub    $0x8,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
80101a84:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101a88:	74 17                	je     80101aa1 <iunlock+0x23>
80101a8a:	8b 45 08             	mov    0x8(%ebp),%eax
80101a8d:	8b 40 0c             	mov    0xc(%eax),%eax
80101a90:	83 e0 01             	and    $0x1,%eax
80101a93:	85 c0                	test   %eax,%eax
80101a95:	74 0a                	je     80101aa1 <iunlock+0x23>
80101a97:	8b 45 08             	mov    0x8(%ebp),%eax
80101a9a:	8b 40 08             	mov    0x8(%eax),%eax
80101a9d:	85 c0                	test   %eax,%eax
80101a9f:	7f 0d                	jg     80101aae <iunlock+0x30>
    panic("iunlock");
80101aa1:	83 ec 0c             	sub    $0xc,%esp
80101aa4:	68 3d 8e 10 80       	push   $0x80108e3d
80101aa9:	e8 b8 ea ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
80101aae:	83 ec 0c             	sub    $0xc,%esp
80101ab1:	68 60 22 11 80       	push   $0x80112260
80101ab6:	e8 b5 3a 00 00       	call   80105570 <acquire>
80101abb:	83 c4 10             	add    $0x10,%esp
  ip->flags &= ~I_BUSY;
80101abe:	8b 45 08             	mov    0x8(%ebp),%eax
80101ac1:	8b 40 0c             	mov    0xc(%eax),%eax
80101ac4:	83 e0 fe             	and    $0xfffffffe,%eax
80101ac7:	89 c2                	mov    %eax,%edx
80101ac9:	8b 45 08             	mov    0x8(%ebp),%eax
80101acc:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101acf:	83 ec 0c             	sub    $0xc,%esp
80101ad2:	ff 75 08             	pushl  0x8(%ebp)
80101ad5:	e8 74 38 00 00       	call   8010534e <wakeup>
80101ada:	83 c4 10             	add    $0x10,%esp
  release(&icache.lock);
80101add:	83 ec 0c             	sub    $0xc,%esp
80101ae0:	68 60 22 11 80       	push   $0x80112260
80101ae5:	e8 ed 3a 00 00       	call   801055d7 <release>
80101aea:	83 c4 10             	add    $0x10,%esp
}
80101aed:	90                   	nop
80101aee:	c9                   	leave  
80101aef:	c3                   	ret    

80101af0 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101af0:	55                   	push   %ebp
80101af1:	89 e5                	mov    %esp,%ebp
80101af3:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101af6:	83 ec 0c             	sub    $0xc,%esp
80101af9:	68 60 22 11 80       	push   $0x80112260
80101afe:	e8 6d 3a 00 00       	call   80105570 <acquire>
80101b03:	83 c4 10             	add    $0x10,%esp
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101b06:	8b 45 08             	mov    0x8(%ebp),%eax
80101b09:	8b 40 08             	mov    0x8(%eax),%eax
80101b0c:	83 f8 01             	cmp    $0x1,%eax
80101b0f:	0f 85 a9 00 00 00    	jne    80101bbe <iput+0xce>
80101b15:	8b 45 08             	mov    0x8(%ebp),%eax
80101b18:	8b 40 0c             	mov    0xc(%eax),%eax
80101b1b:	83 e0 02             	and    $0x2,%eax
80101b1e:	85 c0                	test   %eax,%eax
80101b20:	0f 84 98 00 00 00    	je     80101bbe <iput+0xce>
80101b26:	8b 45 08             	mov    0x8(%ebp),%eax
80101b29:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80101b2d:	66 85 c0             	test   %ax,%ax
80101b30:	0f 85 88 00 00 00    	jne    80101bbe <iput+0xce>
    // inode has no links and no other references: truncate and free.
    if(ip->flags & I_BUSY)
80101b36:	8b 45 08             	mov    0x8(%ebp),%eax
80101b39:	8b 40 0c             	mov    0xc(%eax),%eax
80101b3c:	83 e0 01             	and    $0x1,%eax
80101b3f:	85 c0                	test   %eax,%eax
80101b41:	74 0d                	je     80101b50 <iput+0x60>
      panic("iput busy");
80101b43:	83 ec 0c             	sub    $0xc,%esp
80101b46:	68 45 8e 10 80       	push   $0x80108e45
80101b4b:	e8 16 ea ff ff       	call   80100566 <panic>
    ip->flags |= I_BUSY;
80101b50:	8b 45 08             	mov    0x8(%ebp),%eax
80101b53:	8b 40 0c             	mov    0xc(%eax),%eax
80101b56:	83 c8 01             	or     $0x1,%eax
80101b59:	89 c2                	mov    %eax,%edx
80101b5b:	8b 45 08             	mov    0x8(%ebp),%eax
80101b5e:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101b61:	83 ec 0c             	sub    $0xc,%esp
80101b64:	68 60 22 11 80       	push   $0x80112260
80101b69:	e8 69 3a 00 00       	call   801055d7 <release>
80101b6e:	83 c4 10             	add    $0x10,%esp
    itrunc(ip);
80101b71:	83 ec 0c             	sub    $0xc,%esp
80101b74:	ff 75 08             	pushl  0x8(%ebp)
80101b77:	e8 a8 01 00 00       	call   80101d24 <itrunc>
80101b7c:	83 c4 10             	add    $0x10,%esp
    ip->type = 0;
80101b7f:	8b 45 08             	mov    0x8(%ebp),%eax
80101b82:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101b88:	83 ec 0c             	sub    $0xc,%esp
80101b8b:	ff 75 08             	pushl  0x8(%ebp)
80101b8e:	e8 b3 fb ff ff       	call   80101746 <iupdate>
80101b93:	83 c4 10             	add    $0x10,%esp
    acquire(&icache.lock);
80101b96:	83 ec 0c             	sub    $0xc,%esp
80101b99:	68 60 22 11 80       	push   $0x80112260
80101b9e:	e8 cd 39 00 00       	call   80105570 <acquire>
80101ba3:	83 c4 10             	add    $0x10,%esp
    ip->flags = 0;
80101ba6:	8b 45 08             	mov    0x8(%ebp),%eax
80101ba9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101bb0:	83 ec 0c             	sub    $0xc,%esp
80101bb3:	ff 75 08             	pushl  0x8(%ebp)
80101bb6:	e8 93 37 00 00       	call   8010534e <wakeup>
80101bbb:	83 c4 10             	add    $0x10,%esp
  }
  ip->ref--;
80101bbe:	8b 45 08             	mov    0x8(%ebp),%eax
80101bc1:	8b 40 08             	mov    0x8(%eax),%eax
80101bc4:	8d 50 ff             	lea    -0x1(%eax),%edx
80101bc7:	8b 45 08             	mov    0x8(%ebp),%eax
80101bca:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101bcd:	83 ec 0c             	sub    $0xc,%esp
80101bd0:	68 60 22 11 80       	push   $0x80112260
80101bd5:	e8 fd 39 00 00       	call   801055d7 <release>
80101bda:	83 c4 10             	add    $0x10,%esp
}
80101bdd:	90                   	nop
80101bde:	c9                   	leave  
80101bdf:	c3                   	ret    

80101be0 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101be0:	55                   	push   %ebp
80101be1:	89 e5                	mov    %esp,%ebp
80101be3:	83 ec 08             	sub    $0x8,%esp
  iunlock(ip);
80101be6:	83 ec 0c             	sub    $0xc,%esp
80101be9:	ff 75 08             	pushl  0x8(%ebp)
80101bec:	e8 8d fe ff ff       	call   80101a7e <iunlock>
80101bf1:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80101bf4:	83 ec 0c             	sub    $0xc,%esp
80101bf7:	ff 75 08             	pushl  0x8(%ebp)
80101bfa:	e8 f1 fe ff ff       	call   80101af0 <iput>
80101bff:	83 c4 10             	add    $0x10,%esp
}
80101c02:	90                   	nop
80101c03:	c9                   	leave  
80101c04:	c3                   	ret    

80101c05 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101c05:	55                   	push   %ebp
80101c06:	89 e5                	mov    %esp,%ebp
80101c08:	53                   	push   %ebx
80101c09:	83 ec 14             	sub    $0x14,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101c0c:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101c10:	77 42                	ja     80101c54 <bmap+0x4f>
    if((addr = ip->addrs[bn]) == 0)
80101c12:	8b 45 08             	mov    0x8(%ebp),%eax
80101c15:	8b 55 0c             	mov    0xc(%ebp),%edx
80101c18:	83 c2 04             	add    $0x4,%edx
80101c1b:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101c1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c22:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c26:	75 24                	jne    80101c4c <bmap+0x47>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101c28:	8b 45 08             	mov    0x8(%ebp),%eax
80101c2b:	8b 00                	mov    (%eax),%eax
80101c2d:	83 ec 0c             	sub    $0xc,%esp
80101c30:	50                   	push   %eax
80101c31:	e8 e4 f7 ff ff       	call   8010141a <balloc>
80101c36:	83 c4 10             	add    $0x10,%esp
80101c39:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c3c:	8b 45 08             	mov    0x8(%ebp),%eax
80101c3f:	8b 55 0c             	mov    0xc(%ebp),%edx
80101c42:	8d 4a 04             	lea    0x4(%edx),%ecx
80101c45:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c48:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101c4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c4f:	e9 cb 00 00 00       	jmp    80101d1f <bmap+0x11a>
  }
  bn -= NDIRECT;
80101c54:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101c58:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101c5c:	0f 87 b0 00 00 00    	ja     80101d12 <bmap+0x10d>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101c62:	8b 45 08             	mov    0x8(%ebp),%eax
80101c65:	8b 40 4c             	mov    0x4c(%eax),%eax
80101c68:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c6b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c6f:	75 1d                	jne    80101c8e <bmap+0x89>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101c71:	8b 45 08             	mov    0x8(%ebp),%eax
80101c74:	8b 00                	mov    (%eax),%eax
80101c76:	83 ec 0c             	sub    $0xc,%esp
80101c79:	50                   	push   %eax
80101c7a:	e8 9b f7 ff ff       	call   8010141a <balloc>
80101c7f:	83 c4 10             	add    $0x10,%esp
80101c82:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c85:	8b 45 08             	mov    0x8(%ebp),%eax
80101c88:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c8b:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101c8e:	8b 45 08             	mov    0x8(%ebp),%eax
80101c91:	8b 00                	mov    (%eax),%eax
80101c93:	83 ec 08             	sub    $0x8,%esp
80101c96:	ff 75 f4             	pushl  -0xc(%ebp)
80101c99:	50                   	push   %eax
80101c9a:	e8 17 e5 ff ff       	call   801001b6 <bread>
80101c9f:	83 c4 10             	add    $0x10,%esp
80101ca2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101ca5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ca8:	83 c0 18             	add    $0x18,%eax
80101cab:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101cae:	8b 45 0c             	mov    0xc(%ebp),%eax
80101cb1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101cb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101cbb:	01 d0                	add    %edx,%eax
80101cbd:	8b 00                	mov    (%eax),%eax
80101cbf:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101cc2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101cc6:	75 37                	jne    80101cff <bmap+0xfa>
      a[bn] = addr = balloc(ip->dev);
80101cc8:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ccb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101cd2:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101cd5:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101cd8:	8b 45 08             	mov    0x8(%ebp),%eax
80101cdb:	8b 00                	mov    (%eax),%eax
80101cdd:	83 ec 0c             	sub    $0xc,%esp
80101ce0:	50                   	push   %eax
80101ce1:	e8 34 f7 ff ff       	call   8010141a <balloc>
80101ce6:	83 c4 10             	add    $0x10,%esp
80101ce9:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101cec:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101cef:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101cf1:	83 ec 0c             	sub    $0xc,%esp
80101cf4:	ff 75 f0             	pushl  -0x10(%ebp)
80101cf7:	e8 63 1a 00 00       	call   8010375f <log_write>
80101cfc:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101cff:	83 ec 0c             	sub    $0xc,%esp
80101d02:	ff 75 f0             	pushl  -0x10(%ebp)
80101d05:	e8 24 e5 ff ff       	call   8010022e <brelse>
80101d0a:	83 c4 10             	add    $0x10,%esp
    return addr;
80101d0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d10:	eb 0d                	jmp    80101d1f <bmap+0x11a>
  }

  panic("bmap: out of range");
80101d12:	83 ec 0c             	sub    $0xc,%esp
80101d15:	68 4f 8e 10 80       	push   $0x80108e4f
80101d1a:	e8 47 e8 ff ff       	call   80100566 <panic>
}
80101d1f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101d22:	c9                   	leave  
80101d23:	c3                   	ret    

80101d24 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101d24:	55                   	push   %ebp
80101d25:	89 e5                	mov    %esp,%ebp
80101d27:	83 ec 18             	sub    $0x18,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101d2a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101d31:	eb 45                	jmp    80101d78 <itrunc+0x54>
    if(ip->addrs[i]){
80101d33:	8b 45 08             	mov    0x8(%ebp),%eax
80101d36:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d39:	83 c2 04             	add    $0x4,%edx
80101d3c:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101d40:	85 c0                	test   %eax,%eax
80101d42:	74 30                	je     80101d74 <itrunc+0x50>
      bfree(ip->dev, ip->addrs[i]);
80101d44:	8b 45 08             	mov    0x8(%ebp),%eax
80101d47:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d4a:	83 c2 04             	add    $0x4,%edx
80101d4d:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101d51:	8b 55 08             	mov    0x8(%ebp),%edx
80101d54:	8b 12                	mov    (%edx),%edx
80101d56:	83 ec 08             	sub    $0x8,%esp
80101d59:	50                   	push   %eax
80101d5a:	52                   	push   %edx
80101d5b:	e8 06 f8 ff ff       	call   80101566 <bfree>
80101d60:	83 c4 10             	add    $0x10,%esp
      ip->addrs[i] = 0;
80101d63:	8b 45 08             	mov    0x8(%ebp),%eax
80101d66:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d69:	83 c2 04             	add    $0x4,%edx
80101d6c:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101d73:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101d74:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101d78:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101d7c:	7e b5                	jle    80101d33 <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101d7e:	8b 45 08             	mov    0x8(%ebp),%eax
80101d81:	8b 40 4c             	mov    0x4c(%eax),%eax
80101d84:	85 c0                	test   %eax,%eax
80101d86:	0f 84 a1 00 00 00    	je     80101e2d <itrunc+0x109>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101d8c:	8b 45 08             	mov    0x8(%ebp),%eax
80101d8f:	8b 50 4c             	mov    0x4c(%eax),%edx
80101d92:	8b 45 08             	mov    0x8(%ebp),%eax
80101d95:	8b 00                	mov    (%eax),%eax
80101d97:	83 ec 08             	sub    $0x8,%esp
80101d9a:	52                   	push   %edx
80101d9b:	50                   	push   %eax
80101d9c:	e8 15 e4 ff ff       	call   801001b6 <bread>
80101da1:	83 c4 10             	add    $0x10,%esp
80101da4:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101da7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101daa:	83 c0 18             	add    $0x18,%eax
80101dad:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101db0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101db7:	eb 3c                	jmp    80101df5 <itrunc+0xd1>
      if(a[j])
80101db9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101dbc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101dc3:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101dc6:	01 d0                	add    %edx,%eax
80101dc8:	8b 00                	mov    (%eax),%eax
80101dca:	85 c0                	test   %eax,%eax
80101dcc:	74 23                	je     80101df1 <itrunc+0xcd>
        bfree(ip->dev, a[j]);
80101dce:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101dd1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101dd8:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101ddb:	01 d0                	add    %edx,%eax
80101ddd:	8b 00                	mov    (%eax),%eax
80101ddf:	8b 55 08             	mov    0x8(%ebp),%edx
80101de2:	8b 12                	mov    (%edx),%edx
80101de4:	83 ec 08             	sub    $0x8,%esp
80101de7:	50                   	push   %eax
80101de8:	52                   	push   %edx
80101de9:	e8 78 f7 ff ff       	call   80101566 <bfree>
80101dee:	83 c4 10             	add    $0x10,%esp
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101df1:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101df5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101df8:	83 f8 7f             	cmp    $0x7f,%eax
80101dfb:	76 bc                	jbe    80101db9 <itrunc+0x95>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101dfd:	83 ec 0c             	sub    $0xc,%esp
80101e00:	ff 75 ec             	pushl  -0x14(%ebp)
80101e03:	e8 26 e4 ff ff       	call   8010022e <brelse>
80101e08:	83 c4 10             	add    $0x10,%esp
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101e0b:	8b 45 08             	mov    0x8(%ebp),%eax
80101e0e:	8b 40 4c             	mov    0x4c(%eax),%eax
80101e11:	8b 55 08             	mov    0x8(%ebp),%edx
80101e14:	8b 12                	mov    (%edx),%edx
80101e16:	83 ec 08             	sub    $0x8,%esp
80101e19:	50                   	push   %eax
80101e1a:	52                   	push   %edx
80101e1b:	e8 46 f7 ff ff       	call   80101566 <bfree>
80101e20:	83 c4 10             	add    $0x10,%esp
    ip->addrs[NDIRECT] = 0;
80101e23:	8b 45 08             	mov    0x8(%ebp),%eax
80101e26:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80101e2d:	8b 45 08             	mov    0x8(%ebp),%eax
80101e30:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
80101e37:	83 ec 0c             	sub    $0xc,%esp
80101e3a:	ff 75 08             	pushl  0x8(%ebp)
80101e3d:	e8 04 f9 ff ff       	call   80101746 <iupdate>
80101e42:	83 c4 10             	add    $0x10,%esp
}
80101e45:	90                   	nop
80101e46:	c9                   	leave  
80101e47:	c3                   	ret    

80101e48 <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101e48:	55                   	push   %ebp
80101e49:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101e4b:	8b 45 08             	mov    0x8(%ebp),%eax
80101e4e:	8b 00                	mov    (%eax),%eax
80101e50:	89 c2                	mov    %eax,%edx
80101e52:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e55:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101e58:	8b 45 08             	mov    0x8(%ebp),%eax
80101e5b:	8b 50 04             	mov    0x4(%eax),%edx
80101e5e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e61:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101e64:	8b 45 08             	mov    0x8(%ebp),%eax
80101e67:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101e6b:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e6e:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101e71:	8b 45 08             	mov    0x8(%ebp),%eax
80101e74:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101e78:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e7b:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101e7f:	8b 45 08             	mov    0x8(%ebp),%eax
80101e82:	8b 50 18             	mov    0x18(%eax),%edx
80101e85:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e88:	89 50 10             	mov    %edx,0x10(%eax)
}
80101e8b:	90                   	nop
80101e8c:	5d                   	pop    %ebp
80101e8d:	c3                   	ret    

80101e8e <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101e8e:	55                   	push   %ebp
80101e8f:	89 e5                	mov    %esp,%ebp
80101e91:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101e94:	8b 45 08             	mov    0x8(%ebp),%eax
80101e97:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101e9b:	66 83 f8 03          	cmp    $0x3,%ax
80101e9f:	75 5c                	jne    80101efd <readi+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101ea1:	8b 45 08             	mov    0x8(%ebp),%eax
80101ea4:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101ea8:	66 85 c0             	test   %ax,%ax
80101eab:	78 20                	js     80101ecd <readi+0x3f>
80101ead:	8b 45 08             	mov    0x8(%ebp),%eax
80101eb0:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101eb4:	66 83 f8 09          	cmp    $0x9,%ax
80101eb8:	7f 13                	jg     80101ecd <readi+0x3f>
80101eba:	8b 45 08             	mov    0x8(%ebp),%eax
80101ebd:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101ec1:	98                   	cwtl   
80101ec2:	8b 04 c5 e0 21 11 80 	mov    -0x7feede20(,%eax,8),%eax
80101ec9:	85 c0                	test   %eax,%eax
80101ecb:	75 0a                	jne    80101ed7 <readi+0x49>
      return -1;
80101ecd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ed2:	e9 0c 01 00 00       	jmp    80101fe3 <readi+0x155>
    return devsw[ip->major].read(ip, dst, n);
80101ed7:	8b 45 08             	mov    0x8(%ebp),%eax
80101eda:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101ede:	98                   	cwtl   
80101edf:	8b 04 c5 e0 21 11 80 	mov    -0x7feede20(,%eax,8),%eax
80101ee6:	8b 55 14             	mov    0x14(%ebp),%edx
80101ee9:	83 ec 04             	sub    $0x4,%esp
80101eec:	52                   	push   %edx
80101eed:	ff 75 0c             	pushl  0xc(%ebp)
80101ef0:	ff 75 08             	pushl  0x8(%ebp)
80101ef3:	ff d0                	call   *%eax
80101ef5:	83 c4 10             	add    $0x10,%esp
80101ef8:	e9 e6 00 00 00       	jmp    80101fe3 <readi+0x155>
  }

  if(off > ip->size || off + n < off)
80101efd:	8b 45 08             	mov    0x8(%ebp),%eax
80101f00:	8b 40 18             	mov    0x18(%eax),%eax
80101f03:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f06:	72 0d                	jb     80101f15 <readi+0x87>
80101f08:	8b 55 10             	mov    0x10(%ebp),%edx
80101f0b:	8b 45 14             	mov    0x14(%ebp),%eax
80101f0e:	01 d0                	add    %edx,%eax
80101f10:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f13:	73 0a                	jae    80101f1f <readi+0x91>
    return -1;
80101f15:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f1a:	e9 c4 00 00 00       	jmp    80101fe3 <readi+0x155>
  if(off + n > ip->size)
80101f1f:	8b 55 10             	mov    0x10(%ebp),%edx
80101f22:	8b 45 14             	mov    0x14(%ebp),%eax
80101f25:	01 c2                	add    %eax,%edx
80101f27:	8b 45 08             	mov    0x8(%ebp),%eax
80101f2a:	8b 40 18             	mov    0x18(%eax),%eax
80101f2d:	39 c2                	cmp    %eax,%edx
80101f2f:	76 0c                	jbe    80101f3d <readi+0xaf>
    n = ip->size - off;
80101f31:	8b 45 08             	mov    0x8(%ebp),%eax
80101f34:	8b 40 18             	mov    0x18(%eax),%eax
80101f37:	2b 45 10             	sub    0x10(%ebp),%eax
80101f3a:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101f3d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101f44:	e9 8b 00 00 00       	jmp    80101fd4 <readi+0x146>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101f49:	8b 45 10             	mov    0x10(%ebp),%eax
80101f4c:	c1 e8 09             	shr    $0x9,%eax
80101f4f:	83 ec 08             	sub    $0x8,%esp
80101f52:	50                   	push   %eax
80101f53:	ff 75 08             	pushl  0x8(%ebp)
80101f56:	e8 aa fc ff ff       	call   80101c05 <bmap>
80101f5b:	83 c4 10             	add    $0x10,%esp
80101f5e:	89 c2                	mov    %eax,%edx
80101f60:	8b 45 08             	mov    0x8(%ebp),%eax
80101f63:	8b 00                	mov    (%eax),%eax
80101f65:	83 ec 08             	sub    $0x8,%esp
80101f68:	52                   	push   %edx
80101f69:	50                   	push   %eax
80101f6a:	e8 47 e2 ff ff       	call   801001b6 <bread>
80101f6f:	83 c4 10             	add    $0x10,%esp
80101f72:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101f75:	8b 45 10             	mov    0x10(%ebp),%eax
80101f78:	25 ff 01 00 00       	and    $0x1ff,%eax
80101f7d:	ba 00 02 00 00       	mov    $0x200,%edx
80101f82:	29 c2                	sub    %eax,%edx
80101f84:	8b 45 14             	mov    0x14(%ebp),%eax
80101f87:	2b 45 f4             	sub    -0xc(%ebp),%eax
80101f8a:	39 c2                	cmp    %eax,%edx
80101f8c:	0f 46 c2             	cmovbe %edx,%eax
80101f8f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80101f92:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101f95:	8d 50 18             	lea    0x18(%eax),%edx
80101f98:	8b 45 10             	mov    0x10(%ebp),%eax
80101f9b:	25 ff 01 00 00       	and    $0x1ff,%eax
80101fa0:	01 d0                	add    %edx,%eax
80101fa2:	83 ec 04             	sub    $0x4,%esp
80101fa5:	ff 75 ec             	pushl  -0x14(%ebp)
80101fa8:	50                   	push   %eax
80101fa9:	ff 75 0c             	pushl  0xc(%ebp)
80101fac:	e8 e1 38 00 00       	call   80105892 <memmove>
80101fb1:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101fb4:	83 ec 0c             	sub    $0xc,%esp
80101fb7:	ff 75 f0             	pushl  -0x10(%ebp)
80101fba:	e8 6f e2 ff ff       	call   8010022e <brelse>
80101fbf:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101fc2:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101fc5:	01 45 f4             	add    %eax,-0xc(%ebp)
80101fc8:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101fcb:	01 45 10             	add    %eax,0x10(%ebp)
80101fce:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101fd1:	01 45 0c             	add    %eax,0xc(%ebp)
80101fd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101fd7:	3b 45 14             	cmp    0x14(%ebp),%eax
80101fda:	0f 82 69 ff ff ff    	jb     80101f49 <readi+0xbb>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101fe0:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101fe3:	c9                   	leave  
80101fe4:	c3                   	ret    

80101fe5 <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101fe5:	55                   	push   %ebp
80101fe6:	89 e5                	mov    %esp,%ebp
80101fe8:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101feb:	8b 45 08             	mov    0x8(%ebp),%eax
80101fee:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101ff2:	66 83 f8 03          	cmp    $0x3,%ax
80101ff6:	75 5c                	jne    80102054 <writei+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101ff8:	8b 45 08             	mov    0x8(%ebp),%eax
80101ffb:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101fff:	66 85 c0             	test   %ax,%ax
80102002:	78 20                	js     80102024 <writei+0x3f>
80102004:	8b 45 08             	mov    0x8(%ebp),%eax
80102007:	0f b7 40 12          	movzwl 0x12(%eax),%eax
8010200b:	66 83 f8 09          	cmp    $0x9,%ax
8010200f:	7f 13                	jg     80102024 <writei+0x3f>
80102011:	8b 45 08             	mov    0x8(%ebp),%eax
80102014:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102018:	98                   	cwtl   
80102019:	8b 04 c5 e4 21 11 80 	mov    -0x7feede1c(,%eax,8),%eax
80102020:	85 c0                	test   %eax,%eax
80102022:	75 0a                	jne    8010202e <writei+0x49>
      return -1;
80102024:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102029:	e9 3d 01 00 00       	jmp    8010216b <writei+0x186>
    return devsw[ip->major].write(ip, src, n);
8010202e:	8b 45 08             	mov    0x8(%ebp),%eax
80102031:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102035:	98                   	cwtl   
80102036:	8b 04 c5 e4 21 11 80 	mov    -0x7feede1c(,%eax,8),%eax
8010203d:	8b 55 14             	mov    0x14(%ebp),%edx
80102040:	83 ec 04             	sub    $0x4,%esp
80102043:	52                   	push   %edx
80102044:	ff 75 0c             	pushl  0xc(%ebp)
80102047:	ff 75 08             	pushl  0x8(%ebp)
8010204a:	ff d0                	call   *%eax
8010204c:	83 c4 10             	add    $0x10,%esp
8010204f:	e9 17 01 00 00       	jmp    8010216b <writei+0x186>
  }

  if(off > ip->size || off + n < off)
80102054:	8b 45 08             	mov    0x8(%ebp),%eax
80102057:	8b 40 18             	mov    0x18(%eax),%eax
8010205a:	3b 45 10             	cmp    0x10(%ebp),%eax
8010205d:	72 0d                	jb     8010206c <writei+0x87>
8010205f:	8b 55 10             	mov    0x10(%ebp),%edx
80102062:	8b 45 14             	mov    0x14(%ebp),%eax
80102065:	01 d0                	add    %edx,%eax
80102067:	3b 45 10             	cmp    0x10(%ebp),%eax
8010206a:	73 0a                	jae    80102076 <writei+0x91>
    return -1;
8010206c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102071:	e9 f5 00 00 00       	jmp    8010216b <writei+0x186>
  if(off + n > MAXFILE*BSIZE)
80102076:	8b 55 10             	mov    0x10(%ebp),%edx
80102079:	8b 45 14             	mov    0x14(%ebp),%eax
8010207c:	01 d0                	add    %edx,%eax
8010207e:	3d 00 18 01 00       	cmp    $0x11800,%eax
80102083:	76 0a                	jbe    8010208f <writei+0xaa>
    return -1;
80102085:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010208a:	e9 dc 00 00 00       	jmp    8010216b <writei+0x186>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010208f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102096:	e9 99 00 00 00       	jmp    80102134 <writei+0x14f>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
8010209b:	8b 45 10             	mov    0x10(%ebp),%eax
8010209e:	c1 e8 09             	shr    $0x9,%eax
801020a1:	83 ec 08             	sub    $0x8,%esp
801020a4:	50                   	push   %eax
801020a5:	ff 75 08             	pushl  0x8(%ebp)
801020a8:	e8 58 fb ff ff       	call   80101c05 <bmap>
801020ad:	83 c4 10             	add    $0x10,%esp
801020b0:	89 c2                	mov    %eax,%edx
801020b2:	8b 45 08             	mov    0x8(%ebp),%eax
801020b5:	8b 00                	mov    (%eax),%eax
801020b7:	83 ec 08             	sub    $0x8,%esp
801020ba:	52                   	push   %edx
801020bb:	50                   	push   %eax
801020bc:	e8 f5 e0 ff ff       	call   801001b6 <bread>
801020c1:	83 c4 10             	add    $0x10,%esp
801020c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
801020c7:	8b 45 10             	mov    0x10(%ebp),%eax
801020ca:	25 ff 01 00 00       	and    $0x1ff,%eax
801020cf:	ba 00 02 00 00       	mov    $0x200,%edx
801020d4:	29 c2                	sub    %eax,%edx
801020d6:	8b 45 14             	mov    0x14(%ebp),%eax
801020d9:	2b 45 f4             	sub    -0xc(%ebp),%eax
801020dc:	39 c2                	cmp    %eax,%edx
801020de:	0f 46 c2             	cmovbe %edx,%eax
801020e1:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
801020e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801020e7:	8d 50 18             	lea    0x18(%eax),%edx
801020ea:	8b 45 10             	mov    0x10(%ebp),%eax
801020ed:	25 ff 01 00 00       	and    $0x1ff,%eax
801020f2:	01 d0                	add    %edx,%eax
801020f4:	83 ec 04             	sub    $0x4,%esp
801020f7:	ff 75 ec             	pushl  -0x14(%ebp)
801020fa:	ff 75 0c             	pushl  0xc(%ebp)
801020fd:	50                   	push   %eax
801020fe:	e8 8f 37 00 00       	call   80105892 <memmove>
80102103:	83 c4 10             	add    $0x10,%esp
    log_write(bp);
80102106:	83 ec 0c             	sub    $0xc,%esp
80102109:	ff 75 f0             	pushl  -0x10(%ebp)
8010210c:	e8 4e 16 00 00       	call   8010375f <log_write>
80102111:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80102114:	83 ec 0c             	sub    $0xc,%esp
80102117:	ff 75 f0             	pushl  -0x10(%ebp)
8010211a:	e8 0f e1 ff ff       	call   8010022e <brelse>
8010211f:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102122:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102125:	01 45 f4             	add    %eax,-0xc(%ebp)
80102128:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010212b:	01 45 10             	add    %eax,0x10(%ebp)
8010212e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102131:	01 45 0c             	add    %eax,0xc(%ebp)
80102134:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102137:	3b 45 14             	cmp    0x14(%ebp),%eax
8010213a:	0f 82 5b ff ff ff    	jb     8010209b <writei+0xb6>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80102140:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80102144:	74 22                	je     80102168 <writei+0x183>
80102146:	8b 45 08             	mov    0x8(%ebp),%eax
80102149:	8b 40 18             	mov    0x18(%eax),%eax
8010214c:	3b 45 10             	cmp    0x10(%ebp),%eax
8010214f:	73 17                	jae    80102168 <writei+0x183>
    ip->size = off;
80102151:	8b 45 08             	mov    0x8(%ebp),%eax
80102154:	8b 55 10             	mov    0x10(%ebp),%edx
80102157:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
8010215a:	83 ec 0c             	sub    $0xc,%esp
8010215d:	ff 75 08             	pushl  0x8(%ebp)
80102160:	e8 e1 f5 ff ff       	call   80101746 <iupdate>
80102165:	83 c4 10             	add    $0x10,%esp
  }
  return n;
80102168:	8b 45 14             	mov    0x14(%ebp),%eax
}
8010216b:	c9                   	leave  
8010216c:	c3                   	ret    

8010216d <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
8010216d:	55                   	push   %ebp
8010216e:	89 e5                	mov    %esp,%ebp
80102170:	83 ec 08             	sub    $0x8,%esp
  return strncmp(s, t, DIRSIZ);
80102173:	83 ec 04             	sub    $0x4,%esp
80102176:	6a 0e                	push   $0xe
80102178:	ff 75 0c             	pushl  0xc(%ebp)
8010217b:	ff 75 08             	pushl  0x8(%ebp)
8010217e:	e8 a5 37 00 00       	call   80105928 <strncmp>
80102183:	83 c4 10             	add    $0x10,%esp
}
80102186:	c9                   	leave  
80102187:	c3                   	ret    

80102188 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102188:	55                   	push   %ebp
80102189:	89 e5                	mov    %esp,%ebp
8010218b:	83 ec 28             	sub    $0x28,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
8010218e:	8b 45 08             	mov    0x8(%ebp),%eax
80102191:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80102195:	66 83 f8 01          	cmp    $0x1,%ax
80102199:	74 0d                	je     801021a8 <dirlookup+0x20>
    panic("dirlookup not DIR");
8010219b:	83 ec 0c             	sub    $0xc,%esp
8010219e:	68 62 8e 10 80       	push   $0x80108e62
801021a3:	e8 be e3 ff ff       	call   80100566 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
801021a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801021af:	eb 7b                	jmp    8010222c <dirlookup+0xa4>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801021b1:	6a 10                	push   $0x10
801021b3:	ff 75 f4             	pushl  -0xc(%ebp)
801021b6:	8d 45 e0             	lea    -0x20(%ebp),%eax
801021b9:	50                   	push   %eax
801021ba:	ff 75 08             	pushl  0x8(%ebp)
801021bd:	e8 cc fc ff ff       	call   80101e8e <readi>
801021c2:	83 c4 10             	add    $0x10,%esp
801021c5:	83 f8 10             	cmp    $0x10,%eax
801021c8:	74 0d                	je     801021d7 <dirlookup+0x4f>
      panic("dirlink read");
801021ca:	83 ec 0c             	sub    $0xc,%esp
801021cd:	68 74 8e 10 80       	push   $0x80108e74
801021d2:	e8 8f e3 ff ff       	call   80100566 <panic>
    if(de.inum == 0)
801021d7:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801021db:	66 85 c0             	test   %ax,%ax
801021de:	74 47                	je     80102227 <dirlookup+0x9f>
      continue;
    if(namecmp(name, de.name) == 0){
801021e0:	83 ec 08             	sub    $0x8,%esp
801021e3:	8d 45 e0             	lea    -0x20(%ebp),%eax
801021e6:	83 c0 02             	add    $0x2,%eax
801021e9:	50                   	push   %eax
801021ea:	ff 75 0c             	pushl  0xc(%ebp)
801021ed:	e8 7b ff ff ff       	call   8010216d <namecmp>
801021f2:	83 c4 10             	add    $0x10,%esp
801021f5:	85 c0                	test   %eax,%eax
801021f7:	75 2f                	jne    80102228 <dirlookup+0xa0>
      // entry matches path element
      if(poff)
801021f9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801021fd:	74 08                	je     80102207 <dirlookup+0x7f>
        *poff = off;
801021ff:	8b 45 10             	mov    0x10(%ebp),%eax
80102202:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102205:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
80102207:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010220b:	0f b7 c0             	movzwl %ax,%eax
8010220e:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
80102211:	8b 45 08             	mov    0x8(%ebp),%eax
80102214:	8b 00                	mov    (%eax),%eax
80102216:	83 ec 08             	sub    $0x8,%esp
80102219:	ff 75 f0             	pushl  -0x10(%ebp)
8010221c:	50                   	push   %eax
8010221d:	e8 e5 f5 ff ff       	call   80101807 <iget>
80102222:	83 c4 10             	add    $0x10,%esp
80102225:	eb 19                	jmp    80102240 <dirlookup+0xb8>

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      continue;
80102227:	90                   	nop
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80102228:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
8010222c:	8b 45 08             	mov    0x8(%ebp),%eax
8010222f:	8b 40 18             	mov    0x18(%eax),%eax
80102232:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80102235:	0f 87 76 ff ff ff    	ja     801021b1 <dirlookup+0x29>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
8010223b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102240:	c9                   	leave  
80102241:	c3                   	ret    

80102242 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80102242:	55                   	push   %ebp
80102243:	89 e5                	mov    %esp,%ebp
80102245:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80102248:	83 ec 04             	sub    $0x4,%esp
8010224b:	6a 00                	push   $0x0
8010224d:	ff 75 0c             	pushl  0xc(%ebp)
80102250:	ff 75 08             	pushl  0x8(%ebp)
80102253:	e8 30 ff ff ff       	call   80102188 <dirlookup>
80102258:	83 c4 10             	add    $0x10,%esp
8010225b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010225e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102262:	74 18                	je     8010227c <dirlink+0x3a>
    iput(ip);
80102264:	83 ec 0c             	sub    $0xc,%esp
80102267:	ff 75 f0             	pushl  -0x10(%ebp)
8010226a:	e8 81 f8 ff ff       	call   80101af0 <iput>
8010226f:	83 c4 10             	add    $0x10,%esp
    return -1;
80102272:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102277:	e9 9c 00 00 00       	jmp    80102318 <dirlink+0xd6>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
8010227c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102283:	eb 39                	jmp    801022be <dirlink+0x7c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102285:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102288:	6a 10                	push   $0x10
8010228a:	50                   	push   %eax
8010228b:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010228e:	50                   	push   %eax
8010228f:	ff 75 08             	pushl  0x8(%ebp)
80102292:	e8 f7 fb ff ff       	call   80101e8e <readi>
80102297:	83 c4 10             	add    $0x10,%esp
8010229a:	83 f8 10             	cmp    $0x10,%eax
8010229d:	74 0d                	je     801022ac <dirlink+0x6a>
      panic("dirlink read");
8010229f:	83 ec 0c             	sub    $0xc,%esp
801022a2:	68 74 8e 10 80       	push   $0x80108e74
801022a7:	e8 ba e2 ff ff       	call   80100566 <panic>
    if(de.inum == 0)
801022ac:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801022b0:	66 85 c0             	test   %ax,%ax
801022b3:	74 18                	je     801022cd <dirlink+0x8b>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801022b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022b8:	83 c0 10             	add    $0x10,%eax
801022bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
801022be:	8b 45 08             	mov    0x8(%ebp),%eax
801022c1:	8b 50 18             	mov    0x18(%eax),%edx
801022c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022c7:	39 c2                	cmp    %eax,%edx
801022c9:	77 ba                	ja     80102285 <dirlink+0x43>
801022cb:	eb 01                	jmp    801022ce <dirlink+0x8c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      break;
801022cd:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
801022ce:	83 ec 04             	sub    $0x4,%esp
801022d1:	6a 0e                	push   $0xe
801022d3:	ff 75 0c             	pushl  0xc(%ebp)
801022d6:	8d 45 e0             	lea    -0x20(%ebp),%eax
801022d9:	83 c0 02             	add    $0x2,%eax
801022dc:	50                   	push   %eax
801022dd:	e8 9c 36 00 00       	call   8010597e <strncpy>
801022e2:	83 c4 10             	add    $0x10,%esp
  de.inum = inum;
801022e5:	8b 45 10             	mov    0x10(%ebp),%eax
801022e8:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801022ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022ef:	6a 10                	push   $0x10
801022f1:	50                   	push   %eax
801022f2:	8d 45 e0             	lea    -0x20(%ebp),%eax
801022f5:	50                   	push   %eax
801022f6:	ff 75 08             	pushl  0x8(%ebp)
801022f9:	e8 e7 fc ff ff       	call   80101fe5 <writei>
801022fe:	83 c4 10             	add    $0x10,%esp
80102301:	83 f8 10             	cmp    $0x10,%eax
80102304:	74 0d                	je     80102313 <dirlink+0xd1>
    panic("dirlink");
80102306:	83 ec 0c             	sub    $0xc,%esp
80102309:	68 81 8e 10 80       	push   $0x80108e81
8010230e:	e8 53 e2 ff ff       	call   80100566 <panic>
  
  return 0;
80102313:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102318:	c9                   	leave  
80102319:	c3                   	ret    

8010231a <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
8010231a:	55                   	push   %ebp
8010231b:	89 e5                	mov    %esp,%ebp
8010231d:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int len;

  while(*path == '/')
80102320:	eb 04                	jmp    80102326 <skipelem+0xc>
    path++;
80102322:	83 45 08 01          	addl   $0x1,0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80102326:	8b 45 08             	mov    0x8(%ebp),%eax
80102329:	0f b6 00             	movzbl (%eax),%eax
8010232c:	3c 2f                	cmp    $0x2f,%al
8010232e:	74 f2                	je     80102322 <skipelem+0x8>
    path++;
  if(*path == 0)
80102330:	8b 45 08             	mov    0x8(%ebp),%eax
80102333:	0f b6 00             	movzbl (%eax),%eax
80102336:	84 c0                	test   %al,%al
80102338:	75 07                	jne    80102341 <skipelem+0x27>
    return 0;
8010233a:	b8 00 00 00 00       	mov    $0x0,%eax
8010233f:	eb 7b                	jmp    801023bc <skipelem+0xa2>
  s = path;
80102341:	8b 45 08             	mov    0x8(%ebp),%eax
80102344:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
80102347:	eb 04                	jmp    8010234d <skipelem+0x33>
    path++;
80102349:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
8010234d:	8b 45 08             	mov    0x8(%ebp),%eax
80102350:	0f b6 00             	movzbl (%eax),%eax
80102353:	3c 2f                	cmp    $0x2f,%al
80102355:	74 0a                	je     80102361 <skipelem+0x47>
80102357:	8b 45 08             	mov    0x8(%ebp),%eax
8010235a:	0f b6 00             	movzbl (%eax),%eax
8010235d:	84 c0                	test   %al,%al
8010235f:	75 e8                	jne    80102349 <skipelem+0x2f>
    path++;
  len = path - s;
80102361:	8b 55 08             	mov    0x8(%ebp),%edx
80102364:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102367:	29 c2                	sub    %eax,%edx
80102369:	89 d0                	mov    %edx,%eax
8010236b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
8010236e:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
80102372:	7e 15                	jle    80102389 <skipelem+0x6f>
    memmove(name, s, DIRSIZ);
80102374:	83 ec 04             	sub    $0x4,%esp
80102377:	6a 0e                	push   $0xe
80102379:	ff 75 f4             	pushl  -0xc(%ebp)
8010237c:	ff 75 0c             	pushl  0xc(%ebp)
8010237f:	e8 0e 35 00 00       	call   80105892 <memmove>
80102384:	83 c4 10             	add    $0x10,%esp
80102387:	eb 26                	jmp    801023af <skipelem+0x95>
  else {
    memmove(name, s, len);
80102389:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010238c:	83 ec 04             	sub    $0x4,%esp
8010238f:	50                   	push   %eax
80102390:	ff 75 f4             	pushl  -0xc(%ebp)
80102393:	ff 75 0c             	pushl  0xc(%ebp)
80102396:	e8 f7 34 00 00       	call   80105892 <memmove>
8010239b:	83 c4 10             	add    $0x10,%esp
    name[len] = 0;
8010239e:	8b 55 f0             	mov    -0x10(%ebp),%edx
801023a1:	8b 45 0c             	mov    0xc(%ebp),%eax
801023a4:	01 d0                	add    %edx,%eax
801023a6:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
801023a9:	eb 04                	jmp    801023af <skipelem+0x95>
    path++;
801023ab:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
801023af:	8b 45 08             	mov    0x8(%ebp),%eax
801023b2:	0f b6 00             	movzbl (%eax),%eax
801023b5:	3c 2f                	cmp    $0x2f,%al
801023b7:	74 f2                	je     801023ab <skipelem+0x91>
    path++;
  return path;
801023b9:	8b 45 08             	mov    0x8(%ebp),%eax
}
801023bc:	c9                   	leave  
801023bd:	c3                   	ret    

801023be <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
801023be:	55                   	push   %ebp
801023bf:	89 e5                	mov    %esp,%ebp
801023c1:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *next;

  if(*path == '/')
801023c4:	8b 45 08             	mov    0x8(%ebp),%eax
801023c7:	0f b6 00             	movzbl (%eax),%eax
801023ca:	3c 2f                	cmp    $0x2f,%al
801023cc:	75 17                	jne    801023e5 <namex+0x27>
    ip = iget(ROOTDEV, ROOTINO);
801023ce:	83 ec 08             	sub    $0x8,%esp
801023d1:	6a 01                	push   $0x1
801023d3:	6a 01                	push   $0x1
801023d5:	e8 2d f4 ff ff       	call   80101807 <iget>
801023da:	83 c4 10             	add    $0x10,%esp
801023dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
801023e0:	e9 bb 00 00 00       	jmp    801024a0 <namex+0xe2>
  else
    ip = idup(proc->cwd);
801023e5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801023eb:	8b 40 68             	mov    0x68(%eax),%eax
801023ee:	83 ec 0c             	sub    $0xc,%esp
801023f1:	50                   	push   %eax
801023f2:	e8 ef f4 ff ff       	call   801018e6 <idup>
801023f7:	83 c4 10             	add    $0x10,%esp
801023fa:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
801023fd:	e9 9e 00 00 00       	jmp    801024a0 <namex+0xe2>
    ilock(ip);
80102402:	83 ec 0c             	sub    $0xc,%esp
80102405:	ff 75 f4             	pushl  -0xc(%ebp)
80102408:	e8 13 f5 ff ff       	call   80101920 <ilock>
8010240d:	83 c4 10             	add    $0x10,%esp
    if(ip->type != T_DIR){
80102410:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102413:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80102417:	66 83 f8 01          	cmp    $0x1,%ax
8010241b:	74 18                	je     80102435 <namex+0x77>
      iunlockput(ip);
8010241d:	83 ec 0c             	sub    $0xc,%esp
80102420:	ff 75 f4             	pushl  -0xc(%ebp)
80102423:	e8 b8 f7 ff ff       	call   80101be0 <iunlockput>
80102428:	83 c4 10             	add    $0x10,%esp
      return 0;
8010242b:	b8 00 00 00 00       	mov    $0x0,%eax
80102430:	e9 a7 00 00 00       	jmp    801024dc <namex+0x11e>
    }
    if(nameiparent && *path == '\0'){
80102435:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102439:	74 20                	je     8010245b <namex+0x9d>
8010243b:	8b 45 08             	mov    0x8(%ebp),%eax
8010243e:	0f b6 00             	movzbl (%eax),%eax
80102441:	84 c0                	test   %al,%al
80102443:	75 16                	jne    8010245b <namex+0x9d>
      // Stop one level early.
      iunlock(ip);
80102445:	83 ec 0c             	sub    $0xc,%esp
80102448:	ff 75 f4             	pushl  -0xc(%ebp)
8010244b:	e8 2e f6 ff ff       	call   80101a7e <iunlock>
80102450:	83 c4 10             	add    $0x10,%esp
      return ip;
80102453:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102456:	e9 81 00 00 00       	jmp    801024dc <namex+0x11e>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
8010245b:	83 ec 04             	sub    $0x4,%esp
8010245e:	6a 00                	push   $0x0
80102460:	ff 75 10             	pushl  0x10(%ebp)
80102463:	ff 75 f4             	pushl  -0xc(%ebp)
80102466:	e8 1d fd ff ff       	call   80102188 <dirlookup>
8010246b:	83 c4 10             	add    $0x10,%esp
8010246e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102471:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102475:	75 15                	jne    8010248c <namex+0xce>
      iunlockput(ip);
80102477:	83 ec 0c             	sub    $0xc,%esp
8010247a:	ff 75 f4             	pushl  -0xc(%ebp)
8010247d:	e8 5e f7 ff ff       	call   80101be0 <iunlockput>
80102482:	83 c4 10             	add    $0x10,%esp
      return 0;
80102485:	b8 00 00 00 00       	mov    $0x0,%eax
8010248a:	eb 50                	jmp    801024dc <namex+0x11e>
    }
    iunlockput(ip);
8010248c:	83 ec 0c             	sub    $0xc,%esp
8010248f:	ff 75 f4             	pushl  -0xc(%ebp)
80102492:	e8 49 f7 ff ff       	call   80101be0 <iunlockput>
80102497:	83 c4 10             	add    $0x10,%esp
    ip = next;
8010249a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010249d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
801024a0:	83 ec 08             	sub    $0x8,%esp
801024a3:	ff 75 10             	pushl  0x10(%ebp)
801024a6:	ff 75 08             	pushl  0x8(%ebp)
801024a9:	e8 6c fe ff ff       	call   8010231a <skipelem>
801024ae:	83 c4 10             	add    $0x10,%esp
801024b1:	89 45 08             	mov    %eax,0x8(%ebp)
801024b4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801024b8:	0f 85 44 ff ff ff    	jne    80102402 <namex+0x44>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
801024be:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801024c2:	74 15                	je     801024d9 <namex+0x11b>
    iput(ip);
801024c4:	83 ec 0c             	sub    $0xc,%esp
801024c7:	ff 75 f4             	pushl  -0xc(%ebp)
801024ca:	e8 21 f6 ff ff       	call   80101af0 <iput>
801024cf:	83 c4 10             	add    $0x10,%esp
    return 0;
801024d2:	b8 00 00 00 00       	mov    $0x0,%eax
801024d7:	eb 03                	jmp    801024dc <namex+0x11e>
  }
  return ip;
801024d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801024dc:	c9                   	leave  
801024dd:	c3                   	ret    

801024de <namei>:

struct inode*
namei(char *path)
{
801024de:	55                   	push   %ebp
801024df:	89 e5                	mov    %esp,%ebp
801024e1:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
801024e4:	83 ec 04             	sub    $0x4,%esp
801024e7:	8d 45 ea             	lea    -0x16(%ebp),%eax
801024ea:	50                   	push   %eax
801024eb:	6a 00                	push   $0x0
801024ed:	ff 75 08             	pushl  0x8(%ebp)
801024f0:	e8 c9 fe ff ff       	call   801023be <namex>
801024f5:	83 c4 10             	add    $0x10,%esp
}
801024f8:	c9                   	leave  
801024f9:	c3                   	ret    

801024fa <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801024fa:	55                   	push   %ebp
801024fb:	89 e5                	mov    %esp,%ebp
801024fd:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
80102500:	83 ec 04             	sub    $0x4,%esp
80102503:	ff 75 0c             	pushl  0xc(%ebp)
80102506:	6a 01                	push   $0x1
80102508:	ff 75 08             	pushl  0x8(%ebp)
8010250b:	e8 ae fe ff ff       	call   801023be <namex>
80102510:	83 c4 10             	add    $0x10,%esp
}
80102513:	c9                   	leave  
80102514:	c3                   	ret    

80102515 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102515:	55                   	push   %ebp
80102516:	89 e5                	mov    %esp,%ebp
80102518:	83 ec 14             	sub    $0x14,%esp
8010251b:	8b 45 08             	mov    0x8(%ebp),%eax
8010251e:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102522:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102526:	89 c2                	mov    %eax,%edx
80102528:	ec                   	in     (%dx),%al
80102529:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
8010252c:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102530:	c9                   	leave  
80102531:	c3                   	ret    

80102532 <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
80102532:	55                   	push   %ebp
80102533:	89 e5                	mov    %esp,%ebp
80102535:	57                   	push   %edi
80102536:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
80102537:	8b 55 08             	mov    0x8(%ebp),%edx
8010253a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010253d:	8b 45 10             	mov    0x10(%ebp),%eax
80102540:	89 cb                	mov    %ecx,%ebx
80102542:	89 df                	mov    %ebx,%edi
80102544:	89 c1                	mov    %eax,%ecx
80102546:	fc                   	cld    
80102547:	f3 6d                	rep insl (%dx),%es:(%edi)
80102549:	89 c8                	mov    %ecx,%eax
8010254b:	89 fb                	mov    %edi,%ebx
8010254d:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102550:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
80102553:	90                   	nop
80102554:	5b                   	pop    %ebx
80102555:	5f                   	pop    %edi
80102556:	5d                   	pop    %ebp
80102557:	c3                   	ret    

80102558 <outb>:

static inline void
outb(ushort port, uchar data)
{
80102558:	55                   	push   %ebp
80102559:	89 e5                	mov    %esp,%ebp
8010255b:	83 ec 08             	sub    $0x8,%esp
8010255e:	8b 55 08             	mov    0x8(%ebp),%edx
80102561:	8b 45 0c             	mov    0xc(%ebp),%eax
80102564:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102568:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010256b:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010256f:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102573:	ee                   	out    %al,(%dx)
}
80102574:	90                   	nop
80102575:	c9                   	leave  
80102576:	c3                   	ret    

80102577 <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
80102577:	55                   	push   %ebp
80102578:	89 e5                	mov    %esp,%ebp
8010257a:	56                   	push   %esi
8010257b:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
8010257c:	8b 55 08             	mov    0x8(%ebp),%edx
8010257f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102582:	8b 45 10             	mov    0x10(%ebp),%eax
80102585:	89 cb                	mov    %ecx,%ebx
80102587:	89 de                	mov    %ebx,%esi
80102589:	89 c1                	mov    %eax,%ecx
8010258b:	fc                   	cld    
8010258c:	f3 6f                	rep outsl %ds:(%esi),(%dx)
8010258e:	89 c8                	mov    %ecx,%eax
80102590:	89 f3                	mov    %esi,%ebx
80102592:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102595:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
80102598:	90                   	nop
80102599:	5b                   	pop    %ebx
8010259a:	5e                   	pop    %esi
8010259b:	5d                   	pop    %ebp
8010259c:	c3                   	ret    

8010259d <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
8010259d:	55                   	push   %ebp
8010259e:	89 e5                	mov    %esp,%ebp
801025a0:	83 ec 10             	sub    $0x10,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
801025a3:	90                   	nop
801025a4:	68 f7 01 00 00       	push   $0x1f7
801025a9:	e8 67 ff ff ff       	call   80102515 <inb>
801025ae:	83 c4 04             	add    $0x4,%esp
801025b1:	0f b6 c0             	movzbl %al,%eax
801025b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
801025b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
801025ba:	25 c0 00 00 00       	and    $0xc0,%eax
801025bf:	83 f8 40             	cmp    $0x40,%eax
801025c2:	75 e0                	jne    801025a4 <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801025c4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801025c8:	74 11                	je     801025db <idewait+0x3e>
801025ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
801025cd:	83 e0 21             	and    $0x21,%eax
801025d0:	85 c0                	test   %eax,%eax
801025d2:	74 07                	je     801025db <idewait+0x3e>
    return -1;
801025d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801025d9:	eb 05                	jmp    801025e0 <idewait+0x43>
  return 0;
801025db:	b8 00 00 00 00       	mov    $0x0,%eax
}
801025e0:	c9                   	leave  
801025e1:	c3                   	ret    

801025e2 <ideinit>:

void
ideinit(void)
{
801025e2:	55                   	push   %ebp
801025e3:	89 e5                	mov    %esp,%ebp
801025e5:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  initlock(&idelock, "ide");
801025e8:	83 ec 08             	sub    $0x8,%esp
801025eb:	68 89 8e 10 80       	push   $0x80108e89
801025f0:	68 20 c6 10 80       	push   $0x8010c620
801025f5:	e8 54 2f 00 00       	call   8010554e <initlock>
801025fa:	83 c4 10             	add    $0x10,%esp
  picenable(IRQ_IDE);
801025fd:	83 ec 0c             	sub    $0xc,%esp
80102600:	6a 0e                	push   $0xe
80102602:	e8 c4 18 00 00       	call   80103ecb <picenable>
80102607:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_IDE, ncpu - 1);
8010260a:	a1 60 39 11 80       	mov    0x80113960,%eax
8010260f:	83 e8 01             	sub    $0x1,%eax
80102612:	83 ec 08             	sub    $0x8,%esp
80102615:	50                   	push   %eax
80102616:	6a 0e                	push   $0xe
80102618:	e8 73 04 00 00       	call   80102a90 <ioapicenable>
8010261d:	83 c4 10             	add    $0x10,%esp
  idewait(0);
80102620:	83 ec 0c             	sub    $0xc,%esp
80102623:	6a 00                	push   $0x0
80102625:	e8 73 ff ff ff       	call   8010259d <idewait>
8010262a:	83 c4 10             	add    $0x10,%esp
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
8010262d:	83 ec 08             	sub    $0x8,%esp
80102630:	68 f0 00 00 00       	push   $0xf0
80102635:	68 f6 01 00 00       	push   $0x1f6
8010263a:	e8 19 ff ff ff       	call   80102558 <outb>
8010263f:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<1000; i++){
80102642:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102649:	eb 24                	jmp    8010266f <ideinit+0x8d>
    if(inb(0x1f7) != 0){
8010264b:	83 ec 0c             	sub    $0xc,%esp
8010264e:	68 f7 01 00 00       	push   $0x1f7
80102653:	e8 bd fe ff ff       	call   80102515 <inb>
80102658:	83 c4 10             	add    $0x10,%esp
8010265b:	84 c0                	test   %al,%al
8010265d:	74 0c                	je     8010266b <ideinit+0x89>
      havedisk1 = 1;
8010265f:	c7 05 58 c6 10 80 01 	movl   $0x1,0x8010c658
80102666:	00 00 00 
      break;
80102669:	eb 0d                	jmp    80102678 <ideinit+0x96>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
8010266b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010266f:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
80102676:	7e d3                	jle    8010264b <ideinit+0x69>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
80102678:	83 ec 08             	sub    $0x8,%esp
8010267b:	68 e0 00 00 00       	push   $0xe0
80102680:	68 f6 01 00 00       	push   $0x1f6
80102685:	e8 ce fe ff ff       	call   80102558 <outb>
8010268a:	83 c4 10             	add    $0x10,%esp
}
8010268d:	90                   	nop
8010268e:	c9                   	leave  
8010268f:	c3                   	ret    

80102690 <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102690:	55                   	push   %ebp
80102691:	89 e5                	mov    %esp,%ebp
80102693:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
80102696:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010269a:	75 0d                	jne    801026a9 <idestart+0x19>
    panic("idestart");
8010269c:	83 ec 0c             	sub    $0xc,%esp
8010269f:	68 8d 8e 10 80       	push   $0x80108e8d
801026a4:	e8 bd de ff ff       	call   80100566 <panic>
  if(b->blockno >= FSSIZE)
801026a9:	8b 45 08             	mov    0x8(%ebp),%eax
801026ac:	8b 40 08             	mov    0x8(%eax),%eax
801026af:	3d e7 03 00 00       	cmp    $0x3e7,%eax
801026b4:	76 0d                	jbe    801026c3 <idestart+0x33>
    panic("incorrect blockno");
801026b6:	83 ec 0c             	sub    $0xc,%esp
801026b9:	68 96 8e 10 80       	push   $0x80108e96
801026be:	e8 a3 de ff ff       	call   80100566 <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
801026c3:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int sector = b->blockno * sector_per_block;
801026ca:	8b 45 08             	mov    0x8(%ebp),%eax
801026cd:	8b 50 08             	mov    0x8(%eax),%edx
801026d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801026d3:	0f af c2             	imul   %edx,%eax
801026d6:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if (sector_per_block > 7) panic("idestart");
801026d9:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
801026dd:	7e 0d                	jle    801026ec <idestart+0x5c>
801026df:	83 ec 0c             	sub    $0xc,%esp
801026e2:	68 8d 8e 10 80       	push   $0x80108e8d
801026e7:	e8 7a de ff ff       	call   80100566 <panic>
  
  idewait(0);
801026ec:	83 ec 0c             	sub    $0xc,%esp
801026ef:	6a 00                	push   $0x0
801026f1:	e8 a7 fe ff ff       	call   8010259d <idewait>
801026f6:	83 c4 10             	add    $0x10,%esp
  outb(0x3f6, 0);  // generate interrupt
801026f9:	83 ec 08             	sub    $0x8,%esp
801026fc:	6a 00                	push   $0x0
801026fe:	68 f6 03 00 00       	push   $0x3f6
80102703:	e8 50 fe ff ff       	call   80102558 <outb>
80102708:	83 c4 10             	add    $0x10,%esp
  outb(0x1f2, sector_per_block);  // number of sectors
8010270b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010270e:	0f b6 c0             	movzbl %al,%eax
80102711:	83 ec 08             	sub    $0x8,%esp
80102714:	50                   	push   %eax
80102715:	68 f2 01 00 00       	push   $0x1f2
8010271a:	e8 39 fe ff ff       	call   80102558 <outb>
8010271f:	83 c4 10             	add    $0x10,%esp
  outb(0x1f3, sector & 0xff);
80102722:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102725:	0f b6 c0             	movzbl %al,%eax
80102728:	83 ec 08             	sub    $0x8,%esp
8010272b:	50                   	push   %eax
8010272c:	68 f3 01 00 00       	push   $0x1f3
80102731:	e8 22 fe ff ff       	call   80102558 <outb>
80102736:	83 c4 10             	add    $0x10,%esp
  outb(0x1f4, (sector >> 8) & 0xff);
80102739:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010273c:	c1 f8 08             	sar    $0x8,%eax
8010273f:	0f b6 c0             	movzbl %al,%eax
80102742:	83 ec 08             	sub    $0x8,%esp
80102745:	50                   	push   %eax
80102746:	68 f4 01 00 00       	push   $0x1f4
8010274b:	e8 08 fe ff ff       	call   80102558 <outb>
80102750:	83 c4 10             	add    $0x10,%esp
  outb(0x1f5, (sector >> 16) & 0xff);
80102753:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102756:	c1 f8 10             	sar    $0x10,%eax
80102759:	0f b6 c0             	movzbl %al,%eax
8010275c:	83 ec 08             	sub    $0x8,%esp
8010275f:	50                   	push   %eax
80102760:	68 f5 01 00 00       	push   $0x1f5
80102765:	e8 ee fd ff ff       	call   80102558 <outb>
8010276a:	83 c4 10             	add    $0x10,%esp
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010276d:	8b 45 08             	mov    0x8(%ebp),%eax
80102770:	8b 40 04             	mov    0x4(%eax),%eax
80102773:	83 e0 01             	and    $0x1,%eax
80102776:	c1 e0 04             	shl    $0x4,%eax
80102779:	89 c2                	mov    %eax,%edx
8010277b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010277e:	c1 f8 18             	sar    $0x18,%eax
80102781:	83 e0 0f             	and    $0xf,%eax
80102784:	09 d0                	or     %edx,%eax
80102786:	83 c8 e0             	or     $0xffffffe0,%eax
80102789:	0f b6 c0             	movzbl %al,%eax
8010278c:	83 ec 08             	sub    $0x8,%esp
8010278f:	50                   	push   %eax
80102790:	68 f6 01 00 00       	push   $0x1f6
80102795:	e8 be fd ff ff       	call   80102558 <outb>
8010279a:	83 c4 10             	add    $0x10,%esp
  if(b->flags & B_DIRTY){
8010279d:	8b 45 08             	mov    0x8(%ebp),%eax
801027a0:	8b 00                	mov    (%eax),%eax
801027a2:	83 e0 04             	and    $0x4,%eax
801027a5:	85 c0                	test   %eax,%eax
801027a7:	74 30                	je     801027d9 <idestart+0x149>
    outb(0x1f7, IDE_CMD_WRITE);
801027a9:	83 ec 08             	sub    $0x8,%esp
801027ac:	6a 30                	push   $0x30
801027ae:	68 f7 01 00 00       	push   $0x1f7
801027b3:	e8 a0 fd ff ff       	call   80102558 <outb>
801027b8:	83 c4 10             	add    $0x10,%esp
    outsl(0x1f0, b->data, BSIZE/4);
801027bb:	8b 45 08             	mov    0x8(%ebp),%eax
801027be:	83 c0 18             	add    $0x18,%eax
801027c1:	83 ec 04             	sub    $0x4,%esp
801027c4:	68 80 00 00 00       	push   $0x80
801027c9:	50                   	push   %eax
801027ca:	68 f0 01 00 00       	push   $0x1f0
801027cf:	e8 a3 fd ff ff       	call   80102577 <outsl>
801027d4:	83 c4 10             	add    $0x10,%esp
  } else {
    outb(0x1f7, IDE_CMD_READ);
  }
}
801027d7:	eb 12                	jmp    801027eb <idestart+0x15b>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, IDE_CMD_WRITE);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, IDE_CMD_READ);
801027d9:	83 ec 08             	sub    $0x8,%esp
801027dc:	6a 20                	push   $0x20
801027de:	68 f7 01 00 00       	push   $0x1f7
801027e3:	e8 70 fd ff ff       	call   80102558 <outb>
801027e8:	83 c4 10             	add    $0x10,%esp
  }
}
801027eb:	90                   	nop
801027ec:	c9                   	leave  
801027ed:	c3                   	ret    

801027ee <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801027ee:	55                   	push   %ebp
801027ef:	89 e5                	mov    %esp,%ebp
801027f1:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801027f4:	83 ec 0c             	sub    $0xc,%esp
801027f7:	68 20 c6 10 80       	push   $0x8010c620
801027fc:	e8 6f 2d 00 00       	call   80105570 <acquire>
80102801:	83 c4 10             	add    $0x10,%esp
  if((b = idequeue) == 0){
80102804:	a1 54 c6 10 80       	mov    0x8010c654,%eax
80102809:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010280c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102810:	75 15                	jne    80102827 <ideintr+0x39>
    release(&idelock);
80102812:	83 ec 0c             	sub    $0xc,%esp
80102815:	68 20 c6 10 80       	push   $0x8010c620
8010281a:	e8 b8 2d 00 00       	call   801055d7 <release>
8010281f:	83 c4 10             	add    $0x10,%esp
    // cprintf("spurious IDE interrupt\n");
    return;
80102822:	e9 9a 00 00 00       	jmp    801028c1 <ideintr+0xd3>
  }
  idequeue = b->qnext;
80102827:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010282a:	8b 40 14             	mov    0x14(%eax),%eax
8010282d:	a3 54 c6 10 80       	mov    %eax,0x8010c654

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102832:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102835:	8b 00                	mov    (%eax),%eax
80102837:	83 e0 04             	and    $0x4,%eax
8010283a:	85 c0                	test   %eax,%eax
8010283c:	75 2d                	jne    8010286b <ideintr+0x7d>
8010283e:	83 ec 0c             	sub    $0xc,%esp
80102841:	6a 01                	push   $0x1
80102843:	e8 55 fd ff ff       	call   8010259d <idewait>
80102848:	83 c4 10             	add    $0x10,%esp
8010284b:	85 c0                	test   %eax,%eax
8010284d:	78 1c                	js     8010286b <ideintr+0x7d>
    insl(0x1f0, b->data, BSIZE/4);
8010284f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102852:	83 c0 18             	add    $0x18,%eax
80102855:	83 ec 04             	sub    $0x4,%esp
80102858:	68 80 00 00 00       	push   $0x80
8010285d:	50                   	push   %eax
8010285e:	68 f0 01 00 00       	push   $0x1f0
80102863:	e8 ca fc ff ff       	call   80102532 <insl>
80102868:	83 c4 10             	add    $0x10,%esp
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010286b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010286e:	8b 00                	mov    (%eax),%eax
80102870:	83 c8 02             	or     $0x2,%eax
80102873:	89 c2                	mov    %eax,%edx
80102875:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102878:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
8010287a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010287d:	8b 00                	mov    (%eax),%eax
8010287f:	83 e0 fb             	and    $0xfffffffb,%eax
80102882:	89 c2                	mov    %eax,%edx
80102884:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102887:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80102889:	83 ec 0c             	sub    $0xc,%esp
8010288c:	ff 75 f4             	pushl  -0xc(%ebp)
8010288f:	e8 ba 2a 00 00       	call   8010534e <wakeup>
80102894:	83 c4 10             	add    $0x10,%esp
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
80102897:	a1 54 c6 10 80       	mov    0x8010c654,%eax
8010289c:	85 c0                	test   %eax,%eax
8010289e:	74 11                	je     801028b1 <ideintr+0xc3>
    idestart(idequeue);
801028a0:	a1 54 c6 10 80       	mov    0x8010c654,%eax
801028a5:	83 ec 0c             	sub    $0xc,%esp
801028a8:	50                   	push   %eax
801028a9:	e8 e2 fd ff ff       	call   80102690 <idestart>
801028ae:	83 c4 10             	add    $0x10,%esp

  release(&idelock);
801028b1:	83 ec 0c             	sub    $0xc,%esp
801028b4:	68 20 c6 10 80       	push   $0x8010c620
801028b9:	e8 19 2d 00 00       	call   801055d7 <release>
801028be:	83 c4 10             	add    $0x10,%esp
}
801028c1:	c9                   	leave  
801028c2:	c3                   	ret    

801028c3 <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801028c3:	55                   	push   %ebp
801028c4:	89 e5                	mov    %esp,%ebp
801028c6:	83 ec 18             	sub    $0x18,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
801028c9:	8b 45 08             	mov    0x8(%ebp),%eax
801028cc:	8b 00                	mov    (%eax),%eax
801028ce:	83 e0 01             	and    $0x1,%eax
801028d1:	85 c0                	test   %eax,%eax
801028d3:	75 0d                	jne    801028e2 <iderw+0x1f>
    panic("iderw: buf not busy");
801028d5:	83 ec 0c             	sub    $0xc,%esp
801028d8:	68 a8 8e 10 80       	push   $0x80108ea8
801028dd:	e8 84 dc ff ff       	call   80100566 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801028e2:	8b 45 08             	mov    0x8(%ebp),%eax
801028e5:	8b 00                	mov    (%eax),%eax
801028e7:	83 e0 06             	and    $0x6,%eax
801028ea:	83 f8 02             	cmp    $0x2,%eax
801028ed:	75 0d                	jne    801028fc <iderw+0x39>
    panic("iderw: nothing to do");
801028ef:	83 ec 0c             	sub    $0xc,%esp
801028f2:	68 bc 8e 10 80       	push   $0x80108ebc
801028f7:	e8 6a dc ff ff       	call   80100566 <panic>
  if(b->dev != 0 && !havedisk1)
801028fc:	8b 45 08             	mov    0x8(%ebp),%eax
801028ff:	8b 40 04             	mov    0x4(%eax),%eax
80102902:	85 c0                	test   %eax,%eax
80102904:	74 16                	je     8010291c <iderw+0x59>
80102906:	a1 58 c6 10 80       	mov    0x8010c658,%eax
8010290b:	85 c0                	test   %eax,%eax
8010290d:	75 0d                	jne    8010291c <iderw+0x59>
    panic("iderw: ide disk 1 not present");
8010290f:	83 ec 0c             	sub    $0xc,%esp
80102912:	68 d1 8e 10 80       	push   $0x80108ed1
80102917:	e8 4a dc ff ff       	call   80100566 <panic>

  acquire(&idelock);  //DOC:acquire-lock
8010291c:	83 ec 0c             	sub    $0xc,%esp
8010291f:	68 20 c6 10 80       	push   $0x8010c620
80102924:	e8 47 2c 00 00       	call   80105570 <acquire>
80102929:	83 c4 10             	add    $0x10,%esp

  // Append b to idequeue.
  b->qnext = 0;
8010292c:	8b 45 08             	mov    0x8(%ebp),%eax
8010292f:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102936:	c7 45 f4 54 c6 10 80 	movl   $0x8010c654,-0xc(%ebp)
8010293d:	eb 0b                	jmp    8010294a <iderw+0x87>
8010293f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102942:	8b 00                	mov    (%eax),%eax
80102944:	83 c0 14             	add    $0x14,%eax
80102947:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010294a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010294d:	8b 00                	mov    (%eax),%eax
8010294f:	85 c0                	test   %eax,%eax
80102951:	75 ec                	jne    8010293f <iderw+0x7c>
    ;
  *pp = b;
80102953:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102956:	8b 55 08             	mov    0x8(%ebp),%edx
80102959:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
8010295b:	a1 54 c6 10 80       	mov    0x8010c654,%eax
80102960:	3b 45 08             	cmp    0x8(%ebp),%eax
80102963:	75 23                	jne    80102988 <iderw+0xc5>
    idestart(b);
80102965:	83 ec 0c             	sub    $0xc,%esp
80102968:	ff 75 08             	pushl  0x8(%ebp)
8010296b:	e8 20 fd ff ff       	call   80102690 <idestart>
80102970:	83 c4 10             	add    $0x10,%esp
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102973:	eb 13                	jmp    80102988 <iderw+0xc5>
    sleep(b, &idelock);
80102975:	83 ec 08             	sub    $0x8,%esp
80102978:	68 20 c6 10 80       	push   $0x8010c620
8010297d:	ff 75 08             	pushl  0x8(%ebp)
80102980:	e8 db 28 00 00       	call   80105260 <sleep>
80102985:	83 c4 10             	add    $0x10,%esp
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102988:	8b 45 08             	mov    0x8(%ebp),%eax
8010298b:	8b 00                	mov    (%eax),%eax
8010298d:	83 e0 06             	and    $0x6,%eax
80102990:	83 f8 02             	cmp    $0x2,%eax
80102993:	75 e0                	jne    80102975 <iderw+0xb2>
    sleep(b, &idelock);
  }

  release(&idelock);
80102995:	83 ec 0c             	sub    $0xc,%esp
80102998:	68 20 c6 10 80       	push   $0x8010c620
8010299d:	e8 35 2c 00 00       	call   801055d7 <release>
801029a2:	83 c4 10             	add    $0x10,%esp
}
801029a5:	90                   	nop
801029a6:	c9                   	leave  
801029a7:	c3                   	ret    

801029a8 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
801029a8:	55                   	push   %ebp
801029a9:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
801029ab:	a1 34 32 11 80       	mov    0x80113234,%eax
801029b0:	8b 55 08             	mov    0x8(%ebp),%edx
801029b3:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
801029b5:	a1 34 32 11 80       	mov    0x80113234,%eax
801029ba:	8b 40 10             	mov    0x10(%eax),%eax
}
801029bd:	5d                   	pop    %ebp
801029be:	c3                   	ret    

801029bf <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
801029bf:	55                   	push   %ebp
801029c0:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
801029c2:	a1 34 32 11 80       	mov    0x80113234,%eax
801029c7:	8b 55 08             	mov    0x8(%ebp),%edx
801029ca:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
801029cc:	a1 34 32 11 80       	mov    0x80113234,%eax
801029d1:	8b 55 0c             	mov    0xc(%ebp),%edx
801029d4:	89 50 10             	mov    %edx,0x10(%eax)
}
801029d7:	90                   	nop
801029d8:	5d                   	pop    %ebp
801029d9:	c3                   	ret    

801029da <ioapicinit>:

void
ioapicinit(void)
{
801029da:	55                   	push   %ebp
801029db:	89 e5                	mov    %esp,%ebp
801029dd:	83 ec 18             	sub    $0x18,%esp
  int i, id, maxintr;

  if(!ismp)
801029e0:	a1 64 33 11 80       	mov    0x80113364,%eax
801029e5:	85 c0                	test   %eax,%eax
801029e7:	0f 84 a0 00 00 00    	je     80102a8d <ioapicinit+0xb3>
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
801029ed:	c7 05 34 32 11 80 00 	movl   $0xfec00000,0x80113234
801029f4:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801029f7:	6a 01                	push   $0x1
801029f9:	e8 aa ff ff ff       	call   801029a8 <ioapicread>
801029fe:	83 c4 04             	add    $0x4,%esp
80102a01:	c1 e8 10             	shr    $0x10,%eax
80102a04:	25 ff 00 00 00       	and    $0xff,%eax
80102a09:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102a0c:	6a 00                	push   $0x0
80102a0e:	e8 95 ff ff ff       	call   801029a8 <ioapicread>
80102a13:	83 c4 04             	add    $0x4,%esp
80102a16:	c1 e8 18             	shr    $0x18,%eax
80102a19:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102a1c:	0f b6 05 60 33 11 80 	movzbl 0x80113360,%eax
80102a23:	0f b6 c0             	movzbl %al,%eax
80102a26:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80102a29:	74 10                	je     80102a3b <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102a2b:	83 ec 0c             	sub    $0xc,%esp
80102a2e:	68 f0 8e 10 80       	push   $0x80108ef0
80102a33:	e8 8e d9 ff ff       	call   801003c6 <cprintf>
80102a38:	83 c4 10             	add    $0x10,%esp

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102a3b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102a42:	eb 3f                	jmp    80102a83 <ioapicinit+0xa9>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102a44:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a47:	83 c0 20             	add    $0x20,%eax
80102a4a:	0d 00 00 01 00       	or     $0x10000,%eax
80102a4f:	89 c2                	mov    %eax,%edx
80102a51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a54:	83 c0 08             	add    $0x8,%eax
80102a57:	01 c0                	add    %eax,%eax
80102a59:	83 ec 08             	sub    $0x8,%esp
80102a5c:	52                   	push   %edx
80102a5d:	50                   	push   %eax
80102a5e:	e8 5c ff ff ff       	call   801029bf <ioapicwrite>
80102a63:	83 c4 10             	add    $0x10,%esp
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102a66:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a69:	83 c0 08             	add    $0x8,%eax
80102a6c:	01 c0                	add    %eax,%eax
80102a6e:	83 c0 01             	add    $0x1,%eax
80102a71:	83 ec 08             	sub    $0x8,%esp
80102a74:	6a 00                	push   $0x0
80102a76:	50                   	push   %eax
80102a77:	e8 43 ff ff ff       	call   801029bf <ioapicwrite>
80102a7c:	83 c4 10             	add    $0x10,%esp
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102a7f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102a83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a86:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102a89:	7e b9                	jle    80102a44 <ioapicinit+0x6a>
80102a8b:	eb 01                	jmp    80102a8e <ioapicinit+0xb4>
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
    return;
80102a8d:	90                   	nop
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102a8e:	c9                   	leave  
80102a8f:	c3                   	ret    

80102a90 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102a90:	55                   	push   %ebp
80102a91:	89 e5                	mov    %esp,%ebp
  if(!ismp)
80102a93:	a1 64 33 11 80       	mov    0x80113364,%eax
80102a98:	85 c0                	test   %eax,%eax
80102a9a:	74 39                	je     80102ad5 <ioapicenable+0x45>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102a9c:	8b 45 08             	mov    0x8(%ebp),%eax
80102a9f:	83 c0 20             	add    $0x20,%eax
80102aa2:	89 c2                	mov    %eax,%edx
80102aa4:	8b 45 08             	mov    0x8(%ebp),%eax
80102aa7:	83 c0 08             	add    $0x8,%eax
80102aaa:	01 c0                	add    %eax,%eax
80102aac:	52                   	push   %edx
80102aad:	50                   	push   %eax
80102aae:	e8 0c ff ff ff       	call   801029bf <ioapicwrite>
80102ab3:	83 c4 08             	add    $0x8,%esp
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102ab6:	8b 45 0c             	mov    0xc(%ebp),%eax
80102ab9:	c1 e0 18             	shl    $0x18,%eax
80102abc:	89 c2                	mov    %eax,%edx
80102abe:	8b 45 08             	mov    0x8(%ebp),%eax
80102ac1:	83 c0 08             	add    $0x8,%eax
80102ac4:	01 c0                	add    %eax,%eax
80102ac6:	83 c0 01             	add    $0x1,%eax
80102ac9:	52                   	push   %edx
80102aca:	50                   	push   %eax
80102acb:	e8 ef fe ff ff       	call   801029bf <ioapicwrite>
80102ad0:	83 c4 08             	add    $0x8,%esp
80102ad3:	eb 01                	jmp    80102ad6 <ioapicenable+0x46>

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
    return;
80102ad5:	90                   	nop
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
80102ad6:	c9                   	leave  
80102ad7:	c3                   	ret    

80102ad8 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80102ad8:	55                   	push   %ebp
80102ad9:	89 e5                	mov    %esp,%ebp
80102adb:	8b 45 08             	mov    0x8(%ebp),%eax
80102ade:	05 00 00 00 80       	add    $0x80000000,%eax
80102ae3:	5d                   	pop    %ebp
80102ae4:	c3                   	ret    

80102ae5 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102ae5:	55                   	push   %ebp
80102ae6:	89 e5                	mov    %esp,%ebp
80102ae8:	83 ec 08             	sub    $0x8,%esp
  initlock(&kmem.lock, "kmem");
80102aeb:	83 ec 08             	sub    $0x8,%esp
80102aee:	68 22 8f 10 80       	push   $0x80108f22
80102af3:	68 40 32 11 80       	push   $0x80113240
80102af8:	e8 51 2a 00 00       	call   8010554e <initlock>
80102afd:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102b00:	c7 05 74 32 11 80 00 	movl   $0x0,0x80113274
80102b07:	00 00 00 
  freerange(vstart, vend);
80102b0a:	83 ec 08             	sub    $0x8,%esp
80102b0d:	ff 75 0c             	pushl  0xc(%ebp)
80102b10:	ff 75 08             	pushl  0x8(%ebp)
80102b13:	e8 2a 00 00 00       	call   80102b42 <freerange>
80102b18:	83 c4 10             	add    $0x10,%esp
}
80102b1b:	90                   	nop
80102b1c:	c9                   	leave  
80102b1d:	c3                   	ret    

80102b1e <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102b1e:	55                   	push   %ebp
80102b1f:	89 e5                	mov    %esp,%ebp
80102b21:	83 ec 08             	sub    $0x8,%esp
  freerange(vstart, vend);
80102b24:	83 ec 08             	sub    $0x8,%esp
80102b27:	ff 75 0c             	pushl  0xc(%ebp)
80102b2a:	ff 75 08             	pushl  0x8(%ebp)
80102b2d:	e8 10 00 00 00       	call   80102b42 <freerange>
80102b32:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 1;
80102b35:	c7 05 74 32 11 80 01 	movl   $0x1,0x80113274
80102b3c:	00 00 00 
}
80102b3f:	90                   	nop
80102b40:	c9                   	leave  
80102b41:	c3                   	ret    

80102b42 <freerange>:

void
freerange(void *vstart, void *vend)
{
80102b42:	55                   	push   %ebp
80102b43:	89 e5                	mov    %esp,%ebp
80102b45:	83 ec 18             	sub    $0x18,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102b48:	8b 45 08             	mov    0x8(%ebp),%eax
80102b4b:	05 ff 0f 00 00       	add    $0xfff,%eax
80102b50:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102b55:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b58:	eb 15                	jmp    80102b6f <freerange+0x2d>
    kfree(p);
80102b5a:	83 ec 0c             	sub    $0xc,%esp
80102b5d:	ff 75 f4             	pushl  -0xc(%ebp)
80102b60:	e8 1a 00 00 00       	call   80102b7f <kfree>
80102b65:	83 c4 10             	add    $0x10,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b68:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102b6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b72:	05 00 10 00 00       	add    $0x1000,%eax
80102b77:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102b7a:	76 de                	jbe    80102b5a <freerange+0x18>
    kfree(p);
}
80102b7c:	90                   	nop
80102b7d:	c9                   	leave  
80102b7e:	c3                   	ret    

80102b7f <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102b7f:	55                   	push   %ebp
80102b80:	89 e5                	mov    %esp,%ebp
80102b82:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102b85:	8b 45 08             	mov    0x8(%ebp),%eax
80102b88:	25 ff 0f 00 00       	and    $0xfff,%eax
80102b8d:	85 c0                	test   %eax,%eax
80102b8f:	75 1b                	jne    80102bac <kfree+0x2d>
80102b91:	81 7d 08 60 65 11 80 	cmpl   $0x80116560,0x8(%ebp)
80102b98:	72 12                	jb     80102bac <kfree+0x2d>
80102b9a:	ff 75 08             	pushl  0x8(%ebp)
80102b9d:	e8 36 ff ff ff       	call   80102ad8 <v2p>
80102ba2:	83 c4 04             	add    $0x4,%esp
80102ba5:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102baa:	76 0d                	jbe    80102bb9 <kfree+0x3a>
    panic("kfree");
80102bac:	83 ec 0c             	sub    $0xc,%esp
80102baf:	68 27 8f 10 80       	push   $0x80108f27
80102bb4:	e8 ad d9 ff ff       	call   80100566 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102bb9:	83 ec 04             	sub    $0x4,%esp
80102bbc:	68 00 10 00 00       	push   $0x1000
80102bc1:	6a 01                	push   $0x1
80102bc3:	ff 75 08             	pushl  0x8(%ebp)
80102bc6:	e8 08 2c 00 00       	call   801057d3 <memset>
80102bcb:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102bce:	a1 74 32 11 80       	mov    0x80113274,%eax
80102bd3:	85 c0                	test   %eax,%eax
80102bd5:	74 10                	je     80102be7 <kfree+0x68>
    acquire(&kmem.lock);
80102bd7:	83 ec 0c             	sub    $0xc,%esp
80102bda:	68 40 32 11 80       	push   $0x80113240
80102bdf:	e8 8c 29 00 00       	call   80105570 <acquire>
80102be4:	83 c4 10             	add    $0x10,%esp
  numfreepages++;
80102be7:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102bec:	83 c0 01             	add    $0x1,%eax
80102bef:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  r = (struct run*)v;
80102bf4:	8b 45 08             	mov    0x8(%ebp),%eax
80102bf7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102bfa:	8b 15 78 32 11 80    	mov    0x80113278,%edx
80102c00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c03:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102c05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c08:	a3 78 32 11 80       	mov    %eax,0x80113278
  if(kmem.use_lock)
80102c0d:	a1 74 32 11 80       	mov    0x80113274,%eax
80102c12:	85 c0                	test   %eax,%eax
80102c14:	74 10                	je     80102c26 <kfree+0xa7>
    release(&kmem.lock);
80102c16:	83 ec 0c             	sub    $0xc,%esp
80102c19:	68 40 32 11 80       	push   $0x80113240
80102c1e:	e8 b4 29 00 00       	call   801055d7 <release>
80102c23:	83 c4 10             	add    $0x10,%esp
}
80102c26:	90                   	nop
80102c27:	c9                   	leave  
80102c28:	c3                   	ret    

80102c29 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102c29:	55                   	push   %ebp
80102c2a:	89 e5                	mov    %esp,%ebp
80102c2c:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if(kmem.use_lock)
80102c2f:	a1 74 32 11 80       	mov    0x80113274,%eax
80102c34:	85 c0                	test   %eax,%eax
80102c36:	74 10                	je     80102c48 <kalloc+0x1f>
    acquire(&kmem.lock);
80102c38:	83 ec 0c             	sub    $0xc,%esp
80102c3b:	68 40 32 11 80       	push   $0x80113240
80102c40:	e8 2b 29 00 00       	call   80105570 <acquire>
80102c45:	83 c4 10             	add    $0x10,%esp
  numfreepages--;
80102c48:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102c4d:	83 e8 01             	sub    $0x1,%eax
80102c50:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  r = kmem.freelist;
80102c55:	a1 78 32 11 80       	mov    0x80113278,%eax
80102c5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102c5d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102c61:	74 0a                	je     80102c6d <kalloc+0x44>
    kmem.freelist = r->next;
80102c63:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c66:	8b 00                	mov    (%eax),%eax
80102c68:	a3 78 32 11 80       	mov    %eax,0x80113278
  if(kmem.use_lock)
80102c6d:	a1 74 32 11 80       	mov    0x80113274,%eax
80102c72:	85 c0                	test   %eax,%eax
80102c74:	74 10                	je     80102c86 <kalloc+0x5d>
    release(&kmem.lock);
80102c76:	83 ec 0c             	sub    $0xc,%esp
80102c79:	68 40 32 11 80       	push   $0x80113240
80102c7e:	e8 54 29 00 00       	call   801055d7 <release>
80102c83:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
80102c86:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102c89:	c9                   	leave  
80102c8a:	c3                   	ret    

80102c8b <freemem>:

int freemem(){
80102c8b:	55                   	push   %ebp
80102c8c:	89 e5                	mov    %esp,%ebp
	return numfreepages;
80102c8e:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
}
80102c93:	5d                   	pop    %ebp
80102c94:	c3                   	ret    

80102c95 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102c95:	55                   	push   %ebp
80102c96:	89 e5                	mov    %esp,%ebp
80102c98:	83 ec 14             	sub    $0x14,%esp
80102c9b:	8b 45 08             	mov    0x8(%ebp),%eax
80102c9e:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ca2:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102ca6:	89 c2                	mov    %eax,%edx
80102ca8:	ec                   	in     (%dx),%al
80102ca9:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102cac:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102cb0:	c9                   	leave  
80102cb1:	c3                   	ret    

80102cb2 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102cb2:	55                   	push   %ebp
80102cb3:	89 e5                	mov    %esp,%ebp
80102cb5:	83 ec 10             	sub    $0x10,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102cb8:	6a 64                	push   $0x64
80102cba:	e8 d6 ff ff ff       	call   80102c95 <inb>
80102cbf:	83 c4 04             	add    $0x4,%esp
80102cc2:	0f b6 c0             	movzbl %al,%eax
80102cc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102cc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ccb:	83 e0 01             	and    $0x1,%eax
80102cce:	85 c0                	test   %eax,%eax
80102cd0:	75 0a                	jne    80102cdc <kbdgetc+0x2a>
    return -1;
80102cd2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102cd7:	e9 23 01 00 00       	jmp    80102dff <kbdgetc+0x14d>
  data = inb(KBDATAP);
80102cdc:	6a 60                	push   $0x60
80102cde:	e8 b2 ff ff ff       	call   80102c95 <inb>
80102ce3:	83 c4 04             	add    $0x4,%esp
80102ce6:	0f b6 c0             	movzbl %al,%eax
80102ce9:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102cec:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102cf3:	75 17                	jne    80102d0c <kbdgetc+0x5a>
    shift |= E0ESC;
80102cf5:	a1 60 c6 10 80       	mov    0x8010c660,%eax
80102cfa:	83 c8 40             	or     $0x40,%eax
80102cfd:	a3 60 c6 10 80       	mov    %eax,0x8010c660
    return 0;
80102d02:	b8 00 00 00 00       	mov    $0x0,%eax
80102d07:	e9 f3 00 00 00       	jmp    80102dff <kbdgetc+0x14d>
  } else if(data & 0x80){
80102d0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d0f:	25 80 00 00 00       	and    $0x80,%eax
80102d14:	85 c0                	test   %eax,%eax
80102d16:	74 45                	je     80102d5d <kbdgetc+0xab>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102d18:	a1 60 c6 10 80       	mov    0x8010c660,%eax
80102d1d:	83 e0 40             	and    $0x40,%eax
80102d20:	85 c0                	test   %eax,%eax
80102d22:	75 08                	jne    80102d2c <kbdgetc+0x7a>
80102d24:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d27:	83 e0 7f             	and    $0x7f,%eax
80102d2a:	eb 03                	jmp    80102d2f <kbdgetc+0x7d>
80102d2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d2f:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102d32:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d35:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102d3a:	0f b6 00             	movzbl (%eax),%eax
80102d3d:	83 c8 40             	or     $0x40,%eax
80102d40:	0f b6 c0             	movzbl %al,%eax
80102d43:	f7 d0                	not    %eax
80102d45:	89 c2                	mov    %eax,%edx
80102d47:	a1 60 c6 10 80       	mov    0x8010c660,%eax
80102d4c:	21 d0                	and    %edx,%eax
80102d4e:	a3 60 c6 10 80       	mov    %eax,0x8010c660
    return 0;
80102d53:	b8 00 00 00 00       	mov    $0x0,%eax
80102d58:	e9 a2 00 00 00       	jmp    80102dff <kbdgetc+0x14d>
  } else if(shift & E0ESC){
80102d5d:	a1 60 c6 10 80       	mov    0x8010c660,%eax
80102d62:	83 e0 40             	and    $0x40,%eax
80102d65:	85 c0                	test   %eax,%eax
80102d67:	74 14                	je     80102d7d <kbdgetc+0xcb>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102d69:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102d70:	a1 60 c6 10 80       	mov    0x8010c660,%eax
80102d75:	83 e0 bf             	and    $0xffffffbf,%eax
80102d78:	a3 60 c6 10 80       	mov    %eax,0x8010c660
  }

  shift |= shiftcode[data];
80102d7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d80:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102d85:	0f b6 00             	movzbl (%eax),%eax
80102d88:	0f b6 d0             	movzbl %al,%edx
80102d8b:	a1 60 c6 10 80       	mov    0x8010c660,%eax
80102d90:	09 d0                	or     %edx,%eax
80102d92:	a3 60 c6 10 80       	mov    %eax,0x8010c660
  shift ^= togglecode[data];
80102d97:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d9a:	05 20 a1 10 80       	add    $0x8010a120,%eax
80102d9f:	0f b6 00             	movzbl (%eax),%eax
80102da2:	0f b6 d0             	movzbl %al,%edx
80102da5:	a1 60 c6 10 80       	mov    0x8010c660,%eax
80102daa:	31 d0                	xor    %edx,%eax
80102dac:	a3 60 c6 10 80       	mov    %eax,0x8010c660
  c = charcode[shift & (CTL | SHIFT)][data];
80102db1:	a1 60 c6 10 80       	mov    0x8010c660,%eax
80102db6:	83 e0 03             	and    $0x3,%eax
80102db9:	8b 14 85 20 a5 10 80 	mov    -0x7fef5ae0(,%eax,4),%edx
80102dc0:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102dc3:	01 d0                	add    %edx,%eax
80102dc5:	0f b6 00             	movzbl (%eax),%eax
80102dc8:	0f b6 c0             	movzbl %al,%eax
80102dcb:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102dce:	a1 60 c6 10 80       	mov    0x8010c660,%eax
80102dd3:	83 e0 08             	and    $0x8,%eax
80102dd6:	85 c0                	test   %eax,%eax
80102dd8:	74 22                	je     80102dfc <kbdgetc+0x14a>
    if('a' <= c && c <= 'z')
80102dda:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102dde:	76 0c                	jbe    80102dec <kbdgetc+0x13a>
80102de0:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102de4:	77 06                	ja     80102dec <kbdgetc+0x13a>
      c += 'A' - 'a';
80102de6:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102dea:	eb 10                	jmp    80102dfc <kbdgetc+0x14a>
    else if('A' <= c && c <= 'Z')
80102dec:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102df0:	76 0a                	jbe    80102dfc <kbdgetc+0x14a>
80102df2:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102df6:	77 04                	ja     80102dfc <kbdgetc+0x14a>
      c += 'a' - 'A';
80102df8:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102dfc:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102dff:	c9                   	leave  
80102e00:	c3                   	ret    

80102e01 <kbdintr>:

void
kbdintr(void)
{
80102e01:	55                   	push   %ebp
80102e02:	89 e5                	mov    %esp,%ebp
80102e04:	83 ec 08             	sub    $0x8,%esp
  consoleintr(kbdgetc);
80102e07:	83 ec 0c             	sub    $0xc,%esp
80102e0a:	68 b2 2c 10 80       	push   $0x80102cb2
80102e0f:	e8 e5 d9 ff ff       	call   801007f9 <consoleintr>
80102e14:	83 c4 10             	add    $0x10,%esp
}
80102e17:	90                   	nop
80102e18:	c9                   	leave  
80102e19:	c3                   	ret    

80102e1a <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102e1a:	55                   	push   %ebp
80102e1b:	89 e5                	mov    %esp,%ebp
80102e1d:	83 ec 14             	sub    $0x14,%esp
80102e20:	8b 45 08             	mov    0x8(%ebp),%eax
80102e23:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e27:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102e2b:	89 c2                	mov    %eax,%edx
80102e2d:	ec                   	in     (%dx),%al
80102e2e:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102e31:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102e35:	c9                   	leave  
80102e36:	c3                   	ret    

80102e37 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80102e37:	55                   	push   %ebp
80102e38:	89 e5                	mov    %esp,%ebp
80102e3a:	83 ec 08             	sub    $0x8,%esp
80102e3d:	8b 55 08             	mov    0x8(%ebp),%edx
80102e40:	8b 45 0c             	mov    0xc(%ebp),%eax
80102e43:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102e47:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e4a:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102e4e:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102e52:	ee                   	out    %al,(%dx)
}
80102e53:	90                   	nop
80102e54:	c9                   	leave  
80102e55:	c3                   	ret    

80102e56 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80102e56:	55                   	push   %ebp
80102e57:	89 e5                	mov    %esp,%ebp
80102e59:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102e5c:	9c                   	pushf  
80102e5d:	58                   	pop    %eax
80102e5e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80102e61:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80102e64:	c9                   	leave  
80102e65:	c3                   	ret    

80102e66 <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80102e66:	55                   	push   %ebp
80102e67:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102e69:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102e6e:	8b 55 08             	mov    0x8(%ebp),%edx
80102e71:	c1 e2 02             	shl    $0x2,%edx
80102e74:	01 c2                	add    %eax,%edx
80102e76:	8b 45 0c             	mov    0xc(%ebp),%eax
80102e79:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102e7b:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102e80:	83 c0 20             	add    $0x20,%eax
80102e83:	8b 00                	mov    (%eax),%eax
}
80102e85:	90                   	nop
80102e86:	5d                   	pop    %ebp
80102e87:	c3                   	ret    

80102e88 <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
80102e88:	55                   	push   %ebp
80102e89:	89 e5                	mov    %esp,%ebp
  if(!lapic) 
80102e8b:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102e90:	85 c0                	test   %eax,%eax
80102e92:	0f 84 0b 01 00 00    	je     80102fa3 <lapicinit+0x11b>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102e98:	68 3f 01 00 00       	push   $0x13f
80102e9d:	6a 3c                	push   $0x3c
80102e9f:	e8 c2 ff ff ff       	call   80102e66 <lapicw>
80102ea4:	83 c4 08             	add    $0x8,%esp

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102ea7:	6a 0b                	push   $0xb
80102ea9:	68 f8 00 00 00       	push   $0xf8
80102eae:	e8 b3 ff ff ff       	call   80102e66 <lapicw>
80102eb3:	83 c4 08             	add    $0x8,%esp
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102eb6:	68 20 00 02 00       	push   $0x20020
80102ebb:	68 c8 00 00 00       	push   $0xc8
80102ec0:	e8 a1 ff ff ff       	call   80102e66 <lapicw>
80102ec5:	83 c4 08             	add    $0x8,%esp
  lapicw(TICR, 10000000); 
80102ec8:	68 80 96 98 00       	push   $0x989680
80102ecd:	68 e0 00 00 00       	push   $0xe0
80102ed2:	e8 8f ff ff ff       	call   80102e66 <lapicw>
80102ed7:	83 c4 08             	add    $0x8,%esp

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102eda:	68 00 00 01 00       	push   $0x10000
80102edf:	68 d4 00 00 00       	push   $0xd4
80102ee4:	e8 7d ff ff ff       	call   80102e66 <lapicw>
80102ee9:	83 c4 08             	add    $0x8,%esp
  lapicw(LINT1, MASKED);
80102eec:	68 00 00 01 00       	push   $0x10000
80102ef1:	68 d8 00 00 00       	push   $0xd8
80102ef6:	e8 6b ff ff ff       	call   80102e66 <lapicw>
80102efb:	83 c4 08             	add    $0x8,%esp

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102efe:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102f03:	83 c0 30             	add    $0x30,%eax
80102f06:	8b 00                	mov    (%eax),%eax
80102f08:	c1 e8 10             	shr    $0x10,%eax
80102f0b:	0f b6 c0             	movzbl %al,%eax
80102f0e:	83 f8 03             	cmp    $0x3,%eax
80102f11:	76 12                	jbe    80102f25 <lapicinit+0x9d>
    lapicw(PCINT, MASKED);
80102f13:	68 00 00 01 00       	push   $0x10000
80102f18:	68 d0 00 00 00       	push   $0xd0
80102f1d:	e8 44 ff ff ff       	call   80102e66 <lapicw>
80102f22:	83 c4 08             	add    $0x8,%esp

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102f25:	6a 33                	push   $0x33
80102f27:	68 dc 00 00 00       	push   $0xdc
80102f2c:	e8 35 ff ff ff       	call   80102e66 <lapicw>
80102f31:	83 c4 08             	add    $0x8,%esp

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102f34:	6a 00                	push   $0x0
80102f36:	68 a0 00 00 00       	push   $0xa0
80102f3b:	e8 26 ff ff ff       	call   80102e66 <lapicw>
80102f40:	83 c4 08             	add    $0x8,%esp
  lapicw(ESR, 0);
80102f43:	6a 00                	push   $0x0
80102f45:	68 a0 00 00 00       	push   $0xa0
80102f4a:	e8 17 ff ff ff       	call   80102e66 <lapicw>
80102f4f:	83 c4 08             	add    $0x8,%esp

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102f52:	6a 00                	push   $0x0
80102f54:	6a 2c                	push   $0x2c
80102f56:	e8 0b ff ff ff       	call   80102e66 <lapicw>
80102f5b:	83 c4 08             	add    $0x8,%esp

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102f5e:	6a 00                	push   $0x0
80102f60:	68 c4 00 00 00       	push   $0xc4
80102f65:	e8 fc fe ff ff       	call   80102e66 <lapicw>
80102f6a:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102f6d:	68 00 85 08 00       	push   $0x88500
80102f72:	68 c0 00 00 00       	push   $0xc0
80102f77:	e8 ea fe ff ff       	call   80102e66 <lapicw>
80102f7c:	83 c4 08             	add    $0x8,%esp
  while(lapic[ICRLO] & DELIVS)
80102f7f:	90                   	nop
80102f80:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102f85:	05 00 03 00 00       	add    $0x300,%eax
80102f8a:	8b 00                	mov    (%eax),%eax
80102f8c:	25 00 10 00 00       	and    $0x1000,%eax
80102f91:	85 c0                	test   %eax,%eax
80102f93:	75 eb                	jne    80102f80 <lapicinit+0xf8>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102f95:	6a 00                	push   $0x0
80102f97:	6a 20                	push   $0x20
80102f99:	e8 c8 fe ff ff       	call   80102e66 <lapicw>
80102f9e:	83 c4 08             	add    $0x8,%esp
80102fa1:	eb 01                	jmp    80102fa4 <lapicinit+0x11c>

void
lapicinit(void)
{
  if(!lapic) 
    return;
80102fa3:	90                   	nop
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102fa4:	c9                   	leave  
80102fa5:	c3                   	ret    

80102fa6 <cpunum>:

int
cpunum(void)
{
80102fa6:	55                   	push   %ebp
80102fa7:	89 e5                	mov    %esp,%ebp
80102fa9:	83 ec 08             	sub    $0x8,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80102fac:	e8 a5 fe ff ff       	call   80102e56 <readeflags>
80102fb1:	25 00 02 00 00       	and    $0x200,%eax
80102fb6:	85 c0                	test   %eax,%eax
80102fb8:	74 26                	je     80102fe0 <cpunum+0x3a>
    static int n;
    if(n++ == 0)
80102fba:	a1 64 c6 10 80       	mov    0x8010c664,%eax
80102fbf:	8d 50 01             	lea    0x1(%eax),%edx
80102fc2:	89 15 64 c6 10 80    	mov    %edx,0x8010c664
80102fc8:	85 c0                	test   %eax,%eax
80102fca:	75 14                	jne    80102fe0 <cpunum+0x3a>
      cprintf("cpu called from %x with interrupts enabled\n",
80102fcc:	8b 45 04             	mov    0x4(%ebp),%eax
80102fcf:	83 ec 08             	sub    $0x8,%esp
80102fd2:	50                   	push   %eax
80102fd3:	68 30 8f 10 80       	push   $0x80108f30
80102fd8:	e8 e9 d3 ff ff       	call   801003c6 <cprintf>
80102fdd:	83 c4 10             	add    $0x10,%esp
        __builtin_return_address(0));
  }

  if(lapic)
80102fe0:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102fe5:	85 c0                	test   %eax,%eax
80102fe7:	74 0f                	je     80102ff8 <cpunum+0x52>
    return lapic[ID]>>24;
80102fe9:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102fee:	83 c0 20             	add    $0x20,%eax
80102ff1:	8b 00                	mov    (%eax),%eax
80102ff3:	c1 e8 18             	shr    $0x18,%eax
80102ff6:	eb 05                	jmp    80102ffd <cpunum+0x57>
  return 0;
80102ff8:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102ffd:	c9                   	leave  
80102ffe:	c3                   	ret    

80102fff <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102fff:	55                   	push   %ebp
80103000:	89 e5                	mov    %esp,%ebp
  if(lapic)
80103002:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80103007:	85 c0                	test   %eax,%eax
80103009:	74 0c                	je     80103017 <lapiceoi+0x18>
    lapicw(EOI, 0);
8010300b:	6a 00                	push   $0x0
8010300d:	6a 2c                	push   $0x2c
8010300f:	e8 52 fe ff ff       	call   80102e66 <lapicw>
80103014:	83 c4 08             	add    $0x8,%esp
}
80103017:	90                   	nop
80103018:	c9                   	leave  
80103019:	c3                   	ret    

8010301a <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
8010301a:	55                   	push   %ebp
8010301b:	89 e5                	mov    %esp,%ebp
}
8010301d:	90                   	nop
8010301e:	5d                   	pop    %ebp
8010301f:	c3                   	ret    

80103020 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80103020:	55                   	push   %ebp
80103021:	89 e5                	mov    %esp,%ebp
80103023:	83 ec 14             	sub    $0x14,%esp
80103026:	8b 45 08             	mov    0x8(%ebp),%eax
80103029:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
8010302c:	6a 0f                	push   $0xf
8010302e:	6a 70                	push   $0x70
80103030:	e8 02 fe ff ff       	call   80102e37 <outb>
80103035:	83 c4 08             	add    $0x8,%esp
  outb(CMOS_PORT+1, 0x0A);
80103038:	6a 0a                	push   $0xa
8010303a:	6a 71                	push   $0x71
8010303c:	e8 f6 fd ff ff       	call   80102e37 <outb>
80103041:	83 c4 08             	add    $0x8,%esp
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80103044:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
8010304b:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010304e:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80103053:	8b 45 f8             	mov    -0x8(%ebp),%eax
80103056:	83 c0 02             	add    $0x2,%eax
80103059:	8b 55 0c             	mov    0xc(%ebp),%edx
8010305c:	c1 ea 04             	shr    $0x4,%edx
8010305f:	66 89 10             	mov    %dx,(%eax)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80103062:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80103066:	c1 e0 18             	shl    $0x18,%eax
80103069:	50                   	push   %eax
8010306a:	68 c4 00 00 00       	push   $0xc4
8010306f:	e8 f2 fd ff ff       	call   80102e66 <lapicw>
80103074:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80103077:	68 00 c5 00 00       	push   $0xc500
8010307c:	68 c0 00 00 00       	push   $0xc0
80103081:	e8 e0 fd ff ff       	call   80102e66 <lapicw>
80103086:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
80103089:	68 c8 00 00 00       	push   $0xc8
8010308e:	e8 87 ff ff ff       	call   8010301a <microdelay>
80103093:	83 c4 04             	add    $0x4,%esp
  lapicw(ICRLO, INIT | LEVEL);
80103096:	68 00 85 00 00       	push   $0x8500
8010309b:	68 c0 00 00 00       	push   $0xc0
801030a0:	e8 c1 fd ff ff       	call   80102e66 <lapicw>
801030a5:	83 c4 08             	add    $0x8,%esp
  microdelay(100);    // should be 10ms, but too slow in Bochs!
801030a8:	6a 64                	push   $0x64
801030aa:	e8 6b ff ff ff       	call   8010301a <microdelay>
801030af:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
801030b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801030b9:	eb 3d                	jmp    801030f8 <lapicstartap+0xd8>
    lapicw(ICRHI, apicid<<24);
801030bb:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
801030bf:	c1 e0 18             	shl    $0x18,%eax
801030c2:	50                   	push   %eax
801030c3:	68 c4 00 00 00       	push   $0xc4
801030c8:	e8 99 fd ff ff       	call   80102e66 <lapicw>
801030cd:	83 c4 08             	add    $0x8,%esp
    lapicw(ICRLO, STARTUP | (addr>>12));
801030d0:	8b 45 0c             	mov    0xc(%ebp),%eax
801030d3:	c1 e8 0c             	shr    $0xc,%eax
801030d6:	80 cc 06             	or     $0x6,%ah
801030d9:	50                   	push   %eax
801030da:	68 c0 00 00 00       	push   $0xc0
801030df:	e8 82 fd ff ff       	call   80102e66 <lapicw>
801030e4:	83 c4 08             	add    $0x8,%esp
    microdelay(200);
801030e7:	68 c8 00 00 00       	push   $0xc8
801030ec:	e8 29 ff ff ff       	call   8010301a <microdelay>
801030f1:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
801030f4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801030f8:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
801030fc:	7e bd                	jle    801030bb <lapicstartap+0x9b>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
801030fe:	90                   	nop
801030ff:	c9                   	leave  
80103100:	c3                   	ret    

80103101 <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
80103101:	55                   	push   %ebp
80103102:	89 e5                	mov    %esp,%ebp
  outb(CMOS_PORT,  reg);
80103104:	8b 45 08             	mov    0x8(%ebp),%eax
80103107:	0f b6 c0             	movzbl %al,%eax
8010310a:	50                   	push   %eax
8010310b:	6a 70                	push   $0x70
8010310d:	e8 25 fd ff ff       	call   80102e37 <outb>
80103112:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
80103115:	68 c8 00 00 00       	push   $0xc8
8010311a:	e8 fb fe ff ff       	call   8010301a <microdelay>
8010311f:	83 c4 04             	add    $0x4,%esp

  return inb(CMOS_RETURN);
80103122:	6a 71                	push   $0x71
80103124:	e8 f1 fc ff ff       	call   80102e1a <inb>
80103129:	83 c4 04             	add    $0x4,%esp
8010312c:	0f b6 c0             	movzbl %al,%eax
}
8010312f:	c9                   	leave  
80103130:	c3                   	ret    

80103131 <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
80103131:	55                   	push   %ebp
80103132:	89 e5                	mov    %esp,%ebp
  r->second = cmos_read(SECS);
80103134:	6a 00                	push   $0x0
80103136:	e8 c6 ff ff ff       	call   80103101 <cmos_read>
8010313b:	83 c4 04             	add    $0x4,%esp
8010313e:	89 c2                	mov    %eax,%edx
80103140:	8b 45 08             	mov    0x8(%ebp),%eax
80103143:	89 10                	mov    %edx,(%eax)
  r->minute = cmos_read(MINS);
80103145:	6a 02                	push   $0x2
80103147:	e8 b5 ff ff ff       	call   80103101 <cmos_read>
8010314c:	83 c4 04             	add    $0x4,%esp
8010314f:	89 c2                	mov    %eax,%edx
80103151:	8b 45 08             	mov    0x8(%ebp),%eax
80103154:	89 50 04             	mov    %edx,0x4(%eax)
  r->hour   = cmos_read(HOURS);
80103157:	6a 04                	push   $0x4
80103159:	e8 a3 ff ff ff       	call   80103101 <cmos_read>
8010315e:	83 c4 04             	add    $0x4,%esp
80103161:	89 c2                	mov    %eax,%edx
80103163:	8b 45 08             	mov    0x8(%ebp),%eax
80103166:	89 50 08             	mov    %edx,0x8(%eax)
  r->day    = cmos_read(DAY);
80103169:	6a 07                	push   $0x7
8010316b:	e8 91 ff ff ff       	call   80103101 <cmos_read>
80103170:	83 c4 04             	add    $0x4,%esp
80103173:	89 c2                	mov    %eax,%edx
80103175:	8b 45 08             	mov    0x8(%ebp),%eax
80103178:	89 50 0c             	mov    %edx,0xc(%eax)
  r->month  = cmos_read(MONTH);
8010317b:	6a 08                	push   $0x8
8010317d:	e8 7f ff ff ff       	call   80103101 <cmos_read>
80103182:	83 c4 04             	add    $0x4,%esp
80103185:	89 c2                	mov    %eax,%edx
80103187:	8b 45 08             	mov    0x8(%ebp),%eax
8010318a:	89 50 10             	mov    %edx,0x10(%eax)
  r->year   = cmos_read(YEAR);
8010318d:	6a 09                	push   $0x9
8010318f:	e8 6d ff ff ff       	call   80103101 <cmos_read>
80103194:	83 c4 04             	add    $0x4,%esp
80103197:	89 c2                	mov    %eax,%edx
80103199:	8b 45 08             	mov    0x8(%ebp),%eax
8010319c:	89 50 14             	mov    %edx,0x14(%eax)
}
8010319f:	90                   	nop
801031a0:	c9                   	leave  
801031a1:	c3                   	ret    

801031a2 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
801031a2:	55                   	push   %ebp
801031a3:	89 e5                	mov    %esp,%ebp
801031a5:	83 ec 48             	sub    $0x48,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
801031a8:	6a 0b                	push   $0xb
801031aa:	e8 52 ff ff ff       	call   80103101 <cmos_read>
801031af:	83 c4 04             	add    $0x4,%esp
801031b2:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
801031b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801031b8:	83 e0 04             	and    $0x4,%eax
801031bb:	85 c0                	test   %eax,%eax
801031bd:	0f 94 c0             	sete   %al
801031c0:	0f b6 c0             	movzbl %al,%eax
801031c3:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
801031c6:	8d 45 d8             	lea    -0x28(%ebp),%eax
801031c9:	50                   	push   %eax
801031ca:	e8 62 ff ff ff       	call   80103131 <fill_rtcdate>
801031cf:	83 c4 04             	add    $0x4,%esp
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
801031d2:	6a 0a                	push   $0xa
801031d4:	e8 28 ff ff ff       	call   80103101 <cmos_read>
801031d9:	83 c4 04             	add    $0x4,%esp
801031dc:	25 80 00 00 00       	and    $0x80,%eax
801031e1:	85 c0                	test   %eax,%eax
801031e3:	75 27                	jne    8010320c <cmostime+0x6a>
        continue;
    fill_rtcdate(&t2);
801031e5:	8d 45 c0             	lea    -0x40(%ebp),%eax
801031e8:	50                   	push   %eax
801031e9:	e8 43 ff ff ff       	call   80103131 <fill_rtcdate>
801031ee:	83 c4 04             	add    $0x4,%esp
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
801031f1:	83 ec 04             	sub    $0x4,%esp
801031f4:	6a 18                	push   $0x18
801031f6:	8d 45 c0             	lea    -0x40(%ebp),%eax
801031f9:	50                   	push   %eax
801031fa:	8d 45 d8             	lea    -0x28(%ebp),%eax
801031fd:	50                   	push   %eax
801031fe:	e8 37 26 00 00       	call   8010583a <memcmp>
80103203:	83 c4 10             	add    $0x10,%esp
80103206:	85 c0                	test   %eax,%eax
80103208:	74 05                	je     8010320f <cmostime+0x6d>
8010320a:	eb ba                	jmp    801031c6 <cmostime+0x24>

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
8010320c:	90                   	nop
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
  }
8010320d:	eb b7                	jmp    801031c6 <cmostime+0x24>
    fill_rtcdate(&t1);
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
8010320f:	90                   	nop
  }

  // convert
  if (bcd) {
80103210:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103214:	0f 84 b4 00 00 00    	je     801032ce <cmostime+0x12c>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010321a:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010321d:	c1 e8 04             	shr    $0x4,%eax
80103220:	89 c2                	mov    %eax,%edx
80103222:	89 d0                	mov    %edx,%eax
80103224:	c1 e0 02             	shl    $0x2,%eax
80103227:	01 d0                	add    %edx,%eax
80103229:	01 c0                	add    %eax,%eax
8010322b:	89 c2                	mov    %eax,%edx
8010322d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103230:	83 e0 0f             	and    $0xf,%eax
80103233:	01 d0                	add    %edx,%eax
80103235:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
80103238:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010323b:	c1 e8 04             	shr    $0x4,%eax
8010323e:	89 c2                	mov    %eax,%edx
80103240:	89 d0                	mov    %edx,%eax
80103242:	c1 e0 02             	shl    $0x2,%eax
80103245:	01 d0                	add    %edx,%eax
80103247:	01 c0                	add    %eax,%eax
80103249:	89 c2                	mov    %eax,%edx
8010324b:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010324e:	83 e0 0f             	and    $0xf,%eax
80103251:	01 d0                	add    %edx,%eax
80103253:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
80103256:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103259:	c1 e8 04             	shr    $0x4,%eax
8010325c:	89 c2                	mov    %eax,%edx
8010325e:	89 d0                	mov    %edx,%eax
80103260:	c1 e0 02             	shl    $0x2,%eax
80103263:	01 d0                	add    %edx,%eax
80103265:	01 c0                	add    %eax,%eax
80103267:	89 c2                	mov    %eax,%edx
80103269:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010326c:	83 e0 0f             	and    $0xf,%eax
8010326f:	01 d0                	add    %edx,%eax
80103271:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
80103274:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103277:	c1 e8 04             	shr    $0x4,%eax
8010327a:	89 c2                	mov    %eax,%edx
8010327c:	89 d0                	mov    %edx,%eax
8010327e:	c1 e0 02             	shl    $0x2,%eax
80103281:	01 d0                	add    %edx,%eax
80103283:	01 c0                	add    %eax,%eax
80103285:	89 c2                	mov    %eax,%edx
80103287:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010328a:	83 e0 0f             	and    $0xf,%eax
8010328d:	01 d0                	add    %edx,%eax
8010328f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
80103292:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103295:	c1 e8 04             	shr    $0x4,%eax
80103298:	89 c2                	mov    %eax,%edx
8010329a:	89 d0                	mov    %edx,%eax
8010329c:	c1 e0 02             	shl    $0x2,%eax
8010329f:	01 d0                	add    %edx,%eax
801032a1:	01 c0                	add    %eax,%eax
801032a3:	89 c2                	mov    %eax,%edx
801032a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
801032a8:	83 e0 0f             	and    $0xf,%eax
801032ab:	01 d0                	add    %edx,%eax
801032ad:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
801032b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801032b3:	c1 e8 04             	shr    $0x4,%eax
801032b6:	89 c2                	mov    %eax,%edx
801032b8:	89 d0                	mov    %edx,%eax
801032ba:	c1 e0 02             	shl    $0x2,%eax
801032bd:	01 d0                	add    %edx,%eax
801032bf:	01 c0                	add    %eax,%eax
801032c1:	89 c2                	mov    %eax,%edx
801032c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801032c6:	83 e0 0f             	and    $0xf,%eax
801032c9:	01 d0                	add    %edx,%eax
801032cb:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
801032ce:	8b 45 08             	mov    0x8(%ebp),%eax
801032d1:	8b 55 d8             	mov    -0x28(%ebp),%edx
801032d4:	89 10                	mov    %edx,(%eax)
801032d6:	8b 55 dc             	mov    -0x24(%ebp),%edx
801032d9:	89 50 04             	mov    %edx,0x4(%eax)
801032dc:	8b 55 e0             	mov    -0x20(%ebp),%edx
801032df:	89 50 08             	mov    %edx,0x8(%eax)
801032e2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801032e5:	89 50 0c             	mov    %edx,0xc(%eax)
801032e8:	8b 55 e8             	mov    -0x18(%ebp),%edx
801032eb:	89 50 10             	mov    %edx,0x10(%eax)
801032ee:	8b 55 ec             	mov    -0x14(%ebp),%edx
801032f1:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
801032f4:	8b 45 08             	mov    0x8(%ebp),%eax
801032f7:	8b 40 14             	mov    0x14(%eax),%eax
801032fa:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
80103300:	8b 45 08             	mov    0x8(%ebp),%eax
80103303:	89 50 14             	mov    %edx,0x14(%eax)
}
80103306:	90                   	nop
80103307:	c9                   	leave  
80103308:	c3                   	ret    

80103309 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80103309:	55                   	push   %ebp
8010330a:	89 e5                	mov    %esp,%ebp
8010330c:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
8010330f:	83 ec 08             	sub    $0x8,%esp
80103312:	68 5c 8f 10 80       	push   $0x80108f5c
80103317:	68 80 32 11 80       	push   $0x80113280
8010331c:	e8 2d 22 00 00       	call   8010554e <initlock>
80103321:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
80103324:	83 ec 08             	sub    $0x8,%esp
80103327:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010332a:	50                   	push   %eax
8010332b:	ff 75 08             	pushl  0x8(%ebp)
8010332e:	e8 51 e0 ff ff       	call   80101384 <readsb>
80103333:	83 c4 10             	add    $0x10,%esp
  log.start = sb.logstart;
80103336:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103339:	a3 b4 32 11 80       	mov    %eax,0x801132b4
  log.size = sb.nlog;
8010333e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103341:	a3 b8 32 11 80       	mov    %eax,0x801132b8
  log.dev = dev;
80103346:	8b 45 08             	mov    0x8(%ebp),%eax
80103349:	a3 c4 32 11 80       	mov    %eax,0x801132c4
  recover_from_log();
8010334e:	e8 b2 01 00 00       	call   80103505 <recover_from_log>
}
80103353:	90                   	nop
80103354:	c9                   	leave  
80103355:	c3                   	ret    

80103356 <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
80103356:	55                   	push   %ebp
80103357:	89 e5                	mov    %esp,%ebp
80103359:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010335c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103363:	e9 95 00 00 00       	jmp    801033fd <install_trans+0xa7>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103368:	8b 15 b4 32 11 80    	mov    0x801132b4,%edx
8010336e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103371:	01 d0                	add    %edx,%eax
80103373:	83 c0 01             	add    $0x1,%eax
80103376:	89 c2                	mov    %eax,%edx
80103378:	a1 c4 32 11 80       	mov    0x801132c4,%eax
8010337d:	83 ec 08             	sub    $0x8,%esp
80103380:	52                   	push   %edx
80103381:	50                   	push   %eax
80103382:	e8 2f ce ff ff       	call   801001b6 <bread>
80103387:	83 c4 10             	add    $0x10,%esp
8010338a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010338d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103390:	83 c0 10             	add    $0x10,%eax
80103393:	8b 04 85 8c 32 11 80 	mov    -0x7feecd74(,%eax,4),%eax
8010339a:	89 c2                	mov    %eax,%edx
8010339c:	a1 c4 32 11 80       	mov    0x801132c4,%eax
801033a1:	83 ec 08             	sub    $0x8,%esp
801033a4:	52                   	push   %edx
801033a5:	50                   	push   %eax
801033a6:	e8 0b ce ff ff       	call   801001b6 <bread>
801033ab:	83 c4 10             	add    $0x10,%esp
801033ae:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801033b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801033b4:	8d 50 18             	lea    0x18(%eax),%edx
801033b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033ba:	83 c0 18             	add    $0x18,%eax
801033bd:	83 ec 04             	sub    $0x4,%esp
801033c0:	68 00 02 00 00       	push   $0x200
801033c5:	52                   	push   %edx
801033c6:	50                   	push   %eax
801033c7:	e8 c6 24 00 00       	call   80105892 <memmove>
801033cc:	83 c4 10             	add    $0x10,%esp
    bwrite(dbuf);  // write dst to disk
801033cf:	83 ec 0c             	sub    $0xc,%esp
801033d2:	ff 75 ec             	pushl  -0x14(%ebp)
801033d5:	e8 15 ce ff ff       	call   801001ef <bwrite>
801033da:	83 c4 10             	add    $0x10,%esp
    brelse(lbuf); 
801033dd:	83 ec 0c             	sub    $0xc,%esp
801033e0:	ff 75 f0             	pushl  -0x10(%ebp)
801033e3:	e8 46 ce ff ff       	call   8010022e <brelse>
801033e8:	83 c4 10             	add    $0x10,%esp
    brelse(dbuf);
801033eb:	83 ec 0c             	sub    $0xc,%esp
801033ee:	ff 75 ec             	pushl  -0x14(%ebp)
801033f1:	e8 38 ce ff ff       	call   8010022e <brelse>
801033f6:	83 c4 10             	add    $0x10,%esp
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801033f9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801033fd:	a1 c8 32 11 80       	mov    0x801132c8,%eax
80103402:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103405:	0f 8f 5d ff ff ff    	jg     80103368 <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
8010340b:	90                   	nop
8010340c:	c9                   	leave  
8010340d:	c3                   	ret    

8010340e <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
8010340e:	55                   	push   %ebp
8010340f:	89 e5                	mov    %esp,%ebp
80103411:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
80103414:	a1 b4 32 11 80       	mov    0x801132b4,%eax
80103419:	89 c2                	mov    %eax,%edx
8010341b:	a1 c4 32 11 80       	mov    0x801132c4,%eax
80103420:	83 ec 08             	sub    $0x8,%esp
80103423:	52                   	push   %edx
80103424:	50                   	push   %eax
80103425:	e8 8c cd ff ff       	call   801001b6 <bread>
8010342a:	83 c4 10             	add    $0x10,%esp
8010342d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
80103430:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103433:	83 c0 18             	add    $0x18,%eax
80103436:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
80103439:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010343c:	8b 00                	mov    (%eax),%eax
8010343e:	a3 c8 32 11 80       	mov    %eax,0x801132c8
  for (i = 0; i < log.lh.n; i++) {
80103443:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010344a:	eb 1b                	jmp    80103467 <read_head+0x59>
    log.lh.block[i] = lh->block[i];
8010344c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010344f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103452:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80103456:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103459:	83 c2 10             	add    $0x10,%edx
8010345c:	89 04 95 8c 32 11 80 	mov    %eax,-0x7feecd74(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80103463:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103467:	a1 c8 32 11 80       	mov    0x801132c8,%eax
8010346c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010346f:	7f db                	jg     8010344c <read_head+0x3e>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80103471:	83 ec 0c             	sub    $0xc,%esp
80103474:	ff 75 f0             	pushl  -0x10(%ebp)
80103477:	e8 b2 cd ff ff       	call   8010022e <brelse>
8010347c:	83 c4 10             	add    $0x10,%esp
}
8010347f:	90                   	nop
80103480:	c9                   	leave  
80103481:	c3                   	ret    

80103482 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103482:	55                   	push   %ebp
80103483:	89 e5                	mov    %esp,%ebp
80103485:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
80103488:	a1 b4 32 11 80       	mov    0x801132b4,%eax
8010348d:	89 c2                	mov    %eax,%edx
8010348f:	a1 c4 32 11 80       	mov    0x801132c4,%eax
80103494:	83 ec 08             	sub    $0x8,%esp
80103497:	52                   	push   %edx
80103498:	50                   	push   %eax
80103499:	e8 18 cd ff ff       	call   801001b6 <bread>
8010349e:	83 c4 10             	add    $0x10,%esp
801034a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
801034a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801034a7:	83 c0 18             	add    $0x18,%eax
801034aa:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
801034ad:	8b 15 c8 32 11 80    	mov    0x801132c8,%edx
801034b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801034b6:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
801034b8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801034bf:	eb 1b                	jmp    801034dc <write_head+0x5a>
    hb->block[i] = log.lh.block[i];
801034c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801034c4:	83 c0 10             	add    $0x10,%eax
801034c7:	8b 0c 85 8c 32 11 80 	mov    -0x7feecd74(,%eax,4),%ecx
801034ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
801034d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801034d4:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
801034d8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801034dc:	a1 c8 32 11 80       	mov    0x801132c8,%eax
801034e1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801034e4:	7f db                	jg     801034c1 <write_head+0x3f>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
801034e6:	83 ec 0c             	sub    $0xc,%esp
801034e9:	ff 75 f0             	pushl  -0x10(%ebp)
801034ec:	e8 fe cc ff ff       	call   801001ef <bwrite>
801034f1:	83 c4 10             	add    $0x10,%esp
  brelse(buf);
801034f4:	83 ec 0c             	sub    $0xc,%esp
801034f7:	ff 75 f0             	pushl  -0x10(%ebp)
801034fa:	e8 2f cd ff ff       	call   8010022e <brelse>
801034ff:	83 c4 10             	add    $0x10,%esp
}
80103502:	90                   	nop
80103503:	c9                   	leave  
80103504:	c3                   	ret    

80103505 <recover_from_log>:

static void
recover_from_log(void)
{
80103505:	55                   	push   %ebp
80103506:	89 e5                	mov    %esp,%ebp
80103508:	83 ec 08             	sub    $0x8,%esp
  read_head();      
8010350b:	e8 fe fe ff ff       	call   8010340e <read_head>
  install_trans(); // if committed, copy from log to disk
80103510:	e8 41 fe ff ff       	call   80103356 <install_trans>
  log.lh.n = 0;
80103515:	c7 05 c8 32 11 80 00 	movl   $0x0,0x801132c8
8010351c:	00 00 00 
  write_head(); // clear the log
8010351f:	e8 5e ff ff ff       	call   80103482 <write_head>
}
80103524:	90                   	nop
80103525:	c9                   	leave  
80103526:	c3                   	ret    

80103527 <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
80103527:	55                   	push   %ebp
80103528:	89 e5                	mov    %esp,%ebp
8010352a:	83 ec 08             	sub    $0x8,%esp
  acquire(&log.lock);
8010352d:	83 ec 0c             	sub    $0xc,%esp
80103530:	68 80 32 11 80       	push   $0x80113280
80103535:	e8 36 20 00 00       	call   80105570 <acquire>
8010353a:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
8010353d:	a1 c0 32 11 80       	mov    0x801132c0,%eax
80103542:	85 c0                	test   %eax,%eax
80103544:	74 17                	je     8010355d <begin_op+0x36>
      sleep(&log, &log.lock);
80103546:	83 ec 08             	sub    $0x8,%esp
80103549:	68 80 32 11 80       	push   $0x80113280
8010354e:	68 80 32 11 80       	push   $0x80113280
80103553:	e8 08 1d 00 00       	call   80105260 <sleep>
80103558:	83 c4 10             	add    $0x10,%esp
8010355b:	eb e0                	jmp    8010353d <begin_op+0x16>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
8010355d:	8b 0d c8 32 11 80    	mov    0x801132c8,%ecx
80103563:	a1 bc 32 11 80       	mov    0x801132bc,%eax
80103568:	8d 50 01             	lea    0x1(%eax),%edx
8010356b:	89 d0                	mov    %edx,%eax
8010356d:	c1 e0 02             	shl    $0x2,%eax
80103570:	01 d0                	add    %edx,%eax
80103572:	01 c0                	add    %eax,%eax
80103574:	01 c8                	add    %ecx,%eax
80103576:	83 f8 1e             	cmp    $0x1e,%eax
80103579:	7e 17                	jle    80103592 <begin_op+0x6b>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
8010357b:	83 ec 08             	sub    $0x8,%esp
8010357e:	68 80 32 11 80       	push   $0x80113280
80103583:	68 80 32 11 80       	push   $0x80113280
80103588:	e8 d3 1c 00 00       	call   80105260 <sleep>
8010358d:	83 c4 10             	add    $0x10,%esp
80103590:	eb ab                	jmp    8010353d <begin_op+0x16>
    } else {
      log.outstanding += 1;
80103592:	a1 bc 32 11 80       	mov    0x801132bc,%eax
80103597:	83 c0 01             	add    $0x1,%eax
8010359a:	a3 bc 32 11 80       	mov    %eax,0x801132bc
      release(&log.lock);
8010359f:	83 ec 0c             	sub    $0xc,%esp
801035a2:	68 80 32 11 80       	push   $0x80113280
801035a7:	e8 2b 20 00 00       	call   801055d7 <release>
801035ac:	83 c4 10             	add    $0x10,%esp
      break;
801035af:	90                   	nop
    }
  }
}
801035b0:	90                   	nop
801035b1:	c9                   	leave  
801035b2:	c3                   	ret    

801035b3 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
801035b3:	55                   	push   %ebp
801035b4:	89 e5                	mov    %esp,%ebp
801035b6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;
801035b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
801035c0:	83 ec 0c             	sub    $0xc,%esp
801035c3:	68 80 32 11 80       	push   $0x80113280
801035c8:	e8 a3 1f 00 00       	call   80105570 <acquire>
801035cd:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
801035d0:	a1 bc 32 11 80       	mov    0x801132bc,%eax
801035d5:	83 e8 01             	sub    $0x1,%eax
801035d8:	a3 bc 32 11 80       	mov    %eax,0x801132bc
  if(log.committing)
801035dd:	a1 c0 32 11 80       	mov    0x801132c0,%eax
801035e2:	85 c0                	test   %eax,%eax
801035e4:	74 0d                	je     801035f3 <end_op+0x40>
    panic("log.committing");
801035e6:	83 ec 0c             	sub    $0xc,%esp
801035e9:	68 60 8f 10 80       	push   $0x80108f60
801035ee:	e8 73 cf ff ff       	call   80100566 <panic>
  if(log.outstanding == 0){
801035f3:	a1 bc 32 11 80       	mov    0x801132bc,%eax
801035f8:	85 c0                	test   %eax,%eax
801035fa:	75 13                	jne    8010360f <end_op+0x5c>
    do_commit = 1;
801035fc:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
80103603:	c7 05 c0 32 11 80 01 	movl   $0x1,0x801132c0
8010360a:	00 00 00 
8010360d:	eb 10                	jmp    8010361f <end_op+0x6c>
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
8010360f:	83 ec 0c             	sub    $0xc,%esp
80103612:	68 80 32 11 80       	push   $0x80113280
80103617:	e8 32 1d 00 00       	call   8010534e <wakeup>
8010361c:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
8010361f:	83 ec 0c             	sub    $0xc,%esp
80103622:	68 80 32 11 80       	push   $0x80113280
80103627:	e8 ab 1f 00 00       	call   801055d7 <release>
8010362c:	83 c4 10             	add    $0x10,%esp

  if(do_commit){
8010362f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103633:	74 3f                	je     80103674 <end_op+0xc1>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
80103635:	e8 f5 00 00 00       	call   8010372f <commit>
    acquire(&log.lock);
8010363a:	83 ec 0c             	sub    $0xc,%esp
8010363d:	68 80 32 11 80       	push   $0x80113280
80103642:	e8 29 1f 00 00       	call   80105570 <acquire>
80103647:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
8010364a:	c7 05 c0 32 11 80 00 	movl   $0x0,0x801132c0
80103651:	00 00 00 
    wakeup(&log);
80103654:	83 ec 0c             	sub    $0xc,%esp
80103657:	68 80 32 11 80       	push   $0x80113280
8010365c:	e8 ed 1c 00 00       	call   8010534e <wakeup>
80103661:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
80103664:	83 ec 0c             	sub    $0xc,%esp
80103667:	68 80 32 11 80       	push   $0x80113280
8010366c:	e8 66 1f 00 00       	call   801055d7 <release>
80103671:	83 c4 10             	add    $0x10,%esp
  }
}
80103674:	90                   	nop
80103675:	c9                   	leave  
80103676:	c3                   	ret    

80103677 <write_log>:

// Copy modified blocks from cache to log.
static void 
write_log(void)
{
80103677:	55                   	push   %ebp
80103678:	89 e5                	mov    %esp,%ebp
8010367a:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010367d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103684:	e9 95 00 00 00       	jmp    8010371e <write_log+0xa7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103689:	8b 15 b4 32 11 80    	mov    0x801132b4,%edx
8010368f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103692:	01 d0                	add    %edx,%eax
80103694:	83 c0 01             	add    $0x1,%eax
80103697:	89 c2                	mov    %eax,%edx
80103699:	a1 c4 32 11 80       	mov    0x801132c4,%eax
8010369e:	83 ec 08             	sub    $0x8,%esp
801036a1:	52                   	push   %edx
801036a2:	50                   	push   %eax
801036a3:	e8 0e cb ff ff       	call   801001b6 <bread>
801036a8:	83 c4 10             	add    $0x10,%esp
801036ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801036ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036b1:	83 c0 10             	add    $0x10,%eax
801036b4:	8b 04 85 8c 32 11 80 	mov    -0x7feecd74(,%eax,4),%eax
801036bb:	89 c2                	mov    %eax,%edx
801036bd:	a1 c4 32 11 80       	mov    0x801132c4,%eax
801036c2:	83 ec 08             	sub    $0x8,%esp
801036c5:	52                   	push   %edx
801036c6:	50                   	push   %eax
801036c7:	e8 ea ca ff ff       	call   801001b6 <bread>
801036cc:	83 c4 10             	add    $0x10,%esp
801036cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
801036d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801036d5:	8d 50 18             	lea    0x18(%eax),%edx
801036d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801036db:	83 c0 18             	add    $0x18,%eax
801036de:	83 ec 04             	sub    $0x4,%esp
801036e1:	68 00 02 00 00       	push   $0x200
801036e6:	52                   	push   %edx
801036e7:	50                   	push   %eax
801036e8:	e8 a5 21 00 00       	call   80105892 <memmove>
801036ed:	83 c4 10             	add    $0x10,%esp
    bwrite(to);  // write the log
801036f0:	83 ec 0c             	sub    $0xc,%esp
801036f3:	ff 75 f0             	pushl  -0x10(%ebp)
801036f6:	e8 f4 ca ff ff       	call   801001ef <bwrite>
801036fb:	83 c4 10             	add    $0x10,%esp
    brelse(from); 
801036fe:	83 ec 0c             	sub    $0xc,%esp
80103701:	ff 75 ec             	pushl  -0x14(%ebp)
80103704:	e8 25 cb ff ff       	call   8010022e <brelse>
80103709:	83 c4 10             	add    $0x10,%esp
    brelse(to);
8010370c:	83 ec 0c             	sub    $0xc,%esp
8010370f:	ff 75 f0             	pushl  -0x10(%ebp)
80103712:	e8 17 cb ff ff       	call   8010022e <brelse>
80103717:	83 c4 10             	add    $0x10,%esp
static void 
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010371a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010371e:	a1 c8 32 11 80       	mov    0x801132c8,%eax
80103723:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103726:	0f 8f 5d ff ff ff    	jg     80103689 <write_log+0x12>
    memmove(to->data, from->data, BSIZE);
    bwrite(to);  // write the log
    brelse(from); 
    brelse(to);
  }
}
8010372c:	90                   	nop
8010372d:	c9                   	leave  
8010372e:	c3                   	ret    

8010372f <commit>:

static void
commit()
{
8010372f:	55                   	push   %ebp
80103730:	89 e5                	mov    %esp,%ebp
80103732:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
80103735:	a1 c8 32 11 80       	mov    0x801132c8,%eax
8010373a:	85 c0                	test   %eax,%eax
8010373c:	7e 1e                	jle    8010375c <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
8010373e:	e8 34 ff ff ff       	call   80103677 <write_log>
    write_head();    // Write header to disk -- the real commit
80103743:	e8 3a fd ff ff       	call   80103482 <write_head>
    install_trans(); // Now install writes to home locations
80103748:	e8 09 fc ff ff       	call   80103356 <install_trans>
    log.lh.n = 0; 
8010374d:	c7 05 c8 32 11 80 00 	movl   $0x0,0x801132c8
80103754:	00 00 00 
    write_head();    // Erase the transaction from the log
80103757:	e8 26 fd ff ff       	call   80103482 <write_head>
  }
}
8010375c:	90                   	nop
8010375d:	c9                   	leave  
8010375e:	c3                   	ret    

8010375f <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
8010375f:	55                   	push   %ebp
80103760:	89 e5                	mov    %esp,%ebp
80103762:	83 ec 18             	sub    $0x18,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103765:	a1 c8 32 11 80       	mov    0x801132c8,%eax
8010376a:	83 f8 1d             	cmp    $0x1d,%eax
8010376d:	7f 12                	jg     80103781 <log_write+0x22>
8010376f:	a1 c8 32 11 80       	mov    0x801132c8,%eax
80103774:	8b 15 b8 32 11 80    	mov    0x801132b8,%edx
8010377a:	83 ea 01             	sub    $0x1,%edx
8010377d:	39 d0                	cmp    %edx,%eax
8010377f:	7c 0d                	jl     8010378e <log_write+0x2f>
    panic("too big a transaction");
80103781:	83 ec 0c             	sub    $0xc,%esp
80103784:	68 6f 8f 10 80       	push   $0x80108f6f
80103789:	e8 d8 cd ff ff       	call   80100566 <panic>
  if (log.outstanding < 1)
8010378e:	a1 bc 32 11 80       	mov    0x801132bc,%eax
80103793:	85 c0                	test   %eax,%eax
80103795:	7f 0d                	jg     801037a4 <log_write+0x45>
    panic("log_write outside of trans");
80103797:	83 ec 0c             	sub    $0xc,%esp
8010379a:	68 85 8f 10 80       	push   $0x80108f85
8010379f:	e8 c2 cd ff ff       	call   80100566 <panic>

  acquire(&log.lock);
801037a4:	83 ec 0c             	sub    $0xc,%esp
801037a7:	68 80 32 11 80       	push   $0x80113280
801037ac:	e8 bf 1d 00 00       	call   80105570 <acquire>
801037b1:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < log.lh.n; i++) {
801037b4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801037bb:	eb 1d                	jmp    801037da <log_write+0x7b>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801037bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037c0:	83 c0 10             	add    $0x10,%eax
801037c3:	8b 04 85 8c 32 11 80 	mov    -0x7feecd74(,%eax,4),%eax
801037ca:	89 c2                	mov    %eax,%edx
801037cc:	8b 45 08             	mov    0x8(%ebp),%eax
801037cf:	8b 40 08             	mov    0x8(%eax),%eax
801037d2:	39 c2                	cmp    %eax,%edx
801037d4:	74 10                	je     801037e6 <log_write+0x87>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
801037d6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801037da:	a1 c8 32 11 80       	mov    0x801132c8,%eax
801037df:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801037e2:	7f d9                	jg     801037bd <log_write+0x5e>
801037e4:	eb 01                	jmp    801037e7 <log_write+0x88>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
801037e6:	90                   	nop
  }
  log.lh.block[i] = b->blockno;
801037e7:	8b 45 08             	mov    0x8(%ebp),%eax
801037ea:	8b 40 08             	mov    0x8(%eax),%eax
801037ed:	89 c2                	mov    %eax,%edx
801037ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037f2:	83 c0 10             	add    $0x10,%eax
801037f5:	89 14 85 8c 32 11 80 	mov    %edx,-0x7feecd74(,%eax,4)
  if (i == log.lh.n)
801037fc:	a1 c8 32 11 80       	mov    0x801132c8,%eax
80103801:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103804:	75 0d                	jne    80103813 <log_write+0xb4>
    log.lh.n++;
80103806:	a1 c8 32 11 80       	mov    0x801132c8,%eax
8010380b:	83 c0 01             	add    $0x1,%eax
8010380e:	a3 c8 32 11 80       	mov    %eax,0x801132c8
  b->flags |= B_DIRTY; // prevent eviction
80103813:	8b 45 08             	mov    0x8(%ebp),%eax
80103816:	8b 00                	mov    (%eax),%eax
80103818:	83 c8 04             	or     $0x4,%eax
8010381b:	89 c2                	mov    %eax,%edx
8010381d:	8b 45 08             	mov    0x8(%ebp),%eax
80103820:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
80103822:	83 ec 0c             	sub    $0xc,%esp
80103825:	68 80 32 11 80       	push   $0x80113280
8010382a:	e8 a8 1d 00 00       	call   801055d7 <release>
8010382f:	83 c4 10             	add    $0x10,%esp
}
80103832:	90                   	nop
80103833:	c9                   	leave  
80103834:	c3                   	ret    

80103835 <v2p>:
80103835:	55                   	push   %ebp
80103836:	89 e5                	mov    %esp,%ebp
80103838:	8b 45 08             	mov    0x8(%ebp),%eax
8010383b:	05 00 00 00 80       	add    $0x80000000,%eax
80103840:	5d                   	pop    %ebp
80103841:	c3                   	ret    

80103842 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80103842:	55                   	push   %ebp
80103843:	89 e5                	mov    %esp,%ebp
80103845:	8b 45 08             	mov    0x8(%ebp),%eax
80103848:	05 00 00 00 80       	add    $0x80000000,%eax
8010384d:	5d                   	pop    %ebp
8010384e:	c3                   	ret    

8010384f <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
8010384f:	55                   	push   %ebp
80103850:	89 e5                	mov    %esp,%ebp
80103852:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103855:	8b 55 08             	mov    0x8(%ebp),%edx
80103858:	8b 45 0c             	mov    0xc(%ebp),%eax
8010385b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010385e:	f0 87 02             	lock xchg %eax,(%edx)
80103861:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80103864:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103867:	c9                   	leave  
80103868:	c3                   	ret    

80103869 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80103869:	8d 4c 24 04          	lea    0x4(%esp),%ecx
8010386d:	83 e4 f0             	and    $0xfffffff0,%esp
80103870:	ff 71 fc             	pushl  -0x4(%ecx)
80103873:	55                   	push   %ebp
80103874:	89 e5                	mov    %esp,%ebp
80103876:	51                   	push   %ecx
80103877:	83 ec 04             	sub    $0x4,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010387a:	83 ec 08             	sub    $0x8,%esp
8010387d:	68 00 00 40 80       	push   $0x80400000
80103882:	68 60 65 11 80       	push   $0x80116560
80103887:	e8 59 f2 ff ff       	call   80102ae5 <kinit1>
8010388c:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
8010388f:	e8 45 4c 00 00       	call   801084d9 <kvmalloc>
  mpinit();        // collect info about this machine
80103894:	e8 09 04 00 00       	call   80103ca2 <mpinit>
  lapicinit();
80103899:	e8 ea f5 ff ff       	call   80102e88 <lapicinit>
  seginit();       // set up segments
8010389e:	e8 c9 45 00 00       	call   80107e6c <seginit>
  picinit();       // interrupt controller
801038a3:	e8 50 06 00 00       	call   80103ef8 <picinit>
  ioapicinit();    // another interrupt controller
801038a8:	e8 2d f1 ff ff       	call   801029da <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
801038ad:	e8 67 d2 ff ff       	call   80100b19 <consoleinit>
  uartinit();      // serial port
801038b2:	e8 3d 39 00 00       	call   801071f4 <uartinit>
  pinit();         // process table
801038b7:	e8 39 0b 00 00       	call   801043f5 <pinit>
  tvinit();        // trap vectors
801038bc:	e8 fd 34 00 00       	call   80106dbe <tvinit>
  binit();         // buffer cache
801038c1:	e8 6e c7 ff ff       	call   80100034 <binit>
  fileinit();      // file table
801038c6:	e8 aa d6 ff ff       	call   80100f75 <fileinit>
  ideinit();       // disk
801038cb:	e8 12 ed ff ff       	call   801025e2 <ideinit>
  if(!ismp)
801038d0:	a1 64 33 11 80       	mov    0x80113364,%eax
801038d5:	85 c0                	test   %eax,%eax
801038d7:	75 05                	jne    801038de <main+0x75>
    timerinit();   // uniprocessor timer
801038d9:	e8 3d 34 00 00       	call   80106d1b <timerinit>
  startothers();   // start other processors
801038de:	e8 62 00 00 00       	call   80103945 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801038e3:	83 ec 08             	sub    $0x8,%esp
801038e6:	68 00 00 00 8e       	push   $0x8e000000
801038eb:	68 00 00 40 80       	push   $0x80400000
801038f0:	e8 29 f2 ff ff       	call   80102b1e <kinit2>
801038f5:	83 c4 10             	add    $0x10,%esp
  userinit();      // first user process
801038f8:	e8 46 0c 00 00       	call   80104543 <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
801038fd:	e8 1a 00 00 00       	call   8010391c <mpmain>

80103902 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80103902:	55                   	push   %ebp
80103903:	89 e5                	mov    %esp,%ebp
80103905:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
80103908:	e8 e4 4b 00 00       	call   801084f1 <switchkvm>
  seginit();
8010390d:	e8 5a 45 00 00       	call   80107e6c <seginit>
  lapicinit();
80103912:	e8 71 f5 ff ff       	call   80102e88 <lapicinit>
  mpmain();
80103917:	e8 00 00 00 00       	call   8010391c <mpmain>

8010391c <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
8010391c:	55                   	push   %ebp
8010391d:	89 e5                	mov    %esp,%ebp
8010391f:	83 ec 08             	sub    $0x8,%esp
  idtinit();       // load idt register
80103922:	e8 0d 36 00 00       	call   80106f34 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80103927:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010392d:	05 a8 00 00 00       	add    $0xa8,%eax
80103932:	83 ec 08             	sub    $0x8,%esp
80103935:	6a 01                	push   $0x1
80103937:	50                   	push   %eax
80103938:	e8 12 ff ff ff       	call   8010384f <xchg>
8010393d:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
80103940:	e8 36 17 00 00       	call   8010507b <scheduler>

80103945 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80103945:	55                   	push   %ebp
80103946:	89 e5                	mov    %esp,%ebp
80103948:	53                   	push   %ebx
80103949:	83 ec 14             	sub    $0x14,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
8010394c:	68 00 70 00 00       	push   $0x7000
80103951:	e8 ec fe ff ff       	call   80103842 <p2v>
80103956:	83 c4 04             	add    $0x4,%esp
80103959:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
8010395c:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103961:	83 ec 04             	sub    $0x4,%esp
80103964:	50                   	push   %eax
80103965:	68 30 c5 10 80       	push   $0x8010c530
8010396a:	ff 75 f0             	pushl  -0x10(%ebp)
8010396d:	e8 20 1f 00 00       	call   80105892 <memmove>
80103972:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
80103975:	c7 45 f4 80 33 11 80 	movl   $0x80113380,-0xc(%ebp)
8010397c:	e9 90 00 00 00       	jmp    80103a11 <startothers+0xcc>
    if(c == cpus+cpunum())  // We've started already.
80103981:	e8 20 f6 ff ff       	call   80102fa6 <cpunum>
80103986:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
8010398c:	05 80 33 11 80       	add    $0x80113380,%eax
80103991:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103994:	74 73                	je     80103a09 <startothers+0xc4>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103996:	e8 8e f2 ff ff       	call   80102c29 <kalloc>
8010399b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
8010399e:	8b 45 f0             	mov    -0x10(%ebp),%eax
801039a1:	83 e8 04             	sub    $0x4,%eax
801039a4:	8b 55 ec             	mov    -0x14(%ebp),%edx
801039a7:	81 c2 00 10 00 00    	add    $0x1000,%edx
801039ad:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
801039af:	8b 45 f0             	mov    -0x10(%ebp),%eax
801039b2:	83 e8 08             	sub    $0x8,%eax
801039b5:	c7 00 02 39 10 80    	movl   $0x80103902,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
801039bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801039be:	8d 58 f4             	lea    -0xc(%eax),%ebx
801039c1:	83 ec 0c             	sub    $0xc,%esp
801039c4:	68 00 b0 10 80       	push   $0x8010b000
801039c9:	e8 67 fe ff ff       	call   80103835 <v2p>
801039ce:	83 c4 10             	add    $0x10,%esp
801039d1:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
801039d3:	83 ec 0c             	sub    $0xc,%esp
801039d6:	ff 75 f0             	pushl  -0x10(%ebp)
801039d9:	e8 57 fe ff ff       	call   80103835 <v2p>
801039de:	83 c4 10             	add    $0x10,%esp
801039e1:	89 c2                	mov    %eax,%edx
801039e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039e6:	0f b6 00             	movzbl (%eax),%eax
801039e9:	0f b6 c0             	movzbl %al,%eax
801039ec:	83 ec 08             	sub    $0x8,%esp
801039ef:	52                   	push   %edx
801039f0:	50                   	push   %eax
801039f1:	e8 2a f6 ff ff       	call   80103020 <lapicstartap>
801039f6:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801039f9:	90                   	nop
801039fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039fd:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80103a03:	85 c0                	test   %eax,%eax
80103a05:	74 f3                	je     801039fa <startothers+0xb5>
80103a07:	eb 01                	jmp    80103a0a <startothers+0xc5>
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
    if(c == cpus+cpunum())  // We've started already.
      continue;
80103a09:	90                   	nop
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80103a0a:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
80103a11:	a1 60 39 11 80       	mov    0x80113960,%eax
80103a16:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103a1c:	05 80 33 11 80       	add    $0x80113380,%eax
80103a21:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103a24:	0f 87 57 ff ff ff    	ja     80103981 <startothers+0x3c>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
80103a2a:	90                   	nop
80103a2b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a2e:	c9                   	leave  
80103a2f:	c3                   	ret    

80103a30 <p2v>:
80103a30:	55                   	push   %ebp
80103a31:	89 e5                	mov    %esp,%ebp
80103a33:	8b 45 08             	mov    0x8(%ebp),%eax
80103a36:	05 00 00 00 80       	add    $0x80000000,%eax
80103a3b:	5d                   	pop    %ebp
80103a3c:	c3                   	ret    

80103a3d <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80103a3d:	55                   	push   %ebp
80103a3e:	89 e5                	mov    %esp,%ebp
80103a40:	83 ec 14             	sub    $0x14,%esp
80103a43:	8b 45 08             	mov    0x8(%ebp),%eax
80103a46:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103a4a:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80103a4e:	89 c2                	mov    %eax,%edx
80103a50:	ec                   	in     (%dx),%al
80103a51:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103a54:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103a58:	c9                   	leave  
80103a59:	c3                   	ret    

80103a5a <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103a5a:	55                   	push   %ebp
80103a5b:	89 e5                	mov    %esp,%ebp
80103a5d:	83 ec 08             	sub    $0x8,%esp
80103a60:	8b 55 08             	mov    0x8(%ebp),%edx
80103a63:	8b 45 0c             	mov    0xc(%ebp),%eax
80103a66:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103a6a:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103a6d:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103a71:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103a75:	ee                   	out    %al,(%dx)
}
80103a76:	90                   	nop
80103a77:	c9                   	leave  
80103a78:	c3                   	ret    

80103a79 <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
80103a79:	55                   	push   %ebp
80103a7a:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
80103a7c:	a1 68 c6 10 80       	mov    0x8010c668,%eax
80103a81:	89 c2                	mov    %eax,%edx
80103a83:	b8 80 33 11 80       	mov    $0x80113380,%eax
80103a88:	29 c2                	sub    %eax,%edx
80103a8a:	89 d0                	mov    %edx,%eax
80103a8c:	c1 f8 02             	sar    $0x2,%eax
80103a8f:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
80103a95:	5d                   	pop    %ebp
80103a96:	c3                   	ret    

80103a97 <sum>:

static uchar
sum(uchar *addr, int len)
{
80103a97:	55                   	push   %ebp
80103a98:	89 e5                	mov    %esp,%ebp
80103a9a:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
80103a9d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103aa4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103aab:	eb 15                	jmp    80103ac2 <sum+0x2b>
    sum += addr[i];
80103aad:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103ab0:	8b 45 08             	mov    0x8(%ebp),%eax
80103ab3:	01 d0                	add    %edx,%eax
80103ab5:	0f b6 00             	movzbl (%eax),%eax
80103ab8:	0f b6 c0             	movzbl %al,%eax
80103abb:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
80103abe:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103ac2:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103ac5:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103ac8:	7c e3                	jl     80103aad <sum+0x16>
    sum += addr[i];
  return sum;
80103aca:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103acd:	c9                   	leave  
80103ace:	c3                   	ret    

80103acf <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103acf:	55                   	push   %ebp
80103ad0:	89 e5                	mov    %esp,%ebp
80103ad2:	83 ec 18             	sub    $0x18,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
80103ad5:	ff 75 08             	pushl  0x8(%ebp)
80103ad8:	e8 53 ff ff ff       	call   80103a30 <p2v>
80103add:	83 c4 04             	add    $0x4,%esp
80103ae0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103ae3:	8b 55 0c             	mov    0xc(%ebp),%edx
80103ae6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ae9:	01 d0                	add    %edx,%eax
80103aeb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103aee:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103af1:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103af4:	eb 36                	jmp    80103b2c <mpsearch1+0x5d>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103af6:	83 ec 04             	sub    $0x4,%esp
80103af9:	6a 04                	push   $0x4
80103afb:	68 a0 8f 10 80       	push   $0x80108fa0
80103b00:	ff 75 f4             	pushl  -0xc(%ebp)
80103b03:	e8 32 1d 00 00       	call   8010583a <memcmp>
80103b08:	83 c4 10             	add    $0x10,%esp
80103b0b:	85 c0                	test   %eax,%eax
80103b0d:	75 19                	jne    80103b28 <mpsearch1+0x59>
80103b0f:	83 ec 08             	sub    $0x8,%esp
80103b12:	6a 10                	push   $0x10
80103b14:	ff 75 f4             	pushl  -0xc(%ebp)
80103b17:	e8 7b ff ff ff       	call   80103a97 <sum>
80103b1c:	83 c4 10             	add    $0x10,%esp
80103b1f:	84 c0                	test   %al,%al
80103b21:	75 05                	jne    80103b28 <mpsearch1+0x59>
      return (struct mp*)p;
80103b23:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b26:	eb 11                	jmp    80103b39 <mpsearch1+0x6a>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103b28:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103b2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b2f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103b32:	72 c2                	jb     80103af6 <mpsearch1+0x27>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103b34:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103b39:	c9                   	leave  
80103b3a:	c3                   	ret    

80103b3b <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103b3b:	55                   	push   %ebp
80103b3c:	89 e5                	mov    %esp,%ebp
80103b3e:	83 ec 18             	sub    $0x18,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103b41:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103b48:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b4b:	83 c0 0f             	add    $0xf,%eax
80103b4e:	0f b6 00             	movzbl (%eax),%eax
80103b51:	0f b6 c0             	movzbl %al,%eax
80103b54:	c1 e0 08             	shl    $0x8,%eax
80103b57:	89 c2                	mov    %eax,%edx
80103b59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b5c:	83 c0 0e             	add    $0xe,%eax
80103b5f:	0f b6 00             	movzbl (%eax),%eax
80103b62:	0f b6 c0             	movzbl %al,%eax
80103b65:	09 d0                	or     %edx,%eax
80103b67:	c1 e0 04             	shl    $0x4,%eax
80103b6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103b6d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103b71:	74 21                	je     80103b94 <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103b73:	83 ec 08             	sub    $0x8,%esp
80103b76:	68 00 04 00 00       	push   $0x400
80103b7b:	ff 75 f0             	pushl  -0x10(%ebp)
80103b7e:	e8 4c ff ff ff       	call   80103acf <mpsearch1>
80103b83:	83 c4 10             	add    $0x10,%esp
80103b86:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103b89:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103b8d:	74 51                	je     80103be0 <mpsearch+0xa5>
      return mp;
80103b8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103b92:	eb 61                	jmp    80103bf5 <mpsearch+0xba>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103b94:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b97:	83 c0 14             	add    $0x14,%eax
80103b9a:	0f b6 00             	movzbl (%eax),%eax
80103b9d:	0f b6 c0             	movzbl %al,%eax
80103ba0:	c1 e0 08             	shl    $0x8,%eax
80103ba3:	89 c2                	mov    %eax,%edx
80103ba5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ba8:	83 c0 13             	add    $0x13,%eax
80103bab:	0f b6 00             	movzbl (%eax),%eax
80103bae:	0f b6 c0             	movzbl %al,%eax
80103bb1:	09 d0                	or     %edx,%eax
80103bb3:	c1 e0 0a             	shl    $0xa,%eax
80103bb6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103bb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bbc:	2d 00 04 00 00       	sub    $0x400,%eax
80103bc1:	83 ec 08             	sub    $0x8,%esp
80103bc4:	68 00 04 00 00       	push   $0x400
80103bc9:	50                   	push   %eax
80103bca:	e8 00 ff ff ff       	call   80103acf <mpsearch1>
80103bcf:	83 c4 10             	add    $0x10,%esp
80103bd2:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103bd5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103bd9:	74 05                	je     80103be0 <mpsearch+0xa5>
      return mp;
80103bdb:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103bde:	eb 15                	jmp    80103bf5 <mpsearch+0xba>
  }
  return mpsearch1(0xF0000, 0x10000);
80103be0:	83 ec 08             	sub    $0x8,%esp
80103be3:	68 00 00 01 00       	push   $0x10000
80103be8:	68 00 00 0f 00       	push   $0xf0000
80103bed:	e8 dd fe ff ff       	call   80103acf <mpsearch1>
80103bf2:	83 c4 10             	add    $0x10,%esp
}
80103bf5:	c9                   	leave  
80103bf6:	c3                   	ret    

80103bf7 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103bf7:	55                   	push   %ebp
80103bf8:	89 e5                	mov    %esp,%ebp
80103bfa:	83 ec 18             	sub    $0x18,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103bfd:	e8 39 ff ff ff       	call   80103b3b <mpsearch>
80103c02:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103c05:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103c09:	74 0a                	je     80103c15 <mpconfig+0x1e>
80103c0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c0e:	8b 40 04             	mov    0x4(%eax),%eax
80103c11:	85 c0                	test   %eax,%eax
80103c13:	75 0a                	jne    80103c1f <mpconfig+0x28>
    return 0;
80103c15:	b8 00 00 00 00       	mov    $0x0,%eax
80103c1a:	e9 81 00 00 00       	jmp    80103ca0 <mpconfig+0xa9>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
80103c1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c22:	8b 40 04             	mov    0x4(%eax),%eax
80103c25:	83 ec 0c             	sub    $0xc,%esp
80103c28:	50                   	push   %eax
80103c29:	e8 02 fe ff ff       	call   80103a30 <p2v>
80103c2e:	83 c4 10             	add    $0x10,%esp
80103c31:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103c34:	83 ec 04             	sub    $0x4,%esp
80103c37:	6a 04                	push   $0x4
80103c39:	68 a5 8f 10 80       	push   $0x80108fa5
80103c3e:	ff 75 f0             	pushl  -0x10(%ebp)
80103c41:	e8 f4 1b 00 00       	call   8010583a <memcmp>
80103c46:	83 c4 10             	add    $0x10,%esp
80103c49:	85 c0                	test   %eax,%eax
80103c4b:	74 07                	je     80103c54 <mpconfig+0x5d>
    return 0;
80103c4d:	b8 00 00 00 00       	mov    $0x0,%eax
80103c52:	eb 4c                	jmp    80103ca0 <mpconfig+0xa9>
  if(conf->version != 1 && conf->version != 4)
80103c54:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c57:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103c5b:	3c 01                	cmp    $0x1,%al
80103c5d:	74 12                	je     80103c71 <mpconfig+0x7a>
80103c5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c62:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103c66:	3c 04                	cmp    $0x4,%al
80103c68:	74 07                	je     80103c71 <mpconfig+0x7a>
    return 0;
80103c6a:	b8 00 00 00 00       	mov    $0x0,%eax
80103c6f:	eb 2f                	jmp    80103ca0 <mpconfig+0xa9>
  if(sum((uchar*)conf, conf->length) != 0)
80103c71:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c74:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103c78:	0f b7 c0             	movzwl %ax,%eax
80103c7b:	83 ec 08             	sub    $0x8,%esp
80103c7e:	50                   	push   %eax
80103c7f:	ff 75 f0             	pushl  -0x10(%ebp)
80103c82:	e8 10 fe ff ff       	call   80103a97 <sum>
80103c87:	83 c4 10             	add    $0x10,%esp
80103c8a:	84 c0                	test   %al,%al
80103c8c:	74 07                	je     80103c95 <mpconfig+0x9e>
    return 0;
80103c8e:	b8 00 00 00 00       	mov    $0x0,%eax
80103c93:	eb 0b                	jmp    80103ca0 <mpconfig+0xa9>
  *pmp = mp;
80103c95:	8b 45 08             	mov    0x8(%ebp),%eax
80103c98:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103c9b:	89 10                	mov    %edx,(%eax)
  return conf;
80103c9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103ca0:	c9                   	leave  
80103ca1:	c3                   	ret    

80103ca2 <mpinit>:

void
mpinit(void)
{
80103ca2:	55                   	push   %ebp
80103ca3:	89 e5                	mov    %esp,%ebp
80103ca5:	83 ec 28             	sub    $0x28,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80103ca8:	c7 05 68 c6 10 80 80 	movl   $0x80113380,0x8010c668
80103caf:	33 11 80 
  if((conf = mpconfig(&mp)) == 0)
80103cb2:	83 ec 0c             	sub    $0xc,%esp
80103cb5:	8d 45 e0             	lea    -0x20(%ebp),%eax
80103cb8:	50                   	push   %eax
80103cb9:	e8 39 ff ff ff       	call   80103bf7 <mpconfig>
80103cbe:	83 c4 10             	add    $0x10,%esp
80103cc1:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103cc4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103cc8:	0f 84 96 01 00 00    	je     80103e64 <mpinit+0x1c2>
    return;
  ismp = 1;
80103cce:	c7 05 64 33 11 80 01 	movl   $0x1,0x80113364
80103cd5:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80103cd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cdb:	8b 40 24             	mov    0x24(%eax),%eax
80103cde:	a3 7c 32 11 80       	mov    %eax,0x8011327c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103ce3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ce6:	83 c0 2c             	add    $0x2c,%eax
80103ce9:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103cec:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cef:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103cf3:	0f b7 d0             	movzwl %ax,%edx
80103cf6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cf9:	01 d0                	add    %edx,%eax
80103cfb:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103cfe:	e9 f2 00 00 00       	jmp    80103df5 <mpinit+0x153>
    switch(*p){
80103d03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d06:	0f b6 00             	movzbl (%eax),%eax
80103d09:	0f b6 c0             	movzbl %al,%eax
80103d0c:	83 f8 04             	cmp    $0x4,%eax
80103d0f:	0f 87 bc 00 00 00    	ja     80103dd1 <mpinit+0x12f>
80103d15:	8b 04 85 e8 8f 10 80 	mov    -0x7fef7018(,%eax,4),%eax
80103d1c:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103d1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d21:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
80103d24:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103d27:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103d2b:	0f b6 d0             	movzbl %al,%edx
80103d2e:	a1 60 39 11 80       	mov    0x80113960,%eax
80103d33:	39 c2                	cmp    %eax,%edx
80103d35:	74 2b                	je     80103d62 <mpinit+0xc0>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
80103d37:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103d3a:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103d3e:	0f b6 d0             	movzbl %al,%edx
80103d41:	a1 60 39 11 80       	mov    0x80113960,%eax
80103d46:	83 ec 04             	sub    $0x4,%esp
80103d49:	52                   	push   %edx
80103d4a:	50                   	push   %eax
80103d4b:	68 aa 8f 10 80       	push   $0x80108faa
80103d50:	e8 71 c6 ff ff       	call   801003c6 <cprintf>
80103d55:	83 c4 10             	add    $0x10,%esp
        ismp = 0;
80103d58:	c7 05 64 33 11 80 00 	movl   $0x0,0x80113364
80103d5f:	00 00 00 
      }
      if(proc->flags & MPBOOT)
80103d62:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103d65:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80103d69:	0f b6 c0             	movzbl %al,%eax
80103d6c:	83 e0 02             	and    $0x2,%eax
80103d6f:	85 c0                	test   %eax,%eax
80103d71:	74 15                	je     80103d88 <mpinit+0xe6>
        bcpu = &cpus[ncpu];
80103d73:	a1 60 39 11 80       	mov    0x80113960,%eax
80103d78:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103d7e:	05 80 33 11 80       	add    $0x80113380,%eax
80103d83:	a3 68 c6 10 80       	mov    %eax,0x8010c668
      cpus[ncpu].id = ncpu;
80103d88:	a1 60 39 11 80       	mov    0x80113960,%eax
80103d8d:	8b 15 60 39 11 80    	mov    0x80113960,%edx
80103d93:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103d99:	05 80 33 11 80       	add    $0x80113380,%eax
80103d9e:	88 10                	mov    %dl,(%eax)
      ncpu++;
80103da0:	a1 60 39 11 80       	mov    0x80113960,%eax
80103da5:	83 c0 01             	add    $0x1,%eax
80103da8:	a3 60 39 11 80       	mov    %eax,0x80113960
      p += sizeof(struct mpproc);
80103dad:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103db1:	eb 42                	jmp    80103df5 <mpinit+0x153>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103db3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103db6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80103db9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103dbc:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103dc0:	a2 60 33 11 80       	mov    %al,0x80113360
      p += sizeof(struct mpioapic);
80103dc5:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103dc9:	eb 2a                	jmp    80103df5 <mpinit+0x153>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103dcb:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103dcf:	eb 24                	jmp    80103df5 <mpinit+0x153>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
80103dd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103dd4:	0f b6 00             	movzbl (%eax),%eax
80103dd7:	0f b6 c0             	movzbl %al,%eax
80103dda:	83 ec 08             	sub    $0x8,%esp
80103ddd:	50                   	push   %eax
80103dde:	68 c8 8f 10 80       	push   $0x80108fc8
80103de3:	e8 de c5 ff ff       	call   801003c6 <cprintf>
80103de8:	83 c4 10             	add    $0x10,%esp
      ismp = 0;
80103deb:	c7 05 64 33 11 80 00 	movl   $0x0,0x80113364
80103df2:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103df5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103df8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103dfb:	0f 82 02 ff ff ff    	jb     80103d03 <mpinit+0x61>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
80103e01:	a1 64 33 11 80       	mov    0x80113364,%eax
80103e06:	85 c0                	test   %eax,%eax
80103e08:	75 1d                	jne    80103e27 <mpinit+0x185>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103e0a:	c7 05 60 39 11 80 01 	movl   $0x1,0x80113960
80103e11:	00 00 00 
    lapic = 0;
80103e14:	c7 05 7c 32 11 80 00 	movl   $0x0,0x8011327c
80103e1b:	00 00 00 
    ioapicid = 0;
80103e1e:	c6 05 60 33 11 80 00 	movb   $0x0,0x80113360
    return;
80103e25:	eb 3e                	jmp    80103e65 <mpinit+0x1c3>
  }

  if(mp->imcrp){
80103e27:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103e2a:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80103e2e:	84 c0                	test   %al,%al
80103e30:	74 33                	je     80103e65 <mpinit+0x1c3>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103e32:	83 ec 08             	sub    $0x8,%esp
80103e35:	6a 70                	push   $0x70
80103e37:	6a 22                	push   $0x22
80103e39:	e8 1c fc ff ff       	call   80103a5a <outb>
80103e3e:	83 c4 10             	add    $0x10,%esp
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103e41:	83 ec 0c             	sub    $0xc,%esp
80103e44:	6a 23                	push   $0x23
80103e46:	e8 f2 fb ff ff       	call   80103a3d <inb>
80103e4b:	83 c4 10             	add    $0x10,%esp
80103e4e:	83 c8 01             	or     $0x1,%eax
80103e51:	0f b6 c0             	movzbl %al,%eax
80103e54:	83 ec 08             	sub    $0x8,%esp
80103e57:	50                   	push   %eax
80103e58:	6a 23                	push   $0x23
80103e5a:	e8 fb fb ff ff       	call   80103a5a <outb>
80103e5f:	83 c4 10             	add    $0x10,%esp
80103e62:	eb 01                	jmp    80103e65 <mpinit+0x1c3>
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
80103e64:	90                   	nop
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
80103e65:	c9                   	leave  
80103e66:	c3                   	ret    

80103e67 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103e67:	55                   	push   %ebp
80103e68:	89 e5                	mov    %esp,%ebp
80103e6a:	83 ec 08             	sub    $0x8,%esp
80103e6d:	8b 55 08             	mov    0x8(%ebp),%edx
80103e70:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e73:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103e77:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103e7a:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103e7e:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103e82:	ee                   	out    %al,(%dx)
}
80103e83:	90                   	nop
80103e84:	c9                   	leave  
80103e85:	c3                   	ret    

80103e86 <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80103e86:	55                   	push   %ebp
80103e87:	89 e5                	mov    %esp,%ebp
80103e89:	83 ec 04             	sub    $0x4,%esp
80103e8c:	8b 45 08             	mov    0x8(%ebp),%eax
80103e8f:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80103e93:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103e97:	66 a3 00 c0 10 80    	mov    %ax,0x8010c000
  outb(IO_PIC1+1, mask);
80103e9d:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103ea1:	0f b6 c0             	movzbl %al,%eax
80103ea4:	50                   	push   %eax
80103ea5:	6a 21                	push   $0x21
80103ea7:	e8 bb ff ff ff       	call   80103e67 <outb>
80103eac:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, mask >> 8);
80103eaf:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103eb3:	66 c1 e8 08          	shr    $0x8,%ax
80103eb7:	0f b6 c0             	movzbl %al,%eax
80103eba:	50                   	push   %eax
80103ebb:	68 a1 00 00 00       	push   $0xa1
80103ec0:	e8 a2 ff ff ff       	call   80103e67 <outb>
80103ec5:	83 c4 08             	add    $0x8,%esp
}
80103ec8:	90                   	nop
80103ec9:	c9                   	leave  
80103eca:	c3                   	ret    

80103ecb <picenable>:

void
picenable(int irq)
{
80103ecb:	55                   	push   %ebp
80103ecc:	89 e5                	mov    %esp,%ebp
  picsetmask(irqmask & ~(1<<irq));
80103ece:	8b 45 08             	mov    0x8(%ebp),%eax
80103ed1:	ba 01 00 00 00       	mov    $0x1,%edx
80103ed6:	89 c1                	mov    %eax,%ecx
80103ed8:	d3 e2                	shl    %cl,%edx
80103eda:	89 d0                	mov    %edx,%eax
80103edc:	f7 d0                	not    %eax
80103ede:	89 c2                	mov    %eax,%edx
80103ee0:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80103ee7:	21 d0                	and    %edx,%eax
80103ee9:	0f b7 c0             	movzwl %ax,%eax
80103eec:	50                   	push   %eax
80103eed:	e8 94 ff ff ff       	call   80103e86 <picsetmask>
80103ef2:	83 c4 04             	add    $0x4,%esp
}
80103ef5:	90                   	nop
80103ef6:	c9                   	leave  
80103ef7:	c3                   	ret    

80103ef8 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103ef8:	55                   	push   %ebp
80103ef9:	89 e5                	mov    %esp,%ebp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103efb:	68 ff 00 00 00       	push   $0xff
80103f00:	6a 21                	push   $0x21
80103f02:	e8 60 ff ff ff       	call   80103e67 <outb>
80103f07:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, 0xFF);
80103f0a:	68 ff 00 00 00       	push   $0xff
80103f0f:	68 a1 00 00 00       	push   $0xa1
80103f14:	e8 4e ff ff ff       	call   80103e67 <outb>
80103f19:	83 c4 08             	add    $0x8,%esp

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80103f1c:	6a 11                	push   $0x11
80103f1e:	6a 20                	push   $0x20
80103f20:	e8 42 ff ff ff       	call   80103e67 <outb>
80103f25:	83 c4 08             	add    $0x8,%esp

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
80103f28:	6a 20                	push   $0x20
80103f2a:	6a 21                	push   $0x21
80103f2c:	e8 36 ff ff ff       	call   80103e67 <outb>
80103f31:	83 c4 08             	add    $0x8,%esp

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
80103f34:	6a 04                	push   $0x4
80103f36:	6a 21                	push   $0x21
80103f38:	e8 2a ff ff ff       	call   80103e67 <outb>
80103f3d:	83 c4 08             	add    $0x8,%esp
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
80103f40:	6a 03                	push   $0x3
80103f42:	6a 21                	push   $0x21
80103f44:	e8 1e ff ff ff       	call   80103e67 <outb>
80103f49:	83 c4 08             	add    $0x8,%esp

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
80103f4c:	6a 11                	push   $0x11
80103f4e:	68 a0 00 00 00       	push   $0xa0
80103f53:	e8 0f ff ff ff       	call   80103e67 <outb>
80103f58:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80103f5b:	6a 28                	push   $0x28
80103f5d:	68 a1 00 00 00       	push   $0xa1
80103f62:	e8 00 ff ff ff       	call   80103e67 <outb>
80103f67:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
80103f6a:	6a 02                	push   $0x2
80103f6c:	68 a1 00 00 00       	push   $0xa1
80103f71:	e8 f1 fe ff ff       	call   80103e67 <outb>
80103f76:	83 c4 08             	add    $0x8,%esp
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
80103f79:	6a 03                	push   $0x3
80103f7b:	68 a1 00 00 00       	push   $0xa1
80103f80:	e8 e2 fe ff ff       	call   80103e67 <outb>
80103f85:	83 c4 08             	add    $0x8,%esp

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
80103f88:	6a 68                	push   $0x68
80103f8a:	6a 20                	push   $0x20
80103f8c:	e8 d6 fe ff ff       	call   80103e67 <outb>
80103f91:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC1, 0x0a);             // read IRR by default
80103f94:	6a 0a                	push   $0xa
80103f96:	6a 20                	push   $0x20
80103f98:	e8 ca fe ff ff       	call   80103e67 <outb>
80103f9d:	83 c4 08             	add    $0x8,%esp

  outb(IO_PIC2, 0x68);             // OCW3
80103fa0:	6a 68                	push   $0x68
80103fa2:	68 a0 00 00 00       	push   $0xa0
80103fa7:	e8 bb fe ff ff       	call   80103e67 <outb>
80103fac:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2, 0x0a);             // OCW3
80103faf:	6a 0a                	push   $0xa
80103fb1:	68 a0 00 00 00       	push   $0xa0
80103fb6:	e8 ac fe ff ff       	call   80103e67 <outb>
80103fbb:	83 c4 08             	add    $0x8,%esp

  if(irqmask != 0xFFFF)
80103fbe:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80103fc5:	66 83 f8 ff          	cmp    $0xffff,%ax
80103fc9:	74 13                	je     80103fde <picinit+0xe6>
    picsetmask(irqmask);
80103fcb:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80103fd2:	0f b7 c0             	movzwl %ax,%eax
80103fd5:	50                   	push   %eax
80103fd6:	e8 ab fe ff ff       	call   80103e86 <picsetmask>
80103fdb:	83 c4 04             	add    $0x4,%esp
}
80103fde:	90                   	nop
80103fdf:	c9                   	leave  
80103fe0:	c3                   	ret    

80103fe1 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103fe1:	55                   	push   %ebp
80103fe2:	89 e5                	mov    %esp,%ebp
80103fe4:	83 ec 18             	sub    $0x18,%esp
  struct pipe *p;

  p = 0;
80103fe7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80103fee:	8b 45 0c             	mov    0xc(%ebp),%eax
80103ff1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103ff7:	8b 45 0c             	mov    0xc(%ebp),%eax
80103ffa:	8b 10                	mov    (%eax),%edx
80103ffc:	8b 45 08             	mov    0x8(%ebp),%eax
80103fff:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80104001:	e8 8d cf ff ff       	call   80100f93 <filealloc>
80104006:	89 c2                	mov    %eax,%edx
80104008:	8b 45 08             	mov    0x8(%ebp),%eax
8010400b:	89 10                	mov    %edx,(%eax)
8010400d:	8b 45 08             	mov    0x8(%ebp),%eax
80104010:	8b 00                	mov    (%eax),%eax
80104012:	85 c0                	test   %eax,%eax
80104014:	0f 84 cb 00 00 00    	je     801040e5 <pipealloc+0x104>
8010401a:	e8 74 cf ff ff       	call   80100f93 <filealloc>
8010401f:	89 c2                	mov    %eax,%edx
80104021:	8b 45 0c             	mov    0xc(%ebp),%eax
80104024:	89 10                	mov    %edx,(%eax)
80104026:	8b 45 0c             	mov    0xc(%ebp),%eax
80104029:	8b 00                	mov    (%eax),%eax
8010402b:	85 c0                	test   %eax,%eax
8010402d:	0f 84 b2 00 00 00    	je     801040e5 <pipealloc+0x104>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80104033:	e8 f1 eb ff ff       	call   80102c29 <kalloc>
80104038:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010403b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010403f:	0f 84 9f 00 00 00    	je     801040e4 <pipealloc+0x103>
    goto bad;
  p->readopen = 1;
80104045:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104048:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010404f:	00 00 00 
  p->writeopen = 1;
80104052:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104055:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010405c:	00 00 00 
  p->nwrite = 0;
8010405f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104062:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80104069:	00 00 00 
  p->nread = 0;
8010406c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010406f:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80104076:	00 00 00 
  initlock(&p->lock, "pipe");
80104079:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010407c:	83 ec 08             	sub    $0x8,%esp
8010407f:	68 fc 8f 10 80       	push   $0x80108ffc
80104084:	50                   	push   %eax
80104085:	e8 c4 14 00 00       	call   8010554e <initlock>
8010408a:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010408d:	8b 45 08             	mov    0x8(%ebp),%eax
80104090:	8b 00                	mov    (%eax),%eax
80104092:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80104098:	8b 45 08             	mov    0x8(%ebp),%eax
8010409b:	8b 00                	mov    (%eax),%eax
8010409d:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801040a1:	8b 45 08             	mov    0x8(%ebp),%eax
801040a4:	8b 00                	mov    (%eax),%eax
801040a6:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801040aa:	8b 45 08             	mov    0x8(%ebp),%eax
801040ad:	8b 00                	mov    (%eax),%eax
801040af:	8b 55 f4             	mov    -0xc(%ebp),%edx
801040b2:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
801040b5:	8b 45 0c             	mov    0xc(%ebp),%eax
801040b8:	8b 00                	mov    (%eax),%eax
801040ba:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801040c0:	8b 45 0c             	mov    0xc(%ebp),%eax
801040c3:	8b 00                	mov    (%eax),%eax
801040c5:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801040c9:	8b 45 0c             	mov    0xc(%ebp),%eax
801040cc:	8b 00                	mov    (%eax),%eax
801040ce:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801040d2:	8b 45 0c             	mov    0xc(%ebp),%eax
801040d5:	8b 00                	mov    (%eax),%eax
801040d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801040da:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
801040dd:	b8 00 00 00 00       	mov    $0x0,%eax
801040e2:	eb 4e                	jmp    80104132 <pipealloc+0x151>
  p = 0;
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
801040e4:	90                   	nop
  (*f1)->pipe = p;
  return 0;

//PAGEBREAK: 20
 bad:
  if(p)
801040e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801040e9:	74 0e                	je     801040f9 <pipealloc+0x118>
    kfree((char*)p);
801040eb:	83 ec 0c             	sub    $0xc,%esp
801040ee:	ff 75 f4             	pushl  -0xc(%ebp)
801040f1:	e8 89 ea ff ff       	call   80102b7f <kfree>
801040f6:	83 c4 10             	add    $0x10,%esp
  if(*f0)
801040f9:	8b 45 08             	mov    0x8(%ebp),%eax
801040fc:	8b 00                	mov    (%eax),%eax
801040fe:	85 c0                	test   %eax,%eax
80104100:	74 11                	je     80104113 <pipealloc+0x132>
    fileclose(*f0);
80104102:	8b 45 08             	mov    0x8(%ebp),%eax
80104105:	8b 00                	mov    (%eax),%eax
80104107:	83 ec 0c             	sub    $0xc,%esp
8010410a:	50                   	push   %eax
8010410b:	e8 41 cf ff ff       	call   80101051 <fileclose>
80104110:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80104113:	8b 45 0c             	mov    0xc(%ebp),%eax
80104116:	8b 00                	mov    (%eax),%eax
80104118:	85 c0                	test   %eax,%eax
8010411a:	74 11                	je     8010412d <pipealloc+0x14c>
    fileclose(*f1);
8010411c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010411f:	8b 00                	mov    (%eax),%eax
80104121:	83 ec 0c             	sub    $0xc,%esp
80104124:	50                   	push   %eax
80104125:	e8 27 cf ff ff       	call   80101051 <fileclose>
8010412a:	83 c4 10             	add    $0x10,%esp
  return -1;
8010412d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104132:	c9                   	leave  
80104133:	c3                   	ret    

80104134 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80104134:	55                   	push   %ebp
80104135:	89 e5                	mov    %esp,%ebp
80104137:	83 ec 08             	sub    $0x8,%esp
  acquire(&p->lock);
8010413a:	8b 45 08             	mov    0x8(%ebp),%eax
8010413d:	83 ec 0c             	sub    $0xc,%esp
80104140:	50                   	push   %eax
80104141:	e8 2a 14 00 00       	call   80105570 <acquire>
80104146:	83 c4 10             	add    $0x10,%esp
  if(writable){
80104149:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010414d:	74 23                	je     80104172 <pipeclose+0x3e>
    p->writeopen = 0;
8010414f:	8b 45 08             	mov    0x8(%ebp),%eax
80104152:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80104159:	00 00 00 
    wakeup(&p->nread);
8010415c:	8b 45 08             	mov    0x8(%ebp),%eax
8010415f:	05 34 02 00 00       	add    $0x234,%eax
80104164:	83 ec 0c             	sub    $0xc,%esp
80104167:	50                   	push   %eax
80104168:	e8 e1 11 00 00       	call   8010534e <wakeup>
8010416d:	83 c4 10             	add    $0x10,%esp
80104170:	eb 21                	jmp    80104193 <pipeclose+0x5f>
  } else {
    p->readopen = 0;
80104172:	8b 45 08             	mov    0x8(%ebp),%eax
80104175:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
8010417c:	00 00 00 
    wakeup(&p->nwrite);
8010417f:	8b 45 08             	mov    0x8(%ebp),%eax
80104182:	05 38 02 00 00       	add    $0x238,%eax
80104187:	83 ec 0c             	sub    $0xc,%esp
8010418a:	50                   	push   %eax
8010418b:	e8 be 11 00 00       	call   8010534e <wakeup>
80104190:	83 c4 10             	add    $0x10,%esp
  }
  if(p->readopen == 0 && p->writeopen == 0){
80104193:	8b 45 08             	mov    0x8(%ebp),%eax
80104196:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
8010419c:	85 c0                	test   %eax,%eax
8010419e:	75 2c                	jne    801041cc <pipeclose+0x98>
801041a0:	8b 45 08             	mov    0x8(%ebp),%eax
801041a3:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
801041a9:	85 c0                	test   %eax,%eax
801041ab:	75 1f                	jne    801041cc <pipeclose+0x98>
    release(&p->lock);
801041ad:	8b 45 08             	mov    0x8(%ebp),%eax
801041b0:	83 ec 0c             	sub    $0xc,%esp
801041b3:	50                   	push   %eax
801041b4:	e8 1e 14 00 00       	call   801055d7 <release>
801041b9:	83 c4 10             	add    $0x10,%esp
    kfree((char*)p);
801041bc:	83 ec 0c             	sub    $0xc,%esp
801041bf:	ff 75 08             	pushl  0x8(%ebp)
801041c2:	e8 b8 e9 ff ff       	call   80102b7f <kfree>
801041c7:	83 c4 10             	add    $0x10,%esp
801041ca:	eb 0f                	jmp    801041db <pipeclose+0xa7>
  } else
    release(&p->lock);
801041cc:	8b 45 08             	mov    0x8(%ebp),%eax
801041cf:	83 ec 0c             	sub    $0xc,%esp
801041d2:	50                   	push   %eax
801041d3:	e8 ff 13 00 00       	call   801055d7 <release>
801041d8:	83 c4 10             	add    $0x10,%esp
}
801041db:	90                   	nop
801041dc:	c9                   	leave  
801041dd:	c3                   	ret    

801041de <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801041de:	55                   	push   %ebp
801041df:	89 e5                	mov    %esp,%ebp
801041e1:	83 ec 18             	sub    $0x18,%esp
  int i;

  acquire(&p->lock);
801041e4:	8b 45 08             	mov    0x8(%ebp),%eax
801041e7:	83 ec 0c             	sub    $0xc,%esp
801041ea:	50                   	push   %eax
801041eb:	e8 80 13 00 00       	call   80105570 <acquire>
801041f0:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++){
801041f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801041fa:	e9 ad 00 00 00       	jmp    801042ac <pipewrite+0xce>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
801041ff:	8b 45 08             	mov    0x8(%ebp),%eax
80104202:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80104208:	85 c0                	test   %eax,%eax
8010420a:	74 0d                	je     80104219 <pipewrite+0x3b>
8010420c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104212:	8b 40 24             	mov    0x24(%eax),%eax
80104215:	85 c0                	test   %eax,%eax
80104217:	74 19                	je     80104232 <pipewrite+0x54>
        release(&p->lock);
80104219:	8b 45 08             	mov    0x8(%ebp),%eax
8010421c:	83 ec 0c             	sub    $0xc,%esp
8010421f:	50                   	push   %eax
80104220:	e8 b2 13 00 00       	call   801055d7 <release>
80104225:	83 c4 10             	add    $0x10,%esp
        return -1;
80104228:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010422d:	e9 a8 00 00 00       	jmp    801042da <pipewrite+0xfc>
      }
      wakeup(&p->nread);
80104232:	8b 45 08             	mov    0x8(%ebp),%eax
80104235:	05 34 02 00 00       	add    $0x234,%eax
8010423a:	83 ec 0c             	sub    $0xc,%esp
8010423d:	50                   	push   %eax
8010423e:	e8 0b 11 00 00       	call   8010534e <wakeup>
80104243:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80104246:	8b 45 08             	mov    0x8(%ebp),%eax
80104249:	8b 55 08             	mov    0x8(%ebp),%edx
8010424c:	81 c2 38 02 00 00    	add    $0x238,%edx
80104252:	83 ec 08             	sub    $0x8,%esp
80104255:	50                   	push   %eax
80104256:	52                   	push   %edx
80104257:	e8 04 10 00 00       	call   80105260 <sleep>
8010425c:	83 c4 10             	add    $0x10,%esp
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010425f:	8b 45 08             	mov    0x8(%ebp),%eax
80104262:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80104268:	8b 45 08             	mov    0x8(%ebp),%eax
8010426b:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104271:	05 00 02 00 00       	add    $0x200,%eax
80104276:	39 c2                	cmp    %eax,%edx
80104278:	74 85                	je     801041ff <pipewrite+0x21>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010427a:	8b 45 08             	mov    0x8(%ebp),%eax
8010427d:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104283:	8d 48 01             	lea    0x1(%eax),%ecx
80104286:	8b 55 08             	mov    0x8(%ebp),%edx
80104289:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
8010428f:	25 ff 01 00 00       	and    $0x1ff,%eax
80104294:	89 c1                	mov    %eax,%ecx
80104296:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104299:	8b 45 0c             	mov    0xc(%ebp),%eax
8010429c:	01 d0                	add    %edx,%eax
8010429e:	0f b6 10             	movzbl (%eax),%edx
801042a1:	8b 45 08             	mov    0x8(%ebp),%eax
801042a4:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
801042a8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801042ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042af:	3b 45 10             	cmp    0x10(%ebp),%eax
801042b2:	7c ab                	jl     8010425f <pipewrite+0x81>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801042b4:	8b 45 08             	mov    0x8(%ebp),%eax
801042b7:	05 34 02 00 00       	add    $0x234,%eax
801042bc:	83 ec 0c             	sub    $0xc,%esp
801042bf:	50                   	push   %eax
801042c0:	e8 89 10 00 00       	call   8010534e <wakeup>
801042c5:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801042c8:	8b 45 08             	mov    0x8(%ebp),%eax
801042cb:	83 ec 0c             	sub    $0xc,%esp
801042ce:	50                   	push   %eax
801042cf:	e8 03 13 00 00       	call   801055d7 <release>
801042d4:	83 c4 10             	add    $0x10,%esp
  return n;
801042d7:	8b 45 10             	mov    0x10(%ebp),%eax
}
801042da:	c9                   	leave  
801042db:	c3                   	ret    

801042dc <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801042dc:	55                   	push   %ebp
801042dd:	89 e5                	mov    %esp,%ebp
801042df:	53                   	push   %ebx
801042e0:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&p->lock);
801042e3:	8b 45 08             	mov    0x8(%ebp),%eax
801042e6:	83 ec 0c             	sub    $0xc,%esp
801042e9:	50                   	push   %eax
801042ea:	e8 81 12 00 00       	call   80105570 <acquire>
801042ef:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801042f2:	eb 3f                	jmp    80104333 <piperead+0x57>
    if(proc->killed){
801042f4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801042fa:	8b 40 24             	mov    0x24(%eax),%eax
801042fd:	85 c0                	test   %eax,%eax
801042ff:	74 19                	je     8010431a <piperead+0x3e>
      release(&p->lock);
80104301:	8b 45 08             	mov    0x8(%ebp),%eax
80104304:	83 ec 0c             	sub    $0xc,%esp
80104307:	50                   	push   %eax
80104308:	e8 ca 12 00 00       	call   801055d7 <release>
8010430d:	83 c4 10             	add    $0x10,%esp
      return -1;
80104310:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104315:	e9 bf 00 00 00       	jmp    801043d9 <piperead+0xfd>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
8010431a:	8b 45 08             	mov    0x8(%ebp),%eax
8010431d:	8b 55 08             	mov    0x8(%ebp),%edx
80104320:	81 c2 34 02 00 00    	add    $0x234,%edx
80104326:	83 ec 08             	sub    $0x8,%esp
80104329:	50                   	push   %eax
8010432a:	52                   	push   %edx
8010432b:	e8 30 0f 00 00       	call   80105260 <sleep>
80104330:	83 c4 10             	add    $0x10,%esp
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104333:	8b 45 08             	mov    0x8(%ebp),%eax
80104336:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
8010433c:	8b 45 08             	mov    0x8(%ebp),%eax
8010433f:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104345:	39 c2                	cmp    %eax,%edx
80104347:	75 0d                	jne    80104356 <piperead+0x7a>
80104349:	8b 45 08             	mov    0x8(%ebp),%eax
8010434c:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80104352:	85 c0                	test   %eax,%eax
80104354:	75 9e                	jne    801042f4 <piperead+0x18>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104356:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010435d:	eb 49                	jmp    801043a8 <piperead+0xcc>
    if(p->nread == p->nwrite)
8010435f:	8b 45 08             	mov    0x8(%ebp),%eax
80104362:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104368:	8b 45 08             	mov    0x8(%ebp),%eax
8010436b:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104371:	39 c2                	cmp    %eax,%edx
80104373:	74 3d                	je     801043b2 <piperead+0xd6>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80104375:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104378:	8b 45 0c             	mov    0xc(%ebp),%eax
8010437b:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
8010437e:	8b 45 08             	mov    0x8(%ebp),%eax
80104381:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104387:	8d 48 01             	lea    0x1(%eax),%ecx
8010438a:	8b 55 08             	mov    0x8(%ebp),%edx
8010438d:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
80104393:	25 ff 01 00 00       	and    $0x1ff,%eax
80104398:	89 c2                	mov    %eax,%edx
8010439a:	8b 45 08             	mov    0x8(%ebp),%eax
8010439d:	0f b6 44 10 34       	movzbl 0x34(%eax,%edx,1),%eax
801043a2:	88 03                	mov    %al,(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801043a4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801043a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043ab:	3b 45 10             	cmp    0x10(%ebp),%eax
801043ae:	7c af                	jl     8010435f <piperead+0x83>
801043b0:	eb 01                	jmp    801043b3 <piperead+0xd7>
    if(p->nread == p->nwrite)
      break;
801043b2:	90                   	nop
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801043b3:	8b 45 08             	mov    0x8(%ebp),%eax
801043b6:	05 38 02 00 00       	add    $0x238,%eax
801043bb:	83 ec 0c             	sub    $0xc,%esp
801043be:	50                   	push   %eax
801043bf:	e8 8a 0f 00 00       	call   8010534e <wakeup>
801043c4:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801043c7:	8b 45 08             	mov    0x8(%ebp),%eax
801043ca:	83 ec 0c             	sub    $0xc,%esp
801043cd:	50                   	push   %eax
801043ce:	e8 04 12 00 00       	call   801055d7 <release>
801043d3:	83 c4 10             	add    $0x10,%esp
  return i;
801043d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801043d9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043dc:	c9                   	leave  
801043dd:	c3                   	ret    

801043de <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
801043de:	55                   	push   %ebp
801043df:	89 e5                	mov    %esp,%ebp
801043e1:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801043e4:	9c                   	pushf  
801043e5:	58                   	pop    %eax
801043e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801043e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801043ec:	c9                   	leave  
801043ed:	c3                   	ret    

801043ee <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
801043ee:	55                   	push   %ebp
801043ef:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801043f1:	fb                   	sti    
}
801043f2:	90                   	nop
801043f3:	5d                   	pop    %ebp
801043f4:	c3                   	ret    

801043f5 <pinit>:
//int* exit_status;


void
pinit(void)
{
801043f5:	55                   	push   %ebp
801043f6:	89 e5                	mov    %esp,%ebp
801043f8:	83 ec 08             	sub    $0x8,%esp
  initlock(&ptable.lock, "ptable");
801043fb:	83 ec 08             	sub    $0x8,%esp
801043fe:	68 01 90 10 80       	push   $0x80109001
80104403:	68 80 39 11 80       	push   $0x80113980
80104408:	e8 41 11 00 00       	call   8010554e <initlock>
8010440d:	83 c4 10             	add    $0x10,%esp
}
80104410:	90                   	nop
80104411:	c9                   	leave  
80104412:	c3                   	ret    

80104413 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
struct proc*
allocproc(void)
{
80104413:	55                   	push   %ebp
80104414:	89 e5                	mov    %esp,%ebp
80104416:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
80104419:	83 ec 0c             	sub    $0xc,%esp
8010441c:	68 80 39 11 80       	push   $0x80113980
80104421:	e8 4a 11 00 00       	call   80105570 <acquire>
80104426:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104429:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104430:	eb 11                	jmp    80104443 <allocproc+0x30>
    if(p->state == UNUSED)
80104432:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104435:	8b 40 0c             	mov    0xc(%eax),%eax
80104438:	85 c0                	test   %eax,%eax
8010443a:	74 2a                	je     80104466 <allocproc+0x53>
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010443c:	81 45 f4 8c 00 00 00 	addl   $0x8c,-0xc(%ebp)
80104443:	81 7d f4 b4 5c 11 80 	cmpl   $0x80115cb4,-0xc(%ebp)
8010444a:	72 e6                	jb     80104432 <allocproc+0x1f>
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
8010444c:	83 ec 0c             	sub    $0xc,%esp
8010444f:	68 80 39 11 80       	push   $0x80113980
80104454:	e8 7e 11 00 00       	call   801055d7 <release>
80104459:	83 c4 10             	add    $0x10,%esp
  return 0;
8010445c:	b8 00 00 00 00       	mov    $0x0,%eax
80104461:	e9 db 00 00 00       	jmp    80104541 <allocproc+0x12e>
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
80104466:	90                   	nop
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
80104467:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010446a:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
80104471:	a1 04 c0 10 80       	mov    0x8010c004,%eax
80104476:	8d 50 01             	lea    0x1(%eax),%edx
80104479:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
8010447f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104482:	89 42 10             	mov    %eax,0x10(%edx)
  p->is_thread = 0; //thread_test
80104485:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104488:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010448f:	00 00 00 
  p->tid = 0;
80104492:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104495:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
8010449c:	00 00 00 
  p->numOfThread = 0 ;
8010449f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044a2:	c7 80 88 00 00 00 00 	movl   $0x0,0x88(%eax)
801044a9:	00 00 00 
  release(&ptable.lock);
801044ac:	83 ec 0c             	sub    $0xc,%esp
801044af:	68 80 39 11 80       	push   $0x80113980
801044b4:	e8 1e 11 00 00       	call   801055d7 <release>
801044b9:	83 c4 10             	add    $0x10,%esp

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801044bc:	e8 68 e7 ff ff       	call   80102c29 <kalloc>
801044c1:	89 c2                	mov    %eax,%edx
801044c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044c6:	89 50 08             	mov    %edx,0x8(%eax)
801044c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044cc:	8b 40 08             	mov    0x8(%eax),%eax
801044cf:	85 c0                	test   %eax,%eax
801044d1:	75 11                	jne    801044e4 <allocproc+0xd1>
    p->state = UNUSED;
801044d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044d6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
801044dd:	b8 00 00 00 00       	mov    $0x0,%eax
801044e2:	eb 5d                	jmp    80104541 <allocproc+0x12e>
  }
  sp = p->kstack + KSTACKSIZE;
801044e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044e7:	8b 40 08             	mov    0x8(%eax),%eax
801044ea:	05 00 10 00 00       	add    $0x1000,%eax
801044ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801044f2:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
801044f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044f9:	8b 55 f0             	mov    -0x10(%ebp),%edx
801044fc:	89 50 18             	mov    %edx,0x18(%eax)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
801044ff:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
80104503:	ba 78 6d 10 80       	mov    $0x80106d78,%edx
80104508:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010450b:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
8010450d:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
80104511:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104514:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104517:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
8010451a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010451d:	8b 40 1c             	mov    0x1c(%eax),%eax
80104520:	83 ec 04             	sub    $0x4,%esp
80104523:	6a 14                	push   $0x14
80104525:	6a 00                	push   $0x0
80104527:	50                   	push   %eax
80104528:	e8 a6 12 00 00       	call   801057d3 <memset>
8010452d:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80104530:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104533:	8b 40 1c             	mov    0x1c(%eax),%eax
80104536:	ba 1a 52 10 80       	mov    $0x8010521a,%edx
8010453b:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
8010453e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104541:	c9                   	leave  
80104542:	c3                   	ret    

80104543 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80104543:	55                   	push   %ebp
80104544:	89 e5                	mov    %esp,%ebp
80104546:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
80104549:	e8 c5 fe ff ff       	call   80104413 <allocproc>
8010454e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
80104551:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104554:	a3 6c c6 10 80       	mov    %eax,0x8010c66c
  if((p->pgdir = setupkvm()) == 0)
80104559:	e8 c9 3e 00 00       	call   80108427 <setupkvm>
8010455e:	89 c2                	mov    %eax,%edx
80104560:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104563:	89 50 04             	mov    %edx,0x4(%eax)
80104566:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104569:	8b 40 04             	mov    0x4(%eax),%eax
8010456c:	85 c0                	test   %eax,%eax
8010456e:	75 0d                	jne    8010457d <userinit+0x3a>
    panic("userinit: out of memory?");
80104570:	83 ec 0c             	sub    $0xc,%esp
80104573:	68 08 90 10 80       	push   $0x80109008
80104578:	e8 e9 bf ff ff       	call   80100566 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
8010457d:	ba 2c 00 00 00       	mov    $0x2c,%edx
80104582:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104585:	8b 40 04             	mov    0x4(%eax),%eax
80104588:	83 ec 04             	sub    $0x4,%esp
8010458b:	52                   	push   %edx
8010458c:	68 04 c5 10 80       	push   $0x8010c504
80104591:	50                   	push   %eax
80104592:	e8 ea 40 00 00       	call   80108681 <inituvm>
80104597:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
8010459a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010459d:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
801045a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045a6:	8b 40 18             	mov    0x18(%eax),%eax
801045a9:	83 ec 04             	sub    $0x4,%esp
801045ac:	6a 4c                	push   $0x4c
801045ae:	6a 00                	push   $0x0
801045b0:	50                   	push   %eax
801045b1:	e8 1d 12 00 00       	call   801057d3 <memset>
801045b6:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801045b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045bc:	8b 40 18             	mov    0x18(%eax),%eax
801045bf:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801045c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045c8:	8b 40 18             	mov    0x18(%eax),%eax
801045cb:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
801045d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045d4:	8b 40 18             	mov    0x18(%eax),%eax
801045d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801045da:	8b 52 18             	mov    0x18(%edx),%edx
801045dd:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
801045e1:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801045e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045e8:	8b 40 18             	mov    0x18(%eax),%eax
801045eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
801045ee:	8b 52 18             	mov    0x18(%edx),%edx
801045f1:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
801045f5:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801045f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045fc:	8b 40 18             	mov    0x18(%eax),%eax
801045ff:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80104606:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104609:	8b 40 18             	mov    0x18(%eax),%eax
8010460c:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104613:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104616:	8b 40 18             	mov    0x18(%eax),%eax
80104619:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80104620:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104623:	83 c0 6c             	add    $0x6c,%eax
80104626:	83 ec 04             	sub    $0x4,%esp
80104629:	6a 10                	push   $0x10
8010462b:	68 21 90 10 80       	push   $0x80109021
80104630:	50                   	push   %eax
80104631:	e8 a0 13 00 00       	call   801059d6 <safestrcpy>
80104636:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
80104639:	83 ec 0c             	sub    $0xc,%esp
8010463c:	68 2a 90 10 80       	push   $0x8010902a
80104641:	e8 98 de ff ff       	call   801024de <namei>
80104646:	83 c4 10             	add    $0x10,%esp
80104649:	89 c2                	mov    %eax,%edx
8010464b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010464e:	89 50 68             	mov    %edx,0x68(%eax)

  p->state = RUNNABLE;
80104651:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104654:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
}
8010465b:	90                   	nop
8010465c:	c9                   	leave  
8010465d:	c3                   	ret    

8010465e <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
8010465e:	55                   	push   %ebp
8010465f:	89 e5                	mov    %esp,%ebp
80104661:	83 ec 18             	sub    $0x18,%esp
  uint sz;
  
  sz = proc->sz;
80104664:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010466a:	8b 00                	mov    (%eax),%eax
8010466c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
8010466f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104673:	7e 31                	jle    801046a6 <growproc+0x48>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
80104675:	8b 55 08             	mov    0x8(%ebp),%edx
80104678:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010467b:	01 c2                	add    %eax,%edx
8010467d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104683:	8b 40 04             	mov    0x4(%eax),%eax
80104686:	83 ec 04             	sub    $0x4,%esp
80104689:	52                   	push   %edx
8010468a:	ff 75 f4             	pushl  -0xc(%ebp)
8010468d:	50                   	push   %eax
8010468e:	e8 3b 41 00 00       	call   801087ce <allocuvm>
80104693:	83 c4 10             	add    $0x10,%esp
80104696:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104699:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010469d:	75 3e                	jne    801046dd <growproc+0x7f>
      return -1;
8010469f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046a4:	eb 59                	jmp    801046ff <growproc+0xa1>
  } else if(n < 0){
801046a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801046aa:	79 31                	jns    801046dd <growproc+0x7f>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
801046ac:	8b 55 08             	mov    0x8(%ebp),%edx
801046af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046b2:	01 c2                	add    %eax,%edx
801046b4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046ba:	8b 40 04             	mov    0x4(%eax),%eax
801046bd:	83 ec 04             	sub    $0x4,%esp
801046c0:	52                   	push   %edx
801046c1:	ff 75 f4             	pushl  -0xc(%ebp)
801046c4:	50                   	push   %eax
801046c5:	e8 cd 41 00 00       	call   80108897 <deallocuvm>
801046ca:	83 c4 10             	add    $0x10,%esp
801046cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
801046d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801046d4:	75 07                	jne    801046dd <growproc+0x7f>
      return -1;
801046d6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046db:	eb 22                	jmp    801046ff <growproc+0xa1>
  }
  proc->sz = sz;
801046dd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801046e6:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
801046e8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046ee:	83 ec 0c             	sub    $0xc,%esp
801046f1:	50                   	push   %eax
801046f2:	e8 17 3e 00 00       	call   8010850e <switchuvm>
801046f7:	83 c4 10             	add    $0x10,%esp
  return 0;
801046fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
801046ff:	c9                   	leave  
80104700:	c3                   	ret    

80104701 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80104701:	55                   	push   %ebp
80104702:	89 e5                	mov    %esp,%ebp
80104704:	57                   	push   %edi
80104705:	56                   	push   %esi
80104706:	53                   	push   %ebx
80104707:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
8010470a:	e8 04 fd ff ff       	call   80104413 <allocproc>
8010470f:	89 45 e0             	mov    %eax,-0x20(%ebp)
80104712:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80104716:	75 0a                	jne    80104722 <fork+0x21>
    return -1;
80104718:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010471d:	e9 7d 01 00 00       	jmp    8010489f <fork+0x19e>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
80104722:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104728:	8b 10                	mov    (%eax),%edx
8010472a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104730:	8b 40 04             	mov    0x4(%eax),%eax
80104733:	83 ec 08             	sub    $0x8,%esp
80104736:	52                   	push   %edx
80104737:	50                   	push   %eax
80104738:	e8 f8 42 00 00       	call   80108a35 <copyuvm>
8010473d:	83 c4 10             	add    $0x10,%esp
80104740:	89 c2                	mov    %eax,%edx
80104742:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104745:	89 50 04             	mov    %edx,0x4(%eax)
80104748:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010474b:	8b 40 04             	mov    0x4(%eax),%eax
8010474e:	85 c0                	test   %eax,%eax
80104750:	75 30                	jne    80104782 <fork+0x81>
    kfree(np->kstack);
80104752:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104755:	8b 40 08             	mov    0x8(%eax),%eax
80104758:	83 ec 0c             	sub    $0xc,%esp
8010475b:	50                   	push   %eax
8010475c:	e8 1e e4 ff ff       	call   80102b7f <kfree>
80104761:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
80104764:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104767:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
8010476e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104771:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
80104778:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010477d:	e9 1d 01 00 00       	jmp    8010489f <fork+0x19e>
  }
  np->sz = proc->sz;
80104782:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104788:	8b 10                	mov    (%eax),%edx
8010478a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010478d:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
8010478f:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104796:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104799:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
8010479c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010479f:	8b 50 18             	mov    0x18(%eax),%edx
801047a2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047a8:	8b 40 18             	mov    0x18(%eax),%eax
801047ab:	89 c3                	mov    %eax,%ebx
801047ad:	b8 13 00 00 00       	mov    $0x13,%eax
801047b2:	89 d7                	mov    %edx,%edi
801047b4:	89 de                	mov    %ebx,%esi
801047b6:	89 c1                	mov    %eax,%ecx
801047b8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  np->is_thread = proc->is_thread;    //thread test
801047ba:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047c0:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
801047c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047c9:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
801047cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047d2:	8b 40 18             	mov    0x18(%eax),%eax
801047d5:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
801047dc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801047e3:	eb 43                	jmp    80104828 <fork+0x127>
    if(proc->ofile[i])
801047e5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047eb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801047ee:	83 c2 08             	add    $0x8,%edx
801047f1:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801047f5:	85 c0                	test   %eax,%eax
801047f7:	74 2b                	je     80104824 <fork+0x123>
      np->ofile[i] = filedup(proc->ofile[i]);
801047f9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047ff:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104802:	83 c2 08             	add    $0x8,%edx
80104805:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104809:	83 ec 0c             	sub    $0xc,%esp
8010480c:	50                   	push   %eax
8010480d:	e8 ee c7 ff ff       	call   80101000 <filedup>
80104812:	83 c4 10             	add    $0x10,%esp
80104815:	89 c1                	mov    %eax,%ecx
80104817:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010481a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010481d:	83 c2 08             	add    $0x8,%edx
80104820:	89 4c 90 08          	mov    %ecx,0x8(%eax,%edx,4)
  *np->tf = *proc->tf;
  np->is_thread = proc->is_thread;    //thread test
  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80104824:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104828:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
8010482c:	7e b7                	jle    801047e5 <fork+0xe4>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
8010482e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104834:	8b 40 68             	mov    0x68(%eax),%eax
80104837:	83 ec 0c             	sub    $0xc,%esp
8010483a:	50                   	push   %eax
8010483b:	e8 a6 d0 ff ff       	call   801018e6 <idup>
80104840:	83 c4 10             	add    $0x10,%esp
80104843:	89 c2                	mov    %eax,%edx
80104845:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104848:	89 50 68             	mov    %edx,0x68(%eax)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
8010484b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104851:	8d 50 6c             	lea    0x6c(%eax),%edx
80104854:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104857:	83 c0 6c             	add    $0x6c,%eax
8010485a:	83 ec 04             	sub    $0x4,%esp
8010485d:	6a 10                	push   $0x10
8010485f:	52                   	push   %edx
80104860:	50                   	push   %eax
80104861:	e8 70 11 00 00       	call   801059d6 <safestrcpy>
80104866:	83 c4 10             	add    $0x10,%esp
 
  pid = np->pid;
80104869:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010486c:	8b 40 10             	mov    0x10(%eax),%eax
8010486f:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
80104872:	83 ec 0c             	sub    $0xc,%esp
80104875:	68 80 39 11 80       	push   $0x80113980
8010487a:	e8 f1 0c 00 00       	call   80105570 <acquire>
8010487f:	83 c4 10             	add    $0x10,%esp
  np->state = RUNNABLE;
80104882:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104885:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
 
  release(&ptable.lock);
8010488c:	83 ec 0c             	sub    $0xc,%esp
8010488f:	68 80 39 11 80       	push   $0x80113980
80104894:	e8 3e 0d 00 00       	call   801055d7 <release>
80104899:	83 c4 10             	add    $0x10,%esp
  
  return pid;
8010489c:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
8010489f:	8d 65 f4             	lea    -0xc(%ebp),%esp
801048a2:	5b                   	pop    %ebx
801048a3:	5e                   	pop    %esi
801048a4:	5f                   	pop    %edi
801048a5:	5d                   	pop    %ebp
801048a6:	c3                   	ret    

801048a7 <clone>:




int 
clone(void *(*function)(void*),void *arg,void* stack){
801048a7:	55                   	push   %ebp
801048a8:	89 e5                	mov    %esp,%ebp
801048aa:	57                   	push   %edi
801048ab:	56                   	push   %esi
801048ac:	53                   	push   %ebx
801048ad:	83 ec 1c             	sub    $0x1c,%esp
  int i;//, pid;
  struct proc *np;
  
  if(proc->numOfThread == 7)
801048b0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048b6:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
801048bc:	83 f8 07             	cmp    $0x7,%eax
801048bf:	75 0a                	jne    801048cb <clone+0x24>
      return -1;
801048c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048c6:	e9 21 02 00 00       	jmp    80104aec <clone+0x245>

  if((np = allocproc()) == 0)
801048cb:	e8 43 fb ff ff       	call   80104413 <allocproc>
801048d0:	89 45 d8             	mov    %eax,-0x28(%ebp)
801048d3:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
801048d7:	75 0a                	jne    801048e3 <clone+0x3c>
    return -1;
801048d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048de:	e9 09 02 00 00       	jmp    80104aec <clone+0x245>

  int tid = proc->tid;
801048e3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048e9:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
801048ef:	89 45 e0             	mov    %eax,-0x20(%ebp)
  //page는 똑같음
  np->pgdir = proc->pgdir;
801048f2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048f8:	8b 50 04             	mov    0x4(%eax),%edx
801048fb:	8b 45 d8             	mov    -0x28(%ebp),%eax
801048fe:	89 50 04             	mov    %edx,0x4(%eax)
  //stack 할당을 어떻게 해줘야할까>
  np->sz = proc->sz;
80104901:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104907:	8b 10                	mov    (%eax),%edx
80104909:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010490c:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
8010490e:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104915:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104918:	89 50 14             	mov    %edx,0x14(%eax)
  np->is_thread = 1;
8010491b:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010491e:	c7 80 80 00 00 00 01 	movl   $0x1,0x80(%eax)
80104925:	00 00 00 
  //trap frame 도 위치가 같다. 
  *np->tf = *proc->tf;
80104928:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010492b:	8b 50 18             	mov    0x18(%eax),%edx
8010492e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104934:	8b 40 18             	mov    0x18(%eax),%eax
80104937:	89 c3                	mov    %eax,%ebx
80104939:	b8 13 00 00 00       	mov    $0x13,%eax
8010493e:	89 d7                	mov    %edx,%edi
80104940:	89 de                	mov    %ebx,%esi
80104942:	89 c1                	mov    %eax,%ecx
80104944:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80104946:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104949:	8b 40 18             	mov    0x18(%eax),%eax
8010494c:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80104953:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010495a:	eb 43                	jmp    8010499f <clone+0xf8>
    if(proc->ofile[i])
8010495c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104962:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104965:	83 c2 08             	add    $0x8,%edx
80104968:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010496c:	85 c0                	test   %eax,%eax
8010496e:	74 2b                	je     8010499b <clone+0xf4>
      np->ofile[i] = filedup(proc->ofile[i]);
80104970:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104976:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104979:	83 c2 08             	add    $0x8,%edx
8010497c:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104980:	83 ec 0c             	sub    $0xc,%esp
80104983:	50                   	push   %eax
80104984:	e8 77 c6 ff ff       	call   80101000 <filedup>
80104989:	83 c4 10             	add    $0x10,%esp
8010498c:	89 c1                	mov    %eax,%ecx
8010498e:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104991:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104994:	83 c2 08             	add    $0x8,%edx
80104997:	89 4c 90 08          	mov    %ecx,0x8(%eax,%edx,4)
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
8010499b:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
8010499f:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
801049a3:	7e b7                	jle    8010495c <clone+0xb5>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
801049a5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049ab:	8b 40 68             	mov    0x68(%eax),%eax
801049ae:	83 ec 0c             	sub    $0xc,%esp
801049b1:	50                   	push   %eax
801049b2:	e8 2f cf ff ff       	call   801018e6 <idup>
801049b7:	83 c4 10             	add    $0x10,%esp
801049ba:	89 c2                	mov    %eax,%edx
801049bc:	8b 45 d8             	mov    -0x28(%ebp),%eax
801049bf:	89 50 68             	mov    %edx,0x68(%eax)

 // lock to force the compiler to emit the np->state write last.
 safestrcpy(np->name, proc->name, sizeof(proc->name));
801049c2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049c8:	8d 50 6c             	lea    0x6c(%eax),%edx
801049cb:	8b 45 d8             	mov    -0x28(%ebp),%eax
801049ce:	83 c0 6c             	add    $0x6c,%eax
801049d1:	83 ec 04             	sub    $0x4,%esp
801049d4:	6a 10                	push   $0x10
801049d6:	52                   	push   %edx
801049d7:	50                   	push   %eax
801049d8:	e8 f9 0f 00 00       	call   801059d6 <safestrcpy>
801049dd:	83 c4 10             	add    $0x10,%esp

  //int  pid = np->pid;
  np->pid = proc->pid;
801049e0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049e6:	8b 50 10             	mov    0x10(%eax),%edx
801049e9:	8b 45 d8             	mov    -0x28(%ebp),%eax
801049ec:	89 50 10             	mov    %edx,0x10(%eax)
  nextpid--;
801049ef:	a1 04 c0 10 80       	mov    0x8010c004,%eax
801049f4:	83 e8 01             	sub    $0x1,%eax
801049f7:	a3 04 c0 10 80       	mov    %eax,0x8010c004

  //tid 찾기 
  struct proc *p;
  for(p = ptable.proc ; p < &ptable.proc[NPROC] ; p++){
801049fc:	c7 45 dc b4 39 11 80 	movl   $0x801139b4,-0x24(%ebp)
80104a03:	eb 4a                	jmp    80104a4f <clone+0x1a8>
      if(p->pid == proc->pid && p->is_thread == 0){
80104a05:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104a08:	8b 50 10             	mov    0x10(%eax),%edx
80104a0b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a11:	8b 40 10             	mov    0x10(%eax),%eax
80104a14:	39 c2                	cmp    %eax,%edx
80104a16:	75 30                	jne    80104a48 <clone+0x1a1>
80104a18:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104a1b:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104a21:	85 c0                	test   %eax,%eax
80104a23:	75 23                	jne    80104a48 <clone+0x1a1>
           tid = ++(p->numOfThread);
80104a25:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104a28:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
80104a2e:	8d 50 01             	lea    0x1(%eax),%edx
80104a31:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104a34:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
80104a3a:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104a3d:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
80104a43:	89 45 e0             	mov    %eax,-0x20(%ebp)
           break;
80104a46:	eb 10                	jmp    80104a58 <clone+0x1b1>
  np->pid = proc->pid;
  nextpid--;

  //tid 찾기 
  struct proc *p;
  for(p = ptable.proc ; p < &ptable.proc[NPROC] ; p++){
80104a48:	81 45 dc 8c 00 00 00 	addl   $0x8c,-0x24(%ebp)
80104a4f:	81 7d dc b4 5c 11 80 	cmpl   $0x80115cb4,-0x24(%ebp)
80104a56:	72 ad                	jb     80104a05 <clone+0x15e>
           tid = ++(p->numOfThread);
           break;
      }
  }

  np->tid = tid;
80104a58:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104a5b:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104a5e:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
   
  stack = stack - sizeof(void*);
80104a64:	83 6d 10 04          	subl   $0x4,0x10(%ebp)
  *(uint*)stack = (uint)arg;
80104a68:	8b 55 0c             	mov    0xc(%ebp),%edx
80104a6b:	8b 45 10             	mov    0x10(%ebp),%eax
80104a6e:	89 10                	mov    %edx,(%eax)
  stack = stack - sizeof(void*);
80104a70:	83 6d 10 04          	subl   $0x4,0x10(%ebp)
  *(uint*)stack = 0xFFFFFFFF;
80104a74:	8b 45 10             	mov    0x10(%ebp),%eax
80104a77:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)

  np->tf->eip = (uint)function;
80104a7d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104a80:	8b 40 18             	mov    0x18(%eax),%eax
80104a83:	8b 55 08             	mov    0x8(%ebp),%edx
80104a86:	89 50 38             	mov    %edx,0x38(%eax)
  np->tf->esp = (uint)stack;
80104a89:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104a8c:	8b 40 18             	mov    0x18(%eax),%eax
80104a8f:	8b 55 10             	mov    0x10(%ebp),%edx
80104a92:	89 50 44             	mov    %edx,0x44(%eax)
  np->tf->ebp = np->tf ->esp;
80104a95:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104a98:	8b 40 18             	mov    0x18(%eax),%eax
80104a9b:	8b 55 d8             	mov    -0x28(%ebp),%edx
80104a9e:	8b 52 18             	mov    0x18(%edx),%edx
80104aa1:	8b 52 44             	mov    0x44(%edx),%edx
80104aa4:	89 50 08             	mov    %edx,0x8(%eax)
  
  
  acquire(&ptable.lock);
80104aa7:	83 ec 0c             	sub    $0xc,%esp
80104aaa:	68 80 39 11 80       	push   $0x80113980
80104aaf:	e8 bc 0a 00 00       	call   80105570 <acquire>
80104ab4:	83 c4 10             	add    $0x10,%esp
  np->state = RUNNABLE;
80104ab7:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104aba:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  //for test7
  proc->state = RUNNABLE;
80104ac1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ac7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched(); 
80104ace:	e8 50 06 00 00       	call   80105123 <sched>
  release(&ptable.lock);
80104ad3:	83 ec 0c             	sub    $0xc,%esp
80104ad6:	68 80 39 11 80       	push   $0x80113980
80104adb:	e8 f7 0a 00 00       	call   801055d7 <release>
80104ae0:	83 c4 10             	add    $0x10,%esp
  return np->tid;
80104ae3:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104ae6:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax


}
80104aec:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104aef:	5b                   	pop    %ebx
80104af0:	5e                   	pop    %esi
80104af1:	5f                   	pop    %edi
80104af2:	5d                   	pop    %ebp
80104af3:	c3                   	ret    

80104af4 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80104af4:	55                   	push   %ebp
80104af5:	89 e5                	mov    %esp,%ebp
80104af7:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
80104afa:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104b01:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
80104b06:	39 c2                	cmp    %eax,%edx
80104b08:	75 0d                	jne    80104b17 <exit+0x23>
    panic("init exiting");
80104b0a:	83 ec 0c             	sub    $0xc,%esp
80104b0d:	68 2c 90 10 80       	push   $0x8010902c
80104b12:	e8 4f ba ff ff       	call   80100566 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104b17:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104b1e:	eb 48                	jmp    80104b68 <exit+0x74>
    if(proc->ofile[fd]){
80104b20:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b26:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104b29:	83 c2 08             	add    $0x8,%edx
80104b2c:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104b30:	85 c0                	test   %eax,%eax
80104b32:	74 30                	je     80104b64 <exit+0x70>
      fileclose(proc->ofile[fd]);
80104b34:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b3a:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104b3d:	83 c2 08             	add    $0x8,%edx
80104b40:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104b44:	83 ec 0c             	sub    $0xc,%esp
80104b47:	50                   	push   %eax
80104b48:	e8 04 c5 ff ff       	call   80101051 <fileclose>
80104b4d:	83 c4 10             	add    $0x10,%esp
      proc->ofile[fd] = 0;
80104b50:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b56:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104b59:	83 c2 08             	add    $0x8,%edx
80104b5c:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104b63:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104b64:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104b68:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104b6c:	7e b2                	jle    80104b20 <exit+0x2c>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
80104b6e:	e8 b4 e9 ff ff       	call   80103527 <begin_op>
  iput(proc->cwd);
80104b73:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b79:	8b 40 68             	mov    0x68(%eax),%eax
80104b7c:	83 ec 0c             	sub    $0xc,%esp
80104b7f:	50                   	push   %eax
80104b80:	e8 6b cf ff ff       	call   80101af0 <iput>
80104b85:	83 c4 10             	add    $0x10,%esp
  end_op();
80104b88:	e8 26 ea ff ff       	call   801035b3 <end_op>
  proc->cwd = 0;
80104b8d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b93:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80104b9a:	83 ec 0c             	sub    $0xc,%esp
80104b9d:	68 80 39 11 80       	push   $0x80113980
80104ba2:	e8 c9 09 00 00       	call   80105570 <acquire>
80104ba7:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80104baa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bb0:	8b 40 14             	mov    0x14(%eax),%eax
80104bb3:	83 ec 0c             	sub    $0xc,%esp
80104bb6:	50                   	push   %eax
80104bb7:	e8 50 07 00 00       	call   8010530c <wakeup1>
80104bbc:	83 c4 10             	add    $0x10,%esp


  // Pass abandoned children to init.
  // thread 에서exit 해도 mainthread종료시키는거 같다.
  // thread 에서 exit 하면 mainthread 종료
  if(proc->is_thread ==1){
80104bbf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bc5:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104bcb:	83 f8 01             	cmp    $0x1,%eax
80104bce:	0f 85 a2 00 00 00    	jne    80104c76 <exit+0x182>
    for(p = ptable.proc ; p<&ptable.proc[NPROC];p++){
80104bd4:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104bdb:	eb 7a                	jmp    80104c57 <exit+0x163>
        if(p->pid == proc->pid && p->is_thread == 0){
80104bdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104be0:	8b 50 10             	mov    0x10(%eax),%edx
80104be3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104be9:	8b 40 10             	mov    0x10(%eax),%eax
80104bec:	39 c2                	cmp    %eax,%edx
80104bee:	75 2b                	jne    80104c1b <exit+0x127>
80104bf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bf3:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104bf9:	85 c0                	test   %eax,%eax
80104bfb:	75 1e                	jne    80104c1b <exit+0x127>
            p->state = ZOMBIE;
80104bfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c00:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
            wakeup1(p->parent);
80104c07:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c0a:	8b 40 14             	mov    0x14(%eax),%eax
80104c0d:	83 ec 0c             	sub    $0xc,%esp
80104c10:	50                   	push   %eax
80104c11:	e8 f6 06 00 00       	call   8010530c <wakeup1>
80104c16:	83 c4 10             	add    $0x10,%esp
80104c19:	eb 35                	jmp    80104c50 <exit+0x15c>
        }else if (p->pid == proc->pid && p->is_thread ==1){
80104c1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c1e:	8b 50 10             	mov    0x10(%eax),%edx
80104c21:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c27:	8b 40 10             	mov    0x10(%eax),%eax
80104c2a:	39 c2                	cmp    %eax,%edx
80104c2c:	75 22                	jne    80104c50 <exit+0x15c>
80104c2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c31:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104c37:	83 f8 01             	cmp    $0x1,%eax
80104c3a:	75 14                	jne    80104c50 <exit+0x15c>
            p->parent=0;
80104c3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c3f:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
            p->state = ZOMBIE;
80104c46:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c49:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)

  // Pass abandoned children to init.
  // thread 에서exit 해도 mainthread종료시키는거 같다.
  // thread 에서 exit 하면 mainthread 종료
  if(proc->is_thread ==1){
    for(p = ptable.proc ; p<&ptable.proc[NPROC];p++){
80104c50:	81 45 f4 8c 00 00 00 	addl   $0x8c,-0xc(%ebp)
80104c57:	81 7d f4 b4 5c 11 80 	cmpl   $0x80115cb4,-0xc(%ebp)
80104c5e:	0f 82 79 ff ff ff    	jb     80104bdd <exit+0xe9>
        }else if (p->pid == proc->pid && p->is_thread ==1){
            p->parent=0;
            p->state = ZOMBIE;
        }
    }
    proc->state = ZOMBIE;
80104c64:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c6a:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
    sched();
80104c71:	e8 ad 04 00 00       	call   80105123 <sched>
  }


  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c76:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104c7d:	eb 68                	jmp    80104ce7 <exit+0x1f3>
     if(p->parent == proc){
80104c7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c82:	8b 50 14             	mov    0x14(%eax),%edx
80104c85:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c8b:	39 c2                	cmp    %eax,%edx
80104c8d:	75 51                	jne    80104ce0 <exit+0x1ec>
        if(p->pgdir != proc->pgdir){
80104c8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c92:	8b 50 04             	mov    0x4(%eax),%edx
80104c95:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c9b:	8b 40 04             	mov    0x4(%eax),%eax
80104c9e:	39 c2                	cmp    %eax,%edx
80104ca0:	74 2a                	je     80104ccc <exit+0x1d8>
                p->parent = initproc;
80104ca2:	8b 15 6c c6 10 80    	mov    0x8010c66c,%edx
80104ca8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cab:	89 50 14             	mov    %edx,0x14(%eax)
                if(p->state == ZOMBIE)
80104cae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cb1:	8b 40 0c             	mov    0xc(%eax),%eax
80104cb4:	83 f8 05             	cmp    $0x5,%eax
80104cb7:	75 27                	jne    80104ce0 <exit+0x1ec>
                   wakeup1(initproc);
80104cb9:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
80104cbe:	83 ec 0c             	sub    $0xc,%esp
80104cc1:	50                   	push   %eax
80104cc2:	e8 45 06 00 00       	call   8010530c <wakeup1>
80104cc7:	83 c4 10             	add    $0x10,%esp
80104cca:	eb 14                	jmp    80104ce0 <exit+0x1ec>
        }else{
            p->parent = 0;
80104ccc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ccf:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
            p->state = ZOMBIE;
80104cd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cd9:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
    proc->state = ZOMBIE;
    sched();
  }


  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ce0:	81 45 f4 8c 00 00 00 	addl   $0x8c,-0xc(%ebp)
80104ce7:	81 7d f4 b4 5c 11 80 	cmpl   $0x80115cb4,-0xc(%ebp)
80104cee:	72 8f                	jb     80104c7f <exit+0x18b>
     }

  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
80104cf0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cf6:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80104cfd:	e8 21 04 00 00       	call   80105123 <sched>
  panic("zombie exit");
80104d02:	83 ec 0c             	sub    $0xc,%esp
80104d05:	68 39 90 10 80       	push   $0x80109039
80104d0a:	e8 57 b8 ff ff       	call   80100566 <panic>

80104d0f <exit_thread>:
}
void
exit_thread(void* retval)
{
80104d0f:	55                   	push   %ebp
80104d10:	89 e5                	mov    %esp,%ebp
80104d12:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;


  //process의 exit status 지정 
  proc->exit_status = retval;
80104d15:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d1b:	8b 55 08             	mov    0x8(%ebp),%edx
80104d1e:	89 50 7c             	mov    %edx,0x7c(%eax)
 

  //main thread가 안끝나서 파일은 안지워야함.


  if(proc == initproc)
80104d21:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104d28:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
80104d2d:	39 c2                	cmp    %eax,%edx
80104d2f:	75 0d                	jne    80104d3e <exit_thread+0x2f>
    panic("init exiting");
80104d31:	83 ec 0c             	sub    $0xc,%esp
80104d34:	68 2c 90 10 80       	push   $0x8010902c
80104d39:	e8 28 b8 ff ff       	call   80100566 <panic>

  acquire(&ptable.lock);
80104d3e:	83 ec 0c             	sub    $0xc,%esp
80104d41:	68 80 39 11 80       	push   $0x80113980
80104d46:	e8 25 08 00 00       	call   80105570 <acquire>
80104d4b:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80104d4e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d54:	8b 40 14             	mov    0x14(%eax),%eax
80104d57:	83 ec 0c             	sub    $0xc,%esp
80104d5a:	50                   	push   %eax
80104d5b:	e8 ac 05 00 00       	call   8010530c <wakeup1>
80104d60:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d63:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104d6a:	eb 3f                	jmp    80104dab <exit_thread+0x9c>
    if(p->parent == proc){
80104d6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d6f:	8b 50 14             	mov    0x14(%eax),%edx
80104d72:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d78:	39 c2                	cmp    %eax,%edx
80104d7a:	75 28                	jne    80104da4 <exit_thread+0x95>
            p->parent = initproc;
80104d7c:	8b 15 6c c6 10 80    	mov    0x8010c66c,%edx
80104d82:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d85:	89 50 14             	mov    %edx,0x14(%eax)
            if(p->state == ZOMBIE)
80104d88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d8b:	8b 40 0c             	mov    0xc(%eax),%eax
80104d8e:	83 f8 05             	cmp    $0x5,%eax
80104d91:	75 11                	jne    80104da4 <exit_thread+0x95>
                wakeup1(initproc);
80104d93:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
80104d98:	83 ec 0c             	sub    $0xc,%esp
80104d9b:	50                   	push   %eax
80104d9c:	e8 6b 05 00 00       	call   8010530c <wakeup1>
80104da1:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104da4:	81 45 f4 8c 00 00 00 	addl   $0x8c,-0xc(%ebp)
80104dab:	81 7d f4 b4 5c 11 80 	cmpl   $0x80115cb4,-0xc(%ebp)
80104db2:	72 b8                	jb     80104d6c <exit_thread+0x5d>
    }
  }
            
  // Jump into the scheduler, never to return.
 // proc->state = ZOMBIE;
  proc->state = ZOMBIE;
80104db4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104dba:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80104dc1:	e8 5d 03 00 00       	call   80105123 <sched>
  panic("zombie exit");
80104dc6:	83 ec 0c             	sub    $0xc,%esp
80104dc9:	68 39 90 10 80       	push   $0x80109039
80104dce:	e8 93 b7 ff ff       	call   80100566 <panic>

80104dd3 <wait>:
}
// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104dd3:	55                   	push   %ebp
80104dd4:	89 e5                	mov    %esp,%ebp
80104dd6:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
80104dd9:	83 ec 0c             	sub    $0xc,%esp
80104ddc:	68 80 39 11 80       	push   $0x80113980
80104de1:	e8 8a 07 00 00       	call   80105570 <acquire>
80104de6:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
80104de9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104df0:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104df7:	e9 a9 00 00 00       	jmp    80104ea5 <wait+0xd2>
      if(p->parent != proc)
80104dfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dff:	8b 50 14             	mov    0x14(%eax),%edx
80104e02:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e08:	39 c2                	cmp    %eax,%edx
80104e0a:	0f 85 8d 00 00 00    	jne    80104e9d <wait+0xca>
        continue;
      havekids = 1;
80104e10:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104e17:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e1a:	8b 40 0c             	mov    0xc(%eax),%eax
80104e1d:	83 f8 05             	cmp    $0x5,%eax
80104e20:	75 7c                	jne    80104e9e <wait+0xcb>
        // Found one.
        pid = p->pid;
80104e22:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e25:	8b 40 10             	mov    0x10(%eax),%eax
80104e28:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
80104e2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e2e:	8b 40 08             	mov    0x8(%eax),%eax
80104e31:	83 ec 0c             	sub    $0xc,%esp
80104e34:	50                   	push   %eax
80104e35:	e8 45 dd ff ff       	call   80102b7f <kfree>
80104e3a:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
80104e3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e40:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104e47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e4a:	8b 40 04             	mov    0x4(%eax),%eax
80104e4d:	83 ec 0c             	sub    $0xc,%esp
80104e50:	50                   	push   %eax
80104e51:	e8 fe 3a 00 00       	call   80108954 <freevm>
80104e56:	83 c4 10             	add    $0x10,%esp
        p->state = UNUSED;
80104e59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e5c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
80104e63:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e66:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104e6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e70:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104e77:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e7a:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104e7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e81:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        release(&ptable.lock);
80104e88:	83 ec 0c             	sub    $0xc,%esp
80104e8b:	68 80 39 11 80       	push   $0x80113980
80104e90:	e8 42 07 00 00       	call   801055d7 <release>
80104e95:	83 c4 10             	add    $0x10,%esp
        return pid;
80104e98:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104e9b:	eb 5b                	jmp    80104ef8 <wait+0x125>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc)
        continue;
80104e9d:	90                   	nop

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104e9e:	81 45 f4 8c 00 00 00 	addl   $0x8c,-0xc(%ebp)
80104ea5:	81 7d f4 b4 5c 11 80 	cmpl   $0x80115cb4,-0xc(%ebp)
80104eac:	0f 82 4a ff ff ff    	jb     80104dfc <wait+0x29>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80104eb2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104eb6:	74 0d                	je     80104ec5 <wait+0xf2>
80104eb8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ebe:	8b 40 24             	mov    0x24(%eax),%eax
80104ec1:	85 c0                	test   %eax,%eax
80104ec3:	74 17                	je     80104edc <wait+0x109>
      release(&ptable.lock);
80104ec5:	83 ec 0c             	sub    $0xc,%esp
80104ec8:	68 80 39 11 80       	push   $0x80113980
80104ecd:	e8 05 07 00 00       	call   801055d7 <release>
80104ed2:	83 c4 10             	add    $0x10,%esp
      return -1;
80104ed5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104eda:	eb 1c                	jmp    80104ef8 <wait+0x125>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104edc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ee2:	83 ec 08             	sub    $0x8,%esp
80104ee5:	68 80 39 11 80       	push   $0x80113980
80104eea:	50                   	push   %eax
80104eeb:	e8 70 03 00 00       	call   80105260 <sleep>
80104ef0:	83 c4 10             	add    $0x10,%esp
  }
80104ef3:	e9 f1 fe ff ff       	jmp    80104de9 <wait+0x16>
}
80104ef8:	c9                   	leave  
80104ef9:	c3                   	ret    

80104efa <wait_thread>:

//기존의 wait은 child 가 다 없어질때까지 기다림
//여기서 wait은 exit가 들어올때까지 기다림 ( retval에 exit 값이 들어올때까지 기다림)
int
wait_thread(int tid,void** retval)
{
80104efa:	55                   	push   %ebp
80104efb:	89 e5                	mov    %esp,%ebp
80104efd:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int found = 0 ;
80104f00:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  acquire(&ptable.lock);
80104f07:	83 ec 0c             	sub    $0xc,%esp
80104f0a:	68 80 39 11 80       	push   $0x80113980
80104f0f:	e8 5c 06 00 00       	call   80105570 <acquire>
80104f14:	83 c4 10             	add    $0x10,%esp
  
    // new:
    //이미 terminate 되어있으면 바로 return 
     for(;;){
         
          found=0;
80104f17:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
          for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f1e:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104f25:	e9 fc 00 00 00       	jmp    80105026 <wait_thread+0x12c>
             if(p->parent !=proc)
80104f2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f2d:	8b 50 14             	mov    0x14(%eax),%edx
80104f30:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f36:	39 c2                	cmp    %eax,%edx
80104f38:	0f 85 dd 00 00 00    	jne    8010501b <wait_thread+0x121>
                 continue;
             if(p->tid !=tid || p->is_thread !=1)
80104f3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f41:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
80104f47:	3b 45 08             	cmp    0x8(%ebp),%eax
80104f4a:	0f 85 ce 00 00 00    	jne    8010501e <wait_thread+0x124>
80104f50:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f53:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104f59:	83 f8 01             	cmp    $0x1,%eax
80104f5c:	0f 85 bc 00 00 00    	jne    8010501e <wait_thread+0x124>
//             else{
//                 found = 1;
//                 break;
//             }
//            }
          found=1;
80104f62:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
//          cprintf("p->pid : %d , p->tid: %d, p->exit_status : 0x%x\n",p->pid,p->tid,(int)p->exit_status);         
          if(p->state == ZOMBIE){
80104f69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f6c:	8b 40 0c             	mov    0xc(%eax),%eax
80104f6f:	83 f8 05             	cmp    $0x5,%eax
80104f72:	0f 85 a7 00 00 00    	jne    8010501f <wait_thread+0x125>
                // Found one.
                p->parent->numOfThread--;
80104f78:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f7b:	8b 40 14             	mov    0x14(%eax),%eax
80104f7e:	8b 90 88 00 00 00    	mov    0x88(%eax),%edx
80104f84:	83 ea 01             	sub    $0x1,%edx
80104f87:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
                tid = p->tid;
80104f8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f90:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
80104f96:	89 45 08             	mov    %eax,0x8(%ebp)
                kfree(p->kstack);
80104f99:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f9c:	8b 40 08             	mov    0x8(%eax),%eax
80104f9f:	83 ec 0c             	sub    $0xc,%esp
80104fa2:	50                   	push   %eax
80104fa3:	e8 d7 db ff ff       	call   80102b7f <kfree>
80104fa8:	83 c4 10             	add    $0x10,%esp
                p->kstack = 0;
80104fab:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fae:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
                p->state = UNUSED;
80104fb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fb8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
                p->pid = 0;
80104fbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fc2:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
                p->parent = 0;
80104fc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fcc:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
                p->name[0] = 0;
80104fd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fd6:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
                p->killed = 0;
80104fda:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fdd:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
                p->is_thread = 0;
80104fe4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fe7:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80104fee:	00 00 00 
            // p->numOfThread--;
             // retval 을 exit_status로 바꿔주면 될듯? 
                *retval = p->exit_status;
80104ff1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ff4:	8b 50 7c             	mov    0x7c(%eax),%edx
80104ff7:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ffa:	89 10                	mov    %edx,(%eax)
                p->exit_status=0;
80104ffc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fff:	c7 40 7c 00 00 00 00 	movl   $0x0,0x7c(%eax)
                release(&ptable.lock);
80105006:	83 ec 0c             	sub    $0xc,%esp
80105009:	68 80 39 11 80       	push   $0x80113980
8010500e:	e8 c4 05 00 00       	call   801055d7 <release>
80105013:	83 c4 10             	add    $0x10,%esp
                return tid;
80105016:	8b 45 08             	mov    0x8(%ebp),%eax
80105019:	eb 5e                	jmp    80105079 <wait_thread+0x17f>
     for(;;){
         
          found=0;
          for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
             if(p->parent !=proc)
                 continue;
8010501b:	90                   	nop
8010501c:	eb 01                	jmp    8010501f <wait_thread+0x125>
             if(p->tid !=tid || p->is_thread !=1)
                 continue;
8010501e:	90                   	nop
    // new:
    //이미 terminate 되어있으면 바로 return 
     for(;;){
         
          found=0;
          for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010501f:	81 45 f4 8c 00 00 00 	addl   $0x8c,-0xc(%ebp)
80105026:	81 7d f4 b4 5c 11 80 	cmpl   $0x80115cb4,-0xc(%ebp)
8010502d:	0f 82 f7 fe ff ff    	jb     80104f2a <wait_thread+0x30>
                p->exit_status=0;
                release(&ptable.lock);
                return tid;
            }
         }
         if(!found || proc->killed){
80105033:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105037:	74 0d                	je     80105046 <wait_thread+0x14c>
80105039:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010503f:	8b 40 24             	mov    0x24(%eax),%eax
80105042:	85 c0                	test   %eax,%eax
80105044:	74 17                	je     8010505d <wait_thread+0x163>
                release(&ptable.lock);
80105046:	83 ec 0c             	sub    $0xc,%esp
80105049:	68 80 39 11 80       	push   $0x80113980
8010504e:	e8 84 05 00 00       	call   801055d7 <release>
80105053:	83 c4 10             	add    $0x10,%esp
                return -1;
80105056:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010505b:	eb 1c                	jmp    80105079 <wait_thread+0x17f>
         }    
    
        sleep(proc, &ptable.lock);  //DOC: wait-sleep
8010505d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105063:	83 ec 08             	sub    $0x8,%esp
80105066:	68 80 39 11 80       	push   $0x80113980
8010506b:	50                   	push   %eax
8010506c:	e8 ef 01 00 00       	call   80105260 <sleep>
80105071:	83 c4 10             	add    $0x10,%esp
    
    }
80105074:	e9 9e fe ff ff       	jmp    80104f17 <wait_thread+0x1d>

    // No point waiting if we don't have any children.
    // Wait for children to exit.  (See wakeup1 call in proc_exit.)

  
}
80105079:	c9                   	leave  
8010507a:	c3                   	ret    

8010507b <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
8010507b:	55                   	push   %ebp
8010507c:	89 e5                	mov    %esp,%ebp
8010507e:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  for(;;){
    // Enable interrupts on this processor.
    sti();
80105081:	e8 68 f3 ff ff       	call   801043ee <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80105086:	83 ec 0c             	sub    $0xc,%esp
80105089:	68 80 39 11 80       	push   $0x80113980
8010508e:	e8 dd 04 00 00       	call   80105570 <acquire>
80105093:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105096:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
8010509d:	eb 66                	jmp    80105105 <scheduler+0x8a>
      if(p->state != RUNNABLE)
8010509f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050a2:	8b 40 0c             	mov    0xc(%eax),%eax
801050a5:	83 f8 03             	cmp    $0x3,%eax
801050a8:	75 53                	jne    801050fd <scheduler+0x82>
     // if(p->numOfThread !=0)
      //    yield();
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
801050aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050ad:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
      switchuvm(p);
801050b3:	83 ec 0c             	sub    $0xc,%esp
801050b6:	ff 75 f4             	pushl  -0xc(%ebp)
801050b9:	e8 50 34 00 00       	call   8010850e <switchuvm>
801050be:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNING;
801050c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050c4:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
      swtch(&cpu->scheduler, proc->context);
801050cb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050d1:	8b 40 1c             	mov    0x1c(%eax),%eax
801050d4:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801050db:	83 c2 04             	add    $0x4,%edx
801050de:	83 ec 08             	sub    $0x8,%esp
801050e1:	50                   	push   %eax
801050e2:	52                   	push   %edx
801050e3:	e8 5f 09 00 00       	call   80105a47 <swtch>
801050e8:	83 c4 10             	add    $0x10,%esp
      switchkvm();
801050eb:	e8 01 34 00 00       	call   801084f1 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
801050f0:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
801050f7:	00 00 00 00 
801050fb:	eb 01                	jmp    801050fe <scheduler+0x83>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;
801050fd:	90                   	nop
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801050fe:	81 45 f4 8c 00 00 00 	addl   $0x8c,-0xc(%ebp)
80105105:	81 7d f4 b4 5c 11 80 	cmpl   $0x80115cb4,-0xc(%ebp)
8010510c:	72 91                	jb     8010509f <scheduler+0x24>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
8010510e:	83 ec 0c             	sub    $0xc,%esp
80105111:	68 80 39 11 80       	push   $0x80113980
80105116:	e8 bc 04 00 00       	call   801055d7 <release>
8010511b:	83 c4 10             	add    $0x10,%esp

  }
8010511e:	e9 5e ff ff ff       	jmp    80105081 <scheduler+0x6>

80105123 <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
80105123:	55                   	push   %ebp
80105124:	89 e5                	mov    %esp,%ebp
80105126:	83 ec 18             	sub    $0x18,%esp
  int intena;

  if(!holding(&ptable.lock))
80105129:	83 ec 0c             	sub    $0xc,%esp
8010512c:	68 80 39 11 80       	push   $0x80113980
80105131:	e8 6d 05 00 00       	call   801056a3 <holding>
80105136:	83 c4 10             	add    $0x10,%esp
80105139:	85 c0                	test   %eax,%eax
8010513b:	75 0d                	jne    8010514a <sched+0x27>
    panic("sched ptable.lock");
8010513d:	83 ec 0c             	sub    $0xc,%esp
80105140:	68 45 90 10 80       	push   $0x80109045
80105145:	e8 1c b4 ff ff       	call   80100566 <panic>
  if(cpu->ncli != 1)
8010514a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105150:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80105156:	83 f8 01             	cmp    $0x1,%eax
80105159:	74 0d                	je     80105168 <sched+0x45>
    panic("sched locks");
8010515b:	83 ec 0c             	sub    $0xc,%esp
8010515e:	68 57 90 10 80       	push   $0x80109057
80105163:	e8 fe b3 ff ff       	call   80100566 <panic>
  if(proc->state == RUNNING)
80105168:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010516e:	8b 40 0c             	mov    0xc(%eax),%eax
80105171:	83 f8 04             	cmp    $0x4,%eax
80105174:	75 0d                	jne    80105183 <sched+0x60>
    panic("sched running");
80105176:	83 ec 0c             	sub    $0xc,%esp
80105179:	68 63 90 10 80       	push   $0x80109063
8010517e:	e8 e3 b3 ff ff       	call   80100566 <panic>
  if(readeflags()&FL_IF)
80105183:	e8 56 f2 ff ff       	call   801043de <readeflags>
80105188:	25 00 02 00 00       	and    $0x200,%eax
8010518d:	85 c0                	test   %eax,%eax
8010518f:	74 0d                	je     8010519e <sched+0x7b>
    panic("sched interruptible");
80105191:	83 ec 0c             	sub    $0xc,%esp
80105194:	68 71 90 10 80       	push   $0x80109071
80105199:	e8 c8 b3 ff ff       	call   80100566 <panic>
  intena = cpu->intena;
8010519e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801051a4:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
801051aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  swtch(&proc->context, cpu->scheduler);
801051ad:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801051b3:	8b 40 04             	mov    0x4(%eax),%eax
801051b6:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801051bd:	83 c2 1c             	add    $0x1c,%edx
801051c0:	83 ec 08             	sub    $0x8,%esp
801051c3:	50                   	push   %eax
801051c4:	52                   	push   %edx
801051c5:	e8 7d 08 00 00       	call   80105a47 <swtch>
801051ca:	83 c4 10             	add    $0x10,%esp
  cpu->intena = intena;
801051cd:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801051d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801051d6:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
801051dc:	90                   	nop
801051dd:	c9                   	leave  
801051de:	c3                   	ret    

801051df <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
801051df:	55                   	push   %ebp
801051e0:	89 e5                	mov    %esp,%ebp
801051e2:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801051e5:	83 ec 0c             	sub    $0xc,%esp
801051e8:	68 80 39 11 80       	push   $0x80113980
801051ed:	e8 7e 03 00 00       	call   80105570 <acquire>
801051f2:	83 c4 10             	add    $0x10,%esp
  proc->state = RUNNABLE;
801051f5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051fb:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80105202:	e8 1c ff ff ff       	call   80105123 <sched>
  release(&ptable.lock);
80105207:	83 ec 0c             	sub    $0xc,%esp
8010520a:	68 80 39 11 80       	push   $0x80113980
8010520f:	e8 c3 03 00 00       	call   801055d7 <release>
80105214:	83 c4 10             	add    $0x10,%esp
}
80105217:	90                   	nop
80105218:	c9                   	leave  
80105219:	c3                   	ret    

8010521a <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
8010521a:	55                   	push   %ebp
8010521b:	89 e5                	mov    %esp,%ebp
8010521d:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80105220:	83 ec 0c             	sub    $0xc,%esp
80105223:	68 80 39 11 80       	push   $0x80113980
80105228:	e8 aa 03 00 00       	call   801055d7 <release>
8010522d:	83 c4 10             	add    $0x10,%esp

  if (first) {
80105230:	a1 08 c0 10 80       	mov    0x8010c008,%eax
80105235:	85 c0                	test   %eax,%eax
80105237:	74 24                	je     8010525d <forkret+0x43>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
80105239:	c7 05 08 c0 10 80 00 	movl   $0x0,0x8010c008
80105240:	00 00 00 
    iinit(ROOTDEV);
80105243:	83 ec 0c             	sub    $0xc,%esp
80105246:	6a 01                	push   $0x1
80105248:	e8 f1 c3 ff ff       	call   8010163e <iinit>
8010524d:	83 c4 10             	add    $0x10,%esp
    initlog(ROOTDEV);
80105250:	83 ec 0c             	sub    $0xc,%esp
80105253:	6a 01                	push   $0x1
80105255:	e8 af e0 ff ff       	call   80103309 <initlog>
8010525a:	83 c4 10             	add    $0x10,%esp
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
8010525d:	90                   	nop
8010525e:	c9                   	leave  
8010525f:	c3                   	ret    

80105260 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80105260:	55                   	push   %ebp
80105261:	89 e5                	mov    %esp,%ebp
80105263:	83 ec 08             	sub    $0x8,%esp
  if(proc == 0)
80105266:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010526c:	85 c0                	test   %eax,%eax
8010526e:	75 0d                	jne    8010527d <sleep+0x1d>
    panic("sleep");
80105270:	83 ec 0c             	sub    $0xc,%esp
80105273:	68 85 90 10 80       	push   $0x80109085
80105278:	e8 e9 b2 ff ff       	call   80100566 <panic>

  if(lk == 0)
8010527d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105281:	75 0d                	jne    80105290 <sleep+0x30>
    panic("sleep without lk");
80105283:	83 ec 0c             	sub    $0xc,%esp
80105286:	68 8b 90 10 80       	push   $0x8010908b
8010528b:	e8 d6 b2 ff ff       	call   80100566 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80105290:	81 7d 0c 80 39 11 80 	cmpl   $0x80113980,0xc(%ebp)
80105297:	74 1e                	je     801052b7 <sleep+0x57>
    acquire(&ptable.lock);  //DOC: sleeplock1
80105299:	83 ec 0c             	sub    $0xc,%esp
8010529c:	68 80 39 11 80       	push   $0x80113980
801052a1:	e8 ca 02 00 00       	call   80105570 <acquire>
801052a6:	83 c4 10             	add    $0x10,%esp
    release(lk);
801052a9:	83 ec 0c             	sub    $0xc,%esp
801052ac:	ff 75 0c             	pushl  0xc(%ebp)
801052af:	e8 23 03 00 00       	call   801055d7 <release>
801052b4:	83 c4 10             	add    $0x10,%esp
  }

  // Go to sleep.
  proc->chan = chan;
801052b7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052bd:	8b 55 08             	mov    0x8(%ebp),%edx
801052c0:	89 50 20             	mov    %edx,0x20(%eax)
  proc->state = SLEEPING;
801052c3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052c9:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
801052d0:	e8 4e fe ff ff       	call   80105123 <sched>

  // Tidy up.
  proc->chan = 0;
801052d5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052db:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
801052e2:	81 7d 0c 80 39 11 80 	cmpl   $0x80113980,0xc(%ebp)
801052e9:	74 1e                	je     80105309 <sleep+0xa9>
    release(&ptable.lock);
801052eb:	83 ec 0c             	sub    $0xc,%esp
801052ee:	68 80 39 11 80       	push   $0x80113980
801052f3:	e8 df 02 00 00       	call   801055d7 <release>
801052f8:	83 c4 10             	add    $0x10,%esp
    acquire(lk);
801052fb:	83 ec 0c             	sub    $0xc,%esp
801052fe:	ff 75 0c             	pushl  0xc(%ebp)
80105301:	e8 6a 02 00 00       	call   80105570 <acquire>
80105306:	83 c4 10             	add    $0x10,%esp
  }
}
80105309:	90                   	nop
8010530a:	c9                   	leave  
8010530b:	c3                   	ret    

8010530c <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
8010530c:	55                   	push   %ebp
8010530d:	89 e5                	mov    %esp,%ebp
8010530f:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105312:	c7 45 fc b4 39 11 80 	movl   $0x801139b4,-0x4(%ebp)
80105319:	eb 27                	jmp    80105342 <wakeup1+0x36>
    if(p->state == SLEEPING && p->chan == chan)
8010531b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010531e:	8b 40 0c             	mov    0xc(%eax),%eax
80105321:	83 f8 02             	cmp    $0x2,%eax
80105324:	75 15                	jne    8010533b <wakeup1+0x2f>
80105326:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105329:	8b 40 20             	mov    0x20(%eax),%eax
8010532c:	3b 45 08             	cmp    0x8(%ebp),%eax
8010532f:	75 0a                	jne    8010533b <wakeup1+0x2f>
      p->state = RUNNABLE;
80105331:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105334:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010533b:	81 45 fc 8c 00 00 00 	addl   $0x8c,-0x4(%ebp)
80105342:	81 7d fc b4 5c 11 80 	cmpl   $0x80115cb4,-0x4(%ebp)
80105349:	72 d0                	jb     8010531b <wakeup1+0xf>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
8010534b:	90                   	nop
8010534c:	c9                   	leave  
8010534d:	c3                   	ret    

8010534e <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
8010534e:	55                   	push   %ebp
8010534f:	89 e5                	mov    %esp,%ebp
80105351:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
80105354:	83 ec 0c             	sub    $0xc,%esp
80105357:	68 80 39 11 80       	push   $0x80113980
8010535c:	e8 0f 02 00 00       	call   80105570 <acquire>
80105361:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
80105364:	83 ec 0c             	sub    $0xc,%esp
80105367:	ff 75 08             	pushl  0x8(%ebp)
8010536a:	e8 9d ff ff ff       	call   8010530c <wakeup1>
8010536f:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
80105372:	83 ec 0c             	sub    $0xc,%esp
80105375:	68 80 39 11 80       	push   $0x80113980
8010537a:	e8 58 02 00 00       	call   801055d7 <release>
8010537f:	83 c4 10             	add    $0x10,%esp
}
80105382:	90                   	nop
80105383:	c9                   	leave  
80105384:	c3                   	ret    

80105385 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80105385:	55                   	push   %ebp
80105386:	89 e5                	mov    %esp,%ebp
80105388:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  acquire(&ptable.lock);
8010538b:	83 ec 0c             	sub    $0xc,%esp
8010538e:	68 80 39 11 80       	push   $0x80113980
80105393:	e8 d8 01 00 00       	call   80105570 <acquire>
80105398:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010539b:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
801053a2:	eb 48                	jmp    801053ec <kill+0x67>
    if(p->pid == pid){
801053a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053a7:	8b 40 10             	mov    0x10(%eax),%eax
801053aa:	3b 45 08             	cmp    0x8(%ebp),%eax
801053ad:	75 36                	jne    801053e5 <kill+0x60>
      p->killed = 1;
801053af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053b2:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801053b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053bc:	8b 40 0c             	mov    0xc(%eax),%eax
801053bf:	83 f8 02             	cmp    $0x2,%eax
801053c2:	75 0a                	jne    801053ce <kill+0x49>
        p->state = RUNNABLE;
801053c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053c7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801053ce:	83 ec 0c             	sub    $0xc,%esp
801053d1:	68 80 39 11 80       	push   $0x80113980
801053d6:	e8 fc 01 00 00       	call   801055d7 <release>
801053db:	83 c4 10             	add    $0x10,%esp
      return 0;
801053de:	b8 00 00 00 00       	mov    $0x0,%eax
801053e3:	eb 25                	jmp    8010540a <kill+0x85>
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801053e5:	81 45 f4 8c 00 00 00 	addl   $0x8c,-0xc(%ebp)
801053ec:	81 7d f4 b4 5c 11 80 	cmpl   $0x80115cb4,-0xc(%ebp)
801053f3:	72 af                	jb     801053a4 <kill+0x1f>
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
801053f5:	83 ec 0c             	sub    $0xc,%esp
801053f8:	68 80 39 11 80       	push   $0x80113980
801053fd:	e8 d5 01 00 00       	call   801055d7 <release>
80105402:	83 c4 10             	add    $0x10,%esp
  return -1;
80105405:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010540a:	c9                   	leave  
8010540b:	c3                   	ret    

8010540c <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
8010540c:	55                   	push   %ebp
8010540d:	89 e5                	mov    %esp,%ebp
8010540f:	83 ec 48             	sub    $0x48,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105412:	c7 45 f0 b4 39 11 80 	movl   $0x801139b4,-0x10(%ebp)
80105419:	e9 da 00 00 00       	jmp    801054f8 <procdump+0xec>
    if(p->state == UNUSED)
8010541e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105421:	8b 40 0c             	mov    0xc(%eax),%eax
80105424:	85 c0                	test   %eax,%eax
80105426:	0f 84 c4 00 00 00    	je     801054f0 <procdump+0xe4>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010542c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010542f:	8b 40 0c             	mov    0xc(%eax),%eax
80105432:	83 f8 05             	cmp    $0x5,%eax
80105435:	77 23                	ja     8010545a <procdump+0x4e>
80105437:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010543a:	8b 40 0c             	mov    0xc(%eax),%eax
8010543d:	8b 04 85 0c c0 10 80 	mov    -0x7fef3ff4(,%eax,4),%eax
80105444:	85 c0                	test   %eax,%eax
80105446:	74 12                	je     8010545a <procdump+0x4e>
      state = states[p->state];
80105448:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010544b:	8b 40 0c             	mov    0xc(%eax),%eax
8010544e:	8b 04 85 0c c0 10 80 	mov    -0x7fef3ff4(,%eax,4),%eax
80105455:	89 45 ec             	mov    %eax,-0x14(%ebp)
80105458:	eb 07                	jmp    80105461 <procdump+0x55>
    else
      state = "???";
8010545a:	c7 45 ec 9c 90 10 80 	movl   $0x8010909c,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80105461:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105464:	8d 50 6c             	lea    0x6c(%eax),%edx
80105467:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010546a:	8b 40 10             	mov    0x10(%eax),%eax
8010546d:	52                   	push   %edx
8010546e:	ff 75 ec             	pushl  -0x14(%ebp)
80105471:	50                   	push   %eax
80105472:	68 a0 90 10 80       	push   $0x801090a0
80105477:	e8 4a af ff ff       	call   801003c6 <cprintf>
8010547c:	83 c4 10             	add    $0x10,%esp
    if(p->state == SLEEPING){
8010547f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105482:	8b 40 0c             	mov    0xc(%eax),%eax
80105485:	83 f8 02             	cmp    $0x2,%eax
80105488:	75 54                	jne    801054de <procdump+0xd2>
      getcallerpcs((uint*)p->context->ebp+2, pc);
8010548a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010548d:	8b 40 1c             	mov    0x1c(%eax),%eax
80105490:	8b 40 0c             	mov    0xc(%eax),%eax
80105493:	83 c0 08             	add    $0x8,%eax
80105496:	89 c2                	mov    %eax,%edx
80105498:	83 ec 08             	sub    $0x8,%esp
8010549b:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010549e:	50                   	push   %eax
8010549f:	52                   	push   %edx
801054a0:	e8 84 01 00 00       	call   80105629 <getcallerpcs>
801054a5:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801054a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801054af:	eb 1c                	jmp    801054cd <procdump+0xc1>
        cprintf(" %p", pc[i]);
801054b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054b4:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
801054b8:	83 ec 08             	sub    $0x8,%esp
801054bb:	50                   	push   %eax
801054bc:	68 a9 90 10 80       	push   $0x801090a9
801054c1:	e8 00 af ff ff       	call   801003c6 <cprintf>
801054c6:	83 c4 10             	add    $0x10,%esp
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
801054c9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801054cd:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801054d1:	7f 0b                	jg     801054de <procdump+0xd2>
801054d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054d6:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
801054da:	85 c0                	test   %eax,%eax
801054dc:	75 d3                	jne    801054b1 <procdump+0xa5>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801054de:	83 ec 0c             	sub    $0xc,%esp
801054e1:	68 ad 90 10 80       	push   $0x801090ad
801054e6:	e8 db ae ff ff       	call   801003c6 <cprintf>
801054eb:	83 c4 10             	add    $0x10,%esp
801054ee:	eb 01                	jmp    801054f1 <procdump+0xe5>
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
801054f0:	90                   	nop
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801054f1:	81 45 f0 8c 00 00 00 	addl   $0x8c,-0x10(%ebp)
801054f8:	81 7d f0 b4 5c 11 80 	cmpl   $0x80115cb4,-0x10(%ebp)
801054ff:	0f 82 19 ff ff ff    	jb     8010541e <procdump+0x12>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80105505:	90                   	nop
80105506:	c9                   	leave  
80105507:	c3                   	ret    

80105508 <getpid>:

int getpid(void){
80105508:	55                   	push   %ebp
80105509:	89 e5                	mov    %esp,%ebp
	return proc->pid;
8010550b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105511:	8b 40 10             	mov    0x10(%eax),%eax
}
80105514:	5d                   	pop    %ebp
80105515:	c3                   	ret    

80105516 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80105516:	55                   	push   %ebp
80105517:	89 e5                	mov    %esp,%ebp
80105519:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010551c:	9c                   	pushf  
8010551d:	58                   	pop    %eax
8010551e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80105521:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105524:	c9                   	leave  
80105525:	c3                   	ret    

80105526 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80105526:	55                   	push   %ebp
80105527:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80105529:	fa                   	cli    
}
8010552a:	90                   	nop
8010552b:	5d                   	pop    %ebp
8010552c:	c3                   	ret    

8010552d <sti>:

static inline void
sti(void)
{
8010552d:	55                   	push   %ebp
8010552e:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80105530:	fb                   	sti    
}
80105531:	90                   	nop
80105532:	5d                   	pop    %ebp
80105533:	c3                   	ret    

80105534 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
80105534:	55                   	push   %ebp
80105535:	89 e5                	mov    %esp,%ebp
80105537:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010553a:	8b 55 08             	mov    0x8(%ebp),%edx
8010553d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105540:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105543:	f0 87 02             	lock xchg %eax,(%edx)
80105546:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80105549:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010554c:	c9                   	leave  
8010554d:	c3                   	ret    

8010554e <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
8010554e:	55                   	push   %ebp
8010554f:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80105551:	8b 45 08             	mov    0x8(%ebp),%eax
80105554:	8b 55 0c             	mov    0xc(%ebp),%edx
80105557:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
8010555a:	8b 45 08             	mov    0x8(%ebp),%eax
8010555d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80105563:	8b 45 08             	mov    0x8(%ebp),%eax
80105566:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
8010556d:	90                   	nop
8010556e:	5d                   	pop    %ebp
8010556f:	c3                   	ret    

80105570 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80105570:	55                   	push   %ebp
80105571:	89 e5                	mov    %esp,%ebp
80105573:	83 ec 08             	sub    $0x8,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80105576:	e8 52 01 00 00       	call   801056cd <pushcli>
  if(holding(lk))
8010557b:	8b 45 08             	mov    0x8(%ebp),%eax
8010557e:	83 ec 0c             	sub    $0xc,%esp
80105581:	50                   	push   %eax
80105582:	e8 1c 01 00 00       	call   801056a3 <holding>
80105587:	83 c4 10             	add    $0x10,%esp
8010558a:	85 c0                	test   %eax,%eax
8010558c:	74 0d                	je     8010559b <acquire+0x2b>
    panic("acquire");
8010558e:	83 ec 0c             	sub    $0xc,%esp
80105591:	68 d9 90 10 80       	push   $0x801090d9
80105596:	e8 cb af ff ff       	call   80100566 <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
8010559b:	90                   	nop
8010559c:	8b 45 08             	mov    0x8(%ebp),%eax
8010559f:	83 ec 08             	sub    $0x8,%esp
801055a2:	6a 01                	push   $0x1
801055a4:	50                   	push   %eax
801055a5:	e8 8a ff ff ff       	call   80105534 <xchg>
801055aa:	83 c4 10             	add    $0x10,%esp
801055ad:	85 c0                	test   %eax,%eax
801055af:	75 eb                	jne    8010559c <acquire+0x2c>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
801055b1:	8b 45 08             	mov    0x8(%ebp),%eax
801055b4:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801055bb:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
801055be:	8b 45 08             	mov    0x8(%ebp),%eax
801055c1:	83 c0 0c             	add    $0xc,%eax
801055c4:	83 ec 08             	sub    $0x8,%esp
801055c7:	50                   	push   %eax
801055c8:	8d 45 08             	lea    0x8(%ebp),%eax
801055cb:	50                   	push   %eax
801055cc:	e8 58 00 00 00       	call   80105629 <getcallerpcs>
801055d1:	83 c4 10             	add    $0x10,%esp
}
801055d4:	90                   	nop
801055d5:	c9                   	leave  
801055d6:	c3                   	ret    

801055d7 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
801055d7:	55                   	push   %ebp
801055d8:	89 e5                	mov    %esp,%ebp
801055da:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
801055dd:	83 ec 0c             	sub    $0xc,%esp
801055e0:	ff 75 08             	pushl  0x8(%ebp)
801055e3:	e8 bb 00 00 00       	call   801056a3 <holding>
801055e8:	83 c4 10             	add    $0x10,%esp
801055eb:	85 c0                	test   %eax,%eax
801055ed:	75 0d                	jne    801055fc <release+0x25>
    panic("release");
801055ef:	83 ec 0c             	sub    $0xc,%esp
801055f2:	68 e1 90 10 80       	push   $0x801090e1
801055f7:	e8 6a af ff ff       	call   80100566 <panic>

  lk->pcs[0] = 0;
801055fc:	8b 45 08             	mov    0x8(%ebp),%eax
801055ff:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80105606:	8b 45 08             	mov    0x8(%ebp),%eax
80105609:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
80105610:	8b 45 08             	mov    0x8(%ebp),%eax
80105613:	83 ec 08             	sub    $0x8,%esp
80105616:	6a 00                	push   $0x0
80105618:	50                   	push   %eax
80105619:	e8 16 ff ff ff       	call   80105534 <xchg>
8010561e:	83 c4 10             	add    $0x10,%esp

  popcli();
80105621:	e8 ec 00 00 00       	call   80105712 <popcli>
}
80105626:	90                   	nop
80105627:	c9                   	leave  
80105628:	c3                   	ret    

80105629 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105629:	55                   	push   %ebp
8010562a:	89 e5                	mov    %esp,%ebp
8010562c:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
8010562f:	8b 45 08             	mov    0x8(%ebp),%eax
80105632:	83 e8 08             	sub    $0x8,%eax
80105635:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80105638:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
8010563f:	eb 38                	jmp    80105679 <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105641:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105645:	74 53                	je     8010569a <getcallerpcs+0x71>
80105647:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
8010564e:	76 4a                	jbe    8010569a <getcallerpcs+0x71>
80105650:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80105654:	74 44                	je     8010569a <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
80105656:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105659:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105660:	8b 45 0c             	mov    0xc(%ebp),%eax
80105663:	01 c2                	add    %eax,%edx
80105665:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105668:	8b 40 04             	mov    0x4(%eax),%eax
8010566b:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
8010566d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105670:	8b 00                	mov    (%eax),%eax
80105672:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80105675:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80105679:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
8010567d:	7e c2                	jle    80105641 <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010567f:	eb 19                	jmp    8010569a <getcallerpcs+0x71>
    pcs[i] = 0;
80105681:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105684:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010568b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010568e:	01 d0                	add    %edx,%eax
80105690:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80105696:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
8010569a:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
8010569e:	7e e1                	jle    80105681 <getcallerpcs+0x58>
    pcs[i] = 0;
}
801056a0:	90                   	nop
801056a1:	c9                   	leave  
801056a2:	c3                   	ret    

801056a3 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801056a3:	55                   	push   %ebp
801056a4:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
801056a6:	8b 45 08             	mov    0x8(%ebp),%eax
801056a9:	8b 00                	mov    (%eax),%eax
801056ab:	85 c0                	test   %eax,%eax
801056ad:	74 17                	je     801056c6 <holding+0x23>
801056af:	8b 45 08             	mov    0x8(%ebp),%eax
801056b2:	8b 50 08             	mov    0x8(%eax),%edx
801056b5:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801056bb:	39 c2                	cmp    %eax,%edx
801056bd:	75 07                	jne    801056c6 <holding+0x23>
801056bf:	b8 01 00 00 00       	mov    $0x1,%eax
801056c4:	eb 05                	jmp    801056cb <holding+0x28>
801056c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
801056cb:	5d                   	pop    %ebp
801056cc:	c3                   	ret    

801056cd <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801056cd:	55                   	push   %ebp
801056ce:	89 e5                	mov    %esp,%ebp
801056d0:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
801056d3:	e8 3e fe ff ff       	call   80105516 <readeflags>
801056d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
801056db:	e8 46 fe ff ff       	call   80105526 <cli>
  if(cpu->ncli++ == 0)
801056e0:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801056e7:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
801056ed:	8d 48 01             	lea    0x1(%eax),%ecx
801056f0:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
801056f6:	85 c0                	test   %eax,%eax
801056f8:	75 15                	jne    8010570f <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
801056fa:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105700:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105703:	81 e2 00 02 00 00    	and    $0x200,%edx
80105709:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
8010570f:	90                   	nop
80105710:	c9                   	leave  
80105711:	c3                   	ret    

80105712 <popcli>:

void
popcli(void)
{
80105712:	55                   	push   %ebp
80105713:	89 e5                	mov    %esp,%ebp
80105715:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
80105718:	e8 f9 fd ff ff       	call   80105516 <readeflags>
8010571d:	25 00 02 00 00       	and    $0x200,%eax
80105722:	85 c0                	test   %eax,%eax
80105724:	74 0d                	je     80105733 <popcli+0x21>
    panic("popcli - interruptible");
80105726:	83 ec 0c             	sub    $0xc,%esp
80105729:	68 e9 90 10 80       	push   $0x801090e9
8010572e:	e8 33 ae ff ff       	call   80100566 <panic>
  if(--cpu->ncli < 0)
80105733:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105739:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
8010573f:	83 ea 01             	sub    $0x1,%edx
80105742:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80105748:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010574e:	85 c0                	test   %eax,%eax
80105750:	79 0d                	jns    8010575f <popcli+0x4d>
    panic("popcli");
80105752:	83 ec 0c             	sub    $0xc,%esp
80105755:	68 00 91 10 80       	push   $0x80109100
8010575a:	e8 07 ae ff ff       	call   80100566 <panic>
  if(cpu->ncli == 0 && cpu->intena)
8010575f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105765:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010576b:	85 c0                	test   %eax,%eax
8010576d:	75 15                	jne    80105784 <popcli+0x72>
8010576f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105775:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
8010577b:	85 c0                	test   %eax,%eax
8010577d:	74 05                	je     80105784 <popcli+0x72>
    sti();
8010577f:	e8 a9 fd ff ff       	call   8010552d <sti>
}
80105784:	90                   	nop
80105785:	c9                   	leave  
80105786:	c3                   	ret    

80105787 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
80105787:	55                   	push   %ebp
80105788:	89 e5                	mov    %esp,%ebp
8010578a:	57                   	push   %edi
8010578b:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
8010578c:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010578f:	8b 55 10             	mov    0x10(%ebp),%edx
80105792:	8b 45 0c             	mov    0xc(%ebp),%eax
80105795:	89 cb                	mov    %ecx,%ebx
80105797:	89 df                	mov    %ebx,%edi
80105799:	89 d1                	mov    %edx,%ecx
8010579b:	fc                   	cld    
8010579c:	f3 aa                	rep stos %al,%es:(%edi)
8010579e:	89 ca                	mov    %ecx,%edx
801057a0:	89 fb                	mov    %edi,%ebx
801057a2:	89 5d 08             	mov    %ebx,0x8(%ebp)
801057a5:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
801057a8:	90                   	nop
801057a9:	5b                   	pop    %ebx
801057aa:	5f                   	pop    %edi
801057ab:	5d                   	pop    %ebp
801057ac:	c3                   	ret    

801057ad <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
801057ad:	55                   	push   %ebp
801057ae:	89 e5                	mov    %esp,%ebp
801057b0:	57                   	push   %edi
801057b1:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
801057b2:	8b 4d 08             	mov    0x8(%ebp),%ecx
801057b5:	8b 55 10             	mov    0x10(%ebp),%edx
801057b8:	8b 45 0c             	mov    0xc(%ebp),%eax
801057bb:	89 cb                	mov    %ecx,%ebx
801057bd:	89 df                	mov    %ebx,%edi
801057bf:	89 d1                	mov    %edx,%ecx
801057c1:	fc                   	cld    
801057c2:	f3 ab                	rep stos %eax,%es:(%edi)
801057c4:	89 ca                	mov    %ecx,%edx
801057c6:	89 fb                	mov    %edi,%ebx
801057c8:	89 5d 08             	mov    %ebx,0x8(%ebp)
801057cb:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
801057ce:	90                   	nop
801057cf:	5b                   	pop    %ebx
801057d0:	5f                   	pop    %edi
801057d1:	5d                   	pop    %ebp
801057d2:	c3                   	ret    

801057d3 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801057d3:	55                   	push   %ebp
801057d4:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
801057d6:	8b 45 08             	mov    0x8(%ebp),%eax
801057d9:	83 e0 03             	and    $0x3,%eax
801057dc:	85 c0                	test   %eax,%eax
801057de:	75 43                	jne    80105823 <memset+0x50>
801057e0:	8b 45 10             	mov    0x10(%ebp),%eax
801057e3:	83 e0 03             	and    $0x3,%eax
801057e6:	85 c0                	test   %eax,%eax
801057e8:	75 39                	jne    80105823 <memset+0x50>
    c &= 0xFF;
801057ea:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801057f1:	8b 45 10             	mov    0x10(%ebp),%eax
801057f4:	c1 e8 02             	shr    $0x2,%eax
801057f7:	89 c1                	mov    %eax,%ecx
801057f9:	8b 45 0c             	mov    0xc(%ebp),%eax
801057fc:	c1 e0 18             	shl    $0x18,%eax
801057ff:	89 c2                	mov    %eax,%edx
80105801:	8b 45 0c             	mov    0xc(%ebp),%eax
80105804:	c1 e0 10             	shl    $0x10,%eax
80105807:	09 c2                	or     %eax,%edx
80105809:	8b 45 0c             	mov    0xc(%ebp),%eax
8010580c:	c1 e0 08             	shl    $0x8,%eax
8010580f:	09 d0                	or     %edx,%eax
80105811:	0b 45 0c             	or     0xc(%ebp),%eax
80105814:	51                   	push   %ecx
80105815:	50                   	push   %eax
80105816:	ff 75 08             	pushl  0x8(%ebp)
80105819:	e8 8f ff ff ff       	call   801057ad <stosl>
8010581e:	83 c4 0c             	add    $0xc,%esp
80105821:	eb 12                	jmp    80105835 <memset+0x62>
  } else
    stosb(dst, c, n);
80105823:	8b 45 10             	mov    0x10(%ebp),%eax
80105826:	50                   	push   %eax
80105827:	ff 75 0c             	pushl  0xc(%ebp)
8010582a:	ff 75 08             	pushl  0x8(%ebp)
8010582d:	e8 55 ff ff ff       	call   80105787 <stosb>
80105832:	83 c4 0c             	add    $0xc,%esp
  return dst;
80105835:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105838:	c9                   	leave  
80105839:	c3                   	ret    

8010583a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
8010583a:	55                   	push   %ebp
8010583b:	89 e5                	mov    %esp,%ebp
8010583d:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
80105840:	8b 45 08             	mov    0x8(%ebp),%eax
80105843:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80105846:	8b 45 0c             	mov    0xc(%ebp),%eax
80105849:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
8010584c:	eb 30                	jmp    8010587e <memcmp+0x44>
    if(*s1 != *s2)
8010584e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105851:	0f b6 10             	movzbl (%eax),%edx
80105854:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105857:	0f b6 00             	movzbl (%eax),%eax
8010585a:	38 c2                	cmp    %al,%dl
8010585c:	74 18                	je     80105876 <memcmp+0x3c>
      return *s1 - *s2;
8010585e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105861:	0f b6 00             	movzbl (%eax),%eax
80105864:	0f b6 d0             	movzbl %al,%edx
80105867:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010586a:	0f b6 00             	movzbl (%eax),%eax
8010586d:	0f b6 c0             	movzbl %al,%eax
80105870:	29 c2                	sub    %eax,%edx
80105872:	89 d0                	mov    %edx,%eax
80105874:	eb 1a                	jmp    80105890 <memcmp+0x56>
    s1++, s2++;
80105876:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010587a:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010587e:	8b 45 10             	mov    0x10(%ebp),%eax
80105881:	8d 50 ff             	lea    -0x1(%eax),%edx
80105884:	89 55 10             	mov    %edx,0x10(%ebp)
80105887:	85 c0                	test   %eax,%eax
80105889:	75 c3                	jne    8010584e <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
8010588b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105890:	c9                   	leave  
80105891:	c3                   	ret    

80105892 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105892:	55                   	push   %ebp
80105893:	89 e5                	mov    %esp,%ebp
80105895:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80105898:	8b 45 0c             	mov    0xc(%ebp),%eax
8010589b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
8010589e:	8b 45 08             	mov    0x8(%ebp),%eax
801058a1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
801058a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
801058a7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801058aa:	73 54                	jae    80105900 <memmove+0x6e>
801058ac:	8b 55 fc             	mov    -0x4(%ebp),%edx
801058af:	8b 45 10             	mov    0x10(%ebp),%eax
801058b2:	01 d0                	add    %edx,%eax
801058b4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801058b7:	76 47                	jbe    80105900 <memmove+0x6e>
    s += n;
801058b9:	8b 45 10             	mov    0x10(%ebp),%eax
801058bc:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
801058bf:	8b 45 10             	mov    0x10(%ebp),%eax
801058c2:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
801058c5:	eb 13                	jmp    801058da <memmove+0x48>
      *--d = *--s;
801058c7:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
801058cb:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
801058cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
801058d2:	0f b6 10             	movzbl (%eax),%edx
801058d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
801058d8:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
801058da:	8b 45 10             	mov    0x10(%ebp),%eax
801058dd:	8d 50 ff             	lea    -0x1(%eax),%edx
801058e0:	89 55 10             	mov    %edx,0x10(%ebp)
801058e3:	85 c0                	test   %eax,%eax
801058e5:	75 e0                	jne    801058c7 <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801058e7:	eb 24                	jmp    8010590d <memmove+0x7b>
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
      *d++ = *s++;
801058e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
801058ec:	8d 50 01             	lea    0x1(%eax),%edx
801058ef:	89 55 f8             	mov    %edx,-0x8(%ebp)
801058f2:	8b 55 fc             	mov    -0x4(%ebp),%edx
801058f5:	8d 4a 01             	lea    0x1(%edx),%ecx
801058f8:	89 4d fc             	mov    %ecx,-0x4(%ebp)
801058fb:	0f b6 12             	movzbl (%edx),%edx
801058fe:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80105900:	8b 45 10             	mov    0x10(%ebp),%eax
80105903:	8d 50 ff             	lea    -0x1(%eax),%edx
80105906:	89 55 10             	mov    %edx,0x10(%ebp)
80105909:	85 c0                	test   %eax,%eax
8010590b:	75 dc                	jne    801058e9 <memmove+0x57>
      *d++ = *s++;

  return dst;
8010590d:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105910:	c9                   	leave  
80105911:	c3                   	ret    

80105912 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105912:	55                   	push   %ebp
80105913:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
80105915:	ff 75 10             	pushl  0x10(%ebp)
80105918:	ff 75 0c             	pushl  0xc(%ebp)
8010591b:	ff 75 08             	pushl  0x8(%ebp)
8010591e:	e8 6f ff ff ff       	call   80105892 <memmove>
80105923:	83 c4 0c             	add    $0xc,%esp
}
80105926:	c9                   	leave  
80105927:	c3                   	ret    

80105928 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105928:	55                   	push   %ebp
80105929:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
8010592b:	eb 0c                	jmp    80105939 <strncmp+0x11>
    n--, p++, q++;
8010592d:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105931:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80105935:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80105939:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010593d:	74 1a                	je     80105959 <strncmp+0x31>
8010593f:	8b 45 08             	mov    0x8(%ebp),%eax
80105942:	0f b6 00             	movzbl (%eax),%eax
80105945:	84 c0                	test   %al,%al
80105947:	74 10                	je     80105959 <strncmp+0x31>
80105949:	8b 45 08             	mov    0x8(%ebp),%eax
8010594c:	0f b6 10             	movzbl (%eax),%edx
8010594f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105952:	0f b6 00             	movzbl (%eax),%eax
80105955:	38 c2                	cmp    %al,%dl
80105957:	74 d4                	je     8010592d <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
80105959:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010595d:	75 07                	jne    80105966 <strncmp+0x3e>
    return 0;
8010595f:	b8 00 00 00 00       	mov    $0x0,%eax
80105964:	eb 16                	jmp    8010597c <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
80105966:	8b 45 08             	mov    0x8(%ebp),%eax
80105969:	0f b6 00             	movzbl (%eax),%eax
8010596c:	0f b6 d0             	movzbl %al,%edx
8010596f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105972:	0f b6 00             	movzbl (%eax),%eax
80105975:	0f b6 c0             	movzbl %al,%eax
80105978:	29 c2                	sub    %eax,%edx
8010597a:	89 d0                	mov    %edx,%eax
}
8010597c:	5d                   	pop    %ebp
8010597d:	c3                   	ret    

8010597e <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
8010597e:	55                   	push   %ebp
8010597f:	89 e5                	mov    %esp,%ebp
80105981:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80105984:	8b 45 08             	mov    0x8(%ebp),%eax
80105987:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
8010598a:	90                   	nop
8010598b:	8b 45 10             	mov    0x10(%ebp),%eax
8010598e:	8d 50 ff             	lea    -0x1(%eax),%edx
80105991:	89 55 10             	mov    %edx,0x10(%ebp)
80105994:	85 c0                	test   %eax,%eax
80105996:	7e 2c                	jle    801059c4 <strncpy+0x46>
80105998:	8b 45 08             	mov    0x8(%ebp),%eax
8010599b:	8d 50 01             	lea    0x1(%eax),%edx
8010599e:	89 55 08             	mov    %edx,0x8(%ebp)
801059a1:	8b 55 0c             	mov    0xc(%ebp),%edx
801059a4:	8d 4a 01             	lea    0x1(%edx),%ecx
801059a7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
801059aa:	0f b6 12             	movzbl (%edx),%edx
801059ad:	88 10                	mov    %dl,(%eax)
801059af:	0f b6 00             	movzbl (%eax),%eax
801059b2:	84 c0                	test   %al,%al
801059b4:	75 d5                	jne    8010598b <strncpy+0xd>
    ;
  while(n-- > 0)
801059b6:	eb 0c                	jmp    801059c4 <strncpy+0x46>
    *s++ = 0;
801059b8:	8b 45 08             	mov    0x8(%ebp),%eax
801059bb:	8d 50 01             	lea    0x1(%eax),%edx
801059be:	89 55 08             	mov    %edx,0x8(%ebp)
801059c1:	c6 00 00             	movb   $0x0,(%eax)
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
801059c4:	8b 45 10             	mov    0x10(%ebp),%eax
801059c7:	8d 50 ff             	lea    -0x1(%eax),%edx
801059ca:	89 55 10             	mov    %edx,0x10(%ebp)
801059cd:	85 c0                	test   %eax,%eax
801059cf:	7f e7                	jg     801059b8 <strncpy+0x3a>
    *s++ = 0;
  return os;
801059d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801059d4:	c9                   	leave  
801059d5:	c3                   	ret    

801059d6 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801059d6:	55                   	push   %ebp
801059d7:	89 e5                	mov    %esp,%ebp
801059d9:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
801059dc:	8b 45 08             	mov    0x8(%ebp),%eax
801059df:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
801059e2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801059e6:	7f 05                	jg     801059ed <safestrcpy+0x17>
    return os;
801059e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
801059eb:	eb 31                	jmp    80105a1e <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
801059ed:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801059f1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801059f5:	7e 1e                	jle    80105a15 <safestrcpy+0x3f>
801059f7:	8b 45 08             	mov    0x8(%ebp),%eax
801059fa:	8d 50 01             	lea    0x1(%eax),%edx
801059fd:	89 55 08             	mov    %edx,0x8(%ebp)
80105a00:	8b 55 0c             	mov    0xc(%ebp),%edx
80105a03:	8d 4a 01             	lea    0x1(%edx),%ecx
80105a06:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80105a09:	0f b6 12             	movzbl (%edx),%edx
80105a0c:	88 10                	mov    %dl,(%eax)
80105a0e:	0f b6 00             	movzbl (%eax),%eax
80105a11:	84 c0                	test   %al,%al
80105a13:	75 d8                	jne    801059ed <safestrcpy+0x17>
    ;
  *s = 0;
80105a15:	8b 45 08             	mov    0x8(%ebp),%eax
80105a18:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80105a1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105a1e:	c9                   	leave  
80105a1f:	c3                   	ret    

80105a20 <strlen>:

int
strlen(const char *s)
{
80105a20:	55                   	push   %ebp
80105a21:	89 e5                	mov    %esp,%ebp
80105a23:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80105a26:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105a2d:	eb 04                	jmp    80105a33 <strlen+0x13>
80105a2f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105a33:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105a36:	8b 45 08             	mov    0x8(%ebp),%eax
80105a39:	01 d0                	add    %edx,%eax
80105a3b:	0f b6 00             	movzbl (%eax),%eax
80105a3e:	84 c0                	test   %al,%al
80105a40:	75 ed                	jne    80105a2f <strlen+0xf>
    ;
  return n;
80105a42:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105a45:	c9                   	leave  
80105a46:	c3                   	ret    

80105a47 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105a47:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105a4b:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80105a4f:	55                   	push   %ebp
  pushl %ebx
80105a50:	53                   	push   %ebx
  pushl %esi
80105a51:	56                   	push   %esi
  pushl %edi
80105a52:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105a53:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105a55:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80105a57:	5f                   	pop    %edi
  popl %esi
80105a58:	5e                   	pop    %esi
  popl %ebx
80105a59:	5b                   	pop    %ebx
  popl %ebp
80105a5a:	5d                   	pop    %ebp
  ret
80105a5b:	c3                   	ret    

80105a5c <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105a5c:	55                   	push   %ebp
80105a5d:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
80105a5f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a65:	8b 00                	mov    (%eax),%eax
80105a67:	3b 45 08             	cmp    0x8(%ebp),%eax
80105a6a:	76 12                	jbe    80105a7e <fetchint+0x22>
80105a6c:	8b 45 08             	mov    0x8(%ebp),%eax
80105a6f:	8d 50 04             	lea    0x4(%eax),%edx
80105a72:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a78:	8b 00                	mov    (%eax),%eax
80105a7a:	39 c2                	cmp    %eax,%edx
80105a7c:	76 07                	jbe    80105a85 <fetchint+0x29>
    return -1;
80105a7e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a83:	eb 0f                	jmp    80105a94 <fetchint+0x38>
  *ip = *(int*)(addr);
80105a85:	8b 45 08             	mov    0x8(%ebp),%eax
80105a88:	8b 10                	mov    (%eax),%edx
80105a8a:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a8d:	89 10                	mov    %edx,(%eax)
  return 0;
80105a8f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105a94:	5d                   	pop    %ebp
80105a95:	c3                   	ret    

80105a96 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105a96:	55                   	push   %ebp
80105a97:	89 e5                	mov    %esp,%ebp
80105a99:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
80105a9c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105aa2:	8b 00                	mov    (%eax),%eax
80105aa4:	3b 45 08             	cmp    0x8(%ebp),%eax
80105aa7:	77 07                	ja     80105ab0 <fetchstr+0x1a>
    return -1;
80105aa9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105aae:	eb 46                	jmp    80105af6 <fetchstr+0x60>
  *pp = (char*)addr;
80105ab0:	8b 55 08             	mov    0x8(%ebp),%edx
80105ab3:	8b 45 0c             	mov    0xc(%ebp),%eax
80105ab6:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
80105ab8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105abe:	8b 00                	mov    (%eax),%eax
80105ac0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
80105ac3:	8b 45 0c             	mov    0xc(%ebp),%eax
80105ac6:	8b 00                	mov    (%eax),%eax
80105ac8:	89 45 fc             	mov    %eax,-0x4(%ebp)
80105acb:	eb 1c                	jmp    80105ae9 <fetchstr+0x53>
    if(*s == 0)
80105acd:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105ad0:	0f b6 00             	movzbl (%eax),%eax
80105ad3:	84 c0                	test   %al,%al
80105ad5:	75 0e                	jne    80105ae5 <fetchstr+0x4f>
      return s - *pp;
80105ad7:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105ada:	8b 45 0c             	mov    0xc(%ebp),%eax
80105add:	8b 00                	mov    (%eax),%eax
80105adf:	29 c2                	sub    %eax,%edx
80105ae1:	89 d0                	mov    %edx,%eax
80105ae3:	eb 11                	jmp    80105af6 <fetchstr+0x60>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
80105ae5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105ae9:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105aec:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105aef:	72 dc                	jb     80105acd <fetchstr+0x37>
    if(*s == 0)
      return s - *pp;
  return -1;
80105af1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105af6:	c9                   	leave  
80105af7:	c3                   	ret    

80105af8 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105af8:	55                   	push   %ebp
80105af9:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80105afb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b01:	8b 40 18             	mov    0x18(%eax),%eax
80105b04:	8b 40 44             	mov    0x44(%eax),%eax
80105b07:	8b 55 08             	mov    0x8(%ebp),%edx
80105b0a:	c1 e2 02             	shl    $0x2,%edx
80105b0d:	01 d0                	add    %edx,%eax
80105b0f:	83 c0 04             	add    $0x4,%eax
80105b12:	ff 75 0c             	pushl  0xc(%ebp)
80105b15:	50                   	push   %eax
80105b16:	e8 41 ff ff ff       	call   80105a5c <fetchint>
80105b1b:	83 c4 08             	add    $0x8,%esp
}
80105b1e:	c9                   	leave  
80105b1f:	c3                   	ret    

80105b20 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105b20:	55                   	push   %ebp
80105b21:	89 e5                	mov    %esp,%ebp
80105b23:	83 ec 10             	sub    $0x10,%esp
  int i;
  
  if(argint(n, &i) < 0)
80105b26:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105b29:	50                   	push   %eax
80105b2a:	ff 75 08             	pushl  0x8(%ebp)
80105b2d:	e8 c6 ff ff ff       	call   80105af8 <argint>
80105b32:	83 c4 08             	add    $0x8,%esp
80105b35:	85 c0                	test   %eax,%eax
80105b37:	79 07                	jns    80105b40 <argptr+0x20>
    return -1;
80105b39:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b3e:	eb 3b                	jmp    80105b7b <argptr+0x5b>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
80105b40:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b46:	8b 00                	mov    (%eax),%eax
80105b48:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105b4b:	39 d0                	cmp    %edx,%eax
80105b4d:	76 16                	jbe    80105b65 <argptr+0x45>
80105b4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105b52:	89 c2                	mov    %eax,%edx
80105b54:	8b 45 10             	mov    0x10(%ebp),%eax
80105b57:	01 c2                	add    %eax,%edx
80105b59:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b5f:	8b 00                	mov    (%eax),%eax
80105b61:	39 c2                	cmp    %eax,%edx
80105b63:	76 07                	jbe    80105b6c <argptr+0x4c>
    return -1;
80105b65:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b6a:	eb 0f                	jmp    80105b7b <argptr+0x5b>
  *pp = (char*)i;
80105b6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105b6f:	89 c2                	mov    %eax,%edx
80105b71:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b74:	89 10                	mov    %edx,(%eax)
  return 0;
80105b76:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105b7b:	c9                   	leave  
80105b7c:	c3                   	ret    

80105b7d <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105b7d:	55                   	push   %ebp
80105b7e:	89 e5                	mov    %esp,%ebp
80105b80:	83 ec 10             	sub    $0x10,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105b83:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105b86:	50                   	push   %eax
80105b87:	ff 75 08             	pushl  0x8(%ebp)
80105b8a:	e8 69 ff ff ff       	call   80105af8 <argint>
80105b8f:	83 c4 08             	add    $0x8,%esp
80105b92:	85 c0                	test   %eax,%eax
80105b94:	79 07                	jns    80105b9d <argstr+0x20>
    return -1;
80105b96:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b9b:	eb 0f                	jmp    80105bac <argstr+0x2f>
  return fetchstr(addr, pp);
80105b9d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105ba0:	ff 75 0c             	pushl  0xc(%ebp)
80105ba3:	50                   	push   %eax
80105ba4:	e8 ed fe ff ff       	call   80105a96 <fetchstr>
80105ba9:	83 c4 08             	add    $0x8,%esp
}
80105bac:	c9                   	leave  
80105bad:	c3                   	ret    

80105bae <syscall>:
[SYS_clone] sys_clone,
};

void
syscall(void)
{
80105bae:	55                   	push   %ebp
80105baf:	89 e5                	mov    %esp,%ebp
80105bb1:	53                   	push   %ebx
80105bb2:	83 ec 14             	sub    $0x14,%esp
  int num;

  num = proc->tf->eax;
80105bb5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105bbb:	8b 40 18             	mov    0x18(%eax),%eax
80105bbe:	8b 40 1c             	mov    0x1c(%eax),%eax
80105bc1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105bc4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105bc8:	7e 30                	jle    80105bfa <syscall+0x4c>
80105bca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bcd:	83 f8 1b             	cmp    $0x1b,%eax
80105bd0:	77 28                	ja     80105bfa <syscall+0x4c>
80105bd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bd5:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105bdc:	85 c0                	test   %eax,%eax
80105bde:	74 1a                	je     80105bfa <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
80105be0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105be6:	8b 58 18             	mov    0x18(%eax),%ebx
80105be9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bec:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105bf3:	ff d0                	call   *%eax
80105bf5:	89 43 1c             	mov    %eax,0x1c(%ebx)
80105bf8:	eb 34                	jmp    80105c2e <syscall+0x80>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
80105bfa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c00:	8d 50 6c             	lea    0x6c(%eax),%edx
80105c03:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80105c09:	8b 40 10             	mov    0x10(%eax),%eax
80105c0c:	ff 75 f4             	pushl  -0xc(%ebp)
80105c0f:	52                   	push   %edx
80105c10:	50                   	push   %eax
80105c11:	68 07 91 10 80       	push   $0x80109107
80105c16:	e8 ab a7 ff ff       	call   801003c6 <cprintf>
80105c1b:	83 c4 10             	add    $0x10,%esp
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
80105c1e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c24:	8b 40 18             	mov    0x18(%eax),%eax
80105c27:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80105c2e:	90                   	nop
80105c2f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105c32:	c9                   	leave  
80105c33:	c3                   	ret    

80105c34 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80105c34:	55                   	push   %ebp
80105c35:	89 e5                	mov    %esp,%ebp
80105c37:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105c3a:	83 ec 08             	sub    $0x8,%esp
80105c3d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c40:	50                   	push   %eax
80105c41:	ff 75 08             	pushl  0x8(%ebp)
80105c44:	e8 af fe ff ff       	call   80105af8 <argint>
80105c49:	83 c4 10             	add    $0x10,%esp
80105c4c:	85 c0                	test   %eax,%eax
80105c4e:	79 07                	jns    80105c57 <argfd+0x23>
    return -1;
80105c50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c55:	eb 50                	jmp    80105ca7 <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80105c57:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c5a:	85 c0                	test   %eax,%eax
80105c5c:	78 21                	js     80105c7f <argfd+0x4b>
80105c5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c61:	83 f8 0f             	cmp    $0xf,%eax
80105c64:	7f 19                	jg     80105c7f <argfd+0x4b>
80105c66:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c6c:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105c6f:	83 c2 08             	add    $0x8,%edx
80105c72:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105c76:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105c79:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105c7d:	75 07                	jne    80105c86 <argfd+0x52>
    return -1;
80105c7f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c84:	eb 21                	jmp    80105ca7 <argfd+0x73>
  if(pfd)
80105c86:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105c8a:	74 08                	je     80105c94 <argfd+0x60>
    *pfd = fd;
80105c8c:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105c8f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105c92:	89 10                	mov    %edx,(%eax)
  if(pf)
80105c94:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105c98:	74 08                	je     80105ca2 <argfd+0x6e>
    *pf = f;
80105c9a:	8b 45 10             	mov    0x10(%ebp),%eax
80105c9d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105ca0:	89 10                	mov    %edx,(%eax)
  return 0;
80105ca2:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105ca7:	c9                   	leave  
80105ca8:	c3                   	ret    

80105ca9 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80105ca9:	55                   	push   %ebp
80105caa:	89 e5                	mov    %esp,%ebp
80105cac:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105caf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105cb6:	eb 30                	jmp    80105ce8 <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
80105cb8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105cbe:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105cc1:	83 c2 08             	add    $0x8,%edx
80105cc4:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105cc8:	85 c0                	test   %eax,%eax
80105cca:	75 18                	jne    80105ce4 <fdalloc+0x3b>
      proc->ofile[fd] = f;
80105ccc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105cd2:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105cd5:	8d 4a 08             	lea    0x8(%edx),%ecx
80105cd8:	8b 55 08             	mov    0x8(%ebp),%edx
80105cdb:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80105cdf:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105ce2:	eb 0f                	jmp    80105cf3 <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105ce4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105ce8:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
80105cec:	7e ca                	jle    80105cb8 <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
80105cee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105cf3:	c9                   	leave  
80105cf4:	c3                   	ret    

80105cf5 <sys_dup>:

int
sys_dup(void)
{
80105cf5:	55                   	push   %ebp
80105cf6:	89 e5                	mov    %esp,%ebp
80105cf8:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
80105cfb:	83 ec 04             	sub    $0x4,%esp
80105cfe:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105d01:	50                   	push   %eax
80105d02:	6a 00                	push   $0x0
80105d04:	6a 00                	push   $0x0
80105d06:	e8 29 ff ff ff       	call   80105c34 <argfd>
80105d0b:	83 c4 10             	add    $0x10,%esp
80105d0e:	85 c0                	test   %eax,%eax
80105d10:	79 07                	jns    80105d19 <sys_dup+0x24>
    return -1;
80105d12:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d17:	eb 31                	jmp    80105d4a <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80105d19:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d1c:	83 ec 0c             	sub    $0xc,%esp
80105d1f:	50                   	push   %eax
80105d20:	e8 84 ff ff ff       	call   80105ca9 <fdalloc>
80105d25:	83 c4 10             	add    $0x10,%esp
80105d28:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105d2b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105d2f:	79 07                	jns    80105d38 <sys_dup+0x43>
    return -1;
80105d31:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d36:	eb 12                	jmp    80105d4a <sys_dup+0x55>
  filedup(f);
80105d38:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d3b:	83 ec 0c             	sub    $0xc,%esp
80105d3e:	50                   	push   %eax
80105d3f:	e8 bc b2 ff ff       	call   80101000 <filedup>
80105d44:	83 c4 10             	add    $0x10,%esp
  return fd;
80105d47:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105d4a:	c9                   	leave  
80105d4b:	c3                   	ret    

80105d4c <sys_read>:

int
sys_read(void)
{
80105d4c:	55                   	push   %ebp
80105d4d:	89 e5                	mov    %esp,%ebp
80105d4f:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105d52:	83 ec 04             	sub    $0x4,%esp
80105d55:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d58:	50                   	push   %eax
80105d59:	6a 00                	push   $0x0
80105d5b:	6a 00                	push   $0x0
80105d5d:	e8 d2 fe ff ff       	call   80105c34 <argfd>
80105d62:	83 c4 10             	add    $0x10,%esp
80105d65:	85 c0                	test   %eax,%eax
80105d67:	78 2e                	js     80105d97 <sys_read+0x4b>
80105d69:	83 ec 08             	sub    $0x8,%esp
80105d6c:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105d6f:	50                   	push   %eax
80105d70:	6a 02                	push   $0x2
80105d72:	e8 81 fd ff ff       	call   80105af8 <argint>
80105d77:	83 c4 10             	add    $0x10,%esp
80105d7a:	85 c0                	test   %eax,%eax
80105d7c:	78 19                	js     80105d97 <sys_read+0x4b>
80105d7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d81:	83 ec 04             	sub    $0x4,%esp
80105d84:	50                   	push   %eax
80105d85:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105d88:	50                   	push   %eax
80105d89:	6a 01                	push   $0x1
80105d8b:	e8 90 fd ff ff       	call   80105b20 <argptr>
80105d90:	83 c4 10             	add    $0x10,%esp
80105d93:	85 c0                	test   %eax,%eax
80105d95:	79 07                	jns    80105d9e <sys_read+0x52>
    return -1;
80105d97:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d9c:	eb 17                	jmp    80105db5 <sys_read+0x69>
  return fileread(f, p, n);
80105d9e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105da1:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105da4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105da7:	83 ec 04             	sub    $0x4,%esp
80105daa:	51                   	push   %ecx
80105dab:	52                   	push   %edx
80105dac:	50                   	push   %eax
80105dad:	e8 de b3 ff ff       	call   80101190 <fileread>
80105db2:	83 c4 10             	add    $0x10,%esp
}
80105db5:	c9                   	leave  
80105db6:	c3                   	ret    

80105db7 <sys_write>:

int
sys_write(void)
{
80105db7:	55                   	push   %ebp
80105db8:	89 e5                	mov    %esp,%ebp
80105dba:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0){
80105dbd:	83 ec 04             	sub    $0x4,%esp
80105dc0:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105dc3:	50                   	push   %eax
80105dc4:	6a 00                	push   $0x0
80105dc6:	6a 00                	push   $0x0
80105dc8:	e8 67 fe ff ff       	call   80105c34 <argfd>
80105dcd:	83 c4 10             	add    $0x10,%esp
80105dd0:	85 c0                	test   %eax,%eax
80105dd2:	78 2e                	js     80105e02 <sys_write+0x4b>
80105dd4:	83 ec 08             	sub    $0x8,%esp
80105dd7:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105dda:	50                   	push   %eax
80105ddb:	6a 02                	push   $0x2
80105ddd:	e8 16 fd ff ff       	call   80105af8 <argint>
80105de2:	83 c4 10             	add    $0x10,%esp
80105de5:	85 c0                	test   %eax,%eax
80105de7:	78 19                	js     80105e02 <sys_write+0x4b>
80105de9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dec:	83 ec 04             	sub    $0x4,%esp
80105def:	50                   	push   %eax
80105df0:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105df3:	50                   	push   %eax
80105df4:	6a 01                	push   $0x1
80105df6:	e8 25 fd ff ff       	call   80105b20 <argptr>
80105dfb:	83 c4 10             	add    $0x10,%esp
80105dfe:	85 c0                	test   %eax,%eax
80105e00:	79 17                	jns    80105e19 <sys_write+0x62>
    cprintf("this is a problem\n");
80105e02:	83 ec 0c             	sub    $0xc,%esp
80105e05:	68 23 91 10 80       	push   $0x80109123
80105e0a:	e8 b7 a5 ff ff       	call   801003c6 <cprintf>
80105e0f:	83 c4 10             	add    $0x10,%esp
      return -1;
80105e12:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e17:	eb 17                	jmp    80105e30 <sys_write+0x79>
  }
  return filewrite(f, p, n);
80105e19:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105e1c:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105e1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e22:	83 ec 04             	sub    $0x4,%esp
80105e25:	51                   	push   %ecx
80105e26:	52                   	push   %edx
80105e27:	50                   	push   %eax
80105e28:	e8 1b b4 ff ff       	call   80101248 <filewrite>
80105e2d:	83 c4 10             	add    $0x10,%esp
}
80105e30:	c9                   	leave  
80105e31:	c3                   	ret    

80105e32 <sys_close>:

int
sys_close(void)
{
80105e32:	55                   	push   %ebp
80105e33:	89 e5                	mov    %esp,%ebp
80105e35:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
80105e38:	83 ec 04             	sub    $0x4,%esp
80105e3b:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105e3e:	50                   	push   %eax
80105e3f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e42:	50                   	push   %eax
80105e43:	6a 00                	push   $0x0
80105e45:	e8 ea fd ff ff       	call   80105c34 <argfd>
80105e4a:	83 c4 10             	add    $0x10,%esp
80105e4d:	85 c0                	test   %eax,%eax
80105e4f:	79 07                	jns    80105e58 <sys_close+0x26>
    return -1;
80105e51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e56:	eb 28                	jmp    80105e80 <sys_close+0x4e>
  proc->ofile[fd] = 0;
80105e58:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105e5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105e61:	83 c2 08             	add    $0x8,%edx
80105e64:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105e6b:	00 
  fileclose(f);
80105e6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e6f:	83 ec 0c             	sub    $0xc,%esp
80105e72:	50                   	push   %eax
80105e73:	e8 d9 b1 ff ff       	call   80101051 <fileclose>
80105e78:	83 c4 10             	add    $0x10,%esp
  return 0;
80105e7b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105e80:	c9                   	leave  
80105e81:	c3                   	ret    

80105e82 <sys_fstat>:

int
sys_fstat(void)
{
80105e82:	55                   	push   %ebp
80105e83:	89 e5                	mov    %esp,%ebp
80105e85:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105e88:	83 ec 04             	sub    $0x4,%esp
80105e8b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e8e:	50                   	push   %eax
80105e8f:	6a 00                	push   $0x0
80105e91:	6a 00                	push   $0x0
80105e93:	e8 9c fd ff ff       	call   80105c34 <argfd>
80105e98:	83 c4 10             	add    $0x10,%esp
80105e9b:	85 c0                	test   %eax,%eax
80105e9d:	78 17                	js     80105eb6 <sys_fstat+0x34>
80105e9f:	83 ec 04             	sub    $0x4,%esp
80105ea2:	6a 14                	push   $0x14
80105ea4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ea7:	50                   	push   %eax
80105ea8:	6a 01                	push   $0x1
80105eaa:	e8 71 fc ff ff       	call   80105b20 <argptr>
80105eaf:	83 c4 10             	add    $0x10,%esp
80105eb2:	85 c0                	test   %eax,%eax
80105eb4:	79 07                	jns    80105ebd <sys_fstat+0x3b>
    return -1;
80105eb6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ebb:	eb 13                	jmp    80105ed0 <sys_fstat+0x4e>
  return filestat(f, st);
80105ebd:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105ec0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ec3:	83 ec 08             	sub    $0x8,%esp
80105ec6:	52                   	push   %edx
80105ec7:	50                   	push   %eax
80105ec8:	e8 6c b2 ff ff       	call   80101139 <filestat>
80105ecd:	83 c4 10             	add    $0x10,%esp
}
80105ed0:	c9                   	leave  
80105ed1:	c3                   	ret    

80105ed2 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105ed2:	55                   	push   %ebp
80105ed3:	89 e5                	mov    %esp,%ebp
80105ed5:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105ed8:	83 ec 08             	sub    $0x8,%esp
80105edb:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105ede:	50                   	push   %eax
80105edf:	6a 00                	push   $0x0
80105ee1:	e8 97 fc ff ff       	call   80105b7d <argstr>
80105ee6:	83 c4 10             	add    $0x10,%esp
80105ee9:	85 c0                	test   %eax,%eax
80105eeb:	78 15                	js     80105f02 <sys_link+0x30>
80105eed:	83 ec 08             	sub    $0x8,%esp
80105ef0:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105ef3:	50                   	push   %eax
80105ef4:	6a 01                	push   $0x1
80105ef6:	e8 82 fc ff ff       	call   80105b7d <argstr>
80105efb:	83 c4 10             	add    $0x10,%esp
80105efe:	85 c0                	test   %eax,%eax
80105f00:	79 0a                	jns    80105f0c <sys_link+0x3a>
    return -1;
80105f02:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f07:	e9 68 01 00 00       	jmp    80106074 <sys_link+0x1a2>

  begin_op();
80105f0c:	e8 16 d6 ff ff       	call   80103527 <begin_op>
  if((ip = namei(old)) == 0){
80105f11:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105f14:	83 ec 0c             	sub    $0xc,%esp
80105f17:	50                   	push   %eax
80105f18:	e8 c1 c5 ff ff       	call   801024de <namei>
80105f1d:	83 c4 10             	add    $0x10,%esp
80105f20:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105f23:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105f27:	75 0f                	jne    80105f38 <sys_link+0x66>
    end_op();
80105f29:	e8 85 d6 ff ff       	call   801035b3 <end_op>
    return -1;
80105f2e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f33:	e9 3c 01 00 00       	jmp    80106074 <sys_link+0x1a2>
  }

  ilock(ip);
80105f38:	83 ec 0c             	sub    $0xc,%esp
80105f3b:	ff 75 f4             	pushl  -0xc(%ebp)
80105f3e:	e8 dd b9 ff ff       	call   80101920 <ilock>
80105f43:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
80105f46:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f49:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105f4d:	66 83 f8 01          	cmp    $0x1,%ax
80105f51:	75 1d                	jne    80105f70 <sys_link+0x9e>
    iunlockput(ip);
80105f53:	83 ec 0c             	sub    $0xc,%esp
80105f56:	ff 75 f4             	pushl  -0xc(%ebp)
80105f59:	e8 82 bc ff ff       	call   80101be0 <iunlockput>
80105f5e:	83 c4 10             	add    $0x10,%esp
    end_op();
80105f61:	e8 4d d6 ff ff       	call   801035b3 <end_op>
    return -1;
80105f66:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f6b:	e9 04 01 00 00       	jmp    80106074 <sys_link+0x1a2>
  }

  ip->nlink++;
80105f70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f73:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105f77:	83 c0 01             	add    $0x1,%eax
80105f7a:	89 c2                	mov    %eax,%edx
80105f7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f7f:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105f83:	83 ec 0c             	sub    $0xc,%esp
80105f86:	ff 75 f4             	pushl  -0xc(%ebp)
80105f89:	e8 b8 b7 ff ff       	call   80101746 <iupdate>
80105f8e:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80105f91:	83 ec 0c             	sub    $0xc,%esp
80105f94:	ff 75 f4             	pushl  -0xc(%ebp)
80105f97:	e8 e2 ba ff ff       	call   80101a7e <iunlock>
80105f9c:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
80105f9f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105fa2:	83 ec 08             	sub    $0x8,%esp
80105fa5:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105fa8:	52                   	push   %edx
80105fa9:	50                   	push   %eax
80105faa:	e8 4b c5 ff ff       	call   801024fa <nameiparent>
80105faf:	83 c4 10             	add    $0x10,%esp
80105fb2:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105fb5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105fb9:	74 71                	je     8010602c <sys_link+0x15a>
    goto bad;
  ilock(dp);
80105fbb:	83 ec 0c             	sub    $0xc,%esp
80105fbe:	ff 75 f0             	pushl  -0x10(%ebp)
80105fc1:	e8 5a b9 ff ff       	call   80101920 <ilock>
80105fc6:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105fc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fcc:	8b 10                	mov    (%eax),%edx
80105fce:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fd1:	8b 00                	mov    (%eax),%eax
80105fd3:	39 c2                	cmp    %eax,%edx
80105fd5:	75 1d                	jne    80105ff4 <sys_link+0x122>
80105fd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fda:	8b 40 04             	mov    0x4(%eax),%eax
80105fdd:	83 ec 04             	sub    $0x4,%esp
80105fe0:	50                   	push   %eax
80105fe1:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105fe4:	50                   	push   %eax
80105fe5:	ff 75 f0             	pushl  -0x10(%ebp)
80105fe8:	e8 55 c2 ff ff       	call   80102242 <dirlink>
80105fed:	83 c4 10             	add    $0x10,%esp
80105ff0:	85 c0                	test   %eax,%eax
80105ff2:	79 10                	jns    80106004 <sys_link+0x132>
    iunlockput(dp);
80105ff4:	83 ec 0c             	sub    $0xc,%esp
80105ff7:	ff 75 f0             	pushl  -0x10(%ebp)
80105ffa:	e8 e1 bb ff ff       	call   80101be0 <iunlockput>
80105fff:	83 c4 10             	add    $0x10,%esp
    goto bad;
80106002:	eb 29                	jmp    8010602d <sys_link+0x15b>
  }
  iunlockput(dp);
80106004:	83 ec 0c             	sub    $0xc,%esp
80106007:	ff 75 f0             	pushl  -0x10(%ebp)
8010600a:	e8 d1 bb ff ff       	call   80101be0 <iunlockput>
8010600f:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80106012:	83 ec 0c             	sub    $0xc,%esp
80106015:	ff 75 f4             	pushl  -0xc(%ebp)
80106018:	e8 d3 ba ff ff       	call   80101af0 <iput>
8010601d:	83 c4 10             	add    $0x10,%esp

  end_op();
80106020:	e8 8e d5 ff ff       	call   801035b3 <end_op>

  return 0;
80106025:	b8 00 00 00 00       	mov    $0x0,%eax
8010602a:	eb 48                	jmp    80106074 <sys_link+0x1a2>
  ip->nlink++;
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
8010602c:	90                   	nop
  end_op();

  return 0;

bad:
  ilock(ip);
8010602d:	83 ec 0c             	sub    $0xc,%esp
80106030:	ff 75 f4             	pushl  -0xc(%ebp)
80106033:	e8 e8 b8 ff ff       	call   80101920 <ilock>
80106038:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
8010603b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010603e:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106042:	83 e8 01             	sub    $0x1,%eax
80106045:	89 c2                	mov    %eax,%edx
80106047:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010604a:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
8010604e:	83 ec 0c             	sub    $0xc,%esp
80106051:	ff 75 f4             	pushl  -0xc(%ebp)
80106054:	e8 ed b6 ff ff       	call   80101746 <iupdate>
80106059:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
8010605c:	83 ec 0c             	sub    $0xc,%esp
8010605f:	ff 75 f4             	pushl  -0xc(%ebp)
80106062:	e8 79 bb ff ff       	call   80101be0 <iunlockput>
80106067:	83 c4 10             	add    $0x10,%esp
  end_op();
8010606a:	e8 44 d5 ff ff       	call   801035b3 <end_op>
  return -1;
8010606f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106074:	c9                   	leave  
80106075:	c3                   	ret    

80106076 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80106076:	55                   	push   %ebp
80106077:	89 e5                	mov    %esp,%ebp
80106079:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
8010607c:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80106083:	eb 40                	jmp    801060c5 <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106085:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106088:	6a 10                	push   $0x10
8010608a:	50                   	push   %eax
8010608b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010608e:	50                   	push   %eax
8010608f:	ff 75 08             	pushl  0x8(%ebp)
80106092:	e8 f7 bd ff ff       	call   80101e8e <readi>
80106097:	83 c4 10             	add    $0x10,%esp
8010609a:	83 f8 10             	cmp    $0x10,%eax
8010609d:	74 0d                	je     801060ac <isdirempty+0x36>
      panic("isdirempty: readi");
8010609f:	83 ec 0c             	sub    $0xc,%esp
801060a2:	68 36 91 10 80       	push   $0x80109136
801060a7:	e8 ba a4 ff ff       	call   80100566 <panic>
    if(de.inum != 0)
801060ac:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801060b0:	66 85 c0             	test   %ax,%ax
801060b3:	74 07                	je     801060bc <isdirempty+0x46>
      return 0;
801060b5:	b8 00 00 00 00       	mov    $0x0,%eax
801060ba:	eb 1b                	jmp    801060d7 <isdirempty+0x61>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801060bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060bf:	83 c0 10             	add    $0x10,%eax
801060c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801060c5:	8b 45 08             	mov    0x8(%ebp),%eax
801060c8:	8b 50 18             	mov    0x18(%eax),%edx
801060cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060ce:	39 c2                	cmp    %eax,%edx
801060d0:	77 b3                	ja     80106085 <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
801060d2:	b8 01 00 00 00       	mov    $0x1,%eax
}
801060d7:	c9                   	leave  
801060d8:	c3                   	ret    

801060d9 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
801060d9:	55                   	push   %ebp
801060da:	89 e5                	mov    %esp,%ebp
801060dc:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
801060df:	83 ec 08             	sub    $0x8,%esp
801060e2:	8d 45 cc             	lea    -0x34(%ebp),%eax
801060e5:	50                   	push   %eax
801060e6:	6a 00                	push   $0x0
801060e8:	e8 90 fa ff ff       	call   80105b7d <argstr>
801060ed:	83 c4 10             	add    $0x10,%esp
801060f0:	85 c0                	test   %eax,%eax
801060f2:	79 0a                	jns    801060fe <sys_unlink+0x25>
    return -1;
801060f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060f9:	e9 bc 01 00 00       	jmp    801062ba <sys_unlink+0x1e1>

  begin_op();
801060fe:	e8 24 d4 ff ff       	call   80103527 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80106103:	8b 45 cc             	mov    -0x34(%ebp),%eax
80106106:	83 ec 08             	sub    $0x8,%esp
80106109:	8d 55 d2             	lea    -0x2e(%ebp),%edx
8010610c:	52                   	push   %edx
8010610d:	50                   	push   %eax
8010610e:	e8 e7 c3 ff ff       	call   801024fa <nameiparent>
80106113:	83 c4 10             	add    $0x10,%esp
80106116:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106119:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010611d:	75 0f                	jne    8010612e <sys_unlink+0x55>
    end_op();
8010611f:	e8 8f d4 ff ff       	call   801035b3 <end_op>
    return -1;
80106124:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106129:	e9 8c 01 00 00       	jmp    801062ba <sys_unlink+0x1e1>
  }

  ilock(dp);
8010612e:	83 ec 0c             	sub    $0xc,%esp
80106131:	ff 75 f4             	pushl  -0xc(%ebp)
80106134:	e8 e7 b7 ff ff       	call   80101920 <ilock>
80106139:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010613c:	83 ec 08             	sub    $0x8,%esp
8010613f:	68 48 91 10 80       	push   $0x80109148
80106144:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106147:	50                   	push   %eax
80106148:	e8 20 c0 ff ff       	call   8010216d <namecmp>
8010614d:	83 c4 10             	add    $0x10,%esp
80106150:	85 c0                	test   %eax,%eax
80106152:	0f 84 4a 01 00 00    	je     801062a2 <sys_unlink+0x1c9>
80106158:	83 ec 08             	sub    $0x8,%esp
8010615b:	68 4a 91 10 80       	push   $0x8010914a
80106160:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106163:	50                   	push   %eax
80106164:	e8 04 c0 ff ff       	call   8010216d <namecmp>
80106169:	83 c4 10             	add    $0x10,%esp
8010616c:	85 c0                	test   %eax,%eax
8010616e:	0f 84 2e 01 00 00    	je     801062a2 <sys_unlink+0x1c9>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80106174:	83 ec 04             	sub    $0x4,%esp
80106177:	8d 45 c8             	lea    -0x38(%ebp),%eax
8010617a:	50                   	push   %eax
8010617b:	8d 45 d2             	lea    -0x2e(%ebp),%eax
8010617e:	50                   	push   %eax
8010617f:	ff 75 f4             	pushl  -0xc(%ebp)
80106182:	e8 01 c0 ff ff       	call   80102188 <dirlookup>
80106187:	83 c4 10             	add    $0x10,%esp
8010618a:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010618d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106191:	0f 84 0a 01 00 00    	je     801062a1 <sys_unlink+0x1c8>
    goto bad;
  ilock(ip);
80106197:	83 ec 0c             	sub    $0xc,%esp
8010619a:	ff 75 f0             	pushl  -0x10(%ebp)
8010619d:	e8 7e b7 ff ff       	call   80101920 <ilock>
801061a2:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
801061a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061a8:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801061ac:	66 85 c0             	test   %ax,%ax
801061af:	7f 0d                	jg     801061be <sys_unlink+0xe5>
    panic("unlink: nlink < 1");
801061b1:	83 ec 0c             	sub    $0xc,%esp
801061b4:	68 4d 91 10 80       	push   $0x8010914d
801061b9:	e8 a8 a3 ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
801061be:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061c1:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801061c5:	66 83 f8 01          	cmp    $0x1,%ax
801061c9:	75 25                	jne    801061f0 <sys_unlink+0x117>
801061cb:	83 ec 0c             	sub    $0xc,%esp
801061ce:	ff 75 f0             	pushl  -0x10(%ebp)
801061d1:	e8 a0 fe ff ff       	call   80106076 <isdirempty>
801061d6:	83 c4 10             	add    $0x10,%esp
801061d9:	85 c0                	test   %eax,%eax
801061db:	75 13                	jne    801061f0 <sys_unlink+0x117>
    iunlockput(ip);
801061dd:	83 ec 0c             	sub    $0xc,%esp
801061e0:	ff 75 f0             	pushl  -0x10(%ebp)
801061e3:	e8 f8 b9 ff ff       	call   80101be0 <iunlockput>
801061e8:	83 c4 10             	add    $0x10,%esp
    goto bad;
801061eb:	e9 b2 00 00 00       	jmp    801062a2 <sys_unlink+0x1c9>
  }

  memset(&de, 0, sizeof(de));
801061f0:	83 ec 04             	sub    $0x4,%esp
801061f3:	6a 10                	push   $0x10
801061f5:	6a 00                	push   $0x0
801061f7:	8d 45 e0             	lea    -0x20(%ebp),%eax
801061fa:	50                   	push   %eax
801061fb:	e8 d3 f5 ff ff       	call   801057d3 <memset>
80106200:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106203:	8b 45 c8             	mov    -0x38(%ebp),%eax
80106206:	6a 10                	push   $0x10
80106208:	50                   	push   %eax
80106209:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010620c:	50                   	push   %eax
8010620d:	ff 75 f4             	pushl  -0xc(%ebp)
80106210:	e8 d0 bd ff ff       	call   80101fe5 <writei>
80106215:	83 c4 10             	add    $0x10,%esp
80106218:	83 f8 10             	cmp    $0x10,%eax
8010621b:	74 0d                	je     8010622a <sys_unlink+0x151>
    panic("unlink: writei");
8010621d:	83 ec 0c             	sub    $0xc,%esp
80106220:	68 5f 91 10 80       	push   $0x8010915f
80106225:	e8 3c a3 ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR){
8010622a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010622d:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106231:	66 83 f8 01          	cmp    $0x1,%ax
80106235:	75 21                	jne    80106258 <sys_unlink+0x17f>
    dp->nlink--;
80106237:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010623a:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010623e:	83 e8 01             	sub    $0x1,%eax
80106241:	89 c2                	mov    %eax,%edx
80106243:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106246:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
8010624a:	83 ec 0c             	sub    $0xc,%esp
8010624d:	ff 75 f4             	pushl  -0xc(%ebp)
80106250:	e8 f1 b4 ff ff       	call   80101746 <iupdate>
80106255:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
80106258:	83 ec 0c             	sub    $0xc,%esp
8010625b:	ff 75 f4             	pushl  -0xc(%ebp)
8010625e:	e8 7d b9 ff ff       	call   80101be0 <iunlockput>
80106263:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
80106266:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106269:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010626d:	83 e8 01             	sub    $0x1,%eax
80106270:	89 c2                	mov    %eax,%edx
80106272:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106275:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80106279:	83 ec 0c             	sub    $0xc,%esp
8010627c:	ff 75 f0             	pushl  -0x10(%ebp)
8010627f:	e8 c2 b4 ff ff       	call   80101746 <iupdate>
80106284:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80106287:	83 ec 0c             	sub    $0xc,%esp
8010628a:	ff 75 f0             	pushl  -0x10(%ebp)
8010628d:	e8 4e b9 ff ff       	call   80101be0 <iunlockput>
80106292:	83 c4 10             	add    $0x10,%esp

  end_op();
80106295:	e8 19 d3 ff ff       	call   801035b3 <end_op>

  return 0;
8010629a:	b8 00 00 00 00       	mov    $0x0,%eax
8010629f:	eb 19                	jmp    801062ba <sys_unlink+0x1e1>
  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
801062a1:	90                   	nop
  end_op();

  return 0;

bad:
  iunlockput(dp);
801062a2:	83 ec 0c             	sub    $0xc,%esp
801062a5:	ff 75 f4             	pushl  -0xc(%ebp)
801062a8:	e8 33 b9 ff ff       	call   80101be0 <iunlockput>
801062ad:	83 c4 10             	add    $0x10,%esp
  end_op();
801062b0:	e8 fe d2 ff ff       	call   801035b3 <end_op>
  return -1;
801062b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801062ba:	c9                   	leave  
801062bb:	c3                   	ret    

801062bc <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
801062bc:	55                   	push   %ebp
801062bd:	89 e5                	mov    %esp,%ebp
801062bf:	83 ec 38             	sub    $0x38,%esp
801062c2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801062c5:	8b 55 10             	mov    0x10(%ebp),%edx
801062c8:	8b 45 14             	mov    0x14(%ebp),%eax
801062cb:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
801062cf:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
801062d3:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801062d7:	83 ec 08             	sub    $0x8,%esp
801062da:	8d 45 de             	lea    -0x22(%ebp),%eax
801062dd:	50                   	push   %eax
801062de:	ff 75 08             	pushl  0x8(%ebp)
801062e1:	e8 14 c2 ff ff       	call   801024fa <nameiparent>
801062e6:	83 c4 10             	add    $0x10,%esp
801062e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801062ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801062f0:	75 0a                	jne    801062fc <create+0x40>
    return 0;
801062f2:	b8 00 00 00 00       	mov    $0x0,%eax
801062f7:	e9 90 01 00 00       	jmp    8010648c <create+0x1d0>
  ilock(dp);
801062fc:	83 ec 0c             	sub    $0xc,%esp
801062ff:	ff 75 f4             	pushl  -0xc(%ebp)
80106302:	e8 19 b6 ff ff       	call   80101920 <ilock>
80106307:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
8010630a:	83 ec 04             	sub    $0x4,%esp
8010630d:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106310:	50                   	push   %eax
80106311:	8d 45 de             	lea    -0x22(%ebp),%eax
80106314:	50                   	push   %eax
80106315:	ff 75 f4             	pushl  -0xc(%ebp)
80106318:	e8 6b be ff ff       	call   80102188 <dirlookup>
8010631d:	83 c4 10             	add    $0x10,%esp
80106320:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106323:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106327:	74 50                	je     80106379 <create+0xbd>
    iunlockput(dp);
80106329:	83 ec 0c             	sub    $0xc,%esp
8010632c:	ff 75 f4             	pushl  -0xc(%ebp)
8010632f:	e8 ac b8 ff ff       	call   80101be0 <iunlockput>
80106334:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
80106337:	83 ec 0c             	sub    $0xc,%esp
8010633a:	ff 75 f0             	pushl  -0x10(%ebp)
8010633d:	e8 de b5 ff ff       	call   80101920 <ilock>
80106342:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
80106345:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
8010634a:	75 15                	jne    80106361 <create+0xa5>
8010634c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010634f:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106353:	66 83 f8 02          	cmp    $0x2,%ax
80106357:	75 08                	jne    80106361 <create+0xa5>
      return ip;
80106359:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010635c:	e9 2b 01 00 00       	jmp    8010648c <create+0x1d0>
    iunlockput(ip);
80106361:	83 ec 0c             	sub    $0xc,%esp
80106364:	ff 75 f0             	pushl  -0x10(%ebp)
80106367:	e8 74 b8 ff ff       	call   80101be0 <iunlockput>
8010636c:	83 c4 10             	add    $0x10,%esp
    return 0;
8010636f:	b8 00 00 00 00       	mov    $0x0,%eax
80106374:	e9 13 01 00 00       	jmp    8010648c <create+0x1d0>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80106379:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
8010637d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106380:	8b 00                	mov    (%eax),%eax
80106382:	83 ec 08             	sub    $0x8,%esp
80106385:	52                   	push   %edx
80106386:	50                   	push   %eax
80106387:	e8 e3 b2 ff ff       	call   8010166f <ialloc>
8010638c:	83 c4 10             	add    $0x10,%esp
8010638f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106392:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106396:	75 0d                	jne    801063a5 <create+0xe9>
    panic("create: ialloc");
80106398:	83 ec 0c             	sub    $0xc,%esp
8010639b:	68 6e 91 10 80       	push   $0x8010916e
801063a0:	e8 c1 a1 ff ff       	call   80100566 <panic>

  ilock(ip);
801063a5:	83 ec 0c             	sub    $0xc,%esp
801063a8:	ff 75 f0             	pushl  -0x10(%ebp)
801063ab:	e8 70 b5 ff ff       	call   80101920 <ilock>
801063b0:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
801063b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063b6:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
801063ba:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
801063be:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063c1:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
801063c5:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
801063c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063cc:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
801063d2:	83 ec 0c             	sub    $0xc,%esp
801063d5:	ff 75 f0             	pushl  -0x10(%ebp)
801063d8:	e8 69 b3 ff ff       	call   80101746 <iupdate>
801063dd:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
801063e0:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801063e5:	75 6a                	jne    80106451 <create+0x195>
    dp->nlink++;  // for ".."
801063e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063ea:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801063ee:	83 c0 01             	add    $0x1,%eax
801063f1:	89 c2                	mov    %eax,%edx
801063f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063f6:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
801063fa:	83 ec 0c             	sub    $0xc,%esp
801063fd:	ff 75 f4             	pushl  -0xc(%ebp)
80106400:	e8 41 b3 ff ff       	call   80101746 <iupdate>
80106405:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80106408:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010640b:	8b 40 04             	mov    0x4(%eax),%eax
8010640e:	83 ec 04             	sub    $0x4,%esp
80106411:	50                   	push   %eax
80106412:	68 48 91 10 80       	push   $0x80109148
80106417:	ff 75 f0             	pushl  -0x10(%ebp)
8010641a:	e8 23 be ff ff       	call   80102242 <dirlink>
8010641f:	83 c4 10             	add    $0x10,%esp
80106422:	85 c0                	test   %eax,%eax
80106424:	78 1e                	js     80106444 <create+0x188>
80106426:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106429:	8b 40 04             	mov    0x4(%eax),%eax
8010642c:	83 ec 04             	sub    $0x4,%esp
8010642f:	50                   	push   %eax
80106430:	68 4a 91 10 80       	push   $0x8010914a
80106435:	ff 75 f0             	pushl  -0x10(%ebp)
80106438:	e8 05 be ff ff       	call   80102242 <dirlink>
8010643d:	83 c4 10             	add    $0x10,%esp
80106440:	85 c0                	test   %eax,%eax
80106442:	79 0d                	jns    80106451 <create+0x195>
      panic("create dots");
80106444:	83 ec 0c             	sub    $0xc,%esp
80106447:	68 7d 91 10 80       	push   $0x8010917d
8010644c:	e8 15 a1 ff ff       	call   80100566 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80106451:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106454:	8b 40 04             	mov    0x4(%eax),%eax
80106457:	83 ec 04             	sub    $0x4,%esp
8010645a:	50                   	push   %eax
8010645b:	8d 45 de             	lea    -0x22(%ebp),%eax
8010645e:	50                   	push   %eax
8010645f:	ff 75 f4             	pushl  -0xc(%ebp)
80106462:	e8 db bd ff ff       	call   80102242 <dirlink>
80106467:	83 c4 10             	add    $0x10,%esp
8010646a:	85 c0                	test   %eax,%eax
8010646c:	79 0d                	jns    8010647b <create+0x1bf>
    panic("create: dirlink");
8010646e:	83 ec 0c             	sub    $0xc,%esp
80106471:	68 89 91 10 80       	push   $0x80109189
80106476:	e8 eb a0 ff ff       	call   80100566 <panic>

  iunlockput(dp);
8010647b:	83 ec 0c             	sub    $0xc,%esp
8010647e:	ff 75 f4             	pushl  -0xc(%ebp)
80106481:	e8 5a b7 ff ff       	call   80101be0 <iunlockput>
80106486:	83 c4 10             	add    $0x10,%esp

  return ip;
80106489:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010648c:	c9                   	leave  
8010648d:	c3                   	ret    

8010648e <sys_open>:

int
sys_open(void)
{
8010648e:	55                   	push   %ebp
8010648f:	89 e5                	mov    %esp,%ebp
80106491:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106494:	83 ec 08             	sub    $0x8,%esp
80106497:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010649a:	50                   	push   %eax
8010649b:	6a 00                	push   $0x0
8010649d:	e8 db f6 ff ff       	call   80105b7d <argstr>
801064a2:	83 c4 10             	add    $0x10,%esp
801064a5:	85 c0                	test   %eax,%eax
801064a7:	78 15                	js     801064be <sys_open+0x30>
801064a9:	83 ec 08             	sub    $0x8,%esp
801064ac:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801064af:	50                   	push   %eax
801064b0:	6a 01                	push   $0x1
801064b2:	e8 41 f6 ff ff       	call   80105af8 <argint>
801064b7:	83 c4 10             	add    $0x10,%esp
801064ba:	85 c0                	test   %eax,%eax
801064bc:	79 0a                	jns    801064c8 <sys_open+0x3a>
    return -1;
801064be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064c3:	e9 61 01 00 00       	jmp    80106629 <sys_open+0x19b>

  begin_op();
801064c8:	e8 5a d0 ff ff       	call   80103527 <begin_op>

  if(omode & O_CREATE){
801064cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801064d0:	25 00 02 00 00       	and    $0x200,%eax
801064d5:	85 c0                	test   %eax,%eax
801064d7:	74 2a                	je     80106503 <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
801064d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
801064dc:	6a 00                	push   $0x0
801064de:	6a 00                	push   $0x0
801064e0:	6a 02                	push   $0x2
801064e2:	50                   	push   %eax
801064e3:	e8 d4 fd ff ff       	call   801062bc <create>
801064e8:	83 c4 10             	add    $0x10,%esp
801064eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
801064ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801064f2:	75 75                	jne    80106569 <sys_open+0xdb>
      end_op();
801064f4:	e8 ba d0 ff ff       	call   801035b3 <end_op>
      return -1;
801064f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064fe:	e9 26 01 00 00       	jmp    80106629 <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
80106503:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106506:	83 ec 0c             	sub    $0xc,%esp
80106509:	50                   	push   %eax
8010650a:	e8 cf bf ff ff       	call   801024de <namei>
8010650f:	83 c4 10             	add    $0x10,%esp
80106512:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106515:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106519:	75 0f                	jne    8010652a <sys_open+0x9c>
      end_op();
8010651b:	e8 93 d0 ff ff       	call   801035b3 <end_op>
      return -1;
80106520:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106525:	e9 ff 00 00 00       	jmp    80106629 <sys_open+0x19b>
    }
    ilock(ip);
8010652a:	83 ec 0c             	sub    $0xc,%esp
8010652d:	ff 75 f4             	pushl  -0xc(%ebp)
80106530:	e8 eb b3 ff ff       	call   80101920 <ilock>
80106535:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
80106538:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010653b:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010653f:	66 83 f8 01          	cmp    $0x1,%ax
80106543:	75 24                	jne    80106569 <sys_open+0xdb>
80106545:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106548:	85 c0                	test   %eax,%eax
8010654a:	74 1d                	je     80106569 <sys_open+0xdb>
      iunlockput(ip);
8010654c:	83 ec 0c             	sub    $0xc,%esp
8010654f:	ff 75 f4             	pushl  -0xc(%ebp)
80106552:	e8 89 b6 ff ff       	call   80101be0 <iunlockput>
80106557:	83 c4 10             	add    $0x10,%esp
      end_op();
8010655a:	e8 54 d0 ff ff       	call   801035b3 <end_op>
      return -1;
8010655f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106564:	e9 c0 00 00 00       	jmp    80106629 <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80106569:	e8 25 aa ff ff       	call   80100f93 <filealloc>
8010656e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106571:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106575:	74 17                	je     8010658e <sys_open+0x100>
80106577:	83 ec 0c             	sub    $0xc,%esp
8010657a:	ff 75 f0             	pushl  -0x10(%ebp)
8010657d:	e8 27 f7 ff ff       	call   80105ca9 <fdalloc>
80106582:	83 c4 10             	add    $0x10,%esp
80106585:	89 45 ec             	mov    %eax,-0x14(%ebp)
80106588:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010658c:	79 2e                	jns    801065bc <sys_open+0x12e>
    if(f)
8010658e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106592:	74 0e                	je     801065a2 <sys_open+0x114>
      fileclose(f);
80106594:	83 ec 0c             	sub    $0xc,%esp
80106597:	ff 75 f0             	pushl  -0x10(%ebp)
8010659a:	e8 b2 aa ff ff       	call   80101051 <fileclose>
8010659f:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801065a2:	83 ec 0c             	sub    $0xc,%esp
801065a5:	ff 75 f4             	pushl  -0xc(%ebp)
801065a8:	e8 33 b6 ff ff       	call   80101be0 <iunlockput>
801065ad:	83 c4 10             	add    $0x10,%esp
    end_op();
801065b0:	e8 fe cf ff ff       	call   801035b3 <end_op>
    return -1;
801065b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065ba:	eb 6d                	jmp    80106629 <sys_open+0x19b>
  }
  iunlock(ip);
801065bc:	83 ec 0c             	sub    $0xc,%esp
801065bf:	ff 75 f4             	pushl  -0xc(%ebp)
801065c2:	e8 b7 b4 ff ff       	call   80101a7e <iunlock>
801065c7:	83 c4 10             	add    $0x10,%esp
  end_op();
801065ca:	e8 e4 cf ff ff       	call   801035b3 <end_op>

  f->type = FD_INODE;
801065cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065d2:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
801065d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065db:	8b 55 f4             	mov    -0xc(%ebp),%edx
801065de:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
801065e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065e4:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
801065eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801065ee:	83 e0 01             	and    $0x1,%eax
801065f1:	85 c0                	test   %eax,%eax
801065f3:	0f 94 c0             	sete   %al
801065f6:	89 c2                	mov    %eax,%edx
801065f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065fb:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801065fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106601:	83 e0 01             	and    $0x1,%eax
80106604:	85 c0                	test   %eax,%eax
80106606:	75 0a                	jne    80106612 <sys_open+0x184>
80106608:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010660b:	83 e0 02             	and    $0x2,%eax
8010660e:	85 c0                	test   %eax,%eax
80106610:	74 07                	je     80106619 <sys_open+0x18b>
80106612:	b8 01 00 00 00       	mov    $0x1,%eax
80106617:	eb 05                	jmp    8010661e <sys_open+0x190>
80106619:	b8 00 00 00 00       	mov    $0x0,%eax
8010661e:	89 c2                	mov    %eax,%edx
80106620:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106623:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80106626:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80106629:	c9                   	leave  
8010662a:	c3                   	ret    

8010662b <sys_mkdir>:

int
sys_mkdir(void)
{
8010662b:	55                   	push   %ebp
8010662c:	89 e5                	mov    %esp,%ebp
8010662e:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106631:	e8 f1 ce ff ff       	call   80103527 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80106636:	83 ec 08             	sub    $0x8,%esp
80106639:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010663c:	50                   	push   %eax
8010663d:	6a 00                	push   $0x0
8010663f:	e8 39 f5 ff ff       	call   80105b7d <argstr>
80106644:	83 c4 10             	add    $0x10,%esp
80106647:	85 c0                	test   %eax,%eax
80106649:	78 1b                	js     80106666 <sys_mkdir+0x3b>
8010664b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010664e:	6a 00                	push   $0x0
80106650:	6a 00                	push   $0x0
80106652:	6a 01                	push   $0x1
80106654:	50                   	push   %eax
80106655:	e8 62 fc ff ff       	call   801062bc <create>
8010665a:	83 c4 10             	add    $0x10,%esp
8010665d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106660:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106664:	75 0c                	jne    80106672 <sys_mkdir+0x47>
    end_op();
80106666:	e8 48 cf ff ff       	call   801035b3 <end_op>
    return -1;
8010666b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106670:	eb 18                	jmp    8010668a <sys_mkdir+0x5f>
  }
  iunlockput(ip);
80106672:	83 ec 0c             	sub    $0xc,%esp
80106675:	ff 75 f4             	pushl  -0xc(%ebp)
80106678:	e8 63 b5 ff ff       	call   80101be0 <iunlockput>
8010667d:	83 c4 10             	add    $0x10,%esp
  end_op();
80106680:	e8 2e cf ff ff       	call   801035b3 <end_op>
  return 0;
80106685:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010668a:	c9                   	leave  
8010668b:	c3                   	ret    

8010668c <sys_mknod>:

int
sys_mknod(void)
{
8010668c:	55                   	push   %ebp
8010668d:	89 e5                	mov    %esp,%ebp
8010668f:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
80106692:	e8 90 ce ff ff       	call   80103527 <begin_op>
  if((len=argstr(0, &path)) < 0 ||
80106697:	83 ec 08             	sub    $0x8,%esp
8010669a:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010669d:	50                   	push   %eax
8010669e:	6a 00                	push   $0x0
801066a0:	e8 d8 f4 ff ff       	call   80105b7d <argstr>
801066a5:	83 c4 10             	add    $0x10,%esp
801066a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
801066ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801066af:	78 4f                	js     80106700 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
801066b1:	83 ec 08             	sub    $0x8,%esp
801066b4:	8d 45 e8             	lea    -0x18(%ebp),%eax
801066b7:	50                   	push   %eax
801066b8:	6a 01                	push   $0x1
801066ba:	e8 39 f4 ff ff       	call   80105af8 <argint>
801066bf:	83 c4 10             	add    $0x10,%esp
  char *path;
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
801066c2:	85 c0                	test   %eax,%eax
801066c4:	78 3a                	js     80106700 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801066c6:	83 ec 08             	sub    $0x8,%esp
801066c9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801066cc:	50                   	push   %eax
801066cd:	6a 02                	push   $0x2
801066cf:	e8 24 f4 ff ff       	call   80105af8 <argint>
801066d4:	83 c4 10             	add    $0x10,%esp
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
801066d7:	85 c0                	test   %eax,%eax
801066d9:	78 25                	js     80106700 <sys_mknod+0x74>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
801066db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801066de:	0f bf c8             	movswl %ax,%ecx
801066e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801066e4:	0f bf d0             	movswl %ax,%edx
801066e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801066ea:	51                   	push   %ecx
801066eb:	52                   	push   %edx
801066ec:	6a 03                	push   $0x3
801066ee:	50                   	push   %eax
801066ef:	e8 c8 fb ff ff       	call   801062bc <create>
801066f4:	83 c4 10             	add    $0x10,%esp
801066f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
801066fa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801066fe:	75 0c                	jne    8010670c <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80106700:	e8 ae ce ff ff       	call   801035b3 <end_op>
    return -1;
80106705:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010670a:	eb 18                	jmp    80106724 <sys_mknod+0x98>
  }
  iunlockput(ip);
8010670c:	83 ec 0c             	sub    $0xc,%esp
8010670f:	ff 75 f0             	pushl  -0x10(%ebp)
80106712:	e8 c9 b4 ff ff       	call   80101be0 <iunlockput>
80106717:	83 c4 10             	add    $0x10,%esp
  end_op();
8010671a:	e8 94 ce ff ff       	call   801035b3 <end_op>
  return 0;
8010671f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106724:	c9                   	leave  
80106725:	c3                   	ret    

80106726 <sys_chdir>:

int
sys_chdir(void)
{
80106726:	55                   	push   %ebp
80106727:	89 e5                	mov    %esp,%ebp
80106729:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
8010672c:	e8 f6 cd ff ff       	call   80103527 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80106731:	83 ec 08             	sub    $0x8,%esp
80106734:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106737:	50                   	push   %eax
80106738:	6a 00                	push   $0x0
8010673a:	e8 3e f4 ff ff       	call   80105b7d <argstr>
8010673f:	83 c4 10             	add    $0x10,%esp
80106742:	85 c0                	test   %eax,%eax
80106744:	78 18                	js     8010675e <sys_chdir+0x38>
80106746:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106749:	83 ec 0c             	sub    $0xc,%esp
8010674c:	50                   	push   %eax
8010674d:	e8 8c bd ff ff       	call   801024de <namei>
80106752:	83 c4 10             	add    $0x10,%esp
80106755:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106758:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010675c:	75 0c                	jne    8010676a <sys_chdir+0x44>
    end_op();
8010675e:	e8 50 ce ff ff       	call   801035b3 <end_op>
    return -1;
80106763:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106768:	eb 6e                	jmp    801067d8 <sys_chdir+0xb2>
  }
  ilock(ip);
8010676a:	83 ec 0c             	sub    $0xc,%esp
8010676d:	ff 75 f4             	pushl  -0xc(%ebp)
80106770:	e8 ab b1 ff ff       	call   80101920 <ilock>
80106775:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
80106778:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010677b:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010677f:	66 83 f8 01          	cmp    $0x1,%ax
80106783:	74 1a                	je     8010679f <sys_chdir+0x79>
    iunlockput(ip);
80106785:	83 ec 0c             	sub    $0xc,%esp
80106788:	ff 75 f4             	pushl  -0xc(%ebp)
8010678b:	e8 50 b4 ff ff       	call   80101be0 <iunlockput>
80106790:	83 c4 10             	add    $0x10,%esp
    end_op();
80106793:	e8 1b ce ff ff       	call   801035b3 <end_op>
    return -1;
80106798:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010679d:	eb 39                	jmp    801067d8 <sys_chdir+0xb2>
  }
  iunlock(ip);
8010679f:	83 ec 0c             	sub    $0xc,%esp
801067a2:	ff 75 f4             	pushl  -0xc(%ebp)
801067a5:	e8 d4 b2 ff ff       	call   80101a7e <iunlock>
801067aa:	83 c4 10             	add    $0x10,%esp
  iput(proc->cwd);
801067ad:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801067b3:	8b 40 68             	mov    0x68(%eax),%eax
801067b6:	83 ec 0c             	sub    $0xc,%esp
801067b9:	50                   	push   %eax
801067ba:	e8 31 b3 ff ff       	call   80101af0 <iput>
801067bf:	83 c4 10             	add    $0x10,%esp
  end_op();
801067c2:	e8 ec cd ff ff       	call   801035b3 <end_op>
  proc->cwd = ip;
801067c7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801067cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
801067d0:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
801067d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
801067d8:	c9                   	leave  
801067d9:	c3                   	ret    

801067da <sys_exec>:

int
sys_exec(void)
{
801067da:	55                   	push   %ebp
801067db:	89 e5                	mov    %esp,%ebp
801067dd:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801067e3:	83 ec 08             	sub    $0x8,%esp
801067e6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801067e9:	50                   	push   %eax
801067ea:	6a 00                	push   $0x0
801067ec:	e8 8c f3 ff ff       	call   80105b7d <argstr>
801067f1:	83 c4 10             	add    $0x10,%esp
801067f4:	85 c0                	test   %eax,%eax
801067f6:	78 18                	js     80106810 <sys_exec+0x36>
801067f8:	83 ec 08             	sub    $0x8,%esp
801067fb:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80106801:	50                   	push   %eax
80106802:	6a 01                	push   $0x1
80106804:	e8 ef f2 ff ff       	call   80105af8 <argint>
80106809:	83 c4 10             	add    $0x10,%esp
8010680c:	85 c0                	test   %eax,%eax
8010680e:	79 0a                	jns    8010681a <sys_exec+0x40>
    return -1;
80106810:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106815:	e9 c6 00 00 00       	jmp    801068e0 <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
8010681a:	83 ec 04             	sub    $0x4,%esp
8010681d:	68 80 00 00 00       	push   $0x80
80106822:	6a 00                	push   $0x0
80106824:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
8010682a:	50                   	push   %eax
8010682b:	e8 a3 ef ff ff       	call   801057d3 <memset>
80106830:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80106833:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
8010683a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010683d:	83 f8 1f             	cmp    $0x1f,%eax
80106840:	76 0a                	jbe    8010684c <sys_exec+0x72>
      return -1;
80106842:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106847:	e9 94 00 00 00       	jmp    801068e0 <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
8010684c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010684f:	c1 e0 02             	shl    $0x2,%eax
80106852:	89 c2                	mov    %eax,%edx
80106854:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
8010685a:	01 c2                	add    %eax,%edx
8010685c:	83 ec 08             	sub    $0x8,%esp
8010685f:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106865:	50                   	push   %eax
80106866:	52                   	push   %edx
80106867:	e8 f0 f1 ff ff       	call   80105a5c <fetchint>
8010686c:	83 c4 10             	add    $0x10,%esp
8010686f:	85 c0                	test   %eax,%eax
80106871:	79 07                	jns    8010687a <sys_exec+0xa0>
      return -1;
80106873:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106878:	eb 66                	jmp    801068e0 <sys_exec+0x106>
    if(uarg == 0){
8010687a:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106880:	85 c0                	test   %eax,%eax
80106882:	75 27                	jne    801068ab <sys_exec+0xd1>
      argv[i] = 0;
80106884:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106887:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
8010688e:	00 00 00 00 
      break;
80106892:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80106893:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106896:	83 ec 08             	sub    $0x8,%esp
80106899:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
8010689f:	52                   	push   %edx
801068a0:	50                   	push   %eax
801068a1:	e8 cb a2 ff ff       	call   80100b71 <exec>
801068a6:	83 c4 10             	add    $0x10,%esp
801068a9:	eb 35                	jmp    801068e0 <sys_exec+0x106>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801068ab:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801068b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801068b4:	c1 e2 02             	shl    $0x2,%edx
801068b7:	01 c2                	add    %eax,%edx
801068b9:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801068bf:	83 ec 08             	sub    $0x8,%esp
801068c2:	52                   	push   %edx
801068c3:	50                   	push   %eax
801068c4:	e8 cd f1 ff ff       	call   80105a96 <fetchstr>
801068c9:	83 c4 10             	add    $0x10,%esp
801068cc:	85 c0                	test   %eax,%eax
801068ce:	79 07                	jns    801068d7 <sys_exec+0xfd>
      return -1;
801068d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068d5:	eb 09                	jmp    801068e0 <sys_exec+0x106>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
801068d7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
801068db:	e9 5a ff ff ff       	jmp    8010683a <sys_exec+0x60>
  return exec(path, argv);
}
801068e0:	c9                   	leave  
801068e1:	c3                   	ret    

801068e2 <sys_pipe>:

int
sys_pipe(void)
{
801068e2:	55                   	push   %ebp
801068e3:	89 e5                	mov    %esp,%ebp
801068e5:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801068e8:	83 ec 04             	sub    $0x4,%esp
801068eb:	6a 08                	push   $0x8
801068ed:	8d 45 ec             	lea    -0x14(%ebp),%eax
801068f0:	50                   	push   %eax
801068f1:	6a 00                	push   $0x0
801068f3:	e8 28 f2 ff ff       	call   80105b20 <argptr>
801068f8:	83 c4 10             	add    $0x10,%esp
801068fb:	85 c0                	test   %eax,%eax
801068fd:	79 0a                	jns    80106909 <sys_pipe+0x27>
    return -1;
801068ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106904:	e9 af 00 00 00       	jmp    801069b8 <sys_pipe+0xd6>
  if(pipealloc(&rf, &wf) < 0)
80106909:	83 ec 08             	sub    $0x8,%esp
8010690c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010690f:	50                   	push   %eax
80106910:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106913:	50                   	push   %eax
80106914:	e8 c8 d6 ff ff       	call   80103fe1 <pipealloc>
80106919:	83 c4 10             	add    $0x10,%esp
8010691c:	85 c0                	test   %eax,%eax
8010691e:	79 0a                	jns    8010692a <sys_pipe+0x48>
    return -1;
80106920:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106925:	e9 8e 00 00 00       	jmp    801069b8 <sys_pipe+0xd6>
  fd0 = -1;
8010692a:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106931:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106934:	83 ec 0c             	sub    $0xc,%esp
80106937:	50                   	push   %eax
80106938:	e8 6c f3 ff ff       	call   80105ca9 <fdalloc>
8010693d:	83 c4 10             	add    $0x10,%esp
80106940:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106943:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106947:	78 18                	js     80106961 <sys_pipe+0x7f>
80106949:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010694c:	83 ec 0c             	sub    $0xc,%esp
8010694f:	50                   	push   %eax
80106950:	e8 54 f3 ff ff       	call   80105ca9 <fdalloc>
80106955:	83 c4 10             	add    $0x10,%esp
80106958:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010695b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010695f:	79 3f                	jns    801069a0 <sys_pipe+0xbe>
    if(fd0 >= 0)
80106961:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106965:	78 14                	js     8010697b <sys_pipe+0x99>
      proc->ofile[fd0] = 0;
80106967:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010696d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106970:	83 c2 08             	add    $0x8,%edx
80106973:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010697a:	00 
    fileclose(rf);
8010697b:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010697e:	83 ec 0c             	sub    $0xc,%esp
80106981:	50                   	push   %eax
80106982:	e8 ca a6 ff ff       	call   80101051 <fileclose>
80106987:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
8010698a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010698d:	83 ec 0c             	sub    $0xc,%esp
80106990:	50                   	push   %eax
80106991:	e8 bb a6 ff ff       	call   80101051 <fileclose>
80106996:	83 c4 10             	add    $0x10,%esp
    return -1;
80106999:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010699e:	eb 18                	jmp    801069b8 <sys_pipe+0xd6>
  }
  fd[0] = fd0;
801069a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801069a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801069a6:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
801069a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801069ab:	8d 50 04             	lea    0x4(%eax),%edx
801069ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
801069b1:	89 02                	mov    %eax,(%edx)
  return 0;
801069b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
801069b8:	c9                   	leave  
801069b9:	c3                   	ret    

801069ba <outw>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outw(ushort port, ushort data)
{
801069ba:	55                   	push   %ebp
801069bb:	89 e5                	mov    %esp,%ebp
801069bd:	83 ec 08             	sub    $0x8,%esp
801069c0:	8b 55 08             	mov    0x8(%ebp),%edx
801069c3:	8b 45 0c             	mov    0xc(%ebp),%eax
801069c6:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801069ca:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801069ce:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
801069d2:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801069d6:	66 ef                	out    %ax,(%dx)
}
801069d8:	90                   	nop
801069d9:	c9                   	leave  
801069da:	c3                   	ret    

801069db <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801069db:	55                   	push   %ebp
801069dc:	89 e5                	mov    %esp,%ebp
801069de:	83 ec 08             	sub    $0x8,%esp
  return fork();
801069e1:	e8 1b dd ff ff       	call   80104701 <fork>
}
801069e6:	c9                   	leave  
801069e7:	c3                   	ret    

801069e8 <sys_exit>:

int
sys_exit(void)
{
801069e8:	55                   	push   %ebp
801069e9:	89 e5                	mov    %esp,%ebp
801069eb:	83 ec 08             	sub    $0x8,%esp
  exit();
801069ee:	e8 01 e1 ff ff       	call   80104af4 <exit>
  return 0;  // not reached
801069f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
801069f8:	c9                   	leave  
801069f9:	c3                   	ret    

801069fa <sys_wait>:

int
sys_wait(void)
{
801069fa:	55                   	push   %ebp
801069fb:	89 e5                	mov    %esp,%ebp
801069fd:	83 ec 08             	sub    $0x8,%esp
  return wait();
80106a00:	e8 ce e3 ff ff       	call   80104dd3 <wait>
}
80106a05:	c9                   	leave  
80106a06:	c3                   	ret    

80106a07 <sys_kill>:

int
sys_kill(void)
{
80106a07:	55                   	push   %ebp
80106a08:	89 e5                	mov    %esp,%ebp
80106a0a:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106a0d:	83 ec 08             	sub    $0x8,%esp
80106a10:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106a13:	50                   	push   %eax
80106a14:	6a 00                	push   $0x0
80106a16:	e8 dd f0 ff ff       	call   80105af8 <argint>
80106a1b:	83 c4 10             	add    $0x10,%esp
80106a1e:	85 c0                	test   %eax,%eax
80106a20:	79 07                	jns    80106a29 <sys_kill+0x22>
    return -1;
80106a22:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a27:	eb 0f                	jmp    80106a38 <sys_kill+0x31>
  return kill(pid);
80106a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a2c:	83 ec 0c             	sub    $0xc,%esp
80106a2f:	50                   	push   %eax
80106a30:	e8 50 e9 ff ff       	call   80105385 <kill>
80106a35:	83 c4 10             	add    $0x10,%esp
}
80106a38:	c9                   	leave  
80106a39:	c3                   	ret    

80106a3a <sys_getpid>:

int
sys_getpid(void)
{
80106a3a:	55                   	push   %ebp
80106a3b:	89 e5                	mov    %esp,%ebp
80106a3d:	83 ec 08             	sub    $0x8,%esp
	return getpid();
80106a40:	e8 c3 ea ff ff       	call   80105508 <getpid>
}
80106a45:	c9                   	leave  
80106a46:	c3                   	ret    

80106a47 <sys_sbrk>:

int
sys_sbrk(void)
{
80106a47:	55                   	push   %ebp
80106a48:	89 e5                	mov    %esp,%ebp
80106a4a:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106a4d:	83 ec 08             	sub    $0x8,%esp
80106a50:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106a53:	50                   	push   %eax
80106a54:	6a 00                	push   $0x0
80106a56:	e8 9d f0 ff ff       	call   80105af8 <argint>
80106a5b:	83 c4 10             	add    $0x10,%esp
80106a5e:	85 c0                	test   %eax,%eax
80106a60:	79 07                	jns    80106a69 <sys_sbrk+0x22>
    return -1;
80106a62:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a67:	eb 28                	jmp    80106a91 <sys_sbrk+0x4a>
  addr = proc->sz;
80106a69:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a6f:	8b 00                	mov    (%eax),%eax
80106a71:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80106a74:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106a77:	83 ec 0c             	sub    $0xc,%esp
80106a7a:	50                   	push   %eax
80106a7b:	e8 de db ff ff       	call   8010465e <growproc>
80106a80:	83 c4 10             	add    $0x10,%esp
80106a83:	85 c0                	test   %eax,%eax
80106a85:	79 07                	jns    80106a8e <sys_sbrk+0x47>
    return -1;
80106a87:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a8c:	eb 03                	jmp    80106a91 <sys_sbrk+0x4a>
  return addr;
80106a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106a91:	c9                   	leave  
80106a92:	c3                   	ret    

80106a93 <sys_sleep>:

int
sys_sleep(void)
{
80106a93:	55                   	push   %ebp
80106a94:	89 e5                	mov    %esp,%ebp
80106a96:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
80106a99:	83 ec 08             	sub    $0x8,%esp
80106a9c:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106a9f:	50                   	push   %eax
80106aa0:	6a 00                	push   $0x0
80106aa2:	e8 51 f0 ff ff       	call   80105af8 <argint>
80106aa7:	83 c4 10             	add    $0x10,%esp
80106aaa:	85 c0                	test   %eax,%eax
80106aac:	79 07                	jns    80106ab5 <sys_sleep+0x22>
    return -1;
80106aae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ab3:	eb 77                	jmp    80106b2c <sys_sleep+0x99>
  acquire(&tickslock);
80106ab5:	83 ec 0c             	sub    $0xc,%esp
80106ab8:	68 c0 5c 11 80       	push   $0x80115cc0
80106abd:	e8 ae ea ff ff       	call   80105570 <acquire>
80106ac2:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80106ac5:	a1 00 65 11 80       	mov    0x80116500,%eax
80106aca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80106acd:	eb 39                	jmp    80106b08 <sys_sleep+0x75>
    if(proc->killed){
80106acf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ad5:	8b 40 24             	mov    0x24(%eax),%eax
80106ad8:	85 c0                	test   %eax,%eax
80106ada:	74 17                	je     80106af3 <sys_sleep+0x60>
      release(&tickslock);
80106adc:	83 ec 0c             	sub    $0xc,%esp
80106adf:	68 c0 5c 11 80       	push   $0x80115cc0
80106ae4:	e8 ee ea ff ff       	call   801055d7 <release>
80106ae9:	83 c4 10             	add    $0x10,%esp
      return -1;
80106aec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106af1:	eb 39                	jmp    80106b2c <sys_sleep+0x99>
    }
    sleep(&ticks, &tickslock);
80106af3:	83 ec 08             	sub    $0x8,%esp
80106af6:	68 c0 5c 11 80       	push   $0x80115cc0
80106afb:	68 00 65 11 80       	push   $0x80116500
80106b00:	e8 5b e7 ff ff       	call   80105260 <sleep>
80106b05:	83 c4 10             	add    $0x10,%esp
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80106b08:	a1 00 65 11 80       	mov    0x80116500,%eax
80106b0d:	2b 45 f4             	sub    -0xc(%ebp),%eax
80106b10:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106b13:	39 d0                	cmp    %edx,%eax
80106b15:	72 b8                	jb     80106acf <sys_sleep+0x3c>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80106b17:	83 ec 0c             	sub    $0xc,%esp
80106b1a:	68 c0 5c 11 80       	push   $0x80115cc0
80106b1f:	e8 b3 ea ff ff       	call   801055d7 <release>
80106b24:	83 c4 10             	add    $0x10,%esp
  return 0;
80106b27:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106b2c:	c9                   	leave  
80106b2d:	c3                   	ret    

80106b2e <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106b2e:	55                   	push   %ebp
80106b2f:	89 e5                	mov    %esp,%ebp
80106b31:	83 ec 18             	sub    $0x18,%esp
  uint xticks;
  
  acquire(&tickslock);
80106b34:	83 ec 0c             	sub    $0xc,%esp
80106b37:	68 c0 5c 11 80       	push   $0x80115cc0
80106b3c:	e8 2f ea ff ff       	call   80105570 <acquire>
80106b41:	83 c4 10             	add    $0x10,%esp
  xticks = ticks;
80106b44:	a1 00 65 11 80       	mov    0x80116500,%eax
80106b49:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
80106b4c:	83 ec 0c             	sub    $0xc,%esp
80106b4f:	68 c0 5c 11 80       	push   $0x80115cc0
80106b54:	e8 7e ea ff ff       	call   801055d7 <release>
80106b59:	83 c4 10             	add    $0x10,%esp
  return xticks;
80106b5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106b5f:	c9                   	leave  
80106b60:	c3                   	ret    

80106b61 <sys_halt>:

int
sys_halt(void)
{
80106b61:	55                   	push   %ebp
80106b62:	89 e5                	mov    %esp,%ebp
	outw(0xB004, 0x0|0x2000);
80106b64:	68 00 20 00 00       	push   $0x2000
80106b69:	68 04 b0 00 00       	push   $0xb004
80106b6e:	e8 47 fe ff ff       	call   801069ba <outw>
80106b73:	83 c4 08             	add    $0x8,%esp
	return 0;
80106b76:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106b7b:	c9                   	leave  
80106b7c:	c3                   	ret    

80106b7d <sys_thread_create>:

int sys_thread_create(void){
80106b7d:	55                   	push   %ebp
80106b7e:	89 e5                	mov    %esp,%ebp
80106b80:	53                   	push   %ebx
80106b81:	83 ec 14             	sub    $0x14,%esp
	int function, priority, arg, stack;

	if(argint(0, &function)<0 || argint(1, &priority)<0 || argint(2, &arg)<0 || argint(3, &stack)<0)
80106b84:	83 ec 08             	sub    $0x8,%esp
80106b87:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106b8a:	50                   	push   %eax
80106b8b:	6a 00                	push   $0x0
80106b8d:	e8 66 ef ff ff       	call   80105af8 <argint>
80106b92:	83 c4 10             	add    $0x10,%esp
80106b95:	85 c0                	test   %eax,%eax
80106b97:	78 3f                	js     80106bd8 <sys_thread_create+0x5b>
80106b99:	83 ec 08             	sub    $0x8,%esp
80106b9c:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106b9f:	50                   	push   %eax
80106ba0:	6a 01                	push   $0x1
80106ba2:	e8 51 ef ff ff       	call   80105af8 <argint>
80106ba7:	83 c4 10             	add    $0x10,%esp
80106baa:	85 c0                	test   %eax,%eax
80106bac:	78 2a                	js     80106bd8 <sys_thread_create+0x5b>
80106bae:	83 ec 08             	sub    $0x8,%esp
80106bb1:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106bb4:	50                   	push   %eax
80106bb5:	6a 02                	push   $0x2
80106bb7:	e8 3c ef ff ff       	call   80105af8 <argint>
80106bbc:	83 c4 10             	add    $0x10,%esp
80106bbf:	85 c0                	test   %eax,%eax
80106bc1:	78 15                	js     80106bd8 <sys_thread_create+0x5b>
80106bc3:	83 ec 08             	sub    $0x8,%esp
80106bc6:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106bc9:	50                   	push   %eax
80106bca:	6a 03                	push   $0x3
80106bcc:	e8 27 ef ff ff       	call   80105af8 <argint>
80106bd1:	83 c4 10             	add    $0x10,%esp
80106bd4:	85 c0                	test   %eax,%eax
80106bd6:	79 07                	jns    80106bdf <sys_thread_create+0x62>
		return -1;
80106bd8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106bdd:	eb 1c                	jmp    80106bfb <sys_thread_create+0x7e>

	return thread_create((void *(*)(void *))function, priority, (void *)arg, (void *)stack);
80106bdf:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106be2:	89 c3                	mov    %eax,%ebx
80106be4:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106be7:	89 c1                	mov    %eax,%ecx
80106be9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106bec:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106bef:	53                   	push   %ebx
80106bf0:	51                   	push   %ecx
80106bf1:	50                   	push   %eax
80106bf2:	52                   	push   %edx
80106bf3:	e8 a1 20 00 00       	call   80108c99 <thread_create>
80106bf8:	83 c4 10             	add    $0x10,%esp
}
80106bfb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106bfe:	c9                   	leave  
80106bff:	c3                   	ret    

80106c00 <sys_thread_exit>:

int sys_thread_exit(void){
80106c00:	55                   	push   %ebp
80106c01:	89 e5                	mov    %esp,%ebp
80106c03:	83 ec 18             	sub    $0x18,%esp
	int retval;

	if(argint(0, &retval)<0)
80106c06:	83 ec 08             	sub    $0x8,%esp
80106c09:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106c0c:	50                   	push   %eax
80106c0d:	6a 00                	push   $0x0
80106c0f:	e8 e4 ee ff ff       	call   80105af8 <argint>
80106c14:	83 c4 10             	add    $0x10,%esp
80106c17:	85 c0                	test   %eax,%eax
80106c19:	79 07                	jns    80106c22 <sys_thread_exit+0x22>
		return -1;
80106c1b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c20:	eb 14                	jmp    80106c36 <sys_thread_exit+0x36>

	thread_exit((void *)retval);
80106c22:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c25:	83 ec 0c             	sub    $0xc,%esp
80106c28:	50                   	push   %eax
80106c29:	e8 98 20 00 00       	call   80108cc6 <thread_exit>
80106c2e:	83 c4 10             	add    $0x10,%esp
	return 0;
80106c31:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106c36:	c9                   	leave  
80106c37:	c3                   	ret    

80106c38 <sys_thread_join>:

int sys_thread_join(void){
80106c38:	55                   	push   %ebp
80106c39:	89 e5                	mov    %esp,%ebp
80106c3b:	83 ec 18             	sub    $0x18,%esp
	int tid, retval;

	if(argint(0, &tid)<0 || argint(1, &retval)<0)
80106c3e:	83 ec 08             	sub    $0x8,%esp
80106c41:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106c44:	50                   	push   %eax
80106c45:	6a 00                	push   $0x0
80106c47:	e8 ac ee ff ff       	call   80105af8 <argint>
80106c4c:	83 c4 10             	add    $0x10,%esp
80106c4f:	85 c0                	test   %eax,%eax
80106c51:	78 15                	js     80106c68 <sys_thread_join+0x30>
80106c53:	83 ec 08             	sub    $0x8,%esp
80106c56:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106c59:	50                   	push   %eax
80106c5a:	6a 01                	push   $0x1
80106c5c:	e8 97 ee ff ff       	call   80105af8 <argint>
80106c61:	83 c4 10             	add    $0x10,%esp
80106c64:	85 c0                	test   %eax,%eax
80106c66:	79 07                	jns    80106c6f <sys_thread_join+0x37>
		return -1;
80106c68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c6d:	eb 15                	jmp    80106c84 <sys_thread_join+0x4c>

	return thread_join(tid, (void **)retval);
80106c6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106c72:	89 c2                	mov    %eax,%edx
80106c74:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c77:	83 ec 08             	sub    $0x8,%esp
80106c7a:	52                   	push   %edx
80106c7b:	50                   	push   %eax
80106c7c:	e8 5c 20 00 00       	call   80108cdd <thread_join>
80106c81:	83 c4 10             	add    $0x10,%esp
}
80106c84:	c9                   	leave  
80106c85:	c3                   	ret    

80106c86 <sys_gettid>:

int sys_gettid(void){
80106c86:	55                   	push   %ebp
80106c87:	89 e5                	mov    %esp,%ebp
80106c89:	83 ec 08             	sub    $0x8,%esp
	return gettid();
80106c8c:	e8 92 20 00 00       	call   80108d23 <gettid>
}
80106c91:	c9                   	leave  
80106c92:	c3                   	ret    

80106c93 <sys_clone>:

int sys_clone(void){
80106c93:	55                   	push   %ebp
80106c94:	89 e5                	mov    %esp,%ebp
80106c96:	83 ec 18             	sub    $0x18,%esp
    int function,arg, stack;
       
	if(argint(0, &function)<0 || argint(1, &arg)<0 || argint(2, &stack)<0)
80106c99:	83 ec 08             	sub    $0x8,%esp
80106c9c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106c9f:	50                   	push   %eax
80106ca0:	6a 00                	push   $0x0
80106ca2:	e8 51 ee ff ff       	call   80105af8 <argint>
80106ca7:	83 c4 10             	add    $0x10,%esp
80106caa:	85 c0                	test   %eax,%eax
80106cac:	78 2a                	js     80106cd8 <sys_clone+0x45>
80106cae:	83 ec 08             	sub    $0x8,%esp
80106cb1:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106cb4:	50                   	push   %eax
80106cb5:	6a 01                	push   $0x1
80106cb7:	e8 3c ee ff ff       	call   80105af8 <argint>
80106cbc:	83 c4 10             	add    $0x10,%esp
80106cbf:	85 c0                	test   %eax,%eax
80106cc1:	78 15                	js     80106cd8 <sys_clone+0x45>
80106cc3:	83 ec 08             	sub    $0x8,%esp
80106cc6:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106cc9:	50                   	push   %eax
80106cca:	6a 02                	push   $0x2
80106ccc:	e8 27 ee ff ff       	call   80105af8 <argint>
80106cd1:	83 c4 10             	add    $0x10,%esp
80106cd4:	85 c0                	test   %eax,%eax
80106cd6:	79 07                	jns    80106cdf <sys_clone+0x4c>
        return -1;
80106cd8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106cdd:	eb 1b                	jmp    80106cfa <sys_clone+0x67>
//    return 0;   
    return clone((void *(*)(void*))function,(void*)arg,(void*)stack);
80106cdf:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106ce2:	89 c1                	mov    %eax,%ecx
80106ce4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106ce7:	89 c2                	mov    %eax,%edx
80106ce9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106cec:	83 ec 04             	sub    $0x4,%esp
80106cef:	51                   	push   %ecx
80106cf0:	52                   	push   %edx
80106cf1:	50                   	push   %eax
80106cf2:	e8 b0 db ff ff       	call   801048a7 <clone>
80106cf7:	83 c4 10             	add    $0x10,%esp

}
80106cfa:	c9                   	leave  
80106cfb:	c3                   	ret    

80106cfc <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106cfc:	55                   	push   %ebp
80106cfd:	89 e5                	mov    %esp,%ebp
80106cff:	83 ec 08             	sub    $0x8,%esp
80106d02:	8b 55 08             	mov    0x8(%ebp),%edx
80106d05:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d08:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106d0c:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106d0f:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106d13:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106d17:	ee                   	out    %al,(%dx)
}
80106d18:	90                   	nop
80106d19:	c9                   	leave  
80106d1a:	c3                   	ret    

80106d1b <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80106d1b:	55                   	push   %ebp
80106d1c:	89 e5                	mov    %esp,%ebp
80106d1e:	83 ec 08             	sub    $0x8,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
80106d21:	6a 34                	push   $0x34
80106d23:	6a 43                	push   $0x43
80106d25:	e8 d2 ff ff ff       	call   80106cfc <outb>
80106d2a:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
80106d2d:	68 9c 00 00 00       	push   $0x9c
80106d32:	6a 40                	push   $0x40
80106d34:	e8 c3 ff ff ff       	call   80106cfc <outb>
80106d39:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
80106d3c:	6a 2e                	push   $0x2e
80106d3e:	6a 40                	push   $0x40
80106d40:	e8 b7 ff ff ff       	call   80106cfc <outb>
80106d45:	83 c4 08             	add    $0x8,%esp
  picenable(IRQ_TIMER);
80106d48:	83 ec 0c             	sub    $0xc,%esp
80106d4b:	6a 00                	push   $0x0
80106d4d:	e8 79 d1 ff ff       	call   80103ecb <picenable>
80106d52:	83 c4 10             	add    $0x10,%esp
}
80106d55:	90                   	nop
80106d56:	c9                   	leave  
80106d57:	c3                   	ret    

80106d58 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106d58:	1e                   	push   %ds
  pushl %es
80106d59:	06                   	push   %es
  pushl %fs
80106d5a:	0f a0                	push   %fs
  pushl %gs
80106d5c:	0f a8                	push   %gs
  pushal
80106d5e:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80106d5f:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106d63:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106d65:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
80106d67:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80106d6b:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80106d6d:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80106d6f:	54                   	push   %esp
  call trap
80106d70:	e8 d7 01 00 00       	call   80106f4c <trap>
  addl $4, %esp
80106d75:	83 c4 04             	add    $0x4,%esp

80106d78 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106d78:	61                   	popa   
  popl %gs
80106d79:	0f a9                	pop    %gs
  popl %fs
80106d7b:	0f a1                	pop    %fs
  popl %es
80106d7d:	07                   	pop    %es
  popl %ds
80106d7e:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106d7f:	83 c4 08             	add    $0x8,%esp
  iret
80106d82:	cf                   	iret   

80106d83 <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
80106d83:	55                   	push   %ebp
80106d84:	89 e5                	mov    %esp,%ebp
80106d86:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80106d89:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d8c:	83 e8 01             	sub    $0x1,%eax
80106d8f:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106d93:	8b 45 08             	mov    0x8(%ebp),%eax
80106d96:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106d9a:	8b 45 08             	mov    0x8(%ebp),%eax
80106d9d:	c1 e8 10             	shr    $0x10,%eax
80106da0:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80106da4:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106da7:	0f 01 18             	lidtl  (%eax)
}
80106daa:	90                   	nop
80106dab:	c9                   	leave  
80106dac:	c3                   	ret    

80106dad <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
80106dad:	55                   	push   %ebp
80106dae:	89 e5                	mov    %esp,%ebp
80106db0:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106db3:	0f 20 d0             	mov    %cr2,%eax
80106db6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80106db9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106dbc:	c9                   	leave  
80106dbd:	c3                   	ret    

80106dbe <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106dbe:	55                   	push   %ebp
80106dbf:	89 e5                	mov    %esp,%ebp
80106dc1:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
80106dc4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106dcb:	e9 c3 00 00 00       	jmp    80106e93 <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106dd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106dd3:	8b 04 85 b0 c0 10 80 	mov    -0x7fef3f50(,%eax,4),%eax
80106dda:	89 c2                	mov    %eax,%edx
80106ddc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ddf:	66 89 14 c5 00 5d 11 	mov    %dx,-0x7feea300(,%eax,8)
80106de6:	80 
80106de7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106dea:	66 c7 04 c5 02 5d 11 	movw   $0x8,-0x7feea2fe(,%eax,8)
80106df1:	80 08 00 
80106df4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106df7:	0f b6 14 c5 04 5d 11 	movzbl -0x7feea2fc(,%eax,8),%edx
80106dfe:	80 
80106dff:	83 e2 e0             	and    $0xffffffe0,%edx
80106e02:	88 14 c5 04 5d 11 80 	mov    %dl,-0x7feea2fc(,%eax,8)
80106e09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e0c:	0f b6 14 c5 04 5d 11 	movzbl -0x7feea2fc(,%eax,8),%edx
80106e13:	80 
80106e14:	83 e2 1f             	and    $0x1f,%edx
80106e17:	88 14 c5 04 5d 11 80 	mov    %dl,-0x7feea2fc(,%eax,8)
80106e1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e21:	0f b6 14 c5 05 5d 11 	movzbl -0x7feea2fb(,%eax,8),%edx
80106e28:	80 
80106e29:	83 e2 f0             	and    $0xfffffff0,%edx
80106e2c:	83 ca 0e             	or     $0xe,%edx
80106e2f:	88 14 c5 05 5d 11 80 	mov    %dl,-0x7feea2fb(,%eax,8)
80106e36:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e39:	0f b6 14 c5 05 5d 11 	movzbl -0x7feea2fb(,%eax,8),%edx
80106e40:	80 
80106e41:	83 e2 ef             	and    $0xffffffef,%edx
80106e44:	88 14 c5 05 5d 11 80 	mov    %dl,-0x7feea2fb(,%eax,8)
80106e4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e4e:	0f b6 14 c5 05 5d 11 	movzbl -0x7feea2fb(,%eax,8),%edx
80106e55:	80 
80106e56:	83 e2 9f             	and    $0xffffff9f,%edx
80106e59:	88 14 c5 05 5d 11 80 	mov    %dl,-0x7feea2fb(,%eax,8)
80106e60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e63:	0f b6 14 c5 05 5d 11 	movzbl -0x7feea2fb(,%eax,8),%edx
80106e6a:	80 
80106e6b:	83 ca 80             	or     $0xffffff80,%edx
80106e6e:	88 14 c5 05 5d 11 80 	mov    %dl,-0x7feea2fb(,%eax,8)
80106e75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e78:	8b 04 85 b0 c0 10 80 	mov    -0x7fef3f50(,%eax,4),%eax
80106e7f:	c1 e8 10             	shr    $0x10,%eax
80106e82:	89 c2                	mov    %eax,%edx
80106e84:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e87:	66 89 14 c5 06 5d 11 	mov    %dx,-0x7feea2fa(,%eax,8)
80106e8e:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80106e8f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106e93:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106e9a:	0f 8e 30 ff ff ff    	jle    80106dd0 <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106ea0:	a1 b0 c1 10 80       	mov    0x8010c1b0,%eax
80106ea5:	66 a3 00 5f 11 80    	mov    %ax,0x80115f00
80106eab:	66 c7 05 02 5f 11 80 	movw   $0x8,0x80115f02
80106eb2:	08 00 
80106eb4:	0f b6 05 04 5f 11 80 	movzbl 0x80115f04,%eax
80106ebb:	83 e0 e0             	and    $0xffffffe0,%eax
80106ebe:	a2 04 5f 11 80       	mov    %al,0x80115f04
80106ec3:	0f b6 05 04 5f 11 80 	movzbl 0x80115f04,%eax
80106eca:	83 e0 1f             	and    $0x1f,%eax
80106ecd:	a2 04 5f 11 80       	mov    %al,0x80115f04
80106ed2:	0f b6 05 05 5f 11 80 	movzbl 0x80115f05,%eax
80106ed9:	83 c8 0f             	or     $0xf,%eax
80106edc:	a2 05 5f 11 80       	mov    %al,0x80115f05
80106ee1:	0f b6 05 05 5f 11 80 	movzbl 0x80115f05,%eax
80106ee8:	83 e0 ef             	and    $0xffffffef,%eax
80106eeb:	a2 05 5f 11 80       	mov    %al,0x80115f05
80106ef0:	0f b6 05 05 5f 11 80 	movzbl 0x80115f05,%eax
80106ef7:	83 c8 60             	or     $0x60,%eax
80106efa:	a2 05 5f 11 80       	mov    %al,0x80115f05
80106eff:	0f b6 05 05 5f 11 80 	movzbl 0x80115f05,%eax
80106f06:	83 c8 80             	or     $0xffffff80,%eax
80106f09:	a2 05 5f 11 80       	mov    %al,0x80115f05
80106f0e:	a1 b0 c1 10 80       	mov    0x8010c1b0,%eax
80106f13:	c1 e8 10             	shr    $0x10,%eax
80106f16:	66 a3 06 5f 11 80    	mov    %ax,0x80115f06
  
  initlock(&tickslock, "time");
80106f1c:	83 ec 08             	sub    $0x8,%esp
80106f1f:	68 9c 91 10 80       	push   $0x8010919c
80106f24:	68 c0 5c 11 80       	push   $0x80115cc0
80106f29:	e8 20 e6 ff ff       	call   8010554e <initlock>
80106f2e:	83 c4 10             	add    $0x10,%esp
}
80106f31:	90                   	nop
80106f32:	c9                   	leave  
80106f33:	c3                   	ret    

80106f34 <idtinit>:

void
idtinit(void)
{
80106f34:	55                   	push   %ebp
80106f35:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
80106f37:	68 00 08 00 00       	push   $0x800
80106f3c:	68 00 5d 11 80       	push   $0x80115d00
80106f41:	e8 3d fe ff ff       	call   80106d83 <lidt>
80106f46:	83 c4 08             	add    $0x8,%esp
}
80106f49:	90                   	nop
80106f4a:	c9                   	leave  
80106f4b:	c3                   	ret    

80106f4c <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106f4c:	55                   	push   %ebp
80106f4d:	89 e5                	mov    %esp,%ebp
80106f4f:	57                   	push   %edi
80106f50:	56                   	push   %esi
80106f51:	53                   	push   %ebx
80106f52:	83 ec 1c             	sub    $0x1c,%esp
  if(tf->trapno == T_SYSCALL){
80106f55:	8b 45 08             	mov    0x8(%ebp),%eax
80106f58:	8b 40 30             	mov    0x30(%eax),%eax
80106f5b:	83 f8 40             	cmp    $0x40,%eax
80106f5e:	75 3e                	jne    80106f9e <trap+0x52>
    if(proc->killed)
80106f60:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f66:	8b 40 24             	mov    0x24(%eax),%eax
80106f69:	85 c0                	test   %eax,%eax
80106f6b:	74 05                	je     80106f72 <trap+0x26>
      exit();
80106f6d:	e8 82 db ff ff       	call   80104af4 <exit>
    proc->tf = tf;
80106f72:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f78:	8b 55 08             	mov    0x8(%ebp),%edx
80106f7b:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80106f7e:	e8 2b ec ff ff       	call   80105bae <syscall>
    if(proc->killed)
80106f83:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f89:	8b 40 24             	mov    0x24(%eax),%eax
80106f8c:	85 c0                	test   %eax,%eax
80106f8e:	0f 84 1b 02 00 00    	je     801071af <trap+0x263>
      exit();
80106f94:	e8 5b db ff ff       	call   80104af4 <exit>
    return;
80106f99:	e9 11 02 00 00       	jmp    801071af <trap+0x263>
  }

  switch(tf->trapno){
80106f9e:	8b 45 08             	mov    0x8(%ebp),%eax
80106fa1:	8b 40 30             	mov    0x30(%eax),%eax
80106fa4:	83 e8 20             	sub    $0x20,%eax
80106fa7:	83 f8 1f             	cmp    $0x1f,%eax
80106faa:	0f 87 c0 00 00 00    	ja     80107070 <trap+0x124>
80106fb0:	8b 04 85 44 92 10 80 	mov    -0x7fef6dbc(,%eax,4),%eax
80106fb7:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
80106fb9:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106fbf:	0f b6 00             	movzbl (%eax),%eax
80106fc2:	84 c0                	test   %al,%al
80106fc4:	75 3d                	jne    80107003 <trap+0xb7>
      acquire(&tickslock);
80106fc6:	83 ec 0c             	sub    $0xc,%esp
80106fc9:	68 c0 5c 11 80       	push   $0x80115cc0
80106fce:	e8 9d e5 ff ff       	call   80105570 <acquire>
80106fd3:	83 c4 10             	add    $0x10,%esp
      ticks++;
80106fd6:	a1 00 65 11 80       	mov    0x80116500,%eax
80106fdb:	83 c0 01             	add    $0x1,%eax
80106fde:	a3 00 65 11 80       	mov    %eax,0x80116500
      wakeup(&ticks);
80106fe3:	83 ec 0c             	sub    $0xc,%esp
80106fe6:	68 00 65 11 80       	push   $0x80116500
80106feb:	e8 5e e3 ff ff       	call   8010534e <wakeup>
80106ff0:	83 c4 10             	add    $0x10,%esp
      release(&tickslock);
80106ff3:	83 ec 0c             	sub    $0xc,%esp
80106ff6:	68 c0 5c 11 80       	push   $0x80115cc0
80106ffb:	e8 d7 e5 ff ff       	call   801055d7 <release>
80107000:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
80107003:	e8 f7 bf ff ff       	call   80102fff <lapiceoi>
    break;
80107008:	e9 1c 01 00 00       	jmp    80107129 <trap+0x1dd>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
8010700d:	e8 dc b7 ff ff       	call   801027ee <ideintr>
    lapiceoi();
80107012:	e8 e8 bf ff ff       	call   80102fff <lapiceoi>
    break;
80107017:	e9 0d 01 00 00       	jmp    80107129 <trap+0x1dd>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
8010701c:	e8 e0 bd ff ff       	call   80102e01 <kbdintr>
    lapiceoi();
80107021:	e8 d9 bf ff ff       	call   80102fff <lapiceoi>
    break;
80107026:	e9 fe 00 00 00       	jmp    80107129 <trap+0x1dd>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
8010702b:	e8 34 03 00 00       	call   80107364 <uartintr>
    lapiceoi();
80107030:	e8 ca bf ff ff       	call   80102fff <lapiceoi>
    break;
80107035:	e9 ef 00 00 00       	jmp    80107129 <trap+0x1dd>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010703a:	8b 45 08             	mov    0x8(%ebp),%eax
8010703d:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
80107040:	8b 45 08             	mov    0x8(%ebp),%eax
80107043:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107047:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
8010704a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107050:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107053:	0f b6 c0             	movzbl %al,%eax
80107056:	51                   	push   %ecx
80107057:	52                   	push   %edx
80107058:	50                   	push   %eax
80107059:	68 a4 91 10 80       	push   $0x801091a4
8010705e:	e8 63 93 ff ff       	call   801003c6 <cprintf>
80107063:	83 c4 10             	add    $0x10,%esp
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
80107066:	e8 94 bf ff ff       	call   80102fff <lapiceoi>
    break;
8010706b:	e9 b9 00 00 00       	jmp    80107129 <trap+0x1dd>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
80107070:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107076:	85 c0                	test   %eax,%eax
80107078:	74 11                	je     8010708b <trap+0x13f>
8010707a:	8b 45 08             	mov    0x8(%ebp),%eax
8010707d:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80107081:	0f b7 c0             	movzwl %ax,%eax
80107084:	83 e0 03             	and    $0x3,%eax
80107087:	85 c0                	test   %eax,%eax
80107089:	75 40                	jne    801070cb <trap+0x17f>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010708b:	e8 1d fd ff ff       	call   80106dad <rcr2>
80107090:	89 c3                	mov    %eax,%ebx
80107092:	8b 45 08             	mov    0x8(%ebp),%eax
80107095:	8b 48 38             	mov    0x38(%eax),%ecx
              tf->trapno, cpu->id, tf->eip, rcr2());
80107098:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010709e:	0f b6 00             	movzbl (%eax),%eax
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801070a1:	0f b6 d0             	movzbl %al,%edx
801070a4:	8b 45 08             	mov    0x8(%ebp),%eax
801070a7:	8b 40 30             	mov    0x30(%eax),%eax
801070aa:	83 ec 0c             	sub    $0xc,%esp
801070ad:	53                   	push   %ebx
801070ae:	51                   	push   %ecx
801070af:	52                   	push   %edx
801070b0:	50                   	push   %eax
801070b1:	68 c8 91 10 80       	push   $0x801091c8
801070b6:	e8 0b 93 ff ff       	call   801003c6 <cprintf>
801070bb:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
801070be:	83 ec 0c             	sub    $0xc,%esp
801070c1:	68 fa 91 10 80       	push   $0x801091fa
801070c6:	e8 9b 94 ff ff       	call   80100566 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801070cb:	e8 dd fc ff ff       	call   80106dad <rcr2>
801070d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801070d3:	8b 45 08             	mov    0x8(%ebp),%eax
801070d6:	8b 70 38             	mov    0x38(%eax),%esi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801070d9:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801070df:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801070e2:	0f b6 d8             	movzbl %al,%ebx
801070e5:	8b 45 08             	mov    0x8(%ebp),%eax
801070e8:	8b 48 34             	mov    0x34(%eax),%ecx
801070eb:	8b 45 08             	mov    0x8(%ebp),%eax
801070ee:	8b 50 30             	mov    0x30(%eax),%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801070f1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801070f7:	8d 78 6c             	lea    0x6c(%eax),%edi
801070fa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107100:	8b 40 10             	mov    0x10(%eax),%eax
80107103:	ff 75 e4             	pushl  -0x1c(%ebp)
80107106:	56                   	push   %esi
80107107:	53                   	push   %ebx
80107108:	51                   	push   %ecx
80107109:	52                   	push   %edx
8010710a:	57                   	push   %edi
8010710b:	50                   	push   %eax
8010710c:	68 00 92 10 80       	push   $0x80109200
80107111:	e8 b0 92 ff ff       	call   801003c6 <cprintf>
80107116:	83 c4 20             	add    $0x20,%esp
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
80107119:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010711f:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80107126:	eb 01                	jmp    80107129 <trap+0x1dd>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
80107128:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80107129:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010712f:	85 c0                	test   %eax,%eax
80107131:	74 24                	je     80107157 <trap+0x20b>
80107133:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107139:	8b 40 24             	mov    0x24(%eax),%eax
8010713c:	85 c0                	test   %eax,%eax
8010713e:	74 17                	je     80107157 <trap+0x20b>
80107140:	8b 45 08             	mov    0x8(%ebp),%eax
80107143:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80107147:	0f b7 c0             	movzwl %ax,%eax
8010714a:	83 e0 03             	and    $0x3,%eax
8010714d:	83 f8 03             	cmp    $0x3,%eax
80107150:	75 05                	jne    80107157 <trap+0x20b>
    exit();
80107152:	e8 9d d9 ff ff       	call   80104af4 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80107157:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010715d:	85 c0                	test   %eax,%eax
8010715f:	74 1e                	je     8010717f <trap+0x233>
80107161:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107167:	8b 40 0c             	mov    0xc(%eax),%eax
8010716a:	83 f8 04             	cmp    $0x4,%eax
8010716d:	75 10                	jne    8010717f <trap+0x233>
8010716f:	8b 45 08             	mov    0x8(%ebp),%eax
80107172:	8b 40 30             	mov    0x30(%eax),%eax
80107175:	83 f8 20             	cmp    $0x20,%eax
80107178:	75 05                	jne    8010717f <trap+0x233>
    yield();
8010717a:	e8 60 e0 ff ff       	call   801051df <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
8010717f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107185:	85 c0                	test   %eax,%eax
80107187:	74 27                	je     801071b0 <trap+0x264>
80107189:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010718f:	8b 40 24             	mov    0x24(%eax),%eax
80107192:	85 c0                	test   %eax,%eax
80107194:	74 1a                	je     801071b0 <trap+0x264>
80107196:	8b 45 08             	mov    0x8(%ebp),%eax
80107199:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010719d:	0f b7 c0             	movzwl %ax,%eax
801071a0:	83 e0 03             	and    $0x3,%eax
801071a3:	83 f8 03             	cmp    $0x3,%eax
801071a6:	75 08                	jne    801071b0 <trap+0x264>
    exit();
801071a8:	e8 47 d9 ff ff       	call   80104af4 <exit>
801071ad:	eb 01                	jmp    801071b0 <trap+0x264>
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
    return;
801071af:	90                   	nop
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
801071b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071b3:	5b                   	pop    %ebx
801071b4:	5e                   	pop    %esi
801071b5:	5f                   	pop    %edi
801071b6:	5d                   	pop    %ebp
801071b7:	c3                   	ret    

801071b8 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801071b8:	55                   	push   %ebp
801071b9:	89 e5                	mov    %esp,%ebp
801071bb:	83 ec 14             	sub    $0x14,%esp
801071be:	8b 45 08             	mov    0x8(%ebp),%eax
801071c1:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801071c5:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801071c9:	89 c2                	mov    %eax,%edx
801071cb:	ec                   	in     (%dx),%al
801071cc:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801071cf:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801071d3:	c9                   	leave  
801071d4:	c3                   	ret    

801071d5 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801071d5:	55                   	push   %ebp
801071d6:	89 e5                	mov    %esp,%ebp
801071d8:	83 ec 08             	sub    $0x8,%esp
801071db:	8b 55 08             	mov    0x8(%ebp),%edx
801071de:	8b 45 0c             	mov    0xc(%ebp),%eax
801071e1:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801071e5:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801071e8:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801071ec:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801071f0:	ee                   	out    %al,(%dx)
}
801071f1:	90                   	nop
801071f2:	c9                   	leave  
801071f3:	c3                   	ret    

801071f4 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
801071f4:	55                   	push   %ebp
801071f5:	89 e5                	mov    %esp,%ebp
801071f7:	83 ec 08             	sub    $0x8,%esp
  // Turn off the FIFO
  outb(COM1+2, 0);
801071fa:	6a 00                	push   $0x0
801071fc:	68 fa 03 00 00       	push   $0x3fa
80107201:	e8 cf ff ff ff       	call   801071d5 <outb>
80107206:	83 c4 08             	add    $0x8,%esp
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80107209:	68 80 00 00 00       	push   $0x80
8010720e:	68 fb 03 00 00       	push   $0x3fb
80107213:	e8 bd ff ff ff       	call   801071d5 <outb>
80107218:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
8010721b:	6a 0c                	push   $0xc
8010721d:	68 f8 03 00 00       	push   $0x3f8
80107222:	e8 ae ff ff ff       	call   801071d5 <outb>
80107227:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
8010722a:	6a 00                	push   $0x0
8010722c:	68 f9 03 00 00       	push   $0x3f9
80107231:	e8 9f ff ff ff       	call   801071d5 <outb>
80107236:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80107239:	6a 03                	push   $0x3
8010723b:	68 fb 03 00 00       	push   $0x3fb
80107240:	e8 90 ff ff ff       	call   801071d5 <outb>
80107245:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
80107248:	6a 00                	push   $0x0
8010724a:	68 fc 03 00 00       	push   $0x3fc
8010724f:	e8 81 ff ff ff       	call   801071d5 <outb>
80107254:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80107257:	6a 01                	push   $0x1
80107259:	68 f9 03 00 00       	push   $0x3f9
8010725e:	e8 72 ff ff ff       	call   801071d5 <outb>
80107263:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80107266:	68 fd 03 00 00       	push   $0x3fd
8010726b:	e8 48 ff ff ff       	call   801071b8 <inb>
80107270:	83 c4 04             	add    $0x4,%esp
80107273:	3c ff                	cmp    $0xff,%al
80107275:	74 42                	je     801072b9 <uartinit+0xc5>
    return;
  uart = 1;
80107277:	c7 05 70 c6 10 80 01 	movl   $0x1,0x8010c670
8010727e:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80107281:	68 fa 03 00 00       	push   $0x3fa
80107286:	e8 2d ff ff ff       	call   801071b8 <inb>
8010728b:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
8010728e:	68 f8 03 00 00       	push   $0x3f8
80107293:	e8 20 ff ff ff       	call   801071b8 <inb>
80107298:	83 c4 04             	add    $0x4,%esp
  picenable(IRQ_COM1);
8010729b:	83 ec 0c             	sub    $0xc,%esp
8010729e:	6a 04                	push   $0x4
801072a0:	e8 26 cc ff ff       	call   80103ecb <picenable>
801072a5:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_COM1, 0);
801072a8:	83 ec 08             	sub    $0x8,%esp
801072ab:	6a 00                	push   $0x0
801072ad:	6a 04                	push   $0x4
801072af:	e8 dc b7 ff ff       	call   80102a90 <ioapicenable>
801072b4:	83 c4 10             	add    $0x10,%esp
801072b7:	eb 01                	jmp    801072ba <uartinit+0xc6>
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
    return;
801072b9:	90                   	nop
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
}
801072ba:	c9                   	leave  
801072bb:	c3                   	ret    

801072bc <uartputc>:

void
uartputc(int c)
{
801072bc:	55                   	push   %ebp
801072bd:	89 e5                	mov    %esp,%ebp
801072bf:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
801072c2:	a1 70 c6 10 80       	mov    0x8010c670,%eax
801072c7:	85 c0                	test   %eax,%eax
801072c9:	74 53                	je     8010731e <uartputc+0x62>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801072cb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801072d2:	eb 11                	jmp    801072e5 <uartputc+0x29>
    microdelay(10);
801072d4:	83 ec 0c             	sub    $0xc,%esp
801072d7:	6a 0a                	push   $0xa
801072d9:	e8 3c bd ff ff       	call   8010301a <microdelay>
801072de:	83 c4 10             	add    $0x10,%esp
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801072e1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801072e5:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
801072e9:	7f 1a                	jg     80107305 <uartputc+0x49>
801072eb:	83 ec 0c             	sub    $0xc,%esp
801072ee:	68 fd 03 00 00       	push   $0x3fd
801072f3:	e8 c0 fe ff ff       	call   801071b8 <inb>
801072f8:	83 c4 10             	add    $0x10,%esp
801072fb:	0f b6 c0             	movzbl %al,%eax
801072fe:	83 e0 20             	and    $0x20,%eax
80107301:	85 c0                	test   %eax,%eax
80107303:	74 cf                	je     801072d4 <uartputc+0x18>
    microdelay(10);
  outb(COM1+0, c);
80107305:	8b 45 08             	mov    0x8(%ebp),%eax
80107308:	0f b6 c0             	movzbl %al,%eax
8010730b:	83 ec 08             	sub    $0x8,%esp
8010730e:	50                   	push   %eax
8010730f:	68 f8 03 00 00       	push   $0x3f8
80107314:	e8 bc fe ff ff       	call   801071d5 <outb>
80107319:	83 c4 10             	add    $0x10,%esp
8010731c:	eb 01                	jmp    8010731f <uartputc+0x63>
uartputc(int c)
{
  int i;

  if(!uart)
    return;
8010731e:	90                   	nop
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
8010731f:	c9                   	leave  
80107320:	c3                   	ret    

80107321 <uartgetc>:

static int
uartgetc(void)
{
80107321:	55                   	push   %ebp
80107322:	89 e5                	mov    %esp,%ebp
  if(!uart)
80107324:	a1 70 c6 10 80       	mov    0x8010c670,%eax
80107329:	85 c0                	test   %eax,%eax
8010732b:	75 07                	jne    80107334 <uartgetc+0x13>
    return -1;
8010732d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107332:	eb 2e                	jmp    80107362 <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
80107334:	68 fd 03 00 00       	push   $0x3fd
80107339:	e8 7a fe ff ff       	call   801071b8 <inb>
8010733e:	83 c4 04             	add    $0x4,%esp
80107341:	0f b6 c0             	movzbl %al,%eax
80107344:	83 e0 01             	and    $0x1,%eax
80107347:	85 c0                	test   %eax,%eax
80107349:	75 07                	jne    80107352 <uartgetc+0x31>
    return -1;
8010734b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107350:	eb 10                	jmp    80107362 <uartgetc+0x41>
  return inb(COM1+0);
80107352:	68 f8 03 00 00       	push   $0x3f8
80107357:	e8 5c fe ff ff       	call   801071b8 <inb>
8010735c:	83 c4 04             	add    $0x4,%esp
8010735f:	0f b6 c0             	movzbl %al,%eax
}
80107362:	c9                   	leave  
80107363:	c3                   	ret    

80107364 <uartintr>:

void
uartintr(void)
{
80107364:	55                   	push   %ebp
80107365:	89 e5                	mov    %esp,%ebp
80107367:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
8010736a:	83 ec 0c             	sub    $0xc,%esp
8010736d:	68 21 73 10 80       	push   $0x80107321
80107372:	e8 82 94 ff ff       	call   801007f9 <consoleintr>
80107377:	83 c4 10             	add    $0x10,%esp
}
8010737a:	90                   	nop
8010737b:	c9                   	leave  
8010737c:	c3                   	ret    

8010737d <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
8010737d:	6a 00                	push   $0x0
  pushl $0
8010737f:	6a 00                	push   $0x0
  jmp alltraps
80107381:	e9 d2 f9 ff ff       	jmp    80106d58 <alltraps>

80107386 <vector1>:
.globl vector1
vector1:
  pushl $0
80107386:	6a 00                	push   $0x0
  pushl $1
80107388:	6a 01                	push   $0x1
  jmp alltraps
8010738a:	e9 c9 f9 ff ff       	jmp    80106d58 <alltraps>

8010738f <vector2>:
.globl vector2
vector2:
  pushl $0
8010738f:	6a 00                	push   $0x0
  pushl $2
80107391:	6a 02                	push   $0x2
  jmp alltraps
80107393:	e9 c0 f9 ff ff       	jmp    80106d58 <alltraps>

80107398 <vector3>:
.globl vector3
vector3:
  pushl $0
80107398:	6a 00                	push   $0x0
  pushl $3
8010739a:	6a 03                	push   $0x3
  jmp alltraps
8010739c:	e9 b7 f9 ff ff       	jmp    80106d58 <alltraps>

801073a1 <vector4>:
.globl vector4
vector4:
  pushl $0
801073a1:	6a 00                	push   $0x0
  pushl $4
801073a3:	6a 04                	push   $0x4
  jmp alltraps
801073a5:	e9 ae f9 ff ff       	jmp    80106d58 <alltraps>

801073aa <vector5>:
.globl vector5
vector5:
  pushl $0
801073aa:	6a 00                	push   $0x0
  pushl $5
801073ac:	6a 05                	push   $0x5
  jmp alltraps
801073ae:	e9 a5 f9 ff ff       	jmp    80106d58 <alltraps>

801073b3 <vector6>:
.globl vector6
vector6:
  pushl $0
801073b3:	6a 00                	push   $0x0
  pushl $6
801073b5:	6a 06                	push   $0x6
  jmp alltraps
801073b7:	e9 9c f9 ff ff       	jmp    80106d58 <alltraps>

801073bc <vector7>:
.globl vector7
vector7:
  pushl $0
801073bc:	6a 00                	push   $0x0
  pushl $7
801073be:	6a 07                	push   $0x7
  jmp alltraps
801073c0:	e9 93 f9 ff ff       	jmp    80106d58 <alltraps>

801073c5 <vector8>:
.globl vector8
vector8:
  pushl $8
801073c5:	6a 08                	push   $0x8
  jmp alltraps
801073c7:	e9 8c f9 ff ff       	jmp    80106d58 <alltraps>

801073cc <vector9>:
.globl vector9
vector9:
  pushl $0
801073cc:	6a 00                	push   $0x0
  pushl $9
801073ce:	6a 09                	push   $0x9
  jmp alltraps
801073d0:	e9 83 f9 ff ff       	jmp    80106d58 <alltraps>

801073d5 <vector10>:
.globl vector10
vector10:
  pushl $10
801073d5:	6a 0a                	push   $0xa
  jmp alltraps
801073d7:	e9 7c f9 ff ff       	jmp    80106d58 <alltraps>

801073dc <vector11>:
.globl vector11
vector11:
  pushl $11
801073dc:	6a 0b                	push   $0xb
  jmp alltraps
801073de:	e9 75 f9 ff ff       	jmp    80106d58 <alltraps>

801073e3 <vector12>:
.globl vector12
vector12:
  pushl $12
801073e3:	6a 0c                	push   $0xc
  jmp alltraps
801073e5:	e9 6e f9 ff ff       	jmp    80106d58 <alltraps>

801073ea <vector13>:
.globl vector13
vector13:
  pushl $13
801073ea:	6a 0d                	push   $0xd
  jmp alltraps
801073ec:	e9 67 f9 ff ff       	jmp    80106d58 <alltraps>

801073f1 <vector14>:
.globl vector14
vector14:
  pushl $14
801073f1:	6a 0e                	push   $0xe
  jmp alltraps
801073f3:	e9 60 f9 ff ff       	jmp    80106d58 <alltraps>

801073f8 <vector15>:
.globl vector15
vector15:
  pushl $0
801073f8:	6a 00                	push   $0x0
  pushl $15
801073fa:	6a 0f                	push   $0xf
  jmp alltraps
801073fc:	e9 57 f9 ff ff       	jmp    80106d58 <alltraps>

80107401 <vector16>:
.globl vector16
vector16:
  pushl $0
80107401:	6a 00                	push   $0x0
  pushl $16
80107403:	6a 10                	push   $0x10
  jmp alltraps
80107405:	e9 4e f9 ff ff       	jmp    80106d58 <alltraps>

8010740a <vector17>:
.globl vector17
vector17:
  pushl $17
8010740a:	6a 11                	push   $0x11
  jmp alltraps
8010740c:	e9 47 f9 ff ff       	jmp    80106d58 <alltraps>

80107411 <vector18>:
.globl vector18
vector18:
  pushl $0
80107411:	6a 00                	push   $0x0
  pushl $18
80107413:	6a 12                	push   $0x12
  jmp alltraps
80107415:	e9 3e f9 ff ff       	jmp    80106d58 <alltraps>

8010741a <vector19>:
.globl vector19
vector19:
  pushl $0
8010741a:	6a 00                	push   $0x0
  pushl $19
8010741c:	6a 13                	push   $0x13
  jmp alltraps
8010741e:	e9 35 f9 ff ff       	jmp    80106d58 <alltraps>

80107423 <vector20>:
.globl vector20
vector20:
  pushl $0
80107423:	6a 00                	push   $0x0
  pushl $20
80107425:	6a 14                	push   $0x14
  jmp alltraps
80107427:	e9 2c f9 ff ff       	jmp    80106d58 <alltraps>

8010742c <vector21>:
.globl vector21
vector21:
  pushl $0
8010742c:	6a 00                	push   $0x0
  pushl $21
8010742e:	6a 15                	push   $0x15
  jmp alltraps
80107430:	e9 23 f9 ff ff       	jmp    80106d58 <alltraps>

80107435 <vector22>:
.globl vector22
vector22:
  pushl $0
80107435:	6a 00                	push   $0x0
  pushl $22
80107437:	6a 16                	push   $0x16
  jmp alltraps
80107439:	e9 1a f9 ff ff       	jmp    80106d58 <alltraps>

8010743e <vector23>:
.globl vector23
vector23:
  pushl $0
8010743e:	6a 00                	push   $0x0
  pushl $23
80107440:	6a 17                	push   $0x17
  jmp alltraps
80107442:	e9 11 f9 ff ff       	jmp    80106d58 <alltraps>

80107447 <vector24>:
.globl vector24
vector24:
  pushl $0
80107447:	6a 00                	push   $0x0
  pushl $24
80107449:	6a 18                	push   $0x18
  jmp alltraps
8010744b:	e9 08 f9 ff ff       	jmp    80106d58 <alltraps>

80107450 <vector25>:
.globl vector25
vector25:
  pushl $0
80107450:	6a 00                	push   $0x0
  pushl $25
80107452:	6a 19                	push   $0x19
  jmp alltraps
80107454:	e9 ff f8 ff ff       	jmp    80106d58 <alltraps>

80107459 <vector26>:
.globl vector26
vector26:
  pushl $0
80107459:	6a 00                	push   $0x0
  pushl $26
8010745b:	6a 1a                	push   $0x1a
  jmp alltraps
8010745d:	e9 f6 f8 ff ff       	jmp    80106d58 <alltraps>

80107462 <vector27>:
.globl vector27
vector27:
  pushl $0
80107462:	6a 00                	push   $0x0
  pushl $27
80107464:	6a 1b                	push   $0x1b
  jmp alltraps
80107466:	e9 ed f8 ff ff       	jmp    80106d58 <alltraps>

8010746b <vector28>:
.globl vector28
vector28:
  pushl $0
8010746b:	6a 00                	push   $0x0
  pushl $28
8010746d:	6a 1c                	push   $0x1c
  jmp alltraps
8010746f:	e9 e4 f8 ff ff       	jmp    80106d58 <alltraps>

80107474 <vector29>:
.globl vector29
vector29:
  pushl $0
80107474:	6a 00                	push   $0x0
  pushl $29
80107476:	6a 1d                	push   $0x1d
  jmp alltraps
80107478:	e9 db f8 ff ff       	jmp    80106d58 <alltraps>

8010747d <vector30>:
.globl vector30
vector30:
  pushl $0
8010747d:	6a 00                	push   $0x0
  pushl $30
8010747f:	6a 1e                	push   $0x1e
  jmp alltraps
80107481:	e9 d2 f8 ff ff       	jmp    80106d58 <alltraps>

80107486 <vector31>:
.globl vector31
vector31:
  pushl $0
80107486:	6a 00                	push   $0x0
  pushl $31
80107488:	6a 1f                	push   $0x1f
  jmp alltraps
8010748a:	e9 c9 f8 ff ff       	jmp    80106d58 <alltraps>

8010748f <vector32>:
.globl vector32
vector32:
  pushl $0
8010748f:	6a 00                	push   $0x0
  pushl $32
80107491:	6a 20                	push   $0x20
  jmp alltraps
80107493:	e9 c0 f8 ff ff       	jmp    80106d58 <alltraps>

80107498 <vector33>:
.globl vector33
vector33:
  pushl $0
80107498:	6a 00                	push   $0x0
  pushl $33
8010749a:	6a 21                	push   $0x21
  jmp alltraps
8010749c:	e9 b7 f8 ff ff       	jmp    80106d58 <alltraps>

801074a1 <vector34>:
.globl vector34
vector34:
  pushl $0
801074a1:	6a 00                	push   $0x0
  pushl $34
801074a3:	6a 22                	push   $0x22
  jmp alltraps
801074a5:	e9 ae f8 ff ff       	jmp    80106d58 <alltraps>

801074aa <vector35>:
.globl vector35
vector35:
  pushl $0
801074aa:	6a 00                	push   $0x0
  pushl $35
801074ac:	6a 23                	push   $0x23
  jmp alltraps
801074ae:	e9 a5 f8 ff ff       	jmp    80106d58 <alltraps>

801074b3 <vector36>:
.globl vector36
vector36:
  pushl $0
801074b3:	6a 00                	push   $0x0
  pushl $36
801074b5:	6a 24                	push   $0x24
  jmp alltraps
801074b7:	e9 9c f8 ff ff       	jmp    80106d58 <alltraps>

801074bc <vector37>:
.globl vector37
vector37:
  pushl $0
801074bc:	6a 00                	push   $0x0
  pushl $37
801074be:	6a 25                	push   $0x25
  jmp alltraps
801074c0:	e9 93 f8 ff ff       	jmp    80106d58 <alltraps>

801074c5 <vector38>:
.globl vector38
vector38:
  pushl $0
801074c5:	6a 00                	push   $0x0
  pushl $38
801074c7:	6a 26                	push   $0x26
  jmp alltraps
801074c9:	e9 8a f8 ff ff       	jmp    80106d58 <alltraps>

801074ce <vector39>:
.globl vector39
vector39:
  pushl $0
801074ce:	6a 00                	push   $0x0
  pushl $39
801074d0:	6a 27                	push   $0x27
  jmp alltraps
801074d2:	e9 81 f8 ff ff       	jmp    80106d58 <alltraps>

801074d7 <vector40>:
.globl vector40
vector40:
  pushl $0
801074d7:	6a 00                	push   $0x0
  pushl $40
801074d9:	6a 28                	push   $0x28
  jmp alltraps
801074db:	e9 78 f8 ff ff       	jmp    80106d58 <alltraps>

801074e0 <vector41>:
.globl vector41
vector41:
  pushl $0
801074e0:	6a 00                	push   $0x0
  pushl $41
801074e2:	6a 29                	push   $0x29
  jmp alltraps
801074e4:	e9 6f f8 ff ff       	jmp    80106d58 <alltraps>

801074e9 <vector42>:
.globl vector42
vector42:
  pushl $0
801074e9:	6a 00                	push   $0x0
  pushl $42
801074eb:	6a 2a                	push   $0x2a
  jmp alltraps
801074ed:	e9 66 f8 ff ff       	jmp    80106d58 <alltraps>

801074f2 <vector43>:
.globl vector43
vector43:
  pushl $0
801074f2:	6a 00                	push   $0x0
  pushl $43
801074f4:	6a 2b                	push   $0x2b
  jmp alltraps
801074f6:	e9 5d f8 ff ff       	jmp    80106d58 <alltraps>

801074fb <vector44>:
.globl vector44
vector44:
  pushl $0
801074fb:	6a 00                	push   $0x0
  pushl $44
801074fd:	6a 2c                	push   $0x2c
  jmp alltraps
801074ff:	e9 54 f8 ff ff       	jmp    80106d58 <alltraps>

80107504 <vector45>:
.globl vector45
vector45:
  pushl $0
80107504:	6a 00                	push   $0x0
  pushl $45
80107506:	6a 2d                	push   $0x2d
  jmp alltraps
80107508:	e9 4b f8 ff ff       	jmp    80106d58 <alltraps>

8010750d <vector46>:
.globl vector46
vector46:
  pushl $0
8010750d:	6a 00                	push   $0x0
  pushl $46
8010750f:	6a 2e                	push   $0x2e
  jmp alltraps
80107511:	e9 42 f8 ff ff       	jmp    80106d58 <alltraps>

80107516 <vector47>:
.globl vector47
vector47:
  pushl $0
80107516:	6a 00                	push   $0x0
  pushl $47
80107518:	6a 2f                	push   $0x2f
  jmp alltraps
8010751a:	e9 39 f8 ff ff       	jmp    80106d58 <alltraps>

8010751f <vector48>:
.globl vector48
vector48:
  pushl $0
8010751f:	6a 00                	push   $0x0
  pushl $48
80107521:	6a 30                	push   $0x30
  jmp alltraps
80107523:	e9 30 f8 ff ff       	jmp    80106d58 <alltraps>

80107528 <vector49>:
.globl vector49
vector49:
  pushl $0
80107528:	6a 00                	push   $0x0
  pushl $49
8010752a:	6a 31                	push   $0x31
  jmp alltraps
8010752c:	e9 27 f8 ff ff       	jmp    80106d58 <alltraps>

80107531 <vector50>:
.globl vector50
vector50:
  pushl $0
80107531:	6a 00                	push   $0x0
  pushl $50
80107533:	6a 32                	push   $0x32
  jmp alltraps
80107535:	e9 1e f8 ff ff       	jmp    80106d58 <alltraps>

8010753a <vector51>:
.globl vector51
vector51:
  pushl $0
8010753a:	6a 00                	push   $0x0
  pushl $51
8010753c:	6a 33                	push   $0x33
  jmp alltraps
8010753e:	e9 15 f8 ff ff       	jmp    80106d58 <alltraps>

80107543 <vector52>:
.globl vector52
vector52:
  pushl $0
80107543:	6a 00                	push   $0x0
  pushl $52
80107545:	6a 34                	push   $0x34
  jmp alltraps
80107547:	e9 0c f8 ff ff       	jmp    80106d58 <alltraps>

8010754c <vector53>:
.globl vector53
vector53:
  pushl $0
8010754c:	6a 00                	push   $0x0
  pushl $53
8010754e:	6a 35                	push   $0x35
  jmp alltraps
80107550:	e9 03 f8 ff ff       	jmp    80106d58 <alltraps>

80107555 <vector54>:
.globl vector54
vector54:
  pushl $0
80107555:	6a 00                	push   $0x0
  pushl $54
80107557:	6a 36                	push   $0x36
  jmp alltraps
80107559:	e9 fa f7 ff ff       	jmp    80106d58 <alltraps>

8010755e <vector55>:
.globl vector55
vector55:
  pushl $0
8010755e:	6a 00                	push   $0x0
  pushl $55
80107560:	6a 37                	push   $0x37
  jmp alltraps
80107562:	e9 f1 f7 ff ff       	jmp    80106d58 <alltraps>

80107567 <vector56>:
.globl vector56
vector56:
  pushl $0
80107567:	6a 00                	push   $0x0
  pushl $56
80107569:	6a 38                	push   $0x38
  jmp alltraps
8010756b:	e9 e8 f7 ff ff       	jmp    80106d58 <alltraps>

80107570 <vector57>:
.globl vector57
vector57:
  pushl $0
80107570:	6a 00                	push   $0x0
  pushl $57
80107572:	6a 39                	push   $0x39
  jmp alltraps
80107574:	e9 df f7 ff ff       	jmp    80106d58 <alltraps>

80107579 <vector58>:
.globl vector58
vector58:
  pushl $0
80107579:	6a 00                	push   $0x0
  pushl $58
8010757b:	6a 3a                	push   $0x3a
  jmp alltraps
8010757d:	e9 d6 f7 ff ff       	jmp    80106d58 <alltraps>

80107582 <vector59>:
.globl vector59
vector59:
  pushl $0
80107582:	6a 00                	push   $0x0
  pushl $59
80107584:	6a 3b                	push   $0x3b
  jmp alltraps
80107586:	e9 cd f7 ff ff       	jmp    80106d58 <alltraps>

8010758b <vector60>:
.globl vector60
vector60:
  pushl $0
8010758b:	6a 00                	push   $0x0
  pushl $60
8010758d:	6a 3c                	push   $0x3c
  jmp alltraps
8010758f:	e9 c4 f7 ff ff       	jmp    80106d58 <alltraps>

80107594 <vector61>:
.globl vector61
vector61:
  pushl $0
80107594:	6a 00                	push   $0x0
  pushl $61
80107596:	6a 3d                	push   $0x3d
  jmp alltraps
80107598:	e9 bb f7 ff ff       	jmp    80106d58 <alltraps>

8010759d <vector62>:
.globl vector62
vector62:
  pushl $0
8010759d:	6a 00                	push   $0x0
  pushl $62
8010759f:	6a 3e                	push   $0x3e
  jmp alltraps
801075a1:	e9 b2 f7 ff ff       	jmp    80106d58 <alltraps>

801075a6 <vector63>:
.globl vector63
vector63:
  pushl $0
801075a6:	6a 00                	push   $0x0
  pushl $63
801075a8:	6a 3f                	push   $0x3f
  jmp alltraps
801075aa:	e9 a9 f7 ff ff       	jmp    80106d58 <alltraps>

801075af <vector64>:
.globl vector64
vector64:
  pushl $0
801075af:	6a 00                	push   $0x0
  pushl $64
801075b1:	6a 40                	push   $0x40
  jmp alltraps
801075b3:	e9 a0 f7 ff ff       	jmp    80106d58 <alltraps>

801075b8 <vector65>:
.globl vector65
vector65:
  pushl $0
801075b8:	6a 00                	push   $0x0
  pushl $65
801075ba:	6a 41                	push   $0x41
  jmp alltraps
801075bc:	e9 97 f7 ff ff       	jmp    80106d58 <alltraps>

801075c1 <vector66>:
.globl vector66
vector66:
  pushl $0
801075c1:	6a 00                	push   $0x0
  pushl $66
801075c3:	6a 42                	push   $0x42
  jmp alltraps
801075c5:	e9 8e f7 ff ff       	jmp    80106d58 <alltraps>

801075ca <vector67>:
.globl vector67
vector67:
  pushl $0
801075ca:	6a 00                	push   $0x0
  pushl $67
801075cc:	6a 43                	push   $0x43
  jmp alltraps
801075ce:	e9 85 f7 ff ff       	jmp    80106d58 <alltraps>

801075d3 <vector68>:
.globl vector68
vector68:
  pushl $0
801075d3:	6a 00                	push   $0x0
  pushl $68
801075d5:	6a 44                	push   $0x44
  jmp alltraps
801075d7:	e9 7c f7 ff ff       	jmp    80106d58 <alltraps>

801075dc <vector69>:
.globl vector69
vector69:
  pushl $0
801075dc:	6a 00                	push   $0x0
  pushl $69
801075de:	6a 45                	push   $0x45
  jmp alltraps
801075e0:	e9 73 f7 ff ff       	jmp    80106d58 <alltraps>

801075e5 <vector70>:
.globl vector70
vector70:
  pushl $0
801075e5:	6a 00                	push   $0x0
  pushl $70
801075e7:	6a 46                	push   $0x46
  jmp alltraps
801075e9:	e9 6a f7 ff ff       	jmp    80106d58 <alltraps>

801075ee <vector71>:
.globl vector71
vector71:
  pushl $0
801075ee:	6a 00                	push   $0x0
  pushl $71
801075f0:	6a 47                	push   $0x47
  jmp alltraps
801075f2:	e9 61 f7 ff ff       	jmp    80106d58 <alltraps>

801075f7 <vector72>:
.globl vector72
vector72:
  pushl $0
801075f7:	6a 00                	push   $0x0
  pushl $72
801075f9:	6a 48                	push   $0x48
  jmp alltraps
801075fb:	e9 58 f7 ff ff       	jmp    80106d58 <alltraps>

80107600 <vector73>:
.globl vector73
vector73:
  pushl $0
80107600:	6a 00                	push   $0x0
  pushl $73
80107602:	6a 49                	push   $0x49
  jmp alltraps
80107604:	e9 4f f7 ff ff       	jmp    80106d58 <alltraps>

80107609 <vector74>:
.globl vector74
vector74:
  pushl $0
80107609:	6a 00                	push   $0x0
  pushl $74
8010760b:	6a 4a                	push   $0x4a
  jmp alltraps
8010760d:	e9 46 f7 ff ff       	jmp    80106d58 <alltraps>

80107612 <vector75>:
.globl vector75
vector75:
  pushl $0
80107612:	6a 00                	push   $0x0
  pushl $75
80107614:	6a 4b                	push   $0x4b
  jmp alltraps
80107616:	e9 3d f7 ff ff       	jmp    80106d58 <alltraps>

8010761b <vector76>:
.globl vector76
vector76:
  pushl $0
8010761b:	6a 00                	push   $0x0
  pushl $76
8010761d:	6a 4c                	push   $0x4c
  jmp alltraps
8010761f:	e9 34 f7 ff ff       	jmp    80106d58 <alltraps>

80107624 <vector77>:
.globl vector77
vector77:
  pushl $0
80107624:	6a 00                	push   $0x0
  pushl $77
80107626:	6a 4d                	push   $0x4d
  jmp alltraps
80107628:	e9 2b f7 ff ff       	jmp    80106d58 <alltraps>

8010762d <vector78>:
.globl vector78
vector78:
  pushl $0
8010762d:	6a 00                	push   $0x0
  pushl $78
8010762f:	6a 4e                	push   $0x4e
  jmp alltraps
80107631:	e9 22 f7 ff ff       	jmp    80106d58 <alltraps>

80107636 <vector79>:
.globl vector79
vector79:
  pushl $0
80107636:	6a 00                	push   $0x0
  pushl $79
80107638:	6a 4f                	push   $0x4f
  jmp alltraps
8010763a:	e9 19 f7 ff ff       	jmp    80106d58 <alltraps>

8010763f <vector80>:
.globl vector80
vector80:
  pushl $0
8010763f:	6a 00                	push   $0x0
  pushl $80
80107641:	6a 50                	push   $0x50
  jmp alltraps
80107643:	e9 10 f7 ff ff       	jmp    80106d58 <alltraps>

80107648 <vector81>:
.globl vector81
vector81:
  pushl $0
80107648:	6a 00                	push   $0x0
  pushl $81
8010764a:	6a 51                	push   $0x51
  jmp alltraps
8010764c:	e9 07 f7 ff ff       	jmp    80106d58 <alltraps>

80107651 <vector82>:
.globl vector82
vector82:
  pushl $0
80107651:	6a 00                	push   $0x0
  pushl $82
80107653:	6a 52                	push   $0x52
  jmp alltraps
80107655:	e9 fe f6 ff ff       	jmp    80106d58 <alltraps>

8010765a <vector83>:
.globl vector83
vector83:
  pushl $0
8010765a:	6a 00                	push   $0x0
  pushl $83
8010765c:	6a 53                	push   $0x53
  jmp alltraps
8010765e:	e9 f5 f6 ff ff       	jmp    80106d58 <alltraps>

80107663 <vector84>:
.globl vector84
vector84:
  pushl $0
80107663:	6a 00                	push   $0x0
  pushl $84
80107665:	6a 54                	push   $0x54
  jmp alltraps
80107667:	e9 ec f6 ff ff       	jmp    80106d58 <alltraps>

8010766c <vector85>:
.globl vector85
vector85:
  pushl $0
8010766c:	6a 00                	push   $0x0
  pushl $85
8010766e:	6a 55                	push   $0x55
  jmp alltraps
80107670:	e9 e3 f6 ff ff       	jmp    80106d58 <alltraps>

80107675 <vector86>:
.globl vector86
vector86:
  pushl $0
80107675:	6a 00                	push   $0x0
  pushl $86
80107677:	6a 56                	push   $0x56
  jmp alltraps
80107679:	e9 da f6 ff ff       	jmp    80106d58 <alltraps>

8010767e <vector87>:
.globl vector87
vector87:
  pushl $0
8010767e:	6a 00                	push   $0x0
  pushl $87
80107680:	6a 57                	push   $0x57
  jmp alltraps
80107682:	e9 d1 f6 ff ff       	jmp    80106d58 <alltraps>

80107687 <vector88>:
.globl vector88
vector88:
  pushl $0
80107687:	6a 00                	push   $0x0
  pushl $88
80107689:	6a 58                	push   $0x58
  jmp alltraps
8010768b:	e9 c8 f6 ff ff       	jmp    80106d58 <alltraps>

80107690 <vector89>:
.globl vector89
vector89:
  pushl $0
80107690:	6a 00                	push   $0x0
  pushl $89
80107692:	6a 59                	push   $0x59
  jmp alltraps
80107694:	e9 bf f6 ff ff       	jmp    80106d58 <alltraps>

80107699 <vector90>:
.globl vector90
vector90:
  pushl $0
80107699:	6a 00                	push   $0x0
  pushl $90
8010769b:	6a 5a                	push   $0x5a
  jmp alltraps
8010769d:	e9 b6 f6 ff ff       	jmp    80106d58 <alltraps>

801076a2 <vector91>:
.globl vector91
vector91:
  pushl $0
801076a2:	6a 00                	push   $0x0
  pushl $91
801076a4:	6a 5b                	push   $0x5b
  jmp alltraps
801076a6:	e9 ad f6 ff ff       	jmp    80106d58 <alltraps>

801076ab <vector92>:
.globl vector92
vector92:
  pushl $0
801076ab:	6a 00                	push   $0x0
  pushl $92
801076ad:	6a 5c                	push   $0x5c
  jmp alltraps
801076af:	e9 a4 f6 ff ff       	jmp    80106d58 <alltraps>

801076b4 <vector93>:
.globl vector93
vector93:
  pushl $0
801076b4:	6a 00                	push   $0x0
  pushl $93
801076b6:	6a 5d                	push   $0x5d
  jmp alltraps
801076b8:	e9 9b f6 ff ff       	jmp    80106d58 <alltraps>

801076bd <vector94>:
.globl vector94
vector94:
  pushl $0
801076bd:	6a 00                	push   $0x0
  pushl $94
801076bf:	6a 5e                	push   $0x5e
  jmp alltraps
801076c1:	e9 92 f6 ff ff       	jmp    80106d58 <alltraps>

801076c6 <vector95>:
.globl vector95
vector95:
  pushl $0
801076c6:	6a 00                	push   $0x0
  pushl $95
801076c8:	6a 5f                	push   $0x5f
  jmp alltraps
801076ca:	e9 89 f6 ff ff       	jmp    80106d58 <alltraps>

801076cf <vector96>:
.globl vector96
vector96:
  pushl $0
801076cf:	6a 00                	push   $0x0
  pushl $96
801076d1:	6a 60                	push   $0x60
  jmp alltraps
801076d3:	e9 80 f6 ff ff       	jmp    80106d58 <alltraps>

801076d8 <vector97>:
.globl vector97
vector97:
  pushl $0
801076d8:	6a 00                	push   $0x0
  pushl $97
801076da:	6a 61                	push   $0x61
  jmp alltraps
801076dc:	e9 77 f6 ff ff       	jmp    80106d58 <alltraps>

801076e1 <vector98>:
.globl vector98
vector98:
  pushl $0
801076e1:	6a 00                	push   $0x0
  pushl $98
801076e3:	6a 62                	push   $0x62
  jmp alltraps
801076e5:	e9 6e f6 ff ff       	jmp    80106d58 <alltraps>

801076ea <vector99>:
.globl vector99
vector99:
  pushl $0
801076ea:	6a 00                	push   $0x0
  pushl $99
801076ec:	6a 63                	push   $0x63
  jmp alltraps
801076ee:	e9 65 f6 ff ff       	jmp    80106d58 <alltraps>

801076f3 <vector100>:
.globl vector100
vector100:
  pushl $0
801076f3:	6a 00                	push   $0x0
  pushl $100
801076f5:	6a 64                	push   $0x64
  jmp alltraps
801076f7:	e9 5c f6 ff ff       	jmp    80106d58 <alltraps>

801076fc <vector101>:
.globl vector101
vector101:
  pushl $0
801076fc:	6a 00                	push   $0x0
  pushl $101
801076fe:	6a 65                	push   $0x65
  jmp alltraps
80107700:	e9 53 f6 ff ff       	jmp    80106d58 <alltraps>

80107705 <vector102>:
.globl vector102
vector102:
  pushl $0
80107705:	6a 00                	push   $0x0
  pushl $102
80107707:	6a 66                	push   $0x66
  jmp alltraps
80107709:	e9 4a f6 ff ff       	jmp    80106d58 <alltraps>

8010770e <vector103>:
.globl vector103
vector103:
  pushl $0
8010770e:	6a 00                	push   $0x0
  pushl $103
80107710:	6a 67                	push   $0x67
  jmp alltraps
80107712:	e9 41 f6 ff ff       	jmp    80106d58 <alltraps>

80107717 <vector104>:
.globl vector104
vector104:
  pushl $0
80107717:	6a 00                	push   $0x0
  pushl $104
80107719:	6a 68                	push   $0x68
  jmp alltraps
8010771b:	e9 38 f6 ff ff       	jmp    80106d58 <alltraps>

80107720 <vector105>:
.globl vector105
vector105:
  pushl $0
80107720:	6a 00                	push   $0x0
  pushl $105
80107722:	6a 69                	push   $0x69
  jmp alltraps
80107724:	e9 2f f6 ff ff       	jmp    80106d58 <alltraps>

80107729 <vector106>:
.globl vector106
vector106:
  pushl $0
80107729:	6a 00                	push   $0x0
  pushl $106
8010772b:	6a 6a                	push   $0x6a
  jmp alltraps
8010772d:	e9 26 f6 ff ff       	jmp    80106d58 <alltraps>

80107732 <vector107>:
.globl vector107
vector107:
  pushl $0
80107732:	6a 00                	push   $0x0
  pushl $107
80107734:	6a 6b                	push   $0x6b
  jmp alltraps
80107736:	e9 1d f6 ff ff       	jmp    80106d58 <alltraps>

8010773b <vector108>:
.globl vector108
vector108:
  pushl $0
8010773b:	6a 00                	push   $0x0
  pushl $108
8010773d:	6a 6c                	push   $0x6c
  jmp alltraps
8010773f:	e9 14 f6 ff ff       	jmp    80106d58 <alltraps>

80107744 <vector109>:
.globl vector109
vector109:
  pushl $0
80107744:	6a 00                	push   $0x0
  pushl $109
80107746:	6a 6d                	push   $0x6d
  jmp alltraps
80107748:	e9 0b f6 ff ff       	jmp    80106d58 <alltraps>

8010774d <vector110>:
.globl vector110
vector110:
  pushl $0
8010774d:	6a 00                	push   $0x0
  pushl $110
8010774f:	6a 6e                	push   $0x6e
  jmp alltraps
80107751:	e9 02 f6 ff ff       	jmp    80106d58 <alltraps>

80107756 <vector111>:
.globl vector111
vector111:
  pushl $0
80107756:	6a 00                	push   $0x0
  pushl $111
80107758:	6a 6f                	push   $0x6f
  jmp alltraps
8010775a:	e9 f9 f5 ff ff       	jmp    80106d58 <alltraps>

8010775f <vector112>:
.globl vector112
vector112:
  pushl $0
8010775f:	6a 00                	push   $0x0
  pushl $112
80107761:	6a 70                	push   $0x70
  jmp alltraps
80107763:	e9 f0 f5 ff ff       	jmp    80106d58 <alltraps>

80107768 <vector113>:
.globl vector113
vector113:
  pushl $0
80107768:	6a 00                	push   $0x0
  pushl $113
8010776a:	6a 71                	push   $0x71
  jmp alltraps
8010776c:	e9 e7 f5 ff ff       	jmp    80106d58 <alltraps>

80107771 <vector114>:
.globl vector114
vector114:
  pushl $0
80107771:	6a 00                	push   $0x0
  pushl $114
80107773:	6a 72                	push   $0x72
  jmp alltraps
80107775:	e9 de f5 ff ff       	jmp    80106d58 <alltraps>

8010777a <vector115>:
.globl vector115
vector115:
  pushl $0
8010777a:	6a 00                	push   $0x0
  pushl $115
8010777c:	6a 73                	push   $0x73
  jmp alltraps
8010777e:	e9 d5 f5 ff ff       	jmp    80106d58 <alltraps>

80107783 <vector116>:
.globl vector116
vector116:
  pushl $0
80107783:	6a 00                	push   $0x0
  pushl $116
80107785:	6a 74                	push   $0x74
  jmp alltraps
80107787:	e9 cc f5 ff ff       	jmp    80106d58 <alltraps>

8010778c <vector117>:
.globl vector117
vector117:
  pushl $0
8010778c:	6a 00                	push   $0x0
  pushl $117
8010778e:	6a 75                	push   $0x75
  jmp alltraps
80107790:	e9 c3 f5 ff ff       	jmp    80106d58 <alltraps>

80107795 <vector118>:
.globl vector118
vector118:
  pushl $0
80107795:	6a 00                	push   $0x0
  pushl $118
80107797:	6a 76                	push   $0x76
  jmp alltraps
80107799:	e9 ba f5 ff ff       	jmp    80106d58 <alltraps>

8010779e <vector119>:
.globl vector119
vector119:
  pushl $0
8010779e:	6a 00                	push   $0x0
  pushl $119
801077a0:	6a 77                	push   $0x77
  jmp alltraps
801077a2:	e9 b1 f5 ff ff       	jmp    80106d58 <alltraps>

801077a7 <vector120>:
.globl vector120
vector120:
  pushl $0
801077a7:	6a 00                	push   $0x0
  pushl $120
801077a9:	6a 78                	push   $0x78
  jmp alltraps
801077ab:	e9 a8 f5 ff ff       	jmp    80106d58 <alltraps>

801077b0 <vector121>:
.globl vector121
vector121:
  pushl $0
801077b0:	6a 00                	push   $0x0
  pushl $121
801077b2:	6a 79                	push   $0x79
  jmp alltraps
801077b4:	e9 9f f5 ff ff       	jmp    80106d58 <alltraps>

801077b9 <vector122>:
.globl vector122
vector122:
  pushl $0
801077b9:	6a 00                	push   $0x0
  pushl $122
801077bb:	6a 7a                	push   $0x7a
  jmp alltraps
801077bd:	e9 96 f5 ff ff       	jmp    80106d58 <alltraps>

801077c2 <vector123>:
.globl vector123
vector123:
  pushl $0
801077c2:	6a 00                	push   $0x0
  pushl $123
801077c4:	6a 7b                	push   $0x7b
  jmp alltraps
801077c6:	e9 8d f5 ff ff       	jmp    80106d58 <alltraps>

801077cb <vector124>:
.globl vector124
vector124:
  pushl $0
801077cb:	6a 00                	push   $0x0
  pushl $124
801077cd:	6a 7c                	push   $0x7c
  jmp alltraps
801077cf:	e9 84 f5 ff ff       	jmp    80106d58 <alltraps>

801077d4 <vector125>:
.globl vector125
vector125:
  pushl $0
801077d4:	6a 00                	push   $0x0
  pushl $125
801077d6:	6a 7d                	push   $0x7d
  jmp alltraps
801077d8:	e9 7b f5 ff ff       	jmp    80106d58 <alltraps>

801077dd <vector126>:
.globl vector126
vector126:
  pushl $0
801077dd:	6a 00                	push   $0x0
  pushl $126
801077df:	6a 7e                	push   $0x7e
  jmp alltraps
801077e1:	e9 72 f5 ff ff       	jmp    80106d58 <alltraps>

801077e6 <vector127>:
.globl vector127
vector127:
  pushl $0
801077e6:	6a 00                	push   $0x0
  pushl $127
801077e8:	6a 7f                	push   $0x7f
  jmp alltraps
801077ea:	e9 69 f5 ff ff       	jmp    80106d58 <alltraps>

801077ef <vector128>:
.globl vector128
vector128:
  pushl $0
801077ef:	6a 00                	push   $0x0
  pushl $128
801077f1:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801077f6:	e9 5d f5 ff ff       	jmp    80106d58 <alltraps>

801077fb <vector129>:
.globl vector129
vector129:
  pushl $0
801077fb:	6a 00                	push   $0x0
  pushl $129
801077fd:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80107802:	e9 51 f5 ff ff       	jmp    80106d58 <alltraps>

80107807 <vector130>:
.globl vector130
vector130:
  pushl $0
80107807:	6a 00                	push   $0x0
  pushl $130
80107809:	68 82 00 00 00       	push   $0x82
  jmp alltraps
8010780e:	e9 45 f5 ff ff       	jmp    80106d58 <alltraps>

80107813 <vector131>:
.globl vector131
vector131:
  pushl $0
80107813:	6a 00                	push   $0x0
  pushl $131
80107815:	68 83 00 00 00       	push   $0x83
  jmp alltraps
8010781a:	e9 39 f5 ff ff       	jmp    80106d58 <alltraps>

8010781f <vector132>:
.globl vector132
vector132:
  pushl $0
8010781f:	6a 00                	push   $0x0
  pushl $132
80107821:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80107826:	e9 2d f5 ff ff       	jmp    80106d58 <alltraps>

8010782b <vector133>:
.globl vector133
vector133:
  pushl $0
8010782b:	6a 00                	push   $0x0
  pushl $133
8010782d:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80107832:	e9 21 f5 ff ff       	jmp    80106d58 <alltraps>

80107837 <vector134>:
.globl vector134
vector134:
  pushl $0
80107837:	6a 00                	push   $0x0
  pushl $134
80107839:	68 86 00 00 00       	push   $0x86
  jmp alltraps
8010783e:	e9 15 f5 ff ff       	jmp    80106d58 <alltraps>

80107843 <vector135>:
.globl vector135
vector135:
  pushl $0
80107843:	6a 00                	push   $0x0
  pushl $135
80107845:	68 87 00 00 00       	push   $0x87
  jmp alltraps
8010784a:	e9 09 f5 ff ff       	jmp    80106d58 <alltraps>

8010784f <vector136>:
.globl vector136
vector136:
  pushl $0
8010784f:	6a 00                	push   $0x0
  pushl $136
80107851:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80107856:	e9 fd f4 ff ff       	jmp    80106d58 <alltraps>

8010785b <vector137>:
.globl vector137
vector137:
  pushl $0
8010785b:	6a 00                	push   $0x0
  pushl $137
8010785d:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80107862:	e9 f1 f4 ff ff       	jmp    80106d58 <alltraps>

80107867 <vector138>:
.globl vector138
vector138:
  pushl $0
80107867:	6a 00                	push   $0x0
  pushl $138
80107869:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
8010786e:	e9 e5 f4 ff ff       	jmp    80106d58 <alltraps>

80107873 <vector139>:
.globl vector139
vector139:
  pushl $0
80107873:	6a 00                	push   $0x0
  pushl $139
80107875:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
8010787a:	e9 d9 f4 ff ff       	jmp    80106d58 <alltraps>

8010787f <vector140>:
.globl vector140
vector140:
  pushl $0
8010787f:	6a 00                	push   $0x0
  pushl $140
80107881:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80107886:	e9 cd f4 ff ff       	jmp    80106d58 <alltraps>

8010788b <vector141>:
.globl vector141
vector141:
  pushl $0
8010788b:	6a 00                	push   $0x0
  pushl $141
8010788d:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80107892:	e9 c1 f4 ff ff       	jmp    80106d58 <alltraps>

80107897 <vector142>:
.globl vector142
vector142:
  pushl $0
80107897:	6a 00                	push   $0x0
  pushl $142
80107899:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
8010789e:	e9 b5 f4 ff ff       	jmp    80106d58 <alltraps>

801078a3 <vector143>:
.globl vector143
vector143:
  pushl $0
801078a3:	6a 00                	push   $0x0
  pushl $143
801078a5:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801078aa:	e9 a9 f4 ff ff       	jmp    80106d58 <alltraps>

801078af <vector144>:
.globl vector144
vector144:
  pushl $0
801078af:	6a 00                	push   $0x0
  pushl $144
801078b1:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801078b6:	e9 9d f4 ff ff       	jmp    80106d58 <alltraps>

801078bb <vector145>:
.globl vector145
vector145:
  pushl $0
801078bb:	6a 00                	push   $0x0
  pushl $145
801078bd:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801078c2:	e9 91 f4 ff ff       	jmp    80106d58 <alltraps>

801078c7 <vector146>:
.globl vector146
vector146:
  pushl $0
801078c7:	6a 00                	push   $0x0
  pushl $146
801078c9:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801078ce:	e9 85 f4 ff ff       	jmp    80106d58 <alltraps>

801078d3 <vector147>:
.globl vector147
vector147:
  pushl $0
801078d3:	6a 00                	push   $0x0
  pushl $147
801078d5:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801078da:	e9 79 f4 ff ff       	jmp    80106d58 <alltraps>

801078df <vector148>:
.globl vector148
vector148:
  pushl $0
801078df:	6a 00                	push   $0x0
  pushl $148
801078e1:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801078e6:	e9 6d f4 ff ff       	jmp    80106d58 <alltraps>

801078eb <vector149>:
.globl vector149
vector149:
  pushl $0
801078eb:	6a 00                	push   $0x0
  pushl $149
801078ed:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801078f2:	e9 61 f4 ff ff       	jmp    80106d58 <alltraps>

801078f7 <vector150>:
.globl vector150
vector150:
  pushl $0
801078f7:	6a 00                	push   $0x0
  pushl $150
801078f9:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801078fe:	e9 55 f4 ff ff       	jmp    80106d58 <alltraps>

80107903 <vector151>:
.globl vector151
vector151:
  pushl $0
80107903:	6a 00                	push   $0x0
  pushl $151
80107905:	68 97 00 00 00       	push   $0x97
  jmp alltraps
8010790a:	e9 49 f4 ff ff       	jmp    80106d58 <alltraps>

8010790f <vector152>:
.globl vector152
vector152:
  pushl $0
8010790f:	6a 00                	push   $0x0
  pushl $152
80107911:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80107916:	e9 3d f4 ff ff       	jmp    80106d58 <alltraps>

8010791b <vector153>:
.globl vector153
vector153:
  pushl $0
8010791b:	6a 00                	push   $0x0
  pushl $153
8010791d:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80107922:	e9 31 f4 ff ff       	jmp    80106d58 <alltraps>

80107927 <vector154>:
.globl vector154
vector154:
  pushl $0
80107927:	6a 00                	push   $0x0
  pushl $154
80107929:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
8010792e:	e9 25 f4 ff ff       	jmp    80106d58 <alltraps>

80107933 <vector155>:
.globl vector155
vector155:
  pushl $0
80107933:	6a 00                	push   $0x0
  pushl $155
80107935:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
8010793a:	e9 19 f4 ff ff       	jmp    80106d58 <alltraps>

8010793f <vector156>:
.globl vector156
vector156:
  pushl $0
8010793f:	6a 00                	push   $0x0
  pushl $156
80107941:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80107946:	e9 0d f4 ff ff       	jmp    80106d58 <alltraps>

8010794b <vector157>:
.globl vector157
vector157:
  pushl $0
8010794b:	6a 00                	push   $0x0
  pushl $157
8010794d:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80107952:	e9 01 f4 ff ff       	jmp    80106d58 <alltraps>

80107957 <vector158>:
.globl vector158
vector158:
  pushl $0
80107957:	6a 00                	push   $0x0
  pushl $158
80107959:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
8010795e:	e9 f5 f3 ff ff       	jmp    80106d58 <alltraps>

80107963 <vector159>:
.globl vector159
vector159:
  pushl $0
80107963:	6a 00                	push   $0x0
  pushl $159
80107965:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
8010796a:	e9 e9 f3 ff ff       	jmp    80106d58 <alltraps>

8010796f <vector160>:
.globl vector160
vector160:
  pushl $0
8010796f:	6a 00                	push   $0x0
  pushl $160
80107971:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80107976:	e9 dd f3 ff ff       	jmp    80106d58 <alltraps>

8010797b <vector161>:
.globl vector161
vector161:
  pushl $0
8010797b:	6a 00                	push   $0x0
  pushl $161
8010797d:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80107982:	e9 d1 f3 ff ff       	jmp    80106d58 <alltraps>

80107987 <vector162>:
.globl vector162
vector162:
  pushl $0
80107987:	6a 00                	push   $0x0
  pushl $162
80107989:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
8010798e:	e9 c5 f3 ff ff       	jmp    80106d58 <alltraps>

80107993 <vector163>:
.globl vector163
vector163:
  pushl $0
80107993:	6a 00                	push   $0x0
  pushl $163
80107995:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
8010799a:	e9 b9 f3 ff ff       	jmp    80106d58 <alltraps>

8010799f <vector164>:
.globl vector164
vector164:
  pushl $0
8010799f:	6a 00                	push   $0x0
  pushl $164
801079a1:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801079a6:	e9 ad f3 ff ff       	jmp    80106d58 <alltraps>

801079ab <vector165>:
.globl vector165
vector165:
  pushl $0
801079ab:	6a 00                	push   $0x0
  pushl $165
801079ad:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801079b2:	e9 a1 f3 ff ff       	jmp    80106d58 <alltraps>

801079b7 <vector166>:
.globl vector166
vector166:
  pushl $0
801079b7:	6a 00                	push   $0x0
  pushl $166
801079b9:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801079be:	e9 95 f3 ff ff       	jmp    80106d58 <alltraps>

801079c3 <vector167>:
.globl vector167
vector167:
  pushl $0
801079c3:	6a 00                	push   $0x0
  pushl $167
801079c5:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801079ca:	e9 89 f3 ff ff       	jmp    80106d58 <alltraps>

801079cf <vector168>:
.globl vector168
vector168:
  pushl $0
801079cf:	6a 00                	push   $0x0
  pushl $168
801079d1:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801079d6:	e9 7d f3 ff ff       	jmp    80106d58 <alltraps>

801079db <vector169>:
.globl vector169
vector169:
  pushl $0
801079db:	6a 00                	push   $0x0
  pushl $169
801079dd:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801079e2:	e9 71 f3 ff ff       	jmp    80106d58 <alltraps>

801079e7 <vector170>:
.globl vector170
vector170:
  pushl $0
801079e7:	6a 00                	push   $0x0
  pushl $170
801079e9:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801079ee:	e9 65 f3 ff ff       	jmp    80106d58 <alltraps>

801079f3 <vector171>:
.globl vector171
vector171:
  pushl $0
801079f3:	6a 00                	push   $0x0
  pushl $171
801079f5:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801079fa:	e9 59 f3 ff ff       	jmp    80106d58 <alltraps>

801079ff <vector172>:
.globl vector172
vector172:
  pushl $0
801079ff:	6a 00                	push   $0x0
  pushl $172
80107a01:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107a06:	e9 4d f3 ff ff       	jmp    80106d58 <alltraps>

80107a0b <vector173>:
.globl vector173
vector173:
  pushl $0
80107a0b:	6a 00                	push   $0x0
  pushl $173
80107a0d:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80107a12:	e9 41 f3 ff ff       	jmp    80106d58 <alltraps>

80107a17 <vector174>:
.globl vector174
vector174:
  pushl $0
80107a17:	6a 00                	push   $0x0
  pushl $174
80107a19:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107a1e:	e9 35 f3 ff ff       	jmp    80106d58 <alltraps>

80107a23 <vector175>:
.globl vector175
vector175:
  pushl $0
80107a23:	6a 00                	push   $0x0
  pushl $175
80107a25:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107a2a:	e9 29 f3 ff ff       	jmp    80106d58 <alltraps>

80107a2f <vector176>:
.globl vector176
vector176:
  pushl $0
80107a2f:	6a 00                	push   $0x0
  pushl $176
80107a31:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80107a36:	e9 1d f3 ff ff       	jmp    80106d58 <alltraps>

80107a3b <vector177>:
.globl vector177
vector177:
  pushl $0
80107a3b:	6a 00                	push   $0x0
  pushl $177
80107a3d:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80107a42:	e9 11 f3 ff ff       	jmp    80106d58 <alltraps>

80107a47 <vector178>:
.globl vector178
vector178:
  pushl $0
80107a47:	6a 00                	push   $0x0
  pushl $178
80107a49:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107a4e:	e9 05 f3 ff ff       	jmp    80106d58 <alltraps>

80107a53 <vector179>:
.globl vector179
vector179:
  pushl $0
80107a53:	6a 00                	push   $0x0
  pushl $179
80107a55:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107a5a:	e9 f9 f2 ff ff       	jmp    80106d58 <alltraps>

80107a5f <vector180>:
.globl vector180
vector180:
  pushl $0
80107a5f:	6a 00                	push   $0x0
  pushl $180
80107a61:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80107a66:	e9 ed f2 ff ff       	jmp    80106d58 <alltraps>

80107a6b <vector181>:
.globl vector181
vector181:
  pushl $0
80107a6b:	6a 00                	push   $0x0
  pushl $181
80107a6d:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80107a72:	e9 e1 f2 ff ff       	jmp    80106d58 <alltraps>

80107a77 <vector182>:
.globl vector182
vector182:
  pushl $0
80107a77:	6a 00                	push   $0x0
  pushl $182
80107a79:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107a7e:	e9 d5 f2 ff ff       	jmp    80106d58 <alltraps>

80107a83 <vector183>:
.globl vector183
vector183:
  pushl $0
80107a83:	6a 00                	push   $0x0
  pushl $183
80107a85:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107a8a:	e9 c9 f2 ff ff       	jmp    80106d58 <alltraps>

80107a8f <vector184>:
.globl vector184
vector184:
  pushl $0
80107a8f:	6a 00                	push   $0x0
  pushl $184
80107a91:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80107a96:	e9 bd f2 ff ff       	jmp    80106d58 <alltraps>

80107a9b <vector185>:
.globl vector185
vector185:
  pushl $0
80107a9b:	6a 00                	push   $0x0
  pushl $185
80107a9d:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80107aa2:	e9 b1 f2 ff ff       	jmp    80106d58 <alltraps>

80107aa7 <vector186>:
.globl vector186
vector186:
  pushl $0
80107aa7:	6a 00                	push   $0x0
  pushl $186
80107aa9:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107aae:	e9 a5 f2 ff ff       	jmp    80106d58 <alltraps>

80107ab3 <vector187>:
.globl vector187
vector187:
  pushl $0
80107ab3:	6a 00                	push   $0x0
  pushl $187
80107ab5:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107aba:	e9 99 f2 ff ff       	jmp    80106d58 <alltraps>

80107abf <vector188>:
.globl vector188
vector188:
  pushl $0
80107abf:	6a 00                	push   $0x0
  pushl $188
80107ac1:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107ac6:	e9 8d f2 ff ff       	jmp    80106d58 <alltraps>

80107acb <vector189>:
.globl vector189
vector189:
  pushl $0
80107acb:	6a 00                	push   $0x0
  pushl $189
80107acd:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80107ad2:	e9 81 f2 ff ff       	jmp    80106d58 <alltraps>

80107ad7 <vector190>:
.globl vector190
vector190:
  pushl $0
80107ad7:	6a 00                	push   $0x0
  pushl $190
80107ad9:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107ade:	e9 75 f2 ff ff       	jmp    80106d58 <alltraps>

80107ae3 <vector191>:
.globl vector191
vector191:
  pushl $0
80107ae3:	6a 00                	push   $0x0
  pushl $191
80107ae5:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107aea:	e9 69 f2 ff ff       	jmp    80106d58 <alltraps>

80107aef <vector192>:
.globl vector192
vector192:
  pushl $0
80107aef:	6a 00                	push   $0x0
  pushl $192
80107af1:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107af6:	e9 5d f2 ff ff       	jmp    80106d58 <alltraps>

80107afb <vector193>:
.globl vector193
vector193:
  pushl $0
80107afb:	6a 00                	push   $0x0
  pushl $193
80107afd:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80107b02:	e9 51 f2 ff ff       	jmp    80106d58 <alltraps>

80107b07 <vector194>:
.globl vector194
vector194:
  pushl $0
80107b07:	6a 00                	push   $0x0
  pushl $194
80107b09:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107b0e:	e9 45 f2 ff ff       	jmp    80106d58 <alltraps>

80107b13 <vector195>:
.globl vector195
vector195:
  pushl $0
80107b13:	6a 00                	push   $0x0
  pushl $195
80107b15:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107b1a:	e9 39 f2 ff ff       	jmp    80106d58 <alltraps>

80107b1f <vector196>:
.globl vector196
vector196:
  pushl $0
80107b1f:	6a 00                	push   $0x0
  pushl $196
80107b21:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107b26:	e9 2d f2 ff ff       	jmp    80106d58 <alltraps>

80107b2b <vector197>:
.globl vector197
vector197:
  pushl $0
80107b2b:	6a 00                	push   $0x0
  pushl $197
80107b2d:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80107b32:	e9 21 f2 ff ff       	jmp    80106d58 <alltraps>

80107b37 <vector198>:
.globl vector198
vector198:
  pushl $0
80107b37:	6a 00                	push   $0x0
  pushl $198
80107b39:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107b3e:	e9 15 f2 ff ff       	jmp    80106d58 <alltraps>

80107b43 <vector199>:
.globl vector199
vector199:
  pushl $0
80107b43:	6a 00                	push   $0x0
  pushl $199
80107b45:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107b4a:	e9 09 f2 ff ff       	jmp    80106d58 <alltraps>

80107b4f <vector200>:
.globl vector200
vector200:
  pushl $0
80107b4f:	6a 00                	push   $0x0
  pushl $200
80107b51:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107b56:	e9 fd f1 ff ff       	jmp    80106d58 <alltraps>

80107b5b <vector201>:
.globl vector201
vector201:
  pushl $0
80107b5b:	6a 00                	push   $0x0
  pushl $201
80107b5d:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80107b62:	e9 f1 f1 ff ff       	jmp    80106d58 <alltraps>

80107b67 <vector202>:
.globl vector202
vector202:
  pushl $0
80107b67:	6a 00                	push   $0x0
  pushl $202
80107b69:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107b6e:	e9 e5 f1 ff ff       	jmp    80106d58 <alltraps>

80107b73 <vector203>:
.globl vector203
vector203:
  pushl $0
80107b73:	6a 00                	push   $0x0
  pushl $203
80107b75:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107b7a:	e9 d9 f1 ff ff       	jmp    80106d58 <alltraps>

80107b7f <vector204>:
.globl vector204
vector204:
  pushl $0
80107b7f:	6a 00                	push   $0x0
  pushl $204
80107b81:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107b86:	e9 cd f1 ff ff       	jmp    80106d58 <alltraps>

80107b8b <vector205>:
.globl vector205
vector205:
  pushl $0
80107b8b:	6a 00                	push   $0x0
  pushl $205
80107b8d:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80107b92:	e9 c1 f1 ff ff       	jmp    80106d58 <alltraps>

80107b97 <vector206>:
.globl vector206
vector206:
  pushl $0
80107b97:	6a 00                	push   $0x0
  pushl $206
80107b99:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107b9e:	e9 b5 f1 ff ff       	jmp    80106d58 <alltraps>

80107ba3 <vector207>:
.globl vector207
vector207:
  pushl $0
80107ba3:	6a 00                	push   $0x0
  pushl $207
80107ba5:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107baa:	e9 a9 f1 ff ff       	jmp    80106d58 <alltraps>

80107baf <vector208>:
.globl vector208
vector208:
  pushl $0
80107baf:	6a 00                	push   $0x0
  pushl $208
80107bb1:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107bb6:	e9 9d f1 ff ff       	jmp    80106d58 <alltraps>

80107bbb <vector209>:
.globl vector209
vector209:
  pushl $0
80107bbb:	6a 00                	push   $0x0
  pushl $209
80107bbd:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80107bc2:	e9 91 f1 ff ff       	jmp    80106d58 <alltraps>

80107bc7 <vector210>:
.globl vector210
vector210:
  pushl $0
80107bc7:	6a 00                	push   $0x0
  pushl $210
80107bc9:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107bce:	e9 85 f1 ff ff       	jmp    80106d58 <alltraps>

80107bd3 <vector211>:
.globl vector211
vector211:
  pushl $0
80107bd3:	6a 00                	push   $0x0
  pushl $211
80107bd5:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107bda:	e9 79 f1 ff ff       	jmp    80106d58 <alltraps>

80107bdf <vector212>:
.globl vector212
vector212:
  pushl $0
80107bdf:	6a 00                	push   $0x0
  pushl $212
80107be1:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107be6:	e9 6d f1 ff ff       	jmp    80106d58 <alltraps>

80107beb <vector213>:
.globl vector213
vector213:
  pushl $0
80107beb:	6a 00                	push   $0x0
  pushl $213
80107bed:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107bf2:	e9 61 f1 ff ff       	jmp    80106d58 <alltraps>

80107bf7 <vector214>:
.globl vector214
vector214:
  pushl $0
80107bf7:	6a 00                	push   $0x0
  pushl $214
80107bf9:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107bfe:	e9 55 f1 ff ff       	jmp    80106d58 <alltraps>

80107c03 <vector215>:
.globl vector215
vector215:
  pushl $0
80107c03:	6a 00                	push   $0x0
  pushl $215
80107c05:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107c0a:	e9 49 f1 ff ff       	jmp    80106d58 <alltraps>

80107c0f <vector216>:
.globl vector216
vector216:
  pushl $0
80107c0f:	6a 00                	push   $0x0
  pushl $216
80107c11:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107c16:	e9 3d f1 ff ff       	jmp    80106d58 <alltraps>

80107c1b <vector217>:
.globl vector217
vector217:
  pushl $0
80107c1b:	6a 00                	push   $0x0
  pushl $217
80107c1d:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80107c22:	e9 31 f1 ff ff       	jmp    80106d58 <alltraps>

80107c27 <vector218>:
.globl vector218
vector218:
  pushl $0
80107c27:	6a 00                	push   $0x0
  pushl $218
80107c29:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107c2e:	e9 25 f1 ff ff       	jmp    80106d58 <alltraps>

80107c33 <vector219>:
.globl vector219
vector219:
  pushl $0
80107c33:	6a 00                	push   $0x0
  pushl $219
80107c35:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107c3a:	e9 19 f1 ff ff       	jmp    80106d58 <alltraps>

80107c3f <vector220>:
.globl vector220
vector220:
  pushl $0
80107c3f:	6a 00                	push   $0x0
  pushl $220
80107c41:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107c46:	e9 0d f1 ff ff       	jmp    80106d58 <alltraps>

80107c4b <vector221>:
.globl vector221
vector221:
  pushl $0
80107c4b:	6a 00                	push   $0x0
  pushl $221
80107c4d:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80107c52:	e9 01 f1 ff ff       	jmp    80106d58 <alltraps>

80107c57 <vector222>:
.globl vector222
vector222:
  pushl $0
80107c57:	6a 00                	push   $0x0
  pushl $222
80107c59:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107c5e:	e9 f5 f0 ff ff       	jmp    80106d58 <alltraps>

80107c63 <vector223>:
.globl vector223
vector223:
  pushl $0
80107c63:	6a 00                	push   $0x0
  pushl $223
80107c65:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107c6a:	e9 e9 f0 ff ff       	jmp    80106d58 <alltraps>

80107c6f <vector224>:
.globl vector224
vector224:
  pushl $0
80107c6f:	6a 00                	push   $0x0
  pushl $224
80107c71:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107c76:	e9 dd f0 ff ff       	jmp    80106d58 <alltraps>

80107c7b <vector225>:
.globl vector225
vector225:
  pushl $0
80107c7b:	6a 00                	push   $0x0
  pushl $225
80107c7d:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80107c82:	e9 d1 f0 ff ff       	jmp    80106d58 <alltraps>

80107c87 <vector226>:
.globl vector226
vector226:
  pushl $0
80107c87:	6a 00                	push   $0x0
  pushl $226
80107c89:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107c8e:	e9 c5 f0 ff ff       	jmp    80106d58 <alltraps>

80107c93 <vector227>:
.globl vector227
vector227:
  pushl $0
80107c93:	6a 00                	push   $0x0
  pushl $227
80107c95:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107c9a:	e9 b9 f0 ff ff       	jmp    80106d58 <alltraps>

80107c9f <vector228>:
.globl vector228
vector228:
  pushl $0
80107c9f:	6a 00                	push   $0x0
  pushl $228
80107ca1:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107ca6:	e9 ad f0 ff ff       	jmp    80106d58 <alltraps>

80107cab <vector229>:
.globl vector229
vector229:
  pushl $0
80107cab:	6a 00                	push   $0x0
  pushl $229
80107cad:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80107cb2:	e9 a1 f0 ff ff       	jmp    80106d58 <alltraps>

80107cb7 <vector230>:
.globl vector230
vector230:
  pushl $0
80107cb7:	6a 00                	push   $0x0
  pushl $230
80107cb9:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107cbe:	e9 95 f0 ff ff       	jmp    80106d58 <alltraps>

80107cc3 <vector231>:
.globl vector231
vector231:
  pushl $0
80107cc3:	6a 00                	push   $0x0
  pushl $231
80107cc5:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107cca:	e9 89 f0 ff ff       	jmp    80106d58 <alltraps>

80107ccf <vector232>:
.globl vector232
vector232:
  pushl $0
80107ccf:	6a 00                	push   $0x0
  pushl $232
80107cd1:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107cd6:	e9 7d f0 ff ff       	jmp    80106d58 <alltraps>

80107cdb <vector233>:
.globl vector233
vector233:
  pushl $0
80107cdb:	6a 00                	push   $0x0
  pushl $233
80107cdd:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107ce2:	e9 71 f0 ff ff       	jmp    80106d58 <alltraps>

80107ce7 <vector234>:
.globl vector234
vector234:
  pushl $0
80107ce7:	6a 00                	push   $0x0
  pushl $234
80107ce9:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107cee:	e9 65 f0 ff ff       	jmp    80106d58 <alltraps>

80107cf3 <vector235>:
.globl vector235
vector235:
  pushl $0
80107cf3:	6a 00                	push   $0x0
  pushl $235
80107cf5:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107cfa:	e9 59 f0 ff ff       	jmp    80106d58 <alltraps>

80107cff <vector236>:
.globl vector236
vector236:
  pushl $0
80107cff:	6a 00                	push   $0x0
  pushl $236
80107d01:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107d06:	e9 4d f0 ff ff       	jmp    80106d58 <alltraps>

80107d0b <vector237>:
.globl vector237
vector237:
  pushl $0
80107d0b:	6a 00                	push   $0x0
  pushl $237
80107d0d:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107d12:	e9 41 f0 ff ff       	jmp    80106d58 <alltraps>

80107d17 <vector238>:
.globl vector238
vector238:
  pushl $0
80107d17:	6a 00                	push   $0x0
  pushl $238
80107d19:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107d1e:	e9 35 f0 ff ff       	jmp    80106d58 <alltraps>

80107d23 <vector239>:
.globl vector239
vector239:
  pushl $0
80107d23:	6a 00                	push   $0x0
  pushl $239
80107d25:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107d2a:	e9 29 f0 ff ff       	jmp    80106d58 <alltraps>

80107d2f <vector240>:
.globl vector240
vector240:
  pushl $0
80107d2f:	6a 00                	push   $0x0
  pushl $240
80107d31:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107d36:	e9 1d f0 ff ff       	jmp    80106d58 <alltraps>

80107d3b <vector241>:
.globl vector241
vector241:
  pushl $0
80107d3b:	6a 00                	push   $0x0
  pushl $241
80107d3d:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80107d42:	e9 11 f0 ff ff       	jmp    80106d58 <alltraps>

80107d47 <vector242>:
.globl vector242
vector242:
  pushl $0
80107d47:	6a 00                	push   $0x0
  pushl $242
80107d49:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107d4e:	e9 05 f0 ff ff       	jmp    80106d58 <alltraps>

80107d53 <vector243>:
.globl vector243
vector243:
  pushl $0
80107d53:	6a 00                	push   $0x0
  pushl $243
80107d55:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107d5a:	e9 f9 ef ff ff       	jmp    80106d58 <alltraps>

80107d5f <vector244>:
.globl vector244
vector244:
  pushl $0
80107d5f:	6a 00                	push   $0x0
  pushl $244
80107d61:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107d66:	e9 ed ef ff ff       	jmp    80106d58 <alltraps>

80107d6b <vector245>:
.globl vector245
vector245:
  pushl $0
80107d6b:	6a 00                	push   $0x0
  pushl $245
80107d6d:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80107d72:	e9 e1 ef ff ff       	jmp    80106d58 <alltraps>

80107d77 <vector246>:
.globl vector246
vector246:
  pushl $0
80107d77:	6a 00                	push   $0x0
  pushl $246
80107d79:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107d7e:	e9 d5 ef ff ff       	jmp    80106d58 <alltraps>

80107d83 <vector247>:
.globl vector247
vector247:
  pushl $0
80107d83:	6a 00                	push   $0x0
  pushl $247
80107d85:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107d8a:	e9 c9 ef ff ff       	jmp    80106d58 <alltraps>

80107d8f <vector248>:
.globl vector248
vector248:
  pushl $0
80107d8f:	6a 00                	push   $0x0
  pushl $248
80107d91:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107d96:	e9 bd ef ff ff       	jmp    80106d58 <alltraps>

80107d9b <vector249>:
.globl vector249
vector249:
  pushl $0
80107d9b:	6a 00                	push   $0x0
  pushl $249
80107d9d:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80107da2:	e9 b1 ef ff ff       	jmp    80106d58 <alltraps>

80107da7 <vector250>:
.globl vector250
vector250:
  pushl $0
80107da7:	6a 00                	push   $0x0
  pushl $250
80107da9:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107dae:	e9 a5 ef ff ff       	jmp    80106d58 <alltraps>

80107db3 <vector251>:
.globl vector251
vector251:
  pushl $0
80107db3:	6a 00                	push   $0x0
  pushl $251
80107db5:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107dba:	e9 99 ef ff ff       	jmp    80106d58 <alltraps>

80107dbf <vector252>:
.globl vector252
vector252:
  pushl $0
80107dbf:	6a 00                	push   $0x0
  pushl $252
80107dc1:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107dc6:	e9 8d ef ff ff       	jmp    80106d58 <alltraps>

80107dcb <vector253>:
.globl vector253
vector253:
  pushl $0
80107dcb:	6a 00                	push   $0x0
  pushl $253
80107dcd:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107dd2:	e9 81 ef ff ff       	jmp    80106d58 <alltraps>

80107dd7 <vector254>:
.globl vector254
vector254:
  pushl $0
80107dd7:	6a 00                	push   $0x0
  pushl $254
80107dd9:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107dde:	e9 75 ef ff ff       	jmp    80106d58 <alltraps>

80107de3 <vector255>:
.globl vector255
vector255:
  pushl $0
80107de3:	6a 00                	push   $0x0
  pushl $255
80107de5:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107dea:	e9 69 ef ff ff       	jmp    80106d58 <alltraps>

80107def <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
80107def:	55                   	push   %ebp
80107df0:	89 e5                	mov    %esp,%ebp
80107df2:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80107df5:	8b 45 0c             	mov    0xc(%ebp),%eax
80107df8:	83 e8 01             	sub    $0x1,%eax
80107dfb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107dff:	8b 45 08             	mov    0x8(%ebp),%eax
80107e02:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107e06:	8b 45 08             	mov    0x8(%ebp),%eax
80107e09:	c1 e8 10             	shr    $0x10,%eax
80107e0c:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80107e10:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107e13:	0f 01 10             	lgdtl  (%eax)
}
80107e16:	90                   	nop
80107e17:	c9                   	leave  
80107e18:	c3                   	ret    

80107e19 <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80107e19:	55                   	push   %ebp
80107e1a:	89 e5                	mov    %esp,%ebp
80107e1c:	83 ec 04             	sub    $0x4,%esp
80107e1f:	8b 45 08             	mov    0x8(%ebp),%eax
80107e22:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107e26:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107e2a:	0f 00 d8             	ltr    %ax
}
80107e2d:	90                   	nop
80107e2e:	c9                   	leave  
80107e2f:	c3                   	ret    

80107e30 <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
80107e30:	55                   	push   %ebp
80107e31:	89 e5                	mov    %esp,%ebp
80107e33:	83 ec 04             	sub    $0x4,%esp
80107e36:	8b 45 08             	mov    0x8(%ebp),%eax
80107e39:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80107e3d:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107e41:	8e e8                	mov    %eax,%gs
}
80107e43:	90                   	nop
80107e44:	c9                   	leave  
80107e45:	c3                   	ret    

80107e46 <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
80107e46:	55                   	push   %ebp
80107e47:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107e49:	8b 45 08             	mov    0x8(%ebp),%eax
80107e4c:	0f 22 d8             	mov    %eax,%cr3
}
80107e4f:	90                   	nop
80107e50:	5d                   	pop    %ebp
80107e51:	c3                   	ret    

80107e52 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80107e52:	55                   	push   %ebp
80107e53:	89 e5                	mov    %esp,%ebp
80107e55:	8b 45 08             	mov    0x8(%ebp),%eax
80107e58:	05 00 00 00 80       	add    $0x80000000,%eax
80107e5d:	5d                   	pop    %ebp
80107e5e:	c3                   	ret    

80107e5f <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80107e5f:	55                   	push   %ebp
80107e60:	89 e5                	mov    %esp,%ebp
80107e62:	8b 45 08             	mov    0x8(%ebp),%eax
80107e65:	05 00 00 00 80       	add    $0x80000000,%eax
80107e6a:	5d                   	pop    %ebp
80107e6b:	c3                   	ret    

80107e6c <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107e6c:	55                   	push   %ebp
80107e6d:	89 e5                	mov    %esp,%ebp
80107e6f:	53                   	push   %ebx
80107e70:	83 ec 14             	sub    $0x14,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80107e73:	e8 2e b1 ff ff       	call   80102fa6 <cpunum>
80107e78:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80107e7e:	05 80 33 11 80       	add    $0x80113380,%eax
80107e83:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107e86:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e89:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80107e8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e92:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80107e98:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e9b:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80107e9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ea2:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107ea6:	83 e2 f0             	and    $0xfffffff0,%edx
80107ea9:	83 ca 0a             	or     $0xa,%edx
80107eac:	88 50 7d             	mov    %dl,0x7d(%eax)
80107eaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107eb2:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107eb6:	83 ca 10             	or     $0x10,%edx
80107eb9:	88 50 7d             	mov    %dl,0x7d(%eax)
80107ebc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ebf:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107ec3:	83 e2 9f             	and    $0xffffff9f,%edx
80107ec6:	88 50 7d             	mov    %dl,0x7d(%eax)
80107ec9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ecc:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107ed0:	83 ca 80             	or     $0xffffff80,%edx
80107ed3:	88 50 7d             	mov    %dl,0x7d(%eax)
80107ed6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ed9:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107edd:	83 ca 0f             	or     $0xf,%edx
80107ee0:	88 50 7e             	mov    %dl,0x7e(%eax)
80107ee3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ee6:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107eea:	83 e2 ef             	and    $0xffffffef,%edx
80107eed:	88 50 7e             	mov    %dl,0x7e(%eax)
80107ef0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ef3:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107ef7:	83 e2 df             	and    $0xffffffdf,%edx
80107efa:	88 50 7e             	mov    %dl,0x7e(%eax)
80107efd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f00:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107f04:	83 ca 40             	or     $0x40,%edx
80107f07:	88 50 7e             	mov    %dl,0x7e(%eax)
80107f0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f0d:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107f11:	83 ca 80             	or     $0xffffff80,%edx
80107f14:	88 50 7e             	mov    %dl,0x7e(%eax)
80107f17:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f1a:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107f1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f21:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107f28:	ff ff 
80107f2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f2d:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80107f34:	00 00 
80107f36:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f39:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107f40:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f43:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107f4a:	83 e2 f0             	and    $0xfffffff0,%edx
80107f4d:	83 ca 02             	or     $0x2,%edx
80107f50:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107f56:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f59:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107f60:	83 ca 10             	or     $0x10,%edx
80107f63:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107f69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f6c:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107f73:	83 e2 9f             	and    $0xffffff9f,%edx
80107f76:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107f7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f7f:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107f86:	83 ca 80             	or     $0xffffff80,%edx
80107f89:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107f8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f92:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107f99:	83 ca 0f             	or     $0xf,%edx
80107f9c:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107fa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fa5:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107fac:	83 e2 ef             	and    $0xffffffef,%edx
80107faf:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107fb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fb8:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107fbf:	83 e2 df             	and    $0xffffffdf,%edx
80107fc2:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107fc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fcb:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107fd2:	83 ca 40             	or     $0x40,%edx
80107fd5:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107fdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fde:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107fe5:	83 ca 80             	or     $0xffffff80,%edx
80107fe8:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107fee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ff1:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107ff8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ffb:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80108002:	ff ff 
80108004:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108007:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
8010800e:	00 00 
80108010:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108013:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
8010801a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010801d:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108024:	83 e2 f0             	and    $0xfffffff0,%edx
80108027:	83 ca 0a             	or     $0xa,%edx
8010802a:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108030:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108033:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010803a:	83 ca 10             	or     $0x10,%edx
8010803d:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108043:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108046:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010804d:	83 ca 60             	or     $0x60,%edx
80108050:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108056:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108059:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108060:	83 ca 80             	or     $0xffffff80,%edx
80108063:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108069:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010806c:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108073:	83 ca 0f             	or     $0xf,%edx
80108076:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010807c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010807f:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108086:	83 e2 ef             	and    $0xffffffef,%edx
80108089:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010808f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108092:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108099:	83 e2 df             	and    $0xffffffdf,%edx
8010809c:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801080a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080a5:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801080ac:	83 ca 40             	or     $0x40,%edx
801080af:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801080b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080b8:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801080bf:	83 ca 80             	or     $0xffffff80,%edx
801080c2:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801080c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080cb:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801080d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080d5:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
801080dc:	ff ff 
801080de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080e1:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
801080e8:	00 00 
801080ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080ed:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
801080f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080f7:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801080fe:	83 e2 f0             	and    $0xfffffff0,%edx
80108101:	83 ca 02             	or     $0x2,%edx
80108104:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
8010810a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010810d:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108114:	83 ca 10             	or     $0x10,%edx
80108117:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
8010811d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108120:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108127:	83 ca 60             	or     $0x60,%edx
8010812a:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108130:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108133:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
8010813a:	83 ca 80             	or     $0xffffff80,%edx
8010813d:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108143:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108146:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
8010814d:	83 ca 0f             	or     $0xf,%edx
80108150:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108156:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108159:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108160:	83 e2 ef             	and    $0xffffffef,%edx
80108163:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108169:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010816c:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108173:	83 e2 df             	and    $0xffffffdf,%edx
80108176:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010817c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010817f:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108186:	83 ca 40             	or     $0x40,%edx
80108189:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010818f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108192:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108199:	83 ca 80             	or     $0xffffff80,%edx
8010819c:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801081a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081a5:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
801081ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081af:	05 b4 00 00 00       	add    $0xb4,%eax
801081b4:	89 c3                	mov    %eax,%ebx
801081b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081b9:	05 b4 00 00 00       	add    $0xb4,%eax
801081be:	c1 e8 10             	shr    $0x10,%eax
801081c1:	89 c2                	mov    %eax,%edx
801081c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081c6:	05 b4 00 00 00       	add    $0xb4,%eax
801081cb:	c1 e8 18             	shr    $0x18,%eax
801081ce:	89 c1                	mov    %eax,%ecx
801081d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081d3:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
801081da:	00 00 
801081dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081df:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
801081e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081e9:	88 90 8c 00 00 00    	mov    %dl,0x8c(%eax)
801081ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081f2:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801081f9:	83 e2 f0             	and    $0xfffffff0,%edx
801081fc:	83 ca 02             	or     $0x2,%edx
801081ff:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108205:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108208:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
8010820f:	83 ca 10             	or     $0x10,%edx
80108212:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108218:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010821b:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108222:	83 e2 9f             	and    $0xffffff9f,%edx
80108225:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
8010822b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010822e:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108235:	83 ca 80             	or     $0xffffff80,%edx
80108238:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
8010823e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108241:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108248:	83 e2 f0             	and    $0xfffffff0,%edx
8010824b:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108251:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108254:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010825b:	83 e2 ef             	and    $0xffffffef,%edx
8010825e:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108264:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108267:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010826e:	83 e2 df             	and    $0xffffffdf,%edx
80108271:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108277:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010827a:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108281:	83 ca 40             	or     $0x40,%edx
80108284:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010828a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010828d:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108294:	83 ca 80             	or     $0xffffff80,%edx
80108297:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010829d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082a0:	88 88 8f 00 00 00    	mov    %cl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
801082a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082a9:	83 c0 70             	add    $0x70,%eax
801082ac:	83 ec 08             	sub    $0x8,%esp
801082af:	6a 38                	push   $0x38
801082b1:	50                   	push   %eax
801082b2:	e8 38 fb ff ff       	call   80107def <lgdt>
801082b7:	83 c4 10             	add    $0x10,%esp
  loadgs(SEG_KCPU << 3);
801082ba:	83 ec 0c             	sub    $0xc,%esp
801082bd:	6a 18                	push   $0x18
801082bf:	e8 6c fb ff ff       	call   80107e30 <loadgs>
801082c4:	83 c4 10             	add    $0x10,%esp
  
  // Initialize cpu-local storage.
  cpu = c;
801082c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082ca:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
801082d0:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
801082d7:	00 00 00 00 
}
801082db:	90                   	nop
801082dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801082df:	c9                   	leave  
801082e0:	c3                   	ret    

801082e1 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801082e1:	55                   	push   %ebp
801082e2:	89 e5                	mov    %esp,%ebp
801082e4:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801082e7:	8b 45 0c             	mov    0xc(%ebp),%eax
801082ea:	c1 e8 16             	shr    $0x16,%eax
801082ed:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801082f4:	8b 45 08             	mov    0x8(%ebp),%eax
801082f7:	01 d0                	add    %edx,%eax
801082f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
801082fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801082ff:	8b 00                	mov    (%eax),%eax
80108301:	83 e0 01             	and    $0x1,%eax
80108304:	85 c0                	test   %eax,%eax
80108306:	74 18                	je     80108320 <walkpgdir+0x3f>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
80108308:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010830b:	8b 00                	mov    (%eax),%eax
8010830d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108312:	50                   	push   %eax
80108313:	e8 47 fb ff ff       	call   80107e5f <p2v>
80108318:	83 c4 04             	add    $0x4,%esp
8010831b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010831e:	eb 48                	jmp    80108368 <walkpgdir+0x87>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80108320:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80108324:	74 0e                	je     80108334 <walkpgdir+0x53>
80108326:	e8 fe a8 ff ff       	call   80102c29 <kalloc>
8010832b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010832e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108332:	75 07                	jne    8010833b <walkpgdir+0x5a>
      return 0;
80108334:	b8 00 00 00 00       	mov    $0x0,%eax
80108339:	eb 44                	jmp    8010837f <walkpgdir+0x9e>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
8010833b:	83 ec 04             	sub    $0x4,%esp
8010833e:	68 00 10 00 00       	push   $0x1000
80108343:	6a 00                	push   $0x0
80108345:	ff 75 f4             	pushl  -0xc(%ebp)
80108348:	e8 86 d4 ff ff       	call   801057d3 <memset>
8010834d:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
80108350:	83 ec 0c             	sub    $0xc,%esp
80108353:	ff 75 f4             	pushl  -0xc(%ebp)
80108356:	e8 f7 fa ff ff       	call   80107e52 <v2p>
8010835b:	83 c4 10             	add    $0x10,%esp
8010835e:	83 c8 07             	or     $0x7,%eax
80108361:	89 c2                	mov    %eax,%edx
80108363:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108366:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80108368:	8b 45 0c             	mov    0xc(%ebp),%eax
8010836b:	c1 e8 0c             	shr    $0xc,%eax
8010836e:	25 ff 03 00 00       	and    $0x3ff,%eax
80108373:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010837a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010837d:	01 d0                	add    %edx,%eax
}
8010837f:	c9                   	leave  
80108380:	c3                   	ret    

80108381 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80108381:	55                   	push   %ebp
80108382:	89 e5                	mov    %esp,%ebp
80108384:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
80108387:	8b 45 0c             	mov    0xc(%ebp),%eax
8010838a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010838f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80108392:	8b 55 0c             	mov    0xc(%ebp),%edx
80108395:	8b 45 10             	mov    0x10(%ebp),%eax
80108398:	01 d0                	add    %edx,%eax
8010839a:	83 e8 01             	sub    $0x1,%eax
8010839d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801083a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801083a5:	83 ec 04             	sub    $0x4,%esp
801083a8:	6a 01                	push   $0x1
801083aa:	ff 75 f4             	pushl  -0xc(%ebp)
801083ad:	ff 75 08             	pushl  0x8(%ebp)
801083b0:	e8 2c ff ff ff       	call   801082e1 <walkpgdir>
801083b5:	83 c4 10             	add    $0x10,%esp
801083b8:	89 45 ec             	mov    %eax,-0x14(%ebp)
801083bb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801083bf:	75 07                	jne    801083c8 <mappages+0x47>
      return -1;
801083c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801083c6:	eb 5d                	jmp    80108425 <mappages+0xa4>
    if(*pte)
801083c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801083cb:	8b 00                	mov    (%eax),%eax
801083cd:	85 c0                	test   %eax,%eax
801083cf:	74 0d                	je     801083de <mappages+0x5d>
        panic("*pte is 0");
801083d1:	83 ec 0c             	sub    $0xc,%esp
801083d4:	68 c4 92 10 80       	push   $0x801092c4
801083d9:	e8 88 81 ff ff       	call   80100566 <panic>
    if(*pte & PTE_P)
801083de:	8b 45 ec             	mov    -0x14(%ebp),%eax
801083e1:	8b 00                	mov    (%eax),%eax
801083e3:	83 e0 01             	and    $0x1,%eax
801083e6:	85 c0                	test   %eax,%eax
801083e8:	74 0d                	je     801083f7 <mappages+0x76>
      panic("remap");
801083ea:	83 ec 0c             	sub    $0xc,%esp
801083ed:	68 ce 92 10 80       	push   $0x801092ce
801083f2:	e8 6f 81 ff ff       	call   80100566 <panic>
    *pte = pa | perm | PTE_P;
801083f7:	8b 45 18             	mov    0x18(%ebp),%eax
801083fa:	0b 45 14             	or     0x14(%ebp),%eax
801083fd:	83 c8 01             	or     $0x1,%eax
80108400:	89 c2                	mov    %eax,%edx
80108402:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108405:	89 10                	mov    %edx,(%eax)
    if(a == last)
80108407:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010840a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010840d:	74 10                	je     8010841f <mappages+0x9e>
      break;
    a += PGSIZE;
8010840f:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80108416:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
8010841d:	eb 86                	jmp    801083a5 <mappages+0x24>
        panic("*pte is 0");
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
8010841f:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80108420:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108425:	c9                   	leave  
80108426:	c3                   	ret    

80108427 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80108427:	55                   	push   %ebp
80108428:	89 e5                	mov    %esp,%ebp
8010842a:	53                   	push   %ebx
8010842b:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
8010842e:	e8 f6 a7 ff ff       	call   80102c29 <kalloc>
80108433:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108436:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010843a:	75 0a                	jne    80108446 <setupkvm+0x1f>
    return 0;
8010843c:	b8 00 00 00 00       	mov    $0x0,%eax
80108441:	e9 8e 00 00 00       	jmp    801084d4 <setupkvm+0xad>
  memset(pgdir, 0, PGSIZE);
80108446:	83 ec 04             	sub    $0x4,%esp
80108449:	68 00 10 00 00       	push   $0x1000
8010844e:	6a 00                	push   $0x0
80108450:	ff 75 f0             	pushl  -0x10(%ebp)
80108453:	e8 7b d3 ff ff       	call   801057d3 <memset>
80108458:	83 c4 10             	add    $0x10,%esp
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
8010845b:	83 ec 0c             	sub    $0xc,%esp
8010845e:	68 00 00 00 0e       	push   $0xe000000
80108463:	e8 f7 f9 ff ff       	call   80107e5f <p2v>
80108468:	83 c4 10             	add    $0x10,%esp
8010846b:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
80108470:	76 0d                	jbe    8010847f <setupkvm+0x58>
    panic("PHYSTOP too high");
80108472:	83 ec 0c             	sub    $0xc,%esp
80108475:	68 d4 92 10 80       	push   $0x801092d4
8010847a:	e8 e7 80 ff ff       	call   80100566 <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010847f:	c7 45 f4 c0 c4 10 80 	movl   $0x8010c4c0,-0xc(%ebp)
80108486:	eb 40                	jmp    801084c8 <setupkvm+0xa1>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80108488:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010848b:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0)
8010848e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108491:	8b 50 04             	mov    0x4(%eax),%edx
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80108494:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108497:	8b 58 08             	mov    0x8(%eax),%ebx
8010849a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010849d:	8b 40 04             	mov    0x4(%eax),%eax
801084a0:	29 c3                	sub    %eax,%ebx
801084a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084a5:	8b 00                	mov    (%eax),%eax
801084a7:	83 ec 0c             	sub    $0xc,%esp
801084aa:	51                   	push   %ecx
801084ab:	52                   	push   %edx
801084ac:	53                   	push   %ebx
801084ad:	50                   	push   %eax
801084ae:	ff 75 f0             	pushl  -0x10(%ebp)
801084b1:	e8 cb fe ff ff       	call   80108381 <mappages>
801084b6:	83 c4 20             	add    $0x20,%esp
801084b9:	85 c0                	test   %eax,%eax
801084bb:	79 07                	jns    801084c4 <setupkvm+0x9d>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
801084bd:	b8 00 00 00 00       	mov    $0x0,%eax
801084c2:	eb 10                	jmp    801084d4 <setupkvm+0xad>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801084c4:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801084c8:	81 7d f4 00 c5 10 80 	cmpl   $0x8010c500,-0xc(%ebp)
801084cf:	72 b7                	jb     80108488 <setupkvm+0x61>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
801084d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801084d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801084d7:	c9                   	leave  
801084d8:	c3                   	ret    

801084d9 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
801084d9:	55                   	push   %ebp
801084da:	89 e5                	mov    %esp,%ebp
801084dc:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801084df:	e8 43 ff ff ff       	call   80108427 <setupkvm>
801084e4:	a3 58 65 11 80       	mov    %eax,0x80116558
  switchkvm();
801084e9:	e8 03 00 00 00       	call   801084f1 <switchkvm>
}
801084ee:	90                   	nop
801084ef:	c9                   	leave  
801084f0:	c3                   	ret    

801084f1 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
801084f1:	55                   	push   %ebp
801084f2:	89 e5                	mov    %esp,%ebp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
801084f4:	a1 58 65 11 80       	mov    0x80116558,%eax
801084f9:	50                   	push   %eax
801084fa:	e8 53 f9 ff ff       	call   80107e52 <v2p>
801084ff:	83 c4 04             	add    $0x4,%esp
80108502:	50                   	push   %eax
80108503:	e8 3e f9 ff ff       	call   80107e46 <lcr3>
80108508:	83 c4 04             	add    $0x4,%esp
}
8010850b:	90                   	nop
8010850c:	c9                   	leave  
8010850d:	c3                   	ret    

8010850e <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
8010850e:	55                   	push   %ebp
8010850f:	89 e5                	mov    %esp,%ebp
80108511:	56                   	push   %esi
80108512:	53                   	push   %ebx
  pushcli();
80108513:	e8 b5 d1 ff ff       	call   801056cd <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80108518:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010851e:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80108525:	83 c2 08             	add    $0x8,%edx
80108528:	89 d6                	mov    %edx,%esi
8010852a:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80108531:	83 c2 08             	add    $0x8,%edx
80108534:	c1 ea 10             	shr    $0x10,%edx
80108537:	89 d3                	mov    %edx,%ebx
80108539:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80108540:	83 c2 08             	add    $0x8,%edx
80108543:	c1 ea 18             	shr    $0x18,%edx
80108546:	89 d1                	mov    %edx,%ecx
80108548:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
8010854f:	67 00 
80108551:	66 89 b0 a2 00 00 00 	mov    %si,0xa2(%eax)
80108558:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
8010855e:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108565:	83 e2 f0             	and    $0xfffffff0,%edx
80108568:	83 ca 09             	or     $0x9,%edx
8010856b:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80108571:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108578:	83 ca 10             	or     $0x10,%edx
8010857b:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80108581:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108588:	83 e2 9f             	and    $0xffffff9f,%edx
8010858b:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80108591:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108598:	83 ca 80             	or     $0xffffff80,%edx
8010859b:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801085a1:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801085a8:	83 e2 f0             	and    $0xfffffff0,%edx
801085ab:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801085b1:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801085b8:	83 e2 ef             	and    $0xffffffef,%edx
801085bb:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801085c1:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801085c8:	83 e2 df             	and    $0xffffffdf,%edx
801085cb:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801085d1:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801085d8:	83 ca 40             	or     $0x40,%edx
801085db:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801085e1:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801085e8:	83 e2 7f             	and    $0x7f,%edx
801085eb:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801085f1:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
801085f7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801085fd:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108604:	83 e2 ef             	and    $0xffffffef,%edx
80108607:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
8010860d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108613:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80108619:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010861f:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80108626:	8b 52 08             	mov    0x8(%edx),%edx
80108629:	81 c2 00 10 00 00    	add    $0x1000,%edx
8010862f:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
80108632:	83 ec 0c             	sub    $0xc,%esp
80108635:	6a 30                	push   $0x30
80108637:	e8 dd f7 ff ff       	call   80107e19 <ltr>
8010863c:	83 c4 10             	add    $0x10,%esp
  if(p->pgdir == 0)
8010863f:	8b 45 08             	mov    0x8(%ebp),%eax
80108642:	8b 40 04             	mov    0x4(%eax),%eax
80108645:	85 c0                	test   %eax,%eax
80108647:	75 0d                	jne    80108656 <switchuvm+0x148>
    panic("switchuvm: no pgdir");
80108649:	83 ec 0c             	sub    $0xc,%esp
8010864c:	68 e5 92 10 80       	push   $0x801092e5
80108651:	e8 10 7f ff ff       	call   80100566 <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
80108656:	8b 45 08             	mov    0x8(%ebp),%eax
80108659:	8b 40 04             	mov    0x4(%eax),%eax
8010865c:	83 ec 0c             	sub    $0xc,%esp
8010865f:	50                   	push   %eax
80108660:	e8 ed f7 ff ff       	call   80107e52 <v2p>
80108665:	83 c4 10             	add    $0x10,%esp
80108668:	83 ec 0c             	sub    $0xc,%esp
8010866b:	50                   	push   %eax
8010866c:	e8 d5 f7 ff ff       	call   80107e46 <lcr3>
80108671:	83 c4 10             	add    $0x10,%esp
  popcli();
80108674:	e8 99 d0 ff ff       	call   80105712 <popcli>
}
80108679:	90                   	nop
8010867a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010867d:	5b                   	pop    %ebx
8010867e:	5e                   	pop    %esi
8010867f:	5d                   	pop    %ebp
80108680:	c3                   	ret    

80108681 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80108681:	55                   	push   %ebp
80108682:	89 e5                	mov    %esp,%ebp
80108684:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  
  if(sz >= PGSIZE)
80108687:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
8010868e:	76 0d                	jbe    8010869d <inituvm+0x1c>
    panic("inituvm: more than a page");
80108690:	83 ec 0c             	sub    $0xc,%esp
80108693:	68 f9 92 10 80       	push   $0x801092f9
80108698:	e8 c9 7e ff ff       	call   80100566 <panic>
  mem = kalloc();
8010869d:	e8 87 a5 ff ff       	call   80102c29 <kalloc>
801086a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
801086a5:	83 ec 04             	sub    $0x4,%esp
801086a8:	68 00 10 00 00       	push   $0x1000
801086ad:	6a 00                	push   $0x0
801086af:	ff 75 f4             	pushl  -0xc(%ebp)
801086b2:	e8 1c d1 ff ff       	call   801057d3 <memset>
801086b7:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
801086ba:	83 ec 0c             	sub    $0xc,%esp
801086bd:	ff 75 f4             	pushl  -0xc(%ebp)
801086c0:	e8 8d f7 ff ff       	call   80107e52 <v2p>
801086c5:	83 c4 10             	add    $0x10,%esp
801086c8:	83 ec 0c             	sub    $0xc,%esp
801086cb:	6a 06                	push   $0x6
801086cd:	50                   	push   %eax
801086ce:	68 00 10 00 00       	push   $0x1000
801086d3:	6a 00                	push   $0x0
801086d5:	ff 75 08             	pushl  0x8(%ebp)
801086d8:	e8 a4 fc ff ff       	call   80108381 <mappages>
801086dd:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
801086e0:	83 ec 04             	sub    $0x4,%esp
801086e3:	ff 75 10             	pushl  0x10(%ebp)
801086e6:	ff 75 0c             	pushl  0xc(%ebp)
801086e9:	ff 75 f4             	pushl  -0xc(%ebp)
801086ec:	e8 a1 d1 ff ff       	call   80105892 <memmove>
801086f1:	83 c4 10             	add    $0x10,%esp
}
801086f4:	90                   	nop
801086f5:	c9                   	leave  
801086f6:	c3                   	ret    

801086f7 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
801086f7:	55                   	push   %ebp
801086f8:	89 e5                	mov    %esp,%ebp
801086fa:	53                   	push   %ebx
801086fb:	83 ec 14             	sub    $0x14,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
801086fe:	8b 45 0c             	mov    0xc(%ebp),%eax
80108701:	25 ff 0f 00 00       	and    $0xfff,%eax
80108706:	85 c0                	test   %eax,%eax
80108708:	74 0d                	je     80108717 <loaduvm+0x20>
    panic("loaduvm: addr must be page aligned");
8010870a:	83 ec 0c             	sub    $0xc,%esp
8010870d:	68 14 93 10 80       	push   $0x80109314
80108712:	e8 4f 7e ff ff       	call   80100566 <panic>
  for(i = 0; i < sz; i += PGSIZE){
80108717:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010871e:	e9 95 00 00 00       	jmp    801087b8 <loaduvm+0xc1>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80108723:	8b 55 0c             	mov    0xc(%ebp),%edx
80108726:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108729:	01 d0                	add    %edx,%eax
8010872b:	83 ec 04             	sub    $0x4,%esp
8010872e:	6a 00                	push   $0x0
80108730:	50                   	push   %eax
80108731:	ff 75 08             	pushl  0x8(%ebp)
80108734:	e8 a8 fb ff ff       	call   801082e1 <walkpgdir>
80108739:	83 c4 10             	add    $0x10,%esp
8010873c:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010873f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108743:	75 0d                	jne    80108752 <loaduvm+0x5b>
      panic("loaduvm: address should exist");
80108745:	83 ec 0c             	sub    $0xc,%esp
80108748:	68 37 93 10 80       	push   $0x80109337
8010874d:	e8 14 7e ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
80108752:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108755:	8b 00                	mov    (%eax),%eax
80108757:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010875c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
8010875f:	8b 45 18             	mov    0x18(%ebp),%eax
80108762:	2b 45 f4             	sub    -0xc(%ebp),%eax
80108765:	3d ff 0f 00 00       	cmp    $0xfff,%eax
8010876a:	77 0b                	ja     80108777 <loaduvm+0x80>
      n = sz - i;
8010876c:	8b 45 18             	mov    0x18(%ebp),%eax
8010876f:	2b 45 f4             	sub    -0xc(%ebp),%eax
80108772:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108775:	eb 07                	jmp    8010877e <loaduvm+0x87>
    else
      n = PGSIZE;
80108777:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
8010877e:	8b 55 14             	mov    0x14(%ebp),%edx
80108781:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108784:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80108787:	83 ec 0c             	sub    $0xc,%esp
8010878a:	ff 75 e8             	pushl  -0x18(%ebp)
8010878d:	e8 cd f6 ff ff       	call   80107e5f <p2v>
80108792:	83 c4 10             	add    $0x10,%esp
80108795:	ff 75 f0             	pushl  -0x10(%ebp)
80108798:	53                   	push   %ebx
80108799:	50                   	push   %eax
8010879a:	ff 75 10             	pushl  0x10(%ebp)
8010879d:	e8 ec 96 ff ff       	call   80101e8e <readi>
801087a2:	83 c4 10             	add    $0x10,%esp
801087a5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801087a8:	74 07                	je     801087b1 <loaduvm+0xba>
      return -1;
801087aa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801087af:	eb 18                	jmp    801087c9 <loaduvm+0xd2>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
801087b1:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801087b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087bb:	3b 45 18             	cmp    0x18(%ebp),%eax
801087be:	0f 82 5f ff ff ff    	jb     80108723 <loaduvm+0x2c>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
801087c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
801087c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801087cc:	c9                   	leave  
801087cd:	c3                   	ret    

801087ce <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801087ce:	55                   	push   %ebp
801087cf:	89 e5                	mov    %esp,%ebp
801087d1:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
801087d4:	8b 45 10             	mov    0x10(%ebp),%eax
801087d7:	85 c0                	test   %eax,%eax
801087d9:	79 0a                	jns    801087e5 <allocuvm+0x17>
    return 0;
801087db:	b8 00 00 00 00       	mov    $0x0,%eax
801087e0:	e9 b0 00 00 00       	jmp    80108895 <allocuvm+0xc7>
  if(newsz < oldsz)
801087e5:	8b 45 10             	mov    0x10(%ebp),%eax
801087e8:	3b 45 0c             	cmp    0xc(%ebp),%eax
801087eb:	73 08                	jae    801087f5 <allocuvm+0x27>
    return oldsz;
801087ed:	8b 45 0c             	mov    0xc(%ebp),%eax
801087f0:	e9 a0 00 00 00       	jmp    80108895 <allocuvm+0xc7>

  a = PGROUNDUP(oldsz);
801087f5:	8b 45 0c             	mov    0xc(%ebp),%eax
801087f8:	05 ff 0f 00 00       	add    $0xfff,%eax
801087fd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108802:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80108805:	eb 7f                	jmp    80108886 <allocuvm+0xb8>
    mem = kalloc();
80108807:	e8 1d a4 ff ff       	call   80102c29 <kalloc>
8010880c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
8010880f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108813:	75 2b                	jne    80108840 <allocuvm+0x72>
      cprintf("allocuvm out of memory\n");
80108815:	83 ec 0c             	sub    $0xc,%esp
80108818:	68 55 93 10 80       	push   $0x80109355
8010881d:	e8 a4 7b ff ff       	call   801003c6 <cprintf>
80108822:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
80108825:	83 ec 04             	sub    $0x4,%esp
80108828:	ff 75 0c             	pushl  0xc(%ebp)
8010882b:	ff 75 10             	pushl  0x10(%ebp)
8010882e:	ff 75 08             	pushl  0x8(%ebp)
80108831:	e8 61 00 00 00       	call   80108897 <deallocuvm>
80108836:	83 c4 10             	add    $0x10,%esp
      return 0;
80108839:	b8 00 00 00 00       	mov    $0x0,%eax
8010883e:	eb 55                	jmp    80108895 <allocuvm+0xc7>
    }
    memset(mem, 0, PGSIZE);
80108840:	83 ec 04             	sub    $0x4,%esp
80108843:	68 00 10 00 00       	push   $0x1000
80108848:	6a 00                	push   $0x0
8010884a:	ff 75 f0             	pushl  -0x10(%ebp)
8010884d:	e8 81 cf ff ff       	call   801057d3 <memset>
80108852:	83 c4 10             	add    $0x10,%esp
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
80108855:	83 ec 0c             	sub    $0xc,%esp
80108858:	ff 75 f0             	pushl  -0x10(%ebp)
8010885b:	e8 f2 f5 ff ff       	call   80107e52 <v2p>
80108860:	83 c4 10             	add    $0x10,%esp
80108863:	89 c2                	mov    %eax,%edx
80108865:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108868:	83 ec 0c             	sub    $0xc,%esp
8010886b:	6a 06                	push   $0x6
8010886d:	52                   	push   %edx
8010886e:	68 00 10 00 00       	push   $0x1000
80108873:	50                   	push   %eax
80108874:	ff 75 08             	pushl  0x8(%ebp)
80108877:	e8 05 fb ff ff       	call   80108381 <mappages>
8010887c:	83 c4 20             	add    $0x20,%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
8010887f:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108886:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108889:	3b 45 10             	cmp    0x10(%ebp),%eax
8010888c:	0f 82 75 ff ff ff    	jb     80108807 <allocuvm+0x39>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
80108892:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108895:	c9                   	leave  
80108896:	c3                   	ret    

80108897 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108897:	55                   	push   %ebp
80108898:	89 e5                	mov    %esp,%ebp
8010889a:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010889d:	8b 45 10             	mov    0x10(%ebp),%eax
801088a0:	3b 45 0c             	cmp    0xc(%ebp),%eax
801088a3:	72 08                	jb     801088ad <deallocuvm+0x16>
    return oldsz;
801088a5:	8b 45 0c             	mov    0xc(%ebp),%eax
801088a8:	e9 a5 00 00 00       	jmp    80108952 <deallocuvm+0xbb>

  a = PGROUNDUP(newsz);
801088ad:	8b 45 10             	mov    0x10(%ebp),%eax
801088b0:	05 ff 0f 00 00       	add    $0xfff,%eax
801088b5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801088ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801088bd:	e9 81 00 00 00       	jmp    80108943 <deallocuvm+0xac>
    pte = walkpgdir(pgdir, (char*)a, 0);
801088c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088c5:	83 ec 04             	sub    $0x4,%esp
801088c8:	6a 00                	push   $0x0
801088ca:	50                   	push   %eax
801088cb:	ff 75 08             	pushl  0x8(%ebp)
801088ce:	e8 0e fa ff ff       	call   801082e1 <walkpgdir>
801088d3:	83 c4 10             	add    $0x10,%esp
801088d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
801088d9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801088dd:	75 09                	jne    801088e8 <deallocuvm+0x51>
      a += (NPTENTRIES - 1) * PGSIZE;
801088df:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
801088e6:	eb 54                	jmp    8010893c <deallocuvm+0xa5>
    else if((*pte & PTE_P) != 0){
801088e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801088eb:	8b 00                	mov    (%eax),%eax
801088ed:	83 e0 01             	and    $0x1,%eax
801088f0:	85 c0                	test   %eax,%eax
801088f2:	74 48                	je     8010893c <deallocuvm+0xa5>
      pa = PTE_ADDR(*pte);
801088f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801088f7:	8b 00                	mov    (%eax),%eax
801088f9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801088fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80108901:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108905:	75 0d                	jne    80108914 <deallocuvm+0x7d>
        panic("kfree");
80108907:	83 ec 0c             	sub    $0xc,%esp
8010890a:	68 6d 93 10 80       	push   $0x8010936d
8010890f:	e8 52 7c ff ff       	call   80100566 <panic>
      char *v = p2v(pa);
80108914:	83 ec 0c             	sub    $0xc,%esp
80108917:	ff 75 ec             	pushl  -0x14(%ebp)
8010891a:	e8 40 f5 ff ff       	call   80107e5f <p2v>
8010891f:	83 c4 10             	add    $0x10,%esp
80108922:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80108925:	83 ec 0c             	sub    $0xc,%esp
80108928:	ff 75 e8             	pushl  -0x18(%ebp)
8010892b:	e8 4f a2 ff ff       	call   80102b7f <kfree>
80108930:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80108933:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108936:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
8010893c:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108943:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108946:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108949:	0f 82 73 ff ff ff    	jb     801088c2 <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
8010894f:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108952:	c9                   	leave  
80108953:	c3                   	ret    

80108954 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108954:	55                   	push   %ebp
80108955:	89 e5                	mov    %esp,%ebp
80108957:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
8010895a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010895e:	75 0d                	jne    8010896d <freevm+0x19>
    panic("freevm: no pgdir");
80108960:	83 ec 0c             	sub    $0xc,%esp
80108963:	68 73 93 10 80       	push   $0x80109373
80108968:	e8 f9 7b ff ff       	call   80100566 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
8010896d:	83 ec 04             	sub    $0x4,%esp
80108970:	6a 00                	push   $0x0
80108972:	68 00 00 00 80       	push   $0x80000000
80108977:	ff 75 08             	pushl  0x8(%ebp)
8010897a:	e8 18 ff ff ff       	call   80108897 <deallocuvm>
8010897f:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80108982:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108989:	eb 4f                	jmp    801089da <freevm+0x86>
    if(pgdir[i] & PTE_P){
8010898b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010898e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108995:	8b 45 08             	mov    0x8(%ebp),%eax
80108998:	01 d0                	add    %edx,%eax
8010899a:	8b 00                	mov    (%eax),%eax
8010899c:	83 e0 01             	and    $0x1,%eax
8010899f:	85 c0                	test   %eax,%eax
801089a1:	74 33                	je     801089d6 <freevm+0x82>
      char * v = p2v(PTE_ADDR(pgdir[i]));
801089a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089a6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801089ad:	8b 45 08             	mov    0x8(%ebp),%eax
801089b0:	01 d0                	add    %edx,%eax
801089b2:	8b 00                	mov    (%eax),%eax
801089b4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801089b9:	83 ec 0c             	sub    $0xc,%esp
801089bc:	50                   	push   %eax
801089bd:	e8 9d f4 ff ff       	call   80107e5f <p2v>
801089c2:	83 c4 10             	add    $0x10,%esp
801089c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
801089c8:	83 ec 0c             	sub    $0xc,%esp
801089cb:	ff 75 f0             	pushl  -0x10(%ebp)
801089ce:	e8 ac a1 ff ff       	call   80102b7f <kfree>
801089d3:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801089d6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801089da:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
801089e1:	76 a8                	jbe    8010898b <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
801089e3:	83 ec 0c             	sub    $0xc,%esp
801089e6:	ff 75 08             	pushl  0x8(%ebp)
801089e9:	e8 91 a1 ff ff       	call   80102b7f <kfree>
801089ee:	83 c4 10             	add    $0x10,%esp
}
801089f1:	90                   	nop
801089f2:	c9                   	leave  
801089f3:	c3                   	ret    

801089f4 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801089f4:	55                   	push   %ebp
801089f5:	89 e5                	mov    %esp,%ebp
801089f7:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801089fa:	83 ec 04             	sub    $0x4,%esp
801089fd:	6a 00                	push   $0x0
801089ff:	ff 75 0c             	pushl  0xc(%ebp)
80108a02:	ff 75 08             	pushl  0x8(%ebp)
80108a05:	e8 d7 f8 ff ff       	call   801082e1 <walkpgdir>
80108a0a:	83 c4 10             	add    $0x10,%esp
80108a0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80108a10:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108a14:	75 0d                	jne    80108a23 <clearpteu+0x2f>
    panic("clearpteu");
80108a16:	83 ec 0c             	sub    $0xc,%esp
80108a19:	68 84 93 10 80       	push   $0x80109384
80108a1e:	e8 43 7b ff ff       	call   80100566 <panic>
  *pte &= ~PTE_U;
80108a23:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a26:	8b 00                	mov    (%eax),%eax
80108a28:	83 e0 fb             	and    $0xfffffffb,%eax
80108a2b:	89 c2                	mov    %eax,%edx
80108a2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a30:	89 10                	mov    %edx,(%eax)
}
80108a32:	90                   	nop
80108a33:	c9                   	leave  
80108a34:	c3                   	ret    

80108a35 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108a35:	55                   	push   %ebp
80108a36:	89 e5                	mov    %esp,%ebp
80108a38:	53                   	push   %ebx
80108a39:	83 ec 24             	sub    $0x24,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80108a3c:	e8 e6 f9 ff ff       	call   80108427 <setupkvm>
80108a41:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108a44:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108a48:	75 0a                	jne    80108a54 <copyuvm+0x1f>
    return 0;
80108a4a:	b8 00 00 00 00       	mov    $0x0,%eax
80108a4f:	e9 f8 00 00 00       	jmp    80108b4c <copyuvm+0x117>
  for(i = 0; i < sz; i += PGSIZE){
80108a54:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108a5b:	e9 c4 00 00 00       	jmp    80108b24 <copyuvm+0xef>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108a60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a63:	83 ec 04             	sub    $0x4,%esp
80108a66:	6a 00                	push   $0x0
80108a68:	50                   	push   %eax
80108a69:	ff 75 08             	pushl  0x8(%ebp)
80108a6c:	e8 70 f8 ff ff       	call   801082e1 <walkpgdir>
80108a71:	83 c4 10             	add    $0x10,%esp
80108a74:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108a77:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108a7b:	75 0d                	jne    80108a8a <copyuvm+0x55>
      panic("copyuvm: pte should exist");
80108a7d:	83 ec 0c             	sub    $0xc,%esp
80108a80:	68 8e 93 10 80       	push   $0x8010938e
80108a85:	e8 dc 7a ff ff       	call   80100566 <panic>
    if(!(*pte & PTE_P))
80108a8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108a8d:	8b 00                	mov    (%eax),%eax
80108a8f:	83 e0 01             	and    $0x1,%eax
80108a92:	85 c0                	test   %eax,%eax
80108a94:	75 0d                	jne    80108aa3 <copyuvm+0x6e>
      panic("copyuvm: page not present");
80108a96:	83 ec 0c             	sub    $0xc,%esp
80108a99:	68 a8 93 10 80       	push   $0x801093a8
80108a9e:	e8 c3 7a ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
80108aa3:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108aa6:	8b 00                	mov    (%eax),%eax
80108aa8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108aad:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80108ab0:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108ab3:	8b 00                	mov    (%eax),%eax
80108ab5:	25 ff 0f 00 00       	and    $0xfff,%eax
80108aba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80108abd:	e8 67 a1 ff ff       	call   80102c29 <kalloc>
80108ac2:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108ac5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80108ac9:	74 6a                	je     80108b35 <copyuvm+0x100>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
80108acb:	83 ec 0c             	sub    $0xc,%esp
80108ace:	ff 75 e8             	pushl  -0x18(%ebp)
80108ad1:	e8 89 f3 ff ff       	call   80107e5f <p2v>
80108ad6:	83 c4 10             	add    $0x10,%esp
80108ad9:	83 ec 04             	sub    $0x4,%esp
80108adc:	68 00 10 00 00       	push   $0x1000
80108ae1:	50                   	push   %eax
80108ae2:	ff 75 e0             	pushl  -0x20(%ebp)
80108ae5:	e8 a8 cd ff ff       	call   80105892 <memmove>
80108aea:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
80108aed:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80108af0:	83 ec 0c             	sub    $0xc,%esp
80108af3:	ff 75 e0             	pushl  -0x20(%ebp)
80108af6:	e8 57 f3 ff ff       	call   80107e52 <v2p>
80108afb:	83 c4 10             	add    $0x10,%esp
80108afe:	89 c2                	mov    %eax,%edx
80108b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b03:	83 ec 0c             	sub    $0xc,%esp
80108b06:	53                   	push   %ebx
80108b07:	52                   	push   %edx
80108b08:	68 00 10 00 00       	push   $0x1000
80108b0d:	50                   	push   %eax
80108b0e:	ff 75 f0             	pushl  -0x10(%ebp)
80108b11:	e8 6b f8 ff ff       	call   80108381 <mappages>
80108b16:	83 c4 20             	add    $0x20,%esp
80108b19:	85 c0                	test   %eax,%eax
80108b1b:	78 1b                	js     80108b38 <copyuvm+0x103>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80108b1d:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108b24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b27:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108b2a:	0f 82 30 ff ff ff    	jb     80108a60 <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
80108b30:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108b33:	eb 17                	jmp    80108b4c <copyuvm+0x117>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
80108b35:	90                   	nop
80108b36:	eb 01                	jmp    80108b39 <copyuvm+0x104>
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
80108b38:	90                   	nop
  }
  return d;

bad:
  freevm(d);
80108b39:	83 ec 0c             	sub    $0xc,%esp
80108b3c:	ff 75 f0             	pushl  -0x10(%ebp)
80108b3f:	e8 10 fe ff ff       	call   80108954 <freevm>
80108b44:	83 c4 10             	add    $0x10,%esp
  return 0;
80108b47:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108b4c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108b4f:	c9                   	leave  
80108b50:	c3                   	ret    

80108b51 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108b51:	55                   	push   %ebp
80108b52:	89 e5                	mov    %esp,%ebp
80108b54:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108b57:	83 ec 04             	sub    $0x4,%esp
80108b5a:	6a 00                	push   $0x0
80108b5c:	ff 75 0c             	pushl  0xc(%ebp)
80108b5f:	ff 75 08             	pushl  0x8(%ebp)
80108b62:	e8 7a f7 ff ff       	call   801082e1 <walkpgdir>
80108b67:	83 c4 10             	add    $0x10,%esp
80108b6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80108b6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b70:	8b 00                	mov    (%eax),%eax
80108b72:	83 e0 01             	and    $0x1,%eax
80108b75:	85 c0                	test   %eax,%eax
80108b77:	75 07                	jne    80108b80 <uva2ka+0x2f>
    return 0;
80108b79:	b8 00 00 00 00       	mov    $0x0,%eax
80108b7e:	eb 29                	jmp    80108ba9 <uva2ka+0x58>
  if((*pte & PTE_U) == 0)
80108b80:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b83:	8b 00                	mov    (%eax),%eax
80108b85:	83 e0 04             	and    $0x4,%eax
80108b88:	85 c0                	test   %eax,%eax
80108b8a:	75 07                	jne    80108b93 <uva2ka+0x42>
    return 0;
80108b8c:	b8 00 00 00 00       	mov    $0x0,%eax
80108b91:	eb 16                	jmp    80108ba9 <uva2ka+0x58>
  return (char*)p2v(PTE_ADDR(*pte));
80108b93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b96:	8b 00                	mov    (%eax),%eax
80108b98:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108b9d:	83 ec 0c             	sub    $0xc,%esp
80108ba0:	50                   	push   %eax
80108ba1:	e8 b9 f2 ff ff       	call   80107e5f <p2v>
80108ba6:	83 c4 10             	add    $0x10,%esp
}
80108ba9:	c9                   	leave  
80108baa:	c3                   	ret    

80108bab <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108bab:	55                   	push   %ebp
80108bac:	89 e5                	mov    %esp,%ebp
80108bae:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80108bb1:	8b 45 10             	mov    0x10(%ebp),%eax
80108bb4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80108bb7:	eb 7f                	jmp    80108c38 <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
80108bb9:	8b 45 0c             	mov    0xc(%ebp),%eax
80108bbc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108bc1:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80108bc4:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108bc7:	83 ec 08             	sub    $0x8,%esp
80108bca:	50                   	push   %eax
80108bcb:	ff 75 08             	pushl  0x8(%ebp)
80108bce:	e8 7e ff ff ff       	call   80108b51 <uva2ka>
80108bd3:	83 c4 10             	add    $0x10,%esp
80108bd6:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80108bd9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80108bdd:	75 07                	jne    80108be6 <copyout+0x3b>
      return -1;
80108bdf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108be4:	eb 61                	jmp    80108c47 <copyout+0x9c>
    n = PGSIZE - (va - va0);
80108be6:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108be9:	2b 45 0c             	sub    0xc(%ebp),%eax
80108bec:	05 00 10 00 00       	add    $0x1000,%eax
80108bf1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80108bf4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108bf7:	3b 45 14             	cmp    0x14(%ebp),%eax
80108bfa:	76 06                	jbe    80108c02 <copyout+0x57>
      n = len;
80108bfc:	8b 45 14             	mov    0x14(%ebp),%eax
80108bff:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80108c02:	8b 45 0c             	mov    0xc(%ebp),%eax
80108c05:	2b 45 ec             	sub    -0x14(%ebp),%eax
80108c08:	89 c2                	mov    %eax,%edx
80108c0a:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108c0d:	01 d0                	add    %edx,%eax
80108c0f:	83 ec 04             	sub    $0x4,%esp
80108c12:	ff 75 f0             	pushl  -0x10(%ebp)
80108c15:	ff 75 f4             	pushl  -0xc(%ebp)
80108c18:	50                   	push   %eax
80108c19:	e8 74 cc ff ff       	call   80105892 <memmove>
80108c1e:	83 c4 10             	add    $0x10,%esp
    len -= n;
80108c21:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108c24:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80108c27:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108c2a:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80108c2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108c30:	05 00 10 00 00       	add    $0x1000,%eax
80108c35:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108c38:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80108c3c:	0f 85 77 ff ff ff    	jne    80108bb9 <copyout+0xe>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80108c42:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108c47:	c9                   	leave  
80108c48:	c3                   	ret    

80108c49 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
80108c49:	55                   	push   %ebp
80108c4a:	89 e5                	mov    %esp,%ebp
80108c4c:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80108c4f:	8b 55 08             	mov    0x8(%ebp),%edx
80108c52:	8b 45 0c             	mov    0xc(%ebp),%eax
80108c55:	8b 4d 08             	mov    0x8(%ebp),%ecx
80108c58:	f0 87 02             	lock xchg %eax,(%edx)
80108c5b:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80108c5e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80108c61:	c9                   	leave  
80108c62:	c3                   	ret    

80108c63 <lockinit>:

//lock
typedef uint lock_t;
lock_t lock = 1 ;
void 
lockinit(volatile lock_t *lock){
80108c63:	55                   	push   %ebp
80108c64:	89 e5                	mov    %esp,%ebp
   *lock = 1 ;  
80108c66:	8b 45 08             	mov    0x8(%ebp),%eax
80108c69:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
}
80108c6f:	90                   	nop
80108c70:	5d                   	pop    %ebp
80108c71:	c3                   	ret    

80108c72 <lock_acquire>:

void
lock_acquire(volatile lock_t *lock){
80108c72:	55                   	push   %ebp
80108c73:	89 e5                	mov    %esp,%ebp
    while(xchg(lock,0) ==0);
80108c75:	90                   	nop
80108c76:	6a 00                	push   $0x0
80108c78:	ff 75 08             	pushl  0x8(%ebp)
80108c7b:	e8 c9 ff ff ff       	call   80108c49 <xchg>
80108c80:	83 c4 08             	add    $0x8,%esp
80108c83:	85 c0                	test   %eax,%eax
80108c85:	74 ef                	je     80108c76 <lock_acquire+0x4>
}
80108c87:	90                   	nop
80108c88:	c9                   	leave  
80108c89:	c3                   	ret    

80108c8a <lock_release>:

void
lock_release(volatile lock_t *lock){
80108c8a:	55                   	push   %ebp
80108c8b:	89 e5                	mov    %esp,%ebp
    *lock = 1;
80108c8d:	8b 45 08             	mov    0x8(%ebp),%eax
80108c90:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
}
80108c96:	90                   	nop
80108c97:	5d                   	pop    %ebp
80108c98:	c3                   	ret    

80108c99 <thread_create>:


int thread_create(void *(*function)(void *), int priority, void *arg, void *stack){
80108c99:	55                   	push   %ebp
80108c9a:	89 e5                	mov    %esp,%ebp
80108c9c:	83 ec 18             	sub    $0x18,%esp
    int tid;

    if((tid = clone(function,arg,(void*)stack))!=0)
80108c9f:	83 ec 04             	sub    $0x4,%esp
80108ca2:	ff 75 14             	pushl  0x14(%ebp)
80108ca5:	ff 75 10             	pushl  0x10(%ebp)
80108ca8:	ff 75 08             	pushl  0x8(%ebp)
80108cab:	e8 f7 bb ff ff       	call   801048a7 <clone>
80108cb0:	83 c4 10             	add    $0x10,%esp
80108cb3:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108cb6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108cba:	74 05                	je     80108cc1 <thread_create+0x28>
        return tid;
80108cbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cbf:	eb 03                	jmp    80108cc4 <thread_create+0x2b>
    return tid;
80108cc1:	8b 45 f4             	mov    -0xc(%ebp),%eax

}
80108cc4:	c9                   	leave  
80108cc5:	c3                   	ret    

80108cc6 <thread_exit>:

void thread_exit(void *retval){
80108cc6:	55                   	push   %ebp
80108cc7:	89 e5                	mov    %esp,%ebp
80108cc9:	83 ec 08             	sub    $0x8,%esp
    exit_thread((void*)retval);
80108ccc:	83 ec 0c             	sub    $0xc,%esp
80108ccf:	ff 75 08             	pushl  0x8(%ebp)
80108cd2:	e8 38 c0 ff ff       	call   80104d0f <exit_thread>
80108cd7:	83 c4 10             	add    $0x10,%esp
}
80108cda:	90                   	nop
80108cdb:	c9                   	leave  
80108cdc:	c3                   	ret    

80108cdd <thread_join>:

// exit의 retval 이면 join 가능 
//**retval : retval 's pointer
//thread_join 의 retval 에 exit의 retval을 저장하면 됨
//해당 tid 를 가진 thread가 종료되는걸 기다린다.
int thread_join(int tid, void **retval){
80108cdd:	55                   	push   %ebp
80108cde:	89 e5                	mov    %esp,%ebp
80108ce0:	83 ec 08             	sub    $0x8,%esp

    //종료되면 메모리들을 반환해줌
    //성공시 0 return 아니면 -1return
       lock_acquire(&lock);
80108ce3:	68 00 c5 10 80       	push   $0x8010c500
80108ce8:	e8 85 ff ff ff       	call   80108c72 <lock_acquire>
80108ced:	83 c4 04             	add    $0x4,%esp
       if(wait_thread(tid,retval) <0)
80108cf0:	83 ec 08             	sub    $0x8,%esp
80108cf3:	ff 75 0c             	pushl  0xc(%ebp)
80108cf6:	ff 75 08             	pushl  0x8(%ebp)
80108cf9:	e8 fc c1 ff ff       	call   80104efa <wait_thread>
80108cfe:	83 c4 10             	add    $0x10,%esp
80108d01:	85 c0                	test   %eax,%eax
80108d03:	79 07                	jns    80108d0c <thread_join+0x2f>
           return-1;
80108d05:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108d0a:	eb 15                	jmp    80108d21 <thread_join+0x44>
       lock_release(&lock);
80108d0c:	83 ec 0c             	sub    $0xc,%esp
80108d0f:	68 00 c5 10 80       	push   $0x8010c500
80108d14:	e8 71 ff ff ff       	call   80108c8a <lock_release>
80108d19:	83 c4 10             	add    $0x10,%esp
       return 0;
80108d1c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108d21:	c9                   	leave  
80108d22:	c3                   	ret    

80108d23 <gettid>:

int gettid(void){ 
80108d23:	55                   	push   %ebp
80108d24:	89 e5                	mov    %esp,%ebp
    //tid 0부터 시작해서 이미 있으면 ++ 해줘서 return 해줄듯?
    return proc->tid;
80108d26:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108d2c:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
}
80108d32:	5d                   	pop    %ebp
80108d33:	c3                   	ret    
