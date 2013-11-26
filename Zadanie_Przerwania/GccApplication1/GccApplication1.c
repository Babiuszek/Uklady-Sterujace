/*
 * GccApplication1.c
 *
 * Created: 2013-11-13 16:18:19
 *  Author: student
 */ 


#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>

#define F_CPU 16000000UL

int przerwania = 0;

ISR(TIMER0_OVF_vect)
{
	przerwania++;
}

void SETUP_TIMEOUT(int us)
{
	
}

void SETUP_PWM()
{
	// Setup Timer0 (FCPU/64)
	TCCR0 = (1 << CS00) | (0 << CS01) | (0 << CS02);
	// Setup Timer0 Mode to Fast PWM
	TCCR0 |= (1 << WGM00) | (1 << WGM01);
	// Enable Compare Interrupt and Overflow Interrupt
	TCCR0 |= (1 << COM00) | (1 << COM01);
	
	sei();
}

void SET_PWM(unsigned char in)
{
	OCR0 = in;
}

int main(void)
{
	//Not much to comment, basic function counts the amount of interrupts
	DDRB = 0x08;
	
	SETUP_PWM();
	
    while(1)
	{
		OCR0++;
		_delay_ms(20);
	}
}