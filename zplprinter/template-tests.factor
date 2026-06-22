USING: tools.test zplprinter.template ;

IN: zplprinter.tests.template

LH{ { "product" "TestProduct" } { "grocycode" "1234567890" } } CONSTANT: test-payload
LH{ { "product" "TestProduct" } } CONSTANT: no-code-payload

"^XA\n^CI28\n1234567890^FS\n^CF0,50^FO50,50^FDTestProduct^FS ^FO700,50^FDN/A^FS\n^FO50,275^GB650,3,3^FS\n^BY2,2,225\n^FO50,315^BC^FD1234567890^FS\n^XZ\n" CONSTANT: expected-zpl

! === Template ===

[ t ] [ "TestProduct" test-payload label>zpl subseq? ] unit-test
[ t ] [ "1234567890" test-payload label>zpl subseq? ] unit-test
[ expected-zpl ] [ test-payload label>zpl ] unit-test
[ f ] [ "1234567890" no-code-payload label>zpl subseq? ] unit-test

ABOUT: "zplprinter.tests.template"