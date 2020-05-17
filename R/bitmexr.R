#' bitmexr: R Client for the BitMEX Exchange
#'
#' @description
#' bitmexr provides tools to obtain price/trade data from
#' the BitMEX cryptocurrency derivatives exchange https://www.bitmex.com/.
#'
#'
#' @section See Also:
#'  * https://www.bitmex.com/app/apiOverview
#'  * https://www.bitmex.com/api/explorer/
#'
#'
#' @importFrom progress progress_bar
#' @importFrom attempt stop_if stop_if_not message_if
#' @importFrom purrr compact map_dfr pluck slowly rate_delay
#' @importFrom httr GET content status_code headers user_agent modify_url add_headers
#' @importFrom httr POST PUT DELETE content_type_json
#' @importFrom dplyr bind_rows tibble select mutate filter
#' @importFrom magrittr "%>%"
#' @importFrom jsonlite fromJSON toJSON
#' @importFrom lubridate as_datetime now is.timepoint
#' @importFrom attempt stop_if_not
#' @importFrom curl has_internet
#' @importFrom utils flush.console menu
#' @importFrom rlang .data
#' @importFrom digest hmac
#' @importFrom stringr str_glue
#'
#' @docType package
#' @name bitmexr
#' @md
NULL
