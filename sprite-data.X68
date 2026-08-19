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
    dc.b    4, 50,20, 59,20, 59,29, 50,29, $2b,$8a,$3e, $ff,$f8,$5b                     ; square
testShapeSpriteSize dc.w $0000    ; $wwhh

;====================================================
;================== Palm Tree Sprite ================
;====================================================
palmTree:
    dc.b    11
    dc.b    3, 9,114,  55,95, 91,118, $ff,$d4,$3b, $fa,$b0,$05   ; island
    dc.b    3, 48,107, 51,73, 61,69,  $9c,$52,$0d, $9c,$52,$0d   ; trunk 1 *
    dc.b    3, 48,107, 61,69, 63,109, $9c,$52,$0d, $9c,$52,$0d   ; trunk 2
    dc.b    3, 51,73,  38,30, 47,29,  $9c,$52,$0d, $9c,$52,$0d   ; trunk 3 *
    dc.b    3, 51,73,  47,29, 61,69,  $9c,$52,$0d, $9c,$52,$0d   ; trunk 4
    dc.b    3, 47,36,  72,39, 77,73,  $47,$c8,$19, $33,$9c,$0d   ; leaf 1
    dc.b    3, 47,33,  77,20, 91,39,  $47,$c8,$19, $33,$9c,$0d   ; leaf 2
    dc.b    3, 44,33,  47,8,  76,0,   $47,$c8,$19, $33,$9c,$0d   ; leaf 3 *
    dc.b    3, 42,32,  32,8,  3,9,    $47,$c8,$19, $33,$9c,$0d   ; leaf 4 *
    dc.b    3, 42,34,  12,26, 0,46,   $47,$c8,$19, $33,$9c,$0d   ; leaf 5
    dc.b    3, 44,36,  14,49, 17,76,  $47,$c8,$19, $33,$9c,$0d   ; leaf 6
    dc.b    0   ; EVEN
palmTreeSpriteSize dc.w $0000    ; $wwhh

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
