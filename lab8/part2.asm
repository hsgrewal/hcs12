;****************************************************************
;* Lab 8 Part 2
;****************************************************************

;----------------------------------------------------
; Export Symbols
; KEEP THIS!!
;----------------------------------------------------
          XDEF      Entry     ; export 'Entry' symbol
          ABSENTRY  Entry     ; for absolute assembly: mark this as application entry point

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

CNT       FCB     0           ; Counter
TOI       FCB     $80
PR_BITS   FCB     0           ; Init PR2,PR1,PR0=0

;----------------------------------------------------
; Code Section
; KEEP THIS!!
;----------------------------------------------------
          ORG     PROG

; Insert your code following the label "Entry"
Entry:    ; KEEP THIS LABEL!!

          LDS     #PROG       ; Init stack

          ; Initialization
          BSR     LED_INIT
          BSR     TOF_INIT
          BSR     PB_INIT

INF_LOOP:
          ; Loop Continuously
          BRA     INF_LOOP

;----------------------------------------------------
; TOF Init Subroutine
;----------------------------------------------------
TOF_INIT:

          SEI
          MOVB    #$80, TSCR1
          MOVB    #$80, TSCR2
          MOVB    #$80, TFLG2
          CLI

          RTS

;----------------------------------------------------
; LED Init Subroutine
;----------------------------------------------------
LED_INIT:

          BSET    DDRB,$FF

          BSET    DDRP,#$0F
          BSET    PTP,#$0F

          RTS

;----------------------------------------------------
; PB Init Subroutine
;----------------------------------------------------
PB_INIT:
          SEI                 ; Disable msakable interrupts

          BCLR    DDRH,$03    ; Set Port H pins 0-1 to input
          BCLR    PTH,$FF     ; Enable PBs

          ; Enable interrupts on Port H, pin 0 (PB1/DIP1)
          ; Disable interrupts on Port H for other pins
          MOVB    #$03, PIEH
          MOVB    #$03, PIFH  ; Clear flag for pin 0, set the rest

          CLI                 ; Enable maskable interrupts

          RTS

;----------------------------------------------------
; TOF ISR
;----------------------------------------------------
TOF_ISR:

          MOVB    #$80, TFLG2

          LDAA    CNT
          STAA    PORTB
          ADDA    #1
          STAA    CNT

          LDAA    TOI         ; TOI Bit
          ADDA    PR_BITS     ; PR bits
          STAA    TSCR2       ; TOI arm, TOF period


          RTI

;----------------------------------------------------
; PB ISR
;----------------------------------------------------
PB_ISR:
          MOVB    #$03, PIFH

          LDAA    PTH
          COMA

          CMPA    #$01
          BEQ     DEC_PR_BITS

          CMPA    #$02
          BEQ     IN_PR_BITS

DEC_PR_BITS:
          LDAA    PR_BITS
          CMPA    #0
          BEQ     DO_NOTHING
          DECA
          STAA    PR_BITS
          RTI

IN_PR_BITS:
          LDAA    PR_BITS
          CMPA    #7
          BEQ     DO_NOTHING
          INCA
          STAA    PR_BITS
          RTI

DO_NOTHING:
          NOP

          RTI

;----------------------------------------------------
; Interrupt Vector Table
;----------------------------------------------------
          ; TOF Vector
          ; $3E5E = $FFDE - $C180
          ORG     $3E5E
          FDB     TOF_ISR

          ; RAM Interrupt Vector for PORT H
          ; $3E4C = $FFCC - $C180
          ORG     $3E4C
          FDB     PB_ISR
