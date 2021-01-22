#ifndef _STEPMOTOR_H_
#define _STEPMOTOR_H_

#ifndef True
#define True    1
#endif

#ifndef False
#define False   0
#endif

#define FORWARD 4
#define LEFT    5
#define RIGHT   6
#define BACK    7
#define HALF    8

#define TIRE_RAD        50.   // unit : mm
#define MOUSE_WIDTH     80.   // unit : mm (middle of tire)
#define MOUSE_LENGTH    100.  // unit : mm
#define MOTOR_STEP      500   // unit : step

    void InitializeStepMotor(void);
    void Direction(int mode);

#endif