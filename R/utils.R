#' @importFrom attempt stop_if_not
#' @importFrom curl has_internet
check_internet <- function(){
  stop_if_not(.x = has_internet(), msg = "Please check your internet connexion")
}

#' @importFrom httr status_code
check_status <- function(res){
  stop_if_not(.x = status_code(res),
              .p = ~ .x == 200,
              msg = "The API returned an error")
}

trade_url <- "https://www.bitmex.com/api/v1/trade"
trade_bucketed_url <- "https://www.bitmex.com/api/v1/trade/bucketed"
orderbook_url <- "https://www.bitmex.com/api/v1/orderbook/L2"




