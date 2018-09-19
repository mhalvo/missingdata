// import original data
import delimited "~/desktop/examples/smoking.dat"
rename (v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11)(id txgroup txdum1 txdum2 male age years cigs heavycig efficacy stress)
generate imp=0

foreach var of varlist id txgroup txdum1 txdum2 male age years cigs heavycig efficacy stress {
     replace `var' = . if `var'== -99
}
save original, replace

// import imputed data
clear
import delimited "~/desktop/examples/imps.csv"
rename (v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12)(imp id txgroup txdum1 txdum2 male age years cigs heavycig efficacy stress)
save imputed, replace

// append original and imputed data
use original, clear
append using imputed

//// convert to mi data
mi import flong, m(imp) id(id) imputed(txgroup txdum1 txdum2 male age years cigs heavycig efficacy stress) clear

//// analyze data and pool results
mi estimate, cmdok: regress efficacy years cigs

