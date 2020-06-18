### Test based on trust variable labels --------------------------------
#paste0("'",
#       paste( var_label_orig[c(1,122,455,899,1234,1989, 2400)], collapse = "', '"),
#       "'")

example_trust_labels <- c('QA17_1 EUROPEAN PARLIAMENT - TRUST',
                          'Q26 COUNCIL OF MINISTERS - TRUST',
                          'Q17 EUROPEAN COMMISSION - TRUST',
                          'Q10 TRUST IN INSTITUTIONS: CIVIL SERVICE',
                          'TRUST IN INSTITUTIONS: JUSTICE / LEGAL SYSTEM',
                          'TRUST IN INSTITUTIONS: REG/LOC PUBLIC AUTHORITIES',
                          'TRUST IN INSTITUTIONS: UNITED NATIONS')

tested_trust_labels <- label_normalize ( example_trust_labels)

test_that("correct vector is returned", {
  expect_equal(length(tested_trust_labels), 7)
  expect_equal(class(tested_trust_labels), "character")
})
tested_trust_labels

test_that("qb preffix is removed", {
  expect_equal(all(grepl( "qa1|q1", tested_trust_labels)), FALSE)
})

test_that("/ is removed", {
  expect_equal(all(grepl( "\\/", tested_trust_labels)), FALSE)
})

test_that("/ is removed", {
  expect_equal(all(grepl( "\\/", tested_trust_labels)), FALSE)
})

tested_trust_endings <- substr (x = tested_trust_labels,
                                start = length(tested_trust_labels),
                                stop = length(tested_trust_labels))

test_that("no whitespace or clutter on end", {
  expect_equal(all(grepl ( "\\s|_", tested_trust_endings )), FALSE)
})



