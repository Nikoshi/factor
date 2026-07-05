USING: calendar io io.encodings.utf8 io.sockets kernel threads continuations ;
IN: zplprinter.client

<PRIVATE

: (send-zpl) ( zpl -- )
    "127.0.0.1" 9100 <inet4> utf8 [ print ] with-client ;

PRIVATE>

: send-zpl-to-printer ( zpl -- )
    [ (send-zpl) ] [             ! 1st Attempt
        drop                     ! Silence 1st error
        1 seconds sleep
        
        [ (send-zpl) ] [         ! 2nd Attempt
            drop                 ! Silence 2nd error
            2 seconds sleep
            
            (send-zpl)           ! Fails with an error on the 3rd Attempt
        ] recover
    ] recover ;
