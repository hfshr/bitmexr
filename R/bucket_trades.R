#' Bucketed trade data
#'
#' `bucket_trades()` retrieves open high low close (OHLC) data for the specified symbol/time frame.
#'
#' The API will only return 1000 rows per call. If the desired time frame requires more than one API call,
#' consider using [map_bucket_trades()].
#'
#' @references url{https://www.bitmex.com/api/explorer/#!/Trade/Trade_getBucketed}
#'
#' @family map_bucket_trades
#'
#' @param binSize character string.
#' The time interval to bucket by, must be one of: `"1m"`, `"5m"`, `"1h"` or `"1d"`.
#' @param partial character string. Either `"true"` of `"false"`.
#' If `"true"`, will send in-progress (incomplete) bins for the current time period.
#' @inheritParams trades
#'
#' @return `bucket_trades()` returns a `data.frame` containing:
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
#'
#' # Return most recent data for symbol `"ETHUSD"` for 1 hour buckets
#'
#' bucket_trades(
#'   binSize = "1h",
#'   symbol = "ETHUSD",
#'   count = 10
#' )
#' }
#' @export
bucket_trades <- function(
  binSize = "1m",
  partial = "false",
  symbol = "XBTUSD",
  count = 1000,
  reverse = "true",
  filter = NULL,
  columns = NULL,
  start = NULL,
  startTime = NULL,
  endTime = NULL,
  use_auth = FALSE
) {
  check_internet()

  stop_if_not(
    symbol %in% as,
    msg = paste(
      "Please use one of the available symbols:",
      paste(as, collapse = ", ")
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

  ua <- user_agent("https://github.com/hfshr/bitmexr")

  if (isTRUE(use_auth)) {
    prep_url <- modify_url(paste0(live_url, "/trade/bucketed"), query = compact(args))

    expires <- as.character(as.integer(now() + 10))

    sig <- gen_signature(
      secret = Sys.getenv("bitmex_apisecret"),
      verb = "GET",
      url = gsub("https://www.bitmex.com", "", prep_url),
      data = ""
    )

    res <- GET(
      paste0(live_url, "/trade/bucketed"),
      ua,
      query = compact(args),
      add_headers(.headers = c(
        "api-expires" = expires,
        "api-key" = Sys.getenv("bitmex_apikey"),
        "api-signature" = sig
      ))
    )
  } else {
    res <- GET(paste0(live_url, "/trade/bucketed"), ua, query = compact(args))
  }

  check_status(res)

  limits <- rate_limit(res)

  if (isTRUE(limits[["remaining"]] == 2)) {
    warning(
      "\nRate limit nearing max - Pausing for 60 seconds to reset limit.\n",
      immediate. = TRUE
    )

    Sys.sleep(60)
  }

  result <- jsonlite::fromJSON(content(res, "text")) %>%
    mutate(timestamp = as_datetime(.data$timestamp))

  stop_if(
    length(result) == 0,
    msg = "No result returned"
  )

  return(result)
}


#' Bucketed trade data (testnet)
#'
#' `tn_bucket_trades()` retrieves open high low close (OHLC) data for the specified symbol/time frame.
#'
#' The API will only return 1000 rows per call. If the desired time frame requires more than one API call,
#' consider using [tn_map_bucket_trades()].
#'
#' @inheritParams tn_trades
#' @inheritParams bucket_trades
#'
#' @examples
#' \donttest{
#'
#' # Return most recent data for symbol `"ETHUSD"` for 1 hour buckets
#'
#' tn_bucket_trades(
#'   binSize = "1h",
#'   symbol = "ETHUSD",
#'   count = 10
#' )
#' }
#' @export
tn_bucket_trades <- function(
  binSize = "1m",
  partial = "false",
  symbol = "XBTUSD",
  count = 1000,
  reverse = "true",
  filter = NULL,
  columns = NULL,
  start = NULL,
  startTime = NULL,
  endTime = NULL,
  use_auth = FALSE
) {
  check_internet()

  stop_if_not(
    symbol %in% as,
    msg = paste(
      "Please use one of the available symbols:",
      paste(as, collapse = ", ")
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

  ua <- user_agent("https://github.com/hfshr/bitmexr")

  if (isTRUE(use_auth)) {
    prep_url <- modify_url(paste0(testnet_url, "/trade/bucketed"), query = compact(args))

    expires <- as.character(as.integer(now() + 10))

    sig <- gen_signature(
      secret = Sys.getenv("testnet_bitmex_apisecret"),
      verb = "GET",
      url = gsub("https://testnet.bitmex.com", "", prep_url),
      data = ""
    )

    res <- GET(
      paste0(testnet_url, "/trade/bucketed"),
      ua,
      query = compact(args),
      add_headers(.headers = c(
        "api-expires" = expires,
        "api-key" = Sys.getenv("testnet_bitmex_apikey"),
        "api-signature" = sig
      ))
    )
  } else {
    res <- GET(paste0(testnet_url, "/trade/bucketed"), ua, query = compact(args))
  }


  check_status(res)

  limits <- rate_limit(res)

  if (isTRUE(limits[["remaining"]] == 2)) {
    warning(
      "\nRate limit nearing max - Pausing for 60 seconds to reset limit.\n",
      immediate. = TRUE
    )

    Sys.sleep(60)
  }

  result <- jsonlite::fromJSON(content(res, "text")) %>%
    mutate(timestamp = as_datetime(.data$timestamp))

  stop_if(
    length(result) == 0,
    msg = "No result returned"
  )

  return(result)
}
