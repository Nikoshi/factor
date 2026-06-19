USING: accessors assocs combinators continuations formatting http
http.json kernel namespaces sequences ;

IN: chores

SYMBOL: API-KEY
CONSTANT: API-URL "http://localhost:9283/api/chores"

ERROR: missing-api-key ;

TUPLE: chore id name next-execution ;
C: <chore> chore

: check-api-key ( -- key )
    API-KEY get [ missing-api-key ] unless* ;

: authenticated-json-get ( url -- json )
    "GET" <json-request>
    check-api-key "GROCY-API-KEY" set-header
    accept-json http-json ;

: convert-chore ( assoc -- chore )
    [ "chore_id" of ]
    [ "chore_name" of ]
    [ "next_estimated_execution_time" of ] tri <chore> ;

: get-chores ( -- chores )
    API-URL authenticated-json-get 
    [ convert-chore ] map ;

: print-chore ( chore -- )
    [ id>> ] [ name>> ] [ next-execution>> ] tri
    "%d. %-20s: %s\n" printf ;
