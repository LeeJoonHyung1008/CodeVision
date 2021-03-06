#include <mega128.h>
#include <mega128.h>
#include "switch.h"
#include "LED.h"
#include <delay.h>

char switch1;
char switch2;
int i =0;
int j =0;
int count_SW = 0;
int flag = 1;

void InitializeSwitch(void)
{
// 스위치 PORTD 0,1
// External Interrupt(s) initialization
// INT0: On
// INT0 Mode: Low level
// INT1: On
// INT1 Mode: Falling Edge
// INT2: Off
// INT3: Off
// INT4: Off
// INT5: Off
// INT6: Off
// INT7: Off
EICRA=0x0A;
EICRB=0x00;
EIMSK=0x03;
EIFR=0x03;
#asm("sei")
}

/*
// Declare your global variables here
     struct Buttons{
          char SW1;
          char SW2;
          } ;
  Buttons Button; 
*/

                   
// External Interrupt 0 service routine
interrupt [EXT_INT0] void ext_int0_isr(void)
{
// Place your code here
    if(EICRA == 0x0A)   // 둘다 falling edge
    {
        flag = 0;
        EICRA = 0x09;   
    }
    else if(EICRA == 0x09)  // SW1 lowlevel
    {
        flag = 1;
        EICRA = 0x0A;
    }
//     switch1 = TRUE;
//     count_SW++;
}

// External Interrupt 1 service routine
interrupt [EXT_INT1] void ext_int1_isr(void)
{
// Place your code here
     switch2 = TRUE;
}

char SW1(void)
{
     char ret;
     
     ret = switch1;
     switch1 = FALSE;
     
     return ret;     
}

char SW2(void)
{
     char ret;
     
     ret = switch2;
     switch2 = FALSE;
     
     return ret;     
}

void main(void)
{
// Declare your local variables here

     InitializeSwitch();
     InitializeLED();
     
     switch1 = TRUE;
     switch2 = FALSE;

// Global enable interrupts
#asm("sei")

while (1)
      {                   // 누르면 True, 안누르면 False ,,
     while(flag == 0) 
     {
        PORTF=~(0x10<<j);
        delay_ms(1000);
        j++;
        if(j >3)
        {
            j = j%4;
        }
        PORTF = 0xFF;
        if(flag == 1)
        break;    
    }         
    PORTF=~(0x10<<(j-1));
    if(SW2() == TRUE)
    {
        PORTF = 0x00;
        j = 0;
    }
    
    }
//    PORTF = 0xFF; 
}