#include <mega128.h>
#include <delay.h>
#include "Sensor.h"

eeprom int StandardSensor[3], CenterStandardSensor[3];

void InitializeSensor(void)
{
    PORTB &= 0x1F;
    DDRB |= 0xE0;
    PORTF &= 0xF8;
    DDRF &= 0xF8;
    ADMUX = ADC_VREF_TYPE & 0xFF;
    ADCSRA = 0x87;
}

unsigned int readSensor(char si)
{
    switch(si)
    {
        case FRONT_SENSOR:
            PORTB.5 = 1;
            delay_us(50);
            PORTB.5 = 0;
            return read_adc(si);
        case LEFT_SENSOR:
            PORTB.6 = 1;
            delay_us(50);
            PORTB.6=0;
            return read_adc(si);
        case RIGHT_SENSOR:
            PORTB.7=1;
            delay_us(50);
            PORTB.7=0;
            return read_adc(si);
    }
}

unsigned int read_adc(unsigned char adc_input)
{
    ADMUX = adc_input | (ADC_VREF_TYPE & 0xFF);
    delay_us(10);
    ADCSRA |= 0x40;
    while((ADCSRA & 0x10) == 0);
    ADCSRA |= 0x10;
    return ADCW;
}