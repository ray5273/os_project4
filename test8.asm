
_test8:     file format elf32-i386


Disassembly of section .text:

00000000 <thread1>:

void *stack[NTHREAD];
int tid[NTHREAD];
void *retval[NTHREAD];

void *thread1(void *arg){
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
	int *fd = (int *)arg;
   6:	8b 45 08             	mov    0x8(%ebp),%eax
   9:	89 45 f4             	mov    %eax,-0xc(%ebp)

	*fd = open("testfile", O_CREATE|O_RDWR);
   c:	83 ec 08             	sub    $0x8,%esp
   f:	68 02 02 00 00       	push   $0x202
  14:	68 78 0a 00 00       	push   $0xa78
  19:	e8 3d 05 00 00       	call   55b <open>
  1e:	83 c4 10             	add    $0x10,%esp
  21:	89 c2                	mov    %eax,%edx
  23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  26:	89 10                	mov    %edx,(%eax)
	if(*fd < 0){
  28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  2b:	8b 00                	mov    (%eax),%eax
  2d:	85 c0                	test   %eax,%eax
  2f:	79 17                	jns    48 <thread1+0x48>
		printf(1, "FILE WRONG\n");
  31:	83 ec 08             	sub    $0x8,%esp
  34:	68 81 0a 00 00       	push   $0xa81
  39:	6a 01                	push   $0x1
  3b:	e8 82 06 00 00       	call   6c2 <printf>
  40:	83 c4 10             	add    $0x10,%esp
		exit();
  43:	e8 d3 04 00 00       	call   51b <exit>
	}

	if(write(*fd, "hello", 5) != 5){
  48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  4b:	8b 00                	mov    (%eax),%eax
  4d:	83 ec 04             	sub    $0x4,%esp
  50:	6a 05                	push   $0x5
  52:	68 8d 0a 00 00       	push   $0xa8d
  57:	50                   	push   %eax
  58:	e8 de 04 00 00       	call   53b <write>
  5d:	83 c4 10             	add    $0x10,%esp
  60:	83 f8 05             	cmp    $0x5,%eax
  63:	74 17                	je     7c <thread1+0x7c>
		printf(1, "FILE WRITEWRONG\n");
  65:	83 ec 08             	sub    $0x8,%esp
  68:	68 93 0a 00 00       	push   $0xa93
  6d:	6a 01                	push   $0x1
  6f:	e8 4e 06 00 00       	call   6c2 <printf>
  74:	83 c4 10             	add    $0x10,%esp
		exit();
  77:	e8 9f 04 00 00       	call   51b <exit>
	}

	thread_exit(0);
  7c:	83 ec 0c             	sub    $0xc,%esp
  7f:	6a 00                	push   $0x0
  81:	e8 45 05 00 00       	call   5cb <thread_exit>

00000086 <thread2>:
}

void *thread2(void *arg){
  86:	55                   	push   %ebp
  87:	89 e5                	mov    %esp,%ebp
  89:	83 ec 18             	sub    $0x18,%esp
	int fd = (int)arg;
  8c:	8b 45 08             	mov    0x8(%ebp),%eax
  8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(write(fd, "world", 5) != 5){
  92:	83 ec 04             	sub    $0x4,%esp
  95:	6a 05                	push   $0x5
  97:	68 a4 0a 00 00       	push   $0xaa4
  9c:	ff 75 f4             	pushl  -0xc(%ebp)
  9f:	e8 97 04 00 00       	call   53b <write>
  a4:	83 c4 10             	add    $0x10,%esp
  a7:	83 f8 05             	cmp    $0x5,%eax
  aa:	74 17                	je     c3 <thread2+0x3d>
		printf(1, "THREAD2 FILE WRITE WRONG\n");
  ac:	83 ec 08             	sub    $0x8,%esp
  af:	68 aa 0a 00 00       	push   $0xaaa
  b4:	6a 01                	push   $0x1
  b6:	e8 07 06 00 00       	call   6c2 <printf>
  bb:	83 c4 10             	add    $0x10,%esp
		exit(); 
  be:	e8 58 04 00 00       	call   51b <exit>
	}

	close(fd);
  c3:	83 ec 0c             	sub    $0xc,%esp
  c6:	ff 75 f4             	pushl  -0xc(%ebp)
  c9:	e8 75 04 00 00       	call   543 <close>
  ce:	83 c4 10             	add    $0x10,%esp

	thread_exit(0);
  d1:	83 ec 0c             	sub    $0xc,%esp
  d4:	6a 00                	push   $0x0
  d6:	e8 f0 04 00 00       	call   5cb <thread_exit>

000000db <main>:
}

int
main(int argc, char **argv)
{
  db:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  df:	83 e4 f0             	and    $0xfffffff0,%esp
  e2:	ff 71 fc             	pushl  -0x4(%ecx)
  e5:	55                   	push   %ebp
  e6:	89 e5                	mov    %esp,%ebp
  e8:	51                   	push   %ecx
  e9:	83 ec 74             	sub    $0x74,%esp
	int i;
	int fd;
	char buf[100];

	printf(1, "TEST8: ");
  ec:	83 ec 08             	sub    $0x8,%esp
  ef:	68 c4 0a 00 00       	push   $0xac4
  f4:	6a 01                	push   $0x1
  f6:	e8 c7 05 00 00       	call   6c2 <printf>
  fb:	83 c4 10             	add    $0x10,%esp

	for(i=0;i<NTHREAD;i++)
  fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 105:	eb 20                	jmp    127 <main+0x4c>
		stack[i] = malloc(4096);
 107:	83 ec 0c             	sub    $0xc,%esp
 10a:	68 00 10 00 00       	push   $0x1000
 10f:	e8 81 08 00 00       	call   995 <malloc>
 114:	83 c4 10             	add    $0x10,%esp
 117:	89 c2                	mov    %eax,%edx
 119:	8b 45 f4             	mov    -0xc(%ebp),%eax
 11c:	89 14 85 f8 0d 00 00 	mov    %edx,0xdf8(,%eax,4)
	int fd;
	char buf[100];

	printf(1, "TEST8: ");

	for(i=0;i<NTHREAD;i++)
 123:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 127:	83 7d f4 06          	cmpl   $0x6,-0xc(%ebp)
 12b:	7e da                	jle    107 <main+0x2c>
		stack[i] = malloc(4096);

	if((tid[0] = thread_create(thread1, 10, (void *)&fd, stack[0])) == -1){
 12d:	a1 f8 0d 00 00       	mov    0xdf8,%eax
 132:	50                   	push   %eax
 133:	8d 45 f0             	lea    -0x10(%ebp),%eax
 136:	50                   	push   %eax
 137:	6a 0a                	push   $0xa
 139:	68 00 00 00 00       	push   $0x0
 13e:	e8 80 04 00 00       	call   5c3 <thread_create>
 143:	83 c4 10             	add    $0x10,%esp
 146:	a3 14 0e 00 00       	mov    %eax,0xe14
 14b:	a1 14 0e 00 00       	mov    0xe14,%eax
 150:	83 f8 ff             	cmp    $0xffffffff,%eax
 153:	75 17                	jne    16c <main+0x91>
		printf(1, "THREAD 1 CREATE WRONG\n");
 155:	83 ec 08             	sub    $0x8,%esp
 158:	68 cc 0a 00 00       	push   $0xacc
 15d:	6a 01                	push   $0x1
 15f:	e8 5e 05 00 00       	call   6c2 <printf>
 164:	83 c4 10             	add    $0x10,%esp
		exit();
 167:	e8 af 03 00 00       	call   51b <exit>
	}
	if(thread_join(tid[0], &retval[0]) == -1){
 16c:	a1 14 0e 00 00       	mov    0xe14,%eax
 171:	83 ec 08             	sub    $0x8,%esp
 174:	68 30 0e 00 00       	push   $0xe30
 179:	50                   	push   %eax
 17a:	e8 54 04 00 00       	call   5d3 <thread_join>
 17f:	83 c4 10             	add    $0x10,%esp
 182:	83 f8 ff             	cmp    $0xffffffff,%eax
 185:	75 17                	jne    19e <main+0xc3>
		printf(1, "JOIN WRONG\n");
 187:	83 ec 08             	sub    $0x8,%esp
 18a:	68 e3 0a 00 00       	push   $0xae3
 18f:	6a 01                	push   $0x1
 191:	e8 2c 05 00 00       	call   6c2 <printf>
 196:	83 c4 10             	add    $0x10,%esp
		exit();
 199:	e8 7d 03 00 00       	call   51b <exit>
	}

    
	if((tid[1] = thread_create(thread2, 10, (void *)fd, stack[1])) == -1){
 19e:	a1 fc 0d 00 00       	mov    0xdfc,%eax
 1a3:	8b 55 f0             	mov    -0x10(%ebp),%edx
 1a6:	50                   	push   %eax
 1a7:	52                   	push   %edx
 1a8:	6a 0a                	push   $0xa
 1aa:	68 86 00 00 00       	push   $0x86
 1af:	e8 0f 04 00 00       	call   5c3 <thread_create>
 1b4:	83 c4 10             	add    $0x10,%esp
 1b7:	a3 18 0e 00 00       	mov    %eax,0xe18
 1bc:	a1 18 0e 00 00       	mov    0xe18,%eax
 1c1:	83 f8 ff             	cmp    $0xffffffff,%eax
 1c4:	75 17                	jne    1dd <main+0x102>
		printf(1, "THREAD 2 CREATE WRONG\n");
 1c6:	83 ec 08             	sub    $0x8,%esp
 1c9:	68 ef 0a 00 00       	push   $0xaef
 1ce:	6a 01                	push   $0x1
 1d0:	e8 ed 04 00 00       	call   6c2 <printf>
 1d5:	83 c4 10             	add    $0x10,%esp
		exit();
 1d8:	e8 3e 03 00 00       	call   51b <exit>
	}
    
	if(thread_join(tid[1], &retval[1]) == -1){
 1dd:	a1 18 0e 00 00       	mov    0xe18,%eax
 1e2:	83 ec 08             	sub    $0x8,%esp
 1e5:	68 34 0e 00 00       	push   $0xe34
 1ea:	50                   	push   %eax
 1eb:	e8 e3 03 00 00       	call   5d3 <thread_join>
 1f0:	83 c4 10             	add    $0x10,%esp
 1f3:	83 f8 ff             	cmp    $0xffffffff,%eax
 1f6:	75 17                	jne    20f <main+0x134>
		printf(1, "THREAD 2 join WRONG\n");
 1f8:	83 ec 08             	sub    $0x8,%esp
 1fb:	68 06 0b 00 00       	push   $0xb06
 200:	6a 01                	push   $0x1
 202:	e8 bb 04 00 00       	call   6c2 <printf>
 207:	83 c4 10             	add    $0x10,%esp
		exit();
 20a:	e8 0c 03 00 00       	call   51b <exit>
	}

	fd = open("testfile", O_RDONLY);
 20f:	83 ec 08             	sub    $0x8,%esp
 212:	6a 00                	push   $0x0
 214:	68 78 0a 00 00       	push   $0xa78
 219:	e8 3d 03 00 00       	call   55b <open>
 21e:	83 c4 10             	add    $0x10,%esp
 221:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(read(fd, buf, 10) != 10){
 224:	8b 45 f0             	mov    -0x10(%ebp),%eax
 227:	83 ec 04             	sub    $0x4,%esp
 22a:	6a 0a                	push   $0xa
 22c:	8d 55 8c             	lea    -0x74(%ebp),%edx
 22f:	52                   	push   %edx
 230:	50                   	push   %eax
 231:	e8 fd 02 00 00       	call   533 <read>
 236:	83 c4 10             	add    $0x10,%esp
 239:	83 f8 0a             	cmp    $0xa,%eax
 23c:	74 17                	je     255 <main+0x17a>
		printf(1, "FILE READ WRONG\n");
 23e:	83 ec 08             	sub    $0x8,%esp
 241:	68 1b 0b 00 00       	push   $0xb1b
 246:	6a 01                	push   $0x1
 248:	e8 75 04 00 00       	call   6c2 <printf>
 24d:	83 c4 10             	add    $0x10,%esp
		exit();
 250:	e8 c6 02 00 00       	call   51b <exit>
	}

	if(strcmp(buf, "helloworld") != 0){
 255:	83 ec 08             	sub    $0x8,%esp
 258:	68 2c 0b 00 00       	push   $0xb2c
 25d:	8d 45 8c             	lea    -0x74(%ebp),%eax
 260:	50                   	push   %eax
 261:	e8 b4 00 00 00       	call   31a <strcmp>
 266:	83 c4 10             	add    $0x10,%esp
 269:	85 c0                	test   %eax,%eax
 26b:	74 17                	je     284 <main+0x1a9>
		printf(1, "FILE COMPARE WRONG\n");
 26d:	83 ec 08             	sub    $0x8,%esp
 270:	68 37 0b 00 00       	push   $0xb37
 275:	6a 01                	push   $0x1
 277:	e8 46 04 00 00       	call   6c2 <printf>
 27c:	83 c4 10             	add    $0x10,%esp
		exit();
 27f:	e8 97 02 00 00       	call   51b <exit>
	}

	for(i=0;i<NTHREAD;i++)
 284:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 28b:	eb 1a                	jmp    2a7 <main+0x1cc>
		free(stack[i]);
 28d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 290:	8b 04 85 f8 0d 00 00 	mov    0xdf8(,%eax,4),%eax
 297:	83 ec 0c             	sub    $0xc,%esp
 29a:	50                   	push   %eax
 29b:	e8 b3 05 00 00       	call   853 <free>
 2a0:	83 c4 10             	add    $0x10,%esp
	if(strcmp(buf, "helloworld") != 0){
		printf(1, "FILE COMPARE WRONG\n");
		exit();
	}

	for(i=0;i<NTHREAD;i++)
 2a3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 2a7:	83 7d f4 06          	cmpl   $0x6,-0xc(%ebp)
 2ab:	7e e0                	jle    28d <main+0x1b2>
		free(stack[i]);

	printf(1, "OK\n");
 2ad:	83 ec 08             	sub    $0x8,%esp
 2b0:	68 4b 0b 00 00       	push   $0xb4b
 2b5:	6a 01                	push   $0x1
 2b7:	e8 06 04 00 00       	call   6c2 <printf>
 2bc:	83 c4 10             	add    $0x10,%esp

	exit();
 2bf:	e8 57 02 00 00       	call   51b <exit>

000002c4 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 2c4:	55                   	push   %ebp
 2c5:	89 e5                	mov    %esp,%ebp
 2c7:	57                   	push   %edi
 2c8:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 2c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2cc:	8b 55 10             	mov    0x10(%ebp),%edx
 2cf:	8b 45 0c             	mov    0xc(%ebp),%eax
 2d2:	89 cb                	mov    %ecx,%ebx
 2d4:	89 df                	mov    %ebx,%edi
 2d6:	89 d1                	mov    %edx,%ecx
 2d8:	fc                   	cld    
 2d9:	f3 aa                	rep stos %al,%es:(%edi)
 2db:	89 ca                	mov    %ecx,%edx
 2dd:	89 fb                	mov    %edi,%ebx
 2df:	89 5d 08             	mov    %ebx,0x8(%ebp)
 2e2:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 2e5:	90                   	nop
 2e6:	5b                   	pop    %ebx
 2e7:	5f                   	pop    %edi
 2e8:	5d                   	pop    %ebp
 2e9:	c3                   	ret    

000002ea <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 2ea:	55                   	push   %ebp
 2eb:	89 e5                	mov    %esp,%ebp
 2ed:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 2f0:	8b 45 08             	mov    0x8(%ebp),%eax
 2f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 2f6:	90                   	nop
 2f7:	8b 45 08             	mov    0x8(%ebp),%eax
 2fa:	8d 50 01             	lea    0x1(%eax),%edx
 2fd:	89 55 08             	mov    %edx,0x8(%ebp)
 300:	8b 55 0c             	mov    0xc(%ebp),%edx
 303:	8d 4a 01             	lea    0x1(%edx),%ecx
 306:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 309:	0f b6 12             	movzbl (%edx),%edx
 30c:	88 10                	mov    %dl,(%eax)
 30e:	0f b6 00             	movzbl (%eax),%eax
 311:	84 c0                	test   %al,%al
 313:	75 e2                	jne    2f7 <strcpy+0xd>
    ;
  return os;
 315:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 318:	c9                   	leave  
 319:	c3                   	ret    

0000031a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 31a:	55                   	push   %ebp
 31b:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 31d:	eb 08                	jmp    327 <strcmp+0xd>
    p++, q++;
 31f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 323:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 327:	8b 45 08             	mov    0x8(%ebp),%eax
 32a:	0f b6 00             	movzbl (%eax),%eax
 32d:	84 c0                	test   %al,%al
 32f:	74 10                	je     341 <strcmp+0x27>
 331:	8b 45 08             	mov    0x8(%ebp),%eax
 334:	0f b6 10             	movzbl (%eax),%edx
 337:	8b 45 0c             	mov    0xc(%ebp),%eax
 33a:	0f b6 00             	movzbl (%eax),%eax
 33d:	38 c2                	cmp    %al,%dl
 33f:	74 de                	je     31f <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 341:	8b 45 08             	mov    0x8(%ebp),%eax
 344:	0f b6 00             	movzbl (%eax),%eax
 347:	0f b6 d0             	movzbl %al,%edx
 34a:	8b 45 0c             	mov    0xc(%ebp),%eax
 34d:	0f b6 00             	movzbl (%eax),%eax
 350:	0f b6 c0             	movzbl %al,%eax
 353:	29 c2                	sub    %eax,%edx
 355:	89 d0                	mov    %edx,%eax
}
 357:	5d                   	pop    %ebp
 358:	c3                   	ret    

00000359 <strlen>:

uint
strlen(char *s)
{
 359:	55                   	push   %ebp
 35a:	89 e5                	mov    %esp,%ebp
 35c:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 35f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 366:	eb 04                	jmp    36c <strlen+0x13>
 368:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 36c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 36f:	8b 45 08             	mov    0x8(%ebp),%eax
 372:	01 d0                	add    %edx,%eax
 374:	0f b6 00             	movzbl (%eax),%eax
 377:	84 c0                	test   %al,%al
 379:	75 ed                	jne    368 <strlen+0xf>
    ;
  return n;
 37b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 37e:	c9                   	leave  
 37f:	c3                   	ret    

00000380 <memset>:

void*
memset(void *dst, int c, uint n)
{
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 383:	8b 45 10             	mov    0x10(%ebp),%eax
 386:	50                   	push   %eax
 387:	ff 75 0c             	pushl  0xc(%ebp)
 38a:	ff 75 08             	pushl  0x8(%ebp)
 38d:	e8 32 ff ff ff       	call   2c4 <stosb>
 392:	83 c4 0c             	add    $0xc,%esp
  return dst;
 395:	8b 45 08             	mov    0x8(%ebp),%eax
}
 398:	c9                   	leave  
 399:	c3                   	ret    

0000039a <strchr>:

char*
strchr(const char *s, char c)
{
 39a:	55                   	push   %ebp
 39b:	89 e5                	mov    %esp,%ebp
 39d:	83 ec 04             	sub    $0x4,%esp
 3a0:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a3:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 3a6:	eb 14                	jmp    3bc <strchr+0x22>
    if(*s == c)
 3a8:	8b 45 08             	mov    0x8(%ebp),%eax
 3ab:	0f b6 00             	movzbl (%eax),%eax
 3ae:	3a 45 fc             	cmp    -0x4(%ebp),%al
 3b1:	75 05                	jne    3b8 <strchr+0x1e>
      return (char*)s;
 3b3:	8b 45 08             	mov    0x8(%ebp),%eax
 3b6:	eb 13                	jmp    3cb <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 3b8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3bc:	8b 45 08             	mov    0x8(%ebp),%eax
 3bf:	0f b6 00             	movzbl (%eax),%eax
 3c2:	84 c0                	test   %al,%al
 3c4:	75 e2                	jne    3a8 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 3c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
 3cb:	c9                   	leave  
 3cc:	c3                   	ret    

000003cd <gets>:

char*
gets(char *buf, int max)
{
 3cd:	55                   	push   %ebp
 3ce:	89 e5                	mov    %esp,%ebp
 3d0:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3d3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 3da:	eb 42                	jmp    41e <gets+0x51>
    cc = read(0, &c, 1);
 3dc:	83 ec 04             	sub    $0x4,%esp
 3df:	6a 01                	push   $0x1
 3e1:	8d 45 ef             	lea    -0x11(%ebp),%eax
 3e4:	50                   	push   %eax
 3e5:	6a 00                	push   $0x0
 3e7:	e8 47 01 00 00       	call   533 <read>
 3ec:	83 c4 10             	add    $0x10,%esp
 3ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 3f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3f6:	7e 33                	jle    42b <gets+0x5e>
      break;
    buf[i++] = c;
 3f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3fb:	8d 50 01             	lea    0x1(%eax),%edx
 3fe:	89 55 f4             	mov    %edx,-0xc(%ebp)
 401:	89 c2                	mov    %eax,%edx
 403:	8b 45 08             	mov    0x8(%ebp),%eax
 406:	01 c2                	add    %eax,%edx
 408:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 40c:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 40e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 412:	3c 0a                	cmp    $0xa,%al
 414:	74 16                	je     42c <gets+0x5f>
 416:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 41a:	3c 0d                	cmp    $0xd,%al
 41c:	74 0e                	je     42c <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 41e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 421:	83 c0 01             	add    $0x1,%eax
 424:	3b 45 0c             	cmp    0xc(%ebp),%eax
 427:	7c b3                	jl     3dc <gets+0xf>
 429:	eb 01                	jmp    42c <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 42b:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 42c:	8b 55 f4             	mov    -0xc(%ebp),%edx
 42f:	8b 45 08             	mov    0x8(%ebp),%eax
 432:	01 d0                	add    %edx,%eax
 434:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 437:	8b 45 08             	mov    0x8(%ebp),%eax
}
 43a:	c9                   	leave  
 43b:	c3                   	ret    

0000043c <stat>:

int
stat(char *n, struct stat *st)
{
 43c:	55                   	push   %ebp
 43d:	89 e5                	mov    %esp,%ebp
 43f:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 442:	83 ec 08             	sub    $0x8,%esp
 445:	6a 00                	push   $0x0
 447:	ff 75 08             	pushl  0x8(%ebp)
 44a:	e8 0c 01 00 00       	call   55b <open>
 44f:	83 c4 10             	add    $0x10,%esp
 452:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 455:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 459:	79 07                	jns    462 <stat+0x26>
    return -1;
 45b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 460:	eb 25                	jmp    487 <stat+0x4b>
  r = fstat(fd, st);
 462:	83 ec 08             	sub    $0x8,%esp
 465:	ff 75 0c             	pushl  0xc(%ebp)
 468:	ff 75 f4             	pushl  -0xc(%ebp)
 46b:	e8 03 01 00 00       	call   573 <fstat>
 470:	83 c4 10             	add    $0x10,%esp
 473:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 476:	83 ec 0c             	sub    $0xc,%esp
 479:	ff 75 f4             	pushl  -0xc(%ebp)
 47c:	e8 c2 00 00 00       	call   543 <close>
 481:	83 c4 10             	add    $0x10,%esp
  return r;
 484:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 487:	c9                   	leave  
 488:	c3                   	ret    

00000489 <atoi>:

int
atoi(const char *s)
{
 489:	55                   	push   %ebp
 48a:	89 e5                	mov    %esp,%ebp
 48c:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 48f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 496:	eb 25                	jmp    4bd <atoi+0x34>
    n = n*10 + *s++ - '0';
 498:	8b 55 fc             	mov    -0x4(%ebp),%edx
 49b:	89 d0                	mov    %edx,%eax
 49d:	c1 e0 02             	shl    $0x2,%eax
 4a0:	01 d0                	add    %edx,%eax
 4a2:	01 c0                	add    %eax,%eax
 4a4:	89 c1                	mov    %eax,%ecx
 4a6:	8b 45 08             	mov    0x8(%ebp),%eax
 4a9:	8d 50 01             	lea    0x1(%eax),%edx
 4ac:	89 55 08             	mov    %edx,0x8(%ebp)
 4af:	0f b6 00             	movzbl (%eax),%eax
 4b2:	0f be c0             	movsbl %al,%eax
 4b5:	01 c8                	add    %ecx,%eax
 4b7:	83 e8 30             	sub    $0x30,%eax
 4ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 4bd:	8b 45 08             	mov    0x8(%ebp),%eax
 4c0:	0f b6 00             	movzbl (%eax),%eax
 4c3:	3c 2f                	cmp    $0x2f,%al
 4c5:	7e 0a                	jle    4d1 <atoi+0x48>
 4c7:	8b 45 08             	mov    0x8(%ebp),%eax
 4ca:	0f b6 00             	movzbl (%eax),%eax
 4cd:	3c 39                	cmp    $0x39,%al
 4cf:	7e c7                	jle    498 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 4d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 4d4:	c9                   	leave  
 4d5:	c3                   	ret    

000004d6 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 4d6:	55                   	push   %ebp
 4d7:	89 e5                	mov    %esp,%ebp
 4d9:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 4dc:	8b 45 08             	mov    0x8(%ebp),%eax
 4df:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 4e2:	8b 45 0c             	mov    0xc(%ebp),%eax
 4e5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 4e8:	eb 17                	jmp    501 <memmove+0x2b>
    *dst++ = *src++;
 4ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
 4ed:	8d 50 01             	lea    0x1(%eax),%edx
 4f0:	89 55 fc             	mov    %edx,-0x4(%ebp)
 4f3:	8b 55 f8             	mov    -0x8(%ebp),%edx
 4f6:	8d 4a 01             	lea    0x1(%edx),%ecx
 4f9:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 4fc:	0f b6 12             	movzbl (%edx),%edx
 4ff:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 501:	8b 45 10             	mov    0x10(%ebp),%eax
 504:	8d 50 ff             	lea    -0x1(%eax),%edx
 507:	89 55 10             	mov    %edx,0x10(%ebp)
 50a:	85 c0                	test   %eax,%eax
 50c:	7f dc                	jg     4ea <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 50e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 511:	c9                   	leave  
 512:	c3                   	ret    

00000513 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 513:	b8 01 00 00 00       	mov    $0x1,%eax
 518:	cd 40                	int    $0x40
 51a:	c3                   	ret    

0000051b <exit>:
SYSCALL(exit)
 51b:	b8 02 00 00 00       	mov    $0x2,%eax
 520:	cd 40                	int    $0x40
 522:	c3                   	ret    

00000523 <wait>:
SYSCALL(wait)
 523:	b8 03 00 00 00       	mov    $0x3,%eax
 528:	cd 40                	int    $0x40
 52a:	c3                   	ret    

0000052b <pipe>:
SYSCALL(pipe)
 52b:	b8 04 00 00 00       	mov    $0x4,%eax
 530:	cd 40                	int    $0x40
 532:	c3                   	ret    

00000533 <read>:
SYSCALL(read)
 533:	b8 05 00 00 00       	mov    $0x5,%eax
 538:	cd 40                	int    $0x40
 53a:	c3                   	ret    

0000053b <write>:
SYSCALL(write)
 53b:	b8 10 00 00 00       	mov    $0x10,%eax
 540:	cd 40                	int    $0x40
 542:	c3                   	ret    

00000543 <close>:
SYSCALL(close)
 543:	b8 15 00 00 00       	mov    $0x15,%eax
 548:	cd 40                	int    $0x40
 54a:	c3                   	ret    

0000054b <kill>:
SYSCALL(kill)
 54b:	b8 06 00 00 00       	mov    $0x6,%eax
 550:	cd 40                	int    $0x40
 552:	c3                   	ret    

00000553 <exec>:
SYSCALL(exec)
 553:	b8 07 00 00 00       	mov    $0x7,%eax
 558:	cd 40                	int    $0x40
 55a:	c3                   	ret    

0000055b <open>:
SYSCALL(open)
 55b:	b8 0f 00 00 00       	mov    $0xf,%eax
 560:	cd 40                	int    $0x40
 562:	c3                   	ret    

00000563 <mknod>:
SYSCALL(mknod)
 563:	b8 11 00 00 00       	mov    $0x11,%eax
 568:	cd 40                	int    $0x40
 56a:	c3                   	ret    

0000056b <unlink>:
SYSCALL(unlink)
 56b:	b8 12 00 00 00       	mov    $0x12,%eax
 570:	cd 40                	int    $0x40
 572:	c3                   	ret    

00000573 <fstat>:
SYSCALL(fstat)
 573:	b8 08 00 00 00       	mov    $0x8,%eax
 578:	cd 40                	int    $0x40
 57a:	c3                   	ret    

0000057b <link>:
SYSCALL(link)
 57b:	b8 13 00 00 00       	mov    $0x13,%eax
 580:	cd 40                	int    $0x40
 582:	c3                   	ret    

00000583 <mkdir>:
SYSCALL(mkdir)
 583:	b8 14 00 00 00       	mov    $0x14,%eax
 588:	cd 40                	int    $0x40
 58a:	c3                   	ret    

0000058b <chdir>:
SYSCALL(chdir)
 58b:	b8 09 00 00 00       	mov    $0x9,%eax
 590:	cd 40                	int    $0x40
 592:	c3                   	ret    

00000593 <dup>:
SYSCALL(dup)
 593:	b8 0a 00 00 00       	mov    $0xa,%eax
 598:	cd 40                	int    $0x40
 59a:	c3                   	ret    

0000059b <getpid>:
SYSCALL(getpid)
 59b:	b8 0b 00 00 00       	mov    $0xb,%eax
 5a0:	cd 40                	int    $0x40
 5a2:	c3                   	ret    

000005a3 <sbrk>:
SYSCALL(sbrk)
 5a3:	b8 0c 00 00 00       	mov    $0xc,%eax
 5a8:	cd 40                	int    $0x40
 5aa:	c3                   	ret    

000005ab <sleep>:
SYSCALL(sleep)
 5ab:	b8 0d 00 00 00       	mov    $0xd,%eax
 5b0:	cd 40                	int    $0x40
 5b2:	c3                   	ret    

000005b3 <uptime>:
SYSCALL(uptime)
 5b3:	b8 0e 00 00 00       	mov    $0xe,%eax
 5b8:	cd 40                	int    $0x40
 5ba:	c3                   	ret    

000005bb <halt>:
SYSCALL(halt)
 5bb:	b8 16 00 00 00       	mov    $0x16,%eax
 5c0:	cd 40                	int    $0x40
 5c2:	c3                   	ret    

000005c3 <thread_create>:
SYSCALL(thread_create)
 5c3:	b8 17 00 00 00       	mov    $0x17,%eax
 5c8:	cd 40                	int    $0x40
 5ca:	c3                   	ret    

000005cb <thread_exit>:
SYSCALL(thread_exit)
 5cb:	b8 18 00 00 00       	mov    $0x18,%eax
 5d0:	cd 40                	int    $0x40
 5d2:	c3                   	ret    

000005d3 <thread_join>:
SYSCALL(thread_join)
 5d3:	b8 19 00 00 00       	mov    $0x19,%eax
 5d8:	cd 40                	int    $0x40
 5da:	c3                   	ret    

000005db <gettid>:
SYSCALL(gettid)
 5db:	b8 1a 00 00 00       	mov    $0x1a,%eax
 5e0:	cd 40                	int    $0x40
 5e2:	c3                   	ret    

000005e3 <clone>:
SYSCALL(clone)
 5e3:	b8 1b 00 00 00       	mov    $0x1b,%eax
 5e8:	cd 40                	int    $0x40
 5ea:	c3                   	ret    

000005eb <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 5eb:	55                   	push   %ebp
 5ec:	89 e5                	mov    %esp,%ebp
 5ee:	83 ec 18             	sub    $0x18,%esp
 5f1:	8b 45 0c             	mov    0xc(%ebp),%eax
 5f4:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 5f7:	83 ec 04             	sub    $0x4,%esp
 5fa:	6a 01                	push   $0x1
 5fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
 5ff:	50                   	push   %eax
 600:	ff 75 08             	pushl  0x8(%ebp)
 603:	e8 33 ff ff ff       	call   53b <write>
 608:	83 c4 10             	add    $0x10,%esp
}
 60b:	90                   	nop
 60c:	c9                   	leave  
 60d:	c3                   	ret    

0000060e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 60e:	55                   	push   %ebp
 60f:	89 e5                	mov    %esp,%ebp
 611:	53                   	push   %ebx
 612:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 615:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 61c:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 620:	74 17                	je     639 <printint+0x2b>
 622:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 626:	79 11                	jns    639 <printint+0x2b>
    neg = 1;
 628:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 62f:	8b 45 0c             	mov    0xc(%ebp),%eax
 632:	f7 d8                	neg    %eax
 634:	89 45 ec             	mov    %eax,-0x14(%ebp)
 637:	eb 06                	jmp    63f <printint+0x31>
  } else {
    x = xx;
 639:	8b 45 0c             	mov    0xc(%ebp),%eax
 63c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 63f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 646:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 649:	8d 41 01             	lea    0x1(%ecx),%eax
 64c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 64f:	8b 5d 10             	mov    0x10(%ebp),%ebx
 652:	8b 45 ec             	mov    -0x14(%ebp),%eax
 655:	ba 00 00 00 00       	mov    $0x0,%edx
 65a:	f7 f3                	div    %ebx
 65c:	89 d0                	mov    %edx,%eax
 65e:	0f b6 80 d8 0d 00 00 	movzbl 0xdd8(%eax),%eax
 665:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 669:	8b 5d 10             	mov    0x10(%ebp),%ebx
 66c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 66f:	ba 00 00 00 00       	mov    $0x0,%edx
 674:	f7 f3                	div    %ebx
 676:	89 45 ec             	mov    %eax,-0x14(%ebp)
 679:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 67d:	75 c7                	jne    646 <printint+0x38>
  if(neg)
 67f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 683:	74 2d                	je     6b2 <printint+0xa4>
    buf[i++] = '-';
 685:	8b 45 f4             	mov    -0xc(%ebp),%eax
 688:	8d 50 01             	lea    0x1(%eax),%edx
 68b:	89 55 f4             	mov    %edx,-0xc(%ebp)
 68e:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 693:	eb 1d                	jmp    6b2 <printint+0xa4>
    putc(fd, buf[i]);
 695:	8d 55 dc             	lea    -0x24(%ebp),%edx
 698:	8b 45 f4             	mov    -0xc(%ebp),%eax
 69b:	01 d0                	add    %edx,%eax
 69d:	0f b6 00             	movzbl (%eax),%eax
 6a0:	0f be c0             	movsbl %al,%eax
 6a3:	83 ec 08             	sub    $0x8,%esp
 6a6:	50                   	push   %eax
 6a7:	ff 75 08             	pushl  0x8(%ebp)
 6aa:	e8 3c ff ff ff       	call   5eb <putc>
 6af:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 6b2:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 6b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6ba:	79 d9                	jns    695 <printint+0x87>
    putc(fd, buf[i]);
}
 6bc:	90                   	nop
 6bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 6c0:	c9                   	leave  
 6c1:	c3                   	ret    

000006c2 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 6c2:	55                   	push   %ebp
 6c3:	89 e5                	mov    %esp,%ebp
 6c5:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 6c8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 6cf:	8d 45 0c             	lea    0xc(%ebp),%eax
 6d2:	83 c0 04             	add    $0x4,%eax
 6d5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 6d8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 6df:	e9 59 01 00 00       	jmp    83d <printf+0x17b>
    c = fmt[i] & 0xff;
 6e4:	8b 55 0c             	mov    0xc(%ebp),%edx
 6e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6ea:	01 d0                	add    %edx,%eax
 6ec:	0f b6 00             	movzbl (%eax),%eax
 6ef:	0f be c0             	movsbl %al,%eax
 6f2:	25 ff 00 00 00       	and    $0xff,%eax
 6f7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 6fa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6fe:	75 2c                	jne    72c <printf+0x6a>
      if(c == '%'){
 700:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 704:	75 0c                	jne    712 <printf+0x50>
        state = '%';
 706:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 70d:	e9 27 01 00 00       	jmp    839 <printf+0x177>
      } else {
        putc(fd, c);
 712:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 715:	0f be c0             	movsbl %al,%eax
 718:	83 ec 08             	sub    $0x8,%esp
 71b:	50                   	push   %eax
 71c:	ff 75 08             	pushl  0x8(%ebp)
 71f:	e8 c7 fe ff ff       	call   5eb <putc>
 724:	83 c4 10             	add    $0x10,%esp
 727:	e9 0d 01 00 00       	jmp    839 <printf+0x177>
      }
    } else if(state == '%'){
 72c:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 730:	0f 85 03 01 00 00    	jne    839 <printf+0x177>
      if(c == 'd'){
 736:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 73a:	75 1e                	jne    75a <printf+0x98>
        printint(fd, *ap, 10, 1);
 73c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 73f:	8b 00                	mov    (%eax),%eax
 741:	6a 01                	push   $0x1
 743:	6a 0a                	push   $0xa
 745:	50                   	push   %eax
 746:	ff 75 08             	pushl  0x8(%ebp)
 749:	e8 c0 fe ff ff       	call   60e <printint>
 74e:	83 c4 10             	add    $0x10,%esp
        ap++;
 751:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 755:	e9 d8 00 00 00       	jmp    832 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 75a:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 75e:	74 06                	je     766 <printf+0xa4>
 760:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 764:	75 1e                	jne    784 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 766:	8b 45 e8             	mov    -0x18(%ebp),%eax
 769:	8b 00                	mov    (%eax),%eax
 76b:	6a 00                	push   $0x0
 76d:	6a 10                	push   $0x10
 76f:	50                   	push   %eax
 770:	ff 75 08             	pushl  0x8(%ebp)
 773:	e8 96 fe ff ff       	call   60e <printint>
 778:	83 c4 10             	add    $0x10,%esp
        ap++;
 77b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 77f:	e9 ae 00 00 00       	jmp    832 <printf+0x170>
      } else if(c == 's'){
 784:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 788:	75 43                	jne    7cd <printf+0x10b>
        s = (char*)*ap;
 78a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 78d:	8b 00                	mov    (%eax),%eax
 78f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 792:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 796:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 79a:	75 25                	jne    7c1 <printf+0xff>
          s = "(null)";
 79c:	c7 45 f4 4f 0b 00 00 	movl   $0xb4f,-0xc(%ebp)
        while(*s != 0){
 7a3:	eb 1c                	jmp    7c1 <printf+0xff>
          putc(fd, *s);
 7a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a8:	0f b6 00             	movzbl (%eax),%eax
 7ab:	0f be c0             	movsbl %al,%eax
 7ae:	83 ec 08             	sub    $0x8,%esp
 7b1:	50                   	push   %eax
 7b2:	ff 75 08             	pushl  0x8(%ebp)
 7b5:	e8 31 fe ff ff       	call   5eb <putc>
 7ba:	83 c4 10             	add    $0x10,%esp
          s++;
 7bd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 7c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c4:	0f b6 00             	movzbl (%eax),%eax
 7c7:	84 c0                	test   %al,%al
 7c9:	75 da                	jne    7a5 <printf+0xe3>
 7cb:	eb 65                	jmp    832 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 7cd:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 7d1:	75 1d                	jne    7f0 <printf+0x12e>
        putc(fd, *ap);
 7d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7d6:	8b 00                	mov    (%eax),%eax
 7d8:	0f be c0             	movsbl %al,%eax
 7db:	83 ec 08             	sub    $0x8,%esp
 7de:	50                   	push   %eax
 7df:	ff 75 08             	pushl  0x8(%ebp)
 7e2:	e8 04 fe ff ff       	call   5eb <putc>
 7e7:	83 c4 10             	add    $0x10,%esp
        ap++;
 7ea:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7ee:	eb 42                	jmp    832 <printf+0x170>
      } else if(c == '%'){
 7f0:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7f4:	75 17                	jne    80d <printf+0x14b>
        putc(fd, c);
 7f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7f9:	0f be c0             	movsbl %al,%eax
 7fc:	83 ec 08             	sub    $0x8,%esp
 7ff:	50                   	push   %eax
 800:	ff 75 08             	pushl  0x8(%ebp)
 803:	e8 e3 fd ff ff       	call   5eb <putc>
 808:	83 c4 10             	add    $0x10,%esp
 80b:	eb 25                	jmp    832 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 80d:	83 ec 08             	sub    $0x8,%esp
 810:	6a 25                	push   $0x25
 812:	ff 75 08             	pushl  0x8(%ebp)
 815:	e8 d1 fd ff ff       	call   5eb <putc>
 81a:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 81d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 820:	0f be c0             	movsbl %al,%eax
 823:	83 ec 08             	sub    $0x8,%esp
 826:	50                   	push   %eax
 827:	ff 75 08             	pushl  0x8(%ebp)
 82a:	e8 bc fd ff ff       	call   5eb <putc>
 82f:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 832:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 839:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 83d:	8b 55 0c             	mov    0xc(%ebp),%edx
 840:	8b 45 f0             	mov    -0x10(%ebp),%eax
 843:	01 d0                	add    %edx,%eax
 845:	0f b6 00             	movzbl (%eax),%eax
 848:	84 c0                	test   %al,%al
 84a:	0f 85 94 fe ff ff    	jne    6e4 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 850:	90                   	nop
 851:	c9                   	leave  
 852:	c3                   	ret    

00000853 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 853:	55                   	push   %ebp
 854:	89 e5                	mov    %esp,%ebp
 856:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 859:	8b 45 08             	mov    0x8(%ebp),%eax
 85c:	83 e8 08             	sub    $0x8,%eax
 85f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 862:	a1 f4 0d 00 00       	mov    0xdf4,%eax
 867:	89 45 fc             	mov    %eax,-0x4(%ebp)
 86a:	eb 24                	jmp    890 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 86c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 86f:	8b 00                	mov    (%eax),%eax
 871:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 874:	77 12                	ja     888 <free+0x35>
 876:	8b 45 f8             	mov    -0x8(%ebp),%eax
 879:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 87c:	77 24                	ja     8a2 <free+0x4f>
 87e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 881:	8b 00                	mov    (%eax),%eax
 883:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 886:	77 1a                	ja     8a2 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 888:	8b 45 fc             	mov    -0x4(%ebp),%eax
 88b:	8b 00                	mov    (%eax),%eax
 88d:	89 45 fc             	mov    %eax,-0x4(%ebp)
 890:	8b 45 f8             	mov    -0x8(%ebp),%eax
 893:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 896:	76 d4                	jbe    86c <free+0x19>
 898:	8b 45 fc             	mov    -0x4(%ebp),%eax
 89b:	8b 00                	mov    (%eax),%eax
 89d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8a0:	76 ca                	jbe    86c <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 8a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8a5:	8b 40 04             	mov    0x4(%eax),%eax
 8a8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8af:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8b2:	01 c2                	add    %eax,%edx
 8b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8b7:	8b 00                	mov    (%eax),%eax
 8b9:	39 c2                	cmp    %eax,%edx
 8bb:	75 24                	jne    8e1 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 8bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8c0:	8b 50 04             	mov    0x4(%eax),%edx
 8c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c6:	8b 00                	mov    (%eax),%eax
 8c8:	8b 40 04             	mov    0x4(%eax),%eax
 8cb:	01 c2                	add    %eax,%edx
 8cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8d0:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 8d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d6:	8b 00                	mov    (%eax),%eax
 8d8:	8b 10                	mov    (%eax),%edx
 8da:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8dd:	89 10                	mov    %edx,(%eax)
 8df:	eb 0a                	jmp    8eb <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 8e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8e4:	8b 10                	mov    (%eax),%edx
 8e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8e9:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 8eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ee:	8b 40 04             	mov    0x4(%eax),%eax
 8f1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8fb:	01 d0                	add    %edx,%eax
 8fd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 900:	75 20                	jne    922 <free+0xcf>
    p->s.size += bp->s.size;
 902:	8b 45 fc             	mov    -0x4(%ebp),%eax
 905:	8b 50 04             	mov    0x4(%eax),%edx
 908:	8b 45 f8             	mov    -0x8(%ebp),%eax
 90b:	8b 40 04             	mov    0x4(%eax),%eax
 90e:	01 c2                	add    %eax,%edx
 910:	8b 45 fc             	mov    -0x4(%ebp),%eax
 913:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 916:	8b 45 f8             	mov    -0x8(%ebp),%eax
 919:	8b 10                	mov    (%eax),%edx
 91b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 91e:	89 10                	mov    %edx,(%eax)
 920:	eb 08                	jmp    92a <free+0xd7>
  } else
    p->s.ptr = bp;
 922:	8b 45 fc             	mov    -0x4(%ebp),%eax
 925:	8b 55 f8             	mov    -0x8(%ebp),%edx
 928:	89 10                	mov    %edx,(%eax)
  freep = p;
 92a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 92d:	a3 f4 0d 00 00       	mov    %eax,0xdf4
}
 932:	90                   	nop
 933:	c9                   	leave  
 934:	c3                   	ret    

00000935 <morecore>:

static Header*
morecore(uint nu)
{
 935:	55                   	push   %ebp
 936:	89 e5                	mov    %esp,%ebp
 938:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 93b:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 942:	77 07                	ja     94b <morecore+0x16>
    nu = 4096;
 944:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 94b:	8b 45 08             	mov    0x8(%ebp),%eax
 94e:	c1 e0 03             	shl    $0x3,%eax
 951:	83 ec 0c             	sub    $0xc,%esp
 954:	50                   	push   %eax
 955:	e8 49 fc ff ff       	call   5a3 <sbrk>
 95a:	83 c4 10             	add    $0x10,%esp
 95d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 960:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 964:	75 07                	jne    96d <morecore+0x38>
    return 0;
 966:	b8 00 00 00 00       	mov    $0x0,%eax
 96b:	eb 26                	jmp    993 <morecore+0x5e>
  hp = (Header*)p;
 96d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 970:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 973:	8b 45 f0             	mov    -0x10(%ebp),%eax
 976:	8b 55 08             	mov    0x8(%ebp),%edx
 979:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 97c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 97f:	83 c0 08             	add    $0x8,%eax
 982:	83 ec 0c             	sub    $0xc,%esp
 985:	50                   	push   %eax
 986:	e8 c8 fe ff ff       	call   853 <free>
 98b:	83 c4 10             	add    $0x10,%esp
  return freep;
 98e:	a1 f4 0d 00 00       	mov    0xdf4,%eax
}
 993:	c9                   	leave  
 994:	c3                   	ret    

00000995 <malloc>:

void*
malloc(uint nbytes)
{
 995:	55                   	push   %ebp
 996:	89 e5                	mov    %esp,%ebp
 998:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 99b:	8b 45 08             	mov    0x8(%ebp),%eax
 99e:	83 c0 07             	add    $0x7,%eax
 9a1:	c1 e8 03             	shr    $0x3,%eax
 9a4:	83 c0 01             	add    $0x1,%eax
 9a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 9aa:	a1 f4 0d 00 00       	mov    0xdf4,%eax
 9af:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9b2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 9b6:	75 23                	jne    9db <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 9b8:	c7 45 f0 ec 0d 00 00 	movl   $0xdec,-0x10(%ebp)
 9bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9c2:	a3 f4 0d 00 00       	mov    %eax,0xdf4
 9c7:	a1 f4 0d 00 00       	mov    0xdf4,%eax
 9cc:	a3 ec 0d 00 00       	mov    %eax,0xdec
    base.s.size = 0;
 9d1:	c7 05 f0 0d 00 00 00 	movl   $0x0,0xdf0
 9d8:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9db:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9de:	8b 00                	mov    (%eax),%eax
 9e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 9e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9e6:	8b 40 04             	mov    0x4(%eax),%eax
 9e9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9ec:	72 4d                	jb     a3b <malloc+0xa6>
      if(p->s.size == nunits)
 9ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9f1:	8b 40 04             	mov    0x4(%eax),%eax
 9f4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9f7:	75 0c                	jne    a05 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 9f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9fc:	8b 10                	mov    (%eax),%edx
 9fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a01:	89 10                	mov    %edx,(%eax)
 a03:	eb 26                	jmp    a2b <malloc+0x96>
      else {
        p->s.size -= nunits;
 a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a08:	8b 40 04             	mov    0x4(%eax),%eax
 a0b:	2b 45 ec             	sub    -0x14(%ebp),%eax
 a0e:	89 c2                	mov    %eax,%edx
 a10:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a13:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a19:	8b 40 04             	mov    0x4(%eax),%eax
 a1c:	c1 e0 03             	shl    $0x3,%eax
 a1f:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a25:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a28:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a2e:	a3 f4 0d 00 00       	mov    %eax,0xdf4
      return (void*)(p + 1);
 a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a36:	83 c0 08             	add    $0x8,%eax
 a39:	eb 3b                	jmp    a76 <malloc+0xe1>
    }
    if(p == freep)
 a3b:	a1 f4 0d 00 00       	mov    0xdf4,%eax
 a40:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a43:	75 1e                	jne    a63 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 a45:	83 ec 0c             	sub    $0xc,%esp
 a48:	ff 75 ec             	pushl  -0x14(%ebp)
 a4b:	e8 e5 fe ff ff       	call   935 <morecore>
 a50:	83 c4 10             	add    $0x10,%esp
 a53:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a56:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a5a:	75 07                	jne    a63 <malloc+0xce>
        return 0;
 a5c:	b8 00 00 00 00       	mov    $0x0,%eax
 a61:	eb 13                	jmp    a76 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a63:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a66:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a69:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a6c:	8b 00                	mov    (%eax),%eax
 a6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 a71:	e9 6d ff ff ff       	jmp    9e3 <malloc+0x4e>
}
 a76:	c9                   	leave  
 a77:	c3                   	ret    
