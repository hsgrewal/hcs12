;----------------------------------------------------
; Variable/Data Section
; KEEP THIS!!
;----------------------------------------------------
          ORG     DATA

IN        FCB     $01
OUT       RMB     1
;----------------------------------------------------
; Code Section
; KEEP THIS!!
;----------------------------------------------------
          ORG     PROG

; Insert your code following the label "Entry"
Entry:    ; KEEP THIS LABEL!!
          LDAA    IN
          COMA
          STAA    OUT
          BCLR    OUT, %11111110

          ; Branch to end of program
          BRA     FINISH
