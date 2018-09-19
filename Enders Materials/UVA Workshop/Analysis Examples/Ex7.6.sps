* Encoding: UTF-8.
data list free file =  '/users/craig/desktop/examples/imps.csv'
 /imputation_ id female diagnose sleep pain posaff negaff stress.
exe. 

* Compute product variable.
compute femxpain = female * pain.
exe.

* Initiate pooling routines.
sort cases by imputation_.
split file layed by imputation_.

* Analysis and pooling.
regression
  /descriptives mean stddev corr sig n
  /dependent stress
  /method enter female pain femxpain.
 
