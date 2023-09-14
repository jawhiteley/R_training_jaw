params <-
list(is_virtual = TRUE)

## ----install_tidyverse, eval=FALSE--------------------------------------------
## install.packages("tidyverse")




## ----2.get_working_dir, results='hide'----------------------------------------
getwd()


## ----setwd, eval=FALSE, echo=FALSE, results='hide', include=FALSE-------------
## Before running the commands in this file,
## set your working directory (*in the console*)
## to the folder that *contains* the 'data' folder
## (i.e., the workshop folder, as it appears on the web site.)
## 
## setwd("path/to/the/folder")
## if (.Platform$OS.type == "windows") {
##   setwd( choose.dir() )
## }


## ----check_wd-----------------------------------------------------------------
DF_path <- file.path("data", "data_example.csv")
file.exists(DF_path)


## ----load1, echo=FALSE--------------------------------------------------------
try( read.csv(DF_path) )


## ----readlines----------------------------------------------------------------
readLines(DF_path, n = 4)


## ----load---------------------------------------------------------------------
DF <- read.csv(DF_path, skip = 2)


## ----3.data.frame-------------------------------------------------------------
class(DF)
typeof(DF)


## ----head---------------------------------------------------------------------
head(DF)


## ----dims---------------------------------------------------------------------
dim(DF)
nrow(DF)
ncol(DF)


## ----colnames-----------------------------------------------------------------
names(DF)
colnames(DF)
rownames(DF)


## -----------------------------------------------------------------------------
DF[, "Treatment"]
unique(DF$Type)


## ----str----------------------------------------------------------------------
str(DF)


## ----summary------------------------------------------------------------------
summary(DF)


## ----plot_basic---------------------------------------------------------------
plot(DF)




## ----read.csv() with encoding-------------------------------------------------
DF <- read.csv(DF_path, skip = 2, encoding = "UTF-8")


## ----read_csv-----------------------------------------------------------------
library(readr)
DF_readr <- read_csv(DF_path, skip = 2)


## ----tibble examples----------------------------------------------------------
print(DF_readr, n=2)
is.null(DF$Treat)
is.null(DF_readr$Treat)


## ----names with backticks, results='hide'-------------------------------------
DF_readr[, "95"]  # still a `data.frame` (with 1 column)
DF_readr[["95"]]  # vector
DF_readr$`95`     # quoted name


## ----read_csv() name_repair, results='hide', message=FALSE--------------------
read_csv(
  DF_path, skip = 2, 
  name_repair = "universal" # make names unique and syntactic
)

read_csv(
  DF_path, skip = 2, 
  name_repair = make.names  # a function: same as read.csv()
)  


## ----read_csv() guess examples, results = 'hide', message=FALSE---------------
# use the first 2 rows to guess column types (less successful)
  read_csv(DF_path, skip = 2, guess_max = 2)
# use *all* rows to guess column types
# - slow: has to read *every row* twice.
  read_csv(DF_path, skip = 2, guess_max = Inf)


## ----read_csv() column spec, results = 'hide', message=FALSE, warning=FALSE----
## Specify column types with a compact string
read_csv(DF_path, skip = 2, col_types = "cccddddddd")

## Or use a `column specification`
# extract specification from tibble
col_spec <- spec(DF_readr)
# change a column to numeric (double)
col_spec$cols[["500"]] <- col_double()
read_csv(DF_path, skip = 2, col_types = col_spec)

# ?read_csv for more options


## ----read_csv() all columns as character--------------------------------------
# read all columns as character
read_csv(DF_path, skip = 2, 
         col_types = cols(.default = col_character())
         )


## ----read_csv() na argument, message=FALSE, warning=FALSE---------------------
read_csv(DF_path, skip = 2, 
         na = c(".", "NA")  # will not replace empty strings ("") with NA
         )


## ----readxl demo--------------------------------------------------------------
library(readxl)    # load the package
## Documentation: ?read_excel  help(package="readxl")
## use an example included in the package
xl_path <- readxl_example("datasets.xlsx")
excel_sheets(xl_path)  # get the names of the sheets
## read a specified sheet from the Excel file
iris_xl <- read_excel(xl_path, "iris")


## ----load dplyr---------------------------------------------------------------
library(dplyr)


## ----masking, eval=FALSE------------------------------------------------------
## ?filter  # more than one result!


## ----package::object notation, eval=FALSE-------------------------------------
## ?filter  # more than one result
## ?dplyr::filter
## ?stats::filter


## ----filter() examples--------------------------------------------------------
filter(DF, X95 < 10)
filter(CO2, conc == 95 & uptake < 10)
filter(DF, Treatment != "")
filter(DF, !Type %in% c("Quebec", "Mississippi"))
filter(DF, !Type %in% levels(CO2$Type))


## ----user-defined function, echo=-(1:2)---------------------------------------
# http://www.cookbook-r.com/Manipulating_data/Comparing_vectors_or_factors_with_NA/
# https://github.com/jawhiteley/R-lib/blob/master/functions/compare-na.R
`%==%` <- function (v1, v2) {
  same <- (v1 == v2) | (is.na(v1) & is.na(v2))
  same[is.na(same)] <- FALSE
  return(same)
}

# test it:
c(1, NA, 3, 4 , NaN) %==%
c(1, NA, 1, NA, NaN)


## ----write_csv, eval=FALSE----------------------------------------------------
## write_csv(DF_tidy, "data/data_clean.csv")
## write_excel_csv(DF_tidy, "data/data_excel.csv")


## ----test write, eval=FALSE---------------------------------------------------
## save_test <- read_csv("data/data_clean.csv")
## save_test

