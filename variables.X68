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
gameFlags           dc.w    0           ; a bitmask of game event flags. bit 0 = flip monkey

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
    dc.w 490,90
    dc.w 480,94
    dc.w 469,98
    dc.w 459,103
    dc.w 449,108
    dc.w 439,113
    dc.w 429,118
    dc.w 419,124
    dc.w 409,130
    dc.w 400,136
    dc.w 390,142
    dc.w 380,149
    dc.w 371,156
    dc.w 361,164
    dc.w 352,171
    dc.w 342,179
    dc.w 333,187
    dc.w 324,196
    dc.w 314,204
    dc.w 305,213
    dc.w 296,222
    dc.w 287,232
    dc.w 278,242
    dc.w 269,252
    dc.w 260,262
    dc.w 251,273
    dc.w 243,283
    dc.w 234,295
    dc.w 225,306
    dc.w 217,318
    dc.w 208,330
    dc.w 200,342

lane2Positions:
    dc.w 490,120
    dc.w 484,123
    dc.w 477,127
    dc.w 471,131
    dc.w 464,135
    dc.w 458,139
    dc.w 452,144
    dc.w 445,149
    dc.w 439,154
    dc.w 433,159
    dc.w 427,165
    dc.w 420,171
    dc.w 414,177
    dc.w 408,183
    dc.w 402,190
    dc.w 396,197
    dc.w 389,204
    dc.w 383,212
    dc.w 377,219
    dc.w 371,227
    dc.w 365,235
    dc.w 359,244
    dc.w 353,252
    dc.w 347,261
    dc.w 341,271
    dc.w 335,280
    dc.w 329,290
    dc.w 323,300
    dc.w 318,310
    dc.w 312,320
    dc.w 306,331
    dc.w 300,342

lane3Positions:
    dc.w 490,150
    dc.w 487,152
    dc.w 484,154
    dc.w 480,157
    dc.w 477,160
    dc.w 474,163
    dc.w 471,167
    dc.w 468,170
    dc.w 465,174
    dc.w 462,179
    dc.w 459,183
    dc.w 456,188
    dc.w 453,193
    dc.w 450,198
    dc.w 447,204
    dc.w 444,210
    dc.w 441,216
    dc.w 438,223
    dc.w 435,229
    dc.w 432,236
    dc.w 430,244
    dc.w 427,251
    dc.w 424,259
    dc.w 421,267
    dc.w 419,276
    dc.w 416,284
    dc.w 413,293
    dc.w 410,302
    dc.w 408,312
    dc.w 405,322
    dc.w 403,332
    dc.w 400,342