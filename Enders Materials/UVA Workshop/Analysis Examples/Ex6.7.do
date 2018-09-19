// Import and save original data
import delimited "~/desktop/examples/eatingrisk.csv"
rename (v1 - v16)(id abuse bmi bds1 bds2 bds3 bds4 bds5 bds6 bds7 edr1 edr2 edr3 edr4 edr5 edr6)
generate imp = 0

// Recode missing values
foreach var of varlist id - edr6 {
     replace `var' = . if `var'== -99
}
save original, replace

// Import and save imputed data
clear
import delimited "~/desktop/examples/imps.csv"
rename (v1 - v17)(imp id abuse bmi bds1 bds2 bds3 bds4 bds5 bds6 bds7 edr1 edr2 edr3 edr4 edr5 edr6)
save imputed, replace

// Append original and imputed data
use original, clear
append using imputed

// Compute scale scores
generate bodydis = bds1 + bds2 + bds3 + bds4 + bds5 + bds6 + bds7
generate eatrisk = edr1 + edr2 + edr3 + edr4 + edr5 + edr6

// Convert to mi data
mi import flong, m(imp) id(id) imputed(abuse bmi bds1 - bds7 edr1 - edr6 bodydis eatrisk) clear

// Analyze data and pool results
mi estimate, cmdok: regress eatrisk abuse bodydis
