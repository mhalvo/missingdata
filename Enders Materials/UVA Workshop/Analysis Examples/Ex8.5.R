# Required packages
library(mitml)
library(lme4)

# Read data
filepath <- "~/desktop/examples/imps.csv"
impdata <- read.csv(filepath, header = F)
names(impdata) <- c("imputation", "school", "condition", "esolpercent", "student", "abilitygrp", "female", "stanmath", "frlunch", "wave", "months", "probsolve", "efficacy")
impdata$conditionbytime <- impdata$months * impdata$condition

# Analyze data and pool estimates
implist <-  as.mitml.list(split(impdata, impdata$imputation))
analysis <- with(implist, lmer(probsolve ~ months + efficacy + stanmath + condition + conditionbytime + (months|student), REML = F))
estimates <- testEstimates(analysis, var.comp = T, df.com = NULL)
estimates
