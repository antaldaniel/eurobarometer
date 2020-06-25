data ("ZA5913_sample")

small_sample_convert  <- ZA5913_sample %>%
  mutate ( filename = "ZA5913_sample") %>%
  select (all_of(c("uniqid", "filename", "doi", "p3", "qa10_3", 'w1'))) %>%
  sample_n(20)
small_sample_metadata <- gesis_metadata_create( small_sample_convert )

test_converted <- convert_class  ( dat = small_sample_convert,
                   metadata = small_sample_metadata,
                   var_name = "var_name_orig")

test_that("Correct class conversion takes place", {
  expect_equal(class(test_converted$filename), "character")
  expect_equal(class(test_converted$w1), "numeric")
  expect_equal(class(test_converted$p3), c("haven_labelled_spss", "haven_labelled", "vctrs_vctr", "double"))
  expect_equal(class(test_converted$qa10_3), c("haven_labelled", "vctrs_vctr", "double"))
  expect_equal(sort(names(attr ( test_converted$qa10_3, "labels"))),
  c("declined", "tend_not_to_trust", "tend_to_trust"))
  expect_equal(sort(names(attr ( test_converted$qa10_3, "labels_orig"))),
               c("DK", "Tend not to trust", "Tend to trust"))
})
