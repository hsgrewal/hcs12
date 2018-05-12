;----------------------------------------------------
; Variable/Data Section
; KEEP THIS!!
;----------------------------------------------------
          ORG     DATA

IN        FCB     $00, $00, $001
OUT       RMB     1
;----------------------------------------------------
; Code Section
; KEEP THIS!!
;----------------------------------------------------
          ORG     PROG

; Insert your code following the label "Entry"
Entry:    ; KEEP THIS LABEL!!
          LDAA    IN
          ORAA    IN+1
          ORAA    IN+2
          STAA    OUT

          ; Branch to end of program
          BRA     FINISH
