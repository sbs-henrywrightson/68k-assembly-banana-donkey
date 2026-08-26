*-----------------------------------------------------------
* Title      : constants
* Written by : Henry Wrightson
* Date       : 16/8/2026
* Type       : Include file
* Depends on : 
* Description: Constants that the main program depends on
*-----------------------------------------------------------

; graphics constants
RES_X                   equ     650
RES_Y                   equ     480

; colour constants, $RRGGBB
COLOUR_BACKGROUND       equ     $000000 ; black

COLOUR_WHITE            equ     $ffffff ; white
COLOUR_RED              equ     $ff0000 ; red
COLOUR_GREEN            equ     $339c0d ; green

; polygon constants
MAX_VERTICES            equ     22

; dirty rectangle buffer
MAX_SPRITES             equ     8
SPRITE_BUFFER_OFFSET    equ     40000   ; pixels in a sprite * 4 bytes per pixel, scaled to 40% that's ~100*100 * 4

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
