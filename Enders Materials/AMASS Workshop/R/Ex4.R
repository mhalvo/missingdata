# Required packages
library(mitml)
library(lme4)

# Read data
filepath <- "~/desktop/examples/imps.csv"
impdata <- read.csv(filepath, header = F)
names(impdata) <- c("imputation", "school", "condition", "esolpercent", "student", "abilitygrp", "female", "stanmath", "frlunch", "efficacy", "probsolve1", "probsolve7")

# Analyze data and pool estimates

model <- "probsolve7 ~ probsolve1 + efficacy + female + esolpercent + condition + (efficacy|school)"
implist <-  as.mitml.list(split(impdata, impdata$imputation))
analysis <- with(implist, lmer(model, REML = F))
estimates <- testEstimates(analysis, var.comp = T, df.com = NULL)
estimates

# Compare models with likelihood ratio test
ranintercept <- with(implist, lmer(probsolve7 ~ probsolve1 + efficacy + female + esolpercent + condition + (1|school)))
testModels(analysis, ranintercept, method = "D3")
