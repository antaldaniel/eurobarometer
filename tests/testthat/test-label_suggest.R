library(testthat)

#metadata <- trust_metadata[c(1,122,455,899,1234,1989, 2400),]

### Test with trust metadata ---------------------------------------
metadata <- data.frame (
  var_name_orig = c('v335', 'v121', 'v150', 'v83', 'qa6a_3', 'qa8a_5', 'qa10_9'),
  var_label_orig = c('QA17_1 EUROPEAN PARLIAMENT - TRUST', 'Q26 COUNCIL OF MINISTERS - TRUST', 'Q17 EUROPEAN COMMISSION - TRUST', 'Q10 TRUST IN INSTITUTIONS: CIVIL SERVICE', 'TRUST IN INSTITUTIONS: JUSTICE / LEGAL SYSTEM', 'TRUST IN INSTITUTIONS: REG/LOC PUBLIC AUTHORITIES', 'TRUST IN INSTITUTIONS: UNITED NATIONS')
)

trust_suggested <- label_suggest(
  var_label_orig = metadata$var_label_orig,
  var_name_orig = metadata$var_name_orig
  )

test_that("correct vector is returned", {
  expect_equal(length(trust_suggested ), 7)
  expect_equal(class(trust_suggested ), "character")
})

## Could be better!
expected_return <- c(
  'european_parliament_trust', 'council_of_ministers_trust',
  'european_commission_trust', 'trust_in_institutions_civil_service',
  'trust_in_institutions_justice_legal_system',
  'trust_in_institutions_reg_loc_public_authorities',
  'trust_in_institutions_united_nations')

test_that("correct results", {
  expect_equal(trust_suggested, expected_return)
})

