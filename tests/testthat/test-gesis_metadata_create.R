library(testthat)
library(eurobarometer)

import_file_names <- system.file("examples", "ZA5913.rds", package = "eurobarometer")

survey_list_2 <- read_surveys (
  import_file_names, .f = 'read_rds' )

returned_metadata <- gesis_metadata_create( survey_list = survey_list_2 )

single_data_frame <- gesis_metadata_create( survey_list = ZA5913_sample )

row_n <- which(returned_metadata$var_name_suggested == "european_council_trust")

test_that("correct structure is returned", {
  expect_equal(returned_metadata$length_cat_range[row_n], 2)
  expect_equal(returned_metadata$length_na_range[row_n], 1)
  expect_equal(returned_metadata$length_total_range[row_n], 3)
  #test this in retroharmonize
  #expect_equal(unique(single_data_frame$filename), "unknown")
})
