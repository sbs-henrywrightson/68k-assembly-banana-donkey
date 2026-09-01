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
monkeyOrientation   dc.w    0           ; 0=none,1=horizontal,2=vertical,3=both
bananaThrowTime     dc.l    0           ; the last time the a banana was thrown
bananaMoveTime      dc.l    0           ; the last time the the bananas moved down the lanes
donkeyMoveTime      dc.l    0           ; the last time the donkey moved
bananaCount         dc.w    0           ; the number of bananas in the lanes
currentLane         dc.l    0           ; the current lane being displayed
lane1               dc.l    0           ; the first lane the bananas go down
lane2               dc.l    0           ; the second lane the bananas go down
lane3               dc.l    0           ; the third lane the bananas go down
oldLane1            dc.l    0           ; the previous value of lane1
oldLane2            dc.l    0           ; the previous value of lane2
oldLane3            dc.l    0           ; the previous value of lane3
donkeyX             dc.w    0           ; the x-coord of the donkey
donkeyLane          dc.w    0           ; the lane the donkey is in. 0=lane1, 1=lane2, 2=lane3
donkeyOrientation   dc.w    0           ; 0=none,1=horizontal,2=vertical,3=both
gameFlags           dc.w    0           ; a bitmask of game event flags.
                                        ;   bit 0 = flip monkey
                                        ;   bit 1 = banana caught
                                        ;   bit 2 = banana hit ground
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

;====================================================
;==================== Lane Positions ===============
;====================================================
lane1Positions:
    dc.w    490,90
    dc.w    480,75
    dc.w    471,62
    dc.w    461,50
    dc.w    452,40
    dc.w    443,32
    dc.w    433,25
    dc.w    424,19
    dc.w    415,16
    dc.w    405,13
    dc.w    396,13
    dc.w    387,14
    dc.w    377,16
    dc.w    368,20
    dc.w    359,26
    dc.w    349,33
    dc.w    340,42
    dc.w    330,52
    dc.w    321,64
    dc.w    312,77
    dc.w    302,92
    dc.w    293,109
    dc.w    284,127
    dc.w    274,146
    dc.w    265,167
    dc.w    256,190
    dc.w    246,214
    dc.w    237,240
    dc.w    228,268
    dc.w    218,297
    dc.w    209,327
    dc.w    200,360


lane2Positions:
    dc.w    490,90
    dc.w    483,75
    dc.w    477,62
    dc.w    471,50
    dc.w    465,40
    dc.w    459,32
    dc.w    453,25
    dc.w    447,19
    dc.w    440,16
    dc.w    434,13
    dc.w    428,13
    dc.w    422,14
    dc.w    416,16
    dc.w    410,20
    dc.w    404,26
    dc.w    398,33
    dc.w    391,42
    dc.w    385,52
    dc.w    379,64
    dc.w    373,77
    dc.w    367,92
    dc.w    361,109
    dc.w    355,127
    dc.w    349,146
    dc.w    342,167
    dc.w    336,190
    dc.w    330,214
    dc.w    324,240
    dc.w    318,268
    dc.w    312,297
    dc.w    306,327
    dc.w    300,360

lane3Positions:
    dc.w    490,90
    dc.w    487,75
    dc.w    484,62
    dc.w    481,50
    dc.w    478,40
    dc.w    475,32
    dc.w    472,25
    dc.w    469,19
    dc.w    466,16
    dc.w    463,13
    dc.w    460,13
    dc.w    458,14
    dc.w    455,16
    dc.w    452,20
    dc.w    449,26
    dc.w    446,33
    dc.w    443,42
    dc.w    440,52
    dc.w    437,64
    dc.w    434,77
    dc.w    431,92
    dc.w    429,109
    dc.w    426,127
    dc.w    423,146
    dc.w    420,167
    dc.w    417,190
    dc.w    414,214
    dc.w    411,240
    dc.w    408,268
    dc.w    405,297
    dc.w    402,327
    dc.w    400,360
