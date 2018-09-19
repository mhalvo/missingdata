data impdata;
infile '/folders/myfolders/imps.csv' delimiter = ",";
input _imputation_ id female diagnose sleep pain posaff negaff stress;

* compute product variable;
femxpain = female * pain;
run;

* analysis;
proc reg data = impdata outest = estimates covout noprint;
model stress = female pain femxpain;
by _imputation_;
run;

* pooling;
proc mianalyze data = estimates edf = 246;
modeleffects Intercept female pain femxpain;
run;