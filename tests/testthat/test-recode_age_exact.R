library(testthat)


recode_age_education(var, age_exact)

test_that("recode_age_education works", {
  expect_equal(recode_age_education(var, age_exact),
               c(15, 75,NA_real_, 23, NA_real_, 15))
})

test_that("recode_age_education works", {
  expect_equal(recode_age_education(var),
               c(15, 75,NA_real_, NA_real_, NA_real_, 15))
})
