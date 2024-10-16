#include "uart.h"

int main()
{
	/* int a, b; */
	/* a = 1; */
	/* b = a + 4; */
	uart_init();
	uart_send_string("Hello World.\n");

	return 0;
}
