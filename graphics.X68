*-----------------------------------------------------------
* Title      : graphics
* Written by : Henry Wrightson
* Date       : 16/8/2026
* Type       : Include file
* Depends on : constants.x68
* Description: Sub-routines used for graphics. Mainly wrappers
*            : for trap #15 tasks
*-----------------------------------------------------------

;====================================================
;===                                              ===
;===             Graphics Sub-routines            ===
;===                                              ===
;====================================================
InitialiseGraphics:          ; set the output window
    bsr     SetScreenResolution
    bsr     SetDoubleBufferMode
    bsr     ClearScreen
    
    rts

SetScreenResolution:
    move.b  #33,d0
    move.l  #RES_X*$10000+RES_Y,d1
    trap    #15
    rts

SetDoubleBufferMode:
    moveq   #92,d0
    moveq   #17,d1
    trap    #15
    rts

ClearScreen:                    ; clear the screen
    move.l  #COLOUR_BACKGROUND,d1
    bsr     SetPenColour
    moveq   #11,d0
    move.w  #$ff00,d1
    trap    #15
    rts

SetPenColour:                   ; set pen colour to d1.l ($00RRGGBB)
    bsr     ReverseRGB
    moveq   #80,d0
    trap    #15
    rts

SetBackgroundColour:            ; set background colour to d1.l ($00RRGGBB)
    bsr     ReverseRGB
    moveq   #81,d0
    trap    #15
    rts
    
PlotPoint:                      ; plot a point at d1.w,d2.w
    moveq   #82,d0
    trap    #15
    rts

DrawLine:                       ; draw a line between (d1.w,d2.w) and (d3.w,d4.w)
    moveq   #84,d0
    trap    #15

ReverseRGB:                     ; convert d1 from $00RRGGBB to $00BBGGRR
    ror.w   #8,d1
    swap    d1
    lsl.w   #8,d1
    lsr.l   #8,d1

    rts

RepaintScreen:
    moveq   #94,d0
    trap    #15
    rts

PlotNumber:                     ; plot the 5-digit number in d0 as pixels at digitPlotX,digitPlotY
    bsr     BuildDigitBuffer
    bsr     PlotDigits
    rts

BuildDigitBuffer:               ; build digit buffer so the number can be read from left to right. d0=number
    move.l  d0,d1
    lea     digitBuffer,a0      ; point just past buffer
    adda.w  #5,a0               ; maximum of 5 digits so the number fits in a word
    move.b  #0,digitCount

.getDigit:
    divu    #10,d1              ; quotient in low word, remainder in high word

    swap    d1                  ; remainder -> low word
    move.b  d1,-(a0)            ; store it
    addq.b  #1,digitCount       ; increment the digit counter

    swap    d1                  ; quotient back to low word
    andi.l  #$0000ffff,d1

    tst.w   d1
    bne     .getDigit
    rts

PlotDigits:                     ; d0 = number to plot
    moveq   #0,d4
    move.b  digitCount,d4
    subi.b  #1,d4
.digitLoop:
    moveq   #0,d0
    move.b  (a0)+,d0            ; read digit from buffer
    
    lea     digitsFont,a1
    lsl.w   #3,d0               ; digit * 8
    adda.w  d0,a1

    moveq   #0,d0
    moveq   #7,d3
.digitLineLoop:
    move.b  (a1)+,d0            ; read first bit line of digit into d0
    move.b  #7,digitPlotLine
    sub.b   d3,digitPlotLine
    bsr     PlotBitLine

    dbra    d3,.digitLineLoop

    dbra    d4,.digitLoop
    rts

PlotBitLine:                    ; d4 = digit counter
    CacheDataRegisters

    move    d0,d5
    move.b  #7,d3
.bitLineLoop:
    btst    d3,d5
    beq     .noPixel

    moveq   #0,d0
    move.b  fontSize,d0

    moveq   #0,d1
    move.b  digitCount,d1
    subq    #1,d1
    sub.b   d4,d1               ; start with current zero-based digit position 
    mulu    #8,d1               ; shift along 8bits for each digit displayed
    addq    #7,d1
    sub.b   d3,d1               ; add the number of bits along the line
    mulu.w  d0,d1               ; increase font size by multiples of fontSize
    add.w   digitPlotX,d1       ; add the x position

    moveq   #0,d2
    add.b   digitPlotLine,d2    ; the y is simply the current line
    mulu.w  d0,d2               ; increase font size by multiples of fontSize
    add.w   digitPlotY,d2       ; add the y position

    moveq   #82,d0
    trap    #15

    moveq   #0,d0       ; DEBUG : these turn a single pixel into a block of 4
    move.b  fontBold,d0
    tst.b   d0
    beq     .skipBold
    moveq   #82,d0
    addq    #1,d1
    trap    #15
    addq    #1,d2
    trap    #15
    subq    #1,d1
    trap    #15
.skipBold:

.noPixel:
    dbra    d3,.bitLineLoop

    RestoreDataRegisters
    rts

ShowMessageOverlay:
    move.w  #300,width
    move.w  #200,height
    bsr     GetBoxCentre

    SetOverlay 0,d1,d2,#99,#99      ; 1,1
    bsr     PlaceOverlay

    addi    #100,d1                 ; 2,1
    SetOverlay 1,d1,d2,#99,#99
    bsr     PlaceOverlay

    addi    #100,d1                 ; 3,1
    SetOverlay 2,d1,d2,#99,#99
    bsr     PlaceOverlay

    addi    #100,d2                 ; 3,2
    SetOverlay 3,d1,d2,#99,#99
    bsr     PlaceOverlay

    subi    #100,d1                 ; 2,2
    SetOverlay 4,d1,d2,#99,#99
    bsr     PlaceOverlay

    subi    #100,d1                 ; 1,2
    SetOverlay 5,d1,d2,#99,#99
    bsr     PlaceOverlay

    move.l  #COLOUR_YELLOW,d1
    jsr     SetPenColour
    move.l  #COLOUR_YELLOW,d1
    jsr     SetBackgroundColour

    move.w  #300,width
    move.w  #200,height
    bsr     GetBoxCentre
    move.w  d1,x
    move.w  d2,y
    move.w  #3,border
    bsr     DrawBorder

    move.l  #COLOUR_GREEN,d1
    bsr     SetPenColour
    move.w  #1,border
    bsr     DrawBorder
    
    rts

HideMessageOverlay:
    move.w  #300,width
    move.w  #200,height
    bsr     GetBoxCentre

    SetOverlay 0,d1,d2,#99,#99
    bsr     RemoveOverlay

    addi    #100,d1
    SetOverlay 1,d1,d2,#99,#99
    bsr     RemoveOverlay
    
    addi    #100,d1
    SetOverlay 2,d1,d2,#99,#99
    bsr     RemoveOverlay

    addi    #100,d2
    SetOverlay 3,d1,d2,#99,#99
    bsr     RemoveOverlay

    subi    #100,d1
    SetOverlay 4,d1,d2,#99,#99
    bsr     RemoveOverlay

    subi    #100,d1
    SetOverlay 5,d1,d2,#99,#99
    bsr     RemoveOverlay
    rts

GetBoxCentre:                           ; given a box of width,height find the x,y where it would be centred
    move.w  #RES_X,d0
    sub.w   width,d0
    divu    #2,d0
    move.w  d0,d1

    move.w  #RES_Y,d0
    sub.w   height,d0
    divu    #2,d0
    move.w  d0,d2
    rts

PlaceOverlay:                           ; display an overlay by lowering the pixel luminosity for an area at (d1,d2) size d3 x d4
    CacheRegisters

    jsr     SaveDirtyRectangle

    move.w  #0,x
    move.w  #0,y
    moveq   #0,d6
    move.b  spriteSize+1,d6
.yLoop:
    moveq   #0,d5
    move.b  spriteSize,d5
.xLoop:
    moveq   #0,d0
    move.b  d5,d0
    add.w   spriteOrigin,d0
    move.w  d0,x
    moveq   #0,d0
    move.b  d6,d0
    add.w   spriteOrigin+2,d0
    move.w  d0,y

    move.w  x,d1
    move.w  y,d2
    jsr     Trap15GetPixelColour

    ; darken pixel element by a variable factor. Each pixel element needs doing d0=Red/Blue/Green
    ;mulu    #DARKEN_FACTOR_30,d0
    ;lsr.l   #8,d0

    ; darken pixel colour by 50%
    and.l   #$00FEFEFE,d0
    lsr.l   #1,d0

    move.l  d0,d1
    jsr     Trap15SetPenColour

    move.w  x,d1
    move.w  y,d2
    jsr     Trap15PlotPixel

    dbra    d5,.xLoop
    dbra    d6,.yLoop

    RestoreRegisters
    rts

RemoveOverlay:                          ; restore the pixel colour values for the overlay at (d1,d2) size d3 x d4
    CacheRegisters

    jsr     RestoreDirtyRectangle

    RestoreRegisters
    rts

DrawBorder:                             ; draw a border at (x, y) of dimensions: width x height
    sub.w   #1,width
    sub.w   #1,height

    ; top border
    move.w  x,d1
    move.w  y,d2
    move.w  x,d3
    add.w   width,d3
    move.w  y,d4
    add.w   border,d4
    jsr     Trap15DrawFilledRectangle

    ; right border
    move.w  d3,d1
    move.w  d4,d2
    sub.w   border,d3
    add.w   height,d4
    sub.w   border,d4
    sub.w   border,d4
    jsr     Trap15DrawFilledRectangle

    ; bottom border
    move.w  d3,d1
    add.w   border,d1
    move.w  d4,d2
    add.w   border,d2
    add.w   border,d3
    sub.w   width,d3
    jsr     Trap15DrawFilledRectangle

    ; left border
    move.w  d3,d1
    move.w  d4,d2
    add.w   border,d3
    add.w   border,d4
    add.w   border,d4
    sub.w   height,d4
    jsr     Trap15DrawFilledRectangle

    add.w   #1,width
    add.w   #1,height
    rts

RenderParagraph:                    ; a0=paragraph, d1=x, d2=y
    move.w  textX,d1
.lineLoop
    move.w  d1,textX

    bsr     RenderText

    add.w  #13,textY
    move.b  (a0),d0
    tst.b   d0
    bne     .lineLoop

    rts

RenderText:                         ; render the text in a0 at textX,textY, don't forget to use SetFont
    CacheDataRegisters

.characterLoop:
    moveq   #0,d0
    move.b  (a0)+,d0
    tst.b   d0
    beq     .finishRender

    subi.b  #32,d0                  ; the ASCII code of the first character in the font set

.render:
    mulu    #12,d0                  ; total bytes per character
    moveq   #0,d1
    move.b  characterHeight,d1
    move.l  d1,d6                   ; total glyph rows per character

    move.b  (a1,d0.w),d1
    subi    #1,d1
    move.b  d1,characterWidth
    addq    #1,d0
    move.w  d0,fontCharacterOffset

    move.w  textY,d4
.rowLoop:
    move.w  fontCharacterOffset,d0
    move.b  (a1,d0.w),d2
    cmpi.b  #0,d2
    beq     .finishedBits

    move.b  d2,characterRowBits
    moveq   #0,d5
    move.b  characterWidth,d5
    move.b  #7,d7
    move.w  textX,d3
.bitLoop:
    btst    d7,characterRowBits
    bne     .one
.zero:
    bra     .nextBit
.one:
    move.w  d3,d1
    move.w  d4,d2
    jsr     PlotPoint
    tst.b   fontBold
    beq     .nextBit

    ; 3 more pixels to make the single pixel a 2x2 block
    addi    #1,d1
    jsr     PlotPoint
    addi    #1,d2
    jsr     PlotPoint
    subi    #1,d1
    jsr     PlotPoint

.nextBit:
    moveq   #0,d0
    move.b  fontSize,d0
    add.w   d0,d3                     ; scaling factor
    subi    #1,d7

    dbra    d5,.bitLoop

.finishedBits:
    addq    #1,fontCharacterOffset
    moveq   #0,d0
    move.b  fontSize,d0
    add.w   d0,d4                     ; scaling factor
    dbra    d6,.rowLoop

.finishedCharacter:
    moveq   #0,d0
    move.b  fontSize,d0

    moveq   #0,d1
    move.b  characterWidth,d1
    addi    #2,d1
    mulu.w  d0,d1                     ; scaling factor
    add.w   d1,textX
    bra     .characterLoop
    rts

.finishRender:
    RestoreDataRegisters
    rts