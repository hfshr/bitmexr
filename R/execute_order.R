#' Place an order
#'
#' Place an order using the Bitmex API. Requires API key.
#'
#' @param symbol string. Instrument symbol. e.g. 'XBTUSD'.
#' @param side string. Order side. Valid options: Buy, Sell. Defaults to 'Buy' unless `orderQty`is negative.
#' @param orderQty double. Order quantity in units of the instrument (i.e. contracts).
#' @param price double. Optional limit price for 'Limit', 'StopLimit', and 'LimitIfTouched' orders.
#' @param displayQty double. Optional quantity to display in the book. Use 0 for a fully hidden order.
#' @param stopPx double. Optional trigger price for 'Stop', 'StopLimit', 'MarketIfTouched', and 'LimitIfTouched' orders.
#' Use a price below the current price for stop-sell orders and buy-if-touched orders.
#' Use `execInst` of 'MarkPrice' or 'LastPrice' to define the current price used for triggering.
#' @param clOrdID string. Optional Client Order ID. This clOrdID will come back on the order and any related executions.
#' @param pegOffsetValue string. Optional trailing offset from the current price for 'Stop', 'StopLimit', '
#' MarketIfTouched', and 'LimitIfTouched' orders; use a negative offset for stop-sell orders and buy-if-touched orders.
#' Optional offset from the peg price for 'Pegged' orders.
#' @param pegPriceType string. Optional peg price type.
#' Valid options: LastPeg, MidPricePeg, MarketPeg, PrimaryPeg, TrailingStopPeg.
#' @param ordType string. Order type. Valid options: Market, Limit, Stop, StopLimit, MarketIfTouched, LimitIfTouched, Pegged.
#' Defaults to 'Limit' when `price` is specified. Defaults to 'Stop' when `stopPx` is specified.
#' Defaults to 'StopLimit' when `price` and `stopPx` are specified.
#' @param timeInForce string. Time in force. Valid options: Day, GoodTillCancel, ImmediateOrCancel, FillOrKill.
#' Defaults to 'GoodTillCancel' for 'Limit', 'StopLimit', and 'LimitIfTouched' orders.
#' @param execInst string. Optional execution instructions. Valid options: ParticipateDoNotInitiate,
#' AllOrNone, MarkPrice, IndexPrice, LastPrice, Close, ReduceOnly, Fixed.
#' 'AllOrNone' instruction requires `displayQty` to be 0. 'MarkPrice', 'IndexPrice' or 'LastPrice'
#' instruction valid for 'Stop', 'StopLimit', 'MarketIfTouched', and 'LimitIfTouched' orders.
#' @param text string. Optional order annotation. e.g. 'Take profit'.
#'
#' @return A tibble containing information about the trade that has been placed.
#' See \url{https://www.bitmex.com/api/explorer/#!/Order/Order_new} for more details.
#'
#'
#' @examples
#' \dontrun{
#'
#' # place limit order to Buy 10 contracts at a specific price
#' place_order(symbol = "XBTUSD", price = 6000, orderQty = 10)
#' }
#'
#' @export
place_order <- function(
  symbol = NULL,
  side = NULL,
  orderQty = NULL,
  price = NULL,
  displayQty = NULL,
  stopPx = NULL,
  clOrdID = NULL,
  pegOffsetValue = NULL,
  pegPriceType = NULL,
  ordType = NULL,
  timeInForce = NULL,
  execInst = NULL,
  text = NULL
) {
  check_internet()

  args <- list(
    symbol = symbol,
    side = side,
    orderQty = orderQty,
    price = price,
    displayQty = displayQty,
    stopPx = stopPx,
    clOrdID = clOrdID,
    pegOffsetValue = pegOffsetValue,
    pegPriceType = pegPriceType,
    ordType = ordType,
    timeInForce = timeInForce,
    execInst = execInst,
    text = text
  )

  json_body <- toJSON(compact(args), auto_unbox = TRUE)

  expires <- format(as.integer(now() + 10))

  sig <- gen_signature(
    secret = Sys.getenv("bitmex_apisecret"),
    verb = "POST",
    url = "/api/v1/order",
    data = json_body
  )

  res <- POST(
    paste0(live_url, "/order"),
    body = json_body,
    encode = "json",
    content_type_json(),
    add_headers(.headers = c(
      "api-expires" = expires,
      "api-key" = Sys.getenv("bitmex_apikey"),
      "api-signature" = sig
    ))
  )

  check_status(res)

  result <- fromJSON(content(res, "text")) %>%
    map(function(x) {
      ifelse(is.null(x), NA, x)
    }) %>%
    as_tibble() %>%
    mutate_all(~ ifelse(. == "", NA, .))

  return(result)
}

#' Place an order (testnet)
#'
#' Place an order using the Bitmex testnet API. Requires testnet API key.
#'
#' @inheritParams place_order
#'
#' @return Returns a `tibble` containing information about the trade that has been placed.
#' See \url{https://testnet.bitmex.com/api/explorer/#!/Order/Order_new} for more details.
#'
#' @examples
#' \dontrun{
#' # place limit order to Buy at specific price
#' tn_place_order(symbol = "XBTUSD", price = 6000, orderQty = 10)
#' }
#'
#' @export
tn_place_order <- function(
  symbol = NULL,
  side = NULL,
  orderQty = NULL,
  price = NULL,
  displayQty = NULL,
  stopPx = NULL,
  clOrdID = NULL,
  pegOffsetValue = NULL,
  pegPriceType = NULL,
  ordType = NULL,
  timeInForce = NULL,
  execInst = NULL,
  text = NULL
) {
  check_internet()

  args <- list(
    symbol = symbol,
    side = side,
    orderQty = orderQty,
    price = price,
    displayQty = displayQty,
    stopPx = stopPx,
    clOrdID = clOrdID,
    pegOffsetValue = pegOffsetValue,
    pegPriceType = pegPriceType,
    ordType = ordType,
    timeInForce = timeInForce,
    execInst = execInst,
    text = text
  )

  json_body <- toJSON(compact(args), auto_unbox = TRUE)

  expires <- format.libraryIQR()(as.integer(now() + 10))

  sig <- gen_signature(
    secret = Sys.getenv("testnet_bitmex_apisecret"),
    verb = "POST",
    url = "/api/v1/order",
    data = json_body
  )

  res <- POST(
    paste0(testnet_url, "/order"),
    body = json_body,
    encode = "json",
    content_type_json(),
    add_headers(.headers = c(
      "api-expires" = expires,
      "api-key" = Sys.getenv("testnet_bitmex_apikey"),
      "api-signature" = sig
    ))
  )

  check_status(res)

  result <- fromJSON(content(res, "text")) %>%
    map(function(x) {
      ifelse(is.null(x), NA, x)
    }) %>%
    as_tibble() %>%
    mutate_all(~ ifelse(. == "", NA, .))

  return(result)
}