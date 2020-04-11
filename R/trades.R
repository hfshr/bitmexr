#' Trade data
#'
#' \code{trades()} retrieves information regarding individual trades that have taken place on the
#' exchange for the given symbol / time frame.
#'
#'
#' @param symbol Instrument symbol. Use \code{available_symbols()} to see valid symbols.
#' @param filter Generic table filter. Send JSON key/value pairs, such as "\{'key':'value'\}".
#' @param columns Array of column names to fetch. If omitted, will return all columns.
#' @param count Number of results to fetch. Maximum of 1000 (the default) per request.
#' @param start Starting point for results.
#' @param reverse If true, will sort results newest first (default = "true").
#' @param startTime Starting date filter for results.
#' @param endTime Ending date filter for results.
#'
#'
#' @return \code{trades()} returns a data.frame containing information for executed trades for the given arguments.
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
#'
#' @family map_trades
#'
#' @references \href{https://www.bitmex.com/api/explorer/#!/Trade/Trade_get}{API Documentation}
#'
#' @examples
#' \dontrun{
#' # Return 1000 most recent trades for symbol "XBTUSD".
#' trades(symbol = "XBTUSD")
#'
#' # Use filter for very specific values: Return trade data executed at 12:15.
#' trades(symbol = "XBTUSD", filter = "{'timestamp.minute':'12:15'}")
#'
#' # Also possible to combine more than one filter.
#' trades(symbol = "XBTUSD", filter = "{'timestamp.minute':'12:15', 'size':10000}")
#' }
#'
#' @export

trades <- function(
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

  res <- GET(trade_url, query = compact(args))

  check_status(res)

  result <- jsonlite::fromJSON(content(res, "text")) %>%
    mutate(timestamp = as_datetime(.data$timestamp))

  return(result)
}
