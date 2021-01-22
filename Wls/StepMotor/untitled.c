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

     LeftstepCount = 0;		// 왼쪽 모터의 스텝 초기화
     RightstepCount = 0;		// 오른쪽 모터의 스텝 초기화

// Global enable interrupts
#asm("sei")

     VelocityLeftmotorTCNT1 = 65400;    // 왼쪽 모터의 속도 (65200 ~ 65535)
     VelocityRightmotorTCNT3 = 65400;    // 오른쪽 모터의 속도 (65200 ~ 65535)
     
     Direction(FORWARD);        // 한블럭 전진
     Direction(LEFT);        // 좌로 90도 턴
     Direction(RIGHT);		// 우로 90도 턴
     Direction(HALF);		// 반블럭 전진


while (1)
      {
      // Place your code here

      };
}