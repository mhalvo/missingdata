data impdata;
infile '/folders/myfolders/imps.csv' delimiter = ",";
input _imputation_ id txgroup txdum1 txdum2 male age years 
  cigs heavycig efficacy stress;
run;

proc reg data = impdata outest = estimates covout noprint;
model efficacy = years cigs;
by _imputation_;
run;

proc mianalyze data = estimates edf = 17;
modeleffects Intercept years cigs;
run;