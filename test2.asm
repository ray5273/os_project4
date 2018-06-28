
_test2:     file format elf32-i386


Disassembly of section .text:

00000000 <thread>:
#include "types.h"
#include "stat.h"
#include "user.h"

void *thread(void *arg){
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 08             	sub    $0x8,%esp
	thread_exit((void *)0x87654321);
   6:	83 ec 0c             	sub    $0xc,%esp
   9:	68 21 43 65 87       	push   $0x87654321
   e:	e8 e8 03 00 00       	call   3fb <thread_exit>

00000013 <main>:
}

int
main(int argc, char **argv)
{
  13:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  17:	83 e4 f0             	and    $0xfffffff0,%esp
  1a:	ff 71 fc             	pushl  -0x4(%ecx)
  1d:	55                   	push   %ebp
  1e:	89 e5                	mov    %esp,%ebp
  20:	51                   	push   %ecx
  21:	83 ec 14             	sub    $0x14,%esp
	void *stack;
	int tid;
	void *retval;

	printf(1, "TEST2: ");
  24:	83 ec 08             	sub    $0x8,%esp
  27:	68 a8 08 00 00       	push   $0x8a8
  2c:	6a 01                	push   $0x1
  2e:	e8 bf 04 00 00       	call   4f2 <printf>
  33:	83 c4 10             	add    $0x10,%esp

	stack = malloc(4096);
  36:	83 ec 0c             	sub    $0xc,%esp
  39:	68 00 10 00 00       	push   $0x1000
  3e:	e8 82 07 00 00       	call   7c5 <malloc>
  43:	83 c4 10             	add    $0x10,%esp
  46:	89 45 f4             	mov    %eax,-0xc(%ebp)
	
	tid = thread_create(thread, 30, (void *)0x12345678, stack);
  49:	ff 75 f4             	pushl  -0xc(%ebp)
  4c:	68 78 56 34 12       	push   $0x12345678
  51:	6a 1e                	push   $0x1e
  53:	68 00 00 00 00       	push   $0x0
  58:	e8 96 03 00 00       	call   3f3 <thread_create>
  5d:	83 c4 10             	add    $0x10,%esp
  60:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(tid == -1){
  63:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  67:	75 17                	jne    80 <main+0x6d>
		printf(1, "CREATE WRONG\n");
  69:	83 ec 08             	sub    $0x8,%esp
  6c:	68 b0 08 00 00       	push   $0x8b0
  71:	6a 01                	push   $0x1
  73:	e8 7a 04 00 00       	call   4f2 <printf>
  78:	83 c4 10             	add    $0x10,%esp
		exit();
  7b:	e8 cb 02 00 00       	call   34b <exit>
	}

	if(thread_join(tid, &retval) == -1){
  80:	83 ec 08             	sub    $0x8,%esp
  83:	8d 45 ec             	lea    -0x14(%ebp),%eax
  86:	50                   	push   %eax
  87:	ff 75 f0             	pushl  -0x10(%ebp)
  8a:	e8 74 03 00 00       	call   403 <thread_join>
  8f:	83 c4 10             	add    $0x10,%esp
  92:	83 f8 ff             	cmp    $0xffffffff,%eax
  95:	75 17                	jne    ae <main+0x9b>
		printf(1, "JOIN WRONG\n");
  97:	83 ec 08             	sub    $0x8,%esp
  9a:	68 be 08 00 00       	push   $0x8be
  9f:	6a 01                	push   $0x1
  a1:	e8 4c 04 00 00       	call   4f2 <printf>
  a6:	83 c4 10             	add    $0x10,%esp
		exit();
  a9:	e8 9d 02 00 00       	call   34b <exit>
	}

	if(retval != (void *)0x87654321){
  ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  b1:	3d 21 43 65 87       	cmp    $0x87654321,%eax
  b6:	74 17                	je     cf <main+0xbc>
		printf(1, "RETVAL WRONG\n");
  b8:	83 ec 08             	sub    $0x8,%esp
  bb:	68 ca 08 00 00       	push   $0x8ca
  c0:	6a 01                	push   $0x1
  c2:	e8 2b 04 00 00       	call   4f2 <printf>
  c7:	83 c4 10             	add    $0x10,%esp
		exit();
  ca:	e8 7c 02 00 00       	call   34b <exit>
	}

	free(stack);
  cf:	83 ec 0c             	sub    $0xc,%esp
  d2:	ff 75 f4             	pushl  -0xc(%ebp)
  d5:	e8 a9 05 00 00       	call   683 <free>
  da:	83 c4 10             	add    $0x10,%esp

	printf(1, "OK\n");
  dd:	83 ec 08             	sub    $0x8,%esp
  e0:	68 d8 08 00 00       	push   $0x8d8
  e5:	6a 01                	push   $0x1
  e7:	e8 06 04 00 00       	call   4f2 <printf>
  ec:	83 c4 10             	add    $0x10,%esp

	exit();
  ef:	e8 57 02 00 00       	call   34b <exit>

000000f4 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  f4:	55                   	push   %ebp
  f5:	89 e5                	mov    %esp,%ebp
  f7:	57                   	push   %edi
  f8:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  fc:	8b 55 10             	mov    0x10(%ebp),%edx
  ff:	8b 45 0c             	mov    0xc(%ebp),%eax
 102:	89 cb                	mov    %ecx,%ebx
 104:	89 df                	mov    %ebx,%edi
 106:	89 d1                	mov    %edx,%ecx
 108:	fc                   	cld    
 109:	f3 aa                	rep stos %al,%es:(%edi)
 10b:	89 ca                	mov    %ecx,%edx
 10d:	89 fb                	mov    %edi,%ebx
 10f:	89 5d 08             	mov    %ebx,0x8(%ebp)
 112:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 115:	90                   	nop
 116:	5b                   	pop    %ebx
 117:	5f                   	pop    %edi
 118:	5d                   	pop    %ebp
 119:	c3                   	ret    

0000011a <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 11a:	55                   	push   %ebp
 11b:	89 e5                	mov    %esp,%ebp
 11d:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 120:	8b 45 08             	mov    0x8(%ebp),%eax
 123:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 126:	90                   	nop
 127:	8b 45 08             	mov    0x8(%ebp),%eax
 12a:	8d 50 01             	lea    0x1(%eax),%edx
 12d:	89 55 08             	mov    %edx,0x8(%ebp)
 130:	8b 55 0c             	mov    0xc(%ebp),%edx
 133:	8d 4a 01             	lea    0x1(%edx),%ecx
 136:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 139:	0f b6 12             	movzbl (%edx),%edx
 13c:	88 10                	mov    %dl,(%eax)
 13e:	0f b6 00             	movzbl (%eax),%eax
 141:	84 c0                	test   %al,%al
 143:	75 e2                	jne    127 <strcpy+0xd>
    ;
  return os;
 145:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 148:	c9                   	leave  
 149:	c3                   	ret    

0000014a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 14a:	55                   	push   %ebp
 14b:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 14d:	eb 08                	jmp    157 <strcmp+0xd>
    p++, q++;
 14f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 153:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 157:	8b 45 08             	mov    0x8(%ebp),%eax
 15a:	0f b6 00             	movzbl (%eax),%eax
 15d:	84 c0                	test   %al,%al
 15f:	74 10                	je     171 <strcmp+0x27>
 161:	8b 45 08             	mov    0x8(%ebp),%eax
 164:	0f b6 10             	movzbl (%eax),%edx
 167:	8b 45 0c             	mov    0xc(%ebp),%eax
 16a:	0f b6 00             	movzbl (%eax),%eax
 16d:	38 c2                	cmp    %al,%dl
 16f:	74 de                	je     14f <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 171:	8b 45 08             	mov    0x8(%ebp),%eax
 174:	0f b6 00             	movzbl (%eax),%eax
 177:	0f b6 d0             	movzbl %al,%edx
 17a:	8b 45 0c             	mov    0xc(%ebp),%eax
 17d:	0f b6 00             	movzbl (%eax),%eax
 180:	0f b6 c0             	movzbl %al,%eax
 183:	29 c2                	sub    %eax,%edx
 185:	89 d0                	mov    %edx,%eax
}
 187:	5d                   	pop    %ebp
 188:	c3                   	ret    

00000189 <strlen>:

uint
strlen(char *s)
{
 189:	55                   	push   %ebp
 18a:	89 e5                	mov    %esp,%ebp
 18c:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 18f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 196:	eb 04                	jmp    19c <strlen+0x13>
 198:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 19c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 19f:	8b 45 08             	mov    0x8(%ebp),%eax
 1a2:	01 d0                	add    %edx,%eax
 1a4:	0f b6 00             	movzbl (%eax),%eax
 1a7:	84 c0                	test   %al,%al
 1a9:	75 ed                	jne    198 <strlen+0xf>
    ;
  return n;
 1ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1ae:	c9                   	leave  
 1af:	c3                   	ret    

000001b0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1b0:	55                   	push   %ebp
 1b1:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1b3:	8b 45 10             	mov    0x10(%ebp),%eax
 1b6:	50                   	push   %eax
 1b7:	ff 75 0c             	pushl  0xc(%ebp)
 1ba:	ff 75 08             	pushl  0x8(%ebp)
 1bd:	e8 32 ff ff ff       	call   f4 <stosb>
 1c2:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1c5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1c8:	c9                   	leave  
 1c9:	c3                   	ret    

000001ca <strchr>:

char*
strchr(const char *s, char c)
{
 1ca:	55                   	push   %ebp
 1cb:	89 e5                	mov    %esp,%ebp
 1cd:	83 ec 04             	sub    $0x4,%esp
 1d0:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d3:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1d6:	eb 14                	jmp    1ec <strchr+0x22>
    if(*s == c)
 1d8:	8b 45 08             	mov    0x8(%ebp),%eax
 1db:	0f b6 00             	movzbl (%eax),%eax
 1de:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1e1:	75 05                	jne    1e8 <strchr+0x1e>
      return (char*)s;
 1e3:	8b 45 08             	mov    0x8(%ebp),%eax
 1e6:	eb 13                	jmp    1fb <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1e8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1ec:	8b 45 08             	mov    0x8(%ebp),%eax
 1ef:	0f b6 00             	movzbl (%eax),%eax
 1f2:	84 c0                	test   %al,%al
 1f4:	75 e2                	jne    1d8 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1fb:	c9                   	leave  
 1fc:	c3                   	ret    

000001fd <gets>:

char*
gets(char *buf, int max)
{
 1fd:	55                   	push   %ebp
 1fe:	89 e5                	mov    %esp,%ebp
 200:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 203:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 20a:	eb 42                	jmp    24e <gets+0x51>
    cc = read(0, &c, 1);
 20c:	83 ec 04             	sub    $0x4,%esp
 20f:	6a 01                	push   $0x1
 211:	8d 45 ef             	lea    -0x11(%ebp),%eax
 214:	50                   	push   %eax
 215:	6a 00                	push   $0x0
 217:	e8 47 01 00 00       	call   363 <read>
 21c:	83 c4 10             	add    $0x10,%esp
 21f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 222:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 226:	7e 33                	jle    25b <gets+0x5e>
      break;
    buf[i++] = c;
 228:	8b 45 f4             	mov    -0xc(%ebp),%eax
 22b:	8d 50 01             	lea    0x1(%eax),%edx
 22e:	89 55 f4             	mov    %edx,-0xc(%ebp)
 231:	89 c2                	mov    %eax,%edx
 233:	8b 45 08             	mov    0x8(%ebp),%eax
 236:	01 c2                	add    %eax,%edx
 238:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 23c:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 23e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 242:	3c 0a                	cmp    $0xa,%al
 244:	74 16                	je     25c <gets+0x5f>
 246:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 24a:	3c 0d                	cmp    $0xd,%al
 24c:	74 0e                	je     25c <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 24e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 251:	83 c0 01             	add    $0x1,%eax
 254:	3b 45 0c             	cmp    0xc(%ebp),%eax
 257:	7c b3                	jl     20c <gets+0xf>
 259:	eb 01                	jmp    25c <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 25b:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 25c:	8b 55 f4             	mov    -0xc(%ebp),%edx
 25f:	8b 45 08             	mov    0x8(%ebp),%eax
 262:	01 d0                	add    %edx,%eax
 264:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 267:	8b 45 08             	mov    0x8(%ebp),%eax
}
 26a:	c9                   	leave  
 26b:	c3                   	ret    

0000026c <stat>:

int
stat(char *n, struct stat *st)
{
 26c:	55                   	push   %ebp
 26d:	89 e5                	mov    %esp,%ebp
 26f:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 272:	83 ec 08             	sub    $0x8,%esp
 275:	6a 00                	push   $0x0
 277:	ff 75 08             	pushl  0x8(%ebp)
 27a:	e8 0c 01 00 00       	call   38b <open>
 27f:	83 c4 10             	add    $0x10,%esp
 282:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 285:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 289:	79 07                	jns    292 <stat+0x26>
    return -1;
 28b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 290:	eb 25                	jmp    2b7 <stat+0x4b>
  r = fstat(fd, st);
 292:	83 ec 08             	sub    $0x8,%esp
 295:	ff 75 0c             	pushl  0xc(%ebp)
 298:	ff 75 f4             	pushl  -0xc(%ebp)
 29b:	e8 03 01 00 00       	call   3a3 <fstat>
 2a0:	83 c4 10             	add    $0x10,%esp
 2a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2a6:	83 ec 0c             	sub    $0xc,%esp
 2a9:	ff 75 f4             	pushl  -0xc(%ebp)
 2ac:	e8 c2 00 00 00       	call   373 <close>
 2b1:	83 c4 10             	add    $0x10,%esp
  return r;
 2b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2b7:	c9                   	leave  
 2b8:	c3                   	ret    

000002b9 <atoi>:

int
atoi(const char *s)
{
 2b9:	55                   	push   %ebp
 2ba:	89 e5                	mov    %esp,%ebp
 2bc:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2bf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2c6:	eb 25                	jmp    2ed <atoi+0x34>
    n = n*10 + *s++ - '0';
 2c8:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2cb:	89 d0                	mov    %edx,%eax
 2cd:	c1 e0 02             	shl    $0x2,%eax
 2d0:	01 d0                	add    %edx,%eax
 2d2:	01 c0                	add    %eax,%eax
 2d4:	89 c1                	mov    %eax,%ecx
 2d6:	8b 45 08             	mov    0x8(%ebp),%eax
 2d9:	8d 50 01             	lea    0x1(%eax),%edx
 2dc:	89 55 08             	mov    %edx,0x8(%ebp)
 2df:	0f b6 00             	movzbl (%eax),%eax
 2e2:	0f be c0             	movsbl %al,%eax
 2e5:	01 c8                	add    %ecx,%eax
 2e7:	83 e8 30             	sub    $0x30,%eax
 2ea:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2ed:	8b 45 08             	mov    0x8(%ebp),%eax
 2f0:	0f b6 00             	movzbl (%eax),%eax
 2f3:	3c 2f                	cmp    $0x2f,%al
 2f5:	7e 0a                	jle    301 <atoi+0x48>
 2f7:	8b 45 08             	mov    0x8(%ebp),%eax
 2fa:	0f b6 00             	movzbl (%eax),%eax
 2fd:	3c 39                	cmp    $0x39,%al
 2ff:	7e c7                	jle    2c8 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 301:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 304:	c9                   	leave  
 305:	c3                   	ret    

00000306 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 306:	55                   	push   %ebp
 307:	89 e5                	mov    %esp,%ebp
 309:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 30c:	8b 45 08             	mov    0x8(%ebp),%eax
 30f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 312:	8b 45 0c             	mov    0xc(%ebp),%eax
 315:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 318:	eb 17                	jmp    331 <memmove+0x2b>
    *dst++ = *src++;
 31a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 31d:	8d 50 01             	lea    0x1(%eax),%edx
 320:	89 55 fc             	mov    %edx,-0x4(%ebp)
 323:	8b 55 f8             	mov    -0x8(%ebp),%edx
 326:	8d 4a 01             	lea    0x1(%edx),%ecx
 329:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 32c:	0f b6 12             	movzbl (%edx),%edx
 32f:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 331:	8b 45 10             	mov    0x10(%ebp),%eax
 334:	8d 50 ff             	lea    -0x1(%eax),%edx
 337:	89 55 10             	mov    %edx,0x10(%ebp)
 33a:	85 c0                	test   %eax,%eax
 33c:	7f dc                	jg     31a <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 33e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 341:	c9                   	leave  
 342:	c3                   	ret    

00000343 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 343:	b8 01 00 00 00       	mov    $0x1,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <exit>:
SYSCALL(exit)
 34b:	b8 02 00 00 00       	mov    $0x2,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <wait>:
SYSCALL(wait)
 353:	b8 03 00 00 00       	mov    $0x3,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <pipe>:
SYSCALL(pipe)
 35b:	b8 04 00 00 00       	mov    $0x4,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <read>:
SYSCALL(read)
 363:	b8 05 00 00 00       	mov    $0x5,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret    

0000036b <write>:
SYSCALL(write)
 36b:	b8 10 00 00 00       	mov    $0x10,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret    

00000373 <close>:
SYSCALL(close)
 373:	b8 15 00 00 00       	mov    $0x15,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret    

0000037b <kill>:
SYSCALL(kill)
 37b:	b8 06 00 00 00       	mov    $0x6,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret    

00000383 <exec>:
SYSCALL(exec)
 383:	b8 07 00 00 00       	mov    $0x7,%eax
 388:	cd 40                	int    $0x40
 38a:	c3                   	ret    

0000038b <open>:
SYSCALL(open)
 38b:	b8 0f 00 00 00       	mov    $0xf,%eax
 390:	cd 40                	int    $0x40
 392:	c3                   	ret    

00000393 <mknod>:
SYSCALL(mknod)
 393:	b8 11 00 00 00       	mov    $0x11,%eax
 398:	cd 40                	int    $0x40
 39a:	c3                   	ret    

0000039b <unlink>:
SYSCALL(unlink)
 39b:	b8 12 00 00 00       	mov    $0x12,%eax
 3a0:	cd 40                	int    $0x40
 3a2:	c3                   	ret    

000003a3 <fstat>:
SYSCALL(fstat)
 3a3:	b8 08 00 00 00       	mov    $0x8,%eax
 3a8:	cd 40                	int    $0x40
 3aa:	c3                   	ret    

000003ab <link>:
SYSCALL(link)
 3ab:	b8 13 00 00 00       	mov    $0x13,%eax
 3b0:	cd 40                	int    $0x40
 3b2:	c3                   	ret    

000003b3 <mkdir>:
SYSCALL(mkdir)
 3b3:	b8 14 00 00 00       	mov    $0x14,%eax
 3b8:	cd 40                	int    $0x40
 3ba:	c3                   	ret    

000003bb <chdir>:
SYSCALL(chdir)
 3bb:	b8 09 00 00 00       	mov    $0x9,%eax
 3c0:	cd 40                	int    $0x40
 3c2:	c3                   	ret    

000003c3 <dup>:
SYSCALL(dup)
 3c3:	b8 0a 00 00 00       	mov    $0xa,%eax
 3c8:	cd 40                	int    $0x40
 3ca:	c3                   	ret    

000003cb <getpid>:
SYSCALL(getpid)
 3cb:	b8 0b 00 00 00       	mov    $0xb,%eax
 3d0:	cd 40                	int    $0x40
 3d2:	c3                   	ret    

000003d3 <sbrk>:
SYSCALL(sbrk)
 3d3:	b8 0c 00 00 00       	mov    $0xc,%eax
 3d8:	cd 40                	int    $0x40
 3da:	c3                   	ret    

000003db <sleep>:
SYSCALL(sleep)
 3db:	b8 0d 00 00 00       	mov    $0xd,%eax
 3e0:	cd 40                	int    $0x40
 3e2:	c3                   	ret    

000003e3 <uptime>:
SYSCALL(uptime)
 3e3:	b8 0e 00 00 00       	mov    $0xe,%eax
 3e8:	cd 40                	int    $0x40
 3ea:	c3                   	ret    

000003eb <halt>:
SYSCALL(halt)
 3eb:	b8 16 00 00 00       	mov    $0x16,%eax
 3f0:	cd 40                	int    $0x40
 3f2:	c3                   	ret    

000003f3 <thread_create>:
SYSCALL(thread_create)
 3f3:	b8 17 00 00 00       	mov    $0x17,%eax
 3f8:	cd 40                	int    $0x40
 3fa:	c3                   	ret    

000003fb <thread_exit>:
SYSCALL(thread_exit)
 3fb:	b8 18 00 00 00       	mov    $0x18,%eax
 400:	cd 40                	int    $0x40
 402:	c3                   	ret    

00000403 <thread_join>:
SYSCALL(thread_join)
 403:	b8 19 00 00 00       	mov    $0x19,%eax
 408:	cd 40                	int    $0x40
 40a:	c3                   	ret    

0000040b <gettid>:
SYSCALL(gettid)
 40b:	b8 1a 00 00 00       	mov    $0x1a,%eax
 410:	cd 40                	int    $0x40
 412:	c3                   	ret    

00000413 <clone>:
SYSCALL(clone)
 413:	b8 1b 00 00 00       	mov    $0x1b,%eax
 418:	cd 40                	int    $0x40
 41a:	c3                   	ret    

0000041b <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 41b:	55                   	push   %ebp
 41c:	89 e5                	mov    %esp,%ebp
 41e:	83 ec 18             	sub    $0x18,%esp
 421:	8b 45 0c             	mov    0xc(%ebp),%eax
 424:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 427:	83 ec 04             	sub    $0x4,%esp
 42a:	6a 01                	push   $0x1
 42c:	8d 45 f4             	lea    -0xc(%ebp),%eax
 42f:	50                   	push   %eax
 430:	ff 75 08             	pushl  0x8(%ebp)
 433:	e8 33 ff ff ff       	call   36b <write>
 438:	83 c4 10             	add    $0x10,%esp
}
 43b:	90                   	nop
 43c:	c9                   	leave  
 43d:	c3                   	ret    

0000043e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 43e:	55                   	push   %ebp
 43f:	89 e5                	mov    %esp,%ebp
 441:	53                   	push   %ebx
 442:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 445:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 44c:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 450:	74 17                	je     469 <printint+0x2b>
 452:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 456:	79 11                	jns    469 <printint+0x2b>
    neg = 1;
 458:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 45f:	8b 45 0c             	mov    0xc(%ebp),%eax
 462:	f7 d8                	neg    %eax
 464:	89 45 ec             	mov    %eax,-0x14(%ebp)
 467:	eb 06                	jmp    46f <printint+0x31>
  } else {
    x = xx;
 469:	8b 45 0c             	mov    0xc(%ebp),%eax
 46c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 46f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 476:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 479:	8d 41 01             	lea    0x1(%ecx),%eax
 47c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 47f:	8b 5d 10             	mov    0x10(%ebp),%ebx
 482:	8b 45 ec             	mov    -0x14(%ebp),%eax
 485:	ba 00 00 00 00       	mov    $0x0,%edx
 48a:	f7 f3                	div    %ebx
 48c:	89 d0                	mov    %edx,%eax
 48e:	0f b6 80 48 0b 00 00 	movzbl 0xb48(%eax),%eax
 495:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 499:	8b 5d 10             	mov    0x10(%ebp),%ebx
 49c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 49f:	ba 00 00 00 00       	mov    $0x0,%edx
 4a4:	f7 f3                	div    %ebx
 4a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4a9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4ad:	75 c7                	jne    476 <printint+0x38>
  if(neg)
 4af:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4b3:	74 2d                	je     4e2 <printint+0xa4>
    buf[i++] = '-';
 4b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4b8:	8d 50 01             	lea    0x1(%eax),%edx
 4bb:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4be:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4c3:	eb 1d                	jmp    4e2 <printint+0xa4>
    putc(fd, buf[i]);
 4c5:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4cb:	01 d0                	add    %edx,%eax
 4cd:	0f b6 00             	movzbl (%eax),%eax
 4d0:	0f be c0             	movsbl %al,%eax
 4d3:	83 ec 08             	sub    $0x8,%esp
 4d6:	50                   	push   %eax
 4d7:	ff 75 08             	pushl  0x8(%ebp)
 4da:	e8 3c ff ff ff       	call   41b <putc>
 4df:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4e2:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4ea:	79 d9                	jns    4c5 <printint+0x87>
    putc(fd, buf[i]);
}
 4ec:	90                   	nop
 4ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4f0:	c9                   	leave  
 4f1:	c3                   	ret    

000004f2 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4f2:	55                   	push   %ebp
 4f3:	89 e5                	mov    %esp,%ebp
 4f5:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4f8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4ff:	8d 45 0c             	lea    0xc(%ebp),%eax
 502:	83 c0 04             	add    $0x4,%eax
 505:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 508:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 50f:	e9 59 01 00 00       	jmp    66d <printf+0x17b>
    c = fmt[i] & 0xff;
 514:	8b 55 0c             	mov    0xc(%ebp),%edx
 517:	8b 45 f0             	mov    -0x10(%ebp),%eax
 51a:	01 d0                	add    %edx,%eax
 51c:	0f b6 00             	movzbl (%eax),%eax
 51f:	0f be c0             	movsbl %al,%eax
 522:	25 ff 00 00 00       	and    $0xff,%eax
 527:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 52a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 52e:	75 2c                	jne    55c <printf+0x6a>
      if(c == '%'){
 530:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 534:	75 0c                	jne    542 <printf+0x50>
        state = '%';
 536:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 53d:	e9 27 01 00 00       	jmp    669 <printf+0x177>
      } else {
        putc(fd, c);
 542:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 545:	0f be c0             	movsbl %al,%eax
 548:	83 ec 08             	sub    $0x8,%esp
 54b:	50                   	push   %eax
 54c:	ff 75 08             	pushl  0x8(%ebp)
 54f:	e8 c7 fe ff ff       	call   41b <putc>
 554:	83 c4 10             	add    $0x10,%esp
 557:	e9 0d 01 00 00       	jmp    669 <printf+0x177>
      }
    } else if(state == '%'){
 55c:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 560:	0f 85 03 01 00 00    	jne    669 <printf+0x177>
      if(c == 'd'){
 566:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 56a:	75 1e                	jne    58a <printf+0x98>
        printint(fd, *ap, 10, 1);
 56c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 56f:	8b 00                	mov    (%eax),%eax
 571:	6a 01                	push   $0x1
 573:	6a 0a                	push   $0xa
 575:	50                   	push   %eax
 576:	ff 75 08             	pushl  0x8(%ebp)
 579:	e8 c0 fe ff ff       	call   43e <printint>
 57e:	83 c4 10             	add    $0x10,%esp
        ap++;
 581:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 585:	e9 d8 00 00 00       	jmp    662 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 58a:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 58e:	74 06                	je     596 <printf+0xa4>
 590:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 594:	75 1e                	jne    5b4 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 596:	8b 45 e8             	mov    -0x18(%ebp),%eax
 599:	8b 00                	mov    (%eax),%eax
 59b:	6a 00                	push   $0x0
 59d:	6a 10                	push   $0x10
 59f:	50                   	push   %eax
 5a0:	ff 75 08             	pushl  0x8(%ebp)
 5a3:	e8 96 fe ff ff       	call   43e <printint>
 5a8:	83 c4 10             	add    $0x10,%esp
        ap++;
 5ab:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5af:	e9 ae 00 00 00       	jmp    662 <printf+0x170>
      } else if(c == 's'){
 5b4:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5b8:	75 43                	jne    5fd <printf+0x10b>
        s = (char*)*ap;
 5ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5bd:	8b 00                	mov    (%eax),%eax
 5bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5c2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5ca:	75 25                	jne    5f1 <printf+0xff>
          s = "(null)";
 5cc:	c7 45 f4 dc 08 00 00 	movl   $0x8dc,-0xc(%ebp)
        while(*s != 0){
 5d3:	eb 1c                	jmp    5f1 <printf+0xff>
          putc(fd, *s);
 5d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5d8:	0f b6 00             	movzbl (%eax),%eax
 5db:	0f be c0             	movsbl %al,%eax
 5de:	83 ec 08             	sub    $0x8,%esp
 5e1:	50                   	push   %eax
 5e2:	ff 75 08             	pushl  0x8(%ebp)
 5e5:	e8 31 fe ff ff       	call   41b <putc>
 5ea:	83 c4 10             	add    $0x10,%esp
          s++;
 5ed:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5f4:	0f b6 00             	movzbl (%eax),%eax
 5f7:	84 c0                	test   %al,%al
 5f9:	75 da                	jne    5d5 <printf+0xe3>
 5fb:	eb 65                	jmp    662 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5fd:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 601:	75 1d                	jne    620 <printf+0x12e>
        putc(fd, *ap);
 603:	8b 45 e8             	mov    -0x18(%ebp),%eax
 606:	8b 00                	mov    (%eax),%eax
 608:	0f be c0             	movsbl %al,%eax
 60b:	83 ec 08             	sub    $0x8,%esp
 60e:	50                   	push   %eax
 60f:	ff 75 08             	pushl  0x8(%ebp)
 612:	e8 04 fe ff ff       	call   41b <putc>
 617:	83 c4 10             	add    $0x10,%esp
        ap++;
 61a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 61e:	eb 42                	jmp    662 <printf+0x170>
      } else if(c == '%'){
 620:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 624:	75 17                	jne    63d <printf+0x14b>
        putc(fd, c);
 626:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 629:	0f be c0             	movsbl %al,%eax
 62c:	83 ec 08             	sub    $0x8,%esp
 62f:	50                   	push   %eax
 630:	ff 75 08             	pushl  0x8(%ebp)
 633:	e8 e3 fd ff ff       	call   41b <putc>
 638:	83 c4 10             	add    $0x10,%esp
 63b:	eb 25                	jmp    662 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 63d:	83 ec 08             	sub    $0x8,%esp
 640:	6a 25                	push   $0x25
 642:	ff 75 08             	pushl  0x8(%ebp)
 645:	e8 d1 fd ff ff       	call   41b <putc>
 64a:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 64d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 650:	0f be c0             	movsbl %al,%eax
 653:	83 ec 08             	sub    $0x8,%esp
 656:	50                   	push   %eax
 657:	ff 75 08             	pushl  0x8(%ebp)
 65a:	e8 bc fd ff ff       	call   41b <putc>
 65f:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 662:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 669:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 66d:	8b 55 0c             	mov    0xc(%ebp),%edx
 670:	8b 45 f0             	mov    -0x10(%ebp),%eax
 673:	01 d0                	add    %edx,%eax
 675:	0f b6 00             	movzbl (%eax),%eax
 678:	84 c0                	test   %al,%al
 67a:	0f 85 94 fe ff ff    	jne    514 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 680:	90                   	nop
 681:	c9                   	leave  
 682:	c3                   	ret    

00000683 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 683:	55                   	push   %ebp
 684:	89 e5                	mov    %esp,%ebp
 686:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 689:	8b 45 08             	mov    0x8(%ebp),%eax
 68c:	83 e8 08             	sub    $0x8,%eax
 68f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 692:	a1 64 0b 00 00       	mov    0xb64,%eax
 697:	89 45 fc             	mov    %eax,-0x4(%ebp)
 69a:	eb 24                	jmp    6c0 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 69c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69f:	8b 00                	mov    (%eax),%eax
 6a1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6a4:	77 12                	ja     6b8 <free+0x35>
 6a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6ac:	77 24                	ja     6d2 <free+0x4f>
 6ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b1:	8b 00                	mov    (%eax),%eax
 6b3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6b6:	77 1a                	ja     6d2 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bb:	8b 00                	mov    (%eax),%eax
 6bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6c6:	76 d4                	jbe    69c <free+0x19>
 6c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cb:	8b 00                	mov    (%eax),%eax
 6cd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6d0:	76 ca                	jbe    69c <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d5:	8b 40 04             	mov    0x4(%eax),%eax
 6d8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6df:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e2:	01 c2                	add    %eax,%edx
 6e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e7:	8b 00                	mov    (%eax),%eax
 6e9:	39 c2                	cmp    %eax,%edx
 6eb:	75 24                	jne    711 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f0:	8b 50 04             	mov    0x4(%eax),%edx
 6f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f6:	8b 00                	mov    (%eax),%eax
 6f8:	8b 40 04             	mov    0x4(%eax),%eax
 6fb:	01 c2                	add    %eax,%edx
 6fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 700:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 703:	8b 45 fc             	mov    -0x4(%ebp),%eax
 706:	8b 00                	mov    (%eax),%eax
 708:	8b 10                	mov    (%eax),%edx
 70a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70d:	89 10                	mov    %edx,(%eax)
 70f:	eb 0a                	jmp    71b <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 711:	8b 45 fc             	mov    -0x4(%ebp),%eax
 714:	8b 10                	mov    (%eax),%edx
 716:	8b 45 f8             	mov    -0x8(%ebp),%eax
 719:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 71b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71e:	8b 40 04             	mov    0x4(%eax),%eax
 721:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 728:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72b:	01 d0                	add    %edx,%eax
 72d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 730:	75 20                	jne    752 <free+0xcf>
    p->s.size += bp->s.size;
 732:	8b 45 fc             	mov    -0x4(%ebp),%eax
 735:	8b 50 04             	mov    0x4(%eax),%edx
 738:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73b:	8b 40 04             	mov    0x4(%eax),%eax
 73e:	01 c2                	add    %eax,%edx
 740:	8b 45 fc             	mov    -0x4(%ebp),%eax
 743:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 746:	8b 45 f8             	mov    -0x8(%ebp),%eax
 749:	8b 10                	mov    (%eax),%edx
 74b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74e:	89 10                	mov    %edx,(%eax)
 750:	eb 08                	jmp    75a <free+0xd7>
  } else
    p->s.ptr = bp;
 752:	8b 45 fc             	mov    -0x4(%ebp),%eax
 755:	8b 55 f8             	mov    -0x8(%ebp),%edx
 758:	89 10                	mov    %edx,(%eax)
  freep = p;
 75a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75d:	a3 64 0b 00 00       	mov    %eax,0xb64
}
 762:	90                   	nop
 763:	c9                   	leave  
 764:	c3                   	ret    

00000765 <morecore>:

static Header*
morecore(uint nu)
{
 765:	55                   	push   %ebp
 766:	89 e5                	mov    %esp,%ebp
 768:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 76b:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 772:	77 07                	ja     77b <morecore+0x16>
    nu = 4096;
 774:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 77b:	8b 45 08             	mov    0x8(%ebp),%eax
 77e:	c1 e0 03             	shl    $0x3,%eax
 781:	83 ec 0c             	sub    $0xc,%esp
 784:	50                   	push   %eax
 785:	e8 49 fc ff ff       	call   3d3 <sbrk>
 78a:	83 c4 10             	add    $0x10,%esp
 78d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 790:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 794:	75 07                	jne    79d <morecore+0x38>
    return 0;
 796:	b8 00 00 00 00       	mov    $0x0,%eax
 79b:	eb 26                	jmp    7c3 <morecore+0x5e>
  hp = (Header*)p;
 79d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a6:	8b 55 08             	mov    0x8(%ebp),%edx
 7a9:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7af:	83 c0 08             	add    $0x8,%eax
 7b2:	83 ec 0c             	sub    $0xc,%esp
 7b5:	50                   	push   %eax
 7b6:	e8 c8 fe ff ff       	call   683 <free>
 7bb:	83 c4 10             	add    $0x10,%esp
  return freep;
 7be:	a1 64 0b 00 00       	mov    0xb64,%eax
}
 7c3:	c9                   	leave  
 7c4:	c3                   	ret    

000007c5 <malloc>:

void*
malloc(uint nbytes)
{
 7c5:	55                   	push   %ebp
 7c6:	89 e5                	mov    %esp,%ebp
 7c8:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7cb:	8b 45 08             	mov    0x8(%ebp),%eax
 7ce:	83 c0 07             	add    $0x7,%eax
 7d1:	c1 e8 03             	shr    $0x3,%eax
 7d4:	83 c0 01             	add    $0x1,%eax
 7d7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7da:	a1 64 0b 00 00       	mov    0xb64,%eax
 7df:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7e2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7e6:	75 23                	jne    80b <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7e8:	c7 45 f0 5c 0b 00 00 	movl   $0xb5c,-0x10(%ebp)
 7ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f2:	a3 64 0b 00 00       	mov    %eax,0xb64
 7f7:	a1 64 0b 00 00       	mov    0xb64,%eax
 7fc:	a3 5c 0b 00 00       	mov    %eax,0xb5c
    base.s.size = 0;
 801:	c7 05 60 0b 00 00 00 	movl   $0x0,0xb60
 808:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 80b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80e:	8b 00                	mov    (%eax),%eax
 810:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 813:	8b 45 f4             	mov    -0xc(%ebp),%eax
 816:	8b 40 04             	mov    0x4(%eax),%eax
 819:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 81c:	72 4d                	jb     86b <malloc+0xa6>
      if(p->s.size == nunits)
 81e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 821:	8b 40 04             	mov    0x4(%eax),%eax
 824:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 827:	75 0c                	jne    835 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 829:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82c:	8b 10                	mov    (%eax),%edx
 82e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 831:	89 10                	mov    %edx,(%eax)
 833:	eb 26                	jmp    85b <malloc+0x96>
      else {
        p->s.size -= nunits;
 835:	8b 45 f4             	mov    -0xc(%ebp),%eax
 838:	8b 40 04             	mov    0x4(%eax),%eax
 83b:	2b 45 ec             	sub    -0x14(%ebp),%eax
 83e:	89 c2                	mov    %eax,%edx
 840:	8b 45 f4             	mov    -0xc(%ebp),%eax
 843:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 846:	8b 45 f4             	mov    -0xc(%ebp),%eax
 849:	8b 40 04             	mov    0x4(%eax),%eax
 84c:	c1 e0 03             	shl    $0x3,%eax
 84f:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 852:	8b 45 f4             	mov    -0xc(%ebp),%eax
 855:	8b 55 ec             	mov    -0x14(%ebp),%edx
 858:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 85b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 85e:	a3 64 0b 00 00       	mov    %eax,0xb64
      return (void*)(p + 1);
 863:	8b 45 f4             	mov    -0xc(%ebp),%eax
 866:	83 c0 08             	add    $0x8,%eax
 869:	eb 3b                	jmp    8a6 <malloc+0xe1>
    }
    if(p == freep)
 86b:	a1 64 0b 00 00       	mov    0xb64,%eax
 870:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 873:	75 1e                	jne    893 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 875:	83 ec 0c             	sub    $0xc,%esp
 878:	ff 75 ec             	pushl  -0x14(%ebp)
 87b:	e8 e5 fe ff ff       	call   765 <morecore>
 880:	83 c4 10             	add    $0x10,%esp
 883:	89 45 f4             	mov    %eax,-0xc(%ebp)
 886:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 88a:	75 07                	jne    893 <malloc+0xce>
        return 0;
 88c:	b8 00 00 00 00       	mov    $0x0,%eax
 891:	eb 13                	jmp    8a6 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 893:	8b 45 f4             	mov    -0xc(%ebp),%eax
 896:	89 45 f0             	mov    %eax,-0x10(%ebp)
 899:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89c:	8b 00                	mov    (%eax),%eax
 89e:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8a1:	e9 6d ff ff ff       	jmp    813 <malloc+0x4e>
}
 8a6:	c9                   	leave  
 8a7:	c3                   	ret    
