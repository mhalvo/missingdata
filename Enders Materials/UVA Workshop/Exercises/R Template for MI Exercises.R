# Required packages
library(mitml)

# Read data
filepath <- "yourfilepath"
impdata <- read.csv(filepath, header = F)
names(impdata) <- c("imputation", "student", "abilitygrp", "female", "stanmath", "frlunch", "efficacy", "probsolve1", "probsolve7")
