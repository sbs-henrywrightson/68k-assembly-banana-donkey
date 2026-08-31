; Create bezier curve variables
startX      dc.w    490
startY      dc.w    90

midX        dc.w    460
midY        dc.w    -150

endX        dc.w    400
endY        dc.w    342

pointX      dc.w    32
pointY      dc.w    32

; Write bezier curve to a file variables
CurveOutputFile     dc.b    'curve_output_1.txt',0
CurveFileHandle     dc.l    0
CurveLineBuffer     ds.b    64
