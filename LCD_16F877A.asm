;Author: DarshanaAriyarathna || darshana.uop@gmail.com || +94774901245
processor	16f84a			;Initialize the processor


#include "p16f877a.inc"

; CONFIG
; __config 0xFF3A
 __CONFIG _FOSC_HS & _WDTE_OFF & _PWRTE_OFF & _BOREN_OFF & _LVP_OFF & _CPD_OFF & _WRT_OFF & _CP_OFF



org	0x00;
    TIMER1  EQU	0x20
    TIMER2  EQU	0x21
    DISP    EQU	0x22
GOTO	Main
;org	0x04			    ;origin vector of interrupt
;GOTO	READ

Main:
    CALL    INITIALIZE_IC
    CALL    INITIALIZE_LCD
    
    CALL    writeOnDisp
   
    GOTO	Main

    ;______________________________________
    
    
    ;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    ;subroutings_for_INITIALIZE_LCD
    INITIALIZE_LCD
	CALL    instructionMode
	CALL    setFunctions
	CALL    setDisplayOnOff
	CALL    displayClear
	CALL    setEntryModule
	CALL	set_CGRAM_address
	CALL	set_DDRAM_address_to_line1
    RETURN
    ;______________________________________
    
    instructionMode
	    MOVLW   b'000'
            MOVWF   PORTC
	    CALL    ENABLE_PULSE
    RETURN
    ;______________________________________
    dataSendMode
	    ;MOVLW   b'11111111'
	    ;MOVWF   PORTD

            ;MOVLW   b'00001'
            ;MOVWF   PORTC
	    BSF	    PORTC,0
	    ;CALL    ENABLE_PULSE
    RETURN
    ;______________________________________
    
    setFunctions
    	CALL    instructionMode
	MOVWF   PORTC
	MOVLW   b'00111000'
	;+----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+
	;| bit7	    | bit6	| bit5	    | bit4	| bit3	    | bit2	| bit1	    | bit0	|
	;+----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+
	;|	0   |	0   	|	1   |   1	|0=1 Line   |0=5x8 Dots |	x   |	x   	|
	;|	    |	    	|	    |	    	|1=2 Line   |1=5x11 Dots|	x   |	x   	|
	;+----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+  
	MOVWF   PORTD
	CALL    ENABLE_PULSE
    RETURN
    ;______________________________________
    setDisplayOnOff
	CALL    instructionMode
	MOVLW   b'00001111'
	;+----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+
	;| bit7	    | bit6      | bit5	    | bit4	| bit3	    | bit2	| bit1	    | bit0      |
	;+----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+
	;|	0   |	0   	|	0   |	0   	|	1   |0=DispOff  |0=CurserOff|0=BlinkOff |
	;|	    |	    	|	    |	    	|	    |1=DispOn   |1=CurserOn |1=BlinkOn  |
	;+----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+
	MOVWF   PORTD
	CALL    ENABLE_PULSE
    RETURN
    ;______________________________________
    displayClear
    	CALL    instructionMode
	MOVLW   b'00000001'
	;+----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+
	;| bit7	    | bit6	| bit5	    | bit4      | bit3	    | bit2      | bit1	    | bit0	|
	;+----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+
	;|	0   |	0	|	0   |	0	|	0   |   0	|	0   |   1	|
	;|	    |		|	    |		|	    |		|	    |		|
	;+----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+
	MOVWF   PORTD
	CALL    ENABLE_PULSE
	CALL	set_DDRAM_address_to_line1
    RETURN
    ;______________________________________
    setEntryModule
       	CALL	instructionMode
	MOVLW   b'00000110'
	;+----------+-----------+-----------+-----------+-----------+-----------+-----------+---------------+
	;| bit7	    | bit6	| bit5	    | bit4      | bit3	    | bit2      | bit1	    | bit0	    |
	;+----------+-----------+-----------+-----------+-----------+-----------+-----------+---------------+
	;|	0   |   0	|	0   |   0	|	0   |   1	|0=Decrement|0=EntireShift  |
	;|	    |		|	    |		|	    |		|   Mode    |   off	    |
	;|	    |		|	    |		|	    |	        |1=Increment|1=EntireShif   |
	;|	    |		|	    |		|	    |		|   Mode    |   on	    |
	;+----------+-----------+-----------+-----------+-----------+-----------+-----------+---------------+
	MOVWF   PORTD
	CALL    ENABLE_PULSE
    RETURN
    
    ;______________________________________
    set_CGRAM_address
    	CALL	instructionMode
	MOVLW   b'01000000'	
	;SET CGRAM ADDRESS
	;+----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+
	;| bit7	    | bit6	| bit5	    |bit4	| bit3	    | bit2	| bit1	    | bit0	|
	;+----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+
	;|	0   |	1	|	AC5 |	AC4	|	AC3 |	AC2	|	AC1 |	AC0	|
	;+----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+
	
	MOVWF   PORTD
	CALL    ENABLE_PULSE
    RETURN
    
    ;______________________________________
    set_DDRAM_address_to_line1
    	CALL	instructionMode
	MOVLW   b'10000000'	;SET DDRAM ADDRESS
    
	;+----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+
	;| bit7	    | bit6	| bit5	    | bit4	| bit3	    | bit2	| bit1	    | bit0	|
	;+----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+
	;|	1   |	AC6	|	AC5 |	AC4	|	AC3 |	AC2	|	AC1 |	AC0	|
	;+----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+
	    ;DDRAM ADDRESS 1ST Line:00H to 27H
	    ;DDRAM ADDRESS 2ND Line:40H to 67H

	MOVWF   PORTD
	CALL    ENABLE_PULSE
	CALL	dataSendMode
    RETURN
    ;______________________________________
    set_DDRAM_address_to_line2
    	CALL	instructionMode
	MOVLW   b'11000000'
	MOVWF   PORTD
	CALL    ENABLE_PULSE
	CALL	dataSendMode

    RETURN
    
    ;______________________________________
   
    ;______________________________________
    
   
    
    ;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    ;subroutings_for_INITIALIZE_IC
    INITIALIZE_IC
	CALL	GO_BANK_1
	    MOVLW   b'000'
	    MOVWF   TRISC
	    MOVLW   b'00000000'
	    MOVWF   TRISD
	    CLRF    TRISB
	CALL	GO_BANK_0
	    MOVLW   b'000'
	    MOVWF   PORTC
	    MOVLW   b'00000000'
	    MOVWF   PORTD

    RETURN
    
    ;_______________________________________
    
    GO_BANK_0
	BCF	    STATUS,5
        BCF	    STATUS,6
    RETURN
    
    GO_BANK_1
	BSF	    STATUS,5
        BCF	    STATUS,6
    RETURN
    
    GO_BANK_2
	BCF	    STATUS,5
        BSF	    STATUS,6
    RETURN
    
    GO_BANK_3
	BSF	    STATUS,5
        BSF	    STATUS,6
    RETURN
    
    ;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    ;_______________________________________
    
    ;_______________________________________
    
    ENABLE_PULSE
	BSF	    PORTC,2
	CALL    DELAY_50_MS
	BCF	    PORTC,2
	CALL    DELAY_50_MS
    RETURN
    ;_______________________________________
    DELAY_50_MS
	DECFSZ	TIMER1,1
	GOTO	DELAY_50_MS
	DECFSZ	TIMER2,1
	GOTO	DELAY_50_MS
	;MOVLW   b'11111111'
	;movwf   TIMER1
    RETURN
    
    ;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    ;subroutings_for_PRINT_IN_LCD
    writeOnDisp
	    BSF	PORTB,7
	    BCF	PORTB,6
	CALL	displayClear
	    MOVLW	"D"	
	    CALL    PRINT_CHAR
	    ;CALL	WAIT
	    MOVLW	"A"
	    ;CALL	WAIT
	    CALL    PRINT_CHAR
	    MOVLW	"R"
	    ;PALL	WAIT
	    CALL    PRINT_CHAR
	    MOVLW	"S"
	    ;CALL	WAIT
	    CALL    PRINT_CHAR
	    MOVLW	"H"
	    ;CALL	WAIT
	    CALL    PRINT_CHAR
	    ;CALL	WAIT
	    MOVLW	"A"	
	    CALL    PRINT_CHAR
	    ;CALL	WAIT
	    MOVLW	"N"
	    ;CALL	WAIT
	    CALL    PRINT_CHAR
	    MOVLW	"A"
	    ;CALL	WAIT
	    CALL    PRINT_CHAR
	    CALL	set_DDRAM_address_to_line2
	    MOVLW	"A"
	    ;CALL	WAIT
	    CALL    PRINT_CHAR
	    MOVLW	"r"
	    ;CALL	WAIT
	    CALL    PRINT_CHAR
	    MOVLW	"i"
	    ;CALL	WAIT
	    CALL    PRINT_CHAR
	    MOVLW	"y"
	    ;CALL	WAIT
	    CALL    PRINT_CHAR
	    MOVLW	"a"
	    ;CALL	WAIT
	    CALL    PRINT_CHAR
	    MOVLW	"r"
	    ;CALL	WAIT
	    CALL    PRINT_CHAR
	    MOVLW	"a"
	    ;CALL	WAIT
	    CALL    PRINT_CHAR
	    MOVLW	"t"
	    ;CALL	WAIT
	    CALL    PRINT_CHAR
	    MOVLW	"h"
	    ;CALL	WAIT
	    CALL    PRINT_CHAR
	    MOVLW	"n"
	    ;CALL	WAIT
	    CALL    PRINT_CHAR
	    MOVLW	"a"
	    ;CALL	WAIT
	    CALL    PRINT_CHAR
	    MOVLW	"."
	    ;CALL	WAIT
	    CALL    PRINT_CHAR
	
	    BCF	    PORTB,7
	    BSF	    PORTB,6
	
    RETURN
    
    PRINT_CHAR
	MOVWF  PORTD
	CALL    ENABLE_PULSE
    RETURN
    
    ;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
    
    WAIT
	DECFSZ	TIMER1,1
	GOTO	WAIT
	DECFSZ	TIMER2,1
	GOTO	WAIT
    RETURN
    
END

