#include <math.h>
#include "StepMotor.h"
#include <mega128.h>
#include <delay.h>

char switch1; // ���Ӱ� ������ switch1, switch2�Դϴ�. (boolean ����)
char switch2;
int i = 0; // for������ ��� ��� ����� ���� I, j �Դϴ�.
int j = 0;

// External Interrupt 0 service routine
interrupt [EXT_INT0] void ext_int0_isr(void) 
{
// Place your code here
 switch1 = TRUE; // �ش� Interrupt�� ȣ��Ǹ� switch1�� boolean ���� TRUE�� ��
}
// External Interrupt 1 service routine
interrupt [EXT_INT1] void ext_int1_isr(void) // 
{
// Place your code here
 switch2 = TRUE; // �ش� Interrupt�� ȣ��Ǹ� switch2�� boolean ���� TRUE�� ��
}

void InitializeSwitch(void) // Switch ���� �������͸� �����ϴ� �Լ��Դϴ�. 
{
// ����ġ PORTD 0,1
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
 EICRA=0x0A; // SW1, 2�� ���� ��� Falling Edge�� �����մϴ�.
 EICRB=0x00; // �ƹ��� Interrupt�� ������� �ʽ��ϴ�.
 EIMSK=0x03; // INT0, 1�� Enable ���ݴϴ�.
 EIFR=0x03; // INT0, 1�� Enable ���ݴϴ�. 
 }
char SW1(void) // SW1�� ���� �Լ��Դϴ�. {
 {
 char ret; // return ���� ������ ���Ӱ� �����մϴ�.

 ret = switch1; // switch1�� ���� ���� �ٲߴϴ�.
 switch1 = FALSE; // switch1�� FALSE ���� �ֽ��ϴ�.

 return ret; // ret�� ��ȯ�մϴ�. 
 }
char SW2(void) // SW2�� ���� �Լ��Դϴ�. {
 {
 char ret; // return ���� ������ ���Ӱ� �����մϴ�.

 ret = switch2; // switch2�� ���� ���� �ٲߴϴ�.
 switch2 = FALSE; // switch2�� FALSE ���� �ֽ��ϴ�.

 return ret; // ret�� ��ȯ�մϴ�. 
 }

// Declare your global variables here
     char rotateR[8] = {0b1001,0b0001,0b0101,0b0100,0b0110,0b0010,0b1010,0b1000};
     char rotateL[8] = {0b1001,0b1000,0b1010,0b0010,0b0110,0b0100,0b0101,0b0001};
     int LeftstepCount, RightstepCount;        // rotateR�� rotateL�� ���� ������ ���Ϳ� ������� �Էµǵ��� Count 
     unsigned int VelocityLeftmotorTCNT1, VelocityRightmotorTCNT3;    // ���ʰ� ������ ������ TCNT �ӵ�
     unsigned char direction_control;        // ���ͷ�Ʈ ��ƾ�� ���������� �����ϱ� ���� ��������

     struct {
          int nStep4perBlock;            // �� ���� �̵��� �ʿ��� ����ȸ�� ���� ����
          int nStep4Turn90forRight;            // 90�� �� �̵��� �ʿ��� ����ȸ�� ���� ����
          int nStep4Turn90forLeft;
     } Information;
     struct {
          char LmotorRun;            // ���� ���Ͱ� ȸ���ߴ����� ���� Flag
          char RmotorRun;			// ������ ���Ͱ� ȸ���ߴ����� ���� Flag
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

    LeftstepCount = 0;		// ���� ������ ���� �ʱ�ȭ
     RightstepCount = 0;		// ������ ������ ���� �ʱ�ȭ

// Global enable interrupts
#asm("sei")

     VelocityLeftmotorTCNT1 = 65400;	// ���� ������ �ӵ� (65200 ~ 65535)
     VelocityRightmotorTCNT3 = 65400;	// ������ ������ �ӵ� (65200 ~ 65535)
    InitializeSwitch;
//     Direction(RIGHT);		// ��� 90�� ��
//     Direction(HALF);		// �ݺ��� ����

      switch1 = FALSE; // switch1, 2�� �ʱⰪ�� FALSE �Դϴ�.
        switch2 = FALSE;
while (1)
      {
      // Place your code here 
      Direction(LEFT);		// �·� 90�� ��

      Direction(LEFT);		// �·� 90�� 
      
            Direction(LEFT);		// �·� 90�� ��

      Direction(LEFT);		// �·� 90�� 
            Direction(LEFT);		// �·� 90�� ��

      Direction(LEFT);		// �·� 90�� 
            Direction(LEFT);		// �·� 90�� ��

      Direction(LEFT);		// �·� 90�� 
      break;
      }
}