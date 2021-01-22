#include <mega128.h>
#include <delay.h>
#include <math.h>
#include <stdio.h>
#include "LED.h"
#include "Switch.h"
#include "Sensor.h"
#include "StepMotor.h"

extern int mode;
extern struct Buttons{
    char SW1;
    char SW2;
}Button; 
extern int LeftstepCount=0;
extern int RightstepCount=0;        // rotateR�� rotateL�� ���� ������ ���Ϳ� ������� �Էµǵ��� Count 
extern unsigned int VelocityLeftmotorTCNT1 = 65400;
extern unsigned int VelocityRightmotorTCNT3 = 65400;    // ���ʰ� ������ ������ TCNT �ӵ�

void main(void)
{
// Declare your local variables here

     InitializeStepmotor();
     InitializeLED();
     InitializeSensor();
     InitializeSwitch();   
     
// Global enable interrupts
#asm("sei")
    LeftstepCount = 0;      // ���� ������ ���� �ʱ�ȭ
    RightstepCount = 0;      // ������ ������ ���� �ʱ�ȭ
    VelocityLeftmotorTCNT1 = 65400;   // ���� ������ �ӵ� (65200 ~ 65535)
    VelocityRightmotorTCNT3 = 65400;   // ������ ������ �ӵ� (65200 ~ 65535)

while (1)
      {
      // Place your code here
      Direction(FORWARD);      // �·� 90�� 
      break;
      };
}
