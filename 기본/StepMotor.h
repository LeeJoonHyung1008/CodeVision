#ifndef _STEPMOTOR_H_
#define _STEPMOTOR_H_

#ifndef TRUE
#define TRUE    1
#endif

#ifndef FALSE
#define FALSE   0
#endif

#define ACCEL   1
#define NOACCEL 2
#define DEACCEL 3
#define FORWARD 4
#define LEFT    5
#define RIGHT   6
#define BACK    7
#define HALF    8

#define TIRE_RAD        52.   // unit : mm
#define MOUSE_WIDTH     83.2   // unit : mm (middle of tire)
#define MOUSE_LENGTH    114.  // unit : mm
#define MOTOR_STEP      400   // unit : step

void InitializeStepMotor(void);
void Direction(int mode);
void adjustmouse(void);

#endif