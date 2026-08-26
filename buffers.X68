*-----------------------------------------------------------
* Title      : buffers
* Written by : Henry Wrightson
* Date       : 23/8/2026
* Type       : Include file
* Depends on : 
* Description: All the reserved memory buffers. Need to be
*            : declared at the end of the program so that
*            : the branch distances don't change
*-----------------------------------------------------------

;====================================================
;=============== Bresenham Line buffers =============
;====================================================
scanLineLeft    ds.w    RES_Y               ; the start positions of the scan-lines needed to make the filled polygon. The offset is the y and the value is the x
scanLineRight   ds.w    RES_Y               ; the end positions of the scan-lines needed to make the filled polygon. The offset is the y and the value is the x

;====================================================
;=================== Sprite buffers =================
;====================================================
dirtyRectangleBuffer    ds.l    MAX_SPRITES*SPRITE_BUFFER_OFFSET

;====================================================
;================== Polygon buffers =================
;====================================================
; the points in a polygon as $xxxxyyyy. the first word is the number of vertices in the polygon
vertices:
    ds.w    1               ; the number of vertices
    ds.l    MAX_VERTICES    ; the vertices as long words $xxxxyyyy

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
