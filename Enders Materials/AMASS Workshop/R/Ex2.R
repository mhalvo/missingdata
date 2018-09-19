# Required packages
library(mitml)

# Read data
filepath <- "~/desktop/examples/imps.csv"
impdata <- read.csv(filepath, header = F)
names(impdata) <- c("imputation","id","abuse","bmi","bds1","bds2","bds3","bds4","bds5","bds6","bds7",
                    "edr1","edr2","edr3","edr4","edr5","edr6")

# Compute scale scores
impdata$bodydis <- bds1+bds2+bds3+bds4+bds5+bds6+bds7
impdata$eatrisk <- edr1+edr2+edr3+edr4+edr5+edr6

# Analyze data and pool estimates
implist <- as.mitml.list(split(impdata, impdata$imputation))
analysis <- with(implist, lm(eatrisk ~ abuse + bodydis))
estimates <- testEstimates(analysis, var.comp = T, df.com = (500-2-1))
estimates

# Compare models with Wald test
emptymodel <- with(implist, lm(eatrisk ~ 1))
testModels(analysis, emptymodel, method = "D1")
