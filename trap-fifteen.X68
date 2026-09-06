*-----------------------------------------------------------
* Title      : trap-fifteen
* Written by : Henry Wrightson
* Date       : 2/9/2026
* Type       : Include file
* Description: Trap #15 task functions so I don't have to
*            : keep remembering the task numbers!
*-----------------------------------------------------------

Trap15ReadKeyboard:
    moveq   #5,d0
    trap    #15
    rts

Trap15DisplayChar:          ; display the ascii character in d1.b
    move.w  #6,d0
    trap    #15
    rts

Trap15CheckKeyBuffer:
    moveq   #7,d0
    trap    #15
    rts

Trap15GetSystemTime:
    moveq   #8,d0
    trap    #15
    rts

Trap15ClearScreen:
    moveq   #11,d0
    move.w  #$ff00,d1
    trap    #15
    rts

Trap15SetCursor:            ; d1=coordinates (d1.w = $XXYY)
    moveq   #11,d0
    trap    #15
    rts

Trap15ZeroCursor:           ; set cursor to 0,0
    moveq   #0,d1
    move.w  $0000,d1
    bsr     Trap15SetCursor
    rts

Trap15EchoOff:
    moveq   #12,d0
    moveq   #0,d1
    trap    #15
    rts

Trap15DisplayText:          ; a0=null terminated text
    moveq   #14,d0
    trap    #15
    rts

Trap15DisplayDecimal:       ; d1=unsigned word number as a decimal
    moveq   #10,d2
    moveq   #15,d0
    trap    #15
    rts

Trap15KeyPressCheck:        ; check for any of the keys in d1 (d1.l = $K1K2K3K4) being pressed
    moveq   #19,d0
    trap    #15
    rts

Trap15SetScreenSize:
    move.b  #33,d0
    trap    #15
    rts

Trap15LoadWAVFile:
    moveq   #71,d0
    trap    #15
    rts

Trap15PlaySound:
    moveq   #72,d0
    trap    #15
    rts

Trap15SetPenColour:         ; set pen colour - d1=colour ($00BBGGRR)
    moveq   #80,d0
    trap    #15
    rts

Trap15SetFillColour:        ; set fill colour - d1=colour ($00BBGGRR)
    moveq   #81,d0
    trap    #15
    rts

Trap15PlotPixel:            ; draw pixel at x,y in pen colour - d1.w=x, d2.w=y
    moveq   #82,d0
    trap    #15
    rts

Trap15GetPixelColour:       ; get pixel colour - d1.w=x, d2.w=y, result in d0.l ($00BBGGRR)
    move.w  #83,d0
    trap    #15
    rts

Trap15DrawLine:             ; draw a line between (d1,d2) and (d3,d4)
    moveq   #84,d0
    trap    #15
    rts

Trap15DrawFilledBox:        ; draw rectangle defined by from (x1=d1.w, y1=d2.w) to (x2=d3.w, y2=d4.w)
    moveq   #87,d0
    trap    #15
    rts

Trap15DoubleBuffer:         ; draw to an off-screen screen buffer
    moveq   #92,d0
    moveq   #17,d1
    trap    #15
    rts

Trap15RepaintScreen:        ; switch off-screen frame buffer with on-screen one
    moveq   #94,d0
    trap    #15
    rts