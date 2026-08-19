*-----------------------------------------------------------
* Title      : banana-donkey
* Written by : Henry Wrightson
* Date       : 16/8/2026
* Type       : Program file
* Depends on : 
* Description:
*-----------------------------------------------------------
    org     $1000
    
    include 'constants.x68'
    include 'diagnostics.x68'
    include 'sprite-data.x68'
    
    include 'macros.x68'
    include 'core.x68'
    
Start:
    bsr     InitialiseEnvironment
    bsr     BuildSprites

MoveSprite:    
    move.w  #0,d0

.MoveLoop:
    move.w  d0,spriteOrigin     ; x
    move.w  d0,spriteOrigin+2   ; y
    
    CacheRegisters
    bsr     ClearCycleCounter
    bsr     DrawTestSprite
    
    ;moveq   #3,d1
    ;bsr     Wait
    
    bsr     ClearTestSprite
    RestoreRegisters
    
    add.w   #1,d0
    cmp.w   #400,d0
    bls     .MoveLoop
    bsr     DisplayCycleCounter

    bra     Finish
    
    include 'sprites.x68'
    
    include 'polygons.x68'
    include 'bresenham-line.x68'
    include 'graphics.x68'

Finish:
    simhalt

    end     Start
    
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
