#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

int
sys_yield(void)
{
  yield();
  return 0;
}

int sys_shutdown(void)
{
  shutdown();
  return 0;
}

int sys_settickets(void) {
  int ticketnum;
  struct proc *curproc = myproc();

  argint(0, &ticketnum);
  curproc->tickets = ticketnum;
  return 0;
}

int sys_gettickets(void) {
  return myproc()->tickets;
}

int sys_getprocessinfo(void) {
  int np;
  struct processes_info *p;

  np = getnumprocesses();
  // traverses ptable for number of non-UNUSED process
  argptr(0, &p, sizeof(*p));
  p->num_processes = np;

  struct proc *proc;
  int i;
  for(i = 0; i < np; i++) {
    // assigns values for each ith non-UNUSED process
    proc = getproc(i);
    p->pids[i] = proc->pid;
    p->times_scheduled[i] = proc->times_scheduled;
    p->tickets[i] = proc->tickets;
  }

  return 0;
}
