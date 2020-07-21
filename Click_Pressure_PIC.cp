#line 1 "C:/Users/dime-/OneDrive/Desktop/kresa python 16.7/temp press hz final mikroc/Click_Pressure_PIC.c"
#line 1 "c:/users/dime-/onedrive/desktop/kresa python 16.7/temp press hz final mikroc/click_pressure_types.h"
#line 1 "c:/users/public/documents/mikroelektronika/mikroc pro for pic/include/stdint.h"




typedef signed char int8_t;
typedef signed int int16_t;
typedef signed long int int32_t;


typedef unsigned char uint8_t;
typedef unsigned int uint16_t;
typedef unsigned long int uint32_t;


typedef signed char int_least8_t;
typedef signed int int_least16_t;
typedef signed long int int_least32_t;


typedef unsigned char uint_least8_t;
typedef unsigned int uint_least16_t;
typedef unsigned long int uint_least32_t;



typedef signed char int_fast8_t;
typedef signed int int_fast16_t;
typedef signed long int int_fast32_t;


typedef unsigned char uint_fast8_t;
typedef unsigned int uint_fast16_t;
typedef unsigned long int uint_fast32_t;


typedef signed int intptr_t;
typedef unsigned int uintptr_t;


typedef signed long int intmax_t;
typedef unsigned long int uintmax_t;
#line 1 "c:/users/dime-/onedrive/desktop/kresa python 16.7/temp press hz final mikroc/click_pressure_config.h"
#line 1 "c:/users/dime-/onedrive/desktop/kresa python 16.7/temp press hz final mikroc/click_pressure_types.h"
#line 4 "c:/users/dime-/onedrive/desktop/kresa python 16.7/temp press hz final mikroc/click_pressure_config.h"
const uint32_t _PRESSURE_I2C_CFG[ 1 ] =
{
 100000
};
#line 1 "c:/users/public/documents/mikroelektronika/mikroc pro for pic/include/stdbool.h"



 typedef char _Bool;
#line 19 "C:/Users/dime-/OneDrive/Desktop/kresa python 16.7/temp press hz final mikroc/Click_Pressure_PIC.c"
float pressure;
float temperature;
char logText[ 50 ];
char logText1[ 50 ];
char logText2[ 50 ];
char degCel[ 4 ];
int timer_cnt = 0;
 _Bool  freq_read_done =  0 ;
unsigned long cnt, freq, old_freq;
char *txt;
unsigned long freq_y = 0;
float zracenje = 0;
char uart_rd;


void interrupt() {
 if (TMR1IF_bit) {
 if(timer_cnt == 16){
 freq = cnt;
 cnt = 0;
 timer_cnt = 0;
 freq_read_done =  1 ;
 }
 else
 timer_cnt++;

 TMR1H = 0x0B;
 TMR1L = 0xDC;
 TMR1IF_bit = 0;
 }
 if(INT0IF_bit){
 cnt++;
 INT0IF_bit = 0;
 }
}

void systemInit()
{
 mikrobus_gpioInit( _MIKROBUS2, _MIKROBUS_INT_PIN, _GPIO_INPUT );
 mikrobus_gpioInit( _MIKROBUS2, _MIKROBUS_CS_PIN, _GPIO_OUTPUT );

 mikrobus_gpioInit( _MIKROBUS1, _MIKROBUS_PWM_PIN, _GPIO_OUTPUT );
 mikrobus_gpioInit( _MIKROBUS1, _MIKROBUS_AN_PIN, _GPIO_OUTPUT );
 mikrobus_gpioInit( _MIKROBUS1, _MIKROBUS_CS_PIN, _GPIO_OUTPUT );
 mikrobus_gpioInit( _MIKROBUS1, _MIKROBUS_RST_PIN, _GPIO_OUTPUT );

 LATC1_bit = 0;
 LATA0_bit = 1;
 LATC0_bit = 0;
 LATE0_bit = 0;

 TRISH = 0;

 mikrobus_i2cInit( _MIKROBUS2, &_PRESSURE_I2C_CFG[0] );

 mikrobus_logInit( _LOG_USBUART, 9600 );

 ANCON0 = 0;
 ANCON1 = 0;
 ANCON2 = 0;

 TMR1H = 0x0B;
 TMR1L = 0xDC;
 T1CON = 0x35;
 TRISB0_bit = 1;
 TMR1IE_bit = 1;
 INTEDG0_bit = 1;
 INTCON = 0xD0;
 Delay_100ms();
}

void applicationInit()
{
 pressure_i2cDriverInit( ( const uint8_t* )&_MIKROBUS2_GPIO, ( const uint8_t* )&_MIKROBUS2_I2C, _PRESSURE_I2C_ADDRESS_1 );
 Delay_100ms();

 degCel[ 0 ] = 32;
 degCel[ 1 ] = 176;
 degCel[ 2 ] = 67;
 degCel[ 3 ] = 0;

 Delay_100ms();
}

void applicationTask()
{
 pressure = pressure_getPressure();
 FloatToStr( pressure, logText );
 Delay_10ms();
 temperature = pressure_getTemperature();
 FloatToStr( temperature, logText1 );
 Delay_10ms();
 if (UART1_Data_Ready()) {
 uart_rd = UART1_Read();
 if(uart_rd == 'T'){
 LATH = 0xFF;
 }
 else if(uart_rd == 'F'){
 LATH = 0x00;
 }
 }




 while(freq_read_done ==  0 );
 GIE_bit = 0;
 freq_read_done =  0 ;
 freq = freq >> 1;

 zracenje = (freq+8)/9;

 FloatToStr( zracenje, logText2 );
 sprintf(txt,"%s %s %s \r", logText, logText1, logText2 );
 UART1_Write_Text(txt);
 UART1_Write('\n');

 old_freq = freq;
 GIE_bit = 1;





}

void main()
{
 systemInit();
 applicationInit();

 while (1)
 {
 applicationTask();
 }
}
