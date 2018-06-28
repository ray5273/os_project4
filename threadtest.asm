
_threadtest:     file format elf32-i386


Disassembly of section .text:

00000000 <thread>:
#include "types.h"
#include "stat.h"
#include "user.h"

void *thread(void *arg){
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
	int tid = gettid(); //여기서 tid 는 pid
   6:	e8 84 04 00 00       	call   48f <gettid>
   b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int pid = getpid();
   e:	e8 3c 04 00 00       	call   44f <getpid>
  13:	89 45 f0             	mov    %eax,-0x10(%ebp)
	void *retval = (void *)0x87654321;
  16:	c7 45 ec 21 43 65 87 	movl   $0x87654321,-0x14(%ebp)

	printf(1, "Thread tid %d(pid %d) is running, arg=0x%x, retval=0x%x\n", tid, pid, (int)arg, (int)retval);
  1d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  20:	8b 45 08             	mov    0x8(%ebp),%eax
  23:	83 ec 08             	sub    $0x8,%esp
  26:	52                   	push   %edx
  27:	50                   	push   %eax
  28:	ff 75 f0             	pushl  -0x10(%ebp)
  2b:	ff 75 f4             	pushl  -0xc(%ebp)
  2e:	68 2c 09 00 00       	push   $0x92c
  33:	6a 01                	push   $0x1
  35:	e8 3c 05 00 00       	call   576 <printf>
  3a:	83 c4 20             	add    $0x20,%esp

	thread_exit(retval);
  3d:	83 ec 0c             	sub    $0xc,%esp
  40:	ff 75 ec             	pushl  -0x14(%ebp)
  43:	e8 37 04 00 00       	call   47f <thread_exit>

00000048 <main>:
    
}

int
main(int argc, char **argv)
{
  48:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  4c:	83 e4 f0             	and    $0xfffffff0,%esp
  4f:	ff 71 fc             	pushl  -0x4(%ecx)
  52:	55                   	push   %ebp
  53:	89 e5                	mov    %esp,%ebp
  55:	51                   	push   %ecx
  56:	83 ec 14             	sub    $0x14,%esp
	int tid = gettid(); // 여기서 tid는 proc->pid +1
  59:	e8 31 04 00 00       	call   48f <gettid>
  5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int pid = getpid();
  61:	e8 e9 03 00 00       	call   44f <getpid>
  66:	89 45 f0             	mov    %eax,-0x10(%ebp)
	void *stack = malloc(4096);
  69:	83 ec 0c             	sub    $0xc,%esp
  6c:	68 00 10 00 00       	push   $0x1000
  71:	e8 d3 07 00 00       	call   849 <malloc>
  76:	83 c4 10             	add    $0x10,%esp
  79:	89 45 ec             	mov    %eax,-0x14(%ebp)
	void *retval;
    printf(1,"stack: 0x%x\n",(int)stack);
  7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  7f:	83 ec 04             	sub    $0x4,%esp
  82:	50                   	push   %eax
  83:	68 65 09 00 00       	push   $0x965
  88:	6a 01                	push   $0x1
  8a:	e8 e7 04 00 00       	call   576 <printf>
  8f:	83 c4 10             	add    $0x10,%esp
    
	printf(1, "threadtest start\n");
  92:	83 ec 08             	sub    $0x8,%esp
  95:	68 72 09 00 00       	push   $0x972
  9a:	6a 01                	push   $0x1
  9c:	e8 d5 04 00 00       	call   576 <printf>
  a1:	83 c4 10             	add    $0x10,%esp

	printf(1, "Main thread: tid %d(pid %d) is running\n", tid, pid);
  a4:	ff 75 f0             	pushl  -0x10(%ebp)
  a7:	ff 75 f4             	pushl  -0xc(%ebp)
  aa:	68 84 09 00 00       	push   $0x984
  af:	6a 01                	push   $0x1
  b1:	e8 c0 04 00 00       	call   576 <printf>
  b6:	83 c4 10             	add    $0x10,%esp

	tid = thread_create(thread, 20, (void *)0x12345678, stack);
  b9:	ff 75 ec             	pushl  -0x14(%ebp)
  bc:	68 78 56 34 12       	push   $0x12345678
  c1:	6a 14                	push   $0x14
  c3:	68 00 00 00 00       	push   $0x0
  c8:	e8 aa 03 00 00       	call   477 <thread_create>
  cd:	83 c4 10             	add    $0x10,%esp
  d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(tid == -1){
  d3:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  d7:	75 25                	jne    fe <main+0xb6>
		printf(1, "thread creation failed\n");
  d9:	83 ec 08             	sub    $0x8,%esp
  dc:	68 ac 09 00 00       	push   $0x9ac
  e1:	6a 01                	push   $0x1
  e3:	e8 8e 04 00 00       	call   576 <printf>
  e8:	83 c4 10             	add    $0x10,%esp
		free(stack);
  eb:	83 ec 0c             	sub    $0xc,%esp
  ee:	ff 75 ec             	pushl  -0x14(%ebp)
  f1:	e8 11 06 00 00       	call   707 <free>
  f6:	83 c4 10             	add    $0x10,%esp
		exit();
  f9:	e8 d1 02 00 00       	call   3cf <exit>
	}
    printf(1,"after create , before join\n");
  fe:	83 ec 08             	sub    $0x8,%esp
 101:	68 c4 09 00 00       	push   $0x9c4
 106:	6a 01                	push   $0x1
 108:	e8 69 04 00 00       	call   576 <printf>
 10d:	83 c4 10             	add    $0x10,%esp
	if(thread_join(tid, &retval) == -1){
 110:	83 ec 08             	sub    $0x8,%esp
 113:	8d 45 e8             	lea    -0x18(%ebp),%eax
 116:	50                   	push   %eax
 117:	ff 75 f4             	pushl  -0xc(%ebp)
 11a:	e8 68 03 00 00       	call   487 <thread_join>
 11f:	83 c4 10             	add    $0x10,%esp
 122:	83 f8 ff             	cmp    $0xffffffff,%eax
 125:	75 28                	jne    14f <main+0x107>
		printf(1, "thread %d join failed\n", tid);
 127:	83 ec 04             	sub    $0x4,%esp
 12a:	ff 75 f4             	pushl  -0xc(%ebp)
 12d:	68 e0 09 00 00       	push   $0x9e0
 132:	6a 01                	push   $0x1
 134:	e8 3d 04 00 00       	call   576 <printf>
 139:	83 c4 10             	add    $0x10,%esp
		free(stack);
 13c:	83 ec 0c             	sub    $0xc,%esp
 13f:	ff 75 ec             	pushl  -0x14(%ebp)
 142:	e8 c0 05 00 00       	call   707 <free>
 147:	83 c4 10             	add    $0x10,%esp
		exit();
 14a:	e8 80 02 00 00       	call   3cf <exit>
	}

	free(stack);
 14f:	83 ec 0c             	sub    $0xc,%esp
 152:	ff 75 ec             	pushl  -0x14(%ebp)
 155:	e8 ad 05 00 00       	call   707 <free>
 15a:	83 c4 10             	add    $0x10,%esp
 	printf(1, "Thread tid %d is terminated, retval: 0x%x\n", tid, (int)retval);
 15d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 160:	50                   	push   %eax
 161:	ff 75 f4             	pushl  -0xc(%ebp)
 164:	68 f8 09 00 00       	push   $0x9f8
 169:	6a 01                	push   $0x1
 16b:	e8 06 04 00 00       	call   576 <printf>
 170:	83 c4 10             	add    $0x10,%esp

	exit();
 173:	e8 57 02 00 00       	call   3cf <exit>

00000178 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 178:	55                   	push   %ebp
 179:	89 e5                	mov    %esp,%ebp
 17b:	57                   	push   %edi
 17c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 17d:	8b 4d 08             	mov    0x8(%ebp),%ecx
 180:	8b 55 10             	mov    0x10(%ebp),%edx
 183:	8b 45 0c             	mov    0xc(%ebp),%eax
 186:	89 cb                	mov    %ecx,%ebx
 188:	89 df                	mov    %ebx,%edi
 18a:	89 d1                	mov    %edx,%ecx
 18c:	fc                   	cld    
 18d:	f3 aa                	rep stos %al,%es:(%edi)
 18f:	89 ca                	mov    %ecx,%edx
 191:	89 fb                	mov    %edi,%ebx
 193:	89 5d 08             	mov    %ebx,0x8(%ebp)
 196:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 199:	90                   	nop
 19a:	5b                   	pop    %ebx
 19b:	5f                   	pop    %edi
 19c:	5d                   	pop    %ebp
 19d:	c3                   	ret    

0000019e <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 19e:	55                   	push   %ebp
 19f:	89 e5                	mov    %esp,%ebp
 1a1:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1a4:	8b 45 08             	mov    0x8(%ebp),%eax
 1a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1aa:	90                   	nop
 1ab:	8b 45 08             	mov    0x8(%ebp),%eax
 1ae:	8d 50 01             	lea    0x1(%eax),%edx
 1b1:	89 55 08             	mov    %edx,0x8(%ebp)
 1b4:	8b 55 0c             	mov    0xc(%ebp),%edx
 1b7:	8d 4a 01             	lea    0x1(%edx),%ecx
 1ba:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 1bd:	0f b6 12             	movzbl (%edx),%edx
 1c0:	88 10                	mov    %dl,(%eax)
 1c2:	0f b6 00             	movzbl (%eax),%eax
 1c5:	84 c0                	test   %al,%al
 1c7:	75 e2                	jne    1ab <strcpy+0xd>
    ;
  return os;
 1c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1cc:	c9                   	leave  
 1cd:	c3                   	ret    

000001ce <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1ce:	55                   	push   %ebp
 1cf:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 1d1:	eb 08                	jmp    1db <strcmp+0xd>
    p++, q++;
 1d3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1d7:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1db:	8b 45 08             	mov    0x8(%ebp),%eax
 1de:	0f b6 00             	movzbl (%eax),%eax
 1e1:	84 c0                	test   %al,%al
 1e3:	74 10                	je     1f5 <strcmp+0x27>
 1e5:	8b 45 08             	mov    0x8(%ebp),%eax
 1e8:	0f b6 10             	movzbl (%eax),%edx
 1eb:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ee:	0f b6 00             	movzbl (%eax),%eax
 1f1:	38 c2                	cmp    %al,%dl
 1f3:	74 de                	je     1d3 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1f5:	8b 45 08             	mov    0x8(%ebp),%eax
 1f8:	0f b6 00             	movzbl (%eax),%eax
 1fb:	0f b6 d0             	movzbl %al,%edx
 1fe:	8b 45 0c             	mov    0xc(%ebp),%eax
 201:	0f b6 00             	movzbl (%eax),%eax
 204:	0f b6 c0             	movzbl %al,%eax
 207:	29 c2                	sub    %eax,%edx
 209:	89 d0                	mov    %edx,%eax
}
 20b:	5d                   	pop    %ebp
 20c:	c3                   	ret    

0000020d <strlen>:

uint
strlen(char *s)
{
 20d:	55                   	push   %ebp
 20e:	89 e5                	mov    %esp,%ebp
 210:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 213:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 21a:	eb 04                	jmp    220 <strlen+0x13>
 21c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 220:	8b 55 fc             	mov    -0x4(%ebp),%edx
 223:	8b 45 08             	mov    0x8(%ebp),%eax
 226:	01 d0                	add    %edx,%eax
 228:	0f b6 00             	movzbl (%eax),%eax
 22b:	84 c0                	test   %al,%al
 22d:	75 ed                	jne    21c <strlen+0xf>
    ;
  return n;
 22f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 232:	c9                   	leave  
 233:	c3                   	ret    

00000234 <memset>:

void*
memset(void *dst, int c, uint n)
{
 234:	55                   	push   %ebp
 235:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 237:	8b 45 10             	mov    0x10(%ebp),%eax
 23a:	50                   	push   %eax
 23b:	ff 75 0c             	pushl  0xc(%ebp)
 23e:	ff 75 08             	pushl  0x8(%ebp)
 241:	e8 32 ff ff ff       	call   178 <stosb>
 246:	83 c4 0c             	add    $0xc,%esp
  return dst;
 249:	8b 45 08             	mov    0x8(%ebp),%eax
}
 24c:	c9                   	leave  
 24d:	c3                   	ret    

0000024e <strchr>:

char*
strchr(const char *s, char c)
{
 24e:	55                   	push   %ebp
 24f:	89 e5                	mov    %esp,%ebp
 251:	83 ec 04             	sub    $0x4,%esp
 254:	8b 45 0c             	mov    0xc(%ebp),%eax
 257:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 25a:	eb 14                	jmp    270 <strchr+0x22>
    if(*s == c)
 25c:	8b 45 08             	mov    0x8(%ebp),%eax
 25f:	0f b6 00             	movzbl (%eax),%eax
 262:	3a 45 fc             	cmp    -0x4(%ebp),%al
 265:	75 05                	jne    26c <strchr+0x1e>
      return (char*)s;
 267:	8b 45 08             	mov    0x8(%ebp),%eax
 26a:	eb 13                	jmp    27f <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 26c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 270:	8b 45 08             	mov    0x8(%ebp),%eax
 273:	0f b6 00             	movzbl (%eax),%eax
 276:	84 c0                	test   %al,%al
 278:	75 e2                	jne    25c <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 27a:	b8 00 00 00 00       	mov    $0x0,%eax
}
 27f:	c9                   	leave  
 280:	c3                   	ret    

00000281 <gets>:

char*
gets(char *buf, int max)
{
 281:	55                   	push   %ebp
 282:	89 e5                	mov    %esp,%ebp
 284:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 287:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 28e:	eb 42                	jmp    2d2 <gets+0x51>
    cc = read(0, &c, 1);
 290:	83 ec 04             	sub    $0x4,%esp
 293:	6a 01                	push   $0x1
 295:	8d 45 ef             	lea    -0x11(%ebp),%eax
 298:	50                   	push   %eax
 299:	6a 00                	push   $0x0
 29b:	e8 47 01 00 00       	call   3e7 <read>
 2a0:	83 c4 10             	add    $0x10,%esp
 2a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 2a6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 2aa:	7e 33                	jle    2df <gets+0x5e>
      break;
    buf[i++] = c;
 2ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2af:	8d 50 01             	lea    0x1(%eax),%edx
 2b2:	89 55 f4             	mov    %edx,-0xc(%ebp)
 2b5:	89 c2                	mov    %eax,%edx
 2b7:	8b 45 08             	mov    0x8(%ebp),%eax
 2ba:	01 c2                	add    %eax,%edx
 2bc:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2c0:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 2c2:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2c6:	3c 0a                	cmp    $0xa,%al
 2c8:	74 16                	je     2e0 <gets+0x5f>
 2ca:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2ce:	3c 0d                	cmp    $0xd,%al
 2d0:	74 0e                	je     2e0 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2d5:	83 c0 01             	add    $0x1,%eax
 2d8:	3b 45 0c             	cmp    0xc(%ebp),%eax
 2db:	7c b3                	jl     290 <gets+0xf>
 2dd:	eb 01                	jmp    2e0 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 2df:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 2e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2e3:	8b 45 08             	mov    0x8(%ebp),%eax
 2e6:	01 d0                	add    %edx,%eax
 2e8:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2eb:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2ee:	c9                   	leave  
 2ef:	c3                   	ret    

000002f0 <stat>:

int
stat(char *n, struct stat *st)
{
 2f0:	55                   	push   %ebp
 2f1:	89 e5                	mov    %esp,%ebp
 2f3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2f6:	83 ec 08             	sub    $0x8,%esp
 2f9:	6a 00                	push   $0x0
 2fb:	ff 75 08             	pushl  0x8(%ebp)
 2fe:	e8 0c 01 00 00       	call   40f <open>
 303:	83 c4 10             	add    $0x10,%esp
 306:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 309:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 30d:	79 07                	jns    316 <stat+0x26>
    return -1;
 30f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 314:	eb 25                	jmp    33b <stat+0x4b>
  r = fstat(fd, st);
 316:	83 ec 08             	sub    $0x8,%esp
 319:	ff 75 0c             	pushl  0xc(%ebp)
 31c:	ff 75 f4             	pushl  -0xc(%ebp)
 31f:	e8 03 01 00 00       	call   427 <fstat>
 324:	83 c4 10             	add    $0x10,%esp
 327:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 32a:	83 ec 0c             	sub    $0xc,%esp
 32d:	ff 75 f4             	pushl  -0xc(%ebp)
 330:	e8 c2 00 00 00       	call   3f7 <close>
 335:	83 c4 10             	add    $0x10,%esp
  return r;
 338:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 33b:	c9                   	leave  
 33c:	c3                   	ret    

0000033d <atoi>:

int
atoi(const char *s)
{
 33d:	55                   	push   %ebp
 33e:	89 e5                	mov    %esp,%ebp
 340:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 343:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 34a:	eb 25                	jmp    371 <atoi+0x34>
    n = n*10 + *s++ - '0';
 34c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 34f:	89 d0                	mov    %edx,%eax
 351:	c1 e0 02             	shl    $0x2,%eax
 354:	01 d0                	add    %edx,%eax
 356:	01 c0                	add    %eax,%eax
 358:	89 c1                	mov    %eax,%ecx
 35a:	8b 45 08             	mov    0x8(%ebp),%eax
 35d:	8d 50 01             	lea    0x1(%eax),%edx
 360:	89 55 08             	mov    %edx,0x8(%ebp)
 363:	0f b6 00             	movzbl (%eax),%eax
 366:	0f be c0             	movsbl %al,%eax
 369:	01 c8                	add    %ecx,%eax
 36b:	83 e8 30             	sub    $0x30,%eax
 36e:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 371:	8b 45 08             	mov    0x8(%ebp),%eax
 374:	0f b6 00             	movzbl (%eax),%eax
 377:	3c 2f                	cmp    $0x2f,%al
 379:	7e 0a                	jle    385 <atoi+0x48>
 37b:	8b 45 08             	mov    0x8(%ebp),%eax
 37e:	0f b6 00             	movzbl (%eax),%eax
 381:	3c 39                	cmp    $0x39,%al
 383:	7e c7                	jle    34c <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 385:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 388:	c9                   	leave  
 389:	c3                   	ret    

0000038a <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 38a:	55                   	push   %ebp
 38b:	89 e5                	mov    %esp,%ebp
 38d:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 390:	8b 45 08             	mov    0x8(%ebp),%eax
 393:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 396:	8b 45 0c             	mov    0xc(%ebp),%eax
 399:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 39c:	eb 17                	jmp    3b5 <memmove+0x2b>
    *dst++ = *src++;
 39e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3a1:	8d 50 01             	lea    0x1(%eax),%edx
 3a4:	89 55 fc             	mov    %edx,-0x4(%ebp)
 3a7:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3aa:	8d 4a 01             	lea    0x1(%edx),%ecx
 3ad:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 3b0:	0f b6 12             	movzbl (%edx),%edx
 3b3:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3b5:	8b 45 10             	mov    0x10(%ebp),%eax
 3b8:	8d 50 ff             	lea    -0x1(%eax),%edx
 3bb:	89 55 10             	mov    %edx,0x10(%ebp)
 3be:	85 c0                	test   %eax,%eax
 3c0:	7f dc                	jg     39e <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 3c2:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3c5:	c9                   	leave  
 3c6:	c3                   	ret    

000003c7 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3c7:	b8 01 00 00 00       	mov    $0x1,%eax
 3cc:	cd 40                	int    $0x40
 3ce:	c3                   	ret    

000003cf <exit>:
SYSCALL(exit)
 3cf:	b8 02 00 00 00       	mov    $0x2,%eax
 3d4:	cd 40                	int    $0x40
 3d6:	c3                   	ret    

000003d7 <wait>:
SYSCALL(wait)
 3d7:	b8 03 00 00 00       	mov    $0x3,%eax
 3dc:	cd 40                	int    $0x40
 3de:	c3                   	ret    

000003df <pipe>:
SYSCALL(pipe)
 3df:	b8 04 00 00 00       	mov    $0x4,%eax
 3e4:	cd 40                	int    $0x40
 3e6:	c3                   	ret    

000003e7 <read>:
SYSCALL(read)
 3e7:	b8 05 00 00 00       	mov    $0x5,%eax
 3ec:	cd 40                	int    $0x40
 3ee:	c3                   	ret    

000003ef <write>:
SYSCALL(write)
 3ef:	b8 10 00 00 00       	mov    $0x10,%eax
 3f4:	cd 40                	int    $0x40
 3f6:	c3                   	ret    

000003f7 <close>:
SYSCALL(close)
 3f7:	b8 15 00 00 00       	mov    $0x15,%eax
 3fc:	cd 40                	int    $0x40
 3fe:	c3                   	ret    

000003ff <kill>:
SYSCALL(kill)
 3ff:	b8 06 00 00 00       	mov    $0x6,%eax
 404:	cd 40                	int    $0x40
 406:	c3                   	ret    

00000407 <exec>:
SYSCALL(exec)
 407:	b8 07 00 00 00       	mov    $0x7,%eax
 40c:	cd 40                	int    $0x40
 40e:	c3                   	ret    

0000040f <open>:
SYSCALL(open)
 40f:	b8 0f 00 00 00       	mov    $0xf,%eax
 414:	cd 40                	int    $0x40
 416:	c3                   	ret    

00000417 <mknod>:
SYSCALL(mknod)
 417:	b8 11 00 00 00       	mov    $0x11,%eax
 41c:	cd 40                	int    $0x40
 41e:	c3                   	ret    

0000041f <unlink>:
SYSCALL(unlink)
 41f:	b8 12 00 00 00       	mov    $0x12,%eax
 424:	cd 40                	int    $0x40
 426:	c3                   	ret    

00000427 <fstat>:
SYSCALL(fstat)
 427:	b8 08 00 00 00       	mov    $0x8,%eax
 42c:	cd 40                	int    $0x40
 42e:	c3                   	ret    

0000042f <link>:
SYSCALL(link)
 42f:	b8 13 00 00 00       	mov    $0x13,%eax
 434:	cd 40                	int    $0x40
 436:	c3                   	ret    

00000437 <mkdir>:
SYSCALL(mkdir)
 437:	b8 14 00 00 00       	mov    $0x14,%eax
 43c:	cd 40                	int    $0x40
 43e:	c3                   	ret    

0000043f <chdir>:
SYSCALL(chdir)
 43f:	b8 09 00 00 00       	mov    $0x9,%eax
 444:	cd 40                	int    $0x40
 446:	c3                   	ret    

00000447 <dup>:
SYSCALL(dup)
 447:	b8 0a 00 00 00       	mov    $0xa,%eax
 44c:	cd 40                	int    $0x40
 44e:	c3                   	ret    

0000044f <getpid>:
SYSCALL(getpid)
 44f:	b8 0b 00 00 00       	mov    $0xb,%eax
 454:	cd 40                	int    $0x40
 456:	c3                   	ret    

00000457 <sbrk>:
SYSCALL(sbrk)
 457:	b8 0c 00 00 00       	mov    $0xc,%eax
 45c:	cd 40                	int    $0x40
 45e:	c3                   	ret    

0000045f <sleep>:
SYSCALL(sleep)
 45f:	b8 0d 00 00 00       	mov    $0xd,%eax
 464:	cd 40                	int    $0x40
 466:	c3                   	ret    

00000467 <uptime>:
SYSCALL(uptime)
 467:	b8 0e 00 00 00       	mov    $0xe,%eax
 46c:	cd 40                	int    $0x40
 46e:	c3                   	ret    

0000046f <halt>:
SYSCALL(halt)
 46f:	b8 16 00 00 00       	mov    $0x16,%eax
 474:	cd 40                	int    $0x40
 476:	c3                   	ret    

00000477 <thread_create>:
SYSCALL(thread_create)
 477:	b8 17 00 00 00       	mov    $0x17,%eax
 47c:	cd 40                	int    $0x40
 47e:	c3                   	ret    

0000047f <thread_exit>:
SYSCALL(thread_exit)
 47f:	b8 18 00 00 00       	mov    $0x18,%eax
 484:	cd 40                	int    $0x40
 486:	c3                   	ret    

00000487 <thread_join>:
SYSCALL(thread_join)
 487:	b8 19 00 00 00       	mov    $0x19,%eax
 48c:	cd 40                	int    $0x40
 48e:	c3                   	ret    

0000048f <gettid>:
SYSCALL(gettid)
 48f:	b8 1a 00 00 00       	mov    $0x1a,%eax
 494:	cd 40                	int    $0x40
 496:	c3                   	ret    

00000497 <clone>:
SYSCALL(clone)
 497:	b8 1b 00 00 00       	mov    $0x1b,%eax
 49c:	cd 40                	int    $0x40
 49e:	c3                   	ret    

0000049f <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 49f:	55                   	push   %ebp
 4a0:	89 e5                	mov    %esp,%ebp
 4a2:	83 ec 18             	sub    $0x18,%esp
 4a5:	8b 45 0c             	mov    0xc(%ebp),%eax
 4a8:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4ab:	83 ec 04             	sub    $0x4,%esp
 4ae:	6a 01                	push   $0x1
 4b0:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4b3:	50                   	push   %eax
 4b4:	ff 75 08             	pushl  0x8(%ebp)
 4b7:	e8 33 ff ff ff       	call   3ef <write>
 4bc:	83 c4 10             	add    $0x10,%esp
}
 4bf:	90                   	nop
 4c0:	c9                   	leave  
 4c1:	c3                   	ret    

000004c2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4c2:	55                   	push   %ebp
 4c3:	89 e5                	mov    %esp,%ebp
 4c5:	53                   	push   %ebx
 4c6:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4c9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4d0:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4d4:	74 17                	je     4ed <printint+0x2b>
 4d6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4da:	79 11                	jns    4ed <printint+0x2b>
    neg = 1;
 4dc:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4e3:	8b 45 0c             	mov    0xc(%ebp),%eax
 4e6:	f7 d8                	neg    %eax
 4e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4eb:	eb 06                	jmp    4f3 <printint+0x31>
  } else {
    x = xx;
 4ed:	8b 45 0c             	mov    0xc(%ebp),%eax
 4f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4fa:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4fd:	8d 41 01             	lea    0x1(%ecx),%eax
 500:	89 45 f4             	mov    %eax,-0xc(%ebp)
 503:	8b 5d 10             	mov    0x10(%ebp),%ebx
 506:	8b 45 ec             	mov    -0x14(%ebp),%eax
 509:	ba 00 00 00 00       	mov    $0x0,%edx
 50e:	f7 f3                	div    %ebx
 510:	89 d0                	mov    %edx,%eax
 512:	0f b6 80 90 0c 00 00 	movzbl 0xc90(%eax),%eax
 519:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 51d:	8b 5d 10             	mov    0x10(%ebp),%ebx
 520:	8b 45 ec             	mov    -0x14(%ebp),%eax
 523:	ba 00 00 00 00       	mov    $0x0,%edx
 528:	f7 f3                	div    %ebx
 52a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 52d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 531:	75 c7                	jne    4fa <printint+0x38>
  if(neg)
 533:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 537:	74 2d                	je     566 <printint+0xa4>
    buf[i++] = '-';
 539:	8b 45 f4             	mov    -0xc(%ebp),%eax
 53c:	8d 50 01             	lea    0x1(%eax),%edx
 53f:	89 55 f4             	mov    %edx,-0xc(%ebp)
 542:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 547:	eb 1d                	jmp    566 <printint+0xa4>
    putc(fd, buf[i]);
 549:	8d 55 dc             	lea    -0x24(%ebp),%edx
 54c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 54f:	01 d0                	add    %edx,%eax
 551:	0f b6 00             	movzbl (%eax),%eax
 554:	0f be c0             	movsbl %al,%eax
 557:	83 ec 08             	sub    $0x8,%esp
 55a:	50                   	push   %eax
 55b:	ff 75 08             	pushl  0x8(%ebp)
 55e:	e8 3c ff ff ff       	call   49f <putc>
 563:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 566:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 56a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 56e:	79 d9                	jns    549 <printint+0x87>
    putc(fd, buf[i]);
}
 570:	90                   	nop
 571:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 574:	c9                   	leave  
 575:	c3                   	ret    

00000576 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 576:	55                   	push   %ebp
 577:	89 e5                	mov    %esp,%ebp
 579:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 57c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 583:	8d 45 0c             	lea    0xc(%ebp),%eax
 586:	83 c0 04             	add    $0x4,%eax
 589:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 58c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 593:	e9 59 01 00 00       	jmp    6f1 <printf+0x17b>
    c = fmt[i] & 0xff;
 598:	8b 55 0c             	mov    0xc(%ebp),%edx
 59b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 59e:	01 d0                	add    %edx,%eax
 5a0:	0f b6 00             	movzbl (%eax),%eax
 5a3:	0f be c0             	movsbl %al,%eax
 5a6:	25 ff 00 00 00       	and    $0xff,%eax
 5ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5ae:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5b2:	75 2c                	jne    5e0 <printf+0x6a>
      if(c == '%'){
 5b4:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5b8:	75 0c                	jne    5c6 <printf+0x50>
        state = '%';
 5ba:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5c1:	e9 27 01 00 00       	jmp    6ed <printf+0x177>
      } else {
        putc(fd, c);
 5c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5c9:	0f be c0             	movsbl %al,%eax
 5cc:	83 ec 08             	sub    $0x8,%esp
 5cf:	50                   	push   %eax
 5d0:	ff 75 08             	pushl  0x8(%ebp)
 5d3:	e8 c7 fe ff ff       	call   49f <putc>
 5d8:	83 c4 10             	add    $0x10,%esp
 5db:	e9 0d 01 00 00       	jmp    6ed <printf+0x177>
      }
    } else if(state == '%'){
 5e0:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5e4:	0f 85 03 01 00 00    	jne    6ed <printf+0x177>
      if(c == 'd'){
 5ea:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5ee:	75 1e                	jne    60e <printf+0x98>
        printint(fd, *ap, 10, 1);
 5f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5f3:	8b 00                	mov    (%eax),%eax
 5f5:	6a 01                	push   $0x1
 5f7:	6a 0a                	push   $0xa
 5f9:	50                   	push   %eax
 5fa:	ff 75 08             	pushl  0x8(%ebp)
 5fd:	e8 c0 fe ff ff       	call   4c2 <printint>
 602:	83 c4 10             	add    $0x10,%esp
        ap++;
 605:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 609:	e9 d8 00 00 00       	jmp    6e6 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 60e:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 612:	74 06                	je     61a <printf+0xa4>
 614:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 618:	75 1e                	jne    638 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 61a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 61d:	8b 00                	mov    (%eax),%eax
 61f:	6a 00                	push   $0x0
 621:	6a 10                	push   $0x10
 623:	50                   	push   %eax
 624:	ff 75 08             	pushl  0x8(%ebp)
 627:	e8 96 fe ff ff       	call   4c2 <printint>
 62c:	83 c4 10             	add    $0x10,%esp
        ap++;
 62f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 633:	e9 ae 00 00 00       	jmp    6e6 <printf+0x170>
      } else if(c == 's'){
 638:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 63c:	75 43                	jne    681 <printf+0x10b>
        s = (char*)*ap;
 63e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 641:	8b 00                	mov    (%eax),%eax
 643:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 646:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 64a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 64e:	75 25                	jne    675 <printf+0xff>
          s = "(null)";
 650:	c7 45 f4 23 0a 00 00 	movl   $0xa23,-0xc(%ebp)
        while(*s != 0){
 657:	eb 1c                	jmp    675 <printf+0xff>
          putc(fd, *s);
 659:	8b 45 f4             	mov    -0xc(%ebp),%eax
 65c:	0f b6 00             	movzbl (%eax),%eax
 65f:	0f be c0             	movsbl %al,%eax
 662:	83 ec 08             	sub    $0x8,%esp
 665:	50                   	push   %eax
 666:	ff 75 08             	pushl  0x8(%ebp)
 669:	e8 31 fe ff ff       	call   49f <putc>
 66e:	83 c4 10             	add    $0x10,%esp
          s++;
 671:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 675:	8b 45 f4             	mov    -0xc(%ebp),%eax
 678:	0f b6 00             	movzbl (%eax),%eax
 67b:	84 c0                	test   %al,%al
 67d:	75 da                	jne    659 <printf+0xe3>
 67f:	eb 65                	jmp    6e6 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 681:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 685:	75 1d                	jne    6a4 <printf+0x12e>
        putc(fd, *ap);
 687:	8b 45 e8             	mov    -0x18(%ebp),%eax
 68a:	8b 00                	mov    (%eax),%eax
 68c:	0f be c0             	movsbl %al,%eax
 68f:	83 ec 08             	sub    $0x8,%esp
 692:	50                   	push   %eax
 693:	ff 75 08             	pushl  0x8(%ebp)
 696:	e8 04 fe ff ff       	call   49f <putc>
 69b:	83 c4 10             	add    $0x10,%esp
        ap++;
 69e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6a2:	eb 42                	jmp    6e6 <printf+0x170>
      } else if(c == '%'){
 6a4:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6a8:	75 17                	jne    6c1 <printf+0x14b>
        putc(fd, c);
 6aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6ad:	0f be c0             	movsbl %al,%eax
 6b0:	83 ec 08             	sub    $0x8,%esp
 6b3:	50                   	push   %eax
 6b4:	ff 75 08             	pushl  0x8(%ebp)
 6b7:	e8 e3 fd ff ff       	call   49f <putc>
 6bc:	83 c4 10             	add    $0x10,%esp
 6bf:	eb 25                	jmp    6e6 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6c1:	83 ec 08             	sub    $0x8,%esp
 6c4:	6a 25                	push   $0x25
 6c6:	ff 75 08             	pushl  0x8(%ebp)
 6c9:	e8 d1 fd ff ff       	call   49f <putc>
 6ce:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 6d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6d4:	0f be c0             	movsbl %al,%eax
 6d7:	83 ec 08             	sub    $0x8,%esp
 6da:	50                   	push   %eax
 6db:	ff 75 08             	pushl  0x8(%ebp)
 6de:	e8 bc fd ff ff       	call   49f <putc>
 6e3:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6e6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6ed:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6f1:	8b 55 0c             	mov    0xc(%ebp),%edx
 6f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6f7:	01 d0                	add    %edx,%eax
 6f9:	0f b6 00             	movzbl (%eax),%eax
 6fc:	84 c0                	test   %al,%al
 6fe:	0f 85 94 fe ff ff    	jne    598 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 704:	90                   	nop
 705:	c9                   	leave  
 706:	c3                   	ret    

00000707 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 707:	55                   	push   %ebp
 708:	89 e5                	mov    %esp,%ebp
 70a:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 70d:	8b 45 08             	mov    0x8(%ebp),%eax
 710:	83 e8 08             	sub    $0x8,%eax
 713:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 716:	a1 ac 0c 00 00       	mov    0xcac,%eax
 71b:	89 45 fc             	mov    %eax,-0x4(%ebp)
 71e:	eb 24                	jmp    744 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 720:	8b 45 fc             	mov    -0x4(%ebp),%eax
 723:	8b 00                	mov    (%eax),%eax
 725:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 728:	77 12                	ja     73c <free+0x35>
 72a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 730:	77 24                	ja     756 <free+0x4f>
 732:	8b 45 fc             	mov    -0x4(%ebp),%eax
 735:	8b 00                	mov    (%eax),%eax
 737:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 73a:	77 1a                	ja     756 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 73c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73f:	8b 00                	mov    (%eax),%eax
 741:	89 45 fc             	mov    %eax,-0x4(%ebp)
 744:	8b 45 f8             	mov    -0x8(%ebp),%eax
 747:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 74a:	76 d4                	jbe    720 <free+0x19>
 74c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74f:	8b 00                	mov    (%eax),%eax
 751:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 754:	76 ca                	jbe    720 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 756:	8b 45 f8             	mov    -0x8(%ebp),%eax
 759:	8b 40 04             	mov    0x4(%eax),%eax
 75c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 763:	8b 45 f8             	mov    -0x8(%ebp),%eax
 766:	01 c2                	add    %eax,%edx
 768:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76b:	8b 00                	mov    (%eax),%eax
 76d:	39 c2                	cmp    %eax,%edx
 76f:	75 24                	jne    795 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 771:	8b 45 f8             	mov    -0x8(%ebp),%eax
 774:	8b 50 04             	mov    0x4(%eax),%edx
 777:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77a:	8b 00                	mov    (%eax),%eax
 77c:	8b 40 04             	mov    0x4(%eax),%eax
 77f:	01 c2                	add    %eax,%edx
 781:	8b 45 f8             	mov    -0x8(%ebp),%eax
 784:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 787:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78a:	8b 00                	mov    (%eax),%eax
 78c:	8b 10                	mov    (%eax),%edx
 78e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 791:	89 10                	mov    %edx,(%eax)
 793:	eb 0a                	jmp    79f <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 795:	8b 45 fc             	mov    -0x4(%ebp),%eax
 798:	8b 10                	mov    (%eax),%edx
 79a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 79d:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 79f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a2:	8b 40 04             	mov    0x4(%eax),%eax
 7a5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7af:	01 d0                	add    %edx,%eax
 7b1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7b4:	75 20                	jne    7d6 <free+0xcf>
    p->s.size += bp->s.size;
 7b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b9:	8b 50 04             	mov    0x4(%eax),%edx
 7bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7bf:	8b 40 04             	mov    0x4(%eax),%eax
 7c2:	01 c2                	add    %eax,%edx
 7c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c7:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7cd:	8b 10                	mov    (%eax),%edx
 7cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d2:	89 10                	mov    %edx,(%eax)
 7d4:	eb 08                	jmp    7de <free+0xd7>
  } else
    p->s.ptr = bp;
 7d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d9:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7dc:	89 10                	mov    %edx,(%eax)
  freep = p;
 7de:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e1:	a3 ac 0c 00 00       	mov    %eax,0xcac
}
 7e6:	90                   	nop
 7e7:	c9                   	leave  
 7e8:	c3                   	ret    

000007e9 <morecore>:

static Header*
morecore(uint nu)
{
 7e9:	55                   	push   %ebp
 7ea:	89 e5                	mov    %esp,%ebp
 7ec:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7ef:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7f6:	77 07                	ja     7ff <morecore+0x16>
    nu = 4096;
 7f8:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7ff:	8b 45 08             	mov    0x8(%ebp),%eax
 802:	c1 e0 03             	shl    $0x3,%eax
 805:	83 ec 0c             	sub    $0xc,%esp
 808:	50                   	push   %eax
 809:	e8 49 fc ff ff       	call   457 <sbrk>
 80e:	83 c4 10             	add    $0x10,%esp
 811:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 814:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 818:	75 07                	jne    821 <morecore+0x38>
    return 0;
 81a:	b8 00 00 00 00       	mov    $0x0,%eax
 81f:	eb 26                	jmp    847 <morecore+0x5e>
  hp = (Header*)p;
 821:	8b 45 f4             	mov    -0xc(%ebp),%eax
 824:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 827:	8b 45 f0             	mov    -0x10(%ebp),%eax
 82a:	8b 55 08             	mov    0x8(%ebp),%edx
 82d:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 830:	8b 45 f0             	mov    -0x10(%ebp),%eax
 833:	83 c0 08             	add    $0x8,%eax
 836:	83 ec 0c             	sub    $0xc,%esp
 839:	50                   	push   %eax
 83a:	e8 c8 fe ff ff       	call   707 <free>
 83f:	83 c4 10             	add    $0x10,%esp
  return freep;
 842:	a1 ac 0c 00 00       	mov    0xcac,%eax
}
 847:	c9                   	leave  
 848:	c3                   	ret    

00000849 <malloc>:

void*
malloc(uint nbytes)
{
 849:	55                   	push   %ebp
 84a:	89 e5                	mov    %esp,%ebp
 84c:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 84f:	8b 45 08             	mov    0x8(%ebp),%eax
 852:	83 c0 07             	add    $0x7,%eax
 855:	c1 e8 03             	shr    $0x3,%eax
 858:	83 c0 01             	add    $0x1,%eax
 85b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 85e:	a1 ac 0c 00 00       	mov    0xcac,%eax
 863:	89 45 f0             	mov    %eax,-0x10(%ebp)
 866:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 86a:	75 23                	jne    88f <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 86c:	c7 45 f0 a4 0c 00 00 	movl   $0xca4,-0x10(%ebp)
 873:	8b 45 f0             	mov    -0x10(%ebp),%eax
 876:	a3 ac 0c 00 00       	mov    %eax,0xcac
 87b:	a1 ac 0c 00 00       	mov    0xcac,%eax
 880:	a3 a4 0c 00 00       	mov    %eax,0xca4
    base.s.size = 0;
 885:	c7 05 a8 0c 00 00 00 	movl   $0x0,0xca8
 88c:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 88f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 892:	8b 00                	mov    (%eax),%eax
 894:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 897:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89a:	8b 40 04             	mov    0x4(%eax),%eax
 89d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8a0:	72 4d                	jb     8ef <malloc+0xa6>
      if(p->s.size == nunits)
 8a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a5:	8b 40 04             	mov    0x4(%eax),%eax
 8a8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8ab:	75 0c                	jne    8b9 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b0:	8b 10                	mov    (%eax),%edx
 8b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8b5:	89 10                	mov    %edx,(%eax)
 8b7:	eb 26                	jmp    8df <malloc+0x96>
      else {
        p->s.size -= nunits;
 8b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8bc:	8b 40 04             	mov    0x4(%eax),%eax
 8bf:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8c2:	89 c2                	mov    %eax,%edx
 8c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c7:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8cd:	8b 40 04             	mov    0x4(%eax),%eax
 8d0:	c1 e0 03             	shl    $0x3,%eax
 8d3:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d9:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8dc:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8df:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8e2:	a3 ac 0c 00 00       	mov    %eax,0xcac
      return (void*)(p + 1);
 8e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ea:	83 c0 08             	add    $0x8,%eax
 8ed:	eb 3b                	jmp    92a <malloc+0xe1>
    }
    if(p == freep)
 8ef:	a1 ac 0c 00 00       	mov    0xcac,%eax
 8f4:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8f7:	75 1e                	jne    917 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 8f9:	83 ec 0c             	sub    $0xc,%esp
 8fc:	ff 75 ec             	pushl  -0x14(%ebp)
 8ff:	e8 e5 fe ff ff       	call   7e9 <morecore>
 904:	83 c4 10             	add    $0x10,%esp
 907:	89 45 f4             	mov    %eax,-0xc(%ebp)
 90a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 90e:	75 07                	jne    917 <malloc+0xce>
        return 0;
 910:	b8 00 00 00 00       	mov    $0x0,%eax
 915:	eb 13                	jmp    92a <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 917:	8b 45 f4             	mov    -0xc(%ebp),%eax
 91a:	89 45 f0             	mov    %eax,-0x10(%ebp)
 91d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 920:	8b 00                	mov    (%eax),%eax
 922:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 925:	e9 6d ff ff ff       	jmp    897 <malloc+0x4e>
}
 92a:	c9                   	leave  
 92b:	c3                   	ret    
