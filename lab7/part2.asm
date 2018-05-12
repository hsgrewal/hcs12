;----------------------------------------------------
; Export Symbols
; KEEP THIS!!
;----------------------------------------------------
          XDEF      Entry       ; export 'Entry' symbol
          ABSENTRY  Entry       ; for absolute assembly: mark this as application entry point

;----------------------------------------------------
; Derivative-Specific Definitions
; KEEP THIS!!
;----------------------------------------------------
          INCLUDE   'derivative.inc'

;----------------------------------------------------
; Constants Section
; KEEP THIS!!
;----------------------------------------------------
ROM       EQU     $0400
DATA      EQU     $1000
PROG      EQU     $2000

;----------------------------------------------------
; Variable/Data Section
; KEEP THIS!!
;----------------------------------------------------
          ORG     DATA

OUT       FCB     0
CNT       FDB     18750       ; 100ms

;----------------------------------------------------
; Code Section
; KEEP THIS!!
;----------------------------------------------------
          ORG     PROG

; Insert your code following the label "Entry"
Entry:    ; KEEP THIS LABEL!!

          LDS     #PROG

          BSR     INIT
          BSR     OC_INIT

MAIN:
          LDAA    OUT
          STAA    PORTB
          BRA     MAIN

;----------------------------------------------------
; Init Subroutine
;----------------------------------------------------
INIT:
          SEI

          ;******************************************
          ; Enable Discrete LEDs here
          ;******************************************

          BSET    DDRB,$FF

          ;******************************************

          ; Disable 7-Segment Display
          BSET    DDRP,#$0F     ; Set Port P pins 0-3 to output

          BCLR    DDRH,$03      ; Set Port H pins 0-1 to input
          BCLR    PTH,$FF       ; Enable PBs

          ; Enable interrupts on Port H, pin 0 (PB1/DIP1)
          ; Disable interrupts on Port H for other pins
          MOVB	  #$03, PIEH
          MOVB    #$03, PIFH    	; Clear flag for pin 0, set the rest

          CLI                   ; Enable maskable interrupts

          RTS

;----------------------------------------------------
; OC Init Subroutine
;----------------------------------------------------
OC_INIT:
          ;******************************************
          ; Enter OC Init here
          ;******************************************

          SEI                   ; Disable maskable interrupts

          BSET    TIOS, #$02    ; OC1
          BSET    DDRT, #$02    ; PT1 Output

          MOVB    #$80, TSCR1   ; Enable
          MOVB    #$07, TSCR2   ; Divide clock by 128, 5.33 us

          BSET    TIE, #$02     ; Arm interrupts for OC1

          BSET    TCTL2, #$07   ; OL1 = 1, Toggle
          BCLR    TCTL2, #$08   ; OM1 = 0

          MOVB    #$02, TFLG1   ; Clear C1F
          LDD     TCNT          ; Current Time
          ADDD    CNT           ; First in 100ms

          STD     TC1

          CLI                   ; Enable maskable interrupts

          ;******************************************
          RTS

;----------------------------------------------------
; OC ISR
;----------------------------------------------------
OC1_ISR:

          ;******************************************
          ; Enter ISR code here
          ;******************************************

          MOVB    #$02, TFLG1

          LDAA    OUT           ; Increment OUT
          INCA
          STAA    OUT

          LDD     TCNT
          ADDD    CNT        ; Next in 100ms
          STD     TC1

          ;******************************************
          RTI

;----------------------------------------------------
; PB ISR
;----------------------------------------------------
PB_ISR:

          ;******************************************
          ; Enter ISR code here
          ;******************************************

          MOVB    #$03, PIFH

          LDAA    PTH
          COMA

          CMPA    #$01
          BEQ     DECREASE_SPEED

          CMPA    #$02
          BEQ     INCREASE_SPEED

DECREASE_SPEED:
          LDD     CNT
          CPD     #63750
          BEQ     DO_NOTHING
          ADDD    #1875
          STD     CNT
          RTI

INCREASE_SPEED:

          LDD     CNT
          CPD     #1875
          BEQ     DO_NOTHING
          SUBD    #1875
          STD     CNT

          RTI
DO_NOTHING:
          NOP

          ;******************************************
          RTI

;----------------------------------------------------
; Interrupt Vector
;----------------------------------------------------
          ;******************************************
          ; Enter Interrupt Vector code here
          ;******************************************

          ; RAM Interrupt Vector for OC1
          ; $3E6C = $FFEC - $C180

          ORG     $3E6C
          FDB     OC1_ISR

          ; RAM Interrupt Vector for PORT H
          ; $3E4C = $FFCC - $C180

          ORG     $3E4C
          FDB     PB_ISR

          ;******************************************
