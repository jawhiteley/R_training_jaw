params <-
list(is_virtual = TRUE)

## ----Housekeeping, include = FALSE--------------------------------------------
################################################################
### A Short Introduction to Working With Data in R
### All code from workshop slides (automatically generated)
### Jonathan Whiteley           R v4.3.1              2023-09-18
################################################################
## Housekeeping: clear memory
if (F) # do not run when source()d
  rm(list = ls())


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
CSV_path <- file.path("data", "data_example.csv")
file.exists(CSV_path)


## ----load with read_csv (1st try), results='hide', message=FALSE, warning=TRUE----
library(readr)
try( read_csv(CSV_path) )


## ----readlines----------------------------------------------------------------
readLines(CSV_path, n = 4)


## ----load with read_csv-------------------------------------------------------
CSV <- read_csv(CSV_path, skip = 2)


## ----data.frame---------------------------------------------------------------
class(CSV)
typeof(CSV)






## ----head---------------------------------------------------------------------
head(CSV)


## ----dims---------------------------------------------------------------------
dim(CSV)
nrow(CSV)
ncol(CSV)


## ----colnames-----------------------------------------------------------------
names(CSV)
colnames(CSV)
rownames(CSV)


## -----------------------------------------------------------------------------
CSV[["Treatment"]]
unique(CSV$Type)


## ----str, results='hide', purl=TRUE-------------------------------------------
str(CSV)



## ----summary------------------------------------------------------------------
summary(CSV)


## ----plot_basic---------------------------------------------------------------
plot(CSV)


## ----load internal CO2 data---------------------------------------------------
data(CO2)




## ----read a csv encoded in "latin1", message=FALSE, results='hide'------------
CSV_latin1 <- read_csv("data/data_example_latin1.csv")
CSV_latin1




## ----read_csv() with encoding, results='hide', message=FALSE------------------
read_csv(CSV_path, skip = 2, 
         locale = locale(encoding = "latin1")
)


## ----names with backticks, results='hide'-------------------------------------
CSV[, "95"]  # still a `data.frame` (with 1 column)
CSV[["95"]]  # vector
CSV$`95`     # quoted name


## ----read_csv() name_repair universal, results='hide', message=FALSE----------
read_csv(
  CSV_path, skip = 2, 
  name_repair = "universal" # make names unique and syntactic
)


## ----read_csv() name_repair make.names, results='hide', message=FALSE---------
read_csv(
  CSV_path, skip = 2, 
  name_repair = make.names  # function: same as read.csv()
)  


## ----read_csv() guess examples, results = 'hide', message=FALSE---------------
# use the first 2 rows to guess column types (less successful)
  read_csv(CSV_path, skip = 2, guess_max = 2)
# use *all* rows to guess column types
# - slow: has to read *every row* twice.
  read_csv(CSV_path, skip = 2, guess_max = Inf)


## ----read_csv() column spec, results = 'hide', message=FALSE, warning=FALSE----
## Specify column types with a compact string
read_csv(CSV_path, skip = 2, col_types = "cccddddddd")

## Or use a `column specification`
# extract specification from tibble
col_spec <- spec(CSV)
# change a column to numeric (double)
col_spec$cols[["500"]] <- col_double()
read_csv(CSV_path, skip = 2, col_types = col_spec)

# ?read_csv for more options


## ----read_csv() all columns as character--------------------------------------
# read all columns as character
read_csv(CSV_path, skip = 2, 
         col_types = cols(.default = col_character())
         )


## ----read_csv() na argument, message=FALSE, warning=FALSE---------------------
read_csv(CSV_path, skip = 2, 
         na = c(".", "NA")  # will not replace empty strings ("") with NA
         )


## ----read_csv() grouping_mark, message=FALSE, warning=FALSE-------------------
CSV_comma <- read_csv(CSV_path, skip = 2, 
         locale = locale(grouping_mark = "")
)
CSV_comma[["675"]]


## ----read_csv() version to work with, message=FALSE---------------------------
DF <- read_csv(
  CSV_path, skip = 2, 
  name_repair = make.names
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

select(DF, any_of(c("Type", "Treatment", "Plant", "95")))


## ----filter() examples, results='hide'----------------------------------------
filter(DF, X95 < 10)
filter(CO2, conc == 95, uptake < 10)  # "AND"
filter(CO2, conc == 95 | uptake < 10) # | == "OR" operator

filter(DF, Treatment != "")
filter(DF, !Type %in% c("Quebec", "Mississippi"))
filter(DF, !Type %in% unique(CO2$Type)) 

filter(DF, X175 > mean(X175))


## ----select() & filter()------------------------------------------------------
select( filter(DF, Treatment == "chilled"), 
        where(is.numeric)
)


## ----filter() %>% select()----------------------------------------------------
DF %>% filter(Treatment == "chilled") %>% 
  select(where(is.numeric))


## ----Find characters where numeric expected-----------------------------------
# specify columns by pattern 
# (in this case, all numeric columns start with "X")
DF %>% 
  select(where(is.character) & starts_with("X")) %>% names()
# specify a range of known columns
DF %>% 
  select(where(is.character) & X95:X1000) %>% names()


## ----Find non-numeric values in character column------------------------------
DF_nonum <- 
  DF %>% select(1:3, X500) %>% 
  filter(!is.na(X500) &       # exclude existing NAs
           X500 %>%           
           as.numeric() %>%   # non-numeric -> NA + warning
           is.na() %>%        # check for new NAs
           suppressWarnings() # suppress expected warnings
  )
DF_nonum


## ----Find numeric values outside expected range-------------------------------
DF_extreme_nums <- 
  DF %>% select(1:3, X675) %>% 
  filter(X675 > 100)
DF_extreme_nums


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


## ----load stringr package-----------------------------------------------------
library(stringr)
# help(package="stringr")
# vignette("stringr")


## ----Find non-numeric values in `675` column, echo = FALSE--------------------
CSV_comma %>% select(1:3, "675") %>% 
  filter(!is.na(`675`) & `675` %>%
           as.numeric() %>%
           is.na() %>%
           suppressWarnings()
  ) %>% pull("675")


## ----clean `675` column (character), results='hide'---------------------------
CSV_comma %>% select(1:3, "675") %>% 
  mutate(
    # Replace "," with "."
    `675` = str_replace(`675`, ",", "."),
    # convert to numeric
    `675` = as.numeric(`675`)
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


## ----clean `X500` column------------------------------------------------------
DF_clean2_500 <- DF_clean1_type %>% 
  mutate(
    # drop everything after the first space:
    X500 = word(X500, 1),
    # convert to numeric
    X500 = as.numeric(X500)
  )




## ----clean `X675` column------------------------------------------------------
DF_clean3_675 <- DF_clean2_500 %>% 
  mutate(
    X675 = if_else(X675 > 100, X675 / 10, X675)
  )


## ----unique values of the Treatment column------------------------------------
DF %>% distinct(Treatment) %>% pull()


## ----clean `Treatment` column-------------------------------------------------
DF_clean4_trt <- DF_clean3_675 %>% 
  # replace empty strings with NA (if present)
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


## ----grouping columns are excluded from operations, results='hide', message=FALSE----
DF %>% group_by(Type, PlantNum) %>% 
  select(starts_with("X"))


## ----summarise ungrouped------------------------------------------------------
DF_clean4_trt %>% summarise(n(), mean(X95))


## ----summarise grouped, results='hide'----------------------------------------
DF_clean4_trt %>% group_by(Type, PlantNum) %>% 
  summarise(n = n(), sum(X95))


## ----count rows on each group-------------------------------------------------
DF_clean4_trt %>%
  group_by(Type, Treatment, PlantNum) %>% 
  summarise(n = n(), .groups = "drop") %>% 
  filter(n > 1)


## ----look at duplicate rows---------------------------------------------------
DF_duprows <- DF_clean4_trt %>%
  group_by(Type, Treatment, PlantNum) %>% 
  filter(n() > 1)
DF_duprows


## ----load tidyr---------------------------------------------------------------
library(tidyr)


## ----unique values of `Plant` in CO2------------------------------------------
CO2 %>% pull(Plant) %>% unique() %>% as.character()


## ----temporary columns, results='hide'----------------------------------------
DF_clean4_trt %>% select(Type, Treatment) %>% 
  ## Create columns with the first letter of each row
  mutate(
    Type.tmp      = str_sub(Type, 1, 1),
    Treatment.tmp = str_sub(Treatment, 1, 1),
  )


## ----unite() columns----------------------------------------------------------
DF_clean5_cols <- DF_clean4_trt %>% 
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
DF_clean5_cols %>% select(where(is.numeric)) %>% names()


## ----pivot longer-------------------------------------------------------------
DF_tidy <- DF_clean5_cols %>% 
  pivot_longer(
    cols = where(is.numeric),  # columns to pivot
    names_to = "conc",         # name of new column with old column names
    values_to = "uptake"       # name of new column with old values
  ) %>% 
  ## Clean former column names and convert to numeric
  mutate(
    conc = str_replace(conc, "X", "") %>% as.numeric()
  )


## ----Duplicate values of `uptake`, message=FALSE------------------------------
DF_tidy %>% 
  group_by(Plant, Type, Treatment, conc) %>% 
  summarise(n = n()) %>% 
  filter(n > 1)


## ----Confirm that all duplicate values are "near" the max & min---------------
DF_tidy %>% 
  group_by(Plant, conc) %>% 
  summarise(
    n = n(), 
    min_max = min(uptake, na.rm = TRUE) %>% 
              near(max(uptake, na.rm = TRUE)),
    .groups = "drop"
  ) %>% 
  filter(!min_max) %>% nrow()


## ----collapse duplicate rows--------------------------------------------------
DF_clean <- 
  DF_tidy %>% 
  group_by(Plant, Type, Treatment, conc) %>% 
  summarise(
    uptake = max(uptake, na.rm = TRUE), 
    .groups = "drop"
  ) %>% 
  arrange(desc(Type), desc(Treatment), Plant, conc)


## ----check results------------------------------------------------------------
all.equal(DF_clean, CO2, check.attributes = FALSE)


## ----convert character columns to factors-------------------------------------
DF_final <- DF_clean %>% 
  mutate(
    Plant     = factor(Plant, levels = unique(Plant)),
    Type      = factor(Type,  levels = unique(Type)),
    Treatment = factor(Treatment, levels = unique(Treatment))
  )


## ----convert *all* character columns to factors, results='hide'---------------
DF_clean %>% 
  mutate( across(where(is.character), factor) )




## ----check final results------------------------------------------------------
all.equal(DF_final, CO2, check.attributes = FALSE)


## ----write_csv----------------------------------------------------------------
write_csv(DF_final, "data/data_clean.csv")
write_excel_csv(DF_final, "data/data_excel.csv")


## ----test write, message=FALSE, results='hide'--------------------------------
save_test <- read_csv("data/data_clean.csv")
head(save_test)




## ----bind_rows() stack data vertically, results='hide'------------------------
DF_bindr <- bind_rows(DF_duprows, DF_clean5_cols)
head(DF_bindr)

# can also use it on a _list of data frames_
bind_rows(list(DF_duprows, DF_duprows))


## ----bind_cols() stack data horizontally, message=FALSE, results='hide'-------
bind_cols(tibble(new = 1:nrow(DF_duprows)), DF_duprows)

DF_bindc <- bind_cols(DF_final, DF_clean)
head(DF_bindc)

# can also use it on a _list of data frames_
bind_cols(list("..", DF_duprows))

