;----------------------------------------------------
; Code Section
; KEEP THIS!!
;----------------------------------------------------
          ORG     PROG

; Insert your code following the label "Entry"
Entry:    ; KEEP THIS LABEL!!

          LDS     #PROG
          LDAA    #$88
LOOP:
          PSHA
          SUBA    #$11
          CMPA    #11
          BGE     LOOP

          TSX

          LDAA    3,X
          LDAB    6,X


          ; Branch to end of program
          BRA     FINISH
