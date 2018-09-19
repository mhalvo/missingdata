// Import and save original data
import delimited "~/desktop/examples/probsolve.csv"
rename (v1 - v12)(school condition esolpercent student abilitygrp female stanmath frlunch wave months probsolve efficacy)
generate imp = 0
generate id = student * 10000 + wave

// Recode missing values
foreach var of varlist school condition esolpercent student abilitygrp female stanmath frlunch wave months probsolve efficacy {
     replace `var' = . if `var'== -99
}
save original, replace

// Import and save imputed data
clear
import delimited "~/desktop/examples/imps.csv"
rename (v1 - v13)(imp school condition esolpercent student abilitygrp female stanmath frlunch wave months probsolve efficacy)
generate id = student * 10000 + wave
save imputed, replace

// Append original and imputed data
use original, clear
append using imputed

// Convert to mi data
mi import flong, m(imp) id(id) imputed(school condition esolpercent student abilitygrp female stanmath frlunch wave months probsolve efficacy) clear

// Analyze data and pool results
mi estimate, cmdok: mixed probsolve months efficacy stanmath condition c.months#c.condition || student: months, covariance(un) var
