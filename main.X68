*-----------------------------------------------------------
* Title      : main
* Written by : Henry Wrightson
* Date       : 20/8/2026
* Type       : Include file
* Depends on : 
* Description: The main entry point to the game
*-----------------------------------------------------------

Main:
    ;bsr     PositionSprite
    bsr     DrawBackdrop
    bsr     DrawBackLayer
    bsr     DrawFrontLayer
    bsr     RepaintScreen
    
    rts
    
DrawBackdrop:
    ; SKY
    move.l  #$0070c1ff,d1        ; fill
    bsr     SetBackgroundColour
    move.l  #$0070c1ff,d1        ; outline
    bsr     SetPenColour
    moveq   #87,d0
    move.w  #0,d1       ; x0
    move.w  #0,d2       ; y0
    move.w  #650,d3   ; x1
    move.w  #149,d4      ; y1
    trap    #15

    ; DESERT
    move.l  #$00ffe894,d1        ; fill
    bsr     SetBackgroundColour
    move.l  #$00ffe894,d1        ; outline
    bsr     SetPenColour
    moveq   #87,d0
    move.w  #0,d1       ; x0
    move.w  #150,d2      ; y0
    move.w  #650,d3   ; x1
    move.w  #340,d4   ; y1
    trap    #15

    ; SEA
    move.l  #$00002ee6,d1        ; fill
    bsr     SetBackgroundColour
    move.l  #$00002ee6,d1        ; outline
    bsr     SetPenColour
    moveq   #87,d0
    move.w  #0,d1       ; x0
    move.w  #340,d2   ; y0
    move.w  #650,d3   ; x1
    move.w  #480,d4   ; y1
    trap    #15

    rts

DrawBackLayer:
    SetSprite sandDune,sandDuneSpriteSize,#0,#230,#140,#0
    bsr     DrawSprite

    SetSprite sandDune,sandDuneSpriteSize,#400,#240,#100,#0
    bsr     DrawSprite
    rts

DrawFrontLayer:
    SetSprite palmTree,palmTreeSpriteSize,#20,#100,#85,#1
    bsr     DrawSprite

    SetSprite palmTree,palmTreeSpriteSize,#80,#150,#65,#0
    bsr     DrawSprite

    SetSprite palmTree,palmTreeSpriteSize,#430,#70,#100,#0
    bsr     DrawSprite

    SetSprite seaFoam,seaFoamSpriteSize,#0,#322,#100,#0
    bsr     DrawSprite

    SetSprite seaFoam,seaFoamSpriteSize,#215,#326,#80,#0
    bsr     DrawSprite

    SetSprite seaFoam,seaFoamSpriteSize,#395,#325,#100,#2
    bsr     DrawSprite

    rts

PositionSprite:
    move.w  #220,posX
    move.w  #320,posY
    move.w  #100,scale
    move.w  #0,flip
    
.MoveLoop:
    bsr     DrawBackdrop
    bsr     DrawBackLayer

    SetSprite seaFoam,seaFoamSpriteSize,posX,posY,scale,flip
    bsr     DrawSprite

    bsr     OutputInfo
    bsr     DrawFrontLayer

    bsr     RepaintScreen

    bsr     ClearScreen
    bsr     MoveSprite
    bra     .MoveLoop
    
MoveSprite:
    bsr     SetMoveAmount
    bsr     SetScaleAmount
    bsr     SetSpriteScale
    bsr     SetSpriteFlip

.Continue
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
    rts
.Right:
    move.w  posX,d0
    add.w   moveAmount,d0
    move.w  d0,posX
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
.SmallMove
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
.SmallMove
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

.Plus
    move.w  scale,d0
    add.w   scaleAmount,d0
    move.w  d0,scale
    rts
.Minus
    move.w  scale,d0
    sub.w   scaleAmount,d0
    cmp.w   #1,d0
    blo     .DontShrink
    move.w  d0,scale
.DontShrink
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
.ResetFlip
    move.w  #0,flip
.DontFlip
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

moveAmount      dc.w    1
scaleAmount     dc.w    1
posX            dc.w    0
posY            dc.w    0
cleanEnd        dc.b    '   ',0
positionMessage dc.b    'Position: ',0
scaleMessage    dc.b    'Scale: ',0
flipMessage     dc.b    'Flip: ',0
spacer          dc.b    '   -   ',0
flip            dc.w    0
scale           dc.w    100
