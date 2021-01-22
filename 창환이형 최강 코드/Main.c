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
                    // for(i = 0 ; i < 20 ; i++)

                        Direction(ACCEL);
                        Direction(SMOOTHRIGHT);
                    break;
                case 1:
                    while(!SW2())
                    {
                        // printf("StandardL : %4u  |  StandardF : %4u  |  StandardR : %4u\r\n", StandardSensor[LEFT_SENSOR], StandardSensor[FRONT_SENSOR], StandardSensor[RIGHT_SENSOR]);
                        // printf(" CenterL  : %4u  |   CenterF  : %4u  |   CenterR  : %4u\r\n", CenterStandardSensor[LEFT_SENSOR], CenterStandardSensor[FRONT_SENSOR], CenterStandardSensor[RIGHT_SENSOR]);
                        printf("   LEFT   : %4u  |    FRONT   : %4u  |    RIGHT   : %4u\r\n", readSensor(LEFT_SENSOR), readSensor(FRONT_SENSOR), readSensor(RIGHT_SENSOR));
                    }
                    break;
                case 2:
                    LED_OFF(LED1 | LED2 | LED3 | LED4);
                    LED_ON(LED2 | LED3);
                    while(!SW2());
                    StandardSensor[FRONT_SENSOR] = 0;
                    for(i = 0; i < 10; i++)
    	                StandardSensor[FRONT_SENSOR] += readSensor(FRONT_SENSOR);
                    StandardSensor[FRONT_SENSOR] /= i;

                    LED_OFF(LED1 | LED2 | LED3 | LED4);
                    LED_ON(LED1 | LED2);
                    while(!SW2());
                    StandardSensor[LEFT_SENSOR] = 0;
                    for(i = 0; i < 10; i++)
    	                StandardSensor[LEFT_SENSOR] += readSensor(LEFT_SENSOR);
                    StandardSensor[LEFT_SENSOR] /= i;

                    LED_OFF(LED1 | LED2 | LED3 | LED4);
    	            LED_ON(LED3 | LED4);
                    while(!SW2());
                    StandardSensor[RIGHT_SENSOR] = 0;
    	            for(i = 0; i < 10; i++)
    	                StandardSensor[RIGHT_SENSOR] += readSensor(RIGHT_SENSOR);
                    StandardSensor[RIGHT_SENSOR] /= i;

                    LED_OFF(LED1 | LED2 | LED3 | LED4);
    	            LED_ON(LED1 | LED4);
                    while(!SW2());
                    CenterStandardSensor[FRONT_SENSOR] = 0;
                    CenterStandardSensor[LEFT_SENSOR] = 0;
                    CenterStandardSensor[RIGHT_SENSOR] = 0;
    	            for(i = 0; i < 10; i++)
                    {
                        CenterStandardSensor[FRONT_SENSOR] += readSensor(FRONT_SENSOR);
    	                CenterStandardSensor[LEFT_SENSOR] += readSensor(LEFT_SENSOR);
    	                CenterStandardSensor[RIGHT_SENSOR] += readSensor(RIGHT_SENSOR);
                    }
                    CenterStandardSensor[FRONT_SENSOR] /= i;
                    CenterStandardSensor[LEFT_SENSOR] /= i;
                    CenterStandardSensor[RIGHT_SENSOR] /= i;

                    LED_OFF(LED1 | LED2 | LED3 | LED4);
    	            LED_ON(LED3);
                    break;
                case 3:
                    delay_ms(500);
                    Direction(ACCEL);
                    while (TRUE)
                    {
                        if(readSensor(LEFT_SENSOR) < StandardSensor[LEFT_SENSOR])
                        {
                            LED_OFF(LED1 | LED2 | LED3 | LED4);
                            LED_ON(LED1 | LED2);
                            Direction(SMOOTHLEFT);
                        }
                        else if(readSensor(FRONT_SENSOR) < StandardSensor[FRONT_SENSOR])
                        {
                            LED_OFF(LED1 | LED2 | LED3 | LED4);
                            LED_ON(LED2 | LED3);
                            Direction(NOACCEL);                            
                            Direction(SENSORTOCENTER);
                        }
                        else if(readSensor(RIGHT_SENSOR) < StandardSensor[RIGHT_SENSOR])
                        {
                            LED_OFF(LED1 | LED2 | LED3 | LED4);
                            LED_ON(LED3 | LED4);
                            Direction(SMOOTHRIGHT);
                        }
                        else
                        {
                            LED_OFF(LED1 | LED2 | LED3 | LED4);
                            LED_ON(LED1 | LED2 | LED3 | LED4);
                            Direction(DEACCEL);
                            Direction(BACK);
                            Direction(ACCEL);
                        }
                    }
                    break;
            }
        }
    }
}