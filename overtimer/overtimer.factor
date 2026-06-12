USING: formatting kernel math ;
IN: overtimer

CONSTANT: keep-hours 16
CONSTANT: net-per-hour 18.70
CONSTANT: overtime-per-day 2

! --- Logic ---

: billable-hours ( current -- billable )
    keep-hours - ;

: missing-hours ( target current -- missing )
    billable-hours - ;

: calc-payout ( hours -- net-payout )
    net-per-hour * ;

: days-required ( missing -- days )
    overtime-per-day / ;

! --- Output ---

: print-payout ( net-payout prefix -- )
    swap "%s payout is estimated EUR %.2f\n" printf ;

: print-missing ( missing -- )
    dup days-required "Missing %.2f hours. %.2f Days required\n" printf ;

: target-payout. ( target -- )
    calc-payout "Target" print-payout ;

: current-payout. ( current -- )
    billable-hours calc-payout "Curr. " print-payout ;

: run-overtimer ( target current -- )
    2dup missing-hours print-missing
    [ target-payout. ] [ current-payout. ] bi* ;

MAIN: [
    21.50          ! Target
    36.50 1.5 +    ! Current + Today
    run-overtimer
]
