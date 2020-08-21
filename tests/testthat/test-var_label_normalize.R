x <- c('QF4C INTERESTS INFO SOURCES: INTERNET',
       'QB15A CHILDREN NEEDS: SOME NEW CLOTHES',
       'QB9B RESEARCH INFO SOURCE - PREFERENCE 2ND',
       'EU MEANING: CULTURAL DIVERSITY',
       'P6 SIZE OF COMMUNITY - AUSTRIA',
       'D49D_CY WEBSITES: OTHER',
       'LOVE RELATIONSHIP OF CHILD - CHRISTIAN PERSON' )

test_that("variable label normalization works", {
  expect_equal(var_label_normalize(x),
               c('interests information sources internet',
                 'children needs some new clothes',
                 'research information source preference second ',
                 'eu meaning cultural diversity',
                 'size-of-community austria',
                 'cy websites other',
                 'love relationship of child christian person')
               )
})
