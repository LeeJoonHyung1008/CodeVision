#include <mega128.h>
#include <stdio.h>
#include <delay.h>
// Standard Input/Output functions
#include <stdio.h>
#include "Sensor.h"
#include "switch.h"
#include "LED.h"

char switch1;   // 새롭게 선언한 switch1, switch2입니다. (boolean 변수)
char switch2;
int count_SW = 0;
unsigned int Front=0, Right=0, Left = 0;
int i=0, j=0 ,k=0;
// External Interrupt 0 service routine
interrupt [EXT_INT0] void ext_int0_isr(void)        // INT0에 대한 ISR 함수입니다. (SW1에 해당합니다.)
{
// Place your code here
     switch1 = TRUE;    // 해당 Interrupt가 호출되면 switch1의 boolean 값을 TRUE로 바꿔줍니다.
}

// External Interrupt 1 service routine
interrupt [EXT_INT1] void ext_int1_isr(void)        // INT1에 대한 ISR 함수입니다. (SW2에 해당합니다.)
{
// Place your code here
     switch2 = TRUE;    // 해당 Interrupt가 호출되면 switch2의 boolean 값을 TRUE로 바꿔줍니다.
}
  
void InitializeSwitch(void)    // Switch 관련 레지스터를 설정하는 함수입니다.
{
// 스위치 PORTD 0,1
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
     EICRA=0x0A;    // SW1, 2에 대해 모두 Falling Edge로 선언합니다.
     EICRB=0x00;    // 아무런 Interrupt를 사용하지 않습니다.
     EIMSK=0x03;    // INT0, 1을 Enable 해줍니다.
     EIFR=0x03;        // INT0, 1을 Enable 해줍니다.
}

char SW1(void)    // SW1에 대한 함수입니다.
{
     char ret;    // return 해줄 변수를 새롭게 선언합니다.
     
     ret = switch1;    // switch1의 현재 값과 바꿉니다.
     switch1 = FALSE;    // switch1에 FALSE 값을 넣습니다.
     
     return ret;     // ret를 반환합니다.
}

char SW2(void)   // SW2에 대한 함수입니다.
{
     char ret;   // return 해줄 변수를 새롭게 선언합니다.
     
     ret = switch2;   // switch2의 현재 값과 바꿉니다.
     switch2 = FALSE;   // switch2에 FALSE 값을 넣습니다.
     
     return ret;     // ret를 반환합니다.
}

void InitializeSensor(void)
{
 // PORTB 5,6,7 발광센서
 PORTB &= 0X1F;
 DDRB |= 0XE0;
 // PORTF 0,1,2 수광부센서
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
 ADMUX=adc_input | (ADC_VREF_TYPE & 0xff); // 채널 선택
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
 case FRONT_SENSOR: // 앞쪽을 관찰함
 PORTB.5 = 1;
 delay_us(50);
 ret = read_adc(si); // adc값을 읽음
 PORTB.5 = 0;
 break;
 case LEFT_SENSOR: // 왼쪽을 관찰함
 PORTB.6 = 1;
 delay_us(50);
 ret = read_adc(si); // adc값을 읽음
 PORTB.6 = 0;
 break;
 case RIGHT_SENSOR: // 오른쪽을 관찰함
 PORTB.7 = 1;
 delay_us(50);
 ret = read_adc(si); // adc값을 읽음
 PORTB.7 = 0;
 break;
 }
 return ret; // adc값을 반환함
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
     
     switch1 = FALSE;   // switch1, 2의 초기값은 FALSE 입니다.
     switch2 = FALSE;     
    
     // Global enable interrupts    
    #asm("sei")   // 전역 Interrupt를 Enable 합니다.
     
while (1)
 {
      
  delay_ms(20); // 통신할 때 생기는 렉 때문에 추가했다.
 printf("CENTER : %d LEFT : %d RIGHT : %d\r\n",
 readSensor(FRONT_SENSOR),readSensor(LEFT_SENSOR),readSensor(RIGHT_SENSOR));
// 현재 Sensor가 받아오는 값을 출력한다.

    
 
 };
}
