#include <mega128.h>
#include <delay.h>

     int i = 0;

void main(void)
{
     DDRF=0xFF;              
while (1)
      {  

      // Place your code here
        if( i == 0)
        {
           
            for(i =0; i<100; i++)
            {                 
                delay_ms(i);
                PORTF = 0xFF;
                delay_ms(100-i);
                PORTF = 0x00;
            }
        }
        
        if( i == 100)
        {
            for(i =0; i<100; i++)
            {                 
                delay_ms(100-i);
                PORTF = 0xFF;
                delay_ms(i);
                PORTF = 0x00;
            }
            i=0;
        }
      }
}