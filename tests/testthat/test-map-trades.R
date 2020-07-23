
test_that("The map_trades() function works", {
  skip_on_cran()

  # capture_requests({
  #
  #  res <- map_trades(symbol = "XBTUSD", start_date = "2020-01-01 12:00:00", end_date = "2020-01-01 12:05:00")
  #  expect_is(res, "data.frame")
  #  expect(length(res) > 0, failure_message = "No data returned")
  #  expect_error(map_trades(start_date = "not-a-valid-datetime-format",symbol = "XBTUSD"))
  #  expect_error(map_trades(end_date = "not-a-valid-datetime-format", symbol = "XBTUSD"))
  #
  # })

  # with_mock_api({
  #   res <- map_trades(symbol = "XBTUSD", start_date = "2020-01-01 12:00:00", end_date = "2020-01-01 12:05:00")
  #   expect_is(res, "data.frame")
  #   expect(length(res) > 0, failure_message = "No data returned")
  #   expect_error(map_trades(start_date = "not-a-valid-datetime-format", symbol = "XBTUSD"))
  #   expect_error(map_trades(end_date = "not-a-valid-datetime-format", symbol = "XBTUSD"))
  # })

  res <- map_trades(symbol = "XBTUSD", start_date = "2020-01-01 12:00:00", end_date = "2020-01-01 12:05:00")
  expect_is(res, "data.frame")
  expect(length(res) > 0, failure_message = "No data returned")
  expect_error(map_trades(start_date = "not-a-valid-datetime-format", symbol = "XBTUSD"))
  expect_error(map_trades(end_date = "not-a-valid-datetime-format", symbol = "XBTUSD"))
  Sys.sleep(3)
})

test_that("The tn_map_trades() function works", {
  skip_on_cran()

  # capture_requests({
  #
  #  testnet_res <- tn_map_trades(symbol = "XBTUSD", start_date = "2020-01-01 12:00:00", end_date = "2020-01-01 12:05:00")
  #  expect_is(testnet_res, "data.frame")
  #  expect(length(testnet_res) > 0, failure_message = "No data returned")
  #  expect_error(tn_map_trades(start_date = "not-a-valid-datetime-format",symbol = "XBTUSD"))
  #  expect_error(tn_map_trades(end_date = "not-a-valid-datetime-format", symbol = "XBTUSD"))
  #
  # })

  # with_mock_api({
  #   testnet_res <- tn_map_trades(symbol = "XBTUSD", start_date = "2020-01-01 12:00:00", end_date = "2020-01-01 12:05:00")
  #   expect_is(testnet_res, "data.frame")
  #   expect(length(testnet_res) > 0, failure_message = "No data returned")
  #   expect_error(tn_map_trades(start_date = "not-a-valid-datetime-format", symbol = "XBTUSD"))
  #   expect_error(tn_map_trades(end_date = "not-a-valid-datetime-format", symbol = "XBTUSD"))
  # })

  testnet_res <- tn_map_trades(symbol = "XBTUSD", start_date = "2020-01-01 12:00:00", end_date = "2020-01-01 12:05:00")
  expect_is(testnet_res, "data.frame")
  expect(length(testnet_res) > 0, failure_message = "No data returned")
  expect_error(tn_map_trades(start_date = "not-a-valid-datetime-format", symbol = "XBTUSD"))
  expect_error(tn_map_trades(end_date = "not-a-valid-datetime-format", symbol = "XBTUSD"))
  Sys.sleep(3)
})
