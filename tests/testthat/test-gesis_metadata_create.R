library(testthat)

import_file_names <- c(
  'ZA7576_sample','ZA5913_sample','ZA6863_sample'
)

survey_list_2 <- read_surveys (
  import_file_names, .f = 'read_example_file' )

returned_metadata <- gesis_metadata_create( survey_list_2 )

single_data_frame <- gesis_metadata_create( survey_list = ZA5913_sample )

test_that("correct structure is returned", {
  expect_equal(names(returned_metadata),
               c('filename', 'qb', 'var_name_orig',  'var_label_orig',
                 'var_label_norm', 'var_name_suggested', 'factor_levels',
                 'n_categories', 'class_orig', 'class_suggested'))
  expect_equal(unique(single_data_frame$filename), "not_given")
})

