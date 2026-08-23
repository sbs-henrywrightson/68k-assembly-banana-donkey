*-----------------------------------------------------------
* Title      : buffers
* Written by : Henry Wrightson
* Date       : 23/8/2026
* Type       : Include file
* Depends on : 
* Description: All the reserved memory buffers. Need to be
*            : declared at the end of the program so that
*            : the branch distances don't change
*-----------------------------------------------------------

;====================================================
;================== buffer variables ================
;====================================================
dirtyRectangleBuffer    ds.l    MAX_SPRITES*SPRITE_BUFFER_OFFSET

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
