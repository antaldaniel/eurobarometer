
v <- labelled(c(3,4,4,3,8, 9),
             c(YES = 3, NO = 4, wrong_label = 8, refused = 9)
             )

test_that("multiplication works", {
  expect_equal(as.numeric ( harmonize_value_labels(v) ),
               c(1,0,0, 1, 8999,9998))
  expect_equal(labelled::to_character ( harmonize_value_labels(v) ),
               c("yes", "no", "no", "yes", "wrong_label", "declined"))
})
