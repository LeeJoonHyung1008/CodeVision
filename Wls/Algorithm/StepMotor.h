#ifndef _StepMotor_h_
#define _StepMotor_h_

#ifndef 	TRUE
#define   TRUE		1
#endif

#ifndef     FALSE
#define   FALSE        0
#endif

#define   FORWARD        4
#define   LEFT        5
#define   RIGHT        6
#define   BACK        7
#define   HALF        8
#define   ACCEL 9 // ACCEL�� ���� �Ǿ����� �����Ƿ� 9�� �����ߴ�. 
#define   DEACCEL 10 // DEACCEL�� ���� �Ǿ����� �����Ƿ� 10�� �����ߴ�. 
#define   NOACCEL 11 // NOACCEL�� ���� �Ǿ����� �����Ƿ� 11�� �����ߴ�.
#define   SmoothL 12
#define   SmoothR 13
#define   Quarter 14
#define   HexaStep 15

#define   TIRE_RAD        51.    // unit : mm
#define   TIRE_RAD2       52.
#define   MOUSE_WIDTH    82.    // unit : mm (Ÿ�̾� �߰�)
#define   MOUSE_LENGTH    114.    // unit : mm
#define   MOTOR_STEP    400    // unit : step

     void InitializeStepmotor(void);
     void Direction(int mode);
     int adjustmouse(void);
     int adjustmouse_Super(void);  
     void A(int speed);
     void D(int speed2);
       
#endif