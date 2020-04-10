#' Bucket trade data over an extended period
#'
#' \code{map_bucket_trades} uses purrr::map_dfr under the hood to execute multiple API calls.
#' This is useful when the data you want to return exceeds the maximum 1000 row response limit,
#' but do not want to have to manually call \code{\link{bucket_trades}} repeatedly.
#'
#' \code{map_bucket_trades} takes a start and end date, and creates a sequence of start dates
#' which are passed in to the \code{startTime} parameter in \code{\link{bucket_trades}}.
#'
#' The length of time between each start time in each API call is determined by the binSize.
#' For example, "1d" is chosen as the binSize the length of time between start dates will be 1000 days.
#' If "1h" is chosen, it will be 1000 hours etc.
#'
#' The function will print the number of API calls being sent and provides a progress bar in the consol
#'
#' Public API requests are limited to 30 per minute. Consequently, the function uses purrr::slowly to ensure this
#' limit is never reached while sending multiple API requests.
#'
#' @family bucket_trades
#'
#' @references \href{https://www.bitmex.com/api/explorer/#!/Trade/Trade_getBucketed}{API Documentation}
#'
#' @inheritParams bucket_trades
#'
#' @param start_date The start date of the sample. Default to the earliest date for api calls
#' @param end_date The end date of the sample. Default to today
#'
#' @return `map_bucket_trades` returns a data.frame containing bucketed trade data for the specified time frame.
#'
#' @examples
#'
#' # Get hourly bucketed trade data between 2020-01-01 and 2020-02-01
#'
#' map_bucket_trades(start_date = "2020-01-01", end_date = "2020-02-01")
#'
#' @export
map_bucket_trades <- function(
  start_date = "2015-09-25 13:00:00",
  end_date = now(tzone = "UTC"),
  binSize = "1d",
  symbol = "XBT",
  partial = "false"
) {
  stop_if_not(
    binSize %in% c("1m", "5m", "1h", "1d"),
    msg = "binSize must be 1m, 5m, 1h or 1d"
  )

  stop_if(
    date_check(start_date),
    .p = isFALSE,
    msg = "Invalid date format. Please use 'yyyy-mm-dd' or 'yyyy-mm-dd hh:mm:ss'"
  )

  stop_if(
    date_check(end_date),
    .p = isFALSE,
    msg = "Invalid date format. Please use 'yyyy-mm-dd' or 'yyyy-mm-dd hh:mm:ss'"
  )

  by <- switch(
    binSize,
    "1d" = "1000 days",
    "1h" = "1000 hours",
    "5m" = "5000 min",
    "1m" = "1000 min"
  )

  breaks <- seq(as_datetime(start_date), as_datetime(end_date), by = by)

  pb <- progress_bar$new(
    format = "Progress[:bar] :current/:total  eta: ~:eta",
    total = length(breaks),
    width = 70,
    clear = FALSE
  )

  limit_bucket_trades <- slowly(bucket_trades, rate_delay(2))

  limit <- rate_limit(base_url)

  pb$message(paste(length(breaks), "API requests generated."))
  pb$message(paste("Current limit =", limit, "requests per minute"))



  res <- map_dfr(breaks, ~ {
    pb$tick()
    limit_bucket_trades(
      startTime = .x,
      binSize = binSize,
      reverse = "false",
      partial = partial,
      symbol = symbol
    )
  })

  return(res)
}
