################################################################
### Activity: read a messy Excel file
### "A Short Introduction to Working With Data in R"
### R v4.3.1
################################################################
## No need to change your working directory for this one
## --- we'll use an example that comes with the `readxl` package

# Libraries ---------------------------------------------------------------

library(readxl)


# LOAD data ---------------------------------------------------------------

XL_path <- readxl_example("deaths.xlsx")
XL_sheets <- excel_sheets(XL_path)

## Basic version: doesn't quite work
XL <- read_excel(XL_path, sheet = XL_sheets[1])

## Modify the read_excel command with other arguments to get a better result
# ?read_excel for arguments and options

