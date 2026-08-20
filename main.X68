*-----------------------------------------------------------
* Title      : main
* Written by : Henry Wrightson
* Date       : 20/8/2026
* Type       : Include file
* Depends on : 
* Description: the main entry point to the game
*-----------------------------------------------------------

Main:
    move.w  #100,spriteOrigin     ; x
    move.w  #100,spriteOrigin+2   ; y

    move.w  #75,spriteScale
    bsr     DrawPalmTree

    bsr     RepaintScreen
    
    rts
