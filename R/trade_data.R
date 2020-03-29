#'  Individual trade data
#'
#' @param symbol Instrument symbol. You can also send a timeframe, e.g. XBT:quarterly
#' @param filter Generic table filter. Send JSON key/value pairs, such as {"key": "value"}. You can key on individual fields, and do more advanced querying on timestamps.
#' @param columns Array of column names to fetch. If omitted, will return all columns.
#' @param count Number of results to fetch.
#' @param start Starting point for results.
#' @param reverse If true, will sort results newest first.
#' @param startTime Starting date filter for results.
#' @param endTime Ending date filter for results.
#'
#' @importFrom attempt stop_if
#' @importFrom purrr compact
#' @importFrom httr GET content
#' @importFrom dplyr bind_rows
#' @importFrom magrittr "%>%"
#'
#'
#' @export
#' @rdname individual_trades
#'
#' @return `individual_trades` returns a tibble containing data for executed trades
#'


individual_trades <- function(symbol = "XBT",
                              filter = NULL,
                              columns = NULL,
                              count = 1000,
                              start = NULL,
                              reverse = "true",
                              startTime = NULL,
                              endTime = NULL){

  args <- list(symbol = symbol,
               filter = filter,
               columns =columns,
               count = count,
               start = start,
               reverse =reverse,
               startTime = startTime,
               endTime =endTime)

  check_internet()

  res <- GET(trade_url, query = compact(args))

  check_status(res)

  result <- content(res, "parsed") %>%
    bind_rows()



}



#' Bucketed trade data
#'
#' @param binSize Time interval to bucket by. Available options: 1m,5m,1h,1d
#' @param partial If true, will send in-progress (incomplete) bins for the current time period.
#' @param symbol Instrument symbol. You can also send a timeframe, e.g. XBT:quarterly
#' @param filter Generic table filter. Send JSON key/value pairs, such as {"key": "value"}. You can key on individual fields, and do more advanced querying on timestamps.
#' @param columns Array of column names to fetch. If omitted, will return all columns.
#' @param count Number of results to fetch.
#' @param start Starting point for results.
#' @param reverse If true, will sort results newest first.
#' @param startTime Starting date filter for results.
#' @param endTime Ending date filter for results.
#'
#'
#' @export
#' @rdname bucket_trades
#'
#' @return `bucket_trades` returns a tibble containing open high low close data for the specified time interval
#'


bucket_trades <- function(binSize = "1m",
                            partial = NULL,
                            symbol = "XBT",
                            filter = NULL,
                            columns = NULL,
                            count = 1000,
                            start = NULL,
                            reverse = "true",
                            startTime = NULL,
                            endTime = NULL){

  args <- list(binSize = binSize,
               partial = partial,
               symbol = symbol,
               filter = filter,
               columns =columns,
               count = count,
               start = start,
               reverse =reverse,
               startTime = startTime,
               endTime =endTime)

  check_internet()

  stop_if(!binSize %in% c("1m", "5m", "1h", "1d"),
          msg = "binSize must be 1m, 5m, 1h or 1d")

  stop_if(count > 1000,
          msg = "Maximum reponse per request is 1000")


  res <- GET(trade_bucketed_url, query = compact(args))

  check_status(res)

  result <- content(res, "parsed") %>%
    bind_rows()


}


