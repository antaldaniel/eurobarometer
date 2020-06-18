library(testthat)
x <- c("my_trend_type_of_community",
       "cultural_act_go_to_exhibition",
       "age_recoded_4__categories",
       "unique_case_id",
       "cultural_act_visit_hist_monuments",
       "gesis_archive_version")

metadata <- data.frame(
  r_name           = rep(paste0(1:length(x), "_var")),
  normalized_names = x)

canonical_names(metadata)

test_that("correct lengths is returned", {
  expect_equal(length(canonical_names(metadata)), nrow(metadata))
})

test_that("canonical names are correct", {
  expect_equal(canonical_names(metadata), c("type_of_community",
                                            "cultural_activities_freq_exhibition",
                                            "age_rec_4",
                                            "uniqid",
                                            "cultural_activities_freq_hist_monuments",
                                            "gesis_archive_version_and_date"))
})
