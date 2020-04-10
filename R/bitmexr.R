#' bitmexr: R Client for the BitMEX Exchange
#'
#' @description
#' bitmexr provides tools to obtain price/trade data from
#' the BitMEX cryptocurrency derivatives exchange https://www.bitmex.com/.
#'
#' @section See Also:
#'  * https://www.bitmex.com/app/apiOverview
#'  * https://www.bitmex.com/api/explorer/
#'
#'
#' @importFrom progress progress_bar
#' @importFrom attempt stop_if stop_if_not
#' @importFrom purrr compact map_dfr pluck slowly rate_delay
#' @importFrom httr GET content status_code headers
#' @importFrom dplyr bind_rows tibble
#' @importFrom magrittr "%>%"
#' @importFrom jsonlite fromJSON
#' @importFrom lubridate as_datetime now is.timepoint
#' @importFrom attempt stop_if_not
#' @importFrom curl has_internet
#' @importFrom utils flush.console menu
#'
#'
#' @docType package
#' @name bitmexr
#' @md
NULL
