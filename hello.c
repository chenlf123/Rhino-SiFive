#include <stdio.h>
#include <stdlib.h>
#include "platform.h"
#include <string.h>
#include "plic/plic_driver.h"
#include "encoding.h"
#include <unistd.h>
#include <csi_kernel.h>

int test_func(int a)
{
    if (a != 0) return a;
    else return a+1;
}

void handle_m_time_interrupt(){
//  puts("timer\n");
  csi_kernel_intrpt_enter();
  static uint32_t onoff=1;

  clear_csr(mie, MIP_MTIP);

  set_timer();
  systick_handler();
  csi_kernel_intrpt_exit();
}

#define EXAMPLE_PRIO    5
#define EXAMPLE_TASK_STK_SIZE 1024

k_task_handle_t example_main_task;

void example_main(void)
{
    int i = 0;

    while (1) {
        printf("Hello World! %d\n", i++);
        csi_kernel_delay_ms(1000);
    }
}


int main()
{
  puts("hello world!\n");
  set_timer();

  // Enable Global (PLIC) interrupts.
  set_csr(mie, MIP_MEIP);

  // Enable all interrupts
//  set_csr(mstatus, MSTATUS_MIE);

  csi_kernel_init();
  csi_kernel_task_new((k_task_entry_t)example_main, "example_main",
                      0, EXAMPLE_PRIO, 0, 0, EXAMPLE_TASK_STK_SIZE, &example_main_task);

  csi_kernel_start();

  test_func(1);

  while(1);

  return 0;
}
