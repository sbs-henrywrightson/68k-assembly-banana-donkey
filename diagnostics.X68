*-----------------------------------------------------------
* Title      : diagnostics
* Written by : Henry Wrightson
* Date       : 17/8/2026
* Type       : Program file
* Depends on : 
* Description: Sub-routines used for debugging the main app
*-----------------------------------------------------------

;====================================================
;===                                              ===
;===            Performance Diagnostics           ===
;===                                              ===
;====================================================
ClearCycleCounter:
    moveq   #30,d0
    trap    #15
    rts

DisplayCycleCounter:
    moveq   #31,d0
    trap    #15

    lea     cycleText,a1
    moveq   #14,d0
    trap    #15
    
    moveq   #15,d0
    moveq   #10,d2
    trap    #15
    rts

;====================================================
;===                                              ===
;===               Sprite Diagnostics             ===
;===                                              ===
;====================================================
PositionSprite:
    move.w  #180,posX
    move.w  #340,posY
    move.w  #32,scale
    move.w  #0,flip

    jsr     ClearScreen
    jsr     DrawBackdrop
    jsr     DrawSceneSprites

.moveLoop:
    SetSprite donkey,donkeySpriteSize,#0,posX,posY,scale,flip
    jsr     SaveDirtyRectangle
    jsr     DrawSprite
    bsr     OutputInfo
    jsr     RepaintScreen

    jsr     RestoreDirtyRectangle
    bsr     MoveSprite
    bra     .moveLoop
    rts

MoveSprite:
    bsr     SetMoveAmount
    bsr     SetScaleAmount
    bsr     SetSpriteScale
    bsr     SetSpriteFlip

    moveq   #19,d0
    move.l  #$25272628,d1  ; check for keypress Left, Right, Up, Down    
    trap    #15

    btst.l  #24,d1
    bne     .left

    btst.l  #16,d1
    bne     .right
    
    btst.l  #8,d1
    bne     .up
    
    btst.l  #0,d1
    bne     .down
    rts

.left:
    move.w  posX,d0
    sub.w   moveAmount,d0
    move.w  d0,posX
    ;moveq   #0,d0          ; DEBUG : Face in the direction of movement
    ;move.w  d0,flip
    rts
.right:
    move.w  posX,d0
    add.w   moveAmount,d0
    move.w  d0,posX
    ;moveq   #1,d0          ; DEBUG : Face in the direction of movement
    ;move.w  d0,flip
    rts
.up:
    move.w  posY,d0
    sub.w   moveAmount,d0
    move.w  d0,posY
    rts
.down:
    move.w  posY,d0
    add.w   moveAmount,d0
    move.w  d0,posY
    rts

SetMoveAmount:
    moveq   #19,d0
    move.l  #$10,d1       ; Shift
    trap    #15
    tst.b   d1
    bne    .smallMove
    move.w  #10,moveAmount
    rts
.smallMove:
    move.w  #1,moveAmount
    rts

SetScaleAmount:
    moveq   #19,d0
    move.l  #$11,d1       ; CTRL
    trap    #15
    tst.b   d1
    bne    .smallMove
    move.w  #10,scaleAmount
    rts
.smallMove:
    move.w  #1,scaleAmount
    rts

SetSpriteScale:
    moveq   #19,d0
    move.l  #$00006B6D,d1  ; check for keypress + and -    
    trap    #15
    
    btst.l  #8,d1
    bne     .plus
    
    btst.l  #0,d1
    bne     .minus
    rts

.plus:
    move.w  scale,d0
    add.w   scaleAmount,d0
    move.w  d0,scale
    rts
.minus:
    move.w  scale,d0
    sub.w   scaleAmount,d0
    cmp.w   #1,d0
    blo     .dontShrink
    move.w  d0,scale
.dontShrink:
    rts

SetSpriteFlip:
    moveq   #19,d0
    move.l  #$46,d1       ; f key
    trap    #15
    tst.b   d1
    beq     .dontFlip
    add.w   #1,flip
    cmp.w   #4,flip
    beq     .resetFlip
    rts
.resetFlip:
    move.w  #0,flip
.dontFlip:
    rts

OutputInfo:
    moveq   #10,d2

    moveq   #11,d0      ; position at 0,0
    moveq   #0,d1
    move.w  $0000,d1
    trap    #15
    
    moveq   #14,d0      ; position message
    lea     positionText,a1
    trap    #15

    moveq   #15,d0      ; x-coord
    move.w  posX,d1
    trap    #15

    move.w  #6,d0       ; comma
    move.b  #',',d1
    trap    #15

    moveq   #15,d0      ; y-coord
    move.w  posY,d1
    trap    #15

    moveq   #14,d0      ; spacer
    lea     spacerText,a1
    trap    #15

    moveq   #14,d0      ; scale message
    lea     scaleText,a1
    trap    #15

    moveq   #15,d0      ; scale
    move.w  scale,d1
    trap    #15

    moveq   #14,d0      ; spacer
    lea     spacerText,a1
    trap    #15

    moveq   #14,d0      ; flip message
    lea     flipText,a1
    trap    #15

    moveq   #15,d0      ; flip
    move.w  flip,d1
    trap    #15

    moveq   #14,d0      ; output some spaces at the end
    lea     cleanEndText,a1
    trap    #15
    
    rts

;====================================================
;===                                              ===
;===               Game Diagnostics               ===
;===                                              ===
;====================================================

OutputDebugText:
    move.l  #COLOUR_WHITE,d1
    jsr     SetPenColour

    moveq   #11,d0                      ; position at 0,28
    move.w  #$001c,d1
    trap    #15

    moveq   #0,d5
    move.l  lane1,d0
    cmp.w   #0,donkeyLane
    bne     .displayLane1
    moveq   #1,d5                       ; this is the lane the donkey is in so a collision check might be needed
.displayLane1:
    bsr     DisplayLaneMask

    moveq   #0,d5
    move.l  lane2,d0
    cmp.w   #1,donkeyLane
    bne     .displayLane2
    moveq   #1,d5                       ; this is the lane the donkey is in so a collision check might be needed
.displayLane2:
    bsr     DisplayLaneMask

    moveq   #0,d5
    move.l  lane3,d0
    cmp.w   #2,donkeyLane
    bne     .displayLane3
    moveq   #1,d5                       ; this is the lane the donkey is in so a collision check might be needed
.displayLane3:
    bsr     DisplayLaneMask

    bsr     DisplayGameFlags
    bsr     DisplayBananaCount

    rts

DisplayLaneMask:                        ; print the long word in d0 as binary with leading zeros
    move.l  d0,d4
    moveq   #31,d3

.loop:
    btst    d3,d4
    beq     .noBit

    move.l  #COLOUR_RED,d1
    cmp.b   #1,d5
    bne     .setBackground
    btst    #1,gameFlags
    beq     .setBackground
    move.l  #COLOUR_GREEN,d1
.setBackground:
    jsr     SetBackgroundColour

    moveq   #6,d0
    moveq   #'+',d1
    trap    #15
    bra     .nextBit

.noBit:
    move.l  #COLOUR_BLUE,d1
    jsr     SetBackgroundColour
    
    moveq   #0,d0
    moveq   #0,d1
    move.l  d3,d0
    divu    #10,d0
    swap    d0
    move.w  d0,d1

    moveq   #15,d0
    moveq   #10,d2
    trap    #15

.nextBit:
    dbra    d3,.loop

    moveq   #6,d0
    moveq   #13,d1
    trap    #15
    moveq   #10,d1
    trap    #15
    rts

DisplayGameFlags:
    moveq   #11,d0
    move.w  #$321c,d1                   ; position at 50,28
    trap    #15

    move.b  gameFlags,d2
    moveq   #7,d3
.bitLoop:
    moveq   #'0',d1
    btst    d3,d2
    beq.s   .outputBit
    moveq   #'1',d1
.outputBit:
    moveq   #6,d0
    trap    #15
    dbra    d3,.bitLoop
    rts

DisplayBananaCount:
    moveq   #11,d0
    move.w  #$3c1c,d1                   ; position at 60,28
    trap    #15

    moveq   #15,d0
    move.w  bananaCount,d1
    moveq   #10,d2
    trap    #15
    rts