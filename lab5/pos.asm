;----------------------------------------------------
; Variable/Data Section
; KEEP THIS!!
;----------------------------------------------------
          ORG     DATA

IN        RMB     4
OUT       RMB     1
COMP      RMB     3

;----------------------------------------------------
; Code Section
; KEEP THIS!!
;----------------------------------------------------
          ORG     PROG

; Insert your code following the label "Entry"
Entry:    ; KEEP THIS LABEL!!

          LDS     #PROG     ; Initialize stack
          BSR     INIT      ; Initialization

LOOP:
          LDAA    PTH
          COMA
          STAA    IN+3
          BCLR    IN+3,$FE

          LSRA
          STAA    IN+2
          BCLR    IN+2,$FE

          LSRA
          STAA    IN+1
          BCLR    IN+1,$FE

          LSRA
          STAA    IN
          BCLR    IN,$FE

          LDAA    IN+1
          COMA
          STAA    COMP
          BCLR    COMP,$FE

          LDAA    IN+2
          COMA
          STAA    COMP+1
          BCLR    COMP+1,$FE

          LDAA    IN+3
          COMA
          STAA    COMP+2
          BCLR    COMP+2,$FE

          LDAA    IN+1
          ORAA    IN+3
          STAA    OUT

          LDAA    IN
          ORAA    COMP
          ANDA    OUT
          STAA    OUT

          LDAA    COMP
          ORAA    COMP+1
          ORAA    COMP+2
          ANDA    OUT

          STAA    OUT
          STAA    PORTB

          BRA     LOOP

;----------------------------------------------------
; INIT subroutine
;----------------------------------------------------
INIT:
          ; Configure Port H to accept input from pushbuttons
          BCLR    DDRH, #$0F    ; Set Port H pins 0-3 to input
          BCLR    PTH, #$0F     ; Enable PBs

          ; Disable 7-Segment Display
          BSET    DDRP,#$0F     ; Set Port P pins 0-3 to output
          BSET    PTP, #$0F     ; Disable 7-Segment Display

          ; LED
          BSET    DDRB,$01      ; Set all pins on Port B to output

          RTS

          ; Branch to end of program
          BRA     FINISH
