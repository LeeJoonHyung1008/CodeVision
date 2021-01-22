#include <mega128.h>
#include <math.h>
#include "StepMotor.h"
#include "Sensor.h"
#include <delay.h>

// Declare your global variables here
     char rotateR[8] = {0b1001,0b0001,0b0101,0b0100,0b0110,0b0010,0b1010,0b1000};
     char rotateL[8] = {0b1001,0b1000,0b1010,0b0010,0b0110,0b0100,0b0101,0b0001};

     int LeftstepCount;
     int RightstepCount;        // rotateR과 rotateL의 각각 스텝이 모터에 순서대로 입력되도록 Count 
     unsigned int VelocityLeftmotorTCNT1;
     unsigned int VelocityRightmotorTCNT3;    // 왼쪽과 오른쪽 모터의 TCNT 속도
     unsigned char direction_control;        // 인터럽트 루틴에 방향정보를 전달하기 위한 전역변수
     
     unsigned int vel_counter_high_L, vel_counter_high_R, vel_counter_high; // 마우스 보정을 위한 변수 설정.

     struct {
          int nStep4perBlock;            // 한 블록 이동시 필요한 모터회전 스텝 정보
          int nStep4Turn90forRight;            // 90도 턴 이동시 필요한 모터회전 스텝 정보
          int nStep4Turn90forLeft;  // LEFT가 90도 회전을 하기 위한 step 수
          int nStep4Turn90_smooth;
     } Information;
     struct {
          char LmotorRun;            // 왼쪽 모터가 회전했는지에 대한 Flag
          char RmotorRun;            // 오른쪽 모터가 회전했는지에 대한 Flag
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
    
    vel_counter_high_L = VelocityLeftmotorTCNT1;	        //현재 바퀴속도값을 변수 counter에 각각 저장(65200 ~ 65535)
    vel_counter_high_R = VelocityRightmotorTCNT3;
    
    if((adjRightSensor < StandardSensor[2])             // 오른쪽 벽이 존재하지 않을 경우
    || (adjLeftSensor < StandardSensor[1]))             // 왼쪽 벽이 존재하지 않을 경우
    {
        vel_counter_high_L = vel_counter_high;          // 속도를 같게하고 리턴
        vel_counter_high_R = vel_counter_high;
        return 0;
    }                                   

    if(adjRightSensor < CenterStandardSensor[2])            // 오른쪽 벽이 멀 경우
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

    if(adjLeftSensor < CenterStandardSensor[1])    // 왼쪽 벽이 멀 경우
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

    if(adjflagcnt == 2)  // 오른쪽 벽과 왼쪽 벽이 둘다 멀지 않을 경우
	{					
		vel_counter_high_L = vel_counter_high;  // 속도 동일하게
		vel_counter_high_R = vel_counter_high;

	}
    VelocityLeftmotorTCNT1 = vel_counter_high_L;
    VelocityRightmotorTCNT3 = vel_counter_high_R;
}
 
int adjustmouse_Super(void)                                                             //보정
{
    int adjLeftSensor,adjRightSensor;                           //보정하기위한 센서값을 저장한 변수
    int adjflagcnt = 0;

    adjLeftSensor = readSensor(LEFT_SENSOR); 
    adjRightSensor = readSensor(RIGHT_SENSOR);                  //읽어들인 센서값을 저장
    
    vel_counter_high_L=VelocityLeftmotorTCNT1;                      //모터 속도 65250 으로 초기화
    vel_counter_high_R=VelocityRightmotorTCNT3;                          //모터 속도 65400 으로 초기화
         
   
    if(adjRightSensor > CenterStandardSensor[2])                    //미로 주행 중 오른 쪽 벽에 너무 가까이 붙었을 경우 
    {
        vel_counter_high_L-=2;
        vel_counter_high_R+=1; 
        if(vel_counter_high_R > vel_counter_high+20)
            vel_counter_high_R = vel_counter_high+20;
        if(vel_counter_high_L < (vel_counter_high-20))
            vel_counter_high_L = (vel_counter_high-20);
                                                                    //왼쪽 모터의 속도를 줄이고 오른쪽 모터의 속도를 높여서 오른쪽 벽에서 멀어지도록 하였다. 
    }
    else
    {
        if(adjRightSensor < CenterStandardSensor[2])                        // 오른쪽 벽이 멀 경우
        {
            vel_counter_high_L+=1;
            vel_counter_high_R-=2;
            if(vel_counter_high_L > vel_counter_high+20)
                vel_counter_high_L = vel_counter_high+20;
            if(vel_counter_high_R < vel_counter_high-20)
                vel_counter_high_R = vel_counter_high-20;
                                                                                                        //오른쪽 벽이 멀 경우에 왼쪽 모터의 속도를 높이고 오른쪽 모터의 속도를 줄여서 주행경로의 가운데에 마우스가 위치하게 한다. 
        }
        else
            adjflagcnt++;                                                           //오른쪽 벽에 너무 가깝지도 않고, 멀지도 않은 경우 flagcnt 증가

        if(adjLeftSensor < CenterStandardSensor[1])                                         // 왼쪽 벽이 멀 경우
        {
            vel_counter_high_L-=2;
            vel_counter_high_R+=1; 
            if(vel_counter_high_R > vel_counter_high+20)
                vel_counter_high_R = vel_counter_high+20;
            if(vel_counter_high_L < (vel_counter_high-20))
                vel_counter_high_L = (vel_counter_high-20);
                                                                                //왼쪽 벽이 멀 경우에 오른쪽 모터의 속도를 높이고 왼쪽 모터의 속도를 줄여서 주행경로의 가운데에 마우스가 위치하도록 한다. 
        }
        else
            adjflagcnt++;                                                           //오른쪽 벽에 너무 가깝지도 않고, 왼쪽 벽과도 멀지 않은 경우 flagcnt 증가
    } 
    
    if(adjLeftSensor > CenterStandardSensor[1])                                     //마우스가 왼쪽 벽에 너무 가까이 붙은 경우  
    {
        vel_counter_high_L+=1;
        vel_counter_high_R-=2;
        if(vel_counter_high_L > vel_counter_high+20)
            vel_counter_high_L = vel_counter_high+20;
        if(vel_counter_high_R < vel_counter_high-20)
            vel_counter_high_R = vel_counter_high-20;
                                                                                    //왼쪽모터의 속도를 높이고 오른쪽 모터의 속도를 줄여서 주행경로의 가운데에 마우스가 위치하도록 한다. 
    }
    else
    {
        if(adjRightSensor < CenterStandardSensor[2])                                // 오른쪽 벽이 멀 경우
        {
            vel_counter_high_L+=1;
            vel_counter_high_R-=2;
            if(vel_counter_high_L > vel_counter_high+20)
                vel_counter_high_L = vel_counter_high+20;
            if(vel_counter_high_R < vel_counter_high-20)
                vel_counter_high_R = vel_counter_high-20;
                                                                                        //왼쪽모터의 속도를 높이고 오른쪽 모터의 속도를 줄여서 주행경로의 가운데에 마우스가 위치하도록 한다.
        }
        else
            adjflagcnt++;                                                                   //왼쪽 벽에 너무 가깝지 않고 오른쪽 벽과도 멀지 않은 경우 flagcnt 증가

        if(adjLeftSensor < CenterStandardSensor[1])                                             // 왼쪽 벽이 멀 경우
        {
            vel_counter_high_L-=2;
            vel_counter_high_R+=1; 
            if(vel_counter_high_R > vel_counter_high+20)
                vel_counter_high_R = vel_counter_high+20;
            if(vel_counter_high_L < (vel_counter_high-20))
                vel_counter_high_L = (vel_counter_high-20);
                                                                                                    //왼쪽 모터의 속도를 줄이고 오른쪽 모터의 속도를 줄여 주행경로의 가운데에 마우스가 위치하도록 한다. 
        }
        else
            adjflagcnt++;                                                                           //왼쪽 벽에 너무 붙지도 않고, 왼쪽 벽에 멀지 않은 경우(마우스가 주행경로의 가운데) flagcnt 증가

    }
    
    if(adjRightSensor < StandardSensor[2])                                                                  //오른쪽 벽이 존재하지 않을 경우
    {
        if(adjLeftSensor < CenterStandardSensor[1])                                                      // 왼쪽 벽이 멀 경우
        {
            vel_counter_high_L-=2;
            vel_counter_high_R+=1; 
            if(vel_counter_high_R > vel_counter_high+20)
                vel_counter_high_R = vel_counter_high+20;
            if(vel_counter_high_L < (vel_counter_high-20))
                vel_counter_high_L = (vel_counter_high-20);
                                                                                                //왼쪽 벽이 멀 경우에 오른쪽 모터의 속도를 높이고 왼쪽 모터의 속도를 줄여서 주행경로의 가운데에 마우스가 위치하도록 한다. 
        }
        if(adjLeftSensor > CenterStandardSensor[1])                                                 //마우스가 왼쪽 벽에 너무 가까이 붙은 경우  
        {
        vel_counter_high_L+=1;
        vel_counter_high_R-=2;
        if(vel_counter_high_L > vel_counter_high+20)
            vel_counter_high_L = vel_counter_high+20;
        if(vel_counter_high_R < vel_counter_high-20)
            vel_counter_high_R = vel_counter_high-20;
                                                                                        //왼쪽모터의 속도를 높이고 오른쪽 모터의 속도를 줄여서 주행경로의 가운데에 마우스가 위치하도록 한다. 
        }  
    } 
    
     if(adjLeftSensor < StandardSensor[2])                                                  //왼쪽 벽이 존재하지 않을 경우
     {
           if(adjRightSensor < CenterStandardSensor[2])                                 // 오른쪽 벽이 멀 경우
        {
            vel_counter_high_L+=1;
            vel_counter_high_R-=2;
            if(vel_counter_high_L > vel_counter_high+20)
                vel_counter_high_L = vel_counter_high+20;
            if(vel_counter_high_R < vel_counter_high-20)
                vel_counter_high_R = vel_counter_high-20;
                                                                                            //왼쪽모터의 속도를 높이고 오른쪽 모터의 속도를 줄여서 주행경로의 가운데에 마우스가 위치하도록 한다.
        } 
        if(adjRightSensor > CenterStandardSensor[2])                                        //    미로 주행 중 오른 쪽 벽에 너무 가까이 붙었을 경우 
         {
        vel_counter_high_L-=2;
        vel_counter_high_R+=1; 
        if(vel_counter_high_R > vel_counter_high+20)
            vel_counter_high_R = vel_counter_high+20;
        if(vel_counter_high_L < (vel_counter_high-20))
            vel_counter_high_L = (vel_counter_high-20);
                                                                                        //왼쪽 모터의 속도를 줄이고 오른쪽 모터의 속도를 높여서 오른쪽 벽에서 멀어지도록 하였다. 
        }
        
     } 
 
    if(adjflagcnt == 2)   
    {       // 속도 동일하게
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
              adjustmouse();  // 직진으로 진행하며 좌우 보정을 진행해야 하기에 코드 첫 부분에 삽입했다.
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
               break;   // 오차가 누적되어 전방에 벽이 있을 경우 바로 멈추게 함. 
               
               if(Flag.LmotorRun || Flag.RmotorRun)
               {    // Step이 진행될 때 마다 보정이 진행되게끔 한다.
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
               break;   // 오차가 누적되어 전방에 벽이 있을 경우 바로 멈추게 함.                                                 
                             
               if(Flag.LmotorRun || Flag.RmotorRun)
               {    // Step이 진행될 때 마다 보정이 진행되게끔 한다.
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
           //   adjustmouse_Super();  // 보정 함수는 앞으로 가면서 보정을 하기 때문에 삽입한다.
           //   VelocityLeftmotorTCNT1=vel_counter_high_L;
           //   VelocityRightmotorTCNT3=vel_counter_high_R;
              
               if(readSensor(FRONT_SENSOR)>=CenterStandardSensor[0])
               break;                                                 //전방 보정 : 전방에 벽 있는 경우 정지
                             
               if(Flag.LmotorRun || Flag.RmotorRun)
               {
                    vel_counter_high_L= VelocityLeftmotorTCNT1; 
                    vel_counter_high_R =VelocityRightmotorTCNT3; 
                    adjustmouse_Super();                                  //마우스 자세 보정   
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
