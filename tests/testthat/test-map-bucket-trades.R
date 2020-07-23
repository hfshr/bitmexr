
test_that("The map_bucket_trades() function works", {
  skip_on_cran()

  # capture_requests({
  #   res <- map_bucket_trades()
  #   expect_is(res, "data.frame")
  #   expect(length(res) > 0, failure_message = "No data returned")
  #   expect_error(map_bucket_trades(binSize = "not 1m, 5m, 1h or 1d"))
  #   expect_error(map_bucket_trades(start_date = "not-a-valid-datetime-format"))
  #   expect_error(map_bucket_trades(end_date = "not-a-valid-datetime-format"))
  #
  #   expect_error(map_bucket_trades(start_date = "2020-01-01", end_date = "1990-01-01"))
  #
  # })

  # with_mock_api({
  #   res <- map_bucket_trades()
  #
  #   expect_is(res, "data.frame")
  #   expect(length(res) > 0, failure_message = "No data returned")
  #   expect_error(map_bucket_trades(binSize = "not 1m, 5m, 1h or 1d"))
  #   expect_error(map_bucket_trades(start_date = "not-a-valid-datetime-format"))
  #   expect_error(map_bucket_trades(end_date = "not-a-valid-datetime-format"))
  #
  #   expect_error(map_bucket_trades(start_date = "2020-01-01", end_date = "1990-01-01"))
  # })
  #

  res <- map_bucket_trades()
  expect_is(res, "data.frame")
  expect(length(res) > 0, failure_message = "No data returned")
  expect_error(map_bucket_trades(binSize = "not 1m, 5m, 1h or 1d"))
  expect_error(map_bucket_trades(start_date = "not-a-valid-datetime-format"))
  expect_error(map_bucket_trades(end_date = "not-a-valid-datetime-format"))

  expect_error(map_bucket_trades(start_date = "2020-01-01", end_date = "1990-01-01"))
  Sys.sleep(3)
})


test_that("The tn_map_bucket_trades() function works", {
  skip_on_cran()

  # capture_requests({
  #   res_testnet <- tn_map_bucket_trades()
  #   expect_is(res_testnet, "data.frame")
  #   expect(length(res_testnet) > 0, failure_message = "No data returned")
  #   expect_error(tn_map_bucket_trades(binSize = "not 1m, 5m, 1h or 1d"))
  #   expect_error(tn_map_bucket_trades(start_date = "not-a-valid-datetime-format"))
  #   expect_error(tn_map_bucket_trades(end_date = "not-a-valid-datetime-format"))
  #
  #   expect_error(tn_map_bucket_trades(start_date = "2020-01-01", end_date = "1990-01-01"))
  #
  # })

  # with_mock_api({
  #   res_testnet <- tn_map_bucket_trades()
  #   expect_is(res_testnet, "data.frame")
  #   expect(length(res_testnet) > 0, failure_message = "No data returned")
  #   expect_error(tn_map_bucket_trades(binSize = "not 1m, 5m, 1h or 1d"))
  #   expect_error(tn_map_bucket_trades(start_date = "not-a-valid-datetime-format"))
  #   expect_error(tn_map_bucket_trades(end_date = "not-a-valid-datetime-format"))
  #
  #   expect_error(tn_map_bucket_trades(start_date = "2020-01-01", end_date = "1990-01-01"))
  # })
  res_testnet <- tn_map_bucket_trades()
  expect_is(res_testnet, "data.frame")
  expect(length(res_testnet) > 0, failure_message = "No data returned")
  expect_error(tn_map_bucket_trades(binSize = "not 1m, 5m, 1h or 1d"))
  expect_error(tn_map_bucket_trades(start_date = "not-a-valid-datetime-format"))
  expect_error(tn_map_bucket_trades(end_date = "not-a-valid-datetime-format"))

  expect_error(tn_map_bucket_trades(start_date = "2020-01-01", end_date = "1990-01-01"))

  Sys.sleep(3)
})
