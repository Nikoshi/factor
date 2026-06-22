USING: kernel tools.test zplprinter.utils ;

IN: zplprinter.tests.utils

LH{ { "product" "TestProduct" } { "grocycode" "1234567890" } } CONSTANT: test-payload
LH{ } CONSTANT: empty-payload

! === Utils ===

[ t ] [ test-payload "grocycode" safe-at "1234567890" = ] unit-test
[ f ] [ f "grocycode" safe-at ] unit-test
[ t ] [ test-payload { "product" } get-nested "TestProduct" = ] unit-test
[ f ] [ empty-payload { "product" } get-nested ] unit-test
[ f ] [ test-payload { "details" "product" "min_stock_amount" } get-nested ] unit-test

ABOUT: "zplprinter.tests.utils"