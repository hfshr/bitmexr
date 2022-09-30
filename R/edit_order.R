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
#' @return A `data.frame` with information about the amended order. See
#' \url{https://www.bitmex.com/api/explorer/#!/Order/Order_amend} for more information.
#'
#' @examples
#' \dontrun{
#'
#' # place an order
#'
#' place_order(symbol = "XBTUSD", price = 5000, orderQty = 100, clOrdID = "myorderid")
#'
#' # edit the order
#'
#' edit_order(origClOrID = "myorderid", orderQty = 200)
#' }
#'
#' @export
edit_order <- function(
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

  expires <- format(as.integer(now() + 10))

  sig <- gen_signature(
    secret = Sys.getenv("bitmex_apisecret"),
    verb = "PUT",
    url = "/api/v1/order",
    data = json_body
  )

  res <- PUT(
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

  result <- fromJSON(content(res, "text"))
}


#' Edit an order (testnet)
#'
#' Edit an order that has been placed with the testnet API.
#'
#' @inheritParams edit_order
#'
#' @return A `data.frame` with information about the amended order. See
#' \url{https://www.bitmex.com/api/explorer/#!/Order/Order_amend} for more information.
#'
#' @examples
#' \dontrun{
#'
#' # place an order
#'
#' tn_place_order(symbol = "XBTUSD", price = 5000, orderQty = 100, clOrdID = "myorderid")
#'
#' # edit the order
#'
#' tn_edit_order(origClOrID = "myorderid", orderQty = 200)
#' }
#'
#' @export
tn_edit_order <- function(
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

  expires <- format(as.integer(now() + 10))

  sig <- gen_signature(
    secret = Sys.getenv("testnet_bitmex_apisecret"),
    verb = "PUT",
    url = "/api/v1/order",
    data = json_body
  )

  res <- PUT(
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

  result <- fromJSON(content(res, "text"))
}