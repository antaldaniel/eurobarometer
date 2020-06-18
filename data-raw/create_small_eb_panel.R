library(tidyverse)
source('R/utils.R')
source (file.path("data-raw", "create_trust_tables.R"))
source(file.path("not_included", "daniel_env.R")) ##loads Daniel's local gesis directory

selected_files <- sort ( unique ( trust_metadata$filename),
                         decreasing = T)[1:3]
selected_trust_vars <- trust_metadata %>%
  filter ( filename %in% selected_files ) %>%
  select (
    all_of(c("filename", "var_name_orig", "var_label_norm"))
    )

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



metadata_var_names_orig <- c("p1", "p2", "p3", "p4", "p5", "isocntry", "doi")

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
  filter ( grepl( "voters_|political_discussion|vaccine_info_source",
                  var_name_suggested )) %>%
  distinct_all()

subsetting_vars <- full_join ( metadata_vars, demography_vars ) %>%
  full_join ( selected_trust_vars ) %>%
  full_join ( other_vars ) %>%
  full_join ( weight_vars ) %>%
  select ( all_of(c("filename", "var_name_orig")))

for (f in selected_files) { cat (f)}


ZA7489_sample <- haven::read_spss( file.path(gesis_dir, "ZA7489_v1-0-0.sav"))
ZA7562_sample <- haven::read_spss( file.path(gesis_dir, "ZA7562_v1-0-0.sav"))
ZA7576_sample <- haven::read_spss( file.path(gesis_dir, "ZA7576_v1-0-0.sav"))

ZA7489_sample  <- ZA7489_sample [, subsetting_vars %>%
                                   filter ( filename == "ZA7489_v1-0-0.sav") %>%
                                   select (var_name_orig)  %>%
                                   unlist() %>% as.character()
                                 ]

ZA7489_sample <- ZA7489_sample [ ZA7489_sample$isocntry %in% c("PL", "HU",
                                                               "DE-E", "DE-W",
                                                               "MK", "CY", "CY-TCC",
                                                               "GB"),]


ZA7562_sample  <- ZA7562_sample [, subsetting_vars %>%
                                 filter ( filename == "ZA7562_v1-0-0.sav") %>%
                                 select (var_name_orig)  %>%
                                 unlist() %>% as.character()
                               ]

ZA7562_sample <- ZA7562_sample [ ZA7562_sample$isocntry %in% c("PL", "HU",
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


usethis::use_data(ZA7489_sample, ZA7576_sample, ZA7562_sample, overwrite = TRUE )

ZA7489_sample_documentation <- paste0(
  "item{",
  names ( ZA7489_sample ),
  "}",
  "{",
  as.character(sapply (  ZA7489_sample, function(x) attr ( x , "label"))),
  "}\n"
)

cat (ZA7489_sample_documentation )

ZA7576_sample_documentation <- paste0(
  "item{",
  names ( ZA7576_sample ),
  "}",
  "{",
  as.character(sapply (  ZA7576_sample, function(x) attr ( x , "label"))),
  "}\n"
)

ZA7562_sample_documentation <- paste0(
  "item{",
  names ( ZA7562_sample ),
  "}",
  "{",
  as.character(sapply (  ZA7562_sample, function(x) attr ( x , "label"))),
  "}\n"
)

cat ( ZA7562_sample_documentation )

nrow ( ZA7562_sample)
