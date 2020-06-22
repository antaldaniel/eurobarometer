import_file_names <- c(
'ZA7576_sample','ZA6863_sample','ZA5913_sample'
)

surveys_read <- read_surveys (
   import_file_names, .f = 'read_example_file' )

test_that("Correct structure returned", {
  expect_equal(length( surveys_read), 3)
  expect_equal(all(vapply ( surveys_read, function(x) 'filename' %in% names(x),
                            logical(1))), TRUE)
  expect_equal(attr(surveys_read[[1]]$filename, "label"), "filename")
})
