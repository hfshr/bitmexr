skip_if_no_auth <- function(var) {
  if (identical(Sys.getenv(var), "")) {
    skip("No authentication available")
  }
}

test_that("execute_order works", {
  skip_if_no_auth("bitmex_apikey")
  skip_if_no_auth("bitmex_apisecret")

  expect_error(place_order(), "The API returned an error:  'symbol' is a required arg.")
})

test_that("testnet_execute_order works", {
  skip_if_no_auth("testnet_bitmex_apikey")
  skip_if_no_auth("testnet_bitmex_apisecret")

  expect_error(tn_place_order(), "The API returned an error:  'symbol' is a required arg.")
})
