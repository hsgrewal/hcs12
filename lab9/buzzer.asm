;****************************************************************
;* Lab 9
;* NOTE: Change J26 to PP5
;****************************************************************

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

          ; Vars for PWM
FREQS     FDB     34433         ; 697 Hz

;----------------------------------------------------
; Code Section
; KEEP THIS!!
;----------------------------------------------------
          ORG     PROG

; Insert your code following the label "Entry"
Entry:                          ; KEEP THIS LABEL!!
          LDS     #PROG         ; Init stack

          BSR     PWM_INIT      ; Init PWM
          BSR     PB_INIT       ; Init PB

MAIN:
          BSR     PWM           ; Output PWM
          BRA     MAIN

;----------------------------------------------------
; PWM Init Subroutine
;----------------------------------------------------
PWM_INIT:
          BCLR    MODRR,#$30    ; Output on PP5 and PP4
          BSET    PWME,#$30     ; Enable chans 4,5
          BSET    PWMCTL,#$40   ; Set CON45
          BSET    PWMPOL,#$30   ; Chans 4,5 active high
          BCLR    PWMCLK,#$30   ; Chans 4,5 use clock A
          BCLR    PWMPRCLK,#$07 ; A = E = 24MHz
          CLR     PWMDTY45      ; Init off
          RTS

;----------------------------------------------------
; PB Init Subroutine
;----------------------------------------------------
PB_INIT:
          SEI                   ; Disable msakable interrupts

          BCLR    DDRH,$0F      ; Set Port H pins 0-1 to input
          BCLR    PTH,$FF       ; Enable PBs

          ; Enable interrupts on Port H, pin 0 (PB1/DIP1)
          ; Disable interrupts on Port H for other pins
          MOVB	  #$0F, PIEH
          MOVB    #$0F, PIFH    ; Clear flag for pin 0, set the rest

          CLI                   ; Enable maskable interrupts

          RTS

;----------------------------------------------------
; PWM Subroutine
;----------------------------------------------------
PWM:
          ; Load Freq
          LDD     FREQS         ; Load freq 1
          LDX     #2
          IDIV                  ; Get 50% duty cycle
          LDD     FREQS         ; Load freq 1
          STD     PWMPER45      ; Freq in Hz, signal ; generated on chan 5
          STX     PWMDTY45      ; Duty cycle
          RTS

;----------------------------------------------------
; PB ISR
;----------------------------------------------------
PB_ISR:
          MOVB    #$0F, PIFH

          LDAA    PTH
          COMA

          CMPA    #$01
          BEQ     PB1

          CMPA    #$02
          BEQ     PB2

          CMPA    #$04
          BEQ     PB3

          CMPA    #$08
          BEQ     PB4

          CMPA    #$03
          BEQ     PB12

          CMPA    #$06
          BEQ     PB23

          CMPA    #$0C
          BEQ     PB34

          CMPA    #$09
          BEQ     PB14

PB1:
          LDD     #34433
          STD     FREQS
          RTI

PB2:
          LDD     #31169
          STD     FREQS
          RTI

PB3:
          LDD     #28169
          STD     FREQS
          RTI

PB4:
          LDD     #25505
          STD     FREQS
          RTI

PB12:
          LDD     #19851
          STD     FREQS
          RTI

PB23:
          LDD     #17964
          STD     FREQS
          RTI

PB34:
          LDD     #16249
          STD     FREQS
          RTI

PB14:
          LDD     #14697
          STD     FREQS
          RTI

          RTI

;----------------------------------------------------
; Interrupt Vector Table
;----------------------------------------------------

          ; PORT H Interrupt Vector
          ; $3E4C = $FFCC - $C180
          ORG     $3E4C
          FDB     PB_ISR
