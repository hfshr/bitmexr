

test_that("The bucket_trades() function works", {

  skip_on_cran()

  # capture_requests({
  #  res <- bucket_trades()
  #
  #  expect_is(res, "data.frame")
  #  expect(length(res) > 0, failure_message = "No data returned")
  #  expect_error(bucket_trades(count = 1001))
  #  expect_error(bucket_trades(binSize = "not 1m, 5m, 1h or 1d"))
  #  expect_error(bucket_trades(startTime = "not-a-valid-datetime-format"))
  #  expect_error(bucket_trades(endTime = "not-a-valid-datetime-format"))
  #
  #  expect_error(bucket_trades(symbol = "not valid"))
  #
  # }
  # )

  # with_mock_api({
  #   res <- bucket_trades()
  #
  #   expect_is(res, "data.frame")
  #   expect(length(res) > 0, failure_message = "No data returned")
  #   expect_error(bucket_trades(count = 1001))
  #   expect_error(bucket_trades(binSize = "not 1m, 5m, 1h or 1d"))
  #   expect_error(bucket_trades(startTime = "not-a-valid-datetime-format"))
  #   expect_error(bucket_trades(endTime = "not-a-valid-datetime-format"))
  #
  #   expect_error(bucket_trades(symbol = "not valid"))
  # })

  res <- bucket_trades()

  expect_is(res, "data.frame")
  expect(length(res) > 0, failure_message = "No data returned")
  expect_error(bucket_trades(count = 1001))
  expect_error(bucket_trades(binSize = "not 1m, 5m, 1h or 1d"))
  expect_error(bucket_trades(startTime = "not-a-valid-datetime-format"))
  expect_error(bucket_trades(endTime = "not-a-valid-datetime-format"))

  expect_error(bucket_trades(symbol = "not valid"))
  Sys.sleep(3)
})

test_that("The tn_bucket_trades() function works", {

  skip_on_cran()

  # capture_requests({
  #  res_testnet <- tn_bucket_trades()
  #
  #  expect_is(res_testnet, "data.frame")
  #  expect(length(res_testnet) > 0, failure_message = "No data returned")
  #  expect_error(tn_bucket_trades(count = 1001))
  #  expect_error(tn_bucket_trades(binSize = "not 1m, 5m, 1h or 1d"))
  #  expect_error(tn_bucket_trades(startTime = "not-a-valid-datetime-format"))
  #  expect_error(tn_bucket_trades(endTime = "not-a-valid-datetime-format"))
  #
  #  expect_error(tn_bucket_trades(symbol = "not valid"))
  #
  # }
  # )

  # with_mock_api({
  #   res_testnet <- tn_bucket_trades()
  #
  #   expect_is(res_testnet, "data.frame")
  #   expect(length(res_testnet) > 0, failure_message = "No data returned")
  #   expect_error(tn_bucket_trades(count = 1001))
  #   expect_error(tn_bucket_trades(binSize = "not 1m, 5m, 1h or 1d"))
  #   expect_error(tn_bucket_trades(startTime = "not-a-valid-datetime-format"))
  #   expect_error(tn_bucket_trades(endTime = "not-a-valid-datetime-format"))
  #
  #   expect_error(tn_bucket_trades(symbol = "not valid"))
  # })

  res_testnet <- tn_bucket_trades()

  expect_is(res_testnet, "data.frame")
  expect(length(res_testnet) > 0, failure_message = "No data returned")
  expect_error(tn_bucket_trades(count = 1001))
  expect_error(tn_bucket_trades(binSize = "not 1m, 5m, 1h or 1d"))
  expect_error(tn_bucket_trades(startTime = "not-a-valid-datetime-format"))
  expect_error(tn_bucket_trades(endTime = "not-a-valid-datetime-format"))

  expect_error(tn_bucket_trades(symbol = "not valid"))

  Sys.sleep(3)
})
