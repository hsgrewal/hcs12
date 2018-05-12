;----------------------------------------------------
; Variable/Data Section
; KEEP THIS!!
;----------------------------------------------------
          ORG     DATA

RPN_IN    FCB     $06, $03, $2F, $04, $2A, $02, $2B ; 63/4*2+=10
RPN_OUT   RMB     1

RPN_START FDB     RPN_IN    ; Pointer to start of RPN array
RPN_END   FDB     RPN_OUT-1 ; Pointer to end of RPN array

OPER      FCB     $2A,$2B,$2D,$2F ;*,+,-,/

;----------------------------------------------------
; Code Section
; KEEP THIS!!
;----------------------------------------------------
          ORG     PROG

; Insert your code following the label "Entry"
Entry:                          ; KEEP THIS LABEL!!

          LDS     #PROG
          LDY     RPN_START

LOOP:
          LDAA    Y
          CMPA    OPER
          BEQ     MULT
          CMPA    OPER+1
          BEQ     ADD
          CMPA    OPER+2
          BEQ     SUB
          CMPA    OPER+3
          BEQ     DIVD

          PSHA

RETURN:
          INY
          CPY     RPN_END
          BEQ     END
          BRA     LOOP

MULT:
          PULA
          PULB
          MUL
          PSHB
          BRA     RETURN


ADD:
          PULA
          PULB
          ABA
          PSHA
          BRA     RETURN

SUB:
          PULB
          PULA
          SBA
          PSHA
          BRA     RETURN

DIVD:
          PULA
          PULB
          TFR     A,X
          CLRA
          IDIVS
          TFR     X,D
          PSHB
          BRA     RETURN

END:
          STAA    RPN_OUT       ; SAVE RESULT

          ; Branch to end of program
          BRA     FINISH
