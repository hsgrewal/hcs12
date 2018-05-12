;----------------------------------------------------
; Code Section
; KEEP THIS!!
;----------------------------------------------------
          ORG     PROG

; Insert your code following the label "Entry"
Entry:    ; KEEP THIS LABEL!!
          LDAA    #$FF
          LDAB    #$01
          ABA


          ; Branch to end of program
          BRA     FINISH
