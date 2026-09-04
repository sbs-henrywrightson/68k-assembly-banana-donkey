*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Type       : Program file
* Depends on : 
* Description:
*-----------------------------------------------------------
    org     $1000

    include 'constants.X68'
    include 'macros.X68'
    include 'sprite-data.X68'

Start:

    bra     Finish

    include 'font-renderer.X68'
    include 'core.X68'
    include 'trap-fifteen.X68'
    
    include 'graphics.X68'
    include 'sprites.X68'
    include 'polygons.X68'
    include 'bresenham-line.X68'

Finish:
    simhalt

    include 'variables.X68'
    include 'fonts.X68'
    include 'buffers.X68'

    end     Start