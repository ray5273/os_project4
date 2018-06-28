
_test5:     file format elf32-i386


Disassembly of section .text:

00000000 <thread>:

void *stack[NTHREAD];
int tid[NTHREAD];
void *retval[NTHREAD];

void *thread(void *arg){
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 08             	sub    $0x8,%esp
	thread_exit((void *)getpid());
   6:	e8 66 04 00 00       	call   471 <getpid>
   b:	83 ec 0c             	sub    $0xc,%esp
   e:	50                   	push   %eax
   f:	e8 8d 04 00 00       	call   4a1 <thread_exit>

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
	int pid = getpid();
  25:	e8 47 04 00 00       	call   471 <getpid>
  2a:	89 45 f0             	mov    %eax,-0x10(%ebp)

	printf(1, "TEST5: ");
  2d:	83 ec 08             	sub    $0x8,%esp
  30:	68 4e 09 00 00       	push   $0x94e
  35:	6a 01                	push   $0x1
  37:	e8 5c 05 00 00       	call   598 <printf>
  3c:	83 c4 10             	add    $0x10,%esp

	for(i=0;i<NTHREAD;i++)
  3f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  46:	eb 20                	jmp    68 <main+0x54>
		stack[i] = malloc(4096);
  48:	83 ec 0c             	sub    $0xc,%esp
  4b:	68 00 10 00 00       	push   $0x1000
  50:	e8 16 08 00 00       	call   86b <malloc>
  55:	83 c4 10             	add    $0x10,%esp
  58:	89 c2                	mov    %eax,%edx
  5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  5d:	89 14 85 10 0c 00 00 	mov    %edx,0xc10(,%eax,4)
	int i;
	int pid = getpid();

	printf(1, "TEST5: ");

	for(i=0;i<NTHREAD;i++)
  64:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  68:	83 7d f4 06          	cmpl   $0x6,-0xc(%ebp)
  6c:	7e da                	jle    48 <main+0x34>
		stack[i] = malloc(4096);

	for(i=0;i<NTHREAD; i++){
  6e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  75:	eb 52                	jmp    c9 <main+0xb5>
		tid[i] = thread_create(thread, 30, 0, stack[i]);
  77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  7a:	8b 04 85 10 0c 00 00 	mov    0xc10(,%eax,4),%eax
  81:	50                   	push   %eax
  82:	6a 00                	push   $0x0
  84:	6a 1e                	push   $0x1e
  86:	68 00 00 00 00       	push   $0x0
  8b:	e8 09 04 00 00       	call   499 <thread_create>
  90:	83 c4 10             	add    $0x10,%esp
  93:	89 c2                	mov    %eax,%edx
  95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  98:	89 14 85 2c 0c 00 00 	mov    %edx,0xc2c(,%eax,4)
		if(tid[i] == -1){
  9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  a2:	8b 04 85 2c 0c 00 00 	mov    0xc2c(,%eax,4),%eax
  a9:	83 f8 ff             	cmp    $0xffffffff,%eax
  ac:	75 17                	jne    c5 <main+0xb1>
			printf(1, "CREATE WRONG\n");
  ae:	83 ec 08             	sub    $0x8,%esp
  b1:	68 56 09 00 00       	push   $0x956
  b6:	6a 01                	push   $0x1
  b8:	e8 db 04 00 00       	call   598 <printf>
  bd:	83 c4 10             	add    $0x10,%esp
			exit();
  c0:	e8 2c 03 00 00       	call   3f1 <exit>
	printf(1, "TEST5: ");

	for(i=0;i<NTHREAD;i++)
		stack[i] = malloc(4096);

	for(i=0;i<NTHREAD; i++){
  c5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  c9:	83 7d f4 06          	cmpl   $0x6,-0xc(%ebp)
  cd:	7e a8                	jle    77 <main+0x63>
			printf(1, "CREATE WRONG\n");
			exit();
		}
	}

	for(i=0;i<NTHREAD;i++){
  cf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  d6:	eb 43                	jmp    11b <main+0x107>
		if(thread_join(tid[i], &retval[i]) == -1){
  d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  db:	c1 e0 02             	shl    $0x2,%eax
  de:	8d 90 48 0c 00 00    	lea    0xc48(%eax),%edx
  e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  e7:	8b 04 85 2c 0c 00 00 	mov    0xc2c(,%eax,4),%eax
  ee:	83 ec 08             	sub    $0x8,%esp
  f1:	52                   	push   %edx
  f2:	50                   	push   %eax
  f3:	e8 b1 03 00 00       	call   4a9 <thread_join>
  f8:	83 c4 10             	add    $0x10,%esp
  fb:	83 f8 ff             	cmp    $0xffffffff,%eax
  fe:	75 17                	jne    117 <main+0x103>
			printf(1, "JOIN WRONG\n");
 100:	83 ec 08             	sub    $0x8,%esp
 103:	68 64 09 00 00       	push   $0x964
 108:	6a 01                	push   $0x1
 10a:	e8 89 04 00 00       	call   598 <printf>
 10f:	83 c4 10             	add    $0x10,%esp
			exit();
 112:	e8 da 02 00 00       	call   3f1 <exit>
			printf(1, "CREATE WRONG\n");
			exit();
		}
	}

	for(i=0;i<NTHREAD;i++){
 117:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 11b:	83 7d f4 06          	cmpl   $0x6,-0xc(%ebp)
 11f:	7e b7                	jle    d8 <main+0xc4>
			printf(1, "JOIN WRONG\n");
			exit();
		}
	}

	for(i=0;i<NTHREAD;i++){
 121:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 128:	eb 2a                	jmp    154 <main+0x140>
//        printf(1,"cur pid:%d, get val:%d ",pid,(int)retval[i]); 
		if(pid != (int)retval[i]){
 12a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 12d:	8b 04 85 48 0c 00 00 	mov    0xc48(,%eax,4),%eax
 134:	3b 45 f0             	cmp    -0x10(%ebp),%eax
 137:	74 17                	je     150 <main+0x13c>
			printf(1, "RETVAL WRONG\n");
 139:	83 ec 08             	sub    $0x8,%esp
 13c:	68 70 09 00 00       	push   $0x970
 141:	6a 01                	push   $0x1
 143:	e8 50 04 00 00       	call   598 <printf>
 148:	83 c4 10             	add    $0x10,%esp
			exit();
 14b:	e8 a1 02 00 00       	call   3f1 <exit>
			printf(1, "JOIN WRONG\n");
			exit();
		}
	}

	for(i=0;i<NTHREAD;i++){
 150:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 154:	83 7d f4 06          	cmpl   $0x6,-0xc(%ebp)
 158:	7e d0                	jle    12a <main+0x116>
			printf(1, "RETVAL WRONG\n");
			exit();
		}
	}

	for(i=0;i<NTHREAD;i++)
 15a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 161:	eb 1a                	jmp    17d <main+0x169>
		free(stack[i]);
 163:	8b 45 f4             	mov    -0xc(%ebp),%eax
 166:	8b 04 85 10 0c 00 00 	mov    0xc10(,%eax,4),%eax
 16d:	83 ec 0c             	sub    $0xc,%esp
 170:	50                   	push   %eax
 171:	e8 b3 05 00 00       	call   729 <free>
 176:	83 c4 10             	add    $0x10,%esp
			printf(1, "RETVAL WRONG\n");
			exit();
		}
	}

	for(i=0;i<NTHREAD;i++)
 179:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 17d:	83 7d f4 06          	cmpl   $0x6,-0xc(%ebp)
 181:	7e e0                	jle    163 <main+0x14f>
		free(stack[i]);

	printf(1, "OK\n");
 183:	83 ec 08             	sub    $0x8,%esp
 186:	68 7e 09 00 00       	push   $0x97e
 18b:	6a 01                	push   $0x1
 18d:	e8 06 04 00 00       	call   598 <printf>
 192:	83 c4 10             	add    $0x10,%esp

	exit();
 195:	e8 57 02 00 00       	call   3f1 <exit>

0000019a <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 19a:	55                   	push   %ebp
 19b:	89 e5                	mov    %esp,%ebp
 19d:	57                   	push   %edi
 19e:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 19f:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1a2:	8b 55 10             	mov    0x10(%ebp),%edx
 1a5:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a8:	89 cb                	mov    %ecx,%ebx
 1aa:	89 df                	mov    %ebx,%edi
 1ac:	89 d1                	mov    %edx,%ecx
 1ae:	fc                   	cld    
 1af:	f3 aa                	rep stos %al,%es:(%edi)
 1b1:	89 ca                	mov    %ecx,%edx
 1b3:	89 fb                	mov    %edi,%ebx
 1b5:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1b8:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1bb:	90                   	nop
 1bc:	5b                   	pop    %ebx
 1bd:	5f                   	pop    %edi
 1be:	5d                   	pop    %ebp
 1bf:	c3                   	ret    

000001c0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1c6:	8b 45 08             	mov    0x8(%ebp),%eax
 1c9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1cc:	90                   	nop
 1cd:	8b 45 08             	mov    0x8(%ebp),%eax
 1d0:	8d 50 01             	lea    0x1(%eax),%edx
 1d3:	89 55 08             	mov    %edx,0x8(%ebp)
 1d6:	8b 55 0c             	mov    0xc(%ebp),%edx
 1d9:	8d 4a 01             	lea    0x1(%edx),%ecx
 1dc:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 1df:	0f b6 12             	movzbl (%edx),%edx
 1e2:	88 10                	mov    %dl,(%eax)
 1e4:	0f b6 00             	movzbl (%eax),%eax
 1e7:	84 c0                	test   %al,%al
 1e9:	75 e2                	jne    1cd <strcpy+0xd>
    ;
  return os;
 1eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1ee:	c9                   	leave  
 1ef:	c3                   	ret    

000001f0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 1f3:	eb 08                	jmp    1fd <strcmp+0xd>
    p++, q++;
 1f5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1f9:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1fd:	8b 45 08             	mov    0x8(%ebp),%eax
 200:	0f b6 00             	movzbl (%eax),%eax
 203:	84 c0                	test   %al,%al
 205:	74 10                	je     217 <strcmp+0x27>
 207:	8b 45 08             	mov    0x8(%ebp),%eax
 20a:	0f b6 10             	movzbl (%eax),%edx
 20d:	8b 45 0c             	mov    0xc(%ebp),%eax
 210:	0f b6 00             	movzbl (%eax),%eax
 213:	38 c2                	cmp    %al,%dl
 215:	74 de                	je     1f5 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 217:	8b 45 08             	mov    0x8(%ebp),%eax
 21a:	0f b6 00             	movzbl (%eax),%eax
 21d:	0f b6 d0             	movzbl %al,%edx
 220:	8b 45 0c             	mov    0xc(%ebp),%eax
 223:	0f b6 00             	movzbl (%eax),%eax
 226:	0f b6 c0             	movzbl %al,%eax
 229:	29 c2                	sub    %eax,%edx
 22b:	89 d0                	mov    %edx,%eax
}
 22d:	5d                   	pop    %ebp
 22e:	c3                   	ret    

0000022f <strlen>:

uint
strlen(char *s)
{
 22f:	55                   	push   %ebp
 230:	89 e5                	mov    %esp,%ebp
 232:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 235:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 23c:	eb 04                	jmp    242 <strlen+0x13>
 23e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 242:	8b 55 fc             	mov    -0x4(%ebp),%edx
 245:	8b 45 08             	mov    0x8(%ebp),%eax
 248:	01 d0                	add    %edx,%eax
 24a:	0f b6 00             	movzbl (%eax),%eax
 24d:	84 c0                	test   %al,%al
 24f:	75 ed                	jne    23e <strlen+0xf>
    ;
  return n;
 251:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 254:	c9                   	leave  
 255:	c3                   	ret    

00000256 <memset>:

void*
memset(void *dst, int c, uint n)
{
 256:	55                   	push   %ebp
 257:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 259:	8b 45 10             	mov    0x10(%ebp),%eax
 25c:	50                   	push   %eax
 25d:	ff 75 0c             	pushl  0xc(%ebp)
 260:	ff 75 08             	pushl  0x8(%ebp)
 263:	e8 32 ff ff ff       	call   19a <stosb>
 268:	83 c4 0c             	add    $0xc,%esp
  return dst;
 26b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 26e:	c9                   	leave  
 26f:	c3                   	ret    

00000270 <strchr>:

char*
strchr(const char *s, char c)
{
 270:	55                   	push   %ebp
 271:	89 e5                	mov    %esp,%ebp
 273:	83 ec 04             	sub    $0x4,%esp
 276:	8b 45 0c             	mov    0xc(%ebp),%eax
 279:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 27c:	eb 14                	jmp    292 <strchr+0x22>
    if(*s == c)
 27e:	8b 45 08             	mov    0x8(%ebp),%eax
 281:	0f b6 00             	movzbl (%eax),%eax
 284:	3a 45 fc             	cmp    -0x4(%ebp),%al
 287:	75 05                	jne    28e <strchr+0x1e>
      return (char*)s;
 289:	8b 45 08             	mov    0x8(%ebp),%eax
 28c:	eb 13                	jmp    2a1 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 28e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 292:	8b 45 08             	mov    0x8(%ebp),%eax
 295:	0f b6 00             	movzbl (%eax),%eax
 298:	84 c0                	test   %al,%al
 29a:	75 e2                	jne    27e <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 29c:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2a1:	c9                   	leave  
 2a2:	c3                   	ret    

000002a3 <gets>:

char*
gets(char *buf, int max)
{
 2a3:	55                   	push   %ebp
 2a4:	89 e5                	mov    %esp,%ebp
 2a6:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2a9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2b0:	eb 42                	jmp    2f4 <gets+0x51>
    cc = read(0, &c, 1);
 2b2:	83 ec 04             	sub    $0x4,%esp
 2b5:	6a 01                	push   $0x1
 2b7:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2ba:	50                   	push   %eax
 2bb:	6a 00                	push   $0x0
 2bd:	e8 47 01 00 00       	call   409 <read>
 2c2:	83 c4 10             	add    $0x10,%esp
 2c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 2c8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 2cc:	7e 33                	jle    301 <gets+0x5e>
      break;
    buf[i++] = c;
 2ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2d1:	8d 50 01             	lea    0x1(%eax),%edx
 2d4:	89 55 f4             	mov    %edx,-0xc(%ebp)
 2d7:	89 c2                	mov    %eax,%edx
 2d9:	8b 45 08             	mov    0x8(%ebp),%eax
 2dc:	01 c2                	add    %eax,%edx
 2de:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2e2:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 2e4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2e8:	3c 0a                	cmp    $0xa,%al
 2ea:	74 16                	je     302 <gets+0x5f>
 2ec:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2f0:	3c 0d                	cmp    $0xd,%al
 2f2:	74 0e                	je     302 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2f7:	83 c0 01             	add    $0x1,%eax
 2fa:	3b 45 0c             	cmp    0xc(%ebp),%eax
 2fd:	7c b3                	jl     2b2 <gets+0xf>
 2ff:	eb 01                	jmp    302 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 301:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 302:	8b 55 f4             	mov    -0xc(%ebp),%edx
 305:	8b 45 08             	mov    0x8(%ebp),%eax
 308:	01 d0                	add    %edx,%eax
 30a:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 30d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 310:	c9                   	leave  
 311:	c3                   	ret    

00000312 <stat>:

int
stat(char *n, struct stat *st)
{
 312:	55                   	push   %ebp
 313:	89 e5                	mov    %esp,%ebp
 315:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 318:	83 ec 08             	sub    $0x8,%esp
 31b:	6a 00                	push   $0x0
 31d:	ff 75 08             	pushl  0x8(%ebp)
 320:	e8 0c 01 00 00       	call   431 <open>
 325:	83 c4 10             	add    $0x10,%esp
 328:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 32b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 32f:	79 07                	jns    338 <stat+0x26>
    return -1;
 331:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 336:	eb 25                	jmp    35d <stat+0x4b>
  r = fstat(fd, st);
 338:	83 ec 08             	sub    $0x8,%esp
 33b:	ff 75 0c             	pushl  0xc(%ebp)
 33e:	ff 75 f4             	pushl  -0xc(%ebp)
 341:	e8 03 01 00 00       	call   449 <fstat>
 346:	83 c4 10             	add    $0x10,%esp
 349:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 34c:	83 ec 0c             	sub    $0xc,%esp
 34f:	ff 75 f4             	pushl  -0xc(%ebp)
 352:	e8 c2 00 00 00       	call   419 <close>
 357:	83 c4 10             	add    $0x10,%esp
  return r;
 35a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 35d:	c9                   	leave  
 35e:	c3                   	ret    

0000035f <atoi>:

int
atoi(const char *s)
{
 35f:	55                   	push   %ebp
 360:	89 e5                	mov    %esp,%ebp
 362:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 365:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 36c:	eb 25                	jmp    393 <atoi+0x34>
    n = n*10 + *s++ - '0';
 36e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 371:	89 d0                	mov    %edx,%eax
 373:	c1 e0 02             	shl    $0x2,%eax
 376:	01 d0                	add    %edx,%eax
 378:	01 c0                	add    %eax,%eax
 37a:	89 c1                	mov    %eax,%ecx
 37c:	8b 45 08             	mov    0x8(%ebp),%eax
 37f:	8d 50 01             	lea    0x1(%eax),%edx
 382:	89 55 08             	mov    %edx,0x8(%ebp)
 385:	0f b6 00             	movzbl (%eax),%eax
 388:	0f be c0             	movsbl %al,%eax
 38b:	01 c8                	add    %ecx,%eax
 38d:	83 e8 30             	sub    $0x30,%eax
 390:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 393:	8b 45 08             	mov    0x8(%ebp),%eax
 396:	0f b6 00             	movzbl (%eax),%eax
 399:	3c 2f                	cmp    $0x2f,%al
 39b:	7e 0a                	jle    3a7 <atoi+0x48>
 39d:	8b 45 08             	mov    0x8(%ebp),%eax
 3a0:	0f b6 00             	movzbl (%eax),%eax
 3a3:	3c 39                	cmp    $0x39,%al
 3a5:	7e c7                	jle    36e <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 3a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3aa:	c9                   	leave  
 3ab:	c3                   	ret    

000003ac <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 3ac:	55                   	push   %ebp
 3ad:	89 e5                	mov    %esp,%ebp
 3af:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 3b2:	8b 45 08             	mov    0x8(%ebp),%eax
 3b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 3b8:	8b 45 0c             	mov    0xc(%ebp),%eax
 3bb:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3be:	eb 17                	jmp    3d7 <memmove+0x2b>
    *dst++ = *src++;
 3c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3c3:	8d 50 01             	lea    0x1(%eax),%edx
 3c6:	89 55 fc             	mov    %edx,-0x4(%ebp)
 3c9:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3cc:	8d 4a 01             	lea    0x1(%edx),%ecx
 3cf:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 3d2:	0f b6 12             	movzbl (%edx),%edx
 3d5:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3d7:	8b 45 10             	mov    0x10(%ebp),%eax
 3da:	8d 50 ff             	lea    -0x1(%eax),%edx
 3dd:	89 55 10             	mov    %edx,0x10(%ebp)
 3e0:	85 c0                	test   %eax,%eax
 3e2:	7f dc                	jg     3c0 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 3e4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3e7:	c9                   	leave  
 3e8:	c3                   	ret    

000003e9 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3e9:	b8 01 00 00 00       	mov    $0x1,%eax
 3ee:	cd 40                	int    $0x40
 3f0:	c3                   	ret    

000003f1 <exit>:
SYSCALL(exit)
 3f1:	b8 02 00 00 00       	mov    $0x2,%eax
 3f6:	cd 40                	int    $0x40
 3f8:	c3                   	ret    

000003f9 <wait>:
SYSCALL(wait)
 3f9:	b8 03 00 00 00       	mov    $0x3,%eax
 3fe:	cd 40                	int    $0x40
 400:	c3                   	ret    

00000401 <pipe>:
SYSCALL(pipe)
 401:	b8 04 00 00 00       	mov    $0x4,%eax
 406:	cd 40                	int    $0x40
 408:	c3                   	ret    

00000409 <read>:
SYSCALL(read)
 409:	b8 05 00 00 00       	mov    $0x5,%eax
 40e:	cd 40                	int    $0x40
 410:	c3                   	ret    

00000411 <write>:
SYSCALL(write)
 411:	b8 10 00 00 00       	mov    $0x10,%eax
 416:	cd 40                	int    $0x40
 418:	c3                   	ret    

00000419 <close>:
SYSCALL(close)
 419:	b8 15 00 00 00       	mov    $0x15,%eax
 41e:	cd 40                	int    $0x40
 420:	c3                   	ret    

00000421 <kill>:
SYSCALL(kill)
 421:	b8 06 00 00 00       	mov    $0x6,%eax
 426:	cd 40                	int    $0x40
 428:	c3                   	ret    

00000429 <exec>:
SYSCALL(exec)
 429:	b8 07 00 00 00       	mov    $0x7,%eax
 42e:	cd 40                	int    $0x40
 430:	c3                   	ret    

00000431 <open>:
SYSCALL(open)
 431:	b8 0f 00 00 00       	mov    $0xf,%eax
 436:	cd 40                	int    $0x40
 438:	c3                   	ret    

00000439 <mknod>:
SYSCALL(mknod)
 439:	b8 11 00 00 00       	mov    $0x11,%eax
 43e:	cd 40                	int    $0x40
 440:	c3                   	ret    

00000441 <unlink>:
SYSCALL(unlink)
 441:	b8 12 00 00 00       	mov    $0x12,%eax
 446:	cd 40                	int    $0x40
 448:	c3                   	ret    

00000449 <fstat>:
SYSCALL(fstat)
 449:	b8 08 00 00 00       	mov    $0x8,%eax
 44e:	cd 40                	int    $0x40
 450:	c3                   	ret    

00000451 <link>:
SYSCALL(link)
 451:	b8 13 00 00 00       	mov    $0x13,%eax
 456:	cd 40                	int    $0x40
 458:	c3                   	ret    

00000459 <mkdir>:
SYSCALL(mkdir)
 459:	b8 14 00 00 00       	mov    $0x14,%eax
 45e:	cd 40                	int    $0x40
 460:	c3                   	ret    

00000461 <chdir>:
SYSCALL(chdir)
 461:	b8 09 00 00 00       	mov    $0x9,%eax
 466:	cd 40                	int    $0x40
 468:	c3                   	ret    

00000469 <dup>:
SYSCALL(dup)
 469:	b8 0a 00 00 00       	mov    $0xa,%eax
 46e:	cd 40                	int    $0x40
 470:	c3                   	ret    

00000471 <getpid>:
SYSCALL(getpid)
 471:	b8 0b 00 00 00       	mov    $0xb,%eax
 476:	cd 40                	int    $0x40
 478:	c3                   	ret    

00000479 <sbrk>:
SYSCALL(sbrk)
 479:	b8 0c 00 00 00       	mov    $0xc,%eax
 47e:	cd 40                	int    $0x40
 480:	c3                   	ret    

00000481 <sleep>:
SYSCALL(sleep)
 481:	b8 0d 00 00 00       	mov    $0xd,%eax
 486:	cd 40                	int    $0x40
 488:	c3                   	ret    

00000489 <uptime>:
SYSCALL(uptime)
 489:	b8 0e 00 00 00       	mov    $0xe,%eax
 48e:	cd 40                	int    $0x40
 490:	c3                   	ret    

00000491 <halt>:
SYSCALL(halt)
 491:	b8 16 00 00 00       	mov    $0x16,%eax
 496:	cd 40                	int    $0x40
 498:	c3                   	ret    

00000499 <thread_create>:
SYSCALL(thread_create)
 499:	b8 17 00 00 00       	mov    $0x17,%eax
 49e:	cd 40                	int    $0x40
 4a0:	c3                   	ret    

000004a1 <thread_exit>:
SYSCALL(thread_exit)
 4a1:	b8 18 00 00 00       	mov    $0x18,%eax
 4a6:	cd 40                	int    $0x40
 4a8:	c3                   	ret    

000004a9 <thread_join>:
SYSCALL(thread_join)
 4a9:	b8 19 00 00 00       	mov    $0x19,%eax
 4ae:	cd 40                	int    $0x40
 4b0:	c3                   	ret    

000004b1 <gettid>:
SYSCALL(gettid)
 4b1:	b8 1a 00 00 00       	mov    $0x1a,%eax
 4b6:	cd 40                	int    $0x40
 4b8:	c3                   	ret    

000004b9 <clone>:
SYSCALL(clone)
 4b9:	b8 1b 00 00 00       	mov    $0x1b,%eax
 4be:	cd 40                	int    $0x40
 4c0:	c3                   	ret    

000004c1 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4c1:	55                   	push   %ebp
 4c2:	89 e5                	mov    %esp,%ebp
 4c4:	83 ec 18             	sub    $0x18,%esp
 4c7:	8b 45 0c             	mov    0xc(%ebp),%eax
 4ca:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4cd:	83 ec 04             	sub    $0x4,%esp
 4d0:	6a 01                	push   $0x1
 4d2:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4d5:	50                   	push   %eax
 4d6:	ff 75 08             	pushl  0x8(%ebp)
 4d9:	e8 33 ff ff ff       	call   411 <write>
 4de:	83 c4 10             	add    $0x10,%esp
}
 4e1:	90                   	nop
 4e2:	c9                   	leave  
 4e3:	c3                   	ret    

000004e4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4e4:	55                   	push   %ebp
 4e5:	89 e5                	mov    %esp,%ebp
 4e7:	53                   	push   %ebx
 4e8:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4eb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4f2:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4f6:	74 17                	je     50f <printint+0x2b>
 4f8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4fc:	79 11                	jns    50f <printint+0x2b>
    neg = 1;
 4fe:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 505:	8b 45 0c             	mov    0xc(%ebp),%eax
 508:	f7 d8                	neg    %eax
 50a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 50d:	eb 06                	jmp    515 <printint+0x31>
  } else {
    x = xx;
 50f:	8b 45 0c             	mov    0xc(%ebp),%eax
 512:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 515:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 51c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 51f:	8d 41 01             	lea    0x1(%ecx),%eax
 522:	89 45 f4             	mov    %eax,-0xc(%ebp)
 525:	8b 5d 10             	mov    0x10(%ebp),%ebx
 528:	8b 45 ec             	mov    -0x14(%ebp),%eax
 52b:	ba 00 00 00 00       	mov    $0x0,%edx
 530:	f7 f3                	div    %ebx
 532:	89 d0                	mov    %edx,%eax
 534:	0f b6 80 f0 0b 00 00 	movzbl 0xbf0(%eax),%eax
 53b:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 53f:	8b 5d 10             	mov    0x10(%ebp),%ebx
 542:	8b 45 ec             	mov    -0x14(%ebp),%eax
 545:	ba 00 00 00 00       	mov    $0x0,%edx
 54a:	f7 f3                	div    %ebx
 54c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 54f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 553:	75 c7                	jne    51c <printint+0x38>
  if(neg)
 555:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 559:	74 2d                	je     588 <printint+0xa4>
    buf[i++] = '-';
 55b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 55e:	8d 50 01             	lea    0x1(%eax),%edx
 561:	89 55 f4             	mov    %edx,-0xc(%ebp)
 564:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 569:	eb 1d                	jmp    588 <printint+0xa4>
    putc(fd, buf[i]);
 56b:	8d 55 dc             	lea    -0x24(%ebp),%edx
 56e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 571:	01 d0                	add    %edx,%eax
 573:	0f b6 00             	movzbl (%eax),%eax
 576:	0f be c0             	movsbl %al,%eax
 579:	83 ec 08             	sub    $0x8,%esp
 57c:	50                   	push   %eax
 57d:	ff 75 08             	pushl  0x8(%ebp)
 580:	e8 3c ff ff ff       	call   4c1 <putc>
 585:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 588:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 58c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 590:	79 d9                	jns    56b <printint+0x87>
    putc(fd, buf[i]);
}
 592:	90                   	nop
 593:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 596:	c9                   	leave  
 597:	c3                   	ret    

00000598 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 598:	55                   	push   %ebp
 599:	89 e5                	mov    %esp,%ebp
 59b:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 59e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5a5:	8d 45 0c             	lea    0xc(%ebp),%eax
 5a8:	83 c0 04             	add    $0x4,%eax
 5ab:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5ae:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5b5:	e9 59 01 00 00       	jmp    713 <printf+0x17b>
    c = fmt[i] & 0xff;
 5ba:	8b 55 0c             	mov    0xc(%ebp),%edx
 5bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5c0:	01 d0                	add    %edx,%eax
 5c2:	0f b6 00             	movzbl (%eax),%eax
 5c5:	0f be c0             	movsbl %al,%eax
 5c8:	25 ff 00 00 00       	and    $0xff,%eax
 5cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5d0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5d4:	75 2c                	jne    602 <printf+0x6a>
      if(c == '%'){
 5d6:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5da:	75 0c                	jne    5e8 <printf+0x50>
        state = '%';
 5dc:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5e3:	e9 27 01 00 00       	jmp    70f <printf+0x177>
      } else {
        putc(fd, c);
 5e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5eb:	0f be c0             	movsbl %al,%eax
 5ee:	83 ec 08             	sub    $0x8,%esp
 5f1:	50                   	push   %eax
 5f2:	ff 75 08             	pushl  0x8(%ebp)
 5f5:	e8 c7 fe ff ff       	call   4c1 <putc>
 5fa:	83 c4 10             	add    $0x10,%esp
 5fd:	e9 0d 01 00 00       	jmp    70f <printf+0x177>
      }
    } else if(state == '%'){
 602:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 606:	0f 85 03 01 00 00    	jne    70f <printf+0x177>
      if(c == 'd'){
 60c:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 610:	75 1e                	jne    630 <printf+0x98>
        printint(fd, *ap, 10, 1);
 612:	8b 45 e8             	mov    -0x18(%ebp),%eax
 615:	8b 00                	mov    (%eax),%eax
 617:	6a 01                	push   $0x1
 619:	6a 0a                	push   $0xa
 61b:	50                   	push   %eax
 61c:	ff 75 08             	pushl  0x8(%ebp)
 61f:	e8 c0 fe ff ff       	call   4e4 <printint>
 624:	83 c4 10             	add    $0x10,%esp
        ap++;
 627:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 62b:	e9 d8 00 00 00       	jmp    708 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 630:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 634:	74 06                	je     63c <printf+0xa4>
 636:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 63a:	75 1e                	jne    65a <printf+0xc2>
        printint(fd, *ap, 16, 0);
 63c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 63f:	8b 00                	mov    (%eax),%eax
 641:	6a 00                	push   $0x0
 643:	6a 10                	push   $0x10
 645:	50                   	push   %eax
 646:	ff 75 08             	pushl  0x8(%ebp)
 649:	e8 96 fe ff ff       	call   4e4 <printint>
 64e:	83 c4 10             	add    $0x10,%esp
        ap++;
 651:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 655:	e9 ae 00 00 00       	jmp    708 <printf+0x170>
      } else if(c == 's'){
 65a:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 65e:	75 43                	jne    6a3 <printf+0x10b>
        s = (char*)*ap;
 660:	8b 45 e8             	mov    -0x18(%ebp),%eax
 663:	8b 00                	mov    (%eax),%eax
 665:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 668:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 66c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 670:	75 25                	jne    697 <printf+0xff>
          s = "(null)";
 672:	c7 45 f4 82 09 00 00 	movl   $0x982,-0xc(%ebp)
        while(*s != 0){
 679:	eb 1c                	jmp    697 <printf+0xff>
          putc(fd, *s);
 67b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 67e:	0f b6 00             	movzbl (%eax),%eax
 681:	0f be c0             	movsbl %al,%eax
 684:	83 ec 08             	sub    $0x8,%esp
 687:	50                   	push   %eax
 688:	ff 75 08             	pushl  0x8(%ebp)
 68b:	e8 31 fe ff ff       	call   4c1 <putc>
 690:	83 c4 10             	add    $0x10,%esp
          s++;
 693:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 697:	8b 45 f4             	mov    -0xc(%ebp),%eax
 69a:	0f b6 00             	movzbl (%eax),%eax
 69d:	84 c0                	test   %al,%al
 69f:	75 da                	jne    67b <printf+0xe3>
 6a1:	eb 65                	jmp    708 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6a3:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6a7:	75 1d                	jne    6c6 <printf+0x12e>
        putc(fd, *ap);
 6a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6ac:	8b 00                	mov    (%eax),%eax
 6ae:	0f be c0             	movsbl %al,%eax
 6b1:	83 ec 08             	sub    $0x8,%esp
 6b4:	50                   	push   %eax
 6b5:	ff 75 08             	pushl  0x8(%ebp)
 6b8:	e8 04 fe ff ff       	call   4c1 <putc>
 6bd:	83 c4 10             	add    $0x10,%esp
        ap++;
 6c0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6c4:	eb 42                	jmp    708 <printf+0x170>
      } else if(c == '%'){
 6c6:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6ca:	75 17                	jne    6e3 <printf+0x14b>
        putc(fd, c);
 6cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6cf:	0f be c0             	movsbl %al,%eax
 6d2:	83 ec 08             	sub    $0x8,%esp
 6d5:	50                   	push   %eax
 6d6:	ff 75 08             	pushl  0x8(%ebp)
 6d9:	e8 e3 fd ff ff       	call   4c1 <putc>
 6de:	83 c4 10             	add    $0x10,%esp
 6e1:	eb 25                	jmp    708 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6e3:	83 ec 08             	sub    $0x8,%esp
 6e6:	6a 25                	push   $0x25
 6e8:	ff 75 08             	pushl  0x8(%ebp)
 6eb:	e8 d1 fd ff ff       	call   4c1 <putc>
 6f0:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 6f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6f6:	0f be c0             	movsbl %al,%eax
 6f9:	83 ec 08             	sub    $0x8,%esp
 6fc:	50                   	push   %eax
 6fd:	ff 75 08             	pushl  0x8(%ebp)
 700:	e8 bc fd ff ff       	call   4c1 <putc>
 705:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 708:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 70f:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 713:	8b 55 0c             	mov    0xc(%ebp),%edx
 716:	8b 45 f0             	mov    -0x10(%ebp),%eax
 719:	01 d0                	add    %edx,%eax
 71b:	0f b6 00             	movzbl (%eax),%eax
 71e:	84 c0                	test   %al,%al
 720:	0f 85 94 fe ff ff    	jne    5ba <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 726:	90                   	nop
 727:	c9                   	leave  
 728:	c3                   	ret    

00000729 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 729:	55                   	push   %ebp
 72a:	89 e5                	mov    %esp,%ebp
 72c:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 72f:	8b 45 08             	mov    0x8(%ebp),%eax
 732:	83 e8 08             	sub    $0x8,%eax
 735:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 738:	a1 0c 0c 00 00       	mov    0xc0c,%eax
 73d:	89 45 fc             	mov    %eax,-0x4(%ebp)
 740:	eb 24                	jmp    766 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 742:	8b 45 fc             	mov    -0x4(%ebp),%eax
 745:	8b 00                	mov    (%eax),%eax
 747:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 74a:	77 12                	ja     75e <free+0x35>
 74c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 74f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 752:	77 24                	ja     778 <free+0x4f>
 754:	8b 45 fc             	mov    -0x4(%ebp),%eax
 757:	8b 00                	mov    (%eax),%eax
 759:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 75c:	77 1a                	ja     778 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 75e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 761:	8b 00                	mov    (%eax),%eax
 763:	89 45 fc             	mov    %eax,-0x4(%ebp)
 766:	8b 45 f8             	mov    -0x8(%ebp),%eax
 769:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 76c:	76 d4                	jbe    742 <free+0x19>
 76e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 771:	8b 00                	mov    (%eax),%eax
 773:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 776:	76 ca                	jbe    742 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 778:	8b 45 f8             	mov    -0x8(%ebp),%eax
 77b:	8b 40 04             	mov    0x4(%eax),%eax
 77e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 785:	8b 45 f8             	mov    -0x8(%ebp),%eax
 788:	01 c2                	add    %eax,%edx
 78a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78d:	8b 00                	mov    (%eax),%eax
 78f:	39 c2                	cmp    %eax,%edx
 791:	75 24                	jne    7b7 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 793:	8b 45 f8             	mov    -0x8(%ebp),%eax
 796:	8b 50 04             	mov    0x4(%eax),%edx
 799:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79c:	8b 00                	mov    (%eax),%eax
 79e:	8b 40 04             	mov    0x4(%eax),%eax
 7a1:	01 c2                	add    %eax,%edx
 7a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a6:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ac:	8b 00                	mov    (%eax),%eax
 7ae:	8b 10                	mov    (%eax),%edx
 7b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b3:	89 10                	mov    %edx,(%eax)
 7b5:	eb 0a                	jmp    7c1 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 7b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ba:	8b 10                	mov    (%eax),%edx
 7bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7bf:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c4:	8b 40 04             	mov    0x4(%eax),%eax
 7c7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d1:	01 d0                	add    %edx,%eax
 7d3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7d6:	75 20                	jne    7f8 <free+0xcf>
    p->s.size += bp->s.size;
 7d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7db:	8b 50 04             	mov    0x4(%eax),%edx
 7de:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e1:	8b 40 04             	mov    0x4(%eax),%eax
 7e4:	01 c2                	add    %eax,%edx
 7e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e9:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ef:	8b 10                	mov    (%eax),%edx
 7f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f4:	89 10                	mov    %edx,(%eax)
 7f6:	eb 08                	jmp    800 <free+0xd7>
  } else
    p->s.ptr = bp;
 7f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7fb:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7fe:	89 10                	mov    %edx,(%eax)
  freep = p;
 800:	8b 45 fc             	mov    -0x4(%ebp),%eax
 803:	a3 0c 0c 00 00       	mov    %eax,0xc0c
}
 808:	90                   	nop
 809:	c9                   	leave  
 80a:	c3                   	ret    

0000080b <morecore>:

static Header*
morecore(uint nu)
{
 80b:	55                   	push   %ebp
 80c:	89 e5                	mov    %esp,%ebp
 80e:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 811:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 818:	77 07                	ja     821 <morecore+0x16>
    nu = 4096;
 81a:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 821:	8b 45 08             	mov    0x8(%ebp),%eax
 824:	c1 e0 03             	shl    $0x3,%eax
 827:	83 ec 0c             	sub    $0xc,%esp
 82a:	50                   	push   %eax
 82b:	e8 49 fc ff ff       	call   479 <sbrk>
 830:	83 c4 10             	add    $0x10,%esp
 833:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 836:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 83a:	75 07                	jne    843 <morecore+0x38>
    return 0;
 83c:	b8 00 00 00 00       	mov    $0x0,%eax
 841:	eb 26                	jmp    869 <morecore+0x5e>
  hp = (Header*)p;
 843:	8b 45 f4             	mov    -0xc(%ebp),%eax
 846:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 849:	8b 45 f0             	mov    -0x10(%ebp),%eax
 84c:	8b 55 08             	mov    0x8(%ebp),%edx
 84f:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 852:	8b 45 f0             	mov    -0x10(%ebp),%eax
 855:	83 c0 08             	add    $0x8,%eax
 858:	83 ec 0c             	sub    $0xc,%esp
 85b:	50                   	push   %eax
 85c:	e8 c8 fe ff ff       	call   729 <free>
 861:	83 c4 10             	add    $0x10,%esp
  return freep;
 864:	a1 0c 0c 00 00       	mov    0xc0c,%eax
}
 869:	c9                   	leave  
 86a:	c3                   	ret    

0000086b <malloc>:

void*
malloc(uint nbytes)
{
 86b:	55                   	push   %ebp
 86c:	89 e5                	mov    %esp,%ebp
 86e:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 871:	8b 45 08             	mov    0x8(%ebp),%eax
 874:	83 c0 07             	add    $0x7,%eax
 877:	c1 e8 03             	shr    $0x3,%eax
 87a:	83 c0 01             	add    $0x1,%eax
 87d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 880:	a1 0c 0c 00 00       	mov    0xc0c,%eax
 885:	89 45 f0             	mov    %eax,-0x10(%ebp)
 888:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 88c:	75 23                	jne    8b1 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 88e:	c7 45 f0 04 0c 00 00 	movl   $0xc04,-0x10(%ebp)
 895:	8b 45 f0             	mov    -0x10(%ebp),%eax
 898:	a3 0c 0c 00 00       	mov    %eax,0xc0c
 89d:	a1 0c 0c 00 00       	mov    0xc0c,%eax
 8a2:	a3 04 0c 00 00       	mov    %eax,0xc04
    base.s.size = 0;
 8a7:	c7 05 08 0c 00 00 00 	movl   $0x0,0xc08
 8ae:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8b4:	8b 00                	mov    (%eax),%eax
 8b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8bc:	8b 40 04             	mov    0x4(%eax),%eax
 8bf:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8c2:	72 4d                	jb     911 <malloc+0xa6>
      if(p->s.size == nunits)
 8c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c7:	8b 40 04             	mov    0x4(%eax),%eax
 8ca:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8cd:	75 0c                	jne    8db <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d2:	8b 10                	mov    (%eax),%edx
 8d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d7:	89 10                	mov    %edx,(%eax)
 8d9:	eb 26                	jmp    901 <malloc+0x96>
      else {
        p->s.size -= nunits;
 8db:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8de:	8b 40 04             	mov    0x4(%eax),%eax
 8e1:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8e4:	89 c2                	mov    %eax,%edx
 8e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e9:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ef:	8b 40 04             	mov    0x4(%eax),%eax
 8f2:	c1 e0 03             	shl    $0x3,%eax
 8f5:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8fb:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8fe:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 901:	8b 45 f0             	mov    -0x10(%ebp),%eax
 904:	a3 0c 0c 00 00       	mov    %eax,0xc0c
      return (void*)(p + 1);
 909:	8b 45 f4             	mov    -0xc(%ebp),%eax
 90c:	83 c0 08             	add    $0x8,%eax
 90f:	eb 3b                	jmp    94c <malloc+0xe1>
    }
    if(p == freep)
 911:	a1 0c 0c 00 00       	mov    0xc0c,%eax
 916:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 919:	75 1e                	jne    939 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 91b:	83 ec 0c             	sub    $0xc,%esp
 91e:	ff 75 ec             	pushl  -0x14(%ebp)
 921:	e8 e5 fe ff ff       	call   80b <morecore>
 926:	83 c4 10             	add    $0x10,%esp
 929:	89 45 f4             	mov    %eax,-0xc(%ebp)
 92c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 930:	75 07                	jne    939 <malloc+0xce>
        return 0;
 932:	b8 00 00 00 00       	mov    $0x0,%eax
 937:	eb 13                	jmp    94c <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 939:	8b 45 f4             	mov    -0xc(%ebp),%eax
 93c:	89 45 f0             	mov    %eax,-0x10(%ebp)
 93f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 942:	8b 00                	mov    (%eax),%eax
 944:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 947:	e9 6d ff ff ff       	jmp    8b9 <malloc+0x4e>
}
 94c:	c9                   	leave  
 94d:	c3                   	ret    
