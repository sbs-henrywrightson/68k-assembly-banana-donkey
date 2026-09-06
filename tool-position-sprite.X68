*-----------------------------------------------------------
* Title      : tool-position-sprite
* Written by : Henry Wrightson
* Date       : 17/8/2026
* Type       : Include file
* Description: Sub-routines used for positioning a sprite
*-----------------------------------------------------------

;====================================================
;===                                              ===
;===               Position Sprites               ===
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
    jsr     Trap15RepaintScreen

    jsr     RestoreDirtyRectangle
    bsr     MoveSprite
    bra     .moveLoop
    rts

MoveSprite:
    bsr     SetMoveAmount
    bsr     SetScaleAmount
    bsr     SetSpriteScale
    bsr     SetSpriteFlip

    move.l  #$25272628,d1  ; check for keypress Left, Right, Up, Down    
    jsr     Trap15KeyPressCheck

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
    move.l  #$10,d1       ; Shift
    jsr     Trap15KeyPressCheck
    tst.b   d1
    bne    .smallMove
    move.w  #10,moveAmount
    rts
.smallMove:
    move.w  #1,moveAmount
    rts

SetScaleAmount:
    move.l  #$11,d1       ; CTRL
    jsr     Trap15KeyPressCheck
    tst.b   d1
    bne    .smallMove
    move.w  #10,scaleAmount
    rts
.smallMove:
    move.w  #1,scaleAmount
    rts

SetSpriteScale:
    move.l  #$00006B6D,d1  ; check for keypress + and -    
    jsr     Trap15KeyPressCheck
    
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
    move.l  #$46,d1       ; f key
    jsr     Trap15KeyPressCheck
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
    jsr     Trap15ZeroCursor    ; position at 0,0
    
    lea     positionText,a1     ; position message
    jsr     Trap15DisplayText

    move.w  posX,d1             ; x-coord
    jsr     Trap15DisplayDecimal

    move.b  #',',d1             ; comma
    jsr     Trap15DisplayChar

    move.w  posY,d1             ; y-coord
    jsr     Trap15DisplayDecimal

    lea     spacerText,a1       ; spacer
    jsr     Trap15DisplayText

    lea     scaleText,a1        ; scale message
    jsr     Trap15DisplayText

    move.w  scale,d1            ; scale
    jsr     Trap15DisplayDecimal

    lea     spacerText,a1       ; spacer
    jsr     Trap15DisplayText

    lea     flipText,a1         ; flip message
    jsr     Trap15DisplayText

    move.w  flip,d1             ; flip
    jsr     Trap15DisplayDecimal

    lea     cleanEndText,a1     ; output some spaces at the end
    jsr     Trap15DisplayText
    
    rts
