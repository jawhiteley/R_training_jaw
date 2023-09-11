################################################################
### Clean the example file for the Workshop
### "A Short Introduction to Working With Data in R"
### Jonathan Whiteley            R v4.3.1            2023-09-10
################################################################
## Testing the cleaning plan,
## and building a reference for the workshop materials

################################################################
### SETUP

## Housekeeping
rm(list=ls())

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

## Generate example data set, if necessary
if (!file.exists(file.path(out_path, "data_example.csv"))) {
  source("make_example_data.R")
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
test_clean1_type <- messy %>% 
  mutate(Type = ifelse(Type == "Mississippi", Type, "Quebec"),  # In workshop, keep accent to make point about file encoding?
         Type = factor(Type, levels = unique(Type))
  )
str(test_clean1_type)

## Clean `Treatment` column
test_clean2_trt <- test_clean1_type %>% 
  mutate(Treatment = na_if(Treatment, "")) %>%      # replace empty strings with NA
  tidyr::fill(Treatment, .direction = "down") %>%   # Fill Down to replace NAs (tidyr)
  mutate(Treatment = factor(Treatment, levels = unique(Treatment)))  # make it a factor
str(test_clean2_trt)

## The dataset is at least now able to be sorted and grouped without problems. :)

## Recover Plant ID - needs `Treatment` to be fixed first
test_clean3_plant <- test_clean2_trt %>% 
  mutate(
    Type.tmp = str_sub(Type, 1, 1),
    Treatment.tmp = str_sub(Treatment, 1, 1)
  ) %>% 
  unite(Plant, Type.tmp, Treatment.tmp, PlantNum, sep = "") %>% 
  mutate(Plant = factor(Plant, levels = unique(Plant))) %>% 
  relocate(Plant, Type, Treatment)
str(test_clean3_plant)

## Fix `500` column & convert to numeric - could be done earlier
test_clean4_uptake <- test_clean3_plant %>% 
  mutate(
    X500 = str_split_i(X500, " ", i=1),  # drop everything after the first space
    # X500 = str_replace(X500, fixed("+"), ""),    # strip extra character (not strictly necessary)
    X500 = as.numeric(X500)
  )
str(test_clean3_plant)

## Fix `675` column & convert to numeric - could be done earlier
test_clean5_uptake <- test_clean4_uptake %>% 
  mutate(X675 = str_replace(X675, ",", ".") %>% as.numeric())
str(test_clean5_uptake)


## Combine duplicate rows with summarize() - needs `Treatment` to be fixed first
## - in the workshop, explore functions like distinct() and duplicated() before doing this.
test_clean <- test_clean5_uptake %>% 
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

##==============================================================
## Compare
all.equal(test_tidy, CO2, check.attributes = FALSE)

str(CO2)
str(test_tidy)

levels(CO2$Plant)
levels(test_tidy$Plant)
