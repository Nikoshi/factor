USING: accessors combinators formatting fry kernel locals math
math.functions math.order io ;
IN: kredit

TUPLE: kredit-daten 
    { kaufpreis real }
    { eigenkapital real }
    { zins-pa real } 
    { laufzeit integer }
    { sondertilgung real } ;

: <kredit-daten> ( kaufpreis eigenkapital zins-pa laufzeit sondertilgung -- daten )
    kredit-daten boa ;

! bi: Führt zwei Quotations (Code-Blöcke) auf demselben Wert aus. 
! Hier wird 'daten' behalten und an 'kaufpreis>>' sowie 'eigenkapital>>' übergeben.
! Danach liegen beide Ergebnisse auf dem Stack und das '-' kann sie subtrahieren.
: kreditsumme ( daten -- summe )
    [ kaufpreis>> ] [ eigenkapital>> ] bi - ;

: monatszins ( daten -- zins )
    zins-pa>>  100 /  12 / ;

: q-faktor ( daten -- n )
    monatszins 1 + ;

: q^n ( daten -- n )
    [ q-faktor ] [ laufzeit>> ] bi ^ ;

: kalkuliere-rate ( daten -- rate )
    [ [ kreditsumme ] [ monatszins ] bi * ] [ q^n ] bi
    dup 1 - / * ;

TUPLE: status 
    { schuld real }
    { monat integer }
    { rate real }
    { zinsen-gesamt real }
    { daten kredit-daten } ;

! cleave: Wendet mehrere Quotations auf einen einzelnen Wert an.
! Das Array { ... } definiert die einzelnen Ableitungen aus 'daten',
! um die Parameter für das 'status'-Tupel zu generieren.
: <status> ( daten -- status )
    { [ kreditsumme ] [ drop 1 ] [ kalkuliere-rate ] [ drop 0.0 ] [ ] } cleave status boa ;

: zinsen-anteil ( status -- zinsen )
    [ schuld>> ] [ daten>> monatszins ] bi * ;

: sondertilgung-faellig? ( status -- ? )
    monat>> 12 mod 0 = ;

: drucke-sondertilgung ( betrag -- )
    "\n\n-> SONDERTILGUNG:  %.2f EUR\n" printf ;

! fry ('[ _ ]'): Erstellt eine Quotation, bei der ein Stackwert an 
! der Stelle von '_' "eingefroren" wird (Partial Application).
! '[ _ - ]' fixiert also den berechneten Tilgungsbetrag für 'change-schuld'.
: buche-sondertilgung ( status -- status' )
    dup sondertilgung-faellig? [
        dup [ schuld>> ] [ daten>> sondertilgung>> ] bi min
        [ drucke-sondertilgung ] keep
        '[ _ - ] change-schuld
    ] when ;

:: verarbeite-monat ( status -- status' )
    status zinsen-anteil :> zinsen
    status schuld>> zinsen + status rate>> min :> rate
    rate zinsen - :> tilg
    status schuld>> tilg - :> restschuld

    status monat>> rate tilg zinsen restschuld
    "\n%2d. Monat | Rate: %6.2f EUR | Tilg: %6.2f EUR | Zins: %5.2f EUR | Rest: %8.2f EUR" printf

    status clone 
        restschuld >>schuld
        rate >>rate
        [ 1 + ] change-monat
        [ zinsen + ] change-zinsen-gesamt ;

: monats-schritt ( status -- status' )
    verarbeite-monat buche-sondertilgung ;

: tilgungsplan ( status -- status' )
    [ dup schuld>> 0 > ] [ monats-schritt ] while ;

! tri: Wie 'bi', wendet aber drei Quotations auf den obersten Wert an.
! Hier: Dauer berechnen, Zinsen auslesen, Gesamtkosten berechnen.
: zusammenfassung ( status -- )
    "\n--------------------------------------------------------------------------------------\n" print
    [ monat>> 1 - 12 /mod ] 
    [ zinsen-gesamt>> ] 
    [ [ daten>> kreditsumme ] [ zinsen-gesamt>> ] bi + ] tri
    "Kredit vollständig berechnet.\nDauer beträgt %d Jahre und %d Monate.\n\nZinsen: %8.2f EUR\nGesamt: %8.2f EUR" printf ;

! Wiederverwendbarer Einstiegspunkt. Nimmt die Parameter dynamisch vom Stack.
: berechne-kredit ( kaufpreis eigenkapital zins laufzeit sondertilgung -- )
    <kredit-daten> <status>
    "Monatsuebersicht\n--------------------------------------------------------------------------------------" printf
    tilgungsplan
    zusammenfassung ;

IN: kredit.examples

! Konkreter Anwendungsfall mit Werten.
: beispiel-kredit ( -- )
    12999.00        ! Gesamtkosten
     3500.00        ! Anzahlung
        5.14        ! Jahreszinssatz
       60.00        ! Dauer in Monaten
     1200.00        ! Jährliche Sondertilgung
    berechne-kredit ;