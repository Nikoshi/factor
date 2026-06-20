USING: accessors assocs combinators formatting http http.server http.server.responses 
io io.encodings.utf8 io.servers io.sockets json kernel make math namespaces present sequences calendar calendar.format ;

IN: zplprinter

SYMBOL: server-console

<PRIVATE
! Robuste Hilfsfunktionen für Payload-Verarbeitung:
! Warum: Webhooks können Felder auslassen oder unterschiedliche Strukturen haben.
! Diese Funktionen geben `f` zurück statt zu crashen, sodass höhere Ebenen
! mit fehlenden Daten entscheiden können und die Pipeline stabil bleibt.
: safe-at ( assoc/f key -- value/f )
    over [ swap at ] [ 2drop f ] if ;

: get-nested ( assoc keys -- value/f )
    [ safe-at ] each ;

: with-console ( quot -- )
    server-console get-global swap with-output-stream* ; inline

PRIVATE>

! --- ZPL-Template-Logik ---
! Template-Fragmente: Jedes Wort rendert einen kleinen, fokussierten
! Teil des Labels, nur wenn das Feld in der Payload vorhanden ist.
! So bleibt die Rendering-Pipeline zusammensetzbar und testbar.
<PRIVATE

: %header ( data -- )
    "^XA\n^CI28\n" %
    { "grocycode" } get-nested [ present % ] when* "^FS\n" % ;

: %product ( data -- )
    { "product" } get-nested   ! TODO: Show Amount As Well
    [ "^CF0,50^FO50,50^FD" % present % "^FS ^FO700,50^FD" % "N/A" % "^FS\n" % ] when* ;

: %price ( data -- )
    { "details" "avg_price" } get-nested 
    [ "^CF0,30^FO50,115^FDDurchschnittspreis: " % present % "^FS\n" % ] when* ;

: %stock ( data -- )
    dup { "details" "product" "min_stock_amount" } get-nested [
        dup 0 > [
            "^FO50,155^FDMin Stock: " % present % " " %
            { "details" "quantity_unit_stock" "name" } get-nested [ present % ] when* "^FS\n" %
        ] [ 2drop ] if
    ] [ drop ] if* ;

: %move-on-open ( data -- )
    { "details" "product" "move_on_open" } get-nested 
    [ 1 = [ "^FO50,235^FDMove On Open^FS\n" % ] when ] when* ;

: %barcode ( data -- )  ! TODO: The X-Start of the barcode depends on the length of the code (to center it)
    "^FO50,275^GB650,3,3^FS\n^BY2,2,225\n^FO50,315^BC^FD" %
    { "grocycode" } get-nested [ present % ] when* "^FS\n" % ;

: %footer ( -- )
    "^XZ\n" % ;

:: label>zpl ( data -- zpl )
    [
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
    [ "Error: " prepend print flush ] with-console
    <response> 400 >>code "Invalid data" "text/plain" <content> >>body ;

: parse-request-payload ( -- assoc/f )
    request get [
        data>> [
            ! JSON-String extrahieren (je nach Webhook-Struktur)
            data>> [ [ json> ] ignore-errors ] [ f ] if*
        ] [ f ] if*
    ] [ f ] if* ;

! Eine Zeile pro Webhook loggen für Nachverfolgung.
! Format stabil halten zum einfachen Durchsuchen von Logs.
:: log-webhook-call ( data -- )
    [
        "Processing label for: " write
        data { "product" } get-nested [ present write ] [ "kein Produkt" write ] if*
        " (Grocycode: " write
        data { "grocycode" } get-nested [ present write ] [ "kein Code" write ] if*
        ")" print flush
    ] with-console ;

! Verarbeitung von Logging separieren, damit Tests das Rendering
! unabhängig von Seiteneffekten (Socket-Senden) testen können.
: process-label-payload ( assoc -- response )
    dup log-webhook-call
    label>zpl send-zpl-to-printer
    [ "Successfully sent to printer." print flush ] with-console
    respond-ok ;

TUPLE: webhook-action ;
M: webhook-action call-responder* ( path responder -- response )
    2drop
    [ "--- New Webhook Call --- " write current-utc-timestamp print "\n" print flush ] with-console
    parse-request-payload
    [ process-label-payload ] 
    [ "No or invalid JSON data." respond-bad ] if* ;

! --- Start / CLI ---
! Einstiegspunkt: startet den HTTP-Server zum Empfang von Webhooks.

: start-zpl-server ( -- )
    "Starting Webhook-Receiver on port 8080..." print flush
    output-stream get server-console set-global  ! <-- Hier den Stream für Threads speichern
    webhook-action new main-responder set-global
    5000 httpd wait-for-server ;

MAIN: start-zpl-server
