################################################################
### Activity: Using mutate() with conditional expressions
### "A Short Introduction to Working With Data in R"
### R v4.3.1
################################################################
# Libraries ---------------------------------------------------------------

library(dplyr)

# LOAD data ---------------------------------------------------------------

data(iris)


# Analysis ----------------------------------------------------------------

## 1. Make a new object where values of Sepal.Length 
## more than 2 standard deviations from the mean are replaced with NA


## 2. Make a new object with the Species "virginica" and "versicolor" swapped


## 3. Make a new object with a column named "fizzbuzz" that contains:
## - the word "fizz" whenever the Petal.Length is greater than 3
## - the word "buzz" whenever the Petal.Length is greater than 5
## - the word "fizzbuzz" whenever the Petal.Length is greater than 6
## - The integer value of Petal.Length otherwise
## - you may need to use functions like ?floor, ?'%%', and ?as.character



## 4. Make a new object with:
## - a column (mean_dist) that contains the distance of Sepal.Width from the mean
## - another column that contains: 
##    - "*" in rows that are more than 1 standard deviation away
##    - "**" in rows that are more than 2 standard deviations away
##    - "." otherwise
