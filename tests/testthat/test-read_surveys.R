file1 <- system.file(
    "examples", "ZA7576.rds", package = "eurobarometer")
file2 <- system.file(
    "examples", "ZA5913.rds", package = "eurobarometer")

if(!is.null(file1)){
  tested <- read_surveys (c(file1,file2), .f = 'read_rds' )

  test_that("correct files are read", {
    expect_equal(attr(tested[[1]], "filename"), "ZA7576.rds")
    expect_equal(attr(tested[[2]], "id"), "ZA5913")
  })

}

