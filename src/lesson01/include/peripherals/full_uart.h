#ifndef	_P_FULL_UART_H
#define	_P_FULL_UART_H

#include "peripherals/base.h"

#define UART_REG_BASE	(PBASE+0x00201000)

#define UART_DATA_REG   (UART_REG_BASE+0x00)
#define UART_FLAG_REG   (UART_REG_BASE+0x18)
#define UART_IBRD_REG   (UART_REG_BASE+0x24)
#define UART_FBRD_REG   (UART_REG_BASE+0x28)
#define UART_LCRH_REG   (UART_REG_BASE+0x2C)
#define UART_CTRL_REG   (UART_REG_BASE+0x30)


#define MHZ       *1000000
#define SYSCLK    250 MHZ
#define UARTCLK	   48 MHZ

#define BAUD_RATE 9600

#define UART_BAUD_DIV	((double)UARTCLK)/(16*BAUD_RATE)
#define UART_IBRD 	(unsigned int)(UART_BAUD_DIV)
#define UART_FBRD	(unsigned int)((UART_BAUD_DIV-UART_IBRD)*64 + .5)
#endif  /*_P_FULL_UART_H */
