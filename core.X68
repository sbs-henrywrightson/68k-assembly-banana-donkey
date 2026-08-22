*-----------------------------------------------------------
* Title      : core
* Written by : Henry Wrightson
* Date       : 18/8/2026
* Type       : Include file
* Depends on : 
* Description: Core functions
*-----------------------------------------------------------

Wait:       ; wait for d1/100ths of a second
    moveq   #23,d0
    trap    #15
    rts

GetKey:
    
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
