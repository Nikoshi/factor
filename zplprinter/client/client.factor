USING: calendar continuations io io.encodings.utf8 io.sockets kernel locals math threads ;
IN: zplprinter.client

:: (send-zpl-retry) ( zpl retries delay -- error/f )
    [
        ! Try-Block
        zpl "127.0.0.1" 9100 <inet4> utf8 [ print ] with-client f
    ] [
        ! Catch-Block (Fehler liegt auf dem Stack)
        retries 0 > [
            drop ! Verwirf den aktuellen Fehler
            delay seconds sleep
            zpl retries 1 - delay 2 * (send-zpl-retry)
        ] [ ] if ! Ohne verbleibende Retries bleibt der Fehler auf dem Stack
    ] recover ;

: send-zpl-to-printer ( zpl -- success? error/f )
    3 1 (send-zpl-retry) dup [ f swap ] [ t f ] if* ;
