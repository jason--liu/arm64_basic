#include "uart.h"
extern void ldr_test(void);
extern void memcpy_32bytes(void);
extern void label_test(void);
extern void mov_test(void);
extern void add_test(void);
extern void bit_test(void);
extern int csel_test(int a, int b);
extern int bl_test(void);
extern int adr_test(void);
extern unsigned long my_data;
extern unsigned long atomic_write(void *addr, unsigned long val);
extern int call_macro(int a, int b);

static inline void mem_copy_32bytes()
{
	asm volatile("ldr x0, =0x80000 \n\t"
		     "ldr x1, =0x200000 \n\t"
		     "mov x2, #32 \n\t"
		     "copy_loop: \n\t"
		     "ldrb w3, [x0], #1 \n\t"
		     "strb w3, [x1], #1 \n\t"
		     "subs x2, x2, #1  \n\t"
		     // compare to zero, if x2 !=0, coutinue
		     "bne copy_loop \n\t"
		     /* "ret" */
		     : // no output
		     : // no input
		     : "memory");
}

#define read_sysreg(reg)                                                       \
	({                                                                     \
		unsigned long _val;                                            \
		asm volatile("mrs %0, " #reg : "=r"(_val));                    \
		_val;                                                          \
	})

#define write_sysreg(val, reg)                                                 \
	({                                                                     \
		unsigned long _val = (unsigned long)val;                       \
		asm volatile("msr " #reg ", %x0" ::"rZ"(_val))                 \
	})

static void print_currentEL()
{
	unsigned long el;
	el = read_sysreg(CurrentEL);
	el = el >> 2;
}

int main()
{
	int ret = 0;
	unsigned long ab;
	uart_init();
	uart_send_string("Hello World.\n");

	mem_copy_32bytes();
	ret = call_macro(8, 9);
	print_currentEL();

	ret = csel_test(0, 2);

	ab = atomic_write(&my_data, 0x55);
	adr_test();
	bl_test();
	bit_test();
	add_test();
	mov_test();
	label_test();
	ldr_test();
	memcpy_32bytes();
	return 0;
}
