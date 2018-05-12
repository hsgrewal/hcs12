;----------------------------------------------------
; Variable/Data Section
; KEEP THIS!!
;----------------------------------------------------
          ORG     DATA
CARRY     FCB     $00
OUT       FCB     $3C
;----------------------------------------------------
; Code Section
; KEEP THIS!!
;----------------------------------------------------
          ORG     PROG

; Insert your code following the label "Entry"
Entry:    ; KEEP THIS LABEL!!

          LDS     #PROG     ; Initialize stack
          BSR     INIT      ; Initialization

MAIN:
          LDAA    OUT
          STAA    PORTB
          BRA     MAIN
;----------------------------------------------------
; INIT subroutine
;----------------------------------------------------
INIT:

          ; Configure Port H to accept input from pushbuttons
          BCLR    DDRH, $8F ; Set Port H pins 0-3,7 to input
          BCLR    PTH, $FF  ; Enable PBs

          ; Disable 7-Segment Display
          BSET    DDRP, #$0F  ; Set Port P pins 0-3 to output
          BSET    PTP, #$0F   ; Disable 7-Segment Display

          ; LED
          BSET    DDRB,$FF  ; Set all pins on Port B to output

          SEI               ; Disable maskable interrupts

          ; Enable interrupts on Port H, pin 0 (PB1/DIP1)
          ; Disable interrupts on Port H for other pins
          MOVB    #$8F, PIEH
          MOVB    #$8F, PIFH  ; Clear flag for pin 0, set the rest

          CLI                   ; Enable maskable interrupts
          RTS

;----------------------------------------------------
; ISR
;----------------------------------------------------
PB_ISR:
          MOVB    #$8F, PIFH  ; Acknowledge interrupt

          LDAA    PTH
          COMA

          CMPA    #$01
          BEQ     SHIFT_RIGHT

          CMPA    #$02
          BEQ     ROTATE_RIGHT

          CMPA    #$04
          BEQ     ROTATE_LEFT

          CMPA    #$08
          BEQ     SHIFT_LEFT

          CMPA    #$80
          BEQ     RESET

SHIFT_RIGHT:
          LDAB    OUT
          LSRB
          STAB    OUT
          STAB    PORTB

          BCS     C_CARRY
          RTI

ROTATE_RIGHT:
          LDAB    CARRY
          CMPB    #$00
          BEQ     C_RIGHT_CARRY
          SEC

RETURN_RR:
          LDAB    OUT
          RORB
          STAB    OUT
          STAB    PORTB

          BCC     CARRY_0
          BCS     CARRY_1

C_RIGHT_CARRY:
          CLC
          BRA     RETURN_RR

CARRY_0:
          LDAB    #$00
          STAB    CARRY
          RTI

CARRY_1:
          LDAB    #$01
          STAB    CARRY
          RTI

ROTATE_LEFT:
          LDAB    CARRY
          CMPB    #$00
          BEQ     C_LEFT_CARRY
          SEC

RETURN_RL:
          LDAB    OUT
          ROLB
          STAB    OUT
          STAB    PORTB

          BCC     CARRY_0
          BCS     CARRY_1

C_LEFT_CARRY:
          CLC
          BRA     RETURN_RL

SHIFT_LEFT:
          LDAB    OUT
          LSLB
          STAB    OUT
          STAB    PORTB

          BCS     C_CARRY
          RTI
        
RESET:
          LDAA    #$3C
          STAA    OUT
          CLC
          CLR     CARRY
          RTI

C_CARRY:
          CLC
          RTI

;----------------------------------------------------
; Interrupt Vector
;----------------------------------------------------
          ; Port H Vector
          ; $3E4C = $FFCC - $C180

          ORG     $3E4C
          FDB     PB_ISR

          ; Branch to end of program
          BRA     FINISH
