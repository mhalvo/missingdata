// Import original data
import delimited "yourfilepath/exercisedat.csv"
rename (v1 - v8)(student abilitygrp female stanmath frlunch efficacy probsolve1 probsolve7)
generate imp=0

// Recode missing values
foreach var of varlist abilitygrp female stanmath frlunch efficacy probsolve1 probsolve7 {
     replace `var' = . if `var'== -99
}
save original, replace

// Import imputed data
clear
import delimited "~/desktop/examples/imps.csv"
rename (v1 - v9)(imp student abilitygrp female stanmath frlunch efficacy probsolve1 probsolve7)
save imputed, replace

// Append original and imputed data
use original, clear
append using imputed

