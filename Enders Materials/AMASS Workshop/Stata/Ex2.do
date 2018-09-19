// import original data
import delimited "~/desktop/examples/eatingrisk.dat"
rename (v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14 v15 v16)(id abuse bmi bds1 bds2 bds3 bds4 bds5 bds6 bds7 edr1 edr2 edr3 edr4 edr5 edr6)
foreach var of varlist id abuse bmi bds1 bds2 bds3 bds4 bds5 bds6 bds7 edr1 edr2 edr3 edr4 edr5 edr6 {
     replace `var' = . if `var'== -99
}
generate imp=0
generate bodydis=bds1+bds2+bds3+bds4+bds5+bds6+bds7
generate eatrisk=edr1+edr2+edr3+edr4+edr5+edr6
save original, replace

// import imputed data
clear
import delimited "~/desktop/examples/imps.csv"
rename (v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14 v15 v16 v17)(imp id abuse bmi bds1 bds2 bds3 bds4 bds5 bds6 bds7 edr1 edr2 edr3 edr4 edr5 edr6)
generate bodydis=bds1+bds2+bds3+bds4+bds5+bds6+bds7
generate eatrisk=edr1+edr2+edr3+edr4+edr5+edr6
save imputed, replace

// append original and imputed data
use original, clear
append using imputed

//// convert to mi data
mi import flong, m(imp) id(id) imputed(abuse bmi bds1 bds2 bds3 bds4 bds5 bds6 bds7 edr1 edr2 edr3 edr4 edr5 edr6) clear

//// analyze data and pool results
mi estimate, cmdok: regress eatrisk abuse bodydis

