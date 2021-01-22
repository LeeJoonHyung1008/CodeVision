#include <mega128.h>
#include <math.h>
#include <stdio.h>
#include "StepMotor.h"
#include "Sensor.h"

char rotateL[8] = {0b1001, 0b1000, 0b1010, 0b0010, 0b0110, 0b0100, 0b0101, 0b0001};
char rotateR[8] = {0b1001, 0b0001, 0b0101, 0b0100, 0b0110, 0b0010, 0b1010, 0b1000};

int LeftstepCount, RightstepCount;
unsigned int VelocityLeftmotorTCNT1, VelocityRightmotorTCNT3;
unsigned int vel_counter_high_L, vel_counter_high_R, vel_counter_high = 65400;
unsigned char direction_control;

struct
{
    int nStep4perBlock;
    int nStep4Turn90;
} Information;

struct
{
    char LmotorRun;
    char RmotorRun;
} Flag;

void InitializeStepMotor(void)
{
    double distance4perStep;
    PORTD &= 0x0F;
    DDRD |= 0xF0;
    TCCR1A = 0x00;
    TCCR1B = 0x04;
    TCNT1H = 0x00;
    TCNT1L = 0x00;
    ICR1H = 0x00;
    ICR1L = 0x00;
    OCR1AH = 0x00;
    OCR1AL = 0x00;
    OCR1BH = 0x00;
    OCR1BL = 0x00;
    OCR1CH = 0x00;
    OCR1CL = 0x00;

    PORTE &= 0x0F;
    DDRE |= 0xF0;
    TCCR3A = 0x00;
    TCCR3B = 0x04;
    TCNT3H = 0x00;
    TCNT3L = 0x00;
    ICR3H = 0x00;
    ICR3L = 0x00;
    OCR3AH = 0x00;
    OCR3AL = 0x00;
    OCR3BH = 0x00;
    OCR3BL = 0x00;
    OCR3CH = 0x00;
    OCR3CL = 0x00;

    TIMSK=0x04;
    ETIMSK=0x04;

    distance4perStep = (double)(PI * TIRE_RAD / (double)MOTOR_STEP);
	Information.nStep4perBlock = (int)((double)180. / distance4perStep);
	Information.nStep4Turn90 = (int)((PI*MOUSE_WIDTH/4.)/distance4perStep);

    LeftstepCount = 0;
    RightstepCount = 0;
    VelocityLeftmotorTCNT1 = vel_counter_high;
    VelocityRightmotorTCNT3 = vel_counter_high;
}

void Direction(int mode)
{
    int LStepCount = 0, RStepCount = 0;
    TCCR1B = 0x04;
    TCCR3B = 0x04;
    direction_control = mode;
    Flag.LmotorRun = FALSE;
    Flag.RmotorRun = FALSE;
    switch(mode)
    {
        case FORWARD:
            while(LStepCount < Information.nStep4perBlock || RStepCount < Information.nStep4perBlock)
            {
                adjustmouse();
                if(Flag.LmotorRun)
                {
                    LStepCount++;
                    Flag.LmotorRun = FALSE;
                }
                if(Flag.RmotorRun)
                {
                    RStepCount++;
                    Flag.RmotorRun = FALSE;
                }
            }
            break;
        case HALF:
            while(LStepCount < Information.nStep4perBlock>>1 || RStepCount < Information.nStep4perBlock>>1)
            {
                adjustmouse();
                if(Flag.LmotorRun)
                {
                    LStepCount++;
                    Flag.LmotorRun = FALSE;
                }
                if(Flag.RmotorRun)
                {
                    RStepCount++;
                    Flag.RmotorRun = FALSE;
                }
            }
            break;
        case LEFT:
        case RIGHT:
            while(LStepCount < Information.nStep4Turn90 || RStepCount < Information.nStep4Turn90)
            {
                if(Flag.LmotorRun)
                {
                    LStepCount++;
                    Flag.LmotorRun = FALSE;
                }
                if(Flag.RmotorRun)
                {
                    RStepCount++;
                    Flag.RmotorRun = FALSE;
                }
            }
            break;
        case BACK:
            while(LStepCount < Information.nStep4Turn90*2 || RStepCount < Information.nStep4Turn90*2)
            {
                if(Flag.LmotorRun)
                {
                    LStepCount++;
                    Flag.LmotorRun = FALSE;
                }
                if(Flag.RmotorRun)
                {
                    RStepCount++;
                    Flag.RmotorRun = FALSE;
                }
            }
            break;
    }
    TCCR1B = 0x00;
    TCCR3B = 0x00;
}

void adjustmouse(void)
{
    int adjLeftSensor, adjRightSensor;
    int adjflagcnt = 0;

    adjLeftSensor = readSensor(LEFT_SENSOR);
    adjRightSensor = readSensor(RIGHT_SENSOR);
    vel_counter_high_L = VelocityLeftmotorTCNT1;
    vel_counter_high_R = VelocityRightmotorTCNT3;

    if((adjRightSensor < StandardSensor[RIGHT_SENSOR]) || (adjLeftSensor < StandardSensor[LEFT_SENSOR]))
    {
        vel_counter_high_L = vel_counter_high;
        vel_counter_high_R = vel_counter_high;
    }
    else
    {
        if(adjRightSensor < CenterStandardSensor[RIGHT_SENSOR])
        {
            vel_counter_high_L += 1;
            vel_counter_high_R -= 1;
            if(vel_counter_high_L > vel_counter_high + 20)
                vel_counter_high_L = vel_counter_high + 20;
            if(vel_counter_high_R < (vel_counter_high - 20))
                vel_counter_high_R = (vel_counter_high - 20);
        }
        else
            adjflagcnt++;

        if(adjLeftSensor < CenterStandardSensor[LEFT_SENSOR])
        {
            vel_counter_high_L -= 1;
            vel_counter_high_R += 1;
            if(vel_counter_high_R > vel_counter_high + 20)
                vel_counter_high_R = vel_counter_high + 20;
            if(vel_counter_high_L < (vel_counter_high - 20))
                vel_counter_high_L = (vel_counter_high - 20);
        }
        else
            adjflagcnt++;

        if(adjflagcnt == 2)
        {
            vel_counter_high_L = vel_counter_high;
            vel_counter_high_R = vel_counter_high;
        }
    }
    VelocityLeftmotorTCNT1 = vel_counter_high_L;
    VelocityRightmotorTCNT3 = vel_counter_high_R;
}

interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
    PORTD |= (rotateL[LeftstepCount]<<4);
    PORTD &= ((rotateL[LeftstepCount]<<4) + 0x0F);
    switch(direction_control)
    {
        case LEFT:
            LeftstepCount--;
            if(LeftstepCount < 0)
                LeftstepCount = sizeof(rotateL)-1;
            break;
        case RIGHT:
        case BACK:
        case FORWARD:
        case HALF:
            LeftstepCount++;
            LeftstepCount %= sizeof(rotateL);
            break;
    }
    Flag.LmotorRun = TRUE;
    TCNT1H = VelocityLeftmotorTCNT1 >> 8;
    TCNT1L = VelocityLeftmotorTCNT1 & 0xFF;
}

interrupt [TIM3_OVF] void timer3_ovf_isr(void)
{
    PORTE |= (rotateR[RightstepCount]<<4);
    PORTE &= ((rotateR[RightstepCount]<<4) + 0x0F);
    switch(direction_control)
    {
        case RIGHT:
        case BACK:
            RightstepCount--;
            if(RightstepCount < 0)
                RightstepCount = sizeof(rotateR)-1;
            break;
        case FORWARD:
        case HALF:
        case LEFT:
            RightstepCount++;
            RightstepCount %= sizeof(rotateR);
            break;
    }
    Flag.RmotorRun = TRUE;
    TCNT3H = VelocityRightmotorTCNT3 >> 8;
    TCNT3L = VelocityRightmotorTCNT3 & 0xFF;
}