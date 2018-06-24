// timer0.c
// Runs on LM4F120 or TM4C123
// Use SysTick interrupts to implement a single 440Hz sine wave
// Port B bits 3-0 have the 4-bit binary weighted DAC
// Port F is onboard LaunchPad switches and LED
// Port F bit 4 is negative logic switch to play sound, SW1
// SysTick ISR: PF3 ISR heartbeat

#include "../tm4c123gh6pm.h"
#include "PLL.h"
#include "Sound.h"
#include "Switch.h"

// basic functions defined at end of startup.s
void DisableInterrupts(void); // Disable interrupts
void EnableInterrupts(void);  // Enable interrupts
void WaitForInterrupt(void);  // low power mode
// need to generate a 100 Hz sine wave
// table size is 16, so need 100Hz*16=1.6 kHz interrupt
// bus is 80MHz, so SysTick period is 80000kHz/1.6kHz = 50000
int main(void){ unsigned long i,input,previous,increase;
 increase = 4500;	
  DisableInterrupts();    
  PLL_Init();          // bus clock at 80 MHz
  Switch_Init();       // Port F is onboard switches, LEDs, profiling
  Sound_Init(50000);   // initialize SysTick timer, 100 Hz
// Initial testing, law of superposition
  DAC_Out(1);
  DAC_Out(2);
  DAC_Out(4);
// static testing, single step and record Vout

// dynamic testing, push SW1 for sound
  previous = Switch_In()&0x10;
  while(1){ 
    input = Switch_In()&0x10; // bit 4 means SW1 pressed
    if(input&&(previous==0)){ // just pressed     
      EnableInterrupts();
      Sound_Init(increase);      // Play 100 Hz wave
	//		increase = increase - 100;
	for(i=0;i<8;i++){
    DAC_Out(i);
  }
    }
    if(previous&&(input==0)){ // just released     
      //DisableInterrupts();    // stop sound
    }
    previous = input; 
    Delay10ms();  // remove switch bounce    
  }  
}

