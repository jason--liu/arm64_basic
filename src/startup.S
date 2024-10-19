#include "mm.h"

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

    // clear bss
    ldr x1, =_bss_start
    ldr x2, =_bss_end
clear_bss:
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


//;; .section .bss
//;;     .align 3
//;; stack_base:
//;;     .skip 0x1000
//;; stack_top:
//
//;; .section .text
//;; _bss_start:  .word 0
//;; _bss_end:  .word 0
