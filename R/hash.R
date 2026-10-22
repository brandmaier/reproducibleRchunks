#' Create a fingerprint of an objext
#'
#' This function calls \code{digest} with the default hashing algorithm
#' as set in the package.
#'
#' By default, the function hashes a canonical objec representation:
#' Across R versions, attribute order of objects seems not to
#' be consistent, so attributes are sorted by name first. Further,
#' numeric variables are rounded to a given precision.
#'
#' @examples
#' hash( c(1,2,3,4,5) )
#'
#'
#' @param x Object. An arbitrary R object which will be serialized and fingerprinted.
#' @param canonical_attributes Boolean. Determines whether the canonical form of the attributes should be used.
#' @param digits Numeric/Boolean. If FALSE or NULL, no rounding is applied. Otherwise rounding up to the number of digits.
#'
#' @export
hash <- function(x, canonical_attributes=TRUE, digits=default_digits()) {

  x <- normalize_for_hash(x,
                          canonical_attributes = canonical_attributes,
                          digits=digits)

  digest::digest(x, algo=default_hashing_algorithm(), serialize=TRUE)
}
