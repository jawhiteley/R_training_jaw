params <-
list(is_virtual = TRUE)

## ----install_tidyverse, eval=FALSE--------------------------------------------
## install.packages("tidyverse")




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


## ----data.frame---------------------------------------------------------------
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


## ----plot_basic---------------------------------------------------------------
plot(DF)

