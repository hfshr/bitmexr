#' POST requests
#'
#' @param path string. End point for the api.
#' @param args A named list containing the
#' @param testnet logcial. Use `TRUE` access testnet.bitmex, `FALSE` to access the live site.
#'
#' @export
post_bitmex <- function(path, args = NULL, testnet = TRUE){

  json_body <- toJSON(compact(args), auto_unbox = TRUE)

  if (isTRUE(testnet)) {

    url <- testnet_url
    key <-  Sys.getenv("bitmex_apikey_test")
    secret <- Sys.getenv("bitmex_apisecret_test")

  } else {

    url <- live_url
    key <-  Sys.getenv("bitmex_apikey")
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


}


#' GET requests
#'
#' @inheritParams post_bitmex
#' @param use_auth logcial. Use `TRUE` to use apikey with request
#'
#' @export
get_bitmex <- function(path, args = NULL, use_auth = FALSE, testnet = FALSE){

  ua <- user_agent("https://github.com/hfshr/bitmexr")

  if (isTRUE(testnet)) {

    if (isTRUE(use_auth)) {

      expires<-as.character(as.integer(now() + 10))

      sig <- gen_signature(secret = Sys.getenv("bitmex_apisecret_test"),
                           verb = "GET",
                           url = modify_url(paste0(testnet_url, path), query = compact(args)) %>%
                             gsub("https://testnet.bitmex.com", "", .))

      res <- GET(paste0(testnet_url, path), ua, query = compact(args),
                 add_headers(.headers = c("api-expires"=expires,
                                          "api-key" = Sys.getenv("bitmex_apikey_test"),
                                          "api-signature"=sig))
      )

    } else {
      res <- GET(paste0(testnet_url, path), ua, query = compact(args))
    }

  } else {

    if (isTRUE(use_auth)) {

      expires<-as.character(as.integer(now() + 10))

      sig <- gen_signature(secret = Sys.getenv("bitmex_apisecret"),
                           verb = "GET",
                           url = modify_url(paste0(base_url, path), query = compact(args)) %>%
                             gsub("https://www.bitmex.com", "", .))

      res <- GET(paste0(base_url, path), ua, query = compact(args),
                 add_headers(.headers = c("api-expires"=expires,
                                          "api-key" = Sys.getenv("bitmex_apikey"),
                                          "api-signature"=sig))
      )
    }

    else {

      res <- GET(paste0(base_url, path), ua, query = compact(args))
    }

  }

  check_status(res)

  x <- fromJSON(content(res, "text"))

  return(x)
}
