#include "mm.h"
#include "sysregs.h"

.section .text.boot
.global _start


_start:
    mrs x0, mpidr_el1
    and x0, x0,0xFF
    cmp x0,#0
    bne proc_hang

_start_cpu0:
 //   ;; ldr x1,  =stack_top
  //  ;; mov sp, #4096*8

    mrs x5, CurrentEL
    cmp x5, #CurrentEL_EL3
    b.ne el2_entry

clear_bss:
    // clear bss
    ldr x1, =_bss_start
    ldr x2, =_bss_end
    cmp x1, x2
    b.ge done_bss
    str xzr, [x1], #8
    b clear_bss

done_bss:
    mov sp, #4096*8
    bl main
    b proc_hang
proc_hang:
    wfi
    b   proc_hang

    .type el2_entry, %function
    .global el2_entry
el2_entry:
    ldr x0, =HCR_HOST_NVHE_FLAGS
    msr hcr_el2, x0

    // the value of spsr will restore to pstate after eret
    ldr x0, =SPSR_EL1
    msr spsr_el2, x0

    // set exception return address
    adr x0, clear_bss
    msr elr_el2, x0
    eret

    .size el2_entry, (. - el2_entry)
// .section .bss
//;;     .align 3
//;; stack_base:
//;;     .skip 0x1000
//;; stack_top:
//
//;; .section .text
//;; _bss_start:  .word 0
//;; _bss_end:  .word 0
