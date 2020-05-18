#' Place an order
#'
#' Place an order using the Bitmex API. Requires API key.
#'
#' @param testnet logical. Use `TRUE` to query the BitMEX testnet platform.
#' Set to `FALSE` by default.
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
#' @export
place_order <- function(
  testnet = FALSE,
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

  if (isTRUE(testnet)) {
    url <- testnet_url
    key <- Sys.getenv("bitmex_apikey_testnet")
    secret <- Sys.getenv("bitmex_apisecret_testnet")
  } else {
    url <- live_url
    key <- Sys.getenv("bitmex_apikey")
    secret <- Sys.getenv("bitmex_apisecret")
  }

  expires <- as.character(as.integer(now() + 10))

  sig <- gen_signature(
    secret = secret,
    verb = "POST",
    url = "/api/v1/order",
    data = json_body
  )

  res <- POST(
    paste0(url, "/order"),
    body = json_body,
    encode = "json",
    content_type_json(),
    add_headers(.headers = c(
      "api-expires" = expires,
      "api-key" = key,
      "api-signature" = sig
    ))
  )

  check_status(res)

  result <- fromJSON(content(res, "text"))

  return(result)
}
