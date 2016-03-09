; Cal Poly SLO
; CPE 233 - Gerfen
; Winter 2016
; Joseph Prachar and Brandon Kelley
; Documentation avalible at ...


.DSEG
.ORG 0x00
; CPU IO constants
.EQU VIDEO_X    = 0x00
.EQU VIDEO_Y    = 0x01
.EQU VIDEO_DATA = 0x02

; Grid constants
.EQU GRID_WIDTH  = 0x28 ; 40 in dec
.EQU GRID_HEIGHT = 0x1E ; 30 in dec

; Interupt/input state constants
.EQU NO_INPUT = 0x01
.EQU COMPUTE_NEXT_FRAME = 0x01
.EQU QUIT = 0x02

.EQU BITSEL_0 = 0x01
.EQU BITSEL_7 = 0X80

.CSEG
.ORG 0x10

MAIN:        MOV  R0, 0x01 ; Add other init work here
  WAITFORIN: CMP  R0, NO_INPUT
             BREQ WAITFORIN ; Wait for input from user
             CMP  R0, QUIT
             BREQ DONE
             CMP  R0, COMPUTE_NEXT_FRAME
             BRNE WAITFORIN
             CALL COMPUTE
             BRN  WAITFORIN

COMPUTE:     MOV R2, 0x00
     Y_LOOP: MOV R1, 0x00
     X_LOOP:   CALL CALC_LINE
               CALL PRINT_BUF
               CALL SHIFT_BUF
               ADD R1, 0x01
               CMP R1, GRID_WIDTH
               BRNE X_LOOP
             ADD R2, 0x01
             CMP R2, GRID_HEIGHT
             BRNE Y_LOOP


DONE:        ; Do clean-up work
      DONE1: BRN DONE1
