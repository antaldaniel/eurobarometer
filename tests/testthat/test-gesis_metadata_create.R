library(testthat)

import_file_names <- c(
  'ZA7576_sample','ZA7562_sample','ZA7489_sample'
)

survey_list_2 <- read_surveys (
  import_file_names, .f = 'read_example_file' )

returned_metadata <- gesis_metadata_create( survey_list_2 )

single_data_frame <- gesis_metadata_create( survey_list = ZA7489_sample )


test_that("correct structure is returned", {
  expect_equal(names(returned_metadata),
               c('filename', 'var_name_orig', 'class_orig', 'var_label_orig',
                 'var_label_norm', 'var_name_suggested', 'factor_levels',
                 'n_categories', 'class_suggested'))
  expect_equal(unique(single_data_frame$filename), "not_given")
})
