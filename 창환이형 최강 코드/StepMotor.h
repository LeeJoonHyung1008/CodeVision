#ifndef _STEPMOTOR_H_
#define _STEPMOTOR_H_

#ifndef TRUE
#define TRUE    1
#endif

#ifndef FALSE
#define FALSE   0
#endif

#define ACCEL           1
#define NOACCEL         2
#define DEACCEL         3
#define FORWARD         4
#define LEFT            5
#define RIGHT           6
#define BACK            7
#define HALF            8
#define SMOOTHLEFT      9
#define SMOOTHRIGHT     10
#define SENSORTOCENTER  11

#define TIRE_RAD            52.     // unit : mm
#define MOUSE_WIDTH_LEFT    85.    // unit : mm (middle of tire)
#define MOUSE_WIDTH_RIGHT   87.    // unit : mm (middle of tire)
#define MOUSE_LENGTH        114.    // unit : mm
#define MOTOR_STEP          400     // unit : step
#define SMOOTHTURNLEFT      53.5
#define SMOOTHTURNRIGHT     49.5

void InitializeStepMotor(void);
void Direction(int mode);
void adjustmouse(void);
void Super_adjust(void);

#endif