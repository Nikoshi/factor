USING: accessors calendar io kernel namespaces sequences strings tools.test zplprinter ;
IN: zplprinter.tests

! Server-Konsole für die Responder-Tests initialisieren, um Abstürze zu vermeiden
output-stream get server-console set-global

LH{ { "product" "TestProduct" } { "grocycode" "1234567890" } } CONSTANT: test-payload
LH{ { "product" "TestProduct" } } CONSTANT: no-code-payload
LH{ } CONSTANT: empty-payload

"^XA\n^CI28\n1234567890^FS\n^CF0,50^FO50,50^FDTestProduct^FS ^FO700,50^FDN/A^FS\n^FO50,275^GB650,3,3^FS\n^BY2,2,225\n^FO50,315^BC^FD1234567890^FS\n^XZ\n" CONSTANT: expected-zpl

! === label>zpl Tests ===

[ t ] [ "TestProduct" test-payload label>zpl subseq? ] unit-test
[ t ] [ "1234567890" test-payload label>zpl subseq? ] unit-test
[ expected-zpl ] [ test-payload label>zpl ] unit-test
[ f ] [ "1234567890" no-code-payload label>zpl subseq? ] unit-test

! === Helper-Funktionen ===

[ f ] [ empty-payload { "product" } get-nested ] unit-test
[ t ] [ current-utc-timestamp length 10 > ] unit-test

! === respond-ok / respond-bad ===

[ 200 ] [ respond-ok code>> ] unit-test
[ 400 ] [ "Test error" respond-bad code>> ] unit-test

ABOUT: "zplprinter.tests"
