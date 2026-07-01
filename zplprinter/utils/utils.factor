USING: assocs kernel sequences ;

IN: zplprinter.utils

: safe-at ( assoc/f key -- value/f )
    over [ swap at ] [ 2drop f ] if ;

: get-nested ( assoc keys -- value/f )
    [ safe-at ] each ;
