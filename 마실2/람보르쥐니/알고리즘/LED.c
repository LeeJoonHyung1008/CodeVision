
#include <mega128.h>
#include <delay.h>
#include "LED.h"
void InitializeLED(void)
{
     // LED - PORTF 4,5,6,7 
     PORTF &= 0x0F;
     DDRF |= 0xF0;
}
void LED_OFF(int nLED)
{
     PORTF |= nLED;
}

void LED_ON(int nLED)
{
     PORTF &= ~(nLED);
}
