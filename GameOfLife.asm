; Cal Poly SLO
; CPE 233 - Gerfen
; Winter 2016
; Joseph Prachar and Brandon Kelley
; Documentation avalible at ...


.DSEG
.ORG 0x00
; Main loop constants
.EQU NO_INPUT = 0x01
.EQU COMPUTE_NEXT_FRAME = 0x01
.EQU QUIT = 0x02

.EQU VIDEO_OUT = 0x00

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



DONE:        ; Do clean-up work
      DONE1: BRN DONE1
