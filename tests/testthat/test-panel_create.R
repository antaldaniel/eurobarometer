library(testthat)

data (ZA7576_sample)
data (ZA7562_sample)
data (ZA7489_sample)

survey_list_1 <- list ( 'ZA7576_sample' = ZA7576_sample,
                      'ZA7562_sample' = ZA7562_sample,
                      'ZA7489_sample' = ZA7489_sample)

import_file_names <- c(
  'ZA7576_sample','ZA7562_sample','ZA7489_sample'
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
               nrow (ZA7576_sample) + nrow(ZA7562_sample) +
                 nrow(ZA7489_sample))
  expect_equal(names(panel_skeleton_1),c("panel_id", "uniqid", "doi"))
  expect_equal(names(panel_skeleton_2),c("panel_id", "uniqid", "filename"))
})
