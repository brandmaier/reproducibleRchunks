# Create a fingerprint of an objext

This function calls `digest` with the default hashing algorithm as set
in the package.

## Usage

``` r
hash(x, canonical_attributes = TRUE, digits = default_digits())
```

## Arguments

- x:

  Object. An arbitrary R object which will be serialized and
  fingerprinted.

- canonical_attributes:

  Boolean. Determines whether the canonical form of the attributes
  should be used.

- digits:

  Numeric/Boolean. If FALSE or NULL, no rounding is applied. Otherwise
  rounding up to the number of digits.

## Details

By default, the function hashes a canonical objec representation: Across
R versions, attribute order of objects seems not to be consistent, so
attributes are sorted by name first. Further, numeric variables are
rounded to a given precision.

## Examples

``` r
hash( c(1,2,3,4,5) )
#> [1] "fa45ce885f810ef9039b80b0edb889fa195a599fb0b7c70ebcd1f4f3cedc220a"

```
