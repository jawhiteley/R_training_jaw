################################################################
### Preparing an example file for the Workshop
### "A Short Introduction to Working With Data in R"
### Jonathan Whiteley            R v4.3.1            2023-09-10
################################################################
## Using the `CO2` data set included in R
## with a few modifications to illustrate 
## dplyr, tidyr, and other tidyverse functions.

################################################################
### SETUP & LOAD

## Load packages
library(dplyr)
library(tidyr)
library(stringr)

out_path <- "../data"    # relative path to output destination

## Check working directory
wd_paths <- getwd() |> strsplit("/") |> unlist()
wd_fpath <- do.call(file.path, as.list(wd_paths))
if (!("R2_data_scripting" %in% wd_paths))
  warning("The current working directory is not in the workshop files:\n  ", 
          wd_fpath)

## LOAD original data
data(CO2)




################################################################
### UN-CLEAN - apply changes (processing)

## transform data to a wider, less 'tidy' format
data_wide <- CO2 %>% 
  pivot_wider(names_from = conc, values_from = uptake)

## Introduce some inconsistent spelling into a factor
data_mod1 <- data_wide %>% 
  mutate(Type = ifelse(Type == "Quebec" & Treatment == "chilled", 
                       "Québec", 
                       as.character(Type)
                       ),
         Type = Type %>% factor(levels = sort(unique(Type))[c(2, 3, 1)])
         )

## Introduce a character value into a numeric column
data_mod2 <- data_mod1 %>% 
  mutate(
    `500` = as.character(`500`),
    `500` = case_when(
      Plant == "Qc1"    ~ paste0(`500`, " (umol/m^2 sec)"),
      Plant == "Qc3"    ~ paste0("+", `500`),
      TRUE              ~ `500`
    ),
    `675` = as.character(`675`),
    `675` = case_when(
      Plant == "Qn2"    ~ paste0(`675`, " "),  # a trailing or leading space: difficult to debug (if it is imported as such)
      TRUE              ~ `675`
    ),
    `675` = case_when(
      Type == "Québec"  ~ str_replace(`675`, "\\.", ","),  # french-formatted numbers
      TRUE              ~ `675`
    )
  )

## Duplicate a row
data_mod3 <- data_mod2 %>% 
  slice(c(1:n(), n() - 1)) %>% 
  arrange(Type, Treatment, as.character(Plant))

## derive duplicate row numbers
dup_rows <- which( duplicated(data_mod3$Plant) )
plant_dup <- data_mod3[dup_rows[1], "Plant"] %>% unlist() %>% as.character()

## Introduce some missing values (to the duplicate rows)
data_mod4 <- data_mod3 %>% 
  mutate(
    `250` = case_when(
      Plant == plant_dup & row_number() != dup_rows[1]  ~ NA_real_,
      TRUE   ~ `250`
    ),
    `1000` = case_when(
      Plant == plant_dup & row_number() == dup_rows[1]  ~ NA_real_,
      TRUE   ~ `1000`
    )
  )


## Replace 'Plant' column with ambiguous & incomplete number
##  (to re-build in exercise)

data_mod5 <- data_mod4 %>% 
  mutate(PlantNum = stringr::str_extract(Plant, "[0-9]")) %>% 
  relocate(PlantNum, .after = Treatment) %>% 
  select(-Plant)

## Replace Treatment entries with missing values, except for first appearance (Plant == 1)
##  to illustrate ?fill

data_mod <- data_mod5 %>% 
  mutate(Treatment = if_else(PlantNum == 1, Treatment, NA))



################################################################
### SAVE - export results
library(readr)

if (T) {
  ## Add extra lines (that have to be skipped) to the beginning?
  cat(
    "Data from an experiment on the cold tolerance of the grass species Echinochloa crus-galli.\n",
    "Modified from `data(CO2)`.  See `?CO2`.\n",
    file = file.path(out_path, "data_example.csv"),
    append = FALSE
  )
  ## Append data
  write_csv(data_mod, 
            file=file.path(out_path, "data_example.csv"), 
            append = TRUE,
            col_names = TRUE,
            quote = "needed", 
            na = "",
  )
}




################################################################
### TEST - load & clean

##==============================================================
## Load

test_base <- read.csv(file.path(out_path, "data_example.csv"), 
                  fileEncoding = "UTF-8", 
                  skip = 2#,
                  #na.strings = ""
                  )

test_readr <- readr::read_csv(file.path(out_path, "data_example.csv"), skip = 2)


##==============================================================
## Clean

## Use this for testing
messy <- test_base

## Clean `Type` column
test_clean <- messy %>% 
  mutate(Type = ifelse(Type == "Mississippi", Type, "Quebec"),  # In workshop, keep accent to make point about file encoding
         Type = factor(Type, levels = unique(Type))
  )
str(test_clean)

## Clean `Treatment` column
test_clean <- test_clean %>% 
  mutate(Treatment = na_if(Treatment, "")) %>%      # replace empty strings with NA
  tidyr::fill(Treatment, .direction = "down") %>%   # Fill Down to replace NAs (tidyr)
  mutate(Treatment = factor(Treatment, levels = unique(Treatment)))  # make it a factor
str(test_clean)

## The dataset is at least now able to be sorted and grouped without problems. :)

## Recover Plant ID
test_clean <- test_clean %>% 
  mutate(
    Type.tmp = str_sub(Type, 1, 1),
    Treatment.tmp = str_sub(Treatment, 1, 1)
  ) %>% 
  unite(Plant, Type.tmp, Treatment.tmp, PlantNum, sep = "") %>% 
  mutate(Plant = factor(Plant, levels = unique(Plant))) %>% 
  relocate(Plant, Type, Treatment)
str(test_clean)

## Fix `500` column & convert to numeric
test_clean <- test_clean %>% 
  mutate(
    X500 = str_split_i(X500, " ", i=1),  # drop everything after the first space
    # X500 = str_replace(X500, fixed("+"), ""),    # strip extra character (not strictly necessary)
    X500 = as.numeric(X500)
  )
str(test_clean)

## Fix `675` column & convert to numeric
test_clean <- test_clean %>% 
  mutate(X675 = str_replace(X675, ",", ".") %>% as.numeric())
str(test_clean)


## Combine duplicate rows with summarize()
## - in the workshop, explore functions like distinct() and duplicated() before doing this.
test_clean <- test_clean %>% 
  group_by(Plant, Type, Treatment) %>% 
  summarize( across(where(is.numeric), ~ max(., na.rm = TRUE)), 
             .groups = "drop"      # drop groups to avoid having to use ungroup()
  )
str(test_clean)  # now a 'tibble'


## Reshape
test_tidy <- test_clean %>% 
  pivot_longer(
    cols = where(is.numeric),    # or starts_with("X")
    names_to = "conc",
    values_to = "uptake"
  ) %>% 
  mutate(
    conc = str_replace(conc, "X", "") %>% as.numeric()
  )
str(test_tidy)

## Compare
all.equal(test_tidy, CO2, check.attributes = FALSE)

str(CO2)
str(test_tidy)

levels(CO2$Plant)
levels(test_tidy$Plant)
