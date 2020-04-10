
test_that("The trades() functions works", {

  res <- trades()

  expect_is(res, "data.frame")
  expect(length(res) > 0, failure_message = "No data returned")
  expect_error(trades(count = 1001))
  expect_error(trades(startTime = "not-a-valid-datetime-format"))
  expect_error(trades(endTime = "not-a-valid-datetime-format"))

})

