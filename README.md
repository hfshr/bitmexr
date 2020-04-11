
# bitmexr: R Client for the BitMEX Exchange

[![Travis build
status](https://travis-ci.org/hfshr/bitmexr.svg?branch=master)](https://travis-ci.org/hfshr/bitmexr)

# Overview

The goal of `bitmexr` is to provide an API wrapper for cryptocurrency
derivatives exchange [BitMEX](https://www.bitmex.com/). Specifically, it
can help R users access price/trade data across the many products
available on the exchange, which can then be used for further analysis.
For more information about the API, check
<https://www.bitmex.com/app/apiOverview>.

# Installation

The development version of `bitmexr` can be installed from github:

``` r
# install.packages("devtools")
devtools::install_github("hfshr/bitmexr")
```

# Package contents

The package as two main functions:

  - `trades()` returns individual trade data for a specified symbol/time
    period
  - `bucket_trades()` returns bucketed trade data (open, high, low,
    close) for either 1 minute, 5 minute, 1 hour or 1 day time frames
    for a specified symbol.

The package also contains map\_\* variants of these functions
(`map_trades()` and `map_bucket_trades()`) which create and send
multiple API requests when the total length of the data desired is
greater than the 1000 row limit in a single API request.

# Examples

Simple price data for the most recent trades on the exchange:

``` r
library(bitmexr)
library(dplyr)

# 1000 for most recent trades on the exchange for "XBTUSD"

trades(symbol = "XBTUSD") %>% 
  select(timestamp, symbol, side, size, price) %>% 
  head()
#>             timestamp symbol side size  price
#> 1 2020-04-11 16:17:43 XBTUSD Sell   25 6858.5
#> 2 2020-04-11 16:17:43 XBTUSD Sell  140 6858.5
#> 3 2020-04-11 16:17:43 XBTUSD  Buy  280 6859.0
#> 4 2020-04-11 16:17:38 XBTUSD Sell  700 6858.5
#> 5 2020-04-11 16:17:38 XBTUSD Sell    1 6858.5
#> 6 2020-04-11 16:17:38 XBTUSD Sell 5000 6858.5
```

Get all bucketed trade data (hourly binSize) between January 2019 and
June 2019.

``` r
map_bucket_trades(start_date = "2019-01-01", 
                  end_date = "2019-06-01", 
                  binSize = "1h",
                  symbol = "XBTUSD") %>% 
  select(1:6) %>% 
  head()
#> 
#> 4 API requests generated.
#> Current limit = 30 requests per minute
#>             timestamp symbol   open   high    low  close
#> 1 2019-01-01 00:00:00 XBTUSD 3686.5 3695.5 3682.5 3693.0
#> 2 2019-01-01 01:00:00 XBTUSD 3693.0 3705.0 3684.5 3694.0
#> 3 2019-01-01 02:00:00 XBTUSD 3694.0 3695.0 3675.5 3681.5
#> 4 2019-01-01 03:00:00 XBTUSD 3681.5 3683.5 3665.0 3678.5
#> 5 2019-01-01 04:00:00 XBTUSD 3678.5 3687.0 3678.5 3685.0
#> 6 2019-01-01 05:00:00 XBTUSD 3685.0 3699.0 3683.0 3684.0
```

# What the package *does not* do

The package is designed to simply obtain trade data from the exchange
for further analysis/visualisation within R. However the BitMEX API can
do far more than what is implemented within this package. For more
information please see <https://www.bitmex.com/app/apiOverview>.
Currently, the package does not support any of the API requests
requiring authentication (e.g., obtaining trade data for personal
account, posting/executing trades etc), however this may change in the
future.

# Disclaimer

This software is in no way affiliated, endorsed, or approved by the
[BitMEX cryptocurrency exchange](https://www.bitmex.com) or any of its
affiliates.

# Contribution

If you spot any issues, or would like additional features added, please
feel free to raise an issue, or submit a pull request.

# Code of Conduct

Please note that this project is released with a [Contributor Code of
Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree
to abide by its terms.
