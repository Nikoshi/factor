USING: help.markup help.syntax zplprinter.dev ;

IN: zplprinter.dev

ARTICLE: "zplprinter.dev" "ZPL Printer Development Support"
"Das Vokabular bietet Hilfsfunktionen für die Entwicklung, insbesondere zum Starten des Servers in einem separaten Thread."
{ $heading "Verwendung" }
"Zum Starten des Dev-Servers im Listener auf Port 8080:"
{ $code "USE: zplprinter.dev ; 8080 start-dev-server" }
"Danach kann F2 gedrückt werden um den Listener zu refreshen, ohne den Server neu starten zu müssen."

HELP: start-dev-server
{ $values { "port" "integer" } }
{ $description "Startet den Webhook-Server auf dem angegebenen Port in einem separaten Thread. Ermöglicht F2-Refresh im Listener ohne Server-Neustart. Warum separater Thread? So können Änderungen am Code schnell mit F2 reloaded werden, ohne den Server manuell neu zu starten." }
{ $examples
    "Dev-Server auf Port 8080 starten:"
    { $code "USE: zplprinter.dev ; 8080 start-dev-server" }
    "Server-Status prüfen:"
    { $code "dev-server-running?" }
    "Server stoppen:"
    { $code "stop-dev-server" }
}

HELP: stop-dev-server
{ $description "Stoppt den laufenden Dev-Server-Thread." }

HELP: dev-server-running?
{ $values { "?" "boolean" } }
{ $description "Prüft, ob der Dev-Server noch läuft." }

ABOUT: "zplprinter.dev"
