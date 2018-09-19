data impdata;
infile '/folders/myfolders/imps.csv' delimiter = ",";
input _imputation_ student abilitygrp female stanmath frlunch 
   efficacy probsolve1 probsolve7;
abilitygrp2 = 0;
abilitygrp3 = 0;
if abilitygrp = 2 then abilitygrp2 = 1;
if abilitygrp = 3 then abilitygrp3 = 1;
run;

proc reg data = impdata outest = estimates covout noprint;
model probsolve7 = probsolve1 efficacy female abilitygrp2 abilitygrp3;
by _imputation_;
run;

proc mianalyze data = estimates edf = 924;
modeleffects Intercept probsolve1 efficacy female abilitygrp2 abilitygrp3;
run;