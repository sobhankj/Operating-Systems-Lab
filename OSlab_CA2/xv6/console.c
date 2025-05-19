// Console input and output.
// Input is from the keyboard or serial port.
// Output is written to the screen and serial port.

#include "types.h"
#include "defs.h"
#include "param.h"
#include "traps.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "fs.h"
#include "file.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"

#define LEFT_ARROW 228
#define RIGHT_ARROW 229
#define UP_ARROW 226
#define DOWN_ARROW 227 
#define ENTER_KEY '\n'
#define NUM_OF_HISTORY_COMMAND 10
//for left arrow
static int num_of_left_pressed = 0;
static int ctrl_s_pressed = 0;
static int start_ctrl_s = 0;
char first_digit, second_digit;
char operand;
int state_of_question_mark = 0;
int index_question_mark = 0;
int currecnt_com = 0;
char* hist = {"history\n"};
char coppied_input[128];
int cur_index = 0;
int num_of_left_copy = 0;
int ctrl_s_start = 0;
static void consputc(int);


static int panicked = 0;

static struct {
  struct spinlock lock;
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    x = -xx;
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
    consputc(buf[i]);
}
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    if(c != '%'){
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
      consputc(c);
      break;
    }
  }

  if(locking)
    release(&cons.lock);
}

void
panic(char *s)
{
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
  for(;;)
    ;
}

//PAGEBREAK: 50
#define BACKSPACE 0x100
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory
//--------------------------
//shift_back
void shift_back(int pos){
  for(int i = pos-1; i < pos + num_of_left_pressed; i++){
    crt[i] = crt[i + 1];
  }
}
// push_right
void push_right(int pos){
  for(int i = pos + num_of_left_pressed; i > pos; i--){
    crt[i] = crt[i-1];
  }
}
//--------------------------


#define INPUT_BUF 128
struct Input{
  char buf[INPUT_BUF];
  uint r;  // Read index
  uint w;  // Write index
  uint e;  // Edit index
} input;


struct {                                      
  struct Input hist[NUM_OF_HISTORY_COMMAND];
  struct Input current_command;
  int num_of_cmnd;
  int start_index;
  int num_of_press;
}history_cmnd;

enum Direction {
  DOWN ,
  UP 
};

void show_current_history(int temp){
  for(int i = temp; i > 0; i--){
    if(input.buf[i - 1] != '\n'){
      consputc(BACKSPACE);
      input.e--;
    }
  input = history_cmnd.current_command;
  }
  for(int j = input.w; j < input.e; j++){
        consputc(input.buf[j]);
      }
}

int is_history(char* command){
  for(int i = 0; i < 8; i++){
    if(command[i] != input.buf[i + input.w]){
      return 0;
    }
  }
  return 1;
}

void print_history(){
  release(&cons.lock);
  for(int i = 0; i < history_cmnd.num_of_cmnd; i++){
      input = history_cmnd.hist[i];
      // input.e--;
      for(int j = history_cmnd.hist[i].w; j < history_cmnd.hist[i].e; j++){
        consputc(input.buf[j]);
      }
  }
  acquire(&cons.lock);
}

struct Input copied_command;

void handle_shifting(int length, int cursor_pos){
  for (int i = input.e - 1; i >= cursor_pos; i--)
  {
    input.buf[i + length] = input.buf[i];
  }
}

void print_copied_command(){
  for(int i = 0; i < cur_index; i++){
    consputc(coppied_input[i]);
  }
  if(num_of_left_pressed > 0){
    handle_shifting(cur_index, input.e - num_of_left_pressed);
  }
  int x = input.e;
  // for(int j = input.e - num_of_left_pressed; j < input.e - num_of_left_pressed + input.e - start_ctrl_s -1; j++){
  //   input.buf[x + j - num_of_left_pressed] = input.buf[start_ctrl_s + j];
  //   input.e++;
  // }
  // release(&cons.lock);
  // cprintf("%s\n", coppied_input);
  // acquire(&cons.lock);
  for(int i = 0; coppied_input[i] != '\0'; i++){
    input.buf[x - num_of_left_pressed + i] = coppied_input[i];
    input.e++;
  }
}

void handle_ctrl_s(){
  start_ctrl_s = input.e;
  memset(coppied_input, '\0', sizeof(coppied_input));

}
void handle_ctrl_f(){
  if(ctrl_s_pressed){
    // copied_command = input;
    print_copied_command();
  }
}
void update_coppied_commands(){
  for(int i = start_ctrl_s; i < input.e; i++){
    if(copied_command.e < INPUT_BUF){
      copied_command.buf[copied_command.e + (i - start_ctrl_s)] = input.buf[i];
      copied_command.e++;
    }
  }
}

int convert_char_to_int(char* digits, int size_of_number){
  int result = 0;
  for(int i = 0; i < size_of_number; i++){
    int power_10 = 1;
    for(int j = 0; j < i; j++){
      power_10 *= 10;
    }
    result += ((int)digits[i] - 48) * power_10;
  }
  return result;
}
int int_to_string(float num, char * string){
  int i = 0;
  int num1 = num;
  if((int)(num * 10) % 10 != 0){
    string[i] = ((int)(num * 10) % 10) + '0';
    i++;
    string[i] = '.';
    i++;
  }
  while(num1 > 0){
    int temp  = num1 % 10;
    string[i] = temp + '0';
    i++;
    num1 /= 10;
  }
  return i;
}

void
change_cursor_position(int direction){
  //get cursor position
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  //case
  switch(direction){
    case 0:
      pos -= 1;
      break;
    case 1:
      pos += 1;
      break;
    default:
      break;
  }
  //update
  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
}

void show_result(int offset, char* result){
  for(int i = input.e - num_of_left_pressed; i <= index_question_mark; i++){
    change_cursor_position(1);
    num_of_left_pressed--;
  }
  for(int i = 0; i < 5; i++){
    consputc(BACKSPACE);
    input.e--;
  }

  int temp_e = input.e;
  for(int i = 0; i < 5; i++){
    for(int j = index_question_mark + 1; j <= temp_e - 1; j++){
      input.buf[j - 1] = input.buf[j];
    }
  }

  for(int j = offset - 1; j >= 0; j--){
    input.buf[input.e] = result[j];
    consputc(input.buf[input.e]);
    input.e++;
  }
  //here is about clearing arrays
}


void do_operation(){
  int first_num = first_digit - '0';
  int second_num = second_digit - '0';
  float result = 0;
  switch (operand)
  {
  case '+':
    result = (float)second_num + (float)first_num;
    break;
  case '-':
    result = (float)second_num - (float)first_num;
    break;
  case '*':
    result = (float)second_num * (float)first_num;
    break;
  case '/':
    result = (float)second_num / (float)first_num;
    break;
  default:
    result = (float)second_num + (float)first_num;
    break;
  }

  // release(&cons.lock);
  // cprintf("\n\nsecond = %d\n\n", first_num);
  // acquire(&cons.lock);
  // release(&cons.lock);
  // cprintf("\nresult\n = %d", result);
  // acquire(&cons.lock);
  char result_as_string[INPUT_BUF];
  memset(result_as_string, '\0', sizeof(result_as_string));
  int num_res_digits = int_to_string(result, result_as_string);
  show_result(num_res_digits, result_as_string);
}

int is_digit(char c){
  return c >= '0' && c <= '9';
}

int is_operand(char c){
  if((c =='+') || (c == '-') || (c == '*') || (c == '/')){
    return 1;
  }
  return 0;
}

int is_equal_mark(char c){
  return c == '=';
}

int is_question_mark(char c){
  return c == '?';
}

int there_is_question_mark(){
  for(int i = input.w; i < input.e; i++){
    if(input.buf[i] == '?'){
      return 1;
    }
  }
  return 0;
}

int find_question_mark_index(){
  for(int i = input.w; i < input.e; i++){
    if(input.buf[i] == '?'){
      return i;
    }
  }
  return 0;
}


void handle_up_and_down_arrow(enum Direction dir){
  for(int i = input.e; i > input.w; i--){
    if(input.buf[i - 1] != '\n'){
      consputc(BACKSPACE);
    }
  }
  if(dir == UP){
    input = history_cmnd.hist[history_cmnd.num_of_cmnd - history_cmnd.num_of_press];
    input.e--;
  }
  if(dir == DOWN){
    input = history_cmnd.hist[history_cmnd.num_of_cmnd - history_cmnd.num_of_press];
    input.e--;
  }

  //here is about showing on the console
  for(int i = input.w; i < input.e; i++){
    consputc(input.buf[i]);
  }
}

static void
cgaputc(int c)
{
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  if(c == '\n'){
    pos += 80 - pos%80;
  }
  else if(c == BACKSPACE){
    shift_back(pos);
    if(pos > 0) --pos;
  } else{
    push_right(pos);
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
  }
  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
  }

  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  crt[pos + num_of_left_pressed] = ' ' | 0x0700;
}

void
consputc(int c)
{
  if(panicked){
    cli();
    for(;;)
      ;
  }

  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
  cgaputc(c);
}

void check_states_question_mark(char c){
  switch (state_of_question_mark)
  {
  case 0:
    if(!is_equal_mark(c)){
      state_of_question_mark = 0;
    }
    else{
      state_of_question_mark = 1;
    }
    break;
  case 1:
    if(is_digit(c)){
      first_digit = c;
      state_of_question_mark = 2;
    }
    else{
      state_of_question_mark = 0;
    }
  break;
  case 2:
    if(is_operand(c)){
      state_of_question_mark = 3;
      operand = c;
    }
    else{
      state_of_question_mark = 0;
    }
  break;
  case 3:
    if(is_digit(c)){
      second_digit = c;
      do_operation();
      state_of_question_mark = 0;
    }
    else{
      state_of_question_mark = 0;
    }
  break;

  default:
    state_of_question_mark = 0;
    break;
  }
}

void search_for_NON(int qm_index){
  index_question_mark = qm_index;
  for(int i = 1;i <= 4; i++){
    check_states_question_mark(input.buf[qm_index - i]);
  }
}

#define C(x)  ((x)-'@')  // Control-x

void update_history_memory(){
  if((input.e - input.w) > 1){
    if(history_cmnd.num_of_cmnd < 10){
      history_cmnd.hist[history_cmnd.num_of_cmnd] = input;
      history_cmnd.num_of_cmnd++;
      }
    else{
      for(int i = 0; i < 9; i++){
          history_cmnd.hist[i] = history_cmnd.hist[i + 1];
        }
      history_cmnd.hist[NUM_OF_HISTORY_COMMAND - 1] = input;
    }
  }
} 

void handle_deletion(){
  for(int i = input.e - num_of_left_pressed - 1; i < input.e; i++){
    input.buf[i % INPUT_BUF] = input.buf[(i + 1) % INPUT_BUF];
  }
}

void handle_copy_delete(){
  for(int i = cur_index - num_of_left_copy - 1; i < cur_index; i++){
    coppied_input[i % INPUT_BUF] = coppied_input[(i + 1) % INPUT_BUF];
  }
}

void handle_writing(){
  int init = input.e - 1;
  int limit = input.e - num_of_left_pressed - 1;
  for(int i = init; i > limit; i--){
    input.buf[(i + 1) % INPUT_BUF] = input.buf[i % INPUT_BUF];
  }
}

void handle_copying(){
  int init = cur_index - 1;
  int limit = cur_index - 1 - num_of_left_copy;
  for(int i = init; i > limit; i--){
    coppied_input[(i + 1) % INPUT_BUF] = coppied_input[i % INPUT_BUF];
  }
}

void
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;
  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
        if(ctrl_s_pressed){
          if(num_of_left_copy == 0){
            coppied_input[cur_index - 1] = '\0';
            cur_index--;
          }
          else if(num_of_left_copy > 0 && num_of_left_copy != cur_index){
            handle_copy_delete();
            coppied_input[cur_index - 1] = '\0';
            cur_index--;
          }
          else if(num_of_left_copy == cur_index){
            ctrl_s_start--;
          }
        }
        if(num_of_left_pressed == 0){
        input.e--;
        consputc(BACKSPACE);
        }
        else if(num_of_left_pressed < input.e - input.w){
          handle_deletion();
          input.e--;
          consputc(BACKSPACE);
        }
      }
      break;
    case LEFT_ARROW:
      if((input.e - num_of_left_pressed) > input.w){
        change_cursor_position(0);
        num_of_left_pressed++;
        if(ctrl_s_pressed && cur_index > 0 && num_of_left_copy < cur_index)
          num_of_left_copy++;
      }
      break;
    case RIGHT_ARROW:
      if(num_of_left_pressed > 0){
        change_cursor_position(1);
        num_of_left_pressed--;
      }
      if(num_of_left_copy > 0)
        num_of_left_copy--;
      break;
    case UP_ARROW:
      for(int i = 0; i < num_of_left_pressed; i++)
        change_cursor_position(1);
      num_of_left_pressed = 0;
      if(currecnt_com == 0){
        history_cmnd.current_command = input;
        currecnt_com = 1;
      }
      if(history_cmnd.num_of_cmnd != 0 && history_cmnd.num_of_press < history_cmnd.num_of_cmnd){
        history_cmnd.num_of_press++;
        handle_up_and_down_arrow(UP);
      }
    break;
    case DOWN_ARROW:
      for(int i = 0; i < num_of_left_pressed; i++)
        change_cursor_position(1);
      num_of_left_pressed = 0;
      if(history_cmnd.num_of_cmnd != 0 && history_cmnd.num_of_press > 1){
        history_cmnd.num_of_press--;
        handle_up_and_down_arrow(DOWN);
      }
      else if(history_cmnd.num_of_press == 1){
        history_cmnd.num_of_press = 0;
        int temp = input.e - input.w + 1;
        show_current_history(temp);
        currecnt_com = 0;
      }
      break;
    case C('S'):
      cur_index = 0;
      ctrl_s_pressed = 1;
      ctrl_s_start = input.e - input.w;
      //is about chacking ctrl s and f
      handle_ctrl_s();

    break;
    case C('F'):
      handle_ctrl_f();
    break;
    default:
      //here is about checking operation
      if(there_is_question_mark()){
        int qm_index = find_question_mark_index();
        search_for_NON(qm_index);//int type, int current_index, char temp_char
      }
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        if(ctrl_s_pressed){
          if(num_of_left_pressed == 0){
            coppied_input[cur_index] = c;
            cur_index++;
          }
          else{
            if(cur_index - num_of_left_pressed >= 0){
              handle_copying();
              coppied_input[cur_index - num_of_left_copy] = c;
              cur_index++;
            }
            else if(num_of_left_copy > 0 && num_of_left_copy != cur_index){
              coppied_input[cur_index - num_of_left_copy] = c;
              cur_index++;
            }
          }
          // cur_index++;
        }
        if(num_of_left_pressed == 0 || c == '\n'){
          input.buf[input.e++ % INPUT_BUF] = c;
        }
        else{
          handle_writing();
          input.buf[(input.e - num_of_left_pressed) % INPUT_BUF] = c;
          input.e++;
        }
        consputc(c);
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
          num_of_left_pressed = 0;
          num_of_left_copy = 0;
          //each time prees enter this will be initiate
          history_cmnd.num_of_press = 0;
          //is about adding new command to history 
          update_history_memory();
          if(is_history(hist)){
            print_history();
          }
          //update copied commands
          update_coppied_commands();
          //is about current draft
          currecnt_com = 0;

          input.w = input.e;
          wakeup(&input.r);
        }
      }
      break;
    }
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
  uint target;
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
int
consolewrite(struct inode *ip, char *buf, int n)
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
    consputc(buf[i] & 0xff);
  release(&cons.lock);
  ilock(ip);
  return n;
}

void
consoleinit(void)
{

  history_cmnd.num_of_cmnd = 0;
  history_cmnd.start_index = 0;
  history_cmnd.num_of_press = 0;

  initlock(&cons.lock, "console");

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
}

