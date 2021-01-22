#ifndef _SENSOR_H_
#define _SENSOR_H_

#define FRONT_SENSOR  0
#define LEFT_SENSOR   1
#define RIGHT_SENSOR  2

#define ADC_VREF_TYPE 0x40

    // Declare 'extern' to use the references in other file
    // These arrays can be used by just including
    extern eeprom int StandardSensor[3], CenterStandardSensor[3];
    
    void InitializeSensor(void);
    unsigned int readSensor(char si);
     
#endif