order_book <- function(symbol = "XBT",
                       depth = NULL){

  args <- list(symbol = symbol,
               depth = depth)

  check_internet()

  res <- GET(orderbook_url, query = compact(args))

  check_status(res)

  result <- tibble(data = content(res, "parsed")) %>%
    unnest_wider(data)
}
