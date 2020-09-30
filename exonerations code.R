#import exonerations dataset
exonerations <- read.csv("~/junior/14.33/short paper/exonerations.csv")

#RESTRICT DATASET TO RELEVANT DATA****************************************************
#remove entries that are not associated with a state
#set all missing entries to NA
state_exonerations <- read.csv("~/junior/14.33/short paper/exonerations.csv", 
                               header=T, na.strings=c(""," ","NA"))

#drop entries where state entry is NA
state_exonerations <- state_exonerations[!is.na(state_exonerations$state),]


#DESCRIPTIVE ANALYSIS*****************************************************************
#obtain descriptive statistics for table 1
#subset for those where mistaken witness id exists and those where it does not
yesmwid <- state_exonerations[which(state_exonerations$mwid==1),]
nomwid <- state_exonerations[which(state_exonerations$mwid==0),]

#breakdown by sex
sum(yesmwid$sex=='Female')
sum(yesmwid$sex=='Male')
sum(nomwid$sex=='Female')
sum(nomwid$sex=='Male')

#breakdown by race
sum(yesmwid$race=='White')
sum(yesmwid$race=='Black')
sum(yesmwid$race=='Hispanic')
sum(yesmwid$race=='Native American')
sum(yesmwid$race=='Other')
sum(yesmwid$race == 'Asian')
nomwidwhite <- nomwid[which(nomwid$race=='White'),]
nomwidasian <- nomwid[which(nomwid$race=='Asian'),]
nomwidblack <- nomwid[which(nomwid$race=='Black'),]
nomwidhispanic <- nomwid[which(nomwid$race=='Hispanic'),]
nomwidnative <- nomwid[which(nomwid$race=='Native American'),]
nomwidother <- nomwid[which(nomwid$race=='Other'),]

#subset for where official misconduct exists and where it does not
yesom <- state_exonerations[which(state_exonerations$om==1),]
noom <- state_exonerations[which(state_exonerations$om==0),]

#breakdown by sex
sum(yesom$sex=='Female')
sum(yesom$sex=='Male')
sum(noom$sex=='Female')
sum(noom$sex=='Male')

#breakdown by race
sum(yesom$race=='White')
sum(yesom$race=='Black')
sum(yesom$race=='Hispanic')
sum(yesom$race=='Native American')
sum(yesom$race=='Other')
sum(yesom$race == 'Asian')
noomwhite <- noom[which(noom$race=='White'),]
noomasian <- noom[which(noom$race=='Asian'),]
noomblack <- noom[which(noom$race=='Black'),]
noomhispanic <- noom[which(noom$race=='Hispanic'),]
noomnative <- noom[which(noom$race=='Native American'),]
noomother <- noom[which(noom$race=='Other'),]


#CAUSAL ANALYSIS**********************************************************************
#installing packages
install.packages("AER")
install.packages("dynlm")
library(AER)
library(dynlm)
library(forecast)
library(readxl)
library(stargazer)
library(scales)
library(quantmod)
library(urca)
install.packages("plm")
library(plm)

#constructing a variable that accounts for trends -- calculates the number of years since policy implentation, 
#where 1 = 1 year since policy change#
state_exonerations$trend <- c(0)
state_exonerations$trend <- c(as.numeric(state_exonerations$convicted) 
                              - as.numeric(state_exonerations$date_witnessreform))

#drop observations for states where no reform policy ever made
state_exonerations <- state_exonerations[!is.na(state_exonerations$trend),]


#binary variable representing if the reform is in effect in the year of conviction
state_exonerations$ineffect <- c(0)
state_exonerations$ineffect[state_exonerations$convicted >= 
                              state_exonerations$date_witnessreform] <- c(1)  


#running the basic regression to construct a linear regression 
install.packages("lfe")
library(lfe)

#fitting basic linear model with fixed group effects, with standard errors clustered at the state level
reg1 <- felm(formula = mwid ~ ineffect | convicted + state| 0 | 
               state, data=state_exonerations)
reg1
summary(reg1)
  

#fitting the linear model, controlling for occurrences of mwid that would have occured
#regardless of the policy reform, with standard errors clustered at the state level
reg2 <- felm(formula = mwid ~ ineffect + trend*state | convicted + state | 0 |
    state, data = state_exonerations)
summary(reg2)

#DISPLAYING RESULTS******************************************************************
#create event study graph
#sum amount of cases with mwid = 1 in each year 
freqmwid <- as.data.frame(table(state_exonerations$mwid, state_exonerations$trend))
subfreqmwid <- freqmwid[freqmwid$Var1 == 1,]
plot(subfreqmwid$Var2, subfreqmwid$Freq, main = "Number of Exonerations involving Mistaken
    Witness Identification", xlab = "Years Post Policy Reform", ylab = "# Cases")
#add line at convictions in year of policy reform
abline(v= 54, col="cyan3")
#add line marking 2 years following policy reform
abline(v=56, col="deepskyblue4")


#normalize mwid = 1 as a percent of total cases 
#sum total number of cases per trend year
normfreq <- as.data.frame(table(state_exonerations$trend))
#add ratio of mwid = 1: mwid = 0 as column to frquency dataframe
subfreqmwid$ratio <- c((as.numeric(subfreqmwid$Freq) 
                              / as.numeric(normfreq$Freq))*100)
plot(subfreqmwid$Var2, subfreqmwid$ratio, main = "% Exonerations involving Mistaken
    Witness Identification", xlab = "Years Post Policy Reform", ylab = "% Cases")
#add line at convictions in year of policy reform
abline(v= 54, col="coral")
#add line marking 2 years following policy reform
abline(v=56, col = "darkorange3")


#exclude years with a single data point 
subnormfreq <- normfreq[normfreq$Freq > 1,]
sub2freqmid <- subfreqmwid[as.numeric(subfreqmwid$Freq) >= 2,]
plot(sub2freqmid$Var2, sub2freqmid$ratio, main = "% Exonerations involving Mistaken
    Witness Identification", xlab = "Years Post Policy Reform", ylab = "% Cases")
#add line at convictions in year of policy reform
abline(v= 54, col="purple")
#add line marking 2 years following policy reform
abline(v=56, col = "deeppink3")