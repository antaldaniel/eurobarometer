library(testthat)
library(eurobarometer)
import_file_names <- c(
  'ZA7576_sample','ZA5913_sample','ZA6863_sample'
)

data ("ZA5913_sample")

survey_list_2 <- read_surveys (
  import_file_names, .f = 'read_example_file' )

returned_metadata <- gesis_metadata_create( survey_list = survey_list_2 )

single_data_frame <- gesis_metadata_create( survey_list = ZA5913_sample )

row_n <- which(returned_metadata$var_name_suggested == "european_council_trust")

test_that("correct structure is returned", {
  expect_equal(returned_metadata$length_cat_range[row_n], 2)
  expect_equal(returned_metadata$length_na_range[row_n], 1)
  expect_equal(returned_metadata$length_total_range[row_n], 3)
  expect_equal(unique(single_data_frame$filename), "not_given")
})
