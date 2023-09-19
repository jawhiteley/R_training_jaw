################################################################
### Activity: summarize() data with 'dplyr'
### "A Short Introduction to Working With Data in R"
### R v4.3.1
################################################################
# Libraries ---------------------------------------------------------------

library(dplyr)

# LOAD data ---------------------------------------------------------------

data(CO2)
## Run a short external script to create a 'CO2_wide' object
source("source/CO2_wide.R")
exists("CO2_wide")  # check if it worked: should be TRUE


# Activity ----------------------------------------------------------------
## For each activity, try answering each question with _both_
## 'CO2' and 'CO2_wide' objects.


## What is the mean 'uptake' value for each combination 
##    of Type and Treatment?


## Which concentration level ('conc') has the widest spread 
##    (variance or standard deviation)?


## Which Plant _number_ has highest value of 'uptake'
## in each location ('Type')?

