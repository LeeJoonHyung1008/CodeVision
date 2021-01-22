#include <mega128.h>
#include "LED.h"

void InitializeLED(void)
{
     // LED - PORTF 4,5,6,7 
     PORTF &= 0xFF; // �츮�� pcb ���ǿ��� ����ϴ� LED�� 4�� �̹Ƿ�
     DDRF |= 0xF0;  // �̿� �ش��ϴ� LED�� ������� �����Ѵ�.                                                     
}

void LED_OFF(int nLED)  // LED�� OFF ���ִ� �Լ��̴�.
{
    PORTF |= nLED;      // nLED�� |(OR) ���� �������ν� �ش� bit�� 1�� ����� LED�� ����.
}

void LED_ON(int nLED)   // LED�� ON ���ִ� �Լ��̴�.
{
PORTF &= ~(nLED);       // nLED�� &(AND) ���� �������ν� �ش� bit�� 0���� ����� LED�� Ų��.
}