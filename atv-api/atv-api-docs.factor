USING: atv-api help.markup help.syntax http.server.dispatchers
math math.functions ;
IN: atv-api

! --- Dokumentation der mathematischen Fachlogik ---

HELP: calc-cost
{ $values 
    { "liters" "a positive number (f.e. float)" } 
    { "price" "price per liter in currency" } 
    { "cost" "total cost as product of both" } 
}
{ $description "Berechnet die Gesamtkosten für eine gegebene Menge Kraftstoff und den aktuellen Literpreis." }
{ $examples
    { $example
        "USING: atv-api ;"
        "34.0 1.65 calc-cost ."
        "! 56.1"
    }
} ;

HELP: calc-consumption
{ $values 
    { "liters" "consumed fuel in liters" } 
    { "km" "driven distance in kilometers" } 
    { "l/100km" "average consumption per 100km" } 
}
{ $description "Berechnet den Durchschnittsverbrauch auf 100 Kilometern. Enthält eine Schutzbedingung für Division durch Null: Wenn die Kilometeranzahl 0.0 beträgt, wird 0.0 zurückgegeben." }
{ $examples
    { $example
        "USING: atv-api ;"
        "12.0 80.0 calc-consumption ."
        "! 15.0"
    }
    { $example
        "USING: atv-api ;"
        "12.0 0.0 calc-consumption ."
        "! 0.0"
    }
} ;

HELP: calc-range
{ $values 
    { "liters-left" "remaining fuel in tank" } 
    { "l/100km" "vehicle consumption rate" } 
    { "km" "estimated remaining distance" } 
}
{ $description "Berechnet die verbleibende Reichweite. Wenn der Verbrauch mit 0.0 angegeben wird, fängt das Wort eine Division durch Null ab und gibt 0.0 zurück." }
{ $examples
    { $example
        "USING: atv-api ;"
        "15.0 10.0 calc-range ."
        "! 150.0"
    }
} ;

HELP: duration
{ $values 
    { "dist" "distance in kilometers" } 
    { "speed" "average speed in km/h" } 
    { "hours" "travel duration in hours" } 
}
{ $description "Berechnet die reine Fahrtzeit. Eine Durchschnittsgeschwindigkeit von 0.0 resultiert in einer Fahrtzeit von 0.0, um Fehler bei fehlenden Daten zu verhindern." } ;

HELP: fuel-needed
{ $values 
    { "dist" "distance in kilometers" } 
    { "cons" "consumption per 100km" } 
    { "liters" "total volume required" } 
}
{ $description "Multipliziert die Distanz mit dem Verbrauch und normiert das Ergebnis auf 100 km, um den absoluten Kraftstoffbedarf zu ermitteln." } ;

HELP: refuel-stops
{ $values 
    { "fuel" "total fuel needed for the trip" } 
    { "cap" "usable tank capacity of the vehicle" } 
    { "stops" "number of required stops (integer)" } 
}
{ $description "Ermittelt die Anzahl der notwendigen Tankstopps. Das Ergebnis wird mittels " { $link floor } " abgerundet und in ein Integer konvertiert, da der letzte Tankstopp am Zielort entfällt." }
{ $examples
    { $example
        "USING: atv-api ;"
        "45.0 15.0 refuel-stops ."
        "! 3"
    }
} ;


! --- Dokumentation der HTTP-Infrastruktur ---

HELP: param>number!
{ $values 
    { "name" "string key of the URL query parameter" } 
    { "n" "parsed float number" } 
}
{ $description "Extrahiert einen Parameter aus dem aktuellen HTTP-Request und konvertiert ihn in eine Zahl. Wenn der Parameter fehlt oder Buchstaben enthält, wird eine Exception geworfen, die vom API-Responder abgefangen wird." } ;

HELP: route-plan-action
{ $values 
    { "response" "an HTTP 200 response containing JSON" } 
}
{ $description "Orchestriert die Routenplanung. Liest die URL-Parameter für Distanz, Geschwindigkeit, Tankvolumen und Verbrauch aus, berechnet die Teilkomponenten über die Fachlogik und verpackt das Ergebnis in ein " { $link route-res } "-Tupel." } ;


! --- Hauptdokumentation (Artikel) ---

ARTICLE: "atv-api" "ATV & Car REST-API Dokumentation"

"Dieses Vokabular (" { $vocab-link "atv-api" } ") implementiert eine REST-API zur Berechnung von Verbrauchs-, Kosten- und Routendaten für Fahrzeuge (optimiert auf ATVs wie die XWolf 1000)."

{ $heading "Inbetriebnahme" }
$nl
"Der Server wird durch den Aufruf von " { $link start-api } " auf Port 8080 gestartet:"
{ $code "USING: atv-api ;" "start-api" }

{ $heading "Schnittstellen-Referenz" }
$nl
"1. Gesamtkosten-Berechnung"
{ $code "GET /cost?liters=[Zahl]&price=[Zahl]" }
$nl
{ $table
    { "Parameter" "Typ" "Beschreibung" }
    { "liters" "Float" "Menge in Litern" }
    { "price" "Float" "Preis pro Liter" }
}
$nl
"Beispiel-Response (200 OK):"
{ $code "{\n  \"total_cost\": 56.1\n}" }
$nl
$nl

"2. Verbrauch ermitteln"
{ $code "GET /consumption?liters=[Zahl]&km=[Zahl]" }
$nl
{ $table
    { "Parameter" "Typ" "Beschreibung" }
    { "liters" "Float" "Verbrauchter Kraftstoff" }
    { "km" "Float" "Gefahrene Strecke" }
}
$nl
"Beispiel-Response (200 OK):"
{ $code "{\n  \"liters_per_100km\": 12.5\n}" }
$nl
$nl

"3. Reichweiten-Kalkulation"
{ $code "GET /range?liters_left=[Zahl]&l_per_100km=[Zahl]" }
$nl
{ $table
    { "Parameter" "Typ" "Beschreibung" }
    { "liters_left" "Float" "Verbleibender Tankinhalt" }
    { "l_per_100km" "Float" "Durchschnittsverbrauch" }
}
$nl
"Beispiel-Response (200 OK):"
{ $code "{\n  \"estimated_range_km\": 240.0\n}" }
$nl
$nl

"4. Offroad-Modifikator (ATV-Spezifisch)"
{ $code "GET /offroad-consumption?base_l_per_100km=[Zahl]&terrain_factor=[Zahl]" }
$nl
{ $table
    { "Parameter" "Typ" "Beschreibung" }
    { "base_l_per_100km" "Float" "Standardverbrauch (Straße)" }
    { "terrain_factor" "Float" "Multiplikator (z.B. Schlamm = 1.3)" }
}
$nl
"Beispiel-Response (200 OK):"
{ $code "{\n  \"offroad_l_per_100km\": 15.6\n}" }
$nl
$nl

"5. Komplette Routenplanung"
{ $code "GET /route-plan?distance=[Zahl]&avg_speed=[Zahl]&tank_capacity=[Zahl]&consumption=[Zahl]" }
$nl
{ $table
    { "Parameter" "Typ" "Beschreibung" }
    { "distance" "Float" "Gesamtstrecke in km" }
    { "avg_speed" "Float" "Schnitt in km/h" }
    { "tank_capacity" "Float" "Tankvolumen (z.B. 34.0 bei XWolf)" }
    { "consumption" "Float" "Erwarteter Verbrauch auf 100km" }
}
$nl
"Beispiel-Response (200 OK):"
{ $code "{\n  \"duration_hours\": 4.5,\n  \"fuel_needed_liters\": 54.0,\n  \"refuel_stops\": 1\n}" }

{ $heading "Resilienz & Fehlerbehandlung" }
$nl
"Sollte ein Parameter unvollständig sein, komplett fehlen oder nicht-numerische Zeichen enthalten (z. B. " { $code "distance=hundert" } "), bricht die Verarbeitung ab. Die API liefert in diesem Fall ausnahmslos einen standardisierten Fehler zurück:"
{ $table
    { "HTTP Status" "Content-Type" }
    { "400 Bad Request" "application/json" }
}
$nl
"Fehler-Response:"
{ $code "{\n  \"error\": \"Bad Request: Parameter missing or not a number\"\n}" } ;

ABOUT: "atv-api"