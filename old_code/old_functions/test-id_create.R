
test_id_create <- data.frame (
  uniqid = c(1,2,3,4,5,5),
  doi = rep("doi:10.4232/1.13393", 6))

corrected <- id_create ( dat = test_id_create,
                         id_vars = c("uniqid", "doi")
                         )

#test_that("warning is given", {
#  expect_warning( id_create (test_id_create,
#                             id_vars = c("uniqid", "doi")))
#})

test_that("correct ID is returned", {
  expect_equal( id_create (test_id_create,
                             id_vars = c("uniqid", "doi"))$panel_id,
                paste0 ( 1:6, "_", c(1,2,3,4,5,5), "_", "doi_10_4232_1_13393") )
})



