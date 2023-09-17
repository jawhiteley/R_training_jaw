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


## ----select() by name, results='hide'-----------------------------------------
select(DF, Type, Treatment, PlantNum)
select(DF, "Type", "Treatment", "X95")
select(DF, Type:PlantNum)


## ----select() by position, results='hide'-------------------------------------
select(DF, 2:5)


## ----select() change name and order, results='hide'---------------------------
select(DF, c(Type, 4:6, Plant = PlantNum))


## ----selection helpers, results='hide'----------------------------------------
select(DF, starts_with("X"))
select(DF, !starts_with("X"))
select(DF, contains("m"))

select(DF, where(is.character) & starts_with("X"))

select(DF, any_of(c("Type", "Treatment", "95")))


## ----filter() examples, results='hide'----------------------------------------
filter(DF, X95 < 10)
filter(CO2, conc == 95, uptake < 10)
filter(CO2, conc == 95 | uptake < 10) # | == "OR" operator

filter(DF, Treatment != "")
filter(DF, !Type %in% c("Quebec", "Mississippi"))
filter(DF, !Type %in% unique(CO2$Type)) 

filter(DF, X175 > mean(X175))


## ----arrange() examples, results='hide'---------------------------------------
arrange(CO2, conc)
arrange(CO2, desc(uptake))  # sort in descending order

arrange(DF, Type, Treatment, PlantNum)
arrange(DF, PlantNum, desc(Type), Treatment)

arrange(DF, X95 %% 2) 
arrange(DF, length(Type), X95 + X175)

## sort by all character columns
arrange(DF, across(where(is.character)) )  


## ----select() & filter()------------------------------------------------------
select( filter(DF, Treatment == "chilled"), 
        where(is.numeric)
)


## ----filter() %>% select()----------------------------------------------------
DF %>% filter(Treatment == "chilled") %>% 
  select(where(is.numeric))


## ----find char cols-----------------------------------------------------------
cols_charn <- DF %>% 
  select(starts_with("X") & where(is.character)) %>% 
  names()


## ----find non-numeric values in char cols-------------------------------------
for (col in cols_charn) {
  DF %>% select(1:3, all_of(col)) %>% 
    filter( get(col) %>% as.numeric() %>% is.na() %>% 
              suppressWarnings() ) %>% 
    print()
}


## ----user-defined function, echo=-(1:2)---------------------------------------
# http://www.cookbook-r.com/Manipulating_data/Comparing_vectors_or_factors_with_NA/
# https://github.com/jawhiteley/R-lib/blob/master/functions/compare-na.R
'%==%' <- function (v1, v2) {
  same <- (v1 == v2) | (is.na(v1) & is.na(v2))
  same[is.na(same)] <- FALSE
  return(same)                 # return the result
}

# test it:
c(1, NA, 3, 4 , NaN) %==% c(1, NA, 1, NA, NaN)
c(1, NA, 3, 4 , NaN)  ==  c(1, NA, 1, NA, NaN)


## ----infix operator-----------------------------------------------------------
c(1, NA, 3, 4 , NaN) %==% c(1, NA, 1, NA, NaN)


## ----mutate() add columns, results='hide'-------------------------------------
DF %>% mutate(
  Trt_n = Treatment %>% nchar(),
  Xsum = X95 + X175
  )


## ----mutate() modify columns, results='hide'----------------------------------
DF %>% mutate(X95 = X95 / mean(X95))


## ----lag-lead, results='hide'-------------------------------------------------
DF %>% mutate(
  Plant_lag  =  lag(PlantNum),
  Plant_lead = lead(PlantNum, n=2)
)


## ----row_number(), results='hide'---------------------------------------------
DF %>% mutate(
  Plant_row = PlantNum < row_number()
)


## ----case_when(), results='hide'----------------------------------------------
DF %>% mutate(
  Type_ab = case_when(
    Type == "Quebec"      ~ "QC",
    Type == "Mississippi" ~ "MS",
    .default = as.character(Type)
  )
)


## ----clean `Type` column------------------------------------------------------
DF_clean1_type <- DF %>% 
  mutate(
    Type = if_else(Type == "Mississippi", Type, "Quebec")
  )


## ----clean `Type` column with case_when(), results='hide'---------------------
DF %>% 
  mutate(
    Type = case_when(
      Type == "Québec"  ~ "Quebec",
      .default = Type
    )
  )


## ----load stringr package-----------------------------------------------------
library(stringr)
# help(package="stringr")
# vignette("stringr")


## ----clean `X675` column------------------------------------------------------
DF_clean2_675 <- DF_clean1_type %>% 
  mutate(
    # Replace "," with "."
    X675 = str_replace(X675, ",", "."),
    # convert to numeric
    X675 = as.numeric(X675)
  )


## ----clean `X500` column------------------------------------------------------
DF_clean3_500 <- DF_clean2_675 %>% 
  mutate(
    # drop everything after the first space:
    X500 = str_split_i(X500, " ", i=1),
    # convert to numeric
    X500 = as.numeric(X500)
  )


## ----clean `Treatment` column-------------------------------------------------
DF_clean4_cols <- DF_clean3_500 %>% 
  # replace empty strings with NA
  mutate(Treatment = na_if(Treatment, "")) %>%  
  # Fill Down to replace NAs (tidyr)
  tidyr::fill(Treatment, .direction = "down")   


## ----group_by, results='hide'-------------------------------------------------
DF %>% group_by(Type, PlantNum)  # no visible change


## ----group_by + verbs, results='hide'-----------------------------------------
DF %>% group_by(Type, PlantNum) %>% 
  filter(row_number() == 1)
DF %>% group_by(Type, PlantNum) %>% 
  arrange(Type, PlantNum) %>% 
  mutate(Norm95 = X95 / mean(X95))


## ----grouping columns are excluded from operations, results='hide'------------
DF %>% group_by(Type, PlantNum) %>% 
  select(starts_with("X"))


## ----summarise ungrouped------------------------------------------------------
DF_clean4_cols %>% summarise(n(), mean(X95))


## ----summarise grouped, results='hide'----------------------------------------
DF_clean4_cols %>% group_by(Type, PlantNum) %>% 
  summarise(n = n(), sum(X95))


## ----summarise() multiple columns with across()-------------------------------
DF_clean4_cols %>% 
  summarise( across(where(is.numeric), max) )
DF_clean4_cols %>% group_by(Treatment) %>% 
  summarise( across(starts_with("X"), max) )


## ----summarise() across() with ad hoc function--------------------------------
DF_clean4_cols %>% 
  summarise(
    across(where(is.numeric), 
           function(x) max(x, na.rm = TRUE)
    )
  )


## ----summarise() across() with lambda-----------------------------------------
DF_clean4_cols %>% 
  summarise( across(everything(), ~ sum(is.na(.x))) )


## ----count rows on each group-------------------------------------------------
DF_clean4_cols %>%
  group_by(Type, Treatment, PlantNum) %>% 
  summarise(n = n(), .groups = "drop") %>% 
  filter(n > 1)


## ----look at duplicate rows---------------------------------------------------
DF_duprows <- DF_clean4_cols %>%
  group_by(Type, Treatment, PlantNum) %>% 
  filter(n() > 1)
DF_duprows %>%
  mutate(across(everything(), ~ near(.x, max(.x, na.rm = TRUE)) ))


## ----collapse duplicate rows--------------------------------------------------
DF_clean5_rows <- DF_clean4_cols %>%
  group_by(Type, Treatment, PlantNum) %>% 
  summarise(
    across(where(is.numeric), ~ max(.x, na.rm = TRUE)),
    .groups = "drop"
  ) %>% 
  ## Re-sort to original order
  arrange(desc(Type), desc(Treatment), PlantNum)


## ----load tidyr---------------------------------------------------------------
library(tidyr)


## ----unique values of `Plant` in CO2------------------------------------------
CO2 %>% pull(Plant) %>% unique() %>% as.character()


## ----temporary columns, results='hide'----------------------------------------
DF_clean5_rows %>% select(Type, Treatment) %>% 
  ## Create columns with the first letter of each row
  mutate(
    Type.tmp      = str_sub(Type, 1, 1),
    Treatment.tmp = str_sub(Treatment, 1, 1),
  )


## ----unite() columns----------------------------------------------------------
DF_clean <- DF_clean5_rows %>% 
  ## Create columns with the first letter of each row
  mutate(
    Type.tmp      = str_sub(Type, 1, 1),
    Treatment.tmp = str_sub(Treatment, 1, 1)
  ) %>% 
  ## Combine columns, and remove them
  unite(
    Plant,                             # new column name
    Type.tmp, Treatment.tmp, PlantNum, # input columns
    sep = ""      # characters to separate each input
  ) %>% 
  ## Move columns to the front (left)
  relocate(Plant, Type, Treatment)


## ----example data is wide-----------------------------------------------------
DF_clean %>% select(where(is.numeric)) %>% names()


## ----pivot longer-------------------------------------------------------------
DF_tidy <- DF_clean %>% 
  pivot_longer(
    cols = where(is.numeric),  # columns to pivot
    names_to = "conc",         # name of new column with old column names
    values_to = "uptake"       # name of new column with old values
  ) %>% 
  ## Clean former column names and convert to numeric
  mutate(
    conc = str_replace(conc, "X", "") %>% as.numeric()
  )


## ----check results------------------------------------------------------------
all.equal(DF_tidy, CO2, check.attributes = FALSE)


## ----convert character columns to factors-------------------------------------
DF_final <- DF_tidy %>% 
  mutate( across(where(is.character), factor) )


## -----------------------------------------------------------------------------
DF_final <- DF_tidy %>% 
  mutate(
    across( where(is.character), ~ factor(.x, levels = unique(.x)) )
  )


## ----check final results------------------------------------------------------
all.equal(DF_final, CO2, check.attributes = FALSE)


## ----write_csv----------------------------------------------------------------
write_csv(DF_final, "data/data_clean.csv")
write_excel_csv(DF_final, "data/data_excel.csv")


## ----test write, message=FALSE, results='hide'--------------------------------
save_test <- read_csv("data/data_clean.csv")
head(save_test)

