
/* Enable interrupts when returning from the handler */
#define MSTATUS_PRV1 0x1880

/******************************************************************************
 * Functions:
 *     size_t cpu_intrpt_save(void);
 *     void   cpu_intrpt_restore(size_t psr);
 ******************************************************************************/

.global cpu_intrpt_save
.type cpu_intrpt_save, %function
cpu_intrpt_save:
    csrr    a0, mstatus
    csrc    mstatus, 8
    ret

.global cpu_intrpt_restore
.type cpu_intrpt_restore, %function
cpu_intrpt_restore:
    csrw    mstatus, a0
    ret

/******************************************************************************
 * Functions:
 *     void cpu_intrpt_switch(void);
 *     void cpu_task_switch(void);
 ******************************************************************************/

.global cpu_task_switch
.type cpu_task_switch, %function
cpu_task_switch:
    la     a0, g_intrpt_nested_level
    lb     a0, (a0)
    beqz   a0, __task_switch

    la     a0, g_active_task
    la     a1, g_preferred_ready_task
    lw     a2, (a1)
    sw     a2, (a0)

    ret

.global cpu_intrpt_switch
.type cpu_intrpt_switch, %function
cpu_intrpt_switch:
    la     a0, g_active_task
    la     a1, g_preferred_ready_task
    lw     a2, (a1)
    sw     a2, (a0)

    ret

/******************************************************************************
 * Functions:
 *     void cpu_first_task_start(void);
 ******************************************************************************/
.global cpu_first_task_start
.type cpu_first_task_start, %function
cpu_first_task_start:
    j       __task_switch_nosave

/******************************************************************************
 * Functions:
 *     void __task_switch(void);
 ******************************************************************************/

.type __task_switch, %function
__task_switch:
    addi    sp, sp, -128

    sw      x1, 0(sp)
    sw      x2, 4(sp)
    sw      x3, 8(sp)
    sw      x4, 12(sp)
    sw      x5, 16(sp)
    sw      x6, 20(sp)
    sw      x7, 24(sp)
    sw      x8, 28(sp)
    sw      x9, 32(sp)
    sw      x10, 36(sp)
    sw      x11, 40(sp)
    sw      x12, 44(sp)
    sw      x13, 48(sp)
    sw      x14, 52(sp)
    sw      x15, 56(sp)
    sw      x16, 60(sp)
    sw      x17, 64(sp)
    sw      x18, 68(sp)
    sw      x19, 72(sp)
    sw      x20, 76(sp)
    sw      x21, 80(sp)
    sw      x22, 84(sp)
    sw      x23, 88(sp)
    sw      x24, 92(sp)
    sw      x25, 96(sp)
    sw      x26, 100(sp)
    sw      x27, 104(sp)
    sw      x28, 108(sp)
    sw      x29, 112(sp)
    sw      x30, 116(sp)
    sw      x31, 120(sp)

    sw      ra, 124(sp)

    la      a1, g_active_task
    lw      a1, (a1)
    sw      sp, (a1)

__task_switch_nosave:
    la      a0, g_preferred_ready_task
    la      a1, g_active_task
    lw      a2, (a0)
    sw      a2, (a1)

    lw      sp, (a2)

    /* Run in machine mode */
    li      t0, MSTATUS_PRV1
    csrs    mstatus, t0

    lw      t0, 124(sp)
    csrw    mepc, t0

    lw      x1, 0(sp)
    lw      x3, 8(sp)
    lw      x4, 12(sp)
    lw      x5, 16(sp)
    lw      x6, 20(sp)
    lw      x7, 24(sp)
    lw      x8, 28(sp)
    lw      x9, 32(sp)
    lw      x10, 36(sp)
    lw      x11, 40(sp)
    lw      x12, 44(sp)
    lw      x13, 48(sp)
    lw      x14, 52(sp)
    lw      x15, 56(sp)
    lw      x16, 60(sp)
    lw      x17, 64(sp)
    lw      x18, 68(sp)
    lw      x19, 72(sp)
    lw      x20, 76(sp)
    lw      x21, 80(sp)
    lw      x22, 84(sp)
    lw      x23, 88(sp)
    lw      x24, 92(sp)
    lw      x25, 96(sp)
    lw      x26, 100(sp)
    lw      x27, 104(sp)
    lw      x28, 108(sp)
    lw      x29, 112(sp)
    lw      x30, 116(sp)
    lw      x31, 120(sp)

    addi    sp, sp, 128
    mret

/******************************************************************************
 * Functions:
 *     void NOVIC_IRQ_Default_Handler(void);
 * novic default irq entry
 ******************************************************************************/

.global NOVIC_IRQ_Default_Handler
.type   NOVIC_IRQ_Default_Handler, %function
NOVIC_IRQ_Default_Handler:
    addi    sp, sp, 4
    addi    sp, sp, -128

    sw      x1, 0(sp)
    sw      x2, 4(sp)
    sw      x3, 8(sp)
    sw      x4, 12(sp)
    sw      x5, 16(sp)
    sw      x6, 20(sp)
    sw      x7, 24(sp)
    sw      x8, 28(sp)
    sw      x9, 32(sp)
    sw      x10, 36(sp)
    sw      x11, 40(sp)
    sw      x12, 44(sp)
    sw      x13, 48(sp)
    sw      x14, 52(sp)
    sw      x15, 56(sp)
    sw      x16, 60(sp)
    sw      x17, 64(sp)
    sw      x18, 68(sp)
    sw      x19, 72(sp)
    sw      x20, 76(sp)
    sw      x21, 80(sp)
    sw      x22, 84(sp)
    sw      x23, 88(sp)
    sw      x24, 92(sp)
    sw      x25, 96(sp)
    sw      x26, 100(sp)
    sw      x27, 104(sp)
    sw      x28, 108(sp)
    sw      x29, 112(sp)
    sw      x30, 116(sp)
    sw      x31, 120(sp)

    csrr    t0, mepc
    sw      t0, 124(sp)

    la      a0, g_active_task
    lw      a0, (a0)
    sw      sp, (a0)

    la      sp, g_top_irqstack

    jal     handle_m_time_interrupt

    la      a0, g_active_task
    lw      a0, (a0)
    lw      sp, (a0)

    /* Run in machine mode */
    li      t0, MSTATUS_PRV1
    csrs    mstatus, t0

    lw      t0, 124(sp)
    csrw    mepc, t0

    lw      x1, 0(sp)
    lw      x3, 8(sp)
    lw      x4, 12(sp)
    lw      x5, 16(sp)
    lw      x6, 20(sp)
    lw      x7, 24(sp)
    lw      x8, 28(sp)
    lw      x9, 32(sp)
    lw      x10, 36(sp)
    lw      x11, 40(sp)
    lw      x12, 44(sp)
    lw      x13, 48(sp)
    lw      x14, 52(sp)
    lw      x15, 56(sp)
    lw      x16, 60(sp)
    lw      x17, 64(sp)
    lw      x18, 68(sp)
    lw      x19, 72(sp)
    lw      x20, 76(sp)
    lw      x21, 80(sp)
    lw      x22, 84(sp)
    lw      x23, 88(sp)
    lw      x24, 92(sp)
    lw      x25, 96(sp)
    lw      x26, 100(sp)
    lw      x27, 104(sp)
    lw      x28, 108(sp)
    lw      x29, 112(sp)
    lw      x30, 116(sp)
    lw      x31, 120(sp)

    addi    sp, sp, 128
    mret
