

#' @title Get the total number of failed reproduction attempts
#'
#' @param envir Environment to retrieve data from. This defaults to an internal package namespace.
#'
#' @returns Returns the number of errors encountered when reproducing a Markdown document
#' @export
get_num_reproducibility_errors <- function(envir=.cache) {
  num_errors <- get0(x = "repror_error_counter", envir=envir)
  if (is.null(num_errors)) num_errors <- 0
  return(num_errors)
}


#' @title Get a summary about all reproduction attempts
#' @description This function returns a data frame, in which details
#' about reproduction attempts are collected. The data frame has
#' three columns named "Chunk","Variable", and "Success". Every row
#' in the data frame corresponds to one variable, for which reproducibility
#' was tested. `Chunk` stores the name of the surrounding chunk, `Variable`
#' stores the name of the variable, and `Success` is a boolean variable,
#' which indicates whether the reproduction attempt was successful.
#'
#' @param envir Environment to retrieve data from. This defaults to an internal package namespace.
#'
#' @returns Returns a data.frame with three columns.
#' @export
get_reproducibility_summary <- function(envir=.cache) {
  get0(x = "repror_summary", envir=envir)
}


