#include <mega128.h>
#include <delay.h>
#include "Sensor.h"
#include "StepMotor.h"
#include "LED.h"
#include "switch.h"
#include "Algorithm.h"
#include <stdio.h>

// Declare your global variables here
extern unsigned int VelocityLeftmotorTCNT1, VelocityRightmotorTCNT3;


void InitializeUART(void){ // UART ����� ���� �� register�� �ʱ�ȭ �Ѵ�.
 // USART1 initialization
 // Communication Parameters: 8 Data, 1 Stop, No Parity
 // USART1 Receiver: On
 // USART1 Transmitter: On
 // USART1 Mode: Asynchronous
 // USART1 Baud Rate: 9600
 UCSR1A=0x00; // UART 1�� ä�ο� ���� register�� �ʱ�ȭ�Ѵ�.
 UCSR1B=0x18;
 UCSR1C=0x06;
 UBRR1H=0x00;
 UBRR1L=0x67;
} 

//eeprom extern int StandardSensor[3], CenterStandardSensor[3];
 

void main(void)
{
int i;
int mode;
i=0;
mode=0;
  
     InitializeSensor();
     InitializeUART(); 
       InitializeLED();    
     InitializeSwitch(); 
     InitializeStepmotor();              
     LED_OFF(LED1 | LED2 | LED3 | LED4);
     #asm("sei")
while(1)                     //�޴� ����
{
     if(SW1() == TRUE)
     {
    mode++;
    mode%=5;
    LED_OFF(LED1 | LED2 | LED3 | LED4);
    switch(mode)
    {
    case 0: LED_ON(LED1); break;
    case 1: LED_ON(LED2); break;
    case 2: LED_ON(LED3); break;
    case 3: LED_ON(LED4); break;
    case 4: LED_ON(LED1 | LED2 | LED3 | LED4); break;      
    }            
     }                     //�� ��忡 �´� LED�ѱ�
     if(SW2() == TRUE)
     {
    switch(mode)
    {
    case 0:         
         Direction(Quarter);
         A(50);     
         Direction(Quarter);
         D(20);
         Direction(Quarter);
         A(30);
         Direction(Quarter);

         delay_ms(1000);
    break;                  // 0�� ��� �����׽�Ʈ
    case 1:
         printf("left : %d    center : %d    tight : %d\n",readSensor(LEFT_SENSOR),readSensor(FRONT_SENSOR),readSensor(RIGHT_SENSOR));
         break;                  //1�� ��� ���� �׽�Ʈ
    case 2:
               LED_OFF(LED1 | LED2 | LED3 | LED4);
         while(!SW2());
         StandardSensor[1] = readSensor(FRONT_SENSOR);   
         LED_ON(LED1);
         while(!SW2());
         StandardSensor[0] = readSensor(LEFT_SENSOR);    // ���� �� ����
         LED_ON(LED2);
         while(!SW2());
         StandardSensor[2] = readSensor(RIGHT_SENSOR);    // ������ �� ����
         LED_ON(LED4);
         while(!SW2());
         CenterStandardSensor[0] = readSensor(LEFT_SENSOR);    // �ڼ����� ���� �� ����
         CenterStandardSensor[2]= readSensor(RIGHT_SENSOR);    // �ڼ����� ������ �� ���� 
         CenterStandardSensor[1]= readSensor(FRONT_SENSOR);
         LED_ON(LED1 | LED2 | LED3 | LED4);
               LED_OFF(LED1 | LED2 | LED3 | LED4);
         LED_ON(LED3);       
         printf("left standard : %d    center stand : %d    right stand : %d    center standatd : %d  %d  %d",StandardSensor[0],StandardSensor[1],StandardSensor[2],CenterStandardSensor[0],CenterStandardSensor[1],CenterStandardSensor[2]);
         
//         Button.SW2 = FALSE;

          while(i<5)
          {         // ���� �� ������ ��հ�
             while(!SW2());
             StandardSensor[1] = readSensor(FRONT_SENSOR) + StandardSensor[1]; // ���� �� ����
             LED_ON(LED1 | LED2 | LED3 | LED4);
             delay_ms(100);
             LED_OFF(LED1 | LED2 | LED3 | LED4);
             i++;
          }
         StandardSensor[1] = (int)(StandardSensor[1] / 6);
         i = 0;
         delay_ms(500);
         LED_ON(LED1);
//         Button.SW2 = FALSE;                    
                                          
          while(i<5)
          {         // ���� �� ������ ��հ�
             while(!SW2());
             StandardSensor[0] = readSensor(LEFT_SENSOR) + StandardSensor[0]; // ���� �� ����
             LED_ON(LED1 | LED2 | LED3 | LED4);
             delay_ms(100);
             LED_OFF(LED1 | LED2 | LED3 | LED4);
             i++;
          }
         StandardSensor[0] = (int)(StandardSensor[0] / 6);
         i = 0;
         delay_ms(500);
         LED_ON(LED1|LED2);
//         Button.SW2 = FALSE;


         while(i<5)
         {
         // ���� �� ������ ��հ�
         while(!SW2());
         StandardSensor[2] = readSensor(RIGHT_SENSOR) + StandardSensor[2]; // �� �� ����
         LED_ON(LED1 | LED2 | LED3 | LED4);
         delay_ms(100);
         LED_OFF(LED1 | LED2 | LED3 | LED4);
         i++;
         }         
         StandardSensor[2] = (int)( StandardSensor[2] / 6);
         i = 0;
         delay_ms(500);
         LED_ON(LED1 | LED2 | LED4);
//         Button.SW2 = FALSE;
         
         while(i<5)
         {
         // �¿캸�� ������ ��հ�
         while(!SW2());
         CenterStandardSensor[0] += readSensor(LEFT_SENSOR);         
         CenterStandardSensor[1] += readSensor(FRONT_SENSOR); // �ڼ�����
         CenterStandardSensor[2] += readSensor(RIGHT_SENSOR); // �ڼ�����
         LED_ON(LED1 | LED2 | LED3 | LED4);
         delay_ms(100);
         LED_OFF(LED1 | LED2 | LED3 | LED4);
         i++;
         }
         CenterStandardSensor[0] = (int)(CenterStandardSensor[0]/6);         
         CenterStandardSensor[1] = (int)(CenterStandardSensor[1]/6); // �ڼ�����
         CenterStandardSensor[2] = (int)(CenterStandardSensor[2]/6); // �ڼ�����
         i = 0;
         delay_ms(500);
         LED_ON(LED1 | LED2 | LED3 | LED4);
         LED_OFF(LED1 | LED2 | LED3 | LED4);
         LED_ON(LED2 | LED3 | LED4);
//         Button.SW2 = FALSE;
         break;               //2����� ������ ������, �߾Ӻ������� ����

    case 3:
         {
        printf("left standard : %d    center stand : %d    right stand : %d    center standatd : %d  %d  %d",StandardSensor[0],StandardSensor[1],StandardSensor[2],CenterStandardSensor[0],CenterStandardSensor[1],CenterStandardSensor[2]);
            
             
               while (1)
               {
//                         delay_ms(500);
                   if(readSensor(LEFT_SENSOR) < StandardSensor[0])
                    {    
//                         Direction(Quarter);
//                         Direction(Quarter);

                       //  Direction(HexaStep);

                         Direction(SmoothL);            
                         Direction(SmoothL);            
                    delay_ms(500);
                         Direction(Quarter);                                                  
                         Direction(Quarter);                                   
                    }                  
                    else if(readSensor(FRONT_SENSOR) > StandardSensor[1])
                    {
                         if(readSensor(RIGHT_SENSOR) < StandardSensor[2])
                         {
//                             Direction(Quarter);
//                             Direction(Quarter);
                          //   Direction(HexaStep);

                             Direction(SmoothR);  
                             Direction(SmoothR);
                         delay_ms(500);
                             Direction(Quarter);                          
                             Direction(Quarter);   
                          }
                         else
                         {  
                              LED_ON(LED3);
                              LED_ON(LED4);     
                              Direction(Quarter);
                              Direction(Quarter);                              
                              
                              Direction(LEFT);       
                              Direction(LEFT); 
                              delay_ms(100);
                              
                              Direction(Quarter);                               
                              Direction(Quarter);  
                        }
                    }                   
                    else
                    {
                         if(readSensor(FRONT_SENSOR)< StandardSensor[1])
                         {
                    //   A(10);
                    //     Direction(Quarter);
                         Direction(Quarter);
                         Direction(Quarter);
                         Direction(Quarter);                                                  
                         }
                         else
                         {
                     //    D(30);
                     //    Direction(Quarter);
                         Direction(Quarter);
                         Direction(Quarter);
                         Direction(Quarter);
                         }
                    }
               }
          }                   
         break;               //3�� ��� �¼���   
         case 4:     {      
                  Direction(Quarter);
                  Direction(Quarter);
                  Direction(Quarter);
                  Direction(Quarter);
         
                  Direction(SmoothR);
                  Direction(SmoothR);
                  delay_ms(2000);

                  Direction(Quarter);
                  Direction(Quarter);
                  Direction(Quarter);
                  Direction(Quarter);
                  Direction(SmoothL);
                  Direction(SmoothL);                  
         
         }break;         //4����� smooth turn ������ ���� �׽�Ʈ
    }
   }  
     
}     ;

}