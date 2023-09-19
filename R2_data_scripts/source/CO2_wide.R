## Make a wide version of `CO2` before the pivot section,
## but hide it from workshop participants,
## to avoid giving away one of the activity solutions

CO2_wide <- CO2 %>% 
  tidyr::pivot_wider(names_from = conc, values_from = uptake)
