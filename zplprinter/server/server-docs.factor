USING: help.markup help.syntax zplprinter.server ;

IN: zplprinter.server

ARTICLE: "zplprinter.server" "ZPL Printer Server"
"HTTP-Verarbeitung, Logging und Testendpunkt für den Webhook-Receiver."
{ $subsections
    current-utc-timestamp
    parse-request-payload
    respond-ok
    respond-bad
    log-webhook-call
}

HELP: current-utc-timestamp
{ $values { "timestamp" "string" } }
{ $description "Erzeugt einen UTC-Zeitstempel im RFC 3339-Format." }

HELP: parse-request-payload
{ $values { "assoc/f" "assoc/f" } }
{ $description "Parst den JSON-Body der aktuellen HTTP-Request zu einer Assoziation oder gibt f zurück." }

HELP: respond-ok
{ $values { "response" "response" } }
{ $description "Gibt eine erfolgreiche HTTP-Antwort zurück." }

HELP: respond-bad
{ $values { "err-msg" "string" } { "response" "response" } }
{ $description "Gibt eine Fehlerantwort für ungültige Eingaben zurück." }

HELP: log-webhook-call
{ $values { "data" "assoc" } }
{ $description "Schreibt eine stabile Logzeile mit Produkt und Barcode." }

ABOUT: "zplprinter.server"