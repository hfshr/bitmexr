
check_internet <- function() {
  stop_if_not(.x = has_internet(), msg = "Please check your internet connection")
}


check_status <- function(res) {
  resp <- jsonlite::fromJSON(content(res, "text"))

  stop_if_not(
    .x = status_code(res),
    .p = ~ .x == 200,
    msg = paste("The API returned an error: ", resp$error$message)
  )
}

rate_limit <- function(res){

  header <- res %>%
    headers()

  limits <- list(limit = as.numeric(header[["x-ratelimit-limit"]]),
      remaining = as.numeric(header[["x-ratelimit-remaining"]]),
      reset = as_datetime(as.numeric(header[["x-ratelimit-reset"]])))

  return(limits)
}

date_check <- function(x) tryCatch(as_datetime(x), warning = function(w) FALSE)

trade_warning <- function(start, end) {
  if (difftime(end, start, units = "days") > 1) {
    choice <- menu(
      choices = c("yes", "no"),
      title = paste(
        "There are potentially a large number of trades between the time points you have chosen.",
        "\nIt may be more efficient to use 'map_bucket_trades' instead.",
        "\nAre you sure you want to continue?"
      )
    )

    stop_if(
      choice == 2,
      msg = "Qutting function"
    )
  }
}


#' Available symbols
#' @return A character vector of currently available symbols to be used in the 'symbol' argument
#' @examples
#' \dontrun{
#' available_symbols()
#' }
#' @export
available_symbols <- function() {
  jsonlite::fromJSON(content(GET("https://www.bitmex.com/api/bitcoincharts"), "text"))$all
}

#' Start date of data availability for valid symbols
#'
#' Can pass in a symbol from \code{available_symbols()} or no symbol to return dates for all valid symbols
#' @returns A data.frame containing the symbol and date from which data is available
#' @param symbol symbol to find start date for, or NULL for all available symbols
#'
#' @examples
#' \dontrun{
#' valid_dates("XBTUSD")
#'
#' valid_dates(NULL)
#' }
#' @export
valid_dates <- function(symbol = NULL) {
  if (is.null(symbol)) {
    limit_trades <- slowly(trades, rate_delay(2))
    dates <- map_dfr(available_symbols(), ~ limit_trades(.x, count = 1, reverse = "false")) %>%
      select(.data$symbol, .data$timestamp) %>%
      mutate(timestamp = as_datetime(.data$timestamp))
  } else {
    dates <- trades(symbol, count = 1, reverse = "false") %>%
      select(.data$symbol, .data$timestamp) %>%
      mutate(timestamp = as_datetime(.data$timestamp))
  }
  return(dates)
}

base_url <- "https://www.bitmex.com/api/v1/"
trade_url <- "https://www.bitmex.com/api/v1/trade"
trade_bucketed_url <- "https://www.bitmex.com/api/v1/trade/bucketed"
