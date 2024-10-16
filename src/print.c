
void uart_send(char c);
void putchar(char c)
{
	if (c == '\n') {
		uart_send(
			'\r'); /* Add carriage return for new lines (optional) */
	}
	uart_send(c);
}

void printnum(int num)
{
	if (num == 0) {
		putchar('0');
		return;
	}

	char buffer[10];
	int i = 0;
	if (num < 0) {
		putchar('-');
		num = -num;
	}

	while (num > 0) {
		buffer[i++] = '0' + (num % 10);
		num /= 10;
	}

	while (i--) {
		putchar(buffer[i]);
	}
}

void printf(const char *fmt, ...)
{
	const char *s;
	int d;

	/* Loop over each character in the format string */
	for (; *fmt != '\0'; fmt++) {
		if (*fmt == '%') {
			fmt++; /* Move past '%' */
			switch (*fmt) {
			case 'd': /* Print an integer */
				d = *((int *)(&fmt +
					      1)); /* Get next argument (integer) */
				(fmt)++; /* Increment argument pointer */
				printnum(d);
				break;
			case 's': /* Print a string */
				s = *((char **)(&fmt +
						1)); /* Get next argument (string) */
				(fmt)++; /* Increment argument pointer */
				while (*s) {
					putchar(*s++);
				}
				break;
			default:
				putchar('%');
				putchar(*fmt); /* Handle unknown format specifier */
				break;
			}
		} else {
			putchar(*fmt); /* Regular character, print it */
		}
	}
}
