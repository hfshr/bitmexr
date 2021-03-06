% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/general.R
\name{tn_post_bitmex}
\alias{tn_post_bitmex}
\title{POST requests (testnet)}
\usage{
tn_post_bitmex(path, args = NULL)
}
\arguments{
\item{path}{string. End point for the api.}

\item{args}{A named list containing valid parameters for the given API endpoint.}
}
\value{
Returns a \code{data.frame} containing the response from the request.
}
\description{
Use \code{tn_post_bitmex()} to send POST requests to the testnet API. All POST requests require authentication.
}
\examples{
\dontrun{
# edit leverage on a position

tn_post_bitmex(
  path = "/position/leverage",
  args = list("symbol" = "XBTUSD", "leverage" = 10)
)
}

}
\references{
\url{https://www.bitmex.com/api/explorer/}
}
