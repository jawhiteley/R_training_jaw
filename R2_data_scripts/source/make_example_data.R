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
if (!("R2_data_scripts" %in% wd_paths))
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
    ## Something else in `350`?
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
      Type == "Québec"  ~ str_replace(`675`, "\\.", ","),  # french-formatted numbers; read_csv reads these as grouping marks, resulting in numbers x10
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
  ## ?write_excel_csv 
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
  
  ## Version in latin1 encoding
  write.csv(data_mod, 
            file=file.path(out_path, "data_example_latin1.csv"), 
            row.names = FALSE,
            fileEncoding = "latin1"
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

test_latin1_readr <- readr::read_csv(
  file.path(out_path, "data_example_latin1.csv")#,
  #locale = locale(encoding = "UTF-8")
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




################################################################
### Prepare final activity

data(who)
data(population)

countries2 <- c("CA", "US", "GB", "AU", "NZ")

## who data
data_activity <- 
  who %>% 
  filter(iso2 %in% countries2) %>% 
  group_by(country) %>% 
  mutate(
    year = if_else(iso2 == "US", year %% 100, year),  # 2-digit year
    new_sp_m1524 = new_sp_m1524 %>% 
      as.character() %>% 
      replace_na(".."),
    new_sn_m014 = new_sn_m014 %>% 
      as.character() %>% 
      replace_na("."),
    new_sp_f65 = new_sp_f65 %>% 
      as.character() %>% 
      if_else(iso2 == "CA" & (year %in% c(1988, 1995, 2007, 2008)) & !is.na(new_sp_f65), 
              paste0(., " F"), # "F", "E" with no space is still read in as numeric by read_csv!
              .
      ),
    country = if_else(iso2 == "CA" & (year %% 4 == 0), "Canäda", country),
  )

## Population data
data_pop <- population %>% 
  filter(country %in% unique(data_activity$country)) %>% 
  # left_join(who %>% distinct(country, iso2), by = "country") %>% 
  # relocate(country, iso2) %>% 
  mutate(
    country = if_else(country == "Canada" & (year %% 4 == 0), "Canäda", country),
  )



##==============================================================
## Split & export into separate files
for (d in countries2) {
  data_activity %>% 
    filter(iso2 == d) %>% 
    write_csv( file.path(out_path, "activity", paste0("tb_", unique(.$iso3), ".csv")) )
}

## Export population table
data_pop %>% 
  write.csv(file.path(out_path, "activity", "population.csv"),
            fileEncoding = "latin1"
  )


##==============================================================
## Quick test

tb_files <- list.files(file.path(out_path, "activity"), "tb_")

test_tb <- read_csv(file.path(out_path, "activity", "tb_CAN.csv"))

test_pop <- read_csv( file.path(out_path, "activity", "population.csv") )


## target analysis
whotb <- who %>% 
  filter(iso2 %in% countries2) %>% 
  pivot_longer(where(is.numeric) & !year, names_to = "trt", values_to = "cases") %>% 
  group_by(country, year) %>% 
  summarise(cases = sum(cases, na.rm = TRUE))

whotb_pop <- whotb %>% 
  left_join(population, by = c("country", "year")) %>% 
  mutate(
    rate = (cases / population) #%>% if_else(is.na(.), 0, .)
  )

## country with highest all-time rate
whotb_pop %>% 
  group_by(country) %>% 
  summarise(max = max(rate, na.rm = TRUE))

## what year was it in?
whotb_pop %>% 
  group_by(country) %>% 
  filter(rate == max(rate, na.rm = TRUE))

## Which country has had the lowest average rate since 2006 (including that year)?
whotb_pop %>% 
  group_by(country) %>% 
  filter(year >= 2006) %>% 
  summarise(avg_rate = mean(rate, na.rm = TRUE))

## Which country has had the highest & lowest _growth rate_ in cases since 2006 (including that year)?
whotb_pop %>% 
  group_by(country) %>% 
  filter(year >= 2006) %>% 
  mutate(
    growth = cases / lag(cases) -1
  ) %>% 
  summarise(avg_growth = mean(growth, na.rm = TRUE))

## Why 2006?  Sudden jump in that year ...

## Are cases monotonically increasing or decreasing in any country? NO
whotb_pop %>% 
  group_by(country) %>% 
  filter(year >= 2006) %>% 
  summarise(
    incr = (cases >= lag(cases)) %>% all(),
    decr = (cases <= lag(cases)) %>% all()
  )
