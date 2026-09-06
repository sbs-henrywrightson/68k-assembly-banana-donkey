*-----------------------------------------------------------
* Title      : sounds
* Written by : Henry Wrightson
* Date       : 1/9/2026
* Type       : Include file
* Description: Load the sound files into memory
*-----------------------------------------------------------

;====================================================
;===                                              ===
;===              Sound Sub-routines              ===
;===                                              ===
;====================================================

LoadSounds:                             ; load all the sound files into memory
    lea     squelchFilePath,a1
    moveq   #SQUELCH_SOUND_ID,d1
    jsr     Trap15LoadWAVFile

    lea     scrumpleFilePath,a1
    moveq   #SCRUMPLE_SOUND_ID,d1
    jsr     Trap15LoadWAVFile

    lea     Monkey1FilePath,a1
    moveq   #MONKEY_1_SOUND_ID,d1
    jsr     Trap15LoadWAVFile

    lea     Monkey2FilePath,a1
    moveq   #MONKEY_2_SOUND_ID,d1
    jsr     Trap15LoadWAVFile

    lea     Monkey3FilePath,a1
    moveq   #MONKEY_3_SOUND_ID,d1
    jsr     Trap15LoadWAVFile

    lea     Monkey4FilePath,a1
    moveq   #MONKEY_4_SOUND_ID,d1
    jsr     Trap15LoadWAVFile

    lea     Monkey5FilePath,a1
    moveq   #MONKEY_5_SOUND_ID,d1
    jsr     Trap15LoadWAVFile

    lea     Monkey6FilePath,a1
    moveq   #MONKEY_6_SOUND_ID,d1
    jsr     Trap15LoadWAVFile
    rts

PlayCatchSound:                         ; banana caught by donkey
    CacheRegisters

    moveq   #SCRUMPLE_SOUND_ID,d1
    bsr     PlaySound

    RestoreRegisters
    rts

PlayDropSound:                          ; banana hits the ground
    CacheRegisters
    
    moveq   #SQUELCH_SOUND_ID,d1
    bsr     PlaySound

    RestoreRegisters
    rts

PlayThrowSound:                         ; monkey throws a banana
    CacheRegisters

    moveq   #6,d1
    jsr     RandomChance
    cmp.w   #1,d2
    beq     .throwSound1
    cmp.w   #2,d2
    beq     .throwSound2
    cmp.w   #3,d2
    beq     .throwSound3
    cmp.w   #4,d2
    beq     .throwSound4
    cmp.w   #5,d2
    beq     .throwSound5
    bra     .throwSound6

.throwSound1:
    moveq   #MONKEY_1_SOUND_ID,d1
    bra     .playSound
.throwSound2:
    moveq   #MONKEY_2_SOUND_ID,d1
    bra     .playSound
.throwSound3:
    moveq   #MONKEY_3_SOUND_ID,d1
    bra     .playSound
.throwSound4:
    moveq   #MONKEY_4_SOUND_ID,d1
    bra     .playSound
.throwSound5:
    moveq   #MONKEY_5_SOUND_ID,d1
    bra     .playSound
.throwSound6:
    moveq   #MONKEY_6_SOUND_ID,d1


.playSound:
    bsr     PlaySound

    RestoreRegisters
    rts

PlaySound:                              ; play the sound who's ID is in d1
    move.l  systemTime,d0
    sub.l   playSoundTime,d0            ; debounce this event to prevent sounds overlapping each other
    cmp.l   #PLAY_SOUND_INTERVAL,d0     ; has it been long enough since the last sound played
    blo     .finish
    jsr     Trap15PlaySound
.finish
    rts