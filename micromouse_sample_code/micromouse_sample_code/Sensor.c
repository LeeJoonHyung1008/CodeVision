#include <mega128.h>
#include <delay.h>
#include "Sensor.h"

// Arrays to save the reference value of the sensor
eeprom int StandardSensor[3], CenterStandardSensor[3];

// Read the AD conversion result
unsigned int read_adc(unsigned char adc_input){
    ADMUX = adc_input | (ADC_VREF_TYPE & 0xFF);
    // Delay needed for the stabilization of the ADC input voltage
    delay_us(10);
    // Start the AD conversion
    ADCSRA|=0x40;
    // Wait for the AD conversion to complete
    while ((ADCSRA & 0x10)==0);
    ADCSRA|=0x10;
    return ADCW;
}

void InitializeSensor(void){
    // Initialize PORTB 5,6,7 as output for emit sensors
    PORTB &= 0x1F;
    DDRB |= 0xE0;

    // Initialize PORTF 0,1,2 as input for detect sensors
    PORTF &= 0xF8;
    DDRF &= 0xF8;
    
    // ADC initialization
    // ADC Clock frequency: 125.000 kHz
    // ADC Voltage Reference: AVCC pin
    ADMUX = ADC_VREF_TYPE & 0xFF;
    ADCSRA = 0x87;
}

unsigned int readSensor(char si){
    unsigned int ret, i;
    
    switch(si){
    case FRONT_SENSOR:
        PORTB.5=1;
        delay_us(50);
        ret=read_adc(si);
        PORTB.5=0;
        break;
    case LEFT_SENSOR:
        PORTB.6=1;
        delay_us(50);
        ret=read_adc(si);
        PORTB.6=0;
        break;
    case RIGHT_SENSOR:
        PORTB.7=1;
        delay_us(50);
        ret=read_adc(si);
        PORTB.7=0;
        break;
    }
    return ret;
}