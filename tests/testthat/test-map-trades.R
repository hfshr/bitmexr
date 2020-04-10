test_that("The map_trades() function works", {

  res <- map_trades()
  expect_is(res, "data.frame")
  expect(length(res) > 0, failure_message = "No data returned")
  expect_error(map_trades(start_date = "not-a-valid-datetime-format"))
  expect_error(map_trades(end_date = "not-a-valid-datetime-format"))

})
