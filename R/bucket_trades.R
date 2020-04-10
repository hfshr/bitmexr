#' Bucketed trade data
#'
#' \code{bucket_trades} retrieves open high low close (OHLC) data for the specified symbol/timeframe.
#'
#' The API will only return 1000 rows per call. If the desired timeframe requires more than one API call,
#' consider using \code{\link{map_bucket_trades}}.
#'
#' @references \href{https://www.bitmex.com/api/explorer/#!/Trade/Trade_getBucketed}{API Documentation}
#'
#' @family map_bucket_trades
#'
#' @param binSize Time interval to bucket by. Must be one of: 1m, 5m, 1h or 1d.
#' @param partial If true, will send in-progress (incomplete) bins for the current time period.
#' @inheritParams trades
#'
#' @return `bucket_trades` returns a data.frame containing open high low close data for the specified time interval
#'
#' @examples
#'
#' # Return most recent data for symbol "ETHUSD" for 1 hour buckets
#'
#' bucket_trades(binSize = "1h", symbol = "ETHUSD")
#'
#' @export

bucket_trades <- function(
  binSize = "1m",
  partial = "false",
  symbol = "XBT",
  filter = NULL,
  columns = NULL,
  count = 1000,
  start = NULL,
  reverse = "true",
  startTime = NULL,
  endTime = NULL
) {
  check_internet()

  stop_if(
    !binSize %in% c("1m", "5m", "1h", "1d"),
    msg = "binSize must be 1m, 5m, 1h or 1d"
  )

  stop_if(
    count > 1000,
    msg = "Maximum reponse per request is 1000. Consider using map_bucket_trades for returning > 1000 rows"
  )

  if (!is.null(startTime)) {
    reverse <- "false"
    stop_if(
      date_check(startTime),
      .p = isFALSE,
      msg = "Invalid date format. Please use 'yyyy-mm-dd' or 'yyyy-mm-dd hh:mm:ss'"
    )
  }

  if (!is.null(endTime)) {
    reverse <- "false"
    stop_if(
      date_check(endTime),
      .p = isFALSE,
      msg = "Invalid date format. Please use 'yyyy-mm-dd' or 'yyyy-mm-dd hh:mm:ss'"
    )
  }


  args <- list(
    binSize = binSize,
    partial = partial,
    symbol = symbol,
    filter = gsub("'", "\"", filter),
    columns = columns,
    count = count,
    start = start,
    reverse = reverse,
    startTime = startTime,
    endTime = endTime
  )


  res <- GET(trade_bucketed_url, query = compact(args))

  check_status(res)

  result <- jsonlite::fromJSON(content(res, "text"))

  stop_if(
    length(result) == 0,
    msg = "No result returned"
  )

  return(result)
}
