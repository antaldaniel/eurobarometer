v <- labelled::labelled(c(3,4,4,3,8,9),
             c(YES = 3, NO = 4, wrong_label = 8, refused = 9)
             )

input_labelled_var = harmonize_value_labels(v)

test_that("correct values are retured", {
  expect_equal(harmonize_to_numeric(harmonized_labelled_var = input_labelled_var),
               c(1,0,0,1,NA_real_, NA_real_))
})
