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

.type bit_test, %function
    .global bit_test
bit_test:
    // bfi xd, xn, #lsb, #width
    // xd[lsb, width-1] = xn[0, width-1]
    mov x1, #0x345
    bfi x0, x1, 8, 4 // x0=0x500

    // ubfx xd, xn, #lsb, #width
    // xd[0, width-1] = xn[lsb, width-1]
    // sbfx xd, xn, #lsb, #width
    ldr x2, =0xdeadfeaf
    ubfx x3, x2, 0, #16 // x3=0xfeaf
    sbfx x4, x2, 0, #16 // x4=0xfffffffffffffeaf

    mrs x0, ID_AA64ISAR0_EL1
    ubfx x0, x0, 20, 4
    ret
    .size bit_test, (. - bit_test)


/* unsigned long csel_test(unsigned long a, unsigned b) */
/* { */
/* 	if (a == 0) */
/* 		return b + 2; */
/* 	else */
/* 		return b - 1; */
/* } */
.type csel_test, %function
    .global csel_test
csel_test:
    add x2, x1, #2
    sub x3, x1, #1
    cmp x0, xzr
    csel x0, x2, x3, eq
    ret
    .size csel_test, (. - csel_test)

.type bl_test2, %function
    .global bl_test2
bl_test2:
    mov x1, #2
    ret
    .size bl_test2, (. - bl_test2)

.type bl_test, %function
    .global bl_test
bl_test:
    mov x0, #3
    mov x3, x30
    bl bl_test2
    mov x30, x3
    ret
    .size bl_test, (. - bl_test)

.align 3
    .global test_data1
test_data1:
    .dword 0x12345678deadbeaf
.type adr_test, %function
    .global adr_test
adr_test:
    adrp x1, init_pg_dir
    ldr x1, test_data1
    ldr x2, =test_data1
    adr x3, test_data1
    adrp x4, test_data1 // load address of the begining of the 4k memory page whick contains the label using pc-relative imme addressing.
    add x4, x4, #:lo12:test_data1
    ret
    .size adr_test, (. - adr_test)

    .data
    .global my_data
    .align 3   // On Armv8
my_data:
    .dword 0xdead889977   // 8bytes
    .text
.type atomic_write, %function
    .global atomic_write
atomic_write:
    //adr x6, my_data // x6 store the address of my_data
1:
    ldxr x2, [x0]
    //orr x2, x2, x0
    mov x2, x1
    stxr w3, x2, [x0]  // w3=0, success
    cbnz w3, 1b
    mov x0, x2
    ret
    .size atomic_write, (. - atomic_write)

    .macro add_ma a, b, label
    mov x0, \a
    mov x1, \b
    bl add_\()\label
    .endm

    .type add_1, %function
add_1:
    add x2, x1, #1
    add x0, x0, x2
    ret
    .size add_1, (. - add_1)

    .type add_2, %function
add_2:
    add x2, x1, #2
    add x0, x0, x2
    ret
    .size add_2, (. - add_2)

.type call_macro, %function
    .global call_macro
call_macro:
    mov x6, x30
    add_ma x0, x1, 1
    mov x30, x6
    ret
    .size call_macro, (. - call_macro)
