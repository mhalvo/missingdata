// import original data
import delimited "~/desktop/examples/pain.dat"
rename (v1 v2 v3 v4 v5 v6 v7 v8)(id female diagnose sleep pain posaff negaff stress)
foreach var of varlist id female diagnose sleep pain posaff negaff stress {
     replace `var' = . if `var'== -99
}
generate imp = 0
save original, replace

// import imputed data
clear
import delimited "~/desktop/examples/imps.csv"
rename (v1 v2 v3 v4 v5 v6 v7 v8 v9)(imp id female diagnose sleep pain posaff negaff stress)
save imputed, replace

// append original and imputed data
use original, clear
append using imputed

// convert to mi data
mi import flong, m(imp) id(id) imputed(female diagnose sleep pain posaff negaff stress) clear

// analyze data and pool results
mi estimate, cmdok: regress stress = female pain c.female#c.pain

