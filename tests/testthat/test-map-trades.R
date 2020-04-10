test_that("The map_trades() function works", {

  res <- map_trades(start_date = "2020-01-01 12:00:00",
                    end_date = "2020-01-01 12:15:00")
  expect_is(res, "data.frame")
  expect(length(res) > 0, failure_message = "No data returned")
  expect_error(map_trades(start_date = "not-a-valid-datetime-format"))
  expect_error(map_trades(end_date = "not-a-valid-datetime-format"))

})
