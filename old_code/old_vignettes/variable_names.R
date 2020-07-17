## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup, message=FALSE, warnings=FALSE-------------------------------------
library(eurobarometer)
library(knitr)
library(kableExtra)
library(dplyr)

## -----------------------------------------------------------------------------
data("categorical_variables_2", package = "eurobarometer")

categorical_variables_2 %>%
  kable() %>%
  kable_styling(bootstrap_options = 
                  c("striped", "hover", "condensed"), 
                  fixed_thead = T, 
                  font_size = 10 ) %>%
    add_header_above(c("Filtering" = 3, 
                       "Preferred Term" = 1, 
                       "Keywords" = 2)
                     )

