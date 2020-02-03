# eurobarometer

<!-- badges: start -->
<!-- badges: end -->

The goal of eurobarometer is to ...

## Installation

You can not yet install the released version of eurobarometer from [CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("eurobarometer")
```

## Reading in an SPSS file from GESIS

First of all, we create a representation of the GESIS archive SPSS file that can be programatically used in R.  One problem is that SPSS variable names may contain reserved characters. For further programmatic use in R, the best is to rename the variables.

``` r 
library(eurobarometer)
gesis_spss_read ( path = file.path('data-raw', 'example.sav'), 
                  rename = TRUE, 
                  unique_id = TRUE)
```

This setting the function calls `canonical_file_rename()` which removes spaces and special characters, and converts all variable names to lowercase. Similarly, by default the serial
identifiers of observations (rows) in the SPSS file are brought to the harmonized name `unique_id`. This ID is unique in the single survey data file, but not if you create panel trend files. 

If you are planning to work in R with certain files, it makes sense to save the result of this function as an R data object with `save()` or `saveRDS()` somewhere. Conversion from SPSS is a rather resource-intensive operation.
