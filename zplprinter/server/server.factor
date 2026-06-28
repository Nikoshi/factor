USING: accessors calendar calendar.format continuations
formatting http http.server http.server.responses io json
kernel multiline namespaces present sequences strings
zplprinter.utils ;
IN: zplprinter.server

SYMBOL: server-console
SYMBOL: payload-handler

: with-console ( quot -- )
    server-console get-global swap with-output-stream* ; inline

: current-utc-timestamp ( -- string )
    now-utc timestamp>rfc3339 ;

: respond-ok ( -- response )
    <response> 200 >>code "text/plain" >>content-type "Printed" >>body ;

: respond-bad ( err-msg -- response )
    [ "Error: " prepend print flush ] with-console
    <response> 400 >>code "text/plain" >>content-type "Invalid data" >>body ;

: parse-request-payload ( -- assoc/f )
    request get [
        data>> [
            data>> [ [ json> ] ignore-errors ] [ f ] if*
        ] [ f ] if*
    ] [ f ] if* ;

:: log-webhook-call ( data -- )
    [
        "Processing label for: " write
        data { "product" } get-nested [ present write ] [ "kein Produkt" write ] if*
        " (Grocycode: " write
        data { "grocycode" } get-nested [ present write ] [ "kein Code" write ] if*
        ")" print flush
    ] with-console ;

STRING: test-form-html
<!DOCTYPE html>
<html lang='de'>
<head>
    <meta charset='UTF-8'>
    <title>ZPL Printer Testformular</title>
    <style>
        body { font-family: sans-serif; max-width: 600px; margin: 40px auto; padding: 0 20px; }
        textarea { white-space: pre; font-family: monospace; width: 100%; height: 250px; }
        button { padding: 10px 20px; background: #0066cc; color: white; border: none; cursor: pointer; }
        pre { background: #f0f0f0; padding: 10px; border-radius: 4px; }
    </style>
</head>
<body>
    <h1>ZPL Test-Payload senden</h1>
    <textarea id='jsonPayload'>{
  "product": "Testprodukt",
  "grocycode": "grcy:p:1:x6a3fe19eb0644",
  "details": {
    "avg_price": 1.49,
    "product": {
      "min_stock_amount": 0,
      "move_on_open": 1
    },
    "quantity_unit_stock": {
      "name": "Packung"
    }
  }
}</textarea>
    <br><br>
    <button onclick='sendTest()'>Payload an API senden</button>
    <h3>Server-Antwort (/):</h3>
    <pre id='response'>-</pre>

    <script>
        async function sendTest() {
            const resBox = document.getElementById('response');
            resBox.innerText = 'Sende...';
            try {
                const response = await fetch('/', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json; charset=utf-8' },
                    body: document.getElementById('jsonPayload').value
                });
                const text = await response.text();
                resBox.innerText = `HTTP ${response.status}: ${text}`;
            } catch (err) {
                resBox.innerText = 'Verbindungfehler: ' + err.message;
            }
        }
    </script>
</body>
</html>
;

: respond-html ( html -- response )
    <response> 200 >>code "text/html; charset=utf-8" >>content-type swap >>body ;

TUPLE: test-form-action ;
TUPLE: webhook-action ;

M: test-form-action call-responder* ( path responder -- response )
    2drop test-form-html respond-html ;

M: webhook-action call-responder* ( path responder -- response )
    2drop
    [ "--- New Webhook Call --- " write current-utc-timestamp print "\n" print flush ] with-console
    parse-request-payload
    [
        dup log-webhook-call
        payload-handler get-global [ call( assoc -- response ) ] [ drop "No payload handler configured." respond-bad ] if*
    ] [ "No or invalid JSON data." respond-bad ] if* ;
    
