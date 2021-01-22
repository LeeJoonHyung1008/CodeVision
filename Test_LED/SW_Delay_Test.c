#include <mega128.h>
#include "Switch.h"
#include "LED.h"
#include <delay.h>

int i=0;    // �̴� ��� ��� ���� �����̴�.
int j=0;

int Count_SW1 = 0;
     
 struct Buttons{
          char SW1; // SW1, SW2�� char type���� �����Ѵ�.
          char SW2;
          }Buttons; // Buttons�� ��ü�� Buttons�� �����Ѵ�.
          
void InitializeSwitch(void) // SW�� Ȱ��ȭ�ϴ� �Լ��̴�.
{
     PORTD &= 0xfc; // SW1, SW2�� ����ϹǷ� 0xFC�� &(AND) ������ �����Ѵ�.
     DDRD &= 0xfc;  // �� ���� �����ϴ�.                                                         
     EICRA=0x0A; // 0x0A = 0b00001010����, SW1, SW2�� ��� Falling Edge�� �����Ͽ���.
     EICRB=0x00; // �� �̿��� Interrupt�� ������� �����Ƿ� �������� �ʴ´�,
     EIMSK=0x03;  // 0x03 = 0b00000011����, SW1, SW2�� ���� Interrupt 1, 2�� Ȱ��ȭ �Ѵٴ� ���̴�. 
     EIFR=0x03;  // Interrupt�� Set �ȴ�.
}

char SW1(void)  // SW1�� ���� �Լ��̴�.
{
     char ret;  // �ش� ������ SW�� �Է��� ���� ���̴�.
     
     ret = Buttons.SW1; // SW1�� ���� ret�� �־��ش�.
     Buttons.SW1 = FALSE;   // Buttons.SW1�� FALSE ���� �־��ش�.
     return ret;    // ret�� ��ȯ�Ѵ�.     
}

char SW2(void)  // SW1�� ���� �Լ��̴�.
{
     char ret;  // �ش� ������ SW�� �Է��� ���� ���̴�.
     
     ret = Buttons.SW2 ;    // SW2�� ���� ret�� �־��ش�.
     Buttons.SW2 = FALSE;   // Buttons.SW1�� FALSE ���� �־��ش�.
     
     return ret;    // ret�� ��ȯ�Ѵ�.          
}

interrupt [EXT_INT0] void ext_int0_isr(void)    // External Interrupt0 ��, 0�� Interrupt�� ���� Interrupt Service Routine �Լ��̴�.
{   // SW1�� ���� �Լ��̴�.
     Buttons.SW1 = TRUE;    // �ش� Interrupt�� �߻��� �� FALSE ���� ����Ǿ� �ִ� Buttons.SW1�� TRUE ���� �־��ش�.
     Count_SW1++;   // �׸��� SW1�� ���� Ƚ���� count ���ش�.
}

interrupt [EXT_INT1] void ext_int1_isr(void)    // External Interrupt1 ��, 1�� Interrupt�� ���� Interrupt Service Routine �Լ��̴�.
{   // SW2�� ���� �Լ��̴�.
     Buttons.SW2 = TRUE;    // �ش� Interrupt�� �߻��� �� FALSE ���� ����Ǿ� �ִ� Buttons.SW2�� TRUE ���� �־��ش�.
}

void main(void)
{
       
     InitializeSwitch();    // Switch ���� �������� �����ϴ� �Լ��� ȣ���Ѵ�.
     InitializeLED();   // LED ���� �������� �����ϴ� �Լ��� ȣ���Ѵ�.
     
     Buttons.SW1 = FALSE;   // SW1�� SW2�� ���� �ʱ� ���� FALSE�� �Ѵ�.
     Buttons.SW2 = FALSE;
     
    #asm("sei")

while (1)
      {   
        LED_ON(Count_SW1);          
          
     if(SW2() == TRUE)  // SW2�� ���ȴٸ�,
     {   
        if(Count_SW1 == 1)
        { 
            for(i = 0; i<10; i++)
            {   // 50ms �ֱ� ���� 10�� on/off �ϵ��� �����Ͽ���.
          LED_ON(LED1);
          LED_ON(LED2);
          LED_ON(LED3);
          LED_ON(LED4);
          delay(50);
          LED_OFF(LED1);
          LED_OFF(LED2);
          LED_OFF(LED3);
          LED_OFF(LED4);
          delay(50);
            } 
        }
        else if(Count_SW1 == 2)
        {               // 50ms �ֱ�� LED1 ���� LED4 ���� shift�ϴ� �����̴�.
          LED_ON(LED1);
          delay(50);
          LED_OFF(LED1);
          
          LED_ON(LED2);
          delay(50);
          LED_OFF(LED2);
          
          LED_ON(LED3);
          delay(50);
          LED_OFF(LED3);
          
          LED_ON(LED4);
          delay(50);
          LED_OFF(LED4);
            } 
        }
        else if(Count_SW1 == 3)       
        {   // Count_SW1 �� ���� ���� 2������ ��Ÿ�� ��ŭ LED�� Ų��.
            LED_ON(Count_SW1);
        }
     }     
      };
}