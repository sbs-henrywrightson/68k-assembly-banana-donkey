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
; sprite IDs : 0-5 : bananas
;                6 : monkey
;                7 : donkey
PlayGame:
    ;jsr     PositionSprite

    jsr     ClearScreen
    bsr     DrawBackdrop
    bsr     DrawSceneSprites
    bsr     DrawGrid
    jsr     RepaintScreen

    bsr     InitialiseGame

.GameLoop
    bsr     OutputLanesText
    jsr     RepaintScreen

    moveq   #8,d0
    trap    #15
    move.l  d1,systemTime
    
    move.l  systemTime,d0
    sub.l   bananaMoveTime,d0
    cmp.l   #BANANA_MOVE_RATE,d0               ; is it time to move the bananas
    blo     .DontMoveBananas
    bsr     MoveBananas
.DontMoveBananas

    move.l  systemTime,d0
    sub.l   bananaThrowTime,d0
    cmp.l   #BANANA_EVENT_RATE,d0               ; is it time to throw a banana
    blo     .DontThrowBanana
    bsr     ThrowBanana
.DontThrowBanana

    bra     .GameLoop
    rts
    
DrawBackdrop:
    ; SKY
    move.l  #$0070c1ff,d1       ; fill
    jsr     SetBackgroundColour
    move.l  #$0070c1ff,d1       ; outline
    jsr     SetPenColour
    moveq   #87,d0
    move.w  #0,d1       ; x0
    move.w  #0,d2       ; y0
    move.w  #650,d3   ; x1
    move.w  #149,d4      ; y1
    trap    #15

    ; DESERT
    move.l  #$00ffe894,d1        ; fill
    jsr     SetBackgroundColour
    move.l  #$00ffe894,d1        ; outline
    jsr     SetPenColour
    moveq   #87,d0
    move.w  #0,d1       ; x0
    move.w  #150,d2      ; y0
    move.w  #650,d3   ; x1
    move.w  #419,d4   ; y1
    trap    #15

    ; SEA
    move.l  #$00002ee6,d1        ; fill
    jsr     SetBackgroundColour
    move.l  #$00002ee6,d1        ; outline
    jsr     SetPenColour
    moveq   #87,d0
    move.w  #0,d1       ; x0
    move.w  #420,d2   ; y0
    move.w  #650,d3   ; x1
    move.w  #480,d4   ; y1
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

    rts

DrawGrid:
    moveq   #15,d6

.HorizontalLoop:
    moveq   #COLOUR_BLACK,d1
    jsr     SetPenColour
    
    ;draw lines across the screen for the bananas vertical movement
    move.w  d6,d5
    mulu    #20,d5

    move.w  #0,d1
    move.w  d5,d2
    move.w  #RES_X,d3
    move.w  d5,d4
    jsr     DrawLine

    move.w  #200,digitPlotX
    move.w  d5,digitPlotY
    addq    #5,digitPlotY
    move.w  d6,d0
    bsr     PlotNumber

    move.w  #300,digitPlotX
    move.w  d5,digitPlotY
    addq    #5,digitPlotY
    move.w  d6,d0
    bsr     PlotNumber
    
    move.w  #400,digitPlotX
    move.w  d5,digitPlotY
    addq    #5,digitPlotY
    move.w  d6,d0
    bsr     PlotNumber

    dbra    d6,.HorizontalLoop

    ;draw three lines for the three banana lanes
    move.w  #200,d1
    move.w  #0,d2
    move.w  #200,d3
    move.w  #RES_Y,d4
    jsr     DrawLine

    move.w  #300,d1
    move.w  #300,d3
    jsr     DrawLine

    move.w  #400,d1
    move.w  #400,d3
    jsr     DrawLine
    rts

InitialiseGame:
    moveq   #8,d0
    trap    #15

    ; GENERAL
    moveq   #8,d0           ; seed the random number generator with the current time
    trap    #15
    move.l  d1,randomSeed
    eori.l  #$12345678,randomSeed
    move.w  #0,bananaCount

    ; MONKEY
    move.w  #0,monkeyFlip
    SetSprite monkey,monkeySpriteSize,#MONKEY_ID,#MONKEY_X,#MONKEY_Y,#MONKEY_SCALE,monkeyFlip
    jsr     SaveDirtyRectangle
    bsr     FlipMonkey

    ; BANANAS
    move.l  #0,bananaThrowTime

    ; LANES
    move.l  #0,bananaMoveTime
    move.w  #0,lane1
    move.w  #0,lane2
    move.w  #0,lane3

    ;bsr     DisplayBananas
    jsr     RepaintScreen

    rts

FlipMonkey:
    SetSprite monkey,monkeySpriteSize,#MONKEY_ID,#MONKEY_X,#MONKEY_Y,#MONKEY_SCALE,monkeyFlip
    jsr     RestoreDirtyRectangle

    eori.w  #1,monkeyFlip
    SetSprite monkey,monkeySpriteSize,#MONKEY_ID,#MONKEY_X,#MONKEY_Y,#MONKEY_SCALE,monkeyFlip
    jsr     SaveDirtyRectangle
    jsr     DrawSprite

    rts

ThrowBanana:
    move.l  systemTime,bananaThrowTime

    ;bsr     CheckForMaxBananas
    move.w  bananaCount,d0
    cmp.w   #MAX_BANANAS,d0
    bhs     .EndEvent

    moveq   #4,d1
    jsr     RandomChance
    bne     .EndEvent

    moveq   #3,d1
    jsr     RandomChance
    cmp.w   #1,d2
    beq     .Lane1
    cmp.w   #2,d2
    beq     .Lane2
    bra     .Lane3

.Lane1:
    move.w  lane1,d0
    bset    #0,d0
    move.w  d0,lane1
    bra     .Finally
.Lane2:
    move.w  lane2,d0
    bset    #0,d0
    move.w  d0,lane2
    bra     .Finally
.Lane3:
    move.w  lane3,d0
    bset    #0,d0
    move.w  d0,lane3
    
.Finally:
    addq    #1,bananaCount

    bsr     OutputLanesText     ; DEBUGGING - REMOVE
    jsr     RepaintScreen       ; DEBUGGING - REMOVE

    bsr     FlipMonkey
    bsr     DisplayBananas
.EndEvent:
    rts

MoveBananas:
    move.l  systemTime,bananaMoveTime

    move.w  lane1,oldLane1
    move.w  lane2,oldLane2
    move.w  lane3,oldLane3

    ; un-count any bananas that will drop off the end
    move.w  lane1,d0
    btst    #15,d0
    beq     .ShiftLane1
    subq    #1,bananaCount
.ShiftLane1
    lsl.w   #1,d0
    move.w  d0,lane1
    
    move.w  lane2,d0
    btst    #15,d0
    beq     .ShiftLane2
    subq    #1,bananaCount
.ShiftLane2
    lsl.w   #1,d0
    move.w  d0,lane2
    
    move.w  lane3,d0
    btst    #15,d0
    beq     .ShiftLane3
    subq    #1,bananaCount
.ShiftLane3
    lsl.w   #1,d0
    move.w  d0,lane3
    
    bsr     OutputLanesText
    jsr     RepaintScreen

    bsr     DisplayBananas
    jsr     RepaintScreen
    rts

OutputLanesText:
    moveq   #11,d0      ; position at 0,0
    move.w  $0000,d1
    trap    #15

    move.l  #COLOUR_WHITE,d1
    jsr     SetPenColour

    move.w  lane1,d0
    jsr     PrintBinary

    move.w  lane2,d0
    jsr     PrintBinary

    move.w  lane3,d0
    jsr     PrintBinary

    rts

PrintBinary:        ; print the word in d0 as binary with leading zeros
    move.w  d0,d4
    moveq   #15,d3

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
    move.w  d3,d0
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

DisplayBananas:
    ; d0 = scratch
    ; d1 = current lane position
    ; d2 = lane number
    ; d3 = remove or display banana, 1=remove, 0=display
    ; d4 = banana Id
    ; d5 = x-coord of banana
    ; d6 = y-coord of banana
    moveq   #0,d0
    move.w  oldLane1,d0 ; check to see if there are any bananas that need removing or displaying
    add.w   oldLane2,d0
    add.w   oldLane3,d0
    add.w   lane1,d0
    add.w   lane2,d0
    add.w   lane3,d0
    tst.w   d0
    beq     .FinishDisplay

    moveq   #2,d3         ; d3 = 2=clear old banana, 1=save new banana, 0=display new banana

.RemoveDisplayLoop:
    moveq   #2,d2         ; d2 = lane number
    moveq   #0,d4         ; d4 = banana Id
.LaneLoop:
    moveq   #0,d5
    moveq   #0,d6
    
    cmp.w   #0,d2
    beq     .ChooseLane1
    cmp.w   #1,d2
    beq     .ChooseLane2
    bra     .ChooseLane3
.ChooseLane1:
    move.w  #200,d5     ;d5 = x-coord of banana in lane 1
    cmp.b   #2,d3
    beq     .RemoveLane1
    move.w  lane1,currentLane
    bra     .ShowHideBananas
.RemoveLane1:
    move.w  oldLane1,currentLane
    bra     .ShowHideBananas
.ChooseLane2:
    move.w  #300,d5     ;d5 = x-coord of banana in lane 2
    cmp.b   #2,d3
    beq     .RemoveLane2
    move.w  lane2,currentLane
    bra     .ShowHideBananas
.RemoveLane2:
    move.w  oldLane2,currentLane
    bra     .ShowHideBananas
.ChooseLane3:
    move.w  #400,d5     ;d5 = x-coord of banana in lane 3
    cmp.b   #2,d3
    beq     .RemoveLane3
    move.w  lane3,currentLane
    bra     .ShowHideBananas
.RemoveLane3:
    move.w  oldLane3,currentLane
    bra     .ShowHideBananas
.ShowHideBananas:
    moveq   #15,d1      ; d1 = current lane position
.BananaLoop:
    move.w  currentLane,d0
    btst    d1,d0       ; check for a banana at position d1 in currentLane
    beq.s   .NextLanePosition
    
    move.b  d1,d6       ; d6 = y-coord of banana
    mulu    #20,d6
    
    SetSprite banana,bananaSpriteSize,d4,d5,d6,#BANANA_SCALE,#0
    
    cmp.b   #1,d3
    beq     .SaveBanana
    cmp.b   #0,d3
    beq     .DisplayBanana
    jsr     RestoreDirtyRectangle
    jsr     RepaintScreen   ; DEBUG - REMOVE
    addq    #1,d4       ; increment the banana id after a restore
    bra     .NextLanePosition
.SaveBanana:
    jsr     SaveDirtyRectangle
    jsr     RepaintScreen   ; DEBUG - REMOVE
    addq    #1,d4       ; increment the banana id after a restore
    bra     .NextLanePosition
.DisplayBanana:
    jsr     DrawSprite
    jsr     RepaintScreen   ; DEBUG - REMOVE
    addq    #1,d4       ; increment the banana id after a restore

.NextLanePosition:
    dbra    d1,.BananaLoop
    dbra    d2,.LaneLoop
    dbra    d3,.RemoveDisplayLoop

.FinishDisplay:
    rts

CheckForMaxBananas:     ; loop through all the lanes counting bananas until 6 have been found
    moveq   #0,d0
    move.w  lane1,d0
    add.w   lane2,d0
    add.w   lane3,d0
    beq     .FinalCheck
    
    moveq   #15,d0      ; d0 = lane position
    moveq   #0,d1       ; d1 = banana count
.PositionLoop:
    move.w  lane1,d2
    btst    d0,d2
    beq     .NoBananaLane1
    addq    #1,d1
    cmp.b   #MAX_BANANAS,d1
    beq     .Finish

.NoBananaLane1:
    move.w  lane2,d2
    btst    d0,d2
    beq     .NoBananaLane2
    addq    #1,d1
    cmp.b   #MAX_BANANAS,d1
    beq     .Finish

.NoBananaLane2:
    move.w  lane3,d2
    btst    d0,d2
    beq     .NextPosition
    addq    #1,d1
    cmp.b   #MAX_BANANAS,d1
    beq     .Finish

.NextPosition:
    dbra    d0,.PositionLoop
    
.FinalCheck
    cmp.b   #MAX_BANANAS,d1
    
.Finish:
    rts
