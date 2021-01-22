#include <mega128.h>
#include <math.h>
#include <stdio.h>
#include "StepMotor.h"
#include "Sensor.h"

char rotateL[8] = {0b1001, 0b1000, 0b1010, 0b0010, 0b0110, 0b0100, 0b0101, 0b0001};
char rotateR[8] = {0b1001, 0b0001, 0b0101, 0b0100, 0b0110, 0b0010, 0b1010, 0b1000};
int LeftstepCount, RightstepCount;

float VelocityLeftmotorTCNT1, VelocityRightmotorTCNT3;
float VelocityLeftmotorTCNT1_Max = 65400, VelocityRightmotorTCNT3_Max = 65400; // 65400 65400
float VelocityLeftmotorTCNT1_Min = 65000, VelocityRightmotorTCNT3_Min = 65000; // 65000 65000
unsigned char direction_control;

struct
{
    int nStep4perBlock;
    int nStep4Sensor2Center;
    int nStep4LEFTTurn90;
    int nStep4RIGHTTurn90;
    int nStep4SmoothLEFTTurn;
    int nStep4SmoothRIGHTTurn;
} Information;

struct
{
    char LmotorRun;
    char RmotorRun;
} Flag;

void InitializeStepMotor(void)
{
    float distance4perStep;
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

    distance4perStep = (float)(PI * TIRE_RAD / (float)MOTOR_STEP);
	Information.nStep4perBlock = (int)((float)180. / distance4perStep);
    Information.nStep4Sensor2Center = (int)((float)34. / distance4perStep);
	Information.nStep4LEFTTurn90 = (int)((PI*MOUSE_WIDTH_LEFT/4.)/distance4perStep);
	Information.nStep4RIGHTTurn90 = (int)((PI*MOUSE_WIDTH_RIGHT/4.)/distance4perStep);
    Information.nStep4SmoothLEFTTurn = (int)((PI*SMOOTHTURNLEFT/2.)/distance4perStep);
    Information.nStep4SmoothRIGHTTurn = (int)((PI*SMOOTHTURNRIGHT/2.)/distance4perStep);

    LeftstepCount = 0;
    RightstepCount = 0;
    VelocityLeftmotorTCNT1 = VelocityLeftmotorTCNT1_Min;
    VelocityRightmotorTCNT3 = VelocityRightmotorTCNT3_Min;
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
        case ACCEL:
            while(LStepCount < (Information.nStep4perBlock>>2) || RStepCount < (Information.nStep4perBlock>>2))
            {
                if(Flag.LmotorRun)
                {
                    VelocityLeftmotorTCNT1 += (float)(VelocityLeftmotorTCNT1_Max - VelocityLeftmotorTCNT1_Min) / (Information.nStep4perBlock>>2);
                    if(VelocityLeftmotorTCNT1 > VelocityLeftmotorTCNT1_Max)
                        VelocityLeftmotorTCNT1 = VelocityLeftmotorTCNT1_Max;
                    LStepCount++;
                    Flag.LmotorRun = FALSE;
                }
                if(Flag.RmotorRun)
                {
                    VelocityRightmotorTCNT3 += (float)(VelocityRightmotorTCNT3_Max - VelocityRightmotorTCNT3_Min) / (Information.nStep4perBlock>>2);
                    if(VelocityRightmotorTCNT3 > VelocityRightmotorTCNT3_Max)
                        VelocityRightmotorTCNT3 = VelocityRightmotorTCNT3_Max;
                    RStepCount++;
                    Flag.RmotorRun = FALSE;
                }
            }
            break;

        case NOACCEL:
            while(readSensor(LEFT_SENSOR) > StandardSensor[LEFT_SENSOR] && readSensor(FRONT_SENSOR) < StandardSensor[FRONT_SENSOR])
                adjustmouse();
            break;

        case DEACCEL:
            while(LStepCount < (Information.nStep4perBlock>>2) || RStepCount < (Information.nStep4perBlock>>2))
            {
                if(Flag.LmotorRun)
                {
                    VelocityLeftmotorTCNT1 -= (float)(VelocityLeftmotorTCNT1_Max - VelocityLeftmotorTCNT1_Min) / (Information.nStep4perBlock>>2);
                    if(VelocityLeftmotorTCNT1 < VelocityLeftmotorTCNT1_Min)
                        VelocityLeftmotorTCNT1 = VelocityLeftmotorTCNT1_Min;
                    LStepCount++;
                    Flag.LmotorRun = FALSE;
                }
                if(Flag.RmotorRun)
                {
                    VelocityRightmotorTCNT3 -= (float)(VelocityRightmotorTCNT3_Max - VelocityRightmotorTCNT3_Min) / (Information.nStep4perBlock>>2);
                    if(VelocityRightmotorTCNT3 < VelocityRightmotorTCNT3_Min)
                        VelocityRightmotorTCNT3 = VelocityRightmotorTCNT3_Min;
                    RStepCount++;
                    Flag.RmotorRun = FALSE;
                }
            }
            break;

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
            while(LStepCount < (Information.nStep4perBlock>>1) || RStepCount < (Information.nStep4perBlock>>1))
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
            while(LStepCount < Information.nStep4LEFTTurn90 || RStepCount < Information.nStep4LEFTTurn90)
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

        case RIGHT:
            while(LStepCount < Information.nStep4RIGHTTurn90 || RStepCount < Information.nStep4RIGHTTurn90)
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
            while(LStepCount < Information.nStep4RIGHTTurn90*2 || RStepCount < Information.nStep4RIGHTTurn90*2)
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

        case SMOOTHLEFT:
            VelocityLeftmotorTCNT1 = VelocityLeftmotorTCNT1_Max - 210;
            while(LStepCount < Information.nStep4SmoothLEFTTurn || RStepCount < Information.nStep4SmoothLEFTTurn)
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
            VelocityLeftmotorTCNT1 = VelocityLeftmotorTCNT1_Max;
            break;

        case SMOOTHRIGHT:
            VelocityRightmotorTCNT3 = VelocityRightmotorTCNT3_Max - 230;
            while(LStepCount < Information.nStep4SmoothRIGHTTurn || RStepCount < Information.nStep4SmoothRIGHTTurn)
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
            VelocityRightmotorTCNT3 = VelocityRightmotorTCNT3_Max;
            break;

        case SENSORTOCENTER:
            while(LStepCount < Information.nStep4Sensor2Center || RStepCount < Information.nStep4Sensor2Center)
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

    if((adjRightSensor < StandardSensor[RIGHT_SENSOR]) || (adjLeftSensor < StandardSensor[LEFT_SENSOR]))
    {
        VelocityLeftmotorTCNT1 = VelocityLeftmotorTCNT1_Max;
        VelocityRightmotorTCNT3 = VelocityRightmotorTCNT3_Max;
    }
    else
    {
        if(adjRightSensor < CenterStandardSensor[RIGHT_SENSOR])
        {
            VelocityLeftmotorTCNT1 += 1;
            VelocityRightmotorTCNT3 -= 1;
            if(VelocityLeftmotorTCNT1 > VelocityLeftmotorTCNT1_Max + 30)
                VelocityLeftmotorTCNT1 = VelocityLeftmotorTCNT1_Max + 30;
            if(VelocityRightmotorTCNT3 < (VelocityRightmotorTCNT3_Max - 30))
                VelocityRightmotorTCNT3 = (VelocityRightmotorTCNT3_Max - 30);
        }
        else
            adjflagcnt++;

        if(adjLeftSensor < CenterStandardSensor[LEFT_SENSOR])
        {
            VelocityLeftmotorTCNT1 -= 1;
            VelocityRightmotorTCNT3 += 1;
            if(VelocityLeftmotorTCNT1 < (VelocityLeftmotorTCNT1_Max - 30))
                VelocityLeftmotorTCNT1 = (VelocityLeftmotorTCNT1_Max - 30);
            if(VelocityRightmotorTCNT3 > VelocityRightmotorTCNT3_Max + 30)
                VelocityRightmotorTCNT3 = VelocityRightmotorTCNT3_Max + 30;
        }
        else
            adjflagcnt++;

        if(adjflagcnt == 2)
        {
            VelocityLeftmotorTCNT1 = VelocityLeftmotorTCNT1_Max;
            VelocityRightmotorTCNT3 = VelocityRightmotorTCNT3_Max;
        }
    }
}

void Super_adjust(void)
{
    if(readSensor(LEFT_SENSOR) > CenterStandardSensor[LEFT_SENSOR]+5)
    {
        VelocityLeftmotorTCNT1 += 1;
        VelocityRightmotorTCNT3 -= 1;
        if(VelocityLeftmotorTCNT1 > VelocityLeftmotorTCNT1_Max + 30)
            VelocityLeftmotorTCNT1 = VelocityLeftmotorTCNT1_Max + 30;
        if(VelocityRightmotorTCNT3 < (VelocityRightmotorTCNT3_Max - 30))
            VelocityRightmotorTCNT3 = (VelocityRightmotorTCNT3_Max - 30);
    }
    if(readSensor(LEFT_SENSOR) < CenterStandardSensor[LEFT_SENSOR]-5)
    {
        VelocityLeftmotorTCNT1 -= 1;
        VelocityRightmotorTCNT3 += 1;
        if(VelocityLeftmotorTCNT1 < (VelocityLeftmotorTCNT1_Max - 30))
            VelocityLeftmotorTCNT1 = (VelocityLeftmotorTCNT1_Max - 30);
        if(VelocityRightmotorTCNT3 > VelocityRightmotorTCNT3_Max + 30)
            VelocityRightmotorTCNT3 = VelocityRightmotorTCNT3_Max + 30;
    }
    if(readSensor(LEFT_SENSOR) <= CenterStandardSensor[LEFT_SENSOR]+5 && readSensor(LEFT_SENSOR) >= CenterStandardSensor[LEFT_SENSOR]-5)
    {
        VelocityLeftmotorTCNT1 = VelocityLeftmotorTCNT1_Max;
        VelocityRightmotorTCNT3 = VelocityRightmotorTCNT3_Max;
    }
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
        case FORWARD: case HALF: case SENSORTOCENTER:
        case ACCEL: case NOACCEL: case DEACCEL:
        case SMOOTHLEFT: case SMOOTHRIGHT:
        case RIGHT: case BACK:
            LeftstepCount++;
            LeftstepCount %= sizeof(rotateL);
            break;
    }
    Flag.LmotorRun = TRUE;
    TCNT1H = ((unsigned int)VelocityLeftmotorTCNT1) >> 8;
    TCNT1L = ((unsigned int)VelocityLeftmotorTCNT1) & 0xFF;
}

interrupt [TIM3_OVF] void timer3_ovf_isr(void)
{
    PORTE |= (rotateR[RightstepCount]<<4);
    PORTE &= ((rotateR[RightstepCount]<<4) + 0x0F);
    switch(direction_control)
    {
        case RIGHT: case BACK:
            RightstepCount--;
            if(RightstepCount < 0)
                RightstepCount = sizeof(rotateR)-1;
            break;
        case FORWARD: case HALF: case SENSORTOCENTER:
        case ACCEL: case NOACCEL: case DEACCEL:
        case SMOOTHLEFT: case SMOOTHRIGHT:
        case LEFT:
            RightstepCount++;
            RightstepCount %= sizeof(rotateR);
            break;
    }
    Flag.RmotorRun = TRUE;
    TCNT3H = ((unsigned int)VelocityRightmotorTCNT3) >> 8;
    TCNT3L = ((unsigned int)VelocityRightmotorTCNT3) & 0xFF;
}