*-----------------------------------------------------------
* Title      : sprites
* Written by : Henry Wrightson
* Date       : 16/8/2026
* Type       : Program file
* Depends on : constants.x68, graphics.x68
* Description: Sprite data for the on-screen graphics, drawn with filled polygons
*            : The first byte is the number of polys in the sprite then after that
*            : each row is a poly.
*            : the first byte of the polygon is the number of vertices it has then
*            : it's words containing x,y bytes pairs. then fill and outline colours
*            : are 3-bytes each of $RR,$GG,$BB.
*            : It must be a convex polygon and the order of vertices matter because 
*            : it will draw the lines from each vertex and back to the start
*            : to close the polygon
*            : 
*            : vc, x,y, ..., fill, outline
*            : vc=number of vertices
*            : x,y=pairs of bytes for each vertex in the polygon
*            : fill=3-bytes for fill colour $RR,$GG,$BB
*            : outline=3-bytes for outline colour $RR,$GG,$B
*-----------------------------------------------------------

;====================================================
;===================== Test Sprite ==================
;====================================================
testSquare:
    dc.b    1
    dc.b    4, 0,0, 9,0, 9,9, 0,9, $d8,$de,$e9, $ff,$00,$00
testSquareSpriteSize dc.w $0000    ; $wwhh

testTriangle:
    dc.b    1
    dc.b    3, 0,0, 9,9, 0,9, $d8,$de,$e9, $ff,$00,$00
testTriangleSpriteSize dc.w $0000    ; $wwhh

testHexagon:
    dc.b    1
    dc.b    6, 0,27, 17,1, 50,0, 66,27, 53,53, 17,54, $d8,$de,$e9, $ff,$00,$00
testHexagonSpriteSize dc.w $0000    ; $wwhh

testShape:
    dc.b    3
    dc.b    3, 0,0, 9,9, 0,9, $fa,$a2,$c1, $5f,$3d,$c4                          ; triangle
    dc.b    6, 0,27, 17,1, 50,0, 66,27, 53,53, 17,54, $d8,$de,$e9, $ff,$00,$00  ; hexagon
    dc.b    4, 50,20, 59,20, 59,29, 50,29, $2b,$8a,$3e, $ff,$f8,$5b             ; square
testShapeSpriteSize dc.w $0000    ; $wwhh

;====================================================
;================== Palm Tree Sprite ================
;====================================================
palmTree:
    dc.b    8
    dc.b    7,  22,239, 73,247,  126,248, 180,239, 137,213, 87,208, 46,220, $ff,$d4,$3b, $fa,$b0,$05   ; island
    dc.b    6,  94,75,  129,74,  153,91,  163,121, 156,150, 128,102,        $47,$c8,$19, $33,$9c,$0d   ; leaf 1
    dc.b    6,  94,72,  145,71,  192,80,  182,59,  155,45,  120,47,         $47,$c8,$19, $33,$9c,$0d   ; leaf 2
    dc.b    5,  92,69,  90,44,   105,16,  130,0,   157,5,                   $47,$c8,$19, $33,$9c,$0d   ; leaf 3
    dc.b    5,  89,67,  84,34,   59,15,   34,12,   13,18,                   $47,$c8,$19, $33,$9c,$0d   ; leaf 4
    dc.b    6,  88,71,  53,54,   30,54,   19,68,   13,95,   47,76,          $47,$c8,$19, $33,$9c,$0d   ; leaf 5
    dc.b    6,  90,74,  52,79,   33,100,  27,125,  34,154,  55,107,         $47,$c8,$19, $33,$9c,$0d   ; leaf 6
    dc.b    10, 85,65,  91,63,   109,95,  127,146, 130,178, 127,212
    dc.b        98,210, 108,180, 110,156, 100,100,                          $9c,$52,$0d, $9c,$52,$0d   ; trunk
    dc.b    0   ; EVEN
palmTreeSpriteSize dc.w $0000    ; $wwhh

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
