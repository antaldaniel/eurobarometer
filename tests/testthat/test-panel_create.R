library(testthat)

data (ZA7576_sample)
data (ZA7562_sample)
data (ZA7489_sample)

survey_list <- list ( 'ZA7576_sample' = ZA7576_sample,
                      'ZA7562_sample' = ZA7562_sample,
                      'ZA7489_sample' = ZA7489_sample)


panel_skeleton <- panel_create (survey_list,
                                id_vars =c("uniqid", "doi") )

test_that("Correct data frame is created", {
  expect_equal(nrow ( panel_skeleton),
               nrow (ZA7576_sample) + nrow(ZA7562_sample) +
                 nrow(ZA7489_sample))
  expect_equal(names(panel_skeleton),c("panel_id", "uniqid", "doi"))
})
