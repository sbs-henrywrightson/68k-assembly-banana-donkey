*-----------------------------------------------------------
* Title      : diagnostics
* Written by : Henry Wrightson
* Date       : 17/8/2026
* Type       : Program file
* Depends on : 
* Description: Sub-routines used for debugging the main app
*-----------------------------------------------------------

;====================================================
;==================== Diagnostics ===================
;====================================================
ClearCycleCounter:
    moveq   #30,d0
    trap    #15
    rts

DisplayCycleCounter:
    moveq   #31,d0
    trap    #15

    lea     cycleMessage,a1
    moveq   #14,d0
    trap    #15
    
    moveq   #15,d0
    moveq   #10,d2
    trap    #15
    rts
