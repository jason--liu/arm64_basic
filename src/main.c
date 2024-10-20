#include "uart.h"
extern void ldr_test(void);
extern void memcpy_32bytes(void);

int main()
{
	uart_init();
	uart_send_string("Hello World.\n");
	ldr_test();
	memcpy_32bytes();
	return 0;
}
