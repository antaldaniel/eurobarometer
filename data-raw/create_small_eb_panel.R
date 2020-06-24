library(tidyverse)
source('R/utils.R')
source (file.path("data-raw", "create_trust_tables.R"))
source(file.path("not_included", "daniel_env.R")) ##loads Daniel's local gesis directory

selected_files <- sort ( unique ( trust_metadata$filename),
                         decreasing = T)

selected_files <- c("ZA5913_v2-0-0.sav",
                    "ZA7576_v1-0-0.sav",
                    "ZA6863_v1-0-0.sav")

selected_trust_vars <- trust_metadata %>%
  filter ( filename %in% selected_files ) %>%
  select (
    all_of(c("filename", "var_name_orig", "var_label_norm"))
    ) %>%
  distinct_all()

id_vars <- metadata_database %>%
  select (
    all_of(c("filename", "var_name_orig", "var_name_suggested"))
  ) %>%
  filter (
    filename %in% selected_files
  ) %>%
  filter (
    grepl( 'gesis_archive', var_name_suggested) |
    var_name_suggested %in% c("uniqid", "doi")
  ) %>%
  distinct_all()


demography_var_name_orig <- c("d7", "d7r2", "d8", "d8r2",
                              "d15a",  "d15a_r2", "d25", 'd60')

demography_vars <- metadata_database %>%
  select (
    all_of(c("filename", "var_name_orig", "var_name_suggested"))
  ) %>%
  filter (
    filename %in% selected_files
  ) %>%
  filter (
    substr( var_name_orig, 1,3) %in% demography_var_name_orig ) %>%
  distinct_all()

#p7, p13 should be one

weight_vars <- metadata_database %>%
  select (
    all_of(c("filename", "var_name_orig", "var_name_suggested"))
    ) %>%
  filter (
    filename %in% selected_files
  ) %>%
  filter (
    var_name_orig %in% c("w1", "w3", "wex")) %>%
  distinct_all()


metadata_var_names_orig <- c("p1", "p2", "p3", "p4", "p5",
                             "isocntry", "doi", "v713", "nuts")

metadata_vars <- metadata_database %>%
  select (
    all_of(c("filename", "var_name_orig", "var_name_suggested"))
  ) %>%
  filter (
    filename %in% selected_files
  ) %>%
  filter (
    var_name_orig %in% metadata_var_names_orig ) %>%
  distinct_all()


other_vars <- metadata_database %>%
  select (
    all_of(c("filename", "var_name_orig", "var_name_suggested"))
  ) %>%
  filter (
    filename %in% selected_files
  ) %>%
  filter ( grepl( "voters_|important_values_pers|vaccine_info_source",
                  var_name_suggested )) %>%
  distinct_all()

subsetting_vars <- id_vars %>%
  full_join ( metadata_vars ) %>%
  full_join ( demography_vars ) %>%
  full_join ( selected_trust_vars ) %>%
  full_join ( other_vars ) %>%
  full_join ( weight_vars ) %>%
  select ( all_of(c("filename", "var_name_orig")))

selected_files <- c("ZA5913_v2-0-0.sav",
                    "ZA7576_v1-0-0.sav",
                    "ZA6863_v1-0-0.sav")

selected_files <- c("ZA5913_v2-0-0.sav",
                    "ZA7576_v1-0-0.sav",
                    "ZA6863_v1-0-0.sav")


my_spss_files <- file.path(gesis_dir, selected_files)

read <- read_surveys  ( my_spss_files, .f= 'read_spss_survey')
read <- read_surveys  ( my_spss_files, .f= 'read_spss_survey')

ZA5913_sample <- read[[1]]
ZA6863_sample <- read[[3]]
ZA7576_sample <- read[[2]]

ZA5913_sample  <- ZA5913_sample [, subsetting_vars %>%
                                   filter ( filename == "ZA5913_v2-0-0.sav") %>%
                                   select (var_name_orig)  %>%
                                   unlist() %>% as.character()
                                 ]

ZA5913_sample <- ZA5913_sample [ ZA5913_sample$isocntry %in% c("PL", "HU",
                                                               "DE-E", "DE-W",
                                                               "MK", "CY", "CY-TCC",
                                                               "GB"),]


ZA6863_sample  <- ZA6863_sample [, subsetting_vars %>%
                                 filter ( filename == "ZA6863_v1-0-0.sav") %>%
                                 select (var_name_orig)  %>%
                                 unlist() %>% as.character()
                               ]

ZA6863_sample <- ZA6863_sample [ ZA6863_sample$isocntry %in% c("PL", "HU",
                                                               "DE-E", "DE-W",
                                                               "MK", "CY", "CY-TCC",
                                                               "GB"),]

ZA7576_sample <- ZA7576_sample[, subsetting_vars %>%
                filter ( filename == "ZA7576_v1-0-0.sav") %>%
                select (var_name_orig)  %>%
                unlist() %>% as.character()
              ]

ZA7576_sample <- ZA7576_sample [ ZA7576_sample$isocntry %in% c("PL", "HU",
                                              "DE-E", "DE-W",
                                              "MK", "CY", "CY-TCC",
                                              "GB"),]


usethis::use_data(ZA5913_sample, ZA7576_sample,
                  ZA6863_sample, overwrite = TRUE )

ZA5913_sample_documentation <- paste0(
  "item{",
  names ( ZA5913_sample ),
  "}",
  "{",
  as.character(sapply (  ZA5913_sample, function(x) attr ( x , "label"))),
  "}\n"
)

cat (ZA5913_sample_documentation )

ZA7576_sample_documentation <- paste0(
  "item{",
  names ( ZA7576_sample ),
  "}",
  "{",
  as.character(sapply (  ZA7576_sample, function(x) attr ( x , "label"))),
  "}\n"
)

cat (ZA7576_sample_documentation )

ZA6863_sample_documentation <- paste0(
  "item{",
  names ( ZA6863_sample ),
  "}",
  "{",
  as.character(sapply (  ZA6863_sample, function(x) attr ( x , "label"))),
  "}\n"
)

cat ( ZA6863_sample_documentation )

nrow ( ZA6863_sample)
