*-----------------------------------------------------------
* Title      : diagnostics
* Written by : Henry Wrightson
* Date       : 17/8/2026
* Type       : Program file
* Depends on : 
* Description: Sub-routines used for debugging the main app
*-----------------------------------------------------------

;====================================================
;============== Performance Diagnostics =============
;====================================================
ClearCycleCounter:
    moveq   #30,d0
    trap    #15
    rts

DisplayCycleCounter:
    moveq   #31,d0
    trap    #15

    lea     cycleMessage,a1
    moveq   #14,d0
    trap    #15
    
    moveq   #15,d0
    moveq   #10,d2
    trap    #15
    rts

;====================================================
;================= Sprite Diagnostics ===============
;====================================================
PositionSprite:
    move.w  #180,posX
    move.w  #340,posY
    move.w  #32,scale
    move.w  #0,flip

    jsr     ClearScreen
    jsr     DrawBackdrop
    jsr     DrawSceneSprites
    ;bsr     DrawGrid

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
    move.l  #$25<<24+$27<<16+$26<<8+$28,d1  ; check for keypress Left, Right, Up, Down    
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
    move.l  #$6B<<8+$6D,d1  ; check for keypress + and -    
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
    lea     positionMessage,a1
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
    lea     spacer,a1
    trap    #15

    moveq   #14,d0      ; scale message
    lea     scaleMessage,a1
    trap    #15

    moveq   #15,d0      ; scale
    move.w  scale,d1
    trap    #15

    moveq   #14,d0      ; spacer
    lea     spacer,a1
    trap    #15

    moveq   #14,d0      ; flip message
    lea     flipMessage,a1
    trap    #15

    moveq   #15,d0      ; flip
    move.w  flip,d1
    trap    #15

    moveq   #14,d0      ; output some spaces at the end
    lea     cleanEnd,a1
    trap    #15
    
    rts

DrawGrid:
    moveq   #31,d6

.horizontalLoop:
    move.l  #COLOUR_GREY,d1
    jsr     SetPenColour
    
    ;draw lines across the screen for the bananas vertical movement
    move.w  d6,d5
    mulu    #11,d5

    move.w  #0,d1
    move.w  d5,d2
    move.w  #RES_X,d3
    move.w  d5,d4
    jsr     DrawLine

    SetFontSize #1,#0

    move.w  #200,digitPlotX
    move.w  d5,digitPlotY
    addq    #5,digitPlotY
    move.w  d6,d0
    bsr     PlotNumber

    move.w  #300,digitPlotX
    move.w  d5,digitPlotY
    addq    #5,digitPlotY
    move.w  d6,d0
    bsr     PlotNumber
    
    move.w  #400,digitPlotX
    move.w  d5,digitPlotY
    addq    #5,digitPlotY
    move.w  d6,d0
    bsr     PlotNumber

    dbra    d6,.horizontalLoop

    ;draw three lines for the three banana lanes
    move.w  #200,d1
    move.w  #0,d2
    move.w  #200,d3
    move.w  #RES_Y,d4
    jsr     DrawLine

    move.w  #300,d1
    move.w  #300,d3
    jsr     DrawLine

    move.w  #400,d1
    move.w  #400,d3
    jsr     DrawLine
    rts