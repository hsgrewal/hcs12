;----------------------------------------------------
; Variable/Data Section
; KEEP THIS!!
;----------------------------------------------------
          ORG     DATA

IN        FCB     $00, $00, $00
OUT       RMB     1
BUFF      RMB     1

;----------------------------------------------------
; Code Section
; KEEP THIS!!
;----------------------------------------------------
          ORG     PROG

; Insert your code following the label "Entry"
Entry:    ; KEEP THIS LABEL!!

          LDAA    IN
          COMA
          STAA    BUFF
          BCLR    BUFF, $FE

          LDAA    BUFF
          ANDA    IN+2
          STAA    BUFF

          LDAA    IN+1
          COMA
          STAA    OUT
          BCLR    OUT, $FE

          LDAA    OUT
          ANDA    BUFF
          STAA    BUFF

          LDAA    IN
          ANDA    IN+1

          ORAA    BUFF

          LDAB    IN+2
          COMB
          STAB    BUFF
          BCLR    BUFF, $FE

          LDAB    BUFF
          ANDB    IN+1

          STAB    BUFF
          ORAA    BUFF
          STAA    OUT

          ; Branch to end of program
          BRA     FINISH
