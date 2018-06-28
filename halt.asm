
_halt:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "stat.h"
#include "user.h"

int main(void){
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
	return halt();
  11:	e8 f7 02 00 00       	call   30d <halt>

00000016 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  16:	55                   	push   %ebp
  17:	89 e5                	mov    %esp,%ebp
  19:	57                   	push   %edi
  1a:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  1b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  1e:	8b 55 10             	mov    0x10(%ebp),%edx
  21:	8b 45 0c             	mov    0xc(%ebp),%eax
  24:	89 cb                	mov    %ecx,%ebx
  26:	89 df                	mov    %ebx,%edi
  28:	89 d1                	mov    %edx,%ecx
  2a:	fc                   	cld    
  2b:	f3 aa                	rep stos %al,%es:(%edi)
  2d:	89 ca                	mov    %ecx,%edx
  2f:	89 fb                	mov    %edi,%ebx
  31:	89 5d 08             	mov    %ebx,0x8(%ebp)
  34:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  37:	90                   	nop
  38:	5b                   	pop    %ebx
  39:	5f                   	pop    %edi
  3a:	5d                   	pop    %ebp
  3b:	c3                   	ret    

0000003c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  3c:	55                   	push   %ebp
  3d:	89 e5                	mov    %esp,%ebp
  3f:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  42:	8b 45 08             	mov    0x8(%ebp),%eax
  45:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  48:	90                   	nop
  49:	8b 45 08             	mov    0x8(%ebp),%eax
  4c:	8d 50 01             	lea    0x1(%eax),%edx
  4f:	89 55 08             	mov    %edx,0x8(%ebp)
  52:	8b 55 0c             	mov    0xc(%ebp),%edx
  55:	8d 4a 01             	lea    0x1(%edx),%ecx
  58:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  5b:	0f b6 12             	movzbl (%edx),%edx
  5e:	88 10                	mov    %dl,(%eax)
  60:	0f b6 00             	movzbl (%eax),%eax
  63:	84 c0                	test   %al,%al
  65:	75 e2                	jne    49 <strcpy+0xd>
    ;
  return os;
  67:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  6a:	c9                   	leave  
  6b:	c3                   	ret    

0000006c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  6c:	55                   	push   %ebp
  6d:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  6f:	eb 08                	jmp    79 <strcmp+0xd>
    p++, q++;
  71:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  75:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  79:	8b 45 08             	mov    0x8(%ebp),%eax
  7c:	0f b6 00             	movzbl (%eax),%eax
  7f:	84 c0                	test   %al,%al
  81:	74 10                	je     93 <strcmp+0x27>
  83:	8b 45 08             	mov    0x8(%ebp),%eax
  86:	0f b6 10             	movzbl (%eax),%edx
  89:	8b 45 0c             	mov    0xc(%ebp),%eax
  8c:	0f b6 00             	movzbl (%eax),%eax
  8f:	38 c2                	cmp    %al,%dl
  91:	74 de                	je     71 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  93:	8b 45 08             	mov    0x8(%ebp),%eax
  96:	0f b6 00             	movzbl (%eax),%eax
  99:	0f b6 d0             	movzbl %al,%edx
  9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  9f:	0f b6 00             	movzbl (%eax),%eax
  a2:	0f b6 c0             	movzbl %al,%eax
  a5:	29 c2                	sub    %eax,%edx
  a7:	89 d0                	mov    %edx,%eax
}
  a9:	5d                   	pop    %ebp
  aa:	c3                   	ret    

000000ab <strlen>:

uint
strlen(char *s)
{
  ab:	55                   	push   %ebp
  ac:	89 e5                	mov    %esp,%ebp
  ae:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  b8:	eb 04                	jmp    be <strlen+0x13>
  ba:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  be:	8b 55 fc             	mov    -0x4(%ebp),%edx
  c1:	8b 45 08             	mov    0x8(%ebp),%eax
  c4:	01 d0                	add    %edx,%eax
  c6:	0f b6 00             	movzbl (%eax),%eax
  c9:	84 c0                	test   %al,%al
  cb:	75 ed                	jne    ba <strlen+0xf>
    ;
  return n;
  cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  d0:	c9                   	leave  
  d1:	c3                   	ret    

000000d2 <memset>:

void*
memset(void *dst, int c, uint n)
{
  d2:	55                   	push   %ebp
  d3:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
  d5:	8b 45 10             	mov    0x10(%ebp),%eax
  d8:	50                   	push   %eax
  d9:	ff 75 0c             	pushl  0xc(%ebp)
  dc:	ff 75 08             	pushl  0x8(%ebp)
  df:	e8 32 ff ff ff       	call   16 <stosb>
  e4:	83 c4 0c             	add    $0xc,%esp
  return dst;
  e7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  ea:	c9                   	leave  
  eb:	c3                   	ret    

000000ec <strchr>:

char*
strchr(const char *s, char c)
{
  ec:	55                   	push   %ebp
  ed:	89 e5                	mov    %esp,%ebp
  ef:	83 ec 04             	sub    $0x4,%esp
  f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  f5:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
  f8:	eb 14                	jmp    10e <strchr+0x22>
    if(*s == c)
  fa:	8b 45 08             	mov    0x8(%ebp),%eax
  fd:	0f b6 00             	movzbl (%eax),%eax
 100:	3a 45 fc             	cmp    -0x4(%ebp),%al
 103:	75 05                	jne    10a <strchr+0x1e>
      return (char*)s;
 105:	8b 45 08             	mov    0x8(%ebp),%eax
 108:	eb 13                	jmp    11d <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 10a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 10e:	8b 45 08             	mov    0x8(%ebp),%eax
 111:	0f b6 00             	movzbl (%eax),%eax
 114:	84 c0                	test   %al,%al
 116:	75 e2                	jne    fa <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 118:	b8 00 00 00 00       	mov    $0x0,%eax
}
 11d:	c9                   	leave  
 11e:	c3                   	ret    

0000011f <gets>:

char*
gets(char *buf, int max)
{
 11f:	55                   	push   %ebp
 120:	89 e5                	mov    %esp,%ebp
 122:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 125:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 12c:	eb 42                	jmp    170 <gets+0x51>
    cc = read(0, &c, 1);
 12e:	83 ec 04             	sub    $0x4,%esp
 131:	6a 01                	push   $0x1
 133:	8d 45 ef             	lea    -0x11(%ebp),%eax
 136:	50                   	push   %eax
 137:	6a 00                	push   $0x0
 139:	e8 47 01 00 00       	call   285 <read>
 13e:	83 c4 10             	add    $0x10,%esp
 141:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 144:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 148:	7e 33                	jle    17d <gets+0x5e>
      break;
    buf[i++] = c;
 14a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 14d:	8d 50 01             	lea    0x1(%eax),%edx
 150:	89 55 f4             	mov    %edx,-0xc(%ebp)
 153:	89 c2                	mov    %eax,%edx
 155:	8b 45 08             	mov    0x8(%ebp),%eax
 158:	01 c2                	add    %eax,%edx
 15a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 15e:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 160:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 164:	3c 0a                	cmp    $0xa,%al
 166:	74 16                	je     17e <gets+0x5f>
 168:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 16c:	3c 0d                	cmp    $0xd,%al
 16e:	74 0e                	je     17e <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 170:	8b 45 f4             	mov    -0xc(%ebp),%eax
 173:	83 c0 01             	add    $0x1,%eax
 176:	3b 45 0c             	cmp    0xc(%ebp),%eax
 179:	7c b3                	jl     12e <gets+0xf>
 17b:	eb 01                	jmp    17e <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 17d:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 17e:	8b 55 f4             	mov    -0xc(%ebp),%edx
 181:	8b 45 08             	mov    0x8(%ebp),%eax
 184:	01 d0                	add    %edx,%eax
 186:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 189:	8b 45 08             	mov    0x8(%ebp),%eax
}
 18c:	c9                   	leave  
 18d:	c3                   	ret    

0000018e <stat>:

int
stat(char *n, struct stat *st)
{
 18e:	55                   	push   %ebp
 18f:	89 e5                	mov    %esp,%ebp
 191:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 194:	83 ec 08             	sub    $0x8,%esp
 197:	6a 00                	push   $0x0
 199:	ff 75 08             	pushl  0x8(%ebp)
 19c:	e8 0c 01 00 00       	call   2ad <open>
 1a1:	83 c4 10             	add    $0x10,%esp
 1a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1ab:	79 07                	jns    1b4 <stat+0x26>
    return -1;
 1ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1b2:	eb 25                	jmp    1d9 <stat+0x4b>
  r = fstat(fd, st);
 1b4:	83 ec 08             	sub    $0x8,%esp
 1b7:	ff 75 0c             	pushl  0xc(%ebp)
 1ba:	ff 75 f4             	pushl  -0xc(%ebp)
 1bd:	e8 03 01 00 00       	call   2c5 <fstat>
 1c2:	83 c4 10             	add    $0x10,%esp
 1c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1c8:	83 ec 0c             	sub    $0xc,%esp
 1cb:	ff 75 f4             	pushl  -0xc(%ebp)
 1ce:	e8 c2 00 00 00       	call   295 <close>
 1d3:	83 c4 10             	add    $0x10,%esp
  return r;
 1d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 1d9:	c9                   	leave  
 1da:	c3                   	ret    

000001db <atoi>:

int
atoi(const char *s)
{
 1db:	55                   	push   %ebp
 1dc:	89 e5                	mov    %esp,%ebp
 1de:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 1e1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 1e8:	eb 25                	jmp    20f <atoi+0x34>
    n = n*10 + *s++ - '0';
 1ea:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1ed:	89 d0                	mov    %edx,%eax
 1ef:	c1 e0 02             	shl    $0x2,%eax
 1f2:	01 d0                	add    %edx,%eax
 1f4:	01 c0                	add    %eax,%eax
 1f6:	89 c1                	mov    %eax,%ecx
 1f8:	8b 45 08             	mov    0x8(%ebp),%eax
 1fb:	8d 50 01             	lea    0x1(%eax),%edx
 1fe:	89 55 08             	mov    %edx,0x8(%ebp)
 201:	0f b6 00             	movzbl (%eax),%eax
 204:	0f be c0             	movsbl %al,%eax
 207:	01 c8                	add    %ecx,%eax
 209:	83 e8 30             	sub    $0x30,%eax
 20c:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 20f:	8b 45 08             	mov    0x8(%ebp),%eax
 212:	0f b6 00             	movzbl (%eax),%eax
 215:	3c 2f                	cmp    $0x2f,%al
 217:	7e 0a                	jle    223 <atoi+0x48>
 219:	8b 45 08             	mov    0x8(%ebp),%eax
 21c:	0f b6 00             	movzbl (%eax),%eax
 21f:	3c 39                	cmp    $0x39,%al
 221:	7e c7                	jle    1ea <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 223:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 226:	c9                   	leave  
 227:	c3                   	ret    

00000228 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 228:	55                   	push   %ebp
 229:	89 e5                	mov    %esp,%ebp
 22b:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 22e:	8b 45 08             	mov    0x8(%ebp),%eax
 231:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 234:	8b 45 0c             	mov    0xc(%ebp),%eax
 237:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 23a:	eb 17                	jmp    253 <memmove+0x2b>
    *dst++ = *src++;
 23c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 23f:	8d 50 01             	lea    0x1(%eax),%edx
 242:	89 55 fc             	mov    %edx,-0x4(%ebp)
 245:	8b 55 f8             	mov    -0x8(%ebp),%edx
 248:	8d 4a 01             	lea    0x1(%edx),%ecx
 24b:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 24e:	0f b6 12             	movzbl (%edx),%edx
 251:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 253:	8b 45 10             	mov    0x10(%ebp),%eax
 256:	8d 50 ff             	lea    -0x1(%eax),%edx
 259:	89 55 10             	mov    %edx,0x10(%ebp)
 25c:	85 c0                	test   %eax,%eax
 25e:	7f dc                	jg     23c <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 260:	8b 45 08             	mov    0x8(%ebp),%eax
}
 263:	c9                   	leave  
 264:	c3                   	ret    

00000265 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 265:	b8 01 00 00 00       	mov    $0x1,%eax
 26a:	cd 40                	int    $0x40
 26c:	c3                   	ret    

0000026d <exit>:
SYSCALL(exit)
 26d:	b8 02 00 00 00       	mov    $0x2,%eax
 272:	cd 40                	int    $0x40
 274:	c3                   	ret    

00000275 <wait>:
SYSCALL(wait)
 275:	b8 03 00 00 00       	mov    $0x3,%eax
 27a:	cd 40                	int    $0x40
 27c:	c3                   	ret    

0000027d <pipe>:
SYSCALL(pipe)
 27d:	b8 04 00 00 00       	mov    $0x4,%eax
 282:	cd 40                	int    $0x40
 284:	c3                   	ret    

00000285 <read>:
SYSCALL(read)
 285:	b8 05 00 00 00       	mov    $0x5,%eax
 28a:	cd 40                	int    $0x40
 28c:	c3                   	ret    

0000028d <write>:
SYSCALL(write)
 28d:	b8 10 00 00 00       	mov    $0x10,%eax
 292:	cd 40                	int    $0x40
 294:	c3                   	ret    

00000295 <close>:
SYSCALL(close)
 295:	b8 15 00 00 00       	mov    $0x15,%eax
 29a:	cd 40                	int    $0x40
 29c:	c3                   	ret    

0000029d <kill>:
SYSCALL(kill)
 29d:	b8 06 00 00 00       	mov    $0x6,%eax
 2a2:	cd 40                	int    $0x40
 2a4:	c3                   	ret    

000002a5 <exec>:
SYSCALL(exec)
 2a5:	b8 07 00 00 00       	mov    $0x7,%eax
 2aa:	cd 40                	int    $0x40
 2ac:	c3                   	ret    

000002ad <open>:
SYSCALL(open)
 2ad:	b8 0f 00 00 00       	mov    $0xf,%eax
 2b2:	cd 40                	int    $0x40
 2b4:	c3                   	ret    

000002b5 <mknod>:
SYSCALL(mknod)
 2b5:	b8 11 00 00 00       	mov    $0x11,%eax
 2ba:	cd 40                	int    $0x40
 2bc:	c3                   	ret    

000002bd <unlink>:
SYSCALL(unlink)
 2bd:	b8 12 00 00 00       	mov    $0x12,%eax
 2c2:	cd 40                	int    $0x40
 2c4:	c3                   	ret    

000002c5 <fstat>:
SYSCALL(fstat)
 2c5:	b8 08 00 00 00       	mov    $0x8,%eax
 2ca:	cd 40                	int    $0x40
 2cc:	c3                   	ret    

000002cd <link>:
SYSCALL(link)
 2cd:	b8 13 00 00 00       	mov    $0x13,%eax
 2d2:	cd 40                	int    $0x40
 2d4:	c3                   	ret    

000002d5 <mkdir>:
SYSCALL(mkdir)
 2d5:	b8 14 00 00 00       	mov    $0x14,%eax
 2da:	cd 40                	int    $0x40
 2dc:	c3                   	ret    

000002dd <chdir>:
SYSCALL(chdir)
 2dd:	b8 09 00 00 00       	mov    $0x9,%eax
 2e2:	cd 40                	int    $0x40
 2e4:	c3                   	ret    

000002e5 <dup>:
SYSCALL(dup)
 2e5:	b8 0a 00 00 00       	mov    $0xa,%eax
 2ea:	cd 40                	int    $0x40
 2ec:	c3                   	ret    

000002ed <getpid>:
SYSCALL(getpid)
 2ed:	b8 0b 00 00 00       	mov    $0xb,%eax
 2f2:	cd 40                	int    $0x40
 2f4:	c3                   	ret    

000002f5 <sbrk>:
SYSCALL(sbrk)
 2f5:	b8 0c 00 00 00       	mov    $0xc,%eax
 2fa:	cd 40                	int    $0x40
 2fc:	c3                   	ret    

000002fd <sleep>:
SYSCALL(sleep)
 2fd:	b8 0d 00 00 00       	mov    $0xd,%eax
 302:	cd 40                	int    $0x40
 304:	c3                   	ret    

00000305 <uptime>:
SYSCALL(uptime)
 305:	b8 0e 00 00 00       	mov    $0xe,%eax
 30a:	cd 40                	int    $0x40
 30c:	c3                   	ret    

0000030d <halt>:
SYSCALL(halt)
 30d:	b8 16 00 00 00       	mov    $0x16,%eax
 312:	cd 40                	int    $0x40
 314:	c3                   	ret    

00000315 <thread_create>:
SYSCALL(thread_create)
 315:	b8 17 00 00 00       	mov    $0x17,%eax
 31a:	cd 40                	int    $0x40
 31c:	c3                   	ret    

0000031d <thread_exit>:
SYSCALL(thread_exit)
 31d:	b8 18 00 00 00       	mov    $0x18,%eax
 322:	cd 40                	int    $0x40
 324:	c3                   	ret    

00000325 <thread_join>:
SYSCALL(thread_join)
 325:	b8 19 00 00 00       	mov    $0x19,%eax
 32a:	cd 40                	int    $0x40
 32c:	c3                   	ret    

0000032d <gettid>:
SYSCALL(gettid)
 32d:	b8 1a 00 00 00       	mov    $0x1a,%eax
 332:	cd 40                	int    $0x40
 334:	c3                   	ret    

00000335 <clone>:
SYSCALL(clone)
 335:	b8 1b 00 00 00       	mov    $0x1b,%eax
 33a:	cd 40                	int    $0x40
 33c:	c3                   	ret    

0000033d <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 33d:	55                   	push   %ebp
 33e:	89 e5                	mov    %esp,%ebp
 340:	83 ec 18             	sub    $0x18,%esp
 343:	8b 45 0c             	mov    0xc(%ebp),%eax
 346:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 349:	83 ec 04             	sub    $0x4,%esp
 34c:	6a 01                	push   $0x1
 34e:	8d 45 f4             	lea    -0xc(%ebp),%eax
 351:	50                   	push   %eax
 352:	ff 75 08             	pushl  0x8(%ebp)
 355:	e8 33 ff ff ff       	call   28d <write>
 35a:	83 c4 10             	add    $0x10,%esp
}
 35d:	90                   	nop
 35e:	c9                   	leave  
 35f:	c3                   	ret    

00000360 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 360:	55                   	push   %ebp
 361:	89 e5                	mov    %esp,%ebp
 363:	53                   	push   %ebx
 364:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 367:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 36e:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 372:	74 17                	je     38b <printint+0x2b>
 374:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 378:	79 11                	jns    38b <printint+0x2b>
    neg = 1;
 37a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 381:	8b 45 0c             	mov    0xc(%ebp),%eax
 384:	f7 d8                	neg    %eax
 386:	89 45 ec             	mov    %eax,-0x14(%ebp)
 389:	eb 06                	jmp    391 <printint+0x31>
  } else {
    x = xx;
 38b:	8b 45 0c             	mov    0xc(%ebp),%eax
 38e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 391:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 398:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 39b:	8d 41 01             	lea    0x1(%ecx),%eax
 39e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3a1:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3a7:	ba 00 00 00 00       	mov    $0x0,%edx
 3ac:	f7 f3                	div    %ebx
 3ae:	89 d0                	mov    %edx,%eax
 3b0:	0f b6 80 1c 0a 00 00 	movzbl 0xa1c(%eax),%eax
 3b7:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 3bb:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3be:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3c1:	ba 00 00 00 00       	mov    $0x0,%edx
 3c6:	f7 f3                	div    %ebx
 3c8:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3cb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3cf:	75 c7                	jne    398 <printint+0x38>
  if(neg)
 3d1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3d5:	74 2d                	je     404 <printint+0xa4>
    buf[i++] = '-';
 3d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3da:	8d 50 01             	lea    0x1(%eax),%edx
 3dd:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3e0:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 3e5:	eb 1d                	jmp    404 <printint+0xa4>
    putc(fd, buf[i]);
 3e7:	8d 55 dc             	lea    -0x24(%ebp),%edx
 3ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3ed:	01 d0                	add    %edx,%eax
 3ef:	0f b6 00             	movzbl (%eax),%eax
 3f2:	0f be c0             	movsbl %al,%eax
 3f5:	83 ec 08             	sub    $0x8,%esp
 3f8:	50                   	push   %eax
 3f9:	ff 75 08             	pushl  0x8(%ebp)
 3fc:	e8 3c ff ff ff       	call   33d <putc>
 401:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 404:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 408:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 40c:	79 d9                	jns    3e7 <printint+0x87>
    putc(fd, buf[i]);
}
 40e:	90                   	nop
 40f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 412:	c9                   	leave  
 413:	c3                   	ret    

00000414 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 414:	55                   	push   %ebp
 415:	89 e5                	mov    %esp,%ebp
 417:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 41a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 421:	8d 45 0c             	lea    0xc(%ebp),%eax
 424:	83 c0 04             	add    $0x4,%eax
 427:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 42a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 431:	e9 59 01 00 00       	jmp    58f <printf+0x17b>
    c = fmt[i] & 0xff;
 436:	8b 55 0c             	mov    0xc(%ebp),%edx
 439:	8b 45 f0             	mov    -0x10(%ebp),%eax
 43c:	01 d0                	add    %edx,%eax
 43e:	0f b6 00             	movzbl (%eax),%eax
 441:	0f be c0             	movsbl %al,%eax
 444:	25 ff 00 00 00       	and    $0xff,%eax
 449:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 44c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 450:	75 2c                	jne    47e <printf+0x6a>
      if(c == '%'){
 452:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 456:	75 0c                	jne    464 <printf+0x50>
        state = '%';
 458:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 45f:	e9 27 01 00 00       	jmp    58b <printf+0x177>
      } else {
        putc(fd, c);
 464:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 467:	0f be c0             	movsbl %al,%eax
 46a:	83 ec 08             	sub    $0x8,%esp
 46d:	50                   	push   %eax
 46e:	ff 75 08             	pushl  0x8(%ebp)
 471:	e8 c7 fe ff ff       	call   33d <putc>
 476:	83 c4 10             	add    $0x10,%esp
 479:	e9 0d 01 00 00       	jmp    58b <printf+0x177>
      }
    } else if(state == '%'){
 47e:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 482:	0f 85 03 01 00 00    	jne    58b <printf+0x177>
      if(c == 'd'){
 488:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 48c:	75 1e                	jne    4ac <printf+0x98>
        printint(fd, *ap, 10, 1);
 48e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 491:	8b 00                	mov    (%eax),%eax
 493:	6a 01                	push   $0x1
 495:	6a 0a                	push   $0xa
 497:	50                   	push   %eax
 498:	ff 75 08             	pushl  0x8(%ebp)
 49b:	e8 c0 fe ff ff       	call   360 <printint>
 4a0:	83 c4 10             	add    $0x10,%esp
        ap++;
 4a3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4a7:	e9 d8 00 00 00       	jmp    584 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 4ac:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4b0:	74 06                	je     4b8 <printf+0xa4>
 4b2:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4b6:	75 1e                	jne    4d6 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 4b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4bb:	8b 00                	mov    (%eax),%eax
 4bd:	6a 00                	push   $0x0
 4bf:	6a 10                	push   $0x10
 4c1:	50                   	push   %eax
 4c2:	ff 75 08             	pushl  0x8(%ebp)
 4c5:	e8 96 fe ff ff       	call   360 <printint>
 4ca:	83 c4 10             	add    $0x10,%esp
        ap++;
 4cd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4d1:	e9 ae 00 00 00       	jmp    584 <printf+0x170>
      } else if(c == 's'){
 4d6:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 4da:	75 43                	jne    51f <printf+0x10b>
        s = (char*)*ap;
 4dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4df:	8b 00                	mov    (%eax),%eax
 4e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 4e4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 4e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4ec:	75 25                	jne    513 <printf+0xff>
          s = "(null)";
 4ee:	c7 45 f4 ca 07 00 00 	movl   $0x7ca,-0xc(%ebp)
        while(*s != 0){
 4f5:	eb 1c                	jmp    513 <printf+0xff>
          putc(fd, *s);
 4f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4fa:	0f b6 00             	movzbl (%eax),%eax
 4fd:	0f be c0             	movsbl %al,%eax
 500:	83 ec 08             	sub    $0x8,%esp
 503:	50                   	push   %eax
 504:	ff 75 08             	pushl  0x8(%ebp)
 507:	e8 31 fe ff ff       	call   33d <putc>
 50c:	83 c4 10             	add    $0x10,%esp
          s++;
 50f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 513:	8b 45 f4             	mov    -0xc(%ebp),%eax
 516:	0f b6 00             	movzbl (%eax),%eax
 519:	84 c0                	test   %al,%al
 51b:	75 da                	jne    4f7 <printf+0xe3>
 51d:	eb 65                	jmp    584 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 51f:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 523:	75 1d                	jne    542 <printf+0x12e>
        putc(fd, *ap);
 525:	8b 45 e8             	mov    -0x18(%ebp),%eax
 528:	8b 00                	mov    (%eax),%eax
 52a:	0f be c0             	movsbl %al,%eax
 52d:	83 ec 08             	sub    $0x8,%esp
 530:	50                   	push   %eax
 531:	ff 75 08             	pushl  0x8(%ebp)
 534:	e8 04 fe ff ff       	call   33d <putc>
 539:	83 c4 10             	add    $0x10,%esp
        ap++;
 53c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 540:	eb 42                	jmp    584 <printf+0x170>
      } else if(c == '%'){
 542:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 546:	75 17                	jne    55f <printf+0x14b>
        putc(fd, c);
 548:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 54b:	0f be c0             	movsbl %al,%eax
 54e:	83 ec 08             	sub    $0x8,%esp
 551:	50                   	push   %eax
 552:	ff 75 08             	pushl  0x8(%ebp)
 555:	e8 e3 fd ff ff       	call   33d <putc>
 55a:	83 c4 10             	add    $0x10,%esp
 55d:	eb 25                	jmp    584 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 55f:	83 ec 08             	sub    $0x8,%esp
 562:	6a 25                	push   $0x25
 564:	ff 75 08             	pushl  0x8(%ebp)
 567:	e8 d1 fd ff ff       	call   33d <putc>
 56c:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 56f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 572:	0f be c0             	movsbl %al,%eax
 575:	83 ec 08             	sub    $0x8,%esp
 578:	50                   	push   %eax
 579:	ff 75 08             	pushl  0x8(%ebp)
 57c:	e8 bc fd ff ff       	call   33d <putc>
 581:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 584:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 58b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 58f:	8b 55 0c             	mov    0xc(%ebp),%edx
 592:	8b 45 f0             	mov    -0x10(%ebp),%eax
 595:	01 d0                	add    %edx,%eax
 597:	0f b6 00             	movzbl (%eax),%eax
 59a:	84 c0                	test   %al,%al
 59c:	0f 85 94 fe ff ff    	jne    436 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5a2:	90                   	nop
 5a3:	c9                   	leave  
 5a4:	c3                   	ret    

000005a5 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5a5:	55                   	push   %ebp
 5a6:	89 e5                	mov    %esp,%ebp
 5a8:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5ab:	8b 45 08             	mov    0x8(%ebp),%eax
 5ae:	83 e8 08             	sub    $0x8,%eax
 5b1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5b4:	a1 38 0a 00 00       	mov    0xa38,%eax
 5b9:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5bc:	eb 24                	jmp    5e2 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5be:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5c1:	8b 00                	mov    (%eax),%eax
 5c3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5c6:	77 12                	ja     5da <free+0x35>
 5c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5cb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5ce:	77 24                	ja     5f4 <free+0x4f>
 5d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5d3:	8b 00                	mov    (%eax),%eax
 5d5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5d8:	77 1a                	ja     5f4 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5da:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5dd:	8b 00                	mov    (%eax),%eax
 5df:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5e5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5e8:	76 d4                	jbe    5be <free+0x19>
 5ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5ed:	8b 00                	mov    (%eax),%eax
 5ef:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5f2:	76 ca                	jbe    5be <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 5f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5f7:	8b 40 04             	mov    0x4(%eax),%eax
 5fa:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 601:	8b 45 f8             	mov    -0x8(%ebp),%eax
 604:	01 c2                	add    %eax,%edx
 606:	8b 45 fc             	mov    -0x4(%ebp),%eax
 609:	8b 00                	mov    (%eax),%eax
 60b:	39 c2                	cmp    %eax,%edx
 60d:	75 24                	jne    633 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 60f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 612:	8b 50 04             	mov    0x4(%eax),%edx
 615:	8b 45 fc             	mov    -0x4(%ebp),%eax
 618:	8b 00                	mov    (%eax),%eax
 61a:	8b 40 04             	mov    0x4(%eax),%eax
 61d:	01 c2                	add    %eax,%edx
 61f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 622:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 625:	8b 45 fc             	mov    -0x4(%ebp),%eax
 628:	8b 00                	mov    (%eax),%eax
 62a:	8b 10                	mov    (%eax),%edx
 62c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 62f:	89 10                	mov    %edx,(%eax)
 631:	eb 0a                	jmp    63d <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 633:	8b 45 fc             	mov    -0x4(%ebp),%eax
 636:	8b 10                	mov    (%eax),%edx
 638:	8b 45 f8             	mov    -0x8(%ebp),%eax
 63b:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 63d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 640:	8b 40 04             	mov    0x4(%eax),%eax
 643:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 64a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64d:	01 d0                	add    %edx,%eax
 64f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 652:	75 20                	jne    674 <free+0xcf>
    p->s.size += bp->s.size;
 654:	8b 45 fc             	mov    -0x4(%ebp),%eax
 657:	8b 50 04             	mov    0x4(%eax),%edx
 65a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65d:	8b 40 04             	mov    0x4(%eax),%eax
 660:	01 c2                	add    %eax,%edx
 662:	8b 45 fc             	mov    -0x4(%ebp),%eax
 665:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 668:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66b:	8b 10                	mov    (%eax),%edx
 66d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 670:	89 10                	mov    %edx,(%eax)
 672:	eb 08                	jmp    67c <free+0xd7>
  } else
    p->s.ptr = bp;
 674:	8b 45 fc             	mov    -0x4(%ebp),%eax
 677:	8b 55 f8             	mov    -0x8(%ebp),%edx
 67a:	89 10                	mov    %edx,(%eax)
  freep = p;
 67c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67f:	a3 38 0a 00 00       	mov    %eax,0xa38
}
 684:	90                   	nop
 685:	c9                   	leave  
 686:	c3                   	ret    

00000687 <morecore>:

static Header*
morecore(uint nu)
{
 687:	55                   	push   %ebp
 688:	89 e5                	mov    %esp,%ebp
 68a:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 68d:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 694:	77 07                	ja     69d <morecore+0x16>
    nu = 4096;
 696:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 69d:	8b 45 08             	mov    0x8(%ebp),%eax
 6a0:	c1 e0 03             	shl    $0x3,%eax
 6a3:	83 ec 0c             	sub    $0xc,%esp
 6a6:	50                   	push   %eax
 6a7:	e8 49 fc ff ff       	call   2f5 <sbrk>
 6ac:	83 c4 10             	add    $0x10,%esp
 6af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6b2:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6b6:	75 07                	jne    6bf <morecore+0x38>
    return 0;
 6b8:	b8 00 00 00 00       	mov    $0x0,%eax
 6bd:	eb 26                	jmp    6e5 <morecore+0x5e>
  hp = (Header*)p;
 6bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6c8:	8b 55 08             	mov    0x8(%ebp),%edx
 6cb:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 6ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6d1:	83 c0 08             	add    $0x8,%eax
 6d4:	83 ec 0c             	sub    $0xc,%esp
 6d7:	50                   	push   %eax
 6d8:	e8 c8 fe ff ff       	call   5a5 <free>
 6dd:	83 c4 10             	add    $0x10,%esp
  return freep;
 6e0:	a1 38 0a 00 00       	mov    0xa38,%eax
}
 6e5:	c9                   	leave  
 6e6:	c3                   	ret    

000006e7 <malloc>:

void*
malloc(uint nbytes)
{
 6e7:	55                   	push   %ebp
 6e8:	89 e5                	mov    %esp,%ebp
 6ea:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6ed:	8b 45 08             	mov    0x8(%ebp),%eax
 6f0:	83 c0 07             	add    $0x7,%eax
 6f3:	c1 e8 03             	shr    $0x3,%eax
 6f6:	83 c0 01             	add    $0x1,%eax
 6f9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 6fc:	a1 38 0a 00 00       	mov    0xa38,%eax
 701:	89 45 f0             	mov    %eax,-0x10(%ebp)
 704:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 708:	75 23                	jne    72d <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 70a:	c7 45 f0 30 0a 00 00 	movl   $0xa30,-0x10(%ebp)
 711:	8b 45 f0             	mov    -0x10(%ebp),%eax
 714:	a3 38 0a 00 00       	mov    %eax,0xa38
 719:	a1 38 0a 00 00       	mov    0xa38,%eax
 71e:	a3 30 0a 00 00       	mov    %eax,0xa30
    base.s.size = 0;
 723:	c7 05 34 0a 00 00 00 	movl   $0x0,0xa34
 72a:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 72d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 730:	8b 00                	mov    (%eax),%eax
 732:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 735:	8b 45 f4             	mov    -0xc(%ebp),%eax
 738:	8b 40 04             	mov    0x4(%eax),%eax
 73b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 73e:	72 4d                	jb     78d <malloc+0xa6>
      if(p->s.size == nunits)
 740:	8b 45 f4             	mov    -0xc(%ebp),%eax
 743:	8b 40 04             	mov    0x4(%eax),%eax
 746:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 749:	75 0c                	jne    757 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 74b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 74e:	8b 10                	mov    (%eax),%edx
 750:	8b 45 f0             	mov    -0x10(%ebp),%eax
 753:	89 10                	mov    %edx,(%eax)
 755:	eb 26                	jmp    77d <malloc+0x96>
      else {
        p->s.size -= nunits;
 757:	8b 45 f4             	mov    -0xc(%ebp),%eax
 75a:	8b 40 04             	mov    0x4(%eax),%eax
 75d:	2b 45 ec             	sub    -0x14(%ebp),%eax
 760:	89 c2                	mov    %eax,%edx
 762:	8b 45 f4             	mov    -0xc(%ebp),%eax
 765:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 768:	8b 45 f4             	mov    -0xc(%ebp),%eax
 76b:	8b 40 04             	mov    0x4(%eax),%eax
 76e:	c1 e0 03             	shl    $0x3,%eax
 771:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 774:	8b 45 f4             	mov    -0xc(%ebp),%eax
 777:	8b 55 ec             	mov    -0x14(%ebp),%edx
 77a:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 77d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 780:	a3 38 0a 00 00       	mov    %eax,0xa38
      return (void*)(p + 1);
 785:	8b 45 f4             	mov    -0xc(%ebp),%eax
 788:	83 c0 08             	add    $0x8,%eax
 78b:	eb 3b                	jmp    7c8 <malloc+0xe1>
    }
    if(p == freep)
 78d:	a1 38 0a 00 00       	mov    0xa38,%eax
 792:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 795:	75 1e                	jne    7b5 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 797:	83 ec 0c             	sub    $0xc,%esp
 79a:	ff 75 ec             	pushl  -0x14(%ebp)
 79d:	e8 e5 fe ff ff       	call   687 <morecore>
 7a2:	83 c4 10             	add    $0x10,%esp
 7a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7ac:	75 07                	jne    7b5 <malloc+0xce>
        return 0;
 7ae:	b8 00 00 00 00       	mov    $0x0,%eax
 7b3:	eb 13                	jmp    7c8 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7be:	8b 00                	mov    (%eax),%eax
 7c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 7c3:	e9 6d ff ff ff       	jmp    735 <malloc+0x4e>
}
 7c8:	c9                   	leave  
 7c9:	c3                   	ret    
