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
    include 'macros.X68'
    include 'sprite-data.X68'

Start:

    bsr     InitialiseEnvironment
    bsr     GetSpriteSizes
    bsr     Main
    bra     Finish

    include 'main.X68'
    include 'core.X68'
    
    include 'graphics.X68'
    include 'sprites.X68'
    include 'polygons.X68'
    include 'bresenham-line.X68'

    include 'diagnostics.X68'
    

Finish:
    simhalt

    include 'variables.X68'
    include 'buffers.X68'

    end     Start
