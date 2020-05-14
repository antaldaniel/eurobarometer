library(dplyr)
library(stringr)

nuts_2_matching <- function (x) {
  x <- tolower (x)
  x <- gsub ("prov.", "", x)
  x <- gsub( "\\(", "[", x)
  x <- gsub( "\\)", "]", x)
  x <- ifelse ( grepl( "brussels hoofdstedelijk", x),
                yes = "région de bruxelles-capitale / brussels hoofdstedelijk gewest",
                no= x)
  x <- gsub("vlaams brabant", "vlaams-brabant", x)
  x <- gsub("li\u0232ge", "liege",  x)
  x <- gsub ( "oesterreich", "österreich", x)
  x <- gsub ( "kaernten", "kärnten", x )
  x <- stringr::str_trim ( x, side = "both")
  x
}

## remove empty  -------------------------------------------------

make_explicit_na <- function(x) dplyr::case_when (
  x =="" ~  NA_character_,
  x =="NA" ~  NA_character_,
  TRUE ~ x
  )


## NUTS2010 and NUTS2013 regions ---------------------------------

nuts_2013_raw <- read.csv("data-raw/NUTS 2010 - NUTS 2013.csv",
                          skip = 1,
                          encoding = "UTF-8")%>%
  select ( 1:12) %>%
  mutate_if ( is.factor, as.character ) %>%
  purrr::set_names(.,
                   c("row", "code2010", "code2013", "country",
                     "nuts1", "nuts2", "nuts3", "change", "nuts_level",
                     "countries", "sorting_order_2010", "sorting_order_2013"
                   )) %>%
  select( row, code2010, code2013, nuts2, nuts3 ) %>%
  mutate_at ( .vars = c("nuts2", "nuts3",
                        "code2010", "code2013"), make_explicit_na )



nuts1013 <- nuts_2013_raw  %>%
  filter ( !is.na(nuts2) ) %>%
  mutate ( nuts_2_name = nuts_2_matching(nuts2)) %>%
  mutate ( country_code = stringr::str_sub(code2010, 1, 2)) %>%
  mutate ( country_code = case_when (
    country_code == "EL" ~ "GR",
    country_code == "UK" ~ "GB",
    TRUE ~  country_code)) %>%
  mutate_at ( c("nuts2", "nuts3"), make_explicit_na )


vocabulary_nuts2 <- readxl::read_excel("data-raw/code_regions2.xlsx",
                                       sheet = "NUTS2") %>%
  select ( country_code, region_nuts_names, code2010 ) %>%
  mutate_all ( as.character )  %>%
  mutate_all ( make_explicit_na ) %>%
  left_join ( nuts1013, by = c("code2010", "country_code")) %>%
  dplyr::rename ( code10 = code2010,
                  code13 = code2013) %>%
  select ( country_code, region_nuts_names, code10, code13) %>%
  mutate ( regon_nuts_names = ifelse ( region_nuts_names == "NA",
                    NA_character_,
                    region_nuts_names )) %>%
  #mutate ( code2013 = as.character(code2013)) %>%
  filter ( !is.na(country_code)) %>%
  #mutate ( code2013 = ifelse ( code2010 == "UKN0", code2010, code2013)) %>%
  mutate ( region_nuts_names = ifelse ( test = code10 == "UKN0",
                                        yes  = "Northern Ireland",
                                        no   = region_nuts_names))  %>%
  select ( country_code, region_nuts_names, code10, code13 )

vocabulary_nuts1 <- readxl::read_excel("data-raw/code_regions2.xlsx",
                                       sheet = "NUTS1") %>%
  dplyr::rename ( code10 = code2010,
                  code13 = code2013) %>%
  select ( country_code, region_nuts_names, code10, code13 ) %>%
  mutate_all ( as.character )


usethis::use_data(vocabulary_nuts1, overwrite = TRUE)

usethis::use_data(vocabulary_nuts2, overwrite = TRUE)


imputation <- readxl::read_excel("data-raw/NUTS2_2010_imputation.xlsx") %>%
  purrr::set_names(.,c("country_code", "row", "code2010", "code2013", "region_nuts_codes",
                       "nuts1", "nuts2", "nuts3", "change", "nuts_level",
                       "countries", "sorting_order_2010",
                       "sorting_order_2013"
  ) ) %>%
  filter ( !is.na(nuts2))

nuts2_imputation <- readxl::read_excel("data-raw/NUTS2_2010_imputation.xlsx") %>%
  purrr::set_names(.,c("country_code", "row", "code2010", "code2013",
                       "region_nuts_codes",
                       "nuts1", "nuts2", "nuts3", "change", "nuts_level",
                       "countries", "sorting_order_2010", "sorting_order_2013"
  ) ) %>%  dplyr::rename ( code10 = code2010,
                           code13 = code2013,
                           region_nuts_names = region_nuts_codes ) %>%
  filter ( !is.na(nuts2)) %>%
  select ( country_code, region_nuts_names, code10, code13)

usethis::use_data(nuts2_imputation, overwrite = TRUE)

