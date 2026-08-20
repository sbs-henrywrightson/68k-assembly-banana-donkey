*-----------------------------------------------------------
* Title      : main
* Written by : Henry Wrightson
* Date       : 20/8/2026
* Type       : Include file
* Depends on : 
* Description: the main entry point to the game
*-----------------------------------------------------------

Main:
    bsr     MoveSprite
    rts

MoveSprite:
    move.w  #0,d0

.MoveLoop:
    move.w  d0,spriteOrigin     ; x
    move.w  d0,spriteOrigin+2   ; y
    
    CacheRegisters
    bsr     ClearCycleCounter
    bsr     DrawTestSprite
    bsr     RepaintScreen
    bsr     ClearTestSprite
    RestoreRegisters
    
    add.w   #5,d0
    cmp.w   #400,d0
    bls     .MoveLoop
    bsr     DrawTestSprite
    bsr     DisplayCycleCounter
    bsr     RepaintScreen

    rts