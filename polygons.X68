*-----------------------------------------------------------
* Title      : polygons
* Written by : Henry Wrightson
* Date       : 16/8/2026
* Type       : Include file
* Depends on : graphics.x68, bresenham-line.x68
* Description: Create a filled convex polygon by getting all the points
*            : round the edge of it and drawing horizontal lines between
*            : them to create a filled polygon
*-----------------------------------------------------------

DrawFilledPolygon:
    CacheRegisters
    
    move.l  fillColour,d1
    bsr     SetPenColour
    
    bsr     BuildPolygon        ; calculate the outline of the polygon
    bsr     FillPolygon         ; fill it in with horizontal lines
    
    move.l  outlineColour,d1    ; if the outline colour is different, draw the outline
    cmp.l   fillColour,d1
    beq     .SkipOutline
    bsr     SetPenColour
    bsr     DrawPolygon
.SkipOutline:
    RestoreRegisters
    rts

BuildPolygon:               ; draw the polygon described by the vertices
    bsr     ResetScanLines
    
    lea     vertices,a0    
    moveq   #0,d1
    move.w  (a0)+,d1        ; number of vertices
    subq    #1,d1
    move.l  a0,a1
.VerticesLoop:              ; draw all the lines between all the vetices
    move.l  (a0)+,d0        ; a vertex A
    move.w  d0,d5           ; y0
    swap    d0
    move.w  d0,d4           ; x0
    tst.w   d1              ; on the last vertex so move back to the top to draw a line from last to first vertex
    bne     .NotLastVertex
    move.l  a1,a0
.NotLastVertex:
    move.l  (a0),d0         ; the next vertex B
    move.w  d0,d7           ; y0
    swap    d0
    move.w  d0,d6           ; x0
    bsr     MarkLine        ; line A-B
    dbra    d1,.VerticesLoop
    rts

ResetScanLines:             ; fill the scanLineLeft with max value and scanLineRight with min value
    move.w  #$FFFF,scanLineMinY
    move.w  #$0000,scanLineMaxY

    lea     vertices,a0
    moveq   #0,d1
    move.w  (a0)+,d1        ; number of vertices
    subq    #1,d1
.VerticesLoop:
    move.l  (a0)+,d0        ; vertex
    bsr     StoreLowHighY
    dbra    d1,.VerticesLoop
    
    lea     scanLineLeft,a0
    lea     scanLineRight,a1
    
    move.w  scanLineMinY,d0
    add.w   d0,d0           ; y*2 cos the scanLine lists are words, 1 for each y
    adda.w  d0,a0           ; shift the pointer along so it starts at MinY and not 0
    adda.w  d0,a1
    
    moveq   #0,d1
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
    
FillPolygon:
    lea     scanLineLeft,a0
    lea     scanLineRight,a1
    
    move.w  scanLineMinY,d0
    add.w   d0,d0           ; double it cos we're adding a word for each MinY
    adda.w  d0,a0           ; shift the pointer along so it starts at MinY and not 0
    adda.w  d0,a1
    
    move.w  scanLineMinY,d5
.Loop:
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

DrawPolygon:
    lea     vertices,a0
    moveq   #0,d5
    move.w  (a0)+,d5        ; number of vertices
    subq    #1,d5
    move.l  a0,a1
.VerticesLoop:
    move.l  (a0)+,d0        ; vertex A
    move.w  d0,d2           ; y0
    swap    d0
    move.w  d0,d1           ; x0

    tst.w   d5              ; on the last vertex so move back to the top to draw a line from last to first vertex
    bne     .NotLastVertex
    move.l  a1,a0           ; roll back to the start of the vertices to draw the line from last to first vertex
.NotLastVertex:
    move.l  (a0),d0         ; vertex B
    move.w  d0,d4           ; y0
    swap    d0
    move.w  d0,d3           ; x0
    moveq   #84,d0          ; line A-B
    trap    #15
    
    dbra    d5,.VerticesLoop
    
    rts

;====================================================
;================== Polygon variables ===============
;====================================================
scanLineMinY    dc.w    0
scanLineMaxY    dc.w    0

fillColour      dc.l    $00ffffff
outlineColour   dc.l    $00ffffff

; the points in a polygon as $xxxxyyyy. the first word is the number of vertices in the polygon
vertices:
    ds.w    1               ; the number of vertices
    ds.l    MAX_VERTICES    ; the vertices as long words $xxxxyyyy


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
