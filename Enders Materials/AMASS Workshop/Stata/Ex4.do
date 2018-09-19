// import original data
import delimited "~/desktop/examples/probsolve.dat"
rename (v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11)(school condition esolpercent student abilitygrp female stanmath frlunch efficacy probsolve1 probsolve7)
foreach var of varlist condition esolpercent abilitygrp female stanmath frlunch efficacy probsolve1 probsolve7 {
     replace `var' = . if `var'== 999
}
generate imp = 0
save original, replace

// import imputed data
clear
import delimited "~/desktop/examples/imps.csv"
rename (v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 )(imp school condition esolpercent student abilitygrp female stanmath frlunch efficacy probsolve1 probsolve7)
save imputed, replace

// append original and imputed data
use original, clear
append using imputed

// convert to mi data
mi import flong, m(imp) id(student) imputed(school condition esolpercent abilitygrp female stanmath frlunch efficacy probsolve1 probsolve7) clear

// analyze data and pool results
mi estimate, cmdok: mixed probsolve7 probsolve1 efficacy female esolpercent condition c.efficacy#c.condition || school: efficacy, covariance(independent) var
