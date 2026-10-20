# Delete reproducibility files

Deletes all meta data in the current directory, that is, deletes all
files in the current working directory that start with
`default_prefix()` and end with `default_filetype()`.

## Usage

``` r
reset(interactive = NULL)
```

## Arguments

- interactive:

  Logical. If `TRUE` (the default), the user is asked for confirmation
  before files are removed.

## Value

Invisibly returns the vector of deleted files.
