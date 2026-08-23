*-----------------------------------------------------------
* Title      : banana-donkey
* Written by : Henry Wrightson
* Date       : 16/8/2026
* Type       : Program file
* Depends on : 
* Description: The main program file that includes all the
*            : required files and starts the game
*-----------------------------------------------------------
    org     $1000
    
    include 'constants.X68'
    include 'diagnostics.X68'
    include 'sprite-data.X68'
    
    include 'macros.X68'
    include 'core.X68'
    include 'main.X68'
    
Start:
    bsr     InitialiseEnvironment
    bsr     BuildSprites

    bsr     Main

    bra     Finish
    
    include 'sprites.X68'
    
    include 'polygons.X68'
    include 'bresenham-line.X68'
    include 'graphics.X68'

Finish:
    simhalt


;====================================================
;================== buffer variables ================
;====================================================
dirtyRectangleBuffer    ds.l    262144      ; screen buffer large enough to a 2x sprite dirty buffer

    end     Start
    

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
