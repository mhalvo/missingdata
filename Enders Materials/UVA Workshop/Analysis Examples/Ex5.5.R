# Required packages
library(mitml)

# Read data
filepath <- "~/desktop/examples/imps.csv"
impdata <- read.csv(filepath, header = F)
names(impdata) <- c("imputation", "id", "quitmeth", "male", "age", "years", "cigs", "heavycig", "efficacy", "stress")

# Analyze data and pool estimates
implist <- as.mitml.list(split(impdata, impdata$imputation))
analysis <- with(implist, lm(efficacy ~ heavycig + male + years))
estimates <- testEstimates(analysis, var.comp = T, df.com = 17)
estimates

# Test full model with Wald test
emptymodel <- with(implist, lm(efficacy ~ 1))
testModels(analysis, emptymodel, method = "D1")