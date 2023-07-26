# check for internet connection
check_internet <- function() {
  stop_if_not(.x = has_internet(), msg = "Please check your internet connection")
}

# Check status, if error print error
check_status <- function(res) {
  resp <- jsonlite::fromJSON(content(res, "text"))

  stop_if_not(
    .x = status_code(res),
    .p = ~ .x == 200,
    msg = paste("The API returned an error: ", resp$error$message)
  )
}

# Get information regarding rate limits
rate_limit <- function(res) {
  header <- res %>%
    headers()

  limits <- list(
    limit = as.numeric(header[["x-ratelimit-limit"]]),
    remaining = as.numeric(header[["x-ratelimit-remaining"]]),
    reset = as_datetime(as.numeric(header[["x-ratelimit-reset"]]))
  )

  return(limits)
}

# Check is date format is correct
date_check <- function(x) tryCatch(as_datetime(x), warning = function(w) FALSE)

# Warn if attempt to use map_trades for long duration
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
      msg = "Quitting function"
    )
  }
}


#' Available symbols
#' @return A character vector of currently available symbols to be used as the `symbol` value in
#' functions within the package.
#' @examples
#' \dontrun{
#' available_symbols()
#' }
#' @export
available_symbols <- function() {
  check_internet()

  jsonlite::fromJSON(content(GET("https://www.bitmex.com/api/bitcoincharts"), "text"))$all
}

#' Start date of data availability for available symbols
#'
#' Pass in a symbol from [available_symbols()] or no symbol to return dates for all available symbols
#' @returns A data.frame containing the symbol and date from which data is available
#' @param symbol character string of the instrument
#' symbol to find start date for.
#'
#' @examples
#' \dontrun{
#' valid_dates("XBTUSD")
#' }
#' @export
valid_dates <- function(symbol = NULL) {
  check_internet()
  stop_if_not(
    .x = !is.null(symbol),
    msg = paste0(
      "Please provide a valid symbol, one of: ",
      paste(available_symbols(), collapse = ", "),
      "."
    )
  )

  dates <- trades(symbol, count = 1, reverse = "false") %>%
    select(.data$symbol, .data$timestamp) %>%
    mutate(timestamp = as_datetime(.data$timestamp))

  return(dates)
}


# Generate authentication signature
gen_signature <- function(secret, verb, url, data = "") {
  expires <- as.integer(now() + 10)

  sig <- hmac(
    secret,
    object = str_glue("{verb}{url}{expires}{data}"),
    algo = "sha256"
  )

  return(sig)
}

live_url <- "https://www.bitmex.com/api/v1"
testnet_url <- "https://testnet.bitmex.com/api/v1"