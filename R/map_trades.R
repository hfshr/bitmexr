#' Trade data over an extended period
#'
#' The map variant of \code{\link{trades}} uses a repeat loop to continually request trade data between two time points.
#' The function will stop when the `start_date` is greater than `end_date`.
#' There is a 2 second pause after each API call to ensure the API request limit is not reached when using the function.
#'
#' Warning! Due to the extremely large number of trades executed on the exchange,
#' using this function over an extended of time frame will result in an extremely long running process.
#' For example, during 2019 the exchanged averaged approximately 630000 trades per day,
#' with a maximum of 2114878 trades executed in a single day.
#' Obtaining the trade data for this day alone would take over an hour, and users should consider using
#' \code{\link{map_bucket_trades}} with a small `binSize` value instead.
#'
#' @references \href{https://www.bitmex.com/api/explorer/#!/Trade/Trade_get}{API Documentation}
#'
#' @inheritParams trades
#' @param start_date The start date of the desired sample
#' @param end_date The end date of the desired sample
#'
#' @family trades
#'
#' @examples
#' \dontrun{
#'
#' # Get all trades for XBTUSD between 2016-01-01 and 2016-02-01
#'
#' map_trades(start_date = "2016-01-01", end_date = "2016_02_01", symbol = "XBTUSD")
#' }
#'
#' @export
#'
map_trades <- function(start_date = "2016-01-01",
                       end_date = "2016-01-05",
                       symbol = "XBT",
                       filter = NULL) {
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


  start_date <- as_datetime(start_date)
  end_date <- as_datetime(end_date)

  check_internet()

  result <- tibble()

  cat(
    " Getting trade data between",
    format(start_date, "%Y/%m/%d %H:%M:%S"),
    "and",
    format(end_date, "%Y/%m/%d %H:%M:%S"),
    "\n"
  )

  repeat({
    data <- trades(
      startTime = start_date,
      reverse = "false",
      symbol = symbol,
      filter = filter,
      count = 1000
    )

    Sys.sleep(2)

    if (start_date > end_date) break() # the end was reached...

    result <- rbind(result, data)

    cat("\r", "Current progress: ", format(as_datetime(max(result$timestamp)), "%Y/%m/%d %H:%M:%OS"))

    flush.console()

    start_date <- as_datetime(max(result$timestamp))
  })

  return(result)
}
