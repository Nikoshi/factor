USING: help.markup help.syntax strings ;
IN: zplprinter.client

ARTICLE: "zplprinter.client" "ZPL Printer Client"
"TCP-Kommunikation mit dem lokalen Drucker."
{ $subsections
    send-zpl-to-printer
} ;

HELP: send-zpl-to-printer
{ $values 
    { "zpl" string } 
    { "success?" boolean }
    { "error/f" object }
}
{ $description 
    "Sendet den gerenderten ZPL-String an den lokalen ZPL-Drucker auf Port 9100.\n\n"
    "Bei Verbindungsfehlern greift ein Exponential Backoff mit maximal 3 Wiederholungsversuchen.\n\n"
    "Rückgabewerte:\n"
    { $list
        { { $code "success?" } " ist " { $code "t" } " bei Erfolg, sonst " { $code "f" } "." }
        { { $code "error/f" } " enthält das Fehler-Tuple, falls alle Versuche fehlschlagen, sonst " { $code "f" } "." }
    }
} ;

ABOUT: "zplprinter.client"
