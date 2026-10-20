# Knitr Hook

This is the main RMarkdown chunk hook for processing the automated
reproducibility tests of code chunks. This function is not intended to
be called directly. Rather, it is expected that RStudio calls this
function when rendering chunks with the label identical to this function
name.

## Usage

``` r
reproducibleR(options)
```

## Arguments

- options:

  A list of chunk options passed from the knitr engine. Usually this is
  just the object options passed to the engine function; see
  [knit_engines](https://rdrr.io/pkg/knitr/man/knit_engines.html).

## Value

A character string generated from the source code and output.

## Details

This function first executes the R code from a given chunk. If a
variable is declared within the scope of the chunk, meta information
about the variable's content are generated. If no metadata exists, this
metadata is stored in a separate file. If metadata exists, it is
compared against the metadata of the reproduction attempt.

## Author

Andreas M. Brandmaier

## Examples

``` r
reproducibleR(knitr::opts_chunk$merge(list(engine="reproducibleR",code="1+1")))
#> [1] "1+1"
```
