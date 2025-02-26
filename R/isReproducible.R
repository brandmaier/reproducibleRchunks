#' @export
#' @title Test reproducibility of an R Markdown file
#'
#' @param filename Character. An R Markdown file to check for reproducibility
#' @param resetOptions Boolean. Should all package options be reset to defaults? TRUE by default. This avoids problems if multiple checks on multiple documents with varying options are made in a row
#' @param \ldots Optional arguments passed down to \code{rmarkdown::render()}
#'
isReproducible <- function(filename, resetOptions = TRUE,
                           ...)
{
  if (!file.exists(filename)) stop("File does not exist")
  if (!endsWith(tolower(filename),"rmd")) warning("Possibly not an Rmd file")

  if (resetOptions) {
    ids <- (startsWith(names(options()),"reproducibleRchunks."))
    opnames <- names(options())[ids]
    for (name in opnames)    options(structure(list(NULL), names = name))
  }

  .reset()

  rmarkdown::render(input = filename,
                    quiet = TRUE,
                    ...)

  if (nrow(get_reproducibility_summary()) == 0) {
    warning("No reproducibility information found! Could not evaluate reproducibility status.")
    return(NA)
  }

  all(get_reproducibility_summary()$Success)

}
