#' Cancel order
#'
#' Cancel an order that has been placed.
#'
#' @param orderID string. Order ID.
#' @param text string. Optional cancellation annotation. e.g. 'Spread Exceeded'.
#' @param clOrdID string. Optional client ID set when placing an order.
#'
#' @return Returns a `data.frame` with details about the order that was cancelled.
#' See \url{https://www.bitmex.com/api/explorer/#!/Order/Order_cancel} for more information.
#'
#' @examples
#' \dontrun{
#' # Cancel an order
#' cancel_order(clOrdID = "myorderid")
#' }
#'
#' @export
cancel_order <- function(
  orderID = NULL,
  clOrdID = NULL,
  text = NULL
) {
  check_internet()

  args <- list(
    orderID = orderID,
    clOrdID = clOrdID,
    text = text
  )

  json_body <- toJSON(compact(args), auto_unbox = TRUE)

  expires <- as.character(as.integer(now() + 10))

  sig <- gen_signature(
    secret = Sys.getenv("bitmex_apisecret"),
    verb = "DELETE",
    url = "/api/v1/order",
    data = json_body
  )

  res <- DELETE(
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

  return(result)
}

#' Cancel order (testnet)
#'
#' Cancel an order that has been placed using the testnet API.
#'
#' @param orderID string. Order ID.
#' @param text string. Optional cancellation annotation. e.g. 'Spread Exceeded'.
#' @param clOrdID string. Optional client ID set when placing an order.
#'
#' @return Returns a `data.frame` with details about the order that was cancelled.
#' See \url{https://www.bitmex.com/api/explorer/#!/Order/Order_cancel} for more information.
#'
#' @examples
#' \dontrun{
#' # Cancel an order
#' tn_cancel_order(clOrdID = "myorderid")
#' }
#'
#' @export
tn_cancel_order <- function(
  orderID = NULL,
  clOrdID = NULL,
  text = NULL
) {
  check_internet()

  args <- list(
    orderID = orderID,
    clOrdID = clOrdID,
    text = text
  )

  json_body <- toJSON(compact(args), auto_unbox = TRUE)

  expires <- as.character(as.integer(now() + 10))

  sig <- gen_signature(
    secret = Sys.getenv("testnet_bitmex_apisecret"),
    verb = "DELETE",
    url = "/api/v1/order",
    data = json_body
  )

  res <- DELETE(
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

  return(result)
}

#' Cancel all orders
#'
#' Cancel all orders that have been placed for a specific symbol,
#' or use a filter to select specific orders.
#'
#' @inheritParams cancel_order
#' @param symbol string. Optional symbol. If provided, only cancels orders for that symbol.
#' @param filter string. Optional filter for cancellation. Use to only cancel some orders,
#' e.g. '{"side": "Buy"}'.
#'
#' @return Returns a `data.frame` with information about the orders that were cancelled.
#' See \url{https://www.bitmex.com/api/explorer/#!/Order/Order_cancelAll} for more information.
#'
#' @examples
#' \dontrun{
#' # cancel all "Buy" orders
#' cancel_all_orders(filter = '{"side": "Buy"}')
#' }
#'
#' @export
cancel_all_orders <- function(
  symbol = NULL,
  filter = NULL,
  text = NULL
) {
  check_internet()

  args <- list(
    symbol = symbol,
    filter = filter,
    text = text
  )

  json_body <- toJSON(compact(args), auto_unbox = TRUE)

  expires <- as.character(as.integer(now() + 10))

  sig <- gen_signature(
    secret = Sys.getenv("bitmex_apisecret"),
    verb = "DELETE",
    url = "/api/v1/order/all",
    data = json_body
  )

  res <- DELETE(
    paste0(live_url, "/order/all"),
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

  if (length(result) == 0) {
    message("No orders to cancel")
  } else {
    return(result)
  }
}


#' Cancel all orders (testnet)
#'
#' Cancel all orders that have been placed using testnet API for a specific symbol,
#' or use a filter to select specific orders.
#'
#' @inheritParams cancel_order
#' @inheritParams cancel_all_orders
#'
#' @return Returns a `data.frame` with information about the orders that were cancelled.
#' See \url{https://www.bitmex.com/api/explorer/#!/Order/Order_cancelAll} for more information.
#'
#' @examples
#' \dontrun{
#' # cancel all "Buy" orders
#' tn_cancel_all_orders(filter = '{"side": "Buy"}')
#' }
#'
#' @export
tn_cancel_all_orders <- function(
  symbol = NULL,
  filter = NULL,
  text = NULL
) {
  check_internet()

  args <- list(
    symbol = symbol,
    filter = filter,
    text = text
  )

  json_body <- toJSON(compact(args), auto_unbox = TRUE)

  expires <- as.character(as.integer(now() + 10))

  sig <- gen_signature(
    secret = Sys.getenv("testnet_bitmex_apisecret"),
    verb = "DELETE",
    url = "/api/v1/order/all",
    data = json_body
  )

  res <- DELETE(
    paste0(testnet_url, "/order/all"),
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

  if (length(result) == 0) {
    message("No orders to cancel")
  } else {
    return(result)
  }
}
