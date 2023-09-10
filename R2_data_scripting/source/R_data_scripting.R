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


## ----read_csv-----------------------------------------------------------------
library(readr)
DF_readr <- read_csv(DF_path, skip = 2)


## ----tibble examples----------------------------------------------------------
print(DF_readr, n=2)
is.null(DF$Treat)
is.null(DF_readr$Treat)


## ----readxl demo--------------------------------------------------------------
library(readxl)    # load the package
## Documentation: ?read_excel  help(package="readxl")
## use an example included in the package
xl_path <- readxl_example("datasets.xlsx")
excel_sheets(xl_path)  # get the names of the sheets
## read a specified sheet from the Excel file
iris_xl <- read_excel(xl_path, "iris")

