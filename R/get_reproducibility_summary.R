

#' @export
get_num_reproducibility_errors <- function() {
  get(x = "repror_error_counter", envir=knitr::knit_global())
}

#' @export
get_reproducibility_summary <- function() {
  get(x = "repror_summary", envir=knitr::knit_global())
}


