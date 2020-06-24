library(testthat)

import_file_names <- c(
  'ZA7576_sample','ZA5913_sample','ZA6863_sample'
)

data ("ZA5913_sample")

survey_list_2 <- read_surveys (
  import_file_names, .f = 'read_example_file' )

returned_vocabulary <- gesis_vocabulary_create( survey_list_2 )


test_that("correct structure is returned", {
  expect_equal(names(returned_vocabulary),
               c('var_name_orig', 'val_numeric_orig', 'val_label_orig',
                 'val_order_alpha', 'val_order_length', 'val_label_norm'))
  expect_equal(unique(single_data_frame$filename), "not_given")
})

names ( returned_vocabulary )
