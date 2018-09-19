data list free file =  '/users/craig/desktop/examples/imps.csv'
 /imputation_ student abilitygrp female stanmath frlunch efficacy probsolve1
    probsolve7.
exe. 

* create dummy codes.
compute abilitygrp2 = 0.
compute abilitygrp3 = 0.
if (abilitygrp = 2) abilitygrp2 = 1.
if (abilitygrp = 3) abilitygrp3 = 1.
exe. 

* initiate pooling routines.
sort cases by imputation_.
split file layed by imputation_.

* analysis and pooling.
regression
  /descriptives mean stddev corr sig n
  /dependent probsolve7
  /method enter probsolve1 efficacy female abilitygrp2 abilitygrp3.
 
