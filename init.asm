
_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 14             	sub    $0x14,%esp
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
  11:	83 ec 08             	sub    $0x8,%esp
  14:	6a 02                	push   $0x2
  16:	68 8d 08 00 00       	push   $0x88d
  1b:	e8 4d 03 00 00       	call   36d <open>
  20:	83 c4 10             	add    $0x10,%esp
  23:	85 c0                	test   %eax,%eax
  25:	79 26                	jns    4d <main+0x4d>
    mknod("console", 1, 1);
  27:	83 ec 04             	sub    $0x4,%esp
  2a:	6a 01                	push   $0x1
  2c:	6a 01                	push   $0x1
  2e:	68 8d 08 00 00       	push   $0x88d
  33:	e8 3d 03 00 00       	call   375 <mknod>
  38:	83 c4 10             	add    $0x10,%esp
    open("console", O_RDWR);
  3b:	83 ec 08             	sub    $0x8,%esp
  3e:	6a 02                	push   $0x2
  40:	68 8d 08 00 00       	push   $0x88d
  45:	e8 23 03 00 00       	call   36d <open>
  4a:	83 c4 10             	add    $0x10,%esp
  }
  dup(0);  // stdout
  4d:	83 ec 0c             	sub    $0xc,%esp
  50:	6a 00                	push   $0x0
  52:	e8 4e 03 00 00       	call   3a5 <dup>
  57:	83 c4 10             	add    $0x10,%esp
  dup(0);  // stderr
  5a:	83 ec 0c             	sub    $0xc,%esp
  5d:	6a 00                	push   $0x0
  5f:	e8 41 03 00 00       	call   3a5 <dup>
  64:	83 c4 10             	add    $0x10,%esp

  for(;;){
    pid = fork();
  67:	e8 b9 02 00 00       	call   325 <fork>
  6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(pid < 0){
  6f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  73:	79 17                	jns    8c <main+0x8c>
      printf(1, "init: fork failed\n");
  75:	83 ec 08             	sub    $0x8,%esp
  78:	68 95 08 00 00       	push   $0x895
  7d:	6a 01                	push   $0x1
  7f:	e8 50 04 00 00       	call   4d4 <printf>
  84:	83 c4 10             	add    $0x10,%esp
      exit();
  87:	e8 a1 02 00 00       	call   32d <exit>
    }
    if(pid == 0){
  8c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  90:	75 2c                	jne    be <main+0xbe>
      exec("sh", argv);
  92:	83 ec 08             	sub    $0x8,%esp
  95:	68 10 0b 00 00       	push   $0xb10
  9a:	68 8a 08 00 00       	push   $0x88a
  9f:	e8 c1 02 00 00       	call   365 <exec>
  a4:	83 c4 10             	add    $0x10,%esp
      printf(1, "init: exec sh failed\n");
  a7:	83 ec 08             	sub    $0x8,%esp
  aa:	68 a8 08 00 00       	push   $0x8a8
  af:	6a 01                	push   $0x1
  b1:	e8 1e 04 00 00       	call   4d4 <printf>
  b6:	83 c4 10             	add    $0x10,%esp
      exit();
  b9:	e8 6f 02 00 00       	call   32d <exit>
    }
    while((wpid=wait()) >= 0 && wpid != pid);
  be:	e8 72 02 00 00       	call   335 <wait>
  c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  c6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  ca:	78 9b                	js     67 <main+0x67>
  cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  cf:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  d2:	75 ea                	jne    be <main+0xbe>
  }
  d4:	eb 91                	jmp    67 <main+0x67>

000000d6 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  d6:	55                   	push   %ebp
  d7:	89 e5                	mov    %esp,%ebp
  d9:	57                   	push   %edi
  da:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  db:	8b 4d 08             	mov    0x8(%ebp),%ecx
  de:	8b 55 10             	mov    0x10(%ebp),%edx
  e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  e4:	89 cb                	mov    %ecx,%ebx
  e6:	89 df                	mov    %ebx,%edi
  e8:	89 d1                	mov    %edx,%ecx
  ea:	fc                   	cld    
  eb:	f3 aa                	rep stos %al,%es:(%edi)
  ed:	89 ca                	mov    %ecx,%edx
  ef:	89 fb                	mov    %edi,%ebx
  f1:	89 5d 08             	mov    %ebx,0x8(%ebp)
  f4:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  f7:	90                   	nop
  f8:	5b                   	pop    %ebx
  f9:	5f                   	pop    %edi
  fa:	5d                   	pop    %ebp
  fb:	c3                   	ret    

000000fc <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  fc:	55                   	push   %ebp
  fd:	89 e5                	mov    %esp,%ebp
  ff:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 102:	8b 45 08             	mov    0x8(%ebp),%eax
 105:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 108:	90                   	nop
 109:	8b 45 08             	mov    0x8(%ebp),%eax
 10c:	8d 50 01             	lea    0x1(%eax),%edx
 10f:	89 55 08             	mov    %edx,0x8(%ebp)
 112:	8b 55 0c             	mov    0xc(%ebp),%edx
 115:	8d 4a 01             	lea    0x1(%edx),%ecx
 118:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 11b:	0f b6 12             	movzbl (%edx),%edx
 11e:	88 10                	mov    %dl,(%eax)
 120:	0f b6 00             	movzbl (%eax),%eax
 123:	84 c0                	test   %al,%al
 125:	75 e2                	jne    109 <strcpy+0xd>
    ;
  return os;
 127:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 12a:	c9                   	leave  
 12b:	c3                   	ret    

0000012c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 12c:	55                   	push   %ebp
 12d:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 12f:	eb 08                	jmp    139 <strcmp+0xd>
    p++, q++;
 131:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 135:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 139:	8b 45 08             	mov    0x8(%ebp),%eax
 13c:	0f b6 00             	movzbl (%eax),%eax
 13f:	84 c0                	test   %al,%al
 141:	74 10                	je     153 <strcmp+0x27>
 143:	8b 45 08             	mov    0x8(%ebp),%eax
 146:	0f b6 10             	movzbl (%eax),%edx
 149:	8b 45 0c             	mov    0xc(%ebp),%eax
 14c:	0f b6 00             	movzbl (%eax),%eax
 14f:	38 c2                	cmp    %al,%dl
 151:	74 de                	je     131 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 153:	8b 45 08             	mov    0x8(%ebp),%eax
 156:	0f b6 00             	movzbl (%eax),%eax
 159:	0f b6 d0             	movzbl %al,%edx
 15c:	8b 45 0c             	mov    0xc(%ebp),%eax
 15f:	0f b6 00             	movzbl (%eax),%eax
 162:	0f b6 c0             	movzbl %al,%eax
 165:	29 c2                	sub    %eax,%edx
 167:	89 d0                	mov    %edx,%eax
}
 169:	5d                   	pop    %ebp
 16a:	c3                   	ret    

0000016b <strlen>:

uint
strlen(char *s)
{
 16b:	55                   	push   %ebp
 16c:	89 e5                	mov    %esp,%ebp
 16e:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 171:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 178:	eb 04                	jmp    17e <strlen+0x13>
 17a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 17e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 181:	8b 45 08             	mov    0x8(%ebp),%eax
 184:	01 d0                	add    %edx,%eax
 186:	0f b6 00             	movzbl (%eax),%eax
 189:	84 c0                	test   %al,%al
 18b:	75 ed                	jne    17a <strlen+0xf>
    ;
  return n;
 18d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 190:	c9                   	leave  
 191:	c3                   	ret    

00000192 <memset>:

void*
memset(void *dst, int c, uint n)
{
 192:	55                   	push   %ebp
 193:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 195:	8b 45 10             	mov    0x10(%ebp),%eax
 198:	50                   	push   %eax
 199:	ff 75 0c             	pushl  0xc(%ebp)
 19c:	ff 75 08             	pushl  0x8(%ebp)
 19f:	e8 32 ff ff ff       	call   d6 <stosb>
 1a4:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1a7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1aa:	c9                   	leave  
 1ab:	c3                   	ret    

000001ac <strchr>:

char*
strchr(const char *s, char c)
{
 1ac:	55                   	push   %ebp
 1ad:	89 e5                	mov    %esp,%ebp
 1af:	83 ec 04             	sub    $0x4,%esp
 1b2:	8b 45 0c             	mov    0xc(%ebp),%eax
 1b5:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1b8:	eb 14                	jmp    1ce <strchr+0x22>
    if(*s == c)
 1ba:	8b 45 08             	mov    0x8(%ebp),%eax
 1bd:	0f b6 00             	movzbl (%eax),%eax
 1c0:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1c3:	75 05                	jne    1ca <strchr+0x1e>
      return (char*)s;
 1c5:	8b 45 08             	mov    0x8(%ebp),%eax
 1c8:	eb 13                	jmp    1dd <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1ca:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1ce:	8b 45 08             	mov    0x8(%ebp),%eax
 1d1:	0f b6 00             	movzbl (%eax),%eax
 1d4:	84 c0                	test   %al,%al
 1d6:	75 e2                	jne    1ba <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1dd:	c9                   	leave  
 1de:	c3                   	ret    

000001df <gets>:

char*
gets(char *buf, int max)
{
 1df:	55                   	push   %ebp
 1e0:	89 e5                	mov    %esp,%ebp
 1e2:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1ec:	eb 42                	jmp    230 <gets+0x51>
    cc = read(0, &c, 1);
 1ee:	83 ec 04             	sub    $0x4,%esp
 1f1:	6a 01                	push   $0x1
 1f3:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1f6:	50                   	push   %eax
 1f7:	6a 00                	push   $0x0
 1f9:	e8 47 01 00 00       	call   345 <read>
 1fe:	83 c4 10             	add    $0x10,%esp
 201:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 204:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 208:	7e 33                	jle    23d <gets+0x5e>
      break;
    buf[i++] = c;
 20a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 20d:	8d 50 01             	lea    0x1(%eax),%edx
 210:	89 55 f4             	mov    %edx,-0xc(%ebp)
 213:	89 c2                	mov    %eax,%edx
 215:	8b 45 08             	mov    0x8(%ebp),%eax
 218:	01 c2                	add    %eax,%edx
 21a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 21e:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 220:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 224:	3c 0a                	cmp    $0xa,%al
 226:	74 16                	je     23e <gets+0x5f>
 228:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 22c:	3c 0d                	cmp    $0xd,%al
 22e:	74 0e                	je     23e <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 230:	8b 45 f4             	mov    -0xc(%ebp),%eax
 233:	83 c0 01             	add    $0x1,%eax
 236:	3b 45 0c             	cmp    0xc(%ebp),%eax
 239:	7c b3                	jl     1ee <gets+0xf>
 23b:	eb 01                	jmp    23e <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 23d:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 23e:	8b 55 f4             	mov    -0xc(%ebp),%edx
 241:	8b 45 08             	mov    0x8(%ebp),%eax
 244:	01 d0                	add    %edx,%eax
 246:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 249:	8b 45 08             	mov    0x8(%ebp),%eax
}
 24c:	c9                   	leave  
 24d:	c3                   	ret    

0000024e <stat>:

int
stat(char *n, struct stat *st)
{
 24e:	55                   	push   %ebp
 24f:	89 e5                	mov    %esp,%ebp
 251:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 254:	83 ec 08             	sub    $0x8,%esp
 257:	6a 00                	push   $0x0
 259:	ff 75 08             	pushl  0x8(%ebp)
 25c:	e8 0c 01 00 00       	call   36d <open>
 261:	83 c4 10             	add    $0x10,%esp
 264:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 267:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 26b:	79 07                	jns    274 <stat+0x26>
    return -1;
 26d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 272:	eb 25                	jmp    299 <stat+0x4b>
  r = fstat(fd, st);
 274:	83 ec 08             	sub    $0x8,%esp
 277:	ff 75 0c             	pushl  0xc(%ebp)
 27a:	ff 75 f4             	pushl  -0xc(%ebp)
 27d:	e8 03 01 00 00       	call   385 <fstat>
 282:	83 c4 10             	add    $0x10,%esp
 285:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 288:	83 ec 0c             	sub    $0xc,%esp
 28b:	ff 75 f4             	pushl  -0xc(%ebp)
 28e:	e8 c2 00 00 00       	call   355 <close>
 293:	83 c4 10             	add    $0x10,%esp
  return r;
 296:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 299:	c9                   	leave  
 29a:	c3                   	ret    

0000029b <atoi>:

int
atoi(const char *s)
{
 29b:	55                   	push   %ebp
 29c:	89 e5                	mov    %esp,%ebp
 29e:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2a1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2a8:	eb 25                	jmp    2cf <atoi+0x34>
    n = n*10 + *s++ - '0';
 2aa:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2ad:	89 d0                	mov    %edx,%eax
 2af:	c1 e0 02             	shl    $0x2,%eax
 2b2:	01 d0                	add    %edx,%eax
 2b4:	01 c0                	add    %eax,%eax
 2b6:	89 c1                	mov    %eax,%ecx
 2b8:	8b 45 08             	mov    0x8(%ebp),%eax
 2bb:	8d 50 01             	lea    0x1(%eax),%edx
 2be:	89 55 08             	mov    %edx,0x8(%ebp)
 2c1:	0f b6 00             	movzbl (%eax),%eax
 2c4:	0f be c0             	movsbl %al,%eax
 2c7:	01 c8                	add    %ecx,%eax
 2c9:	83 e8 30             	sub    $0x30,%eax
 2cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2cf:	8b 45 08             	mov    0x8(%ebp),%eax
 2d2:	0f b6 00             	movzbl (%eax),%eax
 2d5:	3c 2f                	cmp    $0x2f,%al
 2d7:	7e 0a                	jle    2e3 <atoi+0x48>
 2d9:	8b 45 08             	mov    0x8(%ebp),%eax
 2dc:	0f b6 00             	movzbl (%eax),%eax
 2df:	3c 39                	cmp    $0x39,%al
 2e1:	7e c7                	jle    2aa <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2e6:	c9                   	leave  
 2e7:	c3                   	ret    

000002e8 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2e8:	55                   	push   %ebp
 2e9:	89 e5                	mov    %esp,%ebp
 2eb:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2ee:	8b 45 08             	mov    0x8(%ebp),%eax
 2f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2f4:	8b 45 0c             	mov    0xc(%ebp),%eax
 2f7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2fa:	eb 17                	jmp    313 <memmove+0x2b>
    *dst++ = *src++;
 2fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2ff:	8d 50 01             	lea    0x1(%eax),%edx
 302:	89 55 fc             	mov    %edx,-0x4(%ebp)
 305:	8b 55 f8             	mov    -0x8(%ebp),%edx
 308:	8d 4a 01             	lea    0x1(%edx),%ecx
 30b:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 30e:	0f b6 12             	movzbl (%edx),%edx
 311:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 313:	8b 45 10             	mov    0x10(%ebp),%eax
 316:	8d 50 ff             	lea    -0x1(%eax),%edx
 319:	89 55 10             	mov    %edx,0x10(%ebp)
 31c:	85 c0                	test   %eax,%eax
 31e:	7f dc                	jg     2fc <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 320:	8b 45 08             	mov    0x8(%ebp),%eax
}
 323:	c9                   	leave  
 324:	c3                   	ret    

00000325 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 325:	b8 01 00 00 00       	mov    $0x1,%eax
 32a:	cd 40                	int    $0x40
 32c:	c3                   	ret    

0000032d <exit>:
SYSCALL(exit)
 32d:	b8 02 00 00 00       	mov    $0x2,%eax
 332:	cd 40                	int    $0x40
 334:	c3                   	ret    

00000335 <wait>:
SYSCALL(wait)
 335:	b8 03 00 00 00       	mov    $0x3,%eax
 33a:	cd 40                	int    $0x40
 33c:	c3                   	ret    

0000033d <pipe>:
SYSCALL(pipe)
 33d:	b8 04 00 00 00       	mov    $0x4,%eax
 342:	cd 40                	int    $0x40
 344:	c3                   	ret    

00000345 <read>:
SYSCALL(read)
 345:	b8 05 00 00 00       	mov    $0x5,%eax
 34a:	cd 40                	int    $0x40
 34c:	c3                   	ret    

0000034d <write>:
SYSCALL(write)
 34d:	b8 10 00 00 00       	mov    $0x10,%eax
 352:	cd 40                	int    $0x40
 354:	c3                   	ret    

00000355 <close>:
SYSCALL(close)
 355:	b8 15 00 00 00       	mov    $0x15,%eax
 35a:	cd 40                	int    $0x40
 35c:	c3                   	ret    

0000035d <kill>:
SYSCALL(kill)
 35d:	b8 06 00 00 00       	mov    $0x6,%eax
 362:	cd 40                	int    $0x40
 364:	c3                   	ret    

00000365 <exec>:
SYSCALL(exec)
 365:	b8 07 00 00 00       	mov    $0x7,%eax
 36a:	cd 40                	int    $0x40
 36c:	c3                   	ret    

0000036d <open>:
SYSCALL(open)
 36d:	b8 0f 00 00 00       	mov    $0xf,%eax
 372:	cd 40                	int    $0x40
 374:	c3                   	ret    

00000375 <mknod>:
SYSCALL(mknod)
 375:	b8 11 00 00 00       	mov    $0x11,%eax
 37a:	cd 40                	int    $0x40
 37c:	c3                   	ret    

0000037d <unlink>:
SYSCALL(unlink)
 37d:	b8 12 00 00 00       	mov    $0x12,%eax
 382:	cd 40                	int    $0x40
 384:	c3                   	ret    

00000385 <fstat>:
SYSCALL(fstat)
 385:	b8 08 00 00 00       	mov    $0x8,%eax
 38a:	cd 40                	int    $0x40
 38c:	c3                   	ret    

0000038d <link>:
SYSCALL(link)
 38d:	b8 13 00 00 00       	mov    $0x13,%eax
 392:	cd 40                	int    $0x40
 394:	c3                   	ret    

00000395 <mkdir>:
SYSCALL(mkdir)
 395:	b8 14 00 00 00       	mov    $0x14,%eax
 39a:	cd 40                	int    $0x40
 39c:	c3                   	ret    

0000039d <chdir>:
SYSCALL(chdir)
 39d:	b8 09 00 00 00       	mov    $0x9,%eax
 3a2:	cd 40                	int    $0x40
 3a4:	c3                   	ret    

000003a5 <dup>:
SYSCALL(dup)
 3a5:	b8 0a 00 00 00       	mov    $0xa,%eax
 3aa:	cd 40                	int    $0x40
 3ac:	c3                   	ret    

000003ad <getpid>:
SYSCALL(getpid)
 3ad:	b8 0b 00 00 00       	mov    $0xb,%eax
 3b2:	cd 40                	int    $0x40
 3b4:	c3                   	ret    

000003b5 <sbrk>:
SYSCALL(sbrk)
 3b5:	b8 0c 00 00 00       	mov    $0xc,%eax
 3ba:	cd 40                	int    $0x40
 3bc:	c3                   	ret    

000003bd <sleep>:
SYSCALL(sleep)
 3bd:	b8 0d 00 00 00       	mov    $0xd,%eax
 3c2:	cd 40                	int    $0x40
 3c4:	c3                   	ret    

000003c5 <uptime>:
SYSCALL(uptime)
 3c5:	b8 0e 00 00 00       	mov    $0xe,%eax
 3ca:	cd 40                	int    $0x40
 3cc:	c3                   	ret    

000003cd <halt>:
SYSCALL(halt)
 3cd:	b8 16 00 00 00       	mov    $0x16,%eax
 3d2:	cd 40                	int    $0x40
 3d4:	c3                   	ret    

000003d5 <thread_create>:
SYSCALL(thread_create)
 3d5:	b8 17 00 00 00       	mov    $0x17,%eax
 3da:	cd 40                	int    $0x40
 3dc:	c3                   	ret    

000003dd <thread_exit>:
SYSCALL(thread_exit)
 3dd:	b8 18 00 00 00       	mov    $0x18,%eax
 3e2:	cd 40                	int    $0x40
 3e4:	c3                   	ret    

000003e5 <thread_join>:
SYSCALL(thread_join)
 3e5:	b8 19 00 00 00       	mov    $0x19,%eax
 3ea:	cd 40                	int    $0x40
 3ec:	c3                   	ret    

000003ed <gettid>:
SYSCALL(gettid)
 3ed:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3f2:	cd 40                	int    $0x40
 3f4:	c3                   	ret    

000003f5 <clone>:
SYSCALL(clone)
 3f5:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3fa:	cd 40                	int    $0x40
 3fc:	c3                   	ret    

000003fd <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3fd:	55                   	push   %ebp
 3fe:	89 e5                	mov    %esp,%ebp
 400:	83 ec 18             	sub    $0x18,%esp
 403:	8b 45 0c             	mov    0xc(%ebp),%eax
 406:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 409:	83 ec 04             	sub    $0x4,%esp
 40c:	6a 01                	push   $0x1
 40e:	8d 45 f4             	lea    -0xc(%ebp),%eax
 411:	50                   	push   %eax
 412:	ff 75 08             	pushl  0x8(%ebp)
 415:	e8 33 ff ff ff       	call   34d <write>
 41a:	83 c4 10             	add    $0x10,%esp
}
 41d:	90                   	nop
 41e:	c9                   	leave  
 41f:	c3                   	ret    

00000420 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 420:	55                   	push   %ebp
 421:	89 e5                	mov    %esp,%ebp
 423:	53                   	push   %ebx
 424:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 427:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 42e:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 432:	74 17                	je     44b <printint+0x2b>
 434:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 438:	79 11                	jns    44b <printint+0x2b>
    neg = 1;
 43a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 441:	8b 45 0c             	mov    0xc(%ebp),%eax
 444:	f7 d8                	neg    %eax
 446:	89 45 ec             	mov    %eax,-0x14(%ebp)
 449:	eb 06                	jmp    451 <printint+0x31>
  } else {
    x = xx;
 44b:	8b 45 0c             	mov    0xc(%ebp),%eax
 44e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 451:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 458:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 45b:	8d 41 01             	lea    0x1(%ecx),%eax
 45e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 461:	8b 5d 10             	mov    0x10(%ebp),%ebx
 464:	8b 45 ec             	mov    -0x14(%ebp),%eax
 467:	ba 00 00 00 00       	mov    $0x0,%edx
 46c:	f7 f3                	div    %ebx
 46e:	89 d0                	mov    %edx,%eax
 470:	0f b6 80 18 0b 00 00 	movzbl 0xb18(%eax),%eax
 477:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 47b:	8b 5d 10             	mov    0x10(%ebp),%ebx
 47e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 481:	ba 00 00 00 00       	mov    $0x0,%edx
 486:	f7 f3                	div    %ebx
 488:	89 45 ec             	mov    %eax,-0x14(%ebp)
 48b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 48f:	75 c7                	jne    458 <printint+0x38>
  if(neg)
 491:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 495:	74 2d                	je     4c4 <printint+0xa4>
    buf[i++] = '-';
 497:	8b 45 f4             	mov    -0xc(%ebp),%eax
 49a:	8d 50 01             	lea    0x1(%eax),%edx
 49d:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4a0:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4a5:	eb 1d                	jmp    4c4 <printint+0xa4>
    putc(fd, buf[i]);
 4a7:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4ad:	01 d0                	add    %edx,%eax
 4af:	0f b6 00             	movzbl (%eax),%eax
 4b2:	0f be c0             	movsbl %al,%eax
 4b5:	83 ec 08             	sub    $0x8,%esp
 4b8:	50                   	push   %eax
 4b9:	ff 75 08             	pushl  0x8(%ebp)
 4bc:	e8 3c ff ff ff       	call   3fd <putc>
 4c1:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4c4:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4cc:	79 d9                	jns    4a7 <printint+0x87>
    putc(fd, buf[i]);
}
 4ce:	90                   	nop
 4cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4d2:	c9                   	leave  
 4d3:	c3                   	ret    

000004d4 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4d4:	55                   	push   %ebp
 4d5:	89 e5                	mov    %esp,%ebp
 4d7:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4da:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4e1:	8d 45 0c             	lea    0xc(%ebp),%eax
 4e4:	83 c0 04             	add    $0x4,%eax
 4e7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4ea:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4f1:	e9 59 01 00 00       	jmp    64f <printf+0x17b>
    c = fmt[i] & 0xff;
 4f6:	8b 55 0c             	mov    0xc(%ebp),%edx
 4f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4fc:	01 d0                	add    %edx,%eax
 4fe:	0f b6 00             	movzbl (%eax),%eax
 501:	0f be c0             	movsbl %al,%eax
 504:	25 ff 00 00 00       	and    $0xff,%eax
 509:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 50c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 510:	75 2c                	jne    53e <printf+0x6a>
      if(c == '%'){
 512:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 516:	75 0c                	jne    524 <printf+0x50>
        state = '%';
 518:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 51f:	e9 27 01 00 00       	jmp    64b <printf+0x177>
      } else {
        putc(fd, c);
 524:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 527:	0f be c0             	movsbl %al,%eax
 52a:	83 ec 08             	sub    $0x8,%esp
 52d:	50                   	push   %eax
 52e:	ff 75 08             	pushl  0x8(%ebp)
 531:	e8 c7 fe ff ff       	call   3fd <putc>
 536:	83 c4 10             	add    $0x10,%esp
 539:	e9 0d 01 00 00       	jmp    64b <printf+0x177>
      }
    } else if(state == '%'){
 53e:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 542:	0f 85 03 01 00 00    	jne    64b <printf+0x177>
      if(c == 'd'){
 548:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 54c:	75 1e                	jne    56c <printf+0x98>
        printint(fd, *ap, 10, 1);
 54e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 551:	8b 00                	mov    (%eax),%eax
 553:	6a 01                	push   $0x1
 555:	6a 0a                	push   $0xa
 557:	50                   	push   %eax
 558:	ff 75 08             	pushl  0x8(%ebp)
 55b:	e8 c0 fe ff ff       	call   420 <printint>
 560:	83 c4 10             	add    $0x10,%esp
        ap++;
 563:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 567:	e9 d8 00 00 00       	jmp    644 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 56c:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 570:	74 06                	je     578 <printf+0xa4>
 572:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 576:	75 1e                	jne    596 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 578:	8b 45 e8             	mov    -0x18(%ebp),%eax
 57b:	8b 00                	mov    (%eax),%eax
 57d:	6a 00                	push   $0x0
 57f:	6a 10                	push   $0x10
 581:	50                   	push   %eax
 582:	ff 75 08             	pushl  0x8(%ebp)
 585:	e8 96 fe ff ff       	call   420 <printint>
 58a:	83 c4 10             	add    $0x10,%esp
        ap++;
 58d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 591:	e9 ae 00 00 00       	jmp    644 <printf+0x170>
      } else if(c == 's'){
 596:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 59a:	75 43                	jne    5df <printf+0x10b>
        s = (char*)*ap;
 59c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 59f:	8b 00                	mov    (%eax),%eax
 5a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5a4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5ac:	75 25                	jne    5d3 <printf+0xff>
          s = "(null)";
 5ae:	c7 45 f4 be 08 00 00 	movl   $0x8be,-0xc(%ebp)
        while(*s != 0){
 5b5:	eb 1c                	jmp    5d3 <printf+0xff>
          putc(fd, *s);
 5b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5ba:	0f b6 00             	movzbl (%eax),%eax
 5bd:	0f be c0             	movsbl %al,%eax
 5c0:	83 ec 08             	sub    $0x8,%esp
 5c3:	50                   	push   %eax
 5c4:	ff 75 08             	pushl  0x8(%ebp)
 5c7:	e8 31 fe ff ff       	call   3fd <putc>
 5cc:	83 c4 10             	add    $0x10,%esp
          s++;
 5cf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5d6:	0f b6 00             	movzbl (%eax),%eax
 5d9:	84 c0                	test   %al,%al
 5db:	75 da                	jne    5b7 <printf+0xe3>
 5dd:	eb 65                	jmp    644 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5df:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5e3:	75 1d                	jne    602 <printf+0x12e>
        putc(fd, *ap);
 5e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5e8:	8b 00                	mov    (%eax),%eax
 5ea:	0f be c0             	movsbl %al,%eax
 5ed:	83 ec 08             	sub    $0x8,%esp
 5f0:	50                   	push   %eax
 5f1:	ff 75 08             	pushl  0x8(%ebp)
 5f4:	e8 04 fe ff ff       	call   3fd <putc>
 5f9:	83 c4 10             	add    $0x10,%esp
        ap++;
 5fc:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 600:	eb 42                	jmp    644 <printf+0x170>
      } else if(c == '%'){
 602:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 606:	75 17                	jne    61f <printf+0x14b>
        putc(fd, c);
 608:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 60b:	0f be c0             	movsbl %al,%eax
 60e:	83 ec 08             	sub    $0x8,%esp
 611:	50                   	push   %eax
 612:	ff 75 08             	pushl  0x8(%ebp)
 615:	e8 e3 fd ff ff       	call   3fd <putc>
 61a:	83 c4 10             	add    $0x10,%esp
 61d:	eb 25                	jmp    644 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 61f:	83 ec 08             	sub    $0x8,%esp
 622:	6a 25                	push   $0x25
 624:	ff 75 08             	pushl  0x8(%ebp)
 627:	e8 d1 fd ff ff       	call   3fd <putc>
 62c:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 62f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 632:	0f be c0             	movsbl %al,%eax
 635:	83 ec 08             	sub    $0x8,%esp
 638:	50                   	push   %eax
 639:	ff 75 08             	pushl  0x8(%ebp)
 63c:	e8 bc fd ff ff       	call   3fd <putc>
 641:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 644:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 64b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 64f:	8b 55 0c             	mov    0xc(%ebp),%edx
 652:	8b 45 f0             	mov    -0x10(%ebp),%eax
 655:	01 d0                	add    %edx,%eax
 657:	0f b6 00             	movzbl (%eax),%eax
 65a:	84 c0                	test   %al,%al
 65c:	0f 85 94 fe ff ff    	jne    4f6 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 662:	90                   	nop
 663:	c9                   	leave  
 664:	c3                   	ret    

00000665 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 665:	55                   	push   %ebp
 666:	89 e5                	mov    %esp,%ebp
 668:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 66b:	8b 45 08             	mov    0x8(%ebp),%eax
 66e:	83 e8 08             	sub    $0x8,%eax
 671:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 674:	a1 34 0b 00 00       	mov    0xb34,%eax
 679:	89 45 fc             	mov    %eax,-0x4(%ebp)
 67c:	eb 24                	jmp    6a2 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 67e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 681:	8b 00                	mov    (%eax),%eax
 683:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 686:	77 12                	ja     69a <free+0x35>
 688:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 68e:	77 24                	ja     6b4 <free+0x4f>
 690:	8b 45 fc             	mov    -0x4(%ebp),%eax
 693:	8b 00                	mov    (%eax),%eax
 695:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 698:	77 1a                	ja     6b4 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 69a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69d:	8b 00                	mov    (%eax),%eax
 69f:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6a8:	76 d4                	jbe    67e <free+0x19>
 6aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ad:	8b 00                	mov    (%eax),%eax
 6af:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6b2:	76 ca                	jbe    67e <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b7:	8b 40 04             	mov    0x4(%eax),%eax
 6ba:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c4:	01 c2                	add    %eax,%edx
 6c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c9:	8b 00                	mov    (%eax),%eax
 6cb:	39 c2                	cmp    %eax,%edx
 6cd:	75 24                	jne    6f3 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d2:	8b 50 04             	mov    0x4(%eax),%edx
 6d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d8:	8b 00                	mov    (%eax),%eax
 6da:	8b 40 04             	mov    0x4(%eax),%eax
 6dd:	01 c2                	add    %eax,%edx
 6df:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e2:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e8:	8b 00                	mov    (%eax),%eax
 6ea:	8b 10                	mov    (%eax),%edx
 6ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ef:	89 10                	mov    %edx,(%eax)
 6f1:	eb 0a                	jmp    6fd <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f6:	8b 10                	mov    (%eax),%edx
 6f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fb:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 700:	8b 40 04             	mov    0x4(%eax),%eax
 703:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 70a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70d:	01 d0                	add    %edx,%eax
 70f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 712:	75 20                	jne    734 <free+0xcf>
    p->s.size += bp->s.size;
 714:	8b 45 fc             	mov    -0x4(%ebp),%eax
 717:	8b 50 04             	mov    0x4(%eax),%edx
 71a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71d:	8b 40 04             	mov    0x4(%eax),%eax
 720:	01 c2                	add    %eax,%edx
 722:	8b 45 fc             	mov    -0x4(%ebp),%eax
 725:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 728:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72b:	8b 10                	mov    (%eax),%edx
 72d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 730:	89 10                	mov    %edx,(%eax)
 732:	eb 08                	jmp    73c <free+0xd7>
  } else
    p->s.ptr = bp;
 734:	8b 45 fc             	mov    -0x4(%ebp),%eax
 737:	8b 55 f8             	mov    -0x8(%ebp),%edx
 73a:	89 10                	mov    %edx,(%eax)
  freep = p;
 73c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73f:	a3 34 0b 00 00       	mov    %eax,0xb34
}
 744:	90                   	nop
 745:	c9                   	leave  
 746:	c3                   	ret    

00000747 <morecore>:

static Header*
morecore(uint nu)
{
 747:	55                   	push   %ebp
 748:	89 e5                	mov    %esp,%ebp
 74a:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 74d:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 754:	77 07                	ja     75d <morecore+0x16>
    nu = 4096;
 756:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 75d:	8b 45 08             	mov    0x8(%ebp),%eax
 760:	c1 e0 03             	shl    $0x3,%eax
 763:	83 ec 0c             	sub    $0xc,%esp
 766:	50                   	push   %eax
 767:	e8 49 fc ff ff       	call   3b5 <sbrk>
 76c:	83 c4 10             	add    $0x10,%esp
 76f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 772:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 776:	75 07                	jne    77f <morecore+0x38>
    return 0;
 778:	b8 00 00 00 00       	mov    $0x0,%eax
 77d:	eb 26                	jmp    7a5 <morecore+0x5e>
  hp = (Header*)p;
 77f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 782:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 785:	8b 45 f0             	mov    -0x10(%ebp),%eax
 788:	8b 55 08             	mov    0x8(%ebp),%edx
 78b:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 78e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 791:	83 c0 08             	add    $0x8,%eax
 794:	83 ec 0c             	sub    $0xc,%esp
 797:	50                   	push   %eax
 798:	e8 c8 fe ff ff       	call   665 <free>
 79d:	83 c4 10             	add    $0x10,%esp
  return freep;
 7a0:	a1 34 0b 00 00       	mov    0xb34,%eax
}
 7a5:	c9                   	leave  
 7a6:	c3                   	ret    

000007a7 <malloc>:

void*
malloc(uint nbytes)
{
 7a7:	55                   	push   %ebp
 7a8:	89 e5                	mov    %esp,%ebp
 7aa:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7ad:	8b 45 08             	mov    0x8(%ebp),%eax
 7b0:	83 c0 07             	add    $0x7,%eax
 7b3:	c1 e8 03             	shr    $0x3,%eax
 7b6:	83 c0 01             	add    $0x1,%eax
 7b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7bc:	a1 34 0b 00 00       	mov    0xb34,%eax
 7c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7c4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7c8:	75 23                	jne    7ed <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7ca:	c7 45 f0 2c 0b 00 00 	movl   $0xb2c,-0x10(%ebp)
 7d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d4:	a3 34 0b 00 00       	mov    %eax,0xb34
 7d9:	a1 34 0b 00 00       	mov    0xb34,%eax
 7de:	a3 2c 0b 00 00       	mov    %eax,0xb2c
    base.s.size = 0;
 7e3:	c7 05 30 0b 00 00 00 	movl   $0x0,0xb30
 7ea:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f0:	8b 00                	mov    (%eax),%eax
 7f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f8:	8b 40 04             	mov    0x4(%eax),%eax
 7fb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7fe:	72 4d                	jb     84d <malloc+0xa6>
      if(p->s.size == nunits)
 800:	8b 45 f4             	mov    -0xc(%ebp),%eax
 803:	8b 40 04             	mov    0x4(%eax),%eax
 806:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 809:	75 0c                	jne    817 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 80b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80e:	8b 10                	mov    (%eax),%edx
 810:	8b 45 f0             	mov    -0x10(%ebp),%eax
 813:	89 10                	mov    %edx,(%eax)
 815:	eb 26                	jmp    83d <malloc+0x96>
      else {
        p->s.size -= nunits;
 817:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81a:	8b 40 04             	mov    0x4(%eax),%eax
 81d:	2b 45 ec             	sub    -0x14(%ebp),%eax
 820:	89 c2                	mov    %eax,%edx
 822:	8b 45 f4             	mov    -0xc(%ebp),%eax
 825:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 828:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82b:	8b 40 04             	mov    0x4(%eax),%eax
 82e:	c1 e0 03             	shl    $0x3,%eax
 831:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 834:	8b 45 f4             	mov    -0xc(%ebp),%eax
 837:	8b 55 ec             	mov    -0x14(%ebp),%edx
 83a:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 83d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 840:	a3 34 0b 00 00       	mov    %eax,0xb34
      return (void*)(p + 1);
 845:	8b 45 f4             	mov    -0xc(%ebp),%eax
 848:	83 c0 08             	add    $0x8,%eax
 84b:	eb 3b                	jmp    888 <malloc+0xe1>
    }
    if(p == freep)
 84d:	a1 34 0b 00 00       	mov    0xb34,%eax
 852:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 855:	75 1e                	jne    875 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 857:	83 ec 0c             	sub    $0xc,%esp
 85a:	ff 75 ec             	pushl  -0x14(%ebp)
 85d:	e8 e5 fe ff ff       	call   747 <morecore>
 862:	83 c4 10             	add    $0x10,%esp
 865:	89 45 f4             	mov    %eax,-0xc(%ebp)
 868:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 86c:	75 07                	jne    875 <malloc+0xce>
        return 0;
 86e:	b8 00 00 00 00       	mov    $0x0,%eax
 873:	eb 13                	jmp    888 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 875:	8b 45 f4             	mov    -0xc(%ebp),%eax
 878:	89 45 f0             	mov    %eax,-0x10(%ebp)
 87b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87e:	8b 00                	mov    (%eax),%eax
 880:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 883:	e9 6d ff ff ff       	jmp    7f5 <malloc+0x4e>
}
 888:	c9                   	leave  
 889:	c3                   	ret    
