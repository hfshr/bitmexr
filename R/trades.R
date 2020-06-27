#' Individual trade data
#'
#' `trades()` retrieves data regarding individual trades that have been executed on the
#' exchange.
#'
#'
#' @param symbol a character string for the instrument symbol.
#' Use [available_symbols()] to see available symbols.
#' @param count an optional integer to specify the number of rows to return.
#' Maximum of 1000 (the default) per request.
#' @param reverse an optional character string. Either `"true"` of `"false"`.
#' If `"true"`, result will be ordered with starting with the newest (defaults to `"true"`).
#' @param filter an optional character string for table filtering.
#' Send JSON key/value pairs, such as `"{'key':'value'}"`. See examples.
#' @param columns an optional character vector of column names to return.
#' If `NULL`, all columns will be returned.
#' @param start an optional integer. Can be used to specify the starting point for results.
#' @param startTime an optional character string.
#' Starting date for results in the format `"yyyy-mm-dd"` or `"yyyy-mm-dd hh-mm-ss"`.
#' @param endTime an optional character string.
#' Ending date for results in the format `"yyyy-mm-dd"` or `"yyyy-mm-dd hh-mm-ss"`.
#' @param use_auth logical. Use `TRUE` to enable authentication with API key.
#'
#'
#' @return `trades()` returns a `data.frame` containing:
#' \itemize{
#'  \item{timestamp: }{POSIXct. Date and time of trade.}
#'  \item{symbol: }{character. The instrument ticker.}
#'  \item{side: }{character. Whether the trade was buy or sell.}
#'  \item{size: }{numeric. Size of the trade.}
#'  \item{price: }{numeric. Price the trade was executed at}
#'  \item{tickDirection: }{character. Indicates if the trade price was higher, lower or the same as the previous trade price.}
#'  \item{trdMatchID: }{character. Unique trade ID.}
#'  \item{grossValue: }{numeric. How many satoshi were exchanged. 1 satoshi = 0.00000001 BTC.}
#'  \item{homeNotional: }{numeric. BTC value of the trade.}
#'  \item{foreignNotional: }{numeric. USD value of the trade.}
#' }
#'
#' @family map_trades
#'
#' @references \url{https://www.bitmex.com/api/explorer/#!/Trade/Trade_get}
#'
#' @examples
#' \dontrun{
#' # Return 1000 most recent trades for symbol "XBTUSD".
#' trades(symbol = "XBTUSD", count = 10)
#'
#' # Use filter for very specific values: Return trade data executed at 12:15.
#' trades(
#'   symbol = "XBTUSD",
#'   filter = "{'timestamp.minute':'12:15'}",
#'   count = 10
#' )
#'
#' # Also possible to combine more than one filter.
#' trades(
#'   symbol = "XBTUSD",
#'   filter = "{'timestamp.minute':'12:15', 'size':10000}",
#'   count = 10
#' )
#' }
#'
#' @export
trades <- function(
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
    count > 1000,
    msg = "Maximum reponse per request is 1000. Use map_trades for returning > 1000 rows"
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
    prep_url <- modify_url(paste0(live_url, "/trade"), query = compact(args))

    expires <- as.character(as.integer(now() + 10))

    sig <- gen_signature(
      secret = Sys.getenv("bitmex_apisecret"),
      verb = "GET",
      url = gsub("https://www.bitmex.com", "", prep_url),
      data = ""
    )

    res <- GET(
      paste0(live_url, "/trade"),
      ua,
      query = compact(args),
      add_headers(.headers = c(
        "api-expires" = expires,
        "api-key" = Sys.getenv("bitmex_apikey"),
        "api-signature" = sig
      ))
    )
  } else {
    res <- GET(paste0(live_url, "/trade"), ua, query = compact(args))
  }

  check_status(res)

  limits <- rate_limit(res)

  if (isTRUE(limits[["remaining"]] == 2)) {
    warning(
      "\nRate limit nearing max. Pausing for 60 seconds to reset limit\n",
      immediate. = TRUE
    )

    Sys.sleep(60)
  }

  result <- jsonlite::fromJSON(content(res, "text")) %>%
    mutate(timestamp = as_datetime(.data$timestamp))

  return(result)
}



#' Individual trade data (testnet)
#'
#' `tn_trades()` retrieves data regarding individual trades that have been executed on the
#' testnet exchange.
#'
#' @inheritParams trades
#'
#' @family tn_map_trades
#'
#' @references \url{https://testnet.bitmex.com/api/explorer/#!/Trade/Trade_get}
#'
#' @examples
#' \dontrun{
#' # Return 1000 most recent trades for symbol "XBTUSD".
#' tn_trades(symbol = "XBTUSD")
#'
#' # Use filter for very specific values: Return trade data executed at 12:15.
#' tn_trades(
#'   symbol = "XBTUSD",
#'   filter = "{'timestamp.minute':'12:15'}"
#' )
#'
#' # Also possible to combine more than one filter.
#' tn_trades(
#'   symbol = "XBTUSD",
#'   filter = "{'timestamp.minute':'12:15', 'size':10000}"
#' )
#' }
#'
#' @export
tn_trades <- function(
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
    count > 1000,
    msg = "Maximum reponse per request is 1000. Use map_trades for returning > 1000 rows"
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
    prep_url <- modify_url(paste0(testnet_url, "/trade"), query = compact(args))

    expires <- as.character(as.integer(now() + 10))

    sig <- gen_signature(
      secret = Sys.getenv("testnet_bitmex_apisecret"),
      verb = "GET",
      url = gsub("https://testnet.bitmex.com", "", prep_url),
      data = ""
    )

    res <- GET(
      paste0(testnet_url, "/trade"),
      ua,
      query = compact(args),
      add_headers(.headers = c(
        "api-expires" = expires,
        "api-key" = Sys.getenv("testnet_bitmex_apikey"),
        "api-signature" = sig
      ))
    )
  } else {
    res <- GET(paste0(testnet_url, "/trade"), ua, query = compact(args))
  }

  check_status(res)

  limits <- rate_limit(res)

  if (isTRUE(limits[["remaining"]] == 2)) {
    warning(
      "\nRate limit nearing max. Pausing for 60 seconds to reset limit\n",
      immediate. = TRUE
    )

    Sys.sleep(60)
  }

  result <- jsonlite::fromJSON(content(res, "text")) %>%
    mutate(timestamp = as_datetime(.data$timestamp))

  return(result)
}
