################################################################
### Activity: Practice using mutate()
### "A Short Introduction to Working With Data in R"
### R v4.3.1
################################################################
# Libraries ---------------------------------------------------------------

library(dplyr)

# LOAD data ---------------------------------------------------------------

data(iris)


# Analysis ----------------------------------------------------------------

## 1. Make a new table named "iris_ratio", with columns that contain the Length-to-Width ratio
##    for Petals and Sepals


## 2. Make a new table named "iris_norm", with a normalized Petal.Length column
##    (i.e., subtract the mean of the entire column from each value, 
##           then divide by the standard deviation)

## 3. Make a new table with the word "Iris" added in front of the Species names
##    Tip: try the paste() function.

## 4. Make a new table that contains only the first 3 rows of each species

