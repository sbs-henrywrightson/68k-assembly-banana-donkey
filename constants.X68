*-----------------------------------------------------------
* Title      : constants
* Written by : Henry Wrightson
* Date       : 16/8/2026
* Type       : Include file
* Depends on : 
* Description: Constants that the main program depends on
*-----------------------------------------------------------

;====================================================
;===================== Constants ====================
;====================================================
; graphics constants
RES_X                   equ     650
RES_Y                   equ     480

; colour constants, $RRGGBB
COLOUR_BACKGROUND       equ     $000000 ; black
COLOUR_WHITE            equ     $ffffff ; white
COLOUR_BLACK            equ     $000000 ; black
COLOUR_RED              equ     $ff0000 ; red
COLOUR_GREEN            equ     $339c0d ; green
COLOUR_BLUE             equ     $002ee6 ; blue

; polygon constants
MAX_VERTICES            equ     22

; dirty rectangle buffer
MAX_DIRTY_SPRITES       equ     8
SPRITE_BUFFER_OFFSET    equ     40000   ; pixels in a sprite * 4 bytes per pixel, 100*100 * 4

; game constants
BANANA_EVENT_RATE       equ     75      ; every 750 milliseconds
BANANA_MOVE_RATE        equ     50      ; every 500 milliseconds
BANANA_SCALE            equ     20
MONKEY_ID               equ     6
MONKEY_X                equ     490
MONKEY_Y                equ     90
MONKEY_SCALE            equ     35
MAX_BANANAS             equ     6

;====================================================
;=============== Text Display variables =============
;====================================================
cleanEnd        dc.b    '   ',0
positionMessage dc.b    'Position: ',0
scaleMessage    dc.b    'Scale: ',0
flipMessage     dc.b    'Flip: ',0
spacer          dc.b    '   -   ',0
cycleMessage    dc.b    'Cycle count: ',0
laneMessage     dc.b    'Lane bits: ',0
