
_test6:     file format elf32-i386


Disassembly of section .text:

00000000 <thread>:

void *stack[NTHREAD];
int tid[NTHREAD];
void *retval[NTHREAD];

void *thread(void *arg){
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
	int i;
	for(i=0;i<10000000;i++);
   6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
   d:	eb 04                	jmp    13 <thread+0x13>
   f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  13:	81 7d f4 7f 96 98 00 	cmpl   $0x98967f,-0xc(%ebp)
  1a:	7e f3                	jle    f <thread+0xf>
	thread_exit((void *)uptime());
  1c:	e8 96 04 00 00       	call   4b7 <uptime>
  21:	83 ec 0c             	sub    $0xc,%esp
  24:	50                   	push   %eax
  25:	e8 a5 04 00 00       	call   4cf <thread_exit>

0000002a <main>:
}

int
main(int argc, char **argv)
{
  2a:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  2e:	83 e4 f0             	and    $0xfffffff0,%esp
  31:	ff 71 fc             	pushl  -0x4(%ecx)
  34:	55                   	push   %ebp
  35:	89 e5                	mov    %esp,%ebp
  37:	51                   	push   %ecx
  38:	83 ec 14             	sub    $0x14,%esp
	int i;

	printf(1, "TEST6: ");
  3b:	83 ec 08             	sub    $0x8,%esp
  3e:	68 7c 09 00 00       	push   $0x97c
  43:	6a 01                	push   $0x1
  45:	e8 7c 05 00 00       	call   5c6 <printf>
  4a:	83 c4 10             	add    $0x10,%esp

	for(i=0;i<NTHREAD;i++)
  4d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  54:	eb 20                	jmp    76 <main+0x4c>
		stack[i] = malloc(4096);
  56:	83 ec 0c             	sub    $0xc,%esp
  59:	68 00 10 00 00       	push   $0x1000
  5e:	e8 36 08 00 00       	call   899 <malloc>
  63:	83 c4 10             	add    $0x10,%esp
  66:	89 c2                	mov    %eax,%edx
  68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  6b:	89 14 85 1c 0c 00 00 	mov    %edx,0xc1c(,%eax,4)
{
	int i;

	printf(1, "TEST6: ");

	for(i=0;i<NTHREAD;i++)
  72:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  76:	83 7d f4 06          	cmpl   $0x6,-0xc(%ebp)
  7a:	7e da                	jle    56 <main+0x2c>
		stack[i] = malloc(4096);

	for(i=0;i<NTHREAD;i++){
  7c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  83:	eb 57                	jmp    dc <main+0xb2>
		tid[i] = thread_create(thread, 30+i, 0, stack[i]);
  85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  88:	8b 04 85 1c 0c 00 00 	mov    0xc1c(,%eax,4),%eax
  8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  92:	83 c2 1e             	add    $0x1e,%edx
  95:	50                   	push   %eax
  96:	6a 00                	push   $0x0
  98:	52                   	push   %edx
  99:	68 00 00 00 00       	push   $0x0
  9e:	e8 24 04 00 00       	call   4c7 <thread_create>
  a3:	83 c4 10             	add    $0x10,%esp
  a6:	89 c2                	mov    %eax,%edx
  a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  ab:	89 14 85 38 0c 00 00 	mov    %edx,0xc38(,%eax,4)
		if(tid[i] == -1){
  b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  b5:	8b 04 85 38 0c 00 00 	mov    0xc38(,%eax,4),%eax
  bc:	83 f8 ff             	cmp    $0xffffffff,%eax
  bf:	75 17                	jne    d8 <main+0xae>
			printf(1, "WRONG\n");
  c1:	83 ec 08             	sub    $0x8,%esp
  c4:	68 84 09 00 00       	push   $0x984
  c9:	6a 01                	push   $0x1
  cb:	e8 f6 04 00 00       	call   5c6 <printf>
  d0:	83 c4 10             	add    $0x10,%esp
			exit();
  d3:	e8 47 03 00 00       	call   41f <exit>
	printf(1, "TEST6: ");

	for(i=0;i<NTHREAD;i++)
		stack[i] = malloc(4096);

	for(i=0;i<NTHREAD;i++){
  d8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  dc:	83 7d f4 06          	cmpl   $0x6,-0xc(%ebp)
  e0:	7e a3                	jle    85 <main+0x5b>
			printf(1, "WRONG\n");
			exit();
		}
	}

	sleep(100);
  e2:	83 ec 0c             	sub    $0xc,%esp
  e5:	6a 64                	push   $0x64
  e7:	e8 c3 03 00 00       	call   4af <sleep>
  ec:	83 c4 10             	add    $0x10,%esp

	for(i=0;i<NTHREAD;i++){
  ef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  f6:	eb 43                	jmp    13b <main+0x111>
		if(thread_join(tid[i], &retval[i]) == -1){
  f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  fb:	c1 e0 02             	shl    $0x2,%eax
  fe:	8d 90 54 0c 00 00    	lea    0xc54(%eax),%edx
 104:	8b 45 f4             	mov    -0xc(%ebp),%eax
 107:	8b 04 85 38 0c 00 00 	mov    0xc38(,%eax,4),%eax
 10e:	83 ec 08             	sub    $0x8,%esp
 111:	52                   	push   %edx
 112:	50                   	push   %eax
 113:	e8 bf 03 00 00       	call   4d7 <thread_join>
 118:	83 c4 10             	add    $0x10,%esp
 11b:	83 f8 ff             	cmp    $0xffffffff,%eax
 11e:	75 17                	jne    137 <main+0x10d>
			printf(1, "WRONG\n");
 120:	83 ec 08             	sub    $0x8,%esp
 123:	68 84 09 00 00       	push   $0x984
 128:	6a 01                	push   $0x1
 12a:	e8 97 04 00 00       	call   5c6 <printf>
 12f:	83 c4 10             	add    $0x10,%esp
			exit();
 132:	e8 e8 02 00 00       	call   41f <exit>
		}
	}

	sleep(100);

	for(i=0;i<NTHREAD;i++){
 137:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 13b:	83 7d f4 06          	cmpl   $0x6,-0xc(%ebp)
 13f:	7e b7                	jle    f8 <main+0xce>
			printf(1, "WRONG\n");
			exit();
		}
	}

	for(i=0;i<NTHREAD-1;i++){
 141:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 148:	eb 38                	jmp    182 <main+0x158>
		if((int)retval[i] > (int)retval[i+1]){
 14a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 14d:	8b 04 85 54 0c 00 00 	mov    0xc54(,%eax,4),%eax
 154:	89 c2                	mov    %eax,%edx
 156:	8b 45 f4             	mov    -0xc(%ebp),%eax
 159:	83 c0 01             	add    $0x1,%eax
 15c:	8b 04 85 54 0c 00 00 	mov    0xc54(,%eax,4),%eax
 163:	39 c2                	cmp    %eax,%edx
 165:	7e 17                	jle    17e <main+0x154>
			printf(1, "WRONG\n");
 167:	83 ec 08             	sub    $0x8,%esp
 16a:	68 84 09 00 00       	push   $0x984
 16f:	6a 01                	push   $0x1
 171:	e8 50 04 00 00       	call   5c6 <printf>
 176:	83 c4 10             	add    $0x10,%esp
			exit();
 179:	e8 a1 02 00 00       	call   41f <exit>
			printf(1, "WRONG\n");
			exit();
		}
	}

	for(i=0;i<NTHREAD-1;i++){
 17e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 182:	83 7d f4 05          	cmpl   $0x5,-0xc(%ebp)
 186:	7e c2                	jle    14a <main+0x120>
			printf(1, "WRONG\n");
			exit();
		}
	}

	for(i=0;i<NTHREAD;i++)
 188:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 18f:	eb 1a                	jmp    1ab <main+0x181>
		free(stack[i]);
 191:	8b 45 f4             	mov    -0xc(%ebp),%eax
 194:	8b 04 85 1c 0c 00 00 	mov    0xc1c(,%eax,4),%eax
 19b:	83 ec 0c             	sub    $0xc,%esp
 19e:	50                   	push   %eax
 19f:	e8 b3 05 00 00       	call   757 <free>
 1a4:	83 c4 10             	add    $0x10,%esp
			printf(1, "WRONG\n");
			exit();
		}
	}

	for(i=0;i<NTHREAD;i++)
 1a7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 1ab:	83 7d f4 06          	cmpl   $0x6,-0xc(%ebp)
 1af:	7e e0                	jle    191 <main+0x167>
		free(stack[i]);

	printf(1, "OK\n");
 1b1:	83 ec 08             	sub    $0x8,%esp
 1b4:	68 8b 09 00 00       	push   $0x98b
 1b9:	6a 01                	push   $0x1
 1bb:	e8 06 04 00 00       	call   5c6 <printf>
 1c0:	83 c4 10             	add    $0x10,%esp

	exit();
 1c3:	e8 57 02 00 00       	call   41f <exit>

000001c8 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1c8:	55                   	push   %ebp
 1c9:	89 e5                	mov    %esp,%ebp
 1cb:	57                   	push   %edi
 1cc:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1cd:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1d0:	8b 55 10             	mov    0x10(%ebp),%edx
 1d3:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d6:	89 cb                	mov    %ecx,%ebx
 1d8:	89 df                	mov    %ebx,%edi
 1da:	89 d1                	mov    %edx,%ecx
 1dc:	fc                   	cld    
 1dd:	f3 aa                	rep stos %al,%es:(%edi)
 1df:	89 ca                	mov    %ecx,%edx
 1e1:	89 fb                	mov    %edi,%ebx
 1e3:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1e6:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1e9:	90                   	nop
 1ea:	5b                   	pop    %ebx
 1eb:	5f                   	pop    %edi
 1ec:	5d                   	pop    %ebp
 1ed:	c3                   	ret    

000001ee <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 1ee:	55                   	push   %ebp
 1ef:	89 e5                	mov    %esp,%ebp
 1f1:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1f4:	8b 45 08             	mov    0x8(%ebp),%eax
 1f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1fa:	90                   	nop
 1fb:	8b 45 08             	mov    0x8(%ebp),%eax
 1fe:	8d 50 01             	lea    0x1(%eax),%edx
 201:	89 55 08             	mov    %edx,0x8(%ebp)
 204:	8b 55 0c             	mov    0xc(%ebp),%edx
 207:	8d 4a 01             	lea    0x1(%edx),%ecx
 20a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 20d:	0f b6 12             	movzbl (%edx),%edx
 210:	88 10                	mov    %dl,(%eax)
 212:	0f b6 00             	movzbl (%eax),%eax
 215:	84 c0                	test   %al,%al
 217:	75 e2                	jne    1fb <strcpy+0xd>
    ;
  return os;
 219:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 21c:	c9                   	leave  
 21d:	c3                   	ret    

0000021e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 21e:	55                   	push   %ebp
 21f:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 221:	eb 08                	jmp    22b <strcmp+0xd>
    p++, q++;
 223:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 227:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 22b:	8b 45 08             	mov    0x8(%ebp),%eax
 22e:	0f b6 00             	movzbl (%eax),%eax
 231:	84 c0                	test   %al,%al
 233:	74 10                	je     245 <strcmp+0x27>
 235:	8b 45 08             	mov    0x8(%ebp),%eax
 238:	0f b6 10             	movzbl (%eax),%edx
 23b:	8b 45 0c             	mov    0xc(%ebp),%eax
 23e:	0f b6 00             	movzbl (%eax),%eax
 241:	38 c2                	cmp    %al,%dl
 243:	74 de                	je     223 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 245:	8b 45 08             	mov    0x8(%ebp),%eax
 248:	0f b6 00             	movzbl (%eax),%eax
 24b:	0f b6 d0             	movzbl %al,%edx
 24e:	8b 45 0c             	mov    0xc(%ebp),%eax
 251:	0f b6 00             	movzbl (%eax),%eax
 254:	0f b6 c0             	movzbl %al,%eax
 257:	29 c2                	sub    %eax,%edx
 259:	89 d0                	mov    %edx,%eax
}
 25b:	5d                   	pop    %ebp
 25c:	c3                   	ret    

0000025d <strlen>:

uint
strlen(char *s)
{
 25d:	55                   	push   %ebp
 25e:	89 e5                	mov    %esp,%ebp
 260:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 263:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 26a:	eb 04                	jmp    270 <strlen+0x13>
 26c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 270:	8b 55 fc             	mov    -0x4(%ebp),%edx
 273:	8b 45 08             	mov    0x8(%ebp),%eax
 276:	01 d0                	add    %edx,%eax
 278:	0f b6 00             	movzbl (%eax),%eax
 27b:	84 c0                	test   %al,%al
 27d:	75 ed                	jne    26c <strlen+0xf>
    ;
  return n;
 27f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 282:	c9                   	leave  
 283:	c3                   	ret    

00000284 <memset>:

void*
memset(void *dst, int c, uint n)
{
 284:	55                   	push   %ebp
 285:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 287:	8b 45 10             	mov    0x10(%ebp),%eax
 28a:	50                   	push   %eax
 28b:	ff 75 0c             	pushl  0xc(%ebp)
 28e:	ff 75 08             	pushl  0x8(%ebp)
 291:	e8 32 ff ff ff       	call   1c8 <stosb>
 296:	83 c4 0c             	add    $0xc,%esp
  return dst;
 299:	8b 45 08             	mov    0x8(%ebp),%eax
}
 29c:	c9                   	leave  
 29d:	c3                   	ret    

0000029e <strchr>:

char*
strchr(const char *s, char c)
{
 29e:	55                   	push   %ebp
 29f:	89 e5                	mov    %esp,%ebp
 2a1:	83 ec 04             	sub    $0x4,%esp
 2a4:	8b 45 0c             	mov    0xc(%ebp),%eax
 2a7:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 2aa:	eb 14                	jmp    2c0 <strchr+0x22>
    if(*s == c)
 2ac:	8b 45 08             	mov    0x8(%ebp),%eax
 2af:	0f b6 00             	movzbl (%eax),%eax
 2b2:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2b5:	75 05                	jne    2bc <strchr+0x1e>
      return (char*)s;
 2b7:	8b 45 08             	mov    0x8(%ebp),%eax
 2ba:	eb 13                	jmp    2cf <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2bc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2c0:	8b 45 08             	mov    0x8(%ebp),%eax
 2c3:	0f b6 00             	movzbl (%eax),%eax
 2c6:	84 c0                	test   %al,%al
 2c8:	75 e2                	jne    2ac <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 2ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2cf:	c9                   	leave  
 2d0:	c3                   	ret    

000002d1 <gets>:

char*
gets(char *buf, int max)
{
 2d1:	55                   	push   %ebp
 2d2:	89 e5                	mov    %esp,%ebp
 2d4:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2d7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2de:	eb 42                	jmp    322 <gets+0x51>
    cc = read(0, &c, 1);
 2e0:	83 ec 04             	sub    $0x4,%esp
 2e3:	6a 01                	push   $0x1
 2e5:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2e8:	50                   	push   %eax
 2e9:	6a 00                	push   $0x0
 2eb:	e8 47 01 00 00       	call   437 <read>
 2f0:	83 c4 10             	add    $0x10,%esp
 2f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 2f6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 2fa:	7e 33                	jle    32f <gets+0x5e>
      break;
    buf[i++] = c;
 2fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2ff:	8d 50 01             	lea    0x1(%eax),%edx
 302:	89 55 f4             	mov    %edx,-0xc(%ebp)
 305:	89 c2                	mov    %eax,%edx
 307:	8b 45 08             	mov    0x8(%ebp),%eax
 30a:	01 c2                	add    %eax,%edx
 30c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 310:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 312:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 316:	3c 0a                	cmp    $0xa,%al
 318:	74 16                	je     330 <gets+0x5f>
 31a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 31e:	3c 0d                	cmp    $0xd,%al
 320:	74 0e                	je     330 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 322:	8b 45 f4             	mov    -0xc(%ebp),%eax
 325:	83 c0 01             	add    $0x1,%eax
 328:	3b 45 0c             	cmp    0xc(%ebp),%eax
 32b:	7c b3                	jl     2e0 <gets+0xf>
 32d:	eb 01                	jmp    330 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 32f:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 330:	8b 55 f4             	mov    -0xc(%ebp),%edx
 333:	8b 45 08             	mov    0x8(%ebp),%eax
 336:	01 d0                	add    %edx,%eax
 338:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 33b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 33e:	c9                   	leave  
 33f:	c3                   	ret    

00000340 <stat>:

int
stat(char *n, struct stat *st)
{
 340:	55                   	push   %ebp
 341:	89 e5                	mov    %esp,%ebp
 343:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 346:	83 ec 08             	sub    $0x8,%esp
 349:	6a 00                	push   $0x0
 34b:	ff 75 08             	pushl  0x8(%ebp)
 34e:	e8 0c 01 00 00       	call   45f <open>
 353:	83 c4 10             	add    $0x10,%esp
 356:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 359:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 35d:	79 07                	jns    366 <stat+0x26>
    return -1;
 35f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 364:	eb 25                	jmp    38b <stat+0x4b>
  r = fstat(fd, st);
 366:	83 ec 08             	sub    $0x8,%esp
 369:	ff 75 0c             	pushl  0xc(%ebp)
 36c:	ff 75 f4             	pushl  -0xc(%ebp)
 36f:	e8 03 01 00 00       	call   477 <fstat>
 374:	83 c4 10             	add    $0x10,%esp
 377:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 37a:	83 ec 0c             	sub    $0xc,%esp
 37d:	ff 75 f4             	pushl  -0xc(%ebp)
 380:	e8 c2 00 00 00       	call   447 <close>
 385:	83 c4 10             	add    $0x10,%esp
  return r;
 388:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 38b:	c9                   	leave  
 38c:	c3                   	ret    

0000038d <atoi>:

int
atoi(const char *s)
{
 38d:	55                   	push   %ebp
 38e:	89 e5                	mov    %esp,%ebp
 390:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 393:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 39a:	eb 25                	jmp    3c1 <atoi+0x34>
    n = n*10 + *s++ - '0';
 39c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 39f:	89 d0                	mov    %edx,%eax
 3a1:	c1 e0 02             	shl    $0x2,%eax
 3a4:	01 d0                	add    %edx,%eax
 3a6:	01 c0                	add    %eax,%eax
 3a8:	89 c1                	mov    %eax,%ecx
 3aa:	8b 45 08             	mov    0x8(%ebp),%eax
 3ad:	8d 50 01             	lea    0x1(%eax),%edx
 3b0:	89 55 08             	mov    %edx,0x8(%ebp)
 3b3:	0f b6 00             	movzbl (%eax),%eax
 3b6:	0f be c0             	movsbl %al,%eax
 3b9:	01 c8                	add    %ecx,%eax
 3bb:	83 e8 30             	sub    $0x30,%eax
 3be:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3c1:	8b 45 08             	mov    0x8(%ebp),%eax
 3c4:	0f b6 00             	movzbl (%eax),%eax
 3c7:	3c 2f                	cmp    $0x2f,%al
 3c9:	7e 0a                	jle    3d5 <atoi+0x48>
 3cb:	8b 45 08             	mov    0x8(%ebp),%eax
 3ce:	0f b6 00             	movzbl (%eax),%eax
 3d1:	3c 39                	cmp    $0x39,%al
 3d3:	7e c7                	jle    39c <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 3d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3d8:	c9                   	leave  
 3d9:	c3                   	ret    

000003da <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 3da:	55                   	push   %ebp
 3db:	89 e5                	mov    %esp,%ebp
 3dd:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 3e0:	8b 45 08             	mov    0x8(%ebp),%eax
 3e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 3e6:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3ec:	eb 17                	jmp    405 <memmove+0x2b>
    *dst++ = *src++;
 3ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3f1:	8d 50 01             	lea    0x1(%eax),%edx
 3f4:	89 55 fc             	mov    %edx,-0x4(%ebp)
 3f7:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3fa:	8d 4a 01             	lea    0x1(%edx),%ecx
 3fd:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 400:	0f b6 12             	movzbl (%edx),%edx
 403:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 405:	8b 45 10             	mov    0x10(%ebp),%eax
 408:	8d 50 ff             	lea    -0x1(%eax),%edx
 40b:	89 55 10             	mov    %edx,0x10(%ebp)
 40e:	85 c0                	test   %eax,%eax
 410:	7f dc                	jg     3ee <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 412:	8b 45 08             	mov    0x8(%ebp),%eax
}
 415:	c9                   	leave  
 416:	c3                   	ret    

00000417 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 417:	b8 01 00 00 00       	mov    $0x1,%eax
 41c:	cd 40                	int    $0x40
 41e:	c3                   	ret    

0000041f <exit>:
SYSCALL(exit)
 41f:	b8 02 00 00 00       	mov    $0x2,%eax
 424:	cd 40                	int    $0x40
 426:	c3                   	ret    

00000427 <wait>:
SYSCALL(wait)
 427:	b8 03 00 00 00       	mov    $0x3,%eax
 42c:	cd 40                	int    $0x40
 42e:	c3                   	ret    

0000042f <pipe>:
SYSCALL(pipe)
 42f:	b8 04 00 00 00       	mov    $0x4,%eax
 434:	cd 40                	int    $0x40
 436:	c3                   	ret    

00000437 <read>:
SYSCALL(read)
 437:	b8 05 00 00 00       	mov    $0x5,%eax
 43c:	cd 40                	int    $0x40
 43e:	c3                   	ret    

0000043f <write>:
SYSCALL(write)
 43f:	b8 10 00 00 00       	mov    $0x10,%eax
 444:	cd 40                	int    $0x40
 446:	c3                   	ret    

00000447 <close>:
SYSCALL(close)
 447:	b8 15 00 00 00       	mov    $0x15,%eax
 44c:	cd 40                	int    $0x40
 44e:	c3                   	ret    

0000044f <kill>:
SYSCALL(kill)
 44f:	b8 06 00 00 00       	mov    $0x6,%eax
 454:	cd 40                	int    $0x40
 456:	c3                   	ret    

00000457 <exec>:
SYSCALL(exec)
 457:	b8 07 00 00 00       	mov    $0x7,%eax
 45c:	cd 40                	int    $0x40
 45e:	c3                   	ret    

0000045f <open>:
SYSCALL(open)
 45f:	b8 0f 00 00 00       	mov    $0xf,%eax
 464:	cd 40                	int    $0x40
 466:	c3                   	ret    

00000467 <mknod>:
SYSCALL(mknod)
 467:	b8 11 00 00 00       	mov    $0x11,%eax
 46c:	cd 40                	int    $0x40
 46e:	c3                   	ret    

0000046f <unlink>:
SYSCALL(unlink)
 46f:	b8 12 00 00 00       	mov    $0x12,%eax
 474:	cd 40                	int    $0x40
 476:	c3                   	ret    

00000477 <fstat>:
SYSCALL(fstat)
 477:	b8 08 00 00 00       	mov    $0x8,%eax
 47c:	cd 40                	int    $0x40
 47e:	c3                   	ret    

0000047f <link>:
SYSCALL(link)
 47f:	b8 13 00 00 00       	mov    $0x13,%eax
 484:	cd 40                	int    $0x40
 486:	c3                   	ret    

00000487 <mkdir>:
SYSCALL(mkdir)
 487:	b8 14 00 00 00       	mov    $0x14,%eax
 48c:	cd 40                	int    $0x40
 48e:	c3                   	ret    

0000048f <chdir>:
SYSCALL(chdir)
 48f:	b8 09 00 00 00       	mov    $0x9,%eax
 494:	cd 40                	int    $0x40
 496:	c3                   	ret    

00000497 <dup>:
SYSCALL(dup)
 497:	b8 0a 00 00 00       	mov    $0xa,%eax
 49c:	cd 40                	int    $0x40
 49e:	c3                   	ret    

0000049f <getpid>:
SYSCALL(getpid)
 49f:	b8 0b 00 00 00       	mov    $0xb,%eax
 4a4:	cd 40                	int    $0x40
 4a6:	c3                   	ret    

000004a7 <sbrk>:
SYSCALL(sbrk)
 4a7:	b8 0c 00 00 00       	mov    $0xc,%eax
 4ac:	cd 40                	int    $0x40
 4ae:	c3                   	ret    

000004af <sleep>:
SYSCALL(sleep)
 4af:	b8 0d 00 00 00       	mov    $0xd,%eax
 4b4:	cd 40                	int    $0x40
 4b6:	c3                   	ret    

000004b7 <uptime>:
SYSCALL(uptime)
 4b7:	b8 0e 00 00 00       	mov    $0xe,%eax
 4bc:	cd 40                	int    $0x40
 4be:	c3                   	ret    

000004bf <halt>:
SYSCALL(halt)
 4bf:	b8 16 00 00 00       	mov    $0x16,%eax
 4c4:	cd 40                	int    $0x40
 4c6:	c3                   	ret    

000004c7 <thread_create>:
SYSCALL(thread_create)
 4c7:	b8 17 00 00 00       	mov    $0x17,%eax
 4cc:	cd 40                	int    $0x40
 4ce:	c3                   	ret    

000004cf <thread_exit>:
SYSCALL(thread_exit)
 4cf:	b8 18 00 00 00       	mov    $0x18,%eax
 4d4:	cd 40                	int    $0x40
 4d6:	c3                   	ret    

000004d7 <thread_join>:
SYSCALL(thread_join)
 4d7:	b8 19 00 00 00       	mov    $0x19,%eax
 4dc:	cd 40                	int    $0x40
 4de:	c3                   	ret    

000004df <gettid>:
SYSCALL(gettid)
 4df:	b8 1a 00 00 00       	mov    $0x1a,%eax
 4e4:	cd 40                	int    $0x40
 4e6:	c3                   	ret    

000004e7 <clone>:
SYSCALL(clone)
 4e7:	b8 1b 00 00 00       	mov    $0x1b,%eax
 4ec:	cd 40                	int    $0x40
 4ee:	c3                   	ret    

000004ef <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4ef:	55                   	push   %ebp
 4f0:	89 e5                	mov    %esp,%ebp
 4f2:	83 ec 18             	sub    $0x18,%esp
 4f5:	8b 45 0c             	mov    0xc(%ebp),%eax
 4f8:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4fb:	83 ec 04             	sub    $0x4,%esp
 4fe:	6a 01                	push   $0x1
 500:	8d 45 f4             	lea    -0xc(%ebp),%eax
 503:	50                   	push   %eax
 504:	ff 75 08             	pushl  0x8(%ebp)
 507:	e8 33 ff ff ff       	call   43f <write>
 50c:	83 c4 10             	add    $0x10,%esp
}
 50f:	90                   	nop
 510:	c9                   	leave  
 511:	c3                   	ret    

00000512 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 512:	55                   	push   %ebp
 513:	89 e5                	mov    %esp,%ebp
 515:	53                   	push   %ebx
 516:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 519:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 520:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 524:	74 17                	je     53d <printint+0x2b>
 526:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 52a:	79 11                	jns    53d <printint+0x2b>
    neg = 1;
 52c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 533:	8b 45 0c             	mov    0xc(%ebp),%eax
 536:	f7 d8                	neg    %eax
 538:	89 45 ec             	mov    %eax,-0x14(%ebp)
 53b:	eb 06                	jmp    543 <printint+0x31>
  } else {
    x = xx;
 53d:	8b 45 0c             	mov    0xc(%ebp),%eax
 540:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 543:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 54a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 54d:	8d 41 01             	lea    0x1(%ecx),%eax
 550:	89 45 f4             	mov    %eax,-0xc(%ebp)
 553:	8b 5d 10             	mov    0x10(%ebp),%ebx
 556:	8b 45 ec             	mov    -0x14(%ebp),%eax
 559:	ba 00 00 00 00       	mov    $0x0,%edx
 55e:	f7 f3                	div    %ebx
 560:	89 d0                	mov    %edx,%eax
 562:	0f b6 80 fc 0b 00 00 	movzbl 0xbfc(%eax),%eax
 569:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 56d:	8b 5d 10             	mov    0x10(%ebp),%ebx
 570:	8b 45 ec             	mov    -0x14(%ebp),%eax
 573:	ba 00 00 00 00       	mov    $0x0,%edx
 578:	f7 f3                	div    %ebx
 57a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 57d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 581:	75 c7                	jne    54a <printint+0x38>
  if(neg)
 583:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 587:	74 2d                	je     5b6 <printint+0xa4>
    buf[i++] = '-';
 589:	8b 45 f4             	mov    -0xc(%ebp),%eax
 58c:	8d 50 01             	lea    0x1(%eax),%edx
 58f:	89 55 f4             	mov    %edx,-0xc(%ebp)
 592:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 597:	eb 1d                	jmp    5b6 <printint+0xa4>
    putc(fd, buf[i]);
 599:	8d 55 dc             	lea    -0x24(%ebp),%edx
 59c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 59f:	01 d0                	add    %edx,%eax
 5a1:	0f b6 00             	movzbl (%eax),%eax
 5a4:	0f be c0             	movsbl %al,%eax
 5a7:	83 ec 08             	sub    $0x8,%esp
 5aa:	50                   	push   %eax
 5ab:	ff 75 08             	pushl  0x8(%ebp)
 5ae:	e8 3c ff ff ff       	call   4ef <putc>
 5b3:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 5b6:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 5ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5be:	79 d9                	jns    599 <printint+0x87>
    putc(fd, buf[i]);
}
 5c0:	90                   	nop
 5c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5c4:	c9                   	leave  
 5c5:	c3                   	ret    

000005c6 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5c6:	55                   	push   %ebp
 5c7:	89 e5                	mov    %esp,%ebp
 5c9:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5cc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5d3:	8d 45 0c             	lea    0xc(%ebp),%eax
 5d6:	83 c0 04             	add    $0x4,%eax
 5d9:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5dc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5e3:	e9 59 01 00 00       	jmp    741 <printf+0x17b>
    c = fmt[i] & 0xff;
 5e8:	8b 55 0c             	mov    0xc(%ebp),%edx
 5eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5ee:	01 d0                	add    %edx,%eax
 5f0:	0f b6 00             	movzbl (%eax),%eax
 5f3:	0f be c0             	movsbl %al,%eax
 5f6:	25 ff 00 00 00       	and    $0xff,%eax
 5fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5fe:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 602:	75 2c                	jne    630 <printf+0x6a>
      if(c == '%'){
 604:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 608:	75 0c                	jne    616 <printf+0x50>
        state = '%';
 60a:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 611:	e9 27 01 00 00       	jmp    73d <printf+0x177>
      } else {
        putc(fd, c);
 616:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 619:	0f be c0             	movsbl %al,%eax
 61c:	83 ec 08             	sub    $0x8,%esp
 61f:	50                   	push   %eax
 620:	ff 75 08             	pushl  0x8(%ebp)
 623:	e8 c7 fe ff ff       	call   4ef <putc>
 628:	83 c4 10             	add    $0x10,%esp
 62b:	e9 0d 01 00 00       	jmp    73d <printf+0x177>
      }
    } else if(state == '%'){
 630:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 634:	0f 85 03 01 00 00    	jne    73d <printf+0x177>
      if(c == 'd'){
 63a:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 63e:	75 1e                	jne    65e <printf+0x98>
        printint(fd, *ap, 10, 1);
 640:	8b 45 e8             	mov    -0x18(%ebp),%eax
 643:	8b 00                	mov    (%eax),%eax
 645:	6a 01                	push   $0x1
 647:	6a 0a                	push   $0xa
 649:	50                   	push   %eax
 64a:	ff 75 08             	pushl  0x8(%ebp)
 64d:	e8 c0 fe ff ff       	call   512 <printint>
 652:	83 c4 10             	add    $0x10,%esp
        ap++;
 655:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 659:	e9 d8 00 00 00       	jmp    736 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 65e:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 662:	74 06                	je     66a <printf+0xa4>
 664:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 668:	75 1e                	jne    688 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 66a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 66d:	8b 00                	mov    (%eax),%eax
 66f:	6a 00                	push   $0x0
 671:	6a 10                	push   $0x10
 673:	50                   	push   %eax
 674:	ff 75 08             	pushl  0x8(%ebp)
 677:	e8 96 fe ff ff       	call   512 <printint>
 67c:	83 c4 10             	add    $0x10,%esp
        ap++;
 67f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 683:	e9 ae 00 00 00       	jmp    736 <printf+0x170>
      } else if(c == 's'){
 688:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 68c:	75 43                	jne    6d1 <printf+0x10b>
        s = (char*)*ap;
 68e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 691:	8b 00                	mov    (%eax),%eax
 693:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 696:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 69a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 69e:	75 25                	jne    6c5 <printf+0xff>
          s = "(null)";
 6a0:	c7 45 f4 8f 09 00 00 	movl   $0x98f,-0xc(%ebp)
        while(*s != 0){
 6a7:	eb 1c                	jmp    6c5 <printf+0xff>
          putc(fd, *s);
 6a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6ac:	0f b6 00             	movzbl (%eax),%eax
 6af:	0f be c0             	movsbl %al,%eax
 6b2:	83 ec 08             	sub    $0x8,%esp
 6b5:	50                   	push   %eax
 6b6:	ff 75 08             	pushl  0x8(%ebp)
 6b9:	e8 31 fe ff ff       	call   4ef <putc>
 6be:	83 c4 10             	add    $0x10,%esp
          s++;
 6c1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6c8:	0f b6 00             	movzbl (%eax),%eax
 6cb:	84 c0                	test   %al,%al
 6cd:	75 da                	jne    6a9 <printf+0xe3>
 6cf:	eb 65                	jmp    736 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6d1:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6d5:	75 1d                	jne    6f4 <printf+0x12e>
        putc(fd, *ap);
 6d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6da:	8b 00                	mov    (%eax),%eax
 6dc:	0f be c0             	movsbl %al,%eax
 6df:	83 ec 08             	sub    $0x8,%esp
 6e2:	50                   	push   %eax
 6e3:	ff 75 08             	pushl  0x8(%ebp)
 6e6:	e8 04 fe ff ff       	call   4ef <putc>
 6eb:	83 c4 10             	add    $0x10,%esp
        ap++;
 6ee:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6f2:	eb 42                	jmp    736 <printf+0x170>
      } else if(c == '%'){
 6f4:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6f8:	75 17                	jne    711 <printf+0x14b>
        putc(fd, c);
 6fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6fd:	0f be c0             	movsbl %al,%eax
 700:	83 ec 08             	sub    $0x8,%esp
 703:	50                   	push   %eax
 704:	ff 75 08             	pushl  0x8(%ebp)
 707:	e8 e3 fd ff ff       	call   4ef <putc>
 70c:	83 c4 10             	add    $0x10,%esp
 70f:	eb 25                	jmp    736 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 711:	83 ec 08             	sub    $0x8,%esp
 714:	6a 25                	push   $0x25
 716:	ff 75 08             	pushl  0x8(%ebp)
 719:	e8 d1 fd ff ff       	call   4ef <putc>
 71e:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 721:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 724:	0f be c0             	movsbl %al,%eax
 727:	83 ec 08             	sub    $0x8,%esp
 72a:	50                   	push   %eax
 72b:	ff 75 08             	pushl  0x8(%ebp)
 72e:	e8 bc fd ff ff       	call   4ef <putc>
 733:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 736:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 73d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 741:	8b 55 0c             	mov    0xc(%ebp),%edx
 744:	8b 45 f0             	mov    -0x10(%ebp),%eax
 747:	01 d0                	add    %edx,%eax
 749:	0f b6 00             	movzbl (%eax),%eax
 74c:	84 c0                	test   %al,%al
 74e:	0f 85 94 fe ff ff    	jne    5e8 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 754:	90                   	nop
 755:	c9                   	leave  
 756:	c3                   	ret    

00000757 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 757:	55                   	push   %ebp
 758:	89 e5                	mov    %esp,%ebp
 75a:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 75d:	8b 45 08             	mov    0x8(%ebp),%eax
 760:	83 e8 08             	sub    $0x8,%eax
 763:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 766:	a1 18 0c 00 00       	mov    0xc18,%eax
 76b:	89 45 fc             	mov    %eax,-0x4(%ebp)
 76e:	eb 24                	jmp    794 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 770:	8b 45 fc             	mov    -0x4(%ebp),%eax
 773:	8b 00                	mov    (%eax),%eax
 775:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 778:	77 12                	ja     78c <free+0x35>
 77a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 77d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 780:	77 24                	ja     7a6 <free+0x4f>
 782:	8b 45 fc             	mov    -0x4(%ebp),%eax
 785:	8b 00                	mov    (%eax),%eax
 787:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 78a:	77 1a                	ja     7a6 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 78c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78f:	8b 00                	mov    (%eax),%eax
 791:	89 45 fc             	mov    %eax,-0x4(%ebp)
 794:	8b 45 f8             	mov    -0x8(%ebp),%eax
 797:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 79a:	76 d4                	jbe    770 <free+0x19>
 79c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79f:	8b 00                	mov    (%eax),%eax
 7a1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7a4:	76 ca                	jbe    770 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a9:	8b 40 04             	mov    0x4(%eax),%eax
 7ac:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b6:	01 c2                	add    %eax,%edx
 7b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7bb:	8b 00                	mov    (%eax),%eax
 7bd:	39 c2                	cmp    %eax,%edx
 7bf:	75 24                	jne    7e5 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 7c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c4:	8b 50 04             	mov    0x4(%eax),%edx
 7c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ca:	8b 00                	mov    (%eax),%eax
 7cc:	8b 40 04             	mov    0x4(%eax),%eax
 7cf:	01 c2                	add    %eax,%edx
 7d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d4:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7da:	8b 00                	mov    (%eax),%eax
 7dc:	8b 10                	mov    (%eax),%edx
 7de:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e1:	89 10                	mov    %edx,(%eax)
 7e3:	eb 0a                	jmp    7ef <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 7e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e8:	8b 10                	mov    (%eax),%edx
 7ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ed:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f2:	8b 40 04             	mov    0x4(%eax),%eax
 7f5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ff:	01 d0                	add    %edx,%eax
 801:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 804:	75 20                	jne    826 <free+0xcf>
    p->s.size += bp->s.size;
 806:	8b 45 fc             	mov    -0x4(%ebp),%eax
 809:	8b 50 04             	mov    0x4(%eax),%edx
 80c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 80f:	8b 40 04             	mov    0x4(%eax),%eax
 812:	01 c2                	add    %eax,%edx
 814:	8b 45 fc             	mov    -0x4(%ebp),%eax
 817:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 81a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 81d:	8b 10                	mov    (%eax),%edx
 81f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 822:	89 10                	mov    %edx,(%eax)
 824:	eb 08                	jmp    82e <free+0xd7>
  } else
    p->s.ptr = bp;
 826:	8b 45 fc             	mov    -0x4(%ebp),%eax
 829:	8b 55 f8             	mov    -0x8(%ebp),%edx
 82c:	89 10                	mov    %edx,(%eax)
  freep = p;
 82e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 831:	a3 18 0c 00 00       	mov    %eax,0xc18
}
 836:	90                   	nop
 837:	c9                   	leave  
 838:	c3                   	ret    

00000839 <morecore>:

static Header*
morecore(uint nu)
{
 839:	55                   	push   %ebp
 83a:	89 e5                	mov    %esp,%ebp
 83c:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 83f:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 846:	77 07                	ja     84f <morecore+0x16>
    nu = 4096;
 848:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 84f:	8b 45 08             	mov    0x8(%ebp),%eax
 852:	c1 e0 03             	shl    $0x3,%eax
 855:	83 ec 0c             	sub    $0xc,%esp
 858:	50                   	push   %eax
 859:	e8 49 fc ff ff       	call   4a7 <sbrk>
 85e:	83 c4 10             	add    $0x10,%esp
 861:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 864:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 868:	75 07                	jne    871 <morecore+0x38>
    return 0;
 86a:	b8 00 00 00 00       	mov    $0x0,%eax
 86f:	eb 26                	jmp    897 <morecore+0x5e>
  hp = (Header*)p;
 871:	8b 45 f4             	mov    -0xc(%ebp),%eax
 874:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 877:	8b 45 f0             	mov    -0x10(%ebp),%eax
 87a:	8b 55 08             	mov    0x8(%ebp),%edx
 87d:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 880:	8b 45 f0             	mov    -0x10(%ebp),%eax
 883:	83 c0 08             	add    $0x8,%eax
 886:	83 ec 0c             	sub    $0xc,%esp
 889:	50                   	push   %eax
 88a:	e8 c8 fe ff ff       	call   757 <free>
 88f:	83 c4 10             	add    $0x10,%esp
  return freep;
 892:	a1 18 0c 00 00       	mov    0xc18,%eax
}
 897:	c9                   	leave  
 898:	c3                   	ret    

00000899 <malloc>:

void*
malloc(uint nbytes)
{
 899:	55                   	push   %ebp
 89a:	89 e5                	mov    %esp,%ebp
 89c:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 89f:	8b 45 08             	mov    0x8(%ebp),%eax
 8a2:	83 c0 07             	add    $0x7,%eax
 8a5:	c1 e8 03             	shr    $0x3,%eax
 8a8:	83 c0 01             	add    $0x1,%eax
 8ab:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8ae:	a1 18 0c 00 00       	mov    0xc18,%eax
 8b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8b6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8ba:	75 23                	jne    8df <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 8bc:	c7 45 f0 10 0c 00 00 	movl   $0xc10,-0x10(%ebp)
 8c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8c6:	a3 18 0c 00 00       	mov    %eax,0xc18
 8cb:	a1 18 0c 00 00       	mov    0xc18,%eax
 8d0:	a3 10 0c 00 00       	mov    %eax,0xc10
    base.s.size = 0;
 8d5:	c7 05 14 0c 00 00 00 	movl   $0x0,0xc14
 8dc:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8df:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8e2:	8b 00                	mov    (%eax),%eax
 8e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ea:	8b 40 04             	mov    0x4(%eax),%eax
 8ed:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8f0:	72 4d                	jb     93f <malloc+0xa6>
      if(p->s.size == nunits)
 8f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f5:	8b 40 04             	mov    0x4(%eax),%eax
 8f8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8fb:	75 0c                	jne    909 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 900:	8b 10                	mov    (%eax),%edx
 902:	8b 45 f0             	mov    -0x10(%ebp),%eax
 905:	89 10                	mov    %edx,(%eax)
 907:	eb 26                	jmp    92f <malloc+0x96>
      else {
        p->s.size -= nunits;
 909:	8b 45 f4             	mov    -0xc(%ebp),%eax
 90c:	8b 40 04             	mov    0x4(%eax),%eax
 90f:	2b 45 ec             	sub    -0x14(%ebp),%eax
 912:	89 c2                	mov    %eax,%edx
 914:	8b 45 f4             	mov    -0xc(%ebp),%eax
 917:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 91a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 91d:	8b 40 04             	mov    0x4(%eax),%eax
 920:	c1 e0 03             	shl    $0x3,%eax
 923:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 926:	8b 45 f4             	mov    -0xc(%ebp),%eax
 929:	8b 55 ec             	mov    -0x14(%ebp),%edx
 92c:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 92f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 932:	a3 18 0c 00 00       	mov    %eax,0xc18
      return (void*)(p + 1);
 937:	8b 45 f4             	mov    -0xc(%ebp),%eax
 93a:	83 c0 08             	add    $0x8,%eax
 93d:	eb 3b                	jmp    97a <malloc+0xe1>
    }
    if(p == freep)
 93f:	a1 18 0c 00 00       	mov    0xc18,%eax
 944:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 947:	75 1e                	jne    967 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 949:	83 ec 0c             	sub    $0xc,%esp
 94c:	ff 75 ec             	pushl  -0x14(%ebp)
 94f:	e8 e5 fe ff ff       	call   839 <morecore>
 954:	83 c4 10             	add    $0x10,%esp
 957:	89 45 f4             	mov    %eax,-0xc(%ebp)
 95a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 95e:	75 07                	jne    967 <malloc+0xce>
        return 0;
 960:	b8 00 00 00 00       	mov    $0x0,%eax
 965:	eb 13                	jmp    97a <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 967:	8b 45 f4             	mov    -0xc(%ebp),%eax
 96a:	89 45 f0             	mov    %eax,-0x10(%ebp)
 96d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 970:	8b 00                	mov    (%eax),%eax
 972:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 975:	e9 6d ff ff ff       	jmp    8e7 <malloc+0x4e>
}
 97a:	c9                   	leave  
 97b:	c3                   	ret    
