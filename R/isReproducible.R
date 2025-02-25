#' @export
#' @title Test reproducibility of an R Markdown file
#'
#' @param filename An R Markdown file to check for reproducibility
#' @param \ldots Optional arguments passed down to rmarkdown::render()
#'
isReproducible <- function(filename,
                           ...)
{
  if (!file.exists(filename)) stop("File does not exist")
  if (!endsWith(tolower(filename),"rmd")) warning("Possibly not an Rmd file")

  temp_envir <- knitr::knit_global()

  .reset(temp_envir)

  rmarkdown::render(input = filename,
                    envir = temp_envir,
                    ...)

  if (nrow(get_reproducibility_summary()) == 0) {
    warning("No reproducibility information found! Could not evaluate reproducibility status.")
    return(NA)
  }

  all(get_reproducibility_summary()$Success)

}
