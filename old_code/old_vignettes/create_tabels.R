## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup, message=FALSE, warnings=FALSE-------------------------------------
library(eurobarometer)
library(dplyr)
library(tibble)
library(knitr)
library(kableExtra)
# The examples of this vignette can be found run with  
# source(
#  file.path("not_included", "vignette_vocabulary_examples.R")
#  )

## -----------------------------------------------------------------------------
metadata_database <-  readRDS( 
  file.path('..', 'data-raw',
  'eb_metadata_database_large.rds')) 

## -----------------------------------------------------------------------------
select_metadata_vars <- c(
  "filename", "var_name_orig", "var_label_orig",
  "var_label_norm", "val_label_orig", "val_label_norm", 
  "val_numeric_orig", "val_order_alpha", "n_categories")

trust_metadata <- metadata_database  %>%
  filter (
    grepl( "trust", var_label_norm )
  )  %>%
  select ( all_of(select_metadata_vars) ) %>%
  arrange ( var_label_norm, val_label_norm, filename )

trust_metadata %>%
  head(10) %>%
  kable %>%
  kable_styling(bootstrap_options =
                  c("striped", "hover", "condensed"),
                  fixed_thead = T,
                  font_size = 10 )

## -----------------------------------------------------------------------------
trust_metadata <- trust_metadata %>% 
  filter (
    grepl( 
      "trust_in_institutions|trust_political_parties|_trust$",
      var_label_norm )
  ) %>%
  filter( ! (filename == "ZA4744_v5-0-0.sav" &
               var_name_orig %in% c("v336", "v347","v292", "v303",
                                    "v314", "v325", "v270", "v281")
             )
          )

trust_metadata %>%
  arrange(filename, var_name_orig, val_order_alpha) %>%
  head(10) %>%
  kable %>%
  kable_styling(bootstrap_options =
                  c("striped", "hover", "condensed"),
                  fixed_thead = T,
                  font_size = 10 )

## -----------------------------------------------------------------------------
trust_metadata %>%
  arrange(val_label_norm) %>%
  select(val_label_norm, everything()) %>% 
  count(n_categories) %>%
  kable %>%
  kable_styling(bootstrap_options =
                  c("striped", "hover", "condensed"),
                  fixed_thead = T,
                  font_size = 10 )

## -----------------------------------------------------------------------------
trust_metadata %>%
  filter(n_categories == 13) %>%
  kable %>%
  kable_styling(bootstrap_options =
                  c("striped", "hover", "condensed"),
                  fixed_thead = T,
                  font_size = 10 )

## -----------------------------------------------------------------------------
trust_metadata <- trust_metadata %>%
  filter( ! ( filename == "ZA3938_v1-0-1.sav" &
                var_name_orig == "v511")
          )


## ---- results='asis'----------------------------------------------------------
trust_metadata %>%
  count(val_label_norm) %>%
  kable %>%
  kable_styling(bootstrap_options =
                  c("striped", "hover", "condensed"),
                  fixed_thead = T,
                  font_size = 10 )

## -----------------------------------------------------------------------------
trust_metadata %>% 
  filter( 
    grepl("you_generally_do_not_trust", val_label_norm)
    ) %>%
  select(-var_label_norm) %>%
  kable %>%
  kable_styling(bootstrap_options =
                  c("striped", "hover", "condensed"),
                  fixed_thead = T,
                  font_size = 10 )

## -----------------------------------------------------------------------------
trust_metadata <- trust_metadata %>% 
  filter( ! ( filename == "ZA6861_v1-2-0.sav" &
                var_name_orig == "qd5.6"
              )
          )

## ---- results='asis'----------------------------------------------------------
trust_metadata %>%
  count(val_label_norm) %>%
  kable %>%
  kable_styling(bootstrap_options =
                  c("striped", "hover", "condensed"),
                  fixed_thead = T,
                  font_size = 10 )

## -----------------------------------------------------------------------------
exclusions <- trust_metadata %>%
  filter(val_label_norm %in% c("mentioned", "not_mentioned")) %>%
  print() %>%
  count(filename, var_name_orig)

## -----------------------------------------------------------------------------
trust_metadata <- trust_metadata %>%
  anti_join(
    # with a filtering join exclude all from iteration 4
    exclusions, 
    by = c("filename", "var_name_orig")
    )

## ---- results='asis'----------------------------------------------------------
trust_metadata %>%
  count(val_label_norm) %>%
  kable %>%
  kable_styling(bootstrap_options =
                  c("striped", "hover", "condensed"),
                  fixed_thead = T,
                  font_size = 10 )

## -----------------------------------------------------------------------------
val_labels_trust <- trust_metadata %>%
  count(val_label_norm)

trust_vocabulary <- tibble::tibble (
  # maybe we can use a generic controlled vocabulary, for example
  # Library of Congress
  topic_1 = 'trust institutions',
  # And if we find them, we can add GESIS or TNS/Kantar keywords here
  topic_2 = 'trust, binary',
  val_label_norm = val_labels_trust %>% pull(val_label_norm), 
  level = 3 # missingness should be harmonized in character form 
)

## ---- results='asis'----------------------------------------------------------
trust_vocabulary %>%
  kable %>%
  kable_styling(bootstrap_options =
                  c("striped", "hover", "condensed"),
                  fixed_thead = T,
                  font_size = 10 )

## -----------------------------------------------------------------------------
trust_values_table <- trust_vocabulary %>%
  mutate(character_value = case_when(
      # and create a surely harmonized character representation 
      grepl("dk|inap|na", val_label_norm) ~ NA_character_, 
      substr(val_label_norm, 1,7) == "tend_to" ~ "tend_to_trust",
      substr(val_label_norm, 1,11) ==
        "tend_not_to" ~ "tend_not_to_trust",
    TRUE ~ "ERROR"), 
    numeric_value = case_when ( 
      character_value == "tend_to_trust"     ~ 1,
      character_value == "tend_not_to_trust" ~ 0,
      TRUE ~ NA_real_),
    missing = case_when (
      # it is useful for faster filtering of missingness
      # and true value labels  
      is.na(numeric_value) ~ TRUE, 
      TRUE ~ FALSE)
  ) %>%
  arrange(numeric_value)

## ---- results='asis'----------------------------------------------------------

trust_values_table %>%
  kable %>%
  kable_styling(bootstrap_options =
                  c("striped", "hover", "condensed"),
                  fixed_thead = T,
                  font_size = 10 )

## -----------------------------------------------------------------------------
trust_variable_table <- trust_metadata %>%
  filter ( 
    val_label_norm %in% trust_values_table$val_label_norm 
    ) %>%
  filter ( ! grepl("_recoded", var_label_norm ) ) %>%
  mutate ( 
    # normalize the names of institutions
    institution = gsub(
      "trust_in_institutions_|in_|_trust|trust_|[0-9]_|^a_|^b_|^q16c_|the_", 
      "", var_label_norm ),
    institution = gsub(
      "charitable_org", "charities", institution ),
    institution = gsub(
      "europ_court_of_auditors|eur_court_of_auditors",
      "eu_court_of_auditors", institution ),
    institution = gsub(
      "europ_court_of_justice|european_court_of_justice",
      "eu_court_of_justice", institution ),
    institution = gsub(
      "justice_legal_system|justice_nat_legal_system",
      "justice", institution ),
    institution = gsub(
      "nat_parliament", "national_parliament", institution ),
    institution = gsub(
      "nat_government", "national_government", institution ),
    institution = gsub(
      "non_govmnt_org|non_govnmt_org", "ngo", institution ),
    institution = gsub(
      "polit_parties", "political_parties", institution ),
    institution = gsub(
      "reg_loc_public_authorities|reg_local_authorities|reg_local_public_authorities|rg_lc_authorities", 
      "reg_loc_authorities", institution ),
    institution = gsub(
      "written_press", "press", institution ),
    institution = gsub(
      "econ_and_social_committee|economic_and_soc_committee", 
      "econ_and_soc_committee", institution ),
  ) %>%
  mutate ( 
    ## handle exceptions from original questionnaire variants
    geo_qualifier = case_when(
      grepl("_tcc", institution) ~ "tcc", #Turkish Cypriot Community
      TRUE ~ NA_character_),
    institution = gsub("_tcc", "", institution)
  ) %>%
  mutate ( 
    ## follow exception handling for special questionnaires
    var_name_suggested = paste0(
      "trust_", institution, "_", geo_qualifier)
    ) %>%
  mutate (
    # remove _na where the no geo_qualifier is present as base case
    var_name_suggested = gsub("_NA", "", var_name_suggested),
  ) %>%
  mutate ( 
    ## add some topical keywords to our table by taste
    topic_1 = "trust institutions",
    topic_2 = "trust, binary"
    ) %>%
  select ( 
    ## remove aux variables 
    -contains("label"),
    -all_of(c("val_numeric_orig", 
              "val_order_alpha", 
              "n_categories"))
  ) %>%
  rename ( keyword_1 = institution ) %>%
  distinct_all() %>%
  mutate(var_name_suggested = ifelse(
    #one last exception to handle
    test = var_name_suggested == "trust_political_partiess_tcc",
    yes = "trust_political_parties_tcc", 
    no = var_name_suggested )
    ) %>%
  arrange(var_name_suggested)

## ---- results='asis'----------------------------------------------------------
trust_variable_table %>% 
  head(10) %>%
  kable %>%
  kable_styling(bootstrap_options =
                  c("striped", "hover", "condensed"),
                  fixed_thead = T,
                  font_size = 10 )

## -----------------------------------------------------------------------------
trust_variable_table %>%
  count(var_name_suggested) %>%
  kable %>%
  kable_styling(bootstrap_options =
                  c("striped", "hover", "condensed"),
                  fixed_thead = T,
                  font_size = 10 )

