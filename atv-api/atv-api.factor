USING: accessors assocs classes.tuple continuations http
http.server http.server.dispatchers http.server.responses
io.servers json kernel math math.functions math.parser
namespaces quotations ;
IN: atv-api


! --- Antwort-Tupel ---
TUPLE: cost-res total_cost ;
TUPLE: cons-res liters_per_100km ;
TUPLE: range-res estimated_range_km ;
TUPLE: offroad-res offroad_l_per_100km ;
TUPLE: route-res duration_hours fuel_needed_liters refuel_stops ;


! --- HTTP-Hilfswörter ---
: param>number! ( name -- n )
    request get url>> query>> at string>number 
    ! unless*: Ist der Wert f (wg. Buchstaben oder Fehlen), 
    ! wird die Quotation ausgeführt und bricht mit throw ab.
    ! Ansonsten bleibt die umgewandelte Zahl auf dem Stack.
    [ "Invalid or missing parameter" throw ] unless* ;

: >json-response ( tuple -- response )
    >json "application/json" <content> ;


! --- Fachlogik ---
: calc-cost ( liters price -- cost ) 
    * ;

: calc-consumption ( liters km -- l/100km ) 
    dup 0.0 = 
    [ 2drop 0.0 ] 
    [ / 100.0 * ] if ;

: calc-range ( liters-left l/100km -- km ) 
    dup 0.0 = 
    [ 2drop 0.0 ] 
    [ / 100.0 * ] if ;

: duration ( dist speed -- hours ) 
    dup 0.0 = 
    [ 2drop 0.0 ] 
    [ / ] if ;

: fuel-needed ( dist cons -- liters ) 
    * 100.0 / ;

: refuel-stops ( fuel cap -- stops ) 
    dup 0.0 = 
    [ 2drop 0 ] 
    [ / floor >integer ] if ;


! --- Komplexe Routen-Logik ---
:: route-plan-action ( -- response )
    "distance" param>number!
    "avg_speed" param>number!
    "tank_capacity" param>number!
    "consumption" param>number! :> ( d s c cons )
    
    d s duration
    d cons fuel-needed
    dup c refuel-stops
    
    route-res boa >json-response ;


! --- Generischer Action-Responder ---
TUPLE: action-responder { action callable } ;
C: <action-responder> action-responder

M: action-responder call-responder*
    nip action>> 
    [ call( -- response ) ] 
    [ 
        2drop ! Verwirft das 'callable' UND das 'error'-Objekt
        H{ { "error" "Bad Request: Parameter missing or not a number" } } >json 
        "application/json" <content> 
        400 >>code 
    ] recover ;


! --- Routen-Konfiguration ---
: api-routes ( -- assoc )
    H{
        { "cost" 
          [ "liters" param>number!
            "price" param>number! calc-cost cost-res boa >json-response ] }
          
        { "consumption" 
          [ "liters" param>number!
            "km" param>number! calc-consumption cons-res boa >json-response ] }
          
        { "range" 
          [ "liters_left" param>number!
            "l_per_100km" param>number! calc-range range-res boa >json-response ] }
          
        { "offroad-consumption" 
          [ "base_l_per_100km" param>number!
            "terrain_factor" param>number! * offroad-res boa >json-response ] }
          
        { "route-plan" 
          [ route-plan-action ] }
    } ;


! --- Server Setup ---
: <atv-api> ( -- dispatcher )
    api-routes >alist 
    dispatcher new-dispatcher
    [ first2 <action-responder> swap add-responder ] reduce ;

: start-api ( -- )
    <atv-api> main-responder set-global
    8080 httpd wait-for-server ;