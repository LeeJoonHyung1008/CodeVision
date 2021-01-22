#include <mega128.h>
#include <stdio.h>
#include <delay.h>
// Standard Input/Output functions
#include <stdio.h>
#include "Sensor.h"
#include "switch.h"
#include "LED.h"

char switch1;   // ���Ӱ� ������ switch1, switch2�Դϴ�. (boolean ����)
char switch2;
int count_SW = 0;
unsigned int Front=0, Right=0, Left = 0;
int i=0, j=0 ,k=0;
// External Interrupt 0 service routine
interrupt [EXT_INT0] void ext_int0_isr(void)        // INT0�� ���� ISR �Լ��Դϴ�. (SW1�� �ش��մϴ�.)
{
// Place your code here
     switch1 = TRUE;    // �ش� Interrupt�� ȣ��Ǹ� switch1�� boolean ���� TRUE�� �ٲ��ݴϴ�.
}

// External Interrupt 1 service routine
interrupt [EXT_INT1] void ext_int1_isr(void)        // INT1�� ���� ISR �Լ��Դϴ�. (SW2�� �ش��մϴ�.)
{
// Place your code here
     switch2 = TRUE;    // �ش� Interrupt�� ȣ��Ǹ� switch2�� boolean ���� TRUE�� �ٲ��ݴϴ�.
}
  
void InitializeSwitch(void)    // Switch ���� �������͸� �����ϴ� �Լ��Դϴ�.
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
     EICRA=0x0A;    // SW1, 2�� ���� ��� Falling Edge�� �����մϴ�.
     EICRB=0x00;    // �ƹ��� Interrupt�� ������� �ʽ��ϴ�.
     EIMSK=0x03;    // INT0, 1�� Enable ���ݴϴ�.
     EIFR=0x03;        // INT0, 1�� Enable ���ݴϴ�.
}

char SW1(void)    // SW1�� ���� �Լ��Դϴ�.
{
     char ret;    // return ���� ������ ���Ӱ� �����մϴ�.
     
     ret = switch1;    // switch1�� ���� ���� �ٲߴϴ�.
     switch1 = FALSE;    // switch1�� FALSE ���� �ֽ��ϴ�.
     
     return ret;     // ret�� ��ȯ�մϴ�.
}

char SW2(void)   // SW2�� ���� �Լ��Դϴ�.
{
     char ret;   // return ���� ������ ���Ӱ� �����մϴ�.
     
     ret = switch2;   // switch2�� ���� ���� �ٲߴϴ�.
     switch2 = FALSE;   // switch2�� FALSE ���� �ֽ��ϴ�.
     
     return ret;     // ret�� ��ȯ�մϴ�.
}

void InitializeSensor(void)
{
 // PORTB 5,6,7 �߱�����
 PORTB &= 0X1F;
 DDRB |= 0XE0;
 // PORTF 0,1,2 �����μ���
 PORTF &= 0XF8;
 DDRF &= 0XF8;
 //ADC initialization
 //ADC Clock frequency: 125.000kHz
 //ADC Voltage Reference: AVCC pin
 ADMUX = ADC_VREF_TYPE;
 ADCSRA = 0X87;
}

unsigned int read_adc(unsigned char adc_input)
{
 ADMUX=adc_input | (ADC_VREF_TYPE & 0xff); // ä�� ����
// Delay needed for the stabilization of the ADC input voltage
 delay_us(10);
// Start the AD conversion(single conversion mode)
 ADCSRA|=0x40;
// Wait for the AD conversion to complete
 while ((ADCSRA & 0x10)==0);
  ADCSRA|=0x10;
 return ADCW;
}
unsigned int readSensor(char si)
{
 unsigned int ret;

 switch(si)
 {
 case FRONT_SENSOR: // ������ ������
 PORTB.5 = 1;
 delay_us(50);
 ret = read_adc(si); // adc���� ����
 PORTB.5 = 0;
 break;
 case LEFT_SENSOR: // ������ ������
 PORTB.6 = 1;
 delay_us(50);
 ret = read_adc(si); // adc���� ����
 PORTB.6 = 0;
 break;
 case RIGHT_SENSOR: // �������� ������
 PORTB.7 = 1;
 delay_us(50);
 ret = read_adc(si); // adc���� ����
 PORTB.7 = 0;
 break;
 }
 return ret; // adc���� ��ȯ��
}

void InitializeUART(void){
    // USART1 initialization
    // Communication Parameters: 8 Data, 1 Stop, No Parity
    // USART1 Receiver: On
    // USART1 Transmitter: On
    // USART1 Mode: Asynchronous
    // USART1 Baud Rate: 9600
    UCSR1A=0x00;
    UCSR1B=0x18;
    UCSR1C=0x06;
    UBRR1H=0x00;
    UBRR1L=0x67;
}              

void main(void)
{
     InitializeLED();
     InitializeSensor();
     InitializeUART();
     InitializeSwitch();
     
     switch1 = FALSE;   // switch1, 2�� �ʱⰪ�� FALSE �Դϴ�.
     switch2 = FALSE;     
    
     // Global enable interrupts    
    #asm("sei")   // ���� Interrupt�� Enable �մϴ�.
     
while (1)
 {
      
  delay_ms(20); // ����� �� ����� �� ������ �߰��ߴ�.
 printf("CENTER : %d LEFT : %d RIGHT : %d\r\n",
 readSensor(FRONT_SENSOR),readSensor(LEFT_SENSOR),readSensor(RIGHT_SENSOR));
// ���� Sensor�� �޾ƿ��� ���� ����Ѵ�.

    
 
 };
}