// Import and save original data
import delimited "~/desktop/examples/smoking.csv"
rename (v1 - v9)(id quitmeth male age years cigs heavycig efficacy stress)
generate imp=0

// Recode missing values
foreach var of varlist id - stress {
     replace `var' = . if `var'== -99
}
save original, replace

// Import and save imputed data
clear
import delimited "~/desktop/examples/imps.csv"
rename (v1 - v10)(imp id quitmeth male age years cigs heavycig efficacy stress)
save imputed, replace

// Append original and imputed data
use original, clear
append using imputed

// Convert to mi data
mi import flong, m(imp) id(id) imputed(quitmeth - stress) clear

// Analyze data and pool results
mi estimate, cmdok: regress efficacy heavycig male years
