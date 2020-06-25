import_file_names <- c(
  'ZA7576_sample','ZA5913_sample','ZA6863_sample'
)

my_survey_list <- read_surveys (
  import_file_names, .f = 'read_example_file' )

my_metadata <- gesis_metadata_create( survey_list = my_survey_list )
names ( my_metadata)
wrong_character_input <- c("a", "b")

harmonized_test <- harmonize_qb_vars (
  survey_list = my_survey_list,
  metadata = my_metadata,
  question_block = "socio-demography",
  var_name = "var_name_suggested",
  conversion = "conversion_suggested" )

small_trust_test <- my_survey_list[[1]]
small_trust_test <- small_trust_test[1:4, c(1, 3, 26)]
small_trust_metadata <- gesis_metadata_create(small_trust_test)

trust_test <-  harmonize_qb_vars (
  survey_list = small_trust_test,
  metadata = small_trust_metadata,
  question_block = "trust",
  var_name = "var_name_suggested",
  conversion = "conversion_suggested" )

a <- as.numeric(unlist(unclass(small_trust_test$qa6a_8)))
a

harmonized_trust_labels <- names(
  attr(trust_test$trust_in_institutions_national_government, "labels"))
harmonized_trust_labels

test_that("correct value is returned", {
  expect_equal(as.numeric(trust_test$trust_in_institutions_national_government),
  c(9998,1,0, 0))
  expect_equal(harmonized_trust_labels,
               c('declined', 'tend_to_trust', 'tend_not_to_trust'))
})

test_that("correct structure is returned", {
  expect_equal("data.frame" %in% class(harmonized_test), TRUE)
})

test_that("data.frame converted to list and correctly returned", {
  expect_equal("data.frame" %in% class(trust_test), TRUE)
})

test_that("error handling works in harmonize_qb_vars", {
  expect_error(harmonized_test <- harmonize_qb_vars (
    survey_list = my_survey_list,
    metadata = wrong_character_input,
    question_block = "socio-demography",
    var_name = "var_name_suggested",
    conversion = "conversion_suggested" ))
  expect_error(harmonized_test <- harmonize_qb_vars (
    survey_list = wrong_character_input,
    metadata = my_metadata,
    question_block = "socio-demography",
    var_name = "var_name_suggested",
    conversion = "conversion_suggested" ))
  expect_error(harmonized_test <- harmonize_qb_vars (
    survey_list = my_survey_list,
    metadata = my_metadata,
    question_block = "socio-demography",
    var_name = "wrong_var_name_suggested",
    conversion = "conversion_suggested" ))
  expect_error(harmonized_test <- harmonize_qb_vars (
    survey_list = my_survey_list,
    metadata = my_metadata,
    question_block = "socio-demography",
    var_name = "var_name_suggested",
    conversion = "wrong_suggestion" ))
  expect_warning(harmonized_test <- harmonize_qb_vars (
    survey_list = my_survey_list,
    metadata = my_metadata,
    question_block = "sociology",
    var_name = "var_name_suggested",
    conversion = "conversion_suggested" ))
})
