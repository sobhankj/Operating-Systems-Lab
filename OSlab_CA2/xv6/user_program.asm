
_user_program:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
            text[i] = ((ch - 'A' + key) % 26) + 'A';
        }
    }
}

int main(int argc, char *argv[]) {
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	83 ec 08             	sub    $0x8,%esp
  14:	8b 01                	mov    (%ecx),%eax
  16:	8b 51 04             	mov    0x4(%ecx),%edx
    if (argc < 3) {
  19:	83 f8 02             	cmp    $0x2,%eax
  1c:	0f 8e 91 00 00 00    	jle    b3 <main+0xb3>
        printf(1, "Usage: encode/decode text key\n");
        exit();
    }

    char *action = argv[1];
  22:	8b 7a 04             	mov    0x4(%edx),%edi
    char *text = argv[2];
  25:	8b 5a 08             	mov    0x8(%edx),%ebx
    int key = (argc == 4) ? atoi(argv[3]) : 20;
  28:	be 14 00 00 00       	mov    $0x14,%esi
  2d:	83 f8 04             	cmp    $0x4,%eax
  30:	0f 84 2c 01 00 00    	je     162 <main+0x162>

    if (strcmp(action, "encode") == 0) {
  36:	83 ec 08             	sub    $0x8,%esp
  39:	68 63 09 00 00       	push   $0x963
  3e:	57                   	push   %edi
  3f:	e8 0c 02 00 00       	call   250 <strcmp>
  44:	83 c4 10             	add    $0x10,%esp
  47:	85 c0                	test   %eax,%eax
  49:	75 3f                	jne    8a <main+0x8a>
        encode(text, key);
  4b:	50                   	push   %eax
  4c:	50                   	push   %eax
  4d:	56                   	push   %esi
  4e:	53                   	push   %ebx
  4f:	e8 3c 01 00 00       	call   190 <encode>
  54:	83 c4 10             	add    $0x10,%esp
    } else {
        printf(1, "Invalid action. Use 'encode' or 'decode'.\n");
        exit();
    }

    int text_len = strlen(text);
  57:	83 ec 0c             	sub    $0xc,%esp
  5a:	53                   	push   %ebx
  5b:	e8 50 02 00 00       	call   2b0 <strlen>
    char new_text[text_len + 2];
  60:	83 c4 10             	add    $0x10,%esp
    int text_len = strlen(text);
  63:	89 c6                	mov    %eax,%esi
    char new_text[text_len + 2];
  65:	8d 40 11             	lea    0x11(%eax),%eax
  68:	89 e1                	mov    %esp,%ecx
  6a:	89 c2                	mov    %eax,%edx
  6c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  71:	83 e2 f0             	and    $0xfffffff0,%edx
  74:	29 c1                	sub    %eax,%ecx
  76:	39 cc                	cmp    %ecx,%esp
  78:	74 5f                	je     d9 <main+0xd9>
  7a:	81 ec 00 10 00 00    	sub    $0x1000,%esp
  80:	83 8c 24 fc 0f 00 00 	orl    $0x0,0xffc(%esp)
  87:	00 
  88:	eb ec                	jmp    76 <main+0x76>
    } else if (strcmp(action, "decode") == 0) {
  8a:	50                   	push   %eax
  8b:	50                   	push   %eax
  8c:	68 6a 09 00 00       	push   $0x96a
  91:	57                   	push   %edi
  92:	e8 b9 01 00 00       	call   250 <strcmp>
  97:	83 c4 10             	add    $0x10,%esp
  9a:	85 c0                	test   %eax,%eax
  9c:	75 28                	jne    c6 <main+0xc6>
        encode(text, 26 - key);
  9e:	50                   	push   %eax
  9f:	50                   	push   %eax
  a0:	b8 1a 00 00 00       	mov    $0x1a,%eax
  a5:	29 f0                	sub    %esi,%eax
  a7:	50                   	push   %eax
  a8:	53                   	push   %ebx
  a9:	e8 e2 00 00 00       	call   190 <encode>
  ae:	83 c4 10             	add    $0x10,%esp
  b1:	eb a4                	jmp    57 <main+0x57>
        printf(1, "Usage: encode/decode text key\n");
  b3:	50                   	push   %eax
  b4:	50                   	push   %eax
  b5:	68 18 09 00 00       	push   $0x918
  ba:	6a 01                	push   $0x1
  bc:	e8 2f 05 00 00       	call   5f0 <printf>
        exit();
  c1:	e8 ad 03 00 00       	call   473 <exit>
        printf(1, "Invalid action. Use 'encode' or 'decode'.\n");
  c6:	57                   	push   %edi
  c7:	57                   	push   %edi
  c8:	68 38 09 00 00       	push   $0x938
  cd:	6a 01                	push   $0x1
  cf:	e8 1c 05 00 00       	call   5f0 <printf>
        exit();
  d4:	e8 9a 03 00 00       	call   473 <exit>
    char new_text[text_len + 2];
  d9:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  df:	29 d4                	sub    %edx,%esp
  e1:	85 d2                	test   %edx,%edx
  e3:	74 05                	je     ea <main+0xea>
  e5:	83 4c 14 fc 00       	orl    $0x0,-0x4(%esp,%edx,1)
  ea:	89 e7                	mov    %esp,%edi
    strcpy(new_text, text);
  ec:	51                   	push   %ecx
  ed:	51                   	push   %ecx
  ee:	53                   	push   %ebx
  ef:	57                   	push   %edi
  f0:	e8 2b 01 00 00       	call   220 <strcpy>
    new_text[text_len] = '\n';
  f5:	c6 04 37 0a          	movb   $0xa,(%edi,%esi,1)
    new_text[text_len + 1] = '\0';
  f9:	c6 44 37 01 00       	movb   $0x0,0x1(%edi,%esi,1)

    int fd = open("result.txt", O_CREATE | O_WRONLY);
  fe:	5b                   	pop    %ebx
  ff:	5e                   	pop    %esi
 100:	68 01 02 00 00       	push   $0x201
 105:	68 71 09 00 00       	push   $0x971
 10a:	e8 a4 03 00 00       	call   4b3 <open>
    if (fd < 0) {
 10f:	89 fc                	mov    %edi,%esp
    int fd = open("result.txt", O_CREATE | O_WRONLY);
 111:	89 c6                	mov    %eax,%esi
    if (fd < 0) {
 113:	85 c0                	test   %eax,%eax
 115:	78 38                	js     14f <main+0x14f>
        printf(1, "Error: Cannot open the file\n");
        exit();
    }
    
    if (write(fd, new_text, strlen(new_text)) != strlen(new_text)) {
 117:	83 ec 0c             	sub    $0xc,%esp
 11a:	57                   	push   %edi
 11b:	e8 90 01 00 00       	call   2b0 <strlen>
 120:	83 c4 0c             	add    $0xc,%esp
 123:	50                   	push   %eax
 124:	57                   	push   %edi
 125:	56                   	push   %esi
 126:	e8 68 03 00 00       	call   493 <write>
 12b:	89 3c 24             	mov    %edi,(%esp)
 12e:	89 c3                	mov    %eax,%ebx
 130:	e8 7b 01 00 00       	call   2b0 <strlen>
 135:	83 c4 10             	add    $0x10,%esp
 138:	39 c3                	cmp    %eax,%ebx
 13a:	74 3b                	je     177 <main+0x177>
        printf(1, "Error writing to file\n");
 13c:	50                   	push   %eax
 13d:	50                   	push   %eax
 13e:	68 99 09 00 00       	push   $0x999
 143:	6a 01                	push   $0x1
 145:	e8 a6 04 00 00       	call   5f0 <printf>
        exit();
 14a:	e8 24 03 00 00       	call   473 <exit>
        printf(1, "Error: Cannot open the file\n");
 14f:	52                   	push   %edx
 150:	52                   	push   %edx
 151:	68 7c 09 00 00       	push   $0x97c
 156:	6a 01                	push   $0x1
 158:	e8 93 04 00 00       	call   5f0 <printf>
        exit();
 15d:	e8 11 03 00 00       	call   473 <exit>
    int key = (argc == 4) ? atoi(argv[3]) : 20;
 162:	83 ec 0c             	sub    $0xc,%esp
 165:	ff 72 0c             	push   0xc(%edx)
 168:	e8 93 02 00 00       	call   400 <atoi>
 16d:	83 c4 10             	add    $0x10,%esp
 170:	89 c6                	mov    %eax,%esi
 172:	e9 bf fe ff ff       	jmp    36 <main+0x36>
    }

    close(fd);
 177:	83 ec 0c             	sub    $0xc,%esp
 17a:	56                   	push   %esi
 17b:	e8 1b 03 00 00       	call   49b <close>
    exit();
 180:	e8 ee 02 00 00       	call   473 <exit>
 185:	66 90                	xchg   %ax,%ax
 187:	66 90                	xchg   %ax,%ax
 189:	66 90                	xchg   %ax,%ax
 18b:	66 90                	xchg   %ax,%ax
 18d:	66 90                	xchg   %ax,%ax
 18f:	90                   	nop

00000190 <encode>:
void encode(char *text, int key) {
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	57                   	push   %edi
 194:	56                   	push   %esi
 195:	8b 75 0c             	mov    0xc(%ebp),%esi
 198:	53                   	push   %ebx
 199:	8b 5d 08             	mov    0x8(%ebp),%ebx
    for (i = 0; text[i] != '\0'; i++) {
 19c:	0f b6 03             	movzbl (%ebx),%eax
 19f:	84 c0                	test   %al,%al
 1a1:	74 6d                	je     210 <encode+0x80>
            text[i] = ((ch - 'A' + key) % 26) + 'A';
 1a3:	bf 4f ec c4 4e       	mov    $0x4ec4ec4f,%edi
 1a8:	eb 2e                	jmp    1d8 <encode+0x48>
 1aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            text[i] = ((ch - 'a' + key) % 26) + 'a';
 1b0:	0f be c9             	movsbl %cl,%ecx
 1b3:	01 f1                	add    %esi,%ecx
 1b5:	89 c8                	mov    %ecx,%eax
 1b7:	f7 ef                	imul   %edi
 1b9:	89 c8                	mov    %ecx,%eax
 1bb:	c1 f8 1f             	sar    $0x1f,%eax
 1be:	c1 fa 03             	sar    $0x3,%edx
 1c1:	29 c2                	sub    %eax,%edx
 1c3:	6b d2 1a             	imul   $0x1a,%edx,%edx
 1c6:	29 d1                	sub    %edx,%ecx
 1c8:	83 c1 61             	add    $0x61,%ecx
 1cb:	88 0b                	mov    %cl,(%ebx)
    for (i = 0; text[i] != '\0'; i++) {
 1cd:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
 1d1:	83 c3 01             	add    $0x1,%ebx
 1d4:	84 c0                	test   %al,%al
 1d6:	74 38                	je     210 <encode+0x80>
        if (ch >= 'a' && ch <= 'z') {
 1d8:	8d 48 9f             	lea    -0x61(%eax),%ecx
 1db:	80 f9 19             	cmp    $0x19,%cl
 1de:	76 d0                	jbe    1b0 <encode+0x20>
        } else if (ch >= 'A' && ch <= 'Z') {
 1e0:	83 e8 41             	sub    $0x41,%eax
 1e3:	3c 19                	cmp    $0x19,%al
 1e5:	77 e6                	ja     1cd <encode+0x3d>
            text[i] = ((ch - 'A' + key) % 26) + 'A';
 1e7:	0f be c0             	movsbl %al,%eax
 1ea:	83 c3 01             	add    $0x1,%ebx
 1ed:	8d 0c 30             	lea    (%eax,%esi,1),%ecx
 1f0:	89 c8                	mov    %ecx,%eax
 1f2:	f7 ef                	imul   %edi
 1f4:	89 c8                	mov    %ecx,%eax
 1f6:	c1 f8 1f             	sar    $0x1f,%eax
 1f9:	c1 fa 03             	sar    $0x3,%edx
 1fc:	29 c2                	sub    %eax,%edx
 1fe:	6b d2 1a             	imul   $0x1a,%edx,%edx
 201:	29 d1                	sub    %edx,%ecx
 203:	83 c1 41             	add    $0x41,%ecx
 206:	88 4b ff             	mov    %cl,-0x1(%ebx)
    for (i = 0; text[i] != '\0'; i++) {
 209:	0f b6 03             	movzbl (%ebx),%eax
 20c:	84 c0                	test   %al,%al
 20e:	75 c8                	jne    1d8 <encode+0x48>
}
 210:	5b                   	pop    %ebx
 211:	5e                   	pop    %esi
 212:	5f                   	pop    %edi
 213:	5d                   	pop    %ebp
 214:	c3                   	ret    
 215:	66 90                	xchg   %ax,%ax
 217:	66 90                	xchg   %ax,%ax
 219:	66 90                	xchg   %ax,%ax
 21b:	66 90                	xchg   %ax,%ax
 21d:	66 90                	xchg   %ax,%ax
 21f:	90                   	nop

00000220 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 220:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 221:	31 c0                	xor    %eax,%eax
{
 223:	89 e5                	mov    %esp,%ebp
 225:	53                   	push   %ebx
 226:	8b 4d 08             	mov    0x8(%ebp),%ecx
 229:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 22c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 230:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 234:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 237:	83 c0 01             	add    $0x1,%eax
 23a:	84 d2                	test   %dl,%dl
 23c:	75 f2                	jne    230 <strcpy+0x10>
    ;
  return os;
}
 23e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 241:	89 c8                	mov    %ecx,%eax
 243:	c9                   	leave  
 244:	c3                   	ret    
 245:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 24c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000250 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 250:	55                   	push   %ebp
 251:	89 e5                	mov    %esp,%ebp
 253:	53                   	push   %ebx
 254:	8b 55 08             	mov    0x8(%ebp),%edx
 257:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 25a:	0f b6 02             	movzbl (%edx),%eax
 25d:	84 c0                	test   %al,%al
 25f:	75 17                	jne    278 <strcmp+0x28>
 261:	eb 3a                	jmp    29d <strcmp+0x4d>
 263:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 267:	90                   	nop
 268:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 26c:	83 c2 01             	add    $0x1,%edx
 26f:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 272:	84 c0                	test   %al,%al
 274:	74 1a                	je     290 <strcmp+0x40>
    p++, q++;
 276:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
 278:	0f b6 19             	movzbl (%ecx),%ebx
 27b:	38 c3                	cmp    %al,%bl
 27d:	74 e9                	je     268 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 27f:	29 d8                	sub    %ebx,%eax
}
 281:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 284:	c9                   	leave  
 285:	c3                   	ret    
 286:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 28d:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
 290:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 294:	31 c0                	xor    %eax,%eax
 296:	29 d8                	sub    %ebx,%eax
}
 298:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 29b:	c9                   	leave  
 29c:	c3                   	ret    
  return (uchar)*p - (uchar)*q;
 29d:	0f b6 19             	movzbl (%ecx),%ebx
 2a0:	31 c0                	xor    %eax,%eax
 2a2:	eb db                	jmp    27f <strcmp+0x2f>
 2a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2af:	90                   	nop

000002b0 <strlen>:

uint
strlen(const char *s)
{
 2b0:	55                   	push   %ebp
 2b1:	89 e5                	mov    %esp,%ebp
 2b3:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 2b6:	80 3a 00             	cmpb   $0x0,(%edx)
 2b9:	74 15                	je     2d0 <strlen+0x20>
 2bb:	31 c0                	xor    %eax,%eax
 2bd:	8d 76 00             	lea    0x0(%esi),%esi
 2c0:	83 c0 01             	add    $0x1,%eax
 2c3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 2c7:	89 c1                	mov    %eax,%ecx
 2c9:	75 f5                	jne    2c0 <strlen+0x10>
    ;
  return n;
}
 2cb:	89 c8                	mov    %ecx,%eax
 2cd:	5d                   	pop    %ebp
 2ce:	c3                   	ret    
 2cf:	90                   	nop
  for(n = 0; s[n]; n++)
 2d0:	31 c9                	xor    %ecx,%ecx
}
 2d2:	5d                   	pop    %ebp
 2d3:	89 c8                	mov    %ecx,%eax
 2d5:	c3                   	ret    
 2d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2dd:	8d 76 00             	lea    0x0(%esi),%esi

000002e0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2e0:	55                   	push   %ebp
 2e1:	89 e5                	mov    %esp,%ebp
 2e3:	57                   	push   %edi
 2e4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 2e7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 2ea:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ed:	89 d7                	mov    %edx,%edi
 2ef:	fc                   	cld    
 2f0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 2f2:	8b 7d fc             	mov    -0x4(%ebp),%edi
 2f5:	89 d0                	mov    %edx,%eax
 2f7:	c9                   	leave  
 2f8:	c3                   	ret    
 2f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000300 <strchr>:

char*
strchr(const char *s, char c)
{
 300:	55                   	push   %ebp
 301:	89 e5                	mov    %esp,%ebp
 303:	8b 45 08             	mov    0x8(%ebp),%eax
 306:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 30a:	0f b6 10             	movzbl (%eax),%edx
 30d:	84 d2                	test   %dl,%dl
 30f:	75 12                	jne    323 <strchr+0x23>
 311:	eb 1d                	jmp    330 <strchr+0x30>
 313:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 317:	90                   	nop
 318:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 31c:	83 c0 01             	add    $0x1,%eax
 31f:	84 d2                	test   %dl,%dl
 321:	74 0d                	je     330 <strchr+0x30>
    if(*s == c)
 323:	38 d1                	cmp    %dl,%cl
 325:	75 f1                	jne    318 <strchr+0x18>
      return (char*)s;
  return 0;
}
 327:	5d                   	pop    %ebp
 328:	c3                   	ret    
 329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 330:	31 c0                	xor    %eax,%eax
}
 332:	5d                   	pop    %ebp
 333:	c3                   	ret    
 334:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 33b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 33f:	90                   	nop

00000340 <gets>:

char*
gets(char *buf, int max)
{
 340:	55                   	push   %ebp
 341:	89 e5                	mov    %esp,%ebp
 343:	57                   	push   %edi
 344:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 345:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 348:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 349:	31 db                	xor    %ebx,%ebx
{
 34b:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 34e:	eb 27                	jmp    377 <gets+0x37>
    cc = read(0, &c, 1);
 350:	83 ec 04             	sub    $0x4,%esp
 353:	6a 01                	push   $0x1
 355:	57                   	push   %edi
 356:	6a 00                	push   $0x0
 358:	e8 2e 01 00 00       	call   48b <read>
    if(cc < 1)
 35d:	83 c4 10             	add    $0x10,%esp
 360:	85 c0                	test   %eax,%eax
 362:	7e 1d                	jle    381 <gets+0x41>
      break;
    buf[i++] = c;
 364:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 368:	8b 55 08             	mov    0x8(%ebp),%edx
 36b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 36f:	3c 0a                	cmp    $0xa,%al
 371:	74 1d                	je     390 <gets+0x50>
 373:	3c 0d                	cmp    $0xd,%al
 375:	74 19                	je     390 <gets+0x50>
  for(i=0; i+1 < max; ){
 377:	89 de                	mov    %ebx,%esi
 379:	83 c3 01             	add    $0x1,%ebx
 37c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 37f:	7c cf                	jl     350 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 381:	8b 45 08             	mov    0x8(%ebp),%eax
 384:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 388:	8d 65 f4             	lea    -0xc(%ebp),%esp
 38b:	5b                   	pop    %ebx
 38c:	5e                   	pop    %esi
 38d:	5f                   	pop    %edi
 38e:	5d                   	pop    %ebp
 38f:	c3                   	ret    
  buf[i] = '\0';
 390:	8b 45 08             	mov    0x8(%ebp),%eax
 393:	89 de                	mov    %ebx,%esi
 395:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 399:	8d 65 f4             	lea    -0xc(%ebp),%esp
 39c:	5b                   	pop    %ebx
 39d:	5e                   	pop    %esi
 39e:	5f                   	pop    %edi
 39f:	5d                   	pop    %ebp
 3a0:	c3                   	ret    
 3a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3af:	90                   	nop

000003b0 <stat>:

int
stat(const char *n, struct stat *st)
{
 3b0:	55                   	push   %ebp
 3b1:	89 e5                	mov    %esp,%ebp
 3b3:	56                   	push   %esi
 3b4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3b5:	83 ec 08             	sub    $0x8,%esp
 3b8:	6a 00                	push   $0x0
 3ba:	ff 75 08             	push   0x8(%ebp)
 3bd:	e8 f1 00 00 00       	call   4b3 <open>
  if(fd < 0)
 3c2:	83 c4 10             	add    $0x10,%esp
 3c5:	85 c0                	test   %eax,%eax
 3c7:	78 27                	js     3f0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 3c9:	83 ec 08             	sub    $0x8,%esp
 3cc:	ff 75 0c             	push   0xc(%ebp)
 3cf:	89 c3                	mov    %eax,%ebx
 3d1:	50                   	push   %eax
 3d2:	e8 f4 00 00 00       	call   4cb <fstat>
  close(fd);
 3d7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 3da:	89 c6                	mov    %eax,%esi
  close(fd);
 3dc:	e8 ba 00 00 00       	call   49b <close>
  return r;
 3e1:	83 c4 10             	add    $0x10,%esp
}
 3e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 3e7:	89 f0                	mov    %esi,%eax
 3e9:	5b                   	pop    %ebx
 3ea:	5e                   	pop    %esi
 3eb:	5d                   	pop    %ebp
 3ec:	c3                   	ret    
 3ed:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 3f0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 3f5:	eb ed                	jmp    3e4 <stat+0x34>
 3f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3fe:	66 90                	xchg   %ax,%ax

00000400 <atoi>:

int
atoi(const char *s)
{
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	53                   	push   %ebx
 404:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 407:	0f be 02             	movsbl (%edx),%eax
 40a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 40d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 410:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 415:	77 1e                	ja     435 <atoi+0x35>
 417:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 41e:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 420:	83 c2 01             	add    $0x1,%edx
 423:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 426:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 42a:	0f be 02             	movsbl (%edx),%eax
 42d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 430:	80 fb 09             	cmp    $0x9,%bl
 433:	76 eb                	jbe    420 <atoi+0x20>
  return n;
}
 435:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 438:	89 c8                	mov    %ecx,%eax
 43a:	c9                   	leave  
 43b:	c3                   	ret    
 43c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000440 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 440:	55                   	push   %ebp
 441:	89 e5                	mov    %esp,%ebp
 443:	57                   	push   %edi
 444:	8b 45 10             	mov    0x10(%ebp),%eax
 447:	8b 55 08             	mov    0x8(%ebp),%edx
 44a:	56                   	push   %esi
 44b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 44e:	85 c0                	test   %eax,%eax
 450:	7e 13                	jle    465 <memmove+0x25>
 452:	01 d0                	add    %edx,%eax
  dst = vdst;
 454:	89 d7                	mov    %edx,%edi
 456:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 45d:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 460:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 461:	39 f8                	cmp    %edi,%eax
 463:	75 fb                	jne    460 <memmove+0x20>
  return vdst;
}
 465:	5e                   	pop    %esi
 466:	89 d0                	mov    %edx,%eax
 468:	5f                   	pop    %edi
 469:	5d                   	pop    %ebp
 46a:	c3                   	ret    

0000046b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 46b:	b8 01 00 00 00       	mov    $0x1,%eax
 470:	cd 40                	int    $0x40
 472:	c3                   	ret    

00000473 <exit>:
SYSCALL(exit)
 473:	b8 02 00 00 00       	mov    $0x2,%eax
 478:	cd 40                	int    $0x40
 47a:	c3                   	ret    

0000047b <wait>:
SYSCALL(wait)
 47b:	b8 03 00 00 00       	mov    $0x3,%eax
 480:	cd 40                	int    $0x40
 482:	c3                   	ret    

00000483 <pipe>:
SYSCALL(pipe)
 483:	b8 04 00 00 00       	mov    $0x4,%eax
 488:	cd 40                	int    $0x40
 48a:	c3                   	ret    

0000048b <read>:
SYSCALL(read)
 48b:	b8 05 00 00 00       	mov    $0x5,%eax
 490:	cd 40                	int    $0x40
 492:	c3                   	ret    

00000493 <write>:
SYSCALL(write)
 493:	b8 10 00 00 00       	mov    $0x10,%eax
 498:	cd 40                	int    $0x40
 49a:	c3                   	ret    

0000049b <close>:
SYSCALL(close)
 49b:	b8 15 00 00 00       	mov    $0x15,%eax
 4a0:	cd 40                	int    $0x40
 4a2:	c3                   	ret    

000004a3 <kill>:
SYSCALL(kill)
 4a3:	b8 06 00 00 00       	mov    $0x6,%eax
 4a8:	cd 40                	int    $0x40
 4aa:	c3                   	ret    

000004ab <exec>:
SYSCALL(exec)
 4ab:	b8 07 00 00 00       	mov    $0x7,%eax
 4b0:	cd 40                	int    $0x40
 4b2:	c3                   	ret    

000004b3 <open>:
SYSCALL(open)
 4b3:	b8 0f 00 00 00       	mov    $0xf,%eax
 4b8:	cd 40                	int    $0x40
 4ba:	c3                   	ret    

000004bb <mknod>:
SYSCALL(mknod)
 4bb:	b8 11 00 00 00       	mov    $0x11,%eax
 4c0:	cd 40                	int    $0x40
 4c2:	c3                   	ret    

000004c3 <unlink>:
SYSCALL(unlink)
 4c3:	b8 12 00 00 00       	mov    $0x12,%eax
 4c8:	cd 40                	int    $0x40
 4ca:	c3                   	ret    

000004cb <fstat>:
SYSCALL(fstat)
 4cb:	b8 08 00 00 00       	mov    $0x8,%eax
 4d0:	cd 40                	int    $0x40
 4d2:	c3                   	ret    

000004d3 <link>:
SYSCALL(link)
 4d3:	b8 13 00 00 00       	mov    $0x13,%eax
 4d8:	cd 40                	int    $0x40
 4da:	c3                   	ret    

000004db <mkdir>:
SYSCALL(mkdir)
 4db:	b8 14 00 00 00       	mov    $0x14,%eax
 4e0:	cd 40                	int    $0x40
 4e2:	c3                   	ret    

000004e3 <chdir>:
SYSCALL(chdir)
 4e3:	b8 09 00 00 00       	mov    $0x9,%eax
 4e8:	cd 40                	int    $0x40
 4ea:	c3                   	ret    

000004eb <dup>:
SYSCALL(dup)
 4eb:	b8 0a 00 00 00       	mov    $0xa,%eax
 4f0:	cd 40                	int    $0x40
 4f2:	c3                   	ret    

000004f3 <getpid>:
SYSCALL(getpid)
 4f3:	b8 0b 00 00 00       	mov    $0xb,%eax
 4f8:	cd 40                	int    $0x40
 4fa:	c3                   	ret    

000004fb <sbrk>:
SYSCALL(sbrk)
 4fb:	b8 0c 00 00 00       	mov    $0xc,%eax
 500:	cd 40                	int    $0x40
 502:	c3                   	ret    

00000503 <sleep>:
SYSCALL(sleep)
 503:	b8 0d 00 00 00       	mov    $0xd,%eax
 508:	cd 40                	int    $0x40
 50a:	c3                   	ret    

0000050b <uptime>:
SYSCALL(uptime)
 50b:	b8 0e 00 00 00       	mov    $0xe,%eax
 510:	cd 40                	int    $0x40
 512:	c3                   	ret    

00000513 <create_palindrome>:
SYSCALL(create_palindrome)
 513:	b8 16 00 00 00       	mov    $0x16,%eax
 518:	cd 40                	int    $0x40
 51a:	c3                   	ret    

0000051b <move_file>:
SYSCALL(move_file)
 51b:	b8 17 00 00 00       	mov    $0x17,%eax
 520:	cd 40                	int    $0x40
 522:	c3                   	ret    

00000523 <get_most_invoked_syscall>:
SYSCALL(get_most_invoked_syscall)
 523:	b8 18 00 00 00       	mov    $0x18,%eax
 528:	cd 40                	int    $0x40
 52a:	c3                   	ret    

0000052b <sort_syscalls>:
SYSCALL(sort_syscalls)
 52b:	b8 19 00 00 00       	mov    $0x19,%eax
 530:	cd 40                	int    $0x40
 532:	c3                   	ret    

00000533 <list_all_processes>:
SYSCALL(list_all_processes)
 533:	b8 1a 00 00 00       	mov    $0x1a,%eax
 538:	cd 40                	int    $0x40
 53a:	c3                   	ret    
 53b:	66 90                	xchg   %ax,%ax
 53d:	66 90                	xchg   %ax,%ax
 53f:	90                   	nop

00000540 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 540:	55                   	push   %ebp
 541:	89 e5                	mov    %esp,%ebp
 543:	57                   	push   %edi
 544:	56                   	push   %esi
 545:	53                   	push   %ebx
 546:	83 ec 3c             	sub    $0x3c,%esp
 549:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 54c:	89 d1                	mov    %edx,%ecx
{
 54e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 551:	85 d2                	test   %edx,%edx
 553:	0f 89 7f 00 00 00    	jns    5d8 <printint+0x98>
 559:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 55d:	74 79                	je     5d8 <printint+0x98>
    neg = 1;
 55f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 566:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 568:	31 db                	xor    %ebx,%ebx
 56a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 56d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 570:	89 c8                	mov    %ecx,%eax
 572:	31 d2                	xor    %edx,%edx
 574:	89 cf                	mov    %ecx,%edi
 576:	f7 75 c4             	divl   -0x3c(%ebp)
 579:	0f b6 92 10 0a 00 00 	movzbl 0xa10(%edx),%edx
 580:	89 45 c0             	mov    %eax,-0x40(%ebp)
 583:	89 d8                	mov    %ebx,%eax
 585:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 588:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 58b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 58e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 591:	76 dd                	jbe    570 <printint+0x30>
  if(neg)
 593:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 596:	85 c9                	test   %ecx,%ecx
 598:	74 0c                	je     5a6 <printint+0x66>
    buf[i++] = '-';
 59a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 59f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 5a1:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 5a6:	8b 7d b8             	mov    -0x48(%ebp),%edi
 5a9:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 5ad:	eb 07                	jmp    5b6 <printint+0x76>
 5af:	90                   	nop
    putc(fd, buf[i]);
 5b0:	0f b6 13             	movzbl (%ebx),%edx
 5b3:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 5b6:	83 ec 04             	sub    $0x4,%esp
 5b9:	88 55 d7             	mov    %dl,-0x29(%ebp)
 5bc:	6a 01                	push   $0x1
 5be:	56                   	push   %esi
 5bf:	57                   	push   %edi
 5c0:	e8 ce fe ff ff       	call   493 <write>
  while(--i >= 0)
 5c5:	83 c4 10             	add    $0x10,%esp
 5c8:	39 de                	cmp    %ebx,%esi
 5ca:	75 e4                	jne    5b0 <printint+0x70>
}
 5cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5cf:	5b                   	pop    %ebx
 5d0:	5e                   	pop    %esi
 5d1:	5f                   	pop    %edi
 5d2:	5d                   	pop    %ebp
 5d3:	c3                   	ret    
 5d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 5d8:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 5df:	eb 87                	jmp    568 <printint+0x28>
 5e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5ef:	90                   	nop

000005f0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 5f0:	55                   	push   %ebp
 5f1:	89 e5                	mov    %esp,%ebp
 5f3:	57                   	push   %edi
 5f4:	56                   	push   %esi
 5f5:	53                   	push   %ebx
 5f6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5f9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
 5fc:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
 5ff:	0f b6 13             	movzbl (%ebx),%edx
 602:	84 d2                	test   %dl,%dl
 604:	74 6a                	je     670 <printf+0x80>
  ap = (uint*)(void*)&fmt + 1;
 606:	8d 45 10             	lea    0x10(%ebp),%eax
 609:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
 60c:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 60f:	31 c9                	xor    %ecx,%ecx
  ap = (uint*)(void*)&fmt + 1;
 611:	89 45 d0             	mov    %eax,-0x30(%ebp)
 614:	eb 36                	jmp    64c <printf+0x5c>
 616:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 61d:	8d 76 00             	lea    0x0(%esi),%esi
 620:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 623:	b9 25 00 00 00       	mov    $0x25,%ecx
      if(c == '%'){
 628:	83 f8 25             	cmp    $0x25,%eax
 62b:	74 15                	je     642 <printf+0x52>
  write(fd, &c, 1);
 62d:	83 ec 04             	sub    $0x4,%esp
 630:	88 55 e7             	mov    %dl,-0x19(%ebp)
 633:	6a 01                	push   $0x1
 635:	57                   	push   %edi
 636:	56                   	push   %esi
 637:	e8 57 fe ff ff       	call   493 <write>
 63c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      } else {
        putc(fd, c);
 63f:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 642:	0f b6 13             	movzbl (%ebx),%edx
 645:	83 c3 01             	add    $0x1,%ebx
 648:	84 d2                	test   %dl,%dl
 64a:	74 24                	je     670 <printf+0x80>
    c = fmt[i] & 0xff;
 64c:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
 64f:	85 c9                	test   %ecx,%ecx
 651:	74 cd                	je     620 <printf+0x30>
      }
    } else if(state == '%'){
 653:	83 f9 25             	cmp    $0x25,%ecx
 656:	75 ea                	jne    642 <printf+0x52>
      if(c == 'd'){
 658:	83 f8 25             	cmp    $0x25,%eax
 65b:	0f 84 07 01 00 00    	je     768 <printf+0x178>
 661:	83 e8 63             	sub    $0x63,%eax
 664:	83 f8 15             	cmp    $0x15,%eax
 667:	77 17                	ja     680 <printf+0x90>
 669:	ff 24 85 b8 09 00 00 	jmp    *0x9b8(,%eax,4)
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 670:	8d 65 f4             	lea    -0xc(%ebp),%esp
 673:	5b                   	pop    %ebx
 674:	5e                   	pop    %esi
 675:	5f                   	pop    %edi
 676:	5d                   	pop    %ebp
 677:	c3                   	ret    
 678:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 67f:	90                   	nop
  write(fd, &c, 1);
 680:	83 ec 04             	sub    $0x4,%esp
 683:	88 55 d4             	mov    %dl,-0x2c(%ebp)
 686:	6a 01                	push   $0x1
 688:	57                   	push   %edi
 689:	56                   	push   %esi
 68a:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 68e:	e8 00 fe ff ff       	call   493 <write>
        putc(fd, c);
 693:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
  write(fd, &c, 1);
 697:	83 c4 0c             	add    $0xc,%esp
 69a:	88 55 e7             	mov    %dl,-0x19(%ebp)
 69d:	6a 01                	push   $0x1
 69f:	57                   	push   %edi
 6a0:	56                   	push   %esi
 6a1:	e8 ed fd ff ff       	call   493 <write>
        putc(fd, c);
 6a6:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6a9:	31 c9                	xor    %ecx,%ecx
 6ab:	eb 95                	jmp    642 <printf+0x52>
 6ad:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 6b0:	83 ec 0c             	sub    $0xc,%esp
 6b3:	b9 10 00 00 00       	mov    $0x10,%ecx
 6b8:	6a 00                	push   $0x0
 6ba:	8b 45 d0             	mov    -0x30(%ebp),%eax
 6bd:	8b 10                	mov    (%eax),%edx
 6bf:	89 f0                	mov    %esi,%eax
 6c1:	e8 7a fe ff ff       	call   540 <printint>
        ap++;
 6c6:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 6ca:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6cd:	31 c9                	xor    %ecx,%ecx
 6cf:	e9 6e ff ff ff       	jmp    642 <printf+0x52>
 6d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 6d8:	8b 45 d0             	mov    -0x30(%ebp),%eax
 6db:	8b 10                	mov    (%eax),%edx
        ap++;
 6dd:	83 c0 04             	add    $0x4,%eax
 6e0:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 6e3:	85 d2                	test   %edx,%edx
 6e5:	0f 84 8d 00 00 00    	je     778 <printf+0x188>
        while(*s != 0){
 6eb:	0f b6 02             	movzbl (%edx),%eax
      state = 0;
 6ee:	31 c9                	xor    %ecx,%ecx
        while(*s != 0){
 6f0:	84 c0                	test   %al,%al
 6f2:	0f 84 4a ff ff ff    	je     642 <printf+0x52>
 6f8:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 6fb:	89 d3                	mov    %edx,%ebx
 6fd:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 700:	83 ec 04             	sub    $0x4,%esp
          s++;
 703:	83 c3 01             	add    $0x1,%ebx
 706:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 709:	6a 01                	push   $0x1
 70b:	57                   	push   %edi
 70c:	56                   	push   %esi
 70d:	e8 81 fd ff ff       	call   493 <write>
        while(*s != 0){
 712:	0f b6 03             	movzbl (%ebx),%eax
 715:	83 c4 10             	add    $0x10,%esp
 718:	84 c0                	test   %al,%al
 71a:	75 e4                	jne    700 <printf+0x110>
      state = 0;
 71c:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 71f:	31 c9                	xor    %ecx,%ecx
 721:	e9 1c ff ff ff       	jmp    642 <printf+0x52>
 726:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 72d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 730:	83 ec 0c             	sub    $0xc,%esp
 733:	b9 0a 00 00 00       	mov    $0xa,%ecx
 738:	6a 01                	push   $0x1
 73a:	e9 7b ff ff ff       	jmp    6ba <printf+0xca>
 73f:	90                   	nop
        putc(fd, *ap);
 740:	8b 45 d0             	mov    -0x30(%ebp),%eax
  write(fd, &c, 1);
 743:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 746:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
 748:	6a 01                	push   $0x1
 74a:	57                   	push   %edi
 74b:	56                   	push   %esi
        putc(fd, *ap);
 74c:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 74f:	e8 3f fd ff ff       	call   493 <write>
        ap++;
 754:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 758:	83 c4 10             	add    $0x10,%esp
      state = 0;
 75b:	31 c9                	xor    %ecx,%ecx
 75d:	e9 e0 fe ff ff       	jmp    642 <printf+0x52>
 762:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        putc(fd, c);
 768:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 76b:	83 ec 04             	sub    $0x4,%esp
 76e:	e9 2a ff ff ff       	jmp    69d <printf+0xad>
 773:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 777:	90                   	nop
          s = "(null)";
 778:	ba b0 09 00 00       	mov    $0x9b0,%edx
        while(*s != 0){
 77d:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 780:	b8 28 00 00 00       	mov    $0x28,%eax
 785:	89 d3                	mov    %edx,%ebx
 787:	e9 74 ff ff ff       	jmp    700 <printf+0x110>
 78c:	66 90                	xchg   %ax,%ax
 78e:	66 90                	xchg   %ax,%ax

00000790 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 790:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 791:	a1 f4 0c 00 00       	mov    0xcf4,%eax
{
 796:	89 e5                	mov    %esp,%ebp
 798:	57                   	push   %edi
 799:	56                   	push   %esi
 79a:	53                   	push   %ebx
 79b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 79e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7a8:	89 c2                	mov    %eax,%edx
 7aa:	8b 00                	mov    (%eax),%eax
 7ac:	39 ca                	cmp    %ecx,%edx
 7ae:	73 30                	jae    7e0 <free+0x50>
 7b0:	39 c1                	cmp    %eax,%ecx
 7b2:	72 04                	jb     7b8 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7b4:	39 c2                	cmp    %eax,%edx
 7b6:	72 f0                	jb     7a8 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7b8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 7bb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 7be:	39 f8                	cmp    %edi,%eax
 7c0:	74 30                	je     7f2 <free+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 7c2:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 7c5:	8b 42 04             	mov    0x4(%edx),%eax
 7c8:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 7cb:	39 f1                	cmp    %esi,%ecx
 7cd:	74 3a                	je     809 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 7cf:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 7d1:	5b                   	pop    %ebx
  freep = p;
 7d2:	89 15 f4 0c 00 00    	mov    %edx,0xcf4
}
 7d8:	5e                   	pop    %esi
 7d9:	5f                   	pop    %edi
 7da:	5d                   	pop    %ebp
 7db:	c3                   	ret    
 7dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7e0:	39 c2                	cmp    %eax,%edx
 7e2:	72 c4                	jb     7a8 <free+0x18>
 7e4:	39 c1                	cmp    %eax,%ecx
 7e6:	73 c0                	jae    7a8 <free+0x18>
  if(bp + bp->s.size == p->s.ptr){
 7e8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 7eb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 7ee:	39 f8                	cmp    %edi,%eax
 7f0:	75 d0                	jne    7c2 <free+0x32>
    bp->s.size += p->s.ptr->s.size;
 7f2:	03 70 04             	add    0x4(%eax),%esi
 7f5:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 7f8:	8b 02                	mov    (%edx),%eax
 7fa:	8b 00                	mov    (%eax),%eax
 7fc:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 7ff:	8b 42 04             	mov    0x4(%edx),%eax
 802:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 805:	39 f1                	cmp    %esi,%ecx
 807:	75 c6                	jne    7cf <free+0x3f>
    p->s.size += bp->s.size;
 809:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
 80c:	89 15 f4 0c 00 00    	mov    %edx,0xcf4
    p->s.size += bp->s.size;
 812:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 815:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 818:	89 0a                	mov    %ecx,(%edx)
}
 81a:	5b                   	pop    %ebx
 81b:	5e                   	pop    %esi
 81c:	5f                   	pop    %edi
 81d:	5d                   	pop    %ebp
 81e:	c3                   	ret    
 81f:	90                   	nop

00000820 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 820:	55                   	push   %ebp
 821:	89 e5                	mov    %esp,%ebp
 823:	57                   	push   %edi
 824:	56                   	push   %esi
 825:	53                   	push   %ebx
 826:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 829:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 82c:	8b 3d f4 0c 00 00    	mov    0xcf4,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 832:	8d 70 07             	lea    0x7(%eax),%esi
 835:	c1 ee 03             	shr    $0x3,%esi
 838:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 83b:	85 ff                	test   %edi,%edi
 83d:	0f 84 9d 00 00 00    	je     8e0 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 843:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 845:	8b 4a 04             	mov    0x4(%edx),%ecx
 848:	39 f1                	cmp    %esi,%ecx
 84a:	73 6a                	jae    8b6 <malloc+0x96>
 84c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 851:	39 de                	cmp    %ebx,%esi
 853:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 856:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 85d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 860:	eb 17                	jmp    879 <malloc+0x59>
 862:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 868:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 86a:	8b 48 04             	mov    0x4(%eax),%ecx
 86d:	39 f1                	cmp    %esi,%ecx
 86f:	73 4f                	jae    8c0 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 871:	8b 3d f4 0c 00 00    	mov    0xcf4,%edi
 877:	89 c2                	mov    %eax,%edx
 879:	39 d7                	cmp    %edx,%edi
 87b:	75 eb                	jne    868 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 87d:	83 ec 0c             	sub    $0xc,%esp
 880:	ff 75 e4             	push   -0x1c(%ebp)
 883:	e8 73 fc ff ff       	call   4fb <sbrk>
  if(p == (char*)-1)
 888:	83 c4 10             	add    $0x10,%esp
 88b:	83 f8 ff             	cmp    $0xffffffff,%eax
 88e:	74 1c                	je     8ac <malloc+0x8c>
  hp->s.size = nu;
 890:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 893:	83 ec 0c             	sub    $0xc,%esp
 896:	83 c0 08             	add    $0x8,%eax
 899:	50                   	push   %eax
 89a:	e8 f1 fe ff ff       	call   790 <free>
  return freep;
 89f:	8b 15 f4 0c 00 00    	mov    0xcf4,%edx
      if((p = morecore(nunits)) == 0)
 8a5:	83 c4 10             	add    $0x10,%esp
 8a8:	85 d2                	test   %edx,%edx
 8aa:	75 bc                	jne    868 <malloc+0x48>
        return 0;
  }
}
 8ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 8af:	31 c0                	xor    %eax,%eax
}
 8b1:	5b                   	pop    %ebx
 8b2:	5e                   	pop    %esi
 8b3:	5f                   	pop    %edi
 8b4:	5d                   	pop    %ebp
 8b5:	c3                   	ret    
    if(p->s.size >= nunits){
 8b6:	89 d0                	mov    %edx,%eax
 8b8:	89 fa                	mov    %edi,%edx
 8ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 8c0:	39 ce                	cmp    %ecx,%esi
 8c2:	74 4c                	je     910 <malloc+0xf0>
        p->s.size -= nunits;
 8c4:	29 f1                	sub    %esi,%ecx
 8c6:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 8c9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 8cc:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 8cf:	89 15 f4 0c 00 00    	mov    %edx,0xcf4
}
 8d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 8d8:	83 c0 08             	add    $0x8,%eax
}
 8db:	5b                   	pop    %ebx
 8dc:	5e                   	pop    %esi
 8dd:	5f                   	pop    %edi
 8de:	5d                   	pop    %ebp
 8df:	c3                   	ret    
    base.s.ptr = freep = prevp = &base;
 8e0:	c7 05 f4 0c 00 00 f8 	movl   $0xcf8,0xcf4
 8e7:	0c 00 00 
    base.s.size = 0;
 8ea:	bf f8 0c 00 00       	mov    $0xcf8,%edi
    base.s.ptr = freep = prevp = &base;
 8ef:	c7 05 f8 0c 00 00 f8 	movl   $0xcf8,0xcf8
 8f6:	0c 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8f9:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 8fb:	c7 05 fc 0c 00 00 00 	movl   $0x0,0xcfc
 902:	00 00 00 
    if(p->s.size >= nunits){
 905:	e9 42 ff ff ff       	jmp    84c <malloc+0x2c>
 90a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 910:	8b 08                	mov    (%eax),%ecx
 912:	89 0a                	mov    %ecx,(%edx)
 914:	eb b9                	jmp    8cf <malloc+0xaf>
