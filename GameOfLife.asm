; Cal Poly SLO
; CPE 233 - Gerfen
; Winter 2016
; Joseph Prachar and Brandon Kelley
; Documentation avalible at ...


.DSEG
.ORG 0x00
; CPU IO constants
.EQU VIDEO_Y    = 0x00
.EQU VIDEO_X    = 0x01
.EQU VIDEO_DATA = 0x02
.EQU VIDEO_WE   = 0x03
.EQU VIDEO_IN   = 0x04
.EQU COLOR_BLUE = 0x03

.EQU LED_PORT   = 0x40

; Grid constants
.EQU GRID_WIDTH   = 0x28 ; 40 in dec
.EQU GRID_WIDTH1  = 0x27 ; 39 in dec
.EQU GRID_HEIGHT  = 0x1E ; 30 in dec
.EQU GRID_HEIGHT1 = 0x1D ; 29 in dec

; Interupt/input state constants
.EQU NO_INPUT = 0x00
.EQU COMPUTE_NEXT_FRAME = 0x01
.EQU QUIT = 0x02

.EQU BITSEL_7 = 0X80

.CSEG
.ORG 0x10

MOV R5, 0x1C
MOV R21, 0x00
MOV R4, 0x00
LABEL: CALL SET_CELL45
ADD R21, 0x02
ADD R4, 0x01
CMP R21, GRID_HEIGHT
BRCS LABEL

MOV R1, 0x00
MOV R2, 0x00
CALL GET_CELL125
MOV R4, 0x01
MOV R21, 0x00
CALL SET_CELL45
BRN DONE
MAIN:        
             MOV  R0, 0x00 ; Add other init work here
             MOV R5, 0xFF
  WAITFORIN: CMP  R0, NO_INPUT
             CALL CLEAR
             BREQ WAITFORIN ; Wait for input from user
             CMP  R0, QUIT
             BREQ DONE
             CMP  R0, COMPUTE_NEXT_FRAME
             BRNE WAITFORIN
             CALL COMPUTE
             BRN  WAITFORIN

COMPUTE:     MOV R21, 0x00
             MOV R2, 0x00
     Y_LOOP: MOV R1, 0x00
             CALL CALC_LINE
             CMP R2, 0x00
             BREQ SKIPPRINT
             CALL PRINT_BUF
  SKIPPRINT: CALL SHIFT_BUF
             ADD R2, 0x01
             CMP R2, GRID_HEIGHT
             BRNE Y_LOOP
             CALL PRINT_BUF
             RET

CLEAR:       MOV R5, 0xE0
             MOV R21, 0x00
   YLOOPCLR: MOV R4, 0x00
   XLOOPCLR: CALL SET_CELL45
             ADD R4, 0x01
             CMP R4, GRID_WIDTH
             BRNE XLOOPCLR
             ADD R21, 0x01
             CMP R21, GRID_HEIGHT
             BRNE YLOOPCLR
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
               ADD R1, 0x01 ; Keep x pos current as well as clear carry
               LSR R3
               BRNE FILL22
             MOV R3, BITSEL_7
             MOV R23, 0x00
     FILL23:   CALL COUNT_SUR
               CALL IS_ALIVE
               AND R4, R3
               OR R23, R4
               ADD R1, 0x01
               LSR R3
               BRNE FILL23
             MOV R3, BITSEL_7
             MOV R24, 0x00
     FILL24:   CALL COUNT_SUR
               CALL IS_ALIVE
               AND R4, R3
               OR R24, R4
               ADD R1, 0x01
               LSR R3
               BRNE FILL24
             MOV R3, BITSEL_7
             MOV R25, 0x00
     FILL25:   CALL COUNT_SUR
               CALL IS_ALIVE
               AND R4, R3
               OR R25, R4
               ADD R1, 0x01
               LSR R3
               BRNE FILL25
             MOV R3, BITSEL_7
             MOV R25, 0x00
     FILL26:   CALL COUNT_SUR
               CALL IS_ALIVE
               AND R4, R3
               OR R26, R4
               ADD R1, 0x01
               LSR R3
               BRNE FILL26
             RET

;      -------
;      |0 1 2|
;Bits: |3 4 5|
;      |6 7 8|
;      -------
; Simpler without writing a loop (although not prettier)
COUNT_SUR:   MOV R4, 0x00
             CMP R2, 0x00 ; Check if bit is on top row
             BREQ CHECKBIT3
             CMP R1, 0x00
             BREQ CHECKBIT1
             MOV R5, R1
             MOV R6, R2
             SUB R5, 0x01 ; Position check point over bit 0
             SUB R6, 0x01
             CALL GET_CELL567
             CMP R7, 0x00
             BREQ CHECKBIT1
             ADD R4, 0x01
  CHECKBIT1: MOV R5, R1 ; Position over bit 1
             MOV R6, R2
             SUB R6, 0x01
             CALL GET_CELL567
             CMP R7, 0x00
             BREQ CHECKBIT2
             ADD R4, 0x01
  CHECKBIT2: CMP R1, GRID_WIDTH1
             BREQ CHECKBIT3
             MOV R5, R1
             MOV R6, R2
             ADD R5, 0x01 ; Position check point over bit 2
             ADD R6, 0x01
             CALL GET_CELL567
             CMP R7, 0x00
             BREQ CHECKBIT3
             ADD R4, 0x01
  CHECKBIT3: CMP R1, 0x00
             BREQ CHECKBIT5
             MOV R5, R1
             MOV R6, R2
             SUB R5, 0x01 ; Position check point over bit 3
             CALL GET_CELL567
             CMP R7, 0x00
             BREQ CHECKBIT5
             ADD R4, 0x01
  CHECKBIT5: CMP R1, GRID_WIDTH1
             BREQ CHECKBIT6
             MOV R5, R1
             MOV R6, R2
             ADD R5, 0x01 ; Position check point over bit 5
             CALL GET_CELL567
             CMP R7, 0x00
             BREQ CHECKBIT6
             ADD R4, 0x01
  CHECKBIT6: CMP R2, GRID_HEIGHT1
             BREQ COUNTSURRET
             CMP R1, 0x00
             BREQ CHECKBIT7
             MOV R5, R1
             MOV R6, R2
             SUB R5, 0x01 ; Position check point over bit 6
             ADD R6, 0x01
             CALL GET_CELL567
             CMP R7, 0x00
             BREQ CHECKBIT7
             ADD R4, 0x01
  CHECKBIT7: MOV R5, R1
             MOV R6, R2
             SUB R6, 0x01 ; Position over bit 7
             CALL GET_CELL567
             CMP R7, 0x00
             BREQ CHECKBIT8
             ADD R4, 0x01
  CHECKBIT8: CMP R1, GRID_WIDTH1
             BREQ COUNTSURRET
             MOV R5, R1
             MOV R6, R2
             ADD R5, 0x01 ; Position check point over bit 8
             ADD R6, 0x01
             CALL GET_CELL567
             CMP R7, 0x00
             BREQ COUNTSURRET
             ADD R4, 0x01
COUNTSURRET: RET

GET_CELL567: OUT R5, VIDEO_X
             OUT R6, VIDEO_Y
             MOV R0, R0
             IN  R7, VIDEO_IN
             RET

GET_CELL125: OUT R1, VIDEO_X
             OUT R2, VIDEO_y
             MOV R0, R0
             IN  R5, VIDEO_IN
             RET

IS_ALIVE:    CALL GET_CELL125
             CMP R5, 0x00
             BREQ DEADCELL
             CMP R4, 0x02
             BREQ LIFE
             CMP RF, 0x03
             BREQ LIFE
             BRN DEATH
   DEADCELL: CMP R4, 0x03
             BRNE DEATH
       LIFE: MOV R4, 0xFF
             BRN ISALIVERET
      DEATH: MOV R4, 0x00
 ISALIVERET: RET

PRINT_BUF:   MOV R3, BITSEL_7
             MOV R4, 0x00 ; x pos
      PRINT27: MOV R5, 0x00 ; Color
               MOV R6, R3
               AND R6, R27
               BREQ SKIPCOLOR27
               MOV R5, COLOR_BLUE ; Cell is alive
  SKIPCOLOR27: CALL SET_CELL45
               ADD R4, 0x01
               LSR R3
               BRNE PRINT27
             MOV R3, BITSEL_7
      PRINT28: MOV R5, 0x00 ; Color
               MOV R6, R3
               AND R6, R28
               BREQ SKIPCOLOR28
               MOV R5, COLOR_BLUE ; Cell is alive
  SKIPCOLOR28: CALL SET_CELL45
               ADD R4, 0x01
               LSR R3
               BRNE PRINT28
             MOV R3, BITSEL_7
      PRINT29: MOV R5, 0x00 ; Color
               MOV R6, R3
               AND R6, R29
               BREQ SKIPCOLOR29
               MOV R5, COLOR_BLUE ; Cell is alive
  SKIPCOLOR29: CALL SET_CELL45
               ADD R4, 0x01
               LSR R3
               BRNE PRINT29
             MOV R3, BITSEL_7
      PRINT30: MOV R5, 0x00 ; Color
               MOV R6, R3
               AND R6, R30
               BREQ SKIPCOLOR30
               MOV R5, COLOR_BLUE ; Cell is alive
  SKIPCOLOR30: CALL SET_CELL45
               ADD R4, 0x01
               LSR R3
               BRNE PRINT30
             MOV R3, BITSEL_7
      PRINT31: MOV R5, 0x00 ; Color
               MOV R6, R3
               AND R6, R31
               BREQ SKIPCOLOR31
               MOV R5, COLOR_BLUE ; Cell is alive
  SKIPCOLOR31: CALL SET_CELL45
               ADD R4, 0x01
               LSR R3
               BRNE PRINT31
             ADD R21, 0x01
             RET

SHIFT_BUF:   MOV R27, R22
             MOV R28, R23
             MOV R29, R24
             MOV R30, R25
             MOV R31, R26
             RET

SET_CELL45:  OUT R4, VIDEO_X
             OUT R21, VIDEO_Y
             OUT R5, VIDEO_DATA
             MOV R20, 0x01
             OUT R20, VIDEO_WE
             MOV R20, 0x00
             OUT R20, VIDEO_WE
             RET

DONE:        ; Do clean-up work
      DONE1: BRN DONE1
