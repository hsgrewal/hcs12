;----------------------------------------------------
; Code Section
; KEEP THIS!!
;----------------------------------------------------
          ORG     PROG

; Insert your code following the label "Entry"
Entry:    ; KEEP THIS LABEL!!
          LDAA    #$01

          STAA    $3000

          ; Branch to end of program
          BRA     FINISH
