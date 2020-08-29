

example_survey <- read_surveys(system.file(
  "examples", "ZA7576.rds", package = "eurobarometer"), .f='read_rds')
identified <- identify_mentioned (metadata_create ( example_survey [[1]] ))
identified <- identified[(!is.na(identified$group_mentioned)),]
results1 <- identified[, c("var_name_orig", "labels", "group_mentioned")]


test_that("expected identification", {
  expect_equal(results1$group_mentioned, rep("not_mentioned_other_na", 14 ))
})
