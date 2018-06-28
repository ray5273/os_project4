
_test7:     file format elf32-i386


Disassembly of section .text:

00000000 <thread>:
void *stack[NTHREAD];
int tid[NTHREAD];
void *retval[NTHREAD];
int mem;

void *thread(void *arg){
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 08             	sub    $0x8,%esp
   // printf(1,"mem : %d , arg : %d",mem,(int)arg);
	if(mem != (int)arg){
   6:	8b 15 34 0c 00 00    	mov    0xc34,%edx
   c:	8b 45 08             	mov    0x8(%ebp),%eax
   f:	39 c2                	cmp    %eax,%edx
  11:	74 17                	je     2a <thread+0x2a>
		printf(1, "IN THREAD WRONG\n");
  13:	83 ec 08             	sub    $0x8,%esp
  16:	68 37 09 00 00       	push   $0x937
  1b:	6a 01                	push   $0x1
  1d:	e8 5f 05 00 00       	call   581 <printf>
  22:	83 c4 10             	add    $0x10,%esp
		exit();
  25:	e8 b0 03 00 00       	call   3da <exit>
	}

	thread_exit(0);
  2a:	83 ec 0c             	sub    $0xc,%esp
  2d:	6a 00                	push   $0x0
  2f:	e8 56 04 00 00       	call   48a <thread_exit>

00000034 <main>:
}

int
main(int argc, char **argv)
{
  34:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  38:	83 e4 f0             	and    $0xfffffff0,%esp
  3b:	ff 71 fc             	pushl  -0x4(%ecx)
  3e:	55                   	push   %ebp
  3f:	89 e5                	mov    %esp,%ebp
  41:	51                   	push   %ecx
  42:	83 ec 14             	sub    $0x14,%esp
	int i;

	printf(1, "TEST7: ");
  45:	83 ec 08             	sub    $0x8,%esp
  48:	68 48 09 00 00       	push   $0x948
  4d:	6a 01                	push   $0x1
  4f:	e8 2d 05 00 00       	call   581 <printf>
  54:	83 c4 10             	add    $0x10,%esp

	for(i=0;i<NTHREAD;i++)
  57:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  5e:	eb 20                	jmp    80 <main+0x4c>
		stack[i] = malloc(4096);
  60:	83 ec 0c             	sub    $0xc,%esp
  63:	68 00 10 00 00       	push   $0x1000
  68:	e8 e7 07 00 00       	call   854 <malloc>
  6d:	83 c4 10             	add    $0x10,%esp
  70:	89 c2                	mov    %eax,%edx
  72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  75:	89 14 85 fc 0b 00 00 	mov    %edx,0xbfc(,%eax,4)
{
	int i;

	printf(1, "TEST7: ");

	for(i=0;i<NTHREAD;i++)
  7c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  80:	83 7d f4 06          	cmpl   $0x6,-0xc(%ebp)
  84:	7e da                	jle    60 <main+0x2c>
		stack[i] = malloc(4096);

	for(i=0;i<NTHREAD;i++){
  86:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8d:	eb 5c                	jmp    eb <main+0xb7>
		mem = i;
  8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  92:	a3 34 0c 00 00       	mov    %eax,0xc34
		tid[i] = thread_create(thread, 10, (void *)i, stack[i]);
  97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  9a:	8b 14 85 fc 0b 00 00 	mov    0xbfc(,%eax,4),%edx
  a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  a4:	52                   	push   %edx
  a5:	50                   	push   %eax
  a6:	6a 0a                	push   $0xa
  a8:	68 00 00 00 00       	push   $0x0
  ad:	e8 d0 03 00 00       	call   482 <thread_create>
  b2:	83 c4 10             	add    $0x10,%esp
  b5:	89 c2                	mov    %eax,%edx
  b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  ba:	89 14 85 18 0c 00 00 	mov    %edx,0xc18(,%eax,4)
		if(tid[i] == -1){
  c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  c4:	8b 04 85 18 0c 00 00 	mov    0xc18(,%eax,4),%eax
  cb:	83 f8 ff             	cmp    $0xffffffff,%eax
  ce:	75 17                	jne    e7 <main+0xb3>
			printf(1, "CREATE WRONG\n");
  d0:	83 ec 08             	sub    $0x8,%esp
  d3:	68 50 09 00 00       	push   $0x950
  d8:	6a 01                	push   $0x1
  da:	e8 a2 04 00 00       	call   581 <printf>
  df:	83 c4 10             	add    $0x10,%esp
			exit();
  e2:	e8 f3 02 00 00       	call   3da <exit>
	printf(1, "TEST7: ");

	for(i=0;i<NTHREAD;i++)
		stack[i] = malloc(4096);

	for(i=0;i<NTHREAD;i++){
  e7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  eb:	83 7d f4 06          	cmpl   $0x6,-0xc(%ebp)
  ef:	7e 9e                	jle    8f <main+0x5b>
			printf(1, "CREATE WRONG\n");
			exit();
		}
	}

	for(i=0;i<NTHREAD;i++){
  f1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  f8:	eb 43                	jmp    13d <main+0x109>
		if(thread_join(tid[i], &retval[i]) == -1){
  fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  fd:	c1 e0 02             	shl    $0x2,%eax
 100:	8d 90 38 0c 00 00    	lea    0xc38(%eax),%edx
 106:	8b 45 f4             	mov    -0xc(%ebp),%eax
 109:	8b 04 85 18 0c 00 00 	mov    0xc18(,%eax,4),%eax
 110:	83 ec 08             	sub    $0x8,%esp
 113:	52                   	push   %edx
 114:	50                   	push   %eax
 115:	e8 78 03 00 00       	call   492 <thread_join>
 11a:	83 c4 10             	add    $0x10,%esp
 11d:	83 f8 ff             	cmp    $0xffffffff,%eax
 120:	75 17                	jne    139 <main+0x105>
			printf(1, "JOIN WRONG\n");
 122:	83 ec 08             	sub    $0x8,%esp
 125:	68 5e 09 00 00       	push   $0x95e
 12a:	6a 01                	push   $0x1
 12c:	e8 50 04 00 00       	call   581 <printf>
 131:	83 c4 10             	add    $0x10,%esp
			exit();
 134:	e8 a1 02 00 00       	call   3da <exit>
			printf(1, "CREATE WRONG\n");
			exit();
		}
	}

	for(i=0;i<NTHREAD;i++){
 139:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 13d:	83 7d f4 06          	cmpl   $0x6,-0xc(%ebp)
 141:	7e b7                	jle    fa <main+0xc6>
			printf(1, "JOIN WRONG\n");
			exit();
		}
	}

	for(i=0;i<NTHREAD;i++)
 143:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 14a:	eb 1a                	jmp    166 <main+0x132>
		free(stack[i]);
 14c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 14f:	8b 04 85 fc 0b 00 00 	mov    0xbfc(,%eax,4),%eax
 156:	83 ec 0c             	sub    $0xc,%esp
 159:	50                   	push   %eax
 15a:	e8 b3 05 00 00       	call   712 <free>
 15f:	83 c4 10             	add    $0x10,%esp
			printf(1, "JOIN WRONG\n");
			exit();
		}
	}

	for(i=0;i<NTHREAD;i++)
 162:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 166:	83 7d f4 06          	cmpl   $0x6,-0xc(%ebp)
 16a:	7e e0                	jle    14c <main+0x118>
		free(stack[i]);

	printf(1, "OK\n");
 16c:	83 ec 08             	sub    $0x8,%esp
 16f:	68 6a 09 00 00       	push   $0x96a
 174:	6a 01                	push   $0x1
 176:	e8 06 04 00 00       	call   581 <printf>
 17b:	83 c4 10             	add    $0x10,%esp

	exit();
 17e:	e8 57 02 00 00       	call   3da <exit>

00000183 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 183:	55                   	push   %ebp
 184:	89 e5                	mov    %esp,%ebp
 186:	57                   	push   %edi
 187:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 188:	8b 4d 08             	mov    0x8(%ebp),%ecx
 18b:	8b 55 10             	mov    0x10(%ebp),%edx
 18e:	8b 45 0c             	mov    0xc(%ebp),%eax
 191:	89 cb                	mov    %ecx,%ebx
 193:	89 df                	mov    %ebx,%edi
 195:	89 d1                	mov    %edx,%ecx
 197:	fc                   	cld    
 198:	f3 aa                	rep stos %al,%es:(%edi)
 19a:	89 ca                	mov    %ecx,%edx
 19c:	89 fb                	mov    %edi,%ebx
 19e:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1a1:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1a4:	90                   	nop
 1a5:	5b                   	pop    %ebx
 1a6:	5f                   	pop    %edi
 1a7:	5d                   	pop    %ebp
 1a8:	c3                   	ret    

000001a9 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 1a9:	55                   	push   %ebp
 1aa:	89 e5                	mov    %esp,%ebp
 1ac:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1af:	8b 45 08             	mov    0x8(%ebp),%eax
 1b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1b5:	90                   	nop
 1b6:	8b 45 08             	mov    0x8(%ebp),%eax
 1b9:	8d 50 01             	lea    0x1(%eax),%edx
 1bc:	89 55 08             	mov    %edx,0x8(%ebp)
 1bf:	8b 55 0c             	mov    0xc(%ebp),%edx
 1c2:	8d 4a 01             	lea    0x1(%edx),%ecx
 1c5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 1c8:	0f b6 12             	movzbl (%edx),%edx
 1cb:	88 10                	mov    %dl,(%eax)
 1cd:	0f b6 00             	movzbl (%eax),%eax
 1d0:	84 c0                	test   %al,%al
 1d2:	75 e2                	jne    1b6 <strcpy+0xd>
    ;
  return os;
 1d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1d7:	c9                   	leave  
 1d8:	c3                   	ret    

000001d9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1d9:	55                   	push   %ebp
 1da:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 1dc:	eb 08                	jmp    1e6 <strcmp+0xd>
    p++, q++;
 1de:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1e2:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1e6:	8b 45 08             	mov    0x8(%ebp),%eax
 1e9:	0f b6 00             	movzbl (%eax),%eax
 1ec:	84 c0                	test   %al,%al
 1ee:	74 10                	je     200 <strcmp+0x27>
 1f0:	8b 45 08             	mov    0x8(%ebp),%eax
 1f3:	0f b6 10             	movzbl (%eax),%edx
 1f6:	8b 45 0c             	mov    0xc(%ebp),%eax
 1f9:	0f b6 00             	movzbl (%eax),%eax
 1fc:	38 c2                	cmp    %al,%dl
 1fe:	74 de                	je     1de <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 200:	8b 45 08             	mov    0x8(%ebp),%eax
 203:	0f b6 00             	movzbl (%eax),%eax
 206:	0f b6 d0             	movzbl %al,%edx
 209:	8b 45 0c             	mov    0xc(%ebp),%eax
 20c:	0f b6 00             	movzbl (%eax),%eax
 20f:	0f b6 c0             	movzbl %al,%eax
 212:	29 c2                	sub    %eax,%edx
 214:	89 d0                	mov    %edx,%eax
}
 216:	5d                   	pop    %ebp
 217:	c3                   	ret    

00000218 <strlen>:

uint
strlen(char *s)
{
 218:	55                   	push   %ebp
 219:	89 e5                	mov    %esp,%ebp
 21b:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 21e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 225:	eb 04                	jmp    22b <strlen+0x13>
 227:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 22b:	8b 55 fc             	mov    -0x4(%ebp),%edx
 22e:	8b 45 08             	mov    0x8(%ebp),%eax
 231:	01 d0                	add    %edx,%eax
 233:	0f b6 00             	movzbl (%eax),%eax
 236:	84 c0                	test   %al,%al
 238:	75 ed                	jne    227 <strlen+0xf>
    ;
  return n;
 23a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 23d:	c9                   	leave  
 23e:	c3                   	ret    

0000023f <memset>:

void*
memset(void *dst, int c, uint n)
{
 23f:	55                   	push   %ebp
 240:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 242:	8b 45 10             	mov    0x10(%ebp),%eax
 245:	50                   	push   %eax
 246:	ff 75 0c             	pushl  0xc(%ebp)
 249:	ff 75 08             	pushl  0x8(%ebp)
 24c:	e8 32 ff ff ff       	call   183 <stosb>
 251:	83 c4 0c             	add    $0xc,%esp
  return dst;
 254:	8b 45 08             	mov    0x8(%ebp),%eax
}
 257:	c9                   	leave  
 258:	c3                   	ret    

00000259 <strchr>:

char*
strchr(const char *s, char c)
{
 259:	55                   	push   %ebp
 25a:	89 e5                	mov    %esp,%ebp
 25c:	83 ec 04             	sub    $0x4,%esp
 25f:	8b 45 0c             	mov    0xc(%ebp),%eax
 262:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 265:	eb 14                	jmp    27b <strchr+0x22>
    if(*s == c)
 267:	8b 45 08             	mov    0x8(%ebp),%eax
 26a:	0f b6 00             	movzbl (%eax),%eax
 26d:	3a 45 fc             	cmp    -0x4(%ebp),%al
 270:	75 05                	jne    277 <strchr+0x1e>
      return (char*)s;
 272:	8b 45 08             	mov    0x8(%ebp),%eax
 275:	eb 13                	jmp    28a <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 277:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 27b:	8b 45 08             	mov    0x8(%ebp),%eax
 27e:	0f b6 00             	movzbl (%eax),%eax
 281:	84 c0                	test   %al,%al
 283:	75 e2                	jne    267 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 285:	b8 00 00 00 00       	mov    $0x0,%eax
}
 28a:	c9                   	leave  
 28b:	c3                   	ret    

0000028c <gets>:

char*
gets(char *buf, int max)
{
 28c:	55                   	push   %ebp
 28d:	89 e5                	mov    %esp,%ebp
 28f:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 292:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 299:	eb 42                	jmp    2dd <gets+0x51>
    cc = read(0, &c, 1);
 29b:	83 ec 04             	sub    $0x4,%esp
 29e:	6a 01                	push   $0x1
 2a0:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2a3:	50                   	push   %eax
 2a4:	6a 00                	push   $0x0
 2a6:	e8 47 01 00 00       	call   3f2 <read>
 2ab:	83 c4 10             	add    $0x10,%esp
 2ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 2b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 2b5:	7e 33                	jle    2ea <gets+0x5e>
      break;
    buf[i++] = c;
 2b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2ba:	8d 50 01             	lea    0x1(%eax),%edx
 2bd:	89 55 f4             	mov    %edx,-0xc(%ebp)
 2c0:	89 c2                	mov    %eax,%edx
 2c2:	8b 45 08             	mov    0x8(%ebp),%eax
 2c5:	01 c2                	add    %eax,%edx
 2c7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2cb:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 2cd:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2d1:	3c 0a                	cmp    $0xa,%al
 2d3:	74 16                	je     2eb <gets+0x5f>
 2d5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2d9:	3c 0d                	cmp    $0xd,%al
 2db:	74 0e                	je     2eb <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2e0:	83 c0 01             	add    $0x1,%eax
 2e3:	3b 45 0c             	cmp    0xc(%ebp),%eax
 2e6:	7c b3                	jl     29b <gets+0xf>
 2e8:	eb 01                	jmp    2eb <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 2ea:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 2eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2ee:	8b 45 08             	mov    0x8(%ebp),%eax
 2f1:	01 d0                	add    %edx,%eax
 2f3:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2f6:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2f9:	c9                   	leave  
 2fa:	c3                   	ret    

000002fb <stat>:

int
stat(char *n, struct stat *st)
{
 2fb:	55                   	push   %ebp
 2fc:	89 e5                	mov    %esp,%ebp
 2fe:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 301:	83 ec 08             	sub    $0x8,%esp
 304:	6a 00                	push   $0x0
 306:	ff 75 08             	pushl  0x8(%ebp)
 309:	e8 0c 01 00 00       	call   41a <open>
 30e:	83 c4 10             	add    $0x10,%esp
 311:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 314:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 318:	79 07                	jns    321 <stat+0x26>
    return -1;
 31a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 31f:	eb 25                	jmp    346 <stat+0x4b>
  r = fstat(fd, st);
 321:	83 ec 08             	sub    $0x8,%esp
 324:	ff 75 0c             	pushl  0xc(%ebp)
 327:	ff 75 f4             	pushl  -0xc(%ebp)
 32a:	e8 03 01 00 00       	call   432 <fstat>
 32f:	83 c4 10             	add    $0x10,%esp
 332:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 335:	83 ec 0c             	sub    $0xc,%esp
 338:	ff 75 f4             	pushl  -0xc(%ebp)
 33b:	e8 c2 00 00 00       	call   402 <close>
 340:	83 c4 10             	add    $0x10,%esp
  return r;
 343:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 346:	c9                   	leave  
 347:	c3                   	ret    

00000348 <atoi>:

int
atoi(const char *s)
{
 348:	55                   	push   %ebp
 349:	89 e5                	mov    %esp,%ebp
 34b:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 34e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 355:	eb 25                	jmp    37c <atoi+0x34>
    n = n*10 + *s++ - '0';
 357:	8b 55 fc             	mov    -0x4(%ebp),%edx
 35a:	89 d0                	mov    %edx,%eax
 35c:	c1 e0 02             	shl    $0x2,%eax
 35f:	01 d0                	add    %edx,%eax
 361:	01 c0                	add    %eax,%eax
 363:	89 c1                	mov    %eax,%ecx
 365:	8b 45 08             	mov    0x8(%ebp),%eax
 368:	8d 50 01             	lea    0x1(%eax),%edx
 36b:	89 55 08             	mov    %edx,0x8(%ebp)
 36e:	0f b6 00             	movzbl (%eax),%eax
 371:	0f be c0             	movsbl %al,%eax
 374:	01 c8                	add    %ecx,%eax
 376:	83 e8 30             	sub    $0x30,%eax
 379:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 37c:	8b 45 08             	mov    0x8(%ebp),%eax
 37f:	0f b6 00             	movzbl (%eax),%eax
 382:	3c 2f                	cmp    $0x2f,%al
 384:	7e 0a                	jle    390 <atoi+0x48>
 386:	8b 45 08             	mov    0x8(%ebp),%eax
 389:	0f b6 00             	movzbl (%eax),%eax
 38c:	3c 39                	cmp    $0x39,%al
 38e:	7e c7                	jle    357 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 390:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 393:	c9                   	leave  
 394:	c3                   	ret    

00000395 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 395:	55                   	push   %ebp
 396:	89 e5                	mov    %esp,%ebp
 398:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 39b:	8b 45 08             	mov    0x8(%ebp),%eax
 39e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 3a1:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3a7:	eb 17                	jmp    3c0 <memmove+0x2b>
    *dst++ = *src++;
 3a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3ac:	8d 50 01             	lea    0x1(%eax),%edx
 3af:	89 55 fc             	mov    %edx,-0x4(%ebp)
 3b2:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3b5:	8d 4a 01             	lea    0x1(%edx),%ecx
 3b8:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 3bb:	0f b6 12             	movzbl (%edx),%edx
 3be:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3c0:	8b 45 10             	mov    0x10(%ebp),%eax
 3c3:	8d 50 ff             	lea    -0x1(%eax),%edx
 3c6:	89 55 10             	mov    %edx,0x10(%ebp)
 3c9:	85 c0                	test   %eax,%eax
 3cb:	7f dc                	jg     3a9 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 3cd:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3d0:	c9                   	leave  
 3d1:	c3                   	ret    

000003d2 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3d2:	b8 01 00 00 00       	mov    $0x1,%eax
 3d7:	cd 40                	int    $0x40
 3d9:	c3                   	ret    

000003da <exit>:
SYSCALL(exit)
 3da:	b8 02 00 00 00       	mov    $0x2,%eax
 3df:	cd 40                	int    $0x40
 3e1:	c3                   	ret    

000003e2 <wait>:
SYSCALL(wait)
 3e2:	b8 03 00 00 00       	mov    $0x3,%eax
 3e7:	cd 40                	int    $0x40
 3e9:	c3                   	ret    

000003ea <pipe>:
SYSCALL(pipe)
 3ea:	b8 04 00 00 00       	mov    $0x4,%eax
 3ef:	cd 40                	int    $0x40
 3f1:	c3                   	ret    

000003f2 <read>:
SYSCALL(read)
 3f2:	b8 05 00 00 00       	mov    $0x5,%eax
 3f7:	cd 40                	int    $0x40
 3f9:	c3                   	ret    

000003fa <write>:
SYSCALL(write)
 3fa:	b8 10 00 00 00       	mov    $0x10,%eax
 3ff:	cd 40                	int    $0x40
 401:	c3                   	ret    

00000402 <close>:
SYSCALL(close)
 402:	b8 15 00 00 00       	mov    $0x15,%eax
 407:	cd 40                	int    $0x40
 409:	c3                   	ret    

0000040a <kill>:
SYSCALL(kill)
 40a:	b8 06 00 00 00       	mov    $0x6,%eax
 40f:	cd 40                	int    $0x40
 411:	c3                   	ret    

00000412 <exec>:
SYSCALL(exec)
 412:	b8 07 00 00 00       	mov    $0x7,%eax
 417:	cd 40                	int    $0x40
 419:	c3                   	ret    

0000041a <open>:
SYSCALL(open)
 41a:	b8 0f 00 00 00       	mov    $0xf,%eax
 41f:	cd 40                	int    $0x40
 421:	c3                   	ret    

00000422 <mknod>:
SYSCALL(mknod)
 422:	b8 11 00 00 00       	mov    $0x11,%eax
 427:	cd 40                	int    $0x40
 429:	c3                   	ret    

0000042a <unlink>:
SYSCALL(unlink)
 42a:	b8 12 00 00 00       	mov    $0x12,%eax
 42f:	cd 40                	int    $0x40
 431:	c3                   	ret    

00000432 <fstat>:
SYSCALL(fstat)
 432:	b8 08 00 00 00       	mov    $0x8,%eax
 437:	cd 40                	int    $0x40
 439:	c3                   	ret    

0000043a <link>:
SYSCALL(link)
 43a:	b8 13 00 00 00       	mov    $0x13,%eax
 43f:	cd 40                	int    $0x40
 441:	c3                   	ret    

00000442 <mkdir>:
SYSCALL(mkdir)
 442:	b8 14 00 00 00       	mov    $0x14,%eax
 447:	cd 40                	int    $0x40
 449:	c3                   	ret    

0000044a <chdir>:
SYSCALL(chdir)
 44a:	b8 09 00 00 00       	mov    $0x9,%eax
 44f:	cd 40                	int    $0x40
 451:	c3                   	ret    

00000452 <dup>:
SYSCALL(dup)
 452:	b8 0a 00 00 00       	mov    $0xa,%eax
 457:	cd 40                	int    $0x40
 459:	c3                   	ret    

0000045a <getpid>:
SYSCALL(getpid)
 45a:	b8 0b 00 00 00       	mov    $0xb,%eax
 45f:	cd 40                	int    $0x40
 461:	c3                   	ret    

00000462 <sbrk>:
SYSCALL(sbrk)
 462:	b8 0c 00 00 00       	mov    $0xc,%eax
 467:	cd 40                	int    $0x40
 469:	c3                   	ret    

0000046a <sleep>:
SYSCALL(sleep)
 46a:	b8 0d 00 00 00       	mov    $0xd,%eax
 46f:	cd 40                	int    $0x40
 471:	c3                   	ret    

00000472 <uptime>:
SYSCALL(uptime)
 472:	b8 0e 00 00 00       	mov    $0xe,%eax
 477:	cd 40                	int    $0x40
 479:	c3                   	ret    

0000047a <halt>:
SYSCALL(halt)
 47a:	b8 16 00 00 00       	mov    $0x16,%eax
 47f:	cd 40                	int    $0x40
 481:	c3                   	ret    

00000482 <thread_create>:
SYSCALL(thread_create)
 482:	b8 17 00 00 00       	mov    $0x17,%eax
 487:	cd 40                	int    $0x40
 489:	c3                   	ret    

0000048a <thread_exit>:
SYSCALL(thread_exit)
 48a:	b8 18 00 00 00       	mov    $0x18,%eax
 48f:	cd 40                	int    $0x40
 491:	c3                   	ret    

00000492 <thread_join>:
SYSCALL(thread_join)
 492:	b8 19 00 00 00       	mov    $0x19,%eax
 497:	cd 40                	int    $0x40
 499:	c3                   	ret    

0000049a <gettid>:
SYSCALL(gettid)
 49a:	b8 1a 00 00 00       	mov    $0x1a,%eax
 49f:	cd 40                	int    $0x40
 4a1:	c3                   	ret    

000004a2 <clone>:
SYSCALL(clone)
 4a2:	b8 1b 00 00 00       	mov    $0x1b,%eax
 4a7:	cd 40                	int    $0x40
 4a9:	c3                   	ret    

000004aa <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4aa:	55                   	push   %ebp
 4ab:	89 e5                	mov    %esp,%ebp
 4ad:	83 ec 18             	sub    $0x18,%esp
 4b0:	8b 45 0c             	mov    0xc(%ebp),%eax
 4b3:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4b6:	83 ec 04             	sub    $0x4,%esp
 4b9:	6a 01                	push   $0x1
 4bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4be:	50                   	push   %eax
 4bf:	ff 75 08             	pushl  0x8(%ebp)
 4c2:	e8 33 ff ff ff       	call   3fa <write>
 4c7:	83 c4 10             	add    $0x10,%esp
}
 4ca:	90                   	nop
 4cb:	c9                   	leave  
 4cc:	c3                   	ret    

000004cd <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4cd:	55                   	push   %ebp
 4ce:	89 e5                	mov    %esp,%ebp
 4d0:	53                   	push   %ebx
 4d1:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4d4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4db:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4df:	74 17                	je     4f8 <printint+0x2b>
 4e1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4e5:	79 11                	jns    4f8 <printint+0x2b>
    neg = 1;
 4e7:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4ee:	8b 45 0c             	mov    0xc(%ebp),%eax
 4f1:	f7 d8                	neg    %eax
 4f3:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4f6:	eb 06                	jmp    4fe <printint+0x31>
  } else {
    x = xx;
 4f8:	8b 45 0c             	mov    0xc(%ebp),%eax
 4fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 505:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 508:	8d 41 01             	lea    0x1(%ecx),%eax
 50b:	89 45 f4             	mov    %eax,-0xc(%ebp)
 50e:	8b 5d 10             	mov    0x10(%ebp),%ebx
 511:	8b 45 ec             	mov    -0x14(%ebp),%eax
 514:	ba 00 00 00 00       	mov    $0x0,%edx
 519:	f7 f3                	div    %ebx
 51b:	89 d0                	mov    %edx,%eax
 51d:	0f b6 80 dc 0b 00 00 	movzbl 0xbdc(%eax),%eax
 524:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 528:	8b 5d 10             	mov    0x10(%ebp),%ebx
 52b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 52e:	ba 00 00 00 00       	mov    $0x0,%edx
 533:	f7 f3                	div    %ebx
 535:	89 45 ec             	mov    %eax,-0x14(%ebp)
 538:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 53c:	75 c7                	jne    505 <printint+0x38>
  if(neg)
 53e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 542:	74 2d                	je     571 <printint+0xa4>
    buf[i++] = '-';
 544:	8b 45 f4             	mov    -0xc(%ebp),%eax
 547:	8d 50 01             	lea    0x1(%eax),%edx
 54a:	89 55 f4             	mov    %edx,-0xc(%ebp)
 54d:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 552:	eb 1d                	jmp    571 <printint+0xa4>
    putc(fd, buf[i]);
 554:	8d 55 dc             	lea    -0x24(%ebp),%edx
 557:	8b 45 f4             	mov    -0xc(%ebp),%eax
 55a:	01 d0                	add    %edx,%eax
 55c:	0f b6 00             	movzbl (%eax),%eax
 55f:	0f be c0             	movsbl %al,%eax
 562:	83 ec 08             	sub    $0x8,%esp
 565:	50                   	push   %eax
 566:	ff 75 08             	pushl  0x8(%ebp)
 569:	e8 3c ff ff ff       	call   4aa <putc>
 56e:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 571:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 575:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 579:	79 d9                	jns    554 <printint+0x87>
    putc(fd, buf[i]);
}
 57b:	90                   	nop
 57c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 57f:	c9                   	leave  
 580:	c3                   	ret    

00000581 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 581:	55                   	push   %ebp
 582:	89 e5                	mov    %esp,%ebp
 584:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 587:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 58e:	8d 45 0c             	lea    0xc(%ebp),%eax
 591:	83 c0 04             	add    $0x4,%eax
 594:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 597:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 59e:	e9 59 01 00 00       	jmp    6fc <printf+0x17b>
    c = fmt[i] & 0xff;
 5a3:	8b 55 0c             	mov    0xc(%ebp),%edx
 5a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5a9:	01 d0                	add    %edx,%eax
 5ab:	0f b6 00             	movzbl (%eax),%eax
 5ae:	0f be c0             	movsbl %al,%eax
 5b1:	25 ff 00 00 00       	and    $0xff,%eax
 5b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5b9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5bd:	75 2c                	jne    5eb <printf+0x6a>
      if(c == '%'){
 5bf:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5c3:	75 0c                	jne    5d1 <printf+0x50>
        state = '%';
 5c5:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5cc:	e9 27 01 00 00       	jmp    6f8 <printf+0x177>
      } else {
        putc(fd, c);
 5d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5d4:	0f be c0             	movsbl %al,%eax
 5d7:	83 ec 08             	sub    $0x8,%esp
 5da:	50                   	push   %eax
 5db:	ff 75 08             	pushl  0x8(%ebp)
 5de:	e8 c7 fe ff ff       	call   4aa <putc>
 5e3:	83 c4 10             	add    $0x10,%esp
 5e6:	e9 0d 01 00 00       	jmp    6f8 <printf+0x177>
      }
    } else if(state == '%'){
 5eb:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5ef:	0f 85 03 01 00 00    	jne    6f8 <printf+0x177>
      if(c == 'd'){
 5f5:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5f9:	75 1e                	jne    619 <printf+0x98>
        printint(fd, *ap, 10, 1);
 5fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5fe:	8b 00                	mov    (%eax),%eax
 600:	6a 01                	push   $0x1
 602:	6a 0a                	push   $0xa
 604:	50                   	push   %eax
 605:	ff 75 08             	pushl  0x8(%ebp)
 608:	e8 c0 fe ff ff       	call   4cd <printint>
 60d:	83 c4 10             	add    $0x10,%esp
        ap++;
 610:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 614:	e9 d8 00 00 00       	jmp    6f1 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 619:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 61d:	74 06                	je     625 <printf+0xa4>
 61f:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 623:	75 1e                	jne    643 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 625:	8b 45 e8             	mov    -0x18(%ebp),%eax
 628:	8b 00                	mov    (%eax),%eax
 62a:	6a 00                	push   $0x0
 62c:	6a 10                	push   $0x10
 62e:	50                   	push   %eax
 62f:	ff 75 08             	pushl  0x8(%ebp)
 632:	e8 96 fe ff ff       	call   4cd <printint>
 637:	83 c4 10             	add    $0x10,%esp
        ap++;
 63a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 63e:	e9 ae 00 00 00       	jmp    6f1 <printf+0x170>
      } else if(c == 's'){
 643:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 647:	75 43                	jne    68c <printf+0x10b>
        s = (char*)*ap;
 649:	8b 45 e8             	mov    -0x18(%ebp),%eax
 64c:	8b 00                	mov    (%eax),%eax
 64e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 651:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 655:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 659:	75 25                	jne    680 <printf+0xff>
          s = "(null)";
 65b:	c7 45 f4 6e 09 00 00 	movl   $0x96e,-0xc(%ebp)
        while(*s != 0){
 662:	eb 1c                	jmp    680 <printf+0xff>
          putc(fd, *s);
 664:	8b 45 f4             	mov    -0xc(%ebp),%eax
 667:	0f b6 00             	movzbl (%eax),%eax
 66a:	0f be c0             	movsbl %al,%eax
 66d:	83 ec 08             	sub    $0x8,%esp
 670:	50                   	push   %eax
 671:	ff 75 08             	pushl  0x8(%ebp)
 674:	e8 31 fe ff ff       	call   4aa <putc>
 679:	83 c4 10             	add    $0x10,%esp
          s++;
 67c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 680:	8b 45 f4             	mov    -0xc(%ebp),%eax
 683:	0f b6 00             	movzbl (%eax),%eax
 686:	84 c0                	test   %al,%al
 688:	75 da                	jne    664 <printf+0xe3>
 68a:	eb 65                	jmp    6f1 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 68c:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 690:	75 1d                	jne    6af <printf+0x12e>
        putc(fd, *ap);
 692:	8b 45 e8             	mov    -0x18(%ebp),%eax
 695:	8b 00                	mov    (%eax),%eax
 697:	0f be c0             	movsbl %al,%eax
 69a:	83 ec 08             	sub    $0x8,%esp
 69d:	50                   	push   %eax
 69e:	ff 75 08             	pushl  0x8(%ebp)
 6a1:	e8 04 fe ff ff       	call   4aa <putc>
 6a6:	83 c4 10             	add    $0x10,%esp
        ap++;
 6a9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6ad:	eb 42                	jmp    6f1 <printf+0x170>
      } else if(c == '%'){
 6af:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6b3:	75 17                	jne    6cc <printf+0x14b>
        putc(fd, c);
 6b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6b8:	0f be c0             	movsbl %al,%eax
 6bb:	83 ec 08             	sub    $0x8,%esp
 6be:	50                   	push   %eax
 6bf:	ff 75 08             	pushl  0x8(%ebp)
 6c2:	e8 e3 fd ff ff       	call   4aa <putc>
 6c7:	83 c4 10             	add    $0x10,%esp
 6ca:	eb 25                	jmp    6f1 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6cc:	83 ec 08             	sub    $0x8,%esp
 6cf:	6a 25                	push   $0x25
 6d1:	ff 75 08             	pushl  0x8(%ebp)
 6d4:	e8 d1 fd ff ff       	call   4aa <putc>
 6d9:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 6dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6df:	0f be c0             	movsbl %al,%eax
 6e2:	83 ec 08             	sub    $0x8,%esp
 6e5:	50                   	push   %eax
 6e6:	ff 75 08             	pushl  0x8(%ebp)
 6e9:	e8 bc fd ff ff       	call   4aa <putc>
 6ee:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6f1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6f8:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6fc:	8b 55 0c             	mov    0xc(%ebp),%edx
 6ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
 702:	01 d0                	add    %edx,%eax
 704:	0f b6 00             	movzbl (%eax),%eax
 707:	84 c0                	test   %al,%al
 709:	0f 85 94 fe ff ff    	jne    5a3 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 70f:	90                   	nop
 710:	c9                   	leave  
 711:	c3                   	ret    

00000712 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 712:	55                   	push   %ebp
 713:	89 e5                	mov    %esp,%ebp
 715:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 718:	8b 45 08             	mov    0x8(%ebp),%eax
 71b:	83 e8 08             	sub    $0x8,%eax
 71e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 721:	a1 f8 0b 00 00       	mov    0xbf8,%eax
 726:	89 45 fc             	mov    %eax,-0x4(%ebp)
 729:	eb 24                	jmp    74f <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 72b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72e:	8b 00                	mov    (%eax),%eax
 730:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 733:	77 12                	ja     747 <free+0x35>
 735:	8b 45 f8             	mov    -0x8(%ebp),%eax
 738:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 73b:	77 24                	ja     761 <free+0x4f>
 73d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 740:	8b 00                	mov    (%eax),%eax
 742:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 745:	77 1a                	ja     761 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 747:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74a:	8b 00                	mov    (%eax),%eax
 74c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 74f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 752:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 755:	76 d4                	jbe    72b <free+0x19>
 757:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75a:	8b 00                	mov    (%eax),%eax
 75c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 75f:	76 ca                	jbe    72b <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 761:	8b 45 f8             	mov    -0x8(%ebp),%eax
 764:	8b 40 04             	mov    0x4(%eax),%eax
 767:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 76e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 771:	01 c2                	add    %eax,%edx
 773:	8b 45 fc             	mov    -0x4(%ebp),%eax
 776:	8b 00                	mov    (%eax),%eax
 778:	39 c2                	cmp    %eax,%edx
 77a:	75 24                	jne    7a0 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 77c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 77f:	8b 50 04             	mov    0x4(%eax),%edx
 782:	8b 45 fc             	mov    -0x4(%ebp),%eax
 785:	8b 00                	mov    (%eax),%eax
 787:	8b 40 04             	mov    0x4(%eax),%eax
 78a:	01 c2                	add    %eax,%edx
 78c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 78f:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 792:	8b 45 fc             	mov    -0x4(%ebp),%eax
 795:	8b 00                	mov    (%eax),%eax
 797:	8b 10                	mov    (%eax),%edx
 799:	8b 45 f8             	mov    -0x8(%ebp),%eax
 79c:	89 10                	mov    %edx,(%eax)
 79e:	eb 0a                	jmp    7aa <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 7a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a3:	8b 10                	mov    (%eax),%edx
 7a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a8:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ad:	8b 40 04             	mov    0x4(%eax),%eax
 7b0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ba:	01 d0                	add    %edx,%eax
 7bc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7bf:	75 20                	jne    7e1 <free+0xcf>
    p->s.size += bp->s.size;
 7c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c4:	8b 50 04             	mov    0x4(%eax),%edx
 7c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ca:	8b 40 04             	mov    0x4(%eax),%eax
 7cd:	01 c2                	add    %eax,%edx
 7cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d2:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d8:	8b 10                	mov    (%eax),%edx
 7da:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7dd:	89 10                	mov    %edx,(%eax)
 7df:	eb 08                	jmp    7e9 <free+0xd7>
  } else
    p->s.ptr = bp;
 7e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e4:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7e7:	89 10                	mov    %edx,(%eax)
  freep = p;
 7e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ec:	a3 f8 0b 00 00       	mov    %eax,0xbf8
}
 7f1:	90                   	nop
 7f2:	c9                   	leave  
 7f3:	c3                   	ret    

000007f4 <morecore>:

static Header*
morecore(uint nu)
{
 7f4:	55                   	push   %ebp
 7f5:	89 e5                	mov    %esp,%ebp
 7f7:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7fa:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 801:	77 07                	ja     80a <morecore+0x16>
    nu = 4096;
 803:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 80a:	8b 45 08             	mov    0x8(%ebp),%eax
 80d:	c1 e0 03             	shl    $0x3,%eax
 810:	83 ec 0c             	sub    $0xc,%esp
 813:	50                   	push   %eax
 814:	e8 49 fc ff ff       	call   462 <sbrk>
 819:	83 c4 10             	add    $0x10,%esp
 81c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 81f:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 823:	75 07                	jne    82c <morecore+0x38>
    return 0;
 825:	b8 00 00 00 00       	mov    $0x0,%eax
 82a:	eb 26                	jmp    852 <morecore+0x5e>
  hp = (Header*)p;
 82c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 832:	8b 45 f0             	mov    -0x10(%ebp),%eax
 835:	8b 55 08             	mov    0x8(%ebp),%edx
 838:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 83b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 83e:	83 c0 08             	add    $0x8,%eax
 841:	83 ec 0c             	sub    $0xc,%esp
 844:	50                   	push   %eax
 845:	e8 c8 fe ff ff       	call   712 <free>
 84a:	83 c4 10             	add    $0x10,%esp
  return freep;
 84d:	a1 f8 0b 00 00       	mov    0xbf8,%eax
}
 852:	c9                   	leave  
 853:	c3                   	ret    

00000854 <malloc>:

void*
malloc(uint nbytes)
{
 854:	55                   	push   %ebp
 855:	89 e5                	mov    %esp,%ebp
 857:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 85a:	8b 45 08             	mov    0x8(%ebp),%eax
 85d:	83 c0 07             	add    $0x7,%eax
 860:	c1 e8 03             	shr    $0x3,%eax
 863:	83 c0 01             	add    $0x1,%eax
 866:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 869:	a1 f8 0b 00 00       	mov    0xbf8,%eax
 86e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 871:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 875:	75 23                	jne    89a <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 877:	c7 45 f0 f0 0b 00 00 	movl   $0xbf0,-0x10(%ebp)
 87e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 881:	a3 f8 0b 00 00       	mov    %eax,0xbf8
 886:	a1 f8 0b 00 00       	mov    0xbf8,%eax
 88b:	a3 f0 0b 00 00       	mov    %eax,0xbf0
    base.s.size = 0;
 890:	c7 05 f4 0b 00 00 00 	movl   $0x0,0xbf4
 897:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 89a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 89d:	8b 00                	mov    (%eax),%eax
 89f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a5:	8b 40 04             	mov    0x4(%eax),%eax
 8a8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8ab:	72 4d                	jb     8fa <malloc+0xa6>
      if(p->s.size == nunits)
 8ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b0:	8b 40 04             	mov    0x4(%eax),%eax
 8b3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8b6:	75 0c                	jne    8c4 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8bb:	8b 10                	mov    (%eax),%edx
 8bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8c0:	89 10                	mov    %edx,(%eax)
 8c2:	eb 26                	jmp    8ea <malloc+0x96>
      else {
        p->s.size -= nunits;
 8c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c7:	8b 40 04             	mov    0x4(%eax),%eax
 8ca:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8cd:	89 c2                	mov    %eax,%edx
 8cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d2:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d8:	8b 40 04             	mov    0x4(%eax),%eax
 8db:	c1 e0 03             	shl    $0x3,%eax
 8de:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e4:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8e7:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ed:	a3 f8 0b 00 00       	mov    %eax,0xbf8
      return (void*)(p + 1);
 8f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f5:	83 c0 08             	add    $0x8,%eax
 8f8:	eb 3b                	jmp    935 <malloc+0xe1>
    }
    if(p == freep)
 8fa:	a1 f8 0b 00 00       	mov    0xbf8,%eax
 8ff:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 902:	75 1e                	jne    922 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 904:	83 ec 0c             	sub    $0xc,%esp
 907:	ff 75 ec             	pushl  -0x14(%ebp)
 90a:	e8 e5 fe ff ff       	call   7f4 <morecore>
 90f:	83 c4 10             	add    $0x10,%esp
 912:	89 45 f4             	mov    %eax,-0xc(%ebp)
 915:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 919:	75 07                	jne    922 <malloc+0xce>
        return 0;
 91b:	b8 00 00 00 00       	mov    $0x0,%eax
 920:	eb 13                	jmp    935 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 922:	8b 45 f4             	mov    -0xc(%ebp),%eax
 925:	89 45 f0             	mov    %eax,-0x10(%ebp)
 928:	8b 45 f4             	mov    -0xc(%ebp),%eax
 92b:	8b 00                	mov    (%eax),%eax
 92d:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 930:	e9 6d ff ff ff       	jmp    8a2 <malloc+0x4e>
}
 935:	c9                   	leave  
 936:	c3                   	ret    
