    .global string1
string1:
    .string "Boot at EL"

.align 3
    .global test_data
test_data:
    .word 0x55

.align 3
    .type label_test, %function
    .global label_test
label_test:
    /* load a huge number */
    ldr x1, = 0xFFFFFFFFdeadbeaf
    /* initialize register */
    ldr x2, = (1<<0) | (1<<2) | (1<<20) | (1<<40) | (1<<55)

    /* what's the difference? */
    ldr x0, string1     // x0 is ascii code of the string
    ldr x0, =string1    // x0 is start address of the string

    /* difference? */
    ldr x0, test_data   // loads the value stored at the memory address test_data, in this contest, x0=0x55
    ldr x0, =test_data  // loads the address of the memory location of test_data info x1, like x0=0x80528
    ret
    .size label_test, (. - label_test)

    .type memcpy_32bytes, %function
    .global memcpy_32bytes
memcpy_32bytes:
    ldr x0, =0x80000
    ldr x1, =0x200000
    mov x2, #32
    /* This case can help you have a deeper understranding
    * about load/store architecture, data must be loaded in a register
    * before it can be used for any data processing instruction.
    */
copy_loop:
    ldrb w3, [x0], #1
    strb w3, [x1], #1
    subs x2, x2, #1
    // compare to zero, if x2 !=0, coutinue
    bne copy_loop
    ret
    .size memcpy_32bytes, (. - memcpy_32bytes)


#define TEST_LABEL 0x20
    /* with %function directive, you can see F in objdump output, which can be useful for debug purpose. */
    .type ldr_test, %function
    .global ldr_test

ldr_test:
    ldr x6, TEST_LABEL  // read the value of address at (pc + label offset)
    ldr x7, =TEST_LABEL // x7 = 0x20


    mov x2, 0x400000
    ldr x6, =0x1234abce
    str x6, [x2, #8]!

    mov x2, 0x500000
    str x6, [x2], #8

/**************pre-indexed or post-indexed addressing******************/
    // pre-index
    // x1 = x1 + 8, x6 = [0x80008]
    ldr x6, [x1, #8]!
    // post-index
    // x7 = [0x80008], x1 = x1 + 8
    ldr x7, [x1], #8


    // ldr base offset
    mov x1, 0x80000
    mov x3, #16
    ldr x0, [x1]
    ldr x2, [x1, #8]
    ldr x4, [x1, x3]
    /* read (x1 + x3<<3)*/
    ldr x5, [x1, x3, lsl #3]
    ret
    .size ldr_test, (. - ldr_test)

    .global mov_test
    .type mov_test, %function
mov_test:
    mov x0, 1               /* 16-bits immediate nums */
    mov x1, #0x20000
    movz x2, #1, lsl #16    /* shift 16, 32, 46 bits */
    ret
    .size mov_test, (. - mov_test)

.type add_test, %function
    .global add_test
add_test:
    ldr x0, =0xffffffffffffffff
    add x1, x0, 1  /* overflow, C flag set */
    adc x2, xzr, xzr

    /* cmp affects on C flag */
    /* if x0 > x1, C=1 */
    /* if x0 < x1, C=0 */
    cmp x0, x1
    adc x3, xzr, xzr

    mov x1, #0x5
    mov x2, #0
    ands x3, x1, x2
    mrs x0, nzcv /* bit31~bit28: N Z C V */

    /* logical shift left */
    mov x0, #0b00001111 // 15
    lsl x1, x0, #2    // 15 << 2 = 60
    /* logical shift right */
    lsr x3, x0, #2    // 15 >> 2 = 3
    /* arithmetic shift right */
    mov x0, #0b11110000
    asr x0, x0, #2   // x0 = 0b11111100
    /* rotate right */
    mov x0, #0b10110011
    ror x0, x0, #3 // 0b01110110


    ret
    .size add_test, (. - add_test)
