/*
Description :
The application is composed of three sections :

- System Initialization - Initializes GPIO, I2C and LOG structures,
     sets INT pins as input and CS pin as output.
- Application Initialization - Initialization driver enable's - I2C, set default configuration start write log.
- Application Task - (code snippet) This is a example which demonstrates the use of Pressure Click board.
     Measured pressure and temperature data from the LPS331AP sensor on Pressure click board.
     Results are being sent to the Usart Terminal where you can track their changes.
     All data logs write on usb uart changes for every 3 sec.

*/

#include "Click_Pressure_types.h"
#include "Click_Pressure_config.h"
#include <stdbool.h>

float pressure;
float temperature;
char logText[ 50 ];
char logText1[ 50 ];
char logText2[ 50 ];
char degCel[ 4 ];
int timer_cnt = 0;
bool freq_read_done = false;
unsigned long cnt, freq, old_freq;
char *txt;
unsigned long freq_y = 0;
float zracenje = 0;
char uart_rd;


void interrupt() {
  if (TMR1IF_bit) {                     // Test Timer1 interrupt flag        62500
    if(timer_cnt == 16){                 // When 2 second time elapsed
      freq = cnt;                       // Store result in freq
      cnt = 0;                          // Reset counter
      timer_cnt = 0;                    // Reset timer_cnt
      freq_read_done = true;
    }
    else
      timer_cnt++;                      // Increment timer_cnt if not elapsed 1 second

    TMR1H = 0x0B;                       // First write higher byte to TMR1
    TMR1L = 0xDC;                       // Write lower byte to TMR1
    TMR1IF_bit = 0;                     // Clear Timer1 interrupt flag
  }
  if(INT0IF_bit){                       // Test RB0/INT interrupt flag
    cnt++;                              // Count interrupts on RB0/INT pin
    INT0IF_bit = 0;                     // Clear RB0/INT interrupt flag
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

    ANCON0 = 0;                           // Configure all port pins as digital
    ANCON1 = 0;
    ANCON2 = 0;

    TMR1H = 0x0B;                         // First write higher byte to TMR1       S1 1 S023 0
    TMR1L = 0xDC;                         // Write lower byte to TMR1
    T1CON = 0x35;
    TRISB0_bit = 1;                        // Timer1 settings (use Fosc/4 as input and prescaler 1/8)
    TMR1IE_bit = 1;                       // Enable Timer1 overflow interrupt
    INTEDG0_bit = 1;                      // Interrupt on RB0/INT0 pin is edge triggered, setting it on rising edge
    INTCON = 0xD0;
    Delay_100ms();
}

void applicationInit()
{
    pressure_i2cDriverInit( (T_PRESSURE_P)&_MIKROBUS2_GPIO, (T_PRESSURE_P)&_MIKROBUS2_I2C, _PRESSURE_I2C_ADDRESS_1 );
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
    if (UART1_Data_Ready()) {      // Ako su primljeni podaci
      uart_rd = UART1_Read();
      if(uart_rd == 'T'){
        LATH = 0xFF;
      }
      else if(uart_rd == 'F'){
        LATH = 0x00;
      }
    }




    while(freq_read_done == false);
      GIE_bit = 0;                      // Disable interrupts
      freq_read_done = false;
      freq = freq >> 1;                 // Doubling number of captured edges because sampling period is 2s
      //freq_y = freq;
      zracenje = (freq+8)/9;
                // Convert freq (long integer number) to a string
      FloatToStr( zracenje, logText2 );
      sprintf(txt,"%s %s %s \r", logText, logText1, logText2 );
      UART1_Write_Text(txt);
      UART1_Write('\n');

      old_freq  = freq;
      GIE_bit   = 1;

      //Delay_1sec();



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