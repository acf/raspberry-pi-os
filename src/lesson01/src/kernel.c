#include "full_uart.h"
#include "utils.h"

unsigned int uart_initialised = 0;

void kernel_main(int procid)
{
	if(procid == 0) {
		full_uart_init();
	} else {
		delay(100000 * procid);
	}	
	
	full_uart_send_string("Hello, from processor ");
	full_uart_send(procid+'0');
	full_uart_send_string("\r\n");

	if(procid == 0) {
		while (1) {
			full_uart_send(full_uart_recv());
		}
	}
}