#include "delay.h"



void delay_ms(unsigned int mseconds)
{
	XTime tEnd, tCur;

	XTime_GetTime(&tCur);
	tEnd = tCur + (((XTime) mseconds) * (COUNTS_PER_SECOND / 1000));
	do
	{
		XTime_GetTime(&tCur);
	} while (tCur < tEnd);
}

void delay_us(unsigned int useconds)
{
	XTime tEnd, tCur;

	XTime_GetTime(&tCur);
	tEnd = tCur + (((XTime) useconds) * (COUNTS_PER_SECOND / 1000000));
	do
	{
		XTime_GetTime(&tCur);
	} while (tCur < tEnd);
}
void delay_ns(unsigned int nseconds)
{
	XTime tEnd, tCur;

	XTime_GetTime(&tCur);
	tEnd = tCur + (((XTime) nseconds) );
	do
	{
		XTime_GetTime(&tCur);
	} while (tCur < tEnd);
}
