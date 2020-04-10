
check_internet <- function(){
  stop_if_not(.x = has_internet(), msg = "Please check your internet connection")
}


check_status <- function(res){
  stop_if_not(.x = status_code(res),
              .p = ~ .x == 200,
              msg = "The API returned an error")
}

rate_limit <- function(url){

  headers(GET(url)) %>%
    pluck(limit = "x-ratelimit-limit")

}

date_check <- function(x) tryCatch(as_datetime(x), warning = function(w) FALSE)

base_url <- "https://www.bitmex.com/api/v1/"
trade_url <- "https://www.bitmex.com/api/v1/trade"
trade_bucketed_url <- "https://www.bitmex.com/api/v1/trade/bucketed"





