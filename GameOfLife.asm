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
             RET

; Notes about CALC_LINE
; Yes this is repetitive, but to keep the buffer stored in the registers there
;needs to be 'concrete' registers for each column of bytes. This could be done
;using the ScratchRAM by incrementing an address each time this function
;switches to a new regester

CALC_LINE:   MOV R3, BITSEL_7
             MOV R22, 0x00
     FILL22:   CALL COUNT_SUR
               CALL IS_ALIVE ; Result is put into R4 [Dead=0x00;Alive=0xFF]
               AND R4, R3
               OR R22, R4
               CLC
               LSR R3
               BRNE FILL22
             MOV R3, BITSEL_7
             MOV R23, 0x00
     FILL23:   CALL COUNT_SUR
               CALL IS_ALIVE
               AND R4, R3
               OR R23, R4
               CLC
               LSR R3
               BRNE FILL23
             MOV R3, BITSEL_7
             MOV R24, 0x00
     FILL24:   CALL COUNT_SUR
               CALL IS_ALIVE
               AND R4, R3
               OR R24, R4
               CLC
               LSR R3
               BRNE FILL24
             MOV R3, BITSEL_7
             MOV R25, 0x00
     FILL25:   CALL COUNT_SUR
               CALL IS_ALIVE
               AND R4, R3
               OR R25, R4
               CLC
               LSR R3
               BRNE FILL25
             MOV R3, BITSEL_7
             MOV R25, 0x00
     FILL26:   CALL COUNT_SUR
               CALL IS_ALIVE
               AND R4, R3
               OR R26, R4
               CLC
               LSR R3
               BRNE FILL26
             RET


               
               
             


DONE:        ; Do clean-up work
      DONE1: BRN DONE1
