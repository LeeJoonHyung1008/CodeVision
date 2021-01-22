#include <mega128.h>
#include "switch.h"
#include "LED.h"

// Declare your global variables here
struct Buttons{
    char SW1;
    char SW2;
}Button; 

// External Interrupt 0 service routine
interrupt [EXT_INT0] void ext_int0_isr(void)
{
// Place your code here
     Button.SW1 = TRUE;
}

// External Interrupt 1 service routine
interrupt [EXT_INT1] void ext_int1_isr(void)
{
// Place your code here
     Button.SW2 = TRUE;
}

void InitializeSwitch(void)
{
// ����ġ PORTD 0,1
     PORTD &= 0xfc;
     DDRD &= 0xfc;
     
     EICRA=0x0A;
     EICRB=0x00;
     EIMSK=0x03;
     EIFR=0x03;
}
char SW1(void)
{
     char ret;
     
     ret = Button.SW1;
     Button.SW1 = FALSE;
     
     return ret;     
}

char SW2(void)
{
     char ret;
     
     ret = Button.SW2;
     Button.SW2 = FALSE;
     
     return ret;     
}