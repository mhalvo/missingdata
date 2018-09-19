data list free file =  '/users/craig/desktop/examples/imps.csv'
 /imputation_ id txgroup txdum1 txdum2 male age years 
  cigs heavycig efficacy stress.
exe. 

* initiate pooling routines.
sort cases by imputation_.
split file layed by imputation_.

* analysis and pooling.
regression
  /descriptives mean stddev corr sig n
  /dependent efficacy
  /method enter years cigs.
 
