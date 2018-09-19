# Required packages
library(mitml)

# Read data
filepath <- "~/desktop/examples/imps.csv"
impdata <- read.csv(filepath, header = F)
names(impdata) <- c("imputation","id","female","diagnose","sleep","pain","posaff","negaff","stress")

# Compute product variable
impdata$femxpain <- impdata$female * impdata$pain

# Analyze data and pool estimates
implist <- as.mitml.list(split(impdata, impdata$imputation))
analysis <- with(implist, lm(stress ~ female + pain + femxpain))
estimates <- testEstimates(analysis, var.comp = T, df.com = (250-3-1))
estimates

# Compare models with Wald test
emptymodel <- with(implist, lm(stress ~ 1))
testModels(analysis, emptymodel, method = "D1")
