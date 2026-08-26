;===================================================
;==================== Variables ====================
;===================================================
; diagnostics
cycleMessage dc.b 'Cycle count: ',0

; bresenham-line
x               dc.w    0
y               dc.w    0
dx              dc.w    0
dy              dc.w    0
sx              dc.w    0
sy              dc.w    0

; game
moveAmount      dc.w    1
scaleAmount     dc.w    1
posX            dc.w    0
posY            dc.w    0
flip            dc.w    0
scale           dc.w    100

spriteCounter   dc.b    0           ; the current sprite being drawn
maxSprites      dc.b    8

; polygon
scanLineMinY    dc.w    0
scanLineMaxY    dc.w    0

fillColour      dc.l    $00ffffff
outlineColour   dc.l    $00ffffff

; sprites
spriteDBNumber      dc.w    0           ; the number used to reference which part of the dirty buffer this sprite should use
spriteSize          dc.w    $0000       ; $wwhh
spriteOrigin        dc.l    $00000000   ; $xxxxyyyy
spriteScale         dc.w    100         ; scale percentage; 100%
spriteFlip          dc.w    0           ; 0=none,1=horizontal,2=vertical,3=both
spriteX             dc.b    0
spriteY             dc.b    0
