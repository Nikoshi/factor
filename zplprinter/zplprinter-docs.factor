USING: help.markup help.syntax zplprinter zplprinter.client zplprinter.server zplprinter.template zplprinter.utils ;
IN: zplprinter

ARTICLE: "zplprinter" "ZPL Printer Orchestration"
"Das Root-Vokabular bündelt nur die Anwendungsschicht und verdrahtet die Fachvokabulare zur ausführbaren Webhook-Lösung."
{ $heading "Aufteilung" }
"Die eigentliche Fachlogik liegt in " { $vocab-link "zplprinter.utils" } ", " { $vocab-link "zplprinter.template" } ", " { $vocab-link "zplprinter.client" } " und " { $vocab-link "zplprinter.server" } "."
{ $heading "Laufzeit" }
{ $link process-label-payload } " bildet die Orchestrierung für eingehende Payloads, " { $link start-zpl-server } " startet den HTTP-Server auf Port 5000."
{ $heading "Kernfunktionen" }
{ $subsections
    process-label-payload
    start-zpl-server
} ;

HELP: process-label-payload
{ $values { "assoc" "assoc" } { "response" "response" } }
{ $description "Orchestriert die Verarbeitung einer Payload, indem es die Server-, Template- und Client-Schicht zusammenführt." }
{ $examples
    "Eine Payload verarbeiten und Antwort erhalten:"
    { $code "H{ { \"product\" \"Test\" } { \"grocycode\" \"123\" } } process-label-payload" }
} ;

HELP: start-zpl-server
{ $description "Startet den Webhook-Receiver auf Port 5000 und setzt dabei den gemeinsamen Server-Kontext der neuen Aufteilung." } ;

ABOUT: "zplprinter"
