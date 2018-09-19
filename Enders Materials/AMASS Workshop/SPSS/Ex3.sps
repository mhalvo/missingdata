data list free file =  '/users/craig/desktop/examples/imps.csv'
 /imputation_ input _imputation_ id female diagnose sleep pain posaff negaff stress.
exe. 

* compute product variable.
compute femxpain = female * pain.
exe.

* initiate pooling routines.
sort cases by imputation_.
split file layed by imputation_.

* analysis and pooling.
regression
  /descriptives mean stddev corr sig n
  /dependent stress
  /method enter female pain femxpain.
 
