;----------------------------------------------------
; Variable/Data Section
; KEEP THIS!!
;----------------------------------------------------
          ORG     DATA

IN        FCB     $01, $01, $01
OUT       RMB     1
;----------------------------------------------------
; Code Section
; KEEP THIS!!
;----------------------------------------------------
          ORG     PROG

; Insert your code following the label "Entry"
Entry:    ; KEEP THIS LABEL!!
          LDAA    IN
          ANDA    IN+1
          ANDA    IN+2
          STAA    OUT

          ; Branch to end of program
          BRA     FINISH
