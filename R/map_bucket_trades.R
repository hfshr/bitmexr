#' Bucket trade data over an extended period
#'
#' `map_bucket_trades()` uses `purrr::map_dfr` to execute multiple API calls.
#' This is useful when the data you want to return exceeds the maximum 1000 row response limit,
#' but do not want to have to manually call [bucket_trades()] repeatedly.
#'
#' `map_bucket_trades()` takes a start and end date, and creates a sequence of start dates
#' which are passed in to the `startTime`` parameter in [bucket_trades()].
#'
#' The length of time between each start time in each API call is determined by the binSize.
#' For example, `"1d"` is chosen as the binSize the length of time between start dates will be 1000 days.
#' If `"1h"` is chosen, it will be 1000 hours etc.
#'
#' The function will print the number of API calls being sent and provides a progress bar in the console
#'
#' Public API requests are limited to 30 per minute. Consequently, `map_bucket_trades()` uses
#' `purrr::slowly` to restrict how often the function is called.
#'
#'
#' @family bucket_trades
#'
#' @references \url{https://www.bitmex.com/api/explorer/#!/Trade/Trade_getBucketed}
#'
#' @param start_date character string.
#' Starting date for results in the format `"yyyy-mm-dd"` or `"yyyy-mm-dd hh-mm-ss"`.
#' @param end_date character string.
#' Ending date for results in the format `"yyyy-mm-dd"` or `"yyyy-mm-dd hh-mm-ss"`.
#' @param symbol a character string for the instrument symbol.
#' Use [available_symbols()] to see available symbols.
#' @param binSize character string.
#' The time interval to bucket by, must be one of: `"1m"`, `"5m"`, `"1h"` or `"1d"`.
#' @param partial character string. Either `"true"` or `"false"`.
#' If `"true"`, will send in-progress (incomplete) bins for the current time period.
#' @param filter an optional character string for table filtering.
#' Send JSON key/value pairs, such as `"{'key':'value'}"`. See examples in [trades()].
#' @inheritParams map_trades
#'
#' @return `map_bucket_trades` returns a `data.frame` containing:
#' \itemize{
#'  \item{timestamp: }{POSIXct. Date and time of trade.}
#'  \item{symbol: }{character. Instrument ticker.}
#'  \item{open: }{numeric. Opening price for the bucket.}
#'  \item{high: }{numeric. Highest price in the bucket.}
#'  \item{low: }{numeric. Lowest price in the bucket.}
#'  \item{close: }{numeric. Closing price of the bucket.}
#'  \item{trades: }{numeric. Number of trades executed within the bucket.}
#'  \item{volume: }{numeric. Volume in USD.}
#'  \item{vwap: }{numeric. Volume weighted average price.}
#'  \item{lastSize: }{numeric. Size of the last trade executed.}
#'  \item{turnover: }{numeric. How many satoshi were exchanged.}
#'  \item{homeNotional: }{numeric. BTC value of the bucket.}
#'  \item{foreignNotional: }{numeric. USD value of the bucket.}
#' }
#'
#' @examples
#' \donttest{
#' # Get hourly bucketed trade data between 2020-01-01 and 2020-02-01
#'
#' map_bucket_trades(
#'   start_date = "2020-01-01",
#'   end_date = "2020-02-01",
#'   binSize = "1h"
#' )
#' }
#'
#' @export
map_bucket_trades <- function(
  start_date = "2015-09-25 13:00:00",
  end_date = now(tzone = "UTC"),
  binSize = "1d",
  symbol = "XBTUSD",
  partial = "false",
  filter = NULL,
  use_auth = FALSE,
  verbose = FALSE
) {
  check_internet()

  stop_if_not(
    binSize %in% c("1m", "5m", "1h", "1d"),
    msg = "binSize must be 1m, 5m, 1h or 1d"
  )

  stop_if(
    is.null(start_date),
    msg = "Please use a valid start date"
  )


  if (!is.null(start_date)) {
    stop_if(
      date_check(start_date),
      .p = isFALSE,
      msg = "Invalid date format. Please use 'yyyy-mm-dd' or 'yyyy-mm-dd hh:mm:ss'"
    )
  }

  if (!is.null(end_date)) {
    stop_if(
      date_check(end_date),
      .p = isFALSE,
      msg = "Invalid date format. Please use 'yyyy-mm-dd' or 'yyyy-mm-dd hh:mm:ss'"
    )
  }


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

    if (vd$timestamp > start_date) {
      start_date <- vd$timestamp
    }

    stop_if(
      start_date > end_date,
      msg = "Make sure start date is before end date"
    )
  }


  by <- switch(
    binSize,
    "1d" = "1000 days",
    "1h" = "1000 hours",
    "5m" = "5000 min",
    "1m" = "1000 min"
  )


  breaks <- seq(start_date, end_date, by = by)

  pb <- progress_bar$new(
    format = "Progress[:bar] :current/:total  eta: ~:eta",
    total = length(breaks),
    width = 70,
    clear = FALSE
  )

  if (isTRUE(use_auth)) {
    delay <- 1
    requests <- 60
  } else {
    delay <- 2
    requests <- 30
  }

  limit_bucket_trades <- slowly(bucket_trades, rate_delay(delay))

  if (verbose == TRUE) {
    pb$message(paste0("\n", length(breaks), " API requests generated."))
    pb$message(paste("Current limit is", requests, "requests per minute"))
  }

  res <- map_dfr(breaks, ~ {
    if (verbose == TRUE) {
      pb$tick()
    }
    limit_bucket_trades(
      startTime = .x,
      binSize = binSize,
      reverse = "false",
      count = 1000,
      partial = partial,
      symbol = symbol,
      filter = filter,
      use_auth = use_auth
    )
  }) %>%
    mutate(timestamp = as_datetime(.data$timestamp)) %>%
    filter(.data$timestamp <= end_date)

  return(res)
}

#' Bucket trade data over an extended period (testnet)
#'
#' `tn_map_bucket_trades()` uses `purrr::map_dfr` to execute multiple API calls.
#' This is useful when the data you want to return exceeds the maximum 1000 row response limit,
#' but do not want to have to manually call [tn_bucket_trades()] repeatedly.
#'
#' @seealso [map_bucket_trades()] for more information.
#'
#' @inheritParams map_bucket_trades
#'
#' @references \url{https://testnet.bitmex.com/api/explorer/#!/Trade/Trade_getBucketed}
#'
#'
#' @examples
#' \donttest{
#' # Get hourly bucketed trade data between 2020-01-01 and 2020-02-01
#'
#' tn_map_bucket_trades(
#'   start_date = "2020-01-01",
#'   end_date = "2020-02-01",
#'   binSize = "1h"
#' )
#' }
#' @export
tn_map_bucket_trades <- function(
  start_date = "2015-09-25 13:00:00",
  end_date = now(tzone = "UTC"),
  binSize = "1d",
  symbol = "XBTUSD",
  partial = "false",
  filter = NULL,
  use_auth = FALSE,
  verbose = FALSE
) {
  check_internet()

  stop_if_not(
    binSize %in% c("1m", "5m", "1h", "1d"),
    msg = "binSize must be 1m, 5m, 1h or 1d"
  )

  stop_if(
    is.null(start_date),
    msg = "Please use a valid start date"
  )


  if (!is.null(start_date)) {
    stop_if(
      date_check(start_date),
      .p = isFALSE,
      msg = "Invalid date format. Please use 'yyyy-mm-dd' or 'yyyy-mm-dd hh:mm:ss'"
    )
  }

  if (!is.null(end_date)) {
    stop_if(
      date_check(end_date),
      .p = isFALSE,
      msg = "Invalid date format. Please use 'yyyy-mm-dd' or 'yyyy-mm-dd hh:mm:ss'"
    )
  }


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

    if (vd$timestamp > start_date) {
      start_date <- vd$timestamp
    }

    stop_if(
      start_date > end_date,
      msg = "Make sure start date is before end date"
    )
  }


  by <- switch(
    binSize,
    "1d" = "1000 days",
    "1h" = "1000 hours",
    "5m" = "5000 min",
    "1m" = "1000 min"
  )


  breaks <- seq(start_date, end_date, by = by)

  pb <- progress_bar$new(
    format = "Progress[:bar] :current/:total  eta: ~:eta",
    total = length(breaks),
    width = 70,
    clear = FALSE
  )

  if (isTRUE(use_auth)) {
    delay <- 1
    requests <- 60
  } else {
    delay <- 2
    requests <- 30
  }

  limit_bucket_trades <- slowly(tn_bucket_trades, rate_delay(delay))

  if (verbose == TRUE) {
    pb$message(paste0("\n", length(breaks), " API requests generated."))
    pb$message(paste("Current limit is", requests, "requests per minute"))
  }

  res <- map_dfr(breaks, ~ {
    if (verbose == TRUE) {
      pb$tick()
    }
    limit_bucket_trades(
      startTime = .x,
      binSize = binSize,
      reverse = "false",
      count = 1000,
      partial = partial,
      symbol = symbol,
      filter = filter,
      use_auth = use_auth
    )
  }) %>%
    mutate(timestamp = as_datetime(.data$timestamp)) %>%
    filter(.data$timestamp <= end_date)

  return(res)
}
