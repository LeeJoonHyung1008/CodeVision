#ifndef _SENSOR_H_
#define _SENSOR_H_

#define FRONT_SENSOR  0
#define LEFT_SENSOR   1
#define RIGHT_SENSOR  2
#define ADC_VREF_TYPE 0x40

extern eeprom int StandardSensor[3], CenterStandardSensor[3];

void InitializeSensor(void);
unsigned int readSensor(char si);
unsigned int read_adc(unsigned char adc_input);

#endif