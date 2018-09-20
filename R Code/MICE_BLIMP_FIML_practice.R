##############################
# Missing Data Workshop      #
#   for UW Graduate Students #
##############################
# Max Halvorson #
#  9/20/18      #
##########################
# Data Analysis Practice #
##########################

dc <- as.tibble(read.csv2("cereal.csv", sep=";"))
dc$rating <- as.numeric(substr(dc$rating.., 1, 5))
dc <- select(dc, rating, calories, protein, fat, sodium, fiber, carbo, sugars, name)
dc[sample(77, 7),1] <- NA
dc[sample(77, 9),2] <- NA
dc[sample(77, 5),3] <- NA
dc[sample(77, 3),4] <- NA
dc[sample(77, 6),5] <- NA
dc[sample(77, 5),6] <- NA
dc[sample(77, 4),7] <- NA
dc[sample(77, 8),8] <- NA
dc$fiber <- as.numeric(dc$fiber)
dc$carbo <- as.numeric(dc$carbo)

###
#######################
# Multiple Imputation #
#######################
###

library('tidyverse')
library('lattice')
library('mice')

### 0) data load and cleaning ###
load('cereal.RData') 

#####################
# Impute using MICE # 
#####################

### 1) look at our data and check missing data patterns
md.pattern()

### 2) run an empty imputation model to check some parameters
init <- mice(dc, maxit=0)

### 3) run imputations 
imp_dt_m <- mice(XX, maxit=50, m=5)

### 4) check out result


### 5) analyze/summarize results: predict AveragePrice from Total.Volume, Small.Bags, Large.Bags, XLarge.Bags, year



################
# FIML Example #
################

library('lavaan')
library('semPlot')


###############################
# Specify models using lavaan # 
###############################

model1 <- '
#betas
'

fit1 <- sem()
summary(fit1, fit.measures=T, standardized=F, rsquare=T)

fit1.ml <- sem(XX,
               missing="ML") # missing="ML" is the piece to add
summary(fit1.ml)


###################################
# Comparison across the 2 methods #
###################################
