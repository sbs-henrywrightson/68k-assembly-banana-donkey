;===================================================
;==================== Variables ====================
;===================================================

; Try to keep the number of byte variables EVEN

; diagnostics
moveAmount          dc.w    1
scaleAmount         dc.w    1
posX                dc.w    0
posY                dc.w    0
flip                dc.w    0
scale               dc.w    100
spriteCounter       dc.b    0           ; the current sprite being drawn
maxSprites          dc.b    8           ; the number of sprites to replicate

; bresenham-line
x                   dc.w    0
y                   dc.w    0
dx                  dc.w    0
dy                  dc.w    0
sx                  dc.w    0
sy                  dc.w    0

; game
systemTime          dc.l    0
monkeyFlip          dc.w    0           ; 0=none,1=horizontal,2=vertical,3=both
bananaThrowTime     dc.l    0           ; the last time the banana event triggered
bananaMoveTime      dc.l    0           ; the last time the lane event triggered
bananaCount         dc.w    0           ; the number of bananas in the lanes
currentLane         dc.l    0           ; the current lane being displayed
lane1               dc.l    0           ; the first lane the bananas go down
lane2               dc.l    0           ; the second lane the bananas go down
lane3               dc.l    0           ; the third lane the bananas go down
oldLane1            dc.l    0           ; the previous value of lane1
oldLane2            dc.l    0           ; the previous value of lane2
oldLane3            dc.l    0           ; the previous value of lane3

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
fontSize            dc.b    1           ; multiples of fontSize, 0=invalid, 1=normal, 2=larger...
fontBold            dc.b    0           ; 0=normal, 1=bold

;====================================================
;=============== Text Display variables =============
;====================================================
cleanEnd            dc.b    '   ',0             ; space for the end of a string to cover anything left from before
positionMessage     dc.b    'Position: ',0      ; the current x,y when positioning a sprite
scaleMessage        dc.b    'Scale: ',0         ; the current scale when positioning a sprite
flipMessage         dc.b    'Flip: ',0          ; the current flip when positioning a sprite
spacer              dc.b    '   -   ',0         ; spacer between xy, scale and flip
cycleMessage        dc.b    'Cycle count: ',0   ; DEBUG : the cycles for performance. Remove when game finished
