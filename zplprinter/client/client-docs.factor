USING: help.markup help.syntax zplprinter.client ;

IN: zplprinter.client

ARTICLE: "zplprinter.client" "ZPL Printer Client"
"TCP-Kommunikation mit dem lokalen Drucker."
{ $subsections
    send-zpl-to-printer
} ;

HELP: send-zpl-to-printer
{ $values { "zpl" "string" } }
{ $description "Sendet den gerenderten ZPL-String an den lokalen ZPL-Drucker auf Port 9100." } ;

ABOUT: "zplprinter.client"
