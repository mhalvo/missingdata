data list free file =  '/users/craig/desktop/examples/imps.csv'
 /imputation_ id abuse bmi bds1 to bds7 edr1 to edr6.
exe. 

* compute scale scores.
compute bodydis = bds1 + bds2 + bds3 + bds4 + bds5 + bds6 + bds7.
compute eatrisk = edr1 + edr2 + edr3 + edr4 + edr5 + edr6.
exe. 

* initiate pooling routines.
sort cases by imputation_.
split file layed by imputation_.

* analysis and pooling.
regression
  /descriptives mean stddev corr sig n
  /dependent eatrisk
  /method enter abuse bodydis.
 
