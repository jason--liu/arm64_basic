#include "uart.h"
extern void ldr_test(void);
extern void memcpy_32bytes(void);
extern void label_test(void);
extern void mov_test(void);
extern void add_test(void);
extern void bit_test(void);

int main()
{
	uart_init();
	uart_send_string("Hello World.\n");

	bit_test();
	add_test();
	mov_test();
	label_test();
	ldr_test();
	memcpy_32bytes();
	return 0;
}
