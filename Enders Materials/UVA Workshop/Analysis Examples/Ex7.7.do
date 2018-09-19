// Import and save original data
import delimited "~/desktop/examples/pain.csv"
rename (v1 - v8)(id female diagnose sleep pain posaff negaff stress)
generate imp = 0

// Recode missing values
foreach var of varlist id - stress {
     replace `var' = . if `var'== -99
}
save original, replace

// Import and save imputed data
clear
import delimited "~/desktop/examples/imps.csv"
rename (v1 - v9)(imp id female diagnose sleep pain posaff negaff stress)
save imputed, replace

// Append original and imputed data
use original, clear
append using imputed

// Convert to mi data
mi import flong, m(imp) id(id) imputed(female - stress) clear

// Compute product term
gen femxpain = female * pain

// Analyze data and pool results
mi estimate, cmdok: regress stress female pain femxpain

