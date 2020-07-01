skip_if_no_auth <- function(var) {
  if (identical(Sys.getenv(var), "")) {
    skip("No authentication available")
  }
}

test_that("test edit_order works", {
  skip_on_cran()

  skip_if_no_auth("bitmex_apikey")
  skip_if_no_auth("bitmex_apisecret")

  expect_error(edit_order(), "The API returned an error:  orderID or origClOrdID must be sent.")
})

test_that("test tn_edit_order works", {
  skip_on_cran()
  skip_if_no_auth("testnet_bitmex_apikey")
  skip_if_no_auth("testnet_bitmex_apisecret")

  expect_error(tn_edit_order(), "The API returned an error:  orderID or origClOrdID must be sent")
})
