USING: accessors assocs combinators formatting http.server http.server.responses 
io io.encodings.utf8 io.sockets json kernel make math namespaces present sequences calendar ;

IN: webhook-printer

<PRIVATE
! Robuste Hilfsfunktionen für Payload-Verarbeitung:
! Warum: Webhooks können Felder auslassen oder unterschiedliche Strukturen haben.
! Diese Funktionen geben `f` zurück statt zu crashen, sodass höhere Ebenen
! mit fehlenden Daten entscheiden können und die Pipeline stabil bleibt.
: safe-at ( assoc/f key -- value/f )
    over [ swap at ] [ 2drop f ] if ;

: get-nested ( assoc keys -- value/f )
    [ safe-at ] each ;

PRIVATE>

! --- ZPL-Template-Logik ---
! Template-Fragmente: Jedes Wort rendert einen kleinen, fokussierten
! Teil des Labels, nur wenn das Feld in der Payload vorhanden ist.
! So bleibt die Rendering-Pipeline zusammensetzbar und testbar.
<PRIVATE

: %header ( data -- )
    "^XA\n^CI28\n^CF0,60\n^FO65,100^BXN,7,200,,,6,~,1^FD" %
    { "Grocycode" } get-nested [ present % ] when* "^FS\n" % ;

: %product ( data -- )
    { "Product" } get-nested 
    [ "^FO250,50^FD" % present % "^FS\n^CF0,30\n" % ] when* ;

: %price ( data -- )
    { "Details" "AvgPrice" } get-nested 
    [ "^FO250,115^FDDurchschnittspreis: " % present % "^FS\n" % ] when* ;

: %stock ( data -- )
    dup { "Details" "Product" "MinStockAmount" } get-nested [
        dup 0 > [
            "^FO250,155^FDMin Stock: " % present % " " %
            { "Details" "QuantityUnitStock" "Name" } get-nested [ present % ] when* "^FS\n" %
        ] [ 2drop ] if
    ] [ drop ] if* ;

: %move-on-open ( data -- )
    { "Details" "Product" "MoveOnOpen" } get-nested 
    [ 1 = [ "^FO250,235^FDMove On Open^FS\n" % ] when ] when* ;

: %barcode ( data -- )
    "^FO50,300^GB700,3,3^FS\n^BY4,2,250\n^FO100,350^BC^FD" %
    { "Grocycode" } get-nested [ present % ] when* "^FS\n" % ;

: %footer ( -- )
    "^XZ\n" % ;

:: label>zpl ( data -- zpl )
    [
        :> data
        data %header
        data %product
        data %price
        data %stock
        data %move-on-open
        data %barcode
        %footer
    ] "" make ;

PRIVATE>

! --- Webhook-Anfrageverarbeitung ---
! Eingehende JSON parsen, nützliche Kontextinformation loggen (für Nachverfolgung),
! das ZPL-Label rendern und an den konfigurierten Drucker senden.

: current-utc-timestamp ( -- string )
    now-utc timestamp>rfc3339 ;

! ZPL über TCP an den lokalen Drucker senden.
! Kein Retry-Mechanismus hier – Einfachheit bewahren und externe Überwachung
! für Wiederholungen nutzen.
: send-zpl-to-printer ( zpl -- )
    "127.0.0.1" 9100 <inet4> utf8 [ print ] with-client ;

: respond-ok ( -- response )
    <response> 200 >>code "Printed" "text/plain" <content> >>body ;

: respond-bad ( err-msg -- response )
    "Error: " prepend print flush
    <response> 400 >>code "Invalid data" "text/plain" <content> >>body ;

: parse-request-payload ( -- assoc/f )
    request get post-data>> [ json> ] [ f ] if* ;

! Eine Zeile pro Webhook loggen für Nachverfolgung.
! Format stabil halten zum einfachen Durchsuchen von Logs.
:: log-webhook-call ( data -- )
    "Processing label for: " write
    data { "Product" } get-nested [ present ] [ "<unknown>" ] if* print
    " (Grocycode: " write
    data { "Grocycode" } get-nested [ present ] [ "<unknown>" ] if* print
    ")" print flush ;

! Verarbeitung von Logging separieren, damit Tests das Rendering
! unabhängig von Seiteneffekten (Socket-Senden) testen können.
: process-label-payload ( assoc -- response )
    log-webhook-call
    label>zpl send-zpl-to-printer
    "Successfully sent to printer." print flush
    respond-ok ;

TUPLE: webhook-action ;
M: webhook-action call-responder* ( responder -- response )
    drop
    "--- New Webhook Call --- " write current-utc-timestamp print "\n" print flush
    parse-request-payload
    [ process-label-payload ] 
    [ "No or invalid JSON data." respond-bad ] if* ;

! --- Start / CLI ---
! Einstiegspunkt: startet den HTTP-Server zum Empfang von Webhooks.

: start-server ( -- )
    "Starting Webhook-Receiver on port 8080..." print flush
    webhook-action new main-responder set-global
    8080 httpd wait-for-server ;

MAIN: start-server