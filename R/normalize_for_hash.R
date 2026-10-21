# If this is a list, recursively apply the function to
# each element of the list. Sort attributes of the list
# into a canonical form and round every number to
# the requested digits
#
normalize_for_hash <- function(x, digits = 7L, canonical_attributes = TRUE) {

  if (is.numeric(x) && is.numeric(digits)) {
    return(round(x, digits = digits))
  }

  if (is.list(x)) {
    original_attributes <- attributes(x)
    x <- lapply(x, normalize_for_hash, digits = digits, canonical_attributes = canonical_attributes)
    if (isTRUE(canonical_attributes)) {
        original_attributes <-
          original_attributes[sort(names(original_attributes))]
    }
    attributes(x) <- original_attributes
  }

  x
}
