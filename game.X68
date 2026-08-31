*-----------------------------------------------------------
* Title      : game
* Written by : Henry Wrightson
* Date       : 20/8/2026
* Type       : Include file
* Depends on : 
* Description: The main entry point to the game
*-----------------------------------------------------------

;====================================================
;================= Game Sub-routines ================
;====================================================
PlayGame:
    ;jsr     PositionSprite             ; DEBUG : move a sprite around to get position and scale

    jsr     ClearScreen
    bsr     DrawBackdrop
    bsr     DrawSceneSprites
    ;jsr     DrawGrid                   ; DEBUG : for movement debugging. Remove when the banana lanes work
    ;bsr     OutputLanesText
    bsr     InitialiseGame
    jsr     RepaintScreen

.gameLoop:
    moveq   #8,d0                       ; get the current system time
    trap    #15
    move.l  d1,systemTime
    
    move.l  systemTime,d0
    sub.l   bananaMoveTime,d0
    cmp.l   #BANANA_MOVE_RATE,d0        ; is it time to move the bananas
    blo     .skipMoveBananas
    bsr     MoveBananas
.skipMoveBananas:

    move.l  systemTime,d0
    sub.l   bananaThrowTime,d0
    cmp.l   #BANANA_THROW_RATE,d0       ; is it time to throw a banana
    blo     .skipThrow
    bsr     ThrowBanana
.skipThrow:

    bra     .gameLoop
    rts
    
DrawBackdrop:
    ; SKY
    move.l  #$70c1ff,d1                 ; fill
    jsr     SetBackgroundColour
    move.l  #$70c1ff,d1                 ; outline
    jsr     SetPenColour
    moveq   #87,d0
    move.w  #0,d1                       ; x0
    move.w  #0,d2                       ; y0
    move.w  #650,d3                     ; x1
    move.w  #149,d4                     ; y1
    trap    #15

    ; DESERT
    move.l  #$ffe894,d1                 ; fill
    jsr     SetBackgroundColour
    move.l  #$ffe894,d1                 ; outline
    jsr     SetPenColour
    moveq   #87,d0
    move.w  #0,d1                       ; x0
    move.w  #150,d2                     ; y0
    move.w  #650,d3                     ; x1
    move.w  #419,d4                     ; y1
    trap    #15

    ; SEA
    move.l  #$002ee6,d1                 ; fill
    jsr     SetBackgroundColour
    move.l  #$002ee6,d1                 ; outline
    jsr     SetPenColour
    moveq   #87,d0
    move.w  #0,d1                       ; x0
    move.w  #420,d2                     ; y0
    move.w  #650,d3                     ; x1
    move.w  #480,d4                     ; y1
    trap    #15
    rts

DrawSceneSprites:
    ; clouds
    SetSprite cloud,cloudSpriteSize,#0,#50,#20,#40,#0
    jsr     DrawSprite

    SetSprite cloud,cloudSpriteSize,#0,#110,#20,#60,#0
    jsr     DrawSprite

    SetSprite cloud,cloudSpriteSize,#0,#550,#20,#20,#1
    jsr     DrawSprite

    ; desert hills
    SetSprite hillLeft,hillLeftSpriteSize,#0,#0,#124,#70,#0
    jsr     DrawSprite

    SetSprite hillLeft,hillLeftSpriteSize,#0,#180,#122,#90,#0
    jsr     DrawSprite

    SetSprite hillRight,hillRightSpriteSize,#0,#431,#126,#80,#1
    jsr     DrawSprite

    SetSprite hillLeft,hillLeftSpriteSize,#0,#30,#130,#130,#0
    jsr     DrawSprite

    SetSprite hillRight,hillRightSpriteSize,#0,#390,#140,#50,#0
    jsr     DrawSprite

    SetSprite hillRight,hillRightSpriteSize,#0,#300,#150,#140,#1
    jsr     DrawSprite

    SetSprite hillLeft,hillLeftSpriteSize,#0,#0,#160,#190,#0
    jsr     DrawSprite

    ; left trees & dunes
    SetSprite sandDune,sandDuneSpriteSize,#0,#0,#230,#140,#0
    jsr     DrawSprite

    SetSprite palmTree,palmTreeSpriteSize,#0,#20,#100,#85,#1
    jsr     DrawSprite

    SetSprite palmTree,palmTreeSpriteSize,#0,#80,#150,#65,#0
    jsr     DrawSprite

    SetSprite sandDune,sandDuneSpriteSize,#0,#0,#300,#60,#0
    jsr     DrawSprite

    ; right trees & dunes
    SetSprite sandDune,sandDuneSpriteSize,#0,#400,#240,#100,#0
    jsr     DrawSprite

    SetSprite palmTree,palmTreeSpriteSize,#0,#430,#70,#100,#0
    jsr     DrawSprite

    SetSprite sandDune,sandDuneSpriteSize,#0,#310,#280,#100,#1
    jsr     DrawSprite

    ; sea
    SetSprite seaFoam,seaFoamSpriteSize,#0,#0,#402,#100,#0
    jsr     DrawSprite

    SetSprite seaFoam,seaFoamSpriteSize,#0,#215,#406,#80,#0
    jsr     DrawSprite

    SetSprite seaFoam,seaFoamSpriteSize,#0,#395,#405,#100,#2
    jsr     DrawSprite

    ; DONKEY   - DEBUG : this will eventually be a player controlled sprite
    SetSprite donkey,donkeySpriteSize,#0,#200,#342,#35,#0
    jsr     DrawSprite
    rts

InitialiseGame:
    moveq   #8,d0
    trap    #15

    ; GENERAL
    moveq   #8,d0                       ; seed the random number generator with the current time
    trap    #15
    move.l  d1,randomSeed
    eori.l  #$12345678,randomSeed
    move.w  #0,bananaCount

    ; MONKEY
    bset    #0,gameFlags                ; set the flip monkey flag
    move.w  #0,monkeyOrientation
    bsr     DrawMonkey

    ; BANANAS
    move.l  #0,bananaThrowTime

    ; LANES
    move.l  #0,bananaMoveTime
    move.l  #0,lane1
    move.l  #0,lane2
    move.l  #0,lane3
    move.l  #0,oldLane1
    move.l  #0,oldLane2
    move.l  #0,oldLane3
    lea     lane1Positions,a4
    lea     lane2Positions,a5
    lea     lane3Positions,a6

    ;          3322222222221111111111                   ; DEBUG : Remove
    ;          10987654321098765432109876543210         ; DEBUG : Remove
    ;move.l  #%00010000000100000001000000010000,lane1   ; DEBUG : Remove
    ;move.w  #4,bananaCount                             ; DEBUG : Remove
    ;bsr     RenderLaneContents                         ; DEBUG : Remove
    ;jsr     RepaintScreen                              ; DEBUG : Remove

    rts

RemoveMonkey:
    btst    #0,gameFlags
    beq     .noFlip
    SetSprite monkey,monkeySpriteSize,#MAX_BANANAS,#MONKEY_X,#MONKEY_Y,#MONKEY_SCALE,monkeyOrientation
    jsr     RestoreDirtyRectangle
.noFlip
    rts

FlipMonkey:
    btst    #0,gameFlags
    beq     .noFlip
    eori.w  #1,monkeyOrientation
    bsr     DrawMonkey
    bclr    #0,gameFlags
.noFlip
    rts

DrawMonkey:
    SetSprite monkey,monkeySpriteSize,#MAX_BANANAS,#MONKEY_X,#MONKEY_Y,#MONKEY_SCALE,monkeyOrientation
    jsr     SaveDirtyRectangle
    jsr     DrawSprite
    rts

ThrowBanana:
    move.l  systemTime,bananaThrowTime

    move.w  bananaCount,d0
    cmp.w   #MAX_BANANAS,d0
    bhs     .endEvent

    moveq   #4,d1
    jsr     RandomChance
    bne     .endEvent

    moveq   #3,d1
    jsr     RandomChance
    cmp.w   #1,d2
    beq     .spawnLane1
    cmp.w   #2,d2
    beq     .spawnLane2
    bra     .spawnLane3

.spawnLane1:
    move.l  lane1,d0
    bset    #0,d0
    move.l  d0,lane1
    bra     .spawnComplete
.spawnLane2:
    move.l  lane2,d0
    bset    #0,d0
    move.l  d0,lane2
    bra     .spawnComplete
.spawnLane3:
    move.l  lane3,d0
    bset    #0,d0
    move.l  d0,lane3

.spawnComplete:
    addq    #1,bananaCount
    bset    #0,gameFlags                ; flip the monkey

    ;bsr     OutputLanesText             ; DEBUG : REMOVE
    ;bsr     RenderLaneContents         ; DEBUG : REMOVE
    jsr     RepaintScreen
.endEvent:
    rts

MoveBananas:
    move.l  systemTime,bananaMoveTime

    move.l  lane1,d0
    btst    #31,d0
    beq     .shiftLane1
    subq    #1,bananaCount              ; banana dropped off the end so subtract 1
.shiftLane1:
    lsl.l   #1,d0
    move.l  d0,lane1
    
    move.l  lane2,d0
    btst    #31,d0
    beq     .shiftLane2
    subq    #1,bananaCount              ; banana dropped off the end so subtract 1
.shiftLane2:
    lsl.l   #1,d0
    move.l  d0,lane2
    
    move.l  lane3,d0
    btst    #31,d0
    beq     .shiftLane3
    subq    #1,bananaCount              ; banana dropped off the end so subtract 1
.shiftLane3:
    lsl.l   #1,d0
    move.l  d0,lane3
    
    ;bsr     OutputLanesText
    bsr     RenderLaneContents
    jsr     RepaintScreen
    rts

OutputLanesText:
    move.l  #COLOUR_WHITE,d1
    jsr     SetPenColour

    moveq   #11,d0                      ; position at 0,28
    move.w  #$001c,d1
    trap    #15

    move.l  lane1,d0
    jsr     DisplayLaneMask

    move.l  lane2,d0
    jsr     DisplayLaneMask

    move.l  lane3,d0
    jsr     DisplayLaneMask

    rts

DisplayLaneMask:                        ; print the long word in d0 as binary with leading zeros
    move.l  d0,d4
    moveq   #31,d3

.loop:
    btst    d3,d4
    beq.s   .noBit

    move.l  #COLOUR_RED,d1
    jsr     SetBackgroundColour

    moveq   #6,d0
    moveq   #'+',d1
    trap    #15
    bra     .nextBit

.noBit:
    move.l  #COLOUR_BLUE,d1
    jsr     SetBackgroundColour
    
    moveq   #0,d0
    moveq   #0,d1
    move.l  d3,d0
    divu    #10,d0
    swap    d0
    move.w  d0,d1

    moveq   #15,d0
    moveq   #10,d2
    trap    #15

.nextBit
    dbra    d3,.loop

    moveq   #6,d0
    moveq   #13,d1
    trap    #15
    moveq   #10,d1
    trap    #15
    rts

******************************************************
* RenderLaneContents register contract
******************************************************
* d0 = scratch
* d1 = current lane position
* d2 = lane number
* d3 = remove or display banana, 1=remove, 0=display
* d4 = banana Id
* d5 = x-coord of banana
* d6 = y-coord of banana
* a1 = current lane positions
* a4 = lane 1 positions
* a5 = lane 2 positions
* a6 = lane3 positions
******************************************************
RenderLaneContents:
    moveq   #0,d0
    move.l  oldLane1,d0
    add.l   oldLane2,d0
    add.l   oldLane3,d0
    add.l   lane1,d0
    add.l   lane2,d0
    add.l   lane3,d0
    tst.l   d0                          ; check to see if there are any bananas that need removing or displaying
    beq     .complete

    moveq   #2,d3                       ; refresh phase : 2=restore bananas dirty rect, 1=save bananas dirty rect, 0=display new banana

.refreshLoop:
    moveq   #2,d2                       ; d2 = lane number
    moveq   #0,d4                       ; d4 = banana Id
    
    cmpi.w  #1,d3                       ; don't flip monkey if we're not in the save phase
    bne     .laneLoop
    btst    #0,gameFlags                ; don't flip monkey if flip flag isn't set
    beq     .laneLoop
    bsr     RemoveMonkey                ; only flip monkey when in at start of save phase and flip flag is set
    bsr     FlipMonkey

.laneLoop:
    cmp.w   #0,d2
    beq     .selectLane1
    cmp.w   #1,d2
    beq     .selectLane2
    bra     .selectLane3
.selectLane1:
    movea.l a4,a1                       ; a1 = lane 1 Positions
    cmp.b   #2,d3
    beq     .removeLane1
    move.l  lane1,currentLane
    bra     .laneSelected
.removeLane1:
    move.l  oldLane1,currentLane
    bra     .laneSelected
.selectLane2:
    movea.l a5,a1                       ; a1 = lane 2 Positions
    cmp.b   #2,d3
    beq     .removeLane2
    move.l  lane2,currentLane
    bra     .laneSelected
.removeLane2:
    move.l  oldLane2,currentLane
    bra     .laneSelected
.selectLane3:
    movea.l a6,a1                       ; a1 = lane 3 Positions
    cmp.b   #2,d3
    beq     .removeLane3
    move.l  lane3,currentLane
    bra     .laneSelected
.removeLane3:
    move.l  oldLane3,currentLane
    bra     .laneSelected

.laneSelected:
    moveq   #31,d1                      ; d1 = current lane position
.bitLoop:
    move.l  currentLane,d0
    btst    d1,d0                       ; check for a banana at position d1 in currentLane
    beq.s   .nextBit
    
    moveq   #0,d5
    moveq   #0,d6
    moveq   #0,d0
    move.w  d1,d0
    lsl.w   #2,d0                       ; each x,y pair is 4 bytes apart so multiply by 4 to get the offset
    move.w  (a1,d0.w),d5                ; d5 = x-coord of banana
    add.w   #2,d0
    move.w  (a1,d0.w),d6                ; d6 = y-coord of banana
    
    SetSprite banana,bananaSpriteSize,d4,d5,d6,#BANANA_SCALE,#0
    
    addq    #1,d4                       ; increment the banana id after any action

    cmp.b   #1,d3
    beq     .saveBanana
    cmp.b   #0,d3
    beq     .displayBanana
.removeBanana
    jsr     RestoreDirtyRectangle
    bra     .nextBit
.saveBanana:
    jsr     SaveDirtyRectangle
    bra     .nextBit
.displayBanana:
    jsr     DrawSprite

.nextBit:
    dbra    d1,.bitLoop
    dbra    d2,.laneLoop
    dbra    d3,.refreshLoop

    move.l  lane1,oldLane1              ; backup the lanes so the bananas can be removed when the lanes change
    move.l  lane2,oldLane2
    move.l  lane3,oldLane3

.complete:
    rts
