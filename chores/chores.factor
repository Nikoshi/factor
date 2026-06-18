USING: accessors assocs combinators formatting http http.json
kernel namespaces sequences ;

IN: chores

SYMBOL: APIKEY

TUPLE: chore id name next-execution ;
C: <chore> chore

: authenticated-json-get ( url -- json )
    "GET" <json-request>
    APIKEY get "GROCY-API-KEY" set-header
    accept-json http-json ;

: convert-chore ( assoc -- chore )
    [ "chore_id" of ]
    [ "chore_name" of ]
    [ "next_estimated_execution_time" of ] tri <chore> ;

: get-chores ( -- chores )
    "http://localhost:9283/api/chores" authenticated-json-get 
    [ convert-chore ] map ;

: print-chore ( chore -- )
    [ id>> ] [ next-execution>> ] [ name>> ] tri
    "%d. %s: %s\n" printf ;