
test_that("The trades() functions works", {
  skip_on_cran()

  # capture_requests({
  #
  #   res <- trades()
  #
  #   expect_is(res, "data.frame")
  #   expect(length(res) > 0, failure_message = "No data returned")
  #   expect_error(trades(count = 1001))
  #   expect_error(trades(startTime = "not-a-valid-datetime-format"))
  #   expect_error(trades(endTime = "not-a-valid-datetime-format"))
  #
  # })

  # with_mock_api({
  #   res <- trades()
  #
  #   expect_is(res, "data.frame")
  #   expect(length(res) > 0, failure_message = "No data returned")
  #   expect_error(trades(count = 1001))
  #   expect_error(trades(startTime = "not-a-valid-datetime-format"))
  #   expect_error(trades(endTime = "not-a-valid-datetime-format"))
  # })

  res <- trades()

  expect_is(res, "data.frame")
  expect(length(res) > 0, failure_message = "No data returned")
  expect_error(trades(count = 1001))
  expect_error(trades(startTime = "not-a-valid-datetime-format"))
  expect_error(trades(endTime = "not-a-valid-datetime-format"))
  Sys.sleep(3)
})


test_that("The tn_trades() function works", {
  skip_on_cran()

  # capture_requests({
  #
  #   testnet_res <- tn_trades()
  #
  #   expect_is(testnet_res, "data.frame")
  #   expect(length(testnet_res) > 0, failure_message = "No data returned")
  #   expect_error(tn_trades(count = 1001))
  #   expect_error(tn_trades(startTime = "not-a-valid-datetime-format"))
  #   expect_error(tn_trades(endTime = "not-a-valid-datetime-format"))
  #
  # })

  # with_mock_api({
  #   testnet_res <- tn_trades()
  #
  #   expect_is(testnet_res, "data.frame")
  #   expect(length(testnet_res) > 0, failure_message = "No data returned")
  #   expect_error(tn_trades(count = 1001))
  #   expect_error(tn_trades(startTime = "not-a-valid-datetime-format"))
  #   expect_error(tn_trades(endTime = "not-a-valid-datetime-format"))
  # })
  #
  testnet_res <- tn_trades()

  expect_is(testnet_res, "data.frame")
  expect(length(testnet_res) > 0, failure_message = "No data returned")
  expect_error(tn_trades(count = 1001))
  expect_error(tn_trades(startTime = "not-a-valid-datetime-format"))
  expect_error(tn_trades(endTime = "not-a-valid-datetime-format"))
  Sys.sleep(3)
})
