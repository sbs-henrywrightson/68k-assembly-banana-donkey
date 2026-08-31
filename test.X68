    org     $1000
    
Start:
    
    jsr     TestRoutine
    bra     Finish
    
    include 'test-code.X68'
    
Finish:
    simhalt

    include 'test-variables.X68'

    end     Start
