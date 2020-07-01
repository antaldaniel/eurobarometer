special_values <- eurobarometer_special_values()

test_that("correct structure and values are returned", {
  expect_equal(as.character(special_values[1,1:2]),
               c("inap", "99999"))
})
