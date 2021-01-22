#include <mega128.h>
#include "UART.h"

void putchar(char c)
{
    while((UCSR1A & DATA_REGISTER_EMPTY) == 0);
    UDR1 = c;
}

unsigned char getchar(void)
{
    while( (UCSR1A & RX_COMPLETE) == 0);
    return UDR1;
}

void InitializeUART(void)
{
    UCSR1A=0x00;
    UCSR1B=0x18;
    UCSR1C=0x06;
    UBRR1H=0x00;
    UBRR1L=0x67;
}