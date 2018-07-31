#include <stdio.h>
#include <stdlib.h>
#include "platform.h"
#include <string.h>
#include "plic/plic_driver.h"
#include "encoding.h"
#include <unistd.h>


void set_timer() {
  static uint64_t then = 0;

  volatile uint64_t * mtime       = (uint64_t*) (CLINT_CTRL_ADDR + CLINT_MTIME);
  volatile uint64_t * mtimecmp    = (uint64_t*) (CLINT_CTRL_ADDR + CLINT_MTIMECMP);
  if(then != 0)  {
    //next timer irq is 1 second from previous
    then += 1*RTC_FREQ/100;
  } else{ //first time setting the timer
    uint64_t now = *mtime;
    then = now + 1*RTC_FREQ/100;
  }
  *mtimecmp = then;

  set_csr(mie, MIP_MTIP);
}
