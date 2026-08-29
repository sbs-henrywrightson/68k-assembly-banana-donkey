*-----------------------------------------------------------
* Title      : core
* Written by : Henry Wrightson
* Date       : 18/8/2026
* Type       : Include file
* Depends on : 
* Description: Core functions
*-----------------------------------------------------------

;====================================================
;======================= Core =======================
;====================================================
Wait:       ; wait for d1/100ths of a second
    moveq   #23,d0
    trap    #15
    rts

GetRandomNumber:     ; return a 32bit psudo-random number in d0 using Marsaglia's Xorshift algorithm
    move.l  randomSeed,d0
    lsl.l   #8,d0
    lsl.l   #5,d0
    eor.l   d0,randomSeed

    move.l  randomSeed,d0
    lsr.l   #8,d0
    lsr.l   #8,d0
    lsr.l   #1,d0
    eor.l   d0,randomSeed

    move.l  randomSeed,d0
    lsl.l   #5,d0
    eor.l   d0,randomSeed

    move.l  randomSeed,d0
    rts

RandomChance:       ; test if a random number is between 1 and the value in d1
    bsr     GetRandomNumber

    moveq   #0,d2
    move.w  d0,d2
    divu    d1,d2
    swap    d2
    tst.w   d2
    rts
