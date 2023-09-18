################################################################
### Activity 1-2: Load & explore a dataset
### "A Short Introduction to Working With Data in R"
### R v4.3.1
################################################################

## Set your working directory to the _parent directory_
## of where this file is

CSV_path <- file.path("data", "data_example.csv")
file.exists(CSV_path)

CSV <- read.csv(CSV_path, skip = 2, encoding = "UTF-8")

colnames(CSV)
plot(CSV)

## Add more functions to explore the loaded dataset
## And comments to explain your approach and document your findings
