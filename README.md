
# bitmexr: R Client for the BitMEX Exchange

<!-- badges: start -->

[![Travis build
status](https://travis-ci.org/hfshr/bitmexr.svg?branch=master)](https://travis-ci.org/hfshr/bitmexr)
[![Codecov test
coverage](https://codecov.io/gh/hfshr/bitmexr/branch/master/graph/badge.svg)](https://codecov.io/gh/hfshr/bitmexr?branch=master)
[![R build
status](https://github.com/hfshr/bitmexr/workflows/R-CMD-check/badge.svg)](https://github.com/hfshr/bitmexr/actions)
<!-- badges: end -->

# Overview

The goal of `bitmexr` is to provide an API wrapper for cryptocurrency
derivatives exchange BitMEX. `bitmexr` now provides support for all
endpoints for both the testnet (www.testnet.bitmex.com) and the live
exchange (www.bitmex.com). For more information about the API, check
<https://www.bitmex.com/app/apiOverview>.

# Installation

The development version of `bitmexr` can be installed from github:

``` r
# install.packages("devtools")
devtools::install_github("hfshr/bitmexr")
```

Or the released version from CRAN:

``` r
install.packages("bitmexr")
```

# Package contents

The package contains wrappers around the majority of API endpoints.

  - `trades()` and `map_trades()` return individual trade data for a
    specified symbol/time period
  - `bucket_trades()` and `map_bucket_trades()` return bucketed trade
    data (open, high, low, close) for either 1 minute, 5 minute, 1 hour
    or 1 day time frames for a specified symbol.
  - `place_order()`, `edit_order()` and `cancel_order()` can be used to
    manage trades on the exchange.

Additional API endpoints that do not have a dedicated wrapper can be
accessed using `get_bitmex()` for GET requests and `post_bitmex()` for
post requests. For example use:

``` r
get_bitmex(path = "/chat", args = list(reverse = "false"))
```

to get the latest trollbox messages.

**Testnet API**

All functions in the package also work with the testnet API simply use
the “tn\_” prefix to access the testnet version of the function. For
example `tn_place_order()` will place an order on the testnet exchange.

**Authentication**

Accessing privite API endpoints requires an API key and secret.
`bitmexr` reads these from the ~/.Renviron file - see vignette
[“Authentication”](docs/articles/authentication.html) for more
information.

# Disclaimer

This software is in no way affiliated, endorsed, or approved by the
[BitMEX cryptocurrency exchange](https://www.bitmex.com) or any of its
affiliates.

# Contribution

If you spot any issues, or would like additional features added, please
feel free to raise an issue, or submit a pull request.

# Code of Conduct

Please note that this project is released with a [Contributor Code of
Conduct](https://hfshr.github.io/bitmexr/CODE_OF_CONDUCT.html). By
participating in this project you agree to abide by its terms.
