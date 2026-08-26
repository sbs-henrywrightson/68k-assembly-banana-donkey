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
Game:
    ;jsr     TestFrameRate
    ;jsr     PositionSprite

    jsr     ClearScreen
    bsr     DrawBackdrop
    bsr     DrawSceneSprites
    jsr     RepaintScreen

.GameLoop
    bra     .GameLoop
    rts
    
DrawBackdrop:
    ; SKY
    move.l  #$0070c1ff,d1        ; fill
    jsr     SetBackgroundColour
    move.l  #$0070c1ff,d1        ; outline
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
