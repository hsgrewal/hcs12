;****************************************************************
;* Lab 8 Part 1
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

CNT       FCB     0       ; Counter

;----------------------------------------------------
; Code Section
; KEEP THIS!!
;----------------------------------------------------
          ORG     PROG

; Insert your code following the label "Entry"
Entry:    ; KEEP THIS LABEL!!

          LDS     #PROG         ; Init stack

          ; Initialization
          BSR     LED_INIT
          BSR     TOF_INIT

INF_LOOP:
          ; Loop Continuously
          BRA     INF_LOOP

;----------------------------------------------------
; TOF Init Subroutine
;----------------------------------------------------
TOF_INIT:

          SEI
          MOVB    #$80, TSCR1
          MOVB    #$85, TSCR2
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
; TOF ISR
;----------------------------------------------------
TOF_ISR:

          MOVB    #$80, TFLG2

          LDAA    CNT
          STAA    PORTB
          ADDA    #1
          STD     CNT

          RTI

;----------------------------------------------------
; Interrupt Vector Table
;----------------------------------------------------
          ; TOF Vector
          ; $3E5E = $FFDE - $C180
          ORG $3E5E
          FDB TOF_ISR
