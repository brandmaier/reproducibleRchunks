# Escape quotes for shell commands

This helper prepares character vectors for use in shell commands by
quoting them with [`shQuote()`](https://rdrr.io/r/base/shQuote.html) and
(double) escaping any internal double quotes.

## Usage

``` r
escapedQuote(x, double = FALSE)
```

## Arguments

- x:

  A character vector that may contain double quotes.

- double:

  Boolean. Should the quotes be escaped twice? Default: FALSE

## Value

A character vector with all double quotes double escaped so that it can
safely be passed to a command line call.

## Examples

``` r
if (FALSE) { # \dontrun{
escapedQuote('foo "bar" baz')
} # }
```
