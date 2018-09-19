data list free file =  '/users/craig/desktop/examples/imps.csv'
 /imputation_ school condition esolpercent student abilitygrp female 
   stanmath frlunch efficacy probsolve1 probsolve7.
exe. 

* initiate pooling routines.
sort cases by imputation_.
split file layed by imputation_.

* analysis and pooling.
mixed probsolve7 with probsolve1 efficacy female esolpercent condition
  /print = solution testcov
  /criteria = mxiter(1000) scoring(1000)
  /fixed = intercept probsolve1 efficacy female esolpercent condition efficacy*condition
  /random = intercept efficacy | subject(school) covtype(un).