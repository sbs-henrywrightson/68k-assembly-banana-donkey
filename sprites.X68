*-----------------------------------------------------------
* Title      : sprites
* Written by : Henry Wrightson
* Date       : 16/8/2026
* Type       : Include file
* Depends on : polygons.x68
* Description: routines for displaying various sprites
*-----------------------------------------------------------

;====================================================
;================ Sprites Sub-routines ==============
;====================================================
GetSpriteSizes:
    lea     palmTree,a3         ; PALM TREE
    bsr     FindSpriteSize
    move.w  spriteSize,palmTreeSpriteSize

    lea     sandDune,a3         ; SAND DUNE
    bsr     FindSpriteSize
    move.w  spriteSize,sandDuneSpriteSize

    lea     seaFoam,a3          ; SEA FOAM
    bsr     FindSpriteSize
    move.w  spriteSize,seaFoamSpriteSize

    lea     banana,a3           ; BANANA
    bsr     FindSpriteSize
    move.w  spriteSize,bananaSpriteSize

    lea     hillLeft,a3         ; HILL LEFT
    bsr     FindSpriteSize
    move.w  spriteSize,hillLeftSpriteSize

    lea     hillRight,a3        ; HILL RIGHT
    bsr     FindSpriteSize
    move.w  spriteSize,hillRightSpriteSize

    lea     donkey,a3           ; DONKEY
    bsr     FindSpriteSize
    move.w  spriteSize,donkeySpriteSize

    lea     monkey,a3           ; MONKEY
    bsr     FindSpriteSize
    move.w  spriteSize,monkeySpriteSize

    lea     cloud,a3            ; CLOUD
    bsr     FindSpriteSize
    move.w  spriteSize,cloudSpriteSize
    rts 

DrawSprite:
    CacheRegisters

    moveq   #0,d2
    move.b  (a3)+,d2            ; loop counter
    subq    #1,d2

.polygonLoop:
    lea     vertices,a0
    moveq   #0,d1
    move.b  (a3)+,d1            ; d1=number of vertices
    move.w  d1,(a0)+
    subq    #1,d1
.vertexLoop:
    bsr     GetVertex
    move.l  d0,(a0)+            ; add vertex to list of vertices
    dbra    d1,.vertexLoop
    
    bsr     ReadSpriteColour
    move.l  d0,fillColour

    bsr     ReadSpriteColour
    move.l  d0,outlineColour
    
    jsr     DrawFilledPolygon
    
    dbra    d2,.polygonLoop
    
    RestoreRegisters
    rts

ReadSpriteColour:
    moveq   #0,d0
    move.b  (a3)+,d0
    swap    d0
    move.b  (a3)+,d0
    lsl.w   #8,d0
    move.b  (a3)+,d0
    rts

GetVertex:                      ; load the next two bytes of a3, ($aa,$bb) into d0 as a long ($00aa00bb)
    move.b  (a3)+,spriteX
    move.b  (a3)+,spriteY
    bsr     FlipVertex

    moveq   #0,d0
    move.b  spriteX,d0
    bsr     ScaleNumber
    swap    d0
    move.b  spriteY,d0
    bsr     ScaleNumber

    add.l   spriteOrigin,d0
    rts

ScaleNumber:                    ; scale d0 by spriteScale%
    move.w  d0,d5
    mulu    spriteScale,d5
    divu    #100,d5
    move.w  d5,d0
    rts

FlipVertex:
    move.w  spriteFlip,d0

    btst    #0,d0
    beq.s   .noX
    move.b  spriteSize,d5
    sub.b   spriteX,d5
    move.b  d5,spriteX
.noX:
    btst    #1,d0
    beq.s   .noY
    move.b  spriteSize+1,d5
    sub.b   spriteY,d5
    move.b  d5,spriteY
.noY:
    rts

BlankSprite:
    move.l  #COLOUR_GREEN,d1
    jsr     SetBackgroundColour
    
    move.l  #COLOUR_WHITE,d1
    jsr     SetPenColour
    
    moveq   #0,d1
    moveq   #0,d2
    moveq   #0,d3
    moveq   #0,d4

    move.w  spriteOrigin,d1
    move.w  spriteOrigin+2,d2

    move.w  d1,d3
    moveq   #0,d0
    move.b  spriteSize,d0
    bsr     scaleNumber
    add.w   d0,d3

    move.w  d2,d4
    moveq   #0,d0
    move.b  spriteSize+1,d0
    bsr     scaleNumber
    add.w   d0,d4

    moveq   #87,d0
    trap    #15
    
    rts

FindSpriteSize:
    move.l  #0,spriteSize
    moveq   #0,d0
    move.b  (a3)+,d0            ; number of polygons in sprite
    subq    #1,d0
    
.polygonLoop:
    moveq   #0,d1
    move.b  (a3)+,d1            ; number of vertices
    subq    #1,d1
.vertexLoop:
    moveq   #0,d2
    move.b  (a3)+,d2            ; x
    cmp.b   spriteSize,d2       ; check for highest x
    bls     .notHighestX
    move.b  d2,spriteSize
.notHighestX:
    move.b  (a3)+,d2            ; y
    cmp.b   spriteSize+1,d2     ; check for highest y
    bls     .notHighestY
    move.b  d2,spriteSize+1
.notHighestY:
    dbra    d1,.vertexLoop

    adda.w  #6,a3
    dbra    d0,.polygonLoop
    rts

************************************************************
* SaveDirtyRectangle register contract
************************************************************
* d0 = trap15-task
* d1 = trap15-x
* d2 = trap15-y
* d3 = sprite-width-scaled
* d4 = sprite-height-scaled
* d5 = x-counter
* d6 = y-counter
************************************************************
SaveDirtyRectangle:             ; save the colour of the pixels in the dirty rectangle of a sprite
    moveq   #0,d7
    bsr     ProcessDirtyPixels
    rts

************************************************************
* RestoreDirtyRectangle register contract
************************************************************
* d0 = trap15-task
* d1 = trap15-x
* d2 = trap15-y
* d3 = sprite-width-scaled
* d4 = sprite-height-scaled
* d5 = x-counter
* d6 = y-counter
************************************************************
RestoreDirtyRectangle:          ; restore the colour of the pixels in the dirty rectangle of a sprite
    moveq   #1,d7
    bsr     ProcessDirtyPixels
    rts

**********************************************
* ProcessDirtyPixels register contract
**********************************************
* d0 = trap15-task
* d1 = trap15-x
* d2 = trap15-y
* d3 = sprite-width-scaled
* d4 = sprite-height-scaled
* d5 = x-counter
* d6 = y-counter
* d7 = save/restore flag - 0=save, 1=restore, 
**********************************************
ProcessDirtyPixels:             ; save the colour of the pixels in the dirty rectangle of a sprite
    CacheDataRegisters

    bsr     LoadDirtyBuffer

    moveq   #0,d0               ; trap15-task
    moveq   #0,d1               ; trap15-x
    moveq   #0,d2               ; trap15-y
    moveq   #0,d3               ; sprite-width-scaled
    moveq   #0,d4               ; sprite-height-scaled
    moveq   #0,d5               ; x-counter
    moveq   #0,d6               ; y-counter

    move.b  spriteSize,d0       ; width of sprite
    bsr     ScaleNumber
    move.w  d0,d3

    move.b  spriteSize+1,d0     ; height of sprite
    bsr     ScaleNumber
    move.w  d0,d4

    move.w  d4,d6               ; set y-counter to sprite-height-scaled
.heightLoop:                    ; loop over the y-axis from high to low
    move.w  d6,d2               ; set trap15-y to y-counter
    add.w   spriteOrigin+2,d2   ; add the y-offset to trap15-y
    move.l  d3,d5               ; reset the x-counter to sprite-width-scaled
.widthLoop:                     ; loop over the x-axis from right to left
    tst.b   d7
    bne     .restore
.save:                          ; save pixel into dirty rectangle buffer
    move.w  d5,d1               ; set trap15-x to x-counter
    add.w   spriteOrigin,d1     ; add the x-offset to trap15-x
    
    moveq   #83,d0              ; get the pixel colour of the pixel at trap15-x,trap15-y
    trap    #15

    move.l  d0,(a0)+            ; store the pixel in the buffer
    bra     .nextPixel

.restore:                       ; restore pixel from dirty rectangle buffer onto screen
    move.l  (a0)+,d1            ; get the pixel colour from the buffer
    moveq   #80,d0              ; set the pen colour
    trap    #15

    move.w  d5,d1               ; set trap15-x to x-counter
    add.w   spriteOrigin,d1     ; add the x-offset to trap15-x
    
    moveq   #82,d0              ; draw a pixel at trap15-x,trap15-y
    trap    #15

.nextPixel:
    dbra    d5,.widthLoop
    dbra    d6,.heightLoop

    RestoreDataRegisters
    rts

LoadDirtyBuffer:
    move.w  spriteDBNumber,d0
    mulu.w  #SPRITE_BUFFER_OFFSET,d0
    lea     dirtyRectangleBuffer,a0
    adda.l  d0,a0
    rts

