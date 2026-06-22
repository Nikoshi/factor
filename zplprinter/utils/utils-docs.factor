USING: help.markup help.syntax zplprinter.utils ;

IN: zplprinter.utils

ARTICLE: "zplprinter.utils" "ZPL Printer Utilities"
"Hilfsfunktionen für den sicheren Zugriff auf verschachtelte Payload-Daten."
{ $subsections
    safe-at
    get-nested
}

HELP: safe-at
{ $values { "assoc/f" "assoc/f" } { "key" "key" } { "value/f" "object/f" } }
{ $description "Liest einen Schlüssel aus einer optionalen Assoziation und gibt f zurück, wenn die Struktur fehlt." }

HELP: get-nested
{ $values { "assoc" "assoc" } { "keys" "sequence" } { "value/f" "object/f" } }
{ $description "Folgt einer Liste von Schlüsseln durch verschachtelte Assoziationen und bricht bei fehlenden Zwischenschritten mit f ab." }

ABOUT: "zplprinter.utils"