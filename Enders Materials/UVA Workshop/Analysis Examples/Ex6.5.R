# Required packages
library(mitml)

# Read data
impdata <- read.csv(file = "~/desktop/examples/imps.csv",head = FALSE, sep = ",")
names(impdata) = c("imp","id","abuse","bmi","bds1","bds2","bds3","bds4","bds5","bds6","bds7",
  "edr1","edr2","edr3","edr4","edr5","edr6")

# Compute scale scores
impdata$bodydis <- rowSums(subset(impdata, select = bds1:bds7))
impdata$eatrisk <- rowSums(subset(impdata, select = edr1:edr6))

# Analyze data and pool estimates
implist <- split(impdata, impdata$imp)
implist <- as.mitml.list(implist)
analysis <- with(implist, lm(eatrisk ~ abuse + bodydis))
testEstimates(analysis, df.com = 497)

# Test full model with Wald test
emptymodel <- with(implist, lm(eatrisk ~ 1))
testModels(analysis, emptymodel, method = "D1")