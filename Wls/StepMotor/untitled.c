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
     
     Direction(FORWARD);        // �Ѻ� ����
     Direction(LEFT);        // �·� 90�� ��
     Direction(RIGHT);		// ��� 90�� ��
     Direction(HALF);		// �ݺ� ����


while (1)
      {
      // Place your code here

      };
}