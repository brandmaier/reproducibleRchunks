# Test reproducibility of an R Markdown file

Test reproducibility of an R Markdown file

## Usage

``` r
isReproducible(
  filename,
  resetOptions = TRUE,
  engine = c("auto", "knitr", "rmarkdown", "quarto"),
  quiet = TRUE,
  ...
)
```

## Arguments

- filename:

  Character. An R Markdown file to check for reproducibility

- resetOptions:

  Boolean. Should all package options be reset to defaults? TRUE by
  default. This avoids problems if multiple checks on multiple documents
  with varying options are made in a row

- engine:

  Character. Either knitr or rmarkdown, depending on what package should
  be used to render the document.

- quiet:

  Boolean. Suppress output when knitting the document.

- ...:

  Optional arguments passed down to
  [`rmarkdown::render()`](https://pkgs.rstudio.com/rmarkdown/reference/render.html)
