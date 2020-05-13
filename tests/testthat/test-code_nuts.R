
test_that("NUTS1 example works", {
  expect_equal(code_nuts1 (
    region_nuts_names = c("Brandenburg", "London", "Centro", NA),
    country_code = c("DE", "GB", "IT", NA),
    nuts_code = "code10"
  ), c("DE4", "UKI", "ITI", NA_character_))
})


test_that("NUTS2 example works", {
  expect_equal(code_nuts2  (region_nuts_names = c("Tirol", "Praha", NA),
    nuts_code = "code10"
  ), c("AT33", "CZ01"))
})

test_that("NUTS2 example works with code13", {
  expect_equal(code_nuts2  (region_nuts_names = c("Tirol", "Praha", NA),
                            nuts_code = "code13"
  ), c("AT33", "CZ01"))
})

test_that("NUTS2 example works", {
  expect_equal(code_nuts2  (region_nuts_names = c("Tirol", "Praha", "MALTA"),
                            nuts_code = "code10"
  ), c("AT33" ,"CZ01", "MT00"))
})






