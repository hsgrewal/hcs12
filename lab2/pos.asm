;----------------------------------------------------
; Variable/Data Section
; KEEP THIS!!
;----------------------------------------------------
          ORG     DATA

IN        FCB     $01, $01, $01, $00
OUT       RMB     1
BUFF      RMB     1

;----------------------------------------------------
; Code Section
; KEEP THIS!!
;----------------------------------------------------
          ORG     PROG

; Insert your code following the label "Entry"
Entry:    ; KEEP THIS LABEL!!

          LDAA    IN+2
          COMA
          STAA    BUFF
          BCLR    BUFF, $FE

          LDAA    BUFF
          ORAA    IN+1
          STAA    BUFF

          LDAB    BUFF

          LDAA    IN+2
          COMA
          STAA    BUFF
          BCLR    BUFF, $FE

          LDAA    BUFF
          ORAA    IN
          ORAA    IN+3
          STAA    BUFF

          ANDB    BUFF

          LDAA    IN
          COMA
          STAA    BUFF
          BCLR    BUFF, $FE

          LDAA    IN+3
          COMA
          STAA    OUT
          BCLR    OUT, $FE

          LDAA    BUFF
          ORAA    OUT
          ORAA    IN+1
          STAA    BUFF

          ANDB    BUFF

          LDAA    IN+1
          COMA
          STAA    BUFF
          BCLR    BUFF, $FE

          LDAA    BUFF
          ORAA    IN
          ORAA    IN+2
          STAA    BUFF

          ANDB    BUFF
          STAB    OUT

          ; Branch to end of program
          BRA     FINISH
