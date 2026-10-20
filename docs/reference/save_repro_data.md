# Storing reproducibility data

Storing reproducibility data

## Usage

``` r
save_repro_data(
  x,
  filename,
  filetype = default_filetype(),
  envir = NULL,
  extra = NULL
)
```

## Arguments

- x:

  Object to be stored.

- filename:

  Name (possible including full path) of the save file

- filetype:

  Character. Currently supported is json and rda.

- envir:

  Environment to load the objects into. By default, this is the global
  environment.

- extra:

  List. Extra payload to store in the meta data

## Value

No return value

## See also

[`load_repro_data()`](load_repro_data.md)
