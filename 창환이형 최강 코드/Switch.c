#include <mega128.h>
#include <delay.h>
#include "Switch.h"

struct Buttons
{
    char SW1;
    char SW2;
} Button;

void InitializeSwitch(void)
{
    PORTD &= 0xFC;
    DDRD &= 0xFC;
    EICRA = 0x0A;
    EICRB = 0x00;
    EIMSK = 0x03;
    EIFR = 0x03;
    Button.SW1 = FALSE;
    Button.SW2 = FALSE;
}

char SW1(void)
{
    char ret = Button.SW1;
    Button.SW1 = FALSE;
    return ret;
}

char SW2(void)
{
    char ret = Button.SW2;
    Button.SW2 = FALSE;
    return ret;
}

interrupt [EXT_INT0] void ext_int0_isr(void)
{
    Button.SW1 = TRUE;
    delay_ms(150);
}

interrupt [EXT_INT1] void ext_int1_isr(void)
{
    Button.SW2 = TRUE;
    delay_ms(150);
}