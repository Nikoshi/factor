USING: help.markup help.syntax zplprinter.dev ;
IN: zplprinter.dev

ARTICLE: "zplprinter.dev" "ZPL Printer Development Support"
"Das Vokabular bietet Hilfsfunktionen für die Entwicklung, insbesondere zum Starten des Webhook-Servers in einem separaten Thread."
{ $heading "Verwendung" }
"Den Dev-Server im Listener auf Port 8080 starten:"
{ $code "8080 start-dev-server" }
"Status prüfen und Server stoppen:"
{ $code
    "dev-server-running?"
    "stop-dev-server"
}
"Durch die Ausführung in einem separaten Thread kann der Code im Listener (z. B. über F2) neu geladen werden, ohne den Server-Prozess manuell beenden und neu starten zu müssen." ;

HELP: start-dev-server
{ $values { "port" "integer" } }
{ $description "Startet den Webhook-Server auf dem angegebenen Port in einem separaten Thread (benannt \"dev-server\")." }
{ $examples
    { $code "8080 start-dev-server" }
}

HELP: stop-dev-server
{ $description "Stoppt den laufenden Dev-Server-Thread und leert die zugehörige globale Variable." }

HELP: dev-server-running?
{ $values { "?" "boolean" } }
{ $description "Prüft den Status des Dev-Server-Threads und gibt zurück, ob dieser aktuell lauffähig ist." }

ABOUT: "zplprinter.dev"
