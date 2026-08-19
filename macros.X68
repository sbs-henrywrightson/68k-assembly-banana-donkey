*-----------------------------------------------------------
* Title      : macros
* Written by : Henry Wrightson
* Date       : 18/8/2026
* Type       : Include file
* Depends on : 
* Description: Macros
*-----------------------------------------------------------

CacheRegisters macro
    movem.l d0-d7/a0-a6,-(a7)
    endm
    
CacheReservedRegisters macro
    movem.l d4-d7/a3-a6,-(a7)
    endm
    
CacheReservedDRegisters macro
    movem.l d4-d7,-(a7)
    endm

CacheReservedARegisters macro
    movem.l a3-a6,-(a7)
    endm

CacheScratchRegisters macro
    movem.l d0-d3/a0-a2,-(a7)
    endm

RestoreRegisters macro
    movem.l (a7)+,d0-d7/a0-a6
    endm
    
RestoreReservedRegisters macro
    movem.l (a7)+,d4-d7/a3-a6
    endm
    
RestoreReservedDRegisters macro
    movem.l (a7)+,d4-d7
    endm

RestoreReservedARegisters macro
    movem.l (a7)+,a3-a6
    endm

RestoreScratchRegisters macro
    movem.l (a7)+,d0-d3/a0-a2
    endm

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
