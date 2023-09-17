################################################################
### Title
### Project or description
### Author Name           R vX.X.X              YYYY-MM-DD
################################################################
## Description, change history, etc.

################################################################
### SETUP

## Housekeeping: clear memory
rm(list = ls())

## Libraries
library(tidyverse)


##==============================================================
## Parameters (aka "macro variables")
## include changing any options (global or package-specific)

ref_period   <- "2023"  # Change to current reference period
path_base    <- "/"     # or use relative paths
save_outputs <- FALSE   # Change to TRUE to save outputs

### You shouldn't have to change anything below
### this section to re-use the script
### e.g., for a new reference period 
###       or switching environments (by changing base_path)




################################################################
### LOAD Data

## Load ALL data in one place.
## If there is an issue, you will know sooner.
## And it's easier to manage paths for all related input.




################################################################
### CLEAN & Process Data

## It might make sense to clean each dataset as it is loaded
## but it is usually easier to separate these tasks,
## and makes it easier to work on multiple datasets at once




################################################################
### DO Analysis or Processing

## Use comments to explain your steps and code
## Include references or links, for easy reference



##==============================================================
## Subsection (level 2)


##--------------------------------------------------------------
## Sub-sub-section (level 3)




################################################################
### SAVE Outputs & Results

if (save_outputs) {

}
