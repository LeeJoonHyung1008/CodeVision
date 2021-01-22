#include <mega128.h>
#include <stdio.h>
#include <delay.h>
#include "LED.h"
#include "Switch.h"
#include "Sensor.h"
#include "UART.h"
#include "StepMotor.h"

void main(void)
{
    int mode = 0, i = 0;
    InitializeLED();
    InitializeSwitch();
    InitializeSensor();
    InitializeUART();
    InitializeStepMotor();
    #asm("sei")

    LED_OFF(LED1 | LED2 | LED3 | LED4);
    LED_ON(LED1);
    while(TRUE)
    {
        if(SW1())
        {
            mode = ++mode % 4;
            LED_OFF(LED1 | LED2 | LED3 | LED4);
            switch (mode)
            {
                case 0: LED_ON(LED1); break;
                case 1: LED_ON(LED2); break;
                case 2: LED_ON(LED3); break;
                case 3: LED_ON(LED4); break;
            }
        }

        if(SW2())
        {
            switch (mode)
            {
                case 0:
                    delay_ms(500);
                    Direction(FORWARD);
                    Direction(LEFT);
                    Direction(FORWARD);
                    Direction(BACK);
                    Direction(FORWARD);
                    Direction(RIGHT);
                    Direction(FORWARD);
                    Direction(BACK);
                    break;
                case 1:
                    while(!SW2())
                        printf("LEFT : %4d  |  CENTER : %4d  |  RIGHT : %4d\r\n", readSensor(LEFT_SENSOR), readSensor(FRONT_SENSOR), readSensor(RIGHT_SENSOR));
                    break;
                case 2:
                    LED_OFF(LED1 | LED2 | LED3 | LED4);
                    LED_ON(LED2 | LED3);
                    StandardSensor[FRONT_SENSOR] = 0;
                    for(i = 0; i < 16; i++)
                    {
                        while(!SW2());
                        LED_OFF(LED1 | LED2 | LED3 | LED4);
                        LED_ON((i + 1)<<4);
    	                StandardSensor[FRONT_SENSOR] += readSensor(FRONT_SENSOR);
                    }
                    StandardSensor[FRONT_SENSOR] /= i;
                    printf("%d\r\n", StandardSensor[FRONT_SENSOR]);

                    LED_OFF(LED1 | LED2 | LED3 | LED4);
                    LED_ON(LED1 | LED2);
                    StandardSensor[LEFT_SENSOR] = 0;
                    for(i = 0; i < 16; i++)
                    {
                        while(!SW2());
                        LED_OFF(LED1 | LED2 | LED3 | LED4);
                        LED_ON((i + 1)<<4);
    	                StandardSensor[LEFT_SENSOR] += readSensor(LEFT_SENSOR);
                    }
                    StandardSensor[LEFT_SENSOR] /= i;
                    printf("%d\r\n", StandardSensor[LEFT_SENSOR]);

                    LED_OFF(LED1 | LED2 | LED3 | LED4);
    	            LED_ON(LED3 | LED4);
                    StandardSensor[RIGHT_SENSOR] = 0;
    	            for(i = 0; i < 16; i++)
                    {
                        while(!SW2());
                        LED_OFF(LED1 | LED2 | LED3 | LED4);
                        LED_ON((i + 1)<<4);
    	                StandardSensor[RIGHT_SENSOR] += readSensor(RIGHT_SENSOR);
                    }
                    StandardSensor[RIGHT_SENSOR] /= i;
                    printf("%d\r\n", StandardSensor[RIGHT_SENSOR]);

                    LED_OFF(LED1 | LED2 | LED3 | LED4);
    	            LED_ON(LED1 | LED4);
                    CenterStandardSensor[FRONT_SENSOR] = 0;
                    CenterStandardSensor[LEFT_SENSOR] = 0;
                    CenterStandardSensor[RIGHT_SENSOR] = 0;
    	            for(i = 0; i < 16; i++)
                    {
                        while(!SW2());
                        LED_OFF(LED1 | LED2 | LED3 | LED4);
                        LED_ON((i + 1)<<4);
                        CenterStandardSensor[FRONT_SENSOR] += readSensor(FRONT_SENSOR);
    	                CenterStandardSensor[LEFT_SENSOR] += readSensor(LEFT_SENSOR);
    	                CenterStandardSensor[RIGHT_SENSOR] += readSensor(RIGHT_SENSOR);
                    }
                    CenterStandardSensor[FRONT_SENSOR] /= i;
                    CenterStandardSensor[LEFT_SENSOR] /= i;
                    CenterStandardSensor[RIGHT_SENSOR] /= i;
                    printf("LEFT : %4d  |  CENTER : %4d  |  RIGHT : %4d\r\n", CenterStandardSensor(LEFT_SENSOR), CenterStandardSensor(FRONT_SENSOR), CenterStandardSensor(RIGHT_SENSOR));

                    LED_OFF(LED1 | LED2 | LED3 | LED4);
    	            LED_ON(LED3);
                    break;
                case 3:
                    while (TRUE)
                    {
                        if(readSensor(LEFT_SENSOR) < StandardSensor[LEFT_SENSOR])
                        {
                            LED_OFF(LED1 | LED2 | LED3 | LED4);
                            LED_ON(LED1 | LED2);
                            Direction(HALF);
                            Direction(LEFT);
                            Direction(HALF);
                        }
                        else if(readSensor(FRONT_SENSOR) > StandardSensor[FRONT_SENSOR])
                        {
                            if(readSensor(RIGHT_SENSOR) < StandardSensor[RIGHT_SENSOR])
                            {
                                LED_OFF(LED1 | LED2 | LED3 | LED4);
                                LED_ON(LED3 | LED4);
                                Direction(HALF);
                                Direction(RIGHT);
                                Direction(HALF);
                            }
                            else
                            {
                                LED_OFF(LED1 | LED2 | LED3 | LED4);
                                LED_ON(LED1 | LED4);
                                Direction(HALF);
                                Direction(LEFT);
                                Direction(LEFT);
                                Direction(HALF);
                            }
                        }
                        else
                        {
                            LED_OFF(LED1 | LED2 | LED3 | LED4);
                            LED_ON(LED2 | LED3);
                            Direction(FORWARD);
                        }
                    }
                    break;
            }
        }
    }
}