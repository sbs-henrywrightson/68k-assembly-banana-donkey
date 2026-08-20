*-----------------------------------------------------------
* Title      : sprites
* Written by : Henry Wrightson
* Date       : 16/8/2026
* Type       : Include file
* Depends on : polygons.x68
* Description: routines for displaying various sprites
*-----------------------------------------------------------

BuildSprites:
    ; TEST SQUARE
    lea     testSquare,a3
    bsr     FindSpriteSize
    move.w  spriteSize,testSquareSpriteSize

    ; TEST TRIANGLE
    lea     testTriangle,a3
    bsr     FindSpriteSize
    move.w  spriteSize,testTriangleSpriteSize

    ; TEST HEXAGON
    lea     testHexagon,a3
    bsr     FindSpriteSize
    move.w  spriteSize,testHexagonSpriteSize

    ; TEST SHAPE
    lea     testShape,a3
    bsr     FindSpriteSize
    move.w  spriteSize,testShapeSpriteSize

    ; PALM TREE
    lea     palmTree,a3
    bsr     FindSpriteSize
    move.w  spriteSize,palmTreeSpriteSize
    
    rts

DrawPalmTree:
    lea     palmTree,a3
    bsr     DrawSprite
    rts

ClearPalmTree:
    move.w  palmTreeSpriteSize,spriteSize
    bsr     ClearSprite
    rts    

DrawSprite:
    moveq   #0,d2
    move.b  (a3)+,d2    ; loop counter
    subq    #1,d2

.PolygonLoop:
    lea     vertices,a0
    moveq   #0,d1
    move.b  (a3)+,d1    ; d1=number of vertices
    move.w  d1,(a0)+
    subq    #1,d1
.VertexLoop:
    bsr     GetVertex
    move.l  d0,(a0)+    ; add vertex to list of vertices
    dbra    d1,.VertexLoop
    
    moveq   #0,d0
    move.b  (a3)+,d0
    swap    d0
    move.b  (a3)+,d0
    lsl.w   #8,d0
    move.b  (a3)+,d0
    move.l  d0,fillColour

    moveq   #0,d0
    move.b  (a3)+,d0
    swap    d0
    move.b  (a3)+,d0
    lsl.w   #8,d0
    move.b  (a3)+,d0
    move.l  d0,outlineColour
    
    bsr     DrawFilledPolygon
    
    dbra    d2,.PolygonLoop
    
    rts
    
GetVertex:          ; load the next two bytes of a3, ($aa,$bb) into d0 as a long ($00aa00bb)
    moveq   #0,d0
    move.b  (a3)+,d0
    bsr     ScaleNumber
    swap    d0
    move.b  (a3)+,d0
    bsr     ScaleNumber
    add.l   spriteOrigin,d0
    rts

ScaleNumber:        ; scale d0 by spriteScale%
    move.w  d0,d5
    mulu    spriteScale,d5
    divu    #100,d5
    move.w  d5,d0
    rts

ClearSprite:
    move.l  #COLOUR_BACKGROUND,d1
    bsr     SetBackgroundColour
    
    move.l  #COLOUR_BACKGROUND,d1
    bsr     SetPenColour
    
    moveq   #0,d1
    moveq   #0,d2
    moveq   #0,d3
    moveq   #0,d4

    move.w  spriteOrigin,d1
    move.w  spriteOrigin+2,d2

    move.w  d1,d3
    move.w  #0,d0
    move.b  spriteSize,d0
    bsr     scaleNumber
    add.w   d0,d3

    move.w  d1,d4
    move.w  #0,d0
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
    
.PolygonLoop:
    moveq   #0,d1
    move.b  (a3)+,d1            ; number of vertices
    subq    #1,d1
.VertexLoop:
    moveq   #0,d2
    move.b  (a3)+,d2            ; x
    cmp.b   spriteSize,d2       ; check for highest x
    bls     .NotHighestX
    move.b  d2,spriteSize
.NotHighestX:
    move.b  (a3)+,d2            ; y
    cmp.b   spriteSize+1,d2     ; check for highest y
    bls     .NotHighestY
    move.b  d2,spriteSize+1
.NotHighestY:
    dbra    d1,.VertexLoop

    adda.w  #6,a3
    dbra    d0,.PolygonLoop
    rts

;====================================================
;================= sprites variables ================
;====================================================
spriteSize      dc.w    $0000       ; $wwhh
spriteOrigin    dc.l    $00000000   ; $xxxxyyyy
spriteScale     dc.w    100         ; scale percentage; 100%

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
