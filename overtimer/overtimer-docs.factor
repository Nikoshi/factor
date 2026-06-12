USING: help.markup help.syntax overtimer math strings io formatting ;
IN: overtimer

HELP: keep-hours
{ $description "A constant specifying the baseline hours that must be completed before any hours are considered billable overtime." } ;

HELP: net-per-hour
{ $description "A constant representing the net payout rate per hour in EUR (18.70)." } ;

HELP: overtime-per-day
{ $description "A constant defining the standard or expected capacity of overtime hours worked per day (2.00)." } ;

HELP: billable-hours
{ $values { "current" real } { "billable" real } }
{ $description "Calculates billable hours by subtracting the baseline " { $link keep-hours } " from the " { $snippet "current" } " accumulated hours." } ;

HELP: missing-hours
{ $values { "target" real } { "current" real } { "missing" real } }
{ $description "Computes the remaining hours needed to reach the target. Subtracts the billable hours (derived from " { $snippet "current" } ") from the " { $snippet "target" } " billable hours." }
{ $notes "The target parameter represents net billable hours, while the current parameter expects gross total hours." } ;

HELP: calc-payout
{ $values { "hours" real } { "net-payout" real } }
{ $description "Multiplies the input " { $snippet "hours" } " by " { $link net-per-hour } " to calculate the total estimated net payout." } ;

HELP: days-required
{ $values { "missing" real } { "days" real } }
{ $description "Calculates the required working days by dividing the " { $snippet "missing" } " hours by the " { $link overtime-per-day } " constant." } ;

HELP: print-payout
{ $values { "net-payout" real } { "prefix" string } }
{ $description "Prints the estimated payout formatted to two decimal places, labeled with the provided " { $snippet "prefix" } "." } ;

HELP: print-missing
{ $values { "missing" real } }
{ $description "Prints the number of missing hours and the required working days calculated via " { $link days-required } "." } ;

HELP: target-payout.
{ $values { "target" real } }
{ $description "Calculates and prints the estimated net payout for the specified target hours." } ;

HELP: current-payout.
{ $values { "current" real } }
{ $description "Calculates the billable hours for the current progress and prints the corresponding estimated net payout." } ;

HELP: run-overtimer
{ $values { "target" real } { "current" real } }
{ $description "Executes the complete evaluation pipeline. Outputs the missing metrics and triggers the payout calculations for both current and target paths." }
{ $example
    "USING: overtimer ;\n21.50 35.50 run-overtimer"
    "Missing 2.00 hours. 1.00 Days required\nTarget payout is estimated EUR 402.05\nCurr.  payout is estimated EUR 364.65\n"
} ;

ARTICLE: "overtimer" "Overtimer Documentation"
"The " { $vocab-link "overtimer" } " vocabulary provides simple calculations for tracking overtime hours, missing targets, and estimating net payouts based on fixed configuration constants."
{ $heading "Constants" }
{ $table
    { { $strong "Constant" } { $strong "Value" } { $strong "Description" } }
    { { $link keep-hours } "16" "Base hours threshold." }
    { { $link net-per-hour } "18.70" "Net hourly wage." }
    { { $link overtime-per-day } "2" "Daily overtime capacity." }
}
{ $heading "Core Logic" }
{ $subsections
    billable-hours
    missing-hours
    calc-payout
    days-required
}
{ $heading "Output Words" }
{ $subsections
    print-payout
    print-missing
    target-payout.
    current-payout.
    run-overtimer
} ;

ABOUT: "overtimer"
