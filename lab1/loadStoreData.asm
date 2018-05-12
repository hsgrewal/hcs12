;----------------------------------------------------
; Code Section
; KEEP THIS!!
;----------------------------------------------------
          ORG     PROG

; Insert your code following the label "Entry"
Entry:    ; KEEP THIS LABEL!!
          LDAA    #$FF
          LDAB    #$0F
          LDX     #$0E
          LDY     #$0D

          STAA    $3000
          STAB    $3002
          STX     $3006
          STY     $3008


          ; Branch to end of program
          BRA     FINISH
