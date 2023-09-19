################################################################
### Activity: Define a function to check example data
### "A Short Introduction to Working With Data in R"
### R vx.x.x
################################################################

# Define a function -------------------------------------------------------

check_my_data <- function (data, reference) {

  if (! (is.data.frame(data) && is.data.frame(reference)) ) {
    stop("'check_my_data()' requires two data.frames to compare.")
  }

  comp <- all.equal(data, reference, check.attributes = FALSE)

  if ( isTRUE(comp) ) {
    message("SUCCESS!  Cleaned data values match reference.")
  } else {
    warning("OOPS!  Cleaned data values *do not* match reference.")
    print(comp)

    ## Add code to check for known problems here, 
    ## with message()s or warning()s to provide more information
    ##
  }

  ## return a result (invisibly)
  invisible( return(comp) )
}


# Test the function -------------------------------------------------------


if (F) { # do not run when source()d
  ## test
  data(CO2)

  test_df <- 
    mutate(CO2,
           Type = ifelse(
             Type == "Quebec" & Treatment == "chilled", 
             "QC", 
             as.character(Type)
           )
    )

  check_my_data(test_df, CO2)
}
