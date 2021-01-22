
#include<mega128.h>           
#include<delay.h>             
#include<mega128.h>
#include"LED.h"
#include<delay.h>

#include<mega128.h>           
#include<delay.h>             
#include<mega128.h>
#include"LED.h"
#include<delay.h>
#include<stdio.h>
#include"switch.h"       
#include"Sensor.h"
#include"Motor.h"
#include"ALGO.h"
int R[4];
int mode=0;
extern unsigned int VelocityLeftmotorTCNT1, VelocityRightmotorTCNT3;
extern int LeftstepCount, RightstepCount,aflag,vel_counter_high2,vel_counter_high1,ado;

eeprom int StandardSensor[3], CenterStandardSensor[3],acc;

void main(void)
{
// Declare your local variables here
      UCSR0A=0x00;
UCSR0B=0x18;
UCSR0C=0x06;
UBRR0H=0x00;
UBRR0L=0x67;

UCSR1A=0x00;
UCSR1B=0x18;
UCSR1C=0x06;
UBRR1H=0x00;
UBRR1L=0x67;


InitializeStepMotor();
InitializeSensor();
InitializeLED();
InitializeSwitch();
LeftstepCount = 0; // ���� ������ ���� �ʱ�ȭ
RightstepCount = 0; // ������ ������ ���� �ʱ�ȭ

// Global enable interrupts
#asm("sei")

VelocityLeftmotorTCNT1 = 65400; // ���� ������ �ӵ� (65200 ~ 65535)
VelocityRightmotorTCNT3 = 65400; // ������ ������ �ӵ� (65200 ~ 65535)


     
  
while(1)
{
if(SW1() == TRUE)
{
mode++;
mode%=8;
LED_OFF(LED1 | LED2 | LED3 | LED4);
switch(mode)
{
case 0: LED_ON(LED1); break;                   //���� ����
case 1: LED_ON(LED2); break;                  //���� ���Ĵ�
case 2: LED_ON(LED2);LED_ON(LED1); break;    ///acc
case 3: LED_ON(LED3); break;                                //�¼���
case 4: LED_ON(LED1);LED_ON(LED3);break;           //���� ���Ĵ�
case 5: LED_ON(LED2);LED_ON(LED3);break;          //���� ���Ͱ�
case 6: LED_ON(LED1);LED_ON(LED2);LED_ON(LED3);break;  //����
case 7: LED_ON(LED4);break;                             //��
}
}
if(SW2() == TRUE)                                                                                
{
switch(mode)
{
case 0:
  /*  
Direction(HALF); // �ݺ� ����
Direction(HALF); // �ݺ� ����
Direction(HALF); // �ݺ� ����
Direction(HALF); // �ݺ� ����
Direction(HALF); // �ݺ� ����
Direction(HALF); // �ݺ� ����
    
    
CenterStandardSensor[0]=10000;
Direction(HALF);
acc=readSensor(FRONT_SENSOR);
Direction(HALF);
delay_ms(500); */
R[0]= readSensor(LEFT_SENSOR);
 Direction(HALF);
 R[1]=readSensor(LEFT_SENSOR); 
  Direction(HALF);
 R[2]=readSensor(LEFT_SENSOR);
  Direction(HALF);
 R[3]=readSensor(LEFT_SENSOR);
StandardSensor[1] = (R[1]+R[2]+R[3])/3;   //���� �� ��
delay_ms(500);
LED_OFF(LED1 | LED2 | LED3 | LED4);
LED_ON(LED2);

break;

case 1: 

 Direction(HALF);
 R[1]=readSensor(RIGHT_SENSOR); 
  Direction(HALF);
 
StandardSensor[2] = R[1]; // �� �� ����

LED_OFF(LED1 | LED2 | LED3 | LED4);
LED_ON(LED3);

/*        
Direction(LEFT); // �ݺ� ����
Direction(LEFT); // �ݺ� ����
Direction(LEFT); // �ݺ� ����
Direction(LEFT); // �ݺ� ����  
delay_ms(200);
while(!SW2());
Direction(RIGHT); // �ݺ� ����
Direction(RIGHT); // �ݺ� ����
Direction(RIGHT); // �ݺ� ����
Direction(RIGHT); // �ݺ� ���� */ 
  /*
while(1)
{
    
printf("�߾� : %d  %d  %d ���� : %d  %d  %d ���� : %d  %d  %d\r\n",readSensor(FRONT_SENSOR),StandardSensor[0],CenterStandardSensor[0],readSensor(LEFT_SENSOR),StandardSensor[1],CenterStandardSensor[1],readSensor(RIGHT_SENSOR),StandardSensor[2],CenterStandardSensor[2]);
Direction(HALF);
}           
    */   
    
//jDirection(HALF);  
   /*
Direction(LEFT);
Direction(LEFT);
Direction(LEFT);
Direction(LEFT);
delay_ms(500);
while(!SW2());
Direction(RIGHT);
Direction(RIGHT);
Direction(RIGHT);
Direction(RIGHT);
delay_ms(500);
while(!SW2());

Direction(HALF);
Direction(HALF);
Direction(HALF);
Direction(HALF);
Direction(HALF);
delay_ms(100);
while(!SW2());  */
break;
case 2:
LED_OFF(LED1 | LED2 | LED3 | LED4);
    
CenterStandardSensor[0]=10000;
Direction(HALF);
acc=readSensor(FRONT_SENSOR);
Direction(HALF);
delay_ms(500);
break;
case 4:
CenterStandardSensor[0]=10000;
R[0]= readSensor(FRONT_SENSOR);
 Direction(HALF);
 R[1]=readSensor(FRONT_SENSOR); 
  Direction(HALF);
 R[2]=readSensor(FRONT_SENSOR);
  Direction(HALF);
 R[3]=readSensor(FRONT_SENSOR);
StandardSensor[0] = (R[1]+R[2]+R[3])/3; // ���� �� ����
delay_ms(500);
LED_OFF(LED1 | LED2 | LED3 | LED4);
LED_ON(LED1);
break;

case 5:
LED_OFF(LED1 | LED2 | LED3 | LED4);
R[0]= readSensor(FRONT_SENSOR);
 Direction(HALF);
 R[1]=readSensor(FRONT_SENSOR); 
  Direction(HALF);
 R[2]=readSensor(FRONT_SENSOR);
  Direction(HALF);
 R[3]=readSensor(FRONT_SENSOR);
CenterStandardSensor[0] = (R[1]+R[2]+R[3])/3; // �ڼ����� �� �� ����
delay_ms(500);
LED_ON(LED1);
break;
case 6:
 LED_OFF(LED1 | LED2 | LED3 | LED4);
R[0]= readSensor(LEFT_SENSOR);
 Direction(HALF);
 R[1]=readSensor(LEFT_SENSOR); 
  Direction(HALF);
 R[2]=readSensor(LEFT_SENSOR);
  Direction(HALF);
 R[3]=readSensor(LEFT_SENSOR);
CenterStandardSensor[1] = (R[1]+R[2]+R[3])/3; // �ڼ����� ���� �� ����
LED_ON(LED2);
break;
case 7:
R[0]= readSensor(RIGHT_SENSOR);
 Direction(HALF);
 R[1]=readSensor(RIGHT_SENSOR); 
  Direction(HALF);
 R[2]=readSensor(RIGHT_SENSOR);
  Direction(HALF);
 R[3]=readSensor(RIGHT_SENSOR);
CenterStandardSensor[2] = (R[1]+R[2]+R[3])/3;// �ڼ����� ������ �� ����
LED_OFF(LED1 | LED2 | LED3 | LED4);
LED_ON(LED3); 
break;
   case 3:
        {    vel_counter_high1=65400;
            vel_counter_high2=65400; 
      
               while (1)
               {       
                    
                    if(readSensor(LEFT_SENSOR) < StandardSensor[1])     //StandardSensor[1]
                    {   vel_counter_high1=65400;
                         vel_counter_high2=65400; 
                        ado=0;    
                        LED_OFF(LED1 | LED2 | LED3 | LED4);
                        LED_ON(LED1);
                         Direction(HALF);
                         Direction(LEFT);
                         
                         
                           
                         Direction(HALF);
                        
                       
                    }
                    else if(readSensor(FRONT_SENSOR) > StandardSensor[0])
                    {
                         if(readSensor(RIGHT_SENSOR) < StandardSensor[2])
                         {     vel_counter_high1=65400;
                                vel_counter_high2=65400;  
                               ado=0;
                              LED_OFF(LED3);
                              LED_ON(LED4);
                                Direction(HALF);
                              Direction(RIGHT);
                              
                              LED_OFF(LED3);
                              LED_OFF(LED4);
                              Direction(HALF);
                            
                         }
                         else
                         {     vel_counter_high1=65400;
                                vel_counter_high2=65400; 
                                ado=0;
                              LED_ON(LED3);
                              LED_ON(LED4);
                             Direction(HALF);
                              Direction(LEFT);
                              Direction(LEFT);
                             Direction(HALF);
                            
                         }
                    }
                    else
                    {
                         LED_OFF(LED3);
                         LED_OFF(LED4);
                         Direction(HALF);
                         if(aflag==1)
                         {
                         ado++;
                         }
                        
                         
                    }
               }
          }
        
        break;
}
}
} 

}