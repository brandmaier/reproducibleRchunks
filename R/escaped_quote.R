#' Escape quotes for shell commands
#'
#' This helper prepares character vectors for use in shell commands by
#' quoting them with \code{shQuote()} and (double) escaping any internal
#' double quotes.
#'
#' @param x A character vector that may contain double quotes.
#' @param double Boolean. Should the quotes be escaped twice? Default: FALSE
#'
#' @return A character vector with all double quotes double escaped so
#'   that it can safely be passed to a command line call.
#'
#' @examples
#' \dontrun{
#' escapedQuote('foo "bar" baz')
#' }
#'
#' @keywords internal
escapedQuote <- function(x, double=FALSE) {
  if (double)
    gsub('"', '\\\\"', shQuote(x, type = "cmd"))
  else
    gsub('"', '\\"', shQuote(x, type = "cmd"))
}
