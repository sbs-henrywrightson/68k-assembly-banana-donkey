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
