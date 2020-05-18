#' Edit an order
#'
#' Edit an order that has been placed.
#'
#' @inheritParams place_order
#' @param orderID string. Order ID.
#' @param origClOrdID string. The original client order ID
#' @param clOrdID string. Optional new client order ID.
#' @param text string. Optional amend annotation. e.g. 'Adjust skew'.
#' @param leavesQty string. Optional leaves quantity in units of the instrument (i.e. contracts).
#' Useful for amending partially filled orders.
#'
#' @export
edit_order <- function(
  testnet = TRUE,
  orderID = NULL,
  origClOrdID = NULL,
  clOrdID = NULL,
  orderQty = NULL,
  leavesQty = NULL,
  price = NULL,
  stopPx = NULL,
  pegOffsetValue = NULL,
  text = NULL
) {
  check_internet()

  args <- list(
    orderID = orderID,
    origClOrdID = origClOrdID,
    clOrdID = clOrdID,
    orderQty = orderQty,
    leavesQty = leavesQty,
    price = price,
    stopPx = stopPx,
    pegOffsetValue = pegOffsetValue,
    text = text
  )

  json_body <- toJSON(compact(args), auto_unbox = TRUE)

  expires <- as.character(as.integer(now() + 10))

  if (isTRUE(testnet)) {
    url <- testnet_url
    key <- Sys.getenv("bitmex_apikey_testnet")
    secret <- Sys.getenv("bitmex_apisecret_testnet")
  } else {
    url <- live_url
    key <- Sys.getenv("bitmex_apikey")
    secret <- Sys.getenv("bitmex_apisecret")
  }


  sig <- gen_signature(
    secret = secret,
    verb = "PUT",
    url = "/api/v1/order",
    data = json_body
  )

  res <- PUT(
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
}
