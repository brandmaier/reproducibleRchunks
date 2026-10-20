# Get a summary about all reproduction attempts

This function returns a data frame, in which details about reproduction
attempts are collected. The data frame has three columns named
"Chunk","Variable", and "Success". Every row in the data frame
corresponds to one variable, for which reproducibility was tested.
`Chunk` stores the name of the surrounding chunk, `Variable` stores the
name of the variable, and `Success` is a boolean variable, which
indicates whether the reproduction attempt was successful.

## Usage

``` r
get_reproducibility_summary(envir = .cache)
```

## Arguments

- envir:

  Environment to retrieve data from. This defaults to an internal
  package namespace.

## Value

Returns a data.frame with three columns.
