#include <mega128.h>
#include <delay.h>
#include "LED.h"
#include "Switch.h"

/*
// Declare your global variables here
     struct Buttons{
          char SW1;
          char SW2;
          } ;
  Buttons Button; 
*/
char switch1;
char switch2;
int i = 0;
int j = 0;
int count_SW = 0;
                   
// External Interrupt 0 service routine
interrupt [EXT_INT0] void ext_int0_isr(void)
{
// Place your code here
     switch1 = TRUE;
//     count_SW++;
}

// External Interrupt 1 service routine
interrupt [EXT_INT1] void ext_int1_isr(void)
{
// Place your code here
     switch2 = TRUE;
}
  
void InitializeSwitch(void)
{
// ����ġ PORTD 0,1
     PORTD &= 0xfc;
     DDRD &= 0xfc;

// External Interrupt(s) initialization
// INT0: On
// INT0 Mode: Falling Edge
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
     
     switch1 = FALSE;
     switch2 = FALSE;

// Global enable interrupts
#asm("sei")

while (1)
      { 
      if(SW1() == TRUE)
     {
          count_SW++;
     }  
      if(count_SW == 1)
     {             
        PORTF = 0xFF;
        LED_ON(LED1);
     }
      if(count_SW == 2)
     {     
        PORTF = 0xFF;
        LED_ON(LED2);
     }
      if(count_SW == 3)
     {  
        PORTF = 0xFF;
        LED_ON(LED3);
     }           
      // Place your code here
      
     if(SW2() == TRUE)
     {      
        if(count_SW == 1)
            {
            int j; 
            
            for(j=0; j<10; j++)
            {
                LED_ON(LED1);
                LED_ON(LED2);
                LED_ON(LED3);
                LED_ON(LED4);
                delay_ms(500);
                LED_OFF(LED1); 
                LED_OFF(LED2);
                LED_OFF(LED3);
                LED_OFF(LED4);
                delay_ms(500);
            
            }   
            count_SW = 0;
            } 
            else if(count_SW == 2)
            {
               int j;
               for(j=0; j<4; j++)
               {
                    PORTF=~(0x10<<j);
                    delay_ms(500);
                    PORTF = 0xFF;
                }
               
                count_SW = 0;
            }     
            
            else if(count_SW == 3)
            {   
                char temp =0 ;  
                while(1){
                
                
                if(SW1() == TRUE)
                {
                    temp++;
                }
                if(SW2() == TRUE)
                {
                    PORTF = ~(temp<<4);
                    delay_ms(1000);
                    PORTF = 0xFF;
                    count_SW = 0;
                    break;
                }   
            }
     }     
      };
}
}

