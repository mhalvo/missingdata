* Encoding: UTF-8.
data list free file = '/users/craig/desktop/examples/imps.csv'
 /imputation_ id quitmeth male age years cigs heavycig 
  efficacy stress.
exe. 

* Initiate pooling routines.
sort cases by imputation_.
split file layered by imputation_.

* Analysis and pooling.
regression
  /descriptives mean stddev corr sig n
  /dependent efficacy
  /method enter heavycig male years.
