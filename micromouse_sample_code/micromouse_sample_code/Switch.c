#include <mega128.h>
#include "Switch.h"

struct Buttons{
    char SW1;
    char SW2;
} Button;

void InitializeSwitch(void){
    // Initialize PORTD 0,1 as input for Switch
    PORTD &= 0xFC;
    DDRD &= 0xFC;

    // Initialize External Intterupt
    // INT0: Falling edge
    // INT1: Falling edge
    EICRA = 0x0A;   // 0b00001100
    EICRB = 0x00;   // 0b00000000
    EIMSK = 0x03;   // 0b00000011
    EIFR = 0x03;    // 0b00000011
    
    // Buttons' initial state
    Button.SW1 = False;
    Button.SW2 = False;
}

char SW1(void){
    char ret;           // variable for return
    ret = Button.SW1;   // check SW1 is pressed
    Button.SW1 = False; // SW1 reset
    return ret;
}

char SW2(void){
    char ret;           // variable for return
    ret = Button.SW2;   // check SW2 is pressed
    Button.SW2 = False; // SW2 reset
    return ret;
}

// External Interrupt 0 service routine
interrupt [EXT_INT0] void ext_int0_isr(void){
    // When SW1 is pressed, then set ON flag
    Button.SW1 = True;
}

// External Interrupt 1 service routine
interrupt [EXT_INT1] void ext_int1_isr(void){
    // When SW2 is pressed, then set ON flag
    Button.SW2 = True;
}