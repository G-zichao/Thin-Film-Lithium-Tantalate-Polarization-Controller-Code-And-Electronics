#ifndef __AD9643_H_
#define __AD9643_H_
// according to AD9643 datasheet & AN-877
// for write 1 bit rw=0 w0=w1=0
#include "stdint.h"
/*AD9643 register*/
#define CONFIG_REG 0X00
#define CHINDEX_REG 0X05
#define TRANSFER_REG 0XFF
#define POWERMODE_REG 0X08
#define GLOBALCLK_REG 0X09
#define CLKDIV_REG 0X0B
#define TESTMODE_REG 0X0D
#define OFFSETADJ_REG 0X10
#define OUTMODE_REG 0X14
#define LVDSCURR_REG 0X15
#define DCOPHASE_REG 0X16
#define DCODELAY_REG 0X17
#define INSPAN_REG 0X18
#define SYNC_CTL_REG 0X3A



/*AD9643 register map*/
typedef enum {//0x00h
    //BIT6 
    LSB_MODE = 0X5A,//LSB first
    MSB_MODE = 0X18,//MSB first
    //BIT5
    SOFT_RST = 0X3C,//Soft Reset
} AD9643_CONFIG_REG;

//Channel Index and Transfer Registers
typedef enum {//0x05h
    ONLY_CHA_MODE = 0X01,
    ONLY_CHB_MODE = 0X02,
    CHA_CHB_MODE = 0X03,
} AD9643_CHINDEX_REG;

typedef enum {//0xFFh
    START_TRAN = 0X01,
} AD9643_TRANSFER_REG;

//ADC Functions
typedef enum {//0x08h
    //BIT5
    EX_PD_EN = 0X00, //USE THIS MODE;DONT USE EXTERNAL POWER DOWN PIN
    EX_ST_EN = 0X20,
    //BIT1:0
    NORMAL_OPERAT = 0X00,
    FULL_POWER_DOWN = 0X01,
} AD9643_POWERMODE_REG;

typedef enum {//0x09h
    DC_STABILIZER_EN = 0X01,
} AD9643_GLOBALCLK_REG;

typedef enum {//0x0Bh
    //BIT5:3
    CLK_PHASE_ADJ_0 = 0X00,
    CLK_PHASE_ADJ_1 = 0X08,//1 input clock cycle
    CLK_PHASE_ADJ_2 = 0X10,//2 input clock cycle
    CLK_PHASE_ADJ_3 = 0X18,//3 input clock cycle
    CLK_PHASE_ADJ_4 = 0X20,//4 input clock cycle
    CLK_PHASE_ADJ_5 = 0X28,//5 input clock cycle
    CLK_PHASE_ADJ_6 = 0X30,//6 input clock cycle
    CLK_PHASE_ADJ_7 = 0X38,//7 input clock cycle
    //BIT2:0
    CLK_DIV_1 = 0X00,//div 1
    CLK_DIV_2 = 0X01,//div 2
    CLK_DIV_3 = 0X02,//div 3
    CLK_DIV_4 = 0X03,//div 4
    CLK_DIV_5 = 0X04,//div 5
    CLK_DIV_6 = 0X05,//div 6
    CLK_DIV_7 = 0X06,//div 7
    CLK_DIV_8 = 0X07,//div 8
} AD9643_CLKDIV_REG;

typedef enum {//0x0Dh
    TEST_OFF = 0X00,
    TEST_RAMP = 0X0F,//Ramp
} AD9643_TESTMODE_REG;

//typedef enum {//0x10h
    // BIT5:0 Offset adjust in LSBs from +31 to 鈭�32 (twos complement format)
//} AD9643_OFFSETADJ_REG;

typedef enum {//0x14h
    //BIT 4
    OUT_EN = 0X00,
    OUT_DIS = 0X10,//output disable
    //BIT 2
    OUT_INVERT_DIS = 0X00,//output not inverted
    //BIT 1:0
    OUT_CODE_OF_BINARY = 0X00,//= offset binary
    OUT_CODE_2S_COMP = 0X01,//2's complement
    OUT_CODE_GRAY = 0X02,//Gray code
} AD9643_OUTMODE_REG;

typedef enum {//0x15h
    LVDS_CURRENT_MAX = 0X01,
    LVDS_CURRENT_MID = 0X04,
    LVDS_CURRENT_MIN = 0X07,
} AD9643_LVDSCURR_REG;

typedef enum {//0x16h
    //BIT 7
    DCO_CLK_INV_DIS = 0X00,//DCO clock not inverted
    DCO_CLK_INV_EN = 0X80,//DCO clock inverted
    //BIT 5
    CROX_DIS = 0X00,
} AD9643_DCOPHASE_REG;

typedef enum {//0x17h
    DCO_DELAY_EN = 0X80,
    DCO_DELAY_DIS = 0X00,
    //BIT4:0
    //DCO clock delay
    // [delay = (3100 ps 脳 register value/31 +100)]
    // 00000 = 100 ps
    // 00001 = 200 ps
} AD9643_DCODELAY_ADJ_REG;

typedef enum {//0x18h
    //BIT 4:0 adjustment in 0.022 V steps.
    INPUT_SPAN_104VPP = 0X10,//1.083 Vp-p
    INPUT_SPAN_175VPP = 0X00,//1.750 Vp-p
    INPUT_SPAN_208VPP = 0X0F,//2.087 Vp-p
} AD9643_INSPAN_REG;

typedef enum {//0x3Ah
// BIT0 鈥� Main Sync Buffer Enable
    // BIT1 鈥� Clock Divider Sync Enable
    // BIT2 鈥� Clock Divider Next Sync Only
    SYNC_DISABLE                   = 0x00, // Bit0=0, 涓嶅惎鐢ㄥ悓姝ワ紙鐪佺數锛�
    SYNC_MAIN_ENABLE                = 0x01, // Bit0=1, 鍚敤涓诲悓姝ュ姛鑳斤紝浣嗘湭鍚敤Clock Divider鍚屾
    SYNC_CONTINUOUS                 = 0x03, // Bit0=1 + Bit1=1, 杩炵画鍚屾妯″紡
    SYNC_NEXT_PULSE_ONLY            = 0x07, // Bit0=1 + Bit1=1 + Bit2=1, 鍙悓姝ョ涓�涓剦鍐诧紝涔嬪悗Bit1鑷姩娓呴浂
} AD9643_SYNC_CTL_REG;

/*AD9643 register struct*/
typedef struct 
{
    AD9643_CONFIG_REG CONFIG;
    AD9643_CHINDEX_REG CHINDEX;
    AD9643_TRANSFER_REG TRANSFER;
    AD9643_POWERMODE_REG POWERMODE;
    AD9643_GLOBALCLK_REG GLOBALCLK;
    AD9643_CLKDIV_REG CLKDIV;
    AD9643_TESTMODE_REG TESTMODE;
    //AD9643_OFFSETADJ_REG OFFSETADJ;
    AD9643_OUTMODE_REG OUTMODE;
    AD9643_LVDSCURR_REG LVDSCURR;
    AD9643_DCOPHASE_REG DCOPHASE;
    AD9643_DCODELAY_ADJ_REG DCODELAY;
    AD9643_INSPAN_REG INSPAN;
    AD9643_SYNC_CTL_REG SYNC_CTL;
    /* data */
}AD9643_REGS;

void AD9643_io_init();
void AD9643_Wirte_Data(uint16_t ADDR,uint8_t Data);
void AD9643_INIT();
void AD9643_INIT_WRITE();
#endif

