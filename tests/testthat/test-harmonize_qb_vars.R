import_file_names <- c(
  'ZA7576_sample','ZA7562_sample','ZA7489_sample'
)

my_survey_list <- read_surveys (
  import_file_names, .f = 'read_example_file' )

my_metadata <- gesis_metadata_create( survey_list )

wrong_character_input <- c("a", "b")

harmonized_test <- harmonize_qb_vars (
  survey_list = my_survey_list,
  metadata = my_metadata,
  question_block = "socio-demography",
  var_name = "var_name_suggested",
  conversion = "class_suggested" )

data_frame_test <- harmonize_qb_vars (
  survey_list = my_survey_list[[1]],
  metadata = my_metadata,
  question_block = "socio-demography",
  var_name = "var_name_suggested",
  conversion = "class_suggested" )

test_that("correct structure is returned", {
  expect_equal("data.frame" %in% class(harmonized_test), TRUE)
})

test_that("data.frame converted to list and correctly returned", {
  expect_equal("data.frame" %in% class(data_frame_test ), TRUE)
})


test_that("error handling works", {
  expect_error(harmonized_test <- harmonize_qb_vars (
    survey_list = my_survey_list,
    metadata = wrong_character_input,
    question_block = "socio-demography",
    var_name = "var_name_suggested",
    conversion = "class_suggested" ))
  expect_error(harmonized_test <- harmonize_qb_vars (
    survey_list = wrong_character_input,
    metadata = my_metadata,
    question_block = "socio-demography",
    var_name = "var_name_suggested",
    conversion = "class_suggested" ))
  expect_error(harmonized_test <- harmonize_qb_vars (
    survey_list = my_survey_list,
    metadata = my_metadata,
    question_block = "socio-demography",
    var_name = "wrong_var_name_suggested",
    conversion = "class_suggested" ))
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
    conversion = "class_suggested" ))
})


### remove large objects ----------------------------------
rm (my_survey_list, my_metadata, wrong_character_input)
