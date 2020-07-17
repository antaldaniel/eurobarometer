## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  message = FALSE,
  warning = FALSE, 
  eval=FALSE,
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
#  library(eurobarometer)
#  library(dplyr)
#  library(tibble)
#  library(knitr)
#  library(kableExtra)
#  # The examples of this vignette can be found run with
#  # source(
#  #  file.path("not_included", "vignette_vocabulary_examples.R")
#  #  )

## -----------------------------------------------------------------------------
#  metadata_database <- readRDS(
#    file.path("..", "data-raw", "eb_metadata_database.rds")
#    )

## -----------------------------------------------------------------------------
#  select_metadata_vars <- c("filename", "var_name_orig",
#                            "var_label_norm",
#                            "var_name_suggested",
#                            "val_label_norm" , "val_label_orig",
#                            "val_order_alpha", "val_order_length")
#  
#  trust_metadata <- metadata_database  %>%
#    filter (
#      grepl( "tend_to_trust|tend_not_to_trust", val_label_norm )
#    )  %>%
#    select ( all_of(select_metadata_vars)) %>%
#    arrange ( var_label_norm, val_label_norm, filename )

## -----------------------------------------------------------------------------
#  require(kableExtra)
#  trust_metadata %>% filter (
#     grepl( "tend_to_trust", val_label_norm )
#    ) %>%
#    sample_n(15) %>% # Print only a sample of 15 rows
#  kable() %>%
#    kable_styling(bootstrap_options =
#                  c("striped", "hover", "condensed"),
#                  fixed_thead = T,
#                  font_size = 7)

## -----------------------------------------------------------------------------
#  trust_metadata %>%
#    select (
#      # previously we filtered tend to (not) agree, remove it
#      -all_of(c("val_label_norm", "val_label_orig"))
#      ) %>%
#    left_join (
#      # add back all value labels, i.e. various declines
#      metadata_database %>%
#                  select ( all_of(select_metadata_vars))
#      )  %>%
#    sample_n(15) %>% # Print only a sample of 15 rows
#  kable() %>%
#    kable_styling(bootstrap_options =
#                  c("striped", "hover", "condensed"),
#                  fixed_thead = T,
#                  font_size = 9)

## ---- results='asis'----------------------------------------------------------
#  trust_with_decline  <- metadata_database %>%
#    select ( all_of(select_metadata_vars) ) %>%
#    semi_join ( trust_metadata %>%
#                  select ( all_of(c("filename", "var_name_orig"))),
#                by = c("filename", "var_name_orig"))
#  
#  trust_var_labels <- trust_with_decline %>%
#    select ( all_of(c("val_label_orig", "val_label_norm",
#                      "val_order_alpha", "val_order_length"))) %>%
#    distinct_all () %>%
#    arrange ( val_label_norm, val_label_orig, val_order_length)
#  
#  trust_var_labels %>%
#  kable() %>%
#    kable_styling(bootstrap_options =
#                  c("striped", "hover", "condensed"),
#                  fixed_thead = T,
#                  font_size = 9 )

## -----------------------------------------------------------------------------
#  trust_2_with_decline  <- trust_with_decline %>%
#    filter ( val_order_length <= 4)
#  
#  trust_2_value_labels <- trust_2_with_decline %>%
#    select ( all_of(c("val_label_orig", "val_label_norm",
#                      "val_order_alpha", "val_order_length"))
#             ) %>%
#    distinct_all () %>%
#    arrange ( val_label_norm, val_label_orig, val_order_length)
#  
#  trust_2_value_labels %>%
#  kable() %>%
#    kable_styling(bootstrap_options =
#                  c("striped", "hover", "condensed"),
#                  fixed_thead = T,
#                  font_size = 10 )
#  

## -----------------------------------------------------------------------------
#  trust_vocabulary <- tibble::tibble (
#    # maybe we can use a generic controlled vocabulary, for example
#    # Library of Congress
#    topic_1 = 'trust',
#    # And if we find them, we can add GESIS or TNS/Kantar keywords here
#    topic_2 = 'trust, binary',
#    val_label_norm = trust_2_value_labels %>%
#      filter (
#        grepl("tend_to|tend_not_to|inap|dk", val_label_norm)) %>%
#      distinct ( val_label_norm ) %>%
#      unlist () %>%
#      as.character(),
#    level = 3 # missingness should be harmonized in character form
#  )
#  
#  trust_table <- trust_vocabulary %>%
#    mutate(
#      character_value = case_when(
#        # and create a surely harmonized character representation
#        grepl("dk|inap", val_label_norm) ~ NA_character_,
#        substr(val_label_norm, 1,7) == "tend_to" ~ "tend_to_trust",
#      TRUE ~ "tend_not_to_trust"),
#      numeric_value = case_when (
#        character_value == "tend_to" ~ 1,
#        character_value == "tend_not_to" ~ 0,
#        TRUE ~ NA_real_),
#      missing = case_when (
#        # it is useful for faster filtering of missingness
#        # and true value labels
#        is.na(numeric_value) ~ TRUE,
#        TRUE ~ FALSE)
#    )
#  
#  trust_table %>%
#    kable %>%
#    kable_styling(bootstrap_options =
#                    c("striped", "hover", "condensed"),
#                    fixed_thead = T,
#                    font_size = 10 ) %>%
#      add_header_above(c("Keywords" = 2,
#                         "Label Identification" = 2,
#                         "Value Harmonization" = 3))

## -----------------------------------------------------------------------------
#  saveRDS(trust_table, file.path(
#    "..",   # we're in vignettes
#    "data-raw", "trust_value_labels.rds"),
#    version = 2 # downward compatibility on CRAN
#    )

## -----------------------------------------------------------------------------
#  trust_variable_table <- trust_with_decline %>%
#    filter ( val_label_norm %in% trust_table$val_label_norm ) %>%
#    filter ( ! grepl("_recoded", var_label_norm ) ) %>%
#    distinct ( val_label_norm, .keep_all = TRUE ) %>%
#    mutate ( institution =      gsub("trust_in_institutions_|trust_in_|_trust", "",
#                                     var_label_norm )) %>%
#    mutate ( geo_qualifier = case_when(
#      grepl("_tcc", institution) ~ "tcc",
#      TRUE ~ NA_character_),
#      institution = gsub("_tcc", "", institution)
#    ) %>%
#    mutate ( var_name_suggested = paste0("trust_in_",
#                                      institution, "_",
#                                      geo_qualifier) ) %>%
#    mutate ( var_name_suggested = gsub("_NA", "", var_name_suggested)) %>%
#    select ( filename, var_name_orig, var_label_norm, var_name_suggested, institution, geo_qualifier) %>%
#    rename ( keyword_1 = institution )
#  
#  trust_variable_table %>%
#    kable %>%
#    kable_styling(bootstrap_options =
#                    c("striped", "hover", "condensed"),
#                    fixed_thead = T,
#                    font_size = 10 ) %>%
#      add_header_above(c("Filtering" = 3,
#                         "Preferred Term" = 1,
#                         "Keywords" = 2)
#                       )

## -----------------------------------------------------------------------------
#  saveRDS(trust_variable_table, file.path(
#    "..",   # we're in vignettes
#    "data-raw", "trust_variables.rds"),
#    version = 2 # downward compatibility on CRAN
#    )

