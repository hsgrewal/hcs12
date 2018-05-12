;----------------------------------------------------
; Variable/Data Section
; KEEP THIS!!
;----------------------------------------------------
          ORG     DATA
NUMNEG    RMB     1
TOTAL     RMB     1

SSTART    FDB     SBLK    ; Pointer to beginning of Source Block
DEST      FDB     DBLK    ; Pointer to beginning of Destination Block

SBLK      FCB     0,126,-8,-63,-44,-115,28  ; Source Block
DBLK      RMB     1                         ; Destination Block

;----------------------------------------------------
; Code Section
; KEEP THIS!!
;----------------------------------------------------
          ORG     PROG

; Insert your code following the label "Entry"
Entry:    ; KEEP THIS LABEL!!

         ; Enter your code starting here

          LDAA    #$00
          STAA    NUMNEG
          STAA    TOTAL

          LDX     SSTART
          LDY     DEST

LOOP:
          CPX     DEST
          BEQ     FINISH
          LDAA    X
          STAA    Y
          INC     TOTAL
          INX
          INY
          CMPA    $00
          BLT     NEGNUM
          BRA     LOOP

NEGNUM:
          INC NUMNEG
          BRA LOOP

          ; Branch to end of program
          BRA     FINISH
