* Encoding: UTF-8.
data list free file = '/users/craig/desktop/examples/imps.csv'
 /imputation_ id abuse bmi bds1 to bds7 edr1 to edr6.
exe. 

* Compute scale scores.
compute bodydis = sum(bds1 to bds7).
compute eatrisk = sum(edr1 to edr6).
exe.

* Initiate pooling routines.
sort cases by imputation_.
split file layered by imputation_.

* Analysis and pooling.
regression
  /descriptives mean stddev corr sig n
  /dependent eatrisk
  /method=enter abuse bodydis.
