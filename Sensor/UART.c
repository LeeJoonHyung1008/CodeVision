#include <mega128.h>
#include "UART.h"

// Write a character to the USART1 Transmitter
void putchar(char c){
    while((UCSR1A & DATA_REGISTER_EMPTY)==0);
    UDR1=c;
}

// Read a character from the USART1 Receiver
unsigned char getchar(void){
    while((UCSR1A & RX_COMPLETE)==0);
    return UDR1;
}
