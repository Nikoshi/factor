USING: help.markup help.syntax zplprinter ;

ARTICLE: "zplprinter" "ZPL Printer Webhook"
"Das Vokabular stellt eine einfache Webhook-empfangende Anwendung bereit, die JSON-Payloads verarbeitet und ZPL an einen lokalen Drucker auf Port 9100 sendet."
{ $heading "Überblick" }
"Der Webhook erwartet eine JSON-Nachricht mit dem Produktnamen unter " { $snippet "product" } " und dem Barcode unter " { $snippet "grocycode" } "."
{ $heading "Beispiel" }
"Eine typische Payload sieht so aus:" { $link example-webhook-payload }
{ $heading "Kernfunktionen" }
{ $subsections
    process-label-payload
    label>zpl
    send-zpl-to-printer
    start-zpl-server
}

HELP: process-label-payload
{ $values { "assoc" "assoc" } { "response" "response" } }
{ $description "Protokolliert Produkt- und Barcode-Informationen, rendert das ZPL-Label und sendet es an den Drucker. Gibt eine HTTP-Response zurück." }
{ $examples
    "Eine Payload verarbeiten und Antwort erhalten:"
    { $code "H{ { \"product\" \"Test\" } { \"grocycode\" \"123\" } } process-label-payload" }
}

HELP: log-webhook-call
{ $values { "data" "assoc" } }
{ $description "Protokolliert Produktname und Barcode in einer stabilen Zeile zum einfachen Log-Durchsuchen." }

HELP: label>zpl
{ $values { "data" "assoc" } { "zpl" "string" } }
{ $description "Erzeugt den vollständigen ZPL-String aus den Payload-Daten. Das Header-Label enthält dabei den Barcode aus dem Feld " { $snippet "grocycode" } "." }

HELP: send-zpl-to-printer
{ $values { "zpl" "string" } }
{ $description "Sendet den gerenderten ZPL-String an den lokalen ZPL-Drucker auf Port 9100." }

HELP: start-zpl-server
{ $description "Startet den Webhook-Receiver auf Port 5000. Blockiert bis zum Herunterfahren des Servers." }

HELP: current-utc-timestamp
{ $values { "timestamp" "string" } }
{ $description "Erzeugt einen UTC-Zeitstempel im RFC 3339-Format für Logeinträge." }

HELP: respond-ok
{ $values { "response" "response" } }
{ $description "Gibt eine erfolgreiche HTTP-Antwort zurück, wenn der Druckauftrag angenommen wurde." }

HELP: respond-bad
{ $values { "err-msg" "string" } { "response" "response" } }
{ $description "Gibt eine HTTP-Fehlerantwort mit einer Fehlermeldung zurück, wenn die Payload ungültig ist." }

HELP: parse-request-payload
{ $values { "assoc/f" "assoc/f" } }
{ $description "Liest die eingehende HTTP-Request aus und parst den JSON-Body in eine Assoziation. Gibt " { $snippet "f" } " zurück, falls das Parsen fehlschlägt." }

HELP: example-webhook-payload
{ $description "Ein Beispiel für eine gültige JSON-Payload, die der Webhook verarbeiten kann." }
{ $code
"{\n  \"product\": \"Beispielprodukt\",\n  \"grocycode\": \"1234567890\",\n  \"details\": {\n    \"avg_price\": 9.99,\n    \"product\": {\n      \"min_stock_amount\": 5,\n      \"move_on_open\": 1\n    },\n    \"quantity_unit_stock\": {\n      \"name\": \"Stück\"\n    }\n  }\n}"
}

ABOUT: "zplprinter"
