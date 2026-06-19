USING: tools.test sequences strings calendar zplprinter ;IN: zplprinter.tests

LH{ { "Product" "TestProduct" } { "Grocycode" "1234567890" } } CONSTANT: test-payload
LH{ { "Product" "TestProduct" } } CONSTANT: no-code-payload
LH{ } CONSTANT: empty-payload

"^XA\n^CI28\n^CF0,60\n^FO65,100^BXN,7,200,,,6,~,1^FD1234567890^FS\n^FO250,50^FDTestProduct^FS\n^CF0,30\n^FO50,300^GB700,3,3^FS\n^BY4,2,250\n^FO100,350^BC^FD1234567890^FS\n^XZ\n" CONSTANT: expected-zpl

! === label>zpl Tests ===

[ t ] [ test-payload label>zpl "TestProduct" contains? ] unit-test
[ t ] [ test-payload label>zpl "1234567890" contains? ] unit-test
[ expected-zpl ] [ test-payload label>zpl ] unit-test
[ f ] [ no-code-payload label>zpl "1234567890" contains? ] unit-test

! === Helper-Funktionen ===

[ f ] [ empty-payload { "Product" } get-nested ] unit-test
[ t ] [ current-utc-timestamp length 10 > ] unit-test

! === respond-ok / respond-bad ===

[ 200 ] [ respond-ok code>> ] unit-test
[ 400 ] [ "Test error" respond-bad code>> ] unit-test

ABOUT: "zplprinter.tests"