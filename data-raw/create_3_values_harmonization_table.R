three_harm_table <- read.csv ( file.path('data-raw',
                                          'three_value_harmonization_table.csv'),
                                sep = ';' ) %>%
  filter (!is.na(label_harmonized_1 ))

three_harmonization <- three_harm_table %>%
  select ( ends_with("_1")) %>%
  purrr::set_names( ., gsub("_1", "", names(.))) %>%
  dplyr::bind_rows(three_harm_table %>%
                     select ( ends_with("_2")) %>%
                     purrr::set_names( ., gsub("_2", "", names(.)))) %>%
  dplyr::bind_rows(three_harm_table %>%
                     select ( ends_with("_3")) %>%
                     purrr::set_names( ., gsub("_3", "", names(.)))) %>%
  purrr::set_names ( c("label_norm", "value_numeric", "label_harmonized"))


three_harmonization_table <- three_harmonization %>%
  distinct_all()

data ('label_harmonization_table')

source(file.path("data-raw", "create_binary_harmonization_table.R"))


label_harmonization_table <- binary_harmonization_table %>%
  mutate ( valid_range = 2 ) %>%
  bind_rows( three_harmonization_table %>%
               mutate ( valid_range = 3))

## Overwrite only if you know what you do!
usethis::use_data(label_harmonization_table, overwrite=TRUE, internal=FALSE)


