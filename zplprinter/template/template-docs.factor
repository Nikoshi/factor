USING: help.markup help.syntax zplprinter.template ;

IN: zplprinter.template

ARTICLE: "zplprinter.template" "ZPL Printer Template"
"Reine ZPL-Generierung aus Payload-Daten ohne Socket- oder HTTP-Abhängigkeiten."
{ $subsections
    label>zpl
} ;

HELP: label>zpl
{ $values { "data" "assoc" } { "zpl" "string" } }
{ $description "Erzeugt den vollständigen ZPL-String aus den Payload-Daten." } ;

ABOUT: "zplprinter.template"
