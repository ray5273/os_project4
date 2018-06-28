
_test1:     file format elf32-i386


Disassembly of section .text:

00000000 <thread>:
#include "types.h"
#include "stat.h"
#include "user.h"

void *thread(void *arg){
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 08             	sub    $0x8,%esp
	if(arg != (void *)0x12345678){
   6:	81 7d 08 78 56 34 12 	cmpl   $0x12345678,0x8(%ebp)
   d:	74 17                	je     26 <thread+0x26>
		printf(1, "WRONG\n");
   f:	83 ec 08             	sub    $0x8,%esp
  12:	68 76 08 00 00       	push   $0x876
  17:	6a 01                	push   $0x1
  19:	e8 a2 04 00 00       	call   4c0 <printf>
  1e:	83 c4 10             	add    $0x10,%esp
		exit();
  21:	e8 f3 02 00 00       	call   319 <exit>
	}

	thread_exit(0);
  26:	83 ec 0c             	sub    $0xc,%esp
  29:	6a 00                	push   $0x0
  2b:	e8 99 03 00 00       	call   3c9 <thread_exit>

00000030 <main>:
}

int
main(int argc, char **argv)
{
  30:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  34:	83 e4 f0             	and    $0xfffffff0,%esp
  37:	ff 71 fc             	pushl  -0x4(%ecx)
  3a:	55                   	push   %ebp
  3b:	89 e5                	mov    %esp,%ebp
  3d:	51                   	push   %ecx
  3e:	83 ec 14             	sub    $0x14,%esp
	void *stack;
	int tid;

	printf(1, "TEST1: ");
  41:	83 ec 08             	sub    $0x8,%esp
  44:	68 7d 08 00 00       	push   $0x87d
  49:	6a 01                	push   $0x1
  4b:	e8 70 04 00 00       	call   4c0 <printf>
  50:	83 c4 10             	add    $0x10,%esp

	stack = malloc(4096);
  53:	83 ec 0c             	sub    $0xc,%esp
  56:	68 00 10 00 00       	push   $0x1000
  5b:	e8 33 07 00 00       	call   793 <malloc>
  60:	83 c4 10             	add    $0x10,%esp
  63:	89 45 f4             	mov    %eax,-0xc(%ebp)
	
	tid = thread_create(thread, 10, (void *)0x12345678, stack);
  66:	ff 75 f4             	pushl  -0xc(%ebp)
  69:	68 78 56 34 12       	push   $0x12345678
  6e:	6a 0a                	push   $0xa
  70:	68 00 00 00 00       	push   $0x0
  75:	e8 47 03 00 00       	call   3c1 <thread_create>
  7a:	83 c4 10             	add    $0x10,%esp
  7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(tid == -1){
  80:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  84:	75 17                	jne    9d <main+0x6d>
		printf(1, "WRONG\n");
  86:	83 ec 08             	sub    $0x8,%esp
  89:	68 76 08 00 00       	push   $0x876
  8e:	6a 01                	push   $0x1
  90:	e8 2b 04 00 00       	call   4c0 <printf>
  95:	83 c4 10             	add    $0x10,%esp
		exit();
  98:	e8 7c 02 00 00       	call   319 <exit>
	}
    //    join을 안하면 문제가 생긴다.
    //    thread_join(tid,0);
	free(stack);
  9d:	83 ec 0c             	sub    $0xc,%esp
  a0:	ff 75 f4             	pushl  -0xc(%ebp)
  a3:	e8 a9 05 00 00       	call   651 <free>
  a8:	83 c4 10             	add    $0x10,%esp

	printf(1, "OK\n");
  ab:	83 ec 08             	sub    $0x8,%esp
  ae:	68 85 08 00 00       	push   $0x885
  b3:	6a 01                	push   $0x1
  b5:	e8 06 04 00 00       	call   4c0 <printf>
  ba:	83 c4 10             	add    $0x10,%esp

	exit();
  bd:	e8 57 02 00 00       	call   319 <exit>

000000c2 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  c2:	55                   	push   %ebp
  c3:	89 e5                	mov    %esp,%ebp
  c5:	57                   	push   %edi
  c6:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ca:	8b 55 10             	mov    0x10(%ebp),%edx
  cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  d0:	89 cb                	mov    %ecx,%ebx
  d2:	89 df                	mov    %ebx,%edi
  d4:	89 d1                	mov    %edx,%ecx
  d6:	fc                   	cld    
  d7:	f3 aa                	rep stos %al,%es:(%edi)
  d9:	89 ca                	mov    %ecx,%edx
  db:	89 fb                	mov    %edi,%ebx
  dd:	89 5d 08             	mov    %ebx,0x8(%ebp)
  e0:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  e3:	90                   	nop
  e4:	5b                   	pop    %ebx
  e5:	5f                   	pop    %edi
  e6:	5d                   	pop    %ebp
  e7:	c3                   	ret    

000000e8 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  e8:	55                   	push   %ebp
  e9:	89 e5                	mov    %esp,%ebp
  eb:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  ee:	8b 45 08             	mov    0x8(%ebp),%eax
  f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  f4:	90                   	nop
  f5:	8b 45 08             	mov    0x8(%ebp),%eax
  f8:	8d 50 01             	lea    0x1(%eax),%edx
  fb:	89 55 08             	mov    %edx,0x8(%ebp)
  fe:	8b 55 0c             	mov    0xc(%ebp),%edx
 101:	8d 4a 01             	lea    0x1(%edx),%ecx
 104:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 107:	0f b6 12             	movzbl (%edx),%edx
 10a:	88 10                	mov    %dl,(%eax)
 10c:	0f b6 00             	movzbl (%eax),%eax
 10f:	84 c0                	test   %al,%al
 111:	75 e2                	jne    f5 <strcpy+0xd>
    ;
  return os;
 113:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 116:	c9                   	leave  
 117:	c3                   	ret    

00000118 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 118:	55                   	push   %ebp
 119:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 11b:	eb 08                	jmp    125 <strcmp+0xd>
    p++, q++;
 11d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 121:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 125:	8b 45 08             	mov    0x8(%ebp),%eax
 128:	0f b6 00             	movzbl (%eax),%eax
 12b:	84 c0                	test   %al,%al
 12d:	74 10                	je     13f <strcmp+0x27>
 12f:	8b 45 08             	mov    0x8(%ebp),%eax
 132:	0f b6 10             	movzbl (%eax),%edx
 135:	8b 45 0c             	mov    0xc(%ebp),%eax
 138:	0f b6 00             	movzbl (%eax),%eax
 13b:	38 c2                	cmp    %al,%dl
 13d:	74 de                	je     11d <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 13f:	8b 45 08             	mov    0x8(%ebp),%eax
 142:	0f b6 00             	movzbl (%eax),%eax
 145:	0f b6 d0             	movzbl %al,%edx
 148:	8b 45 0c             	mov    0xc(%ebp),%eax
 14b:	0f b6 00             	movzbl (%eax),%eax
 14e:	0f b6 c0             	movzbl %al,%eax
 151:	29 c2                	sub    %eax,%edx
 153:	89 d0                	mov    %edx,%eax
}
 155:	5d                   	pop    %ebp
 156:	c3                   	ret    

00000157 <strlen>:

uint
strlen(char *s)
{
 157:	55                   	push   %ebp
 158:	89 e5                	mov    %esp,%ebp
 15a:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 15d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 164:	eb 04                	jmp    16a <strlen+0x13>
 166:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 16a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 16d:	8b 45 08             	mov    0x8(%ebp),%eax
 170:	01 d0                	add    %edx,%eax
 172:	0f b6 00             	movzbl (%eax),%eax
 175:	84 c0                	test   %al,%al
 177:	75 ed                	jne    166 <strlen+0xf>
    ;
  return n;
 179:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 17c:	c9                   	leave  
 17d:	c3                   	ret    

0000017e <memset>:

void*
memset(void *dst, int c, uint n)
{
 17e:	55                   	push   %ebp
 17f:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 181:	8b 45 10             	mov    0x10(%ebp),%eax
 184:	50                   	push   %eax
 185:	ff 75 0c             	pushl  0xc(%ebp)
 188:	ff 75 08             	pushl  0x8(%ebp)
 18b:	e8 32 ff ff ff       	call   c2 <stosb>
 190:	83 c4 0c             	add    $0xc,%esp
  return dst;
 193:	8b 45 08             	mov    0x8(%ebp),%eax
}
 196:	c9                   	leave  
 197:	c3                   	ret    

00000198 <strchr>:

char*
strchr(const char *s, char c)
{
 198:	55                   	push   %ebp
 199:	89 e5                	mov    %esp,%ebp
 19b:	83 ec 04             	sub    $0x4,%esp
 19e:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a1:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1a4:	eb 14                	jmp    1ba <strchr+0x22>
    if(*s == c)
 1a6:	8b 45 08             	mov    0x8(%ebp),%eax
 1a9:	0f b6 00             	movzbl (%eax),%eax
 1ac:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1af:	75 05                	jne    1b6 <strchr+0x1e>
      return (char*)s;
 1b1:	8b 45 08             	mov    0x8(%ebp),%eax
 1b4:	eb 13                	jmp    1c9 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1b6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1ba:	8b 45 08             	mov    0x8(%ebp),%eax
 1bd:	0f b6 00             	movzbl (%eax),%eax
 1c0:	84 c0                	test   %al,%al
 1c2:	75 e2                	jne    1a6 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1c9:	c9                   	leave  
 1ca:	c3                   	ret    

000001cb <gets>:

char*
gets(char *buf, int max)
{
 1cb:	55                   	push   %ebp
 1cc:	89 e5                	mov    %esp,%ebp
 1ce:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1d1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1d8:	eb 42                	jmp    21c <gets+0x51>
    cc = read(0, &c, 1);
 1da:	83 ec 04             	sub    $0x4,%esp
 1dd:	6a 01                	push   $0x1
 1df:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1e2:	50                   	push   %eax
 1e3:	6a 00                	push   $0x0
 1e5:	e8 47 01 00 00       	call   331 <read>
 1ea:	83 c4 10             	add    $0x10,%esp
 1ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1f0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1f4:	7e 33                	jle    229 <gets+0x5e>
      break;
    buf[i++] = c;
 1f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1f9:	8d 50 01             	lea    0x1(%eax),%edx
 1fc:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1ff:	89 c2                	mov    %eax,%edx
 201:	8b 45 08             	mov    0x8(%ebp),%eax
 204:	01 c2                	add    %eax,%edx
 206:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 20a:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 20c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 210:	3c 0a                	cmp    $0xa,%al
 212:	74 16                	je     22a <gets+0x5f>
 214:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 218:	3c 0d                	cmp    $0xd,%al
 21a:	74 0e                	je     22a <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 21c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 21f:	83 c0 01             	add    $0x1,%eax
 222:	3b 45 0c             	cmp    0xc(%ebp),%eax
 225:	7c b3                	jl     1da <gets+0xf>
 227:	eb 01                	jmp    22a <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 229:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 22a:	8b 55 f4             	mov    -0xc(%ebp),%edx
 22d:	8b 45 08             	mov    0x8(%ebp),%eax
 230:	01 d0                	add    %edx,%eax
 232:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 235:	8b 45 08             	mov    0x8(%ebp),%eax
}
 238:	c9                   	leave  
 239:	c3                   	ret    

0000023a <stat>:

int
stat(char *n, struct stat *st)
{
 23a:	55                   	push   %ebp
 23b:	89 e5                	mov    %esp,%ebp
 23d:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 240:	83 ec 08             	sub    $0x8,%esp
 243:	6a 00                	push   $0x0
 245:	ff 75 08             	pushl  0x8(%ebp)
 248:	e8 0c 01 00 00       	call   359 <open>
 24d:	83 c4 10             	add    $0x10,%esp
 250:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 253:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 257:	79 07                	jns    260 <stat+0x26>
    return -1;
 259:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 25e:	eb 25                	jmp    285 <stat+0x4b>
  r = fstat(fd, st);
 260:	83 ec 08             	sub    $0x8,%esp
 263:	ff 75 0c             	pushl  0xc(%ebp)
 266:	ff 75 f4             	pushl  -0xc(%ebp)
 269:	e8 03 01 00 00       	call   371 <fstat>
 26e:	83 c4 10             	add    $0x10,%esp
 271:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 274:	83 ec 0c             	sub    $0xc,%esp
 277:	ff 75 f4             	pushl  -0xc(%ebp)
 27a:	e8 c2 00 00 00       	call   341 <close>
 27f:	83 c4 10             	add    $0x10,%esp
  return r;
 282:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 285:	c9                   	leave  
 286:	c3                   	ret    

00000287 <atoi>:

int
atoi(const char *s)
{
 287:	55                   	push   %ebp
 288:	89 e5                	mov    %esp,%ebp
 28a:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 28d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 294:	eb 25                	jmp    2bb <atoi+0x34>
    n = n*10 + *s++ - '0';
 296:	8b 55 fc             	mov    -0x4(%ebp),%edx
 299:	89 d0                	mov    %edx,%eax
 29b:	c1 e0 02             	shl    $0x2,%eax
 29e:	01 d0                	add    %edx,%eax
 2a0:	01 c0                	add    %eax,%eax
 2a2:	89 c1                	mov    %eax,%ecx
 2a4:	8b 45 08             	mov    0x8(%ebp),%eax
 2a7:	8d 50 01             	lea    0x1(%eax),%edx
 2aa:	89 55 08             	mov    %edx,0x8(%ebp)
 2ad:	0f b6 00             	movzbl (%eax),%eax
 2b0:	0f be c0             	movsbl %al,%eax
 2b3:	01 c8                	add    %ecx,%eax
 2b5:	83 e8 30             	sub    $0x30,%eax
 2b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2bb:	8b 45 08             	mov    0x8(%ebp),%eax
 2be:	0f b6 00             	movzbl (%eax),%eax
 2c1:	3c 2f                	cmp    $0x2f,%al
 2c3:	7e 0a                	jle    2cf <atoi+0x48>
 2c5:	8b 45 08             	mov    0x8(%ebp),%eax
 2c8:	0f b6 00             	movzbl (%eax),%eax
 2cb:	3c 39                	cmp    $0x39,%al
 2cd:	7e c7                	jle    296 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2d2:	c9                   	leave  
 2d3:	c3                   	ret    

000002d4 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2d4:	55                   	push   %ebp
 2d5:	89 e5                	mov    %esp,%ebp
 2d7:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2da:	8b 45 08             	mov    0x8(%ebp),%eax
 2dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2e0:	8b 45 0c             	mov    0xc(%ebp),%eax
 2e3:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2e6:	eb 17                	jmp    2ff <memmove+0x2b>
    *dst++ = *src++;
 2e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2eb:	8d 50 01             	lea    0x1(%eax),%edx
 2ee:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2f1:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2f4:	8d 4a 01             	lea    0x1(%edx),%ecx
 2f7:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2fa:	0f b6 12             	movzbl (%edx),%edx
 2fd:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2ff:	8b 45 10             	mov    0x10(%ebp),%eax
 302:	8d 50 ff             	lea    -0x1(%eax),%edx
 305:	89 55 10             	mov    %edx,0x10(%ebp)
 308:	85 c0                	test   %eax,%eax
 30a:	7f dc                	jg     2e8 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 30c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 30f:	c9                   	leave  
 310:	c3                   	ret    

00000311 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 311:	b8 01 00 00 00       	mov    $0x1,%eax
 316:	cd 40                	int    $0x40
 318:	c3                   	ret    

00000319 <exit>:
SYSCALL(exit)
 319:	b8 02 00 00 00       	mov    $0x2,%eax
 31e:	cd 40                	int    $0x40
 320:	c3                   	ret    

00000321 <wait>:
SYSCALL(wait)
 321:	b8 03 00 00 00       	mov    $0x3,%eax
 326:	cd 40                	int    $0x40
 328:	c3                   	ret    

00000329 <pipe>:
SYSCALL(pipe)
 329:	b8 04 00 00 00       	mov    $0x4,%eax
 32e:	cd 40                	int    $0x40
 330:	c3                   	ret    

00000331 <read>:
SYSCALL(read)
 331:	b8 05 00 00 00       	mov    $0x5,%eax
 336:	cd 40                	int    $0x40
 338:	c3                   	ret    

00000339 <write>:
SYSCALL(write)
 339:	b8 10 00 00 00       	mov    $0x10,%eax
 33e:	cd 40                	int    $0x40
 340:	c3                   	ret    

00000341 <close>:
SYSCALL(close)
 341:	b8 15 00 00 00       	mov    $0x15,%eax
 346:	cd 40                	int    $0x40
 348:	c3                   	ret    

00000349 <kill>:
SYSCALL(kill)
 349:	b8 06 00 00 00       	mov    $0x6,%eax
 34e:	cd 40                	int    $0x40
 350:	c3                   	ret    

00000351 <exec>:
SYSCALL(exec)
 351:	b8 07 00 00 00       	mov    $0x7,%eax
 356:	cd 40                	int    $0x40
 358:	c3                   	ret    

00000359 <open>:
SYSCALL(open)
 359:	b8 0f 00 00 00       	mov    $0xf,%eax
 35e:	cd 40                	int    $0x40
 360:	c3                   	ret    

00000361 <mknod>:
SYSCALL(mknod)
 361:	b8 11 00 00 00       	mov    $0x11,%eax
 366:	cd 40                	int    $0x40
 368:	c3                   	ret    

00000369 <unlink>:
SYSCALL(unlink)
 369:	b8 12 00 00 00       	mov    $0x12,%eax
 36e:	cd 40                	int    $0x40
 370:	c3                   	ret    

00000371 <fstat>:
SYSCALL(fstat)
 371:	b8 08 00 00 00       	mov    $0x8,%eax
 376:	cd 40                	int    $0x40
 378:	c3                   	ret    

00000379 <link>:
SYSCALL(link)
 379:	b8 13 00 00 00       	mov    $0x13,%eax
 37e:	cd 40                	int    $0x40
 380:	c3                   	ret    

00000381 <mkdir>:
SYSCALL(mkdir)
 381:	b8 14 00 00 00       	mov    $0x14,%eax
 386:	cd 40                	int    $0x40
 388:	c3                   	ret    

00000389 <chdir>:
SYSCALL(chdir)
 389:	b8 09 00 00 00       	mov    $0x9,%eax
 38e:	cd 40                	int    $0x40
 390:	c3                   	ret    

00000391 <dup>:
SYSCALL(dup)
 391:	b8 0a 00 00 00       	mov    $0xa,%eax
 396:	cd 40                	int    $0x40
 398:	c3                   	ret    

00000399 <getpid>:
SYSCALL(getpid)
 399:	b8 0b 00 00 00       	mov    $0xb,%eax
 39e:	cd 40                	int    $0x40
 3a0:	c3                   	ret    

000003a1 <sbrk>:
SYSCALL(sbrk)
 3a1:	b8 0c 00 00 00       	mov    $0xc,%eax
 3a6:	cd 40                	int    $0x40
 3a8:	c3                   	ret    

000003a9 <sleep>:
SYSCALL(sleep)
 3a9:	b8 0d 00 00 00       	mov    $0xd,%eax
 3ae:	cd 40                	int    $0x40
 3b0:	c3                   	ret    

000003b1 <uptime>:
SYSCALL(uptime)
 3b1:	b8 0e 00 00 00       	mov    $0xe,%eax
 3b6:	cd 40                	int    $0x40
 3b8:	c3                   	ret    

000003b9 <halt>:
SYSCALL(halt)
 3b9:	b8 16 00 00 00       	mov    $0x16,%eax
 3be:	cd 40                	int    $0x40
 3c0:	c3                   	ret    

000003c1 <thread_create>:
SYSCALL(thread_create)
 3c1:	b8 17 00 00 00       	mov    $0x17,%eax
 3c6:	cd 40                	int    $0x40
 3c8:	c3                   	ret    

000003c9 <thread_exit>:
SYSCALL(thread_exit)
 3c9:	b8 18 00 00 00       	mov    $0x18,%eax
 3ce:	cd 40                	int    $0x40
 3d0:	c3                   	ret    

000003d1 <thread_join>:
SYSCALL(thread_join)
 3d1:	b8 19 00 00 00       	mov    $0x19,%eax
 3d6:	cd 40                	int    $0x40
 3d8:	c3                   	ret    

000003d9 <gettid>:
SYSCALL(gettid)
 3d9:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3de:	cd 40                	int    $0x40
 3e0:	c3                   	ret    

000003e1 <clone>:
SYSCALL(clone)
 3e1:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3e6:	cd 40                	int    $0x40
 3e8:	c3                   	ret    

000003e9 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3e9:	55                   	push   %ebp
 3ea:	89 e5                	mov    %esp,%ebp
 3ec:	83 ec 18             	sub    $0x18,%esp
 3ef:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f2:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3f5:	83 ec 04             	sub    $0x4,%esp
 3f8:	6a 01                	push   $0x1
 3fa:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3fd:	50                   	push   %eax
 3fe:	ff 75 08             	pushl  0x8(%ebp)
 401:	e8 33 ff ff ff       	call   339 <write>
 406:	83 c4 10             	add    $0x10,%esp
}
 409:	90                   	nop
 40a:	c9                   	leave  
 40b:	c3                   	ret    

0000040c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 40c:	55                   	push   %ebp
 40d:	89 e5                	mov    %esp,%ebp
 40f:	53                   	push   %ebx
 410:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 413:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 41a:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 41e:	74 17                	je     437 <printint+0x2b>
 420:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 424:	79 11                	jns    437 <printint+0x2b>
    neg = 1;
 426:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 42d:	8b 45 0c             	mov    0xc(%ebp),%eax
 430:	f7 d8                	neg    %eax
 432:	89 45 ec             	mov    %eax,-0x14(%ebp)
 435:	eb 06                	jmp    43d <printint+0x31>
  } else {
    x = xx;
 437:	8b 45 0c             	mov    0xc(%ebp),%eax
 43a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 43d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 444:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 447:	8d 41 01             	lea    0x1(%ecx),%eax
 44a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 44d:	8b 5d 10             	mov    0x10(%ebp),%ebx
 450:	8b 45 ec             	mov    -0x14(%ebp),%eax
 453:	ba 00 00 00 00       	mov    $0x0,%edx
 458:	f7 f3                	div    %ebx
 45a:	89 d0                	mov    %edx,%eax
 45c:	0f b6 80 f4 0a 00 00 	movzbl 0xaf4(%eax),%eax
 463:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 467:	8b 5d 10             	mov    0x10(%ebp),%ebx
 46a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 46d:	ba 00 00 00 00       	mov    $0x0,%edx
 472:	f7 f3                	div    %ebx
 474:	89 45 ec             	mov    %eax,-0x14(%ebp)
 477:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 47b:	75 c7                	jne    444 <printint+0x38>
  if(neg)
 47d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 481:	74 2d                	je     4b0 <printint+0xa4>
    buf[i++] = '-';
 483:	8b 45 f4             	mov    -0xc(%ebp),%eax
 486:	8d 50 01             	lea    0x1(%eax),%edx
 489:	89 55 f4             	mov    %edx,-0xc(%ebp)
 48c:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 491:	eb 1d                	jmp    4b0 <printint+0xa4>
    putc(fd, buf[i]);
 493:	8d 55 dc             	lea    -0x24(%ebp),%edx
 496:	8b 45 f4             	mov    -0xc(%ebp),%eax
 499:	01 d0                	add    %edx,%eax
 49b:	0f b6 00             	movzbl (%eax),%eax
 49e:	0f be c0             	movsbl %al,%eax
 4a1:	83 ec 08             	sub    $0x8,%esp
 4a4:	50                   	push   %eax
 4a5:	ff 75 08             	pushl  0x8(%ebp)
 4a8:	e8 3c ff ff ff       	call   3e9 <putc>
 4ad:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4b0:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4b8:	79 d9                	jns    493 <printint+0x87>
    putc(fd, buf[i]);
}
 4ba:	90                   	nop
 4bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4be:	c9                   	leave  
 4bf:	c3                   	ret    

000004c0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4c0:	55                   	push   %ebp
 4c1:	89 e5                	mov    %esp,%ebp
 4c3:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4c6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4cd:	8d 45 0c             	lea    0xc(%ebp),%eax
 4d0:	83 c0 04             	add    $0x4,%eax
 4d3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4d6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4dd:	e9 59 01 00 00       	jmp    63b <printf+0x17b>
    c = fmt[i] & 0xff;
 4e2:	8b 55 0c             	mov    0xc(%ebp),%edx
 4e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4e8:	01 d0                	add    %edx,%eax
 4ea:	0f b6 00             	movzbl (%eax),%eax
 4ed:	0f be c0             	movsbl %al,%eax
 4f0:	25 ff 00 00 00       	and    $0xff,%eax
 4f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4f8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4fc:	75 2c                	jne    52a <printf+0x6a>
      if(c == '%'){
 4fe:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 502:	75 0c                	jne    510 <printf+0x50>
        state = '%';
 504:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 50b:	e9 27 01 00 00       	jmp    637 <printf+0x177>
      } else {
        putc(fd, c);
 510:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 513:	0f be c0             	movsbl %al,%eax
 516:	83 ec 08             	sub    $0x8,%esp
 519:	50                   	push   %eax
 51a:	ff 75 08             	pushl  0x8(%ebp)
 51d:	e8 c7 fe ff ff       	call   3e9 <putc>
 522:	83 c4 10             	add    $0x10,%esp
 525:	e9 0d 01 00 00       	jmp    637 <printf+0x177>
      }
    } else if(state == '%'){
 52a:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 52e:	0f 85 03 01 00 00    	jne    637 <printf+0x177>
      if(c == 'd'){
 534:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 538:	75 1e                	jne    558 <printf+0x98>
        printint(fd, *ap, 10, 1);
 53a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 53d:	8b 00                	mov    (%eax),%eax
 53f:	6a 01                	push   $0x1
 541:	6a 0a                	push   $0xa
 543:	50                   	push   %eax
 544:	ff 75 08             	pushl  0x8(%ebp)
 547:	e8 c0 fe ff ff       	call   40c <printint>
 54c:	83 c4 10             	add    $0x10,%esp
        ap++;
 54f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 553:	e9 d8 00 00 00       	jmp    630 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 558:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 55c:	74 06                	je     564 <printf+0xa4>
 55e:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 562:	75 1e                	jne    582 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 564:	8b 45 e8             	mov    -0x18(%ebp),%eax
 567:	8b 00                	mov    (%eax),%eax
 569:	6a 00                	push   $0x0
 56b:	6a 10                	push   $0x10
 56d:	50                   	push   %eax
 56e:	ff 75 08             	pushl  0x8(%ebp)
 571:	e8 96 fe ff ff       	call   40c <printint>
 576:	83 c4 10             	add    $0x10,%esp
        ap++;
 579:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 57d:	e9 ae 00 00 00       	jmp    630 <printf+0x170>
      } else if(c == 's'){
 582:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 586:	75 43                	jne    5cb <printf+0x10b>
        s = (char*)*ap;
 588:	8b 45 e8             	mov    -0x18(%ebp),%eax
 58b:	8b 00                	mov    (%eax),%eax
 58d:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 590:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 594:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 598:	75 25                	jne    5bf <printf+0xff>
          s = "(null)";
 59a:	c7 45 f4 89 08 00 00 	movl   $0x889,-0xc(%ebp)
        while(*s != 0){
 5a1:	eb 1c                	jmp    5bf <printf+0xff>
          putc(fd, *s);
 5a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5a6:	0f b6 00             	movzbl (%eax),%eax
 5a9:	0f be c0             	movsbl %al,%eax
 5ac:	83 ec 08             	sub    $0x8,%esp
 5af:	50                   	push   %eax
 5b0:	ff 75 08             	pushl  0x8(%ebp)
 5b3:	e8 31 fe ff ff       	call   3e9 <putc>
 5b8:	83 c4 10             	add    $0x10,%esp
          s++;
 5bb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5c2:	0f b6 00             	movzbl (%eax),%eax
 5c5:	84 c0                	test   %al,%al
 5c7:	75 da                	jne    5a3 <printf+0xe3>
 5c9:	eb 65                	jmp    630 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5cb:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5cf:	75 1d                	jne    5ee <printf+0x12e>
        putc(fd, *ap);
 5d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5d4:	8b 00                	mov    (%eax),%eax
 5d6:	0f be c0             	movsbl %al,%eax
 5d9:	83 ec 08             	sub    $0x8,%esp
 5dc:	50                   	push   %eax
 5dd:	ff 75 08             	pushl  0x8(%ebp)
 5e0:	e8 04 fe ff ff       	call   3e9 <putc>
 5e5:	83 c4 10             	add    $0x10,%esp
        ap++;
 5e8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5ec:	eb 42                	jmp    630 <printf+0x170>
      } else if(c == '%'){
 5ee:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5f2:	75 17                	jne    60b <printf+0x14b>
        putc(fd, c);
 5f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5f7:	0f be c0             	movsbl %al,%eax
 5fa:	83 ec 08             	sub    $0x8,%esp
 5fd:	50                   	push   %eax
 5fe:	ff 75 08             	pushl  0x8(%ebp)
 601:	e8 e3 fd ff ff       	call   3e9 <putc>
 606:	83 c4 10             	add    $0x10,%esp
 609:	eb 25                	jmp    630 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 60b:	83 ec 08             	sub    $0x8,%esp
 60e:	6a 25                	push   $0x25
 610:	ff 75 08             	pushl  0x8(%ebp)
 613:	e8 d1 fd ff ff       	call   3e9 <putc>
 618:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 61b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 61e:	0f be c0             	movsbl %al,%eax
 621:	83 ec 08             	sub    $0x8,%esp
 624:	50                   	push   %eax
 625:	ff 75 08             	pushl  0x8(%ebp)
 628:	e8 bc fd ff ff       	call   3e9 <putc>
 62d:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 630:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 637:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 63b:	8b 55 0c             	mov    0xc(%ebp),%edx
 63e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 641:	01 d0                	add    %edx,%eax
 643:	0f b6 00             	movzbl (%eax),%eax
 646:	84 c0                	test   %al,%al
 648:	0f 85 94 fe ff ff    	jne    4e2 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 64e:	90                   	nop
 64f:	c9                   	leave  
 650:	c3                   	ret    

00000651 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 651:	55                   	push   %ebp
 652:	89 e5                	mov    %esp,%ebp
 654:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 657:	8b 45 08             	mov    0x8(%ebp),%eax
 65a:	83 e8 08             	sub    $0x8,%eax
 65d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 660:	a1 10 0b 00 00       	mov    0xb10,%eax
 665:	89 45 fc             	mov    %eax,-0x4(%ebp)
 668:	eb 24                	jmp    68e <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 66a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66d:	8b 00                	mov    (%eax),%eax
 66f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 672:	77 12                	ja     686 <free+0x35>
 674:	8b 45 f8             	mov    -0x8(%ebp),%eax
 677:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 67a:	77 24                	ja     6a0 <free+0x4f>
 67c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67f:	8b 00                	mov    (%eax),%eax
 681:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 684:	77 1a                	ja     6a0 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 686:	8b 45 fc             	mov    -0x4(%ebp),%eax
 689:	8b 00                	mov    (%eax),%eax
 68b:	89 45 fc             	mov    %eax,-0x4(%ebp)
 68e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 691:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 694:	76 d4                	jbe    66a <free+0x19>
 696:	8b 45 fc             	mov    -0x4(%ebp),%eax
 699:	8b 00                	mov    (%eax),%eax
 69b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 69e:	76 ca                	jbe    66a <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a3:	8b 40 04             	mov    0x4(%eax),%eax
 6a6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b0:	01 c2                	add    %eax,%edx
 6b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b5:	8b 00                	mov    (%eax),%eax
 6b7:	39 c2                	cmp    %eax,%edx
 6b9:	75 24                	jne    6df <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6be:	8b 50 04             	mov    0x4(%eax),%edx
 6c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c4:	8b 00                	mov    (%eax),%eax
 6c6:	8b 40 04             	mov    0x4(%eax),%eax
 6c9:	01 c2                	add    %eax,%edx
 6cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ce:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d4:	8b 00                	mov    (%eax),%eax
 6d6:	8b 10                	mov    (%eax),%edx
 6d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6db:	89 10                	mov    %edx,(%eax)
 6dd:	eb 0a                	jmp    6e9 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6df:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e2:	8b 10                	mov    (%eax),%edx
 6e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e7:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ec:	8b 40 04             	mov    0x4(%eax),%eax
 6ef:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f9:	01 d0                	add    %edx,%eax
 6fb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6fe:	75 20                	jne    720 <free+0xcf>
    p->s.size += bp->s.size;
 700:	8b 45 fc             	mov    -0x4(%ebp),%eax
 703:	8b 50 04             	mov    0x4(%eax),%edx
 706:	8b 45 f8             	mov    -0x8(%ebp),%eax
 709:	8b 40 04             	mov    0x4(%eax),%eax
 70c:	01 c2                	add    %eax,%edx
 70e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 711:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 714:	8b 45 f8             	mov    -0x8(%ebp),%eax
 717:	8b 10                	mov    (%eax),%edx
 719:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71c:	89 10                	mov    %edx,(%eax)
 71e:	eb 08                	jmp    728 <free+0xd7>
  } else
    p->s.ptr = bp;
 720:	8b 45 fc             	mov    -0x4(%ebp),%eax
 723:	8b 55 f8             	mov    -0x8(%ebp),%edx
 726:	89 10                	mov    %edx,(%eax)
  freep = p;
 728:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72b:	a3 10 0b 00 00       	mov    %eax,0xb10
}
 730:	90                   	nop
 731:	c9                   	leave  
 732:	c3                   	ret    

00000733 <morecore>:

static Header*
morecore(uint nu)
{
 733:	55                   	push   %ebp
 734:	89 e5                	mov    %esp,%ebp
 736:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 739:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 740:	77 07                	ja     749 <morecore+0x16>
    nu = 4096;
 742:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 749:	8b 45 08             	mov    0x8(%ebp),%eax
 74c:	c1 e0 03             	shl    $0x3,%eax
 74f:	83 ec 0c             	sub    $0xc,%esp
 752:	50                   	push   %eax
 753:	e8 49 fc ff ff       	call   3a1 <sbrk>
 758:	83 c4 10             	add    $0x10,%esp
 75b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 75e:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 762:	75 07                	jne    76b <morecore+0x38>
    return 0;
 764:	b8 00 00 00 00       	mov    $0x0,%eax
 769:	eb 26                	jmp    791 <morecore+0x5e>
  hp = (Header*)p;
 76b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 76e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 771:	8b 45 f0             	mov    -0x10(%ebp),%eax
 774:	8b 55 08             	mov    0x8(%ebp),%edx
 777:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 77a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 77d:	83 c0 08             	add    $0x8,%eax
 780:	83 ec 0c             	sub    $0xc,%esp
 783:	50                   	push   %eax
 784:	e8 c8 fe ff ff       	call   651 <free>
 789:	83 c4 10             	add    $0x10,%esp
  return freep;
 78c:	a1 10 0b 00 00       	mov    0xb10,%eax
}
 791:	c9                   	leave  
 792:	c3                   	ret    

00000793 <malloc>:

void*
malloc(uint nbytes)
{
 793:	55                   	push   %ebp
 794:	89 e5                	mov    %esp,%ebp
 796:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 799:	8b 45 08             	mov    0x8(%ebp),%eax
 79c:	83 c0 07             	add    $0x7,%eax
 79f:	c1 e8 03             	shr    $0x3,%eax
 7a2:	83 c0 01             	add    $0x1,%eax
 7a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7a8:	a1 10 0b 00 00       	mov    0xb10,%eax
 7ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7b0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7b4:	75 23                	jne    7d9 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7b6:	c7 45 f0 08 0b 00 00 	movl   $0xb08,-0x10(%ebp)
 7bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c0:	a3 10 0b 00 00       	mov    %eax,0xb10
 7c5:	a1 10 0b 00 00       	mov    0xb10,%eax
 7ca:	a3 08 0b 00 00       	mov    %eax,0xb08
    base.s.size = 0;
 7cf:	c7 05 0c 0b 00 00 00 	movl   $0x0,0xb0c
 7d6:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7dc:	8b 00                	mov    (%eax),%eax
 7de:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e4:	8b 40 04             	mov    0x4(%eax),%eax
 7e7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7ea:	72 4d                	jb     839 <malloc+0xa6>
      if(p->s.size == nunits)
 7ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ef:	8b 40 04             	mov    0x4(%eax),%eax
 7f2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7f5:	75 0c                	jne    803 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fa:	8b 10                	mov    (%eax),%edx
 7fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ff:	89 10                	mov    %edx,(%eax)
 801:	eb 26                	jmp    829 <malloc+0x96>
      else {
        p->s.size -= nunits;
 803:	8b 45 f4             	mov    -0xc(%ebp),%eax
 806:	8b 40 04             	mov    0x4(%eax),%eax
 809:	2b 45 ec             	sub    -0x14(%ebp),%eax
 80c:	89 c2                	mov    %eax,%edx
 80e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 811:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 814:	8b 45 f4             	mov    -0xc(%ebp),%eax
 817:	8b 40 04             	mov    0x4(%eax),%eax
 81a:	c1 e0 03             	shl    $0x3,%eax
 81d:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 820:	8b 45 f4             	mov    -0xc(%ebp),%eax
 823:	8b 55 ec             	mov    -0x14(%ebp),%edx
 826:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 829:	8b 45 f0             	mov    -0x10(%ebp),%eax
 82c:	a3 10 0b 00 00       	mov    %eax,0xb10
      return (void*)(p + 1);
 831:	8b 45 f4             	mov    -0xc(%ebp),%eax
 834:	83 c0 08             	add    $0x8,%eax
 837:	eb 3b                	jmp    874 <malloc+0xe1>
    }
    if(p == freep)
 839:	a1 10 0b 00 00       	mov    0xb10,%eax
 83e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 841:	75 1e                	jne    861 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 843:	83 ec 0c             	sub    $0xc,%esp
 846:	ff 75 ec             	pushl  -0x14(%ebp)
 849:	e8 e5 fe ff ff       	call   733 <morecore>
 84e:	83 c4 10             	add    $0x10,%esp
 851:	89 45 f4             	mov    %eax,-0xc(%ebp)
 854:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 858:	75 07                	jne    861 <malloc+0xce>
        return 0;
 85a:	b8 00 00 00 00       	mov    $0x0,%eax
 85f:	eb 13                	jmp    874 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 861:	8b 45 f4             	mov    -0xc(%ebp),%eax
 864:	89 45 f0             	mov    %eax,-0x10(%ebp)
 867:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86a:	8b 00                	mov    (%eax),%eax
 86c:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 86f:	e9 6d ff ff ff       	jmp    7e1 <malloc+0x4e>
}
 874:	c9                   	leave  
 875:	c3                   	ret    
