
test_that("The map_bucket_trades() function works", {

  res <- map_bucket_trades()

  expect_is(res, "data.frame")
  expect(length(res) > 0, failure_message = "No data returned")
  expect_error(map_bucket_trades(binSize = "not 1m, 5m, 1h or 1d"))
  expect_error(map_bucket_trades(start_date = "not-a-valid-datetime-format"))
  expect_error(map_bucket_trades(end_date = "not-a-valid-datetime-format"))

})
