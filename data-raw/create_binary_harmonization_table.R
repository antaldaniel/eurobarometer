binary_harm_table <- read.csv ( file.path('data-raw',
                                          'binary_value_harmonization_table.csv'),
                                sep = ';' )

binary_harmonization <- binary_harm_table %>%
  select ( ends_with("_1")) %>%
  purrr::set_names( ., gsub("_1", "", names(.))) %>%
  dplyr::bind_rows(binary_harm_table %>%
                     select ( ends_with("_2")) %>%
                     purrr::set_names( ., gsub("_2", "", names(.)))) %>%
  purrr::set_names ( c("label_norm", "value_numeric", "label_harmonized"))


binary_harmonization_table <- binary_harmonization %>%
  distinct_all()

label_harmonization_table <- binary_harmonization_table

## Overwrite only if you know what you do!
usethis::use_data(label_harmonization_table, overwrite=FALSE, internal=FALSE)


