*-----------------------------------------------------------
* Title      : banana-donkey
* Written by : Henry Wrightson
* Date       : 16/8/2026
* Type       : Program file
* Depends on : constants.x68, graphics.x68, triangles.x68
*            : bresenham-line.x68
* Description: A complete rip-off of Parachute; the 80s Nintendo
*            : Game 'N Watch game but this time it's a monkey
*            : throwing banana's from a tree and you're catching
*            : them in a basket on the back of a donkey
*-----------------------------------------------------------
    org     $1000
    

Start:
    bsr     SetScreenRes
    
*    move.l  #COLOUR_GREEN,fillColour
*    move.l  #COLOUR_WHITE,outlineColour
*        
*    move.l  #((65<<16)|40),trianglePoints
*    move.l  #((90<<16)|90),trianglePoints+4
*    move.l  #((40<<16)|90),trianglePoints+8
*    bsr     DrawFilledTriangle
    
    bsr     DrawPalmTree
    
    bra     Finish

* /========================================================\
* |                                                        |
* |                          GAME                          |
* |                                                        |
* \========================================================/
DrawPalmTree:
    lea     palmTree,a3
    moveq   #0,d4
    move.b  (a3)+,d4    ; loop counter
    subq    #1,d4
.Loop:
    bsr     GetTrianglePoint
    move.l  d0,trianglePoints
    bsr     GetTrianglePoint
    move.l  d0,trianglePoints+4
    bsr     GetTrianglePoint
    move.l  d0,trianglePoints+8
    
    ;bsr     DisplayTrianglePoints
    
    move.b  (a3)+,red
    move.b  (a3)+,green
    move.b  (a3)+,blue
    bsr     MoveRGBToD1
    move.l  d1,fillColour

    move.b  (a3)+,red
    move.b  (a3)+,green
    move.b  (a3)+,blue
    bsr     MoveRGBToD1
    move.l  d1,outlineColour
    
    bsr     DrawFilledTriangle
    
    dbra    d4,.Loop
    
    rts

GetTrianglePoint:   ; load the next two bytes of a3, ($aa,$bb) into d0 as a long ($00aa00bb)
    moveq   #0,d0
    move.b  (a3)+,d0
    lsl.l   #8,d0
    lsl.l   #8,d0
    move.b  (a3)+,d0
    rts

* /========================================================\
* |                                                        |
* |                       TRIANGLES                        |
* |                                                        |
* \========================================================/
DrawFilledTriangle:
    movem.l d4-d7,-(a7)
    
    move.l  fillColour,d1
    bsr     SetPenColour
    
*[sim68k]break
    bsr     BuildTriangle  ; draw a filled triangle
    bsr     DrawScanLines
    
    move.l  outlineColour,d1        ; if the outline colour is different, draw the outline
    cmp.l   fillColour,d1
    beq     .SkipOutline
    bsr     SetPenColour
    bsr     DrawTriangle
.SkipOutline
    movem.l (a7)+,d4-d7
    rts

DrawTriangle:
    move.l  trianglePoints,d0   ; triangle point A
    move.w  d0,d2       ; y0
    swap    d0
    move.w  d0,d1       ; x0
    move.l  trianglePoints+4,d0 ; triangle point B
    move.w  d0,d4       ; y0
    swap    d0
    move.w  d0,d3       ; x0
    moveq   #84,d0      ; line A-B
    trap    #15
    
    move.l  trianglePoints+4,d0 ; triangle point B
    move.w  d0,d2
    swap    d0
    move.w  d0,d1
    move.l  trianglePoints+8,d0 ; triangle point C
    move.w  d0,d4
    swap    d0
    move.w  d0,d3
    moveq   #84,d0      ; line B-C
    trap    #15

    move.l  trianglePoints+8,d0 ; triangle point C
    move.w  d0,d2
    swap    d0
    move.w  d0,d1
    move.l  trianglePoints,d0 ; triangle point A
    move.w  d0,d4
    swap    d0
    move.w  d0,d3
    moveq   #84,d0      ; line C-A
    trap    #15
    rts

BuildTriangle:  ; draw the triangle described by the three sets of (x,y) in trianglePoints
    bsr     ResetScanLines
    
    move.l  trianglePoints,d0   ; triangle point A
    move.w  d0,d5       ; y0
    swap    d0
    move.w  d0,d4       ; x0
    move.l  trianglePoints+4,d0 ; triangle point B
    move.w  d0,d7       ; y0
    swap    d0
    move.w  d0,d6       ; x0
    bsr     MarkLine    ; line A-B
    
    move.l  trianglePoints+4,d0 ; triangle point B
    move.w  d0,d5
    swap    d0
    move.w  d0,d4
    move.l  trianglePoints+8,d0 ; triangle point C
    move.w  d0,d7
    swap    d0
    move.w  d0,d6
    bsr     MarkLine    ; line B-C

    move.l  trianglePoints+8,d0 ; triangle point C
    move.w  d0,d5
    swap    d0
    move.w  d0,d4
    move.l  trianglePoints,d0 ; triangle point A
    move.w  d0,d7
    swap    d0
    move.w  d0,d6
    bsr     MarkLine    ; line A-C
    rts

ResetScanLines:         ; fill the scanLineLeft with max value and scanLineRight with min value
    move.w  #$FFFF,scanLineMinY
    move.w  #$0000,scanLineMaxY
    move.l  trianglePoints,d0   ; triangle point A
    bsr     StoreLowHighY
    move.l  trianglePoints+4,d0 ; triangle point B
    bsr     StoreLowHighY
    move.l  trianglePoints+8,d0 ; triangle point C
    bsr     StoreLowHighY
    
    lea     scanLineLeft,a0
    lea     scanLineRight,a1
    
    move.w  scanLineMinY,d0
    add.w   d0,d0           ; y*2 cos the scanLine lists are words, 1 for each y
    adda.w  d0,a0           ; shift the pointer along so it starts at MinY and not 0
    adda.w  d0,a1
    
    move.w  scanLineMaxY,d0
    sub.w   scanLineMinY,d0
.Loop:
    move.w  #$ffff,(a0)+
    move.w  #$0000,(a1)+
    dbra    d0,.Loop
    rts

StoreLowHighY:              ; store d0.w into scanLineMinY or scanLineMaxY if it's lower or higher
    cmp.w   scanLineMinY,d0
    bhs     .NotLowest
    move.w  d0,scanLineMinY
.NotLowest:
    cmp.w   scanLineMaxY,d0
    bls     .Done
    move.w  d0,scanLineMaxY
.Done:
    rts

DrawScanLines:
    lea     scanLineLeft,a0
    lea     scanLineRight,a1
    
    move.w  scanLineMinY,d0
    add.w   d0,d0           ; double it cos we're adding a word for each MinY
    adda.w  d0,a0           ; shift the pointer along so it starts at MinY and not 0
    adda.w  d0,a1
    
    move.w  scanLineMinY,d5
.Loop
    move.w  (a0)+,d1        ; start-x from the left scan line
    move.w  d5,d2           ; start-y from the counter
    move.w  (a1)+,d3        ; end-x from the right scan line
    move.w  d5,d4           ; end-y from the counter
    
    moveq   #84,d0          ; draw the line between (d1,d2) and (d3,d4)
    trap    #15
    
    addq    #1,d5           ; increment the y-coord
    cmp.w   scanLineMaxY,d5
    bls     .Loop
    rts

DrawScanLineEnds:
    lea     scanLineLeft,a0
    lea     scanLineRight,a1
    
    move.w  scanLineMinY,d0
    add.w   d0,d0           ; double it cos we're adding a word for each MinY
    adda.w  d0,a0           ; shift the pointer along so it starts at MinY and not 0
    adda.w  d0,a1
    
    move.w  scanLineMinY,d5
.Loop
    move.w  (a0)+,d1        ; start-x from the left scan line
    move.w  d5,d2           ; start-y from the counter
    move.w  (a1)+,d3        ; end-x from the right scan line
    move.w  d5,d4           ; end-y from the counter
    
    moveq   #84,d0          ; draw the line between (d1,d2) and (d3,d4)
    trap    #15
    
    addq    #1,d5           ; increment the y-coord
    cmp.w   scanLineMaxY,d5
    bls     .Loop
    rts
    
* /========================================================\
* |                                                        |
* |                    BRESENHAM LINE                      |
* |                                                        |
* \========================================================/
MarkLine:               ; walk along a line from (d4,d5) to (d6,d7) using the Bresenham Algorithm and mark the points in the scanLine lists.
                        ; d2=e2  d3=error d4=x0  d5=y0  d6=x1  d7=y1
    move.w  d6,d0       ; length of line on the x-axis as a positive
    sub.w   d4,d0
    bsr     PositiveD0
    move.w  d0,dx
    
    move.w  d7,d0       ; length of line on the y-axis as a negative
    sub.w   d5,d0
    bsr     NegativeD0
    move.w  d0,dy
    
    move.w  #1,sx
    cmp.w   d6,d4       ; if source x is lower than destination y then move left
    blo     .X0LessThanX1
    move.w  #-1,sx
.X0LessThanX1:
    move.w  #1,sy
    cmp.w   d7,d5       ; if source y is lower than destination y then move down
    blo     .Y0LessThanY1
    move.w  #-1,sy
.Y0LessThanY1:
    move.w  dx,d3       ; the position error how far from the line the current point is
    add.w   dy,d3
    move.w  d4,x        ; start the line at x0,y0
    move.w  d5,y
.Loop:
    bsr.s   MarkPoint   ; mark point (x, y) in the list of scanLines
    
    move.w  d3,d2       ; as the error is measured from the mid-point of the pixel, double it to keep it an integer
    muls.w  #2,d2
.MoveX:
    cmp.w   dy,d2       ; only change the x position is dy is less than the error
    blt     .MoveY
    cmp.w   x,d6        ; if the end of the line on the x-axis has been reached stop
    beq     .EndLoop
    add.w   dy,d3       ; add dy to the error to correct it the other way
    move.w  x,d0        ; move along the x-axis in the direction of travel
    add.w   sx,d0
    move.w  d0,x
.MoveY:
    cmp.w   dx,d2       ; only move along the y-axis if dx is more than or equal to the error
    bge     .Loop
    cmp.w   y,d7        ; if the end of the line on the y-axis has been reached stop
    beq     .EndLoop
    add.w   dx,d3       ; add dx to the error to correct it the other way
    move.w  y,d0        ; move along the y-axis in the direction of travel
    add.w   sy,d0
    move.w  d0,y
    bra     .Loop
.EndLoop:
    rts

PositiveD0:             ; convert d0 to a positive number
    tst.w   d0
    bpl     .Positive
    neg.w   d0
.Positive:
    rts
    
NegativeD0:             ; convert d0 to a negative number
    tst.w   d0
    bmi     .Negative
    neg.w   d0
.Negative:
    rts

MarkPoint:              ; store the x of the line points in the scanLineLeft or scanLineRight array if it's further left or right than what's there already
    lea     scanLineLeft,a0
    lea     scanLineRight,a1
    move.w  x,d0
    move.w  y,d1
    add.w   d1,d1       ; y*2 to get the memory offset of the y coordinate

    cmp.w   (a0,d1.w),d0
    bhs     .NotLeft
    move.w  x,(a0,d1.w)
.NotLeft
    cmp.w   (a1,d1.w),d0
    bls     .NotRight
    move.w  x,(a1,d1.w)
.NotRight
    rts

* /========================================================\
* |                                                        |
* |                       GRAPHICS                         |
* |                                                        |
* \========================================================/
SetScreenRes:           ; set the output window size, minimum 640x480
    move.b  #33,d0
    move.l  #RES_X*$10000+RES_Y,d1
    trap    #15
    rts

ClearScreen:            ; clear the screen
    moveq   #11,d0
    move.w  #$ff00,d1
    trap    #15
    rts

SetPenColour:           ; set pen colour to d1.l ($00BBGGRR)
    moveq   #80,d0
    trap    #15
    rts
    
PlotPoint:              ; plot a point at d1.w,d2.w
    moveq   #82,d0
    trap    #15
    rts

DrawLine:               ; draw a line between (d1.w,d2.w) and (d3.w,d4.w)
    moveq   #84,d0
    trap    #15

MoveRGBToD1:         ; place the colours in Red, Green, Blue variables into d1.l as $00BBGGRR
    moveq   #0,d1
    move.b  blue,d1
    lsl.l   #8,d1
    or.b    green,d1
    lsl.l   #8,d1
    or.b    red,d1
    rts

* /========================================================\
* |                                                        |
* |                     DIAGNOSTICS                        |
* |                                                        |
* \========================================================/
 DisplayTrianglePoints:   
    lea     triangleMessage,a1
    
    move.l  trianglePoints,d3
    bsr     DisplayCoordinate
    
    move.l  trianglePoints+4,d3
    bsr     DisplayCoordinate

    move.l  trianglePoints+8,d3
    bsr     DisplayCoordinate
    rts

DisplayCoordinate:
    moveq   #14,d0  ; message
    trap    #15

    swap    d3      ; x-coord
    move.b  #10,d2  
    moveq   #15,d0  
    moveq   #0,d1
    move.w  d3,d1
    trap    #15
    
    moveq   #6,d0   ; comma
    move.b  #44,d1
    trap    #15
    
    swap    d3      ; y-coord
    move.b  #10,d2  
    moveq   #15,d0  
    moveq   #0,d1
    move.w  d3,d1
    trap    #15
    
    moveq   #6,d0   ; crlf
    move.b  #13,d1
    trap    #15
    moveq   #6,d0
    move.b  #10,d1
    trap    #15
    rts

Finish:
    simhalt

* /========================================================\
* |                                                        |
* |                       CONSTANTS                        |
* |                                                        |
* \========================================================/
; graphics constants
RES_X           equ     650
RES_Y           equ     650

; colour constants all formatted $00BBGGRR
COLOUR_WHITE    equ     $00ffffff   ; white
COLOUR_RED      equ     $000000ff   ; red
COLOUR_GREEN    equ     $000d9c33   ; green

* /========================================================\
* |                                                        |
* |                       VARIABLES                        |
* |                                                        |
* \========================================================/
* diagnostics variables
triangleMessage     dc.b    'Triangle point : ',0

* colour variables
red     dc.b    0
green   dc.b    0
blue    dc.b    0

* triangles variables
scanLineMinY    dc.w    0
scanLineMaxY    dc.w    0

fillColour      dc.l    $00ffffff
outlineColour   dc.l    $00ffffff

; bresenham-line variables
x               dc.w    0
y               dc.w    0
dx              dc.w    0
dy              dc.w    0
sx              dc.w    0
sy              dc.w    0

* /========================================================\
* |                                                        |
* |                         MEMORY                         |
* |                                                        |
* \========================================================/
palmTree:
    dc.b 11
    dc.b 25,118, 71,99, 107,122, 255,212,59,  250,176,5  ; island
    dc.b 64,111,67,77,77,73,156,82,13,129,67,9   ; trunk 1 *
    dc.b    64,111, 77,73, 79,113,  156,82,13,   129,67,9   ; trunk 2
    dc.b    67,77,  54,34, 63,33,   156,82,13,   129,67,9   ; trunk 3 *
    dc.b    67,77,  63,33, 77,73,   156,82,13,   129,67,9   ; trunk 4
    dc.b    63,40,  88,43, 93,77,   71,200,25,   51,156,13  ; leaf 1
    dc.b    63,37,  93,24, 107,43,  71,200,25,   51,156,13  ; leaf 2
    dc.b    60,37,  63,12, 92,5,    71,200,25,   51,156,13  ; leaf 3 *
    dc.b    58,36,  48,12, 19,13,   71,200,25,   51,156,13  ; leaf 4 *
    dc.b    58,38,  28,30, 16,50,   71,200,25,   51,156,13  ; leaf 5
    dc.b    60,40,  30,53, 33,80,   71,200,25,   51,156,13  ; leaf 6
    dc.b    0   ; make it even

* /========================================================\
* |                                                        |
* |                      STRUCTURES                        |
* |                                                        |
* \========================================================/
* triangle structures
trianglePoints  ds.l    3                   ; the three points of a triangle, (x=high byte, y=low byte)

* bresenham-line buffers
scanLineLeft    ds.w    RES_Y               ; the start positions of the scan-lines needed to make the filled polygon. The offset is the y and the value is the x
scanLineRight   ds.w    RES_Y               ; the end positions of the scan-lines needed to make the filled polygon. The offset is the y and the value is the x
    end     Start
    
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
