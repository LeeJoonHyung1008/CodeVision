#include <mega128.h>
#include <math.h>
#include "StepMotor.h"
#include "Sensor.h"  // Use sensor in adjustmouse function

// Declare global variables
char rotateL[8] = {0b1001, 0b1000, 0b1010, 0b0010, 0b0110, 0b0100, 0b0101, 0b0001};		//상 여자방식 저장정보
char rotateR[8] = {0b1001, 0b0001, 0b0101, 0b0100, 0b0110, 0b0010, 0b1010, 0b1000};		//상 여자방식 저장정보
// Count so that the steps of rotateR and rotateL are entered in order in the motor
int LeftstepCount, RightstepCount;
// Velocities of left and right motor
unsigned int VelocityLeftmotorTCNT1, VelocityRightmotorTCNT3;
// Adjusted velocities of left and right motor, reference velocity
unsigned int vel_counter_high_L, vel_counter_high_R, vel_counter_high = 65400;
// Global variable for passing direction information to interrupt routine
unsigned char direction_control;

struct {
    int nStep4perBlock;  // Motor rotation step information required for moving one block		
    int nStep4Turn90;    // Motor rotation step information required for moving 90 degree turn
} Information;

struct {
    char LmotorRun;  // Flag for whether the left motor has rotated
    char RmotorRun;  // Flag for whether the right motor has rotated
} Flag;

void InitializeStepMotor(void){
    double distance4perStep;
    // Initialize PORTD 4,5,6,7 as output for left step motor
    PORTD &= 0x0F;
    DDRD |= 0xF0;

    // Timer/Counter 1 initialization
    // Clock source: System Clock
    // Clock value: 62.500 kHz
    // Mode: Normal top=0xFFFF
    // OC1A output: Discon.
    // OC1B output: Discon.
    // OC1C output: Discon.
    // Noise Canceler: Off
    // Input Capture on Falling Edge
    // Timer1 Overflow Interrupt: On
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

    // Initialize PORTE 4,5,6,7 as output for right step motor
    PORTE &= 0x0F;
    DDRE |= 0xF0;

    // Timer/Counter 3 initialization
    // Clock source: System Clock
    // Clock value: 62.500 kHz
    // Mode: Normal top=0xFFFF
    // OC3A output: Discon.
    // OC3B output: Discon.
    // OC3C output: Discon.
    // Noise Canceler: Off
    // Input Capture on Falling Edge
    // Timer3 Overflow Interrupt: On
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

    distance4perStep = (double)(PI * TIRE_RAD / (double)MOTOR_STEP);		//한칸 거리의 필요한 step수
	Information.nStep4perBlock = (int)((double)180. / distance4perStep);	//블록한칸 직진시 필요한 step 수	
	Information.nStep4Turn90 = (int)((PI*MOUSE_WIDTH/4.)/distance4perStep);	//90도 회전 시 필요한 step 수 좌우측 다를것이므로 변수 2개로 나눠하는게 유리

    // Initialize step of motor
    LeftstepCount = 0;
    RightstepCount = 0;

    // Initialize velocity of right motor (65200 ~ 65535)
    VelocityLeftmotorTCNT1 = vel_counter_high;			//TCNT값을 조정하여 바퀴가 회전하는 속도를 조절
    VelocityRightmotorTCNT3 = vel_counter_high;		//65200으로 갈 수록 저속 65535로 갈 수록 고속
}

// Timer 1 overflow interrupt service routine
interrupt [TIM1_OVF] void timer1_ovf_isr(void){
    PORTD |= (rotateL[LeftstepCount]<<4);
    PORTD &= ((rotateL[LeftstepCount]<<4)+0x0f);

    switch(direction_control){
        case LEFT:
            LeftstepCount--;
            if(LeftstepCount < 0)
                LeftstepCount = sizeof(rotateL)-1;		//상여자방식통해서 배열값 너어 실제로 회전
            break;
        case RIGHT:
        case BACK:
        case FORWARD:
        case HALF:
            LeftstepCount++;
            LeftstepCount %= sizeof(rotateL);
            break;
    }
    Flag.LmotorRun = True;

    TCNT1H = VelocityLeftmotorTCNT1 >> 8;
    TCNT1L = VelocityLeftmotorTCNT1 & 0xff;
}

// Timer 3 overflow interrupt service routine
interrupt [TIM3_OVF] void timer3_ovf_isr(void){
    PORTE |= (rotateR[RightstepCount]<<4);
    PORTE &= ((rotateR[RightstepCount]<<4)+0x0f);

    switch(direction_control){
        case RIGHT:
        case BACK:
            RightstepCount--;
            if(RightstepCount < 0)
                RightstepCount = sizeof(rotateR)-1;
            break;
        case FORWARD:
        case HALF:
        case LEFT:
            RightstepCount++;
            RightstepCount %= sizeof(rotateR);
            break;
    }
    Flag.RmotorRun = True;

    TCNT3H = VelocityRightmotorTCNT3 >> 8;
    TCNT3L = VelocityRightmotorTCNT3 & 0xff;
}

void adjustmouse(void){				//직진 보정 알고리즘
    int adjLeftSensor, adjRightSensor;
    int adjflagcnt = 0;

    adjLeftSensor = readSensor(LEFT_SENSOR); 		//왼쪽 센서값 읽어서 adjleft에 저장
    adjRightSensor = readSensor(RIGHT_SENSOR);	//우측 센서값 읽어서 adjright에 저장

    vel_counter_high_L = VelocityLeftmotorTCNT1;	//현재 바퀴속도값을 변수 counter에 각각 저장(65200 ~ 65535)
    vel_counter_high_R = VelocityRightmotorTCNT3;

    // If none of the left and right walls are present
    if((adjRightSensor<StandardSensor[2]) || (adjLeftSensor<StandardSensor[0])){	//좌우 벽중 하나가 없을 시 무조건 등속( 반대로 얘기하면 양쪽에 벽이 있어야만 좌우보정 start)
        vel_counter_high_L = vel_counter_high;  // Equal velocity
        vel_counter_high_R = vel_counter_high;
    }else{							//좌우 벽둘다 존재 할 경우 보정 시작
        // If the right wall is far
        if(adjRightSensor < CenterStandardSensor[2]){		//우측 벽이 더멀면
            vel_counter_high_L+=1;				//좌측 속도 높이고
            vel_counter_high_R-=1;				//우측 속도 down	1의 값을 높이면 변하는 tempo를 더 빠르게 할 수 있음
            if(vel_counter_high_L > vel_counter_high+20){		//속도 변화량의 최대값 설정 아무리 높아도 +20정도까지만 되게
                vel_counter_high_L = vel_counter_high+20; 
            }
            if(vel_counter_high_R < (vel_counter_high-20)){
                vel_counter_high_R = (vel_counter_high-20);
            }
        }else{
            adjflagcnt++;					//카운트 1증가
        }
        // If the left wall is far
        if(adjLeftSensor < CenterStandardSensor[0]){		//좌측벽도 마찬가지로 진행
            vel_counter_high_L-=1;
            vel_counter_high_R+=1;
            if(vel_counter_high_R > vel_counter_high+20){
                vel_counter_high_R = vel_counter_high+20; 
            }
            if(vel_counter_high_L < (vel_counter_high-20)){
                vel_counter_high_L = (vel_counter_high-20);
            }
        }else{
            adjflagcnt++;					//카운트 1중가
        }
        // If both left and right walls are not far away
        if(adjflagcnt==2){					//둘다 보정 후에 값 입력
            vel_counter_high_L = vel_counter_high;  // Equal velocity
            vel_counter_high_R = vel_counter_high;
        }
    }
    VelocityLeftmotorTCNT1 = vel_counter_high_L;
    VelocityRightmotorTCNT3 = vel_counter_high_R;
}

void Direction(int mode){				//모터 방향부
    int LStepCount = 0, RStepCount = 0;
    int nStep4run, OnGoing, adjFrontSensor;
    
    TCCR1B = 0x04;
    TCCR3B = 0x04;

    direction_control = mode;
    
    Flag.LmotorRun = False;
    Flag.RmotorRun = False;
    
    switch(mode){
    case FORWARD:										//직진시에
        while(LStepCount<Information.nStep4perBlock || RStepCount<Information.nStep4perBlock){	//왼쪽 오른쪽 모두 1블럭필요한 step수 될때까지 진행
            adjustmouse();
            if(Flag.LmotorRun){
                LStepCount++;
                Flag.LmotorRun = False;
            }
            if(Flag.RmotorRun){
                RStepCount++;
                Flag.RmotorRun = False;
            }
        }
        break;
    case HALF:
        while(LStepCount<Information.nStep4perBlock>>1 || RStepCount<Information.nStep4perBlock>>1){		//>>1은 0.5배하는것이므로 반블럭 step수 즉 half
            adjustmouse();
            if(Flag.LmotorRun){
                LStepCount++;
                Flag.LmotorRun = False;
            }
            if(Flag.RmotorRun){
                RStepCount++;
                Flag.RmotorRun = False;
            }
        }
        break;
    case LEFT:
    case RIGHT:								//left right 회전시 필요한 수는 동일하게 설정되있으나 실제론 다르므로 각각 분리하는게 유리
        while(LStepCount<Information.nStep4Turn90 || RStepCount<Information.nStep4Turn90){
            if(Flag.LmotorRun){
                LStepCount++;
                Flag.LmotorRun = False;
            }
            if(Flag.RmotorRun){
                RStepCount++;
                Flag.RmotorRun = False;
            }
        }
        break;
    case BACK:
        while(LStepCount<Information.nStep4Turn90*2 || RStepCount<Information.nStep4Turn90*2){
            if(Flag.LmotorRun){
                LStepCount++;
                Flag.LmotorRun = False;
            }
            if(Flag.RmotorRun){
                RStepCount++;
                Flag.RmotorRun = False;
            }
        }
        break;
    }
    TCCR1B = 0x00;
    TCCR3B = 0x00;
}