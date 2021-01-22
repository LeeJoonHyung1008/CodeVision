#include <mega128.h>
#include "Switch.h"
#include "LED.h"
#include <delay.h>

int i=0;    // 이는 밝기 제어에 쓰일 변수이다.
int j=0;
     
 struct Buttons{
          char SW1; // SW1, SW2를 char type으로 선언한다.
          char SW2;
          }Buttons; // Buttons의 객체를 Buttons로 선언한다.
void InitializeSwitch(void) // SW를 활성화하는 함수이다.
{
     PORTD &= 0xfc; // SW1, SW2를 사용하므로 0xFC와 &(AND) 연산을 진행한다.
     DDRD &= 0xfc;  // 이 또한 동일하다.                                                         
     EICRA=0x0A; // 0x0A = 0b00001010으로, SW1, SW2를 모두 Falling Edge로 선언하였다.
     EICRB=0x00; // 그 이외의 Interrupt는 사용하지 않으므로 설정하지 않는다,
     EIMSK=0x03;  // 0x03 = 0b00000011으로, SW1, SW2에 대한 Interrupt 1, 2를 활성화 한다는 뜻이다. 
     EIFR=0x03;  // Interrupt가 Set 된다.
}

char SW1(void)  // SW1에 대한 함수이다.
{
     char ret;  // 해당 변수가 SW의 입력을 받을 것이다.
     
     ret = Buttons.SW1; // SW1의 값을 ret에 넣어준다.
     Buttons.SW1 = FALSE;   // Buttons.SW1에 FALSE 값을 넣어준다.
     return ret;    // ret를 반환한다.     
}

char SW2(void)  // SW1에 대한 함수이다.
{
     char ret;  // 해당 변수가 SW의 입력을 받을 것이다.
     
     ret = Buttons.SW2 ;    // SW2의 값을 ret에 넣어준다.
     Buttons.SW2 = FALSE;   // Buttons.SW1에 FALSE 값을 넣어준다.
     
     return ret;    // ret를 반환한다.          
}

interrupt [EXT_INT0] void ext_int0_isr(void)    // External Interrupt0 즉, 0번 Interrupt에 대한 Interrupt Service Routine 함수이다.
{   // SW1에 대한 함수이다.
     Buttons.SW1 = TRUE;    // 해당 Interrupt가 발생할 시 FALSE 값이 저장되어 있던 Buttons.SW1에 TRUE 값을 넣어준다.
}

interrupt [EXT_INT1] void ext_int1_isr(void)    // External Interrupt1 즉, 1번 Interrupt에 대한 Interrupt Service Routine 함수이다.
{   // SW2에 대한 함수이다.
     Buttons.SW2 = TRUE;    // 해당 Interrupt가 발생할 시 FALSE 값이 저장되어 있던 Buttons.SW2에 TRUE 값을 넣어준다.
}

void main(void)
{
       
     InitializeSwitch();    // Switch 관련 레지스터 설정하는 함수를 호출한다.
     InitializeLED();   // LED 관련 레지스터 설정하는 함수를 호출한다.
     
     Buttons.SW1 = FALSE;   // SW1과 SW2에 대해 초기 값을 FALSE로 한다.
     Buttons.SW2 = FALSE;
     PORTF=0xFF;
#asm("sei")

while (1)
      {
     if(SW1() == TRUE)  // SW1이 눌렸다면,
     {     
         for(i=0;i<50;i++)
         {
          
          LED_ON(LED1);
          LED_ON(LED2);
          LED_ON(LED3);
          LED_ON(LED4); 
          delay_ms(50-i);
          LED_OFF(LED1);
          LED_OFF(LED2);
          LED_OFF(LED3);
          LED_OFF(LED4);
          delay_ms(i);
         }
     }     
     if(SW2() == TRUE)  // SW2이 눌렸다면,
     {    for(j=0;j<50;i++)
        {         
          LED_ON(LED1);
          LED_ON(LED2);
          LED_ON(LED3);
          LED_ON(LED4); 
          delay_ms(j);
          LED_OFF(LED1);
          LED_OFF(LED2);
          LED_OFF(LED3);
          LED_OFF(LED4);
          delay_ms(50-j);
        }
     }     
      };
}