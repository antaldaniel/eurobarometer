import_file_names <- c(
'ZA7576_sample','ZA7562_sample','ZA7489_sample'
)

surveys_read <- read_surveys (
   import_file_names, .f = 'read_example_file' )

test_that("Correct structure returned", {
  expect_equal(length( surveys_read), 3)
  expect_equal(all(vapply ( surveys_read, function(x) 'filename' %in% names(x),
                            logical(1))), TRUE)
})
