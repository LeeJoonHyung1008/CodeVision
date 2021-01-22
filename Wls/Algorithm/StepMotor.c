#include <mega128.h>
#include <math.h>
#include "StepMotor.h"
#include "Sensor.h"
#include <delay.h>

// Declare your global variables here
     char rotateR[8] = {0b1001,0b0001,0b0101,0b0100,0b0110,0b0010,0b1010,0b1000};
     char rotateL[8] = {0b1001,0b1000,0b1010,0b0010,0b0110,0b0100,0b0101,0b0001};

     int LeftstepCount;
     int RightstepCount;        // rotateR�� rotateL�� ���� ������ ���Ϳ� ������� �Էµǵ��� Count 
     unsigned int VelocityLeftmotorTCNT1;
     unsigned int VelocityRightmotorTCNT3;    // ���ʰ� ������ ������ TCNT �ӵ�
     unsigned char direction_control;        // ���ͷ�Ʈ ��ƾ�� ���������� �����ϱ� ���� ��������
     
     unsigned int vel_counter_high_L, vel_counter_high_R, vel_counter_high; // ���콺 ������ ���� ���� ����.

     struct {
          int nStep4perBlock;            // �� ��� �̵��� �ʿ��� ����ȸ�� ���� ����
          int nStep4Turn90forRight;            // 90�� �� �̵��� �ʿ��� ����ȸ�� ���� ����
          int nStep4Turn90forLeft;  // LEFT�� 90�� ȸ���� �ϱ� ���� step ��
          int nStep4Turn90_smooth;
     } Information;
     struct {
          char LmotorRun;            // ���� ���Ͱ� ȸ���ߴ����� ���� Flag
          char RmotorRun;            // ������ ���Ͱ� ȸ���ߴ����� ���� Flag
     } Flag;   

    void A(int speed)
    {
        VelocityLeftmotorTCNT1=65400;     
        VelocityRightmotorTCNT3=65400;
        VelocityLeftmotorTCNT1+=speed;
        VelocityRightmotorTCNT3+=speed;
        
        if(VelocityLeftmotorTCNT1 > 65535)
        {           
            VelocityLeftmotorTCNT1 = 65535;
        }                                 
        
        if(VelocityRightmotorTCNT3 > 65535)
        {
            VelocityRightmotorTCNT3 = 65535;
        }
        
    }
        
    void D(int speed2)
    { 
        VelocityLeftmotorTCNT1=65400;     
        VelocityRightmotorTCNT3=65400;
        VelocityLeftmotorTCNT1-=speed2;       
        VelocityRightmotorTCNT3-=speed2;
        
        if(VelocityLeftmotorTCNT1 < 65200)
        {           
            VelocityLeftmotorTCNT1 = 65200;
        }                                 
        
        if(VelocityRightmotorTCNT3 < 65200)
        {
            VelocityRightmotorTCNT3 = 65200;
        }                                 
    }			

int adjustmouse(void)
{
    int adjLeftSensor,adjRightSensor;
    int adjflagcnt = 0;

    adjLeftSensor = readSensor(LEFT_SENSOR); 
    adjRightSensor = readSensor(RIGHT_SENSOR);
    
    vel_counter_high_L = VelocityLeftmotorTCNT1;	        //���� �����ӵ����� ���� counter�� ���� ����(65200 ~ 65535)
    vel_counter_high_R = VelocityRightmotorTCNT3;
    
    if((adjRightSensor < StandardSensor[2])             // ������ ���� �������� ���� ���
    || (adjLeftSensor < StandardSensor[1]))             // ���� ���� �������� ���� ���
    {
        vel_counter_high_L = vel_counter_high;          // �ӵ��� �����ϰ� ����
        vel_counter_high_R = vel_counter_high;
        return 0;
    }                                   

    if(adjRightSensor < CenterStandardSensor[2])            // ������ ���� �� ���
    {
        vel_counter_high_L+=2.5;
        vel_counter_high_R-=2.5;
        if(vel_counter_high_L > vel_counter_high+15)
        {
            vel_counter_high_L = vel_counter_high+15; 
        }

        if(vel_counter_high_R < (vel_counter_high - 15))
        {
            vel_counter_high_R = (vel_counter_high - 15);
        }
    }
    else
    adjflagcnt++;

    if(adjLeftSensor < CenterStandardSensor[1])    // ���� ���� �� ���
    {
        vel_counter_high_L-=2.5;
        vel_counter_high_R+=2.5; 
        if(vel_counter_high_R > vel_counter_high+15)
        {
            vel_counter_high_R = vel_counter_high+15; 
        }
        if(vel_counter_high_L < (vel_counter_high - 15))
        {
            vel_counter_high_L = (vel_counter_high - 15);
        }
    }
    else
    adjflagcnt++;

    if(adjflagcnt == 2)  // ������ ���� ���� ���� �Ѵ� ���� ���� ���
	{					
		vel_counter_high_L = vel_counter_high;  // �ӵ� �����ϰ�
		vel_counter_high_R = vel_counter_high;

	}
    VelocityLeftmotorTCNT1 = vel_counter_high_L;
    VelocityRightmotorTCNT3 = vel_counter_high_R;
}
 
int adjustmouse_Super(void)                                                             //����
{
    int adjLeftSensor,adjRightSensor;                           //�����ϱ����� �������� ������ ����
    int adjflagcnt = 0;

    adjLeftSensor = readSensor(LEFT_SENSOR); 
    adjRightSensor = readSensor(RIGHT_SENSOR);                  //�о���� �������� ����
    
    vel_counter_high_L=VelocityLeftmotorTCNT1;                      //���� �ӵ� 65250 ���� �ʱ�ȭ
    vel_counter_high_R=VelocityRightmotorTCNT3;                          //���� �ӵ� 65400 ���� �ʱ�ȭ
         
   
    if(adjRightSensor > CenterStandardSensor[2])                    //�̷� ���� �� ���� �� ���� �ʹ� ������ �پ��� ��� 
    {
        vel_counter_high_L-=2;
        vel_counter_high_R+=1; 
        if(vel_counter_high_R > vel_counter_high+20)
            vel_counter_high_R = vel_counter_high+20;
        if(vel_counter_high_L < (vel_counter_high-20))
            vel_counter_high_L = (vel_counter_high-20);
                                                                    //���� ������ �ӵ��� ���̰� ������ ������ �ӵ��� ������ ������ ������ �־������� �Ͽ���. 
    }
    else
    {
        if(adjRightSensor < CenterStandardSensor[2])                        // ������ ���� �� ���
        {
            vel_counter_high_L+=1;
            vel_counter_high_R-=2;
            if(vel_counter_high_L > vel_counter_high+20)
                vel_counter_high_L = vel_counter_high+20;
            if(vel_counter_high_R < vel_counter_high-20)
                vel_counter_high_R = vel_counter_high-20;
                                                                                                        //������ ���� �� ��쿡 ���� ������ �ӵ��� ���̰� ������ ������ �ӵ��� �ٿ��� �������� ����� ���콺�� ��ġ�ϰ� �Ѵ�. 
        }
        else
            adjflagcnt++;                                                           //������ ���� �ʹ� �������� �ʰ�, ������ ���� ��� flagcnt ����

        if(adjLeftSensor < CenterStandardSensor[1])                                         // ���� ���� �� ���
        {
            vel_counter_high_L-=2;
            vel_counter_high_R+=1; 
            if(vel_counter_high_R > vel_counter_high+20)
                vel_counter_high_R = vel_counter_high+20;
            if(vel_counter_high_L < (vel_counter_high-20))
                vel_counter_high_L = (vel_counter_high-20);
                                                                                //���� ���� �� ��쿡 ������ ������ �ӵ��� ���̰� ���� ������ �ӵ��� �ٿ��� �������� ����� ���콺�� ��ġ�ϵ��� �Ѵ�. 
        }
        else
            adjflagcnt++;                                                           //������ ���� �ʹ� �������� �ʰ�, ���� ������ ���� ���� ��� flagcnt ����
    } 
    
    if(adjLeftSensor > CenterStandardSensor[1])                                     //���콺�� ���� ���� �ʹ� ������ ���� ���  
    {
        vel_counter_high_L+=1;
        vel_counter_high_R-=2;
        if(vel_counter_high_L > vel_counter_high+20)
            vel_counter_high_L = vel_counter_high+20;
        if(vel_counter_high_R < vel_counter_high-20)
            vel_counter_high_R = vel_counter_high-20;
                                                                                    //���ʸ����� �ӵ��� ���̰� ������ ������ �ӵ��� �ٿ��� �������� ����� ���콺�� ��ġ�ϵ��� �Ѵ�. 
    }
    else
    {
        if(adjRightSensor < CenterStandardSensor[2])                                // ������ ���� �� ���
        {
            vel_counter_high_L+=1;
            vel_counter_high_R-=2;
            if(vel_counter_high_L > vel_counter_high+20)
                vel_counter_high_L = vel_counter_high+20;
            if(vel_counter_high_R < vel_counter_high-20)
                vel_counter_high_R = vel_counter_high-20;
                                                                                        //���ʸ����� �ӵ��� ���̰� ������ ������ �ӵ��� �ٿ��� �������� ����� ���콺�� ��ġ�ϵ��� �Ѵ�.
        }
        else
            adjflagcnt++;                                                                   //���� ���� �ʹ� ������ �ʰ� ������ ������ ���� ���� ��� flagcnt ����

        if(adjLeftSensor < CenterStandardSensor[1])                                             // ���� ���� �� ���
        {
            vel_counter_high_L-=2;
            vel_counter_high_R+=1; 
            if(vel_counter_high_R > vel_counter_high+20)
                vel_counter_high_R = vel_counter_high+20;
            if(vel_counter_high_L < (vel_counter_high-20))
                vel_counter_high_L = (vel_counter_high-20);
                                                                                                    //���� ������ �ӵ��� ���̰� ������ ������ �ӵ��� �ٿ� �������� ����� ���콺�� ��ġ�ϵ��� �Ѵ�. 
        }
        else
            adjflagcnt++;                                                                           //���� ���� �ʹ� ������ �ʰ�, ���� ���� ���� ���� ���(���콺�� �������� ���) flagcnt ����

    }
    
    if(adjRightSensor < StandardSensor[2])                                                                  //������ ���� �������� ���� ���
    {
        if(adjLeftSensor < CenterStandardSensor[1])                                                      // ���� ���� �� ���
        {
            vel_counter_high_L-=2;
            vel_counter_high_R+=1; 
            if(vel_counter_high_R > vel_counter_high+20)
                vel_counter_high_R = vel_counter_high+20;
            if(vel_counter_high_L < (vel_counter_high-20))
                vel_counter_high_L = (vel_counter_high-20);
                                                                                                //���� ���� �� ��쿡 ������ ������ �ӵ��� ���̰� ���� ������ �ӵ��� �ٿ��� �������� ����� ���콺�� ��ġ�ϵ��� �Ѵ�. 
        }
        if(adjLeftSensor > CenterStandardSensor[1])                                                 //���콺�� ���� ���� �ʹ� ������ ���� ���  
        {
        vel_counter_high_L+=1;
        vel_counter_high_R-=2;
        if(vel_counter_high_L > vel_counter_high+20)
            vel_counter_high_L = vel_counter_high+20;
        if(vel_counter_high_R < vel_counter_high-20)
            vel_counter_high_R = vel_counter_high-20;
                                                                                        //���ʸ����� �ӵ��� ���̰� ������ ������ �ӵ��� �ٿ��� �������� ����� ���콺�� ��ġ�ϵ��� �Ѵ�. 
        }  
    } 
    
     if(adjLeftSensor < StandardSensor[2])                                                  //���� ���� �������� ���� ���
     {
           if(adjRightSensor < CenterStandardSensor[2])                                 // ������ ���� �� ���
        {
            vel_counter_high_L+=1;
            vel_counter_high_R-=2;
            if(vel_counter_high_L > vel_counter_high+20)
                vel_counter_high_L = vel_counter_high+20;
            if(vel_counter_high_R < vel_counter_high-20)
                vel_counter_high_R = vel_counter_high-20;
                                                                                            //���ʸ����� �ӵ��� ���̰� ������ ������ �ӵ��� �ٿ��� �������� ����� ���콺�� ��ġ�ϵ��� �Ѵ�.
        } 
        if(adjRightSensor > CenterStandardSensor[2])                                        //    �̷� ���� �� ���� �� ���� �ʹ� ������ �پ��� ��� 
         {
        vel_counter_high_L-=2;
        vel_counter_high_R+=1; 
        if(vel_counter_high_R > vel_counter_high+20)
            vel_counter_high_R = vel_counter_high+20;
        if(vel_counter_high_L < (vel_counter_high-20))
            vel_counter_high_L = (vel_counter_high-20);
                                                                                        //���� ������ �ӵ��� ���̰� ������ ������ �ӵ��� ������ ������ ������ �־������� �Ͽ���. 
        }
        
     } 
 
    if(adjflagcnt == 2)   
    {       // �ӵ� �����ϰ�
        vel_counter_high_L = vel_counter_high;
        vel_counter_high_R = vel_counter_high;
    }
    return 0;
}
    
void InitializeStepmotor(void)
{
	double distance4perStep;
    double distance4perStep_smooth;
    
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
     
	LeftstepCount = 0;
    RightstepCount = 0;  
    vel_counter_high = 65400;
    VelocityLeftmotorTCNT1 = vel_counter_high;
    VelocityRightmotorTCNT3 = vel_counter_high;
// LEFT MOTOR - PORTD 4,5,6,7
	PORTD&=0x0F;
// Timer(s)/Counter(s) Interrupt(s) initialization
	TIMSK=0x04;
	ETIMSK=0x04;
	     
	distance4perStep = (double)(PI * TIRE_RAD / (double)MOTOR_STEP);
    distance4perStep_smooth = (double)(PI * TIRE_RAD2 / (double)MOTOR_STEP);
     
	Information.nStep4perBlock = (int)((double)185. / distance4perStep);
	Information.nStep4Turn90forRight = (int)((PI*MOUSE_WIDTH/3.55)/distance4perStep);
	Information.nStep4Turn90forLeft = (int)((PI*MOUSE_WIDTH/3.85)/distance4perStep);
    Information.nStep4Turn90_smooth = (int)((PI*MOUSE_WIDTH/3.85)/distance4perStep_smooth);
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
              adjustmouse();  // �������� �����ϸ� �¿� ������ �����ؾ� �ϱ⿡ �ڵ� ù �κп� �����ߴ�.
              VelocityLeftmotorTCNT1=vel_counter_high_L;
              VelocityRightmotorTCNT3=vel_counter_high_R;
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
               if(readSensor(FRONT_SENSOR)>=CenterStandardSensor[0])    
               break;   // ������ �����Ǿ� ���濡 ���� ���� ��� �ٷ� ���߰� ��. 
               
               if(Flag.LmotorRun || Flag.RmotorRun)
               {    // Step�� ����� �� ���� ������ ����ǰԲ� �Ѵ�.
                    vel_counter_high_L= VelocityLeftmotorTCNT1; 
                    vel_counter_high_R =VelocityRightmotorTCNT3; 
                    adjustmouse_Super();                                    
                    VelocityLeftmotorTCNT1 =  vel_counter_high_L;
                    VelocityRightmotorTCNT3 = vel_counter_high_R; 
               }              
              
              
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
          
     case Quarter:
          while(LStepCount<((Information.nStep4perBlock>>2)) || RStepCount<((Information.nStep4perBlock>>2)))
          {      
               if(readSensor(FRONT_SENSOR)>=CenterStandardSensor[0])    
               break;   // ������ �����Ǿ� ���濡 ���� ���� ��� �ٷ� ���߰� ��.                                                 
                             
               if(Flag.LmotorRun || Flag.RmotorRun)
               {    // Step�� ����� �� ���� ������ ����ǰԲ� �Ѵ�.
                    vel_counter_high_L = VelocityLeftmotorTCNT1; 
                    vel_counter_high_R = VelocityRightmotorTCNT3; 
                    adjustmouse_Super();                                     
                    VelocityLeftmotorTCNT1 =  vel_counter_high_L;
                    VelocityRightmotorTCNT3 = vel_counter_high_R; 
               }
                              
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
     
     case HexaStep:
          while(LStepCount<(Information.nStep4perBlock>>3) || RStepCount<(Information.nStep4perBlock>>3))
          {      
           //   adjustmouse_Super();  // ���� �Լ��� ������ ���鼭 ������ �ϱ� ������ �����Ѵ�.
           //   VelocityLeftmotorTCNT1=vel_counter_high_L;
           //   VelocityRightmotorTCNT3=vel_counter_high_R;
              
               if(readSensor(FRONT_SENSOR)>=CenterStandardSensor[0])
               break;                                                 //���� ���� : ���濡 �� �ִ� ��� ����
                             
               if(Flag.LmotorRun || Flag.RmotorRun)
               {
                    vel_counter_high_L= VelocityLeftmotorTCNT1; 
                    vel_counter_high_R =VelocityRightmotorTCNT3; 
                    adjustmouse_Super();                                  //���콺 �ڼ� ����   
                    VelocityLeftmotorTCNT1 =  vel_counter_high_L;
                    VelocityRightmotorTCNT3 = vel_counter_high_R; 
               }
                              
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
                         
     case SmoothR:        
     case SmoothL:
          while(RStepCount<Information.nStep4Turn90_smooth || LStepCount<Information.nStep4Turn90_smooth)
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
          while(LStepCount<(Information.nStep4Turn90_smooth*2) || RStepCount<(Information.nStep4Turn90_smooth*2))
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
          case Quarter:
          case ACCEL:
          case FORWARD:
          case HALF:
          case SmoothR:
               PORTD |= (rotateL[LeftstepCount]<<4);
               PORTD &= ((rotateL[LeftstepCount]<<4)+0x0f);
               LeftstepCount++;
               LeftstepCount %= sizeof(rotateL);
               break;
          case SmoothL: 
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
          case ACCEL:               
          case FORWARD:
          case HALF:
          case Quarter:
          case LEFT:
          case SmoothL:
               PORTE |= (rotateR[RightstepCount]<<4);
               PORTE &= ((rotateR[RightstepCount]<<4)+0x0f);
               RightstepCount++;
               RightstepCount %= sizeof(rotateR);
               break;
          case SmoothR:
          break;
     }
     Flag.RmotorRun = TRUE;

     TCNT3H = VelocityRightmotorTCNT3 >> 8;
     TCNT3L = VelocityRightmotorTCNT3 & 0xff;
}
