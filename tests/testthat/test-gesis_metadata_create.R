library(testthat)
library(eurobarometer)

file1 <- system.file(
  "examples", "ZA7576.rds", package = "eurobarometer")
file2 <- system.file(
  "examples", "ZA5913.rds", package = "eurobarometer")

import_file_names <- c(file1,file2)

survey_list_2 <- read_surveys (
  import_file_names, .f = 'read_rds' )

returned_metadata <- gesis_metadata_create( survey_list = survey_list_2 )

single_data_frame <- gesis_metadata_create( survey_list = survey_list_2[[2]] )

row_n <- which(single_data_frame$var_name_suggested == "paying_bills_last_year")

# These values are not correct
test_that("correct structure is returned", {
  expect_equal(single_data_frame$n_valid_labels[row_n], 3)
  expect_equal(single_data_frame$n_na_labels[row_n], 1)
  expect_equal(unique(single_data_frame$filename), "ZA5913.rds")
})
