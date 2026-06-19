USING: help.markup help.syntax webhook-printer ;

ARTICLE: "zplprinter" "ZPL Printer Webhook"
"Das Vokabular stellt eine einfache Webhook-empfangende Anwendung bereit, die JSON-Payloads verarbeitet und ZPL an einen lokalen Drucker auf Port 9100 sendet."
{ $heading "Überblick" }
"Der Webhook erwartet eine JSON-Nachricht mit dem Produktnamen unter " { $snippet "Product" } " und dem Barcode unter " { $snippet "Grocycode" } "."
{ $heading "Beispiel" }
"Eine typische Payload sieht so aus:" { $link example-webhook-payload }
{ $heading "Kernfunktionen" }
{ $subsections
    call-responder*
    process-label-payload
    label>zpl
    send-zpl-to-printer
}

HELP: call-responder*
{ $description "Top-Level-Responder für eingehende HTTP-Webhooks. Protokolliert den Aufruf mit UTC-Zeitstempel und delegiert die Verarbeitung an das Payload-Handling." }

HELP: process-label-payload
{ $values { "assoc" "assoc" } { "response" "response" } }
{ $description "Protokolliert Produkt- und Barcode-Informationen, rendert das ZPL-Label und sendet es an den Drucker. Gibt eine HTTP-Response zurück." }
{ $examples
    "Eine Payload verarbeiten und Antwort erhalten:"
    { $code "LH{ { \"Product\" \"Test\" } { \"Grocycode\" \"123\" } } process-label-payload" }
}

HELP: log-webhook-call
{ $values { "data" "assoc" } }
{ $description "Protokolliert Produktname und Barcode in einer stabilen Zeile zum einfachen Log-Durchsuchen." }

HELP: label>zpl
{ $values { "data" "assoc" } { "zpl" "string" } }
{ $description "Erzeugt den vollständigen ZPL-String aus den Payload-Daten. Das Header-Label enthält dabei den Barcode aus dem Feld " { $snippet "Grocycode" } "." }

HELP: send-zpl-to-printer
{ $values { "zpl" "string" } }
{ $description "Sendet den gerenderten ZPL-String an den lokalen ZPL-Drucker auf Port 9100." }

HELP: start-server
{ $description "Startet den Webhook-Receiver auf Port 8080. Blockiert bis zum Herunterfahren des Servers." }

HELP: current-utc-timestamp
{ $values { "timestamp" "string" } }
{ $description "Erzeugt einen UTC-Zeitstempel im RFC 3339-Format für Logeinträge." }

HELP: print-zpl
{ $values { "zpl" "string" } }
{ $description "Schreibt ZPL an den Drucker über eine TCP-Verbindung. Veraltete Funktion – nutze stattdessen " { $link send-zpl-to-printer } "." }

HELP: respond-ok
{ $values { "response" "response" } }
{ $description "Gibt eine erfolgreiche HTTP-Antwort zurück, wenn der Druckauftrag angenommen wurde." }

HELP: respond-bad
{ $values { "err-msg" "string" } { "response" "response" } }
{ $description "Gibt eine HTTP-Fehlerantwort mit einer Fehlermeldung zurück, wenn die Payload ungültig ist." }

HELP: parse-request-payload
{ $description "Liest die eingehende HTTP-Request aus und parst den JSON-Body in eine Assoziation." }

HELP: example-webhook-payload
{ $description "Ein Beispiel für eine gültige JSON-Payload, die der Webhook verarbeiten kann." }
{ $example
    "{\n  \"Product\": \"Beispielprodukt\",\n  \"Grocycode\": \"1234567890\",\n  \"Details\": {\n    \"AvgPrice\": 9.99,\n    \"Product\": {\n      \"MinStockAmount\": 5\n    },\n    \"QuantityUnitStock\": {\n      \"Name\": \"Stück\"\n    },\n    \"MoveOnOpen\": 1\n  }\n}"
    ""
}

ABOUT: "zplprinter"
