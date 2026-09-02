************************************************************
* GitHub Copilot wrote the following functions.
* I tidied up variable names because they were all UPPERCASE.
* Also some debugging was required but Copilot did it all
* and I just applied the fixes. I mean, it works :)
************************************************************

CreateBananaLaneCurves:
    move.w  #490,startX
    move.w  #90,startY
    move.w  #345,midX
    move.w  #-150,midY
    move.w  #200,endX
    move.w  #360,endY
    bsr     GenerateBezierCurve
    bsr     PlotCurve
    bsr     OutputCurveToFile

    move.w  #490,startX
    move.w  #90,startY
    move.w  #395,midX
    move.w  #-150,midY
    move.w  #300,endX
    move.w  #360,endY
    bsr     GenerateBezierCurve
    bsr     PlotCurve
    move.b  #'2',CurveOutputFile+14
    bsr     OutputCurveToFile

    move.w  #490,startX
    move.w  #90,startY
    move.w  #445,midX
    move.w  #-150,midY
    move.w  #400,endX
    move.w  #360,endY
    bsr     GenerateBezierCurve
    bsr     PlotCurve
    move.b  #'3',CurveOutputFile+14
    bsr     OutputCurveToFile
    rts

GenerateBezierCurve:
    MOVEQ   #0,D0                ; i = 0
    MOVEQ   #0,D1
    MOVEQ   #0,D2
    MOVEQ   #0,D3
    MOVEQ   #0,D4
    MOVEQ   #0,D5
    MOVEQ   #0,D6
    MOVEQ   #0,D7
    LEA     pointX,A0
    LEA     pointY,A1

.loop:
    CMP.W   #32,D0
    BEQ     .done

    MOVE.W  D0,D1                ; D1 = i
    MOVE.W  D0,D2                ; D2 = i
    MULS.W  D2,D2                ; D2 = i * i

    MOVE.W  #31,D3               ; D3 = 31
    SUB.W   D1,D3                ; D3 = 31 - i

    MOVE.W  D3,D4                ; D4 = 31 - i
    MULS.W  D4,D4                ; D4 = (31 - i)^2

    MOVE.W  D1,D5                ; D5 = i
    MULS.W  D3,D5                ; D5 = i * (31 - i)
    ASL.L   #1,D5                ; D5 = 2 * i * (31 - i)

    ; Compute X = ((31-i)^2 * startX + 2*i*(31-i) * midX + i^2 * endX) / 31^2
    CLR.L   D6
    MOVE.W  startX,D6
    MULS.W  D4,D6                ; startX * (31-i)^2

    MOVE.W  midX,D7
    MULS.W  D5,D7                ; midX * 2*i*(31-i)
    ADD.L   D7,D6

    MOVE.W  endX,D7
    MULS.W  D2,D7                ; endX * i^2
    ADD.L   D7,D6

    MOVE.W  #961,D7
    DIVS.W  D7,D6                ; D6 = result / 961
    MOVE.W  D6,(A0)+             ; store X sample

    ; Compute Y = ((31-i)^2 * startY + 2*i*(31-i) * midY + i^2 * endY) / 31^2
    CLR.L   D6
    MOVE.W  startY,D6
    MULS.W  D4,D6                ; startY * (31-i)^2

    MOVE.W  midY,D7
    MULS.W  D5,D7                ; midY * 2*i*(31-i)
    ADD.L   D7,D6

    MOVE.W  endY,D7
    MULS.W  D2,D7                ; endY * i^2
    ADD.L   D7,D6

    MOVE.W  #961,D7
    DIVS.W  D7,D6                ; D6 = result / 961
    MOVE.W  D6,(A1)+             ; store Y sample

    ADDQ.W  #1,D0
    BRA     .loop

.done:
    rts

PlotCurve:
    LEA     pointX,A0
    LEA     pointY,A1

    MOVEQ   #31,D3
.outputLoop
    move.w  (A0)+,d1
    move.w  (A1)+,d2

    bsr     PlotPoint
    addq    #1,d1
    bsr     PlotPoint
    addq    #1,d2
    bsr     PlotPoint
    subq    #1,d1
    bsr     PlotPoint
    dbra    D3,.outputLoop

    rts

PlotPoint:                       ; plot a point at d1.w,d2.w
    moveq   #82,d0
    trap    #15
    rts

; Writes the generated x,y samples to a text file in CSV format:
; x1,y1
; x2,y2
; ...
; Easy68k file-trap usage:
; D0=52 create/open, D0=54 write, D0=56 close
OutputCurveToFile:
    lea     CurveOutputFile,A1   ; filename to create/open
    moveq   #0,D1                ; mode = create/truncate
    moveq   #52,D0               ; create/open file
    trap    #15
    move.l  D1,CurveFileHandle   ; handle returned in D1

    lea     pointX,A0
    lea     pointY,A4

    moveq   #31,D3               ; 32 points total
.writeLoop:
    move.w  (A0)+,D1             ; x value
    lea     CurveLineBuffer,A2

    bsr     WriteWordToAscii
    move.b  #',',(A2)+

    move.w  (A4)+,D1             ; y value
    
    bsr     WriteWordToAscii
    move.b  #10,(A2)+            ; newline
    clr.b   (A2)                 ; terminate string without adding it to the length

    move.l  A2,D2                ; keep end pointer in D2 for write length
    sub.l   #CurveLineBuffer,D2  ; compute bytes written

    move.l  CurveFileHandle,D1   ; file handle
    lea     CurveLineBuffer,A1   ; buffer to write
    move.w  D2,D2                ; low word length
    moveq   #54,D0               ; write file
    trap    #15

    dbra    D3,.writeLoop

    move.l  CurveFileHandle,D1   ; close handle
    moveq   #56,D0               ; close file
    trap    #15
    rts

; Converts a signed 16-bit value in D1 to ASCII at A2 and advances A2.
; Result is in decimal without leading spaces.
WriteWordToAscii:
    move.w  D1,D4
    ext.l   D4
    tst.w   D4
    bpl.s   .positive
    neg.l   D4
    move.b  #'-',(A2)+
.positive:
    lea     6(A2),A3             ; temporary space for up to five digits
    move.w  #0,D5                ; digit count

.convertLoop:
    divu    #10,D4               ; quotient in low word, remainder in high word
    move.l  D4,D6
    swap    D6                   ; copy remainder into the low word
    add.b   #'0',D6
    move.b  D6,-(A3)
    addq.w  #1,D5
    andi.l  #$0000ffff,D4
    tst.l   D4
    bne     .convertLoop

    move.w  D5,D7
    subq.w  #1,D7
.copyLoop:
    move.b  (A3)+,(A2)+
    dbra    D7,.copyLoop

.done:
    rts