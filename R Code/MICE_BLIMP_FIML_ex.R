##############################
# Missing Data Workshop      #
#   for UW Graduate Students #
##############################
# Max Halvorson #
#  9/20/18      #
#########################
# Data Analysis Example #
#########################


###
################################
# Multiple Imputation Examples #
################################
###

library('tidyverse')
library('lattice')
library('mice')

### 0) data load and cleaning ###
dnba <- as.tibble(read.csv('https://raw.githubusercontent.com/mhalvo/teaching/master/NBAcombine.csv'))
dnba$PID <- 1:1000
dnba <-  select(dnba, 
                Name, PID, Height, Weight, Vertical, T.Q..Spring,
                L.A.T., NSeasons)
dnba_m <- select(dnba, -Name) %>% replace(., . == 0, NA)
dnba_m$NSeasons <- replace(dnba_m$NSeasons, is.na(dnba_m$NSeasons), 0)

#####################
# Impute using MICE # 
#####################

### 1) look at our data and check missing data patterns
print(dnba_m, n=30)
md.pattern(dnba_m)

### 2) run an empty imputation model to check some parameters
init <- mice(dnba_m, maxit=0)
init
meth <- init$method # can specify distributions here

### 3) run imputations 
imp_dnba_m <- mice(dnba_m, # run imputation
                 m=5,
                 maxit=50,
                 method=meth,
                 seed=1337)
# Discuss Predictor and Imputation lists
### A note on predictive mean matching
### FCS: "Fully conditional specification"

### 4) Check out our result
plot(imp_dnba_m) # examine convergence
densityplot(imp_dnba_m) # anything look totally off?

imp1 <- mice::complete(imp_dnba_m, 1) 
imp1$Name <- dnba$Name
select(imp1, Name, Height)[which(dnba$Height==0),] # data checking is always key!

# Check some imputed height values for fun: a few actual heights - Nick Collison: 82, Chris Bosh: 83, Sasha Vujacic: 79

### 5) Analyze/summarize results
fit_m <- with(imp_dnba_m, lm(NSeasons ~ Height + Weight + T.Q..Spring)) # summarize results
pool.fit_m <- pool(fit_m)
summary(pool.fit_m)
summary(lm(NSeasons ~ Height + Weight + T.Q..Spring, data=dnba_m))

###
# Read these before running your own analyses - nice code snippets and 
#   help in decision-making 
#
# http://www.gerkovink.com/miceVignettes/
###


### Note: Under the hood, mice is pooling estimates with the method described in Baraldi & Enders, 2010. We can do this manually if we want a sanity check.
B0s <- sapply(fit$analyses, function(x) {
  x$coef[1]})
B0bar <- mean(B0s)
summ <- lapply(fit$analyses, function(x) {
  summary(x)})
VW0 <- sapply(summ, function(x) { # within-imputation variance
  x$coef[1,2]}) %>% .^2 %>% mean
VB0 <- sum((B0s-B0bar)^2) / (5-1)
poolSEB0 <- sqrt(VW0 + VB0 + VB0/5)

B0bar
poolSEB0
summary(pool.fit)

###################
# Impute in BLIMP #
###################

### 1) export datasets to BLIMP ###
dnba_b <- select(dnba, -Name) %>% replace(., .==0, -9999) 
dnba_b$NSeasons <- replace(dnba_b$NSeasons, dnba_b$NSeasons==-9999, 0)
write.table(dnba_b, file="dnba_b.csv", sep=",", row.names=F, col.names=F)

### 2) impute in BLIMP - BLIMP has PSR and monitors convergence
### 3) read data in to analyze in your software of choice!
# For complex models, you might analyze in MPlus. I'll show R code below to demo data flow
imp_dnba_b <- as.tibble(read.csv(file='imputed_dnba_b.csv', header=F))
names(imp_dnba_b) <- c("imp", names(dnba_b))

# 3a) create a list containing a dataset for each imputation
imps_b <- list()
for(i in 1:5) {
  imps_b[[i]] <- filter(imp_dnba_b, imp==i)
}

### 4) analyze data
fit_b <- lapply(imps_b, function(x) {
  summary(lm(NSeasons ~ Height + Weight + T.Q..Spring, data=x))
})

### 5) pool estimates
Bs <- sapply(fit_b, function(x) {
 x$coef[,1]
})
pooled_Bs <- rowMeans(Bs)

SEs <- sapply(fit_b, function(x) {
  x$coef[,2]})
VWs <- rowMeans(SEs^2)
VBs <- rowMeans((Bs-pooled_Bs)^2)
pooled_SEs <- sqrt(VWs + VBs + VBs/5)

pooled_Bs
pooled_SEs


###
# Read this concise manual when running your own analyses - nice  
#   help in decision-making and succinct description of options 
#
# http://www.appliedmissingdata.com/blimpuserguide-5.pdf
###

#########################
# Notes and Comparisons #
#########################

# MICE can handle multilevel data (but it's confusing, and can only handle normally distributed variables)
# BLIMP is designed to multilevel data intuitively

# MICE wants NA for missing data
# BLIMP wants numeric values (I use -9999) and a numeric ID variable

# MICE imputes observations with NO valid data
# BLIMP does not impute observations with NO data
# BOTH will impute data for observations with even ONE value
dnba[c(375,616),]
imp1[c(375,616),]
mice::complete(imp_dnba_m, 2)[c(375,616),]
lapply(imps_b, function(x) filter(x, PID==c(375,616)))
# Yi Jianlian is 6'11, 243. MICE imputes 6'4.5", 194.2. If nothing else, remember that I am not Yi Jianlian


###
################
# FIML Example #
################
###

library('lavaan')
library('semPlot')

### Data load and cleaning ###
dnba_f <- dnba_m
print(dnba_f, n=50)

###############################
# Specify models using lavaan # Did you know lavaan is an acronym?
###############################

model1 <- '
#betas
NSeasons ~ Height + Weight + T.Q..Spring
'

fit1 <- sem(model1,
            data=dnba_f,
            fixed.x=F)
summary(fit1, fit.measures=T, standardized=F, rsquare=T)
summary(lm(NSeasons ~ Height + Weight + T.Q..Spring, data=dnba_f))


fit1.ml <- sem(model1,
               data=dnba_m,
               fixed.x=F,
               missing="ML") # missing="ML" is the piece to add
summary(fit1.ml)
summary(lm(NSeasons ~ Height + Weight + T.Q..Spring, data=dnba_f))


###################################
# Comparison across the 3 methods #
###################################

(result <- summary(lm(NSeasons ~ Height + Weight + T.Q..Spring, data=dnba_f))$coef)
(result.mice <- summary(pool.fit))
(result.blimp <- cbind(pooled_Bs, pooled_SEs))
result.fiml <- summary(fit1.ml)

