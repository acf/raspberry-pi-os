#ifndef	_FULL_UART_H
#define	_FULL_UART_H

void full_uart_init ( void );
char full_uart_recv ( void );
void full_uart_send ( char c );
void full_uart_send_string(char* str);

#endif  /*_FULL_UART_H */
