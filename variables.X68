;===================================================
;==================== Variables ====================
;===================================================
; diagnostics
moveAmount      dc.w    1
scaleAmount     dc.w    1
posX            dc.w    0
posY            dc.w    0
flip            dc.w    0
scale           dc.w    100
spriteCounter   dc.b    0           ; the current sprite being drawn
maxSprites      dc.b    8           ; the number of sprites to replicate

; bresenham-line
x               dc.w    0
y               dc.w    0
dx              dc.w    0
dy              dc.w    0
sx              dc.w    0
sy              dc.w    0

; game
systemTime          dc.l    0
monkeyFlip          dc.w    0           ; 0=none,1=horizontal,2=vertical,3=both
bananaThrowTime     dc.l    0           ; the last time the banana event triggered
bananaMoveTime      dc.l    0           ; the last time the lane event triggered
bananaCount         dc.w    0           ; the number of bananas in the lanes
currentLane         dc.w    0           ; the current lane being displayed
lane1               dc.w    0           ; the first lane the bananas go down
lane2               dc.w    0           ; the second lane the bananas go down
lane3               dc.w    0           ; the third lane the bananas go down
oldLane1            dc.w    0           ; the previous value of lane1
oldLane2            dc.w    0           ; the previous value of lane2
oldLane3            dc.w    0           ; the previous value of lane3

; polygon
scanLineMinY        dc.w    0
scanLineMaxY        dc.w    0

fillColour          dc.l    $00ffffff
outlineColour       dc.l    $00ffffff

; sprites
spriteDBNumber      dc.w    0           ; the number used to reference which part of the dirty buffer this sprite should use
spriteSize          dc.w    $0000       ; $wwhh
spriteOrigin        dc.l    $00000000   ; $xxxxyyyy
spriteScale         dc.w    100         ; scale percentage; 100%
spriteFlip          dc.w    0           ; 0=none,1=horizontal,2=vertical,3=both
spriteX             dc.b    0
spriteY             dc.b    0

; core
randomSeed          dc.l    $12345678

; graphics
digitPlotX          dc.w    0
digitPlotY          dc.w    0
digitPlotLine       dc.b    0
digitCount          dc.b    0
digits:
    ; 0
    dc.b $1C    ; %00011100
    dc.b $22    ; %00100010
    dc.b $22    ; %00100010
    dc.b $22    ; %00100010
    dc.b $22    ; %00100010
    dc.b $22    ; %00100010
    dc.b $1C    ; %00011100
    dc.b $00    ; %00000000
    ; 1
    dc.b $08    ; %00001000
    dc.b $18    ; %00011000
    dc.b $08    ; %00001000
    dc.b $08    ; %00001000
    dc.b $08    ; %00001000
    dc.b $08    ; %00001000
    dc.b $1C    ; %00011100
    dc.b $00    ; %00000000
    ; 2
    dc.b $1C    ; %00011100
    dc.b $22    ; %00100010
    dc.b $02    ; %00000010
    dc.b $04    ; %00000100
    dc.b $08    ; %00001000
    dc.b $10    ; %00010000
    dc.b $3E    ; %00111110
    dc.b $00    ; %00000000
    ; 3
    dc.b $1C    ; %00011100
    dc.b $22    ; %00100010
    dc.b $02    ; %00000010
    dc.b $0C    ; %00001100
    dc.b $02    ; %00000010
    dc.b $22    ; %00100010
    dc.b $1C    ; %00011100
    dc.b $00    ; %00000000
    ; 4
    dc.b $04    ; %00000100
    dc.b $0C    ; %00001100
    dc.b $14    ; %00010100
    dc.b $24    ; %00100100
    dc.b $3E    ; %00111110
    dc.b $04    ; %00000100
    dc.b $04    ; %00000100
    dc.b $00    ; %00000000
    ; 5
    dc.b $3E    ; %00111110
    dc.b $20    ; %00100000
    dc.b $20    ; %00100000
    dc.b $1C    ; %00011100
    dc.b $02    ; %00000010
    dc.b $22    ; %00100010
    dc.b $1C    ; %00011100
    dc.b $00    ; %00000000
    ; 6
    dc.b $1C    ; %00011100
    dc.b $22    ; %00100010
    dc.b $20    ; %00100000
    dc.b $3C    ; %00111100
    dc.b $22    ; %00100010
    dc.b $22    ; %00100010
    dc.b $1C    ; %00011100
    dc.b $00    ; %00000000
    ; 7
    dc.b $3E    ; %00111110
    dc.b $02    ; %00000010
    dc.b $04    ; %00000100
    dc.b $08    ; %00001000
    dc.b $10    ; %00010000
    dc.b $10    ; %00010000
    dc.b $10    ; %00010000
    dc.b $00    ; %00000000
    ; 8
    dc.b $1C    ; %00011100
    dc.b $22    ; %00100010
    dc.b $22    ; %00100010
    dc.b $1C    ; %00011100
    dc.b $22    ; %00100010
    dc.b $22    ; %00100010
    dc.b $1C    ; %00011100
    dc.b $00    ; %00000000
    ; 9
    dc.b $1C    ; %00011100
    dc.b $22    ; %00100010
    dc.b $22    ; %00100010
    dc.b $1E    ; %00011110
    dc.b $02    ; %00000010
    dc.b $22    ; %00100010
    dc.b $1C    ; %00011100
    dc.b $00    ; %00000000