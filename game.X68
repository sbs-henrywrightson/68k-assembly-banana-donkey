*-----------------------------------------------------------
* Title      : game
* Written by : Henry Wrightson
* Date       : 20/8/2026
* Type       : Include file
* Depends on : 
* Description: The main entry point to the game
*-----------------------------------------------------------

;====================================================
;===                                              ===
;===              Game Sub-routines               ===
;===                                              ===
;====================================================
PlayGame:
    ;jsr     PositionSprite             ; DEBUG : move a sprite around to get position and scale

    bsr     DrawBackdrop
    bsr     DrawSceneSprites
    ;jsr     OutputDebugText            ; DEBUG : Remove
    bsr     InitialiseGame

    bsr     ShowWelcomeMessage
    jsr     RepaintScreen
    
    jsr     Trap15ReadKeyboardCharacter
    jsr     RepaintScreen

    jsr     HideMessageOverlay
    
    bsr     DisplayUI

    jsr     RepaintScreen

.gameLoop:
    moveq   #8,d0                       ; get the current system time
    trap    #15
    move.l  d1,systemTime
    
    ; MOVE BANANAS - is it time to move the bananas
    move.l  systemTime,d0
    sub.l   bananaMoveTime,d0
    cmp.l   #BANANA_MOVE_INTERVAL,d0
    blo     .skipMoveBananas
    bsr     MoveBananas
.skipMoveBananas:

    ; THROW BANANA - is it time to throw a banana
    move.l  systemTime,d0
    sub.l   bananaThrowTime,d0
    cmp.l   #BANANA_THROW_INTERVAL,d0   ; is it time to throw a banana
    blo     .skipThrow
    bsr     ThrowBanana
.skipThrow:

    ; MOVE DONKEY - always poll the keyboard to see if the donkey should move
    bsr     MoveDonkey

    bra     .gameLoop
    rts

DrawBackdrop:
    ; SKY
    move.l  #COLOUR_SKY,d1              ; fill
    jsr     SetBackgroundColour
    move.l  #COLOUR_SKY,d1              ; outline
    jsr     SetPenColour
    move.w  #0,d1                       ; x0
    move.w  #0,d2                       ; y0
    move.w  #650,d3                     ; x1
    move.w  #149,d4                     ; y1
    jsr     Trap15DrawFilledRectangle

    ; DESERT
    move.l  #COLOUR_SAND,d1             ; fill
    jsr     SetBackgroundColour
    move.l  #COLOUR_SAND,d1             ; outline
    jsr     SetPenColour
    move.w  #0,d1                       ; x0
    move.w  #150,d2                     ; y0
    move.w  #650,d3                     ; x1
    move.w  #419,d4                     ; y1
    jsr     Trap15DrawFilledRectangle

    ; SEA
    move.l  #COLOUR_SEA,d1              ; fill
    jsr     SetBackgroundColour
    move.l  #COLOUR_SEA,d1              ; outline
    jsr     SetPenColour
    move.w  #0,d1                       ; x0
    move.w  #420,d2                     ; y0
    move.w  #650,d3                     ; x1
    move.w  #480,d4                     ; y1
    jsr     Trap15DrawFilledRectangle
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

InitialiseGame:
    jsr     Trap15EchoOff

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

    ; DONKEY
    move.w  #1,donkeyLane
    move.w  #DONKEY_LANE2_X,d0
    move.w  d0,donkeyX
    move.w  #0,donkeyOrientation
    bsr     DisplayDonkey

    ;        BANANAS
    move.l  #0,bananaThrowTime
    move.w  #0,score
    move.w  #5,lives

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

    rts

ShowWelcomeMessage:
    jsr     ShowMessageOverlay

    move.l  #COLOUR_YELLOW,d1
    jsr     SetPenColour

    bsr     GetBoxCentre

    ; Banana Donkey
    SetFont gameFont,#GAME_FONT_HEIGHT,#3,#1
    lea     gameNameText,a0
    move.w  d1,textX
    move.w  d2,textY
    addi.w  #40,textX
    addi.w  #22,textY
    bsr     RenderText

    ; Instructions
    SetFont gameFont,#GAME_FONT_HEIGHT,#1,#0
    lea     instructionText,a0
    move.w  d1,textX
    move.w  d2,textY
    addi.w  #20,textX
    addi.w  #70,textY
    bsr     RenderParagraph
    
    ; Press a key
    lea     pressKeyText,a0
    move.w  d1,textX
    move.w  d2,textY
    addi.w  #80,textX
    addi.w  #170,textY
    bsr     RenderText
    rts

DisplayUI:
    move.l  #COLOUR_WHITE,d1
    jsr     SetPenColour
    SetFont gameFont,#GAME_FONT_HEIGHT,#3,#1
    
    lea     scoreText,a0
    move.w  #SCORE_TEXT_X,textX
    move.w  #SCORE_LINE_Y_HI,textY
    jsr     RenderText

    lea     livesText,a0
    move.w  #LIVES_TEXT_X,textX
    move.w  #SCORE_LINE_Y_HI,textY
    jsr     RenderText

    bsr     DisplayScore
    rts

DisplayScore:
    CacheDataRegisters

    bsr     ClearScore

    move.l  #COLOUR_WHITE,d1
    jsr     SetPenColour
    SetFont gameFont,#GAME_FONT_HEIGHT,#3,#1

    move.w  score,d0
    move.w  #SCORE_X,textX
    move.w  #SCORE_LINE_Y_HI,textY
    jsr     RenderNumber

    move.w  lives,d0
    move.w  #LIVES_X,textX
    move.w  #SCORE_LINE_Y_HI,textY
    jsr     RenderNumber

    RestoreDataRegisters
    rts

ClearScore:
    move.l  #$002ee6,d1
    jsr     SetBackgroundColour
    move.l  #$002ee6,d1
    jsr     SetPenColour

    move.w  #SCORE_X,d1
    move.w  #SCORE_LINE_Y_HI,d2
    move.w  #SCORE_X+SCORE_WIDTH,d3
    move.w  #SCORE_LINE_Y_LO,d4
    jsr     Trap15DrawFilledRectangle

    move.w  #LIVES_X,d1
    move.w  #SCORE_LINE_Y_HI,d2
    move.w  #LIVES_X+LIVES_WIDTH,d3
    move.w  #SCORE_LINE_Y_LO,d4
    jsr     Trap15DrawFilledRectangle
    rts

ShowFiredMessage:
    jsr     ShowMessageOverlay

    move.l  #COLOUR_BRT_GREEN,d1
    jsr     SetPenColour

    bsr     GetBoxCentre

    ; Banana Donkey
    SetFont gameFont,#GAME_FONT_HEIGHT,#3,#1
    lea     gameNameText,a0
    move.w  d1,textX
    move.w  d2,textY
    addi.w  #40,textX
    addi.w  #22,textY
    bsr     RenderText

    ; Instructions
    SetFont gameFont,#GAME_FONT_HEIGHT,#1,#0
    lea     instructionText,a0
    move.w  d1,textX
    move.w  d2,textY
    addi.w  #20,textX
    addi.w  #70,textY
    bsr     RenderParagraph
    
    ; Press a key
    lea     pressKeyText,a0
    move.w  d1,textX
    move.w  d2,textY
    addi.w  #80,textX
    addi.w  #170,textY
    bsr     RenderText
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

    ;jsr     OutputDebugText            ; DEBUG : REMOVE
    ;bsr     RenderLaneContents         ; DEBUG : REMOVE
    jsr     PlayThrowSound
    jsr     RepaintScreen
.endEvent:
    rts

MoveBananas:
    move.l  systemTime,bananaMoveTime

    bclr    #1,gameFlags                ; clear the banana/donkey collision flag
    bclr    #2,gameFlags                ; clear the banana hit ground flag

    move.l  lane1,d0
    btst    #31,d0
    beq     .shiftLane1
    subq    #1,bananaCount              ; banana dropped off the end so subtract 1
    bset    #2,gameFlags                ; set the banana hit ground flag
.shiftLane1:
    lsl.l   #1,d0
    move.l  d0,lane1
    
    move.l  lane2,d0
    btst    #31,d0
    beq     .shiftLane2
    subq    #1,bananaCount              ; banana dropped off the end so subtract 1
    bset    #2,gameFlags                ; set the banana hit ground flag
.shiftLane2:
    lsl.l   #1,d0
    move.l  d0,lane2
    
    move.l  lane3,d0
    btst    #31,d0
    beq     .shiftLane3
    subq    #1,bananaCount              ; banana dropped off the end so subtract 1
    bset    #2,gameFlags                ; set the banana hit ground flag
.shiftLane3:
    lsl.l   #1,d0
    move.l  d0,lane3

    bsr     BananaCollisionCheck
    bsr     BananaCatchCheck

    ;jsr     OutputDebugText             ; DEBUG : REMOVE

    btst    #1,gameFlags                ; has the banana collided with the donkey
    bne     .donkeyCollision
    btst    #2,gameFlags                ; has a banana hit the ground
    bne     .donkeyCollision
    bsr     RenderLaneContents          ; banana/donkey collision hasn't occurred so just render the lane contents
    bra     .moveComplete
.donkeyCollision:
    bsr     RemoveDonkey                ; banana/donkey collision has occurred so remove the donkey before rendering the lane contents
    bsr     RenderLaneContents
    bsr     DisplayDonkey

.moveComplete:
    btst    #2,gameFlags                ; has a banana been dropped
    beq     .finished
    sub.w   #1,lives
    bsr     DisplayScore
    jsr     PlayDropSound

.finished:
    jsr     RepaintScreen

    rts

MoveDonkey:
    ;move.l  systemTime,d0
    ;sub.l   donkeyMoveTime,d0           ; debounce this event to prevent the donkey from moving too fast
    ;cmp.l   #DONKEY_MOVE_INTERVAL,d0    ; has it been long enough since the last donkey move to poll the keyboard again
    ;blo     .finishedMoving

    moveq   #19,d0
    move.l  #$00004144,d1  ; check for keypress a,d keys
    trap    #15

    move.w  donkeyLane,d0

    btst.l  #8,d1
    bne     .left

    btst.l  #0,d1
    bne     .right
    rts

.left:
    cmp.w   #0,d0                       ; if donkey is in lane 1, don't move left
    beq     .finishedMoving
    sub.w   #1,d0
    bra     .move
.right:
    cmp.w   #2,d0                       ; if donkey is in lane 3, don't move right
    beq     .finishedMoving
    add.w   #1,d0

.move:
    bsr     RemoveDonkey
    move.w  d0,donkeyLane
    bsr     DisplayDonkey
    move.l  systemTime,donkeyMoveTime

.finishedMoving:
    rts


RemoveDonkey:
    SetSprite donkey,donkeySpriteSize,#DONKEY_DB_NUMBER,donkeyX,#DONKEY_Y,#DONKEY_SCALE,donkeyOrientation
    jsr     RestoreDirtyRectangle
    rts

DisplayDonkey:
    cmp.w   #0,donkeyLane
    beq     .setLane1
    cmp.w   #1,donkeyLane
    beq     .setLane2
    bra     .setLane3
.setLane1:
    move.w  #DONKEY_LANE1_X,d0
    bra     .display
.setLane2:
    move.w  #DONKEY_LANE2_X,d0
    bra     .display
.setLane3:
    move.w  #DONKEY_LANE3_X,d0
.display:
    move.w  d0,donkeyX
    bsr     PlotDonkey
    rts

PlotDonkey:
    SetSprite donkey,donkeySpriteSize,#DONKEY_DB_NUMBER,donkeyX,#DONKEY_Y,#DONKEY_SCALE,donkeyOrientation
    jsr     SaveDirtyRectangle
    jsr     DrawSprite
    rts

BananaCollisionCheck:
    move.w  donkeyLane,d0
    cmp.w   #0,d0
    beq     .checkLane1
    cmp.w   #1,d0
    beq     .checkLane2
    bra     .checkLane3

.checkLane1:
    move.l  lane1,d1
    bra     .checkBits
.checkLane2:
    move.l  lane2,d1
    bra     .checkBits
.checkLane3:
    move.l  lane3,d1

.checkBits:
    andi.l  #$E0000000,d1               ; check the last three bits of the lane
    beq     .endChecks                  ; if they're all clear don't do anything
    bset    #1,gameFlags                ; set the banana/donkey collision flag

.endChecks:
    rts

BananaCatchCheck:
    move.w  donkeyLane,d0
    cmp.w   #0,d0
    beq     .checkLane1
    cmp.w   #1,d0
    beq     .checkLane2
    bra     .checkLane3

.checkLane1:
    move.l  lane1,d1
    bsr     ClearCaughtBananas
    move.l  d1,lane1
    bra     .endChecks
.checkLane2:
    move.l  lane2,d1
    bsr     ClearCaughtBananas
    move.l  d1,lane2
    bra     .endChecks
.checkLane3:
    move.l  lane3,d1
    bsr     ClearCaughtBananas
    move.l  d1,lane3

.endChecks:
    rts

ClearCaughtBananas:                     ; remove the bananas that have been caught by the donkey
    btst    #30,d1
    beq     .bit31                      ; if the bit is clear check the next bit
    bclr    #30,d1
    subq    #1,bananaCount
    add.w   #1,score
    bsr     DisplayScore
    jsr     PlayCatchSound
.bit31:
    btst    #31,d1
    beq     .finished                   ; if the bit is clear finish with the checks
    bclr    #31,d1
    subq    #1,bananaCount
    add.w   #1,score
    bsr     DisplayScore
    jsr     PlayCatchSound
.finished:
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
* a6 = lane 3 positions
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
.removeBanana:
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

RemoveMonkey:
    btst    #0,gameFlags
    beq     .noFlip
    SetSprite monkey,monkeySpriteSize,#MONKEY_DB_NUMBER,#MONKEY_X,#MONKEY_Y,#MONKEY_SCALE,monkeyOrientation
    jsr     RestoreDirtyRectangle
.noFlip:
    rts

FlipMonkey:
    btst    #0,gameFlags
    beq     .noFlip
    eori.w  #1,monkeyOrientation
    bsr     DrawMonkey
    bclr    #0,gameFlags
.noFlip:
    rts

DrawMonkey:
    SetSprite monkey,monkeySpriteSize,#MONKEY_DB_NUMBER,#MONKEY_X,#MONKEY_Y,#MONKEY_SCALE,monkeyOrientation
    jsr     SaveDirtyRectangle
    jsr     DrawSprite
    rts