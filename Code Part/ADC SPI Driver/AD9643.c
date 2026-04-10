#include "AD9643.h"
#include "XGpio.h"
#include "delay.h"

XGpio ADC1CS;
XGpio ADC1SCLK;
XGpio ADC1SDIO;

AD9643_REGS ADC1_INIT;

uint8_t testmode_en =0;
uint8_t adc1_dcodelay =0;//delay = (3100 ps �� register value/31 +100) 5bit
int adc1_offset = 0; // -32 to +31

void AD9643_io_init(){
	XGpio_Initialize(&ADC1CS,			XPAR_ADC1_SPI_ADC1_CS_DEVICE_ID);
	XGpio_Initialize(&ADC1SDIO,			XPAR_ADC1_SPI_ADC1_SDIO_DEVICE_ID);
	XGpio_Initialize(&ADC1SCLK,			XPAR_ADC1_SPI_ADC1_SCLK_DEVICE_ID);

	XGpio_SetDataDirection(&ADC1CS,        1, 0x0);
	XGpio_SetDataDirection(&ADC1SDIO,      1, 0x0);
	XGpio_SetDataDirection(&ADC1SCLK,        1, 0x0);

	XGpio_DiscreteWrite(&ADC1CS, 			 1, 0x1);
	XGpio_DiscreteWrite(&ADC1SDIO, 		 1, 0x0);
	XGpio_DiscreteWrite(&ADC1SCLK, 			 1, 0x0);
}

void AD9643_Wirte_Data(uint16_t ADDR,uint8_t Data){
	XGpio_DiscreteWrite(&ADC1CS,     1,0x1);
	//sleep(1);
	delay_ns(1);
	XGpio_DiscreteWrite(&ADC1SCLK, 1,0x0);
	delay_ns(1);
	XGpio_DiscreteWrite(&ADC1CS,     1,0x0);
	delay_ns(1);
	for(int j=0;j<16;j++){
		delay_ns(1);
			XGpio_DiscreteWrite(&ADC1SCLK, 1,0x0);
			delay_ns(1);
			XGpio_DiscreteWrite(&ADC1SDIO  , 1,(ADDR >> (15-j)) & 0x01);	// MSB
			delay_ns(1);
			XGpio_DiscreteWrite(&ADC1SCLK, 1,0x1);
			delay_ns(1);
		}
	for(int j=0;j<8;j++){
		delay_ns(1);
			XGpio_DiscreteWrite(&ADC1SCLK, 1,0x0);
			delay_ns(1);
			XGpio_DiscreteWrite(&ADC1SDIO  , 1,(Data >> (7-j)) & 0x01);	// MSB
			delay_ns(1);
			XGpio_DiscreteWrite(&ADC1SCLK, 1,0x1);
			delay_ns(1);
		}
	delay_ns(1);
	XGpio_DiscreteWrite(&ADC1SCLK,     1,0x0);
	delay_ns(1);
	XGpio_DiscreteWrite(&ADC1CS,     1,0x1);
	delay_ns(1);
}

void AD9643_INIT(){
    ADC1_INIT.CONFIG = MSB_MODE | SOFT_RST; // RESET & MSBMODE
    ADC1_INIT.CHINDEX = CHA_CHB_MODE; // BOTH CHANNEL
    ADC1_INIT.POWERMODE = EX_PD_EN | NORMAL_OPERAT; // NORMAL OPERATION
    ADC1_INIT.GLOBALCLK = DC_STABILIZER_EN; // DC STABILIZER ENABLE
    ADC1_INIT.CLKDIV = CLK_PHASE_ADJ_0 | CLK_DIV_1; // CLK DIV 1 & PHASE ADJ 0
    if (testmode_en){
        ADC1_INIT.TESTMODE = TEST_RAMP; // TEST MODE ramp
    }
    else{
       ADC1_INIT.TESTMODE = TEST_OFF; // TEST MODE OFF
    }
   // ADC1_INIT.OFFSETADJ = adc1_offset; // OFFSET ADJUST
    ADC1_INIT.OUTMODE = OUT_EN | OUT_INVERT_DIS | OUT_CODE_2S_COMP; // OUTPUT ENABLE, NOT INVERT, 2's complement
    ADC1_INIT.LVDSCURR = LVDS_CURRENT_MAX; // LVDS CURRENT 3.5MA 
    ADC1_INIT.DCOPHASE = DCO_CLK_INV_DIS | CROX_DIS; // DCO CLOCK NOT INVERT, CROX DISABLE
    ADC1_INIT.DCODELAY = (DCO_DELAY_EN) | (adc1_dcodelay & 0x1F); // DCO DELAY ENABLE, delay = (3100 ps �� register value/31 +100)
    ADC1_INIT.INSPAN = INPUT_SPAN_208VPP; // INPUT SPAN 2.087 Vp-p
    ADC1_INIT.SYNC_CTL = SYNC_DISABLE; // SYNC DISABLE
    ADC1_INIT.TRANSFER = START_TRAN; // START TRANSFER
}

void AD9643_INIT_WRITE()
{
	AD9643_Wirte_Data(CONFIG_REG,ADC1_INIT.CONFIG);
    AD9643_Wirte_Data(CHINDEX_REG,ADC1_INIT.CHINDEX);
    AD9643_Wirte_Data(TRANSFER_REG,ADC1_INIT.TRANSFER);
//    //Wait FOR RST
//    delay_ms(500);
    //START WRITE REG BUFFER
    AD9643_Wirte_Data(CHINDEX_REG,ADC1_INIT.CHINDEX);
    AD9643_Wirte_Data(POWERMODE_REG,ADC1_INIT.POWERMODE);
    AD9643_Wirte_Data(GLOBALCLK_REG,ADC1_INIT.GLOBALCLK);
    AD9643_Wirte_Data(CLKDIV_REG,ADC1_INIT.CLKDIV);
    AD9643_Wirte_Data(TESTMODE_REG,ADC1_INIT.TESTMODE);
    AD9643_Wirte_Data(OFFSETADJ_REG,adc1_offset);
    AD9643_Wirte_Data(OUTMODE_REG,ADC1_INIT.OUTMODE);
    AD9643_Wirte_Data(LVDSCURR_REG,ADC1_INIT.LVDSCURR);
    AD9643_Wirte_Data(DCOPHASE_REG,ADC1_INIT.DCOPHASE);
    AD9643_Wirte_Data(DCODELAY_REG,ADC1_INIT.DCODELAY);
    AD9643_Wirte_Data(INSPAN_REG,ADC1_INIT.INSPAN);
    AD9643_Wirte_Data(SYNC_CTL_REG,ADC1_INIT.SYNC_CTL);
    //WRITE REG TO ADC
    AD9643_Wirte_Data(TRANSFER_REG,ADC1_INIT.TRANSFER);
}
