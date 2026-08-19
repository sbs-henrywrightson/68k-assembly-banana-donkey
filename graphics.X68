*-----------------------------------------------------------
* Title      : graphics
* Written by : Henry Wrightson
* Date       : 16/8/2026
* Type       : Include file
* Depends on : constants.x68
* Description: Sub-routines used for graphics. Mainly wrappers
*            : for trap #15 tasks
*-----------------------------------------------------------

InitialiseEnvironment:     ; set the output window
    move.b  #33,d0
    move.l  #RES_X*$10000+RES_Y,d1
    trap    #15
    
    bsr     ClearScreen
    
    rts

ClearScreen:            ; clear the screen
    move    #0,d0
    bsr     SetPenColour
    moveq   #11,d0
    move.w  #$ff00,d1
    trap    #15
    rts

SetPenColour:           ; set pen colour to d1.l ($00BBGGRR)
    moveq   #80,d0
    trap    #15
    rts

SetBackgroundColour:    ; set background colour to d1.l ($00BBGGRR)
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

MoveRGBToD1:            ; place the colours in Red, Green, Blue variables into d1.l as $00BBGGRR
    moveq   #0,d1
    move.b  blue,d1
    lsl.l   #8,d1
    or.b    green,d1
    lsl.l   #8,d1
    or.b    red,d1
    rts

;===================================================
;================ colour variables =================
;===================================================
red     dc.b    0
green   dc.b    0
blue    dc.b    0
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
