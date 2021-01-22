#include <mega128.h>
#include "LED.h"

void InitializeLED(void){
    // Initialize PORTF 4,5,6,7 as output for LED
    PORTF &= 0x0F;
    DDRF |= 0xF0;
}

void LED_ON(int nLED){
    PORTF &= ~(nLED);
}

void LED_OFF(int nLED){
    PORTF |= nLED;
}