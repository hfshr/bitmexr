#' POST requests
#'
#' Use `post_bitmex()` to send POST requests. All POST requests require authentication.
#'
#' @param path string. End point for the api.
#' @param args A named list containing the
#' @param testnet logcial. Use `TRUE` access the testnet API, `FALSE` to access the live API.
#'
#' @export
post_bitmex <- function(
  path,
  args = NULL,
  testnet = FALSE
  ) {
  check_internet()

  json_body <- toJSON(compact(args), auto_unbox = TRUE)

  if (isTRUE(testnet)) {
    url <- testnet_url
    key <- Sys.getenv("bitmex_apikey_testnet")
    secret <- Sys.getenv("bitmex_apisecret_testnet")
  } else {
    url <- live_url
    key <- Sys.getenv("bitmex_apikey")
    secret <- Sys.getenv("bitmex_apisecret")
  }


  expires <- as.character(as.integer(now() + 10))

  sig <- gen_signature(
    secret = secret,
    verb = "POST",
    url = paste0("/api/v1", path),
    data = json_body
  )

  res <- POST(
    paste0(url, path),
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


#' GET requests
#'
#' Use `get_bitmex()` to send GET requests. For private endpoints, authentication is required.
#'
#' @inheritParams post_bitmex
#' @param use_auth logical. Use `TRUE` to access private endpoints.
#'
#' @examples
#' \donttest{
#' # Access a public endpoint
#' chat <- get_bitmex(path = "/chat", args = list(channelID = 1, reverse = "true"))
#'
#' # Access private endpoint using `use_auth` = `TRUE`.
#'
#' user <- get_bitmex(path = "/execution", args = list(symbol = "XBTUSD"), use_auth = TRUE)
#' }
#'
#' @export
get_bitmex <- function(
  path,
  args = NULL,
  testnet = FALSE,
  use_auth = FALSE
  ) {
  check_internet()

  ua <- user_agent("https://github.com/hfshr/bitmexr")

  if (isTRUE(testnet)) {
    url <- testnet_url
    base_url <- "https://testnet.bitmex.com"
    key <- Sys.getenv("bitmex_apikey_testnet")
    secret <- Sys.getenv("bitmex_apisecret_testnet")
  } else {
    url <- live_url
    base_url <- "https://www.bitmex.com"
    key <- Sys.getenv("bitmex_apikey")
    secret <- Sys.getenv("bitmex_apisecret")
  }

  if (isTRUE(use_auth)) {
    prep_url <- modify_url(paste0(url, path), query = compact(args))

    expires <- as.character(as.integer(now() + 10))

    sig <- gen_signature(
      secret = secret,
      verb = "GET",
      url = gsub(base_url, "", prep_url)
    )

    res <- GET(
      paste0(url, path),
      ua,
      query = compact(args),
      add_headers(.headers = c(
        "api-expires" = expires,
        "api-key" = key,
        "api-signature" = sig
      ))
    )
  } else {
    res <- GET(paste0(url, path), ua, query = compact(args))
  }

  check_status(res)

  result <- fromJSON(content(res, "text"))

  return(result)
}
