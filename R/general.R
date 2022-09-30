#' POST requests
#'
#' Use `post_bitmex()` to send POST requests. All POST requests require authentication.
#'
#' @param path string. End point for the api.
#' @param args A named list containing valid parameters for the given API endpoint.
#'
#' @references \url{https://www.bitmex.com/api/explorer/}
#'
#' @return Returns a `data.frame` containing the response from the request.
#'
#' @examples
#' \dontrun{
#' # edit leverage on a position
#'
#' post_bitmex(
#'   path = "/position/leverage",
#'   args = list("symbol" = "XBTUSD", "leverage" = 10)
#' )
#' }
#'
#' @export
post_bitmex <- function(
  path,
  args = NULL
) {
  check_internet()

  json_body <- toJSON(compact(args), auto_unbox = TRUE)

  expires <- format(as.integer(now() + 10))

  sig <- gen_signature(
    secret = Sys.getenv("bitmex_apisecret"),
    verb = "POST",
    url = paste0("/api/v1", path),
    data = json_body
  )

  res <- POST(
    paste0(live_url, path),
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

#' POST requests (testnet)
#'
#' Use `tn_post_bitmex()` to send POST requests to the testnet API. All POST requests require authentication.
#'
#' @inheritParams post_bitmex
#'
#' @references \url{https://www.bitmex.com/api/explorer/}
#'
#' @return Returns a `data.frame` containing the response from the request.
#'
#' @examples
#' \dontrun{
#' # edit leverage on a position
#'
#' tn_post_bitmex(
#'   path = "/position/leverage",
#'   args = list("symbol" = "XBTUSD", "leverage" = 10)
#' )
#' }
#'
#' @export
tn_post_bitmex <- function(
  path,
  args = NULL
) {
  check_internet()

  json_body <- toJSON(compact(args), auto_unbox = TRUE)

  expires <- format(as.integer(now() + 10))

  sig <- gen_signature(
    secret = Sys.getenv("testnet_bitmex_apisecret"),
    verb = "POST",
    url = paste0("/api/v1", path),
    data = json_body
  )

  res <- POST(
    paste0(testnet_url, path),
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

#' GET requests
#'
#' Use `get_bitmex()` to send GET requests. For private endpoints, authentication is required.
#'
#' @inheritParams post_bitmex
#' @param use_auth logical. Use `TRUE` to access private endpoints
#' if authentication has been set up
#'
#' @references \url{https://www.bitmex.com/api/explorer/}
#'
#' @return Returns a `data.frame` containing the response from the request.
#'
#' @examples
#' \dontrun{
#'
#' # Access a public endpoint
#' chat <- get_bitmex(path = "/chat", args = list(channelID = 1, reverse = "true"))
#'
#' # Access private endpoint using `use_auth` = `TRUE`.
#' user <- get_bitmex(path = "/execution", args = list(symbol = "XBTUSD"), use_auth = TRUE)
#' }
#'
#' @export
get_bitmex <- function(
  path,
  args = NULL,
  use_auth = FALSE
) {
  check_internet()

  ua <- user_agent("https://github.com/hfshr/bitmexr")

  if (isTRUE(use_auth)) {
    prep_url <- modify_url(paste0(live_url, path), query = compact(args))

    expires <- format(as.integer(now() + 10))

    sig <- gen_signature(
      secret = Sys.getenv("bitmex_apisecret"),
      verb = "GET",
      url = gsub("https://www.bitmex.com", "", prep_url)
    )

    res <- GET(
      paste0(live_url, path),
      ua,
      query = compact(args),
      add_headers(.headers = c(
        "api-expires" = expires,
        "api-key" = Sys.getenv("bitmex_apikey"),
        "api-signature" = sig
      ))
    )
  } else {
    res <- GET(paste0(live_url, path), ua, query = compact(args))
  }

  check_status(res)

  result <- fromJSON(content(res, "text"))

  return(result)
}


#' GET requests (testnet)
#'
#' Use `tn_get_bitmex()` to send GET requests to the testnet API. For private endpoints, authentication is required.
#'
#' @inheritParams post_bitmex
#' @param use_auth logical. Use `TRUE` to access private endpoints
#' if authentication has been set up.
#'
#' @references \url{https://www.bitmex.com/api/explorer/}
#'
#' @return Returns a `data.frame` containing the response from the request.
#'
#' @examples
#' \dontrun{
#' # Access a public endpoint
#' chat <- tn_get_bitmex(path = "/chat", args = list(channelID = 1, reverse = "true"))
#'
#' # Access private endpoint using `use_auth` = `TRUE`.
#'
#' user <- tn_get_bitmex(path = "/execution", args = list(symbol = "XBTUSD"), use_auth = TRUE)
#' }
#'
#' @export
tn_get_bitmex <- function(
  path,
  args = NULL,
  use_auth = FALSE
) {
  check_internet()

  ua <- user_agent("https://github.com/hfshr/bitmexr")

  if (isTRUE(use_auth)) {
    prep_url <- modify_url(paste0(testnet_url, path), query = compact(args))

    expires <- format(as.integer(now() + 10))

    sig <- gen_signature(
      secret = Sys.getenv("testnet_bitmex_apisecret"),
      verb = "GET",
      url = gsub("https://testnet.bitmex.com", "", prep_url)
    )

    res <- GET(
      paste0(testnet_url, path),
      ua,
      query = compact(args),
      add_headers(.headers = c(
        "api-expires" = expires,
        "api-key" = Sys.getenv("testnet_bitmex_apikey"),
        "api-signature" = sig
      ))
    )
  } else {
    res <- GET(paste0(testnet_url, path), ua, query = compact(args))
  }

  check_status(res)

  result <- fromJSON(content(res, "text"))

  return(result)
}