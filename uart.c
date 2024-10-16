#define UART1_BASE 0xFE215040 /* Base address for Mini UART registers */
#define GPFSEL1 0xFE200004 /* GPIO Function Select 1 */
#define GPSET0 0xFE20001C /* GPIO Pin Output Set 0 */
#define GPCLR0 0xFE200028 /* GPIO Pin Output Clear 0 */
#define GPPUD 0xFE200094 /* GPIO Pin Pull-up/down Enable */
#define GPPUDCLK0 0xFE200098 /* GPIO Pin Pull-up/down Enable Clock 0 */

#define AUX_ENABLES 0xFE215004 /* Auxiliary enables */
#define AUX_MU_IO_REG 0xFE215040 /* Mini UART I/O Data */
#define AUX_MU_IER_REG 0xFE215044 /* Mini UART Interrupt Enable */
#define AUX_MU_IIR_REG 0xFE215048 /* Mini UART Interrupt Identify */
#define AUX_MU_LCR_REG 0xFE21504C /* Mini UART Line Control */
#define AUX_MU_MCR_REG 0xFE215050 /* Mini UART Modem Control */
#define AUX_MU_LSR_REG 0xFE215054 /* Mini UART Line Status */
#define AUX_MU_BAUD_REG 0xFE215068 /* Mini UART Baudrate */

void uart_init(void)
{
	unsigned int selector;

	/* Configure GPIO pins 14 and 15 for UART1 (Mini UART) */
	selector = *((volatile unsigned int *)GPFSEL1);
	selector &= ~(7 << 12); /* Clear GPIO14 */
	selector |= 4 << 12; /* Set GPIO14 to ALT5 (TXD1) */
	selector &= ~(7 << 15); /* Clear GPIO15 */
	selector |= 4 << 15; /* Set GPIO15 to ALT5 (RXD1) */
	*((volatile unsigned int *)GPFSEL1) = selector;

	/* Disable pull-up/down on GPIO14 and GPIO15 */
	*((volatile unsigned int *)GPPUD) = 0;
	for (int i = 0; i < 150; i++)
		asm volatile("nop");
	*((volatile unsigned int *)GPPUDCLK0) = (1 << 14) | (1 << 15);
	for (int i = 0; i < 150; i++)
		asm volatile("nop");
	*((volatile unsigned int *)GPPUDCLK0) = 0;

	/* Enable Mini UART (UART1) */
	*((volatile unsigned int *)AUX_ENABLES) = 1;

	/* Disable UART interrupts */
	*((volatile unsigned int *)AUX_MU_IER_REG) = 0;

	/* Set UART to 8-bit mode */
	*((volatile unsigned int *)AUX_MU_LCR_REG) = 3;

	/* Disable RTS */
	*((volatile unsigned int *)AUX_MU_MCR_REG) = 0;

	/* Set baud rate to 115200 */
	unsigned int baud_reg =
		(250000000 / (115200 * 8)) - 1; /* Assuming 250MHz clock */
	*((volatile unsigned int *)AUX_MU_BAUD_REG) = baud_reg;

	/* Enable transmitter and receiver */
	*((volatile unsigned int *)AUX_MU_IIR_REG) = 0xC6;
}

int uart_is_transmit_ready(void)
{
	return (*((volatile unsigned int *)AUX_MU_LSR_REG) & 0x20) != 0;
}

void uart_send(char c)
{
	while (!uart_is_transmit_ready()) {
		/* Wait until UART is ready to transmit */
	}
	*((volatile unsigned int *)AUX_MU_IO_REG) = c;
}

char uart_recv(void)
{
	while (!(*((volatile unsigned int *)AUX_MU_LSR_REG) & 0x01)) {
		/* Wait until data is available to read */
	}
	return *((volatile unsigned int *)AUX_MU_IO_REG);
}
