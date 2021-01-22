#include <mega128.h>
#include <math.h>
#include "LED.h"
#include "Switch.h"
#include "Sensor.h"
#include "StepMotor.h"
#include <delay.h>

// Declare your global variables here
     char rotateR[8] = {0b1001,0b0001,0b0101,0b0100,0b0110,0b0010,0b1010,0b1000};
     char rotateL[8] = {0b1001,0b1000,0b1010,0b0010,0b0110,0b0100,0b0101,0b0001};
     int LeftstepCount, RightstepCount;        // rotateR�� rotateL�� ���� ������ ���Ϳ� ������� �Էµǵ��� Count 
     unsigned int VelocityLeftmotorTCNT1, VelocityRightmotorTCNT3;    // ���ʰ� ������ ������ TCNT �ӵ�
     unsigned char direction_control;        // ���ͷ�Ʈ ��ƾ�� ���������� �����ϱ� ���� ��������

     struct {
          int nStep4perBlock;            // �� ���� �̵��� �ʿ��� ����ȸ�� ���� ����
          int nStep4Turn90;            // 90�� �� �̵��� �ʿ��� ����ȸ�� ���� ����
     } Information;
     struct {
          char LmotorRun;            // ���� ���Ͱ� ȸ���ߴ����� ���� Flag
          char RmotorRun;            // ������ ���Ͱ� ȸ���ߴ����� ���� Flag
     } Flag;
void InitializeStepmotor(void)
{
	double distance4perStep;
	
// LEFT MOTOR - PORTD 4,5,6,7
	PORTD&=0x0F;
// Timer(s)/Counter(s) Interrupt(s) initialization
	TIMSK=0x04;
	ETIMSK=0x04;
	     
	distance4perStep = (double)(PI * TIRE_RAD / (double)MOTOR_STEP);
	Information.nStep4perBlock = (int)((double)180. / distance4perStep);
	Information.nStep4Turn90 = (int)((PI*MOUSE_WIDTH/4.)/distance4perStep);
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
          while(LStepCount<Information.nStep4perBlock || RStepCount<Information.nStep4perBlock)
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
     case HALF:
          while(LStepCount<(Information.nStep4perBlock>>1) || RStepCount<(Information.nStep4perBlock>>1))
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
     case LEFT:
     case RIGHT:
          while(LStepCount<Information.nStep4Turn90 || RStepCount<Information.nStep4Turn90)
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
          while(LStepCount<(Information.nStep4Turn90*2) || RStepCount<(Information.nStep4Turn90*2))
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

// Timer 1 overflow interrupt service routine
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
// Place your code here
     switch(direction_control)
     {
          case LEFT:
               PORTD |= (rotateL[LeftstepCount]<<4);
               PORTD &= ((rotateL[LeftstepCount]<<4)+0x0f);
               LeftstepCount--;
               if(LeftstepCount < 0)
                    LeftstepCount = sizeof(rotateL)-1;
               break;
          case RIGHT:
          case BACK:
          case FORWARD:
          case HALF:
               PORTD |= (rotateL[LeftstepCount]<<4);
               PORTD &= ((rotateL[LeftstepCount]<<4)+0x0f);
               LeftstepCount++;
               LeftstepCount %= sizeof(rotateL);
               break;
     }
     Flag.LmotorRun = TRUE;

     TCNT1H = VelocityLeftmotorTCNT1 >> 8;
     TCNT1L = VelocityLeftmotorTCNT1 & 0xff;
}

// Timer 3 overflow interrupt service routine
interrupt [TIM3_OVF] void timer3_ovf_isr(void)
{
// Place your code here
     switch(direction_control)
     {
          case RIGHT:
          case BACK:
               PORTE |= (rotateR[RightstepCount]<<4);
               PORTE &= ((rotateR[RightstepCount]<<4)+0x0f);
               RightstepCount--;
               if(RightstepCount < 0)
                    RightstepCount = sizeof(rotateR)-1;
               break;
          case FORWARD:
          case HALF:
          case LEFT:
               PORTE |= (rotateR[RightstepCount]<<4);
               PORTE &= ((rotateR[RightstepCount]<<4)+0x0f);
               RightstepCount++;
               RightstepCount %= sizeof(rotateR);
               break;
     }
     Flag.RmotorRun = TRUE;

     TCNT3H = VelocityRightmotorTCNT3 >> 8;
     TCNT3L = VelocityRightmotorTCNT3 & 0xff;
}
#include <mega128.h>
#include <math.h>
#include "LED.h"
#include "Switch.h"
#include "Sensor.h"
#include "StepMotor.h"
#include <delay.h>


void main(void)
{
// Declare your local variables here

     InitializeStepmotor();

     LeftstepCount = 0;		// ���� ������ ���� �ʱ�ȭ
     RightstepCount = 0;		// ������ ������ ���� �ʱ�ȭ

// Global enable interrupts
#asm("sei")

     VelocityLeftmotorTCNT1 = 65400;    // ���� ������ �ӵ� (65200 ~ 65535)
     VelocityRightmotorTCNT3 = 65400;    // ������ ������ �ӵ� (65200 ~ 65535)
     
     Direction(FORWARD);        // �Ѻ��� ����
     Direction(LEFT);        // �·� 90�� ��
     Direction(RIGHT);		// ��� 90�� ��
     Direction(HALF);		// �ݺ��� ����


while (1)
      {
      // Place your code here

      };
}