/*
 * kernel.c
 *
 * Created: 2013-11-20 15:46:16
 *  Author: student
 */ 

#include "kernel.h"

TASK TASK_TABLE[MAX_TASKS];

int task_count = 0;

ISR(TIMER0_COMP_vect)
{
	//Interrupt function that updates the amount of miliseconds to wait for each task
	for (int i = 0; i < MAX_TASKS; i++)
	{
		//Obviously skipping void tasks...
		if (TASK_TABLE[i].taskPtr == PTR_VOID)
			continue;
		
		//...and lowering time to go/rising ready amount if needed
		if (TASK_TABLE[i].toGo == 0)
		{
			if (TASK_TABLE[i].interval == 0)
				if (TASK_TABLE[i].ready > 0)
					continue;
			
			TASK_TABLE[i].toGo = TASK_TABLE[i].interval;
			TASK_TABLE[i].ready++;
		}
		else
		{
			TASK_TABLE[i].toGo--;
		}
	}
}

void structure()
{
	TIMSK |= (1 << OCIE0); //On compare
	TCCR0 |= (1 << CS01) | (1 << CS00);   //Clock parameter 64
	TCCR0 |= (1 << WGM01); //CTC
	OCR0 = 250; //1 milisecond
	sei();
	
	task_count = 0;
	while (1)
	{
		//Generic loop that checks if a task exists (is not void) and if it is ready to work.
		//Do note that starting a task resets the task_count to 0, once again checking programs with
		//higher priorities.
		if (TASK_TABLE[task_count].taskPtr == PTR_VOID)
		{
			task_count = task_count+1;
			if (task_count >= MAX_TASKS)
				task_count = 0;
		}
		else if (TASK_TABLE[task_count].ready > 0)
		{
			TASK_TABLE[task_count].taskPtr();
			TASK_TABLE[task_count].ready = TASK_TABLE[task_count].ready - 1;
			
			//In case of one shot, do the task and than remove it.
			if (TASK_TABLE[task_count].interval == 0)
				kernel_removeTask(task_count);
			
			task_count = 0;
		}
		else
		{
			task_count = task_count+1;
			if (task_count >= MAX_TASKS)
				task_count = 0;
		}
	}
}

void kernel_addTask(TASK_PTR _tP, uint16 _in, uint16 _pr)
{
	TASK_TABLE[_pr].taskPtr = _tP;
	TASK_TABLE[_pr].ready = 0;
	TASK_TABLE[_pr].interval = _in;
	TASK_TABLE[_pr].toGo = 0;
}

void kernel_removeTask(int i)
{
	TASK_TABLE[i].taskPtr = PTR_VOID;
}