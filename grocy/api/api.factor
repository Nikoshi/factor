! Copyright (C) 2026 Nikoshi.
! See https://factorcode.org/license.txt for BSD license.

USING: accessors assocs continuations http http.client
io.encodings.string io.encodings.utf8 json kernel sequences
splitting urls urls.encoding ;
IN: grocy.api

ERROR: grocy-error code message ;

TUPLE: grocy-client base-url api-key ;

: <grocy-client> ( base-url api-key -- client )
    grocy-client boa ;

<PRIVATE

: api-url ( client path -- url )
    [ base-url>> ] dip append >url ;

: prep-request ( client path method -- request )
    [
        [ api-url <get-request> ]
        [ drop api-key>> ] 2bi
        "GROCY-API-KEY" set-header
    ] dip >>method ;

: handle-api-error ( error -- * )
    dup download-failed? [
        response>> 
        [ code>> ] 
        [ body>> json> "error_message" of ] bi 
        grocy-error
    ] [ rethrow ] if ;

: send-request ( request -- json )
    [ http-request nip json> ] [ handle-api-error ] recover ;

PRIVATE>

! === Basis-HTTP-Methoden ===

: get-api ( client path -- json )
    "GET" prep-request send-request ;

: post-api ( client path payload -- json )
    [ "POST" prep-request ] dip
    >json utf8 encode post-data new
        swap >>data
        "application/json" >>content-type
    >>data
    "application/json" "Accept" set-header
    send-request ;

! === Pfad-Generierung ===

: barcode-path ( barcode -- path )
    url-encode "/stock/products/by-barcode/" prepend 
    ":" "%3A" replace ;

! === API Endpunkte ===

: get-product ( client barcode -- json )
    barcode-path get-api ;

: add-product       ( client barcode payload -- json ) [ barcode-path "/add"       append ] dip post-api ;
: consume-product   ( client barcode payload -- json ) [ barcode-path "/consume"   append ] dip post-api ;
: transfer-product  ( client barcode payload -- json ) [ barcode-path "/transfer"  append ] dip post-api ;
: inventory-product ( client barcode payload -- json ) [ barcode-path "/inventory" append ] dip post-api ;
: open-product      ( client barcode payload -- json ) [ barcode-path "/open"      append ] dip post-api ;