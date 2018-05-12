;----------------------------------------------------
; Code Section
; KEEP THIS!!
;----------------------------------------------------
          ORG     PROG

; Insert your code following the label "Entry"
Entry:    ; KEEP THIS LABEL!!

          LDS     #PROG

          LDAA    #5
          PSHA

          LDAA    #1
          PSHA

          LDAA    #2
          PSHA

          PULA
          PULB
          ABA

          PSHA

          LDAA    #4
          PSHA

          PULA
          PULB

          MUL
          PSHB

          PULA
          PULB
          ABA

          PSHA

          LDAA    #3
          PSHA

          PULB
          PULA
          SBA

          PSHA

          ; Branch to end of program
          BRA     FINISH
