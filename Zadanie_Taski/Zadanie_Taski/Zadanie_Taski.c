/*
 * Zadanie_Taski.c
 *
 * Created: 2013-11-20 15:36:30
 *  Author: student
 */ 


#include <avr/io.h>

void temp1(void)
{
	if (PORTA & 0x80)
		PORTA &= 0x7f;
	else
		PORTA |= 0x80;
}

void temp2(void)
{
	if (PORTA & 0x40)
		PORTA &= 0xbf;
	else
		PORTA |= 0x40;
}

void temp3(void)
{
	if (PORTA & 0x20)
		PORTA &= 0xdf;
	else
		PORTA |= 0x20;
}

void temp4(void)
{
	if (PORTA & 0x80)
		PORTA &= 0xef;
	else
		PORTA |= 0x10;
}

int main(void)
{
	//Initializing output
	DDRA = 0xff;
	PORTA = 0x00;
	
	//Filling in some functions that turn the proper lights on/off. The number is the delay between runs in miliseconds
	kernel_addTask(temp1, 50, 0);
	kernel_addTask(temp2, 100, 1);
	kernel_addTask(temp3, 250, 2);
	kernel_addTask(temp4, 500, 3);
	
	structure();
}