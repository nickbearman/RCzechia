library(dplyr)
library(sf)


test_that("očekávané chyby", {

  skip_on_cran()

  expect_false(.ok_to_proceed("http://httpbin.org/status/404")) # rozbitý zcela
  expect_false(.ok_to_proceed("http://httpbin.org/status/503")) # server down

  expect_message(.ok_to_proceed("http://httpbin.org/status/404"), "broken") # rozbitý zcela
  expect_message(.ok_to_proceed("http://httpbin.org/status/503"), "broken") # server down

  expect_message(.downloader("asdf_wtf")) # objekt neexistuje - message
  expect_warning(.downloader("asdf_wtf"), regexp = NA) # CRAN policy - graceful fail na neexistujícím objektu

  expect_message(.ok_to_proceed("http://10.255.255.1")) # non-routable IP address - should timeout
  expect_warning(.ok_to_proceed("http://10.255.255.1"), regexp = NA) # non-routable IP address - should timeout

  Sys.setenv("NETWORK_UP" = FALSE)
  expect_message(.ok_to_proceed("http://rczechia.jla-data.net/republika.rds"), "internet") # není síť
  expect_message(.downloader("republika"), "internet") # není síť

  expect_warning(.ok_to_proceed("http://rczechia.jla-data.net/republika.rds"), regexp = NA) # není síť / ale je cran policy
  expect_warning(.downloader("republika"), regexp = NA) # není síť / ale je cran policy
  Sys.setenv("NETWORK_UP" = TRUE)

})
