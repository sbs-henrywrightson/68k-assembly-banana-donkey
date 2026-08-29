*-----------------------------------------------------------
* Title      : bresenham-triangle-fill
* Written by : Henry Wrightson
* Date       : 16/8/2026
* Type       : Include file
* Depends on : constants.x68, graphics.x68
* Description: Create a filled triangle by walking along the
*            : Y-axis of a triangle with the Bresenham algorithm
*            : and recording the left and right most points to
*            : later go along that list and draw lines between them
*            : to create a filled triangle
*-----------------------------------------------------------

;====================================================
;=================== Bresenham Line =================
;====================================================
MarkLine:               ; walk along a line from (d4,d5) to (d6,d7) using the Bresenham Algorithm and mark the points in the scanLine lists. d2=e2  d3=error d4=x0  d5=y0  d6=x1  d7=y1
    CacheRegisters
    
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
    blo     .x0LessThanX1
    move.w  #-1,sx
.x0LessThanX1:
    move.w  #1,sy
    cmp.w   d7,d5       ; if source y is lower than destination y then move down
    blo     .y0LessThanY1
    move.w  #-1,sy
.y0LessThanY1:
    move.w  dx,d3       ; the position error how far from the line the current point is
    add.w   dy,d3
    move.w  d4,x        ; start the line at x0,y0
    move.w  d5,y
.loop:
    bsr     MarkPoint   ; mark point (x, y) in the list of scanLines
    
    move.w  d3,d2       ; as the error is measured from the mid-point of the pixel, double it to keep it an integer
    muls.w  #2,d2
.moveX:
    cmp.w   dy,d2       ; only change the x position is dy is less than the error
    blt     .moveY
    cmp.w   x,d6        ; if the end of the line on the x-axis has been reached stop
    beq     .endLoop
    add.w   dy,d3       ; add dy to the error to correct it the other way
    move.w  x,d0        ; move along the x-axis in the direction of travel
    add.w   sx,d0
    move.w  d0,x
.moveY:
    cmp.w   dx,d2       ; only move along the y-axis if dx is more than or equal to the error
    bge     .loop
    cmp.w   y,d7        ; if the end of the line on the y-axis has been reached stop
    beq     .endLoop
    add.w   dx,d3       ; add dx to the error to correct it the other way
    move.w  y,d0        ; move along the y-axis in the direction of travel
    add.w   sy,d0
    move.w  d0,y
    bra     .loop
.endLoop:
    RestoreRegisters
    rts

PositiveD0:             ; convert d0 to a positive number
    tst.w   d0
    bpl     .positive
    neg.w   d0
.positive:
    rts
    
NegativeD0:             ; convert d0 to a negative number
    tst.w   d0
    bmi     .negative
    neg.w   d0
.negative:
    rts

MarkPoint:              ; store the x of the line points in the scanLineLeft or scanLineRight array if it's further left or right than what's there already
    lea     scanLineLeft,a0
    lea     scanLineRight,a1
    move.w  x,d0
    move.w  y,d1
    add.w   d1,d1       ; y*2 to get the memory offset of the y coordinate

    cmp.w   (a0,d1.w),d0
    bhs     .notLeft
    move.w  x,(a0,d1.w)
.notLeft
    cmp.w   (a1,d1.w),d0
    bls     .notRight
    move.w  x,(a1,d1.w)
.notRight
    rts
