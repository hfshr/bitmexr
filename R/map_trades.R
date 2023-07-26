#' Trade data over an extended period
#'
#' The map variant of [trades()] uses a repeat loop to continually
#' request trade data between two time points.
#' The function will stop when the `start_date` is greater than `end_date`.
#' Given the large number of trades executed per day,
#' a warning message with a choice to continue is presented when inputting a
#' date range spanning more than one day.
#'
#' Warning! Due to the extremely large number of trades executed on the exchange,
#' using this function over an extended of time frame will result in an extremely
#' long running process.
#' For example, during 2019 the exchange averaged approximately 630000 trades per day,
#' with a maximum of 2114878 trades being executed in a single day.
#' Obtaining the trade data for this day alone would take over an hour, and the use of
#' [map_bucket_trades()] with a small 'binSize' (e.g., `"1m"`) is preferrable.
#'
#' @references \url{https://www.bitmex.com/api/explorer/#!/Trade/Trade_get}
#'
#' @param symbol a character string for the instrument symbol.
#' Use [available_symbols()] to see available symbols.
#' @param start_date character string.
#' Starting date for results in the format `"yyyy-mm-dd"` or `"yyyy-mm-dd hh-mm-ss"`.
#' @param end_date character string.
#' Ending date for results in the format `"yyyy-mm-dd"` or `"yyyy-mm-dd hh-mm-ss"`.
#' @param filter an optional character string for table filtering.
#' Send JSON key/value pairs, such as `"{'key':'value'}"`. See examples in [trades()].
#' @param use_auth logical. Use `TRUE` to enable authentication with API key.
#' @param verbose logical. If `TRUE`, will print information to the console. Useful for
#' long running requests.

#'
#'
#' @family trades
#'
#' @returns `map_trades()` returns a `data.frame` containing:
#' \itemize{
#'  \item{timestamp: }{POSIXct. Date and time of trade.}
#'  \item{symbol: }{character. The instrument ticker.}
#'  \item{side: }{character. Whether the trade was buy or sell.}
#'  \item{size: }{numeric. Size of the trade.}
#'  \item{price: }{numeric. Price the trade was executed at}
#'  \item{tickDirection: }{character. Indicates if the trade price was higher,
#'  lower or the same as the previous trade price.}
#'  \item{trdMatchID: }{character. Unique trade ID.}
#'  \item{grossValue: }{numeric. How many satoshi were exchanged. 1 satoshi = 0.00000001 BTC.}
#'  \item{homeNotional: }{numeric. BTC value of the trade.}
#'  \item{foreignNotional: }{numeric. USD value of the trade.}
#' }
#'
#' @examples
#' \dontrun{
#'
#' # Get all trade data between 2019-05-03 12:00:00 and 2019-05-03 12:15:00
#'
#' map_trades(
#'   start_date = "2019-05-03 12:00:00",
#'   end_date = "2019-05-03 12:15:00",
#'   symbol = "XBTUSD"
#' )
#' }
#'
#' @export
map_trades <- function(
  symbol = "XBTUSD",
  start_date = "2019-01-01 12:00:00",
  end_date = "2019-01-01 12:15:00",
  filter = NULL,
  use_auth = FALSE,
  verbose = FALSE
) {
  check_internet()

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

  result <- tibble()

  if (isTRUE(use_auth)) {
    delay <- 1
    requests <- 60
  } else {
    delay <- 2
    requests <- 30
  }

  if (verbose == TRUE) {
    cat(
      "Getting trade data between",
      format(start_date, "%Y/%m/%d %H:%M:%S"),
      "and",
      format(end_date, "%Y/%m/%d %H:%M:%S"),
      paste0("\nCurrent limit is ", requests, " requests per minute\n")
    )
  }


  limit_trades <- slowly(trades, rate_delay(delay))

  repeat({
    data <- limit_trades(
      startTime = start_date,
      reverse = "false",
      symbol = symbol,
      filter = filter,
      count = 1000,
      use_auth = use_auth
    )

    if (start_date > end_date) break() # the end was reached...

    result <- rbind(result, data)

    if (verbose == TRUE) {
      cat(
        "\rCurrent progress: ",
        format(
          as_datetime(max(result$timestamp)),
          "%Y/%m/%d %H:%M:%OS"
        )
      )
    }

    flush.console()

    start_date <- as_datetime(max(result$timestamp))
  })

  result <- result %>%
    mutate(timestamp = as_datetime(.data$timestamp)) %>%
    filter(.data$timestamp <= end_date)

  return(result)
}


#' Trade data over an extended period (testnet)
#'
#' The map variant of [tn_trades()] uses a repeat loop to continually
#' request trade data between two time points.
#' The function will stop when the `start_date` is greater than `end_date`.
#'
#' @family tn_trades
#'
#' @inheritParams map_trades
#'
#' @examples
#' \dontrun{
#'
#' # Get all trade data between 2019-05-03 12:00:00 and 2019-05-03 12:15:00
#'
#' tn_map_trades(
#'   start_date = "2019-05-03 12:00:00",
#'   end_date = "2019-05-03 12:15:00",
#'   symbol = "XBTUSD"
#' )
#' }
#'
#' @export
tn_map_trades <- function(
  symbol = "XBTUSD",
  start_date = "2019-01-01 12:00:00",
  end_date = "2019-01-01 12:15:00",
  filter = NULL,
  use_auth = FALSE,
  verbose = FALSE
) {
  check_internet()

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

  result <- tibble()

  if (isTRUE(use_auth)) {
    delay <- 1
    requests <- 60
  } else {
    delay <- 2
    requests <- 30
  }

  if (verbose == TRUE) {
    cat(
      "Getting trade data between",
      format(start_date, "%Y/%m/%d %H:%M:%S"),
      "and",
      format(end_date, "%Y/%m/%d %H:%M:%S"),
      paste0("\nCurrent limit is ", requests, " requests per minute\n")
    )
  }


  limit_trades <- slowly(tn_trades, rate_delay(delay))

  repeat({
    data <- limit_trades(
      startTime = start_date,
      reverse = "false",
      symbol = symbol,
      filter = filter,
      count = 1000,
      use_auth = use_auth
    )

    if (start_date > end_date) break() # the end was reached...

    result <- rbind(result, data)

    if (verbose == TRUE) {
      cat(
        "\rCurrent progress: ",
        format(
          as_datetime(max(result$timestamp)),
          "%Y/%m/%d %H:%M:%OS"
        )
      )
    }

    flush.console()

    start_date <- as_datetime(max(result$timestamp))
  })

  result <- result %>%
    mutate(timestamp = as_datetime(.data$timestamp)) %>%
    filter(.data$timestamp <= end_date)

  return(result)
}
