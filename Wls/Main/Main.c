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
extern int RightstepCount=0;        // rotateR과 rotateL의 각각 스텝이 모터에 순서대로 입력되도록 Count 
extern unsigned int VelocityLeftmotorTCNT1 = 65400;
extern unsigned int VelocityRightmotorTCNT3 = 65400;    // 왼쪽과 오른쪽 모터의 TCNT 속도

void main(void)
{
// Declare your local variables here

     InitializeStepmotor();
     InitializeLED();
     InitializeSensor();
     InitializeSwitch();   
     
// Global enable interrupts
#asm("sei")
    LeftstepCount = 0;      // 왼쪽 모터의 스텝 초기화
    RightstepCount = 0;      // 오른쪽 모터의 스텝 초기화
    VelocityLeftmotorTCNT1 = 65400;   // 왼쪽 모터의 속도 (65200 ~ 65535)
    VelocityRightmotorTCNT3 = 65400;   // 오른쪽 모터의 속도 (65200 ~ 65535)

while (1)
      {
      // Place your code here
      Direction(FORWARD);      // 좌로 90도 
      break;
      };
}
