#'
#' This function calls \code{digest} with the default hashing algorithm
#'
#' Across R versions, attribute order of objects seems not to
#' be consistent. Anecdotally, I found a difference between
#' R 4.5.1 on Windows and R 4.2.2 on macOS Seqouia, which differed
#' only in the order of attributes when creating a data.frame
#' (which may also be related to different tidyverse versions
#' on those computers). In order to prevent this issue, I
#' choose a canonical representation of attributes before
#' creating the hash.
#'
#' @param x Object. An arbitrary R object which will be serialized and fingerprinted.
#' @param canonical Boolean. Determines whether the canonical form of the attributes should be used.
#'
hash <- function(x, canonical=TRUE, digits=default_digits()) {

  if (!isFALSE(digits) && !is.null(digits)) {
    stopifnot(is.numeric(digits))

    x <- round_recursive(x)
  }

  if (isTRUE(canonical)) {
    a <- attributes(x)
    attributes(x) <- a[sort(names(a))]
  }

  digest::digest(x, algo=default_hashing_algorithm(), serialize=TRUE)
}
