

#' @export
get_num_reproducibility_errors <- function() {
  num_errors <- get0(x = "repror_error_counter", envir=knitr::knit_global())
  if (is.null(num_errors)) num_errors <- 0
  return(num_errors)
}

#' @export
get_reproducibility_summary <- function() {
  get0(x = "repror_summary", envir=knitr::knit_global())
}


