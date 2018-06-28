
_test3:     file format elf32-i386


Disassembly of section .text:

00000000 <thread>:

void *stack[NTHREAD];
int tid[NTHREAD];
void *retval[NTHREAD];

void *thread(void *arg){
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 08             	sub    $0x8,%esp
	thread_exit(arg);
   6:	83 ec 0c             	sub    $0xc,%esp
   9:	ff 75 08             	pushl  0x8(%ebp)
   c:	e8 08 06 00 00       	call   619 <thread_exit>

00000011 <thread2>:
}

void *thread2(void *arg){
  11:	55                   	push   %ebp
  12:	89 e5                	mov    %esp,%ebp
  14:	83 ec 08             	sub    $0x8,%esp
	printf(1, "OK\n");
  17:	83 ec 08             	sub    $0x8,%esp
  1a:	68 c6 0a 00 00       	push   $0xac6
  1f:	6a 01                	push   $0x1
  21:	e8 ea 06 00 00       	call   710 <printf>
  26:	83 c4 10             	add    $0x10,%esp
	exit();
  29:	e8 3b 05 00 00       	call   569 <exit>

0000002e <main>:
}

int
main(int argc, char **argv)
{
  2e:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  32:	83 e4 f0             	and    $0xfffffff0,%esp
  35:	ff 71 fc             	pushl  -0x4(%ecx)
  38:	55                   	push   %ebp
  39:	89 e5                	mov    %esp,%ebp
  3b:	51                   	push   %ecx
  3c:	83 ec 14             	sub    $0x14,%esp
	int i;
    int j;

	printf(1, "TEST3: ");
  3f:	83 ec 08             	sub    $0x8,%esp
  42:	68 ca 0a 00 00       	push   $0xaca
  47:	6a 01                	push   $0x1
  49:	e8 c2 06 00 00       	call   710 <printf>
  4e:	83 c4 10             	add    $0x10,%esp
//    exit();
	for(i=0;i<NTHREAD;i++)
  51:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  58:	eb 20                	jmp    7a <main+0x4c>
		stack[i] = malloc(4096);
  5a:	83 ec 0c             	sub    $0xc,%esp
  5d:	68 00 10 00 00       	push   $0x1000
  62:	e8 7c 09 00 00       	call   9e3 <malloc>
  67:	83 c4 10             	add    $0x10,%esp
  6a:	89 c2                	mov    %eax,%edx
  6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  6f:	89 14 85 00 0e 00 00 	mov    %edx,0xe00(,%eax,4)
	int i;
    int j;

	printf(1, "TEST3: ");
//    exit();
	for(i=0;i<NTHREAD;i++)
  76:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  7a:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
  7e:	7e da                	jle    5a <main+0x2c>
		stack[i] = malloc(4096);

    for(i=0;i<100;i++){
  80:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  87:	e9 df 00 00 00       	jmp    16b <main+0x13d>
		for(j=0;j<NTHREAD-1;j++){
  8c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  93:	eb 54                	jmp    e9 <main+0xbb>
			tid[j] = thread_create(thread, 30, (void *)j, stack[j]);
  95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  98:	8b 14 85 00 0e 00 00 	mov    0xe00(,%eax,4),%edx
  9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  a2:	52                   	push   %edx
  a3:	50                   	push   %eax
  a4:	6a 1e                	push   $0x1e
  a6:	68 00 00 00 00       	push   $0x0
  ab:	e8 61 05 00 00       	call   611 <thread_create>
  b0:	83 c4 10             	add    $0x10,%esp
  b3:	89 c2                	mov    %eax,%edx
  b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  b8:	89 14 85 20 0e 00 00 	mov    %edx,0xe20(,%eax,4)
			if(tid[j] == -1){
  bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  c2:	8b 04 85 20 0e 00 00 	mov    0xe20(,%eax,4),%eax
  c9:	83 f8 ff             	cmp    $0xffffffff,%eax
  cc:	75 17                	jne    e5 <main+0xb7>
				printf(1, "ONE WRONG\n");
  ce:	83 ec 08             	sub    $0x8,%esp
  d1:	68 d2 0a 00 00       	push   $0xad2
  d6:	6a 01                	push   $0x1
  d8:	e8 33 06 00 00       	call   710 <printf>
  dd:	83 c4 10             	add    $0x10,%esp
				exit();
  e0:	e8 84 04 00 00       	call   569 <exit>
//    exit();
	for(i=0;i<NTHREAD;i++)
		stack[i] = malloc(4096);

    for(i=0;i<100;i++){
		for(j=0;j<NTHREAD-1;j++){
  e5:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  e9:	83 7d f0 06          	cmpl   $0x6,-0x10(%ebp)
  ed:	7e a6                	jle    95 <main+0x67>
			if(tid[j] == -1){
				printf(1, "ONE WRONG\n");
				exit();
			}
		}
		for(j=0;j<NTHREAD-1;j++){
  ef:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  f6:	eb 69                	jmp    161 <main+0x133>
			if(thread_join(tid[j], &retval[j]) == -1){
  f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  fb:	c1 e0 02             	shl    $0x2,%eax
  fe:	8d 90 40 0e 00 00    	lea    0xe40(%eax),%edx
 104:	8b 45 f0             	mov    -0x10(%ebp),%eax
 107:	8b 04 85 20 0e 00 00 	mov    0xe20(,%eax,4),%eax
 10e:	83 ec 08             	sub    $0x8,%esp
 111:	52                   	push   %edx
 112:	50                   	push   %eax
 113:	e8 09 05 00 00       	call   621 <thread_join>
 118:	83 c4 10             	add    $0x10,%esp
 11b:	83 f8 ff             	cmp    $0xffffffff,%eax
 11e:	75 17                	jne    137 <main+0x109>
				printf(1, "TWO WRONG\n");
 120:	83 ec 08             	sub    $0x8,%esp
 123:	68 dd 0a 00 00       	push   $0xadd
 128:	6a 01                	push   $0x1
 12a:	e8 e1 05 00 00       	call   710 <printf>
 12f:	83 c4 10             	add    $0x10,%esp
				exit();
 132:	e8 32 04 00 00       	call   569 <exit>
			}

			if((int)retval[j] != j){
 137:	8b 45 f0             	mov    -0x10(%ebp),%eax
 13a:	8b 04 85 40 0e 00 00 	mov    0xe40(,%eax,4),%eax
 141:	3b 45 f0             	cmp    -0x10(%ebp),%eax
 144:	74 17                	je     15d <main+0x12f>
                printf(1, "THREE WRONG\n");
 146:	83 ec 08             	sub    $0x8,%esp
 149:	68 e8 0a 00 00       	push   $0xae8
 14e:	6a 01                	push   $0x1
 150:	e8 bb 05 00 00       	call   710 <printf>
 155:	83 c4 10             	add    $0x10,%esp
				exit();
 158:	e8 0c 04 00 00       	call   569 <exit>
			if(tid[j] == -1){
				printf(1, "ONE WRONG\n");
				exit();
			}
		}
		for(j=0;j<NTHREAD-1;j++){
 15d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 161:	83 7d f0 06          	cmpl   $0x6,-0x10(%ebp)
 165:	7e 91                	jle    f8 <main+0xca>
	printf(1, "TEST3: ");
//    exit();
	for(i=0;i<NTHREAD;i++)
		stack[i] = malloc(4096);

    for(i=0;i<100;i++){
 167:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 16b:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
 16f:	0f 8e 17 ff ff ff    	jle    8c <main+0x5e>
			}

		}
    }

	for(i=0;i<NTHREAD-1;i++){
 175:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 17c:	eb 52                	jmp    1d0 <main+0x1a2>
		tid[i] = thread_create(thread, 30, 0, stack[i]);
 17e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 181:	8b 04 85 00 0e 00 00 	mov    0xe00(,%eax,4),%eax
 188:	50                   	push   %eax
 189:	6a 00                	push   $0x0
 18b:	6a 1e                	push   $0x1e
 18d:	68 00 00 00 00       	push   $0x0
 192:	e8 7a 04 00 00       	call   611 <thread_create>
 197:	83 c4 10             	add    $0x10,%esp
 19a:	89 c2                	mov    %eax,%edx
 19c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 19f:	89 14 85 20 0e 00 00 	mov    %edx,0xe20(,%eax,4)
		if(tid[i] == -1){
 1a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1a9:	8b 04 85 20 0e 00 00 	mov    0xe20(,%eax,4),%eax
 1b0:	83 f8 ff             	cmp    $0xffffffff,%eax
 1b3:	75 17                	jne    1cc <main+0x19e>
			printf(1, " FOURWRONG\n");
 1b5:	83 ec 08             	sub    $0x8,%esp
 1b8:	68 f5 0a 00 00       	push   $0xaf5
 1bd:	6a 01                	push   $0x1
 1bf:	e8 4c 05 00 00       	call   710 <printf>
 1c4:	83 c4 10             	add    $0x10,%esp
			exit();
 1c7:	e8 9d 03 00 00       	call   569 <exit>
			}

		}
    }

	for(i=0;i<NTHREAD-1;i++){
 1cc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 1d0:	83 7d f4 06          	cmpl   $0x6,-0xc(%ebp)
 1d4:	7e a8                	jle    17e <main+0x150>
			printf(1, " FOURWRONG\n");
			exit();
		}
	}

	if(thread_create(thread, 30, 0, stack[NTHREAD-1]) != -1){
 1d6:	a1 1c 0e 00 00       	mov    0xe1c,%eax
 1db:	50                   	push   %eax
 1dc:	6a 00                	push   $0x0
 1de:	6a 1e                	push   $0x1e
 1e0:	68 00 00 00 00       	push   $0x0
 1e5:	e8 27 04 00 00       	call   611 <thread_create>
 1ea:	83 c4 10             	add    $0x10,%esp
 1ed:	83 f8 ff             	cmp    $0xffffffff,%eax
 1f0:	74 17                	je     209 <main+0x1db>
		printf(1, "FIVEWRONG\n");
 1f2:	83 ec 08             	sub    $0x8,%esp
 1f5:	68 01 0b 00 00       	push   $0xb01
 1fa:	6a 01                	push   $0x1
 1fc:	e8 0f 05 00 00       	call   710 <printf>
 201:	83 c4 10             	add    $0x10,%esp
		exit();
 204:	e8 60 03 00 00       	call   569 <exit>
	}

	for(i=0;i<NTHREAD-1;i++){
 209:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 210:	eb 43                	jmp    255 <main+0x227>
		if(thread_join(tid[i], &retval[i]) == -1){
 212:	8b 45 f4             	mov    -0xc(%ebp),%eax
 215:	c1 e0 02             	shl    $0x2,%eax
 218:	8d 90 40 0e 00 00    	lea    0xe40(%eax),%edx
 21e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 221:	8b 04 85 20 0e 00 00 	mov    0xe20(,%eax,4),%eax
 228:	83 ec 08             	sub    $0x8,%esp
 22b:	52                   	push   %edx
 22c:	50                   	push   %eax
 22d:	e8 ef 03 00 00       	call   621 <thread_join>
 232:	83 c4 10             	add    $0x10,%esp
 235:	83 f8 ff             	cmp    $0xffffffff,%eax
 238:	75 17                	jne    251 <main+0x223>
			printf(1, "SIXWRONG\n");
 23a:	83 ec 08             	sub    $0x8,%esp
 23d:	68 0c 0b 00 00       	push   $0xb0c
 242:	6a 01                	push   $0x1
 244:	e8 c7 04 00 00       	call   710 <printf>
 249:	83 c4 10             	add    $0x10,%esp
			exit();
 24c:	e8 18 03 00 00       	call   569 <exit>
	if(thread_create(thread, 30, 0, stack[NTHREAD-1]) != -1){
		printf(1, "FIVEWRONG\n");
		exit();
	}

	for(i=0;i<NTHREAD-1;i++){
 251:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 255:	83 7d f4 06          	cmpl   $0x6,-0xc(%ebp)
 259:	7e b7                	jle    212 <main+0x1e4>
			printf(1, "SIXWRONG\n");
			exit();
		}
	}

	for(i=0;i<NTHREAD-1;i++){
 25b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 262:	eb 52                	jmp    2b6 <main+0x288>
		tid[i] = thread_create(thread2, 30, 0, stack[i]);
 264:	8b 45 f4             	mov    -0xc(%ebp),%eax
 267:	8b 04 85 00 0e 00 00 	mov    0xe00(,%eax,4),%eax
 26e:	50                   	push   %eax
 26f:	6a 00                	push   $0x0
 271:	6a 1e                	push   $0x1e
 273:	68 11 00 00 00       	push   $0x11
 278:	e8 94 03 00 00       	call   611 <thread_create>
 27d:	83 c4 10             	add    $0x10,%esp
 280:	89 c2                	mov    %eax,%edx
 282:	8b 45 f4             	mov    -0xc(%ebp),%eax
 285:	89 14 85 20 0e 00 00 	mov    %edx,0xe20(,%eax,4)
		if(tid[i] == -1){
 28c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 28f:	8b 04 85 20 0e 00 00 	mov    0xe20(,%eax,4),%eax
 296:	83 f8 ff             	cmp    $0xffffffff,%eax
 299:	75 17                	jne    2b2 <main+0x284>
			printf(1, "SEVENWRONG\n");
 29b:	83 ec 08             	sub    $0x8,%esp
 29e:	68 16 0b 00 00       	push   $0xb16
 2a3:	6a 01                	push   $0x1
 2a5:	e8 66 04 00 00       	call   710 <printf>
 2aa:	83 c4 10             	add    $0x10,%esp
			exit();
 2ad:	e8 b7 02 00 00       	call   569 <exit>
			printf(1, "SIXWRONG\n");
			exit();
		}
	}

	for(i=0;i<NTHREAD-1;i++){
 2b2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 2b6:	83 7d f4 06          	cmpl   $0x6,-0xc(%ebp)
 2ba:	7e a8                	jle    264 <main+0x236>
			printf(1, "SEVENWRONG\n");
			exit();
		}
	}

	thread_join(tid[0], &retval[0]);
 2bc:	a1 20 0e 00 00       	mov    0xe20,%eax
 2c1:	83 ec 08             	sub    $0x8,%esp
 2c4:	68 40 0e 00 00       	push   $0xe40
 2c9:	50                   	push   %eax
 2ca:	e8 52 03 00 00       	call   621 <thread_join>
 2cf:	83 c4 10             	add    $0x10,%esp

	for(i=0;i<NTHREAD;i++)
 2d2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2d9:	eb 1a                	jmp    2f5 <main+0x2c7>
		free(stack[i]);
 2db:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2de:	8b 04 85 00 0e 00 00 	mov    0xe00(,%eax,4),%eax
 2e5:	83 ec 0c             	sub    $0xc,%esp
 2e8:	50                   	push   %eax
 2e9:	e8 b3 05 00 00       	call   8a1 <free>
 2ee:	83 c4 10             	add    $0x10,%esp
		}
	}

	thread_join(tid[0], &retval[0]);

	for(i=0;i<NTHREAD;i++)
 2f1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 2f5:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
 2f9:	7e e0                	jle    2db <main+0x2ad>
		free(stack[i]);

	printf(1, "WRONG\n");
 2fb:	83 ec 08             	sub    $0x8,%esp
 2fe:	68 22 0b 00 00       	push   $0xb22
 303:	6a 01                	push   $0x1
 305:	e8 06 04 00 00       	call   710 <printf>
 30a:	83 c4 10             	add    $0x10,%esp

	exit();
 30d:	e8 57 02 00 00       	call   569 <exit>

00000312 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 312:	55                   	push   %ebp
 313:	89 e5                	mov    %esp,%ebp
 315:	57                   	push   %edi
 316:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 317:	8b 4d 08             	mov    0x8(%ebp),%ecx
 31a:	8b 55 10             	mov    0x10(%ebp),%edx
 31d:	8b 45 0c             	mov    0xc(%ebp),%eax
 320:	89 cb                	mov    %ecx,%ebx
 322:	89 df                	mov    %ebx,%edi
 324:	89 d1                	mov    %edx,%ecx
 326:	fc                   	cld    
 327:	f3 aa                	rep stos %al,%es:(%edi)
 329:	89 ca                	mov    %ecx,%edx
 32b:	89 fb                	mov    %edi,%ebx
 32d:	89 5d 08             	mov    %ebx,0x8(%ebp)
 330:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 333:	90                   	nop
 334:	5b                   	pop    %ebx
 335:	5f                   	pop    %edi
 336:	5d                   	pop    %ebp
 337:	c3                   	ret    

00000338 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 338:	55                   	push   %ebp
 339:	89 e5                	mov    %esp,%ebp
 33b:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 33e:	8b 45 08             	mov    0x8(%ebp),%eax
 341:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 344:	90                   	nop
 345:	8b 45 08             	mov    0x8(%ebp),%eax
 348:	8d 50 01             	lea    0x1(%eax),%edx
 34b:	89 55 08             	mov    %edx,0x8(%ebp)
 34e:	8b 55 0c             	mov    0xc(%ebp),%edx
 351:	8d 4a 01             	lea    0x1(%edx),%ecx
 354:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 357:	0f b6 12             	movzbl (%edx),%edx
 35a:	88 10                	mov    %dl,(%eax)
 35c:	0f b6 00             	movzbl (%eax),%eax
 35f:	84 c0                	test   %al,%al
 361:	75 e2                	jne    345 <strcpy+0xd>
    ;
  return os;
 363:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 366:	c9                   	leave  
 367:	c3                   	ret    

00000368 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 368:	55                   	push   %ebp
 369:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 36b:	eb 08                	jmp    375 <strcmp+0xd>
    p++, q++;
 36d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 371:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 375:	8b 45 08             	mov    0x8(%ebp),%eax
 378:	0f b6 00             	movzbl (%eax),%eax
 37b:	84 c0                	test   %al,%al
 37d:	74 10                	je     38f <strcmp+0x27>
 37f:	8b 45 08             	mov    0x8(%ebp),%eax
 382:	0f b6 10             	movzbl (%eax),%edx
 385:	8b 45 0c             	mov    0xc(%ebp),%eax
 388:	0f b6 00             	movzbl (%eax),%eax
 38b:	38 c2                	cmp    %al,%dl
 38d:	74 de                	je     36d <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 38f:	8b 45 08             	mov    0x8(%ebp),%eax
 392:	0f b6 00             	movzbl (%eax),%eax
 395:	0f b6 d0             	movzbl %al,%edx
 398:	8b 45 0c             	mov    0xc(%ebp),%eax
 39b:	0f b6 00             	movzbl (%eax),%eax
 39e:	0f b6 c0             	movzbl %al,%eax
 3a1:	29 c2                	sub    %eax,%edx
 3a3:	89 d0                	mov    %edx,%eax
}
 3a5:	5d                   	pop    %ebp
 3a6:	c3                   	ret    

000003a7 <strlen>:

uint
strlen(char *s)
{
 3a7:	55                   	push   %ebp
 3a8:	89 e5                	mov    %esp,%ebp
 3aa:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 3ad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3b4:	eb 04                	jmp    3ba <strlen+0x13>
 3b6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 3ba:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3bd:	8b 45 08             	mov    0x8(%ebp),%eax
 3c0:	01 d0                	add    %edx,%eax
 3c2:	0f b6 00             	movzbl (%eax),%eax
 3c5:	84 c0                	test   %al,%al
 3c7:	75 ed                	jne    3b6 <strlen+0xf>
    ;
  return n;
 3c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3cc:	c9                   	leave  
 3cd:	c3                   	ret    

000003ce <memset>:

void*
memset(void *dst, int c, uint n)
{
 3ce:	55                   	push   %ebp
 3cf:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 3d1:	8b 45 10             	mov    0x10(%ebp),%eax
 3d4:	50                   	push   %eax
 3d5:	ff 75 0c             	pushl  0xc(%ebp)
 3d8:	ff 75 08             	pushl  0x8(%ebp)
 3db:	e8 32 ff ff ff       	call   312 <stosb>
 3e0:	83 c4 0c             	add    $0xc,%esp
  return dst;
 3e3:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3e6:	c9                   	leave  
 3e7:	c3                   	ret    

000003e8 <strchr>:

char*
strchr(const char *s, char c)
{
 3e8:	55                   	push   %ebp
 3e9:	89 e5                	mov    %esp,%ebp
 3eb:	83 ec 04             	sub    $0x4,%esp
 3ee:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f1:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 3f4:	eb 14                	jmp    40a <strchr+0x22>
    if(*s == c)
 3f6:	8b 45 08             	mov    0x8(%ebp),%eax
 3f9:	0f b6 00             	movzbl (%eax),%eax
 3fc:	3a 45 fc             	cmp    -0x4(%ebp),%al
 3ff:	75 05                	jne    406 <strchr+0x1e>
      return (char*)s;
 401:	8b 45 08             	mov    0x8(%ebp),%eax
 404:	eb 13                	jmp    419 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 406:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 40a:	8b 45 08             	mov    0x8(%ebp),%eax
 40d:	0f b6 00             	movzbl (%eax),%eax
 410:	84 c0                	test   %al,%al
 412:	75 e2                	jne    3f6 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 414:	b8 00 00 00 00       	mov    $0x0,%eax
}
 419:	c9                   	leave  
 41a:	c3                   	ret    

0000041b <gets>:

char*
gets(char *buf, int max)
{
 41b:	55                   	push   %ebp
 41c:	89 e5                	mov    %esp,%ebp
 41e:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 421:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 428:	eb 42                	jmp    46c <gets+0x51>
    cc = read(0, &c, 1);
 42a:	83 ec 04             	sub    $0x4,%esp
 42d:	6a 01                	push   $0x1
 42f:	8d 45 ef             	lea    -0x11(%ebp),%eax
 432:	50                   	push   %eax
 433:	6a 00                	push   $0x0
 435:	e8 47 01 00 00       	call   581 <read>
 43a:	83 c4 10             	add    $0x10,%esp
 43d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 440:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 444:	7e 33                	jle    479 <gets+0x5e>
      break;
    buf[i++] = c;
 446:	8b 45 f4             	mov    -0xc(%ebp),%eax
 449:	8d 50 01             	lea    0x1(%eax),%edx
 44c:	89 55 f4             	mov    %edx,-0xc(%ebp)
 44f:	89 c2                	mov    %eax,%edx
 451:	8b 45 08             	mov    0x8(%ebp),%eax
 454:	01 c2                	add    %eax,%edx
 456:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 45a:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 45c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 460:	3c 0a                	cmp    $0xa,%al
 462:	74 16                	je     47a <gets+0x5f>
 464:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 468:	3c 0d                	cmp    $0xd,%al
 46a:	74 0e                	je     47a <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 46c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 46f:	83 c0 01             	add    $0x1,%eax
 472:	3b 45 0c             	cmp    0xc(%ebp),%eax
 475:	7c b3                	jl     42a <gets+0xf>
 477:	eb 01                	jmp    47a <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 479:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 47a:	8b 55 f4             	mov    -0xc(%ebp),%edx
 47d:	8b 45 08             	mov    0x8(%ebp),%eax
 480:	01 d0                	add    %edx,%eax
 482:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 485:	8b 45 08             	mov    0x8(%ebp),%eax
}
 488:	c9                   	leave  
 489:	c3                   	ret    

0000048a <stat>:

int
stat(char *n, struct stat *st)
{
 48a:	55                   	push   %ebp
 48b:	89 e5                	mov    %esp,%ebp
 48d:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 490:	83 ec 08             	sub    $0x8,%esp
 493:	6a 00                	push   $0x0
 495:	ff 75 08             	pushl  0x8(%ebp)
 498:	e8 0c 01 00 00       	call   5a9 <open>
 49d:	83 c4 10             	add    $0x10,%esp
 4a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 4a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4a7:	79 07                	jns    4b0 <stat+0x26>
    return -1;
 4a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 4ae:	eb 25                	jmp    4d5 <stat+0x4b>
  r = fstat(fd, st);
 4b0:	83 ec 08             	sub    $0x8,%esp
 4b3:	ff 75 0c             	pushl  0xc(%ebp)
 4b6:	ff 75 f4             	pushl  -0xc(%ebp)
 4b9:	e8 03 01 00 00       	call   5c1 <fstat>
 4be:	83 c4 10             	add    $0x10,%esp
 4c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 4c4:	83 ec 0c             	sub    $0xc,%esp
 4c7:	ff 75 f4             	pushl  -0xc(%ebp)
 4ca:	e8 c2 00 00 00       	call   591 <close>
 4cf:	83 c4 10             	add    $0x10,%esp
  return r;
 4d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 4d5:	c9                   	leave  
 4d6:	c3                   	ret    

000004d7 <atoi>:

int
atoi(const char *s)
{
 4d7:	55                   	push   %ebp
 4d8:	89 e5                	mov    %esp,%ebp
 4da:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 4dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 4e4:	eb 25                	jmp    50b <atoi+0x34>
    n = n*10 + *s++ - '0';
 4e6:	8b 55 fc             	mov    -0x4(%ebp),%edx
 4e9:	89 d0                	mov    %edx,%eax
 4eb:	c1 e0 02             	shl    $0x2,%eax
 4ee:	01 d0                	add    %edx,%eax
 4f0:	01 c0                	add    %eax,%eax
 4f2:	89 c1                	mov    %eax,%ecx
 4f4:	8b 45 08             	mov    0x8(%ebp),%eax
 4f7:	8d 50 01             	lea    0x1(%eax),%edx
 4fa:	89 55 08             	mov    %edx,0x8(%ebp)
 4fd:	0f b6 00             	movzbl (%eax),%eax
 500:	0f be c0             	movsbl %al,%eax
 503:	01 c8                	add    %ecx,%eax
 505:	83 e8 30             	sub    $0x30,%eax
 508:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 50b:	8b 45 08             	mov    0x8(%ebp),%eax
 50e:	0f b6 00             	movzbl (%eax),%eax
 511:	3c 2f                	cmp    $0x2f,%al
 513:	7e 0a                	jle    51f <atoi+0x48>
 515:	8b 45 08             	mov    0x8(%ebp),%eax
 518:	0f b6 00             	movzbl (%eax),%eax
 51b:	3c 39                	cmp    $0x39,%al
 51d:	7e c7                	jle    4e6 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 51f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 522:	c9                   	leave  
 523:	c3                   	ret    

00000524 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 524:	55                   	push   %ebp
 525:	89 e5                	mov    %esp,%ebp
 527:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 52a:	8b 45 08             	mov    0x8(%ebp),%eax
 52d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 530:	8b 45 0c             	mov    0xc(%ebp),%eax
 533:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 536:	eb 17                	jmp    54f <memmove+0x2b>
    *dst++ = *src++;
 538:	8b 45 fc             	mov    -0x4(%ebp),%eax
 53b:	8d 50 01             	lea    0x1(%eax),%edx
 53e:	89 55 fc             	mov    %edx,-0x4(%ebp)
 541:	8b 55 f8             	mov    -0x8(%ebp),%edx
 544:	8d 4a 01             	lea    0x1(%edx),%ecx
 547:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 54a:	0f b6 12             	movzbl (%edx),%edx
 54d:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 54f:	8b 45 10             	mov    0x10(%ebp),%eax
 552:	8d 50 ff             	lea    -0x1(%eax),%edx
 555:	89 55 10             	mov    %edx,0x10(%ebp)
 558:	85 c0                	test   %eax,%eax
 55a:	7f dc                	jg     538 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 55c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 55f:	c9                   	leave  
 560:	c3                   	ret    

00000561 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 561:	b8 01 00 00 00       	mov    $0x1,%eax
 566:	cd 40                	int    $0x40
 568:	c3                   	ret    

00000569 <exit>:
SYSCALL(exit)
 569:	b8 02 00 00 00       	mov    $0x2,%eax
 56e:	cd 40                	int    $0x40
 570:	c3                   	ret    

00000571 <wait>:
SYSCALL(wait)
 571:	b8 03 00 00 00       	mov    $0x3,%eax
 576:	cd 40                	int    $0x40
 578:	c3                   	ret    

00000579 <pipe>:
SYSCALL(pipe)
 579:	b8 04 00 00 00       	mov    $0x4,%eax
 57e:	cd 40                	int    $0x40
 580:	c3                   	ret    

00000581 <read>:
SYSCALL(read)
 581:	b8 05 00 00 00       	mov    $0x5,%eax
 586:	cd 40                	int    $0x40
 588:	c3                   	ret    

00000589 <write>:
SYSCALL(write)
 589:	b8 10 00 00 00       	mov    $0x10,%eax
 58e:	cd 40                	int    $0x40
 590:	c3                   	ret    

00000591 <close>:
SYSCALL(close)
 591:	b8 15 00 00 00       	mov    $0x15,%eax
 596:	cd 40                	int    $0x40
 598:	c3                   	ret    

00000599 <kill>:
SYSCALL(kill)
 599:	b8 06 00 00 00       	mov    $0x6,%eax
 59e:	cd 40                	int    $0x40
 5a0:	c3                   	ret    

000005a1 <exec>:
SYSCALL(exec)
 5a1:	b8 07 00 00 00       	mov    $0x7,%eax
 5a6:	cd 40                	int    $0x40
 5a8:	c3                   	ret    

000005a9 <open>:
SYSCALL(open)
 5a9:	b8 0f 00 00 00       	mov    $0xf,%eax
 5ae:	cd 40                	int    $0x40
 5b0:	c3                   	ret    

000005b1 <mknod>:
SYSCALL(mknod)
 5b1:	b8 11 00 00 00       	mov    $0x11,%eax
 5b6:	cd 40                	int    $0x40
 5b8:	c3                   	ret    

000005b9 <unlink>:
SYSCALL(unlink)
 5b9:	b8 12 00 00 00       	mov    $0x12,%eax
 5be:	cd 40                	int    $0x40
 5c0:	c3                   	ret    

000005c1 <fstat>:
SYSCALL(fstat)
 5c1:	b8 08 00 00 00       	mov    $0x8,%eax
 5c6:	cd 40                	int    $0x40
 5c8:	c3                   	ret    

000005c9 <link>:
SYSCALL(link)
 5c9:	b8 13 00 00 00       	mov    $0x13,%eax
 5ce:	cd 40                	int    $0x40
 5d0:	c3                   	ret    

000005d1 <mkdir>:
SYSCALL(mkdir)
 5d1:	b8 14 00 00 00       	mov    $0x14,%eax
 5d6:	cd 40                	int    $0x40
 5d8:	c3                   	ret    

000005d9 <chdir>:
SYSCALL(chdir)
 5d9:	b8 09 00 00 00       	mov    $0x9,%eax
 5de:	cd 40                	int    $0x40
 5e0:	c3                   	ret    

000005e1 <dup>:
SYSCALL(dup)
 5e1:	b8 0a 00 00 00       	mov    $0xa,%eax
 5e6:	cd 40                	int    $0x40
 5e8:	c3                   	ret    

000005e9 <getpid>:
SYSCALL(getpid)
 5e9:	b8 0b 00 00 00       	mov    $0xb,%eax
 5ee:	cd 40                	int    $0x40
 5f0:	c3                   	ret    

000005f1 <sbrk>:
SYSCALL(sbrk)
 5f1:	b8 0c 00 00 00       	mov    $0xc,%eax
 5f6:	cd 40                	int    $0x40
 5f8:	c3                   	ret    

000005f9 <sleep>:
SYSCALL(sleep)
 5f9:	b8 0d 00 00 00       	mov    $0xd,%eax
 5fe:	cd 40                	int    $0x40
 600:	c3                   	ret    

00000601 <uptime>:
SYSCALL(uptime)
 601:	b8 0e 00 00 00       	mov    $0xe,%eax
 606:	cd 40                	int    $0x40
 608:	c3                   	ret    

00000609 <halt>:
SYSCALL(halt)
 609:	b8 16 00 00 00       	mov    $0x16,%eax
 60e:	cd 40                	int    $0x40
 610:	c3                   	ret    

00000611 <thread_create>:
SYSCALL(thread_create)
 611:	b8 17 00 00 00       	mov    $0x17,%eax
 616:	cd 40                	int    $0x40
 618:	c3                   	ret    

00000619 <thread_exit>:
SYSCALL(thread_exit)
 619:	b8 18 00 00 00       	mov    $0x18,%eax
 61e:	cd 40                	int    $0x40
 620:	c3                   	ret    

00000621 <thread_join>:
SYSCALL(thread_join)
 621:	b8 19 00 00 00       	mov    $0x19,%eax
 626:	cd 40                	int    $0x40
 628:	c3                   	ret    

00000629 <gettid>:
SYSCALL(gettid)
 629:	b8 1a 00 00 00       	mov    $0x1a,%eax
 62e:	cd 40                	int    $0x40
 630:	c3                   	ret    

00000631 <clone>:
SYSCALL(clone)
 631:	b8 1b 00 00 00       	mov    $0x1b,%eax
 636:	cd 40                	int    $0x40
 638:	c3                   	ret    

00000639 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 639:	55                   	push   %ebp
 63a:	89 e5                	mov    %esp,%ebp
 63c:	83 ec 18             	sub    $0x18,%esp
 63f:	8b 45 0c             	mov    0xc(%ebp),%eax
 642:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 645:	83 ec 04             	sub    $0x4,%esp
 648:	6a 01                	push   $0x1
 64a:	8d 45 f4             	lea    -0xc(%ebp),%eax
 64d:	50                   	push   %eax
 64e:	ff 75 08             	pushl  0x8(%ebp)
 651:	e8 33 ff ff ff       	call   589 <write>
 656:	83 c4 10             	add    $0x10,%esp
}
 659:	90                   	nop
 65a:	c9                   	leave  
 65b:	c3                   	ret    

0000065c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 65c:	55                   	push   %ebp
 65d:	89 e5                	mov    %esp,%ebp
 65f:	53                   	push   %ebx
 660:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 663:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 66a:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 66e:	74 17                	je     687 <printint+0x2b>
 670:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 674:	79 11                	jns    687 <printint+0x2b>
    neg = 1;
 676:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 67d:	8b 45 0c             	mov    0xc(%ebp),%eax
 680:	f7 d8                	neg    %eax
 682:	89 45 ec             	mov    %eax,-0x14(%ebp)
 685:	eb 06                	jmp    68d <printint+0x31>
  } else {
    x = xx;
 687:	8b 45 0c             	mov    0xc(%ebp),%eax
 68a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 68d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 694:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 697:	8d 41 01             	lea    0x1(%ecx),%eax
 69a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 69d:	8b 5d 10             	mov    0x10(%ebp),%ebx
 6a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6a3:	ba 00 00 00 00       	mov    $0x0,%edx
 6a8:	f7 f3                	div    %ebx
 6aa:	89 d0                	mov    %edx,%eax
 6ac:	0f b6 80 b0 0d 00 00 	movzbl 0xdb0(%eax),%eax
 6b3:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 6b7:	8b 5d 10             	mov    0x10(%ebp),%ebx
 6ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6bd:	ba 00 00 00 00       	mov    $0x0,%edx
 6c2:	f7 f3                	div    %ebx
 6c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6c7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6cb:	75 c7                	jne    694 <printint+0x38>
  if(neg)
 6cd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6d1:	74 2d                	je     700 <printint+0xa4>
    buf[i++] = '-';
 6d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6d6:	8d 50 01             	lea    0x1(%eax),%edx
 6d9:	89 55 f4             	mov    %edx,-0xc(%ebp)
 6dc:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 6e1:	eb 1d                	jmp    700 <printint+0xa4>
    putc(fd, buf[i]);
 6e3:	8d 55 dc             	lea    -0x24(%ebp),%edx
 6e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6e9:	01 d0                	add    %edx,%eax
 6eb:	0f b6 00             	movzbl (%eax),%eax
 6ee:	0f be c0             	movsbl %al,%eax
 6f1:	83 ec 08             	sub    $0x8,%esp
 6f4:	50                   	push   %eax
 6f5:	ff 75 08             	pushl  0x8(%ebp)
 6f8:	e8 3c ff ff ff       	call   639 <putc>
 6fd:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 700:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 704:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 708:	79 d9                	jns    6e3 <printint+0x87>
    putc(fd, buf[i]);
}
 70a:	90                   	nop
 70b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 70e:	c9                   	leave  
 70f:	c3                   	ret    

00000710 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 710:	55                   	push   %ebp
 711:	89 e5                	mov    %esp,%ebp
 713:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 716:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 71d:	8d 45 0c             	lea    0xc(%ebp),%eax
 720:	83 c0 04             	add    $0x4,%eax
 723:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 726:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 72d:	e9 59 01 00 00       	jmp    88b <printf+0x17b>
    c = fmt[i] & 0xff;
 732:	8b 55 0c             	mov    0xc(%ebp),%edx
 735:	8b 45 f0             	mov    -0x10(%ebp),%eax
 738:	01 d0                	add    %edx,%eax
 73a:	0f b6 00             	movzbl (%eax),%eax
 73d:	0f be c0             	movsbl %al,%eax
 740:	25 ff 00 00 00       	and    $0xff,%eax
 745:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 748:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 74c:	75 2c                	jne    77a <printf+0x6a>
      if(c == '%'){
 74e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 752:	75 0c                	jne    760 <printf+0x50>
        state = '%';
 754:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 75b:	e9 27 01 00 00       	jmp    887 <printf+0x177>
      } else {
        putc(fd, c);
 760:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 763:	0f be c0             	movsbl %al,%eax
 766:	83 ec 08             	sub    $0x8,%esp
 769:	50                   	push   %eax
 76a:	ff 75 08             	pushl  0x8(%ebp)
 76d:	e8 c7 fe ff ff       	call   639 <putc>
 772:	83 c4 10             	add    $0x10,%esp
 775:	e9 0d 01 00 00       	jmp    887 <printf+0x177>
      }
    } else if(state == '%'){
 77a:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 77e:	0f 85 03 01 00 00    	jne    887 <printf+0x177>
      if(c == 'd'){
 784:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 788:	75 1e                	jne    7a8 <printf+0x98>
        printint(fd, *ap, 10, 1);
 78a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 78d:	8b 00                	mov    (%eax),%eax
 78f:	6a 01                	push   $0x1
 791:	6a 0a                	push   $0xa
 793:	50                   	push   %eax
 794:	ff 75 08             	pushl  0x8(%ebp)
 797:	e8 c0 fe ff ff       	call   65c <printint>
 79c:	83 c4 10             	add    $0x10,%esp
        ap++;
 79f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7a3:	e9 d8 00 00 00       	jmp    880 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 7a8:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 7ac:	74 06                	je     7b4 <printf+0xa4>
 7ae:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 7b2:	75 1e                	jne    7d2 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 7b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7b7:	8b 00                	mov    (%eax),%eax
 7b9:	6a 00                	push   $0x0
 7bb:	6a 10                	push   $0x10
 7bd:	50                   	push   %eax
 7be:	ff 75 08             	pushl  0x8(%ebp)
 7c1:	e8 96 fe ff ff       	call   65c <printint>
 7c6:	83 c4 10             	add    $0x10,%esp
        ap++;
 7c9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7cd:	e9 ae 00 00 00       	jmp    880 <printf+0x170>
      } else if(c == 's'){
 7d2:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 7d6:	75 43                	jne    81b <printf+0x10b>
        s = (char*)*ap;
 7d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7db:	8b 00                	mov    (%eax),%eax
 7dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 7e0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 7e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7e8:	75 25                	jne    80f <printf+0xff>
          s = "(null)";
 7ea:	c7 45 f4 29 0b 00 00 	movl   $0xb29,-0xc(%ebp)
        while(*s != 0){
 7f1:	eb 1c                	jmp    80f <printf+0xff>
          putc(fd, *s);
 7f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f6:	0f b6 00             	movzbl (%eax),%eax
 7f9:	0f be c0             	movsbl %al,%eax
 7fc:	83 ec 08             	sub    $0x8,%esp
 7ff:	50                   	push   %eax
 800:	ff 75 08             	pushl  0x8(%ebp)
 803:	e8 31 fe ff ff       	call   639 <putc>
 808:	83 c4 10             	add    $0x10,%esp
          s++;
 80b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 80f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 812:	0f b6 00             	movzbl (%eax),%eax
 815:	84 c0                	test   %al,%al
 817:	75 da                	jne    7f3 <printf+0xe3>
 819:	eb 65                	jmp    880 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 81b:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 81f:	75 1d                	jne    83e <printf+0x12e>
        putc(fd, *ap);
 821:	8b 45 e8             	mov    -0x18(%ebp),%eax
 824:	8b 00                	mov    (%eax),%eax
 826:	0f be c0             	movsbl %al,%eax
 829:	83 ec 08             	sub    $0x8,%esp
 82c:	50                   	push   %eax
 82d:	ff 75 08             	pushl  0x8(%ebp)
 830:	e8 04 fe ff ff       	call   639 <putc>
 835:	83 c4 10             	add    $0x10,%esp
        ap++;
 838:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 83c:	eb 42                	jmp    880 <printf+0x170>
      } else if(c == '%'){
 83e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 842:	75 17                	jne    85b <printf+0x14b>
        putc(fd, c);
 844:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 847:	0f be c0             	movsbl %al,%eax
 84a:	83 ec 08             	sub    $0x8,%esp
 84d:	50                   	push   %eax
 84e:	ff 75 08             	pushl  0x8(%ebp)
 851:	e8 e3 fd ff ff       	call   639 <putc>
 856:	83 c4 10             	add    $0x10,%esp
 859:	eb 25                	jmp    880 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 85b:	83 ec 08             	sub    $0x8,%esp
 85e:	6a 25                	push   $0x25
 860:	ff 75 08             	pushl  0x8(%ebp)
 863:	e8 d1 fd ff ff       	call   639 <putc>
 868:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 86b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 86e:	0f be c0             	movsbl %al,%eax
 871:	83 ec 08             	sub    $0x8,%esp
 874:	50                   	push   %eax
 875:	ff 75 08             	pushl  0x8(%ebp)
 878:	e8 bc fd ff ff       	call   639 <putc>
 87d:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 880:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 887:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 88b:	8b 55 0c             	mov    0xc(%ebp),%edx
 88e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 891:	01 d0                	add    %edx,%eax
 893:	0f b6 00             	movzbl (%eax),%eax
 896:	84 c0                	test   %al,%al
 898:	0f 85 94 fe ff ff    	jne    732 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 89e:	90                   	nop
 89f:	c9                   	leave  
 8a0:	c3                   	ret    

000008a1 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8a1:	55                   	push   %ebp
 8a2:	89 e5                	mov    %esp,%ebp
 8a4:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8a7:	8b 45 08             	mov    0x8(%ebp),%eax
 8aa:	83 e8 08             	sub    $0x8,%eax
 8ad:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8b0:	a1 e8 0d 00 00       	mov    0xde8,%eax
 8b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8b8:	eb 24                	jmp    8de <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8bd:	8b 00                	mov    (%eax),%eax
 8bf:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8c2:	77 12                	ja     8d6 <free+0x35>
 8c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8c7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8ca:	77 24                	ja     8f0 <free+0x4f>
 8cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8cf:	8b 00                	mov    (%eax),%eax
 8d1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8d4:	77 1a                	ja     8f0 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d9:	8b 00                	mov    (%eax),%eax
 8db:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8de:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8e1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8e4:	76 d4                	jbe    8ba <free+0x19>
 8e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8e9:	8b 00                	mov    (%eax),%eax
 8eb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8ee:	76 ca                	jbe    8ba <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 8f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8f3:	8b 40 04             	mov    0x4(%eax),%eax
 8f6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 900:	01 c2                	add    %eax,%edx
 902:	8b 45 fc             	mov    -0x4(%ebp),%eax
 905:	8b 00                	mov    (%eax),%eax
 907:	39 c2                	cmp    %eax,%edx
 909:	75 24                	jne    92f <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 90b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 90e:	8b 50 04             	mov    0x4(%eax),%edx
 911:	8b 45 fc             	mov    -0x4(%ebp),%eax
 914:	8b 00                	mov    (%eax),%eax
 916:	8b 40 04             	mov    0x4(%eax),%eax
 919:	01 c2                	add    %eax,%edx
 91b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 91e:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 921:	8b 45 fc             	mov    -0x4(%ebp),%eax
 924:	8b 00                	mov    (%eax),%eax
 926:	8b 10                	mov    (%eax),%edx
 928:	8b 45 f8             	mov    -0x8(%ebp),%eax
 92b:	89 10                	mov    %edx,(%eax)
 92d:	eb 0a                	jmp    939 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 92f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 932:	8b 10                	mov    (%eax),%edx
 934:	8b 45 f8             	mov    -0x8(%ebp),%eax
 937:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 939:	8b 45 fc             	mov    -0x4(%ebp),%eax
 93c:	8b 40 04             	mov    0x4(%eax),%eax
 93f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 946:	8b 45 fc             	mov    -0x4(%ebp),%eax
 949:	01 d0                	add    %edx,%eax
 94b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 94e:	75 20                	jne    970 <free+0xcf>
    p->s.size += bp->s.size;
 950:	8b 45 fc             	mov    -0x4(%ebp),%eax
 953:	8b 50 04             	mov    0x4(%eax),%edx
 956:	8b 45 f8             	mov    -0x8(%ebp),%eax
 959:	8b 40 04             	mov    0x4(%eax),%eax
 95c:	01 c2                	add    %eax,%edx
 95e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 961:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 964:	8b 45 f8             	mov    -0x8(%ebp),%eax
 967:	8b 10                	mov    (%eax),%edx
 969:	8b 45 fc             	mov    -0x4(%ebp),%eax
 96c:	89 10                	mov    %edx,(%eax)
 96e:	eb 08                	jmp    978 <free+0xd7>
  } else
    p->s.ptr = bp;
 970:	8b 45 fc             	mov    -0x4(%ebp),%eax
 973:	8b 55 f8             	mov    -0x8(%ebp),%edx
 976:	89 10                	mov    %edx,(%eax)
  freep = p;
 978:	8b 45 fc             	mov    -0x4(%ebp),%eax
 97b:	a3 e8 0d 00 00       	mov    %eax,0xde8
}
 980:	90                   	nop
 981:	c9                   	leave  
 982:	c3                   	ret    

00000983 <morecore>:

static Header*
morecore(uint nu)
{
 983:	55                   	push   %ebp
 984:	89 e5                	mov    %esp,%ebp
 986:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 989:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 990:	77 07                	ja     999 <morecore+0x16>
    nu = 4096;
 992:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 999:	8b 45 08             	mov    0x8(%ebp),%eax
 99c:	c1 e0 03             	shl    $0x3,%eax
 99f:	83 ec 0c             	sub    $0xc,%esp
 9a2:	50                   	push   %eax
 9a3:	e8 49 fc ff ff       	call   5f1 <sbrk>
 9a8:	83 c4 10             	add    $0x10,%esp
 9ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 9ae:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 9b2:	75 07                	jne    9bb <morecore+0x38>
    return 0;
 9b4:	b8 00 00 00 00       	mov    $0x0,%eax
 9b9:	eb 26                	jmp    9e1 <morecore+0x5e>
  hp = (Header*)p;
 9bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 9c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9c4:	8b 55 08             	mov    0x8(%ebp),%edx
 9c7:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 9ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9cd:	83 c0 08             	add    $0x8,%eax
 9d0:	83 ec 0c             	sub    $0xc,%esp
 9d3:	50                   	push   %eax
 9d4:	e8 c8 fe ff ff       	call   8a1 <free>
 9d9:	83 c4 10             	add    $0x10,%esp
  return freep;
 9dc:	a1 e8 0d 00 00       	mov    0xde8,%eax
}
 9e1:	c9                   	leave  
 9e2:	c3                   	ret    

000009e3 <malloc>:

void*
malloc(uint nbytes)
{
 9e3:	55                   	push   %ebp
 9e4:	89 e5                	mov    %esp,%ebp
 9e6:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9e9:	8b 45 08             	mov    0x8(%ebp),%eax
 9ec:	83 c0 07             	add    $0x7,%eax
 9ef:	c1 e8 03             	shr    $0x3,%eax
 9f2:	83 c0 01             	add    $0x1,%eax
 9f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 9f8:	a1 e8 0d 00 00       	mov    0xde8,%eax
 9fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a00:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a04:	75 23                	jne    a29 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 a06:	c7 45 f0 e0 0d 00 00 	movl   $0xde0,-0x10(%ebp)
 a0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a10:	a3 e8 0d 00 00       	mov    %eax,0xde8
 a15:	a1 e8 0d 00 00       	mov    0xde8,%eax
 a1a:	a3 e0 0d 00 00       	mov    %eax,0xde0
    base.s.size = 0;
 a1f:	c7 05 e4 0d 00 00 00 	movl   $0x0,0xde4
 a26:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a29:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a2c:	8b 00                	mov    (%eax),%eax
 a2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a31:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a34:	8b 40 04             	mov    0x4(%eax),%eax
 a37:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a3a:	72 4d                	jb     a89 <malloc+0xa6>
      if(p->s.size == nunits)
 a3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a3f:	8b 40 04             	mov    0x4(%eax),%eax
 a42:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a45:	75 0c                	jne    a53 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 a47:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a4a:	8b 10                	mov    (%eax),%edx
 a4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a4f:	89 10                	mov    %edx,(%eax)
 a51:	eb 26                	jmp    a79 <malloc+0x96>
      else {
        p->s.size -= nunits;
 a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a56:	8b 40 04             	mov    0x4(%eax),%eax
 a59:	2b 45 ec             	sub    -0x14(%ebp),%eax
 a5c:	89 c2                	mov    %eax,%edx
 a5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a61:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a64:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a67:	8b 40 04             	mov    0x4(%eax),%eax
 a6a:	c1 e0 03             	shl    $0x3,%eax
 a6d:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a73:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a76:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a79:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a7c:	a3 e8 0d 00 00       	mov    %eax,0xde8
      return (void*)(p + 1);
 a81:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a84:	83 c0 08             	add    $0x8,%eax
 a87:	eb 3b                	jmp    ac4 <malloc+0xe1>
    }
    if(p == freep)
 a89:	a1 e8 0d 00 00       	mov    0xde8,%eax
 a8e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a91:	75 1e                	jne    ab1 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 a93:	83 ec 0c             	sub    $0xc,%esp
 a96:	ff 75 ec             	pushl  -0x14(%ebp)
 a99:	e8 e5 fe ff ff       	call   983 <morecore>
 a9e:	83 c4 10             	add    $0x10,%esp
 aa1:	89 45 f4             	mov    %eax,-0xc(%ebp)
 aa4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 aa8:	75 07                	jne    ab1 <malloc+0xce>
        return 0;
 aaa:	b8 00 00 00 00       	mov    $0x0,%eax
 aaf:	eb 13                	jmp    ac4 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ab4:	89 45 f0             	mov    %eax,-0x10(%ebp)
 ab7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aba:	8b 00                	mov    (%eax),%eax
 abc:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 abf:	e9 6d ff ff ff       	jmp    a31 <malloc+0x4e>
}
 ac4:	c9                   	leave  
 ac5:	c3                   	ret    
