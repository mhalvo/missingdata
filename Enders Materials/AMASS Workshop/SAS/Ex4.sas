data impdata;
infile '/folders/myfolders/imps.csv' delimiter = ",";
input _imputation_ school condition esolpercent student abilitygrp female 
   stanmath frlunch efficacy probsolve1 probsolve7;
run;

ods _all_ close;
proc mixed data = impdata noclprint;
class school;
model probsolve7 = probsolve1 efficacy female esolpercent condition / solution covb;
random intercept efficacy / subject = school type = un;
by _imputation_;
ods output SolutionF = estimates CovB = covb;
ods listing;
run;

proc mianalyze parms = estimates covb(effectvar = rowcol) = covb;
modeleffects Intercept probsolve1 efficacy female esolpercent condition;
run;