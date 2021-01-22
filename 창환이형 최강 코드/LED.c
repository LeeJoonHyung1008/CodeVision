#include <mega128.h>
#include "LED.h"

void InitializeLED(void)
{
    PORTF &= 0x0F;
    DDRF |= 0xF0;
}

void LED_ON(int nLED)
{
    PORTF &= ~(nLED);
}

void LED_OFF(int nLED)
{
    PORTF |= nLED;
}