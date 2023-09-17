################################################################
### Preparing an example file for the Workshop
### "A Short Introduction to Working With Data in R"
### Jonathan Whiteley            R v4.3.1            2023-09-10
################################################################
## Using the `CO2` data set included in R
## with a few modifications to illustrate 
## dplyr, tidyr, and other tidyverse functions.

## This script file should be encoded in UTF-8.
## Ensure your editor (e.g., RStudio) 
## is configured to read it correctly
## https://stackoverflow.com/questions/67591683/configure-r-to-use-utf-8-by-default

################################################################
### SETUP & LOAD

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
  mutate(Treatment = if_else(PlantNum == 1, Treatment, as.factor(NA_character_)))



################################################################
### SAVE - export results
library(readr)

if (T) {
  ## Add extra lines (that have to be skipped) to the beginning
  ## see ?writeLines and ?cat
  extra_lines <- c(
    "Data from an experiment on the cold tolerance of the grass species Echinochloa crus-galli.",
    "Modified from `data(CO2)`.  See `?CO2`."
  )
  Encoding(extra_lines) <- "UTF-8"    # ensure encoding?
  cat(
    extra_lines,
    sep = "\n",
    file = file.path(out_path, "data_example.csv"),
    append = FALSE
  )
  ## Append data - readr uses UTF-8 encoding by default
  write_csv(data_mod, 
            file=file.path(out_path, "data_example.csv"), 
            append = TRUE,
            col_names = TRUE,
            quote = "needed", 
            na = "",
  )
  
  ## Version with BOM (Byte-Order Mark) and no leading lines
  ## ?file
  ## https://stackoverflow.com/a/41408091
  writeChar(iconv("\ufeff", to = "UTF-8"), 
            file.path(out_path, "data_example_bom.csv"), 
            eos = NULL
  )
  write_csv(data_mod, 
            file=file.path(out_path, "data_example_bom.csv"), 
            append = TRUE,
            col_names = TRUE,
            quote = "needed", 
            na = "",
  )
}




################################################################
### TEST - load & clean
## See 'clean_example_data.R' to see the solution

##==============================================================
## Load

test_base <- read.csv(
  file.path(out_path, "data_example.csv"), 
  encoding = "UTF-8", 
  skip = 2#,
  #na.strings = ""
)

test_readr <- readr::read_csv(
  file.path(out_path, "data_example.csv"), 
  skip = 2
  )

##==============================================================
## Load BOM version
## https://stackoverflow.com/questions/39593637/dealing-with-byte-order-mark-bom-in-r
## https://github.com/ropensci-archive/gtfsr/issues/19#issuecomment-247766324
## https://github.com/tidyverse/readr/issues/263
## https://github.com/tidyverse/readr/issues/500
## https://stackoverflow.com/questions/18789330/r-on-windows-character-encoding-hell

bom_base_fail <- read.csv(
  file.path(out_path, "data_example_bom.csv"), 
  encoding = "UTF-8"  # BOM is included in name of first column
  # fileEncoding = "UTF-8-BOM"    # triggers an Error :(
)

bom_base <- read.csv(
  file.path(out_path, "data_example_bom.csv"), 
  fileEncoding = "UTF-8-BOM"
)

## recent (> 2016, v0.2.2.9000) versions of readr automatically skip the BOM
bom_readr <- readr::read_csv( file.path(out_path, "data_example_bom.csv") )