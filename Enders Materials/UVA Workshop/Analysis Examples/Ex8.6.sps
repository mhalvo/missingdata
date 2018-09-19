* Encoding: UTF-8.
data list free file =  '/users/craig/desktop/examples/imps.csv'
 /imputation_ school condition esolpercent student abilitygrp 
   female stanmath frlunch wave months probsolve efficacy.
exe. 

* Initiate pooling routines.
sort cases by imputation_.
split file layed by imputation_.

* Analysis and pooling.
mixed probsolve with months efficacy stanmath condition
  /print = solution testcov
  /fixed = intercept months efficacy stanmath condition months*condition
  /random = intercept months | subject(student) covtype(un).
