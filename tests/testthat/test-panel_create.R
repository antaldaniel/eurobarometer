library(testthat)

data (ZA7576_sample)
data (ZA5913_sample)
data (ZA6863_sample)

survey_list_1 <- list ('ZA7576_sample' = ZA7576_sample,
                      'ZA5913_sample' = ZA5913_sample,
                      'ZA6863_sample' = ZA6863_sample)

import_file_names <- c(
  'ZA7576_sample','ZA5913_sample','ZA6863_sample'
)

survey_list_2 <- read_surveys (
  import_file_names, .f = 'read_example_file' )

panel_skeleton_1 <- panel_create (survey_list_1,
                                id_vars =c("uniqid", "doi") )

panel_skeleton_2 <- panel_create (survey_list_2,
                                id_vars =c("uniqid", "filename") )

names ( panel_skeleton_2)

test_that("Correct data frame is created", {
  expect_equal(nrow ( panel_skeleton_1),
               nrow (ZA7576_sample) + nrow(ZA5913_sample) +
                 nrow(ZA6863_sample))
  expect_equal(names(panel_skeleton_1),c("panel_id", "uniqid", "doi"))
  expect_equal(names(panel_skeleton_2),c("panel_id", "uniqid", "filename"))
})
