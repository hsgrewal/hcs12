;----------------------------------------------------
; Variable/Data Section
; KEEP THIS!!
;----------------------------------------------------
          ORG     DATA

OUT       FCB     0

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
          ;******************************************
          ; Enable Discrete LEDs here
          ;******************************************

          BSET    DDRB,$FF

          ;******************************************
          ; Disable 7-Segment Display
          ;******************************************
          BSET    DDRP,#$0F   ; Set Port P pins 0-3 to output

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
          ADDD    #18750        ; First in 100ms

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
          ADDD    #18750        ; Next in 100ms
          STD     TC1

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

          ;******************************************
