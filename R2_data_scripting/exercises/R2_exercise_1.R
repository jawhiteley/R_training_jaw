################################################################
### Exercise 1: Load & explore a dataset
### "A Short Introduction to Working With Data in R"
### R v4.3.1
################################################################

## Set your working directory to the _parent directory_
## of where this file is

DF_path <- file.path("data", "data_example.csv")
file.exists(DF_path)

DF <- read.csv(DF_path, skip = 2)

colnames(DF)
plot(DF)

## Add more functions to explore the loaded dataset
## And comments to explain your approach and document your findings