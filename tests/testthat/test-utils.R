
test_that("utils functions work", {
  skip_on_cran()

  # capture_requests({
  #
  #   res <- valid_dates()
  #   expect_is(res, "data.frame")
  #
  #   symbols <- available_symbols()
  #   expect_is(symbols, "character")
  #
  # })


  # with_mock_api({
  #   res <- valid_dates()
  #   expect_is(res, "data.frame")
  #
  #
  #   symbols <- available_symbols()
  #   expect_is(symbols, "character")
  # })

res <- valid_dates()
expect_is(res, "data.frame")

symbols <- available_symbols()
expect_is(symbols, "character")

  expect_false(date_check("hello"))
})
