#include <mega128.h>
#include <delay.h>
#include "LED.h"
#include "Switch.h"
#include "Sensor.h"
#include "UART.h"
#include "StepMotor.h"

void main(void){
    int mode=0;

    // Initialize each module
    InitializeLED();
    InitializeSwitch();
    InitializeSensor();
    InitializeUART();
    InitializeStepMotor();
    #asm("sei")  // Global interrupt enable

    LED_OFF(LEDall);
    while(True){
        if(SW1()){
            mode = ++mode%16;
            LED_OFF(LEDall);
            switch (mode){
                case 0: LED_ON(LED1); break;  // motor test
                case 1: LED_ON(LED2); break;  // sensor test
                case 2: LED_ON(LED3); break;  // adjust setting
                case 3: LED_ON(LED4); break;  // leftweight
            }
        }
        if(SW2()){
            switch (mode){
            case 0:  // motor test
                Direction(FORWARD);
                Direction(LEFT);
                Direction(FORWARD);
                Direction(BACK);
                Direction(FORWARD);
                Direction(RIGHT);
                Direction(FORWARD);
                break;
            case 1:  // sensor test
                while(True){
                    printf("LEFT : %4d  |  CENTER : %4d  |  RIGHT : %4d\r\n",
                    readSensor(LEFT_SENSOR), readSensor(FRONT_SENSOR), readSensor(RIGHT_SENSOR));
                }
                break;
            case 2:  // adjust setting	센서값 저장 case
                LED_OFF(LEDall);
                LED_ON(LED1|LED4);
                while(!SW2());					//스위치2가 눌리면 탈출
                StandardSensor[0] = readSensor(LEFT_SENSOR);
                StandardSensor[2] = readSensor(RIGHT_SENSOR);		//좌 우측 벽판정 기준값 저장
                LED_OFF(LEDall);
                LED_ON(LED2|LED3);
                while(!SW2());					
                StandardSensor[1] = readSensor(FRONT_SENSOR);	//전방 벽판정 기준값 저장
                LED_OFF(LEDall);
                LED_ON(LEDall);
                while(!SW2());				
                CenterStandardSensor[0] = readSensor(LEFT_SENSOR);		//직진시 필요한 보정기준값 저장 전좌우 3방향, 직진보정
                CenterStandardSensor[1] = readSensor(FRONT_SENSOR);	//좌우측 center값은 정중앙으로 똑바로 가기위해 필요
                CenterStandardSensor[2] = readSensor(RIGHT_SENSOR);	//전방 center값은 앞벽에 오차가 싸여서 충돌하려할시 탈출하기 위해 필요
                break;
            case 3:  // leftweight
                while (1){
                    if(readSensor(LEFT_SENSOR) < StandardSensor[1]){			//왼쪽으로 갈 수 있으면
                        LED_ON(LED3);
                        LED_OFF(LED4);
                        Direction(HALF);
                        Direction(LEFT);
                        delay_ms(500);
                        LED_OFF(LED3);
                        LED_OFF(LED4);
                        Direction(HALF);
                    }else if(readSensor(FRONT_SENSOR) > StandardSensor[0]){		//앞이 막혀있고
                        if(readSensor(RIGHT_SENSOR) < StandardSensor[2]){		//우측이 열려있으면
                            LED_OFF(LED3);
                            LED_ON(LED4);
                            Direction(HALF);
                            Direction(RIGHT);
                            delay_ms(500);
                            LED_OFF(LED3);
                            LED_OFF(LED4);
                            Direction(HALF);
                        }else{							//좌 앞 우 다 막혀있으면
                            LED_ON(LED3);
                            LED_ON(LED4);
                            Direction(HALF);
                            Direction(LEFT);
                            Direction(LEFT);
                            Direction(HALF);
                        }
                    }else{						//좌는 막히고 앞이 열려있으면
                        LED_OFF(LED3);
                        LED_OFF(LED4);
                        Direction(FORWARD);
                    }
                }
            }
        }
    }
}