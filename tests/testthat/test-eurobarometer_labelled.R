library(testthat)

### Test wrong parameter classes ---------------------------------

# "Hello, Hi, Hey":
# https://open.spotify.com/track/35J5fWBYFx1LTut0JwXxgh?si=pspMB7AfT2G808_wP3Ysbw

test_that("Appropriate warnings are given", {
  expect_warning(eurobarometer_labelled (x = c(TRUE, TRUE, FALSE, NA))  )
})

test_that("Errors are found", {
  expect_error(eurobarometer_labelled ( x = data.frame ( x = 1:5)))
})

### Test if the constructor works as expected -----------
v <- labelled::labelled(c(3,4,4,3,8, 9),
                        c(YES = 3, NO = 4, `WRONG LABEL` = 8, REFUSED = 9)
)
correct_labels <- c(3,4,8,9)
names(correct_labels) <- c("YES", "NO", "WRONG LABEL", "REFUSED")
correct_yes_no <- c(1,0)
names(correct_yes_no) <- c("yes", "no")


eurobarometer_labelled(x = c(6,7,8,9, 6,7,8),
                       labels =c("HI" = 6, "HELLO" = 7,
                                 "HOWDY" = 8, "BYE" = 9),
                       na_values = 9,
                       qb = "Example Block",
                       conversion = "eurobarometer_labelled")

x <-haven::labelled_spss(
  x = c(1,2,2,1,99998,99999),
  labels =  c(yes = 1, no = 2, wrong_label = 99998, refused = 99999),
  na_values = NULL,
  na_range = 99998:99999,
  label = "Variable Example"
)

test_that("constructor works", {
  expect_equal(labelled::val_labels ( eurobarometer_labelled(v)),
               correct_labels)
  expect_equal(labelled::val_labels (
    eurobarometer_labelled(x = c(0,1),
                           value_labels = c( 'yes' = 1, 'no' = 0)
                           )),
    correct_yes_no)
  expect_equal(labelled::na_range (eurobarometer_labelled(x)),
               c(99998,99999))
  expect_equal(class ( eurobarometer_labelled(x)),
               c("eurobarometer_labelled", class(x)))
})
