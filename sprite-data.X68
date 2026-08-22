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
;======================= Sprites ====================
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

sandDune:
    dc.b    7
    dc.b    6, 0,45,   86,8,   119,3,  185,30, 246,46, 121,50, $da,$9a,$1e, $75,$4b,$08   ; dune
    dc.b    3, 47,28,  61,15,  71,21,                          $12,$8d,$00, $0c,$48,$00   ; grass 1
    dc.b    3, 82,18,  99,0,   106,9,                          $12,$8d,$00, $0c,$48,$00   ; grass 2
    dc.b    3, 66,22,  75,5,   90,17,                          $12,$8d,$00, $0c,$48,$00   ; grass 3
    dc.b    3, 133,16, 150,7,  159,25,                         $12,$8d,$00, $0c,$48,$00   ; grass 4
    dc.b    3, 118,5,  130,1,  139,18,                         $12,$8d,$00, $0c,$48,$00   ; grass 5
    dc.b    3, 152,24, 167,17, 194,33,                         $12,$8d,$00, $0c,$48,$00   ; grass 6
sandDuneSpriteSize dc.w $0000    ; $wwhh

seaFoam:
    dc.b    5
    dc.b    7, 0,18,   16,16, 26,11,  48,12,  48,29,  25,32, 0,29,      $dc,$fd,$ff, $dc,$fd,$ff    ; foam 1
    dc.b    7, 48,12,  73,11, 84,5,   106,9,  106,20, 75,30, 48,29,     $dc,$fd,$ff, $dc,$fd,$ff    ; foam 2
    dc.b    6, 106,9,  141,0, 172,5,  172,17, 143,25, 106,20,           $dc,$fd,$ff, $dc,$fd,$ff    ; foam 3
    dc.b    7, 172,5,  189,2, 209,9,  232,12, 232,22, 199,23, 172,17,   $dc,$fd,$ff, $dc,$fd,$ff    ; foam 4
    dc.b    6, 232,12, 247,9, 254,14, 254,23, 243,27, 232,22,           $dc,$fd,$ff, $dc,$fd,$ff    ; foam 5
seaFoamSpriteSize dc.w $0000    ; $wwhh

banana:
    dc.b    5
    dc.b    12, 36,11,   48,10,   42,47,   67,92,   113,137, 174,153
    dc.b        229,163, 185,181, 136,181, 81,160,  41,117,  29,47,      $ff,$dd,$31, $fe,$bc,$13    ; banana 1
    dc.b    14, 25,7,    35,10,   29,45,   42,118,  81,160,  137,181
    dc.b        184,182, 203,196, 156,210, 101,202, 44,174,  12,136
    dc.b        0,94,    18,46,                                          $fe,$bc,$13, $fe,$bc,$13    ; banana 2
    dc.b    4,  223,165, 233,175, 203,195, 183,181,                      $fe,$bc,$13, $fe,$bc,$13    ; banana 3
    dc.b    4,  229,163, 236,170, 233,175, 223,167,                      $00,$00,$00, $00,$00,$00    ; bottom end
    dc.b    5,  30,0,    42,1,    49,9,    38,10,   25,6,                $00,$00,$00, $00,$00,$00    ; top end
bananaSpriteSize dc.w $0000    ; $wwhh

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
