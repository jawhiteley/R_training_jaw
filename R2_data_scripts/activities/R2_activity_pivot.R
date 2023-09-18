################################################################
### Activity: working with strings using the `stringr` package
### "A Short Introduction to Working With Data in R"
### R v4.3.1
################################################################
# Libraries ---------------------------------------------------------------

library(tidyr)
library(dplyr)
library(sringr)

# LOAD data ---------------------------------------------------------------

data(CO2)


# Analysis ----------------------------------------------------------------

## 1. Recreate the example data we loaded in the workshop:
##    - pivot the 'conc' column to become column names, 
##      with 'uptake' as values


## 2. With the original CO2 dataset, stack the 'conc' and 'uptake' columns 
##    into a single 'variable' column, with all values in a 'value' column
##    (using pivot_longer() --- this is *not* tidy)


## 3. With the original CO2 dataset, try pivoting it wider
##    so that combinations of 'Type' and 'Treatment' are columns
##    with 'conc' as rows, and 'uptake' as values;
##    you will have to extract the number from the 'Plant' column
##    (using mutate() and maybe a `stringr function`)
##    - Save the result as `CO2_wider`


## 4. Try returning CO2_wider to the original layout
##    (i.e., pivot_longer() )


