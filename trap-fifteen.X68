*-----------------------------------------------------------
* Title      : trap-fifteen
* Written by : Henry Wrightson
* Date       : 2/9/2026
* Type       : Include file
* Depends on : 
* Description: Trap #15 task functions so I don't have to
*            : keep remembering the task numbers!
*-----------------------------------------------------------

Trap15GetPixelColour:       ; get pixel colour - d1.w=x, d2.w=y, result in d0.l ($00BBGGRR)
    move.w  #83,d0
    trap    #15
    rts

Trap15SetPenColour:         ; get pen colour - d1=colour ($00BBGGRR)
    moveq   #80,d0
    trap    #15
    rts

Trap15PlotPixel:            ; draw pixel at x,y in pen colour - d1.w=x, d2.w=y
    moveq   #82,d0
    trap    #15
    rts

Trap15DrawFilledRectangle:        ; draw rectangle defined by from (x1=d1.w, y1=d2.w) to (x2=d3.w, y2=d4.w)
    moveq   #87,d0
    trap    #15
    rts
