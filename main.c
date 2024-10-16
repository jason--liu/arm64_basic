
void uart_init(void);
void printf(const char *fmt, ...);

int main()
{
	/* int a, b; */
	/* a = 1; */
	/* b = a + 4; */
	uart_init();
	printf("Hello World.\n");

	return 0;
}
