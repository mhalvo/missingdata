# Required packages
library(mitml)

# Read data
filepath <- "~/desktop/examples/imps.csv"
impdata <- read.csv(filepath, header = F)
names(impdata) <- c("imputation", "student", "abilitygrp", "female", "stanmath", "frlunch", "efficacy", "probsolve1", "probsolve7")
impdata$abilitygrp <- factor(impdata$abilitygrp)

# Analyze data and pool estimates
implist <- as.mitml.list(split(impdata, impdata$imputation))
analysis <- with(implist, lm(probsolve7 ~ probsolve1 + efficacy + female + abilitygrp))
estimates <- testEstimates(analysis, var.comp = T, df.com = (930-5-1))
estimates

# Compare models with Wald test
emptymodel <- with(implist, lm(probsolve7 ~ 1))
testModels(analysis, emptymodel, method = "D1")
