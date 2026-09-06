*-----------------------------------------------------------
* Title      : constants
* Written by : Henry Wrightson
* Date       : 16/8/2026
* Type       : Include file
* Depends on : 
* Description: Constants that the main program depends on
*-----------------------------------------------------------

;====================================================
;===                                              ===
;===                  Constants                   ===
;===                                              ===
;====================================================
; graphics constants
RES_X                   equ     650         ; width of screen in pixels
RES_Y                   equ     480         ; height of screen in pixels

; colour constants, $RRGGBB
COLOUR_BACKGROUND       equ     $000000
COLOUR_WHITE            equ     $ffffff
COLOUR_BLACK            equ     $000000
COLOUR_GREY             equ     $7a7a7a
COLOUR_RED              equ     $ff0000
COLOUR_GREEN            equ     $339c0d
COLOUR_BRT_GREEN        equ     $00ff00
COLOUR_BLUE             equ     $002ee6
COLOUR_YELLOW           equ     $ffff00
COLOUR_ORANGE           equ     $ff7f00
COLOUR_SKY              equ     $70c1ff
COLOUR_SAND             equ     $ffe894
COLOUR_SEA              equ     $002ee6

; polygon constants
MAX_VERTICES            equ     24          ; the maximum number of vertices in a sprite polygone. Keep this EVEN

; game constants
BANANA_THROW_INTERVAL   equ     40          ; hundredths of a second
BANANA_MOVE_INTERVAL    equ     10          ; hundredths of a second
DONKEY_MOVE_INTERVAL    equ     10          ; hundredths of a second
PLAY_SOUND_INTERVAL     equ     50          ; hundredths of a second
BANANA_SCALE            equ     20          ; percentage of full size
MONKEY_X                equ     490         ; the x-coord of the monkey
MONKEY_Y                equ     90          ; the y-coord of the monkey
MONKEY_SCALE            equ     30          ; percentage of full size
MAX_BANANAS             equ     6           ; Maximum number of bananas, used as the sprite ids for the dirty rectangles
DONKEY_Y                equ     323         ; the y-coord of the donkey
DONKEY_SCALE            equ     30          ; percentage of full size
DONKEY_LANE1_X          equ     185         ; the x-coord of the donkey when in lane 1
DONKEY_LANE2_X          equ     285         ; the x-coord of the donkey when in lane 2
DONKEY_LANE3_X          equ     385         ; the x-coord of the donkey when in lane 3
MAX_LIVES               equ     3

; score constants
LIVES_TEXT_X            equ     60
LIVES_X                 equ     165
LIVES_WIDTH             equ     20

SCORE_TEXT_X            equ     210
SCORE_X                 equ     315
SCORE_WIDTH             equ     90

HISCORE_TEXT_X          equ     420
HISCORE_X               equ     505
HISCORE_WIDTH           equ     90

SCORE_LINE_Y_HI         equ     442
SCORE_LINE_Y_LO         equ     466

; dirty rectangle buffers
MAX_DIRTY_SPRITES       equ     MAX_BANANAS+8   ; total number of sprites that require buffer space for their dirty rectangle
SPRITE_BUFFER_OFFSET    equ     40000       ; pixels in a sprite * 4 bytes per pixel, 100*100 * 4

; sprite IDs : 0-5  : bananas (0 - MAX_BANANAS-1)
;                6  : monkey  (MAX_BANANAS)
;                7  : donkey  (MAX_BANANAS + 1)
;              8-11 : overlay (MAX_BANANAS + 2-5)
MONKEY_DB_NUMBER        equ     MAX_BANANAS
DONKEY_DB_NUMBER        equ     MAX_BANANAS+1
OVERLAY_DB_NUMBER       equ     MAX_BANANAS+2

; font constants
DIGIT_FONT_HEIGHT       equ     7
GAME_FONT_HEIGHT        equ     10

; game flag constants
GAMEFLAG_FLIP           equ     0       ; flip the monkey orientation
GAMEFLAG_CATCH          equ     1       ; the donkey caught a banana
GAMEFLAG_DROP           equ     2       ; a banana hit the ground
GAMEFLAG_DEATH          equ     3       ; the player died
GAMEFLAG_FIRST          equ     4       ; first game of the session
GAMEFLAG_NEW_HI         equ     5       ; new high score set

;====================================================
;===                                              ===
;===                Sound Constants               ===
;===                                              ===
;====================================================
SQUELCH_SOUND_ID        equ     0
SCRUMPLE_SOUND_ID       equ     1
MONKEY_1_SOUND_ID       equ     2
MONKEY_2_SOUND_ID       equ     3
MONKEY_3_SOUND_ID       equ     4
MONKEY_4_SOUND_ID       equ     5
MONKEY_5_SOUND_ID       equ     6
MONKEY_6_SOUND_ID       equ     7