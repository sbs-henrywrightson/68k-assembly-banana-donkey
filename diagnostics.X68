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

TestFrameRate:
    move.w  #50,posX
    move.w  #50,posY
    move.w  #20,scale
    move.w  #0,flip
    
    bsr     ClearScreen
    bsr     DrawBackdrop
    bsr     DrawSceneSprites
    bsr     RepaintScreen

.MoveLoop:
    move.b   maxSprites,spriteCounter
.SaveDirty:
    bsr     ShiftSprite
    SetSprite banana,bananaSpriteSize,spriteCounter,posX,posY,scale,flip
    bsr     SaveDirtyRectangle
    bsr     DecrementSpriteCounter
    tst.b   spriteCounter
    bne     .SaveDirty

    move.b  maxSprites,spriteCounter
.Unshift1:
    bsr     UnshiftSprite
    bsr     DecrementSpriteCounter
    tst.b   spriteCounter
    bne     .Unshift1

    move.b   maxSprites,spriteCounter
.DrawSprites:
    bsr     ShiftSprite
    SetSprite banana,bananaSpriteSize,spriteCounter,posX,posY,scale,flip
    bsr     DrawSprite
    bsr     DecrementSpriteCounter
    tst.b   spriteCounter
    bne     .DrawSprites

    move.b   maxSprites,spriteCounter
.Unshift2:
    bsr     UnshiftSprite
    bsr     DecrementSpriteCounter
    tst.b   spriteCounter
    bne     .Unshift2

    bsr     OutputInfo
    bsr     RepaintScreen       ; display the current screen before removing all the sprites

    move.b   maxSprites,spriteCounter
.RestoreDirty:
    bsr     ShiftSprite
    SetSprite banana,bananaSpriteSize,spriteCounter,posX,posY,scale,flip
    bsr     RestoreDirtyRectangle
    bsr     DecrementSpriteCounter
    tst.b   spriteCounter
    bne     .RestoreDirty

    move.b   maxSprites,spriteCounter
.Unshift3:
    bsr     UnshiftSprite
    bsr     DecrementSpriteCounter
    tst.b   spriteCounter
    bne     .Unshift3
    
    bsr     MoveSprite
    bra     .MoveLoop
    rts

DecrementSpriteCounter:
    moveq   #0,d0
    move.b  spriteCounter,d0
    sub.b   #1,d0
    move.b  d0,spriteCounter
    rts

ShiftSprite:
    moveq   #0,d0
    move.w  posX,d0
    add.w   #5,d0
    move.w  d0,posX
    moveq   #0,d0
    move.w  posY,d0
    add.w   #5,d0
    move.w  d0,posY
    rts
UnshiftSprite:
    moveq   #0,d0
    move.w  posX,d0
    sub.w   #5,d0
    move.w  d0,posX
    moveq   #0,d0
    move.w  posY,d0
    sub.w   #5,d0
    move.w  d0,posY
    rts

;====================================================
;================= Sprite Diagnostics ===============
;====================================================
PositionSprite:
    move.w  #50,posX
    move.w  #50,posY
    move.w  #30,scale
    move.w  #0,flip

    bsr     ClearScreen
    bsr     DrawBackdrop
    bsr     DrawSceneSprites

.MoveLoop:
    SetSprite banana,bananaSpriteSize,#0,posX,posY,scale,flip
    bsr     SaveDirtyRectangle
    bsr     DrawSprite    
    bsr     OutputInfo
    bsr     RepaintScreen

    bsr     RestoreDirtyRectangle
    bsr     MoveSprite
    bra     .MoveLoop
    rts

MoveSprite:
    bsr     SetMoveAmount
    bsr     SetScaleAmount
    bsr     SetSpriteScale
    bsr     SetSpriteFlip

.Continue:
    moveq   #19,d0
    move.l  #$25<<24+$27<<16+$26<<8+$28,d1  ; check for keypress Left, Right, Up, Down    
    trap    #15

    btst.l  #24,d1
    bne     .Left

    btst.l  #16,d1
    bne     .Right
    
    btst.l  #8,d1
    bne     .Up
    
    btst.l  #0,d1
    bne     .Down
    rts

.Left:
    move.w  posX,d0
    sub.w   moveAmount,d0
    move.w  d0,posX
    moveq   #0,d0
    move.w  d0,flip
    rts
.Right:
    move.w  posX,d0
    add.w   moveAmount,d0
    move.w  d0,posX
    moveq   #1,d0
    move.w  d0,flip
    rts
.Up:
    move.w  posY,d0
    sub.w   moveAmount,d0
    move.w  d0,posY
    rts
.Down:
    move.w  posY,d0
    add.w   moveAmount,d0
    move.w  d0,posY
    rts

SetMoveAmount:
    moveq   #19,d0
    move.l  #$10,d1       ; Shift
    trap    #15
    tst.b   d1
    bne    .SmallMove
    move.w  #10,moveAmount
    rts
.SmallMove:
    move.w  #1,moveAmount
    rts

SetScaleAmount:
    moveq   #19,d0
    move.l  #$11,d1       ; CTRL
    trap    #15
    tst.b   d1
    bne    .SmallMove
    move.w  #10,scaleAmount
    rts
.SmallMove:
    move.w  #1,scaleAmount
    rts

SetSpriteScale:
    moveq   #19,d0
    move.l  #$6B<<8+$6D,d1  ; check for keypress + and -    
    trap    #15
    
    btst.l  #8,d1
    bne     .Plus
    
    btst.l  #0,d1
    bne     .Minus
    rts

.Plus:
    move.w  scale,d0
    add.w   scaleAmount,d0
    move.w  d0,scale
    rts
.Minus:
    move.w  scale,d0
    sub.w   scaleAmount,d0
    cmp.w   #1,d0
    blo     .DontShrink
    move.w  d0,scale
.DontShrink:
    rts

SetSpriteFlip:
    moveq   #19,d0
    move.l  #$46,d1       ; f key
    trap    #15
    tst.b   d1
    beq     .DontFlip
    add.w   #1,flip
    cmp.w   #4,flip
    beq     .ResetFlip
    rts
.ResetFlip:
    move.w  #0,flip
.DontFlip:
    rts

OutputInfo:
    moveq   #10,d2

    moveq   #11,d0      ; position at 0,0
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