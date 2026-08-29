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
scanLineLeft:    
    ds.w    RES_Y           ; the start positions of the scan-lines needed to make the filled polygon. The offset is the y and the value is the x
    ds.l    4               ; spacer

scanLineRight:
    ds.w    RES_Y           ; the end positions of the scan-lines needed to make the filled polygon. The offset is the y and the value is the x
    ds.l    4               ; spacer

;====================================================
;=================== Sprite buffers =================
;====================================================
dirtyRectangleBuffer:
    ds.l    MAX_DIRTY_SPRITES*SPRITE_BUFFER_OFFSET
    ds.l    4               ; spacer

;====================================================
;================== Polygon buffers =================
;====================================================
; the points in a polygon as $xxxxyyyy. the first word is the number of vertices in the polygon
vertices:
    ds.w    1               ; the number of vertices
    ds.l    MAX_VERTICES    ; the vertices as long words $xxxxyyyy
    ds.l    4               ; spacer

;====================================================
;=================== Digit buffers ==================
;====================================================
; the digit buffer is used to write a number in backwards so it can be read one digit at a time from left to right
digitBuffer:    
    ds.b    6               ; the maximum number of digits that can be read, (99999 will fit in a word)
    ds.l    4               ; spacer