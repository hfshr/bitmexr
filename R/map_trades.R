#' Trade data over an extended period
#'
#' The map variant of \code{\link{trades}} uses a repeat loop to continually request trade data between two time points.
#' The function will stop when the 'start_date' is greater than 'end_date'.
#' Given the large number of trades executed per day,
#' a warning message with a choice to continue is presented when inputting a date range spanning more than one day.
#'
#' Warning! Due to the extremely large number of trades executed on the exchange,
#' using this function over an extended of time frame will result in an extremely long running process.
#' For example, during 2019 the exchange averaged approximately 630000 trades per day,
#' with a maximum of 2114878 trades being executed in a single day.
#' Obtaining the trade data for this day alone would take over an hour, and users should consider using
#' \code{\link{map_bucket_trades}} with a small 'binSize' (e.g., "1m") instead.
#'
#' @references \href{https://www.bitmex.com/api/explorer/#!/Trade/Trade_get}{API Documentation}
#'
#' @inheritParams trades
#' @param start_date The start date of the desired sample
#' @param end_date The end date of the desired sample
#'
#' @family trades
#'
#' @returns A data.frame containing individual trade information for the specific time period / symbol.
#'  \item{timestamp}{Date and time of trade}
#'  \item{symbol}{Instrument ticker}
#'  \item{side}{Whether the trade was buy or sell}
#'  \item{size}{Size of the trade}
#'  \item{price}{Price the trade was executed at}
#'  \item{tickDirection}{Indicates if the trade price was higher, lower or the same as the previous trade price}
#'  \item{trdMatchID}{Unique trade ID}
#'  \item{grossValue}{How many sathoshi were exchanged. 1 satosi = 0.00000001 BTC}
#'  \item{homeNotional}{BTC value of the trade}
#'  \item{foreignNotional}{USD value of the trade}
#'
#' @examples
#' \dontrun{
#'
#' # Get all trade data between 2019-05-03 12:00:00 and 2019-05-03 12:15:00
#'
#' map_trades(start_date = "2019-05-03 12:00:00", end_date = "2019-05-03 12:15:00", symbol = "XBTUSD")
#' }
#'
#' @export
#'
map_trades <- function(
  symbol = "XBTUSD",
  start_date = "2019-01-01 12:00:00",
  end_date = "2019-01-01 12:15:00",
  filter = NULL
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
    date_check(start_date),
    .p = isFALSE,
    msg = "Invalid date format. Please use 'yyyy-mm-dd' or 'yyyy-mm-dd hh:mm:ss'"
  )

  stop_if(
    date_check(end_date),
    .p = isFALSE,
    msg = "Invalid date format. Please use 'yyyy-mm-dd' or 'yyyy-mm-dd hh:mm:ss'"
  )

  if (!is.null(start_date) & !is.null(end_date)) {
    start_date <- as_datetime(start_date)

    end_date <- as_datetime(end_date)

    vd <- valid_dates(symbol)

    message_if(
      vd$timestamp > start_date,
      msg = paste0(
        "Earliest start date for given symbol is: ",
        vd$timestamp,
        ".\nContinuing with earliest start date"
      )
    )
  }

  stop_if(
    start_date > end_date,
    msg = "Make sure start date is before end date"
  )

  trade_warning(start = start_date, end = end_date)

  check_internet()

  result <- tibble()

  limit <- rate_limit(base_url)

  cat(
    "Getting trade data between",
    format(start_date, "%Y/%m/%d %H:%M:%S"),
    "and",
    format(end_date, "%Y/%m/%d %H:%M:%S"),
    paste0("\nCurrent limit = ", limit, " requests per minute\n")
  )

  limit_trades <- slowly(trades, rate_delay(2))

  repeat({
    data <- limit_trades(
      startTime = start_date,
      reverse = "false",
      symbol = symbol,
      filter = filter,
      count = 1000
    )

    if (start_date > end_date) break() # the end was reached...

    result <- rbind(result, data)

    cat("\rCurrent progress: ", format(as_datetime(max(result$timestamp)), "%Y/%m/%d %H:%M:%OS"))

    flush.console()

    start_date <- as_datetime(max(result$timestamp))
  })

  result <- result %>%
    mutate(timestamp = as_datetime(.data$timestamp))

  return(result)
}
