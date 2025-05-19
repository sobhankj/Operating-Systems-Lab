#include "param.h"
#include "types.h"
#include "defs.h"
#include "x86.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "elf.h"
#include "SHM.h"
#include "IPC.h"
#include "spinlock.h"

extern char data[];  // defined by kernel.ld
pde_t *kpgdir;  // for use in scheduler()

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
  struct cpu *c;

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
  lgdt(c->gdt, sizeof(c->gdt));
}

// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}

// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}

// There is one page table per process, plus one that's used when
// a CPU is not running any process (kpgdir). The kernel uses the
// current process's page table during system calls and interrupts;
// page protection bits prevent user code from using the kernel's
// mappings.
//
// setupkvm() and exec() set up every page table like this:
//
//   0..KERNBASE: user memory (text+data+stack+heap), mapped to
//                phys memory allocated by the kernel
//   KERNBASE..KERNBASE+EXTMEM: mapped to 0..EXTMEM (for I/O space)
//   KERNBASE+EXTMEM..data: mapped to EXTMEM..V2P(data)
//                for the kernel's instructions and r/o data
//   data..KERNBASE+PHYSTOP: mapped to V2P(data)..PHYSTOP,
//                                  rw data + free physical memory
//   0xfe000000..0: mapped direct (devices such as ioapic)
//
// The kernel allocates physical memory for its heap and for user memory
// between V2P(end) and the end of physical memory (PHYSTOP)
// (directly addressable from end..P2V(PHYSTOP)).

// This table defines the kernel's mappings, which are present in
// every process's page table.
static struct kmap {
  void *virt;
  uint phys_start;
  uint phys_end;
  int perm;
} kmap[] = {
 { (void*)KERNBASE, 0,             EXTMEM,    PTE_W}, // I/O space
 { (void*)KERNLINK, V2P(KERNLINK), V2P(data), 0},     // kern text+rodata
 { (void*)data,     V2P(data),     PHYSTOP,   PTE_W}, // kern data+memory
 { (void*)DEVSPACE, DEVSPACE,      0,         PTE_W}, // more devices
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
}

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
  kpgdir = setupkvm();
  switchkvm();
}

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
}

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");

  pushcli();
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
}

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
}

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
}

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}

// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
}

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
  *pte &= ~PTE_U;
}

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
      kfree(mem);
      goto bad;
    }
  }
  return d;

bad:
  freevm(d);
  return 0;
}

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}

// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}

struct shared_mem_region {
  uint key, size;
  int shared_mem_id;
  int to_be_deleted;
  void *physical_addr[SHAREDREGIONS];
  struct shared_mem_id_DS buffer;
};

struct shared_mem_table {
  struct spinlock lock;
  struct shared_mem_region all_regions[SHAREDREGIONS];
} shared_mem_table;


/*
  Creates a shared memory region with given key,
  and size depending upon flag provided
*/
int get_shared_mem(uint key, uint size, int shared_mem_flag) {
  int lower_bits = shared_mem_flag & 7, permission = -1;

  acquire(&shared_mem_table.lock);
  if(lower_bits == (int)READ_SHM) {
    permission = READ_SHM;
    shared_mem_flag ^= READ_SHM;
  }
  else if(lower_bits == (int)RW_SHM) {
    permission = RW_SHM;
    shared_mem_flag ^= RW_SHM;
  } else {
    if(!((shared_mem_flag == 0) && (key != IPC_PRIVATE))) {
      release(&shared_mem_table.lock);
      return -1;
    }
  }
  if(size <= 0) {
    release(&shared_mem_table.lock);
    return -1;
  }
  int num_of_pages = (size / PGSIZE) + 1;
  if(num_of_pages > SHAREDREGIONS) {
    release(&shared_mem_table.lock);
    return -1;
  }
  int index = -1;
  for(int i = 0; i < SHAREDREGIONS; i++) {
    if(shared_mem_table.all_regions[i].key == key) {
      if(shared_mem_table.all_regions[i].size != num_of_pages) {
        release(&shared_mem_table.lock);
        return -1;
      }
      if(shared_mem_flag == (IPC_CREAT | IPC_EXCL)) {
        release(&shared_mem_table.lock);
        return -1;
      }
      int check_perm = shared_mem_table.all_regions[i].buffer.shared_mem_perm.mode;
      if(check_perm == READ_SHM || check_perm == RW_SHM) {
        if((shared_mem_flag == 0) && (key != IPC_PRIVATE)) {
          release(&shared_mem_table.lock);
          return shared_mem_table.all_regions[i].shared_mem_id;
        }
        if(shared_mem_flag == IPC_CREAT) {
          release(&shared_mem_table.lock);
          return shared_mem_table.all_regions[i].shared_mem_id;
        }
      }
      release(&shared_mem_table.lock);
      return -1;
    }
  }
  for(int i = 0; i < SHAREDREGIONS; i++) {
    if(shared_mem_table.all_regions[i].key == -1) {
      index = i;
      break;
    }
  }
  if(index == -1) {
    release(&shared_mem_table.lock);
    return -1;
  }
  if((key == IPC_PRIVATE) || (shared_mem_flag == IPC_CREAT) || (shared_mem_flag == (IPC_CREAT | IPC_EXCL))) {
    for(int i = 0; i < num_of_pages; i++) {
      char *new_page = kalloc();
      if(new_page == 0){
        cprintf("shmget: failed to allocate a page (out of memory)\n");
        release(&shared_mem_table.lock);
        return -1;
      }
      memset(new_page, 0, PGSIZE);
      shared_mem_table.all_regions[index].physical_addr[i] = (void *)V2P(new_page);
    }
    shared_mem_table.all_regions[index].size = num_of_pages;
    shared_mem_table.all_regions[index].key = key;
    shared_mem_table.all_regions[index].buffer.shared_mem_segment_size = size;
    shared_mem_table.all_regions[index].buffer.shared_mem_perm.__key = key;
    shared_mem_table.all_regions[index].buffer.shared_mem_perm.mode = permission;
    shared_mem_table.all_regions[index].buffer.shared_mem_creator_pid = myproc()->pid;
    shared_mem_table.all_regions[index].shared_mem_id = index;

    release(&shared_mem_table.lock);
    return index;
  } else {
    release(&shared_mem_table.lock);
    return -1;
  }  
}

// finds the least starting address of a segment greater than current_virtual_addr which is attached 
// to the virtual address space of the current process. Returns the index from the pages  
// array corresponding to this address if found; -1 otherwise
int get_least_virtual_addr_index(void* current_virtual_addr, struct proc *process) {
  
  //maximum virtual address available in range
  void* least_virtual_addr = (void*)(KERNBASE - 1);

  int index = -1;
  for(int i = 0; i < SHAREDREGIONS; i++) {
    if(process->pages[i].key != -1 && (uint)process->pages[i].virtual_addr >= (uint)current_virtual_addr && (uint)least_virtual_addr >= (uint)process->pages[i].virtual_addr) {  
      // store address if greater than current_virtual_addr and smaller than the existing least_virtual_addr.
      least_virtual_addr = process->pages[i].virtual_addr;

      index = i;
    }
  }  
  return index;
}

// detaches the shared memory segment starting at shared_mem_addr from virtual address space of the process
// returns 0 if successful and -1 in case of a failure
int deattach_shared_mem(void* shared_mem_addr) {
  acquire(&shared_mem_table.lock);
  struct proc *process = myproc();
  void* va = (void*)0;
  uint size;
  int index,shared_mem_id;
  for(int i = 0; i < SHAREDREGIONS; i++) {
    if(process->pages[i].key != -1 && process->pages[i].virtual_addr == shared_mem_addr) {
        va =  process->pages[i].virtual_addr;
        index = i;
        shared_mem_id = process->pages[i].shared_mem_id;
        size = process->pages[index].size;
        break;
    }
  }
  if(va) {
    for(int i = 0; i < size; i++) {
      pte_t* pte = walkpgdir(process->pgdir, (void*)((uint)va + i*PGSIZE), 0);
      if(pte == 0) {
        release(&shared_mem_table.lock);
        return -1;
      }
		  *pte = 0;
    }
    process->pages[index].shared_mem_id = -1;  
    process->pages[index].key = -1;
    process->pages[index].size =  0;
    process->pages[index].virtual_addr = (void*)0;
    if(shared_mem_table.all_regions[shared_mem_id].buffer.shared_mem_number_of_attch > 0) {
      shared_mem_table.all_regions[shared_mem_id].buffer.shared_mem_number_of_attch -= 1;
    } 
    if(shared_mem_table.all_regions[shared_mem_id].buffer.shared_mem_number_of_attch == 0 && shared_mem_table.all_regions[shared_mem_id].to_be_deleted == 1) {
      for(int i = 0; i < shared_mem_table.all_regions[index].size; i++) {
        char *addr = (char *)P2V(shared_mem_table.all_regions[index].physical_addr[i]);
        kfree(addr);
        shared_mem_table.all_regions[index].physical_addr[i] = (void *)0;
      }
      shared_mem_table.all_regions[index].size = 0;
      shared_mem_table.all_regions[index].key = shared_mem_table.all_regions[index].shared_mem_id = -1;
      shared_mem_table.all_regions[index].to_be_deleted = 0;
      shared_mem_table.all_regions[index].buffer.shared_mem_number_of_attch = 0;
      shared_mem_table.all_regions[index].buffer.shared_mem_segment_size = 0;
      shared_mem_table.all_regions[index].buffer.shared_mem_perm.__key = -1;
      shared_mem_table.all_regions[index].buffer.shared_mem_perm.mode = 0;
      shared_mem_table.all_regions[index].buffer.shared_mem_creator_pid = -1;
      shared_mem_table.all_regions[index].buffer.shared_mem_last_pid = -1;
    }
    shared_mem_table.all_regions[shared_mem_id].buffer.shared_mem_last_pid = process->pid;
    release(&shared_mem_table.lock);
    return 0;
  } else {
    release(&shared_mem_table.lock);
    return -1;
  }
  
}

// attaches shared memory segment identified by shared_mem_id to the virtual address shared_mem_addr 
// if provided; otherwise attach at the first fitting address 
void* attach_shared_mem(int shared_mem_id, void* shared_mem_addr, int shared_mem_flag) {
  if(shared_mem_id < 0 || shared_mem_id > 64) {
    return (void*)-1;
  }
  acquire(&shared_mem_table.lock);
  int index = -1,idx, perm_flag;
  uint segment,size = 0;
  void *va = (void*)HEAPLIMIT, *least_virtual_addr;
  struct proc *process = myproc();
  index = shared_mem_table.all_regions[shared_mem_id].shared_mem_id;
  if(index == -1) {
    // shared_mem_id not found
    release(&shared_mem_table.lock);
    return (void*)-1;
  }
  if(shared_mem_addr) {
    if((uint)shared_mem_addr >= KERNBASE || (uint)shared_mem_addr < HEAPLIMIT) {
      release(&shared_mem_table.lock);
      return (void*)-1;
    }
    // round down to nearest multiple of SHMLBA
    uint rounded = ((uint)shared_mem_addr & ~(SHMLBA-1));  

    if(shared_mem_flag & SHM_RND) {
      if(!rounded) {
        release(&shared_mem_table.lock);
        return (void*)-1;
      }
      va = (void*)rounded;
    } else {

      // page aligned address
      if(rounded == (uint)shared_mem_addr) {  
        va = shared_mem_addr;    
      }
    }
      
  } else {
    for(int i = 0; i < SHAREDREGIONS; i++) {
      idx = get_least_virtual_addr_index(va,process);
      if(idx != -1) {
        least_virtual_addr = process->pages[idx].virtual_addr;
        if((uint)va + shared_mem_table.all_regions[index].size*PGSIZE <=  (uint)least_virtual_addr)        
          break;
        else
          va = (void*)((uint)least_virtual_addr + process->pages[idx].size*PGSIZE);
      } else 
        break;
    }
  }
  if((uint)va + shared_mem_table.all_regions[index].size*PGSIZE >= KERNBASE) {
    // size exceeded
    release(&shared_mem_table.lock);
    return (void*)-1;
  }
  idx = -1;
  for(int i = 0; i < SHAREDREGIONS; i++) {
    if(process->pages[i].key != -1 && (uint)process->pages[i].virtual_addr + process->pages[i].size*PGSIZE > (uint)va && (uint)va >= (uint)process->pages[i].virtual_addr)  {
      idx = i;
      break;
    }
  }
  if(idx != -1) {
    if(shared_mem_flag & SHM_REMAP) {
      segment = (uint)process->pages[idx].virtual_addr;
      // repeat till all conflicting mappings are removed
      while(segment < (uint)va + shared_mem_table.all_regions[index].size*PGSIZE) { 
        size = process->pages[idx].size;
        release(&shared_mem_table.lock);
        if(deattach_shared_mem((void*)segment) == -1) {
          return (void*)-1;
        }
        acquire(&shared_mem_table.lock);        
        idx = get_least_virtual_addr_index((void*)(segment + size*PGSIZE),process);
        if(idx == -1)
          break;
        segment = (uint)process->pages[idx].virtual_addr;
      }
    } else {
      release(&shared_mem_table.lock);
      return (void*)-1;
    }

  }
  if((shared_mem_flag & SHM_RDONLY) || (shared_mem_table.all_regions[index].buffer.shared_mem_perm.mode == READ_SHM)){
    perm_flag = PTE_U;
  }
  else if (shared_mem_table.all_regions[index].buffer.shared_mem_perm.mode == RW_SHM) {
    perm_flag = PTE_W | PTE_U;
  } else {
    //permission mismatch between get and attach
    release(&shared_mem_table.lock);
    return (void*)-1;
  }
  for (int k = 0; k < shared_mem_table.all_regions[index].size; k++) {
		if(mappages(process->pgdir, (void*)((uint)va + (k*PGSIZE)), PGSIZE, (uint)shared_mem_table.all_regions[index].physical_addr[k], perm_flag) < 0) {
      deallocuvm(process->pgdir,(uint)va,(uint)(va + shared_mem_table.all_regions[index].size));
      release(&shared_mem_table.lock);
      return (void*)-1;
    }
	}
  idx = -1;
  for(int i = 0; i < SHAREDREGIONS; i++) {
    if(process->pages[i].key == -1) {
      idx = i;
      break;
    }
  }
  if(idx != -1) {
    process->pages[idx].shared_mem_id = shared_mem_id;  
    process->pages[idx].virtual_addr = va;
    process->pages[idx].key = shared_mem_table.all_regions[index].key;
    process->pages[idx].size = shared_mem_table.all_regions[index].size;
    process->pages[idx].perm = perm_flag;
    shared_mem_table.all_regions[index].buffer.shared_mem_number_of_attch += 1;
    shared_mem_table.all_regions[index].buffer.shared_mem_last_pid = process->pid;
  } else {
    release(&shared_mem_table.lock);
    return (void*)-1; // all page regions exhausted
  }
  release(&shared_mem_table.lock);
  return va;
}

/*
  Controls the shared memory regions corresponding to shared_mem_id,
  depending upon the cmd (command) provided and buf parameter,
  which is user equivalent of shared_mem_id_ds data structure
*/
int remove_shared_mem(int shared_mem_id, int cmd, void *buf) {
  if(shared_mem_id < 0 || shared_mem_id > 64){
    return -1;
  }
  acquire(&shared_mem_table.lock);
  struct shared_mem_id_DS *buffer = (struct shared_mem_id_DS *)buf;
  int index = -1;
  index = shared_mem_table.all_regions[shared_mem_id].shared_mem_id;
  if(index == -1) {
    release(&shared_mem_table.lock);
    return -1;
  } else {
    int check_perm = shared_mem_table.all_regions[index].buffer.shared_mem_perm.mode;
    switch(cmd) {
      case IPC_SET:
        if(buffer) {
          if((buffer->shared_mem_perm.mode == READ_SHM) || (buffer->shared_mem_perm.mode == RW_SHM)) {
            shared_mem_table.all_regions[index].buffer.shared_mem_perm.mode = buffer->shared_mem_perm.mode;
            release(&shared_mem_table.lock);
            return 0;
          } else {
            release(&shared_mem_table.lock);
            return -1;
          }
        } else {
          release(&shared_mem_table.lock);
          return -1;
        }
        break;
      case SHM_STAT:
      case IPC_STAT:
        if(buffer && (check_perm == READ_SHM || check_perm == RW_SHM)) {
          buffer->shared_mem_number_of_attch = shared_mem_table.all_regions[index].buffer.shared_mem_number_of_attch;
          buffer->shared_mem_segment_size = shared_mem_table.all_regions[index].buffer.shared_mem_segment_size;
          buffer->shared_mem_perm.__key = shared_mem_table.all_regions[index].buffer.shared_mem_perm.__key;
          buffer->shared_mem_perm.mode = check_perm;
          buffer->shared_mem_creator_pid = shared_mem_table.all_regions[index].buffer.shared_mem_creator_pid;
          buffer->shared_mem_last_pid = shared_mem_table.all_regions[index].buffer.shared_mem_last_pid;
          release(&shared_mem_table.lock);
          return 0;
        } else {
          release(&shared_mem_table.lock);
          return -1;
        }
        break;
      case IPC_RMID:
        if(shared_mem_table.all_regions[index].buffer.shared_mem_number_of_attch == 0) {
          for(int i = 0; i < shared_mem_table.all_regions[index].size; i++) {
            char *addr = (char *)P2V(shared_mem_table.all_regions[index].physical_addr[i]);
            kfree(addr);
            shared_mem_table.all_regions[index].physical_addr[i] = (void *)0;
          }
          shared_mem_table.all_regions[index].size = 0;
          shared_mem_table.all_regions[index].key = shared_mem_table.all_regions[index].shared_mem_id = -1;
          shared_mem_table.all_regions[index].to_be_deleted = 0;
          shared_mem_table.all_regions[index].buffer.shared_mem_number_of_attch = 0;
          shared_mem_table.all_regions[index].buffer.shared_mem_segment_size = 0;
          shared_mem_table.all_regions[index].buffer.shared_mem_perm.__key = -1;
          shared_mem_table.all_regions[index].buffer.shared_mem_perm.mode = 0;
          shared_mem_table.all_regions[index].buffer.shared_mem_creator_pid = -1;
          shared_mem_table.all_regions[index].buffer.shared_mem_last_pid = -1;
        } else {
          shared_mem_table.all_regions[index].to_be_deleted = 1;
        }
        release(&shared_mem_table.lock);
        return 0;
        break;
      default:
        release(&shared_mem_table.lock);
        return -1;
        break;
    }
  } 
}

// to initialize shared memory table
void shared_memory_init(void) {
  // initialize shared_mem_table lock
  initlock(&shared_mem_table.lock, "Shared Memory");
  acquire(&shared_mem_table.lock);
  // initialize all shared_mem_table values
  for(int i = 0; i < SHAREDREGIONS; i++) {
    shared_mem_table.all_regions[i].key = shared_mem_table.all_regions[i].shared_mem_id = -1;
    shared_mem_table.all_regions[i].size = 0;
    shared_mem_table.all_regions[i].to_be_deleted = 0;
    shared_mem_table.all_regions[i].buffer.shared_mem_number_of_attch = 0;
    shared_mem_table.all_regions[i].buffer.shared_mem_segment_size = 0;
    shared_mem_table.all_regions[i].buffer.shared_mem_perm.__key = -1;
    shared_mem_table.all_regions[i].buffer.shared_mem_perm.mode = 0;
    shared_mem_table.all_regions[i].buffer.shared_mem_creator_pid = -1;
    shared_mem_table.all_regions[i].buffer.shared_mem_last_pid = -1;
    for(int j = 0; j < SHAREDREGIONS; j++) {
      shared_mem_table.all_regions[i].physical_addr[j] = (void *)0;
    }
  }
  release(&shared_mem_table.lock);
}

// to return shared_mem_id index from shared_mem_table
int
get_shared_mem_id_index(int shared_mem_id) {
  if(shared_mem_id < 0 || shared_mem_id > 64) {
    return -1;
  }
  return shared_mem_table.all_regions[shared_mem_id].shared_mem_id;
}

void mappages_wrapper(struct proc *process, int shmIndex, int index) {
  for(int i = 0; i < process->pages[index].size; i++) {
    uint va = (uint)process->pages[index].virtual_addr;
    if(mappages(process->pgdir, (void*)(va + (i * PGSIZE)), PGSIZE, (uint)shared_mem_table.all_regions[shmIndex].physical_addr[i], process->pages[index].perm) < 0) {
      deallocuvm(process->pgdir, va, (uint)(va + shared_mem_table.all_regions[shmIndex].size));
      return;
    }
  }
}

void shared_mem_deattach_wrapper(void *addr) {
  // call deattac_shared_mem
  deattach_shared_mem(addr);
}


//PAGEBREAK!
// Blank page.
//PAGEBREAK!
// Blank page.
//PAGEBREAK!
// Blank page.

