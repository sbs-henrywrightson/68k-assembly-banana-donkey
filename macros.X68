*-----------------------------------------------------------
* Title      : macros
* Written by : Henry Wrightson
* Date       : 18/8/2026
* Type       : Include file
* Depends on : 
* Description: Macros
*-----------------------------------------------------------

SetSprite macro ; 1=sprite, 2=spriteSize, 3=spriteDBNumber, 4=x, 5=y, 6=scale, 7=flip
    lea     \1,a3
    move.w  \2,spriteSize
    move.w  \3,spriteDBNumber
    move.w  \4,spriteOrigin
    move.w  \5,spriteOrigin+2
    move.w  \6,spriteScale
    move.w  \7,spriteFlip
    endm

CacheRegisters macro
    movem.l d0-d7/a0-a6,-(a7)
    endm

RestoreRegisters macro
    movem.l (a7)+,d0-d7/a0-a6
    endm

CacheDataRegisters macro
    movem.l d0-d7,-(a7)
    endm

RestoreDataRegisters macro
    movem.l (a7)+,d0-d7
    endm

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
