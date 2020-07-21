
_interrupt:

;Click_Pressure_PIC.c,34 :: 		void interrupt() {
;Click_Pressure_PIC.c,35 :: 		if (TMR1IF_bit) {                     // Test Timer1 interrupt flag        62500
	BTFSS       TMR1IF_bit+0, BitPos(TMR1IF_bit+0) 
	GOTO        L_interrupt0
;Click_Pressure_PIC.c,36 :: 		if(timer_cnt == 16){                 // When 2 second time elapsed
	MOVLW       0
	XORWF       _timer_cnt+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt14
	MOVLW       16
	XORWF       _timer_cnt+0, 0 
L__interrupt14:
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt1
;Click_Pressure_PIC.c,37 :: 		freq = cnt;                       // Store result in freq
	MOVF        _cnt+0, 0 
	MOVWF       _freq+0 
	MOVF        _cnt+1, 0 
	MOVWF       _freq+1 
	MOVF        _cnt+2, 0 
	MOVWF       _freq+2 
	MOVF        _cnt+3, 0 
	MOVWF       _freq+3 
;Click_Pressure_PIC.c,38 :: 		cnt = 0;                          // Reset counter
	CLRF        _cnt+0 
	CLRF        _cnt+1 
	CLRF        _cnt+2 
	CLRF        _cnt+3 
;Click_Pressure_PIC.c,39 :: 		timer_cnt = 0;                    // Reset timer_cnt
	CLRF        _timer_cnt+0 
	CLRF        _timer_cnt+1 
;Click_Pressure_PIC.c,40 :: 		freq_read_done = true;
	MOVLW       1
	MOVWF       _freq_read_done+0 
;Click_Pressure_PIC.c,41 :: 		}
	GOTO        L_interrupt2
L_interrupt1:
;Click_Pressure_PIC.c,43 :: 		timer_cnt++;                      // Increment timer_cnt if not elapsed 1 second
	INFSNZ      _timer_cnt+0, 1 
	INCF        _timer_cnt+1, 1 
L_interrupt2:
;Click_Pressure_PIC.c,45 :: 		TMR1H = 0x0B;                       // First write higher byte to TMR1
	MOVLW       11
	MOVWF       TMR1H+0 
;Click_Pressure_PIC.c,46 :: 		TMR1L = 0xDC;                       // Write lower byte to TMR1
	MOVLW       220
	MOVWF       TMR1L+0 
;Click_Pressure_PIC.c,47 :: 		TMR1IF_bit = 0;                     // Clear Timer1 interrupt flag
	BCF         TMR1IF_bit+0, BitPos(TMR1IF_bit+0) 
;Click_Pressure_PIC.c,48 :: 		}
L_interrupt0:
;Click_Pressure_PIC.c,49 :: 		if(INT0IF_bit){                       // Test RB0/INT interrupt flag
	BTFSS       INT0IF_bit+0, BitPos(INT0IF_bit+0) 
	GOTO        L_interrupt3
;Click_Pressure_PIC.c,50 :: 		cnt++;                              // Count interrupts on RB0/INT pin
	MOVLW       1
	ADDWF       _cnt+0, 1 
	MOVLW       0
	ADDWFC      _cnt+1, 1 
	ADDWFC      _cnt+2, 1 
	ADDWFC      _cnt+3, 1 
;Click_Pressure_PIC.c,51 :: 		INT0IF_bit = 0;                     // Clear RB0/INT interrupt flag
	BCF         INT0IF_bit+0, BitPos(INT0IF_bit+0) 
;Click_Pressure_PIC.c,52 :: 		}
L_interrupt3:
;Click_Pressure_PIC.c,53 :: 		}
L_end_interrupt:
L__interrupt13:
	RETFIE      1
; end of _interrupt

_systemInit:

;Click_Pressure_PIC.c,55 :: 		void systemInit()
;Click_Pressure_PIC.c,57 :: 		mikrobus_gpioInit( _MIKROBUS2, _MIKROBUS_INT_PIN, _GPIO_INPUT );
	MOVLW       1
	MOVWF       FARG_mikrobus_gpioInit_bus+0 
	MOVLW       7
	MOVWF       FARG_mikrobus_gpioInit_pin+0 
	MOVLW       1
	MOVWF       FARG_mikrobus_gpioInit_direction+0 
	CALL        _mikrobus_gpioInit+0, 0
;Click_Pressure_PIC.c,58 :: 		mikrobus_gpioInit( _MIKROBUS2, _MIKROBUS_CS_PIN, _GPIO_OUTPUT );
	MOVLW       1
	MOVWF       FARG_mikrobus_gpioInit_bus+0 
	MOVLW       2
	MOVWF       FARG_mikrobus_gpioInit_pin+0 
	CLRF        FARG_mikrobus_gpioInit_direction+0 
	CALL        _mikrobus_gpioInit+0, 0
;Click_Pressure_PIC.c,60 :: 		mikrobus_gpioInit( _MIKROBUS1, _MIKROBUS_PWM_PIN, _GPIO_OUTPUT );
	CLRF        FARG_mikrobus_gpioInit_bus+0 
	MOVLW       6
	MOVWF       FARG_mikrobus_gpioInit_pin+0 
	CLRF        FARG_mikrobus_gpioInit_direction+0 
	CALL        _mikrobus_gpioInit+0, 0
;Click_Pressure_PIC.c,61 :: 		mikrobus_gpioInit( _MIKROBUS1, _MIKROBUS_AN_PIN, _GPIO_OUTPUT );
	CLRF        FARG_mikrobus_gpioInit_bus+0 
	CLRF        FARG_mikrobus_gpioInit_pin+0 
	CLRF        FARG_mikrobus_gpioInit_direction+0 
	CALL        _mikrobus_gpioInit+0, 0
;Click_Pressure_PIC.c,62 :: 		mikrobus_gpioInit( _MIKROBUS1, _MIKROBUS_CS_PIN, _GPIO_OUTPUT );
	CLRF        FARG_mikrobus_gpioInit_bus+0 
	MOVLW       2
	MOVWF       FARG_mikrobus_gpioInit_pin+0 
	CLRF        FARG_mikrobus_gpioInit_direction+0 
	CALL        _mikrobus_gpioInit+0, 0
;Click_Pressure_PIC.c,63 :: 		mikrobus_gpioInit( _MIKROBUS1, _MIKROBUS_RST_PIN, _GPIO_OUTPUT );
	CLRF        FARG_mikrobus_gpioInit_bus+0 
	MOVLW       1
	MOVWF       FARG_mikrobus_gpioInit_pin+0 
	CLRF        FARG_mikrobus_gpioInit_direction+0 
	CALL        _mikrobus_gpioInit+0, 0
;Click_Pressure_PIC.c,65 :: 		LATC1_bit = 0;
	BCF         LATC1_bit+0, BitPos(LATC1_bit+0) 
;Click_Pressure_PIC.c,66 :: 		LATA0_bit = 1;
	BSF         LATA0_bit+0, BitPos(LATA0_bit+0) 
;Click_Pressure_PIC.c,67 :: 		LATC0_bit = 0;
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
;Click_Pressure_PIC.c,68 :: 		LATE0_bit = 0;
	BCF         LATE0_bit+0, BitPos(LATE0_bit+0) 
;Click_Pressure_PIC.c,70 :: 		TRISH = 0;
	CLRF        TRISH+0 
;Click_Pressure_PIC.c,72 :: 		mikrobus_i2cInit( _MIKROBUS2, &_PRESSURE_I2C_CFG[0] );
	MOVLW       1
	MOVWF       FARG_mikrobus_i2cInit_bus+0 
	MOVLW       __PRESSURE_I2C_CFG+0
	MOVWF       FARG_mikrobus_i2cInit_cfg+0 
	MOVLW       hi_addr(__PRESSURE_I2C_CFG+0)
	MOVWF       FARG_mikrobus_i2cInit_cfg+1 
	MOVLW       higher_addr(__PRESSURE_I2C_CFG+0)
	MOVWF       FARG_mikrobus_i2cInit_cfg+2 
	CALL        _mikrobus_i2cInit+0, 0
;Click_Pressure_PIC.c,74 :: 		mikrobus_logInit( _LOG_USBUART, 9600 );
	MOVLW       16
	MOVWF       FARG_mikrobus_logInit_port+0 
	MOVLW       128
	MOVWF       FARG_mikrobus_logInit_baud+0 
	MOVLW       37
	MOVWF       FARG_mikrobus_logInit_baud+1 
	MOVLW       0
	MOVWF       FARG_mikrobus_logInit_baud+2 
	MOVWF       FARG_mikrobus_logInit_baud+3 
	CALL        _mikrobus_logInit+0, 0
;Click_Pressure_PIC.c,76 :: 		ANCON0 = 0;                           // Configure all port pins as digital
	CLRF        ANCON0+0 
;Click_Pressure_PIC.c,77 :: 		ANCON1 = 0;
	CLRF        ANCON1+0 
;Click_Pressure_PIC.c,78 :: 		ANCON2 = 0;
	CLRF        ANCON2+0 
;Click_Pressure_PIC.c,80 :: 		TMR1H = 0x0B;                         // First write higher byte to TMR1       S1 1 S023 0
	MOVLW       11
	MOVWF       TMR1H+0 
;Click_Pressure_PIC.c,81 :: 		TMR1L = 0xDC;                         // Write lower byte to TMR1
	MOVLW       220
	MOVWF       TMR1L+0 
;Click_Pressure_PIC.c,82 :: 		T1CON = 0x35;
	MOVLW       53
	MOVWF       T1CON+0 
;Click_Pressure_PIC.c,83 :: 		TRISB0_bit = 1;                        // Timer1 settings (use Fosc/4 as input and prescaler 1/8)
	BSF         TRISB0_bit+0, BitPos(TRISB0_bit+0) 
;Click_Pressure_PIC.c,84 :: 		TMR1IE_bit = 1;                       // Enable Timer1 overflow interrupt
	BSF         TMR1IE_bit+0, BitPos(TMR1IE_bit+0) 
;Click_Pressure_PIC.c,85 :: 		INTEDG0_bit = 1;                      // Interrupt on RB0/INT0 pin is edge triggered, setting it on rising edge
	BSF         INTEDG0_bit+0, BitPos(INTEDG0_bit+0) 
;Click_Pressure_PIC.c,86 :: 		INTCON = 0xD0;
	MOVLW       208
	MOVWF       INTCON+0 
;Click_Pressure_PIC.c,87 :: 		Delay_100ms();
	CALL        _Delay_100ms+0, 0
;Click_Pressure_PIC.c,88 :: 		}
L_end_systemInit:
	RETURN      0
; end of _systemInit

_applicationInit:

;Click_Pressure_PIC.c,90 :: 		void applicationInit()
;Click_Pressure_PIC.c,92 :: 		pressure_i2cDriverInit( (T_PRESSURE_P)&_MIKROBUS2_GPIO, (T_PRESSURE_P)&_MIKROBUS2_I2C, _PRESSURE_I2C_ADDRESS_1 );
	MOVLW       __MIKROBUS2_GPIO+0
	MOVWF       FARG_pressure_i2cDriverInit_gpioObj+0 
	MOVLW       hi_addr(__MIKROBUS2_GPIO+0)
	MOVWF       FARG_pressure_i2cDriverInit_gpioObj+1 
	MOVLW       higher_addr(__MIKROBUS2_GPIO+0)
	MOVWF       FARG_pressure_i2cDriverInit_gpioObj+2 
	MOVLW       __MIKROBUS2_I2C+0
	MOVWF       FARG_pressure_i2cDriverInit_i2cObj+0 
	MOVLW       hi_addr(__MIKROBUS2_I2C+0)
	MOVWF       FARG_pressure_i2cDriverInit_i2cObj+1 
	MOVLW       higher_addr(__MIKROBUS2_I2C+0)
	MOVWF       FARG_pressure_i2cDriverInit_i2cObj+2 
	MOVLW       93
	MOVWF       FARG_pressure_i2cDriverInit_slave+0 
	CALL        _pressure_i2cDriverInit+0, 0
;Click_Pressure_PIC.c,93 :: 		Delay_100ms();
	CALL        _Delay_100ms+0, 0
;Click_Pressure_PIC.c,95 :: 		degCel[ 0 ] = 32;
	MOVLW       32
	MOVWF       _degCel+0 
;Click_Pressure_PIC.c,96 :: 		degCel[ 1 ] = 176;
	MOVLW       176
	MOVWF       _degCel+1 
;Click_Pressure_PIC.c,97 :: 		degCel[ 2 ] = 67;
	MOVLW       67
	MOVWF       _degCel+2 
;Click_Pressure_PIC.c,98 :: 		degCel[ 3 ] = 0;
	CLRF        _degCel+3 
;Click_Pressure_PIC.c,100 :: 		Delay_100ms();
	CALL        _Delay_100ms+0, 0
;Click_Pressure_PIC.c,101 :: 		}
L_end_applicationInit:
	RETURN      0
; end of _applicationInit

_applicationTask:

;Click_Pressure_PIC.c,103 :: 		void applicationTask()
;Click_Pressure_PIC.c,105 :: 		pressure = pressure_getPressure();
	CALL        _pressure_getPressure+0, 0
	MOVF        R0, 0 
	MOVWF       _pressure+0 
	MOVF        R1, 0 
	MOVWF       _pressure+1 
	MOVF        R2, 0 
	MOVWF       _pressure+2 
	MOVF        R3, 0 
	MOVWF       _pressure+3 
;Click_Pressure_PIC.c,106 :: 		FloatToStr( pressure, logText );
	MOVF        R0, 0 
	MOVWF       FARG_FloatToStr_fnum+0 
	MOVF        R1, 0 
	MOVWF       FARG_FloatToStr_fnum+1 
	MOVF        R2, 0 
	MOVWF       FARG_FloatToStr_fnum+2 
	MOVF        R3, 0 
	MOVWF       FARG_FloatToStr_fnum+3 
	MOVLW       _logText+0
	MOVWF       FARG_FloatToStr_str+0 
	MOVLW       hi_addr(_logText+0)
	MOVWF       FARG_FloatToStr_str+1 
	CALL        _FloatToStr+0, 0
;Click_Pressure_PIC.c,107 :: 		Delay_10ms();
	CALL        _Delay_10ms+0, 0
;Click_Pressure_PIC.c,108 :: 		temperature = pressure_getTemperature();
	CALL        _pressure_getTemperature+0, 0
	MOVF        R0, 0 
	MOVWF       _temperature+0 
	MOVF        R1, 0 
	MOVWF       _temperature+1 
	MOVF        R2, 0 
	MOVWF       _temperature+2 
	MOVF        R3, 0 
	MOVWF       _temperature+3 
;Click_Pressure_PIC.c,109 :: 		FloatToStr( temperature, logText1 );
	MOVF        R0, 0 
	MOVWF       FARG_FloatToStr_fnum+0 
	MOVF        R1, 0 
	MOVWF       FARG_FloatToStr_fnum+1 
	MOVF        R2, 0 
	MOVWF       FARG_FloatToStr_fnum+2 
	MOVF        R3, 0 
	MOVWF       FARG_FloatToStr_fnum+3 
	MOVLW       _logText1+0
	MOVWF       FARG_FloatToStr_str+0 
	MOVLW       hi_addr(_logText1+0)
	MOVWF       FARG_FloatToStr_str+1 
	CALL        _FloatToStr+0, 0
;Click_Pressure_PIC.c,110 :: 		Delay_10ms();
	CALL        _Delay_10ms+0, 0
;Click_Pressure_PIC.c,111 :: 		if (UART1_Data_Ready()) {      // Ako su primljeni podaci
	CALL        _UART1_Data_Ready+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_applicationTask4
;Click_Pressure_PIC.c,112 :: 		uart_rd = UART1_Read();
	CALL        _UART1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _uart_rd+0 
;Click_Pressure_PIC.c,113 :: 		if(uart_rd == 'T'){
	MOVF        R0, 0 
	XORLW       84
	BTFSS       STATUS+0, 2 
	GOTO        L_applicationTask5
;Click_Pressure_PIC.c,114 :: 		LATH = 0xFF;
	MOVLW       255
	MOVWF       LATH+0 
;Click_Pressure_PIC.c,115 :: 		}
	GOTO        L_applicationTask6
L_applicationTask5:
;Click_Pressure_PIC.c,116 :: 		else if(uart_rd == 'F'){
	MOVF        _uart_rd+0, 0 
	XORLW       70
	BTFSS       STATUS+0, 2 
	GOTO        L_applicationTask7
;Click_Pressure_PIC.c,117 :: 		LATH = 0x00;
	CLRF        LATH+0 
;Click_Pressure_PIC.c,118 :: 		}
L_applicationTask7:
L_applicationTask6:
;Click_Pressure_PIC.c,119 :: 		}
L_applicationTask4:
;Click_Pressure_PIC.c,124 :: 		while(freq_read_done == false);
L_applicationTask8:
	MOVF        _freq_read_done+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_applicationTask9
	GOTO        L_applicationTask8
L_applicationTask9:
;Click_Pressure_PIC.c,125 :: 		GIE_bit = 0;                      // Disable interrupts
	BCF         GIE_bit+0, BitPos(GIE_bit+0) 
;Click_Pressure_PIC.c,126 :: 		freq_read_done = false;
	CLRF        _freq_read_done+0 
;Click_Pressure_PIC.c,127 :: 		freq = freq >> 1;                 // Doubling number of captured edges because sampling period is 2s
	MOVF        _freq+0, 0 
	MOVWF       R0 
	MOVF        _freq+1, 0 
	MOVWF       R1 
	MOVF        _freq+2, 0 
	MOVWF       R2 
	MOVF        _freq+3, 0 
	MOVWF       R3 
	RRCF        R3, 1 
	RRCF        R2, 1 
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R3, 7 
	MOVF        R0, 0 
	MOVWF       _freq+0 
	MOVF        R1, 0 
	MOVWF       _freq+1 
	MOVF        R2, 0 
	MOVWF       _freq+2 
	MOVF        R3, 0 
	MOVWF       _freq+3 
;Click_Pressure_PIC.c,129 :: 		zracenje = (freq+8)/9;
	MOVLW       8
	ADDWF       R0, 1 
	MOVLW       0
	ADDWFC      R1, 1 
	ADDWFC      R2, 1 
	ADDWFC      R3, 1 
	MOVLW       9
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Div_32x32_U+0, 0
	CALL        _longword2double+0, 0
	MOVF        R0, 0 
	MOVWF       _zracenje+0 
	MOVF        R1, 0 
	MOVWF       _zracenje+1 
	MOVF        R2, 0 
	MOVWF       _zracenje+2 
	MOVF        R3, 0 
	MOVWF       _zracenje+3 
;Click_Pressure_PIC.c,131 :: 		FloatToStr( zracenje, logText2 );
	MOVF        R0, 0 
	MOVWF       FARG_FloatToStr_fnum+0 
	MOVF        R1, 0 
	MOVWF       FARG_FloatToStr_fnum+1 
	MOVF        R2, 0 
	MOVWF       FARG_FloatToStr_fnum+2 
	MOVF        R3, 0 
	MOVWF       FARG_FloatToStr_fnum+3 
	MOVLW       _logText2+0
	MOVWF       FARG_FloatToStr_str+0 
	MOVLW       hi_addr(_logText2+0)
	MOVWF       FARG_FloatToStr_str+1 
	CALL        _FloatToStr+0, 0
;Click_Pressure_PIC.c,132 :: 		sprintf(txt,"%s %s %s \r", logText, logText1, logText2 );
	MOVF        _txt+0, 0 
	MOVWF       FARG_sprintf_wh+0 
	MOVF        _txt+1, 0 
	MOVWF       FARG_sprintf_wh+1 
	MOVLW       ?lstr_1_Click_Pressure_PIC+0
	MOVWF       FARG_sprintf_f+0 
	MOVLW       hi_addr(?lstr_1_Click_Pressure_PIC+0)
	MOVWF       FARG_sprintf_f+1 
	MOVLW       higher_addr(?lstr_1_Click_Pressure_PIC+0)
	MOVWF       FARG_sprintf_f+2 
	MOVLW       _logText+0
	MOVWF       FARG_sprintf_wh+5 
	MOVLW       hi_addr(_logText+0)
	MOVWF       FARG_sprintf_wh+6 
	MOVLW       _logText1+0
	MOVWF       FARG_sprintf_wh+7 
	MOVLW       hi_addr(_logText1+0)
	MOVWF       FARG_sprintf_wh+8 
	MOVLW       _logText2+0
	MOVWF       FARG_sprintf_wh+9 
	MOVLW       hi_addr(_logText2+0)
	MOVWF       FARG_sprintf_wh+10 
	CALL        _sprintf+0, 0
;Click_Pressure_PIC.c,133 :: 		UART1_Write_Text(txt);
	MOVF        _txt+0, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVF        _txt+1, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Click_Pressure_PIC.c,134 :: 		UART1_Write('\n');
	MOVLW       10
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;Click_Pressure_PIC.c,136 :: 		old_freq  = freq;
	MOVF        _freq+0, 0 
	MOVWF       _old_freq+0 
	MOVF        _freq+1, 0 
	MOVWF       _old_freq+1 
	MOVF        _freq+2, 0 
	MOVWF       _old_freq+2 
	MOVF        _freq+3, 0 
	MOVWF       _old_freq+3 
;Click_Pressure_PIC.c,137 :: 		GIE_bit   = 1;
	BSF         GIE_bit+0, BitPos(GIE_bit+0) 
;Click_Pressure_PIC.c,143 :: 		}
L_end_applicationTask:
	RETURN      0
; end of _applicationTask

_main:

;Click_Pressure_PIC.c,145 :: 		void main()
;Click_Pressure_PIC.c,147 :: 		systemInit();
	CALL        _systemInit+0, 0
;Click_Pressure_PIC.c,148 :: 		applicationInit();
	CALL        _applicationInit+0, 0
;Click_Pressure_PIC.c,150 :: 		while (1)
L_main10:
;Click_Pressure_PIC.c,152 :: 		applicationTask();
	CALL        _applicationTask+0, 0
;Click_Pressure_PIC.c,153 :: 		}
	GOTO        L_main10
;Click_Pressure_PIC.c,154 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
