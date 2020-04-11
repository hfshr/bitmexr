#' Bucketed trade data
#'
#' \code{bucket_trades()} retrieves open high low close (OHLC) data for the specified symbol/time frame.
#' The API will only return 1000 rows per call. If the desired time frame requires more than one API call,
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
#' @return \code{bucket_trades()} returns a data.frame containing open high low close data
#' for the specified time frame and symbol.
#'  \item{timestamp}{Date and time of trade}
#'  \item{symbol}{Instrument ticker}
#'  \item{open}{Opening price for the bucket}
#'  \item{high}{Highest price in the bucket}
#'  \item{low}{Lowest price in the bucket}
#'  \item{close}{Closing price of the bucket}
#'  \item{trades}{Number of trades executed within the bucket}
#'  \item{volume}{Volume in USD}
#'  \item{vwap}{Volume weighted average price}
#'  \item{lastSize}{Size of the last trade executed}
#'  \item{turnover}{How many sathoshi were exchanged}
#'  \item{homeNotional}{BTC value of the bucket}
#'  \item{foreignNotional}{USD value of the bucket}
#'
#'
#' @examples
#' \dontrun{
#'
#' # Return most recent data for symbol "ETHUSD" for 1 hour buckets
#'
#' bucket_trades(binSize = "1h", symbol = "ETHUSD")
#' }
#' @export

bucket_trades <- function(
  binSize = "1m",
  partial = "false",
  symbol = "XBTUSD",
  filter = NULL,
  columns = NULL,
  count = 1000,
  start = NULL,
  reverse = "true",
  startTime = NULL,
  endTime = NULL
) {
  check_internet()

  stop_if_not(
    symbol %in% available_symbols(),
    msg = paste(
      "Please use one of the available symbols:",
      paste(available_symbols(), collapse = ", ")
    )
  )

  stop_if(
    !binSize %in% c("1m", "5m", "1h", "1d"),
    msg = "binSize must be 1m, 5m, 1h or 1d"
  )

  stop_if(
    count > 1000,
    msg = "Maximum reponse per request is 1000. Use map_bucket_trades for returning > 1000 rows"
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

  if (!is.null(startTime) & !is.null(endTime)) {
    startTime <- as_datetime(startTime)

    endTime <- as_datetime(endTime)

    stop_if(
      startTime > endTime,
      msg = "Make sure start date is before end date"
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

  result <- jsonlite::fromJSON(content(res, "text")) %>%
    mutate(timestamp = as_datetime(.data$timestamp))

  stop_if(
    length(result) == 0,
    msg = "No result returned"
  )

  return(result)
}
