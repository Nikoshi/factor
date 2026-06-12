! Copyright (C) 2026 Nikoshi.
! See https://factorcode.org/license.txt for BSD license.

USING: accessors grocy.api grocy.api.private http present
tools.test urls ;
IN: grocy.api

! === Konstruktor ===
[ T{ grocy-client f "https://api.example.com" "secret-key" } ]
[ "https://api.example.com" "secret-key" <grocy-client> ] unit-test


! === Pfad-Generierung ===
[ "/stock/products/by-barcode/123456789" ]
[ "123456789" barcode-path ] unit-test


! === Interne Hilfswörter (PRIVATE) ===

! api-url: Kombiniert Base-URL und Pfad
[ "https://api.example.com/test-path" ]
[ "https://api.example.com" "key" <grocy-client> "/test-path" api-url present ] unit-test

! prep-request: Erzeugt das korrekte Request-Objekt
[ "POST" ]
[ "https://api.example.com" "key" <grocy-client> "/test" "POST" prep-request method>> ] unit-test

[ "https://api.example.com/test" ]
[ "https://api.example.com" "key" <grocy-client> "/test" "GET" prep-request url>> present ] unit-test