
data ("ZA5913_sample")

## Test to_survey_list ---------------------------------------------
test_that("to_survey_list works", {
  expect_equal(class ( to_survey_list(ZA5913_sample) ), "list")
})

test_that("to_survey_list handles exceptions", {
  expect_error(to_survey_list("character"))
})

## Test class suggest ----------------------------------------------

#metadata <- gesis_metadata_create(ZA5913_sample)


