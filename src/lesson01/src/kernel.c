#include "full_uart.h"

void kernel_main(void)
{
	full_uart_init();
	full_uart_send_string("Hello, world!\r\n");

	while (1) {
	//	uart_send(uart_recv());
		full_uart_send_string("Hello, again!\r\n");
	}
}
