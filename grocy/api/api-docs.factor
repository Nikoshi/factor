! Copyright (C) 2026 Nikoshi.
! See https://factorcode.org/license.txt for BSD license.

USING: assocs grocy.api help.markup help.syntax strings ;
IN: grocy.api

ARTICLE: "grocy.api" "Grocy API Client"
"Zustandsloser Client für die Grocy REST API. Das Konfigurationsobjekt wird explizit über den Stack gereicht."
$nl
"Konfiguration:"
{ $subsections
    grocy-client
    <grocy-client>
}
"Basis-HTTP-Methoden und Hilfswörter:"
{ $subsections
    get-api
    post-api
    barcode-path
}
"API Endpunkte:"
{ $subsections
    get-product
    add-product
    consume-product
    transfer-product
    inventory-product
    open-product
} ;

HELP: grocy-client
{ $class-description "Ein Tupel für die Verbindungsparameter zur Grocy API. Slots:"
    { $list
        { { $snippet "base-url" } " - Basis-URL der API." }
        { { $snippet "api-key" } " - API-Schlüssel." }
    }
} ;

HELP: <grocy-client>
{ $values
    { "base-url" string }
    { "api-key" string }
    { "client" grocy-client }
}
{ $description "Erstellt ein neues " { $link grocy-client } " Tupel." }
{ $examples
    { $code "\"https://grocy.example.com/api\" \"SECRET_KEY\" <grocy-client>" }
} ;

HELP: get-api
{ $values
    { "client" grocy-client }
    { "path" string }
    { "json" assoc }
}
{ $description "Führt einen generischen GET-Request gegen den übergebenen Pfad aus." }
{ $examples
    { $code 
        "USING: grocy.api ;"
        "\"https://api.example.com\" \"KEY\" <grocy-client> \"/stock/products\" get-api ." 
    }
} ;

HELP: post-api
{ $values
    { "client" grocy-client }
    { "path" string }
    { "payload" assoc }
    { "json" assoc }
}
{ $description "Führt einen generischen POST-Request mit JSON-Payload gegen den übergebenen Pfad aus." }
{ $examples
    { $code 
        "USING: assocs grocy.api ;"
        "\"https://api.example.com\" \"KEY\" <grocy-client> \"/stock/products\" H{ { \"amount\" 1 } } post-api ." 
    }
} ;

HELP: barcode-path
{ $values
    { "barcode" string }
    { "path" string }
}
{ $description "Generiert den API-Basispfad für einen Barcode." }
{ $examples
    { $code "\"1234567890\" barcode-path ." }
} ;

HELP: get-product
{ $values
    { "client" grocy-client }
    { "barcode" string }
    { "json" assoc }
}
{ $description "Ruft die Produktdetails für den " { $snippet "barcode" } " ab." }
{ $examples
    { $code 
        "USING: grocy.api locals ;"
        "\"https://api\" \"KEY\" <grocy-client> :> client"
        "client \"123456789012\" get-product ." 
    }
} ;

HELP: add-product
{ $values
    { "client" grocy-client }
    { "barcode" string }
    { "payload" assoc }
    { "json" "Array von StockLogEntries" }
}
{ $description "Fügt dem Bestand eine definierte Menge hinzu. Mögliche Payload-Schlüssel:"
    { $list
        { { $snippet "amount" } " (number, zwingend) - Die hinzuzufügende Menge." }
        { { $snippet "best_before_date" } " (string) - Fälligkeitsdatum (z.B. \"2019-01-19\"). Standard ist das aktuelle Datum." }
        { { $snippet "transaction_type" } " (string) - Transaktionstyp (z.B. \"purchase\")." }
        { { $snippet "price" } " (number) - Preis pro Einheit." }
        { { $snippet "location_id" } " (integer) - Spezifische Standort-ID. Standard ist der Standardstandort des Produkts." }
    }
}
{ $examples
    { $code 
        "USING: assocs grocy.api locals ;"
        "\"https://api\" \"KEY\" <grocy-client> :> client"
        "client \"123456789012\" H{ { \"amount\" 5 } } add-product ." 
    }
} ;

HELP: consume-product
{ $values
    { "client" grocy-client }
    { "barcode" string }
    { "payload" assoc }
    { "json" "Array von StockLogEntries" }
}
{ $description "Entfernt eine definierte Menge aus dem Bestand. Mögliche Payload-Schlüssel:"
    { $list
        { { $snippet "amount" } " (number, zwingend) - Die zu entfernende Menge." }
        { { $snippet "transaction_type" } " (string) - Transaktionstyp (z.B. \"consume\")." }
        { { $snippet "spoiled" } " (boolean) - True, wenn das Produkt verdorben ist. Standard ist false." }
        { { $snippet "stock_entry_id" } " (string) - Bestimmte Bestandseintrag-ID (Menge muss dann 1 sein)." }
        { { $snippet "recipe_id" } " (integer) - ID des Rezepts (für Statistik)." }
        { { $snippet "location_id" } " (integer) - Spezifischer Standort." }
        { { $snippet "exact_amount" } " (boolean) - Relevante Angabe bei aktiviertem Tara-Gewicht." }
        { { $snippet "allow_subproduct_substitution" } " (boolean) - Erlaubt die Verwendung von Unterprodukten." }
    }
}
{ $examples
    { $code 
        "USING: assocs grocy.api locals ;"
        "\"https://api\" \"KEY\" <grocy-client> :> client"
        "client \"123456789012\" H{ { \"amount\" 1 } { \"spoiled\" f } } consume-product ." 
    }
} ;

HELP: transfer-product
{ $values
    { "client" grocy-client }
    { "barcode" string }
    { "payload" assoc }
    { "json" "Array von StockLogEntries" }
}
{ $description "Verschiebt Bestand von einem Standort zu einem anderen. Mögliche Payload-Schlüssel:"
    { $list
        { { $snippet "amount" } " (number, zwingend) - Die zu verschiebende Menge." }
        { { $snippet "location_id_from" } " (integer, zwingend) - Ursprungsstandort." }
        { { $snippet "location_id_to" } " (integer, zwingend) - Zielstandort." }
        { { $snippet "stock_entry_id" } " (string) - Bestimmte Bestandseintrag-ID (Menge muss dann 1 sein)." }
    }
}
{ $examples
    { $code 
        "USING: assocs grocy.api locals ;"
        "\"https://api\" \"KEY\" <grocy-client> :> client"
        "client \"123456789012\" H{ { \"amount\" 2 } { \"location_id_from\" 1 } { \"location_id_to\" 2 } } transfer-product ." 
    }
} ;

HELP: inventory-product
{ $values
    { "client" grocy-client }
    { "barcode" string }
    { "payload" assoc }
    { "json" "Array von StockLogEntries" }
}
{ $description "Setzt den absoluten Lagerbestand per Inventur. Mögliche Payload-Schlüssel:"
    { $list
        { { $snippet "new_amount" } " (number, zwingend) - Der neue, absolute Bestand." }
        { { $snippet "best_before_date" } " (string) - Fälligkeitsdatum für hinzugefügte Produkte." }
        { { $snippet "location_id" } " (integer) - Standort-ID für hinzugefügte Produkte." }
        { { $snippet "price" } " (number) - Preis für hinzugefügte Produkte." }
    }
}
{ $examples
    { $code 
        "USING: assocs grocy.api locals ;"
        "\"https://api\" \"KEY\" <grocy-client> :> client"
        "client \"123456789012\" H{ { \"new_amount\" 10 } } inventory-product ." 
    }
} ;

HELP: open-product
{ $values
    { "client" grocy-client }
    { "barcode" string }
    { "payload" assoc }
    { "json" "Array von StockLogEntries" }
}
{ $description "Markiert eine Teilmenge im Bestand als geöffnet. Mögliche Payload-Schlüssel:"
    { $list
        { { $snippet "amount" } " (number, zwingend) - Die als geöffnet zu markierende Menge." }
        { { $snippet "stock_entry_id" } " (string) - Bestimmte Bestandseintrag-ID (Menge muss dann 1 sein)." }
        { { $snippet "allow_subproduct_substitution" } " (boolean) - Erlaubt die Markierung von Unterprodukten." }
    }
}
{ $examples
    { $code 
        "USING: assocs grocy.api locals ;"
        "\"https://api\" \"KEY\" <grocy-client> :> client"
        "client \"123456789012\" H{ { \"amount\" 1 } } open-product ." 
    }
} ;

ABOUT: "grocy.api"