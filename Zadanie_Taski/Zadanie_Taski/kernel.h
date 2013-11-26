/*
 * kernel.h
 *
 * Created: 2013-11-20 15:37:40
 *  Author: student
 */ 

#ifndef KERNEL_H_
#define KERNEL_H_

#include <avr/interrupt.h>

#define MAX_TASKS 10
#define PTR_VOID 0

typedef void (*TASK_PTR)(void);
typedef unsigned char uint8;
typedef unsigned short int uint16;

typedef struct {
	TASK_PTR taskPtr;
	uint8 ready;
	uint16 toGo;
	uint16 interval;
} TASK;

void structure();
void kernel_addTask(TASK_PTR _tP, uint16 _in, uint16 _pr);
void kernel_removeTask(int i);

#endif /* KERNEL_H_ */