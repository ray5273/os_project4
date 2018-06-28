
_test4:     file format elf32-i386


Disassembly of section .text:

00000000 <thread>:

void *stack[NTHREAD];
int tid[NTHREAD];
void *retval[NTHREAD];

void *thread(void *arg){
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 08             	sub    $0x8,%esp
	thread_exit((void *)gettid());
   6:	e8 a7 04 00 00       	call   4b2 <gettid>
   b:	83 ec 0c             	sub    $0xc,%esp
   e:	50                   	push   %eax
   f:	e8 8e 04 00 00       	call   4a2 <thread_exit>

00000014 <main>:
}

int
main(int argc, char **argv)
{
  14:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  18:	83 e4 f0             	and    $0xfffffff0,%esp
  1b:	ff 71 fc             	pushl  -0x4(%ecx)
  1e:	55                   	push   %ebp
  1f:	89 e5                	mov    %esp,%ebp
  21:	51                   	push   %ecx
  22:	83 ec 14             	sub    $0x14,%esp
	int i;

	printf(1, "TEST4: ");
  25:	83 ec 08             	sub    $0x8,%esp
  28:	68 4f 09 00 00       	push   $0x94f
  2d:	6a 01                	push   $0x1
  2f:	e8 65 05 00 00       	call   599 <printf>
  34:	83 c4 10             	add    $0x10,%esp

	for(i=0;i<NTHREAD;i++)
  37:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  3e:	eb 20                	jmp    60 <main+0x4c>
		stack[i] = malloc(4096);
  40:	83 ec 0c             	sub    $0xc,%esp
  43:	68 00 10 00 00       	push   $0x1000
  48:	e8 1f 08 00 00       	call   86c <malloc>
  4d:	83 c4 10             	add    $0x10,%esp
  50:	89 c2                	mov    %eax,%edx
  52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  55:	89 14 85 10 0c 00 00 	mov    %edx,0xc10(,%eax,4)
{
	int i;

	printf(1, "TEST4: ");

	for(i=0;i<NTHREAD;i++)
  5c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  60:	83 7d f4 06          	cmpl   $0x6,-0xc(%ebp)
  64:	7e da                	jle    40 <main+0x2c>
		stack[i] = malloc(4096);

	for(i=0;i<NTHREAD; i++){
  66:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  6d:	eb 52                	jmp    c1 <main+0xad>
		tid[i] = thread_create(thread, 30, 0, stack[i]);
  6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  72:	8b 04 85 10 0c 00 00 	mov    0xc10(,%eax,4),%eax
  79:	50                   	push   %eax
  7a:	6a 00                	push   $0x0
  7c:	6a 1e                	push   $0x1e
  7e:	68 00 00 00 00       	push   $0x0
  83:	e8 12 04 00 00       	call   49a <thread_create>
  88:	83 c4 10             	add    $0x10,%esp
  8b:	89 c2                	mov    %eax,%edx
  8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  90:	89 14 85 2c 0c 00 00 	mov    %edx,0xc2c(,%eax,4)
		if(tid[i] == -1){
  97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  9a:	8b 04 85 2c 0c 00 00 	mov    0xc2c(,%eax,4),%eax
  a1:	83 f8 ff             	cmp    $0xffffffff,%eax
  a4:	75 17                	jne    bd <main+0xa9>
			printf(1, "CREATE WRONG\n");
  a6:	83 ec 08             	sub    $0x8,%esp
  a9:	68 57 09 00 00       	push   $0x957
  ae:	6a 01                	push   $0x1
  b0:	e8 e4 04 00 00       	call   599 <printf>
  b5:	83 c4 10             	add    $0x10,%esp
			exit();
  b8:	e8 35 03 00 00       	call   3f2 <exit>
	printf(1, "TEST4: ");

	for(i=0;i<NTHREAD;i++)
		stack[i] = malloc(4096);

	for(i=0;i<NTHREAD; i++){
  bd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  c1:	83 7d f4 06          	cmpl   $0x6,-0xc(%ebp)
  c5:	7e a8                	jle    6f <main+0x5b>
			printf(1, "CREATE WRONG\n");
			exit();
		}
	}

	for(i=0;i<NTHREAD;i++){
  c7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  ce:	eb 43                	jmp    113 <main+0xff>
		if(thread_join(tid[i], &retval[i]) == -1){
  d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  d3:	c1 e0 02             	shl    $0x2,%eax
  d6:	8d 90 48 0c 00 00    	lea    0xc48(%eax),%edx
  dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  df:	8b 04 85 2c 0c 00 00 	mov    0xc2c(,%eax,4),%eax
  e6:	83 ec 08             	sub    $0x8,%esp
  e9:	52                   	push   %edx
  ea:	50                   	push   %eax
  eb:	e8 ba 03 00 00       	call   4aa <thread_join>
  f0:	83 c4 10             	add    $0x10,%esp
  f3:	83 f8 ff             	cmp    $0xffffffff,%eax
  f6:	75 17                	jne    10f <main+0xfb>
			printf(1, "JOIN WRONG\n");
  f8:	83 ec 08             	sub    $0x8,%esp
  fb:	68 65 09 00 00       	push   $0x965
 100:	6a 01                	push   $0x1
 102:	e8 92 04 00 00       	call   599 <printf>
 107:	83 c4 10             	add    $0x10,%esp
			exit();
 10a:	e8 e3 02 00 00       	call   3f2 <exit>
			printf(1, "CREATE WRONG\n");
			exit();
		}
	}

	for(i=0;i<NTHREAD;i++){
 10f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 113:	83 7d f4 06          	cmpl   $0x6,-0xc(%ebp)
 117:	7e b7                	jle    d0 <main+0xbc>
			printf(1, "JOIN WRONG\n");
			exit();
		}
	}

	for(i=0;i<NTHREAD;i++){
 119:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 120:	eb 33                	jmp    155 <main+0x141>
		if(tid[i] != (int)retval[i]){
 122:	8b 45 f4             	mov    -0xc(%ebp),%eax
 125:	8b 14 85 2c 0c 00 00 	mov    0xc2c(,%eax,4),%edx
 12c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 12f:	8b 04 85 48 0c 00 00 	mov    0xc48(,%eax,4),%eax
 136:	39 c2                	cmp    %eax,%edx
 138:	74 17                	je     151 <main+0x13d>
			printf(1, "RETVAL WRONG\n");
 13a:	83 ec 08             	sub    $0x8,%esp
 13d:	68 71 09 00 00       	push   $0x971
 142:	6a 01                	push   $0x1
 144:	e8 50 04 00 00       	call   599 <printf>
 149:	83 c4 10             	add    $0x10,%esp
			exit();
 14c:	e8 a1 02 00 00       	call   3f2 <exit>
			printf(1, "JOIN WRONG\n");
			exit();
		}
	}

	for(i=0;i<NTHREAD;i++){
 151:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 155:	83 7d f4 06          	cmpl   $0x6,-0xc(%ebp)
 159:	7e c7                	jle    122 <main+0x10e>
			printf(1, "RETVAL WRONG\n");
			exit();
		}
	}

	for(i=0;i<NTHREAD;i++)
 15b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 162:	eb 1a                	jmp    17e <main+0x16a>
		free(stack[i]);
 164:	8b 45 f4             	mov    -0xc(%ebp),%eax
 167:	8b 04 85 10 0c 00 00 	mov    0xc10(,%eax,4),%eax
 16e:	83 ec 0c             	sub    $0xc,%esp
 171:	50                   	push   %eax
 172:	e8 b3 05 00 00       	call   72a <free>
 177:	83 c4 10             	add    $0x10,%esp
			printf(1, "RETVAL WRONG\n");
			exit();
		}
	}

	for(i=0;i<NTHREAD;i++)
 17a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 17e:	83 7d f4 06          	cmpl   $0x6,-0xc(%ebp)
 182:	7e e0                	jle    164 <main+0x150>
		free(stack[i]);

	printf(1, "OK\n");
 184:	83 ec 08             	sub    $0x8,%esp
 187:	68 7f 09 00 00       	push   $0x97f
 18c:	6a 01                	push   $0x1
 18e:	e8 06 04 00 00       	call   599 <printf>
 193:	83 c4 10             	add    $0x10,%esp

	exit();
 196:	e8 57 02 00 00       	call   3f2 <exit>

0000019b <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 19b:	55                   	push   %ebp
 19c:	89 e5                	mov    %esp,%ebp
 19e:	57                   	push   %edi
 19f:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1a0:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1a3:	8b 55 10             	mov    0x10(%ebp),%edx
 1a6:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a9:	89 cb                	mov    %ecx,%ebx
 1ab:	89 df                	mov    %ebx,%edi
 1ad:	89 d1                	mov    %edx,%ecx
 1af:	fc                   	cld    
 1b0:	f3 aa                	rep stos %al,%es:(%edi)
 1b2:	89 ca                	mov    %ecx,%edx
 1b4:	89 fb                	mov    %edi,%ebx
 1b6:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1b9:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1bc:	90                   	nop
 1bd:	5b                   	pop    %ebx
 1be:	5f                   	pop    %edi
 1bf:	5d                   	pop    %ebp
 1c0:	c3                   	ret    

000001c1 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 1c1:	55                   	push   %ebp
 1c2:	89 e5                	mov    %esp,%ebp
 1c4:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1c7:	8b 45 08             	mov    0x8(%ebp),%eax
 1ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1cd:	90                   	nop
 1ce:	8b 45 08             	mov    0x8(%ebp),%eax
 1d1:	8d 50 01             	lea    0x1(%eax),%edx
 1d4:	89 55 08             	mov    %edx,0x8(%ebp)
 1d7:	8b 55 0c             	mov    0xc(%ebp),%edx
 1da:	8d 4a 01             	lea    0x1(%edx),%ecx
 1dd:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 1e0:	0f b6 12             	movzbl (%edx),%edx
 1e3:	88 10                	mov    %dl,(%eax)
 1e5:	0f b6 00             	movzbl (%eax),%eax
 1e8:	84 c0                	test   %al,%al
 1ea:	75 e2                	jne    1ce <strcpy+0xd>
    ;
  return os;
 1ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1ef:	c9                   	leave  
 1f0:	c3                   	ret    

000001f1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1f1:	55                   	push   %ebp
 1f2:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 1f4:	eb 08                	jmp    1fe <strcmp+0xd>
    p++, q++;
 1f6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1fa:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1fe:	8b 45 08             	mov    0x8(%ebp),%eax
 201:	0f b6 00             	movzbl (%eax),%eax
 204:	84 c0                	test   %al,%al
 206:	74 10                	je     218 <strcmp+0x27>
 208:	8b 45 08             	mov    0x8(%ebp),%eax
 20b:	0f b6 10             	movzbl (%eax),%edx
 20e:	8b 45 0c             	mov    0xc(%ebp),%eax
 211:	0f b6 00             	movzbl (%eax),%eax
 214:	38 c2                	cmp    %al,%dl
 216:	74 de                	je     1f6 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 218:	8b 45 08             	mov    0x8(%ebp),%eax
 21b:	0f b6 00             	movzbl (%eax),%eax
 21e:	0f b6 d0             	movzbl %al,%edx
 221:	8b 45 0c             	mov    0xc(%ebp),%eax
 224:	0f b6 00             	movzbl (%eax),%eax
 227:	0f b6 c0             	movzbl %al,%eax
 22a:	29 c2                	sub    %eax,%edx
 22c:	89 d0                	mov    %edx,%eax
}
 22e:	5d                   	pop    %ebp
 22f:	c3                   	ret    

00000230 <strlen>:

uint
strlen(char *s)
{
 230:	55                   	push   %ebp
 231:	89 e5                	mov    %esp,%ebp
 233:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 236:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 23d:	eb 04                	jmp    243 <strlen+0x13>
 23f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 243:	8b 55 fc             	mov    -0x4(%ebp),%edx
 246:	8b 45 08             	mov    0x8(%ebp),%eax
 249:	01 d0                	add    %edx,%eax
 24b:	0f b6 00             	movzbl (%eax),%eax
 24e:	84 c0                	test   %al,%al
 250:	75 ed                	jne    23f <strlen+0xf>
    ;
  return n;
 252:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 255:	c9                   	leave  
 256:	c3                   	ret    

00000257 <memset>:

void*
memset(void *dst, int c, uint n)
{
 257:	55                   	push   %ebp
 258:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 25a:	8b 45 10             	mov    0x10(%ebp),%eax
 25d:	50                   	push   %eax
 25e:	ff 75 0c             	pushl  0xc(%ebp)
 261:	ff 75 08             	pushl  0x8(%ebp)
 264:	e8 32 ff ff ff       	call   19b <stosb>
 269:	83 c4 0c             	add    $0xc,%esp
  return dst;
 26c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 26f:	c9                   	leave  
 270:	c3                   	ret    

00000271 <strchr>:

char*
strchr(const char *s, char c)
{
 271:	55                   	push   %ebp
 272:	89 e5                	mov    %esp,%ebp
 274:	83 ec 04             	sub    $0x4,%esp
 277:	8b 45 0c             	mov    0xc(%ebp),%eax
 27a:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 27d:	eb 14                	jmp    293 <strchr+0x22>
    if(*s == c)
 27f:	8b 45 08             	mov    0x8(%ebp),%eax
 282:	0f b6 00             	movzbl (%eax),%eax
 285:	3a 45 fc             	cmp    -0x4(%ebp),%al
 288:	75 05                	jne    28f <strchr+0x1e>
      return (char*)s;
 28a:	8b 45 08             	mov    0x8(%ebp),%eax
 28d:	eb 13                	jmp    2a2 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 28f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 293:	8b 45 08             	mov    0x8(%ebp),%eax
 296:	0f b6 00             	movzbl (%eax),%eax
 299:	84 c0                	test   %al,%al
 29b:	75 e2                	jne    27f <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 29d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2a2:	c9                   	leave  
 2a3:	c3                   	ret    

000002a4 <gets>:

char*
gets(char *buf, int max)
{
 2a4:	55                   	push   %ebp
 2a5:	89 e5                	mov    %esp,%ebp
 2a7:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2aa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2b1:	eb 42                	jmp    2f5 <gets+0x51>
    cc = read(0, &c, 1);
 2b3:	83 ec 04             	sub    $0x4,%esp
 2b6:	6a 01                	push   $0x1
 2b8:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2bb:	50                   	push   %eax
 2bc:	6a 00                	push   $0x0
 2be:	e8 47 01 00 00       	call   40a <read>
 2c3:	83 c4 10             	add    $0x10,%esp
 2c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 2c9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 2cd:	7e 33                	jle    302 <gets+0x5e>
      break;
    buf[i++] = c;
 2cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2d2:	8d 50 01             	lea    0x1(%eax),%edx
 2d5:	89 55 f4             	mov    %edx,-0xc(%ebp)
 2d8:	89 c2                	mov    %eax,%edx
 2da:	8b 45 08             	mov    0x8(%ebp),%eax
 2dd:	01 c2                	add    %eax,%edx
 2df:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2e3:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 2e5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2e9:	3c 0a                	cmp    $0xa,%al
 2eb:	74 16                	je     303 <gets+0x5f>
 2ed:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2f1:	3c 0d                	cmp    $0xd,%al
 2f3:	74 0e                	je     303 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2f8:	83 c0 01             	add    $0x1,%eax
 2fb:	3b 45 0c             	cmp    0xc(%ebp),%eax
 2fe:	7c b3                	jl     2b3 <gets+0xf>
 300:	eb 01                	jmp    303 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 302:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 303:	8b 55 f4             	mov    -0xc(%ebp),%edx
 306:	8b 45 08             	mov    0x8(%ebp),%eax
 309:	01 d0                	add    %edx,%eax
 30b:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 30e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 311:	c9                   	leave  
 312:	c3                   	ret    

00000313 <stat>:

int
stat(char *n, struct stat *st)
{
 313:	55                   	push   %ebp
 314:	89 e5                	mov    %esp,%ebp
 316:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 319:	83 ec 08             	sub    $0x8,%esp
 31c:	6a 00                	push   $0x0
 31e:	ff 75 08             	pushl  0x8(%ebp)
 321:	e8 0c 01 00 00       	call   432 <open>
 326:	83 c4 10             	add    $0x10,%esp
 329:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 32c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 330:	79 07                	jns    339 <stat+0x26>
    return -1;
 332:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 337:	eb 25                	jmp    35e <stat+0x4b>
  r = fstat(fd, st);
 339:	83 ec 08             	sub    $0x8,%esp
 33c:	ff 75 0c             	pushl  0xc(%ebp)
 33f:	ff 75 f4             	pushl  -0xc(%ebp)
 342:	e8 03 01 00 00       	call   44a <fstat>
 347:	83 c4 10             	add    $0x10,%esp
 34a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 34d:	83 ec 0c             	sub    $0xc,%esp
 350:	ff 75 f4             	pushl  -0xc(%ebp)
 353:	e8 c2 00 00 00       	call   41a <close>
 358:	83 c4 10             	add    $0x10,%esp
  return r;
 35b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 35e:	c9                   	leave  
 35f:	c3                   	ret    

00000360 <atoi>:

int
atoi(const char *s)
{
 360:	55                   	push   %ebp
 361:	89 e5                	mov    %esp,%ebp
 363:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 366:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 36d:	eb 25                	jmp    394 <atoi+0x34>
    n = n*10 + *s++ - '0';
 36f:	8b 55 fc             	mov    -0x4(%ebp),%edx
 372:	89 d0                	mov    %edx,%eax
 374:	c1 e0 02             	shl    $0x2,%eax
 377:	01 d0                	add    %edx,%eax
 379:	01 c0                	add    %eax,%eax
 37b:	89 c1                	mov    %eax,%ecx
 37d:	8b 45 08             	mov    0x8(%ebp),%eax
 380:	8d 50 01             	lea    0x1(%eax),%edx
 383:	89 55 08             	mov    %edx,0x8(%ebp)
 386:	0f b6 00             	movzbl (%eax),%eax
 389:	0f be c0             	movsbl %al,%eax
 38c:	01 c8                	add    %ecx,%eax
 38e:	83 e8 30             	sub    $0x30,%eax
 391:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 394:	8b 45 08             	mov    0x8(%ebp),%eax
 397:	0f b6 00             	movzbl (%eax),%eax
 39a:	3c 2f                	cmp    $0x2f,%al
 39c:	7e 0a                	jle    3a8 <atoi+0x48>
 39e:	8b 45 08             	mov    0x8(%ebp),%eax
 3a1:	0f b6 00             	movzbl (%eax),%eax
 3a4:	3c 39                	cmp    $0x39,%al
 3a6:	7e c7                	jle    36f <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 3a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3ab:	c9                   	leave  
 3ac:	c3                   	ret    

000003ad <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 3ad:	55                   	push   %ebp
 3ae:	89 e5                	mov    %esp,%ebp
 3b0:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 3b3:	8b 45 08             	mov    0x8(%ebp),%eax
 3b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 3b9:	8b 45 0c             	mov    0xc(%ebp),%eax
 3bc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3bf:	eb 17                	jmp    3d8 <memmove+0x2b>
    *dst++ = *src++;
 3c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3c4:	8d 50 01             	lea    0x1(%eax),%edx
 3c7:	89 55 fc             	mov    %edx,-0x4(%ebp)
 3ca:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3cd:	8d 4a 01             	lea    0x1(%edx),%ecx
 3d0:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 3d3:	0f b6 12             	movzbl (%edx),%edx
 3d6:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3d8:	8b 45 10             	mov    0x10(%ebp),%eax
 3db:	8d 50 ff             	lea    -0x1(%eax),%edx
 3de:	89 55 10             	mov    %edx,0x10(%ebp)
 3e1:	85 c0                	test   %eax,%eax
 3e3:	7f dc                	jg     3c1 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 3e5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3e8:	c9                   	leave  
 3e9:	c3                   	ret    

000003ea <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3ea:	b8 01 00 00 00       	mov    $0x1,%eax
 3ef:	cd 40                	int    $0x40
 3f1:	c3                   	ret    

000003f2 <exit>:
SYSCALL(exit)
 3f2:	b8 02 00 00 00       	mov    $0x2,%eax
 3f7:	cd 40                	int    $0x40
 3f9:	c3                   	ret    

000003fa <wait>:
SYSCALL(wait)
 3fa:	b8 03 00 00 00       	mov    $0x3,%eax
 3ff:	cd 40                	int    $0x40
 401:	c3                   	ret    

00000402 <pipe>:
SYSCALL(pipe)
 402:	b8 04 00 00 00       	mov    $0x4,%eax
 407:	cd 40                	int    $0x40
 409:	c3                   	ret    

0000040a <read>:
SYSCALL(read)
 40a:	b8 05 00 00 00       	mov    $0x5,%eax
 40f:	cd 40                	int    $0x40
 411:	c3                   	ret    

00000412 <write>:
SYSCALL(write)
 412:	b8 10 00 00 00       	mov    $0x10,%eax
 417:	cd 40                	int    $0x40
 419:	c3                   	ret    

0000041a <close>:
SYSCALL(close)
 41a:	b8 15 00 00 00       	mov    $0x15,%eax
 41f:	cd 40                	int    $0x40
 421:	c3                   	ret    

00000422 <kill>:
SYSCALL(kill)
 422:	b8 06 00 00 00       	mov    $0x6,%eax
 427:	cd 40                	int    $0x40
 429:	c3                   	ret    

0000042a <exec>:
SYSCALL(exec)
 42a:	b8 07 00 00 00       	mov    $0x7,%eax
 42f:	cd 40                	int    $0x40
 431:	c3                   	ret    

00000432 <open>:
SYSCALL(open)
 432:	b8 0f 00 00 00       	mov    $0xf,%eax
 437:	cd 40                	int    $0x40
 439:	c3                   	ret    

0000043a <mknod>:
SYSCALL(mknod)
 43a:	b8 11 00 00 00       	mov    $0x11,%eax
 43f:	cd 40                	int    $0x40
 441:	c3                   	ret    

00000442 <unlink>:
SYSCALL(unlink)
 442:	b8 12 00 00 00       	mov    $0x12,%eax
 447:	cd 40                	int    $0x40
 449:	c3                   	ret    

0000044a <fstat>:
SYSCALL(fstat)
 44a:	b8 08 00 00 00       	mov    $0x8,%eax
 44f:	cd 40                	int    $0x40
 451:	c3                   	ret    

00000452 <link>:
SYSCALL(link)
 452:	b8 13 00 00 00       	mov    $0x13,%eax
 457:	cd 40                	int    $0x40
 459:	c3                   	ret    

0000045a <mkdir>:
SYSCALL(mkdir)
 45a:	b8 14 00 00 00       	mov    $0x14,%eax
 45f:	cd 40                	int    $0x40
 461:	c3                   	ret    

00000462 <chdir>:
SYSCALL(chdir)
 462:	b8 09 00 00 00       	mov    $0x9,%eax
 467:	cd 40                	int    $0x40
 469:	c3                   	ret    

0000046a <dup>:
SYSCALL(dup)
 46a:	b8 0a 00 00 00       	mov    $0xa,%eax
 46f:	cd 40                	int    $0x40
 471:	c3                   	ret    

00000472 <getpid>:
SYSCALL(getpid)
 472:	b8 0b 00 00 00       	mov    $0xb,%eax
 477:	cd 40                	int    $0x40
 479:	c3                   	ret    

0000047a <sbrk>:
SYSCALL(sbrk)
 47a:	b8 0c 00 00 00       	mov    $0xc,%eax
 47f:	cd 40                	int    $0x40
 481:	c3                   	ret    

00000482 <sleep>:
SYSCALL(sleep)
 482:	b8 0d 00 00 00       	mov    $0xd,%eax
 487:	cd 40                	int    $0x40
 489:	c3                   	ret    

0000048a <uptime>:
SYSCALL(uptime)
 48a:	b8 0e 00 00 00       	mov    $0xe,%eax
 48f:	cd 40                	int    $0x40
 491:	c3                   	ret    

00000492 <halt>:
SYSCALL(halt)
 492:	b8 16 00 00 00       	mov    $0x16,%eax
 497:	cd 40                	int    $0x40
 499:	c3                   	ret    

0000049a <thread_create>:
SYSCALL(thread_create)
 49a:	b8 17 00 00 00       	mov    $0x17,%eax
 49f:	cd 40                	int    $0x40
 4a1:	c3                   	ret    

000004a2 <thread_exit>:
SYSCALL(thread_exit)
 4a2:	b8 18 00 00 00       	mov    $0x18,%eax
 4a7:	cd 40                	int    $0x40
 4a9:	c3                   	ret    

000004aa <thread_join>:
SYSCALL(thread_join)
 4aa:	b8 19 00 00 00       	mov    $0x19,%eax
 4af:	cd 40                	int    $0x40
 4b1:	c3                   	ret    

000004b2 <gettid>:
SYSCALL(gettid)
 4b2:	b8 1a 00 00 00       	mov    $0x1a,%eax
 4b7:	cd 40                	int    $0x40
 4b9:	c3                   	ret    

000004ba <clone>:
SYSCALL(clone)
 4ba:	b8 1b 00 00 00       	mov    $0x1b,%eax
 4bf:	cd 40                	int    $0x40
 4c1:	c3                   	ret    

000004c2 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4c2:	55                   	push   %ebp
 4c3:	89 e5                	mov    %esp,%ebp
 4c5:	83 ec 18             	sub    $0x18,%esp
 4c8:	8b 45 0c             	mov    0xc(%ebp),%eax
 4cb:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4ce:	83 ec 04             	sub    $0x4,%esp
 4d1:	6a 01                	push   $0x1
 4d3:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4d6:	50                   	push   %eax
 4d7:	ff 75 08             	pushl  0x8(%ebp)
 4da:	e8 33 ff ff ff       	call   412 <write>
 4df:	83 c4 10             	add    $0x10,%esp
}
 4e2:	90                   	nop
 4e3:	c9                   	leave  
 4e4:	c3                   	ret    

000004e5 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4e5:	55                   	push   %ebp
 4e6:	89 e5                	mov    %esp,%ebp
 4e8:	53                   	push   %ebx
 4e9:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4ec:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4f3:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4f7:	74 17                	je     510 <printint+0x2b>
 4f9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4fd:	79 11                	jns    510 <printint+0x2b>
    neg = 1;
 4ff:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 506:	8b 45 0c             	mov    0xc(%ebp),%eax
 509:	f7 d8                	neg    %eax
 50b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 50e:	eb 06                	jmp    516 <printint+0x31>
  } else {
    x = xx;
 510:	8b 45 0c             	mov    0xc(%ebp),%eax
 513:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 516:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 51d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 520:	8d 41 01             	lea    0x1(%ecx),%eax
 523:	89 45 f4             	mov    %eax,-0xc(%ebp)
 526:	8b 5d 10             	mov    0x10(%ebp),%ebx
 529:	8b 45 ec             	mov    -0x14(%ebp),%eax
 52c:	ba 00 00 00 00       	mov    $0x0,%edx
 531:	f7 f3                	div    %ebx
 533:	89 d0                	mov    %edx,%eax
 535:	0f b6 80 f0 0b 00 00 	movzbl 0xbf0(%eax),%eax
 53c:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 540:	8b 5d 10             	mov    0x10(%ebp),%ebx
 543:	8b 45 ec             	mov    -0x14(%ebp),%eax
 546:	ba 00 00 00 00       	mov    $0x0,%edx
 54b:	f7 f3                	div    %ebx
 54d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 550:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 554:	75 c7                	jne    51d <printint+0x38>
  if(neg)
 556:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 55a:	74 2d                	je     589 <printint+0xa4>
    buf[i++] = '-';
 55c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 55f:	8d 50 01             	lea    0x1(%eax),%edx
 562:	89 55 f4             	mov    %edx,-0xc(%ebp)
 565:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 56a:	eb 1d                	jmp    589 <printint+0xa4>
    putc(fd, buf[i]);
 56c:	8d 55 dc             	lea    -0x24(%ebp),%edx
 56f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 572:	01 d0                	add    %edx,%eax
 574:	0f b6 00             	movzbl (%eax),%eax
 577:	0f be c0             	movsbl %al,%eax
 57a:	83 ec 08             	sub    $0x8,%esp
 57d:	50                   	push   %eax
 57e:	ff 75 08             	pushl  0x8(%ebp)
 581:	e8 3c ff ff ff       	call   4c2 <putc>
 586:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 589:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 58d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 591:	79 d9                	jns    56c <printint+0x87>
    putc(fd, buf[i]);
}
 593:	90                   	nop
 594:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 597:	c9                   	leave  
 598:	c3                   	ret    

00000599 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 599:	55                   	push   %ebp
 59a:	89 e5                	mov    %esp,%ebp
 59c:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 59f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5a6:	8d 45 0c             	lea    0xc(%ebp),%eax
 5a9:	83 c0 04             	add    $0x4,%eax
 5ac:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5af:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5b6:	e9 59 01 00 00       	jmp    714 <printf+0x17b>
    c = fmt[i] & 0xff;
 5bb:	8b 55 0c             	mov    0xc(%ebp),%edx
 5be:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5c1:	01 d0                	add    %edx,%eax
 5c3:	0f b6 00             	movzbl (%eax),%eax
 5c6:	0f be c0             	movsbl %al,%eax
 5c9:	25 ff 00 00 00       	and    $0xff,%eax
 5ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5d1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5d5:	75 2c                	jne    603 <printf+0x6a>
      if(c == '%'){
 5d7:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5db:	75 0c                	jne    5e9 <printf+0x50>
        state = '%';
 5dd:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5e4:	e9 27 01 00 00       	jmp    710 <printf+0x177>
      } else {
        putc(fd, c);
 5e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5ec:	0f be c0             	movsbl %al,%eax
 5ef:	83 ec 08             	sub    $0x8,%esp
 5f2:	50                   	push   %eax
 5f3:	ff 75 08             	pushl  0x8(%ebp)
 5f6:	e8 c7 fe ff ff       	call   4c2 <putc>
 5fb:	83 c4 10             	add    $0x10,%esp
 5fe:	e9 0d 01 00 00       	jmp    710 <printf+0x177>
      }
    } else if(state == '%'){
 603:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 607:	0f 85 03 01 00 00    	jne    710 <printf+0x177>
      if(c == 'd'){
 60d:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 611:	75 1e                	jne    631 <printf+0x98>
        printint(fd, *ap, 10, 1);
 613:	8b 45 e8             	mov    -0x18(%ebp),%eax
 616:	8b 00                	mov    (%eax),%eax
 618:	6a 01                	push   $0x1
 61a:	6a 0a                	push   $0xa
 61c:	50                   	push   %eax
 61d:	ff 75 08             	pushl  0x8(%ebp)
 620:	e8 c0 fe ff ff       	call   4e5 <printint>
 625:	83 c4 10             	add    $0x10,%esp
        ap++;
 628:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 62c:	e9 d8 00 00 00       	jmp    709 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 631:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 635:	74 06                	je     63d <printf+0xa4>
 637:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 63b:	75 1e                	jne    65b <printf+0xc2>
        printint(fd, *ap, 16, 0);
 63d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 640:	8b 00                	mov    (%eax),%eax
 642:	6a 00                	push   $0x0
 644:	6a 10                	push   $0x10
 646:	50                   	push   %eax
 647:	ff 75 08             	pushl  0x8(%ebp)
 64a:	e8 96 fe ff ff       	call   4e5 <printint>
 64f:	83 c4 10             	add    $0x10,%esp
        ap++;
 652:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 656:	e9 ae 00 00 00       	jmp    709 <printf+0x170>
      } else if(c == 's'){
 65b:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 65f:	75 43                	jne    6a4 <printf+0x10b>
        s = (char*)*ap;
 661:	8b 45 e8             	mov    -0x18(%ebp),%eax
 664:	8b 00                	mov    (%eax),%eax
 666:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 669:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 66d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 671:	75 25                	jne    698 <printf+0xff>
          s = "(null)";
 673:	c7 45 f4 83 09 00 00 	movl   $0x983,-0xc(%ebp)
        while(*s != 0){
 67a:	eb 1c                	jmp    698 <printf+0xff>
          putc(fd, *s);
 67c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 67f:	0f b6 00             	movzbl (%eax),%eax
 682:	0f be c0             	movsbl %al,%eax
 685:	83 ec 08             	sub    $0x8,%esp
 688:	50                   	push   %eax
 689:	ff 75 08             	pushl  0x8(%ebp)
 68c:	e8 31 fe ff ff       	call   4c2 <putc>
 691:	83 c4 10             	add    $0x10,%esp
          s++;
 694:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 698:	8b 45 f4             	mov    -0xc(%ebp),%eax
 69b:	0f b6 00             	movzbl (%eax),%eax
 69e:	84 c0                	test   %al,%al
 6a0:	75 da                	jne    67c <printf+0xe3>
 6a2:	eb 65                	jmp    709 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6a4:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6a8:	75 1d                	jne    6c7 <printf+0x12e>
        putc(fd, *ap);
 6aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6ad:	8b 00                	mov    (%eax),%eax
 6af:	0f be c0             	movsbl %al,%eax
 6b2:	83 ec 08             	sub    $0x8,%esp
 6b5:	50                   	push   %eax
 6b6:	ff 75 08             	pushl  0x8(%ebp)
 6b9:	e8 04 fe ff ff       	call   4c2 <putc>
 6be:	83 c4 10             	add    $0x10,%esp
        ap++;
 6c1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6c5:	eb 42                	jmp    709 <printf+0x170>
      } else if(c == '%'){
 6c7:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6cb:	75 17                	jne    6e4 <printf+0x14b>
        putc(fd, c);
 6cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6d0:	0f be c0             	movsbl %al,%eax
 6d3:	83 ec 08             	sub    $0x8,%esp
 6d6:	50                   	push   %eax
 6d7:	ff 75 08             	pushl  0x8(%ebp)
 6da:	e8 e3 fd ff ff       	call   4c2 <putc>
 6df:	83 c4 10             	add    $0x10,%esp
 6e2:	eb 25                	jmp    709 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6e4:	83 ec 08             	sub    $0x8,%esp
 6e7:	6a 25                	push   $0x25
 6e9:	ff 75 08             	pushl  0x8(%ebp)
 6ec:	e8 d1 fd ff ff       	call   4c2 <putc>
 6f1:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 6f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6f7:	0f be c0             	movsbl %al,%eax
 6fa:	83 ec 08             	sub    $0x8,%esp
 6fd:	50                   	push   %eax
 6fe:	ff 75 08             	pushl  0x8(%ebp)
 701:	e8 bc fd ff ff       	call   4c2 <putc>
 706:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 709:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 710:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 714:	8b 55 0c             	mov    0xc(%ebp),%edx
 717:	8b 45 f0             	mov    -0x10(%ebp),%eax
 71a:	01 d0                	add    %edx,%eax
 71c:	0f b6 00             	movzbl (%eax),%eax
 71f:	84 c0                	test   %al,%al
 721:	0f 85 94 fe ff ff    	jne    5bb <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 727:	90                   	nop
 728:	c9                   	leave  
 729:	c3                   	ret    

0000072a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 72a:	55                   	push   %ebp
 72b:	89 e5                	mov    %esp,%ebp
 72d:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 730:	8b 45 08             	mov    0x8(%ebp),%eax
 733:	83 e8 08             	sub    $0x8,%eax
 736:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 739:	a1 0c 0c 00 00       	mov    0xc0c,%eax
 73e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 741:	eb 24                	jmp    767 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 743:	8b 45 fc             	mov    -0x4(%ebp),%eax
 746:	8b 00                	mov    (%eax),%eax
 748:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 74b:	77 12                	ja     75f <free+0x35>
 74d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 750:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 753:	77 24                	ja     779 <free+0x4f>
 755:	8b 45 fc             	mov    -0x4(%ebp),%eax
 758:	8b 00                	mov    (%eax),%eax
 75a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 75d:	77 1a                	ja     779 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 75f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 762:	8b 00                	mov    (%eax),%eax
 764:	89 45 fc             	mov    %eax,-0x4(%ebp)
 767:	8b 45 f8             	mov    -0x8(%ebp),%eax
 76a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 76d:	76 d4                	jbe    743 <free+0x19>
 76f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 772:	8b 00                	mov    (%eax),%eax
 774:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 777:	76 ca                	jbe    743 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 779:	8b 45 f8             	mov    -0x8(%ebp),%eax
 77c:	8b 40 04             	mov    0x4(%eax),%eax
 77f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 786:	8b 45 f8             	mov    -0x8(%ebp),%eax
 789:	01 c2                	add    %eax,%edx
 78b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78e:	8b 00                	mov    (%eax),%eax
 790:	39 c2                	cmp    %eax,%edx
 792:	75 24                	jne    7b8 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 794:	8b 45 f8             	mov    -0x8(%ebp),%eax
 797:	8b 50 04             	mov    0x4(%eax),%edx
 79a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79d:	8b 00                	mov    (%eax),%eax
 79f:	8b 40 04             	mov    0x4(%eax),%eax
 7a2:	01 c2                	add    %eax,%edx
 7a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a7:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ad:	8b 00                	mov    (%eax),%eax
 7af:	8b 10                	mov    (%eax),%edx
 7b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b4:	89 10                	mov    %edx,(%eax)
 7b6:	eb 0a                	jmp    7c2 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 7b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7bb:	8b 10                	mov    (%eax),%edx
 7bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c0:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c5:	8b 40 04             	mov    0x4(%eax),%eax
 7c8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d2:	01 d0                	add    %edx,%eax
 7d4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7d7:	75 20                	jne    7f9 <free+0xcf>
    p->s.size += bp->s.size;
 7d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7dc:	8b 50 04             	mov    0x4(%eax),%edx
 7df:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e2:	8b 40 04             	mov    0x4(%eax),%eax
 7e5:	01 c2                	add    %eax,%edx
 7e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ea:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f0:	8b 10                	mov    (%eax),%edx
 7f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f5:	89 10                	mov    %edx,(%eax)
 7f7:	eb 08                	jmp    801 <free+0xd7>
  } else
    p->s.ptr = bp;
 7f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7fc:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7ff:	89 10                	mov    %edx,(%eax)
  freep = p;
 801:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804:	a3 0c 0c 00 00       	mov    %eax,0xc0c
}
 809:	90                   	nop
 80a:	c9                   	leave  
 80b:	c3                   	ret    

0000080c <morecore>:

static Header*
morecore(uint nu)
{
 80c:	55                   	push   %ebp
 80d:	89 e5                	mov    %esp,%ebp
 80f:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 812:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 819:	77 07                	ja     822 <morecore+0x16>
    nu = 4096;
 81b:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 822:	8b 45 08             	mov    0x8(%ebp),%eax
 825:	c1 e0 03             	shl    $0x3,%eax
 828:	83 ec 0c             	sub    $0xc,%esp
 82b:	50                   	push   %eax
 82c:	e8 49 fc ff ff       	call   47a <sbrk>
 831:	83 c4 10             	add    $0x10,%esp
 834:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 837:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 83b:	75 07                	jne    844 <morecore+0x38>
    return 0;
 83d:	b8 00 00 00 00       	mov    $0x0,%eax
 842:	eb 26                	jmp    86a <morecore+0x5e>
  hp = (Header*)p;
 844:	8b 45 f4             	mov    -0xc(%ebp),%eax
 847:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 84a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 84d:	8b 55 08             	mov    0x8(%ebp),%edx
 850:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 853:	8b 45 f0             	mov    -0x10(%ebp),%eax
 856:	83 c0 08             	add    $0x8,%eax
 859:	83 ec 0c             	sub    $0xc,%esp
 85c:	50                   	push   %eax
 85d:	e8 c8 fe ff ff       	call   72a <free>
 862:	83 c4 10             	add    $0x10,%esp
  return freep;
 865:	a1 0c 0c 00 00       	mov    0xc0c,%eax
}
 86a:	c9                   	leave  
 86b:	c3                   	ret    

0000086c <malloc>:

void*
malloc(uint nbytes)
{
 86c:	55                   	push   %ebp
 86d:	89 e5                	mov    %esp,%ebp
 86f:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 872:	8b 45 08             	mov    0x8(%ebp),%eax
 875:	83 c0 07             	add    $0x7,%eax
 878:	c1 e8 03             	shr    $0x3,%eax
 87b:	83 c0 01             	add    $0x1,%eax
 87e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 881:	a1 0c 0c 00 00       	mov    0xc0c,%eax
 886:	89 45 f0             	mov    %eax,-0x10(%ebp)
 889:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 88d:	75 23                	jne    8b2 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 88f:	c7 45 f0 04 0c 00 00 	movl   $0xc04,-0x10(%ebp)
 896:	8b 45 f0             	mov    -0x10(%ebp),%eax
 899:	a3 0c 0c 00 00       	mov    %eax,0xc0c
 89e:	a1 0c 0c 00 00       	mov    0xc0c,%eax
 8a3:	a3 04 0c 00 00       	mov    %eax,0xc04
    base.s.size = 0;
 8a8:	c7 05 08 0c 00 00 00 	movl   $0x0,0xc08
 8af:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8b5:	8b 00                	mov    (%eax),%eax
 8b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8bd:	8b 40 04             	mov    0x4(%eax),%eax
 8c0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8c3:	72 4d                	jb     912 <malloc+0xa6>
      if(p->s.size == nunits)
 8c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c8:	8b 40 04             	mov    0x4(%eax),%eax
 8cb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8ce:	75 0c                	jne    8dc <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d3:	8b 10                	mov    (%eax),%edx
 8d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d8:	89 10                	mov    %edx,(%eax)
 8da:	eb 26                	jmp    902 <malloc+0x96>
      else {
        p->s.size -= nunits;
 8dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8df:	8b 40 04             	mov    0x4(%eax),%eax
 8e2:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8e5:	89 c2                	mov    %eax,%edx
 8e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ea:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f0:	8b 40 04             	mov    0x4(%eax),%eax
 8f3:	c1 e0 03             	shl    $0x3,%eax
 8f6:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8fc:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8ff:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 902:	8b 45 f0             	mov    -0x10(%ebp),%eax
 905:	a3 0c 0c 00 00       	mov    %eax,0xc0c
      return (void*)(p + 1);
 90a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 90d:	83 c0 08             	add    $0x8,%eax
 910:	eb 3b                	jmp    94d <malloc+0xe1>
    }
    if(p == freep)
 912:	a1 0c 0c 00 00       	mov    0xc0c,%eax
 917:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 91a:	75 1e                	jne    93a <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 91c:	83 ec 0c             	sub    $0xc,%esp
 91f:	ff 75 ec             	pushl  -0x14(%ebp)
 922:	e8 e5 fe ff ff       	call   80c <morecore>
 927:	83 c4 10             	add    $0x10,%esp
 92a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 92d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 931:	75 07                	jne    93a <malloc+0xce>
        return 0;
 933:	b8 00 00 00 00       	mov    $0x0,%eax
 938:	eb 13                	jmp    94d <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 93a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 93d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 940:	8b 45 f4             	mov    -0xc(%ebp),%eax
 943:	8b 00                	mov    (%eax),%eax
 945:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 948:	e9 6d ff ff ff       	jmp    8ba <malloc+0x4e>
}
 94d:	c9                   	leave  
 94e:	c3                   	ret    
