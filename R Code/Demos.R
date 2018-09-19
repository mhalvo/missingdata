##############################
# Missing Data Workshop      #
#   for UW Graduate Students #
##############################
# Max Halvorson #
#  9/20/18      #
#################

library('tidyverse')
rm(list=ls())
set.seed(1337)
setwd('C:/Users/Max/Dropbox/Missing Data Workshop/R Code')

alc <- data.frame(drinks=c(0,3,NA,4,2,NA,1,NA,0,4,NA,0),
             drinks_m=c(0,3,1.75,4,2,1.75,1,1.75,0,4,1.75,0),
             drinks_s=c(0,3,2,4,2,2,1,2,0,4,2,0),
             drinks_z=c(0,3,0,4,2,0,1,0,0,4,0,0),
             drinks_l=c(0,3,1,4,2,3,1,2,0,4,0,0))

(p0 <- ggplot(data=alc) +
  geom_histogram(aes(x=drinks), fill="black") + 
  geom_histogram(aes(x=drinks_m), fill="purple") + 
  geom_histogram(aes(x=drinks_s), fill="blue") + 
  geom_histogram(aes(x=drinks_z), fill="light blue") +
  geom_histogram(aes(x=drinks_l), fill="white"))

alc$exams <- round(alc$drinks/.3 + rnorm(12,0,1) + 2,0)
alc$exams[c(3,6,8,11)] <- c(2,6,9,1)

alc$drinks_simp <- alc$drinks
B <- coef(lm(alc$drinks ~ alc$exams))
alc$drinks_simp[c(3,6,8,11)] <- B[1] + B[2]*alc$exams[c(3,6,8,11)]

psych::describe(alc)

(p1 <- ggplot(aes(x=exams), data=alc) + 
  geom_point(aes(y=drinks_m), color="purple", size=11) + 
  geom_point(aes(y=drinks_s), color="blue", size=9) + 
  geom_point(aes(y=drinks_z), color="light blue", size=7) + 
  geom_point(aes(y=drinks_l), color="white", size=5) + 
  geom_point(aes(y=drinks), color="black", size=13) + 
  ylim(0,5) + 
  ylab("drinks"))


(p2 <- p1 + 
    geom_hline(aes(yintercept=1.75), color="purple") + 
    geom_hline(aes(yintercept=2), color="blue") + 
    geom_hline(aes(yintercept=0), color="light blue"))
        
(p2 + 
    geom_smooth(aes(y=drinks), method=lm, color="black", se=F))

(ggplot(aes(x=exams), data=alc) +
    geom_point(aes(y=drinks_simp), color="orange", size=11) +
    geom_point(aes(y=drinks), color="black", size=13) +
    geom_smooth(aes(y=drinks), method=lm, color="black", se=F) + 
    ylim(0,5) + 
    ylab("drinks")) 


(ggplot(aes(x=exams), data=alc) +
    geom_point(aes(y=drinks), color="black", size=13) +
    geom_smooth(aes(y=drinks), method=lm, color="black", se=F) + 
    geom_abline(intercept=-.50, slope=.25) + 
    geom_abline(intercept=-.40, slope=.25) + 
    geom_abline(intercept=-.50, slope=.3) + 
    geom_abline(intercept=-.45, slope=.35) + 
    ylim(0,5) + 
    ylab("drinks"))
