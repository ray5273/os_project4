#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"


//status
int *val;

//lock
typedef uint lock_t;
lock_t lock = 1 ;
void 
lockinit(volatile lock_t *lock){
   *lock = 1 ;  
}

void
lock_acquire(volatile lock_t *lock){
    while(xchg(lock,0) ==0);
}

void
lock_release(volatile lock_t *lock){
    *lock = 1;
}


int thread_create(void *(*function)(void *), int priority, void *arg, void *stack){
    int tid;

    if((tid = clone(function,arg,(void*)stack))!=0)
        return tid;
    return tid;

}

void thread_exit(void *retval){
    exit_thread((void*)retval);
}

// exit의 retval 이면 join 가능 
//**retval : retval 's pointer
//thread_join 의 retval 에 exit의 retval을 저장하면 됨
//해당 tid 를 가진 thread가 종료되는걸 기다린다.
int thread_join(int tid, void **retval){

    //종료되면 메모리들을 반환해줌
    //성공시 0 return 아니면 -1return
       lock_acquire(&lock);
       if(wait_thread(tid,retval) <0)
           return-1;
       lock_release(&lock);
       return 0;
}

int gettid(void){ 
    //tid 0부터 시작해서 이미 있으면 ++ 해줘서 return 해줄듯?
    return proc->tid;
}
