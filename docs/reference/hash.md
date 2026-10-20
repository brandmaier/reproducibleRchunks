# This function calls digest with the default hashing algorithm

Across R versions, attribute order of objects seems not to be
consistent. Anecdotally, I found a difference between R 4.5.1 on Windows
and R 4.2.2 on macOS Seqouia, which differed only in the order of
attributes when creating a data.frame (which may also be related to
different tidyverse versions on those computers). In order to prevent
this issue, I choose a canonical representation of attributes before
creating the hash.

## Usage

``` r
hash(x, canonical = TRUE)
```
