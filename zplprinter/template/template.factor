USING: combinators formatting kernel make math math.order
present sequences zplprinter.utils ;
IN: zplprinter.template

: %header ( data -- )
    "^XA\n^CI28\n" %
    { "grocycode" } get-nested [ present % ] when* "^FS\n" % ;

: %product ( data -- )
    { "product" } get-nested
    [ "^CF0,50^FO50,50^FD" % present % "^FS ^FO700,50^FD" % "N/A" % "^FS\n" % ] when* ;

: %price ( data -- )
    { "details" "avg_price" } get-nested
    [
        "^CF0,30^FO50,115^FDDurchschnittspreis: " %
        "%.2f" sprintf %
        " EUR^FS\n" %
    ] when* ;

: %stock ( data -- )
    dup { "details" "product" "min_stock_amount" } get-nested [
        dup 0 > [
            "^FO50,155^FDMin Stock: " % present % " " %
            { "details" "quantity_unit_stock" "name" } get-nested [ present % ] when* "^FS\n" %
        ] [ 2drop ] if
    ] [ drop ] if* ;

: %mhd ( data -- )
    "^FO50,195^FD" %
    { "due_date" } get-nested [ present % ] when* "^FS\n" % ;

: %move-on-open ( data -- )
    { "details" "product" "move_on_open" } get-nested
    [ 1 = [ "^FO50,235^FDMove On Open^FS\n" % ] when ] when* ;

: calc-x-pos ( string -- x )
    length 11 * 381 swap - 0 max ;

: %centered-barcode ( string -- )
    dup calc-x-pos swap "^FO%d,315^BC^FD%s^FS\n" sprintf % ;

: %barcode ( data -- )
    "^FO50,275^GB750,3,3^FS\n^BY2,2,225\n" %
    { "grocycode" } get-nested [ present %centered-barcode ] when* ;

: %footer ( -- )
    "^XZ\n" % ;

:: label>zpl ( data -- zpl )
    [
        data %header
        data %product
        data %price
        data %stock
        data %mhd
        data %move-on-open
        data %barcode
        %footer
    ] "" make ;
