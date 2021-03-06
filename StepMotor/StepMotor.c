#include <math.h>
#include "StepMotor.h"
#include <mega128.h>
#include <delay.h>

char switch1; // 새롭게 선언한 switch1, switch2입니다. (boolean 변수)
char switch2;
int i = 0; // for문에서 밝기 제어를 담당할 변수 I, j 입니다.
int j = 0;

// External Interrupt 0 service routine
interrupt [EXT_INT0] void ext_int0_isr(void) 
{
// Place your code here
 switch1 = TRUE; // 해당 Interrupt가 호출되면 switch1의 boolean 값을 TRUE로 바
}
// External Interrupt 1 service routine
interrupt [EXT_INT1] void ext_int1_isr(void) // 
{
// Place your code here
 switch2 = TRUE; // 해당 Interrupt가 호출되면 switch2의 boolean 값을 TRUE로 바
}

void InitializeSwitch(void) // Switch 관련 레지스터를 설정하는 함수입니다. 
{
// 스위치 PORTD 0,1
 PORTD &= 0xfc;
 DDRD &= 0xfc;
// External Interrupt(s) initialization
// INT0: On
// INT0 Mode: Falling Edge
// INT1: On
// INT1 Mode: Falling Edge
// INT2: Off
// INT3: Off
// INT4: Off
// INT5: Off
// INT6: Off
// INT7: Off
 EICRA=0x0A; // SW1, 2에 대해 모두 Falling Edge로 선언합니다.
 EICRB=0x00; // 아무런 Interrupt를 사용하지 않습니다.
 EIMSK=0x03; // INT0, 1을 Enable 해줍니다.
 EIFR=0x03; // INT0, 1을 Enable 해줍니다. 
 }
char SW1(void) // SW1에 대한 함수입니다. {
 {
 char ret; // return 해줄 변수를 새롭게 선언합니다.

 ret = switch1; // switch1의 현재 값과 바꿉니다.
 switch1 = FALSE; // switch1에 FALSE 값을 넣습니다.

 return ret; // ret를 반환합니다. 
 }
char SW2(void) // SW2에 대한 함수입니다. {
 {
 char ret; // return 해줄 변수를 새롭게 선언합니다.

 ret = switch2; // switch2의 현재 값과 바꿉니다.
 switch2 = FALSE; // switch2에 FALSE 값을 넣습니다.

 return ret; // ret를 반환합니다. 
 }

// Declare your global variables here
     char rotateR[8] = {0b1001,0b0001,0b0101,0b0100,0b0110,0b0010,0b1010,0b1000};
     char rotateL[8] = {0b1001,0b1000,0b1010,0b0010,0b0110,0b0100,0b0101,0b0001};
     int LeftstepCount, RightstepCount;        // rotateR과 rotateL의 각각 스텝이 모터에 순서대로 입력되도록 Count 
     unsigned int VelocityLeftmotorTCNT1, VelocityRightmotorTCNT3;    // 왼쪽과 오른쪽 모터의 TCNT 속도
     unsigned char direction_control;        // 인터럽트 루틴에 방향정보를 전달하기 위한 전역변수

     struct {
          int nStep4perBlock;            // 한 블록 이동시 필요한 모터회전 스텝 정보
          int nStep4Turn90forRight;            // 90도 턴 이동시 필요한 모터회전 스텝 정보
          int nStep4Turn90forLeft;
     } Information;
     struct {
          char LmotorRun;            // 왼쪽 모터가 회전했는지에 대한 Flag
          char RmotorRun;			// 오른쪽 모터가 회전했는지에 대한 Flag
     } Flag;

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
          while(LStepCount<Information.nStep4Turn90forLeft || RStepCount<Information.nStep4Turn90forRight)
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
          while(LStepCount<(Information.nStep4Turn90forLeft*2) || RStepCount<(Information.nStep4Turn90forRight*2))
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
     


// Timer1 overflow interrupt service routine
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

// Declare your global variables here

void main(void)
{
    double distance4perStep; 
    distance4perStep = (double)(PI * TIRE_RAD / (double)MOTOR_STEP);
	Information.nStep4perBlock = (int)((double)180. / distance4perStep);
	Information.nStep4Turn90forRight = (int)((PI*MOUSE_WIDTH/3.8)/distance4perStep);
    Information.nStep4Turn90forLeft = (int)((PI*MOUSE_WIDTH/3.9)/distance4perStep);
// LEFT MOTOR - PORTD 4,5,6,7
     PORTD&=0x0F;
     DDRD|=0xF0;

// RIGHT MOTOR - PORTE 4,5,6,7
     PORTE&=0x0F;
     DDRE|=0xF0;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 62.500 kHz
// Mode: Normal top=FFFFh
// OC1A output: Discon.
// OC1B output: Discon.
// OC1C output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer 1 Overflow Interrupt: On
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
// Compare C Match Interrupt: Off
     TCCR1A=0x00;
     TCCR1B=0x04;
     TCNT1H=0x00;
     TCNT1L=0x00;
     ICR1H=0x00;
     ICR1L=0x00;
     OCR1AH=0x00;
     OCR1AL=0x00;
     OCR1BH=0x00;
     OCR1BL=0x00;
     OCR1CH=0x00;
     OCR1CL=0x00;

// Timer/Counter 3 initialization
// Clock source: System Clock
// Clock value: 62.500 kHz
// Mode: Normal top=FFFFh
// OC3A output: Discon.
// OC3B output: Discon.
// OC3C output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer 3 Overflow Interrupt: On
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
// Compare C Match Interrupt: Off
     TCCR3A=0x00;
     TCCR3B=0x04;
     TCNT3H=0x00;
     TCNT3L=0x00;
     ICR3H=0x00;
     ICR3L=0x00;
     OCR3AH=0x00;
     OCR3AL=0x00;
     OCR3BH=0x00;
     OCR3BL=0x00;
     OCR3CH=0x00;
     OCR3CL=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
     TIMSK=0x04;
     ETIMSK=0x04;               
     
    

#asm("sei")

    LeftstepCount = 0;		// 왼쪽 모터의 스텝 초기화
     RightstepCount = 0;		// 오른쪽 모터의 스텝 초기화

// Global enable interrupts
#asm("sei")

     VelocityLeftmotorTCNT1 = 65400;	// 왼쪽 모터의 속도 (65200 ~ 65535)
     VelocityRightmotorTCNT3 = 65400;	// 오른쪽 모터의 속도 (65200 ~ 65535)
    InitializeSwitch;
//     Direction(RIGHT);		// 우로 90도 턴
//     Direction(HALF);		// 반블럭 전진

      switch1 = FALSE; // switch1, 2의 초기값은 FALSE 입니다.
        switch2 = FALSE;
while (1)
      {
      // Place your code here 
      Direction(LEFT);		// 좌로 90도 턴

      Direction(LEFT);		// 좌로 90도 
      
            Direction(LEFT);		// 좌로 90도 턴

      Direction(LEFT);		// 좌로 90도 
            Direction(LEFT);		// 좌로 90도 턴

      Direction(LEFT);		// 좌로 90도 
            Direction(LEFT);		// 좌로 90도 턴

      Direction(LEFT);		// 좌로 90도 
      break;
      }
}
