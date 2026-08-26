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
;=============== Graphics Sub-routines ==============
;====================================================
InitialiseEnvironment:     ; set the output window
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

ClearScreen:            ; clear the screen
    move.l  #COLOUR_BACKGROUND,d1
    bsr     SetPenColour
    moveq   #11,d0
    move.w  #$ff00,d1
    trap    #15
    rts

SetPenColour:           ; set pen colour to d1.l ($00RRGGBB)
    bsr     ReverseRGB
    moveq   #80,d0
    trap    #15
    rts

SetBackgroundColour:    ; set background colour to d1.l ($00RRGGBB)
    bsr     ReverseRGB
    moveq   #81,d0
    trap    #15
    rts
    
PlotPoint:              ; plot a point at d1.w,d2.w
    moveq   #82,d0
    trap    #15
    rts

DrawLine:               ; draw a line between (d1.w,d2.w) and (d3.w,d4.w)
    moveq   #84,d0
    trap    #15

ReverseRGB:             ; convert d1 from $00RRGGBB to $00BBGGRR
    ror.w   #8,d1
    swap    d1
    lsl.w   #8,d1
    lsr.l   #8,d1

    rts

RepaintScreen:
    moveq   #94,d0
    trap    #15
    rts
