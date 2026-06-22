USING: io.encodings.utf8 io.sockets ;

IN: zplprinter.client

: send-zpl-to-printer ( zpl -- )
    "127.0.0.1" 9100 <inet4> utf8 [ print ] with-client ;
