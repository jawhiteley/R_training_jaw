################################################################
### Activity: compare `read.csv` and `read_csv` from `readr`
### "A Short Introduction to Working With Data in R"
### R v4.3.1
################################################################
## Set your working directory to the _parent directory_
## of where this file is

# Libraries ---------------------------------------------------------------

library(readr)


# LOAD data ---------------------------------------------------------------

DF_path <- file.path("data", "data_example.csv")

DF_base  <- read.csv(DF_path, skip = 2, encoding = "UTF-8")
DF_readr <- read_csv(DF_path, skip = 2)

class(DF_base)
class(DF_readr)

str(DF_base)
str(DF_readr)

## Add more commands to explore the loaded datasets
## And comments to explain your approach and document your findings
