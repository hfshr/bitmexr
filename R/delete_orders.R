
#' Delete order
#'
#' Delete an order that has been placed.
#'
#' @param orderID string. Order ID.
#' @param text string. Optional cancellation annotation. e.g. 'Spread Exceeded'.
#' @param clOrdID string. Optional client ID set when placing an order.
#' @inheritParams place_order
#'
#'
#'
#' @export
delete_order <- function(testnet = TRUE,
                         orderID = NULL,
                         clOrdID = NULL,
                         text = NULL){


  args <- list(orderID = orderID,
               clOrdID = clOrdID,
               text = text)

  json_body <- toJSON(compact(args), auto_unbox = TRUE)

  expires <- as.character(as.integer(now() + 10))

  if (isTRUE(testnet)) {

    url <- testnet_url
    key <-  Sys.getenv("bitmex_apikey_test")
    secret <- Sys.getenv("bitmex_apisecret_test")

  } else {

    url <- live_url
    key <-  Sys.getenv("bitmex_apikey")
    secret <- Sys.getenv("bitmex_apisecret")

  }

    sig <- gen_signature(
      secret = secret,
      verb = "DELETE",
      url = "/api/v1/order",
      data = json_body
    )

    res <- DELETE(
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

#' Delete all orders
#'
#' Delete all orders that have been placed.
#'
#' @inheritParams delete_order
#' @param symbol string. Optional symbol. If provided, only cancels orders for that symbol.
#' @param filter string. Optional filter for cancellation. Use to only cancel some orders,
#' e.g. '{"side": "Buy"}'.
#'
#'
#' @export
delete_all_orders <- function(symbol = NULL,
                              filter = NULL,
                              text = NULL,
                              testnet = TRUE){

  args <- list(symbol = symbol,
               filter = filter,
               text = text)

  json_body <- toJSON(compact(args), auto_unbox = TRUE)

  if (isTRUE(testnet)) {

    url <- testnet_url
    key <- Sys.getenv("bitmex_apikey_test")
    secret <- Sys.getenv("bitmex_apisecret_test")

  } else {

    url <- live_url
    key <- Sys.getenv("bitmex_apikey")
    secret <- Sys.getenv("bitmex_apisecret")

  }

  expires <- as.character(as.integer(now() + 10))

  sig <- gen_signature(
    secret = secret,
    verb = "DELETE",
    url = "/api/v1/order/all",
    data = json_body
  )

  res <- DELETE(
    paste0(url, "/order/all"),
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

  if (length(result) == 0) {
    message("No orders to cancel")
  } else {

    return(result)

  }

}
