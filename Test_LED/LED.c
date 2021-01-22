#include <mega128.h>
#include "LED.h"

void InitializeLED(void)
{
     // LED - PORTF 4,5,6,7 
     PORTF &= 0xFF; // 우리가 pcb 기판에서 사용하는 LED가 4개 이므로
     DDRF |= 0xF0;  // 이에 해당하는 LED를 출력으로 설정한다.                                                     
}

void LED_OFF(int nLED)  // LED를 OFF 해주는 함수이다.
{
    PORTF |= nLED;      // nLED를 |(OR) 연산 해줌으로써 해당 bit를 1로 만들어 LED를 끈다.
}

void LED_ON(int nLED)   // LED를 ON 해주는 함수이다.
{
PORTF &= ~(nLED);       // nLED를 &(AND) 연산 해줌으로써 해당 bit를 0으로 만들어 LED를 킨다.
}
