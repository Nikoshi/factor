USING: threads namespaces zplprinter io http.server ;

IN: zplprinter.dev

SYMBOL: dev-server-thread

! F2-Refresh im Listener ohne Server-Neustart ist nur möglich mit separatem Thread.
:: start-dev-server ( port -- )
    "Dev server started on port " write port write "..." print flush
    [
        webhook-action new main-responder set-global
        port httpd wait-for-server
    ] spawn dev-server-thread set-global ;

: stop-dev-server ( -- )
    dev-server-thread get-global dup [
        "Stopping dev server..." print flush
        stop
    ] [
        "No dev server running." print flush
    ] if ;

! Warum Status checken? Um zu vermeiden, den Server doppelt zu starten.
: dev-server-running? ( -- ? )
    dev-server-thread get-global [
        thread-state "running" =
    ] [ f ] if ;

ABOUT: "zplprinter.dev"
