# exonerations
The Effects of Eyewitness Identification Reform on Wrongful Convictions
The abstract of the paper for which this file was written is the following:

  In the United States, the investigation and prosecution of crimes are centered on eyewitness identifications,
 which are often inaccurate. This paper attempts to extract the causal effect of identification reform policies on the
 mitigation of wrongful convictions resulting from mistaken witness identifications. In this study, a linear regression
 model that controls for state and year fixed effects is unable to extract a significant correlation between policy reform
 and reduction of injustices. Furthermore, this research provides a robust event study of all proven mistaken witness
 identifications since 1989, attesting to the importance of reform.
  
The dataset used for this project contains individual-level data on all known exonerations in the
United States from 1989 to 2020, excluding those where the State of conviction is unknown (6
individuals). An exoneration is defined as a case in which a person was wrongly convicted of
a crime and later cleared of all charges based on new evidence of innocence. The data was
downloaded from the National Registry of Exonerations and includes information regarding the
status of relevant policies in a given state in each year.
The outcome variable used for this analysis, mwid, is a binary variable equal to 1 if the exoneree
was a victim of a mistaken witness identification, and 0 otherwise. Other key variables of interest
were (1) ineffect, a binary variable equal to 1 if eyewitness identification reform was in effect in the
state of trial at the time of conviction, and 0 otherwise, and (2) trend, equal to the number of years
post-reform in the given state that a conviction occured. For this trend variable, 1 represents a
conviction occurring 1 year post reform, -1 represents a conviction occuring 1 year prior to reform,
and exoneeres with NA in this field were convicted in states that are still without policy reform.

The first section of the R file extracts the demographic qualities of the exonerees. 
The second section constructs two linear regressions. The first is a simple regression controlling for state and time fixed effects, and the second incorporates a covariate trend variable that accounts for changes over time. 
The third and final section of the file constructs 3 event study graphs which track the number of exonerations involving witness misidentifications according to year in reference to year of reform of the state of conviction. 

The file is commented at each step of the process. 
