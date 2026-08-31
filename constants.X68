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
RES_X                   equ     650         ; width of screen in pixels
RES_Y                   equ     480         ; height of screen in pixels

; colour constants, $RRGGBB
COLOUR_BACKGROUND       equ     $000000     ; black
COLOUR_WHITE            equ     $ffffff     ; white
COLOUR_BLACK            equ     $000000     ; black
COLOUR_GREY             equ     $7a7a7a
COLOUR_RED              equ     $ff0000     ; red
COLOUR_GREEN            equ     $339c0d     ; green
COLOUR_BLUE             equ     $002ee6     ; blue

; polygon constants
MAX_VERTICES            equ     24          ; the maximum number of vertices in a sprite polygone. Keep this EVEN

; dirty rectangle buffer
MAX_DIRTY_SPRITES       equ     8           ; total number of sprites that require buffer space for their dirty rectangle
SPRITE_BUFFER_OFFSET    equ     40000       ; pixels in a sprite * 4 bytes per pixel, 100*100 * 4

; game constants
BANANA_THROW_RATE       equ     75          ; hundredths of a second
BANANA_MOVE_RATE        equ     15          ; hundredths of a second
BANANA_SCALE            equ     20          ; percentage of full size
MONKEY_X                equ     490         ; the x-coord of the monkey
MONKEY_Y                equ     90          ; the y-coord of the monkey
MONKEY_SCALE            equ     35          ; percentage of full size
MAX_BANANAS             equ     6           ; Maximum number of bananas, also the monkey sprite ID
                                            ;     sprite IDs : 0-5 : bananas (MAX_BANANAS in number)
                                            ;                    6 : monkey  (Same as MAX_BANANAS)
                                            ;                    7 : donkey  (one more than MAX_BANANAS)
