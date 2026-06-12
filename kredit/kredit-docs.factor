USING: help.markup help.syntax kredit ;
IN: kredit

ARTICLE: "kredit" "Kreditberechnung"
{ $vocab-link "kredit" }
$nl
"Das Vokabular ermöglicht die Berechnung von Tilgungsplänen für Kredite unter Berücksichtigung von Eigenkapital, Zinsen, Laufzeit und jährlichen Sondertilgungen."
$nl
"Hauptfunktion für den Start:"
{ $subsections berechne-kredit } ;

HELP: kredit-daten
{ $class-description "Speichert die Basisparameter eines Kredits:"
    { $list
        { { $snippet "kaufpreis" } " - Gesamtkosten der Anschaffung." }
        { { $snippet "eigenkapital" } " - Geleistete Anzahlung." }
        { { $snippet "zins-pa" } " - Jährlicher Zinssatz in Prozent." }
        { { $snippet "laufzeit" } " - Laufzeit in Monaten." }
        { { $snippet "sondertilgung" } " - Jährlicher Sondertilgungsbetrag." }
    }
} ;


HELP: <kredit-daten>
{ $values 
    { "kaufpreis" "real" } { "eigenkapital" "real" } { "zins-pa" "real" } { "laufzeit" "integer" } { "sondertilgung" "real" }
    { "daten" "kredit-daten" }
}
{ $description "Erstellt ein Kredit-Daten Objekt anhand der Eingaben." } ;

HELP: kreditsumme
{ $values { "daten" "kredit-daten" } { "summe" "real" } }
{ $description "Berechnet die eigentliche Kreditsumme. Die Kreditsumme ist hierbei die Differenz aus dem Kaufpreis und dem Eigenkapital. " } ;

HELP: monatszins
{ $values { "daten" "kredit-daten" } { "zins" "real" } }
{ $description "Berechnet den fälligen Zins für einen Monat" } ;

! q-faktor

! q^n

HELP: kalkuliere-rate
{ $values { "daten" "kredit-daten" } { "rate" "real" } }
{ $description "Berechnet die monatliche Annuität auf Basis der Kreditdaten." } ;

! ------------------

HELP: status
{ $class-description "Verwaltet den aktuellen Berechnungszustand während des Tilgungsprozesses."
    { $list
        { { $snippet "schuld" } " - Gesamtschulden." }
        { { $snippet "monat" } " - Aktueller Monat." }
        { { $snippet "rate" } " - Aktuelle monatliche Rate." }
        { { $snippet "zinsen-gesamt" } " - Summierung der bisher gezahlten Zinsen." }
        { { $snippet "daten" } " - Kreditdaten." }
    }
} ;

HELP: <status>
{ $values { "daten" "kredit-daten" } { "status" "status" } }
{ $description "Erstellt das Statusobjekt anhand der Kreditdaten." } ;

HELP: zinsen-anteil
{ $values { "status" "status" } { "zinsen" "real" } }
{ $description "Berechnet die anteiligen Zinsen für den aktuellen Monat." } ;

HELP: sondertilgung-faellig?
{ $values { "status" "status" } { "?" "t/f" } }
{ $description "Überprüft anhand des Monats ob die Zahlung der Sondertilgung fällig ist." } ;

HELP: drucke-sondertilgung
{ $values { "betrag" "real" } }
{ $description "Gibt die aktuelle Sondertilgung `betrag` aus." } ;

HELP: buche-sondertilgung
{ $values { "status" "status" } { "status'" "status" } }
{ $description "Führt die Sondertilgung durch (sofern fällig) und gibt das geänderte Statusobjekt zurück." } ;

HELP: verarbeite-monat
{ $values { "status" "status" } { "status'" "status" } }
{ $description "Berechnet den aktuellen Monat und gibt das geänderte Statusobjekt zurück." } ;

HELP: monats-schritt
{ $values { "status" "status" } { "status'" "status" } }
{ $description "Führt die Verarbeitung des Monats sowie die Sondertilgung durch." } ;

HELP: tilgungsplan
{ $values { "status" "status" } { "status'" "status" } }
{ $description "Iteriert monatlich durch den Tilgungsprozess, bis die Schuld beglichen ist." } ;

HELP: zusammenfassung
{ $values { "status" "status" } }
{ $description "Gibt eine Zusammenfassung des Kredites aus." } ;

HELP: berechne-kredit
{ $values 
    { "kaufpreis" "real" } { "eigenkapital" "real" } { "zins" "real" } { "laufzeit" "integer" } { "sondertilgung" "real" }
}
{ $description "Erstellt einen Tilgungsplan basierend auf den Eingabeparametern und gibt die Übersicht auf der Konsole aus." } ;

HELP: beispiel-kredit
{ $description "Beispielhafte Ausführung der Kreditberechnungsfunktion." } ;

ABOUT: "kredit"