
v <- labelled(c(3,4,4,3,8, 9),
             c(YES = 3, NO = 4, wrong_label = 8, refused = 9)
             )

test_that("binary harmonization works", {
  expect_equal(as.numeric ( harmonize_value_labels(labelled_var = v,
                                                   categories = 2) ),
               c(1,0,0, 1, 8999,9998))
  expect_equal(labelled::to_character ( harmonize_value_labels(v,2) ),
               c("yes", "no", "no", "yes", "wrong_label", "declined"))
})


v3 <- labelled(c(3,4,5,3,8, 9),
              c(`BETTER`= 3, `WORSE`= 4,
                `SAME` = 5,
                wrong_label = 8, refused = 9)
)
test_that("three value harmonization works", {
  expect_equal(length(v3), length(harmonize_value_labels(
    labelled_var = v3,categories = 3)))
  expect_equal(as.numeric ( harmonize_value_labels(
    labelled_var = v3,categories = 3) ),
               c(1,-1,0,1, 8999,9998))
  expect_equal(labelled::to_character ( harmonize_value_labels(v3,3) ),
               c("better", "worse", "same", "better", "wrong_label", "declined"))
})


