data impdata;
infile '/folders/myfolders/imps.csv' delimiter = ",";
input _imputation_ id abuse bmi bds1-bds7 edr1-edr6;

* compute scale scores;
bodydis = bds1 + bds2 + bds3 + bds4 + bds5 + bds6 + bds7;
eatrisk = edr1 + edr2 + edr3 + edr4 + edr5 + edr6;
run;

* analysis;
proc reg data = impdata outest = estimates covout noprint;
model eatrisk = abuse bodydis;
by _imputation_;
run;

* analysis;
proc mianalyze data = estimates edf = 497;
modeleffects Intercept abuse bodydis;
run;