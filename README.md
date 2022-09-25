
# bitmexr - R Client for the bitmex exchange <a href='https://hfshr.github.io/bitmexr/'><img src='man/figures/logo.png' align="right" height="139" /></a>

<!-- badges: start -->

[![R build status](https://github.com/hfshr/bitmexr/workflows/R-CMD-check/badge.svg)](https://github.com/hfshr/bitmexr/actions)
[![CRAN status](https://www.r-pkg.org/badges/version/bitmexr)](https://CRAN.R-project.org/package=bitmexr)
[![](https://cranlogs.r-pkg.org/badges/bitmexr)](https://cran.r-project.org/package=bitmexr)
<!-- badges: end -->

## Overview

The goal of `bitmexr` is to provide an API wrapper for cryptocurrency
derivatives exchange, BitMEX. `bitmexr` now provides support for all API
endpoints for both the Testnet (www.testnet.bitmex.com) and the live
exchange (www.bitmex.com). For more information about the API, check
<https://www.bitmex.com/app/apiOverview>.

## Installation

The development version of `bitmexr` can be installed from github:

``` r
# install.packages("devtools")
devtools::install_github("hfshr/bitmexr")
```

Or the released version from CRAN:

``` r
install.packages("bitmexr")
```

## Package contents

The package contains dedicated wrappers for the majority of API
endpoints.

  - `trades()` and `map_trades()` return individual trade data for a
    specified symbol/time period.
  - `bucket_trades()` and `map_bucket_trades()` return bucketed trade
    data (open, high, low, close) for either 1-minute, 5-minute, 1-hour
    or 1-day time frames for a specified symbol.
  - `place_order()`, `edit_order()` and `cancel_order()` can be used to
    manage trades on the exchange.

Additional API endpoints that do not have a dedicated wrapper can be
accessed using `get_bitmex()` for GET requests and `post_bitmex()` for
POST requests. For example use:

``` r
get_bitmex(path = "/chat", args = list(reverse = "false"))
```

to get the latest trollbox messages.

**Testnet API**

All functions in the package also work with BitMEX’s Testnet API. Simply
use the “tn\_” prefix to access the Testnet version of the function. For
example `tn_place_order()` will place an order on the Testnet exchange.

**Authentication**

Accessing private API endpoints, such as those to manage trades,
requires an API key and secret. `bitmexr` reads these from your
\~/.Renviron file - see vignette
[Authentication](https://hfshr.github.io/bitmexr/articles/authentication.html)
for more information.

## Disclaimer

This software is in no way affiliated, endorsed, or approved by the
[BitMEX cryptocurrency exchange](https://www.bitmex.com) or any of its
affiliates.

## Contribution

If you spot any issues, or would like additional features added, please
feel free to raise an issue, or submit a pull request.

## Code of Conduct

Please note that this project is released with a [Contributor Code of
Conduct](https://hfshr.github.io/bitmexr/CODE_OF_CONDUCT.html). By
participating in this project you agree to abide by its terms.
